package Controller;

import Model.dbConnect;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ChatServlet extends HttpServlet {
//    private static final String API_KEY = "AIzaSyAUPHW_KydhmY5ZLdkTGkWvWJBZ1I4mmWg";
    private static final int MAX_PRODUCTS = 10;

    private static class ConversationState {
        boolean waitingForPromotionAnswer = false;
        List<Map<String, Object>> promoProducts = new ArrayList<>();
        String lastQuery = null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        ConversationState state = (ConversationState) session.getAttribute("chatState");
        if (state == null) {
            state = new ConversationState();
            session.setAttribute("chatState", state);
        }

        String message = request.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            response.getWriter().write("Vui lòng nhập câu hỏi.");
            return;
        }
        message = message.trim();

        // Xử lý trả lời khuyến mãi
        if (state.waitingForPromotionAnswer) {
            String reply = handlePromotionAnswer(message, state, request, response);
            if (reply != null) {
                response.getWriter().write(reply);
                if (!state.waitingForPromotionAnswer) session.removeAttribute("chatState");
                return;
            }
        }

        // Rule cứng (chào, cảm ơn, ...)
        String quick = quickReply(message);
        if (quick != null) {
            response.getWriter().write(quick);
            return;
        }

        // Phân tích câu hỏi
        ParsedQuery pq = parseQuery(message);
        List<Map<String, Object>> products = new ArrayList<>();

        if (pq.intent.equals("find_product")) {
            products = searchProducts(pq);
        }

        // Thiếu thông tin -> hỏi lại
        if (pq.intent.equals("find_product") && products.isEmpty() && pq.priceMin == 0 && pq.priceMax == 0 && pq.category == null) {
            state.lastQuery = message;
            session.setAttribute("chatState", state);
            response.getWriter().write("🔍 Bạn muốn tìm **" + pq.productType + "**? Hãy cho mình biết thêm:\n• 💰 Khoảng giá\n• 🛋️ Danh mục (phòng khách, phòng ngủ, đèn, bàn ghế làm việc...)\n👉 Ví dụ: \"Giường ngủ dưới 3 triệu phòng ngủ\"");
            return;
        }

        // Có sản phẩm -> xử lý khuyến mãi hoặc trả kết quả
        if (!products.isEmpty()) {
            List<Map<String, Object>> promoProducts = filterPromotionProducts(products);
            if (!promoProducts.isEmpty() && !state.waitingForPromotionAnswer) {
                state.waitingForPromotionAnswer = true;
                state.promoProducts = promoProducts;
                session.setAttribute("chatState", state);
                StringBuilder sb = new StringBuilder("🎉 **Ưu đãi đặc biệt!** Có sản phẩm giảm giá:\n");
                for (Map<String, Object> p : promoProducts) {
                    sb.append("- ").append(p.get("name")).append(": <del>").append(formatPrice((float)p.get("price_old"))).append("đ</del> → **")
                      .append(formatPrice((float)p.get("price"))).append("đ**\n");
                }
                sb.append("\n🤔 Bạn **có muốn** xem sản phẩm giảm giá này không? (Có / Không)");
                response.getWriter().write(sb.toString());
                return;
            }
            String reply = formatProductResponse(products, request, response);
            response.getWriter().write(reply);
            session.removeAttribute("chatState");
            return;
        }

        // Không tìm thấy sản phẩm hoặc câu hỏi chung -> gọi Gemini
        System.out.println("[ChatServlet] Gọi Gemini API cho câu: " + message);
        String aiReply = callGemini(message, products, request, response);
        response.getWriter().write(aiReply);
        session.removeAttribute("chatState");
    }

    // -------------------- CÁC HÀM XỬ LÝ --------------------
    private String quickReply(String msg) {
        String m = msg.toLowerCase();
        if (m.matches(".*(xin chào|hello|hi|chào|hey).*")) return "Xin chào! 👋 Bạn cần tư vấn nội thất gì ạ?";
        if (m.matches(".*(cảm ơn|cám ơn|thanks|thank).*")) return "Không có gì! 😊 Bạn cần thêm gì nữa không?";
        if (m.matches(".*(giờ mở cửa|địa chỉ|liên hệ|hotline).*")) return "📍 DECOR LUXURY: 8h-21h hàng ngày. Liên hệ qua trang Liên Hệ nhé!";
        return null;
    }

    private ParsedQuery parseQuery(String message) {
        ParsedQuery pq = new ParsedQuery();
        String lower = message.toLowerCase();
        if (lower.contains("tìm") || lower.contains("muốn mua") || lower.contains("cho tôi") || 
            lower.contains("sản phẩm") || lower.contains("tư vấn") || lower.contains("hỗ trợ") || 
            lower.contains("giải đáp") || lower.contains("check")  || lower.contains("biết")) {
            pq.intent = "find_product";
        } else {
            pq.intent = "general";
            return pq;
        }
        String[] keywords = {"giường", "đèn", "bàn", "ghế", "sofa", "tủ", "kệ", "trà", "máy giặt"};
        for (String kw : keywords) {
            if (lower.contains(kw)) { pq.productType = kw; break; }
        }
        // Giá
        Pattern pricePattern = Pattern.compile("(\\d+(?:\\.\\d+)?)\\s*(k|triệu|tr|ngàn|nghìn)");
        Matcher m = pricePattern.matcher(lower);
        if (m.find()) {
            float val = Float.parseFloat(m.group(1));
            String unit = m.group(2);
            if (unit.equals("k") || unit.equals("ngàn") || unit.equals("nghìn")) val *= 1000;
            else if (unit.equals("triệu") || unit.equals("tr")) val *= 1000000;
            if (lower.contains("dưới") || lower.contains("nhỏ hơn")) pq.priceMax = val;
            else if (lower.contains("trên") || lower.contains("lớn hơn")) pq.priceMin = val;
            else { pq.priceMin = val * 0.8f; pq.priceMax = val * 1.2f; }
        }
        // Danh mục
        String[] cats = {"phòng khách", "phòng ngủ", "đèn", "bàn ghế làm việc", "trang trí decor"};
        for (String cat : cats) {
            if (lower.contains(cat)) { pq.category = cat; break; }
        }
        return pq;
    }

    private List<Map<String, Object>> searchProducts(ParsedQuery pq) {
        List<Map<String, Object>> results = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new dbConnect().getConnect();
            StringBuilder sql = new StringBuilder(
                "SELECT p.product_id, p.product_name, p.price, p.description, c.category_name, p.discount_price " +
                "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id WHERE p.price > 0"
            );
            List<Object> params = new ArrayList<>();
            if (pq.category != null) { sql.append(" AND c.category_name LIKE ?"); params.add("%" + pq.category + "%"); }
            if (pq.priceMin > 0) { sql.append(" AND p.price >= ?"); params.add(pq.priceMin); }
            if (pq.priceMax > 0) { sql.append(" AND p.price <= ?"); params.add(pq.priceMax); }
            if (pq.productType != null && !pq.productType.equals("sản phẩm")) {
                sql.append(" AND p.product_name LIKE ?"); params.add("%" + pq.productType + "%");
            }
            sql.append(" ORDER BY p.price ASC LIMIT ").append(MAX_PRODUCTS);
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) ps.setObject(i+1, params.get(i));
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getInt("product_id"));
                item.put("name", rs.getString("product_name"));
                float original = rs.getFloat("price");
                float discount = rs.getFloat("discount_price");
                boolean hasPromo = discount > 0;
                item.put("price", hasPromo ? discount : original);
                item.put("price_old", original);
                item.put("description", rs.getString("description"));
                item.put("category", rs.getString("category_name"));
                results.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); } 
        finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return results;
    }

    private List<Map<String, Object>> filterPromotionProducts(List<Map<String, Object>> products) {
        List<Map<String, Object>> promo = new ArrayList<>();
        for (Map<String, Object> p : products) {
            if ((float)p.get("price") < (float)p.get("price_old")) promo.add(p);
        }
        return promo;
    }

    private String formatProductResponse(List<Map<String, Object>> products, HttpServletRequest req, HttpServletResponse resp) {
        StringBuilder sb = new StringBuilder();
        if (products.size() == 1) {
            Map<String, Object> p = products.get(0);
            String link = resp.encodeRedirectURL(req.getContextPath() + "/ProductDetail?id=" + p.get("id"));
            sb.append("✅ **").append(p.get("name")).append("**\n💰 ").append(formatPrice((float)p.get("price"))).append("đ");
            if ((float)p.get("price") < (float)p.get("price_old")) sb.append(" (giảm từ ").append(formatPrice((float)p.get("price_old"))).append("đ)");
            sb.append("\n📂 ").append(p.get("category")).append("\n🔗 [Xem chi tiết](").append(link).append(")");
        } else {
            sb.append("🔎 Có ").append(products.size()).append(" sản phẩm phù hợp:\n");
            for (Map<String, Object> p : products) {
                String link = resp.encodeRedirectURL(req.getContextPath() + "/ProductDetail?id=" + p.get("id"));
                sb.append("- **").append(p.get("name")).append("**: ").append(formatPrice((float)p.get("price"))).append("đ");
                if ((float)p.get("price") < (float)p.get("price_old")) sb.append(" (giảm)");
                sb.append(" 🔗 [Chi tiết](").append(link).append(")\n");
            }
        }
        return sb.toString();
    }

    private String formatPrice(float price) {
        return String.format("%,d", (long)price).replace(',', '.');
    }

    // -------------------- GEMINI API CÓ XỬ LÝ 429 --------------------
    private String callGemini(String userMessage, List<Map<String, Object>> products, HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("[Gemini] Bắt đầu gọi API, prompt dài " + userMessage.length() + " ký tự");
        try {
            URL url = new URL("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + API_KEY);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(25000);

            String context = "";
            if (!products.isEmpty()) {
                context = "Dưới đây là danh sách sản phẩm liên quan:\n";
                for (Map<String, Object> p : products) {
                    context += "- " + p.get("name") + " giá " + formatPrice((float)p.get("price")) + "đ (danh mục: " + p.get("category") + ")\n";
                }
                context += "Hãy tư vấn dựa trên các sản phẩm này.";
            } else {
                context = "Trả lời câu hỏi của khách hàng về nội thất một cách thân thiện, ngắn gọn bằng tiếng Việt. Nếu khách hỏi về sản phẩm cụ thể mà bạn chưa rõ, hãy hỏi lại khách: 'Bạn muốn tôi tư vấn sản phẩm nào? (đặt ở đâu, chất liệu nào, hay giá cả bao nhiêu)'";
            }

            String prompt = "Bạn là trợ lý nội thất DECOR LUXURY.\n" + context + "\n\nCâu hỏi: " + userMessage;
            String json = "{\"contents\":[{\"parts\":[{\"text\":\"" + escapeJson(prompt) + "\"}]}],\"generationConfig\":{\"maxOutputTokens\":500,\"temperature\":0.7}}";
            try (OutputStream os = conn.getOutputStream()) { os.write(json.getBytes("utf-8")); }

            int code = conn.getResponseCode();
            if (code == 200) {
                try (Scanner sc = new Scanner(conn.getInputStream(), "utf-8")) {
                    StringBuilder sb = new StringBuilder();
                    while (sc.hasNextLine()) sb.append(sc.nextLine());
                    return parseGeminiResponse(sb.toString());
                }
            } else if (code == 429) {
                // Xử lý rate limit: trả về câu hỏi dẫn dắt tư vấn sản phẩm
                return "🤖 *Trợ lý AI tạm thời quá tải.*\n\n" +
                       "Nhưng mình vẫn có thể giúp bạn tìm sản phẩm thủ công.\n" +
                       "👉 **Bạn muốn tôi tư vấn sản phẩm nào?** (đặt ở đâu, chất liệu nào, hay giá cả bao nhiêu)\n" +
                       "Hãy cho mình biết thêm: **tên sản phẩm**, **khoảng giá** hoặc **danh mục** nhé!";
            } else {
                return "Xin lỗi, AI tạm thời bận (mã " + code + "). Vui lòng thử lại sau.";
            }
        } catch (Exception e) {
            return "🌐 Lỗi kết nối AI: " + e.getMessage();
        }
    }

    private String escapeJson(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    private String parseGeminiResponse(String json) {
        int idx = json.indexOf("\"text\":\"");
        if (idx == -1) return "Không nhận được phản hồi từ AI.";
        idx += 8;
        StringBuilder out = new StringBuilder();
        for (int i = idx; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '\\' && i+1 < json.length()) {
                char n = json.charAt(i+1);
                if (n == '"') { out.append('"'); i++; }
                else if (n == 'n') { out.append('\n'); i++; }
                else if (n == '\\') { out.append('\\'); i++; }
                else out.append(c);
            } else if (c == '"') break;
            else out.append(c);
        }
        String result = out.toString().replaceAll("\\*\\*(.+?)\\*\\*", "<b>$1</b>").replace("\n", "<br>");
        return result;
    }

    private static class ParsedQuery {
        String intent = "general";
        String productType = "sản phẩm";
        float priceMin = 0, priceMax = 0;
        String category = null;
    }

    private String handlePromotionAnswer(String msg, ConversationState state, HttpServletRequest req, HttpServletResponse resp) {
        msg = msg.toLowerCase();
        if (msg.contains("có") || msg.contains("ok")) {
            state.waitingForPromotionAnswer = false;
            StringBuilder sb = new StringBuilder("🎁 Sản phẩm giảm giá:\n");
            for (Map<String, Object> p : state.promoProducts) {
                String link = resp.encodeRedirectURL(req.getContextPath() + "/ProductDetail?id=" + p.get("id"));
                sb.append("- **").append(p.get("name")).append("**: ").append(formatPrice((float)p.get("price"))).append("đ (giảm từ ").append(formatPrice((float)p.get("price_old"))).append("đ) 🔗 [Xem](").append(link).append(")\n");
            }
            state.promoProducts.clear();
            return sb.toString();
        } else if (msg.contains("không")) {
            state.waitingForPromotionAnswer = false;
            state.promoProducts.clear();
            return "OK! Bạn muốn tìm sản phẩm với tiêu chí nào khác?";
        }
        return null;
    }
}
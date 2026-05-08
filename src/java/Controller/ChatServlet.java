package Controller;

import Model.dbConnect;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.regex.*;
import jakarta.servlet.http.*;

public class ChatServlet extends HttpServlet {

    private static final int MAX_RESULTS = 10;

    // Chỉnh lại route này nếu trang liên hệ của bạn khác
    private static final String CONTACT_URL = "/ContactServlet";

    // Từ điển đồng nghĩa: key là từ dùng tìm trong DB, value là những gì user hay gõ
    private static final Map<String, String[]> KeyWord = new LinkedHashMap<>();
    static {
        KeyWord.put("sofa",      new String[]{"sofa", "ghế sofa", "couch", "ghế dài", "ghế tựa"});
        KeyWord.put("bàn",       new String[]{"bàn", "table", "desk", "bàn học", "bàn làm việc", "bàn ăn", "bàn trà"});
        KeyWord.put("ghế",       new String[]{"ghế", "chair", "ghế ngồi", "ghế xoay", "ghế văn phòng"});
        KeyWord.put("giường",    new String[]{"giường", "bed", "giường ngủ", "nệm"});
        KeyWord.put("tủ",        new String[]{"tủ", "cabinet", "wardrobe", "tủ quần áo", "tủ đồ"});
        KeyWord.put("loa",       new String[]{"Loa","âm thanh","sound","phát thanh"});
        KeyWord.put("kệ",        new String[]{"kệ", "shelf", "kệ sách", "kệ tivi", "giá đỡ"});
        KeyWord.put("đèn",       new String[]{"đèn", "lamp", "light", "đèn led", "đèn trang trí", "đèn chùm"});
        KeyWord.put("máy giặt",  new String[]{"máy giặt", "washing machine"});
        KeyWord.put("trang trí", new String[]{"trang trí", "decor", "gương", "thảm", "rèm", "đồng hồ", "tranh"});
    }

    // Các dạng câu hỏi cần tư vấn viên thật — bot không thể trả lời chắc chắn
    // vì cần biết ảnh phòng, kích thước thực tế, sở thích cá nhân...
    private static final String[] NEEDS_HUMAN_PATTERNS = {
        "hợp.*phòng", "phù hợp.*nhà", "hợp.*không gian", "hợp.*màu",
        "trông.*thế nào", "nhìn.*thế nào", "đẹp không", "có hợp không",
        "nên chọn.*nào", "nên mua.*nào", "tư vấn.*phong cách",
        "thiết kế.*phòng", "phối.*màu", "bố trí", "sắp xếp.*nội thất",
        "size.*phù hợp", "kích thước.*phù hợp", "vừa.*phòng",
        "phong cách.*gì", "style.*gì", "hợp.*gu",
        "không biết.*chọn", "không biết.*mua", "phân vân",
        "gợi ý.*tổng thể", "tư vấn.*trọn gói", "tư vấn.*nội thất"
    };

    // Câu chào & cảm ơn có vài phiên bản để bot không bị lặp đơ
    private static final String[] GREETINGS = {
        "Chào bạn! 👋 Bạn đang tìm đồ nội thất gì vậy?",
        "Xin chào! 😊 Mình có thể giúp gì cho bạn hôm nay?",
        "Hi bạn! Bạn muốn trang trí không gian nào — phòng khách, phòng ngủ hay văn phòng?"
    };
    private static final String[] THANKS_REPLIES = {
        "Không có gì! 😊 Bạn cần thêm gì cứ hỏi mình nhé.",
        "Vui được giúp bạn! Còn sản phẩm nào bạn muốn tìm nữa không?",
        "Oke bạn ơi! Có gì cần tư vấn thêm cứ ping mình nha 🙌"
    };

    private final Random rng = new Random();

    // ==================== ENTRY POINT ====================

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("text/plain;charset=UTF-8");
        req.setCharacterEncoding("UTF-8");

        String message = req.getParameter("message");
        if (message == null || message.isBlank()) {
            res.getWriter().write("Bạn muốn hỏi gì vậy? 😊");
            return;
        }
        message = message.trim();

        HttpSession session = req.getSession();
        ChatState state = getOrCreateState(session);

        // Đang chờ user trả lời câu hỏi về khuyến mãi?
        if (state.waitingForPromoAnswer) {
            String promoReply = handlePromoResponse(message, state, req, res);
            if (promoReply != null) {
                res.getWriter().write(promoReply);
                if (!state.waitingForPromoAnswer) session.removeAttribute("chatState");
                return;
            }
        }

        // Câu hỏi cần tư vấn viên thật → chỉ đường sang trang liên hệ
        if (needsHumanAdvice(message)) {
            res.getWriter().write(buildContactSuggestion(req, res));
            return;
        }

        // Câu chào, cảm ơn, địa chỉ... trả lời ngay không cần DB
        String quickReply = tryQuickReply(message);
        if (quickReply != null) {
            res.getWriter().write(quickReply);
            return;
        }

        // Phân tích xem user muốn tìm sản phẩm gì
        UserIntent intent = analyzeMessage(message);

        if (intent.wantsProduct) {
            // Còn mơ hồ → hỏi thêm trước khi tìm
            if (intent.productKeyword != null
                    && intent.specificName == null
                    && intent.priceMin == 0 && intent.priceMax == 0
                    && intent.category == null) {
                state.lastQuestion = message;
                session.setAttribute("chatState", state);
                res.getWriter().write(buildClarifyQuestion(intent.productKeyword));
                return;
            }

            List<Map<String, Object>> found = queryProducts(intent);

            if (!found.isEmpty()) {
                List<Map<String, Object>> onSale = filterOnSale(found);
                if (!onSale.isEmpty() && !state.waitingForPromoAnswer) {
                    state.waitingForPromoAnswer = true;
                    state.promoList = onSale;
                    session.setAttribute("chatState", state);
                    res.getWriter().write(buildPromoTeaser(onSale));
                    return;
                }
                res.getWriter().write(formatResults(found, req, res));
                session.removeAttribute("chatState");
                return;
            }

            // Tìm không ra → thành thật, gợi ý liên hệ
            res.getWriter().write(buildNotFoundReply(intent.productKeyword, req, res));
            return;
        }

        // Câu hỏi linh tinh không nhận dạng được → gợi ý liên hệ
        res.getWriter().write(buildContactSuggestion(req, res));
        session.removeAttribute("chatState");
    }

    // ==================== PHÂN TÍCH CÂU HỎI ====================

    private boolean needsHumanAdvice(String message) {
        String lower = message.toLowerCase();
        for (String pattern : NEEDS_HUMAN_PATTERNS) {
            if (lower.matches(".*" + pattern + ".*")) return true;
        }
        return false;
    }

    private UserIntent analyzeMessage(String message) {
        UserIntent intent = new UserIntent();
        String lower = message.toLowerCase().trim();

        boolean soundsLikeShopping = lower.matches(
            ".*(tìm|muốn mua|cho tôi|cho mình|sản phẩm|hỗ trợ||buy|take" +
            "check|có bán|giá|bao nhiêu|xem thử|mua|cần|buy|take).*"
        );

        boolean mentionedProduct = false;
        outer:
        for (Map.Entry<String, String[]> entry : KeyWord.entrySet()) {
            for (String word : entry.getValue()) {
                if (lower.contains(word)) {
                    intent.productKeyword = entry.getKey();
                    mentionedProduct = true;
                    break outer;
                }
            }
        }

        intent.wantsProduct = soundsLikeShopping || mentionedProduct;
        if (!intent.wantsProduct) return intent;

        extractPrice(lower, intent);

        String[] roomTypes = {"phòng khách", "phòng ngủ", "đèn", "bàn ghế làm việc", "trang trí decor"};
        for (String room : roomTypes) {
            if (lower.contains(room)) { intent.category = room; break; }
        }

        // Chỉ dùng specificName khi câu ngắn gọn, không có giá và không có category.
        // Nếu đã có filter giá hoặc phòng rồi thì để DB tự lọc — không gán specificName
        // vì sẽ khiến SQL LIKE khớp cả chuỗi dài "giường cho phòng ngủ giá dưới 8 triệu" → không ra gì.
        boolean hasOtherFilters = intent.priceMin > 0 || intent.priceMax > 0 || intent.category != null;
        if (!hasOtherFilters && message.split("\\s+").length >= 3 && mentionedProduct) {
            String cleaned = lower
                .replaceAll("tìm|muốn mua|cho tôi|cho mình|tư vấn|hỗ trợ|check|mua|cần|xem thử|buy|take", "")
                .trim();
            if (cleaned.split("\\s+").length >= 2) intent.specificName = cleaned;
        }

        return intent;
    }

    private void extractPrice(String lower, UserIntent intent) {
        Pattern p = Pattern.compile("(\\d+(?:[.,]\\d+)?)\\s*(k|triệu|tr|ngàn|nghìn)");
        Matcher m = p.matcher(lower);
        if (!m.find()) return;

        float amount = Float.parseFloat(m.group(1).replace(",", "."));
        String unit  = m.group(2);
        if (unit.equals("k") || unit.equals("ngàn") || unit.equals("nghìn")) amount *= 1_000;
        else if (unit.equals("triệu") || unit.equals("tr"))                   amount *= 1_000_000;

        if      (lower.contains("dưới") || lower.contains("nhỏ hơn")) intent.priceMax = amount;
        else if (lower.contains("trên") || lower.contains("lớn hơn")) intent.priceMin = amount;
        else { intent.priceMin = amount * 0.8f; intent.priceMax = amount * 1.2f; }
    }

    // ==================== DATABASE ====================

    private List<Map<String, Object>> queryProducts(UserIntent intent) {
        List<Map<String, Object>> results = new ArrayList<>();
        try (Connection conn = new dbConnect().getConnect();
             PreparedStatement ps = conn.prepareStatement(buildSQL(intent))) {

            List<Object> params = buildParams(intent);
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) results.add(rowToMap(rs));
            }
        } catch (Exception e) {
            System.err.println("[ChatServlet] DB lỗi: " + e.getMessage());
        }
        return results;
    }

    private String buildSQL(UserIntent intent) {
        StringBuilder sql = new StringBuilder(
            "SELECT p.product_id, p.product_name, p.price, p.description, " +
            "       c.category_name, p.discount_price " +
            "FROM products p " +
            "LEFT JOIN categories c ON p.category_id = c.category_id " +
            "WHERE p.price > 0"
        );
        if (intent.category     != null) sql.append(" AND LOWER(c.category_name) LIKE LOWER(?)");
        if (intent.priceMin     >  0)    sql.append(" AND p.price >= ?");
        if (intent.priceMax     >  0)    sql.append(" AND p.price <= ?");
        if (intent.specificName != null) sql.append(" AND p.product_name LIKE ?");
        else if (intent.productKeyword != null && !intent.productKeyword.equals("sản phẩm"))
                                          sql.append(" AND p.product_name LIKE ?");
        sql.append(" ORDER BY p.price ASC LIMIT ").append(MAX_RESULTS);
        return sql.toString();
    }

    private List<Object> buildParams(UserIntent intent) {
        List<Object> p = new ArrayList<>();
        if (intent.category     != null) p.add("%" + intent.category + "%");
        if (intent.priceMin     >  0)    p.add(intent.priceMin);
        if (intent.priceMax     >  0)    p.add(intent.priceMax);
        if (intent.specificName != null) p.add("%" + intent.specificName + "%");
        else if (intent.productKeyword != null && !intent.productKeyword.equals("sản phẩm"))
                                          p.add("%" + intent.productKeyword + "%");
        return p;
    }

    private Map<String, Object> rowToMap(ResultSet rs) throws SQLException {
        float original    = rs.getFloat("price");
        int  discountPct = rs.getInt("discount_price"); 
        
        boolean hasDiscount = discountPct > 0 && discountPct < 100;
        float discounted  = hasDiscount ? original * (100 - discountPct) / 100f : original;

        Map<String, Object> row = new HashMap<>();
        row.put("id",       rs.getInt("product_id"));
        row.put("name",     rs.getString("product_name"));
        row.put("price",    discounted);
        row.put("priceOld", original);
        row.put("desc",     rs.getString("description"));
        row.put("category", rs.getString("category_name"));
        return row;
    }

    // ==================== FORMAT RESPONSE ====================

    private String tryQuickReply(String msg) {
        String m = msg.toLowerCase();
        if (m.matches(".*(xin chào|hello|hi|chào|hey).*"))
            return GREETINGS[rng.nextInt(GREETINGS.length)];
        if (m.matches(".*(cảm ơn|cám ơn|thanks|thank|thx).*"))
            return THANKS_REPLIES[rng.nextInt(THANKS_REPLIES.length)];
        if (m.matches(".*(giờ mở cửa|địa chỉ|liên hệ|hotline|ở đâu).*"))
            return "📍 CozyHome mở cửa **8h–21h** hàng ngày.\n" +
                   "Ghé trang **Liên Hệ** để xem địa chỉ và số điện thoại nhé!";
        return null;
    }

    private String buildClarifyQuestion(String keyword) {
        return "🔍 Bạn đang tìm **" + keyword + "** đúng không?\n\n" +
               "Cho mình biết thêm một chút để tìm chính xác hơn:\n" +
               "• 💰 Khoảng giá bạn dự tính?\n" +
               "• 🏠 Đặt ở phòng nào (phòng khách, phòng ngủ, văn phòng...)?\n\n" +
               "_Ví dụ: \"Tôi cần " + keyword + " cho phòng khách, giá dưới 8 triệu\"_";
    }

    private String buildContactSuggestion(HttpServletRequest req, HttpServletResponse res) {
        String link = res.encodeRedirectURL(req.getContextPath() + CONTACT_URL);
        return "Câu hỏi này cần tư vấn chuyên sâu hơn, mình chưa đủ khả năng trả lời chắc chắn 😅\n\n" +
               "Để được tư vấn **đúng nhất** về phong cách, màu sắc hay cách bố trí phù hợp với " +
               "căn phòng của bạn, bạn nên nói chuyện trực tiếp với đội ngũ CozyHome nhé!\n\n" +
               "👉 [Liên hệ tư vấn viên ngay](" + link + ")\n\n" +
               "_Phản hồi trong vòng vài phút trong giờ làm việc (8h–21h)_ 🙏";
    }

    private String buildNotFoundReply(String keyword, HttpServletRequest req, HttpServletResponse res) {
        String link = res.encodeRedirectURL(req.getContextPath() + CONTACT_URL);
        String kw   = keyword != null ? keyword : "sản phẩm này";
        return "Mình tìm trong hệ thống nhưng hiện chưa có **" + kw + "** phù hợp với yêu cầu của bạn 😔\n\n" +
               "Có thể hàng đang tạm hết hoặc chưa cập nhật lên web.\n\n" +
               "👉 [Liên hệ tư vấn viên](" + link + ") để kiểm tra kho hàng thực tế nhé, " +
               "chắc chắn sẽ tìm được thứ bạn cần! 💪";
    }

    private String buildPromoTeaser(List<Map<String, Object>> onSale) {
        StringBuilder sb = new StringBuilder("🎉 Mình tìm được mấy sản phẩm đang **giảm giá** này:\n\n");
        for (Map<String, Object> p : onSale) {
            sb.append("• **").append(p.get("name")).append("**: ")
              .append("<del>").append(toVND(price(p, "priceOld"))).append("đ</del>")
              .append(" → **").append(toVND(price(p, "price"))).append("đ**\n");
        }
        sb.append("\n👉 Bạn **có muốn xem chi tiết** mấy sp này không? *(Có / Không)*");
        return sb.toString();
    }

    private String formatResults(List<Map<String, Object>> products,
                                  HttpServletRequest req, HttpServletResponse res) {
        if (products.size() == 1) return formatSingle(products.get(0), req, res);
        return formatList(products, req, res);
    }

    private String formatSingle(Map<String, Object> p,
                                  HttpServletRequest req, HttpServletResponse res) {
        float current = price(p, "price");
        float old     = price(p, "priceOld");
        String link   = productLink(p, req, res);
        StringBuilder sb = new StringBuilder();
        sb.append("✅ **").append(p.get("name")).append("**\n");
        sb.append("💰 ").append(toVND(current)).append("đ");
        if (current < old) sb.append(" *(giảm từ ").append(toVND(old)).append("đ)*");
        sb.append("\n📂 ").append(p.get("category"));
        sb.append("\n🔗 [Xem chi tiết](").append(link).append(")");
        return sb.toString();
    }

    private String formatList(List<Map<String, Object>> products,
                               HttpServletRequest req, HttpServletResponse res) {
        StringBuilder sb = new StringBuilder(
            "🔎 Mình tìm được **" + products.size() + " sản phẩm** phù hợp:\n\n"
        );
        for (Map<String, Object> p : products) {
            float current = price(p, "price");
            float old     = price(p, "priceOld");
            String link   = productLink(p, req, res);
            sb.append("• **").append(p.get("name")).append("** — ")
              .append(toVND(current)).append("đ");
            if (current < old) sb.append(" 🔥 giảm");
            sb.append("\n 🔗 [Chi tiết](").append(link).append(")\n");
        }
        return sb.toString();
    }

    // ==================== KHUYẾN MÃI ====================

    private List<Map<String, Object>> filterOnSale(List<Map<String, Object>> products) {
        List<Map<String, Object>> onSale = new ArrayList<>();
        for (Map<String, Object> p : products) {
            if (price(p, "price") < price(p, "priceOld")) onSale.add(p);
        }
        return onSale;
    }

    private String handlePromoResponse(String msg, ChatState state,
                                        HttpServletRequest req, HttpServletResponse res) {
        String lower = msg.toLowerCase();
        if (lower.matches(".*(có|ok|ừ|muốn|xem|được).*")) {
            state.waitingForPromoAnswer = false;
            String reply = "🎁 **Sản phẩm giảm giá dành cho bạn:**\n\n" +
                           formatList(state.promoList, req, res);
            state.promoList.clear();
            return reply;
        }
        if (lower.matches(".*(không|thôi|bỏ qua|skip).*")) {
            state.waitingForPromoAnswer = false;
            state.promoList.clear();
            return "Oke! Bạn muốn tìm thêm sản phẩm nào khác không? 😊";
        }
        return null;
    }

    // ==================== HELPERS ====================

    private float price(Map<String, Object> product, String key) {
        return ((Number) product.get(key)).floatValue();
    }

    private String toVND(float amount) {
        return String.format("%,d", (long) amount).replace(',', '.');
    }

    private String productLink(Map<String, Object> p, HttpServletRequest req, HttpServletResponse res) {
        return res.encodeRedirectURL(req.getContextPath() + "/ProductDetail?id=" + p.get("id"));
    }

    private ChatState getOrCreateState(HttpSession session) {
        ChatState state = (ChatState) session.getAttribute("chatState");
        if (state == null) {
            state = new ChatState();
            session.setAttribute("chatState", state);
        }
        return state;
    }

    // ==================== INNER CLASSES ====================

    private static class ChatState {
        boolean waitingForPromoAnswer = false;
        List<Map<String, Object>> promoList = new ArrayList<>();
        String lastQuestion = null;
    }

    private static class UserIntent {
        boolean wantsProduct   = false;
        String  productKeyword = null;
        String  specificName   = null;
        float   priceMin       = 0;
        float   priceMax       = 0;
        String  category       = null;
    }
}

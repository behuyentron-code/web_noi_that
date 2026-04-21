package Controller;

import Model.dbConnect;
import java.sql.Connection;
import java.io.IOException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.annotation.WebServlet;

public class ChatServlet extends HttpServlet {

   // private static final String API_KEY = "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";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain;charset=UTF-8");
        String message = request.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            response.getWriter().write("Vui lòng nhập câu hỏi.");
            return;
        }

        // Lấy dữ liệu sản phẩm từ DB
        String databaseContext = "";
        try {
            Connection conn = new dbConnect().getConnect();
            if (conn != null) {
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT product_name, price FROM products WHERE product_name IS NOT NULL AND price > 0");
                ResultSet rs = ps.executeQuery();
                StringBuilder sb = new StringBuilder();
                while (rs.next()) {
                     System.out.println("product_name = [" + rs.getString("product_name") + "]");
    System.out.println("price = [" + rs.getInt("price") + "]");
                    
                    sb.append(rs.getString("product_name"))
                      .append(": ").append(rs.getInt("price")).append("đ; ");
                }
                databaseContext = sb.toString();
                rs.close(); ps.close(); conn.close();
            }
        } catch (Exception ex) {
            Logger.getLogger(ChatServlet.class.getName()).log(Level.WARNING, "DB error", ex);
        }

        // Xây prompt
        String finalPrompt;
        if (!databaseContext.isEmpty()) {
            finalPrompt = "Bạn là trợ lý tư vấn nội thất DECOR LUXURY. "
                + "Danh sách sản phẩm: " + databaseContext
                + ". Hãy tư vấn cho khách: " + message
                + ". In đậm tên sản phẩm và giá bằng **tên**. Trả lời tiếng Việt, ngắn gọn.";
        } else {
            finalPrompt = "Bạn là trợ lý nội thất DECOR LUXURY. "
                + "Trả lời tiếng Việt, ngắn gọn: " + message;
        }

        // Gọi AI 1 lần duy nhất và trả về
        String botReply = callGemini(finalPrompt);
        response.getWriter().write(botReply);
    }

    private static final String API_KEY = "AIzaSyCQv-zJHgfQoBnZZ7FE3z_9rafYd_EZlFM"; // key Google của bạn

private String callGemini(String message) {
    try {
        URL url = new URL("https://generativelanguage.googleapis.com/v1beta/models/"
                + "gemini-2.0-flash:generateContent?key=" + API_KEY);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(10000);
        conn.setReadTimeout(20000);

        String safe = message
            .replace("\\", "\\\\").replace("\"", "\\\"")
            .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");

        String json = "{"
            + "\"contents\":[{"
            + "\"parts\":[{\"text\":\"" + safe + "\"}]"
            + "}]"
            + "}";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(json.getBytes("utf-8"));
        }

        int code = conn.getResponseCode();
        System.out.println("Gemini response code: " + code);

        if (code == 200) {
            StringBuilder sb = new StringBuilder();
            try (Scanner sc = new Scanner(conn.getInputStream(), "utf-8")) {
                while (sc.hasNextLine()) sb.append(sc.nextLine());
            }
            String result = sb.toString();
            System.out.println("=== GEMINI RESPONSE ===");
            System.out.println(result);
            System.out.println("=======================");

            // Parse: tìm "text":"..."
            int idx = result.indexOf("\"text\":\"");
            if (idx == -1) return "Không nhận được phản hồi từ AI.";
            idx += 8; // bỏ qua "text":"

            StringBuilder out = new StringBuilder();
            for (int i = idx; i < result.length(); i++) {
                char c = result.charAt(i);
                if (c == '\\' && i + 1 < result.length()) {
                    char next = result.charAt(i + 1);
                    if      (next == '"')  { out.append('"');  i++; }
                    else if (next == 'n')  { out.append('\n'); i++; }
                    else if (next == '\\') { out.append('\\'); i++; }
                    else if (next == '*')  { out.append('*');  i++; }
                    else                   { out.append(c); }
                } else if (c == '"') {
                    break;
                } else {
                    out.append(c);
                }
            }
            return out.toString().replace("\n", "<br>");

        } else if (code == 429) {
            return "Hạn mức API đã hết, vui lòng thử lại sau 1 phút! ☕";
        } else {
            StringBuilder err = new StringBuilder();
            try (Scanner sc = new Scanner(conn.getErrorStream(), "utf-8")) {
                while (sc.hasNextLine()) err.append(sc.nextLine());
            }
            System.out.println("Gemini error: " + err);
            return "Lỗi API: " + code;
        }
    } catch (IOException e) {
        return "Lỗi kết nối: " + e.getMessage();
    }
}
}
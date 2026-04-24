/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import DAO.products_DAO;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import service.chatProcessor;
/**
 *
 * @author TRAN ANH DUC
 */
public class ChatBotAI {

     private chatProcessor txtBot;
    private products_DAO dao;
    private Map<String, String> cache = new HashMap<>();

    private final String API_KEY = "YOUR_API_KEY";

    public ChatBotAI(String txtPath) {
        txtBot = new chatProcessor(txtPath);
        dao = new products_DAO();
    }

//    public String getReply(String message, HttpServletRequest request) {
//
//        message = message.toLowerCase().trim();
//
//        // 🔹 1. DB
//        String db = dao.fiAnswer(message);
//        if (db != null && !db.isEmpty()) return db;
//
//        // 🔹 2. TXT
//        String txt = txtBot.getResponse(message);
//        if (!txt.contains("chưa hiểu")) return txt;
//
//        // 🔹 3. Cache
//        if (cache.containsKey(message)) {
//            return cache.get(message);
//        }
//
//        // 🔹 4. tránh spam API
//        if (isSimple(message)) {
//            return "Bạn có thể hỏi rõ hơn về sản phẩm giúp mình nhé 😊";
//        }
//
//        // 🔹 5. AI + Memory
//        List<String> history = getHistory(request);
//        String reply = callGemini(message, history);
//
//        updateHistory(request, message, reply);
//        cache.put(message, reply);
//
//        return reply;
//    }

    // ================= MEMORY =================

    private List<String> getHistory(HttpServletRequest request) {
        HttpSession session = request.getSession();
        List<String> history = (List<String>) session.getAttribute("chatHistory");

        if (history == null) history = new ArrayList<>();
        return history;
    }

    private void updateHistory(HttpServletRequest request, String user, String bot) {
        HttpSession session = request.getSession();
        List<String> history = getHistory(request);

        history.add("User: " + user);
        history.add("Bot: " + bot);

        // giữ tối đa 8 lượt (16 dòng)
        if (history.size() > 16) {
            history = history.subList(history.size() - 16, history.size());
        }

        session.setAttribute("chatHistory", history);
    }

    private String buildPrompt(String message, List<String> history) {
        StringBuilder prompt = new StringBuilder();

        prompt.append("Bạn là chatbot bán nội thất.\n");
        prompt.append("Trả lời ngắn gọn, tự nhiên.\n\n");

        for (String line : history) {
            prompt.append(line).append("\n");
        }

        prompt.append("User: ").append(message).append("\nBot:");

        return prompt.toString();
    }

    // ================= AI =================

    private String callGemini(String message, List<String> history) {

        int maxRetry = 3;

        for (int i = 0; i < maxRetry; i++) {
            try {
                String prompt = buildPrompt(message, history);

                URL url = new URL(
                        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + API_KEY);

                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setDoOutput(true);
                conn.setRequestProperty("Content-Type", "application/json");

                String body = "{ \"contents\": [{ \"parts\": [{\"text\": \"" + prompt + "\"}]}]}";

                try (OutputStream os = conn.getOutputStream()) {
                    os.write(body.getBytes("UTF-8"));
                }

                int status = conn.getResponseCode();
                System.out.println("API status: " + status);

                // ❌ 401
                if (status == 401) {
                    return "❌ API Key không hợp lệ!";
                }

                // 🔁 429
                if (status == 429) {
                    int wait = 2 + i * 2;
                    Thread.sleep(wait * 1000);
                    continue;
                }

                // ⚠️ 503 / 529
                if (status == 503 || status == 529) {
                    return "⚠️ Server AI quá tải, thử lại sau!";
                }

                BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), "UTF-8"));

                String line, result = "";
                while ((line = br.readLine()) != null) {
                    result += line;
                }

                return parseResponse(result);

            } catch (IOException e) {
                return "🌐 Lỗi mạng: " + e.getMessage();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }

        return "⚠️ Quá nhiều request, thử lại sau!";
    }

    private String parseResponse(String json) {
        try {
            int start = json.indexOf("text\":\"") + 7;
            int end = json.indexOf("\"", start);
            return json.substring(start, end);
        } catch (Exception e) {
            return "🤖 Không đọc được phản hồi AI";
        }
    }

    // ================= UTILS =================

    private boolean isSimple(String msg) {
        return msg.length() < 5 ||
               msg.equals("hi") ||
               msg.equals("hello") ||
               msg.equals("ok") ||
               msg.equals("thanks");
    }
}

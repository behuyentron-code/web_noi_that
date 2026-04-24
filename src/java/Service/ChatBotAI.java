/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import java.io.*;
import java.util.*;

/**
 *
 * @author TRAN ANH DUC
 */
public class ChatBotAI {

    private List<String> questions = new ArrayList<>();
    private List<String> answers = new ArrayList<>();
    private Map<String, Integer> vocab = new HashMap<>();

    public ChatBotAI() {
        loadData();
        buildVocab();
    }

    private void loadData() {
        try {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(
                            getClass().getClassLoader().getResourceAsStream("chatbot.txt"), "UTF-8"
                    )
            );

            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 2) {
                    questions.add(parts[0].toLowerCase());
                    answers.add(parts[1]);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void buildVocab() {
        int index = 0;
        for (String q : questions) {
            for (String w : q.split(" ")) {
                if (!vocab.containsKey(w)) {
                    vocab.put(w, index++);
                }
            }
        }
    }

    private double[] vectorize(String text) {
        double[] vec = new double[vocab.size()];
        for (String w : text.toLowerCase().split(" ")) {
            if (vocab.containsKey(w)) {
                vec[vocab.get(w)]++;
            }
        }
        return vec;
    }

    private double cosine(double[] a, double[] b) {
        double dot = 0, na = 0, nb = 0;

        for (int i = 0; i < a.length; i++) {
            dot += a[i] * b[i];
            na += a[i] * a[i];
            nb += b[i] * b[i];
        }

        if (na == 0 || nb == 0) {
            return 0;
        }
        return dot / (Math.sqrt(na) * Math.sqrt(nb));
    }

    public String reply(String message, String dbContext) {

        double[] input = vectorize(message);

        double best = 0;
        int index = -1;

        for (int i = 0; i < questions.size(); i++) {
            double score = cosine(input, vectorize(questions.get(i)));

            if (score > best) {
                best = score;
                index = i;
            }
        }

        if (best > 0.3) {
            return answers.get(index);
        }

        // fallback: gợi ý từ DB
        if (message.contains("bàn") || message.contains("ghế")) {
            return suggest(dbContext);
        }

        return "Mình chưa hiểu 😢 bạn thử hỏi về bàn, ghế hoặc giá nhé!";
    }

    private String suggest(String db) {
        if (db == null || db.isEmpty()) {
            return "Chưa có dữ liệu sản phẩm 😢";
        }

        StringBuilder sb = new StringBuilder("✨ Gợi ý sản phẩm:<br>");
        for (String item : db.split(";")) {
            sb.append("👉 ").append(item).append("<br>");
        }
        return sb.toString();
    }
}

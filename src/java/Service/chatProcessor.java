package service;

import java.io.*;
import java.util.*;

public class chatProcessor {

    private Map<String, String> data = new HashMap<>();

    public chatProcessor(String filePath) {
        loadData(filePath);
    }

    private void loadData(String filePath) {
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;

            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");

                if (parts.length == 2) {
                    data.put(parts[0].toLowerCase(), parts[1]);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getResponse(String message) {
        message = message.toLowerCase();

        for (String key : data.keySet()) {
            if (message.contains(key)) {
                return data.get(key);
            }
        }

        return "chưa hiểu"; // để ChatBotAI fallback sang AI
    }
}
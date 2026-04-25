/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.*;
/**
 *
 * @author Admin
 */
public class dbConnect {
    public Connection getConnect() throws Exception {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String cn = "jdbc:mysql://localhost:3306/furniture_web"
                + "?useUnicode=true"
                + "&characterEncoding=UTF-8"
                + "&useSSL=false"
                + "&serverTimezone=UTC"
                + "&useOldAliasMetadataBehavior=true"
                + "&characterSetResults=UTF-8"
                + "&connectionCollation=utf8mb4_general_ci";
 
            Connection conn = DriverManager.getConnection(cn, "root", "");
 
            // Đảm bảo session dùng UTF-8
            Statement st = conn.createStatement();
            st.execute("SET NAMES 'utf8mb4'");
            st.execute("SET CHARACTER SET 'utf8mb4'");
            st.execute("SET character_set_connection='utf8mb4'");
            st.close();
 
            return conn;
 
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }
}


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
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            String cn = "jdbc:mysql://localhost:3306/furniture_web";
            return DriverManager.getConnection(cn,"root","");
             
        } catch (Exception ex) {
            return null;
        }
    }
}


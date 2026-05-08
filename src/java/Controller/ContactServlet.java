/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.products_DAO;
import Model.dbConnect;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.ResultSet;
import java.util.List;
//import static sun.jvm.hotspot.HelloWorld.e;

/**
 *
 * @author TRANG ANH LAPTOP
 */

public class ContactServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        products_DAO dao = new products_DAO();
        List<String> categories = dao.getAllCategoryNames();
        request.setAttribute("categories", categories);

        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("user");

        if (request.getMethod().equalsIgnoreCase("GET")) {
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }

        if (loggedUser == null) {
            request.setAttribute("error", "Báº¡n cáº§n Ä‘Äƒng nháº­p Ä‘á»ƒ gá»­i liĂªn há»‡!");
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }


        String inputName = request.getParameter("name");
        String inputEmail = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");


        if (inputName == null || inputName.trim().isEmpty() ||
            inputEmail == null || inputEmail.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {

            request.setAttribute("error", "Vui lĂ²ng Ä‘iá»�n Ä‘áº§y Ä‘á»§ há»� tĂªn, email, sá»‘ Ä‘iá»‡n thoáº¡i vĂ  ná»™i dung!");
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }


        String registeredEmail = null;
        String registeredName = null; 

        try (Connection conn = new dbConnect().getConnect()) {
            String sql = "SELECT username, email FROM users WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, loggedUser);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                registeredName = rs.getString("username"); 
                registeredEmail = rs.getString("email");
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lá»—i kiá»ƒm tra thĂ´ng tin tĂ i khoáº£n!");
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }


        if (registeredName == null || registeredEmail == null) {
            request.setAttribute("error", "KhĂ´ng tĂ¬m tháº¥y thĂ´ng tin tĂ i khoáº£n cá»§a báº¡n!");
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }

        boolean nameMatch = inputName.trim().equals(registeredName);
        boolean emailMatch = inputEmail.trim().equals(registeredEmail);

        if (!nameMatch || !emailMatch) {
            String errMsg = "TĂªn hoáº·c email khĂ´ng trĂ¹ng vá»›i lĂºc Ä‘Äƒng kĂ½.";
            request.setAttribute("error", errMsg);
            request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
            return;
        }


        try (Connection conn = new dbConnect().getConnect()) {
            String sql = "INSERT INTO contacts (name, email, phone, message) VALUES (?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, inputName);
            ps.setString(2, inputEmail);
            ps.setString(3, phone);
            ps.setString(4, message);
            int result = ps.executeUpdate();
            if (result > 0) {
                request.setAttribute("success", "Gá»­i liĂªn há»‡ thĂ nh cĂ´ng! ChĂºng tĂ´i sáº½ pháº£n há»“i sá»›m.");
            } else {
                request.setAttribute("error", "Gá»­i tháº¥t báº¡i, vui lĂ²ng thá»­ láº¡i!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lá»—i há»‡ thá»‘ng, vui lĂ²ng thá»­ láº¡i sau!");
        

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head><title>Lá»—i</title></head>");
            out.println("<body>");
            out.println("<h1>Ä�Ă£ xáº£y ra lá»—i khi gá»­i liĂªn há»‡!</h1>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("</body>");
            out.println("</html>");
            }
        }
        request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
    }


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
package Controller.Admin;

import DAO.contacts_DAO;
import DAO.users_DAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        users_DAO dao = new users_DAO();
        contacts_DAO contactDao = new contacts_DAO();

        String action = request.getParameter("action");

        // ================= DELETE =================
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteUser(id);

            response.sendRedirect(request.getContextPath() + "/admin/users?msg=deleted");
            return;
        }

        // ================= EDIT (MỞ FORM) =================
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Map<String, Object> user = dao.getUserById(id);

            request.setAttribute("user", user);
            request.getRequestDispatcher("/admin/user_form.jsp").forward(request, response);
            return;
        }

        // ================= UPDATE =================
        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("user_id"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");

          dao.updateUser(id, username, email, phone, password);

            response.sendRedirect(request.getContextPath() + "/admin/users?msg=updated");
            return;
        }

        // ================= FILTER =================
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        int page = 1;
        int recordsPerPage = 10;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        // Nếu bấm "Xóa lọc" → reset page
        if (request.getParameter("keyword") == null) {
            page = 1;
        }

        List<Map<String, Object>> users = dao.getAllUsersOnly(
                keyword.trim().isEmpty() ? null : keyword.trim(),
                page,
                recordsPerPage
        );

        int totalRecords = dao.countUsersOnly(
                keyword.trim().isEmpty() ? null : keyword.trim()
        );

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        // Đếm số contact
        for (Map<String, Object> user : users) {
            String email = (String) user.get("email");

            int count = (email != null && !email.isEmpty())
                    ? contactDao.countContactsByEmail(email)
                    : 0;

            user.put("contactCount", count);
        }

        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
}
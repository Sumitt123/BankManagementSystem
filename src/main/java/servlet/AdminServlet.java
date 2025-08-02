package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String adminName = request.getParameter("adminName");
        String adminPass = request.getParameter("adminPass");

        if (ADMIN_USERNAME.equals(adminName) && ADMIN_PASSWORD.equals(adminPass)) {
            HttpSession session = request.getSession();
            session.setAttribute("isAdmin", true);
            session.setAttribute("adminName", adminName);
            response.sendRedirect("admin_dashboard.jsp");
        } else {
            response.sendRedirect("login.jsp?adminError=Invalid%20credentials");
        }
    }
}
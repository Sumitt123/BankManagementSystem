package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.DatabaseConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//@WebServlet("/login")
public class LoginServlt extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String password = request.getParameter("password");

        try (Connection con = DatabaseConnection.getConnection()) {
            String sql = "SELECT name, email, isverified FROM users WHERE name = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                boolean isVerified = rs.getBoolean("isverified");

                if (!isVerified) {
                    // ❌ Blocked user
                    response.sendRedirect("login.jsp?error=blocked");
                    return;
                }

                // ✅ Successful login
                HttpSession session = request.getSession();
                session.setAttribute("username", rs.getString("name"));
                session.setAttribute("email", rs.getString("email"));

                response.sendRedirect("dashboard.jsp");

            } else {
                // ❌ Invalid login
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Something went wrong.");
        }
    }
}

package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.DatabaseConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

//@WebServlet("/RegisterServlt") // ✅ Make sure this matches your form's action
public class RegisterServlt extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String father = request.getParameter("father");
        String mobile = request.getParameter("mobile");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // ✅ Step 1: Auto-generate unique account number
        long randomNumber = 1000000000L + (long) (Math.random() * 9000000000L);
        String accountNumber = "ACC" + randomNumber;

        try (Connection con = DatabaseConnection.getConnection()) {
            // ✅ Step 2: Include account_number in the insert query
            String sql = "INSERT INTO users(name, father_name, mobile, email, password, account_number) VALUES(?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, father);
            ps.setString(3, mobile);
            ps.setString(4, email);
            ps.setString(5, password);
            ps.setString(6, accountNumber);  // ✅ Account number added

            int result = ps.executeUpdate();
            if (result > 0) {
                // ✅ Success: Optionally show account number to user
                response.sendRedirect("login.jsp");
            } else {
                response.getWriter().print("Registration failed.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("Database error: " + e.getMessage());
        }
    }
}

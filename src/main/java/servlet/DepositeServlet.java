package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.DatabaseConnection;

import java.io.IOException;
import java.sql.*;

//@WebServlet("/DepositeServlet")
public class DepositeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String amountStr = request.getParameter("amount");
        String description = request.getParameter("description");

        if (email == null || amountStr == null || amountStr.isEmpty()) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            double amount = Double.parseDouble(amountStr);

            PreparedStatement ps1 = conn.prepareStatement("SELECT balance FROM users WHERE email = ?");
            ps1.setString(1, email);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                double currentBalance = rs.getDouble("balance");
                double newBalance = currentBalance + amount;

                PreparedStatement ps2 = conn.prepareStatement("UPDATE users SET balance = ? WHERE email = ?");
                ps2.setDouble(1, newBalance);
                ps2.setString(2, email);
                ps2.executeUpdate();

                PreparedStatement ps3 = conn.prepareStatement("INSERT INTO transaction (email, type, amount, description) VALUES (?, ?, ?, ?)");
                ps3.setString(1, email);
                ps3.setString(2, "Deposit");
                ps3.setDouble(3, amount);
                ps3.setString(4, description != null ? description : "User deposit");
                ps3.executeUpdate();

                response.sendRedirect("dashboard.jsp?deposit=success");
            } else {
                response.getWriter().println("User not found with email: " + email);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Deposit failed: " + e.getMessage());
        }
    }
}

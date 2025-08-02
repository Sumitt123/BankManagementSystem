package servlet;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.DatabaseConnection;

//@WebServlet("/WithdrawServlet")
public class WithdrawServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String amountStr = request.getParameter("amount");
        String description = request.getParameter("description");

        if (amountStr == null || amountStr.isEmpty()) {
            response.sendRedirect("withdraw.jsp?error=invalidAmount");
            return;
        }

        try (Connection con = DatabaseConnection.getConnection()) {
            double amount = Double.parseDouble(amountStr);

            if (amount <= 0) {
                response.sendRedirect("withdraw.jsp?error=invalidAmount");
                return;
            }

            // Get current balance
            String balanceQuery = "SELECT balance FROM users WHERE email = ?";
            PreparedStatement balanceStmt = con.prepareStatement(balanceQuery);
            balanceStmt.setString(1, email);
            ResultSet rs = balanceStmt.executeQuery();

            if (rs.next()) {
                double currentBalance = rs.getDouble("balance");

                if (currentBalance >= amount) {
                    // Start transaction
                    con.setAutoCommit(false);

                    // 1. Update user's balance
                    String updateBalanceSQL = "UPDATE users SET balance = balance - ? WHERE email = ?";
                    PreparedStatement updateStmt = con.prepareStatement(updateBalanceSQL);
                    updateStmt.setDouble(1, amount);
                    updateStmt.setString(2, email);
                    updateStmt.executeUpdate();

                    // 2. Insert transaction record
                    String insertSQL = "INSERT INTO transaction (email, type, amount, description) VALUES (?, 'Withdraw', ?, ?)";
                    PreparedStatement insertStmt = con.prepareStatement(insertSQL);
                    insertStmt.setString(1, email);
                    insertStmt.setDouble(2, amount);
                    insertStmt.setString(3, (description != null && !description.isEmpty()) ? description : "User withdrawal");
                    insertStmt.executeUpdate();

                    con.commit();  // ✅ Commit both updates
                    response.sendRedirect("dashboard.jsp?withdraw=success");
                } else {
                    response.sendRedirect("withdraw.jsp?error=insufficientFunds");
                }
            } else {
                response.sendRedirect("withdraw.jsp?error=userNotFound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("withdraw.jsp?error=serverError");
        }
    }
}

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

//@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String senderEmail = (String) session.getAttribute("email");
        String receiverUsername = request.getParameter("receiver");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String description = request.getParameter("description");

        if (amount <= 0) {
            response.sendRedirect("transfer.jsp?error=invalidAmount");
            return;
        }

        try (Connection con = DatabaseConnection.getConnection()) {
            con.setAutoCommit(false);

            // 1. Check sender balance
            PreparedStatement senderBalanceStmt = con.prepareStatement("SELECT balance FROM users WHERE email = ?");
            senderBalanceStmt.setString(1, senderEmail);
            ResultSet rsSender = senderBalanceStmt.executeQuery();

            if (!rsSender.next()) {
                response.sendRedirect("transfer.jsp?error=senderNotFound");
                return;
            }

            double senderBalance = rsSender.getDouble("balance");
            if (senderBalance < amount) {
                response.sendRedirect("transfer.jsp?error=insufficientFunds");
                return;
            }

            // 2. Get receiver email
            PreparedStatement receiverStmt = con.prepareStatement("SELECT email FROM users WHERE name = ?");
            receiverStmt.setString(1, receiverUsername);
            ResultSet rsReceiver = receiverStmt.executeQuery();

            if (!rsReceiver.next()) {
                response.sendRedirect("transfer.jsp?error=receiverNotFound");
                return;
            }

            String receiverEmail = rsReceiver.getString("email");

            // 3. Deduct from sender
            PreparedStatement deductStmt = con.prepareStatement("UPDATE users SET balance = balance - ? WHERE email = ?");
            deductStmt.setDouble(1, amount);
            deductStmt.setString(2, senderEmail);
            deductStmt.executeUpdate();

            // 4. Add to receiver
            PreparedStatement addStmt = con.prepareStatement("UPDATE users SET balance = balance + ? WHERE email = ?");
            addStmt.setDouble(1, amount);
            addStmt.setString(2, receiverEmail);
            addStmt.executeUpdate();

            // 5. Log transaction for sender
            PreparedStatement logSender = con.prepareStatement("INSERT INTO transaction (email, type, amount, description) VALUES (?, 'transfer', ?, ?)");
            logSender.setString(1, senderEmail);
            logSender.setDouble(2, amount);
            logSender.setString(3, "To: " + receiverUsername + (description != null ? " – " + description : ""));
            logSender.executeUpdate();

            // 6. Log transaction for receiver
            PreparedStatement logReceiver = con.prepareStatement("INSERT INTO transaction (email, type, amount, description) VALUES (?, 'receive', ?, ?)");
            logReceiver.setString(1, receiverEmail);
            logReceiver.setDouble(2, amount);
            logReceiver.setString(3, "From: " + session.getAttribute("username") + (description != null ? " – " + description : ""));
            logReceiver.executeUpdate();

            con.commit();
            request.getSession().setAttribute("transferSuccess", "Transfer Successful!");
            response.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("transferError", "Transfer Failed: Insufficient balance.");
            response.sendRedirect("dashboard.jsp");
    }
    }
}
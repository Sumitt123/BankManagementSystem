<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, java.util.*, util.DatabaseConnection" %>
<%
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    if (username == null || email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, String>> transactions = new ArrayList<>();

    try (Connection con = DatabaseConnection.getConnection()) {
        String txSql = "SELECT type, amount, description, timestamp FROM transaction WHERE email = ? ORDER BY timestamp DESC";
        PreparedStatement ps = con.prepareStatement(txSql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> tx = new HashMap<>();
            tx.put("type", rs.getString("type"));
            tx.put("amount", rs.getString("amount"));
            tx.put("description", rs.getString("description"));
            tx.put("timestamp", rs.getString("timestamp"));
            transactions.add(tx);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="CSS/dashboard.css">
</head>
<body class="light-mode">
    <div class="container py-5">
        <h2 class="text-center mb-4">📜 Full Transaction History</h2>
        <a href="dashboard.jsp" class="btn btn-secondary mb-3">← Back to Dashboard</a>

        <div class="card shadow-sm">
            <div class="card-body">
                <% if (transactions.isEmpty()) { %>
                    <p class="text-muted">No transactions found.</p>
                <% } else { %>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th>Amount (₹)</th>
                                <th>Description</th>
                                <th>Date & Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, String> tx : transactions) { %>
                                <tr>
                                    <td><%= tx.get("type").toUpperCase() %></td>
                                    <td><%= tx.get("amount") %></td>
                                    <td><%= tx.get("description") %></td>
                                    <td><%= tx.get("timestamp") %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>

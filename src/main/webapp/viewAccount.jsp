<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, util.DatabaseConnection" %>
<%
    String displayName = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");

    if (email == null || displayName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String accNumber = "", accType = "", branch = "";
    double balance = 0.0;

    try (Connection con = DatabaseConnection.getConnection()) {
        String sql = "SELECT * FROM users WHERE email = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            accNumber = rs.getString("account_number");
            accType = rs.getString("account_type");
            branch = rs.getString("branch");
            balance = rs.getDouble("balance");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Account</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="CSS/dashboard.css">
</head>
<body>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="d-flex align-items-center">
            <div class="dropdown me-3">
                <img src="images/dashbordicon.png" alt="Avatar" class="avatar dropdown-toggle" data-bs-toggle="dropdown">
                <ul class="dropdown-menu dropdown-menu-end shadow">
                    <li><h6 class="dropdown-header"><%= displayName %></h6></li>
                    <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                    <li><a class="dropdown-item" href="settings.jsp">Settings</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="login.jsp">Logout</a></li>
                </ul>
            </div>
            <h4 class="mb-0"> View Account </h4>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-info text-white">Account Details</div>
        <div class="card-body">
            <p><strong>Account Number:</strong> <%= accNumber %></p>
            <p><strong>Account Type:</strong> <%= accType %></p>
            <p><strong>Current Balance:</strong> ₹<%= String.format("%.2f", balance) %></p>
            <p><strong>Branch:</strong> <%= branch %></p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

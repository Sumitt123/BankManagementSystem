<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, util.DatabaseConnection" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userCount = 0;
    double totalBalance = 0;
    int transactionCount = 0;

    try (Connection con = DatabaseConnection.getConnection()) {
        Statement stmt = con.createStatement();

        ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM users");
        if (rs1.next()) userCount = rs1.getInt(1);

        ResultSet rs2 = stmt.executeQuery("SELECT SUM(balance) FROM users");
        if (rs2.next()) totalBalance = rs2.getDouble(1);

        ResultSet rs3 = stmt.executeQuery("SELECT COUNT(*) FROM transaction");
        if (rs3.next()) transactionCount = rs3.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
        }
        .card {
            border-radius: 16px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }
        .card-title {
            font-weight: 600;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
    <a class="navbar-brand" href="#">Admin Panel</a>
    <div class="ms-auto">
        <span class="text-white me-3">Welcome, <%= session.getAttribute("adminName") %></span>
        <a href="login.jsp" class="btn btn-sm btn-outline-light">Logout</a>
    </div>
</nav>


<div class="container py-5">
    <h2 class="mb-4">Dashboard Overview</h2>
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card text-white bg-primary">
                <div class="card-body">
                    <h5 class="card-title">Total Users</h5>
                    <p class="card-text display-6"><%= userCount %></p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-success">
                <div class="card-body">
                    <h5 class="card-title">Total Balance</h5>
                    <p class="card-text display-6">₹<%= String.format("%.2f", totalBalance) %></p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-white bg-warning">
                <div class="card-body">
                    <h5 class="card-title">Transactions</h5>
                    <p class="card-text display-6"><%= transactionCount %></p>
                </div>
            </div>
        </div>
    </div>

    <div class="mt-5">
        <h4>Quick Actions</h4>
        <div class="d-flex gap-3 mt-3">
            <a href="manageUsers.jsp" class="btn btn-outline-primary">Manage Users</a>
            <a href="transactions.jsp" class="btn btn-outline-success">View Transactions</a>
            <a href="reports.jsp" class="btn btn-outline-secondary">Generate Reports</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

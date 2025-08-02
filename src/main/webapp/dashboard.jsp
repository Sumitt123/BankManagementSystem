<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, java.util.*, util.DatabaseConnection" %>

<%
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    if (username == null || email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    double balance = 0.0;
    List<Map<String, String>> transactions = new ArrayList<>();

    try (Connection con = DatabaseConnection.getConnection()) {
        // Get balance
        String sql = "SELECT balance FROM users WHERE email = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            balance = rs.getDouble("balance");
        }

        // Get recent transactions
        String txSql = "SELECT type, amount, description, timestamp FROM transaction WHERE email = ? ORDER BY timestamp DESC LIMIT 10";
        ps = con.prepareStatement(txSql);
        ps.setString(1, email);
        rs = ps.executeQuery();
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
    <title>Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="CSS/dashboard.css">
</head>
<body class="light-mode">

<%
    String depositSuccess = request.getParameter("deposit");
    String withdrawSuccess = request.getParameter("withdraw");
    String transferSuccess = (String) session.getAttribute("transferSuccess");
    String transferError = (String) session.getAttribute("transferError");
%>

<% if ("success".equals(depositSuccess)) { %>
    <div class="alert alert-success alert-dismissible fade show text-center m-4" role="alert">
        💰 Deposit Successful!
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<% } else if ("success".equals(withdrawSuccess)) { %>
    <div class="alert alert-success alert-dismissible fade show text-center m-4" role="alert">
        💸 Withdrawal Successful!
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<% } else if (transferSuccess != null) { %>
    <div class="alert alert-success alert-dismissible fade show text-center m-4" role="alert">
        🔄 <%= transferSuccess %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%
        session.removeAttribute("transferSuccess");
    %>
<% } else if (transferError != null) { %>
    <div class="alert alert-danger alert-dismissible fade show text-center m-4" role="alert">
        ❌ <%= transferError %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%
        session.removeAttribute("transferError");
    %>
<% } %>



<!-- Navbar -->
<nav class="navbar navbar-expand-lg shadow-sm px-4">
    <div class="container-fluid justify-content-between">
        <span class="navbar-brand">🏦 MyBank Dashboard</span>

        <div class="d-flex align-items-center gap-3">
            <div class="dropdown">
                <img src="images/dashbordicon.png" alt="Avatar" class="avatar dropdown-toggle" data-bs-toggle="dropdown">
                <ul class="dropdown-menu dropdown-menu-end shadow">
                    <li><h6 class="dropdown-header"><%= username %></h6></li>
                    <!-- <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>-->
                    <li><a class="dropdown-item" href="settings.jsp">Settings</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="login.jsp">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<!-- Main Container -->
<div class="container py-5">

    <!-- Welcome & Balance -->
    <div class="text-center mb-4">
        <h3>Hello, <%= username %> 👋</h3>
        <p class="text-muted">Your current balance is:</p>
        <h2>₹<%= String.format("%.2f", balance) %></h2>
    </div>

    <!-- Action Buttons -->
    <div class="row text-center g-4 mb-4">
        <div class="col-md-3"><a href="viewAccount.jsp" class="btn btn-custom btn-primary">View Account</a></div>
        <div class="col-md-3"><a href="deposit.jsp" class="btn btn-custom btn-success">Deposit</a></div>
        <div class="col-md-3"><a href="withdraw.jsp" class="btn btn-custom btn-danger">Withdraw</a></div>
        <div class="col-md-3"><a href="transfer.jsp" class="btn btn-custom btn-warning">Transfer</a></div>
    </div>

   <!-- Cards -->
<div class="row g-4">
    <!-- Recent Transactions Card -->
    <div class="col-md-8">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">Recent Transactions</div>
            <ul class="list-group list-group-flush">
                <% if (transactions.isEmpty()) { %>
                    <li class="list-group-item text-muted">No transactions found.</li>
                <% } else {
                    for (Map<String, String> t : transactions) {
                        String type = t.get("type");
                        String sign = ("withdraw".equalsIgnoreCase(type) || "transfer".equalsIgnoreCase(type)) ? "-" : "+";
                        String badge = ("withdraw".equalsIgnoreCase(type) || "transfer".equalsIgnoreCase(type)) ? "danger" : "success";
                %>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <span class="badge bg-<%= badge %> me-2"><%= type %></span>
                            <%= t.get("description") %>
                            <br/><small class="text-muted"><%= t.get("timestamp") %></small>
                        </div>
                        <div><strong><%= sign %> ₹<%= t.get("amount") %></strong></div>
                    </li>
                <% } } %>
            </ul>
            <div class="text-end p-3">
                <a href="transactionHistory.jsp" class="btn btn-outline-primary btn-sm">View All Transactions</a>
            </div>
        </div>
    </div>

    <!-- Optional: Add another card/column on the right if needed -->
    <div class="col-md-4">
        <!-- You can add notifications, spending chart, etc. here later -->
        <div class="card shadow-sm h-100 text-center p-4">
            <h5 class="mb-3">📊 Summary</h5>
            <p>Last 10 transactions shown. View full history for more.</p>
        </div>
    </div>
</div> <!-- closes .row -->


<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

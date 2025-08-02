<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Withdraw</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="CSS/dashboard.css">
</head>
<body class="light-mode">

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="d-flex align-items-center">
            <div class="dropdown me-3">
                <img src="images/dashbordicon.png" alt="Avatar" class="avatar dropdown-toggle" data-bs-toggle="dropdown">
                <ul class="dropdown-menu dropdown-menu-end shadow">
                    <li><h6 class="dropdown-header"><%= username %></h6></li>
                    <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                    <li><a class="dropdown-item" href="settings.jsp">Settings</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="login.jsp">Logout</a></li>
                </ul>
            </div>
            <h4 class="mb-0">Withdraw Funds</h4>
        </div>
      <!--  <button id="toggleMode" class="btn btn-outline-secondary">Toggle Dark Mode</button> --> 
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <form action="WithdrawServlet" method="post">
                <div class="mb-3">
                    <label for="amount" class="form-label">Amount (₹)</label>
                    <input type="number" class="form-control" id="amount" name="amount" required min="1">
                </div>
                <div class="mb-3">
                    <label for="description" class="form-label">Description (optional)</label>
                    <input type="text" class="form-control" id="description" name="description">
                </div>
                <button type="submit" class="btn btn-danger">Withdraw</button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- <script>
    document.getElementById("toggleMode").addEventListener("click", () => {
        document.body.classList.toggle("dark-mode");
        document.body.classList.toggle("light-mode");
    });
</script> -->
</body>
</html>

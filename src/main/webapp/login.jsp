<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String error = request.getParameter("error");
    String adminError = request.getParameter("adminError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bank Portal</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="CSS/login.css">
</head>
<body>
  <div class="container">

    <!-- 🔔 Error Messages -->
    <% if ("blocked".equals(error)) { %>
      <div class="error-message" id="alertBox">❌ Your account is blocked. Contact admin.</div>
    <% } else if ("invalid".equals(error)) { %>
      <div class="error-message" id="alertBox">⚠️ Invalid username or password.</div>
    <% } else if (adminError != null) { %>
      <div class="error-message" id="alertBox"><%= adminError %></div>
    <% } %>

    <!-- 🔘 Tab Switch Buttons -->
    <div class="tab-buttons">
      <button onclick="showForm('login')">User Login</button>
      <button onclick="showForm('register')">Register</button>
      <button onclick="showForm('admin')">Admin Login</button>
    </div>

    <!-- 👤 User Login Form -->
    <form id="login" class="form active" action="LoginServlt" method="post">
      <h2>User Login</h2>
      <input type="text" name="name" placeholder="Username" required>
      <input type="password" name="password" placeholder="Password" required>
      <button type="submit">Login</button>
    </form>

    <!-- 📝 Registration Form -->
    <form id="register" class="form" action="RegisterServlt" method="post">
      <h2>User Registration</h2>
      <input type="text" name="name" placeholder="Full Name" required>
      <input type="text" name="father" placeholder="Father's Name" required>
      <input type="text" name="mobile" placeholder="Mobile Number" required>
      <input type="email" name="email" placeholder="Email" required>
      <input type="password" name="password" placeholder="Password" required>
      <button type="submit">Register</button>
    </form>

    <!-- 🛡️ Admin Login -->
    <form id="admin" class="form" action="AdminServlet" method="post">
      <h2>Admin Login</h2>
      <input type="text" name="adminName" placeholder="Admin Username" required>
      <input type="password" name="adminPass" placeholder="Password" required>
      <button type="submit">Login</button>
    </form>
  </div>

  <!-- 💡 JavaScript at Bottom -->
  <script>
    function showForm(formId) {
      document.querySelectorAll('.form').forEach(form => form.classList.remove('active'));
      document.getElementById(formId).classList.add('active');
    }

    // Auto-close alert
    window.onload = function () {
      const alertBox = document.getElementById('alertBox');
      if (alertBox) {
        setTimeout(() => {
          alertBox.classList.add('fade-out');
          setTimeout(() => {
            alertBox.remove();
            history.replaceState(null, '', window.location.pathname);
          }, 600);
        }, 5000);
      }
      <% if (adminError != null) { %> showForm('admin'); <% } %>
      <% if ("blocked".equals(error) || "invalid".equals(error)) { %> showForm('login'); <% } %>
    };
  </script>
</body>
</html>

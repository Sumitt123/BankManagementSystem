<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>Settings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <h2 class="mb-4">Settings</h2>

    <!-- Change Password -->
    <div class="card mb-4">
        <div class="card-header">Change Password</div>
        <div class="card-body">
            <form action="ChangePasswordServlet" method="post">
                <div class="mb-3">
                    <label for="currentPassword" class="form-label">Current Password</label>
                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                </div>
                <div class="mb-3">
                    <label for="newPassword" class="form-label">New Password</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                </div>
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                </div>
                <button type="submit" class="btn btn-primary">Update Password</button>
            </form>
        </div>
    </div>

    <!-- Update Contact Info -->
    <div class="card mb-4">
        <div class="card-header">Update Contact Info</div>
        <div class="card-body">
            <form action="UpdateProfileServlet" method="post">
                <div class="mb-3">
                    <label for="mobile" class="form-label">Mobile Number</label>
                    <input type="text" class="form-control" id="mobile" name="mobile" required>
                </div>
                <div class="mb-3">
                    <label for="address" class="form-label">Address</label>
                    <textarea class="form-control" id="address" name="address"></textarea>
                </div>
                <button type="submit" class="btn btn-success">Update Info</button>
            </form>
        </div>
    </div>

    <!-- Deactivate Account -->
    <div class="card">
        <div class="card-header text-danger">Danger Zone</div>
        <div class="card-body">
            <form action="DeactivateAccountServlet" method="post" onsubmit="return confirm('Are you sure you want to deactivate your account?');">
                <button type="submit" class="btn btn-outline-danger">Deactivate Account</button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%@ page import="java.sql.*, java.util.*, util.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
if (isAdmin == null || !isAdmin) {
    response.sendRedirect("login.jsp?adminError=Please login as admin first");
    return;
}



    List<Map<String, String>> users = new ArrayList<>();
    try (Connection con = DatabaseConnection.getConnection()) {
        PreparedStatement ps = con.prepareStatement("SELECT id, name, email, balance, isverified FROM users");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> user = new HashMap<>();
            user.put("id", rs.getString("id"));
            user.put("username", rs.getString("name"));
            user.put("email", rs.getString("email"));
            user.put("balance", rs.getString("balance"));
            user.put("status", rs.getBoolean("isverified")? "active" : "blocked");
            users.add(user);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5">
    <h2 class="mb-4 text-center">👥 Manage Users</h2>

    <table class="table table-bordered table-hover shadow-sm bg-white">
        <thead class="table-dark text-center">
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Balance</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% for (Map<String, String> user : users) { %>
                <tr class="text-center">
                    <td><%= user.get("id") %></td>
                    <td><%= user.get("username") %></td>
                    <td><%= user.get("email") %></td>
                    <td>₹<%= user.get("balance") %></td>
                    <td>
                        <% if ("active".equals(user.get("status"))) { %>
                            <span class="badge bg-success">Active</span>
                        <% } else { %>
                            <span class="badge bg-danger">Blocked</span>
                        <% } %>
                    </td>
                    <td>
                        <form method="post" action="UserActionServlet" class="d-inline">
                            <input type="hidden" name="userId" value="<%= user.get("id") %>">
                            <input type="hidden" name="action" value="<%= "active".equals(user.get("status")) ? "block" : "unblock" %>">
                            <button type="submit" class="btn btn-sm btn-warning"><%= "active".equals(user.get("status")) ? "Block" : "Unblock" %></button>
                        </form>

                        <a href="editUser.jsp?id=<%= user.get("id") %>" class="btn btn-sm btn-info">Edit</a> 

                        <form method="post" action="UserActionServlet" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this user?');">
                            <input type="hidden" name="userId" value="<%= user.get("id") %>">
                            <input type="hidden" name="action" value="delete">
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.DatabaseConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
//@WebServlet("UserActionServlet")
public class UserActionServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException { 
		
		String userId=request.getParameter("userId");
		String action=request.getParameter("action");
		
		try (Connection con=DatabaseConnection.getConnection()){
			PreparedStatement ps=null;
			
			switch (action) {
			case "block":
				ps=con.prepareStatement("UPDATE users SET isverified=0 WHERE id=?");
				break;
				
			case "unblock":
				ps=con.prepareStatement("UPDATE users SET isverified = 1 WHERE id=?");
				break;
				
			case "delete":
				ps=con.prepareStatement("DELETE FROM users WHERE id=?");
				break;
				
				
			default:
				break;
			}
			
			if (ps !=null) {
				ps.setString(1, userId);
				ps.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.sendRedirect("manageUsers.jsp");
	}

}

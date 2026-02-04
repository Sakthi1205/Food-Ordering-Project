package hi;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class loginServlet
 */
@WebServlet("/loginServlet")
public class loginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
		String table_no = request.getParameter("tableNumber");
		String Username = request.getParameter("Username");
		String PhoneNo = request.getParameter("phoneNumber");
		String emailId = request.getParameter("emailnumber");
		
		try {
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/mphasis",
					"root",
					"root@39"
					);
			Statement stmt = con.createStatement();
			
			ResultSet table = stmt.executeQuery("select * from TableID where id="+table_no);
			
			if(!table.next()) {
				response.sendRedirect("user.html");
			}else {
				
				String sql = "insert into NAME(Username,PhoneNumber,emailId) values(?,?,?)";
				
				PreparedStatement ps = con.prepareStatement(sql);
				ps.setString(1, Username);
				ps.setString(2, PhoneNo);
				ps.setString(3, emailId);
				
			}
			
			
		}catch(Exception e) {
			out.println("Error: "+e.getMessage());
		}
		
	}

}

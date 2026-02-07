package h1;

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
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class placed
 */
@WebServlet("/placed")
public class placed extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public placed() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		response.setContentType("text/html");
		HttpSession ss = request.getSession(false);
		PrintWriter out = response.getWriter();
		
		String[] fid =(String[]) ss.getAttribute("fid");
		int[] qty = (int[])ss.getAttribute("qty");
		
try {
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			Connection con = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/mphasis",
					"root",
					"root@39"
					);
			Statement stmt = con.createStatement();
			
			 for (int i = 0; i < fid.length; i++) {
				 ResultSet table = stmt.executeQuery("select * from menu where fid="+fid[i]);
				 
				if(table.next()&&(table.getInt("quantity")-qty[i]) < 0) {
					
//					out.println("<h3>Only "+table.getInt("quantity")+" of "+table.getString("f_item_name")+" is left </h3>");
//					out.println("<a href='menu.jsp'>Back to Menu");
					response.sendRedirect("menu.jsp?itemId="+qty[i]);
					return;
				}
			 }
			 
			 
				String sql = "update menu set quantity=(quantity - ?) where fid=?";
				for (int i = 0; i < fid.length; i++) {
					PreparedStatement ps = con.prepareStatement(sql);
					ps.setInt(1, qty[i]);
					ps.setString(2, fid[i]);
					ps.executeUpdate();

				}
			out.println("<h3>YOUR ORDER PLACED SUCCESSFULLY</h3>");
		}catch(Exception e) {
			out.println("Error: "+e.getMessage());
		}
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		
	}

}

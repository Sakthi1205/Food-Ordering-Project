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

/**
 * Servlet implementation class addtocarts
 */
@WebServlet("/addtocarts")
public class addtocarts extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addtocarts() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("text/html");
    PrintWriter o = response.getWriter();

    String[] fids = request.getParameterValues("fid");
    String[] qtys = request.getParameterValues("qty");

    o.println("<table border='1'>");
    o.println("<tr><th>ID</th><th>Food Name</th><th>Price</th><th>Quantity</th></tr>");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/food_order_project", "root", "root@39");

        PreparedStatement ps =
                con.prepareStatement("SELECT * FROM menu WHERE fid = ?");
        int tp=0;

        for (int i = 0; i < fids.length; i++) {
            ps.setInt(1, Integer.parseInt(fids[i]));
           int qty = Integer.parseInt(qtys[i]);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                o.println("<tr>");
                o.println("<td>" + fids[i] + "</td>");
                o.println("<td>" + rs.getString("f_item_name") + "</td>");
                o.println("<td>" + (rs.getInt("price")*qty) + "</td>");
                o.println("<td>" + qtys[i] + "</td>");
                o.println("</tr>");
                tp+=(rs.getInt("price")*qty);
            }
           
            rs.close();
        }
        o.println("<h3>TOTAL PRICE:"+tp+"</h3>");
        o.println("</table>");
        con.close();

    } catch (Exception e) {
        o.println("Error: " + e.getMessage());
    }
}


}

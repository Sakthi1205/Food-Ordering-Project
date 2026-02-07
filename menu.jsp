<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ page import= "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script>
function setQty(cb, qty) {
    var qty = document.getElementById(qty);

    if (cb.checked) {
        qty.value = 1;
        qty.disabled = false;
    } else {
        qty.value = 0;
        qty.disabled = true;
    }
}
</script>
<title>FOOD MENU</title>
</head>
<body>
<%Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
		"jdbc:mysql://localhost:3306/food_order_project",
		"root",
		"root@39"
		);
Statement stmt=con.createStatement();
ResultSet rs=stmt.executeQuery("Select * from menu ");
%>
<h2>Menu List</h2>
<form action="addtocarts" method="post">
<table border='1'>
<tr><th>ID</th><th>Food Name</th><th>Price</th><th>Quantity</th></tr>
<%
int i=0;
while(rs.next())
{ 
	%>
	<tr>
	<td> <input type="checkbox" name='fid' value="<%= rs.getInt("fid") %>" onclick="setQty(this,'qty<%=i%>')"><%= rs.getInt("fid") %></td>
	<td> <%= rs.getString("f_item_name") %></td>
	<td> <%= rs.getDouble("price") %></td>
	<td><input type="number" id="qty<%=i%>" name="qty" value="0" min="1" disabled></td>
	</tr>
	<% 
	i++;
}
 %>
 <br><br>
 </table>
 <input type="Submit" value="Add to Cart">
 </form>
</body>
</html>
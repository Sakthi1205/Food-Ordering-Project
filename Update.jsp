<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin - Menu Management</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: linear-gradient(to right, #1e3c72, #2a5298);
    margin: 0;
    padding: 40px;
}

h2 {
    text-align: center;
    color: white;
    margin-bottom: 30px;
}

.container {
    background: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.3);
    max-width: 1000px;
    margin: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th {
    background-color: #2a5298;
    color: white;
    padding: 12px;
}

td {
    padding: 10px;
    text-align: center;
}

tr:nth-child(even) {
    background-color: #f2f2f2;
}

tr:hover {
    background-color: #e6f0ff;
}

input[type="number"] {
    width: 70px;
    padding: 5px;
    border-radius: 5px;
    border: 1px solid #ccc;
}

button {
    padding: 6px 12px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: 0.3s;
}

button[value="edit"] {
    background-color: #28a745;
    color: white;
}

button[value="edit"]:hover {
    background-color: #218838;
}

button[value="delete"] {
    background-color: #dc3545;
    color: white;
}

button[value="delete"]:hover {
    background-color: #c82333;
}

.add-btn {
    display: block;
    margin: 20px auto;
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    font-size: 16px;
}

.add-btn:hover {
    background-color: #0056b3;
}

.back-link {
    text-align: center;
    display: block;
    margin-top: 20px;
    color: #2a5298;
    font-weight: bold;
    text-decoration: none;
}

.back-link:hover {
    text-decoration: underline;
}
</style>

</head>
<body>

<%
Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/food_order_project",
"root",
"root@39"
);

String action = request.getParameter("action");

if("edit".equals(action)) {
    int fid = Integer.parseInt(request.getParameter("fid"));
    String f_item_name = request.getParameter("f_item_name");
    Double price = Double.parseDouble(request.getParameter("price"));
    int quantity = Integer.parseInt(request.getParameter("quantity"));

    String sql = "update menu set f_item_name=?,price=?,quantity=? where fid=?";
    PreparedStatement ps = con.prepareStatement(sql);
    ps.setString(1, f_item_name);
    ps.setDouble(2, price);
    ps.setInt(3, quantity);
    ps.setInt(4, fid);
    ps.executeUpdate();

} else if("delete".equals(action)) {
    int fid = Integer.parseInt(request.getParameter("fid"));
    String sql = "delete from menu where fid=?";
    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1,fid);
    ps.executeUpdate();

} else if("add".equals(action)) {
    String name = request.getParameter("fname");
    double price = Double.parseDouble(request.getParameter("fprice"));
    int quantity = Integer.parseInt(request.getParameter("fquantity"));

    String sql = "insert into menu(f_item_name, price, quantity) values(?,?,?)";
    PreparedStatement ps = con.prepareStatement(sql);
    ps.setString(1, name);
    ps.setDouble(2, price);
    ps.setInt(3, quantity);
    ps.executeUpdate();
}
%>

<h2>🍽 Admin - Menu Management</h2>

<div class="container">

<table>
<tr>
<th>ID</th>
<th>Food Name</th>
<th>Price</th>
<th>Quantity</th>
<th>Delete</th>
</tr>

<%
Statement stmt=con.createStatement();
ResultSet rs=stmt.executeQuery("Select * from menu");

while(rs.next()) {
%>

<tr>
<td><%= rs.getInt("fid") %></td>
<td><%= rs.getString("f_item_name") %></td>
<td>₹ <%= rs.getDouble("price") %></td>

<td>
<form action="Update.jsp" method="post">
<input type="hidden" name="fid" value="<%= rs.getInt("fid") %>">
<input type="hidden" name="f_item_name" value="<%= rs.getString("f_item_name") %>">
<input type="hidden" name="price" value="<%= rs.getDouble("price") %>">
<input type="number" name="quantity" value="<%= rs.getInt("quantity") %>">
<button type="submit" name="action" value="edit">Update</button>
</form>
</td>

<td>
<form action="Update.jsp" method="post" style="display:inline;">
<input type="hidden" name="fid" value="<%= rs.getInt("fid") %>">
<button type="submit" onclick="return confirm('Delete this item?');"
name="action" value="delete">Delete</button>
</form>
</td>
</tr>

<%
}
con.close();
%>

</table>

<form action="add.jsp">
<button type="submit" class="add-btn">Add Item</button>
</form>

<a href="view.jsp" class="back-link">⬅ Back to View</a>

</div>

</body>
</html>

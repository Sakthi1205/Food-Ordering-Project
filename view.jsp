<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Menu</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: linear-gradient(to right, #283c86, #45a247);
    margin: 0;
    padding: 40px;
}

h2 {
    text-align: center;
    color: white;
    margin-bottom: 30px;
}

.container {
    background-color: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.3);
    max-width: 900px;
    margin: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th {
    background-color: #45a247;
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
    background-color: #e6ffe6;
}

.button-group {
    text-align: center;
    margin-top: 20px;
}

input[type="submit"] {
    padding: 10px 20px;
    background-color: #283c86;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 15px;
    transition: 0.3s;
}

input[type="submit"]:hover {
    background-color: #1d2c63;
}

.back-link {
    display: inline-block;
    margin-top: 15px;
    color: #283c86;
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

Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery("Select * from menu");
%>

<h2>🍽 Menu List</h2>

<div class="container">

<table>
<tr>
<th>ID</th>
<th>Food Name</th>
<th>Price</th>
<th>Quantity</th>
</tr>

<%
while(rs.next()) {
%>

<tr>
<td><%= rs.getInt("fid") %></td>
<td><%= rs.getString("f_item_name") %></td>
<td>₹ <%= rs.getDouble("price") %></td>
<td><%= rs.getInt("quantity") %></td>
</tr>

<%
}
con.close();
%>

</table>

<div class="button-group">
    <form action="Update.jsp" style="display:inline;">
        <input type="submit" value="Update">
    </form>
    <br>
    <a href="admin2.html" class="back-link">⬅ Back</a>
</div>

</div>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FOOD MENU</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: linear-gradient(to right, #ff9966, #ff5e62);
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
    box-shadow: 0 10px 25px rgba(0,0,0,0.2);
    max-width: 900px;
    margin: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th {
    background-color: #ff5e62;
    color: white;
    padding: 10px;
}

td {
    padding: 10px;
    text-align: center;
}

tr:nth-child(even) {
    background-color: #f2f2f2;
}

tr:hover {
    background-color: #ffe6e6;
}

input[type="number"] {
    width: 60px;
    padding: 5px;
    border-radius: 5px;
    border: 1px solid #ccc;
    text-align: center;
}

input[type="checkbox"] {
    transform: scale(1.2);
    cursor: pointer;
}

input[type="submit"] {
    display: block;
    margin: 20px auto 0;
    padding: 12px 25px;
    background-color: #ff5e62;
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 16px;
    cursor: pointer;
    transition: 0.3s;
}

input[type="submit"]:hover {
    background-color: #e04848;
    transform: scale(1.05);
}
</style>

<script>
function setQty(cb, qtyId) {
    var qty = document.getElementById(qtyId);
    if (cb.checked) {
        qty.value = 1;
        qty.disabled = false;
    } else {
        qty.value = 0;
        qty.disabled = true;
    }
}
</script>
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
ResultSet rs = stmt.executeQuery("SELECT * FROM menu");
%>

<h2>🍽 FOOD MENU</h2>

<div class="container">
<form action="addtocarts" method="post">

<table border="0">
<tr>
    <th>ID</th>
    <th>Food Name</th>
    <th>Price</th>
    <th>Order Qty</th>
</tr>

<%
int i = 0;
while (rs.next()) {
    int fid = rs.getInt("fid");
    int stockQty = rs.getInt("quantity");
%>

<tr>
    <td>
        <input type="checkbox" name="fid"
            value="<%= fid %>"
            onclick="setQty(this,'qty<%=i%>')"
            <%= stockQty == 0 ? "disabled" : "" %>>
       
    </td>

    <td><%= rs.getString("f_item_name") %></td>
    <td>₹ <%= rs.getDouble("price") %></td>

    <td>
        <input type="number" id="qty<%=i%>" name="qty"
            value="0" min="1" max="<%= stockQty %>"
            disabled>
    </td>
</tr>

<%
    i++;
}
con.close();
%>

</table>

<input type="submit" value="Add to Cart">

</form>
</div>

</body>
</html>

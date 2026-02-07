<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FOOD MENU</title>

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
    "jdbc:mysql://localhost:3306/mphasis",
    "root",
    "root@39"
);

Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery("SELECT * FROM menu");

String outItemId = request.getParameter("itemId");
%>

<h2>Menu List</h2>

<form action="addtocarts" method="post">
<table border="1">
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
        <%= fid %>
    </td>

    <td><%= rs.getString("f_item_name") %></td>
    <td><%= rs.getDouble("price") %></td>



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
<br>
<input type="submit" value="Add to Cart">
</form>

</body>
</html>

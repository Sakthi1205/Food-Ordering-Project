<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Food Menu Form</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: linear-gradient(to right, #ff9966, #ff5e62);
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
}

.container {
    background-color: #ffffff;
    padding: 35px;
    border-radius: 10px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.2);
    width: 350px;
}

h2 {
    text-align: center;
    margin-bottom: 20px;
    color: #333;
}

label {
    font-weight: bold;
    display: block;
    margin-top: 10px;
}

input[type="text"] {
    width: 100%;
    padding: 8px;
    margin-top: 5px;
    border-radius: 5px;
    border: 1px solid #ccc;
    box-sizing: border-box;
}

button {
    width: 100%;
    margin-top: 20px;
    padding: 10px;
    background-color: #ff5e62;
    border: none;
    color: white;
    font-size: 16px;
    border-radius: 5px;
    cursor: pointer;
    transition: 0.3s;
}

button:hover {
    background-color: #e04848;
}
</style>

</head>
<body>

<div class="container">
    <h2>Add Food Item</h2>
    <form action="Update.jsp">
        <label>Enter Food Name:</label>
        <input type="text" name="fname" required>

        <label>Enter Food Price:</label>
        <input type="text" name="fprice" required>

        <label>Enter Food Quantity:</label>
        <input type="text" name="fquantity" required>

        <button type="submit" value="add" name="action">Add to Menu</button>
    </form>
</div>

</body>
</html>

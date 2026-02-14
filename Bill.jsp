<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Orders by Table</title>
  <style>
    /* Reset and base */
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f8; margin: 0; padding: 20px; color: #1f2937; }
    h2 { text-align: center; margin-bottom: 30px; color: #0f172a; }
    h3 { margin: 24px 0 12px; color: #0ea5e9; }
    
    /* Messages */
    .msg { padding: 12px 16px; border-radius: 6px; margin-bottom: 16px; font-weight: 500; }
    .msg.ok { background: #e6ffed; border: 1px solid #34c759; color: #065f46; }
    .msg.err { background: #ffecec; border: 1px solid #ff5b5b; color: #b91c1c; }
    
    /* Table */
    table { border-collapse: collapse; width: 100%; margin-bottom: 24px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); background: #fff; }
    th, td { border: 1px solid #d1d5db; padding: 10px 14px; text-align: left; }
    thead { background: #0ea5e9; color: #fff; }
    tbody tr:nth-child(even) { background: #f9fafb; }
    tbody tr:hover { background: #e0f2fe; }

    /* Buttons */
    form.inline { display: inline-block; margin: 4px 0 12px; }
    button { padding: 8px 14px; cursor: pointer; border: none; border-radius: 6px; font-weight: 600; background: #0ea5e9; color: #fff; transition: background 0.3s; }
    button:hover { background: #0284c7; }

    /* Back link */
    .back-link { display: inline-block; margin-top: 20px; padding: 8px 14px; background: #f8fafc; color: #0f172a; border: 1px solid #d1d5db; border-radius: 6px; text-decoration: none; transition: background 0.3s; }
    .back-link:hover { background: #e2e8f0; }
  </style>
</head>
<body>

<h2>Orders Grouped by Table</h2>

<%
    // --- DB config ---
    String url  = "jdbc:mysql://localhost:3306/food_order_project";
    String user = "root";
    String pass = "root@39";

    String message = null;
    String error   = null;

    // --- Handle Generate Bill action (POST) ---
    try {
        request.setCharacterEncoding("UTF-8");
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String action = request.getParameter("action");
            if ("generateBill".equals(action)) {
                String tableIdParam = request.getParameter("table_id");
                if (tableIdParam == null || tableIdParam.isEmpty()) {
                    error = "Missing table_id";
                } else {
                    int tableId = Integer.parseInt(tableIdParam);
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    try (Connection con = DriverManager.getConnection(url, user, pass);
                         PreparedStatement del = con.prepareStatement(
                             "DELETE FROM order_details WHERE table_id = ?")) {
                        del.setInt(1, tableId);
                        int deleted = del.executeUpdate();
                        message = "Bill generated successfully for Table " + tableId +
                                  ". Items removed: " + deleted + ".";
                    }
                }
            }
        }
    } catch (Exception e) {
        error = "Error generating bill: " + e.getMessage();
    }

    if (message != null) {
%>
    <div class="msg ok"><%= message %></div>
<%
    }
    if (error != null) {
%>
    <div class="msg err"><%= error %></div>
<%
    }
%>

<%
    // --- List remaining orders grouped by table_id ---
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, user, pass);

        String sql = "SELECT table_id, order_id, item_name, quantity, price " +
                     "FROM order_details ORDER BY table_id, order_id";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();

        Integer currentTable = null;
        boolean openTable = false;
        boolean anyRows = false;

        while (rs.next()) {
            anyRows = true;
            int tableId   = rs.getInt("table_id");
            int orderId   = rs.getInt("order_id");
            String item   = rs.getString("item_name");
            int qty       = rs.getInt("quantity");
            BigDecimal price = rs.getBigDecimal("price");

            if (currentTable == null || tableId != currentTable) {
                if (openTable) {
%>
      </tbody>
    </table>
<%
                }
                currentTable = tableId;
                openTable = true;
%>
    <h3>Table <%= currentTable %></h3>

    <form method="post" class="inline"
          onsubmit="return confirm('Generate bill for Table <%= currentTable %>? This will clear its orders.');">
      <input type="hidden" name="action" value="generateBill" />
      <input type="hidden" name="table_id" value="<%= currentTable %>" />
      <button type="submit">Generate Bill</button>
    </form>

    <table>
      <thead>
        <tr>
          <th>Order ID</th>
          <th>Item Name</th>
          <th>Quantity</th>
          <th>Price</th>
        </tr>
      </thead>
      <tbody>
<%
            } // end new-table header
%>
        <tr>
          <td><%= orderId %></td>
          <td><%= item %></td>
          <td><%= qty %></td>
          <td>₹ <%= price %></td>
        </tr>
<%
        } // end while

        if (openTable) {
%>
      </tbody>
    </table>
<%
        }

        if (!anyRows) {
%>
    <p class="msg ok">No orders found.</p>
<%
        }

    } catch (Exception e) {
%>
    <p class="msg err">Error loading orders: <%= e.getMessage() %></p>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        if (ps != null) try { ps.close(); } catch (Exception ignore) {}
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
%>

<a class="back-link" href="admin2.html">Back</a>

</body>
</html>

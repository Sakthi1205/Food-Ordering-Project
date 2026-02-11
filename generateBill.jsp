<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Orders by Table</title>
  <style>
    body { font-family: Arial, sans-serif; }
    .msg { padding: 10px; border-radius: 4px; margin-bottom: 16px; }
    .msg.ok { background: #e6ffed; border: 1px solid #34c759; color: #0b5; }
    .msg.err { background: #ffecec; border: 1px solid #ff5b5b; color: #d00; }
    h2 { margin-top: 0; }
    h3 { margin: 18px 0 8px; }
    table { border-collapse: collapse; width: 100%; margin-bottom: 24px; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    thead { background: #f5f5f5; }
    form.inline { display: inline-block; margin: 4px 0 12px; }
    button { padding: 6px 12px; cursor: pointer; }
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
                // Close previous table block
                if (openTable) {
%>
      </tbody>
    </table>
<%
                }
                // New table block
                currentTable = tableId;
                openTable = true;
%>
    <h3>Table <%= currentTable %></h3>

    <!-- Generate Bill button for this table -->
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

            // Row
%>
        <tr>
          <td><%= orderId %></td>
          <td><%= item %></td>
          <td><%= qty %></td>
          <td><%= price %></td>
        </tr>
<%
        } // end while

        // Close last opened table
        if (openTable) {
%>
      </tbody>
    </table>
<%
        }

        if (!anyRows) {
%>
    <p>No orders found.</p>
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

</body>
</html>

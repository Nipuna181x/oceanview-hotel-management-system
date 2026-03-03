<%@ page import="java.sql.Connection" %>
<%@ page import="com.oceanview.hotel.dao.DBConnectionFactory" %>

<html>
<body>
<h2>Database Connection Test</h2>

<%
    try {
        Connection conn = DBConnectionFactory.getConnection();
        out.println("<h3 style='color:green'>Database Connected Successfully ✅</h3>");
        conn.close();
    } catch (Exception e) {
        out.println("<h3 style='color:red'>Connection Failed ❌</h3>");
        out.println("<pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    }
%>

</body>
</html>
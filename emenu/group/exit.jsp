<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ColorRing" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>User exit</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    if (operID != null) {
        session.invalidate();
        sysTime = SocketPortocol.getSysTime() + "--";
        // Ç©ÍË
        try {
            zxyw50.Purview purview = new zxyw50.Purview();
            ColorRing colorRing = new ColorRing();
            purview.signOut(operID,colorRing.getSerkey());
        }
        catch (Exception e) {
        }
        sysInfo.add(sysTime + operName + " exit the system!");
%>
<table border="0" align="center" height="100%" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td align="center">Exit system!</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<%
    }
%>
<script language="javascript">
   window.close();
</script>
</body>
</html>

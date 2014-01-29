<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Operator Management</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<script language="javascript">
   function refresh () {
      document.view.submit();
   }
</script>
</head>
<body class="body-style1">
<%
    try {
        String operID = request.getParameter("operID") == null ? "" : (String)request.getParameter("operID");
        ArrayList list = new ArrayList();
        HashMap map = new HashMap();
        if (operID.length() > 0)
            list = purview.getRights(operID);
%>
<form name="view" method="post" action="operGroupList.jsp">
<input type="hidden" name="operID" value="">
<table border="0" width="100%" class="text-default">
  <tr>
    <td width="100%">Available operator groups</td>
  </tr>
  <tr>
    <td>
      <table border="1" width="100%" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
        <tr class="table-title1">
          <td width="50%" height="24">Operator group name</td>
          <td width="50%" height="24">Management system</td>
        </tr>
<%
        for (int i = 0; i < list.size(); i++) {
            map = (HashMap)list.get(i);
%>
        <tr bgcolor="#FFFFFF">
          <td height="22"><%= (String)map.get("GRPSCRIPT") %>&nbsp;</td>
          <td height="22"><%= (String)map.get("DESCRIPTION") %>&nbsp;</td>
        </tr>
<%
        }
%>
      </table>
    </td>
  </tr>
</table>
</form>
<%
        if (operID.length() > 0) {
%>
<script language="javascript">
   //parent.currentFrame.document.view.operID.value = '<%= operID %>';
   //parent.currentFrame.refresh();
</script>
<%
        }
    }
    catch (Exception e) {
%>
<table border="1" width="100%" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
  <tr>
    <td colspan="2">Error:<%= e.toString() %></td>
  </tr>
</table>
<%
    }
%>
</body>
<html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%
    try {
        String operID = (String)request.getParameter("operID");
        HashMap map = purview.getOperInformation(operID);
        String opertype = (String)request.getParameter("operType");
        String pid = (String)request.getParameter("pid");
%>
<html>
<head>
<title>Delete operator</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<script language="javascript">
   // 关闭前向父窗口回写关闭标志
   function unLoad () {
      window.opener.focus();
   }

   // 页面提交
   function onSubmit () {
      document.view.submit();
   }
</script>
</head>
<body class="body-style1" onunload="javascript:unLoad()">
<form name="view" method="post" action="operDelEnd.jsp">
<input type="hidden" name="operID" value="<%= operID %>">
<input type="hidden" name="operType" value="<%= opertype %>">
<input type="hidden" name="pid" value="<%= pid %>">

<table border="1" width="300" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
  <tr>
    <td width="33%" height="22" align="right" class="table-title">Operator name:</td>
    <td height="22" widht="67%"><%= (String)map.get("OPERNAME") %>&nbsp;</td>
  </tr>
  <tr>
    <td width="33%" height="22" align="right" class="table-title">Full name:</td>
    <td height="22" widht="67%"><%= (String)map.get("OPERALLNAME") %>&nbsp;</td>
  </tr>
  <tr>
    <td width="33%" height="22" align="right" class="table-title">Description:</td>
    <td height="22" widht="67%"><%= (String)map.get("OPERDESCRIPTION") %>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2">
      <table width="100%" border="0" class="table-style5">
        <tr align="center">
          <td height="22"><input type="button" name="sure" value="OK" class="button-style1" onclick="javascript:onSubmit()"></td>
          <td height="22"><input type="button" name="quit" value="Cancel" class="button-style1" onclick="window.close()"></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
</body>
</html>
<%
    }
    catch (Exception e) {
%>
<html>
<body>
<table border="1" width="100%" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style1">
  <tr>
    <td colspan="2">Error:<%= e.toString() %></td>
  </tr>
</table>
</body>
</html>
<%
    }
%>

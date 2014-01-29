<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<html>
<head>
<title>Operator log</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<script language="javascript">
   // 双击指定用户的时候发生的动作
   function viewOper (operID,operName) {
      parent.logFrame.document.view.operID.value = operID;
      parent.logFrame.document.view.operName.value = operName;
   }
</script>
</head>
<body class="body-style1">
<%
    try {
        String operID = (String)session.getAttribute("OPERID");
        ArrayList list = new ArrayList();
        HashMap map = new HashMap();
        if (operID != null)
            list = purview.sortChildOperators(operID);
        if (list == null)
            list = new ArrayList();
%>
<table border="1" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
  <tr class="table-title1">
    <td width="90" height="24">Login name</td>
  </tr>
<%
        for (int i = 0; i < list.size(); i++) {
            map = (HashMap)list.get(i);
%>
  <tr ondblclick="javascript:viewOper('<%= (String)map.get("OPERID")%>','<%= (String)map.get("OPERNAME") %>')">
    <td height="22"><%= (String)map.get("OPERNAME") %>&nbsp;</td>
  </tr>
<%
        }
%>
</table>
<%
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
</table>
</body>
</html>

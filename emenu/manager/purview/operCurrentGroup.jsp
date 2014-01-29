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
</head>
<body class="body-style1">
<%
    try {
        String operID = request.getParameter("operID") == null ? "" : (String)request.getParameter("operID");
        String selfID = (String)session.getAttribute("OPERID");
        String serviceKey = request.getParameter("serviceKey") == null ? "" : (String)request.getParameter("serviceKey");
        ArrayList list = new ArrayList();
        HashMap map = new HashMap();
        if (serviceKey.length() > 0 && (! operID.equals(selfID)))
            purview.signOut(operID,serviceKey);
        if (operID.length() > 0)
            list = purview.getOnlineByID(operID);
%>
<script language="javascript">
   function refresh () {
      document.view.submit();
   }

   function viewOnline (serviceKey,serviceName) {
      if (parent.buttonFrame.checkWin() == 'no') {
         parent.buttonFrame.document.view.serviceKey.value = serviceKey;
         parent.buttonFrame.document.view.serviceName.value = serviceName;
         parent.buttonFrame.document.view.signOut.disabled = false;
      }
   }
</script>
<form name="view" method="post" action="operCurrentGroup.jsp">
<input type="hidden" name="operID" value="">
<input type="hidden" name="serviceKey" value="">
<table border="0" width="100%" class="text-default">
  <tr>
    <td width="100%">Management system being logged</td>
  </tr>
  <tr>
    <td>
      <table border="1" width="100%" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
        <tr class="table-title1">
          <td width="100%" height="24">Management system</td>
        </tr>
<%
        for (int i = 0; i < list.size(); i++) {
            map = (HashMap)list.get(i);
%>
        <tr ondblclick="javascript:viewOnline('<%= (String)map.get("SERVICEKEY") %>','<%= (String)map.get("DESCRIPTION") %>')">
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

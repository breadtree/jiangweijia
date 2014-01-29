<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@page import="zxyw50.CrbtUtil"%>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Exit</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    try {
        String sysTime = "";
        Vector sysInfo = (Vector)application.getAttribute("SYSINFO");      
        String operID = (String)session.getAttribute("OPERID");
        String operName = (String)session.getAttribute("OPERNAME");
        if (operID != null) {
            session.invalidate();
            // 签退
            try {
                zxyw50.Purview purview = new zxyw50.Purview();
                purview.signOut(operID,"pstn51");
            }
            catch (Exception e) {
            }
            sysTime = CrbtUtil.getSysTime() + "--";
            sysInfo.add(sysTime + operName + "Exit the system!");//退出系统
			// 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","102");
            map.put("RESULT","1");
            map.put("PARA1","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION","SP Management System");
            purview.writeLog(map);
%>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<table border="0" align="center" height="400" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td align="center">You have exited the system!</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<%
        }
    }
    catch (Exception e) {
    }
%>
<script language="javascript">
   parent.document.URL = 'index.jsp';

</script>
</body>
</html>

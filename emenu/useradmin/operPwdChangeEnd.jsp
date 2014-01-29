<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page language="java" contentType="text/html;charset=ISO8859_1" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.Purview" scope="page" />
<jsp:setProperty name="db" property="*" />

<html>
<head>
<title>Change password</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    HashMap map = null;
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
		ColorRing colorRing = new ColorRing();
        if (operID != null) {
            String oldpwd = (String)request.getParameter("oldcardpass");
            String newpwd = (String)request.getParameter("newcardpass");

            map = new HashMap();
            map.put("operid",operID);
            map.put("opername",operName);
            map.put("oldpass",oldpwd);
            map.put("newpass",newpwd);
			db.editOperPassword(map);
            sysInfo.add(sysTime +operName+ " change password successfully!");


			// 准备写操作员日志
            if(map.size()>0)
                  map.clear();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("HOSTNAME",request.getRemoteAddr());
            map.put("SERVICEKEY",colorRing.getSerkey());
            map.put("OPERTYPE","1");
            map.put("RESULT","1");
            map.put("DESCRIPTION",operName + " change password");
            db.writeLog(map);
%>
<script language="javascript">
   alert("Change password successfully!");
   document.URL = 'operPwdChange.jsp';
</script>
<%
        }
        else {
%>
<script language="javascript">
   alert("Please log in first!");
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in changing password!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + " errors occurred in changing password!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="operPwdChange.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

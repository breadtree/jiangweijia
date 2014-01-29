<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ColorRing" %>


<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />

<html>
<head>
<title>Modify password</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
     Hashtable hash = null;
    String spIndex = (String)session.getAttribute("SPINDEX");
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
		ColorRing colorRing = new ColorRing();
        if (operID != null) {
            String oldpwd = (String)request.getParameter("oldcardpass");
            String newpwd = (String)request.getParameter("newcardpass");
			hash = new Hashtable();
            hash.put("operid",operID);
            hash.put("opername",operName);
            hash.put("oldpass",oldpwd);
            hash.put("newpass",newpwd);
			db.editSpPassword(hash);
            sysInfo.add(sysTime +operName+ "Succeeded in modifying password!");
			// 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("HOSTNAME",request.getRemoteAddr());
            map.put("SERVICEKEY",colorRing.getSerkey());
            map.put("OPERTYPE","1");
            map.put("RESULT","1");
            map.put("PARA1","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION",operName + " modify passwod");
            purview.writeLog(map);
%>
<script language="javascript">
   alert('Succeeded in modifying password!');
   document.URL = 'changePassword.jsp';
</script>
<%
        }

    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Error occurs in the password modification");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + " error occurs in the password modification!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="changePassword.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

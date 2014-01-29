<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.Manager" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<jsp:useBean id="Purview" class="zxyw50.Purview" scope="page" />
<%@ page language="java" contentType="text/html;charset=ISO8859_1" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="com.zte.zxywpub.login" scope="page" />
<html>
<head>
<title>Log in</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<body  class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operName = request.getParameter("opername") == null ? "" : transferString((String)request.getParameter("opername").trim());
    String serviceKey = request.getParameter("servicekey") == null ? "" : ((String)request.getParameter("servicekey")).trim();
    try {
        String password = request.getParameter("password") == null ? "" : (String)request.getParameter("password");
        Manager manage = new Manager();
	    sysTime = manage.getSysTime() + "--";
        if (db.checkOper(operName,request)) {
   	    String operID = db.getoperid() + "";
            session.setAttribute("OPERNAME",operName);
            session.setAttribute("SERVICEKEY",serviceKey);
            session.setAttribute("OPERID",operID);
             session.setAttribute("PURVIEW",manage.getPurview(operID));
            // 记录系统日志
            sysInfo.add(sysTime + operName + " log in system");
			// 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","101");
            map.put("RESULT","1");
            map.put("DESCRIPTION"," system");
            purview.writeLog(map);

%>
<form name="loginForm" method="post" action="../intro.html">
</form>
<script language="javascript">
   parent.document.URL = 'index.jsp';
</script>
<%
        }
        else {
        int ErrorCode = db.geterrorCode();
	    String strMsg =  db.getStrmsg(ErrorCode);
%>
<script language="javascript">
   var str = "<%= strMsg  %>";
   alert("Log in system failure\n"+str);
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in loging in system!");
        sysInfo.add(e.toString());
        vet.add(operName + "Errors occurred in loging in system!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="enter.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

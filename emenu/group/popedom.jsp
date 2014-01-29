<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Automatic authentication</title>
<meta http-equiv="refresh" content="60" url="popedom.jsp">
</head>
<body>
<%
    
    String operID = (String)session.getAttribute("OPERID");
    boolean flag = true;
    try {
        if (operID != null) {
            String operName = (String)session.getAttribute("OPERNAME");
            Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
            String sysTime = SocketPortocol.getSysTime() + "--";
            ColorRing colorRing = new ColorRing();
            Purview purview = new Purview();
            flag = purview.isOnLine(operID,colorRing.getSerkey());
            if (! flag) {
                session.invalidate();
                sysInfo.add(sysTime + operName + "The authentication fails by other operators!");
                sysInfo.add(sysTime + operName + "Exit the system!");
            }
        }
    }
    catch (Exception e) {
    }
    if (! flag) {
%>
<script language="javascript">
   alert('Your authentication fails!');
   parent.document.URL = 'index.jsp';
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Automatic authorization</title>
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
            String sysTime = zxyw50.CrbtUtil.getSysTime() + "--";          
            Purview purview = new Purview();
            flag = purview.isOnLine(operID,"pstn51");
            if (! flag) {
  
            	 Thread.sleep(5*1000);
            	 flag = purview.isOnLine(operID,"pstn51");
            	 if(! flag)
            	 {
                  session.invalidate();
                  sysInfo.add(sysTime + operName + "Signed out of the system by any other operators!");//已经被其他操作员从系统签退
                  sysInfo.add(sysTime + operName + "Exit the system!");//退出系统
                }
          }
      }
    }
    catch (Exception e) {
    }
    if (! flag) {
%>
<script language="javascript">
   alert('You have been signed out forcedly!');//您已经被强行签退
   parent.document.URL = 'index.jsp';
</script>
<%
    }
%>
</body>
</html>

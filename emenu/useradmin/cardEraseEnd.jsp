<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.manUser" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page language="java" contentType="text/html;charset=ISO8859_1" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Log out</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String craccount = "";
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null && purviewList.get("14-2") != null) {
            String oldpwd = "";
            craccount = (String)request.getParameter("craccount");
            manUser mag = new manUser();
            mag.checkPrefix(craccount);
            mag.delCard(craccount,operName,request.getRemoteAddr());
            sysInfo.add(sysTime +operName+ " log out "+craccount +" successfully!");

            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","3001");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            purview.writeLog(map);
%>
<script language="javascript">
   var str = "Log out"+"<%= craccount %>"+" successfully!";
   alert(str);
   document.URL = 'cardErase.jsp';
</script>
<%
        }
        else {
         if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in first!");
                    document.URL = 'enter.jsp';
              </script>
          <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "Sorry,you have no right to access this function!");
              </script>
            <%

           }

        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in logging out " + craccount);
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(operName + " errors occurred in logging out " + craccount);
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="cardErase.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

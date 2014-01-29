<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.manUser" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Password modification</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String craccount = "";
    String isSmart = CrbtUtil.getConfig("isSmart", "0");
    try {

        if (operID != null) {
            String oldpwd = "";
            craccount = (String)request.getParameter("craccount");
            zxyw50.Purview purview = new zxyw50.Purview();
            if(!purview.CheckOperatorRight(session,"1-1",craccount)){
               throw new Exception("You have no permission to operate!");
            }
            String newpwd = (String)request.getParameter("newcardpass");
            manUser manuser = new manUser();
            sysTime = manuser.getSysTime() + "--";
            manuser.changeCardPass(craccount,newpwd);
            sysInfo.add(sysTime + craccount + " Password modified successfully!");//修改密码成功
            if(isSmart.equals("1"))
             {
            manuser.addRingLog(craccount,"","0","0","52","11",operName,"");
              }
            // 准备写操作员日志
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","105");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
%>
<script language="javascript">
   alert('Password modified successfully!');//密码修改成功
   document.URL = 'changePassword.jsp';
</script>

<%
        }
        else {
%>
<script language="javascript">
   alert('Please log in to the system first!');//Please log in to the system first!
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount + " Error occurred in modifying the password!");//修改用户密码过程出现错误
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(craccount + " Error occurred in modifying the password!");//修改用户密码过程出现错误
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

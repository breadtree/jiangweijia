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
<title>PHS open an account</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String craccount = "";
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
        Hashtable hash = new Hashtable();
        if (operID != null && purviewList.get("14-1") != null) {
            String oldpwd = "";
            craccount = (String)request.getParameter("craccount");
            String inflag = request.getParameter("inflag") == null ? "0" : ((String)request.getParameter("inflag")).trim();
            String serkey = request.getParameter("serkey") == null ? "0" : ((String)request.getParameter("serkey")).trim();
            String scpgt = request.getParameter("scpgt") == null ? "" : ((String)request.getParameter("scpgt")).trim();
            String newpwd = (String)request.getParameter("newcardpass");
            String restInt = (String)request.getParameter("restInt")==null?"0":(String)request.getParameter("restInt").trim();
            manUser manuser = new manUser();
            hash.put("usernumber",craccount);
            hash.put("inflag",inflag);
            hash.put("serkey",serkey);
            hash.put("scpgt",scpgt);
            hash.put("cardpass",newpwd);
            hash.put("restint",restInt);
            hash.put("operator",operName);
	        hash.put("ipaddr",request.getRemoteAddr());
            manuser.checkPrefix(craccount);
            manuser.changeCardUse(hash);
            sysInfo.add(sysTime +" manager of "+ operName +" open an account of "+ craccount + " successfully!");

            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","3000");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            purview.writeLog(map);
%>
<script language="javascript">
   var str = "<%= craccount %>"+" open an account successfully!"
   alert(str);
   document.URL = 'cardUse.jsp';
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
        sysInfo.add(sysTime + craccount + " Exception occurred in opening an account!");
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(craccount + " errors occurred in opening an account!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="cardUse.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.manUser" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@page import="zxyw50.userAdm"%>
<%@ page import="zte.zxyw50.CRBTContext" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Account Cancellation</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String craccount = "";
    String userringtype="0";
    String  reason = "Manager Cancellation";
	String isimp = CrbtUtil.getConfig("isimp","1");
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null && purviewList.get("1-5") != null) {
            String oldpwd = "";
            craccount = (String)request.getParameter("craccount");
           userringtype =  (String)request.getParameter("userringtype");
            zxyw50.Purview purview = new zxyw50.Purview();
            if(!purview.CheckOperatorRight(session,"1-5",craccount)){
               throw new Exception("You have no permission to operate!");
            }
			Hashtable hash = null;
			Hashtable result= new Hashtable();
			 if("1".equals(isimp)){
				 hash = new Hashtable();
              hash.put("opcode","01010102");
              hash.put("userringtype",userringtype);
              hash.put("craccount",craccount);
              hash.put("passwd","");
              hash.put("opmode","b");
              hash.put("ipaddr",operName);
              hash.put("reason",reason);
			  hash.put("servicetype","1");
				 SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
				 result = SocketPortocol.send(pool,hash);
			 }
			 else
			 {
				 hash = new Hashtable();
				 hash.put("userringtype",userringtype);
				 hash.put("craccount",craccount);
				 hash.put("opmode","11");
				 manUser manuser = new manUser();
				 manuser.changeCardErase(hash);
			 }

            sysInfo.add(sysTime +operName+ " Account Cancellation "+craccount +"success!");
            // 准备写操作员日志
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","104");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
            
            String message = "";
            /*
            userAdm adm = new userAdm();
            boolean flag = adm.judgeUserType(craccount);            
            
            if(flag == false)
            {
            	message = " CRBT";
            }else if(flag == true)
            {
            	message = " MRBT";
            }else
            {
            	message = "";
            }
            */
%>
<script language="javascript">
   var str = "<%= craccount %>" + "<%=message%>" +" Account Cancellation successfully!"; //销户成功!
   alert(str);
   document.URL = 'cardErase.jsp';
</script>
<%
        }
        else {
         if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
              </script>
          <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//You have no access to this function!
              </script>
            <%

           }

        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Error occurred in cancelling the account " + craccount +" !");//销户  过程出现错误
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(operName + " Error occurred in cancelling the account " + craccount +" !");//销户  过程出现错误
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

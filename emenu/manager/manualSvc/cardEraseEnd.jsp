<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Account Cancellation</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>
<body class="body-style1">
<%
    String userringtype = request.getParameter("userringtype") == null ? "" : request.getParameter("userringtype");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String craccount = "";
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        craccount = request.getParameter("craccount") == null ? "" : request.getParameter("craccount");
        String  passwd = "";
        String  reason = "Account cancellation via Manual Operator Position.";//人工台销户
        if (operID != null && purviewList.get("13-2") != null) {
          manSysPara msp = new manSysPara();
            if(!msp.isAdUser(craccount)){
            manUser manuser = new manUser();
//            String type  = manuser.getUserCardinfo(craccount);
//            if(type == null)
//               throw new Exception("The subscriber does not exist!");

 	    zxyw50.Purview purview = new zxyw50.Purview();
            if(!purview.CheckOperatorRight(session,"13-2",craccount)){
            	throw new Exception("You have no right to manage this subsciber!");
            }

//            if("".equals(type)){
              Hashtable hash = new Hashtable();
              hash.put("opcode","01010102");
              hash.put("userringtype",userringtype);
              hash.put("craccount",craccount);
              hash.put("passwd",passwd);
              hash.put("opmode","6");
              hash.put("ipaddr",operName);
              hash.put("reason",reason);
              Hashtable result = SocketPortocol.send(pool,hash);
//            }else if("127".equals(type)){
//              SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
//              Hashtable hash = new Hashtable();
//              hash.put("opcode","01010102");
//
//              hash.put("userringtype",userringtype);
//
//              hash.put("craccount",craccount);
//              hash.put("passwd",passwd);
//              hash.put("opmode","6");
//              hash.put("ipaddr",operName);
//              hash.put("reason",reason);
//              Hashtable result = SocketPortocol.send(pool,hash);
//            }else{
//              ManGroup mangroup = new ManGroup();
//              Hashtable hash = new Hashtable();
//              hash.put("usernumber",craccount);
//              hash.put("operator",operName);
//              hash.put("ipaddr",request.getRemoteAddr());
//              mangroup.delGrpUser(hash);
//            }

//
//            Hashtable hash = new Hashtable();
//            hash.put("opcode","01010102");
//            hash.put("craccount",craccount);
//            hash.put("passwd",passwd);
//            hash.put("opmode","6");
//            hash.put("ipaddr",operName);
//            hash.put("reason",reason);
//            Hashtable result = SocketPortocol.send(pool,hash);
            sysInfo.add(sysTime +operName+ ",Account "+craccount +" cancellation via Manual Operator Position successful!");

            // 准备写操作员日志
          //  zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","502");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2","ip:"+request.getRemoteAddr());
            purview.writeLog(map);

%>
<script language="javascript">
   var str = "'<%= craccount %>' Account Cancellation successfully!"//销户成功!
   alert(str);
   document.URL = 'cardErase.jsp';
</script>
<%
           }else{
%>
             <script language="javascript">
                   var str = 'Sorry,the number '+<%= craccount %>+' you entered is ad subscriber,can not use the system!';
                   alert(str);
                   document.URL = 'cardErase.jsp';
             </script>
<%
           }
        }
        else {
         if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = '../enter.jsp';
              </script>
          <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
            <%

           }

        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ",An error occurred during the account " + craccount +" cancellation via Manual Operator Position!");//人工台销户  过程出现错误
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(operName + ",An error occurred during the account " + craccount +" cancellation via Manual Operator Position!");//人工台销户  过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/cardErase.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

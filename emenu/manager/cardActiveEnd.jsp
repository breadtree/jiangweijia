<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.manUser" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="zxyw50.manSysRing" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Active/suspend subscriber</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ifshowforceactivate = CrbtUtil.getConfig("ifshowforceactivate","0").trim();
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String sEnablePairNumber = CrbtUtil.getConfig("isEnablePairNumber","0");
	int isEnablePairNumber=Integer.parseInt(sEnablePairNumber);

	String  craccount = "";
        String opDesc = "";
	try {

	   String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
	   craccount = request.getParameter("craccount") == null ? "" : request.getParameter("craccount");
        if(isEnablePairNumber==1 && !craccount.equals("")) {
			manSysRing sysring = new manSysRing();
			craccount=sysring.getPairUserNumber(craccount);
		}
           String userringtype = request.getParameter("userringtype") == null ? "0" : (String)request.getParameter("userringtype");
	   if (operID != null && purviewList.get("1-13") != null) {
	     String  opmode = "";
	     zxyw50.Purview purview = new zxyw50.Purview();
             if(!purview.CheckOperatorRight(session,"1-13",craccount)){
            	throw new Exception("You have no access to operate on this user!");
             }
             if(op.equals("active")){
	         opmode = request.getParameter("opmode") == null ? "1" : request.getParameter("opmode");
             if(opmode.equals("0"))
             {opDesc = "Active service";}
             else if(opmode.equals("1"))
             {opDesc = "Suspend service";}
             else if(opmode.equals("2"))
             {opDesc = "Active service forcedly";}
             else if(opmode.equals("3"))
             {opDesc = "Suspend service forcedly";}

             manUser mag = new manUser();
             mag.activeUser(craccount,userringtype,opmode);
             sysInfo.add(sysTime +operName+ opDesc + craccount +" successfully!");
             HashMap map = new HashMap();
             map.put("OPERID",operID);
             map.put("OPERNAME",operName);
             map.put("OPERTYPE","113");
             map.put("RESULT","1");
             map.put("PARA1",craccount);
             map.put("PARA2",opDesc);
             map.put("PARA3","ip:"+request.getRemoteAddr());
             purview.writeLog(map);
        %>
            <script language="javascript">
              var str = "'<%= craccount %>' subscriber <%= opDesc %> successfully!"
              alert(str);
              document.URL = 'cardActive.jsp';
            </script>
            <%
         }
         userAdm  useradm = new userAdm();
         Hashtable userInfo = new Hashtable();
         userInfo  = useradm.getUserInfo(craccount);
         int lockid = -1;
         if(userringtype.equalsIgnoreCase("0"))
         lockid = Integer.parseInt((String)userInfo.get("lockid"));
         if(userringtype.equalsIgnoreCase("1"))
         lockid = Integer.parseInt((String)userInfo.get("lockid1"));

         if(userringtype.equalsIgnoreCase("3"))
         lockid = Integer.parseInt((String)userInfo.get("lockid3"));

         String[] userStatus = {"Normal state","Suspend","Account cancellation","Forcedly deactivated","Forcedly deactivated","Unknown status"};
         if(lockid<0 || lockid>4) lockid = 5;
    %>
<script language="javascript">
   function onPause(){
       var fm = document.inputForm;
       fm.opmode.value = 1;
       fm.op.value = 'active';
       fm.submit();
   }
   function onRevert(){
       var fm = document.inputForm;
       fm.opmode.value = 0;
       fm.op.value = 'active';
       fm.submit();
   }
    function onRevertForce(){
       var fm = document.inputForm;
       fm.opmode.value = 2; // 强制激活 4.07.01U2
       fm.op.value = 'active';
       fm.submit();
   }
   function onPauseForce(){
       var fm = document.inputForm;
       fm.opmode.value = 3;
       fm.op.value = 'active'; // 强制去激活 4.07.01U2
       fm.submit();
   }
   function onBack(){
      document.location.href = "cardActive.jsp";
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="cardActiveEnd.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="opmode" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="userringtype" value="<%=userringtype%>">
<table border="0" align="center" height="400" width="400" class="table-style2" >
<tr valign="center">
<td>
      <table border="0" align="center" class="table-style2" width="100%">
        <tr >
          <td height="26" align="center" class="text-title" background="image/n-9.gif">Active/suspend subscriber</td>
        </tr>
        <tr >
          <td height="30" align="center" class="text-title" > </td>
        </tr>
        <tr>
	<td>
           <table border="1" width="80%" align=center cellspacing="0" cellpadding="0" class="table-style2" bordercolorlight="#000000" bordercolordark="#FFFFFF">
           <tr>
           <td class="table-title1" colspan=2 align=center height=26 >
                          User information
           </td>
           </tr>
           <%
            if(userInfo.size()>0){
             out.println("<tr height=23 >");
               out.println("<td width='40%' >Subscriber number:</td>");
               out.println("<td width='60%' >&nbsp;" + craccount + "</td>");
             out.println("</tr>");
             out.println("<tr height=23>");
               out.println("<td>Subscrbier name:</td>");
               out.println("<td >&nbsp;" + (String)userInfo.get("username") +"</td>");
             out.println("</tr>");
             out.println("<tr height=23>");
               out.println("<td>ID No.</td>");
               out.println("<td >&nbsp;" + (String)userInfo.get("personid") + "</td>"); //changed postid to personid
             out.println("</tr>");
             out.println("<tr height=23>");
               out.println("<td>Current state</td>");
               out.println("<td class='font' >&nbsp;" + userStatus[lockid] + "</td>");
             out.println("</tr>");
           }
          %>
          </table>
       </td>
      </tr>
      <tr>
          <td align="center" height=50 >
            <table border="0" width="60%" class="table-style2">
              <tr>
               <% if(lockid==0) {%>
                <td align="center"><img src="button/pause.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onPause()"></td>

                  <%if(ifshowforceactivate.equals("1")){%>
                  <td align="center"><img src="button/pauseforce.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onPauseForce()"></td>
                  <%}} else if(lockid==1) {%>
                 <td align="center"><img src="button/active.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onRevert()"></td>

                   <%if(ifshowforceactivate.equals("1")){%>
                   <td align="center"><img src="button/pauseforce.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onPauseForce()"></td>
                 <%}}%>

                 <%if((lockid==3)&&ifshowforceactivate.equals("1")){%>
                  <td align="center"><img src="button/activeforce.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onRevertForce()"></td>
                 <% }%>
                 <td align="center"><img src="button/back.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onBack()"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
</td>
</tr>
</table>
</form>
<%
    }
    else {
        if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script>
        <%
         }
         else{
         %>
              <script language="javascript">
                   alert("Sorry,you have no access to this function!");
              </script>
            <%

        }
    }
  }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " restore/suspend subscriber " + craccount+ " occurr error!");
        sysInfo.add(sysTime +  e.toString());
        vet.add(operName + "restore/suspend subscriber " + craccount+ " occurr error!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="cardActive.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>

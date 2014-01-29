<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Synchronize User</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">

<%
	String sysTime = "";
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
    	manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null &&  purviewList.get("3-47") != null) { 
            Vector vet = new Vector();
            ArrayList rList  = new ArrayList();
            HashMap hash = new HashMap();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String userNo  = request.getParameter("craccount") == null ? "" : transferString((String)request.getParameter("craccount")).trim();
            String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
            %>
            <script language="javascript">
               function checkUser() {
                  var fm = document.inputForm;
                  var value = trim(fm.craccount.value);
                  if (!isUserNumber(value,'<%=user_number%>')) {
                     fm.craccount.focus();
                     return;
                  }
                 fm.op.value='sync';
                 fm.submit();
               }
            </script>
            <script language="JavaScript">
            	if(parent.frames.length>0)
            		parent.document.all.main.style.height="600";
            </script>
            <%
            if(op.equals("sync")){
                  rList = syspara.synchronizeUser(userNo); // To synchronize user number with other scp.
            }
            if(!op.equals("")&& getResultFlag(rList)) {
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","347");
                map.put("RESULT","1");
                map.put("PARA1","");
                map.put("PARA2","");
                map.put("PARA3","");
                map.put("PARA4","");
                map.put("PARA5",userNo);
                purview.writeLog(map);
            }
            if(rList.size()>0){
                session.setAttribute("rList",rList);
%>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="syncUser.jsp">
<input type="hidden" name="title" value="Synchronize User">
<script language="javascript">
   document.resultForm.submit();
</script>
<% } %>
</form>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>

<form name="inputForm" method="post" action="syncUser.jsp">
<input type="hidden" name="op" value="">
  <table border="0" align="center" height="400" width="400" class="table-style2" >
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Synchronize User </td>
        </tr>
        <br/>
        <tr>
          <td align="right"  ><%=user_number%></td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2" height=30 >
            <table border="0" width="80%" class="table-style2" align="center">
              <tr>
                <td width="40%" align="center"><img src="button/sure.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:checkUser()"></td>
                <td width="60%" align="center"><img src="button/again.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:document.inputForm.reset()"></td>
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
	alert( "Please log in first!");//Please log in to the system.
	document.URL = 'enter.jsp';
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
    	    sysInfo.add(sysTime + operName + " exception occurred in synchronizing user with other Scp!");
    	    sysInfo.add(sysTime + operName + e.toString());
    	    vet.add("Error occurred in synchronizing user with other Scp!");
    	    session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="syncUser.jsp">
</form>
<script language="javascript">
	document.errorForm.submit();
</script>
<%
	}
%>
</body>
</html>

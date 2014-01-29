<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manUser"%>
<%@ page import="zxyw50.CrbtUtil"%>
<%@ page import="zxyw50.Purview"%>
<%@ page import="zte.zxyw50.user.service.*"%>
<%@ page contentType="text/html; " language="java" import="java.sql.*" errorPage="" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>User usage query</title>

<link href="../style.css" type="text/css" rel="stylesheet">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<body>
<script language="JavaScript">
function doBack(){
  document.location.href = 'UserPointsInfo.jsp';
}
function queryInfo(){
  var usernum = trim(document.inputForm.userNumber.value);
  if(usernum == '' ){
    alert('Please input the user number!');//«Î ‰»Î∫≈¬Î
    document.inputForm.userNumber.focus();
    return;
  }
  if(usernum.length<6){
    alert('User number is incorrect!');
    document.inputForm.userNumber.focus();
    return;
  }
  /*
  if(parseInt(usernum.substring(0,1))!=0 && parseInt(usernum.substring(0,2))!=13){
    alert('Please input a telephone number with the area code containing 0!');
    document.inputForm.userNumber.focus();
    return;
  }  
  else if(parseInt(usernum.substring(0,1))!=0 && parseInt(usernum.substring(0,2))==13 && usernum.length<11){
    alert('Please input 11-digit MS number!');//«Î ‰»Î11Œª
    document.inputForm.userNumber.focus();
    return;
  }
  */
  
  if(!checkstring('0123456789',usernum)){
    alert('The user number should be in the digit format!');
    return;
  }
  document.inputForm.submit();
}
</script>
<%
String sysTime = "";
String operID = (String)session.getAttribute("OPERID");
String operName = (String)session.getAttribute("OPERNAME");
Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
String craacount = (String)request.getParameter("userNumber")==null?"":(String)request.getParameter("userNumber").trim();
int userPonits = 0;
try{
  manUser manuser = new manUser();
  sysTime = manuser.getSysTime() + "--";
  Vector result = new Vector();
  String  errmsg = "";
  HashMap map = new HashMap();
  Purview purview = new Purview();
  boolean flag =true;
  if (operID  == null){
    errmsg = "Please log in to the system!";
    flag = false;
  }
  else if (purviewList.get("13-18") == null) {
    errmsg = "You have no access to this function!";
    flag = false;
  }
  if(flag){
    if (craacount != null && craacount.length() > 0){
        UserServiceImpl UserServiceImpl = new UserServiceImpl();
        userPonits = UserServiceImpl.queryUserPoints(craacount);
    }
%>
<script language="JavaScript">
if(parent.frames.length>0)
  parent.document.all.main.style.height="650";
</script>
<form name="inputForm" method="post" action="UserPointsInfo.jsp">
<table width="440"  border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr valign="center">
    <td align="center">
      <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="table-style2">
        <tr >
            <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">User usage query</td>
        </tr>
        <tr>
          <td height="22" align="right" width="40%">User number</td>
          <td height="22"><input type="text" name="userNumber" value="<%= craacount==null?"":craacount %>" maxlength="20" class="input-style1"  ></td>
        </tr>
<%if (craacount != null && craacount.length()>0){%>
        <tr>
          <td height="22" align="right" width="40%">User number</td>
          <td height="22"><%=userPonits%></td>
        </tr>
<%}%>
         <tr align="center">
          <td colspan="3">
            <table border="0" width="75%" class="table-style2">
              <tr align="center">
                 <td align="center"><img src="../button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:queryInfo()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan="2" class="table-styleshow" background="image/n-9.gif" height="28">
            Notes:</td>
        </tr>
        <tr>
          <td colspan="2" height="20">1.User number is: Mobile number or PHS number</td>
        </tr>
        <tr>
          <td colspan="2" height="20">2.Click the Search button to query the usage information</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<%
        }else{
%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = '../enter.jsp';
</script>
<%
       }
   }
   catch(Exception e) {
     Vector vet1 = new Vector();
     sysInfo.add(sysTime + operName + " is abnormal during the query of user usage!");
     sysInfo.add(sysTime + operName + e.toString());
     vet1.add("Error occurs during the query of user usage!");
     vet1.add(e.getMessage());
     session.setAttribute("ERRORMESSAGE",vet1);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/UserPointsInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
}
%>
</body>
</html>

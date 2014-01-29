<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@include file="../base/JsFun.jsp"%>
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
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String passLen = (String)application.getAttribute("PASSLEN")==null?"0":(String)application.getAttribute("PASSLEN");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");

	// add for starhub
	String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
    if (operID != null && purviewList.get("1-1") != null) {
%>
<script language="javascript">
   function changePwd () {
      var fm = document.inputForm;
      if (fm.craccount.value == '') {
         alert('Please enter the <%= colorName %> number!');
         fm.craccount.focus();
         return;
      }
      if(!checkstring('0123456789',fm.newcardpass.value)){
    	  alert('The new password should be a digital number!');
         fm.newcardpass.focus();
         return;
      }
      if(!checkstring('0123456789',fm.concardpass.value)){
    	  alert('The password should be a digital number!');
    	  fm.concardpass.focus();
          return;
      }
      var intFlag = <%= passLen.equals("1")?1:0%>;
//      if (document.inputForm.newcardpass.value.length < 6 && intFlag==0) {
//         alert('新密码至少为六位!');
//         return;
//      }
//      else if(document.inputForm.newcardpass.value.length!=6 && intFlag==1){
//      	alert('请输入六位新密码!');
//      	return;
//      }
      if (document.inputForm.newcardpass.value.length < <%=CrbtUtil.getMinPassword() %>||
	  document.inputForm.newcardpass.value.length > <%=CrbtUtil.getMaxPassword() %>) {
         alert('<%=CrbtUtil.getPasswrodAlertMsg()%>');
         document.inputForm.newcardpass.focus();
         return;
      }

      if (fm.newcardpass.value != fm.concardpass.value) {
         alert('New Password does not match Confirm Password');//新密码与确认密码不一致!
         fm.concardpass.focus();
         return;
      }
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="changePasswordEnd.jsp">
<table border="0" align="center" height="250" class="table-style2" width="60%">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2" width="100%">
        <tr background="image/n-9.gif">
          <td height="26" colspan="2" align="center" class="text-title"background="image/n-9.gif">Password modification</td>
        </tr>
        <tr>
          <td align="right"><%=user_number%></td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">New password</td>
          <td><input type="password" name="newcardpass" value="" maxlength="<%= CrbtUtil.getMaxPassword() %>" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Confirm password</td>
          <td><input type="password" name="concardpass" value="" maxlength="<%= CrbtUtil.getMaxPassword() %>" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="button/change.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:changePwd()"></td>
                <td width="50%" ><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
 <tr>
  	<td colspan="2" class="table-styleshow" background="image/n-9.gif" height="28">
                          Notes:</td>
  </tr>
  <%  if(areacode.equals("3")){
  %>
    <tr>
      <td style="color: #FF0000">Format of PHS Subscriber Number: 0+area code+actual number.</td>
    </tr>
   <% } else {%>
    <tr>
      <td  style="color: #FF0000"><%=user_number%>: Mobile Phone Number.</td>
    </tr>
  <% } %>
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
     alert( "Please log in to the system first!");//Please log in to the system
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
%>
</body>
</html>

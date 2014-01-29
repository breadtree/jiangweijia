<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html;charset=ISO8859_1" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String spIndex = (String)session.getAttribute("SPINDEX");
	if (operID  == null ){
%>
<script language="javascript">
    alert("Please log in first!");
	document.URL = 'enter.jsp';
</script>
<%   }
     else{
 %>

<html>
<head>
<title>Change password</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">


  <script language="javascript">
   function isContainDot(password) {
   	 if(password == null || password.length <= 0) {
   	 	return false;
   	 }
   	 for(var i = 0; i < password.length; i++) {
   	 	var c = password.charAt(i);
   	 	if(c == '.') {
   	 		return true;
   	 	}
   	 }
   	 return false;
   }
   
   function changePwd () {
      var fm = document.inputForm;
     if(fm.oldcardpass.value==''){
	 	alert("Please enter the old password first!");
		fm.oldcardpass.focus();
		return;
	 }
	 if (fm.newcardpass.value == "") {
         alert("The new password can be a null!");
         fm.newcardpass.focus();
         return;
      }
      
      if(isContainDot(fm.newcardpass.value)) {
      	alert("Sorry,the new password should not contain dot character.");
      	fm.newcardpass.focus();
      	return;
      }
      
      if(isContainDot(fm.concardpass.value)) {
      	alert("Sorry,the confirm password should not contain dot character.");
      	fm.concardpass.focus();
      	return;
      }
      
      if (fm.newcardpass.value != fm.concardpass.value) {
         alert("The new password is not same as the confirm password!");
         fm.newcardpass.focus();
         return;
      }
      fm.submit();
   }


  function OnKeyPress(evn,Next_ActiveControl,SenderType)
  {
    var
        charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
    status = charCode;
	if (charCode == 13)
	{
		Next_ActiveControl.select();
		Next_ActiveControl.focus();
		return false;
	}
	switch (SenderType.toUpperCase())
	{
		case 'int'.toUpperCase():
   			if ((charCode < 48) || (charCode > 57)){
				return false;
			}
			break;

		case 'float'.toUpperCase():
			var i = 0;
   			if ((charCode != 46) && (charCode < 48) || (charCode > 57)){
				evn.KeyCode = 0;
				return false;
			} else if (charCode == 46){
				if (Sender.value == "")
					return false;
			    else{
				    for(var i = 0; i < Sender.value.length; i++){
					    var sChar = Sender.value.charAt(i);
					    if (sChar == '.') return false;
				    }
			    }
			}
		break;

		case 'date'.toUpperCase():
		    if (((charCode < 48) || (charCode > 57)) && (charCode!=45)){
				return false;
			}
		break;
		default:
			break;

	}

    return true;

  }

  function onEnter(evn) {
    var   charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
    if (charCode == 13){
       document.forms[0].concardpass.blur();
       changePwd();
      }

  }

</script>

<form name="inputForm" method="post" action="operPwdChangeEnd.jsp">
<table width="551" border="0" cellspacing="0" cellpadding="0" align="center" height="400">
    <tr>
      <td valign="center" bgcolor="#FFFFFF">
       <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
             <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
                <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Change password of operator</td>
        </tr>
              </table>
              <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
                <tr valign="top">
                <td width="100%" align="center">
                  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="table-style2">
                    <tr >
                      <td align="right" width="45%">Operator&nbsp;</td>
                      <td width="55%"><%= (String)session.getAttribute("OPERNAME") %></td>
                      <td ></td>
                    </tr>
                    <tr >
                      <td align="right" width="45%">Old password&nbsp;</td>
                      <td width="55%"><input type="password" name="oldcardpass" value="" maxlength="8" class="input-style1"  onKeyPress="return OnKeyPress(event,document.inputForm.newcardpass,'')"></td>
                    </tr>
                    <tr>
                      <td align="right">New password&nbsp;</td>
                      <td><input type="password" name="newcardpass" value="" maxlength="8" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.concardpass,'')"></td>
                    </tr>
                    <tr>
                      <td align="right">Confirm password&nbsp;</td>
                      <td><input type="password" name="concardpass" value="" maxlength="8" class="input-style1" onKeyPress="onEnter(event)" ></td>
                    </tr>
                    <tr>
                      <td colspan="2" align="center">
                         &nbsp;&nbsp;&nbsp;&nbsp; <img src="../manager/button/change.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:changePwd()">&nbsp;&nbsp;&nbsp;&nbsp;
                          <img src="../manager/button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()">
                      </td>
                    </tr>
                  </table>

                </td>
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
%>
</body>
</html>

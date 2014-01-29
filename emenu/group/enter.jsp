<%@ page import="java.lang.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Operator login </title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("operID");
    if (operID == null) {
%>
<script language="javascript">
   function userLogin() {
      if (document.inputForm.opername.value == '') {
         alert('Please input username!');
         return;
      }
      if (document.inputForm.password.value == '') {
         alert('Please input password!');
         return;
      }
      document.inputForm.submit();
   }
   
   	//¼üÅÌÏìÓ¦º¯Êý
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
  
  function onPassword(evn) {
    var   charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
    if (charCode == 13){
       document.forms[0].password.blur();
      userLogin();
      }
	   
  }
   
   
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="login.jsp">
<input type="hidden" name="servicekey" value="<%= "pstn51" %>">
<table border="0" align="center" height="400" class="table-style2" width="100%">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title">Operator login</td>
        </tr>
        <tr>
          <td align="right">Operator name</td>
          <td><input name="opername" value="" maxlength="20" class="input-style1"  onKeyPress="return OnKeyPress(event,document.inputForm.password,'')"></td>
        </tr>
        <tr>
          <td align="right">Password</td>
          <td><input type="password" name="password" value="" maxlength="20" class="input-style1" onKeyPress="return onPassword(event)"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="../button/login.gif" onclick="javascript:userLogin()" onmouseover="this.style.cursor='hand'"></td>
                <td width="50%" align="center"><img src="../button/again.gif" onclick="javascript:document.inputForm.reset()" onmouseover="this.style.cursor='hand'"></td>
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


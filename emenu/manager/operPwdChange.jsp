<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
	String strMinlength  = zxyw50.CrbtUtil.getConfig("managerminpassword","1");
	int managerminlength =1;
	try{
		managerminlength = Integer.parseInt(strMinlength);
	}catch(Exception e)
	{
		System.out.println("Invalid managerminpassword:"+strMinlength);
		managerminlength = 1;
	}

	zxyw50.Purview purview = new zxyw50.Purview();
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String spIndex = (String)session.getAttribute("SPINDEX");
	String indexpage = request.getParameter("indexpage") == null ? "0" : (String)request.getParameter("indexpage");
	HashMap map1 = new HashMap();
	map1 = purview.getOperInformation(operID);
	String PWDNEVERUPD = (String) map1.get("PWDNEVERUPD");
	
	if (operID  == null ){
%>
<script language="javascript">
    alert("Please log in to the system first!");
	document.URL = 'enter.jsp';
</script>
<%   }
     else if(PWDNEVERUPD.equals("1")){
 %>
 <script language="javascript">
    alert("Not Allowed to modify password!");
	 parent.document.URL = 'index.jsp';
</script>
<% } else{%>

<html>
<head>
<title>Modify password</title>
<link rel="stylesheet" type="text/css" href="style.css">
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
      var newPwd = fm.newcardpass.value;      
     if(fm.oldcardpass.value==''){
	 	alert('Please enter the old password first!');//请先输入旧密码
		fm.oldcardpass.focus();
		return;
	 }
	 if (fm.newcardpass.value == "") {
         alert('The New Password field cannot be blank!');//新密码不能为空
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
         alert('New Password does not match Confirm Password');//新密码与确认密码不一致!
         fm.newcardpass.focus();
         return;
      }
      
      //检查password长度
      if(strlength(fm.newcardpass.value)<<%=managerminlength%>){
      	alert("Sorry,the password should be at least <%=managerminlength%> characters. Please input again.");
      	fm.newcardpass.focus();
      	return;
      }
      if(strlength(fm.concardpass.value)<<%=managerminlength%>){
      	alert("Sorry,the confirm password should be at least <%=managerminlength%> characters. Please input again.");
      	fm.concardpass.focus();
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

function AllowOnly()
	  {    
		 var keyCode = event.keyCode;
		 if((keyCode==32))
		 {			
		  event.returnValue = false;
		 }
		 else
		 {
		  event.returnValue = true;
		 }   
	  }
	  
</script>

<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="operPwdChangeEnd.jsp">
<input type="hidden" name="indexpage" value="<%=indexpage%>">
<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center" height="400">
    <tr>
      <td valign="center" bgcolor="#FFFFFF">
       <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
             <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
                <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Operator password modification</td>
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
                      <td align="right" width="45%">Old password</td>
                      <td width="55%"><input type="password" name="oldcardpass" value="" maxlength="20" class="input-style1" onKeyPress="AllowOnly();return OnKeyPress(event,document.inputForm.newcardpass,'')"></td>
                    </tr>
                    <tr>
                      <td align="right">New password</td>
                      <td><input type="password" name="newcardpass" value="" maxlength="20" class="input-style1" onKeyPress="AllowOnly();return OnKeyPress(event,document.inputForm.concardpass,'')"></td>
                    </tr>
                    <tr>
                      <td align="right">Confirm password&nbsp;</td>
                      <td><input type="password" name="concardpass" value="" maxlength="20" class="input-style1" onKeyPress="AllowOnly();onEnter(event)" ></td>
                    </tr>
                    <tr>
                      <td colspan="2" align="center">
                         &nbsp;&nbsp;&nbsp;&nbsp; <img src="button/change.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:changePwd()">&nbsp;&nbsp;&nbsp;&nbsp;
                          <img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()">
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

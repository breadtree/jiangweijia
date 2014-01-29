<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<script language="JavaScript">
	if(parent.frames.length>0){
			parent.document.all.main.style.height="400";
			}
</script>
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

    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String groupindex = (String)session.getAttribute("GROUPINDEX");
	if (groupindex  == null || groupindex.equals("-1")||operID==null) {
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to the system first! " : "Sorry, you are not the group administrator!" %>');
    document.URL = 'enter.jsp';
</script>
<%
        }
%>
<html>
<head>
<title>Operator password modification</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    if (operID != null) {
%>

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
	 	alert('Please input the old password!');
		fm.oldcardpass.focus();
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
         alert('The New Password does not match Confirm Password!');
         fm.newcardpass.focus();
         return;
      }
      
      //¼ì²épassword³¤¶È
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
</script>

<form name="inputForm" method="post" action="changePasswordEnd.jsp">
<table width="551" border="0" cellspacing="0" cellpadding="0" align="center" height="400">
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
                      <td align="right" width="45%">Old password</td>
                      <td width="55%"><input type="password" name="oldcardpass" value="" maxlength="20" class="input-style1"></td>
                    </tr>
                    <tr>
                      <td align="right">New password</td>
                      <td><input type="password" name="newcardpass" value="" maxlength="20" class="input-style1"></td>
                    </tr>
                    <tr>
                      <td align="right">Confirm password</td>
                      <td><input type="password" name="concardpass" value="" maxlength="20" class="input-style1"></td>
                    </tr>
                    <tr>
                      <td colspan="2" align="center">
                         &nbsp;&nbsp;&nbsp;&nbsp; <img src="../button/change.gif" onclick="javascript:changePwd()" onmouseover="this.style.cursor='hand'">&nbsp;&nbsp;&nbsp;&nbsp;
                          <img src="../button/again.gif" onclick="javascript:document.inputForm.reset()" onmouseover="this.style.cursor='hand'">
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

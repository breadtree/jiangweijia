<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page language="java" contentType="text/html;charset=ISO8859_1" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
    String passLen    = (String)application.getAttribute("PASSLEN")==null?"0":(String)application.getAttribute("PASSLEN");
    String colorName  = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String customName = (String)application.getAttribute("CUSTOMNAME")==null?"Mobile phone number ":(String)application.getAttribute("CUSTOMNAME");
    String opflag     = request.getParameter("opflag")==null?"":((String)request.getParameter("opflag")).trim();
%>
<html>
<head>
<title>Get authentication password</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<script src="../pubfun/JsFun.js"></script>
<script language="JavaScript">
   function userLogin() {
      var  value = trim(document.inputForm.usernumber.value);
      var  custname = "<%= customName %>" ;
      if ( value== '') {
         alert('Please enter '+custname +'!');
         document.inputForm.usernumber.focus();
         return;
      }
      if(!(value.length>5)){
      	alert('Please enter the correct ' + custname +'!');//请输入正确的
      	 document.inputForm.usernumber.focus();
      	return;
      }
      if(!checkstring('0123456789',value)){
      	alert(custname +' can be numbers only. Please re-enter.');//只能是数字，请重新输入!
      	document.inputForm.usernumber.focus();
      	return;
      }
      if (document.inputForm.password.value == '') {
         alert('Please enter the password!');//请输入密码
         document.inputForm.password.focus();
         return;
      }
      var intFlag = <%= passLen.equals("1")?1:0%>;
      if (document.inputForm.password.value.length < <%=CrbtUtil.getMinPassword() %>||
	  document.inputForm.password.value.length > <%=CrbtUtil.getMaxPassword() %>) {
         alert('<%=CrbtUtil.getPasswrodAlertMsg()%>');
         document.inputForm.password.focus();
         return;
      }

//      if (document.inputForm.password.value.length < 6 && intFlag==0) {
//         alert('密码至少为六位！');
//         document.inputForm.password.focus();
//         return;
//      }
//      else if(document.inputForm.password.value.length!=6 && intFlag==1){
//      	alert('请输入六位密码！');
//      	document.inputForm.password.focus();
//      	return;
//      }
      document.inputForm.opflag.value='1';
	  document.inputForm.submit();
   }
   function onClose(){
      window.close();
   }
   function onBack(){
     document.forms[0].opflag.value='';
     document.forms[0].submit();
   }
</script>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<form name="inputForm" method="post" action="getPwd.jsp">
<input name="opflag" type="hidden" >
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" >
  <tr>
    <td width="100%"><img src="../image/pop013.gif" width="400" height="60"></td>
  </tr>
  <tr>
    <td><img src="../image/pop02.gif" width="400" height="26"></td>
  </tr>
  <tr>
    <td background="../image/pop03.gif" height="160">
      <div align="center">
        <table width="80%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
		<tr>
		    <td colspan=2 height=30 class="font-man" align="center"><b>Get authentication password</b> </td>
		</tr>
		<% if(opflag.equals("1")) {  //开始向接口机发送鉴权信息。
		    Hashtable result = null;
		    Hashtable hash = new Hashtable();
		    SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
		    String userNumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();
            String cardPass = request.getParameter("password") == null ? "" : (String)request.getParameter("password");
            hash.put("usernumber",userNumber);
            hash.put("cardpass",cardPass);
            hash.put("opcode","01010937");
            hash.put("craccount",userNumber);
            try {
            //开始鉴权
            ColorRing colorRing = new ColorRing();
            colorRing.checkUserInfo(hash);
            //获取动态密码
             result = SocketPortocol.send(pool,hash);
              out.println("<tr height=30>");
              out.println("<td align=right width='50%'>"+ customName +":</td>");
              out.println("<td width='50%'>"+ userNumber +"</td>");
              out.println("</tr>");
              out.println("<tr height=30 >");
              out.println("<td align=right>Authentication password:</td>");
              out.println("<td class='font' >"+ (String)result.get("password") +"</td>");
              out.println("</tr>");
              out.println("<tr height=30 ><td colspan=2 align=center> <img src='../button/back.gif' onMouseOver=\"this.style.cursor='hand'\" onClick='javascript:onBack()'>&nbsp;&nbsp;&nbsp;&nbsp;<img src='../button/close.gif' onMouseOver=\"this.style.cursor='hand'\" onClick='javascript:onClose()'></td></tr>");
            }
           catch(Exception e) {
              out.println("<tr height=30 ><td align=right>Getting authentication password failed!</td>");
              out.println("<td >" + e.getMessage()+ "</td></tr>");
              out.println("<tr height=30 ><td colspan=2 align=center> <img src='../button/back.gif' onMouseOver=\"this.style.cursor='hand'\" onClick='javascript:onBack()'>&nbsp;&nbsp;&nbsp;&nbsp;<img src='../button/close.gif' onMouseOver=\"this.style.cursor='hand'\"  onClick='javascript:onClose()'></td></tr>");
           }


		} else{%>
		<tr>
		<td width=45% align=right> <%= customName %>
		</td>
		<td width=55%> <input type="text" name="usernumber" value="" maxlength="20" class="input-style2">
		</td>
        </tr>
		<tr>
		<td width=45% align=right> <%= colorName %>Password
		</td>
		<td width=55%> <input type="password" name="password" value="" maxlength="<%=CrbtUtil.getMaxPassword()%>" class="input-style2">
		</td>
		</tr>
		<tr height=30 >
		<td colspan=2  align="center" > <img src="../button/sure.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:userLogin()">&nbsp;&nbsp;&nbsp;&nbsp;<img src='../button/close.gif' onMouseOver="this.style.cursor='hand'" onClick='javascript:onClose()'>
		</td>
		</tr>
		<% } %>
        </table>
      </div>
	  </td>
  </tr>
  <tr>
    <td><img src="../image/pop04.gif" width="400" height="23"></td>
  </tr>
</table>
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2" height=20>
  <tr>
    <td>&nbsp; </td>
  </tr>
  <tr>
    <td>&nbsp; </td>
  </tr>
</table>
</form>
</body>
</html>

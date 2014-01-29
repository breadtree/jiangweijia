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
    String userNumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();
    String cardPass   = request.getParameter("password") == null ? "" : (String)request.getParameter("password");
    String provider = (String)application.getAttribute("PROVIDERCODE")==null?"0":(String)application.getAttribute("PROVIDERCODE");
%>

<%
String img_path = "intl/"+ getZteLocale(request)+"/"; //add by chenxi 2007-03-01
%>
<html>
<head>
<title>Register</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<script src="../pubfun/JsFun.js"></script>
<script language="JavaScript">

   var  custname = "<%= customName %>" ;
   function userLogin() {
      var  value = trim(document.inputForm.usernumber.value);
      if ( value== '') {
         alert('Please enter '+custname +'!');
         document.inputForm.usernumber.focus();
         return;
      }
      if(!(value.length>5)){
      	alert('Please enter the correct ' + custname +'!');//��������ȷ��
      	 document.inputForm.usernumber.focus();
      	return;
      }
      if(!checkstring('0123456789',value)){
      	alert(custname +' can be numbers only. Please re-enter.');//ֻ�������֣�����������!
      	document.inputForm.usernumber.focus();
      	return;
      }
      if (document.inputForm.password.value == '') {
         alert('Please enter the password!');//����������
         document.inputForm.password.focus();
         return;
      }
      var intFlag = <%= passLen.equals("1")?1:0%>;
//      if (document.inputForm.password.value.length < 6 && intFlag==0) {
//         alert('��������Ϊ��λ��');
//         document.inputForm.password.focus();
//         return;
//      }
//      else if(document.inputForm.password.value.length!=6 && intFlag==1){
//      	alert('��������λ���룡');
//      	document.inputForm.password.focus();
//      	return;
//      }
      if (document.inputForm.password.value.length < <%=CrbtUtil.getMinPassword() %>||
	  document.inputForm.password.value.length > <%=CrbtUtil.getMaxPassword() %>) {
         alert('<%=CrbtUtil.getPasswrodAlertMsg()%>');
         document.inputForm.password.focus();
         return;
      }

      document.inputForm.opflag.value='2';
	  document.inputForm.submit();
   }

   function onClose(){
      window.close();
   }
   function onBack(){
     document.forms[0].opflag.value='';
     document.forms[0].submit();
   }

   function sendRequest(){
   	  var value = trim(document.inputForm.usernumber.value);
      if (value == '') {
         alert('Please enter '+custname +'!');
         document.inputForm.usernumber.focus();
         return;
      }
      if(value.length<7){
         alert(custname +'Sorry, your input was invalid! Please re-enter.');//���벻��ȷ������������
         document.inputForm.usernumber.focus();
         return;
      }
      if(!checkstring('0123456789',value)){
         alert(custname +' can only contain digits,Please re-enter!');//ֻ��Ϊ���֣����������룡
         document.inputForm.usernumber.focus();
         return;
      }
	  document.inputForm.opflag.value='1';
	  document.inputForm.submit();
   }

</script>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<form name="inputForm" method="post" action="account.jsp">
<input name="opflag" type="hidden" >
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" >
  <tr>
    <td width="100%"><img src="../<%=img_path%>image/pop013.gif" width="400" height="60"></td>
  </tr>
  <tr>
    <td><img src="../image/pop02.gif" width="400" height="26"></td>
  </tr>
  <tr>
    <td background="../image/pop03.gif" height="160">
      <div align="center">
        <%
           ColorRing colorRing = new ColorRing();
           String    sAlert = "";
           Hashtable hash = new Hashtable();
           Hashtable result = null;
           SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
           String sysTime = SocketPortocol.getSysTime() + "--";
           Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
           try {
                if(!opflag.equals("")){
                   out.println("<table width='50%' cellspacing='1' cellpadding='2' border='0' class='table-style2' align='center'>");
                   out.println("<tr><td height=50 class='font-man' align='center'><b>Register</b> </td>");
                   out.println("</tr>");
                }
                if(opflag.equals("1")) {           //ȡ�ö�̬����
//                   if(colorRing.searchUser(userNumber)) {
//                     	throw new Exception("Subscriber "+ colorName +" data already exists");
//                   }
                   hash.put("craccount",userNumber);//�û�������Ȩ
                   hash.put("opcode","01010903");
     	           result = SocketPortocol.send(pool,hash);
	               //���붯̬����
	  	           hash.put("opcode","01010996");
	               hash.put("craccount",userNumber);
                   result = SocketPortocol.send(pool,hash);
	               session.setAttribute("OPENSTATUS","A dynamic password you applied for has been sent to your mobile phone. Please enter the dynamic password to complete the registration");
	               sAlert = "The dynamic password you applied for has been sent to your mobile phone. Please complete the registration by using your dynamic password.";

                }
                else if(opflag.equals("2")) {//ע��
//                    if(colorRing.searchUser(userNumber))
//                     	throw new Exception("Subscriber  "+ colorName +" data already exists");
                 hash.put("craccount",userNumber);
                 hash.put("passwd",cardPass);
	             String ulabel = "0";
		    	 hash.put("level",Integer.toString(Integer.parseInt(ulabel)+1));  //��ͨ�û�
		    	 //��������
                 hash.put("opcode","01010101");
                 hash.put("opmode","1");
		    	 hash.put("ipaddr",request.getRemoteAddr());
                 result = SocketPortocol.send(pool,hash);
                 String noticeMsg = "";
                 if(provider.equals("1")){
                      noticeMsg = "Your registration request is in processing. You will receive a short message on the registration result within 24 hours.";//���Ŀ��������ѱ�����ϵͳ����24Сʱ���Զ��ŷ�ʽ֪ͨ�����������
                      sAlert = "Your registration request is in processing. You will receive a short message on the registration result within 24 hours.";//���Ŀ��������ѱ�����ϵͳ����24Сʱ���Զ��ŷ�ʽ֪ͨ�����������
                      sysInfo.add(sysTime + userNumber + " sent a registration request and logged in to the system.");//�û������������󲢵�¼���ϵͳ
                 }
                 else{
	             	 noticeMsg = "Your registration request is in process. The service will be available to you in 24 hours.";//ϵͳ���ڴ������Ŀ�������������24Сʱ�Ժ�ʹ��ҵ��
	                 sysInfo.add(sysTime + userNumber + " registered on the Website and logged in to the system.");//�û�web��������¼ϵͳ��
	                 sAlert = "Your registration request is in process. The service will be available to you in 24 hours.";//ϵͳ���ڴ������Ŀ�������������24Сʱ�Ժ�ʹ��ҵ��
	            }
	             session.setAttribute("OPENSTATUS",noticeMsg);
	             userNumber ="";

	           }
	           if(!opflag.equals("")){
	           %>
	           <script language="JavaScript">
	             alert("<%=  sAlert  %>");
	           </script>
	           <%
	            }
	           opflag = "";
           }
           catch(Exception e) {
               Vector vet1 = new Vector();
               if (opflag.equals("1")) {
                   sysInfo.add(sysTime + userNumber + ",Exception occurred in getting dynamic password!");//��ȡ��̬������̳����쳣
                   vet1.add(userNumber + " Getting dynamic password failed!");//��ȡ��̬����ʧ��
                   out.println("<tr height=30 >");
                   out.println("<td >Failed to get dynamic password!</td>");
                   out.println("</tr>");
                   out.println("<tr height=30>");
                   out.println("<td >"+ e.getMessage() +"</td>");
                   out.println("</tr>");

	           }
	           if( opflag.equals("2")){
	       	      sysInfo.add(sysTime+userNumber+",Exception occurred to the registration!");//ע����̳����쳣
	       	      vet1.add(userNumber + " Registration failed!");//ע���û�ʧ��

	       	       out.println("<tr height=30 >");
                   out.println("<td >Registration failed!</td>");//ע��ʧ�ܣ�
                   out.println("</tr>");
                   out.println("<tr >");
                   out.println("<td >"+ e.getMessage() +"</td>");
                   out.println("</tr>");
	           }
	           session.setAttribute("OPENSTATUS",e.getMessage());
               sysInfo.add(e.toString());
               vet1.add(e.getMessage());
               session.setAttribute("ERRORMESSAGE",vet1);

               out.println("<tr height=30>");
               out.println("<td  align='center'><img src='../button/back.gif' border=0 onClick='javascript:onBack()' onMouseOver=\"this.style.cursor='hand'\"> &nbsp;&nbsp;<img src='../button/close.gif' onMouseOver=\"this.style.cursor='hand'\" onClick='javascript:onClose()'> </td>");
               out.println("</tr>");

           }
           if(opflag.equals("")){
        %>
        <table width="80%" cellspacing="1" cellpadding="2" border="0" class="table-style2" align="center">
        <tr>
		    <td colspan=3 height=30 class="font-man" align="center"><b>Register</b> </td>
		</tr>
		<tr>
            <td align="right" width="170"><%= customName %></td>
            <td width="80" align=center><input name="usernumber" type="text"  size="12" maxlength="12" value="<%= userNumber %>" class="input-style2"></td>
            <td width="95"  valign="center"  onClick="javascript:sendRequest()" onMouseOver="this.style.cursor='hand'" height="20" bgcolor="#AEE3AE"> Apply for a dynamic password </td>
        </tr>
         <tr>
           <td align="right" height="40" width="170" >Enter password</td>
           <td width="80" align=center ><input name="password" type="password"  maxlength="<%= CrbtUtil.getMaxPassword() %>" class="input-style2"></td>
           <td width="95"  valign="center" >&nbsp; </td>
         </tr>
         <tr>
         <td colspan="3" align="center">
            <img src="../button/regist.gif" border="0" onClick="javascript:userLogin()" onMouseOver="this.style.cursor='hand'">&nbsp;&nbsp; <img src="../button/again.gif" border="0" onClick="javascript:document.inputForm.reset()" onMouseOver="this.style.cursor='hand'"> &nbsp;&nbsp;<img src='../button/close.gif' onMouseOver="this.style.cursor='hand'" onClick='javascript:onClose()'>
         </td>
         </tr>
		 <tr>
         <td colspan="3" >
		   <table cellspacing="0" cellpadding="0" border="0" class="table-style2">
		    <tr><td>Note:</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;1.You must apply for a dynamic password, and then use the dynamic password to complete registration.</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;2.The dynamic password is your initial password. You can visit our Website to change it. Please keep your password in a secret place to avoid loss.</td></tr>
		   </table>
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

<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page language="java" contentType="text/html;charset=ISO8859_1" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Open an account</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String passLen = (String)application.getAttribute("PASSLEN")==null?"0":(String)application.getAttribute("PASSLEN");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
	if (operID != null && purviewList.get("14-1") != null) {
%>
<script language="javascript">
   function changePwd () {
      var fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (value == '') {
         alert('Please enter an number');
         fm.craccount.focus();
         return;
      }

      if (!checkstring('0123456789',value)) {
         alert("The number only can be a digital number!");
         fm.craccount.focus();
         return;
      }
      if (document.inputForm.newcardpass.value=='') {
         alert("Please enter the password!");
         fm.newcardpass.focus();
         return;
      }
      if (!checkstring('0123456789',document.inputForm.newcardpass.value)) {
         alert("The password only can be a digital number!");
         fm.craccount.focus();
         return;
      }

      var intFlag = <%= passLen.equals("1")?1:0%>;
//      if (document.inputForm.newcardpass.value.length < 6 && intFlag==0) {
//         alert('密码至少为六位！');
//         return;
//      }
//      else if(document.inputForm.newcardpass.value.length!=6 && intFlag==1){
//      	alert('请输入六位密码！');
//      	return;
//      }
      if (document.inputForm.newcardpass.value.length < <%=CrbtUtil.getMinPassword() %>||
	  document.inputForm.newcardpass.value.length > <%=CrbtUtil.getMaxPassword() %>) {
         alert('<%=CrbtUtil.getPasswrodAlertMsg()%>');
         document.inputForm.newcardpass.focus();
         return;
      }


      if (fm.newcardpass.value != fm.concardpass.value) {
         alert("The password is not same as the confirm password!");
         fm.concardpass.focus();
         return;
      }
      if(fm.inflag.value==1){
         if(trim(fm.serkey.value)==""){
             alert("Please enter thr IN service key!");//请输入智能网业务键
             fm.serkey.focus();
             return;
         }
        if(!checkstring('0123456789',trim(fm.serkey.value))){
             alert("The IN service key only can be a digital number!");
             fm.serkey.focus();
             return;
        }
      }
      value = trim(fm.scpgt.value);
      if(value!='' &&  !checkstring('0123456789',value)){
          alert("The code of SCP GT only can be a digital number!");
          fm.scpgt.focus();
          return;
      }
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="cardUseEnd.jsp">
<table border="0" align="center" height="400" width="350" class="table-style2" >
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%= colorName %>Open an account</td>
        </tr>
        <tr>
          <td align="right">Number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Password</td>
          <td><input type="password" name="newcardpass" value="" maxlength="<%= CrbtUtil.getMaxPassword() %>" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Confirm password</td>
          <td><input type="password" name="concardpass" value="" maxlength="<%= CrbtUtil.getMaxPassword() %>" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right">Is subscriber of advance</td>
          <td height="22">
            <select name=restInt style="width:150" class="input-style1">
             <option value=0 selected>No</option>
             <option value=1 >Yes</option>
            </select>
          </td>
        </tr>
        <tr>
          <td align="right">Is subscriber of IN</td>
          <td>
           <select name="inflag"  class="input-style1" style="width:150" >
           <option value=1 >Yes</option>
           <option value=0 >No</option>
           </select>
          </td>
        </tr>
        <tr>
          <td align="right">IN service key</td>
          <td><input type="text" name="serkey" value="" maxlength="8" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Code of SCP GT</td>
          <td><input type="text" name="scpgt" value="" maxlength="26" class="input-style1"></td>
        </tr>

        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="../manager/button/kaihu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:changePwd()"></td>
                <td width="50%" align="center"><img src="../manager/button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
         <tr>
          <td align="right" colspan=2>&nbsp;</td>
        </tr>
        <tr>
          <td colspan=2>
          <table border="0" width="100%" class="table-style2">
            <tr>
                <td class="table-styleshow" background="image/n-9.gif" height="26">
                  Notes:</td>
              </tr>
            <%  if(areacode.equals("3")){
            %>
              <tr>
                <td style="color: #FF0000">1.The format of PHS subscriber to open an account is:0+area no+phone number;</td>
              </tr>
             <% } else {%>
              <tr>
                <td style="color: #FF0000">1.Open number is: mobile phone number;</td>
              </tr>
            <% } %>
              <tr>
                <td style="color: #FF0000">2.If is the user of IN,must enter the IN service key and the code of SCP GT;</td>
              </tr>
              <tr>
                <td style="color: #FF0000">3.The IN service key and the code of SCP GT must be an digital number!</td>
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
                    alert( "Please log in first!");
                    document.URL = 'enter.jsp';
              </script>
        <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "Sorry, you have no right to access this function!");
              </script>
            <%

        }
    }
%>
</body>
</html>

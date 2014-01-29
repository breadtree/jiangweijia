<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zte.zxyw50.CRBTContext" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Account Opening</title>
<link rel="stylesheet" type="text/css" href="style.css">
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
    String isimp = zte.zxyw50.util.CrbtUtil.getConfig("isimp","1");
	String colorphotoname = zte.zxyw50.util.CrbtUtil.getConfig("colorphotoname","Color Photo Show");
	String usecalling =zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0");
	String showUserKeepingNumber = zte.zxyw50.util.CrbtUtil.getConfig("showuserkeepingnumber","0");
	String isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");
	String IMSURL =zte.zxyw50.util.CrbtUtil.getConfig("IMSURL","0");

	// Added by Srinivas Rao K for Telenar 5.11.x
	int isMotenegro = zte.zxyw50.util.CrbtUtil.getConfig("isMotenegro",0);
	String display = "display:block";
	if( isMotenegro == 1)
		display = "display:none";
	//end of added
	

	int isSupportOpenMRBT = 0 ; //0: not support MRBT Open 1: support MRBT Open
	String mrbt_value = CRBTContext.getParameter(26183, "0");
	if("0".equals(mrbt_value))
	{
		isSupportOpenMRBT = 0;	
	}else{
		isSupportOpenMRBT = 1;	
	}	

	
	
	int isNetType = zte.zxyw50.util.CrbtUtil.getConfig("nettype",0); //Added for V5.13.01 TCI [Iran] by Srinivasa Rao 
		
	if (operID != null && purviewList.get("1-4") != null) {
%>
<script language="javascript">
   function changePwd () {
      var fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (value == '') {
         alert('Please enter an Account Opening Number!');//请输入开户号码
         fm.craccount.focus();
         return;
      }

      if (!checkstring('0123456789',value)) {
         alert('Digits of account opening number');//开户号码数字
         fm.craccount.focus();
         return;
      }
      if (document.inputForm.newcardpass.value=='') {
         alert('Please enter the password!');//请输入密码
         fm.newcardpass.focus();
         return;
      }
      if (!checkstring('0123456789',document.inputForm.newcardpass.value)) {
         alert('The password can only contain digits!');//密码只能为数字
         fm.craccount.focus();
         return;
      }

      var intFlag = <%= passLen.equals("1")?1:0%>;
//      if (document.inputForm.newcardpass.value.length < 6 && intFlag==0) {
//         alert('密码至少为六位!');
//         return;
//      }
//      else if(document.inputForm.newcardpass.value.length!=6 && intFlag==1){
//      	alert('请输入六位密码!');
//      	return;
//      }
      if (document.inputForm.newcardpass.value.length < <%=CrbtUtil.getMinPassword() %>||
	  document.inputForm.newcardpass.value.length > <%=CrbtUtil.getMaxPassword() %>) {
         alert('<%=CrbtUtil.getPasswrodAlertMsg()%>');
         document.inputForm.newcardpass.focus();
         return;
      }


      if (fm.newcardpass.value != fm.concardpass.value) {
         alert('The password does not match the Confirm Password!');//密码与确认密码不一致
         fm.concardpass.focus();
         return;
      }
	  if(1 == <%=IMSURL%>){
	    if(trim(fm.imsurl.value)!="" && (fm.imsurl.value).indexOf("@")<0)
		{
		  alert("The IMSURL should contain @ character" );
		  fm.imsurl.focus();
		  return;
		  }
		if(trim(fm.imsurl.value)!="" && (fm.imsurl.value).indexOf("@")==0)
		{
		  alert("@ cannot be the first character in IMSURL" );
		  fm.imsurl.focus();
		  return;
		}
		if(trim(fm.imsurl.value)!="" && (fm.imsurl.value).indexOf(".")<0)
		{
		  alert("The IMSURL should contain . character" );
		  fm.imsurl.focus();
		  return;
		}
		if(trim(fm.imsurl.value)!="" && (fm.imsurl.value).indexOf(".")==0)
		{
		  alert(". cannot be the first character in IMSURL" );
		  fm.imsurl.focus();
		  return;
		}
		if(trim(fm.imsurl.value)!="" && (fm.imsurl.value).indexOf(",")>=0)
		{
		  alert("The IMSURL cannot contain , character" );
		  fm.imsurl.focus();
		  return;
		}
	  }

      <%System.out.println("isimp="+isimp);%>
      if(0 == <%=isimp%>){
	   if( <%=isMotenegro%> == 0){
        if(fm.inflag.value==1){
          if(trim(fm.serkey.value)==""){
            //alert("\u8BF7\u8F93\u5165\u667A\u80FD\u7F51\u4E1A\u52A1\u952E.");
            alert("Please input IN servicekey.");
            fm.serkey.focus();
            return;
          }
          if(!checkstring('0123456789',trim(fm.serkey.value))){
            alert("IN servicekey should be digits!");
            fm.serkey.focus();
            return;
          }
        }
	   }
        value = trim(fm.scpgt.value);
        if(value!='' &&  !checkstring('0123456789',value)){
          alert("SCP GT should be digits!");
          fm.scpgt.focus();
          return;
        }
	}
	if(0 == <%=isimp%>){
		if(1 == <%= showUserKeepingNumber %>){
		value = trim(fm.userkeepnumber.value)
			// 限定长度60位
		if(value.length>60){
				// alert(numbername+"长度不够,请重新输入!");
				alert("The length of User keeping number is larger than 16,please re-enter!");
				fm.userkeepnumber.focus();
				return;
			}
		for( i = 0; i < value.length;  i++)
		{
			var sChar = value.charAt(i);
			// 只允许输入数字，字母及@符号
			if(!(((sChar >= 'A') && (sChar <= 'Z'))
			   ||((sChar >= 'a') && (sChar <= 'z'))
			   ||((sChar >= '0') && (sChar <= '9'))
			   ||(sChar == '@') )){
				   alert("User keeping number cannot include the illegal character ' "+sChar
				   +" ',User keeping number should be digits or characteras or '@' !");
				   fm.userkeepnumber.focus();
				   return;
			   }
		}
	 }
	 }
   fm.submit();
}   
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="cardUseEnd.jsp">
<table border="0" align="center" height="400" width="440" class="table-style2" >
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%= colorName %>&nbsp;Subscriber -- account opening</td>
        </tr>
        <tr style="<%=(("1".equals(usecalling)||"1".equals(isimage))?"display:block":"display:none")%>">
			<td width="43%" align="right">Service type</td>
			<td width="57%">
           <select name="userringtype"  class="input-style1" style="width:150" >
           <option selected="selected" value=0 >Called service</option>
					<%if("1".equals(usecalling)){%>
           <option value=1 >Calling service</option>
					<%} %>
					<!--<option value=2 >Calling and called service</option>-->
					<%if("1".equals(isimage)){ %>
					<option value=3><%= colorphotoname.trim() %></option>
					<%} %>
           </select>
          </td>
        </tr>
        <tr>
          <td align="right">Account opening number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        
        
		<%if(isSupportOpenMRBT == 1){%>
        <tr>
          <td align="right">User Type</td>
          <td>
		   <select name="usertype" class="input-style1" style="width:150" >
            <option value="1">CRBT</option>
            <option value="<%=mrbt_value %>">MRBT</option>
			</select>
		  </td>
        </tr>
		<%}%>
        
		<%if((!("1".equals(isimp)))&&(!("0".equals(showUserKeepingNumber)))){ %>
		<tr>
		  <td align="right">User keeping number</td><%-- 用户持续号码，翻译可能有误，需要确认--%>
          <td><input type="text" name="userkeepnumber" value="" maxlength="60" class="input-style1"></td>
		</tr>
		<%} %>
        <tr>
          <td align="right">New password</td>
          <td><input type="password" name="newcardpass" value="" maxlength="<%= CrbtUtil.getMaxPassword() %>" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Confirm passwod</td>
          <td><input type="password" name="concardpass" value="" maxlength="<%= CrbtUtil.getMaxPassword() %>" class="input-style1"></td>
        </tr>

        <%if("0".equals(isimp)){%>
        <tr>
          <td height="22" align="right">Prepaid user</td>
          <td height="22">
            <select name=restInt style="width:150" class="input-style1">
              <option value=0 selected>No</option>
              <option value=1 >Yes</option>
            </select>
          </td>
        </tr>
        <tr>
          <td align="right">IN user</td>
          <td>
            <select name="inflag"  class="input-style1" style="width:150" >
              <option value=1 >Yes</option>
              <option value=0 >No</option>
            </select>
          </td>
        </tr>
        <tr style="<%=display%>">
          <td align="right">IN servicekey</td>
          <td><input type="text" name="serkey" value="" maxlength="8" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">SCP GT</td>
          <td><input type="text" name="scpgt" value="" maxlength="26" class="input-style1"></td>
        </tr>
	    <% }
		if(IMSURL.equals("1"))
		{
		%>
        <tr>
          <td align="right">IMSURL</td>
          <td><input type="text" name="imsurl" value="" maxlength="90" class="input-style1"></td>
        </tr>
		<%
		}
		
		if(isNetType == 1){
%>
        <tr>
          <td align="right">Network Type</td>
          <td>
		   <select name="nettype" class="input-style1" style="width:150" >
            <option selected="selected" value="1">NGN</option>
            <option value="2">IMS</option>
			</select>
		  </td>
        </tr>
		<%
		}
		%>
        <tr>
          <td colspan="2">
            <table  border="0" align="center" class="table-style2">
              <tr>
                <td width="50%" align="center"><div align="center"><img src="button/kaihu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:changePwd()"></div></td>
                <td width="50%" ><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
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
                <td style="color: #FF0000">1. Format of the PHS Account Opening Number: 0+area code+actual number.</td>
              </tr>
             <% } else {%>
              <tr>
                <td style="color: #FF0000">1. Account Opening Number: Mobile phone number; </td>
              </tr>
            <% } %>
<%if("0".equals(isimp)){%>
            <tr>
                <td style="color: #FF0000">2.If is IN user,need input IN servikekey and SCP GT;</td>
              </tr>
              <tr>
                <td style="color: #FF0000">3.IN servicekey and SCP GT should be digits.</td>
              </tr>

<%}%>

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
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
              </script>
        <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//You have no access to this function!
              </script>
            <%

        }
    }
%>
</body>
</html>

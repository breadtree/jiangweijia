<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>Subscriber account cancellation</title>
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

	String colorphotoname = zte.zxyw50.util.CrbtUtil.getConfig("colorphotoname","Color Photo Show");
	String usecalling = zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0");
	String isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");

    if (operID != null && purviewList.get("1-5") != null) {
%>
<script language="javascript">

   function cardErase () {
      var fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (value == '') {
         alert('Please enter an Account Cancellation Number!');//请输入销户号码
         fm.craccount.focus();
         return;
      }
      if (value.length<6|| value.length>20) {
         alert('The Account Cancellation Number entered is not correct');//销户号码输入不正确
         fm.craccount.focus();
         return;
      }
      if (!checkstring('0123456789',fm.craccount.value)) {
         alert('The Account Cancellation Number should be a digital number!');//销户号码应为数字
         fm.craccount.focus();
         return;
      }
      var str = "Are you sure to delete Subscriber "+fm.craccount.value+" ?"//您确信要删除用户
      if(!confirm(str))
        return;
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="cardEraseEnd.jsp">
<table border="0" align="center" height="400" width="380" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%= colorName %>&nbsp;Subscriber -- account cancellation</td>
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
          <td align="right">Account Cancellation Number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="button/xiaohu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:cardErase()"></td>
                <td width="50%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
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
                  Note:</td>
            </tr>
             <tr>
                <td style="color: #FF0000">1. When the subscriber account is cancelled, the system will not provide the <%= colorName %> service for the subscriber.</td>
             </tr>
            <%  if(areacode.equals("3")){
            %>
              <tr>
                <td style="color: #FF0000">2. Format of the PHS Account Cancellation Number: 0+area code+actual number</td>
              </tr>
             <% } else {%>
              <tr>
                <td style="color: #FF0000">2. Account Cancellation Number: Mobile Phone Number</td>
              </tr>
            <% } %>


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

<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>Account cancellation via Manual Operator Position</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String passLen = (String)application.getAttribute("PASSLEN")==null?"0":(String)application.getAttribute("PASSLEN");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
    if (operID != null && purviewList.get("13-2") != null) {
%>
<script language="javascript">

   function cardErase () {
      var fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (!isUserNumber(value,'Canceled number')) {
         fm.craccount.focus();
         return;
      }
      var str = "Are you sure to delete the number "+fm.craccount.value+"?";
      if(!confirm(str))
        return;
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="cardEraseEnd.jsp">
<table border="0" align="center" height="400" width="300" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">Account cancellation via<br>Manual Operator</td>
        </tr>
        <%
        //add by wuxiang 2005-4-14
        String usecalling = CrbtUtil.getConfig("usecalling","0");
        %>
                <tr >
          <td height="15" colspan="2" align="center" >&nbsp;</td>
        </tr>
        <tr style="<%=("1".equals(usecalling)?"display:block":"display:none")%>">
          <td align="right">Service Type</td>
          <td>
           <select name="userringtype"  class="input-style1" style="width:150" >
           <option selected="selected" value=0 >Called Service</option>
           <option value=1 >Calling Service</option>
           		<!--<option value=2 >Calling/Called Service</option>-->
           </select>
          </td>
        </tr>
        <%//end add%>
        <tr>
          <td align="right" height=40 >Cancellation Number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="80%" class="table-style2" align="center">
              <tr>
                <td width="50%" align="center"><img src="../button/xiaohu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:cardErase()"></td>
                <td width="50%" align="center"><img src="../button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
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
                <td class="table-styleshow" background="../image/n-9.gif" height="26">
                  Notes:</td>
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
                    document.URL = '../enter.jsp';
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

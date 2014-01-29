<%@ page import="java.lang.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Active/suspend via manual Operator Position</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
	String colorphotoname = zte.zxyw50.util.CrbtUtil.getConfig("colorphotoname","Color Photo Show");
	String usecalling =zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0");
	String isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");
        String userringtype = "0";
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	// add for starhub
	String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
	if (operID != null && purviewList.get("1-13") != null) {
   %>
<script language="javascript">
   function changePwd () {
      var fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (!isUserNumber(value,'<%=user_number%>')) {
         fm.craccount.focus();
         return;
      }
     fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="cardActiveEnd.jsp">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" width="400" class="table-style2" >
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Activate/Suspend subscriber</td>
        </tr>
         <tr style="<%=(("1".equals(usecalling)||"1".equals(isimage))?"display:block":"display:none")%>">
          <td width="43%" align="right">Service type</td>
			<td width="57%">
           <select name="userringtype"  class="input-style1" style="width:150" >
					<option selected="selected" value=0 >Called service</option>
					<%if("1".equals(usecalling)){%>
					<option value=1>Calling service</option>
					<%} %>
					<!--<option value=2 >Calling and called service</option>-->
					<%if("1".equals(isimage)){ %>
					<option value=3><%= colorphotoname.trim() %></option>
					<%} %>
           </select>
          </td>
        </tr>
        <tr>
          <td align="right"  ><%=user_number%></td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2" height=30 >
            <table border="0" width="80%" class="table-style2" align="center">
              <tr>
                <td width="40%" align="center"><img src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:changePwd()"></td>
                <td width="60%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
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
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script>
        <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "You have no access to this function!");
              </script>
            <%

        }
    }
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Manage week period of time ringtone</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
   if (operID != null && purviewList.get("13-13") != null) {
   %>
<script language="javascript">
   function changePwd () {
      var fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (!isUserNumber(value,'subscriber number')) {
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
<form name="inputForm" method="post" action="weekRingEnd.jsp">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" width="60%" class="table-style2" >
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">Manage week period of time ringtone</td>
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
           <option selected value=0 >Called Service</option>
           <option  value=1 >Calling Service</option>
           </select>
          </td>
        </tr>
        <%//end add%>
        <tr>
          <td align="right" >Subsciber number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2"  >
            <table border="0" width="80%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="../button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:changePwd()"></td>
                <td width="50%" align="center"><img src="../button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
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
                    document.URL = '../enter.jsp';
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

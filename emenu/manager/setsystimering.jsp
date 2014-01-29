<%@ page import="java.lang.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="java.util.Hashtable" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Time Period Setting</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
   if (operID != null && purviewList.get("2-34") != null) {
   %>
<script language="javascript">

   function onTimeChange(oVal){
	  if(oVal == 3)
	  {
	         document.inputForm.action="systimeperiod.jsp";
	  }
	  else
	  {
		      document.inputForm.action="syscommemoration.jsp";
	  }
      document.inputForm.op.value = "";
      document.inputForm.submit();
   }
      
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post">
<input type="hidden" name="op" value="<%=op%>">
<table border="0" align="center" height="400" width="60%" class="table-style2" >
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Time Period Setting </td>
        </tr>
        <%
        //add by wuxiang 2005-4-14
       // String usecalling = CrbtUtil.getConfig("usecalling","0");
        %>
        <tr >
          <td height="15" colspan="2" align="center" >&nbsp;</td>
        </tr>
        <tr >
          <td align="right">Time Period Type </td>
          <td>
           <select name="settype"  class="input-style1" style="width:200" onChange="javascript:onTimeChange(this.options[this.selectedIndex].value)"  >
		   <option selected="selected" value="-1" >Select a TimePeriod Type</option>
           <option value=3 >Time Period Ring</option>
           <option value=4 >Commemoration day Ring</option>
	       </select>
          </td>
        </tr>
        <%//end add%>
       
        
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
                    document.location.href = 'enter.jsp';
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

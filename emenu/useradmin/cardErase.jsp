<%@ page import="java.util.Hashtable" %>
<%@ page language="java" contentType="text/html;charset=ISO8859_1" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>Subscriber log out</title>
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
    if (operID != null && purviewList.get("14-2") != null) {
%>
<script language="javascript">

   function cardErase () {
      var fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (value == '') {
         alert('Please enter the number!');
         fm.craccount.focus();
         return;
      }
      if (value.length<6|| value.length>20) {
         alert('The number is not correct!');
         fm.craccount.focus();
         return;
      }
      if (!checkstring('0123456789',fm.craccount.value)) {
         alert("The number must be an digital number!");
         fm.craccount.focus();
         return;
      }
      var str = "Are you confirm log out the subscriber of "+fm.craccount.value+"?";
      if(!confirm(str))
        return;
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="cardEraseEnd.jsp">
<table border="0" align="center" height="400" width="300" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%= colorName %>Subscriber log out</td>
        </tr>
        <tr>
          <td align="right">Number</td>
          <td><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="50%" align="center"><img src="../manager/button/xiaohu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:cardErase()"></td>
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
             <tr>
                <td style="color: #FF0000">1.The subscriber will not use the service of <%= colorName %> system after log out!</td>
             </tr>
            <%  if(areacode.equals("3")){
            %>
              <tr>
                <td style="color: #FF0000">2.PHS phone number's format is:area number + phone number</td>
              </tr>
             <% } else {%>
              <tr>
                <td style="color: #FF0000">2.Number of log out: mobile phone number.</td>
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
                    alert( "Please log in first!");
                    document.URL = 'enter.jsp';
              </script>
        <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "Sorry,you have no right to access this function!");
              </script>
            <%

        }
    }
%>
</body>
</html>

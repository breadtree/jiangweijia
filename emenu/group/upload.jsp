
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Ringtone upload</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
      String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String craccount = "";
    if (mode.equals("manager")){
        craccount = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
    }
    else{
        craccount = (String)session.getAttribute("GROUPID");
    }
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))  ringdisplay = "ringtone";
    if (craccount != null) {
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      fm.submit();
   }
</script>
<form name="inputForm" enctype="multipart/form-data" method="post" action="uploadEnd.jsp?mode=<%=mode%>&amp;groupid=<%=craccount%>">
<input type="hidden" name="mode" value="<%=mode%>"/>
<input type="hidden" name="groupid" value="<%=craccount%>"/>
<table width="480" border="0" cellspacing="0" cellpadding="0" align="center" height="220">
  <tr>
    <td valign="top" bgcolor="#FFFFFF">

      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
<table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
              <tr>
                <td width="28"><img src="../image/home_r14_c3.gif" width="28" height="31"></td>
                <td background="../image/home_r14_c5bg.gif"><font color="#006600"><b></b>
                  <b><font class="font"> <%=  ringdisplay  %> upload</font></b></font></td>
                <td width="12"><img src="../image/home_r14_c5.gif" width="12" height="31"></td>
              </tr>
            </table>
            <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
              <tr valign="top">
                <td width="100%"><table width="100%" border="0" cellpadding="2" cellspacing="1" class="table-style3">
                    <tr>
                      <td align="center"><input type="file" name="ringFile"></td>
                    </tr>
                    <tr>
                      <td align="center"><br>
                        <img src="../button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
                    </tr>
                  </table> </td>
              </tr>
              <tr valign="top">
                <td width="100%"> <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
                    <tr>
                      <td class="table-styleshow" background="../image/n-9.gif" height="26">
                       Help:</td>
                    </tr>
                   <tr bgcolor="#d3dbe8">
                      <td bgcolor="#FFFFFF">1.  The size of the upload <%=  ringdisplay  %> file must range from 8KB to 500KB.</td>
                    </tr>
                    <tr bgcolor="#d3dbe8">
                      <td bgcolor="#FFFFFF">2.  The <%=  ringdisplay  %> file must be in the format of CCITT A_Law, without the compression.</td>
                    </tr>
                    <tr bgcolor="#d3dbe8">
                      <td bgcolor="#FFFFFF">3.  The name of <%=  ringdisplay  %> file should not contain a space.</td>
                    </tr>
                    </table></td>
              </tr>
            </table></td>
        </tr>
      </table>
      <p>&nbsp;</p></td>
  </tr>

</table>
</form>
<%
    }
    else {
%>
<script language="javascript">
 	alert('Please log out and then log in again!');
	window.close();
</script>
<%
    }
%>
</body>
</html>

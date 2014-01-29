<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Album Image Upload</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String operID = (String)session.getAttribute("OPERID");
	String sAlbumMovieEdit = (String)request.getParameter("frompage")==null?"":(String)request.getParameter("frompage");
	String sFileName = (String)request.getParameter("filename")==null?"":(String)request.getParameter("filename");
	//System.out.println("FILE NAME------------->"+sFileName);
	String sImageFileTypes = CrbtUtil.getConfig("imageFileTypes","jpg,png,gif").trim();
	if (operID != null) {
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
      fm.submit();
   }
</script>
<form name="inputForm" enctype="multipart/form-data" method="post" action="uploadAlbumImageEnd.jsp?frompage=<%=sAlbumMovieEdit%>&filename=<%=sFileName%>">
<input type="hidden" name="op" value="">
<table border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
  <tr>
		<td>&nbsp;</td>
  </tr>
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <tr>
          <td colspan="2" align="center" class="text-title"><%if(sAlbumMovieEdit.equals("album")){%>Album <%}else{%>Movie <%}%>Image Upload</td>
        </tr>
        <tr>
          <td colspan="2"><input type="file" name="ringFile" ></td>
		
        </tr>
        <tr>
          <td colspan="2" align="center"><img src="button/sure.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:upload()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
		<td>&nbsp;</td>
  </tr>
    <tr style="color: #FF0000">
    <td>The following should be noted when uploading the Album/Movie image file:<br />
	&nbsp;1. Please upload the image file type as per the configuration in &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;db.properties file. Default: <%= sImageFileTypes%> formats.<br />
    &nbsp;2. The maximum upload file size limit is 7MB.</td>
  </tr>
  </table>
</form>
<%
    }
    else {
%>
<script language="javascript">
   alert('Please log in to the system first!');//Please log in to the system first!
   document.URL = 'enter.jsp';
</script>
<%
    }
%>
</body>
</html>

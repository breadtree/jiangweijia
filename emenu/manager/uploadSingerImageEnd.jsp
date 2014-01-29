<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.manSysRing" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Singer upload</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	String sSingerEdit = (String)request.getParameter("frompage")==null?"":(String)request.getParameter("frompage");
//	String sUrlPath = (String)request.getParameter("urlpath")==null?"":(String)request.getParameter("urlpath");
    String sImageFileTypes = CrbtUtil.getConfig("imageFileTypes","jpg,png,gif").trim();
	
    try {
			manSysRing sysring = new manSysRing();
			sysTime = SocketPortocol.getSysTime() + "--";
			String listName = "";
			 if (operID != null) 
			{
			 if(sSingerEdit.equals("singer"))
			 {
				    System.out.println("11");
					SmartUpload fileLoader = new SmartUpload();
					String fileName ="";
					fileLoader.initialize(pageContext);
					fileLoader.setAllowedFilesList(sImageFileTypes);
					fileLoader.setTotalMaxFileSize(7000 * 1024);
					fileLoader.upload();
					com.zte.jspsmart.upload.File listFile = fileLoader.getFiles().getFile(0);
					SocketPortocol portocol = new SocketPortocol();
					listName = listFile.getFileName();
					String tempdir = (String)portocol.getTmpDir() ;
					String imgDir = (String)CrbtUtil.getConfig("singerpath","C:/zxin10/Was/tomcat/webapps/colorring/image/singer/");
				        fileName = listName;
					StringTokenizer token = new StringTokenizer(imgDir, "|" );
					int j=0;
	  			    while(token.hasMoreTokens())
	  			    {
	  				 String sEachImgDirInfo=token.nextToken();
					 if(sEachImgDirInfo!=null && !sEachImgDirInfo.equals("")) {
	  					listFile.saveAs(sEachImgDirInfo+ fileName,listFile.SAVEAS_VIRTUAL); 
	  				 }
					 j++;
	  			    }
				//	 imgDir = imgDir+"image/starhub/artist/";
			 }
			
%>
<script language="javascript">
    window.opener.getListName('<%= listName %>');
    window.close();
</script>
<%
        }
        else {
%>
<script language="javascript">
   alert('Please log in to the system first!');
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in uploading Singer Image!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(" Error occurred in uploading uploading Singer Image!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="uploadSingerImage.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

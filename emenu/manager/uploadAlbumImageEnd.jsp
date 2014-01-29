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
	String sAlbumMovieEdit = (String)request.getParameter("frompage")==null?"":(String)request.getParameter("frompage");
//	String sUrlPath = (String)request.getParameter("urlpath")==null?"":(String)request.getParameter("urlpath");
    String sImageFileTypes = CrbtUtil.getConfig("imageFileTypes","jpg,png,gif").trim();
	System.out.println("sAlbumMovieEdit---------->"+sAlbumMovieEdit);
	
    try {
			manSysRing sysring = new manSysRing();
			sysTime = SocketPortocol.getSysTime() + "--";
			String listName = "";
			 if (operID != null) 
			{
			 if(sAlbumMovieEdit.equals("album"))
			 {
				    //System.out.println("11");
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
					System.out.println("listName=11="+listName);
					System.out.println("tempdir=11="+tempdir);
					String imgDir = (String)CrbtUtil.getConfig("albumpath","C:/zxin10/Was/tomcat/webapps/colorring/image/album/");
					fileName = listName;
					System.out.println("FILENAME INSIDE----------------->"+fileName);
					System.out.println("IMG DIR----------->"+imgDir);
					StringTokenizer token = new StringTokenizer(imgDir, "|" );
					int j=0;
	  			    while(token.hasMoreTokens())
	  			    {
	  				 String sEachImgDirInfo=token.nextToken();
					 //System.out.println("Each Image DirInfo------------->"+sEachImgDirInfo);
	  				 if(sEachImgDirInfo!=null && !sEachImgDirInfo.equals("")) {
	  					listFile.saveAs(sEachImgDirInfo+ fileName,listFile.SAVEAS_VIRTUAL); 
	  				 }
					 j++;
	  			    }
				//	 imgDir = imgDir+"image/starhub/artist/";
			 } else if(sAlbumMovieEdit.equals("movie")) {
				 //System.out.println("11");
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
					System.out.println("listName=11="+listName);
					System.out.println("tempdir=11="+tempdir);
					String imgDir = (String)CrbtUtil.getConfig("moviepath","C:/zxin10/Was/tomcat/webapps/colorring/image/movie/");
					fileName = listName;
					System.out.println("FILENAME INSIDE----------------->"+fileName);
					System.out.println("IMG DIR----------->"+imgDir);
					StringTokenizer token = new StringTokenizer(imgDir, "|" );
					int j=0;
	  			    while(token.hasMoreTokens())
	  			    {
	  				 String sEachImgDirInfo=token.nextToken();
					 //System.out.println("Each Image DirInfo------------->"+sEachImgDirInfo);
	  				 if(sEachImgDirInfo!=null && !sEachImgDirInfo.equals("")) {
	  					listFile.saveAs(sEachImgDirInfo+ fileName,listFile.SAVEAS_VIRTUAL); 
	  				 }
					 j++;
	  			    }
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
        sysInfo.add(sysTime + operName + "Exception occurred in uploading Movie/Album Image!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(" Error occurred in uploading uploading Movie/Album Image!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="uploadAlbumImage.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

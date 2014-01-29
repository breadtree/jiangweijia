<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.jspsmart.upload.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Replace ringtone</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    try {
        ColorRing colorRing = new ColorRing();
        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null) {
            // 铃音上传
            SmartUpload fileLoader = new SmartUpload();
            String ringName = "";
            String fileName = (new java.util.Date()).getTime() + ".wav";
            fileLoader.initialize(pageContext);
            fileLoader.setAllowedFilesList("WAV,wav,WAv,WaV,Wav,wAV,wAv,waV,,");
            fileLoader.setTotalMaxFileSize(500 * 1024);
            fileLoader.upload();
            // 取铃音文件
            com.zte.jspsmart.upload.File ringFile = fileLoader.getFiles().getFile(0);
            if (ringFile.getSize() < 8000)
                throw new Exception("The ringtone file should be greater than 8Kb!");//铃音文件必须大于8KB
            else {
                SocketPortocol portocol = new SocketPortocol();
                ringName = ringFile.getFileName();
                ringFile.saveAs(portocol.getTmpDir() + fileName,ringFile.SAVEAS_VIRTUAL);
            }
%>
<script language="javascript">
    window.opener.getRingName('<%= fileName %>', '<%= ringName %>');
    window.close();
</script>
<%
        }
        else {
%>
<script language="javascript">
   alert("Your login has been invalid. Please re-log in!");//您本次的登录权限已经失效,请退出后重新登录系统!
   window.close();
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in uploading the ringtone!");//铃音上载过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading the ringtone!");//铃音上载过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="com.zte.tao.config.TaoUtil" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Upload ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
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
            // �����ϴ�
            SmartUpload fileLoader = new SmartUpload();
            String ringName = "";
            String fileName = (new java.util.Date()).getTime() + ".wav";
            fileLoader.initialize(pageContext);
            fileLoader.setAllowedFilesList("WAV,wav,WAv,WaV,Wav,wAV,wAv,waV,,");
            fileLoader.setTotalMaxFileSize(100 * 1024);
            fileLoader.upload();
            // ȡ�����ļ�
            com.zte.jspsmart.upload.File ringFile = fileLoader.getFiles().getFile(0);
            if (ringFile.getSize() < 8000)
                throw new Exception("The ringtone file should be greater than 8Kb!");//�����ļ��������8KB
            else {
                SocketPortocol portocol = new SocketPortocol();
                ringName = ringFile.getFileName();
                ringName = new String(ringName.getBytes(),TaoUtil.getCharset("UTF-8"));
                ringFile.saveAs(portocol.getTmpDir() + fileName,ringFile.SAVEAS_PHYSICAL);
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
   alert('Please log in to the system first!');//Please log in to the system!
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in uploading the Greeting Tone!");//�������ع��̳����쳣
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading the Greeting Tone!");//�������ع��̳��ִ���
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="uploadTone.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

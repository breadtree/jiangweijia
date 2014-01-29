<%@ page import="com.zte.jspsmart.upload.*" %><%

 String filename = request.getParameter("filename");
 String filepath = request.getParameter("filepath");
// 新建一个SmartUpload对象
SmartUpload su = new SmartUpload();
// 初始化
su.initialize(pageContext);
// 设定contentDisposition为null以禁止浏览器自动打开文件，
 su.setContentDisposition(null);
 // 下载文件
 if(filename!=null&&filepath!=null&&filename.trim().length()>0&&filepath.trim().length()>0)
 su.downloadFile("/"+filepath+filename);%>
<%@ page import="com.zte.jspsmart.upload.*" %><%

 String filename = request.getParameter("filename");
 String filepath = request.getParameter("filepath");
// �½�һ��SmartUpload����
SmartUpload su = new SmartUpload();
// ��ʼ��
su.initialize(pageContext);
// �趨contentDispositionΪnull�Խ�ֹ������Զ����ļ���
 su.setContentDisposition(null);
 // �����ļ�
 if(filename!=null&&filepath!=null&&filename.trim().length()>0&&filepath.trim().length()>0)
 su.downloadFile("/"+filepath+filename);%>
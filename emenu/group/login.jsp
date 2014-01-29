<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.Manager" %>
<%@ page import="zxyw50.ManGroup" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<jsp:useBean id="Purview" class="zxyw50.Purview" scope="page" />

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="com.zte.zxywpub.login" scope="page" />
<html>
<head>
<title>Login</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    //String operName = (String)session.getAttribute("OPERNAME");
	String operName = request.getParameter("opername") == null ? "" : transferString(((String)request.getParameter("opername")).trim());
    String serviceKey = request.getParameter("servicekey") == null ? "" : ((String)request.getParameter("servicekey")).trim();
    Manager manage = null;
    manSysPara syspara  = null;
    String islnlt = request.getParameter("islnlt") == null ? "" : request.getParameter("islnlt");
    String easyBFlag = request.getParameter("easyBFlag") == null ? "" : request.getParameter("easyBFlag");

    try {

        String password = request.getParameter("password") == null ? "" : (String)request.getParameter("password");
        if(("1".equals(islnlt))&&("1".equals(easyBFlag))){
          operName = request.getParameter("userid") == null ? "" : request.getParameter("userid");
        }

		sysTime = SocketPortocol.getSysTime() + "--";
        if (db.checkOper(operName,request)) {

    	    String operID = db.getoperid() + "";
    	    int  groupindex = -1;
    	    groupindex = Purview.getOperSerIndex(operID,"2");
    	    if(groupindex==-1){
              if(("1".equals(islnlt))&&("1".equals(easyBFlag))){
    	    %>
              <form name="errorForm" method="post" action="error.jsp">
                <input type="hidden" name="easyBFlag" value="1">
                <input type="hidden" name="errmsg" value="Sorry, you are not the group operator!">
              </form>
              <script language="javascript">
                document.errorForm.submit();
              </script>
          <%}else{%>
            <script language="javascript">
              alert("Sorry, you are not the group operator!")
              document.URL = 'enter.jsp';
           </script>
           <%
    	    }}else{

    	    manage = new Manager();
            ManGroup  mangroup = new  ManGroup();
            int lockid = mangroup.getLockidByindex(String.valueOf(groupindex));
            if(lockid!= 0){
              if(("1".equals(islnlt))&&("1".equals(easyBFlag))){
                %>
              <form name="errorForm" method="post" action="error.jsp">
                <input type="hidden" name="easyBFlag" value="1">
                <input type="hidden" name="errmsg" value="Sorry, the group is locked!">
              </form>
              <script language="javascript">
                document.errorForm.submit();
              </script>
           <%}else{%>
            <script language="javascript">
              alert("Sorry, the group is locked")
              document.URL = 'enter.jsp';
           </script>
           <%
            }}else{
    	    Hashtable tmph = mangroup.getGrpInfoByindex(String.valueOf(groupindex));
    	    session.setAttribute("GROUPID",(String)tmph.get("groupid"));
    	    session.setAttribute("GROUPNAME",(String)tmph.get("groupname"));
    	    session.setAttribute("GROUPINDEX",groupindex+"");
            session.setAttribute("OPERNAME",operName);
            session.setAttribute("SERVICEKEY",serviceKey);
            session.setAttribute("OPERID",operID);
            //add by ge quanmin 2005.08.11 for version 3.19.01
            session.setAttribute("GRPMODE",(String)tmph.get("grpmode"));
            int  uploadfee = manage.getParameter(18);
            DecimalFormat format = new DecimalFormat("#,##0.00;(#,##0.00)");
            session.setAttribute("UPLOADFEE",format.format(((float)uploadfee)/100.0f)+"");
            session.setAttribute("PURVIEW",manage.getPurview(operID));

            // 记录系统日志
            sysInfo.add(sysTime + operName + "Log in to the group management system.");
			// 准备写操作员日志
            // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","101");
            map.put("RESULT","1");
            map.put("PARA1","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION"," Group management system");
            purview.writeLog(map);

%>
<form name="loginForm" method="post" action="index.jsp">
  <input type="hidden" name="isshowpwd" value="<%=islnlt%>">
<%
if(("1".equals(islnlt))&&("1".equals(easyBFlag))){
%>
  <input type="hidden" name="loginFlag1" value="1">
<%}else{%>
  <input type="hidden" name="loginFlag2" value="1">
<%}%>
</form>
<script language="javascript">
   if(parent.frames.length>0){
  <%if(("1".equals(islnlt))&&("1".equals(easyBFlag))){%>
    parent.document.URL='index.jsp?isshowpwd=<%=islnlt%>&loginFlag1=1';
  <%}else{%>
    parent.document.URL='index.jsp?isshowpwd=<%=islnlt%>&loginFlag2=1';
  <%}%>
  }else{
    <%if(("1".equals(islnlt))&&("1".equals(easyBFlag))){%>
    document.URL = 'index.jsp?isshowpwd=<%=islnlt%>&loginFlag1=1';
    <%}else{%>
    document.URL = 'index.jsp?isshowpwd=<%=islnlt%>&loginFlag2=1';
    <%}%>
  }

</script>
<%
           }
        }
        }
        else {
        int ErrorCode = db.geterrorCode();
	    String strMsg =  db.getStrmsg(ErrorCode);
        if(("1".equals(islnlt))&&("1".equals(easyBFlag))){
          String msg = "Failed to log in to the system!"+strMsg;

%>
              <form name="errorForm" method="post" action="error.jsp">
                <input type="hidden" name="easyBFlag" value="1">
                <input type="hidden" name="errmsg" value="<%=msg%>">
              </form>
              <script language="javascript">
                document.errorForm.submit();
              </script>
     <%}else{%>
<script language="javascript">
   var str = "<%= strMsg  %>";
   alert('Failed to log in the system!\n'+str);
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " is abnormal during the login of the system!");
        sysInfo.add(e.toString());
        vet.add(operName + " login of the system fails!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
        if(("1".equals(islnlt))&&("1".equals(easyBFlag))){
%>
<form name="errorForm" method="post" action="error.jsp">
     <input type="hidden" name="easyBFlag" value="1">
   </form>
   <script language="javascript">
     document.errorForm.submit();
   </script>
<%}else{%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="enter.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }}
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.Manager" %>
<%@ page import="zxyw50.*"%>
<%@ page import="com.zte.zxywpub.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zte.zxyw50.util.DateUtil"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.ParseException"%>
<jsp:useBean id="Purview" class="zxyw50.Purview" scope="page" />
<jsp:useBean id="db" class="com.zte.zxywpub.login" scope="page" />

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>Login</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body  class="body-style1">
<%
    HashMap map1 = null;
    String sysTime = "";
    Vector sysInfo = new Vector();
    String SSO_APP_USER_NAME = (String)session.getAttribute("SSO_APP_USER_NAME")==null?"":(String)session.getAttribute("SSO_APP_USER_NAME");
    String operName = request.getParameter("opername") == null ? SSO_APP_USER_NAME : transferString((String)request.getParameter("opername").trim());
    String sKey = "pstn51";
    String serviceKey = request.getParameter("servicekey") == null ? sKey : ((String)request.getParameter("servicekey")).trim();
	 try {
        String password = request.getParameter("password") == null ? null : (String)request.getParameter("password");
        Manager manage = new Manager();
		sysTime = manage.getSysTime() + "--";
        if (new com.zte.zxywpub.login().checkOper1(operName,password,request.getRemoteAddr(),serviceKey)) {
    	    String operID =  db.getOperID(operName);
    	    int  spindex = -1;
    	    //spindex = Purview.getOperSerIndex(operID,"1");
    	    int  groupindex = -1;
    	   // groupindex = Purview.getOperSerIndex(operID,"2");

	    if(spindex!=-1 || groupindex!=-1){
    	    %>
            <script language="javascript">
              alert("Sorry, you are not the system operator!")
              document.URL = 'enter.jsp';
           </script>
        <%  }else{
            session.setAttribute("OPERNAME",operName);
            session.setAttribute("SERVICEKEY",serviceKey);
            session.setAttribute("OPERID",operID);
            session.setAttribute("GROUPIDLEN",manage.getParameter(20)+"");
            session.setAttribute("SPCODELEN",manage.getParameter(31)+"");
            //session.setAttribute("RIDPREFIXLEN",manage.getParameter(32)+"");
            //session.setAttribute("RIDPREFIXLEN",""+manage.getRidPrelen(1));
            //session.setAttribute("RIDGRPPREFIXLEN",manage.getParameter(49)+"");
            session.setAttribute("PURVIEW",manage.getPurview(operID));

            session.setAttribute("OPERATORTYPE","manager");


            sysInfo.add(sysTime + operName + " login to the management system.");

            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","101");
            map.put("RESULT","1");
            map.put("PARA1","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION","Manage system");
            purview.writeLog(map);
	
%>
<form name="loginForm" method="post" action="../intro.html">
</form>
<script language="javascript">
<%

// To get Current date
    DateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd");
    java.util.Date date = new java.util.Date();
    String curdate = (String)dateFormat.format(date);
    String beginDate = curdate.substring(0,4) + curdate.substring(5,7)+curdate.substring(8,10);
    int icurdate= Integer.parseInt(beginDate);

//Date from DB
	map1 = new HashMap();
	map1 = purview.getOperInformation(operID);
	String PWDCHANGEDATE = (String) map1.get("PWDCHANGEDATE");
	String PWDMUSTCHANGE1 = (String) map1.get("PWDMUSTCHANGE");
	int iPwdMustChange = Integer.parseInt(PWDMUSTCHANGE1);//No of days 2 add
    

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	Calendar c = Calendar.getInstance();
	c.setTime(sdf.parse(PWDCHANGEDATE));
	c.add(Calendar.DATE, iPwdMustChange);  // number of days to add
	PWDCHANGEDATE = sdf.format(c.getTime());  // dt is now the new date
	String enddate = PWDCHANGEDATE.substring(0,4) + PWDCHANGEDATE.substring(5,7)+PWDCHANGEDATE.substring(8,10);
	
	int validity= Integer.parseInt(enddate);
	int res = validity-icurdate;

    if(((String)map1.get("NEXTUPDPWD")).equals("1"))
    {
%>
     window.document.URL = 'operPwdChange.jsp?indexpage=1';
<%
	}
else if(!PWDMUSTCHANGE1.equals("0"))
	{
		if(res <= 0)
		{
%> 
			window.document.URL = 'operPwdChange.jsp?indexpage=1';
<%      }else
		{
%>          parent.document.URL = 'index.jsp';
<%		}
    }
   else
	{
%>
   parent.document.URL = 'index.jsp';
<%	
   }
%>
</script>

<%       }
        }
        else {
        	int ErrorCode = db.geterrorCode();
        	String strMsg = "";
        	if(ErrorCode==0){
        		ErrorCode=902;
        		strMsg =  db.getStrmsg(ErrorCode);
        	    strMsg = strMsg+" or not assign right";
        	}
    	    

%>
<script language="javascript">
   var str = "<%= strMsg  %>";
   alert('Login failed!\n'+str);
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in logging in to the system");//登录系统过程出现异常!
        sysInfo.add(e.toString());
        vet.add(operName + " login failed!");//登录系统失败
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="enter.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

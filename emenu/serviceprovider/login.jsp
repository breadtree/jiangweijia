<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.Manager" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zte.zxyw50.util.DateUtil"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.ParseException"%>
<jsp:useBean id="Purview" class="zxyw50.Purview" scope="page" />

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="com.zte.zxywpub.login" scope="page" />
<html>
<head>
<title>Login</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    HashMap map1 = null;
    String sysTime = "";
    Vector sysInfo = new Vector();
    //String operName = (String)session.getAttribute("OPERNAME");
	String operName = request.getParameter("opername") == null ? "" : transferString(((String)request.getParameter("opername")).trim());
    String serviceKey = request.getParameter("servicekey") == null ? "" : ((String)request.getParameter("servicekey")).trim();
    Manager manage = null;
    manSysPara syspara  = null;
    try {
        String password = request.getParameter("password") == null ? "" : (String)request.getParameter("password");

		sysTime = CrbtUtil.getSysTime() + "--";
        if (db.checkOper1(operName,request)) {
    	    String operID = db.getoperid() + "";
    	    int  spindex = -1;
    	    spindex = Purview.getOperSerIndex(operID,"1");
    	    if(spindex==-1){
    	    %>
            <script language="javascript">
              alert("Sorry, you are not an SP operator!")//对不起,您不是SP操作员
              document.URL = 'enter.jsp';
           </script>
           <%
    	    }else{

    	    manage = new Manager();
            syspara   = new  manSysPara();
    	    Hashtable tmph = syspara.getSPCode(String.valueOf(spindex));
    	    String spCode = (String)tmph.get("spcode");
    	    String  spname = (String)tmph.get("spname");
    	    session.setAttribute("SPCODE",spCode);
    	    session.setAttribute("SPNAME",spname);
    	    session.setAttribute("SPINDEX",spindex+"");
            session.setAttribute("OPERNAME",operName);
            session.setAttribute("SERVICEKEY",serviceKey);
            session.setAttribute("OPERID",operID);
            session.setAttribute("PURVIEW",manage.getPurview(operID));
            
            session.setAttribute("OPERATORTYPE","spmanager");
            
            // 记录系统日志
            sysInfo.add(sysTime + operName + " log in SP management system.");//登录SP管理系统
			// 准备写操作员日志
           // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","101");
            map.put("RESULT","1");
            map.put("PARA1","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION","SP Management System");
            purview.writeLog(map);

%>
<form name="loginForm" method="post" action="face.html">
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
     window.document.URL = 'spchangePassword.jsp?indexpage=1';
<%
	}
else if(!PWDMUSTCHANGE1.equals("0"))
	{
		if(res <= 0)
		{
%> 
			window.document.URL = 'spchangePassword.jsp?indexpage=1';
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
<%
           }
        }
        else {
        int ErrorCode = db.geterrorCode();
	    String strMsg =  db.getStrmsg(ErrorCode);
%>
<script language="javascript">
   var str = "<%= strMsg  %>";
   alert('Login failed!\n'+str);//登录系统失败
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ".Exception occurred during login to the system!");//登录系统过程出现异常
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

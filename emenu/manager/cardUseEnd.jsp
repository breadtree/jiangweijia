<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.group.dao.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Back from PHS account opening</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String craccount = "";
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
        String isimp = CrbtUtil.getConfig("isimp","1");

        if (operID != null && purviewList.get("1-4") != null) {
            String oldpwd = "";
            craccount = (String)request.getParameter("craccount");
            zxyw50.Purview purview = new zxyw50.Purview();
            if(!purview.CheckOperatorRight(session,"1-4",craccount)){
               throw new Exception("You have no permission to operate!");
            }
            String userringtype = request.getParameter("userringtype") == null ? "0" : ((String)request.getParameter("userringtype")).trim();
            String newpwd = (String)request.getParameter("newcardpass");
	    String imsurl = request.getParameter("imsurl") == null ? "" : ((String)request.getParameter("imsurl")).trim();
	    	String usertype = request.getParameter("usertype") == null ? "1" : ((String)request.getParameter("usertype")).trim();

	    String nettype = request.getParameter("nettype") == null ? "0" : ((String)request.getParameter("nettype")).trim();//Added for V5.13.01 Iran IMS
		
            String SPCODE_LEN = session.getAttribute("SPCODELEN")==null?"3":(String)session.getAttribute("SPCODELEN");
            int spcodelen = Integer.parseInt(SPCODE_LEN);
            String spcode ="";
            for(int j=0;j<spcodelen;j++)
                spcode+="0";
            QueryResult[] results = DAOFactory.createDefaultDBDAO().execQuery(" select spcode from "+DAOFactory.createDefaultDBDAO().getDBAlias()+"s50spinf where spindex=0");
            if(results[0].next()){
              spcode = results[0].getSafeString(1);
              results[0].release();
            }

            //\u83B7\u53D6\u7528\u6237\u72B6\u6001\u4FE1\u606F
            Hashtable hash = null;
            Hashtable result= new Hashtable();
			manUser manuser = new manUser();
            if("1".equals(isimp)){
               hash = new Hashtable();
               hash.put("craccount",craccount);
               hash.put("level",usertype);  //\u666E\u901A\u7528\u6237          
               hash.put("passwd",newpwd);
               hash.put("opcode","01010101");
               hash.put("userringtype",userringtype);
               hash.put("opmode","b");
               hash.put("ipaddr",operName);
               hash.put("nettype",nettype); //Added for V5.13.01 TCI [Iran]
               SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
               result = SocketPortocol.send(pool,hash);
            }else{
               String inflag = request.getParameter("inflag") == null ? "0" : ((String)request.getParameter("inflag")).trim();
               String serkey = request.getParameter("serkey") == null ? "0" : ((String)request.getParameter("serkey")).trim();
               String scpgt = request.getParameter("scpgt") == null ? "" : ((String)request.getParameter("scpgt")).trim();
               String restInt = (String)request.getParameter("restInt")==null?"0":(String)request.getParameter("restInt").trim();
	       String userkeepnumber = request.getParameter("userkeepnumber") == null ? "" : ((String)request.getParameter("userkeepnumber")).trim();
               hash = new Hashtable();
               hash.put("usernumber",craccount);
               hash.put("inflag",inflag);
               hash.put("serkey",serkey);
               hash.put("scpgt",scpgt);
               hash.put("cardpass",newpwd);
               hash.put("restint",restInt);
               hash.put("operator",operName);
               hash.put("ipaddr",request.getRemoteAddr());
               hash.put("userringtype",userringtype);
               hash.put("spcode",spcode);
			   hash.put("userkeepnumber",userkeepnumber);
	       hash.put("nettype",nettype);//Added for V5.13.01 TCI [Iran]
               manuser.changeCardUse(hash);
            }
			if(!imsurl.equals(""))
			{
               manuser.updateimsurl(craccount,imsurl);
			}
            sysInfo.add(sysTime +"Operator "+ operName +" has opened the account "+ craccount + " successfully!");
            // 准备写操作员日志
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","103");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
%>
<script language="javascript">
   var str = "<%= craccount %>"+",The subscriber has opened an account successfully!"//用户开户成功
   alert(str);
   document.URL = 'cardUse.jsp';
</script>
<%
        }
        else {
            if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
              </script>
            <%
             }
             else{
             %>
                  <script language="javascript">
                       alert( "Sorry. You have no permission for this function!");//You have no access to this function!
                  </script>
                <%

            }
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount + " Error occurred in opening the subscriber account");//用户开户过程出现错误!
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add(craccount + " Error occurred in opening the subscriber account");//用户开户过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="cardUse.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

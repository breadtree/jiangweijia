<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>


<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public String transferString(String str) throws Exception {
        try {
            return (new String(str.getBytes("ISO8859_1"),"ISO8859_1")).trim();
        }
        catch (UnsupportedEncodingException e) {
            throw new Exception (e.getMessage() + "\r\nUnsupported type of characters used!");//使用了不支持的字符类型!
        }
    }
    private Vector StrToVector(String str){
	  int index = 0;
	  String  temp = str;
	  String  temp1 ="";
	  Vector ret = new Vector();
	  if (str.length() ==0)
	      return ret;
	  index = str.indexOf("|");
   	  while(index >= 0){
	      if(index==0)
	         temp1 = "&nbsp;";
	      else
	         temp1 = temp.substring(0,index);
	      ret.addElement(temp1);
		  if(index < temp.length())
		     temp = temp.substring(index+1);
		  else
		     break;
		  index = 0;
		  if (temp.length() > 0)
		     index  = temp.indexOf("|");
	  }
	  return ret;
  }

%>
<script src="../../pubfun/JsFun.js"></script>
<html>
<head>
<title>Order ringtones</title>
<link rel="stylesheet" type="text/css" href="../style.css">
</head>

<body topmargin="0" leftmargin="0" class="body-style1">
<%
String openprint = CrbtUtil.getConfig("openprint","0");
HashMap map = new HashMap();
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String url = "";
 try {
    String phone = "";

    String searchvalue = request.getParameter("searchvalue") == null ? "" : ((String)request.getParameter("searchvalue"));
    String ringidtype = request.getParameter("ringidtype")==null?"1":(String)request.getParameter("ringidtype");
    String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
    String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
    String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
     url = request.getParameter("url") == null ? "collectRing.jsp" : (String)request.getParameter("url");
    sysTime = SocketPortocol.getSysTime() + "--";
    String ringList = request.getParameter("ringList") == null ? "" : ((String)request.getParameter("ringList")).trim();
    String ringname = request.getParameter("ringLabel") == null ? "" : ((String)request.getParameter("ringLabel")).trim();
    Vector vetRing =  new Vector();
    vetRing = StrToVector(ringList);
    Vector vetName = StrToVector(ringname);
    boolean flag = false;
    if(operID!=null){
        String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
        phone = request.getParameter("phone") == null ? "" : ((String)request.getParameter("phone")).trim();
        if(("addring".equals(op)) || ("addsysring".equals(op))){
          manSysPara msp = new manSysPara();
          flag = msp.isAdUser(phone);
        }
        if(!flag){
        if(openprint.equalsIgnoreCase("1"))
          session.setAttribute("usernumber",phone);
	zxyw50.Purview purview = new zxyw50.Purview();
        if(!purview.CheckOperatorRight(session,"13-8",phone)){
             throw new Exception("You have no right to manage this subscriber!");
        }
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        Hashtable hash = null;
        Hashtable result = new Hashtable();
%>
<script language="javascript">
   var hei=450;
   if(parent.frames.length>0){

<%

	if(vetRing==null || vetRing.size()<=5 ){
%>
	hei = 500;
<%
	}else  {
%>
	hei = 500 + (<%= vetRing.size()%>-5)*40;

<%
	}
%>
	parent.document.all.main.style.height=hei;
	}
<%if(openprint.equalsIgnoreCase("1")){%>
function goPrint()
{
  var colURL = '../print.jsp?ringinfo=ringinfo';
  window.open(colURL,'Print','resizable=no,scrollbars=yes,width='+screen.width+', height='+screen.height+',top='+screen.top+',left='+screen.left);
}
<%}%>
</script>
<form name="inputForm" method="post" action="<%=url%>">
<input type="hidden" name="op" value="search" >
<input type="hidden" name="searchkey" value="<%= searchkey %>" >
<input type="hidden" name="searchvalue" value="<%= searchvalue %>" >
<input type="hidden" name="spindex" value="<%= spindex %>" >
<input type="hidden" name="sortby" value="<%= sortby %>" >
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="phone" value="<%= phone %>">
 <input type="hidden" value="<%= ringidtype %>" name="ringidtype">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
<tr>
   <td><img src="../../image/pop013.gif" width="400" height="60"></td>
</tr>
<tr>
   <td><img src="../../image/pop02.gif" width="400" height="26"></td>
</tr>
<tr>
   <td background="../../image/pop03.gif" height="91">
   <table width="98%" cellspacing="1" cellpadding="2" border="0" class="table-style2" align="center">
   <tr>
       <td align="center" colspan=2  height=40>  <font class="font"><b><img src="../../image/n-8.gif" width="8" height="8"> <%= phone %>--Result of ringtone purchase</b></font> </td>
   </tr>
   <tr>
        <td align="center" colspan=2>
        <table width="95%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
        <tr class="tr-ringlist">
        <td width="20%" align="center">Ringtone No.</td>
        <td width="40%" align="center" >Ringtone name</td>
        <td width="40%" align="center">The result of order</td>
        </tr>
        <%
         String ringid = "";
         ringAdm ringadm = null;
         String userringtype = "";
         Hashtable defaultRing =null;
         String defultID  = "";
         String setring = request.getParameter("setring") == null ? "0" : ((String)request.getParameter("setring")).trim();
		 if(!("0".equalsIgnoreCase(setring)))
         {
            //设置默认铃音
		   /* ringadm = new ringAdm();
            userringtype = (String)session.getAttribute("USERRINGTYPE1");
            defaultRing = ringadm.getDefaultRing(phone,userringtype);
            defultID = (String)defaultRing.get("defaultring");
            
            if(userringtype==null)
            {
            	//查询该用户的当前主业务，来自s50cardinfo表的mainsubservice
            	zxyw50.manUser  user = new zxyw50.manUser();
            	//同时访问主被叫帐户，以便获得当前主业务类型
            	Vector myVet  = user.getDesUserInfo(phone,3);
            	Hashtable myHash = null;
            	if (myVet!=null)
            		myHash = (Hashtable)(myVet.get(0));
            	if(myHash !=null)
            	{
            		String mainsubservice = (String)myHash.get("mainsubservice");
            		if("1".equals(mainsubservice))
            			userringtype = "0";     //被叫
            		else if("2".equals(mainsubservice))
            			userringtype = "1";     //主叫
            	}	
			}*/
			Hashtable userinfo=new Hashtable();
			zxyw50.userAdm adm1 = new zxyw50.userAdm();
			userinfo=adm1.getUserInfo(phone);
			String lockid=(String)userinfo.get("lockid");
			String lockid1=(String)userinfo.get("lockid1");
			if(lockid.equals("0")&&(!lockid1.equals("0")))
				 userringtype = "1";//用户为被叫用户
			if(!lockid.equals("0")&&lockid1.equals("0"))
				 userringtype = "2";//用户为主叫用户
			ringadm = new ringAdm();
			//userringtype = (String)session.getAttribute("USERRINGTYPE1");
			defaultRing = ringadm.getDefaultRing(phone,userringtype);
			defultID = (String)defaultRing.get("defaultring");
         }
         for(int i=0;i<vetRing.size()-1;i++){
            ringid = vetRing.get(i).toString();

           hash   = new Hashtable();
            hash.put("opcode","01010905");
            hash.put("craccount",phone);
            hash.put("crid",ringid);
            hash.put("opmode","6");
            hash.put("ipaddr",operName);
            hash.put("ringidtype",ringidtype);
            hash.put("ret1","");
            String  res = " successfully";
            try  {
                            if(openprint.equalsIgnoreCase("1"))
              map.put(ringid.trim(),ringid.trim());
              result = SocketPortocol.send(pool,hash);

		if(!("0".equalsIgnoreCase(setring)))
         {
           if(defultID.indexOf("99")==0){
               Hashtable hash1 = new Hashtable();
               hash1.put("usernumber",phone);
               hash1.put("ringgroup",defultID);
               hash1.put("ringid",ringid);
               ringadm.addRingInGroup(hash1);
               res+="(Add to ring group)";
           }else{
             if(i==0)
             {
				 if(!userringtype.equals(setring)){
					 String strResult1 = " be not set to the default ringtone , the default ringtone's type which you want to set is not same to service type you hava applied ";
					 res+="("+ringid+strResult1+")";
				 }
				 else{
               SocketPool pool1 = (SocketPool)application.getAttribute("SOCKETPOOL");
               Hashtable result1 = new Hashtable();
               hash = new Hashtable();
               hash.put("opcode","01010947");
               hash.put("craccount",phone);
               hash.put("crid",ringid);
               hash.put("callingnum","");
               hash.put("starttime","00:00:00");
               hash.put("endtime","23:59:59");
               hash.put("startdate","2000.01.01");
               hash.put("enddate","2999.12.31");
               hash.put("startweek","01");
               hash.put("endweek","07");
               hash.put("startday","01");
               hash.put("endday","31");
               
	       if("2".equals(userringtype))
               hash.put("callingtype","100");
               else
               hash.put("callingtype","0");
               hash.put("settype","0");
               hash.put("opertype","0");
               if("3".equals(ringidtype))
               hash.put("ringidtype","3");
               else if("2".equals(ringidtype))
               hash.put("ringidtype","2");
               else
               hash.put("ringidtype","1");
               hash.put("description","");
               hash.put("setno","");
               hash.put("setpri","");
               result1 = SocketPortocol.send(pool1,hash);
               res+="("+ringid+" has been set to the default ringtone)";
             }
           }
           }
            }
 }
            catch (Exception ex){
               res = "Failure," + ex.getMessage();
            }
            sysInfo.add(sysTime + operName + " order ringtone in manual plat for subscriber of" + phone + " " + ringid + res );
            String color = i == 0 ? "E6ECFF" :"#FFFFFF" ;
            out.print("<tr bgcolor='"+color+"'>");
            out.print("<td >"+ringid+"</td>");
            
            String tmpStr = vetName.get(i).toString();
            if(tmpStr.length()>20)
            	tmpStr = tmpStr.substring(0,20)+" "+tmpStr.substring(20,tmpStr.length());
            
            out.print("<td >"+tmpStr+"</td>");
            out.print("<td >" + res + "</td>");
            out.print("</tr>");

        }
          if(openprint.equalsIgnoreCase("1"))
          session.setAttribute("map",map);
      %>

      </table>
      <tr>
      <td align="center" colspan=2>
          <img src="../button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:submit()">
    <%if(openprint.equalsIgnoreCase("1") && op.trim().equalsIgnoreCase("addring")){%>
          <img src="../button/print.gif" onmouseover="this.style.cursor='hand'" onclick="goPrint()">
    <%}%>
      </td>
      </tr>
    </table>
    </tr>
	    <tr>
      <td><img src="../../image/pop04.gif" width="400" height="23"></td>
    </tr>
  </table>
  <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
    <tr>
      <td>&nbsp;</td>
  </tr>
</table>
</form>
<%
           } else {
%>
              <script language="javascript">
                   var str = 'Sorry! the number '+<%= phone %>+' you entered is ad subscriber,can not use the system!';
                   alert(str);
                   document.URL = '<%=url%>';
              </script>
<%
           }
        }
         else{
%>
<script language="javascript">
 	alert('Please log in first!');//请先登录
	document.location.href = '../enter.jsp';
</script>
<%
    }
   }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime +  ",Exception occurred in searching ringtone!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Errors occurred in searching ringtone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
                     if(url.toLowerCase().indexOf("manualsvc")==-1)
       url = "manualSvc/"+url;
%>
</form>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="<%=url%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
 %>
</body>
</html>

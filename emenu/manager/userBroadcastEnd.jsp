<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manUser" %>


<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public String transferString(String str) throws Exception {
      return str;

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
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<title>Operation AD broadcast</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>

<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String phone = "";

    sysTime = manUser.getSysTime() + "--";
    String sUserList = request.getParameter("userlist") == null ? "" : ((String)request.getParameter("userlist")).trim();
    Vector vetRing =  new Vector();
    vetRing = StrToVector(sUserList);
    if(operID!=null){
        String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
        String sMessage = request.getParameter("message") == null ? "0" : transferString((String)request.getParameter("message"));

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
	hei = 500 + (<%= vetRing.size()%>-5)*15;

<%
	}
%>
	parent.document.all.main.style.height=hei;
	}
</script>
<form name="inputForm" method="post" action="userBroadcast.jsp">
<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" height="200">
<tr>
   <td><img src="../image/pop013.gif" width="400" height="60"></td>
</tr>
<tr>
   <td><img src="../image/pop02.gif" width="400" height="26"></td>
</tr>
<tr>
   <td background="../image/pop03.gif" height="91">
   <table width="98%" cellspacing="1" cellpadding="2" border="0" class="table-style2" align="center">
   <tr>
       <td align="center" colspan=2  height=40>  <font class="font"><b><img src="../image/n-8.gif" width="8" height="8"> Operation AD broadcast</b></font> </td>
   </tr>
   <tr>
        <td align="center" colspan=2>
        <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
        <tr class="tr-ringlist">
        <td width="40" align="center">Index</td>
        <td width="80" align="center" >Subscriber number</td>
        <td align="center">Result</td>
        </tr>
        <%
         String sUserNumber = "";
         manUser manuser = new manUser();
         HashMap  map = null;
         for(int i=0;i<vetRing.size()-1;i++){
            sUserNumber = vetRing.get(i).toString();
            String  res = "Success";
            try  {
                manuser.sendMessage(sUserNumber,sMessage);
            }
            catch (Exception ex){
               res = "Failure," + ex.getMessage();
            }
            sysInfo.add(sysTime + operName + " send SMS "+ sMessage + " to " + sUserNumber + res );
            String color = i == 0 ? "E6ECFF" :"#FFFFFF" ;
            out.print("<tr bgcolor='"+color+"'>");
            out.print("<td >"+Integer.toString(i+1)+"</td>");
            out.print("<td >"+sUserNumber+"</td>");
            out.print("<td >" + res + "</td>");
            out.print("</tr>");

             // 准备写操作员日志
            zxyw50.Purview purview = new zxyw50.Purview();
            map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","107");
            map.put("RESULT","1");
            map.put("PARA1",sUserNumber);
            map.put("PARA2","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION",sMessage);
            purview.writeLog(map);
        }
      %>

      </table>
      <tr>
      <td align="center" colspan=2>
          <img src="../button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:submit()">
      </td>
      </tr>
    </table>
    </tr>
	    <tr>
      <td><img src="../image/pop04.gif" width="400" height="23"></td>
    </tr>
  </table>
  <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
    <tr>
      <td>&nbsp;</td>
  </tr>
</table>
</form>
<%
        }
         else{
%>
<script language="javascript">
 	alert('Please log in to the system first!');
	document.location.href = 'enter.jsp';
</script>
<%
    }
 %>
</body>
</html>

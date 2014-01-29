<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysRing" %>


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
<title>Subscribers order ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>

<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String phone = "";

    String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
    String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
    String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
    String scp = request.getParameter("scplist") == null ? "" : (String)request.getParameter("scplist");
    sysTime = manSysRing.getSysTime() + "--";
    String ringList = request.getParameter("ringList") == null ? "" : ((String)request.getParameter("ringList")).trim();
    String ringname = request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel")).trim();
    Vector vetRing =  new Vector();
    vetRing = StrToVector(ringList);
    Vector vetName = StrToVector(ringname);
    if(operID!=null){
        String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
        String price = request.getParameter("price") == null ? "0" : transferString((String)request.getParameter("price"));
        String ringlib = request.getParameter("ringlib") == null ? "503" : (String)request.getParameter("ringlib");
        String validate = request.getParameter("validate") == null ? "" : (String)request.getParameter("validate");
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
<form name="inputForm" method="post" action="ringUpdate.jsp">
<input type="hidden" name="op" value="search" >
<input type="hidden" name="searchkey" value="<%= searchkey %>" >
<input type="hidden" name="searchvalue" value="<%= searchvalue %>" >
<input type="hidden" name="sortby" value="<%= sortby %>" >
<input type="hidden" name="scplist" value="<%= scp %>" >
<input type="hidden" name="page" value="<%= thepage %>">
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
       <td align="center" colspan=2  height=40>  <font class="font"><b><img src="../image/n-8.gif" width="8" height="8">Personal ringtone transform to system ringtone</b></font> </td>
   </tr>
   <tr>
        <td align="center" colspan=2>
        <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
        <tr class="tr-ringlist">
        <td width="40" align="center">No. of ringtone</td>
        <td width="100" align="center" >Ringtone name</td>
        <td align="center">Result of transform</td>
        </tr>
        <%
         String ringid = "";
         manSysRing sysring = new manSysRing();
         zxyw50.Purview purview = new zxyw50.Purview();
         HashMap  map = null;
         for(int i=0;i<vetRing.size()-1;i++){
            ringid = vetRing.get(i).toString();
            map   = new HashMap();
            map.put("scp", scp);
            map.put("ringid",   ringid);
            map.put("price",    price);
            map.put("ringlib",  ringlib);
            map.put("validate", validate);
                            //begin add 用户有效期
            map.put("uservalidday",request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday"));
                //end
            String  res = "Success";
            int flag = 1;
            try  {
                sysring.updatePersonalRing(map);
            }
            catch (Exception ex){
               res = "Failure," + ex.getMessage();
               flag = 0;
            }
            sysInfo.add(sysTime + operName + " transform personal ringtone " + ringid + " to system ringtone " + res );
            String color = i == 0 ? "E6ECFF" :"#FFFFFF" ;
            out.print("<tr bgcolor='"+color+"'>");
            out.print("<td >"+ringid+"</td>");
            out.print("<td >"+vetName.get(i).toString()+"</td>");
            out.print("<td >" + res + "</td>");
            out.print("</tr>");
            if(flag==1){
              map = new HashMap();
              map.put("OPERID",operID);
              map.put("OPERNAME",operName);
              map.put("OPERTYPE","16");
              map.put("RESULT","1");
              map.put("PARA1",ringid);
              map.put("PARA2",price);
              map.put("PARA3",ringlib);
              map.put("PARA4",validate);
              map.put("PARA5","ip:"+request.getRemoteAddr());
              purview.writeLog(map);
            }
            sysInfo.add(sysTime + operName + " transform personal ringtone " + ringid + " to system ringtone " + res );

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
 	alert("Please log in first!");
	document.location.href = 'enter.jsp';
</script>
<%
    }
 %>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>


<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />

<script language="JavaScript">
    function  initform(fm){
      if(parseInt(fm.checkflag.value)==1)
          fm.checkTime.checked = true;
     else
         fm.checkTime.checked = false;
     onCheckTime();
    }

	function searchInfo(){
		document.InputForm.op.value="1";
		document.InputForm.submit();
	}
</script>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

   String sysTime = "";
   Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
   String operID = (String)session.getAttribute("OPERID");
   String operName = (String)session.getAttribute("OPERNAME");
	String op = request.getParameter("op")==null?"0":(String)request.getParameter("op");
   Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
   String spIndex = (String)session.getAttribute("SPINDEX");

	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


	try {
       String  errmsg = "";
       boolean flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
       else if (spIndex  == null || spIndex.equals("-1")){
          errmsg = "Sorry, you are not an SP administrator!";//Sorry,you are not the SP administrator
          flag = false;
       }
       else if (purviewList.get("9-4") == null) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
       if(flag ){
          Hashtable tmph = new Hashtable();
	      tmph = db.getSPConf(spIndex);
	      String spcode = (String)tmph.get("spcode");
	      String spName = (String)tmph.get("spname");
          Hashtable map = new Hashtable();
		  map = db.spSysStat(spcode);
%>

<html>
<head>
<title>Service development statistics</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
</head>
<body background="background.gif" class="body-style1">
<script language="JavaScript">

	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post">
<input type="hidden" name="op" value="">

<table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2" height="400" align="center">
   <tr>
   <td width="100%" valign="top">
   <table width="100%" class="table-style2">
   <tr>
          <td   height="50" align="center" class="text-title">SP <%= spName.length()>0?spName:""%> System statistics</td>
   </tr>
   <tr>
    <td align="center" valign="top">
      <table border="1" width="90%" cellspacing="0" cellpadding="0" class="table-style2" >
        <tr class="table-title1">
            <td width="40%" height="24"><em></em>Statistics Item</td>
          <td width="30%" height="24">Statistics Values</td>
          <td width="30%" height="24">Unit</td>
        </tr>
        <%
         if(map.size()>0){
          out.println("<tr>");
            out.println("<td>Number of "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+"s ordered</td>");
            out.println("<td align=right>" + (String)map.get("buyrings")+"</td>");
            out.println("<td align=right>Entries</td>");
          out.println("</tr>");
          out.println("<tr>");
            out.println("<td>Number of "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+"s never being ordered</td>");
            out.println("<td align=right>" + (String)map.get("nobuyrings")+"</td>");
            out.println("<td align=right>Entries</td>");
          out.println("</tr>");
		  out.println("<tr>");
            out.println("<td>Total number of " +zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+"s</td>");
            out.println("<td align=right>" + (String)map.get("ringnum")+"</td>");
            out.println("<td align=right>Entries</td>");
          out.println("</tr>");
          out.println("<tr>");
            out.println("<td>"+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" ordering ratio</td>");
            out.println("<td align=right>" + (String)map.get("scale")+"</td>");
            out.println("<td align=right>%</td>");
          out.println("</tr>");
          out.println("<tr>");
            out.println("<td>Total number of "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" uploads</td>");
            out.println("<td align=right>" + (String)map.get("uploadnum")+"</td>");
            out.println("<td align=right>Times</td>");
          out.println("</tr>");
          out.println("<tr>");
            out.println("<td>Total size of "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+"s</td>");
            out.println("<td align=right>" + (String)map.get("totalsize")+"</td>");
            out.println("<td align=right>MB</td>");
          out.println("</tr>");
          out.println("<tr>");
            out.println("<td>Number of passed verifications</td>");
            out.println("<td align=right>" + (String)map.get("checkrings")+"</td>");
            out.println("<td align=right>Times</td>");
          out.println("</tr>");
		  out.println("<tr>");
            out.println("<td>Number of failed verifications</td>");
            out.println("<td align=right>" + (String)map.get("nocheckrings")+"</td>");
            out.println("<td align=right>Times</td>");
          out.println("</tr>");
           out.println("<tr>");
            out.println("<td>Verification ratio</td>");
            out.println("<td align=right>" + (String)map.get("checkscale")+"</td>");
            out.println("<td align=right>%</td>");
          out.println("</tr>");
          out.println("<tr>");
          out.println("<td>Service income during the last month</td>");
          String strfee = (String)map.get("fee")==null?"":(String)map.get("fee");
			if(strfee.length()==0){
					out.println("<td align=right>"+strfee+"</td>");
			}
			else{
					//float fee = Float.parseFloat(strfee);
					out.println("<td align=right>"+displayFee(strfee)+"</td>");

			}
          out.println("<td align=right>"+majorcurrency+"</td>");
          out.println("</tr>");
       }
      else{ %>
	  <tr><td align="center" colspan="3">The statistics task is not running. No statistics result now</td></tr>
	 <%} %>
      </table>
    </td>
  </tr>
  </table>
  </tr>
  </td>
</table>
</form>
<%
        }
        else {
%>
<script language="javascript">
   var errmsg = '<%= operID!=null?errmsg:"Please log in to the system first!"%>';
   alert(errmsg);
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ",Exception occurred in querying the SP service statistics!");//sp业务统计查询过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in querying the SP service statistics!");//sp业务统计查询过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spSysStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

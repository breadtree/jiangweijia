<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manStatUser" %>
<%@ page import="zxyw50.CrbtUtil" %>


<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");



    try {
       String  errmsg = "";
       boolean flag =true;
       	zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
       else if (purviewList.get("4-41") == null || (!purview.CheckOperatorRightAllSerno(session,"4-3"))) {
         errmsg = "You have no access to this function!";
         flag = false;
       }
       if(flag){
          Hashtable map = new Hashtable();
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          manStatUser manstatuser = new manStatUser();
         map = manstatuser.getUserCallerStat();
       	 if(op.equals("bakdata")){
        	//map=(Hashtable)session.getAttribute("ResultSession");

    		response.setContentType("application/msexcel");
		response.setHeader("Content-disposition","inline; filename=userCallStat.xls");
             	out.clear();
             	out.println("<table border='1'>");
    		out.println("<tr><td>Statistics items</td><td>Statistical values</td></tr>");
 		out.println("<tr><td>Current number of subscribers</td><td>" + (String)map.get("userNumber")+"</td></tr>");
          	out.println("<tr><td>Current number of subscribers setting callers</td><td>" + (String)map.get("userCallerNumber")+"</td></tr>");
          	out.println("<tr><td>Average number of callers in subscriber's profile</td><td>" + (String)map.get("userCallerAvg")+"</td></tr>");

               	out.println("</table>");
                map.clear();
        	return;
      	    }


 %>

<html>
<head>
<title>User caller set statistics</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<form name="inputForm" method="post">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";

function WriteDataInExcel(){
 <% if(map==null || map.size()<1){ %>
      alert("No data,no output!");
      return;
 <% }else{%>
      var fm = document.inputForm;
      fm.op.value = 'bakdata';
      fm.target="top";
      fm.submit();
  <%}%>
   }
</script>
<table border="0" width="100%"  height="400" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr>
   <td valign="top" width="100%">
   <table width="100%">
   <tr >
          <td height="26"  align="center" class="text-title"  background="image/n-9.gif">Service profit statistics</td>
   </tr>
   <tr >
          <td   align="right" class="text-title" ><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()"  title="export in excel file">&nbsp;&nbsp;</td>
   </tr>
      <tr>
    <td align="center" valign="top">
      <table border="1" width="80%" cellspacing="0" cellpadding="0" class="table-style2" bordercolorlight="#000000" bordercolordark="#FFFFFF">
        <tr class="table-title1" >
          <td width="70%" height="24">Statistics items</td>
          <td width="30%" height="24">Statistical values</td>
        </tr>
        <%
         if(map.size()>0){
          out.println("<tr height=23 >");
            out.println("<td>Current number of subscribers</td>");
            out.println("<td align=right>" + (String)map.get("userNumber")+"&nbsp;</td>");
          out.println("</tr>");
          out.println("<tr height=23>");
            out.println("<td>Current number of subscribers setting callers</td>");
            out.println("<td align=right>" + (String)map.get("userCallerNumber")+"&nbsp;</td>");
          out.println("</tr>");
          out.println("<tr height=23>");
            out.println("<td>Average number of callers in subscriber's profile</td>");
            out.println("<td align=right>" + (String)map.get("userCallerAvg")+"&nbsp;</td>");
          out.println("</tr>");

          //session.setAttribute("ResultSession",map);

       }

       %>
      </table>
    </td>
  </tr>
  </table>
  </td>
  </tr>
</table>
</form>
<%
        }
        else {
%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in the statistics on the service profit!");//业务收益统计过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in the statistics on the service profit!");//业务收益统计过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="StatUserCaller.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

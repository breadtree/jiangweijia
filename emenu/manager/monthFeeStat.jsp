<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manStat" %>

<%!
    public String displayFee (String ringFee) {
        int len;
        if (ringFee.length() == 1)
            ringFee = "00" + ringFee;
        if (ringFee.length() == 2)
            ringFee = "0" + ringFee;
        len = ringFee.length();
        return ringFee.substring(0,len - 2) + "." + ringFee.substring(len - 2);
    }

    
%>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ifsetfee = (String)application.getAttribute("IFSETFEE")==null?"0":(String)application.getAttribute("IFSETFEE");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
       String  errmsg = "";
       boolean flag =true;
       	zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
       else if (purviewList.get("4-19") == null || (!purview.CheckOperatorRightAllSerno(session,"4-19"))) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
       if(flag){
         manStat manstat = new manStat();
         Hashtable map = new Hashtable();
         map = manstat.getMonthFeeStat();

 %>

<html>
<head>
<title>Month service profit statistics</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<form name="inputForm" method="post">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<table border="0" width="100%"  height="400" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr>
   <td valign="top" width="100%">
   <table width="100%">
   <tr >
          <td height="26"  align="center" class="text-title"  background="image/n-9.gif">Month service profit statistics</td>
   </tr>
   <tr>
    <td align="center" valign="top">
      <table border="1" width="70%" cellspacing="0" cellpadding="0" class="table-style2" bordercolorlight="#000000" bordercolordark="#FFFFFF">
        <tr class="table-title1" >
          <td width="40%" height="24">Statistics items</td>
          <td width="30%" height="24">Statistical values</td>
          <td width="30%" height="24">unit</td>
        </tr>
        <%
         if(map.size()>0){
          out.println("<tr height=23 >");
            out.println("<td>Total number of this month subscriber</td>");
            out.println("<td align=right>" + (String)map.get("totalnum")+"  &nbsp;</td>");
            out.println("<td align=right>person  &nbsp;</td>");
          out.println("</tr>");
          out.println("<tr height=23>");
            out.println("<td>Numbers of success take out fee in this month</td>");
            out.println("<td align=right>" + (String)map.get("successednum")+"  &nbsp;</td>");
            out.println("<td align=right>person  &nbsp;</td>");
          out.println("</tr>");
          out.println("<tr height=23>");
            out.println("<td>Numbers of fail take out fee in this month</td>");
            out.println("<td align=right>" + (String)map.get("failednum")+"  &nbsp;</td>");
            out.println("<td align=right>person  &nbsp;</td>");
          out.println("</tr>");
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
        sysInfo.add(sysTime + operName + " Exception occurred in the statistics on the month service profit!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in the statistics on the month service profit!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="monthFeeStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

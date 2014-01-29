<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.CrbtUtil" %>

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
       else if (purviewList.get("4-9") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-9"))) {
         errmsg = "You have no access to this function!";
         flag = false;
       }
       if(flag){
         HashMap map = null;
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();

         if(op.equals("bakdata")){
        	ArrayList al=(ArrayList)session.getAttribute("ResultSession");
                ArrayList a2=(ArrayList)session.getAttribute("ResultSession1");

    		response.setContentType("application/msexcel");
		response.setHeader("Content-disposition","inline; filename=cur_subscriber_stat.xls");
             	out.clear();
                out.println("<table >");
                out.println("<tr><td>");
             	out.println("<table border='1'>");
    		out.println("<tr><td>SCP</td><td>Total number of subscribers</td><td>Number of subscribers in the activated status</td><td>Number of subscribers in the disabled status</td><td>Number of subscribers in the forcedly deactivated status</td></tr>");
            	for (int i = 0; i <al.size(); i++) {
			map = (HashMap)al.get(i);
                  	out.println("<tr><td>"+(String)map.get("scp")+"</td><td>"+(String)map.get("totaluser")+"</td><td>"+(String)map.get("activeuser")+"</td><td>"+(String)map.get("inactiveuser")+"</td><td>"+(String)map.get("forceuser")+"</td></tr>");
               	}
               	out.println("</table>");
                out.println("</tr></td>");
                if("1".equals(CrbtUtil.getConfig("usecalling","0"))){
                  out.println("<tr><td>");
                  out.println("<table border='1'>");
                  out.println("<tr><td>SCP</td><td>Calling subscriber number</td><td>Calling account opening number</td><td>Calling account opening/cancellation</td></tr>");
                  for (int i = 0; i <a2.size(); i++) {
                    map = (HashMap)a2.get(i);
                    out.println("<tr><td>"+(String)map.get("scp")+"</td><td>"+(String)map.get("totaluser1")+"</td><td>"+(String)map.get("activeuser1")+"</td><td>"+(String)map.get("inactiveuser1")+"</td><td>");
                  }
                  out.println("</tr></td>");
                  out.println("</table>");
                }
                out.println("</table>");
                //al.clear();
        	return;

      	  }
         ArrayList rList = new ArrayList();
         manStat manstat = new manStat();
         rList = manstat.getSysTotalUsers();

 %>

<html>
<head>
<title>Query current number of subscribers in the system</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<form name="inputForm" method="post">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";


  function WriteDataInExcel(){
 <% if(rList==null || rList.size()<1){ %>
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
   <td valign="middle" width="100%">
   <table width="100%">
    <tr >
          <td height="26" >&nbsp;</td>
   </tr>
   <tr >
          <td height="26"  align="center" class="text-title" >Query current number of subscribers<br>in the system</td>
   </tr>
  <tr >
          <td height="26"  align="right" class="text-title" ><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()" title="export in excel file">&nbsp;&nbsp;</td>
   </tr>   <tr>
    <td align="center" valign="top">
      <table border="1" width="90%" cellspacing="0" cellpadding="0" class="table-style2" bordercolorlight="#000000" bordercolordark="#FFFFFF">
        <tr class="table-title1" height=30>
          <td width="10%" height="24"><span title="SCP">SCP</span></td>
          <td width="20%" height="24"><span title="Total number of subscribers">Total</span></td>
          <td width="20%" height="24"><span title="Number of subscribers in the activated status">Activated</span></td>
          <td width="20%" height="24"><span title="Number of subscribers in the disabled status">Disabled</span></td>
          <td width="30%" height="24"><span title="Number of subscribers in the forcedly deactivated status">Forcedly deactivated</span></td>
        </tr>
        <%
          for(int i=0; i<rList.size(); i++){
            map = (HashMap)rList.get(i);
            out.println("<tr height=30>");
            out.println("<td align=center>" + (String)map.get("scp")+"</td>");
            out.println("<td align=center>" + (String)map.get("totaluser")+"</td>");
            out.println("<td align=center>" + (String)map.get("activeuser")+"</td>");
            out.println("<td align=center>" + (String)map.get("inactiveuser")+"</td>");
            out.println("<td align=center>" + (String)map.get("forceuser")+"</td>");
            out.println("</tr>");
        }
            session.setAttribute("ResultSession",rList);

        %>


      </table>
    </td>
  </tr>
  <%
  if("1".equals(CrbtUtil.getConfig("usecalling","0"))){
             ArrayList rList1 = manstat.getSysTotalUsers1();
  %>
<tr>
    <td align="center" valign="top">
      <table border="1" width="90%" cellspacing="0" cellpadding="0" class="table-style2" bordercolorlight="#000000" bordercolordark="#FFFFFF">
        <tr class="table-title1" height=30>
          <td width="10%" height="24">SCP</td>
          <td width="20%" height="24">Calling subscriber number</td>
          <td width="20%" height="24">Calling subscriber opening number</td>
          <td width="20%" height="24">Calling subscriber cancellation number</td>
        </tr>
        <%
          for(int i=0; i<rList1.size(); i++){
            map = (HashMap)rList1.get(i);
            out.println("<tr height=30>");
            out.println("<td align=center>" + (String)map.get("scp")+"</td>");
            out.println("<td align=center>" + (String)map.get("totaluser1")+"</td>");
            out.println("<td align=center>" + (String)map.get("activeuser1")+"</td>");
            out.println("<td align=center>" + (String)map.get("inactiveuser1")+"</td>");
            out.println("</tr>");
        }
        %>
      </table>
    </td>
  </tr>
  <%
  session.setAttribute("ResultSession1",rList1);
}%>

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
        sysInfo.add(sysTime + operName + " exception occurred in querying the current number of subscribers in the system!");//系统当前用户数查询过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in querying the current number of subscribers in the system");//系统当前用户数查询过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="feeStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

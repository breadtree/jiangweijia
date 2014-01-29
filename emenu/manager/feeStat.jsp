<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.XlsNameGenerate"%>

<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ifsetfee = (String)application.getAttribute("IFSETFEE")==null?"0":(String)application.getAttribute("IFSETFEE");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


    try {
       String  errmsg = "";
       boolean flag =true;
       	zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
       else if (purviewList.get("4-3") == null || (!purview.CheckOperatorRightAllSerno(session,"4-3"))) {
         errmsg = "You have no access to this function!";
         flag = false;
       }
       if(flag){
          Hashtable map = new Hashtable();
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          manStat manstat = new manStat();
          map = manstat.getFeeStat();// 查询
          if(op.equals("bakdata")){        // 导出
            response.setContentType("application/msexcel");
            String file_name = XlsNameGenerate.get_xls_filename("", "", "feeStat", XlsNameGenerate.STATISTIC_NONE);
            response.setHeader("Content-disposition","inline; filename=" + file_name);
            out.clear();
            out.println("<table border='1'>");
            out.println("<tr><td>Statistics items</td><td>Statistical values</td><td>unit</td></tr>");
            out.println("<tr><td>Total number of<br>uploaded ringtones</td><td>" + (String)map.get("curnumber")+"</td><td>item&nbsp;</td></tr>");
            out.println("<tr><td>Total income last month</td><td>" + displayFee((String)map.get("totalfee"))+"</td><td>" + majorcurrency + "</td></tr>");
            out.println("<tr><td>Ringtone customization fee</td><td>" + displayFee((String)map.get("buyfee"))+"</td><td>" + majorcurrency +"</td></tr>");
            out.println("<tr><td>Upload fee</td><td>" + displayFee((String)map.get("uploadfee"))+"</td><td>"  + majorcurrency+ "</td></tr>");
            if(ifsetfee.equals("1")){
              out.println("<tr><td>Setting change fee</td><td>" + displayFee((String)map.get("modsetfee"))+"</td><td>" + majorcurrency + "</td></tr>");
            }
            out.println("<tr><td>Income from the function usage fee</td><td>" + displayFee((String)map.get("rentfee"))+"</td><td>"+ majorcurrency +"</td></tr>");
            long discountfee = Integer.parseInt((String)map.get("discountfee"));
            if(discountfee > 0){
              out.println("<tr><td>Income from the ringtone package</td><td>" + displayFee((String)map.get("discountfee"))+"</td><td>" + majorcurrency +"</td></tr>");
            }
            out.println("<tr><td>Net income</td><td>" + displayFee((String)map.get("agentfee"))+"</td><td>" +majorcurrency +"</td></tr>");
            out.println("<tr><td>Net income/Total income</td><td>" + (String)map.get("scale")+"</td><td>%</td></tr>");

            out.println("</table>");
            return;
          }


 %>

<html>
<head>
<title>Service profit statistics</title>
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
   <td valign="middle" width="100%">
   <table width="100%">
    <tr >
          <td height="26" >&nbsp;</td>
   </tr>
   <tr >
          <td height="26"  align="center" class="text-title" >Service profit statistics</td>
   </tr>
   <tr >
          <td   align="right" class="text-title" ><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()"  title="export in excel file">&nbsp;&nbsp;</td>
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
            out.println("<td>Total number of<br>uploaded ringtones</td>");
            out.println("<td align=right>" + (String)map.get("curnumber")+"&nbsp;</td>");
            out.println("<td align=right>item&nbsp;</td>");
          out.println("</tr>");
          out.println("<tr height=23>");
            out.println("<td>Total income last month</td>");
            out.println("<td align=right>" + displayFee((String)map.get("totalfee"))+"&nbsp;</td>");
            out.println("<td align=right>"+ majorcurrency +"&nbsp;</td>");
          out.println("</tr>");
          out.println("<tr height=23>");
            out.println("<td>Ringtone customization fee</td>");
            out.println("<td align=right>" + displayFee((String)map.get("buyfee"))+"&nbsp;</td>");
            out.println("<td align=right>"+majorcurrency+"&nbsp;</td>");
          out.println("</tr>");
          out.println("<tr height=23>");
            out.println("<td>Upload fee</td>");
            out.println("<td align=right>" + displayFee((String)map.get("uploadfee"))+"&nbsp;</td>");
            out.println("<td align=right>" + majorcurrency +"&nbsp;</td>");
          out.println("</tr>");
          if(ifsetfee.equals("1")){
              out.println("<tr height=23>");
              out.println("<td>Setting change fee</td>");
              out.println("<td align=right>" + displayFee((String)map.get("modsetfee"))+"&nbsp;</td>");
              out.println("<td align=right>"+ majorcurrency +"&nbsp;</td>");
              out.println("</tr>");
          }
          out.println("<tr height=23>");
            out.println("<td>Income from the function usage fee</td>");
            out.println("<td align=right>" + displayFee((String)map.get("rentfee"))+"&nbsp;</td>");
            out.println("<td align=right>"+ majorcurrency+"&nbsp;</td>");
          out.println("</tr>");
          long discountfee = Integer.parseInt((String)map.get("discountfee"));
          if(discountfee > 0){
            out.println("<tr height=23>");
                out.println("<td>Income from the ringtone package</td>");
                out.println("<td align=right>" + displayFee((String)map.get("discountfee"))+"&nbsp;</td>");
                out.println("<td align=right>"+ majorcurrency +"&nbsp;</td>");
            out.println("</tr>");
          }
          out.println("<tr height=23>");
            out.println("<td>Net income</td>");
            out.println("<td align=right>" + displayFee((String)map.get("agentfee"))+"&nbsp;</td>");
            out.println("<td align=right>" +majorcurrency+"&nbsp;</td>");
          out.println("</tr>");
          out.println("<tr height=23>");
            out.println("<td>Net income/Total income</td>");
            out.println("<td align=right>" + (String)map.get("scale")+"&nbsp;</td>");
            out.println("<td align=right>%&nbsp;</td>");
          out.println("</tr>");
          session.setAttribute("ResultSession",map);

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

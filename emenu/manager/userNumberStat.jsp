<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.manStatUser"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
    String giftbag   = CrbtUtil.getConfig("giftname","giftbag");
    try {
        ArrayList arraylist = null;
        ArrayList opermodelist = null;
        HashMap   map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        Calendar showdate = Calendar.getInstance();
        showdate.add(Calendar.DATE ,-7);
        SimpleDateFormat formate = new SimpleDateFormat("yyyy.MM.dd");
        String qrydate = formate.format(showdate.getTime());

	zxyw50.Purview purview = new zxyw50.Purview();
        if (purviewList.get("4-33") == null  ) {
          errmsg = "You have no access to this function!";//You have no access to this function
          flag = false;
         }
       if (operID  == null){
          errmsg = "Please log in first!";//Please log in to the system
          flag = false;
       }
       if(flag){
          String startday = qrydate;
          Hashtable hash = null;
          String  optSCP = "";
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
          manStatUser statuser = new manStatUser();
          String  total ="";
          if(op.equals("search") || op.equals("bakdata")){
             startday = request.getParameter("start") == null ? qrydate : ((String)request.getParameter("start")).trim();
            // String usertype = request.getParameter("usertype") == null ? "" : ((String)request.getParameter("usertype")).trim();
             map.put("scp",scp);
             map.put("startday",startday);
             //map.put("usertype",usertype);
             map.put("statperiod","2");//1,day ; 2,week
             map = statuser.userChangeStat(map);
          }
           if(op.equals("bakdata")){
              response.setContentType("application/msexcel");
              String file_name = XlsNameGenerate.get_xls_filename(startday, startday, "userNumber", XlsNameGenerate.STATISTIC_DAY);
              response.setHeader("Content-disposition","inline; filename=" + file_name);
              out.clear();
              out.println("<table border='1'>");
             if(map.size()>0){
                out.print("<tr>");
                out.print("<td align=left>Total No. of  Paying Customers</td>");
                String str1 = map.get("GSM_payuser")==null?"":map.get("GSM_payuser").toString().trim();
                int num1 = str1.length()==0?0:Integer.parseInt(str1);
                str1 = map.get("PSTN_payuser")==null?"":map.get("PSTN_payuser").toString().trim();
                int num2 = str1.length()==0?0:Integer.parseInt(str1);
                out.print("<td align=center>"+(num1+num2)+"</td>");
                out.print("</tr>\n<tr>");
                out.print("<td align=left>Total No. of  Customers With Free Subscription</td>");
                str1 = map.get("GSM_freeuser")==null?"":map.get("GSM_freeuser").toString().trim();
                num1 = str1.length()==0?0:Integer.parseInt(str1);
                str1 = map.get("PSTN_freeuser")==null?"":map.get("PSTN_freeuser").toString().trim();
                num2 = str1.length()==0?0:Integer.parseInt(str1);
                out.print("<td align=center>"+(num1+num2)+"</td>");
                out.print("</tr>");
             }
             out.println("</table>");
             return;
      	  }

          ArrayList scplist = statuser.getScpList();
          for (int i = 0; i < scplist.size(); i++)
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
 %>

<html>
<head>
<title>User Number Statistic Weekly</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<body background="background.gif" class="body-style1" >

<script language="javascript">

   function checkInfo () {
      var fm = document.inputForm;
      var tmp = '';
         if (trim(fm.startday.value) == '') {
            alert('Please enter the start time!');//请输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
            alert('Invalid start time entered. \r\n Please enter the start time in the YYYY.MM.DD format');//起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
            alert('Start time cannot be later than the current time!');//起始时间不能大于当前时间
            fm.startday.focus();
            return false;
         }
         fm.start.value = tmp = trim(fm.startday.value);
      return true;
   }

   function searchInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'search';
      fm.target="_self";
      fm.submit();
   }
  function WriteDataInExcel(){
 if (! checkInfo())
         return;
      var fm = document.inputForm;
      fm.op.value = 'bakdata';
      fm.target="top";
      fm.submit();
   }


</script>
<form name="inputForm" method="post" action="userNumberStat.jsp">
<input type="hidden" name="start" value="<%= startday + "" %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="900";
</script>
  <table border="0" width="98%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="26"  align="center" class="text-title">User Number Statistic Weekly</td>
   </tr>
   <tr>
   <td align="center">
      <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="93%"  align="center">
      <tr height=35>
      <td>
        SCP List&nbsp;
          <select name="scplist" size="1" class="input-style2">
              <% out.print(optSCP); %>
          </select>&nbsp;&nbsp;
          <!--
        User Type <select name="usertype" size="1" class="input-style1">
                    <option value="0">Mobile Line</option>
                    <option value="2">PSTN</option>
                    <option value="1">CDMA</option>
                    <option value="3">PHS</option>
                </select>
                -->&nbsp;&nbsp;&nbsp;
          <img border="0" src="button/search.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:searchInfo()">&nbsp;
          <img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
      </td>
     </tr>
     </table>
  </td>
  </tr>
   <tr>
   <td align="center">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="93%"  align="center">
     <tr height=35>
     <td>Date
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">&nbsp;
        YYYY.MM.DD&nbsp;&nbsp;
      </td>
     </tr>
     </table>
  </td>
  </tr>
  <tr>
  <td>
<%if(op.equals("search")){
%>
<hr>
     <table width="95%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2">
 <%
         if(map.size()>0){
                out.print("<tr>");
                out.print("<td align=left>Total No. of  Paying Customers</td>");
                String str1 = map.get("GSM_payuser")==null?"":map.get("GSM_payuser").toString().trim();
                int num1 = str1.length()==0?0:Integer.parseInt(str1);
                str1 = map.get("PSTN_payuser")==null?"":map.get("PSTN_payuser").toString().trim();
                int num2 = str1.length()==0?0:Integer.parseInt(str1);
                out.print("<td align=center>"+(num1+num2)+"</td>");
                out.print("</tr>\n<tr>");
                out.print("<td align=left>Total No. of  Customers With Free Subscription</td>");
                str1 = map.get("GSM_freeuser")==null?"":map.get("GSM_freeuser").toString().trim();
                num1 = str1.length()==0?0:Integer.parseInt(str1);
                str1 = map.get("PSTN_freeuser")==null?"":map.get("PSTN_freeuser").toString().trim();
                num2 = str1.length()==0?0:Integer.parseInt(str1);
                out.print("<td align=center>"+(num1+num2)+"</td>");
                out.print("</tr>");
         }
         else{
           out.print("<tr><td colspan=3 align='center'>No record matched the criteria!</td></tr>");
         }
 %>
   </table>
<%}%>

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
        sysInfo.add(sysTime + operName + " Exception occurred in User Number Statistic Weekly");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in User Number Statistic Weekly");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="userNumberStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

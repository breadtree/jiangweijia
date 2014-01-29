<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%@ page import="zxyw50.manStat" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String ifdilargess= (String)application.getAttribute("DISLARGESS")==null?"0":(String)application.getAttribute("DISLARGESS");

    String[] statStr = {"","","","Total number of ringtone orders per month","Total number of presented ringtones per month","Total of monthly rentals","",""};//{"","","","月铃音定购总数","月铃音赠送总数","月租费总和","",""}
    int      statCount = 8;
    try {
        String  errmsg = "";
        String  queryType = "";
        int     queryMode = 3;
        boolean flag =true;
        zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
       else if (purviewList.get("4-2") == null || (!purview.CheckOperatorRightAllSerno(session,"4-2"))) {
          errmsg = "You have no access to this function!";//You have no access to this function
          flag = false;
         }
       if(flag){
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
          Hashtable hash = new Hashtable();
          Vector vRet = new Vector();
          String startday = "";
          String endday = "";
          String start = "";
          String end = "";
          int checkflag = 0;
          if(request.getParameter("statMode")!=null)
          	 queryMode = Integer.parseInt(request.getParameter("statMode"));
          if(queryMode<0 || queryMode>=9 )
               queryMode = 0;
          queryType = statStr[queryMode];

          if(op.equals("search") || op.equals("bakdata")){

             if(request.getParameter("checkflag") != null)
                checkflag = Integer.parseInt(request.getParameter("checkflag"));
             if(checkflag==1){
                 startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
                 endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
                 start = request.getParameter("start") == null ? "" : ((String)request.getParameter("start")).trim();
                 end = request.getParameter("end") == null ? "" : ((String)request.getParameter("end")).trim();
             }
          }
         hash.put("startday",start);
         hash.put("endday",end);

         manStat manstat = new manStat();
         String  optSCP = "";
         ArrayList scplist = manstat.getScpList();
         for (int i = 0; i < scplist.size(); i++) {
            if(i==0 && scp.equals(""))
               scp = (String)scplist.get(i);
            optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
         }
         if(!scp.equals("")){
           hash.put("scp",scp);
           vRet = manstat.qrySvcStat(hash);

           if(op.equals("bakdata")){
             response.setContentType("application/msexcel");
             String stat_name = "svcUsage";
             switch(queryMode) {
               case 3:stat_name = "ringorder";break;
               case 4:stat_name = "ringgift";break;
               case 5:stat_name = "rental";break;
               default:stat_name = "svcUsage";
             }
             String file_name = XlsNameGenerate.get_xls_filename(startday, endday, stat_name, XlsNameGenerate.STATISTIC_MONTH);
             response.setHeader("Content-disposition","inline; filename=" + file_name);
             String strTime = "";
             String temp = "";
             String strCount = "";
             out.clear();
             out.println("<table border='1'>");
             out.println("<tr><td>Date</td><td>"+queryType+"</td></tr>");
             for (int i = 0; i < vRet.size(); i=i+10) {
               strTime = vRet.get(i).toString().trim();
               strCount = vRet.get(i+queryMode+1).toString().trim();
               temp = strTime.substring(0,4);
               temp = temp + " Year " + strTime.substring(4)+" Month";
               out.println("<tr><td>"+temp+"</td><td>"+strCount+"</td></tr>");
             }
             out.println("</table>");
             vRet.clear();
             return;
           }
         }

%>

<html>
<head>
<title>Service development statistics</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">

<script language="javascript">

   function checkInfo () {
      var fm = document.inputForm;
      var tmp = '';
      if(fm.statMode.selectedIndex==-1){
          alert("Please select a statistical type!");//请选择统计类别
          return;
      }
      if (fm.checkTime.checked) {
         if (trim(fm.startday.value) == '') {
            alert('Please enter the start Year and Month!');//请输入开始年月
            fm.startday.focus();
            return false;
         }
         if (! checkDate1(fm.startday.value)) {
            alert('Invalid start Year and month entered. \r\n Please enter the start Year and Month in the YYYY.MM format!');//开始年月输入错误,\r\n请按YYYY.MM输入开始年月!
            fm.startday.focus();
            return false;
         }
         if (! checktrue1(fm.startday.value)) {
            alert('Start Year and Month cannot be later than the current time!!');//开始年月不能大于当前时间
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert('Please enter the end Year and Month!');//请输入结束年月
            fm.endday.focus();
            return false;
         }
         if (! checkDate1(fm.endday.value)) {
            alert('Invalid end Year and month entered. \r\n Please enter the start Year and Month in the YYYY.MM format!');//结束年月输入错误,\r\n请按YYYY.MM输入开始年月!
            fm.endday.focus();
            return false;
         }
         if (! checktrue1(fm.endday.value)) {
            alert('End Year and Month cannot be later than the current time!');//结束年月不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate1(fm.startday.value,fm.endday.value)) {
            alert('Start Year and Month should be prior to the end Year and Month!');//开始年月应该在结束年月之前
            fm.startday.focus();
            return false;
         }
      }
      tmp = trim(fm.startday.value);
      fm.start.value = tmp.substring(0,4) + tmp.substring(5,7);
      tmp = trim(fm.endday.value);
      fm.end.value = tmp.substring(0,4) + tmp.substring(5,7) + tmp.substring(8,10);
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
  function onCheckTime(){
     var fm = document.forms[0];
     if(fm.checkTime.checked){
       var today  = new Date();
       var year = today.getYear();
       var month = today.getMonth() + 1;
       var strtemp = "";
       if(month<10)
           strtemp = "0" + month;
       fm.endday.disabled = false;
       fm.startday.disabled = false;
       fm.startday.value = (year-1) + "." + strtemp;
       fm.endday.value = year + "." + strtemp;
       fm.checkflag.value ="1";

     }
     else {
       fm.checkflag.value ="0";
       fm.startday.value = "";
       fm.endday.value = "";
       fm.endday.disabled = true;
       fm.startday.disabled = true;
    }
  }

    function  initform(fm){
     if(parseInt(fm.checkflag.value)==1)
          fm.checkTime.checked = true;
     else
         fm.checkTime.checked = false;
     var temp = "<%= statCount %>";
     var  statCount = parseInt(temp);
     var  mode = "<%= queryMode %>";
     var index = parseInt(mode);
     if(index<0 || index > (statCount-1))
        index = 0;
     var len = fm.statMode.length;
     for(var i=0;i<len ;i++){
       if(fm.statMode.options[i].value==mode){
          fm.statMode.selectedIndex = i;
          break;
       }
     }
     var temp = "<%= scp %>";
     for(var i=0; i<fm.scplist.length; i++){
        if(fm.scplist.options[i].value == temp){
           fm.scplist.selectedIndex = i;
           break;
        }
     }

  }


</script>
<form name="inputForm" method="post" action="querySvcUsage.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="checkflag" value="<%= checkflag %>">
<input type="hidden" name="start" value=0>
<input type="hidden" name="end" value=0>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>

<table border="0" width="500" align="center" cellspacing="0" cellpadding="0" class="table-style2" height="400">
   <tr >
          <td height="26"  align="center" class="text-title"  background="image/n-9.gif" >Service development statistics</td>
   </tr>
  <tr>
    <td height="45" valign="middle">
      <table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2">
        <tr height =40>
        <td >
              SCP<br><select name="scplist" size="1"  class="input-style1" style="width:130px">
              <% out.print(optSCP); %>
             </select>
         </td>
        <td>Statistical category<br>
            <select name="statMode" size=1 width="120px">
             <%
                String tmp ="";
                for(int i=0; i<statCount; i++){
                    tmp = statStr[i];
                    if(!tmp.equals("")){
                    if(i!=4)
                      out.println("<option value=" + Integer.toString(i)+" >" + tmp + "</option>");
                    else if(ifdilargess.equals("0"))
                      out.println("<option value=" + Integer.toString(i)+" >" + tmp + "</option>");
                   }
              }
             %>
            </select>
         </td>
         </tr>
        <tr>
          <td colspan=2>
            <table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2">
             </tr>
              <td width="24%" ><input type="checkbox" name="checkTime" value="1" onclick="onCheckTime()">Time period(YYYY.MM)</td>
              <td width="22%" align="right" ><span title="Start Year and Month">&nbsp;From&nbsp;&nbsp;</span><input type="text" name="startday" value="<%= startday %>" maxlength="10" size="8"></td>
              <td width="22%" align="left" ><span title="End Year and Month">&nbsp;To&nbsp;&nbsp;</span><input type="text" name="endday" value="<%= endday %>" maxlength="10" size="8"></td>
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <td width="13%" align="right"><img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
</td>
             </tr>
            </table>
          </td>
         </tr>
         </table>
  </td>
  </tr>
  <tr>
    <td align="center" height="355" valign="top">
      <table id="data" border="1" width="100%" cellspacing="0" cellpadding="0" class="table-style2" bordercolorlight="#000000" bordercolordark="#FFFFFF">
        <tr class="table-title1">
          <td width="50%" height="24" align="center" >Date</td>
          <td width="50%" height="24"><% out.print(queryType); %></td>
        </tr>
<%
            String strTime = "";
            String temp = "";
            String strCount = "";
            for (int i = 0; i < vRet.size(); i=i+10) {
                strTime = vRet.get(i).toString().trim();
                strCount = vRet.get(i+queryMode+1).toString().trim();
                temp = strTime.substring(0,4);
                temp = temp + " Year " + strTime.substring(4)+" Month";
                out.print("<tr><td>"+temp+"&nbsp;&nbsp;</td>");
                out.print("<td align=right>"+strCount+"&nbsp;&nbsp;</td></tr>");
            }
%>
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
        sysInfo.add(sysTime + operName + "Exception occurred in the statistics on service development!");//业务发展统计过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in the statistics on service development!");//业务发展统计过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="querySvcUsage.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    int isCombodia = zte.zxyw50.util.CrbtUtil.getConfig("isCombodia",0);
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    int pagesize=15;
    try {
        ArrayList arraylist = null;
        ArrayList opermodelist = null;
        HashMap   map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        zxyw50.Purview purview = new zxyw50.Purview();

        if (purviewList.get("4-12") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-12"))) {
          errmsg = "You have no right to access this function!";//You have no access to this function
          flag = false;
         }
       if (operID  == null){
          errmsg = "Please log in first!";
          flag = false;
       }
       if(flag){
          String usernumber = "";
          String startday = "";
          String endday = "";
          String opermode = "";
          String spcode = "";
          String optSCP = "";
          Hashtable hash = null;
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          boolean checkflag = request.getParameter("checkTime") != null ? true : false;
          manStat manstat = new manStat();
          String  total ="";
          String  scp = "";
          if(op.equals("search") || op.equals("bakdata")){
             opermode = request.getParameter("opermode") == null ? "" : ((String)request.getParameter("opermode")).trim();
             scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
             spcode = request.getParameter("spcode") == null ? "" : ((String)request.getParameter("spcode")).trim();
             startday = request.getParameter("start") == null ? "" : ((String)request.getParameter("start")).trim();
             endday = request.getParameter("end") == null ? "" : ((String)request.getParameter("end")).trim();
             map.put("scp",scp);
             map.put("opermode",opermode);
             map.put("startday",startday);
             map.put("endday",endday);
             map.put("spcode",spcode);
             arraylist = manstat.getWebUserStat(map);
             total = manstat.getWebUserStat0(map);
          }
 	  if(op.equals("bakdata")){
    		response.setContentType("application/msexcel");
            String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "accountMode", XlsNameGenerate.STATISTIC_DAY);
            response.setHeader("Content-disposition","inline; filename=" + file_name);
             	out.clear();
             	out.println("<table border='1'>");
    		out.println("<tr><td>Date</td><td>Total opened accounts</td></tr>");
            	for (int i = 0; i <arraylist.size(); i++) {
			map = (HashMap)arraylist.get(i);
                  	out.println("<tr><td>"+(String)map.get("statdate")+"</td><td>"+(String)map.get("statnum")+"</td></tr>");
               	}
               	out.println("</table>");
        	return;
      	  }

          int thepage = 0 ;
          int pagecount = 0;
          int size=0;
          if(arraylist==null)
             size =-1;
          else
             size = arraylist.size();
          pagecount = size/pagesize;
          if(size%pagesize>0)
             pagecount = pagecount + 1;
          if(pagecount==0)
             pagecount = 1;
          manSysPara syspara = new manSysPara();
          ArrayList vet = new ArrayList();
          vet = syspara.getSPInfo();
          ArrayList scplist = syspara.getScpList();
          for (int i = 0; i < scplist.size(); i++)
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
 %>

<html>
<head>
<title>Statistics on account opening modes</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<body background="background.gif" class="body-style1" onload="loadpage(document.forms[0])" >

<script language="javascript">

   function loadpage(pform){
      firstPage();
      var sTmp = "<%=  opermode  %>";
      if(sTmp!='')
         document.forms[0].opermode.value = sTmp;
      if(sTmp==4)
        document.all('id_spshow').style.display= 'block';
      sTmp = "<%=  spcode  %>";
      if(sTmp!='')
         document.forms[0].spcode.value = sTmp;

      var temp = "<%= scp %>";
      for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }

   }


   function modeChange(){
      if(document.forms[0].opermode.value==4){
        if(document.forms[0].spcode.length==0){
           alert("No ringtone provider can be queried. Please configure SPs first.");//没有铃音供应商可供查询,请先配置SP
           return;
        }
        document.all('id_spshow').style.display= 'block';
      }
      else
        document.all('id_spshow').style.display= 'none';
   }

   function onCheckTime(){
      var fm = document.inputForm;
      if (fm.checkTime.checked) {
        var today  = new Date();
        var year = today.getYear();
        var month = today.getMonth() + 1;
        var day = today.getDate();
        fm.endday.disabled = false;
        fm.startday.disabled = false;
        var strMonth = "";
        var strDay = "";
        if(month<10)
           strMonth = "0" + month;
        else
           strMonth = month;
        if(day<10)
           strDay = "0" + day ;
        else
           strDay = day;
        fm.endday.value = year + "." + strMonth+"."+strDay;
        var month1 = (month-1 + 12)%12;
        if(month1==0)
           month1 = 12;
        var year1 = year;
        if(month1>month)
           year1 = year1 - 1;
        if(month1<10)
           strMonth = "0" + month1;
        else
           strMonth = month1;
        var days = getMonthDays(year1,month1)
        if(day>days)
          day = days;
        if(day<10)
           strDay = "0" + day ;
        else
           strDay = day;
        fm.startday.value = year1 + "." + strMonth+"." + strDay ;
      }
      else{
         fm.start.value = "";
         fm.end.value = "";
         fm.startday.value = "";
         fm.endday.value = "";
         fm.endday.disabled = true;
         fm.startday.disabled = true;
      }
      return;
   }

   function checkInfo () {
      var fm = document.inputForm;
      var tmp = '';
      if(document.forms[0].opermode.value==4 && document.forms[0].spcode.length==0){
           alert("No ringtone provider can be queried. Please configure SPs first.");//没有铃音供应商可供查询,请先配置SP
           return;
      }
      if (fm.checkTime.checked) {
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
         if (trim(fm.endday.value) == '') {
            alert('Please enter the end time!');//请输入结束时间
            fm.endday.focus();
            return false;
         }
         if (! checkDate2(fm.endday.value)) {
            alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM format!');//结束时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!
            fm.endday.focus();
            return false;
         }
         if (! checktrue2(fm.endday.value)) {
            alert('End time should not be later than the current time!');//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
            alert('Start time should be prior to the end time!');//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }
         fm.start.value = tmp = trim(fm.startday.value);
         fm.end.value = trim(fm.endday.value);
      }
      else{
          fm.start.value = "";
          fm.end.value = "";
      }
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
   function onpage(num){
      var obj  = eval("page_" + num);
  	  obj.style.display="block";
  	  document.forms[0].thepage.value = num;
  }

   function offpage(num){
  	var obj  = eval("page_" + num);
  	obj.style.display="none";
  }
  function firstPage(){
	if(parseInt(document.forms[0].pagecount.value)==0)
	   return;
	var thePage = document.forms[0].thepage.value;
	offpage(thePage);
	onpage(1);
	return true;
  }

  function toPage(value){
	var thePage = parseInt(document.forms[0].thepage.value);
	var pageCount = parseInt(document.forms[0].pagecount.value);
	var index = thePage+value;
	if(index > pageCount || index<0)
	   return;
	if(index!=thePage){
	   offpage(thePage);
	   onpage(index);
     }
	return true;
  }

  function endPage(){
	var thePage = document.forms[0].thepage.value;
	var pageCount = parseInt(document.forms[0].pagecount.value);
	offpage(thePage);
	onpage(pageCount)
	return true;
  }

</script>
<form name="inputForm" method="post" action="webUserStat.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="start" value="<%= startday + "" %>">
<input type="hidden" name="end" value="<%= endday + "" %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="700";
</script>
  <table border="0" width="98%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="26"  align="center" class="text-title" background="image/n-9.gif">Statistics on account opening modes</td>
   </tr>
   <tr>
   <td align="center" height="35">
      <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="90%"  align="center">
      <tr height=35>
      <td>
        Please select SCP&nbsp; <select name="scplist" size="1" class="input-style1">
              <% out.print(optSCP); %>
             </select>
      </td>
     </tr>
     </table>
  </td>
  </tr>
     <tr >
     <td align='center'>
        <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="90%" align='center'>
        <tr>
        <td width="50%">Account opening modes&nbsp;&nbsp;
         <select name="opermode" class="input-style1"  onchange="modeChange();" style="width:270px"  >
	      <option value ="1" >----BOSS----</option>
	      <option value ="2" >----WEB-----</option>
	      <option value ="3" >----IVR-----</option>
	      <option value ="4" >----SP-----</option>
	      <option value ="9" >----OKP-----</option>
	      <option value ="10">----Manual Operator Position---</option>
	      <option value ="12">----Short message----</option>
		  <option value ="15">----USSD----</option>
               <%if(isCombodia==1){%>
               <option value ="17">----Web Service----</option>
               <%}%>
	     </select>
	    </td>
	    <td id="id_spshow" style="display:none" width="50%">
	    Ringtone provider&nbsp;&nbsp;
	    <select name="spcode" class="input-style1"  >
	     <%
                 for (int i = 0; i < vet.size(); i++) {
                     map = (HashMap)vet.get(i);
                     out.println("<option value="+(String)map.get("spcode") + ">" + (String)map.get("spname") + "</option>");
                 }
         %>
	     </select>
	     </td>
	     </tr>
	     </table>
	 </td>
     </tr>
     <tr>
     <td>
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="90%" align='center'>
     <tr>
     <input type="checkbox" name="checkTime" value="on"<%= checkflag ? " checked" : "" %>  onclick="onCheckTime()" >Start and end dates:YYYY.MM.DD&nbsp;
      <br>Start
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">&nbsp;
      &nbsp;End
      <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:100px">
              &nbsp;<img border="0" src="button/search.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
      </td>
     </tr>
     </table>
  </td>
  </tr>
  <%
     if(op.equals("search")){
      out.println("<tr><td height=30 valign=bottom>");
	  out.println("&nbsp;&nbsp;&nbsp;&nbsp;<font style='color: #FF0000'>Total number of account openings meeting the criteria:&nbsp;" + total + "</font>");
	  out.println("</td></tr>");
     }
  %>
  <tr>
  <td>
  <%
        int  record = 0;
        for (int i = 0; i < pagecount; i++) {
          String pageid = "page_"+Integer.toString(i+1);
  %>

     <table width="95%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="table-title1" align="center" >
           <td height="30" width="40%" align="center">
              Date
          </td>
          <td height="30" width="60%" align="center" >
              Total number of account openings
          </td>
        </tr>

 <%
   			if(size==0){
			%>
			<tr><td align="center" colspan="10">No record matched the criteria</td>
			</tr>
			<%
			}else if(size>0){
			if(i==(pagecount-1))
               record = size;
            else
               record = (i+1)*pagesize;
            for(int j=i*pagesize;j<record;j++){
                String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                map = (HashMap)arraylist.get(j);
                out.print("<tr bgcolor=" +strcolor + ">");
                out.print("<td align=center>"+(String)map.get("statdate")+"</td>");
                out.print("<td align=center >"+(String)map.get("statnum")+"</td>");
                out.print("</td></tr>");
      }

 %>
        <tr>
        <td width="100%" colspan="10">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>Total:<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
              <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
              <td><img src="button/nextpage.gif" <%= i * 15 + 15 >= arraylist.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
              <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()"></td>
            </tr>
          </table>
        </td>
      </tr>
   </table>
<%}

        }
%>
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
        sysInfo.add(sysTime + operName + "Exception occurred in the statistics on the account opening modes!");//开户方式统计过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in the statistics on the account opening modes!");//开户方式统计过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="webUserStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

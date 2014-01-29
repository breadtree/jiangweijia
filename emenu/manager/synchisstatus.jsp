<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manStat" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%!
    public String displaystat(String s){
      if(s.equals("1")){
        return "To be synchronized";
      }
      if(s.equals("2")){
        return "In the synchronization processing";
      }
      if(s.equals("3")){
        return "Synchronization succeed";//同步成功
      }
      if(s.equals("4")){
      	return "Synchronization fail";
      }
      return "Other status";

    }

%>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
    	  zxyw50.Purview purview = new zxyw50.Purview();
        ArrayList arraylist = new ArrayList();
        HashMap   map  = new HashMap();
        String    errmsg = "";
        boolean   flag =true;
        if (purviewList.get("15-4") == null) {
          errmsg = "You have no access to this function";//You have no access to this function!
          flag = false;
         }
       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system!
          flag = false;
       }
       if(flag){

          manCRBT  mancrbt = new manCRBT();
          String usernumber = "";
          String starttime =request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
          String days= request.getParameter("ddays") == null ? "1" : ((String)request.getParameter("ddays")).trim();
          String seqno = "";
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          String checkflag = request.getParameter("checkflag") == null ? "1" : ((String)request.getParameter("checkflag")).trim();
          String status=request.getParameter("status")==null ? "": ((String)request.getParameter("status")).trim();
 		if(starttime.equals("")){

	   	Calendar calendar = Calendar.getInstance();
    	   Date trialTime = new Date();
    	   calendar.setTime(trialTime);
           int  year  = calendar.get(Calendar.YEAR);
           int  month  = calendar.get(Calendar.MONTH) + 1;
           int day=calendar.get(Calendar.DAY_OF_MONTH);
           String sday=Integer.toString(day);
           if(day<10)
             sday="0"+sday;

           String strMonth = Integer.toString(month);
           if(month<10)
              strMonth = "0"  + strMonth;
           starttime = Integer.toString(year) + "." + strMonth+"."+sday;

        }

          if(op.equals("search")){
             usernumber = request.getParameter("usernumber") == null ? "" : transferString((String)request.getParameter("usernumber")).trim();
             seqno = request.getParameter("seqno") == null ? "" : transferString((String)request.getParameter("seqno")).trim();
             map.put("usernumber",usernumber);
             map.put("seqno",seqno);
             map.put("starttime",starttime);
             map.put("days",days);
	    		 map.put("checkflag",checkflag);
	    		 map.put("status",status);
             arraylist = mancrbt.getHisSyncStatus(map);
          }
          int  records = 20;
          int thepage = 0 ;
          int pagecount = 0;
          int size=0;
          if(arraylist==null)
             size =-1;
          else
             size = arraylist.size();
          pagecount = size/records;
          if(size%records>0)
             pagecount = pagecount + 1;
          if(pagecount==0)
             pagecount = 1;
%>

<html>
<head>
<title>User ringtone requirement query</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<body background="background.gif" class="body-style1" onload="loadPage();" >

<script language="javascript">
   var v_seqno = new Array(<%= arraylist.size() + "" %>);
<%
            for (int i = 0; i < arraylist.size(); i++) {
                map = (HashMap)arraylist.get(i);
%>
   v_seqno[<%= i + "" %>] = '<%= (String)map.get("seqno") %>';
<%
            }
%>

   function loadPage(){
      var temp = "<%= days %>";
      var fm = document.inputForm;
      for(var i=0; i<fm.ddays.length; i++){
        if(fm.ddays.options[i].value == temp){
           fm.ddays.selectedIndex = i;
           break;
        }
      }
     firstPage();
     var value = "<%= checkflag %>"
     fm.checkflag[value].checked = true;
   }

   function onCheckTime(){
      var fm = document.inputForm;
        var today  = new Date();
        var year = today.getYear();
        var month = today.getMonth() + 1;
        var day = today.getDate();
        alert(day);
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

      return;
   }

   function checkInfo () {
      var fm = document.inputForm;

      if(fm.checkflag[0].checked){
         if(trim(fm.usernumber.value)==""){
           alert("Please input user number!");
           fm.usernumber.focus();
           return false;
         }
      }
      if (!CheckInputStr(fm.usernumber,'User number')){
         fm.usernumber.focus();
         return  flag;
      }
      if (!CheckInputStr(fm.seqno,'Sequence no')){
         fm.seqno.focus();
         return  flag;
      }
         if (trim(fm.startday.value) == '') {
            alert('Please input the start time!');//请输入起始时间!
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
            alert('Error occurs in the input of start time,Please input start time in the format of YYYY.MM.DD');//起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
            alert('The start time should not be later than current time!');
            fm.startday.focus();
            return false;
         }
      return true;
   }

   function searchInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'search';
      fm.submit();
   }

function actsync(){
var fm = document.inputForm;
if (fm.ringlist.value == '') {
         alert("Please select the synchronization operation.");
         return;
      }
      if (confirm("Are you sure to synchronize the manually selected options?") == 0)
         return;
      fm.op.value = 'insert';
      fm.submit();
 }


   function offpage(num){
  	var obj  = eval("page_" + num);
  	obj.style.display="none";
  }

  function onpage(num){
      var obj  = eval("page_" + num);
  	  obj.style.display="block";
  	  document.forms[0].thepage.value = num;
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
   function oncheckbox(sender,seqno){
       var fm = document.inputForm;
       var ringlist = fm.ringlist.value;
       var ringvalue = "";
       if(sender.checked){
           fm.ringlist.value = ringlist + seqno  + "|";
           return;
       }
       var idd = ringlist.indexOf("|");
	   while( idd > 0){
	      if(ringlist.substring(0,idd)==seqno){
	         ringvalue = ringvalue + ringlist.substring(idd+1);
	         break;
	      }
	      ringvalue = ringvalue +  ringlist.substring(0,idd) + '|';
	      ringlist = ringlist.substring(idd + 1);
	      idd =-1;
	      if(ringlist.length>1)
	         idd  = ringlist.indexOf("|");
	   }
	   fm.ringlist.value = ringvalue;
	   return;
   }

    function onSelectAll(){
      var fm = document.inputForm;
      var ringlist = "";
      if(fm.selectall.checked){
         for(var i=0;i<v_seqno.length; i++){
            eval('document.inputForm.sync'+v_seqno[i]).checked = true;
            ringlist = ringlist + v_seqno[i] + '|';
         }
      }
      else {
          for(var i=0;i<v_seqno.length; i++)
            eval('document.inputForm.sync'+v_seqnox[i]).checked = false;
      }
      fm.ringlist.value = ringlist;
      return;
   }
</script>
<form name="inputForm" method="post" action="synchisstatus.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="days" value="<%= days + "" %>">
<input type="hidden" name="ringlist" value="">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="750";
</script>
  <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr>
       <td height="40"  align="center" class="text-title">CRBT center history synchronization operation status query</td>
   </tr>
   <tr>
   <td align="left">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="900">
     <tr>
   	<td><input type="radio" name="checkflag" value="0"> Person <input type="radio" name="checkflag" value="1">System</td>
     <td>
      Number&nbsp;
      <input type="text" name="usernumber" value="<%= usernumber %>"  maxlength="20" class="input-style0" style="width:120px">
     </td>
     <td>
     Status<select name="status" value="<%=status%>">
      <option value="3">Succeeded in synchronization</value>
      <option value="4">Synchronization fails</value>
      </select>
     </td>
	 <td>
     Serial number&nbsp;
	  <input type="text" name="seqno" value="<%= seqno %>"  maxlength="40" class="input-style0" style="width:120px">
       &nbsp;
     </td>
     <td>
      Start date&nbsp;
      <input type="text" name="startday" value="<%= starttime %>" maxlength="10" class="input-style0" style="width:120px">
      Days&nbsp;
      <select name="ddays" value="<%=days%>">
      <option value="1">1</value>
      <option value="2">2</value>
      <option value="3">3</value>
      </select></td><td>
      &nbsp;<img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()">
     </td>
     </tr>
     </table>
  </td>
  </tr>
  <tr>
  <td>
   <%
        int  record = 0;
        for (int i = 0; i < pagecount; i++) {
          String pageid = "page_"+Integer.toString(i+1);
  %>

     <table width="1000" border="0" cellspacing="1" cellpadding="1" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="table-title1">

           <td height="30" >
              <div align="center">Number</div>
          </td>
          <td height="30">
              <div align="center">Operation serial number</div>
          </td>
          <td height="30">
              <div align="center">Operation code</div>
          </td>
          <td height="30">
              <div align="center">Start date</div>
          </td>
          <td height="30">
              <div align="center">Invalid time</div>
          </td>
           <td height="30">
              <div align="center">Recent update</div>
          </td>
          <td height="30">
              <div align="center">CRBT center</div>
          </td>
          <td height="30">
              <div align="center">Operation status</div>
          </td>
          <td height="30">
              <div align="center">Paramter 1</div>
          </td>
          <td height="30">
              <div align="center">Paramter 2</div>
          </td>
          <td height="30">
              <div align="center">Paramter 3</div>
          </td>
          <td height="30">
              <div align="center">Paramter 4</div>
          </td>
          <td height="30">
              <div align="center">Paramter 5</div>
          </td>
          <td height="30">
              <div align="center">Paramter 6</div>
          </td>
           <td height="30">
              <div align="center">Paramter 7</div>
          </td>
          <td height="30">
              <div align="center">Paramter 8</div>
          </td>
          <td height="30">
              <div align="center">Paramter 9</div>
          </td>          <td height="30">
              <div align="center">Paramter 10</div>
          </td>
          <td height="30">
              <div align="center">Paramter 11</div>
          </td>
          <td height="30">
              <div align="center">Paramter 12</div>
          </td>
          <td height="30">
              <div align="center">Paramter 13</div>
          </td>          <td height="30">
              <div align="center">Paramter 14</div>
          </td>
          <td height="30">
              <div align="center">Paramter 15</div>
          </td>
          <td height="30">
              <div align="center">Paramter 16</div>
          </td>          <td height="30">
              <div align="center">Paramter 17</div>
          </td>
          <td height="30">
              <div align="center">Paramter 18</div>
          </td>
          <td height="30">
              <div align="center">Paramter 19</div>
          </td>
          <td height="30">
              <div align="center">Paramter 20</div>
          </td>

          </tr>

 <%
   			if((!op.equals("")) && size==0){
			%>
			<tr><td class="table-style2" align="center" colspan="10">There are no records meeting the condition!</td>
			</tr>
			<%
			}else if(size>0){
	    if(i==(pagecount-1))
               record = size - (pagecount-1)*records;
            else
               record = records;
            for(int j=0;j<record;j++){
                String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                map = (HashMap)arraylist.get(i*records + j);
                out.print("<tr bgcolor=" +strcolor + " height=20 >");
                out.print("<td align=center>"+(String)map.get("usernumber")+"</td>");
                out.print("<td align=center>"+(String)map.get("seqno")+"</td>");
                out.print("<td >"+(String)map.get("opercode")+"</td>");
                out.print("<td >"+(String)map.get("starttime")+"</td>");
                out.print("<td >"+(String)map.get("endtime")+"</td>");
                out.print("<td >"+(String)map.get("lastmodytime")+"</td>");
                out.print("<td >"+(String)map.get("crbtid")+"</td>");
                out.print("<td >"+displaystat((String)map.get("crbtstatus"))+"</td>");
                out.print("<td >"+(String)map.get("para1")+"</td>");
                out.print("<td >"+(String)map.get("para2")+"</td>");
                out.print("<td >"+(String)map.get("para3")+"</td>");
                out.print("<td >"+(String)map.get("para4")+"</td>");
                out.print("<td >"+(String)map.get("para5")+"</td>");
                out.print("<td >"+(String)map.get("para6")+"</td>");
                out.print("<td >"+(String)map.get("para7")+"</td>");
                out.print("<td >"+(String)map.get("para8")+"</td>");
                out.print("<td >"+(String)map.get("para9")+"</td>");
                out.print("<td >"+(String)map.get("para10")+"</td>");
                out.print("<td >"+(String)map.get("para11")+"</td>");
                out.print("<td >"+(String)map.get("para12")+"</td>");
                out.print("<td >"+(String)map.get("para13")+"</td>");
                out.print("<td >"+(String)map.get("para14")+"</td>");
                out.print("<td >"+(String)map.get("para15")+"</td>");
                out.print("<td >"+(String)map.get("para16")+"</td>");
                out.print("<td >"+(String)map.get("para17")+"</td>");
                out.print("<td >"+(String)map.get("para18")+"</td>");
                out.print("<td >"+(String)map.get("para19")+"</td>");
                out.print("<td >"+(String)map.get("para20")+"</td>");
                out.print("</td></tr>");
      }
 %>
        <tr>
        <td width="100%" colspan="28" align="center">
          <table border="0" cellspacing="1" cellpadding="1" align="center" class="table-style2">
            <tr>
              <td class="table-style2">&nbsp;<%= arraylist.size() %>&nbsp;entries in total&nbsp;<%= pagecount %>&nbsp;pages&nbsp;&nbsp;You are now on page&nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
              <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
              <td><img src="button/nextpage.gif" <%= i * records + records >= arraylist.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
              <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()"></td>
              <td> Note: For meaning of parameters, see Interface of Integrated CRBT Management Platform and CRBT Center</td>
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
<script language="javascript">
   var sTmp = "<%=  seqno  %>";
   if(sTmp!='')
     document.forms[0].seqno.value = sTmp;
</script>
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
        sysInfo.add(sysTime + operName + "It is abnormal during the query of synchronization operation in the CRBT");//彩铃中心同步操作状态查询过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the query of synchronization operation in the CRBT!");//彩铃中心同步操作状态查询过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="synchisstatus.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

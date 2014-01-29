<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manStat" %>

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
        ArrayList arraylist = null;
        HashMap   map  = new HashMap();
        String    errmsg = "";
        boolean   flag =true;
        if (purviewList.get("15-3") == null) {
          errmsg = "You have no access to this function";
          flag = false;
         }
       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system!
          flag = false;
       }
       if(flag){

          manCRBT  mancrbt = new manCRBT();
          String usernumber = "";
          String starttime = "";
          String endtime= "";
          String seqno = "";
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          boolean checktime = request.getParameter("checkTime") != null ? true : false;
          String checkflag = request.getParameter("checkflag") == null ? "1" : ((String)request.getParameter("checkflag")).trim();

          if(op.equals("search")){
             usernumber = request.getParameter("usernumber") == null ? "" : transferString((String)request.getParameter("usernumber")).trim();
             seqno = request.getParameter("seqno") == null ? "" : transferString((String)request.getParameter("seqno")).trim();
             starttime = request.getParameter("start") == null ? "" : ((String)request.getParameter("start")).trim();
             endtime = request.getParameter("end") == null ? "" : ((String)request.getParameter("end")).trim();
             map.put("usernumber",usernumber);
             map.put("seqno",seqno);
             map.put("starttime",starttime);
             map.put("endtime",endtime);
	     map.put("checkflag",checkflag);
             arraylist = mancrbt.getSyncStatus(map);
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
<title></title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<body background="background.gif" class="body-style1" onload="loadPage();" >

<script language="javascript">

   function loadPage(){
     firstPage();
     var value = "<%= checkflag %>"
     document.inputForm.checkflag[value].checked = true;
   }

   function onCheckTime(){
      var fm = document.inputForm;
      if (fm.checkTime.checked) {
        fm.endday.value = getCurrentTime();
        fm.startday.value = "00:00:01";
      }
      else{
         fm.start.value = "0";
         fm.end.value = "0";
         fm.startday.value = "";
         fm.endday.value = "";
         fm.endday.disabled = true;
         fm.startday.disabled = true;
      }
      return;
   }

   function checkInfo () {
      var fm = document.inputForm;
      if(fm.checkflag[0].checked){
         if(trim(fm.usernumber.value)==""){
           alert("Please input the user number!");
           fm.usernumber.focus();
           return false;
         }
      }
      if (!CheckInputStr(fm.usernumber,'User number')){//User number
         fm.usernumber.focus();
         return  flag;
      }
      if (!CheckInputStr(fm.seqno,'Serial number')){//序列号
         fm.seqno.focus();
         return  flag;
      }
      if (fm.checkTime.checked) {
         if (trim(fm.startday.value) == '') {
            alert('Please input the start time!');//序列号
            fm.startday.focus();
            return false;
         }
         if (! isTime(fm.startday.value)) {
            alert('Start time input error,\r\n please input the start time in the HH:MM:SS format!');//起始时间输入错误,\r\n请按HH:MM:SS输入起始时间!
            fm.startday.focus();
            return false;
         }
         
         if (trim(fm.endday.value) == '') {
            //alert('请输入结束时间!');
            alert('Please input the end time!');
            fm.endday.focus();
            return false;
         }
         if (! isTime(fm.endday.value)) {
            //alert('结束时间输入错误,\r\n请按HH:MM:SS输入终止时间!');
            alert('End time input error,\r\n please input the end time in the HH:MM:SS format!');
            fm.endday.focus();
            return false;
         }
         
         if (fm.startday.value>fm.endday.value) {
          //  alert('起始时间应该在结束时间之前!');
            alert("Start time should be earlier than end time!");
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

</script>
<form name="inputForm" method="post" action="syncstatus.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="start" value="<%= starttime + "" %>">
<input type="hidden" name="end" value="<%= endtime + "" %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="750";
</script>
  <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr>
       <td height="40"  align="center" class="text-title">Query of synchronization operation status in the CRBT center</td>
   </tr>
   <tr>
   <td align="left">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="500">
     <tr>
   	<td><input type="radio" name="checkflag" value="0">Person<input type="radio" name="checkflag" value="1">System</td>

     <td>
      Number&nbsp;
      <input type="text" name="usernumber" value="<%= usernumber %>"  maxlength="20" class="input-style0" style="width:120px">
     </td>
	 <td  >
      Serial number&nbsp;
	  <input type="text" name="seqno" value="<%= seqno %>"  maxlength="40" class="input-style0" style="width:120px">
       &nbsp;
     </td>
     </tr>
     <tr>
     <td colspan="3"  >
     <input type="checkbox" name="checkTime" value="on"<%= checktime ? " checked" : "" %>  onclick="onCheckTime()" >Time rangeHH:MM:SS
      
      <input type="text" name="startday" value="<%= starttime %>" maxlength="10" size="12" class="input-style0" style="width:120px">
——
      <input type="text" name="endday" value="<%= endtime %>" maxlength="10" size="12" class="input-style0" style="width:120px">
      &nbsp;
      <img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()">
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

     <table width="100%" border="0" cellspacing="1" cellpadding="1" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="table-title1">
           <td height="30" width="80">
              <div align="center">Number</div>
          </td>
          <td height="30" width="60">
              <div align="center">Operation serial number</div>
          </td>
          <td height="30" width="160">
              <div align="center">Operation code</div>
          </td>
          <td height="30" width="80">
              <div align="center">Start time</div>
          </td>
          <td height="30" width="150">
              <div align="center">nvalidity time</div>
          </td>
           <td height="30" width="80">
              <div align="center">Recent update</div>
          </td>
          <td height="30" width="60">
              <div align="center">CRBT center</div>
          </td>
          <td height="30" width="160">
              <div align="center">Operation status</div>
          </td>
          <td height="30" width="80">
              <div align="center">Parameter 1</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 2</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 3</div>
          </td>
          <td height="30" width="80">
              <div align="center">Parameter 4</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 5</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 6</div>
          </td>          <td height="30" width="80">
              <div align="center">Parameter 7</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 8</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 9</div>
          </td>          <td height="30" width="80">
              <div align="center">Parameter 10</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 11</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 12</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 13</div>
          </td>          <td height="30" width="80">
              <div align="center">Parameter 14</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 15</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 16</div>
          </td>          <td height="30" width="80">
              <div align="center">Parameter 17</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 18</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 19</div>
          </td>
          <td height="30" width="150">
              <div align="center">Parameter 20</div>
          </td>
 	 <td height="30" width="150">
              <div align="center">Synchronization times</div>
          </td>
          </tr>

 <%
   			if(size==0){
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
                out.print("<td >"+(String)map.get("crbtstatus")+"</td>");
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
        <td width="100%" colspan="7">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td class="table-style2">&nbsp;<%= arraylist.size() %>&nbsp;entries in total&nbsp;<%= pagecount %>&nbsp;pages&nbsp;&nbsp;You are now on page&nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
              <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
              <td><img src="button/nextpage.gif" <%= i * records + records >= arraylist.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
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
        sysInfo.add(sysTime + operName + "It is abnormal during CRBT center synchronization operation status query!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during CRBT center synchronization operation status query!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="syncstatus.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

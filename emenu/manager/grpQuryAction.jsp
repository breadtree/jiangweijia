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
    zxyw50.Purview purview = new zxyw50.Purview();
    try {
        ArrayList arraylist = null;
        HashMap map  = new HashMap();
        String errmsg = "";
        String queryType = "";
        int queryMode = 0;
        boolean flag =true;
        if (purviewList.get("11-17") == null) {
         // errmsg = "You have no access to this function!";
          errmsg ="You have no access to this function!";
          flag = false;
         }
       if (operID  == null){
         // errmsg = "Please log in to the system!";
          errmsg = "Please log in to the system!";
          flag = false;
       }
       if(flag){

          manStat manstat = new manStat();
          String usernumber = "";
          String startday = "";
          String endday = "";
          String opcode = "";
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          boolean checkflag = request.getParameter("checkTime") != null ? true : false;
	  if(op.equals("bakdata")){
        	ArrayList al=(ArrayList)session.getAttribute("ResultSession");

    		response.setContentType("application/msexcel");
		response.setHeader("Content-disposition","inline; filename=test.xls");
             	out.clear();
             	out.println("<table border='1'>");
    		out.println("<tr><td>Operation time</td><td>Song name</td><td >Multiply interface</td><td >Operation source</td><td >Notes</td></tr>");

            	for (int i = 0; i <al.size(); i++) {
		    map = (HashMap)al.get(i);
                    out.println("<tr><td>"+(String)map.get("optime")+"</td><td>"+(String)map.get("ringname")+"</td><td>"+(String)map.get("opermode")+"</td><td>"+(String)map.get("opersource")+"</td><td>"+(String)map.get("operdesc")+"</td></tr>");
               	}
               	out.println("</table>");
                al.clear();
        	return;
      	    }
          if(op.equals("search")){
             usernumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();
             if(!usernumber.equals("")){
               if(!purview.checkGroupOperateRight(session,"11-17",usernumber)){
            	  throw new Exception("You have no access to the group!");
          	}
             }
             opcode = request.getParameter("opcode") == null ? "" : ((String)request.getParameter("opcode")).trim();
             startday = request.getParameter("start") == null ? "" : ((String)request.getParameter("start")).trim();
             endday = request.getParameter("end") == null ? "" : ((String)request.getParameter("end")).trim();
             map.put("usernumber",usernumber);
             map.put("opcode",opcode);
             map.put("startday",startday);
             map.put("endday",endday);
             map.put("operator","");
             map.put("scp","");
             map.put("isgroup","isgroup");
             arraylist = manstat.getGrpOpLog(map);
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
<title>Group ringtone operation query</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<body class="body-style1" onload="loadPage();" >

<script language="javascript">

   function loadPage(){
     var fm = document.inputForm;
     firstPage();
     var sTmp = "<%=  opcode  %>";
     if(sTmp!='')
         document.forms[0].opcode.value = sTmp;
     if (fm.checkTime.checked) {
          fm.endday.disabled = false;
          fm.startday.disabled = false;
      }
      else{
         fm.endday.disabled = true;
         fm.startday.disabled = true;
      }
   }

   function onCheckTime(){
      var fm = document.inputForm;
      if (fm.checkTime.checked) {
          fm.endday.disabled = false;
          fm.startday.disabled = false;
          fm.endday.value = getCurrentDate();;
          fm.startday.value = getMonthPriorDate(2); ;
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
      var tmp = '';
      var value = trim(fm.usernumber.value);
       if (fm.checkTime.checked) {
         if (trim(fm.startday.value) == '') {
            alert('Please input the start time!');
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
            alert('Invalid start time entered,\r\n Please enter the start time in the YYYY.MM.DD format!');
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
            alert('Start time cannot be later than current time!');
            fm.startday.focus();
            return false;
         }
         var  value = trim(fm.startday.value);
         var sStartDate = getMonthPriorDate(2);
         var tmp1 = sStartDate.substring(0,4) + sStartDate.substring(5,7) + sStartDate.substring(8,10);
         var tmp2 = value.substring(0,4) + value.substring(5,7) + value.substring(8,10);
         if(tmp1 > tmp2 )      {
            alert('Sorry,the search date should be after ' + sStartDate + ' ,please re-enter !' );
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
           // alert('请输入结束时间!');
            alert('Please input the end time!');
            fm.endday.focus();
            return false;
         }
         if (! checkDate2(fm.endday.value)) {
            alert('Invalid end time entered,\r\n Please enter the end time in the YYYY.MM.DD format!');
            fm.endday.focus();
            return false;
         }
         if (! checktrue2(fm.endday.value)) {
            //alert('结束时间不能大于当前时间!');
            alert('End time cannot be later than current time!');
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
           // alert('起始时间应该在结束时间之前!');
            alert('Start time cannot be earlier than the end time!');
            fm.startday.focus();
            return false;
         }
         fm.start.value = tmp = trim(fm.startday.value);
         fm.end.value = trim(fm.endday.value);
      }
      else{
          fm.end.value = "";
          fm.start.value = "";
      }
      return true;
   }

   function searchInfo () {
      var fm = document.inputForm;
      var usernumber = fm.usernumber.value;
      if (usernumber == ''){
        alert('Please input the group number!');
        return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'search';
      fm.target="_self";
      fm.submit();
   }

   function WriteDataInExcel(){
 <% if(arraylist==null || arraylist.size()<1){ %>
      alert("No data,no output.");
      return;
 <% }else{%>
      var fm = document.inputForm;
      fm.op.value = 'bakdata';
      fm.target="top";
      fm.submit();
  <%}%>
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
<form name="inputForm" method="post" action="grpQuryAction.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="start" value="<%= startday + "" %>">
<input type="hidden" name="end" value="<%= endday + "" %>">
<input type="hidden" name="op" value="">
<script language="JavaScript">
  if(parent.frames.length>0)
    parent.document.all.main.style.height="880";
</script>
  <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
     <td height="26" align="center" class="text-title" background="image/n-9.gif">Group ringtone operation query</td>
   </tr>
   <tr>
   <td align="center">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="98%">
     <tr>
       <td id="id_usernumber" style="display:" width="60%">
         Group number&nbsp;
         <input type="text" name="usernumber" value="<%= usernumber %>"  maxlength="20" class="input-style0" style="width:120px">
       </td>
     </tr>
     <tr>
       <td width="40%" height=30>
         Operation type&nbsp;
         <select name="opcode" style="width:180px" class="input-style0">
           <option value="202">Group upload ringtone</option>
           <option value="204">Group time segment ringtone</option>
           <option value="205">Group ringtone delete</option>
	  </select>
        </td>
      <td><input type="checkbox" name="checkTime" value="on"<%= checkflag ? " checked" : "" %>  onclick="onCheckTime()" >Time segment(YYYY.MM.DD)
     </td>
     </tr>
     <tr>
     <td width="40%" height=30>
      Start time&nbsp;
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:120px">
     </td>
	 <td width="60%" >
      End time&nbsp;
      <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:120px">
      &nbsp;<img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
     </td>
     </tr>
     </table>
  </td>
  </tr>
  <%
     if(op.equals("search") && !usernumber.equals("")){
         out.println("<tr><td height=30 valign=bottom>");
         out.println("&nbsp;Group number:&nbsp;"+usernumber);
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

     <table width="100%" border="0" cellspacing="1" cellpadding="1" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="table-title1">
         <td height="30" width="60" align="center">
              <div align="center">Operation time</div>
          </td>
          <td height="30" width="100" align="center">
              <div align="center">Song name</div>
          </td>
          <td height="30" width="60" align="center">
              <div align="center">Multiply interface</div>
          </td>
          <td height="30" width="80" align="center">
              <div align="center">Operation source</div>
          </td>
             <td height="30" width="120"  align="center">
              <div align="center">Notes:</div>
          </td>
        </tr>

 <%
   			if(size==0){
			%>
			<tr><td align="center" colspan="10">No record matched the criteria!</td>
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
                out.print("<td align=center>"+(String)map.get("optime")+"</td>");
                out.print("<td >"+(String)map.get("ringname")+"</td>");
                out.print("<td >"+(String)map.get("opermode")+"</td>");
                out.print("<td >"+(String)map.get("opersource")+"</td>");
                out.print("<td >"+(String)map.get("operdesc")+"</td>");
                out.print("</td></tr>");
      }
       session.setAttribute("ResultSession",arraylist);

 %>
        <tr>
        <td width="100%" colspan="7">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>&nbsp;<%= arraylist.size() %>&nbsp;entries in total&nbsp;<%= pagecount %>&nbsp;pages&nbsp;&nbsp;You are now on Page &nbsp;<%= i+1 %>&nbsp;</td>
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
        sysInfo.add(sysTime + operName + " Exception occourred in the process of subscriber state query!");//用户状态操作查询过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occourred in the process of subscriber state query!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpQuryAction.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

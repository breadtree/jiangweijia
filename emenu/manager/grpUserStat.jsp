<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.ManGroup" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
	String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");	
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");	
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        String  errmsg = "";
        boolean flag =true;
       if (operID  == null){ 
          errmsg = "Please log in to the system first!";
          flag = false;
      }
      else if (purviewList.get("11-6") == null) {
         errmsg = "You have no access to this function!";
         flag = false;
       }
	   if(!flag){
%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script>
<%
        }
	else{
	    String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
        HashMap   map   = new HashMap();
	    String    startday = "";
	    String    endday   = "";
	    String    checkflag  = "";
	    ArrayList arraylist = new ArrayList();     
        checkflag = request.getParameter("checkflag") == null ? "1" : ((String)request.getParameter("checkflag")).trim();
        startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
        endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
        String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
        String optSCP = "";
        if(startday.equals("")){
           Date today  =  new Date();
           int  year  = today.getYear()+1900;
           int  month  = today.getMonth() + 1;
           String strMonth = Integer.toString(month);
           if(month<10)
              strMonth = "0"  + strMonth;
           endday = Integer.toString(year) + "." + strMonth;
           if(month-3<=0)
              year = year -1;
           month = (month -3 +12)%12;
           if(month==0)
             month = 12;
           strMonth = Integer.toString(month);
           if(month<10)
              strMonth = "0"  + strMonth;
           startday   = Integer.toString(year) + "." + strMonth;
        }     
        ManGroup   mangroup   = new ManGroup();
        ArrayList scplist = mangroup.getScpList();
        for (int i = 0; i < scplist.size(); i++) {
           if(i==0 && scp.equals(""))
              scp = (String)scplist.get(i);
           optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>"; 
        }  
        map.put("scp",scp);
        map.put("checkflag",checkflag);
        map.put("startday",startday);
        map.put("endday",endday);
 //change by wxq 2005.06.15 for version 3.16.01
            zxyw50.Purview purview = new zxyw50.Purview();
            ArrayList tmpList = purview.getOperRights(operID);
            ArrayList resultList = purview.getOperManageArea(tmpList);
            arraylist = mangroup.getGrpUserStat(map,resultList);
            //end
	    int thepage = 0 ;
        int pagecount = 0;
        int records = 20;
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
<title>Query group user person-time</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body class="body-style1" onload="initform(document.forms[0])" >

<script language="javascript">
   function initform(pform){
      firstPage();
      var value = "<%= checkflag %>"
      pform.checkflag[value].checked = true;
      
      var temp = "<%= scp %>";
      for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }
     
   }
   
   function searchBySP(){
		fm = document.InputForm;
		fm.page.value=0;
		fm.submit();	
	}
   
   function toPage (page) {
      document.InputForm.page.value = page;
      document.InputForm.submit();
   }
  
   function checkInfo () {
      var fm = document.InputForm;
      var tmp = '';
      if (fm.checkflag[1].checked) {
         if (trim(fm.startday.value) == '') {
            alert('Please enter the start time!');//请输入起始时间
            fm.startday.focus();
            return false;
         }
         if (! checkDate1(fm.startday.value)) {
            alert('Invalid start time entered. \r\n Please enter the start time in the YYYY.MM format');//起始时间输入错误,\r\n请按YYYY.MM输入起始时间!
            fm.startday.focus();
            return false;
         }
         if (! checktrue1(fm.startday.value)) {
            alert('Start time cannot be later than the current time!');//起始时间不能大于当前时间
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
            alert('Please enter the end time!');//请输入结束时间
            fm.endday.focus();
            return false;
         }
         if (! checkDate1(fm.endday.value)) {
            alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM format');//结束时间输入错误,\r\n请按YYYY.MM输入起始时间!
            fm.endday.focus();
            return false;
         }
         if (! checktrue1(fm.endday.value)) {
            alert('End time should be later than the current time!');//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate1(fm.startday.value,fm.endday.value)) {
            alert('Start time should be prior to the end time!');//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }		 
      }
	  else {
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
            alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM.DD format!');//结束时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!
            fm.endday.focus();
            return false;
         }
         if (! checktrue2(fm.endday.value)) {
            alert('End time should be later than the current time!');//结束时间不能大于当前时间
            fm.endday.focus();
            return false;
         }
         if (! compareDate2(fm.startday.value,fm.endday.value)) {
            alert('Start time should be prior to the end time!');//起始时间应该在结束时间之前
            fm.startday.focus();
            return false;
         }
	  }
	  return true;
   }

   function searchInfo () {
	  var fm = document.InputForm;
      if (! checkInfo()){
		 return;
	  }
      fm.op.value = 'search';
      fm.submit();
   }


 function onCheckTime(){
	var fm = document.InputForm;
	if(fm.checkflag[0].checked){
       var today  = new Date();
       var year = today.getYear();
       var month = today.getMonth() + 1;
       var day = today.getDate();
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
       var month1 = (month-3 + 12)%12;
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
	 else {
       var today  = new Date();
       var year = today.getYear();
       var month = today.getMonth() + 1;
       var strMonth = "";
       if(month<10)
          strMonth = "0" + month;
       else
          strMonth = month;
       fm.endday.value = year + "." + strMonth;  
       var month1 = (month-3 + 12)%12;
       if(month1==0)
          month1 = 12;
       var year1 = year;
       if(month1>month)
          year1 = year1 - 1;
       if(month1<10)
          strMonth = "0" + month1;
       else
          strMonth = month1;
       fm.startday.value = year1 + "." + strMonth ;  
     }
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
<form name="InputForm" method="post" action="grpUserStat.jsp">
<input type="hidden" name="op" value="<%= op%>">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height=600;
</script>
<table border="0" width="90%" cellspacing="0" cellpadding="0" class="table-style2" height=hei align="center">
  <tr>
    <td valign="top" height="35">
	    <table class="table-style2" width="100%" >
	    <tr>
          <td height="26" colspan=3 align="center" class="text-title" >Query group user person-time</td>
        </tr>
        <tr>
             <td width="50%">
             Please select SCP<br> <select name="scplist" size="1" class="input-style1">
              <% out.print(optSCP); %>
             </select>
             </td>
             <td width="15%" >Type of query:</td>
             <td width="15%" > <input type="radio" name="checkflag" value="0" onclick="onCheckTime()">Statistics by day
             <td width="20%"> <input type="radio" name="checkflag" value="1" onClick="onCheckTime()">Statistics by month</td>
         </tr>
        </table>
   </td>
   </tr>
   <tr>
   <td>
      <table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2">
       <td width="80">
				Start time
				</td>
			<td ><input type="text" name="startday" value="<%= startday %>" maxlength="20" size="15">
				</td>
			<td width="80">End time
				</td>
				<td ><input type="text" name="endday" value="<%= endday %>" maxlength="20" size="15">
				</td>
		  <td width="11%" align="right"><img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
  <td align="center" >
  <%
        int  record = 0;
        for (int i = 0; i < pagecount; i++) {
          String pageid = "page_"+Integer.toString(i+1);
  %>
     
     <table width="100%" border="0" cellspacing="1" cellpadding="2"  class="table-style2" id="<%= pageid %>" style="display:none" >
         <tr class="table-title1" height=26>
          <td width="70" align="center" ><span class="style1">Date</span></td>
          <td width="100"  align="center"><span class="style1">Total number of group users</span></td>
		  <td width="120"  align="center"><span class="style1">Number of new group user additions</span></td>
          <td width="120"  align="center"><span class="style1">Number of group user removals</span></td>
         </tr>
         <%
   			if(size==0){
			%>
			<tr><td align="center" colspan="10">No record matched the criteria</td>
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
                out.print("<tr bgcolor=" +strcolor + ">");
                out.print("<td align=center>"+(String)map.get("statdate")+"</td>");
                out.print("<td align=right>"+(String)map.get("grpmems")+"</td>");
                out.print("<td align=right>"+(String)map.get("addgrpmems")+"</td>");
                out.print("<td align=right>"+(String)map.get("delgrpmems")+"</td>");
                out.print("</td></tr>");
      }
 %>
 
 <%if(pagecount>1)
 {
 %>
        <tr>   
        <td width="100%" colspan="10">
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
<%}%>        
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
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in querying the person-time of group users!");//集团用户人次查询过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in querying the person-time of group users!");//集团用户人次查询过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpUserStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>

<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
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
        zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
      }
      else if (purviewList.get("4-28") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-28"))) {
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
          HashMap   map   = new HashMap();
	  String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();


        manSysPara  syspara = new manSysPara();
	    String    startday = "";
	    String    endday   = "";
	    String    checkflag  = "";
	    ArrayList arraylist = new ArrayList();

        checkflag = request.getParameter("checkflag") == null ? "1" : ((String)request.getParameter("checkflag")).trim();
        startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
        endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
        String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
        String serareano = request.getParameter("serareano") == null ? "0" : ((String)request.getParameter("serareano")).trim();
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

        ArrayList scplist = syspara.getScpList();
        for (int i = 0; i < scplist.size(); i++) {
           if(i==0 && scp.equals(""))
              scp = (String)scplist.get(i);
           optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
        }
           ArrayList  serviceList = null;
 	if(!scp.equals("")){
        serviceList = syspara.getServiceArea(scp);
	}
        map.put("scp",scp);
        map.put("serareano",serareano);
        map.put("checkflag",checkflag);
        map.put("startday",startday);
        map.put("endday",endday);
        manStat   manstat   = new manStat();
        arraylist = manstat.getSysUserOps(map);

        if(op.equals("bakdata")){
          response.setContentType("application/msexcel");
          short stat_type = XlsNameGenerate.STATISTIC_NONE;
          if(checkflag.equals("0")) {
            stat_type = XlsNameGenerate.STATISTIC_DAY;// by day
          } else if(checkflag.equals("1")) {
            stat_type = XlsNameGenerate.STATISTIC_MONTH;// by month
          }
          String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "srvAreaPersonTime", stat_type);
          response.setHeader("Content-disposition","inline; filename=" + file_name);
          out.clear();
          out.println("<table border='1'>");
          //out.println("<tr><td>日期</td><td>开户次数</td><td>销户次数</td><td>强制销户次数</td><td>激活用户次数</td><td>暂停用户次数</td><td>强制激活用户次数</td><td>强制去激活用户次数</td></tr>");
          out.println("<tr><td>Date</td><td>Account opening time</td><td>Account cancellation time</td><td>Account cancel forcibly time</td><td>Account activated time</td><td>Account suspended  time</td><td>Account activate forcely time</td><td>Account deactivate forcely time</td></tr>");

          for (int i = 0; i <arraylist.size(); i++) {
            map = (HashMap)arraylist.get(i);
            out.println("<tr><td>&nbsp;"+(String)map.get("statdate")+"</td><td>"+(String)map.get("curadduser")+"</td><td>"+(String)map.get("curdeluser")+"</td><td>"+(String)map.get("forcedeluser")+"</td><td>"+(String)map.get("activeuser")+"</td><td>"+(String)map.get("deactiveuser")+"</td><td>"+(String)map.get("forceactive")+"</td><td>"+(String)map.get("forcedeactive")+"</td></tr>");
          }
          out.println("</table>");
          return;
        }

        int thepage = 0 ;
        int pagecount = 0;
        int records = 15;
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
<title>Service area person-time statistics</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body class="body-style1" onload="initform(document.forms[0])" >

<script language="javascript">

   function initform(pform){
      firstPage();
      var value = "<%= checkflag %>";
      pform.checkflag[value].checked = true;

      var temp = "<%= scp %>";
      for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }
     var temp2 = "<%= serareano %>";
      for(var i=0; i<pform.serareano.length; i++){
        if(pform.serareano.options[i].value == temp2){
           pform.serareano.selectedIndex = i;
           break;
        }
     }
   }


   function toPage (page) {
      document.InputForm.page.value = page;
       document.InputForm.op.value="search";
      document.InputForm.target="_self";
     document.InputForm.submit();
   }

   function checkInfo () {
      var fm = document.InputForm;
      var tmp = '';
      if (fm.checkflag[1].checked) {
         if (trim(fm.startday.value) == '') {
            alert('Please input the start time!');
            fm.startday.focus();
            return false;
         }
         if (! checkDate1(fm.startday.value)) {
            // alert('起始时间输入错误,\r\n请按YYYY.MM输入起始时间!');
            alert('Start time input error,please input start time with the format of YYYY.MM!');
            fm.startday.focus();
            return false;
         }
         if (! checktrue1(fm.startday.value)) {
            //alert('起始时间不能大于当前时间!');
            alert('Start time cannot be later than current time!');
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
           // alert('请输入结束时间!');
            alert('Please input end time!');
            fm.endday.focus();
            return false;
         }
         if (! checkDate1(fm.endday.value)) {
           // alert('结束时间输入错误,\r\n请按YYYY.MM输入起始时间!');
            alert('End time input error,please input the start time with the format of YYYY.MM');
            fm.endday.focus();
            return false;
         }
         if (! checktrue1(fm.endday.value)) {
            //alert('结束时间不能大于当前时间!');
            alert('End time cannot be later than current time!');
            fm.endday.focus();
            return false;
         }
         if (! compareDate1(fm.startday.value,fm.endday.value)) {
           // alert('起始时间应该在结束时间之前!');
            alert('Start time cannot be later than end time!');
            fm.startday.focus();
            return false;
         }
      }
	  else {
	      if (trim(fm.startday.value) == '') {
            //alert('请输入起始时间!');
            alert('Please input start time!');
            fm.startday.focus();
            return false;
         }
         if (! checkDate2(fm.startday.value)) {
            //alert('起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
            alert('The input time input error,please input start time with the format of YYYY.MM.DD!');
            fm.startday.focus();
            return false;
         }
         if (! checktrue2(fm.startday.value)) {
           // alert('起始时间不能大于当前时间!');
            alert('Input time cannot be later than current time!');
            fm.startday.focus();
            return false;
         }
         if (trim(fm.endday.value) == '') {
           // alert('请输入结束时间!');
            alert('Please input end time!');
            fm.endday.focus();
            return false;
         }
         if (! checkDate2(fm.endday.value)) {
           // alert('结束时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!');
            alert('End time input error,please input start time with the format of YYYY.MM.DD!');
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
            //alert('起始时间应该在结束时间之前!');
             alert('Start time should be earlier than the end time!');
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
      fm.target="_self";
      fm.submit();
   }

  function WriteDataInExcel(){
 <% if(arraylist==null || arraylist.size()<1){ %>
      //alert("没有统计数据,无需导出。");
       alert("No statistic data for export.");
      return;
 <% }else{%>
      var fm = document.InputForm;
      fm.op.value = 'bakdata';
      fm.target="top";
      fm.submit();
  <%}%>
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
<form name="InputForm" method="post" action="curAreaUserStat.jsp">
<input type="hidden" name="op" value="<%= op%>">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height=600;
</script>
<table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2" height=hei>
  <tr>
    <td valign="top" height="35">
	    <table class="table-style2" width="100%">
	    <tr>
          <td height="26" colspan=4 align="center" class="text-title" >Statistic of person/times in service area</td>
        </tr>
        <tr>
             <td>
             SCP
             <select name="scplist" size="1" class="input-style2">
              <% out.print(optSCP); %>
             </select>
             </td>
              <td >Service area
        <select name="serareano" class="select-style1"  >
        <%if(purview.CheckOperatorRightAllSerno(session,"4-7")){%>
        <option value="0">-All service area-</option>
        <%}
         for (int i = 0; i < serviceList.size(); i++) {
               map = (HashMap)serviceList.get(i);
       	       out.println("<option value=" +  (String)map.get("serareano")  + ">" + (String)map.get("serareaname")  + "</option>");
       	 }
        %>
        </select>
      </td>
             <td width="15%" >&nbsp;&nbsp;Query type:</td>
             <td width="15%"> <input type="radio" name="checkflag" value="0" onclick="onCheckTime()">Daily
             <td width="20%"> <input type="radio" name="checkflag" value="1" onClick="onCheckTime()">Monthly</td>
         </tr>
        </table>
   </td>
   </tr>
   <tr>
   <td>
      <table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2">
       <td width="80">
				&nbsp;&nbsp;Start time
				</td>
			<td ><input type="text" name="startday" value="<%= startday %>" maxlength="20" size="20">
				</td>
			<td width="80">End time
				</td>
				<td ><input type="text" name="endday" value="<%= endday %>" maxlength="20" size="20">
				</td>
		  <td width="11%" align="right"><img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()"></td>
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
         <tr class="table-title1">
          <td width="70" align="center" ><span title="Date">Date</span></td>
          <td width="50"  align="center"><span title="Account opening number">Open</span></td>
		    <td width="60"  align="center"><span title="Account cancellation number">Close</span></td>
          <td width="50"  align="center"><span title="Forcely account cancellation number">Forcely Close</span></td>
          <td width="60"  align="center"><span title="Activated subscrbier number">Active</span></td>
          <td width="60"  align="center"><span title="Suspend subscriber number">Suspend</span></td>
          <td width="70"  align="center"><span title="Forcely activate subscriber number">Forcely Activate</span></td>
          <td width="70"  align="center"><span title="Forcely deactivate subscriber number">Forcely Deactivate</span></td>
         </tr>
         <%
   			if(size==0){
			%>
			<tr><td align="center" colspan="10">There are no records meeting the condition!</td>
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
                out.print("<td align=right>"+(String)map.get("curadduser")+"</td>");
                out.print("<td align=right>"+(String)map.get("curdeluser")+"</td>");
                out.print("<td align=right>"+(String)map.get("forcedeluser")+"</td>");
                out.print("<td align=right>"+(String)map.get("activeuser")+"</td>");
                out.print("<td align=right>"+(String)map.get("deactiveuser")+"</td>");
                out.print("<td align=right>"+(String)map.get("forceactive")+"</td>");
                out.print("<td align=right>"+(String)map.get("forcedeactive")+"</td>");
                out.print("</td></tr>");
      }

 %>
        <tr>
        <td width="100%" colspan="10">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>Total:<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;Now on page:<%= i+1 %>&nbsp;</td>
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
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occourred in the statistics of service area person-time!");
        sysInfo.add(sysTime + operName + e.toString());
       // vet.add("业务区人次统计过程出现错误!");
        vet.add("Error occourred in the statistics of service area person-time!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="curAreaUserStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>

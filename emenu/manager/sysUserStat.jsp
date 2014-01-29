<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    //add by gequanmin 2005-07-04
    String usefeeaccount = CrbtUtil.getConfig("usefeeaccount","0");
    //add end
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
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
      }
      else if (purviewList.get("4-8") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-8"))) {
         errmsg = "You have no access to this function!";//You have no access to this function!
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
         String userringtype=request.getParameter("userringtype") == null ? "0" : ((String)request.getParameter("userringtype")).trim();
            HashMap    map   = new HashMap();


	    String   startday = "";
	    String   endday   = "";
	    String   checkflag  = "";
	    ArrayList arraylist = new ArrayList();

        String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
        checkflag = request.getParameter("checkflag") == null ? "1" : ((String)request.getParameter("checkflag")).trim();
        startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
        endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
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
        manSysPara syspara = new manSysPara();
        ArrayList scplist = syspara.getScpList();
        for (int i = 0; i < scplist.size(); i++) {
           if(i==0 && scp.equals(""))
              scp = (String)scplist.get(i);
           optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
        }

        map.put("scp",scp);
        map.put("serareano","-1");
        map.put("checkflag",checkflag);
        map.put("startday",startday);
        map.put("endday",endday);
 	    manStat   manstat  = new manStat();
            if("search".equals(op) || op.equals("bakdata")){
              if("1".equals(userringtype))
              arraylist = manstat.queryServiceUsers1(map);
              else
              arraylist = manstat.queryServiceUsers(map);
            }
            if(op.equals("bakdata")){
              response.setContentType("application/msexcel");
              short stat_type = XlsNameGenerate.STATISTIC_NONE;
              if(checkflag.equals("0")) {
                stat_type = XlsNameGenerate.STATISTIC_DAY;
              } else if(checkflag.equals("1")) {
                stat_type = XlsNameGenerate.STATISTIC_MONTH;
              }
          String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "SysUser", stat_type);
          response.setHeader("Content-disposition","inline; filename=" + file_name);
              out.clear();
              out.println("<table border='1'>");
              boolean blBeijiao = true;
              if(arraylist.size()>0){
                HashMap map1 = (HashMap)arraylist.get(0);
                if(map1.size()<=4)
                blBeijiao = false;
              }
              if(blBeijiao)
              out.println("<tr><td>Date</td><td>Number of subscribers activated</td><td>Number of deactivated subscribers</td><td>Number of subscribers deactivated forcedly</td><td>Number of <br>non-IN <br>subscribers</td><td>Number of post-paid IN subscribers</td><td>Number of prepaid IN subscribers</td></tr>");
              //out.println("<tr><td>日期</td><td>激活用户数</td><td>暂停用户数</td><td>强制去激活用户数</td><td>非智能网用户数</td><td>后付费用户数</td><td>预付费用户数</td></tr>");
              else
              //out.println("<tr><td>日期</td><td>开户用户数</td><td>销户用户数</td></tr>");
              out.println("<tr><td>Date</td><td>Number of subscribers activated</td><td>Number of subscribers deactivated</td></tr>");
              for (int i = 0; i <arraylist.size(); i++) {
                map = (HashMap)arraylist.get(i);
                if(blBeijiao)
                out.println("<tr><td>&nbsp;"+(String)map.get("statdate")+"</td><td>"+(String)map.get("activeuser")+"</td><td>"+(String)map.get("deactiveuser")+"</td><td>"+(String)map.get("forceuser")+"</td><td>"+(String)map.get("normaluser")+"</td><td>"+(String)map.get("inuser")+"</td><td>"+(String)map.get("ppcuser")+"</td></tr>");
                else
                out.println("<tr><td>&nbsp;"+(String)map.get("statdate")+"</td><td>"+(String)map.get("activeuser")+"</td><td>"+(String)map.get("deactiveuser")+"</td></tr>");
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
<title>Statistics on the number of subscriber in the system</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body class="body-style1" onload="initform(document.forms[0])" >

<script language="javascript">
   function initform(pform){
      firstPage();
      var value = "<%= checkflag %>"
      pform.checkflag[value].checked = true;

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
            alert('End time should not be later than the current time!');//结束时间不能大于当前时间
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
            alert('End time should not be later than the current time!');//结束时间不能大于当前时间
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
      fm.target="_self";
      fm.submit();
   }

  function WriteDataInExcel(){
    if (! checkInfo()){
		 return;
	  }
      var fm = document.InputForm;
      fm.op.value = 'bakdata';
      fm.target="top";
      fm.submit();
   }

 function onCheckTime(){
	var fm = document.InputForm;
	  <% if("1".equals(CrbtUtil.getConfig("usecalling","0"))){  %>
      if( document.InputForm.userringtype.value == "1"){
        if(fm.checkflag[1].checked){
          alert("Calling service cannot be statistical on monthly!");//主叫业务不能按月统计
         fm.checkflag[0].checked=true;
         onCheckTime();
          return;
        }
       }
      <%}%>
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
        <%
        if(!"search".equals(op)){
        %>
         return;
        <%}%>
  	var obj  = eval("page_" + num);
        if(obj)
        obj.style.display="none";
  }

  function onpage(num){
        <%
        if(!"search".equals(op)){
        %>
         return;
        <%}%>
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

   function onUsertypeChange(){
       if(document.InputForm.userringtype.value == "1"){
         document.InputForm.checkflag[0].checked=true;
         onCheckTime();
       }
   }


</script>
<form name="InputForm" method="post" action="sysUserStat.jsp">
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
          <td height="26" colspan=1 align="center" class="text-title"  background="image/n-9.gif">Statistics on the number of subscriber in the system</td>
        </tr>
        <tr>
          <td >
       <%
       //String _dis = "";
       if("1".equals(CrbtUtil.getConfig("usecalling","0"))){        %>
           &nbsp;&nbsp;Service type&nbsp;
           <select name="userringtype" size="1" class="input-style2"  onchange="javascript:onUsertypeChange()" >
             <option <% if(userringtype!=null && userringtype.equals("0")) {%> selected <%} %> value="0">Called type</option>
             <option <% if(userringtype!=null && userringtype.equals("1")) {%> selected <%} %> value="1">Calling type</option>
       </select>
       <%} %>
             &nbsp;&nbsp;Please select SCP&nbsp; <select name="scplist" size="1" class="input-style1">
              <% out.print(optSCP); %>
             </select>
             </td>
             </tr>
             <tr>
             <td  align="left" >&nbsp;&nbsp;Type of Statistics:
             <input type="radio" name="checkflag" value="0" onclick="onCheckTime()">Statistics by day
             <input type="radio" name="checkflag" value="1" onClick="onCheckTime()">Statistics by month
</td>
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
		  <td width="11%" align="right"><img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()" title="export in excel file"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
  <td align="center" >
  <%
        if("search".equals(op)){
          if("1".equals(userringtype)){
            int  record = 0;
            for (int i = 0; i < pagecount; i++) {
              String pageid = "page_"+Integer.toString(i+1);
              %>

            <table width="100%" border="0" cellspacing="1" cellpadding="2"  class="table-style2" id="<%= pageid %>" style="display:none" >
              <tr class="table-title1">
                <td width="80" align="center" ><span class="style1">Date</span></td>
                <td width="60"  align="center"><span class="style1">Number of subscribers activated</span></td>
                  <td width="60"  align="center"><span class="style1">Number of<br>Deactivated <br>subscribers</span></td>
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
      out.print("<td align=right>"+(String)map.get("activeuser")+"</td>");
      out.print("<td align=right>"+(String)map.get("deactiveuser")+"</td>");
      out.print("</td></tr>");
    }
    session.setAttribute("ResultSession",arraylist);
    %>
    <tr>
      <td width="100%" colspan="10">
        <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
          <tr>
            <td>&nbsp;<%= arraylist.size() %>&nbsp;entries in total&nbsp;<%= pagecount %>&nbsp;&nbsp;&nbsp;You are now on Page&nbsp;<%= i+1 %>&nbsp;</td>
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
          }else{
          int  record = 0;
          for (int i = 0; i < pagecount; i++) {
            String pageid = "page_"+Integer.toString(i+1);
            %>

            <table width="100%" border="0" cellspacing="1" cellpadding="2"  class="table-style2" id="<%= pageid %>" style="display:none" >
              <tr class="table-title1">
                <td width="80" align="center" ><span title="Date">Date</span></td>
                <td width="60"  align="center"><span title="Number of subscribers activated">Activated</span></td>
                  <td width="60"  align="center"><span title="Number of deactivated subscribers">Deactivated</span></td>
                    <td width="60"  align="center"><span title="Number of subscribers deactivated forcedly">Deactivated forcedly</span></td>
                        <!--add by gequanmin 2005-07-04 -->
                      <%if("1".equals(usefeeaccount)){%>
                       <td width="60"  align="center"><span title="Num of subscribers producing month rental">Num of subscribers producing month rental</span></td>
                      <%}%>
                            <td width="60"  align="center"><span title="Number of non-IN subscribers">Non-IN</span></td>
          <td width="60"  align="center"><span title="Number of post-paid IN subscribers">Post-paid</span></td>
          <td width="60"  align="center"><span title="Number of prepaid IN subscribers">Prepaid IN</span></td>
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
      out.print("<td align=right>"+(String)map.get("activeuser")+"</td>");
      out.print("<td align=right>"+(String)map.get("deactiveuser")+"</td>");
      out.print("<td align=right>"+(String)map.get("forceuser")+"</td>");
      //modify by gequanmin 2005-07-04
       if("1".equals(usefeeaccount)){
       out.print("<td align=right>"+(Integer.parseInt((String)map.get("activeuser"))+Integer.parseInt((String)map.get("deactiveuser"))+Integer.parseInt((String)map.get("forceuser")))+"</td>");
       }
      out.print("<td align=right>"+(String)map.get("normaluser")+"</td>");
      out.print("<td align=right>"+(String)map.get("inuser")+"</td>");
      out.print("<td align=right>"+(String)map.get("ppcuser")+"</td>");
      out.print("</td></tr>");
    }
    session.setAttribute("ResultSession",arraylist);
    %>
    <tr>
      <td width="100%" colspan="10">
        <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
          <tr>
              <td>&nbsp;Total:<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;&nbsp;Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
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
          }
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
        sysInfo.add(sysTime + operName + "Exception occurred in the statistics on the number of system subscribers!");//系统用户数统计过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in the statistics on the number of system subscribers!");//系统用户数统计过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="sysUserStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>

<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manStat" %>

<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String type = request.getParameter("type") == null ? "" : transferString((String)request.getParameter("type"));
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	zxyw50.Purview purview = new zxyw50.Purview();
	String Mon = CrbtUtil.getConfig("iMon","3");
        int iMon = Integer.parseInt(Mon.trim());
    try {
        ArrayList arraylist = null;
        ArrayList opcodelist = null;
        HashMap   map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        if(request.getParameter("type")==null||request.getParameter("type").trim().equals(""))
        {
          if (purviewList.get("4-15") == null) {
            errmsg = "You have no access to this function!";//You have no access to this function
            flag = false;
          }
        }else//人工台
        {
          if (purviewList.get("13-17") == null) {
            errmsg = "You have no access to this function!";//You have no access to this function!
            flag = false;
          }
        }
        if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
        }
        if(flag){
         String usecalling = zte.zxyw50.util.CrbtUtil.getConfig("usecalling","1");
          manStat  manstat = new manStat();
          String   operator = "";
          String   usernumber = "";
          String   startday = "";
          String   endday = "";
          String   opcode = "";
          String   opmode = "";
          String   scp = "";
          String   op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          boolean  checkflag = request.getParameter("checkTime") != null ? true : false;
          String termsstatus ="",restint2="";
          String ifshowtermsstatus=CrbtUtil.getConfig("ifshowtermsstatus","0");
          if(op.equals("search") || op.equals("bakdata")){
            operator = request.getParameter("operator") == null ? "" : transferString((String)request.getParameter("operator"));
            opmode = request.getParameter("opmode") == null ? "0" : ((String)request.getParameter("opmode")).trim();
            scp = request.getParameter("scp") == null ? "" : ((String)request.getParameter("scp")).trim();
            usernumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();

            if (ifshowtermsstatus.equals("1")){
              restint2 = manstat.getUserTermstat(usernumber);
              if (restint2.equals("0")){
                termsstatus = "Normal";
              }else if (restint2.equals("1")){
                termsstatus = "Terms";
              }else if (restint2.equals("2")){
                termsstatus = "Pending";
              }else{
                termsstatus = "The user does not exist!";
              }
            }
            boolean flags = false;
            if("1".equals(type)&&"0".equals(opmode)) {
              manSysPara msp = new manSysPara();
              flags = msp.isAdUser(usernumber);
            }
            if(!flags){
              if(!usernumber.equals("")){
                if(!purview.CheckOperatorRight(session,"4-15",usernumber)){
                  throw new Exception("You have no right to manage this subscriber!");
                }
              }
              opcode = request.getParameter("opcode") == null ? "" : ((String)request.getParameter("opcode")).trim();
              startday = request.getParameter("start") == null ? "" : ((String)request.getParameter("start")).trim();
              endday = request.getParameter("end") == null ? "" : ((String)request.getParameter("end")).trim();
              map.put("usernumber",usernumber);
              map.put("opcode",opcode);
              map.put("startday",startday);
              map.put("endday",endday);
              map.put("operator",operator);
              map.put("scp",scp);
              map.put("isgroup","");
              arraylist = manstat.getOpLog(map);

              if(op.equals("bakdata")){
                response.setContentType("application/msexcel");
                short stat_type = XlsNameGenerate.STATISTIC_NONE;
                if(checkflag) {
                  stat_type = XlsNameGenerate.STATISTIC_DAY;
                }
                String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "userStatusOper", stat_type);
                response.setHeader("Content-disposition","inline; filename=" + file_name);
                out.clear();
                out.println("<table border='1'>");
                out.println("<tr><td>Operation Time</td><td>Operation Type</td><td>Operation Result</td><td >Multilateral Interface</td><td >Operation Source</td><td >Operator</td><td >Subscriber number</td><td >Remark</td></tr>");

                for (int i = 0; i <arraylist.size(); i++) {
                  map = (HashMap)arraylist.get(i);
                  out.println("<tr><td>"+(String)map.get("optime")+"</td><td>"+(String)map.get("opname")+"</td><td>"+(String)map.get("result")+"</td><td>"+(String)map.get("opermode")+"</td><td>"+(String)map.get("opersource")+"</td><td>"+(String)map.get("operator")+"</td><td>"+(String)map.get("usernumber")+"</td><td>"+(String)map.get("opcomment")+"</td></tr>");
                }
                out.println("</table>");
                return;
              }
            } else {
              %>
              <script language="javascript">
                // var str = 'Sorry,you input user number '+<%= usernumber %>+' is advertise ringtone user,cannot be managed by this system!'; //是广告铃音的用户,不能使用本系统进行管理
                alert("Sorry,you input subscriber number "+"<%= usernumber %>"+" is an advertisement ringtone subscriber,it cannot be managed by this system!");
                alert(str);
                document.URL = 'quryUserAction.jsp?type=1';
                </script>
                <%
                }
              }
              opcodelist = manstat.getOpCode();
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

              String optSCP = "";
              ArrayList scplist = manstat.getScpList();
              for (int i = 0; i < scplist.size(); i++)
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
              %>

<html>
<head>
<title>Query subscriber status operations</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../base/JsFun.js"></SCRIPT>
<body class="body-style1" onload="loadPage();" >

<script language="javascript">

   function loadPage(){
     var fm = document.inputForm;
     firstPage();
     var sTmp = "<%=  opcode  %>";
     if(sTmp!='')
         document.forms[0].opcode.value = sTmp;
     var opmode = "<%= opmode %>";
     if(opmode!=1)
        opmode = 0;
     fm.opmode.value = opmode;
     var scp = "<%= scp %>";
     if(scp!='')
        fm.scp.value = scp;
     onOpmode();
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
          fm.endday.value = getCurrentDate();
		 var iMon=<%=iMon%>;
          fm.startday.value = getMonthPriorDate(iMon-1); 
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
      var  opmode = fm.opmode.value;
      if(opmode==0){
         if(!isUserNumber(value,'The subscriber number ')){
            fm.usernumber.focus();
            return;
         }
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
         var  value = trim(fm.startday.value);
		 var iMon=<%=iMon%>;
         var sStartDate = getMonthPriorDate(iMon-1);
         var tmp1 = sStartDate.substring(0,4) + sStartDate.substring(5,7) + sStartDate.substring(8,10);
         var tmp2 = value.substring(0,4) + value.substring(5,7) + value.substring(8,10);
         if(tmp1 > tmp2 )      {
            alert('Sorry, you only can search the log after the  ' + sStartDate + ', please re-enter the search date!' );
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
      if (! checkInfo())
         return;
      fm.op.value = 'search';
      fm.target="_self";
      fm.operator.value=fm.dispoperator.value;
      fm.submit();
   }

   function WriteDataInExcel(){
     if (! checkInfo())
     return;
     var fm = document.inputForm;
     fm.op.value = 'bakdata';
     fm.target="top";
     fm.operator.value=fm.dispoperator.value;
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

  function onOpmode(){
     var fm = document.inputForm;
     if(fm.opmode.value==0){
        document.inputForm.operator.value = '';
        document.inputForm.dispoperator.value = '';
        document.all('id_usernumber').style.display= 'block';
        document.all('id_operator').style.display= 'none';
     }
     else {
        document.inputForm.usernumber.value = '';
        <%if(purview.CheckOperatorRightAllSerno(session,"4-15")){%>
                document.inputForm.dispoperator.value = "<%=operator %>";
	<%}else{%>
        	document.inputForm.dispoperator.value="<%=operName%>";
        	document.inputForm.dispoperator.disabled=true;
	<%}%>
        document.all('id_usernumber').style.display= 'none';
        document.all('id_operator').style.display= 'block';
     }
   }

</script>
<form name="inputForm" method="post" action="quryUserAction.jsp">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<input type="hidden" name="start" value="<%= startday + "" %>">
<input type="hidden" name="end" value="<%= endday + "" %>">
<input type="hidden" name="op" value="">
<input type="hidden" name="type" value="<%=type%>">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="900";
</script>
  <table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
   <tr >
          <td height="50"  align="center" class="text-title">Query subscriber status operations</td>
   </tr>
   <tr>
   <td align="center">
     <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="98%">
     <tr>
     <td width="40%" height=30>
        Type of query<br>
        <select name="opmode" style="width:150px" class="input-style0" onchange="onOpmode()">
        <option value=0 selected >Query by subscriber</option>
        <option value=1>Query by operator</option>
        </select>
     </td>
     <td id="id_operator" style="display:none" width="60%">
       Operator name<input type="hidden" name="operator">
      <input type="text" name="dispoperator" value="<%= operator %>"  maxlength="20" class="input-style0" style="width:50px">
      SCP <select name="scp" size="1" class="input-style1" style="width:60px">
             <% out.print(optSCP); %>
      </td>
      <td id="id_usernumber" style="display:none" width="60%">
       The subscriber number &nbsp;
       <input type="text" name="usernumber" value="<%= usernumber %>"  maxlength="20" class="input-style0" style="width:120px">
      </td>
      </tr>
     <tr>
	  <td width="40%" height=30>
      Operation type<br>
      <select name="opcode" style="width:270px" class="input-style0">
	  <option value="">All operations</option>
	  <%
	     for(int j=0; j<opcodelist.size();j++){
	       map = (HashMap)opcodelist.get(j);
		   String tempopcode=(String)map.get("opcode");
		   int iopcode=Integer.parseInt(tempopcode);
		   if(usecalling.equals("1"))
		   {
	       out.println("<option value="+(String)map.get("opcode") + " >" + (String)map.get("opname") + "</option>");
		   }
		   else
		   {
		      if((iopcode < 201) || (iopcode > 207))
		   {
	       out.println("<option value="+(String)map.get("opcode") + " >" + (String)map.get("opname") + "</option>");
	     }
		   }
	     }
	  %>
	  </select></td>
      <td><input type="checkbox" name="checkTime" value="on"<%= checkflag ? " checked" : "" %>  onclick="onCheckTime()" >The time periods YYYY.MM.DD
     </td>
     </tr>
     <tr>
     <td width="40%" height=30>
      Start time&nbsp;
      <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">
     </td>
	 <td width="60%" >
      End time&nbsp;
      <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:100px">
      <img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
     </td>
     </tr>
     </table>
  </td>
  </tr>
  <%
     if(op.equals("search") && !usernumber.equals("")){
      out.println("<tr><td height=30 valign=bottom>");
        if (ifshowtermsstatus.equals("0")){
	  out.println("&nbsp;The subscriber number :&nbsp;"+usernumber + "&nbsp;&nbsp;&nbsp;&nbsp;Current status:<font style='color: #FF0000'>" + manstat.getUserStat(usernumber) + "</font>");
        }else{
          out.println("&nbsp;The subscriber number :&nbsp;"+usernumber + "&nbsp;&nbsp;&nbsp;&nbsp;Current status:<font style='color: #FF0000'>" + termsstatus + "</font>");
        }
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
         <tr class="tr-ring">
           <td height="30" width="60">
              <div align="center">Operation time</div>
          </td>
          <td height="30" width="70">
              <div align="center">Operation type</div>
          </td>
          <td height="30" width="50">
              <div align="center">Operation result</div>
          </td>
          <td height="30" width="50">
              <div align="center">Multilateral interface</div>
          </td>
          <td height="30" width="50">
              <div align="center">Operation source</div>
          </td>
             <td height="30" width="50">
              <div align="center">Operator</div>
          </td>
             <td height="30" width="50">
              <div align="center">Subscriber number</div>
          </td>
             <td height="30" width="180">
              <div align="center">Remark</div>
          </td>
        </tr>

 <%
   			if(size==0){
			%>
			<tr><td class="table-style2" align="center" colspan="10">No record matched the criteria</td>
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
                out.print("<td align=center>"+(String)map.get("opname")+"</td>");
                out.print("<td align=center>"+(String)map.get("result")+"</td>");
                out.print("<td >"+(String)map.get("opermode")+"</td>");
                out.print("<td >"+(String)map.get("opersource")+"</td>");
                out.print("<td >"+(String)map.get("operator")+"</td>");
                out.print("<td >"+(String)map.get("usernumber")+"</td>");
                out.print("<td >"+(String)map.get("opcomment")+"</td>");
                out.print("</td></tr>");
      }

 %>
        <tr>
        <td width="100%" colspan="7">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td>Total:<%= arraylist.size() %>,<%= pagecount %>page(s),Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
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
        sysInfo.add(sysTime + operName + "Exception occurred in querying subscriber status operations!");//用户状态操作查询过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in querying subscriber status operations!");//用户状态操作查询过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="quryUserAction.jsp?type=<%=type%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

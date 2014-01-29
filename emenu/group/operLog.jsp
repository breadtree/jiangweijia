<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<html>
<head>
<title>Operator log</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script src="../pubfun/JsFun.js"></script>
</head>
<script language="javascript">

   function onSearch () {
      // 检查起始时间
      if (trim(document.view.operID.value) == '') {
         //alert('请选择需要查询的操作员!');
         alert("Please select the operator for the query!");
         return;
      }
      if (document.view.checkTime.checked) {
         var value = trim(document.view.start.value);
         if(value==''){
            //alert('请输入起始时间,格式为YYYY.MM.DD!');
            alert("Please input the start date, the format is YYYY.MM.DD!");
            document.view.start.focus();
            return;
         }
         if (! checkDate2(value)) {
            //alert('请输入正确的起始时间!\r\n正确的时间格式为YYYY.MM.DD');
            alert("Please input the right start date, the format is YYYY.MM.DD!");
            document.view.start.focus();
            return;
         }
         value = trim(document.view.end.value);
         if(value==''){
            //alert('请输入结束时间,格式为YYYY.MM.DD!');
            alert("Please input the correct start time,the correct time format is YYYY.MM.DD!");
            document.view.start.focus();
            return;
         }
         if (! checkDate2(value)) {
            //alert('请输入正确的结束时间!\r\n正确的时间格式为YYYY.MM.DD');
            alert("Please input the correct end time,the correct time format is YYYY.MM.DD!");
            document.view.end.focus();
            return;
         }
         if (! compareDate2(document.view.start.value,document.view.end.value)) {
           // alert('起始时间应在结束时间之前!');
           alert("The start time should be earlier than the end time!");
            document.view.start.focus();
            return;
         }
      }
      document.view.operName.disabled = false;
      document.view.submit();
   }

    function toPage (page) {
       document.view.page.value = page;
       document.view.operName.disabled = false;
       document.view.submit();
    }

   function onCheckTime () {
      if (document.view.checkTime.checked) {
        var today  = new Date();
        var year = today.getYear();
        var month = today.getMonth() + 1;
        var day = today.getDate();
        document.view.end.disabled = false;
        document.view.start.disabled = false;
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
        document.view.end.value = year + "." + strMonth+"."+strDay;
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
        document.view.start.value = year1 + "." + strMonth+"." + strDay ;
        document.view.start.disabled = false;
        document.view.end.disabled = false;
        document.view.start.focus();
      }
      else {
         document.view.start.value ='';
         document.view.end.value ='';
         document.view.start.disabled = true;
         document.view.end.disabled = true;
      }
   }
</script>
<body class="body-style1">
<%
    try {
        String operID = (String)session.getAttribute("OPERID");
        String serviceKey = (String)session.getAttribute("SERVICEKEY");
        ArrayList list = new ArrayList();
        HashMap map = new HashMap();
        Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
        if (purviewList.get("12-5") == null)
            operID = null;
        if (operID != null) {
            int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
            // 开始时间和结束时间
            String startTime = "";
            String endTime = "";
            if (request.getParameter("checkTime") != null) {
                startTime = request.getParameter("start") == null ? "" : ((String)request.getParameter("start")).trim();
                endTime = request.getParameter("end") == null ? "" : ((String)request.getParameter("end")).trim();
            }
            String selectOperID = request.getParameter("operID") == null ? "" : ((String)request.getParameter("operID")).trim();
            String selectOperName = request.getParameter("operName") == null ? "" : ((String)request.getParameter("operName")).trim();
            if (selectOperID.length() > 0)
                list = purview.getOperLog(selectOperID,serviceKey,startTime,endTime);
            if ((thepage + 1) * 20 > list.size())
                thepage = (list.size() - 1) / 20;
%>

<form name="view" method="post" action="operLog.jsp">
<input type="hidden" name="operID" value="<%= selectOperID %>">
<input type="hidden" name="page" value="<%= thepage %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="500" class="table-style2">
  <tr bgcolor="#FFFFFF">
    <td width="74%" height="22" align="left"><input type="text" name="operName" value="<%= selectOperName %>" disabled  maxlength="12">&nbsp;&nbsp;<input type="checkbox" name="checkTime" <%= startTime.length() == 0 ? "" : "checked " %>value="on" onclick="javascript:onCheckTime()">Start time(YYYY.MM.DD)</td>
    <td width="26%" height="22" align="right"></td>
 </tr>
 <tr bgcolor="#FFFFFF">
    <td width="74%" height="22"  align="left"><input type="text" name="start" value="<%= startTime %>" maxlength="10">&nbsp;to&nbsp;<input type="text" name="end" value="<%= endTime %>"  maxlength="10"></td>
    <td width="26%" height="22" align="right"><input type="button" name="search" value="Query" class="button-style1" onclick="javascript:onSearch()"></td>
  </tr>
  <tr>
    <td colspan="4" valign="top">
      <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#77BEEE" bordercolordark="#ffffff">
        <tr class="table-title1">
          <!--<td width="50">Operator</td>-->
          <td width="140" height="24">Operation time</td>
          <!--<td width="80">Host name</td>-->
          <td width="120" height="24">Action</td>
          <td width="250" height="24">Description</td>
        </tr>
<script language="JavaScript">
	if(parent.parent.frames.length>0){

		parent.parent.document.all.main.style.height=500;
		}
</script>
<%
            int count = list.size() == 0 ? 20 : 0;
			for (int i = thepage * 20; i < thepage * 20 + 20 && i < list.size(); i++) {
                map = (HashMap)list.get(i);
				count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "#f5fbff" : "" %>" class="table-style2">

          <!--<td><%= (String)map.get("OPERNAME") %>&nbsp;</td>-->
          <td height="24"><%= (String)map.get("OPERTIME") %>&nbsp;</td>
          <!--<td><%= (String)map.get("HOSTNAME") %>&nbsp;</td>-->
          <td height="24"><%= (String)map.get("OPERTYPE") %>&nbsp;</td>
          <td height="24"><%= (String)map.get("DESCRIPTION") %>&nbsp;</td>
        </tr>
<%
            }
%>
      </table>
    </td>
  </tr>
<%
            if (list.size() > 20) {
%>
  <tr>
    <td colspan="4" align="right">
      &nbsp;<%= list.size() + "" %>&nbsp;entries in total&nbsp;&nbsp;No.&nbsp;<%= thepage + 1 %>&nbsp;page&nbsp;&nbsp;
      <a href="javascript:toPage(0)">First page</a>
      <%= thepage == 0 ? "" : "<a href=\"javascript:toPage(" + (thepage - 1) + ")\">" %>Previous page<%= thepage == 0 ? "" : "</a>" %>
      <%= thepage * 20 + 20 >= list.size() ? "" : "<a href=\"javascript:toPage(" + (thepage + 1) + ")\">" %>Next page<%= thepage * 20 + 20 >= list.size() ? "" : "</a>" %>
      <a href="javascript:toPage(<%= (list.size() - 1) / 20 %>)">Last page</a>
    </td>
  </tr>
<%
            }
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    parent.document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry, you are not allowed to perform this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
%>
<table border="1" width="100%"  height="500" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style1">
  <tr>
    <td>Error:<%= e.toString() %></td>
  </tr>
</table>
<%
    }
%>
</body>
<html>

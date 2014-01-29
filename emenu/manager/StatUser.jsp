<%@ page import="java.util.List"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="zxyw50.manStatUser"%>
<%@ page import="zxyw50.manSysPara"%>
<%@ page import="jxl.*"%>
<%@ page import="jxl.write.*"%>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%
	response.addHeader("Cache-Control", "no-cache");
	response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

	String sysTime = "";
	Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
	String operID = (String)session.getAttribute("OPERID");
	String operName = (String)session.getAttribute("OPERNAME");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	try
	{
		String errmsg = "";
		boolean flag = false;
		zxyw50.Purview purview = new zxyw50.Purview();
		if (purviewList.get("4-39") == null ) {
			errmsg = "You have no access to this function!";//You have no access to this function
			flag = true;
		}
		if (operID  == null){
			errmsg = "Please log in first!";//Please log in to the system
			flag = true;
		}
		if(flag){
%>
		<script language="javascript">
			alert("<%=  errmsg  %>");
			document.URL = 'enter.jsp';
		</script>
<%
		}
		String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
		String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
		String startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
		String endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
		boolean checkflag = request.getParameter("checkTime") != null ? true : false;
		List datelist = null;


		if(op.equals("search") || op.equals("bakdata"))
		{

			HashMap  map  = new HashMap();
			map.put("scp",scp);
			map.put("startday",startday);
			map.put("endday",endday);
			map.put("serareano","0");
			manStatUser statuser = new manStatUser();
			datelist = statuser.statUser(map);
		}
        if(op.equals("bakdata")){
			response.setContentType("application/msexcel");
			String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "userStat", XlsNameGenerate.STATISTIC_DAY);
            response.setHeader("Content-disposition","inline; filename=" + file_name);
			out.clear();
			out.println("<table border='1'>");
			out.println("<tr>");
			out.println("<td>stat date</td>");
			out.println("<td>Averagedur</td>");
			out.println("<td>nonbuyuser</td>");
			out.println("</tr>");
			int totalBuytime=0;
			for (int i = 0; i <datelist.size(); i++) {
				HashMap map = (HashMap)datelist.get(i);
				out.println("<tr>");
				out.println("<td>&nbsp;"+(String)map.get("statdate")+"</td>");
				out.println("<td>"+(String)map.get("Averagedur")+"</td>");
				out.println("<td>"+(String)map.get("nonbuyuser")+"</td>");
				out.println("</tr>");
			}
			out.println("</table>");
			return;
		}
		/*  test
		for(int i=0;i<20;i++)
		{
			HashMap map= new HashMap();
			map.put("statdate", i+1+"");
			map.put("Averagedur", i*i+"");
			map.put("nonbuyuser", i*(i+1)+"");
			datelist.add(map);
		}
		session.setAttribute("ResultSession",datelist);
		*/

		int thepage = 0 ;
		int pagecount = 0;
		int size=0;
		int record = 0;
		if(datelist==null)
			size =-1;
		else
			size = datelist.size();
		pagecount = size/15;
		if(size%15>0){
			pagecount = pagecount + 1;
		}
		if(pagecount==0){
			pagecount = 1;
		}
		if(size == 0)
		{
			pagecount = 0;
		}
		String optSCP = "";
		manSysPara syspara = new manSysPara();
		ArrayList scplist = syspara.getScpList();
		for (int i = 0; i < scplist.size(); i++)
		{
			optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
		}
%>
<html>
	<head>
		<title>Orders Statistic by Artist</title>
		<link rel="stylesheet" type="text/css" href="style.css">
	</head>
	<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
	<body background="background.gif" class="body-style1" onload="loadpage(document.forms[0])" >
		<script language="javascript">
			function loadpage(pform){
				if(<%= size %> >0)
				{
					firstPage();
				}
				var temp = "<%= scp %>";
				for(var i=0; i<pform.scplist.length; i++){
					if(pform.scplist.options[i].value == temp){
						pform.scplist.selectedIndex = i;
						break;
					}
				}
			}
			function onCheckTime(){
				var fm = document.inputForm;
				if (fm.checkTime.checked) {
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
					fm.startday.value = "";
					fm.endday.value = "";
				}
				return;
			}
			function checkInfo () {
				var fm = document.inputForm;
				var tmp = '';
				if (trim(fm.startday.value) == '') {
					alert('Please enter the start query time!');//请输入起始时间
					fm.startday.focus();
					return false;
				}
				if (trim(fm.endday.value) == '') {
					alert('Please enter the end query time!');//请输入结束时间
					fm.endday.focus();
					return false;
				}
				if (! checkDate2(fm.startday.value)) {
					alert('Invalid start query time entered. \r\n Please enter the start query time in the YYYY.MM.DD format');//起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!
					fm.startday.focus();
					return false;
				}
				if (! checkDate2(fm.endday.value)) {
					alert('Invalid end query time entered. \r\n Please enter the end query time in the YYYY.MM.DD format');//结束时间输入错误,\r\n请按YYYY.MM.DD输入结束时间!
					fm.endday.focus();
					return false;
				}
				if (! checktrue2(fm.startday.value)) {
					alert('Start time cannot be later than the current time!');//起始时间不能大于当前时间
					fm.startday.focus();
					return false;
				}
				if (! checktrue2(fm.endday.value)) {
					alert('End time cannot be later than the current time!');//结束时间不能大于当前时间
					fm.endday.focus();
					return false;
				}
				if (! compareDate2(fm.startday.value,fm.endday.value)) {
					alert('Start time should be prior to the end time!');//起始时间不能大于结束时间
					fm.startday.focus();
					return false;
				}
				return true;
			}
			function searchInfo () {
				var fm = document.inputForm;
				if (! checkInfo())
					return;
				fm.op.value='search';
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
			<form name="inputForm" method="post" action="StatUser.jsp">
				<input type="hidden" name="pagecount" value="<%= pagecount %>" />
				<input type="hidden" name="thepage" value="<%= thepage+1 %>" />
				<input type="hidden" name="op" value="" />
				<script language="JavaScript">
					if(parent.frames.length>0)
						parent.document.all.main.style.height="900";
				</script>
				<table border="0" width="98%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
					<tr >
						<td height="26"  align="center" class="text-title" background="image/n-9.gif">User Statistic</td>
					</tr>
					<tr>
						<td align="center">
							<table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="100%"  align="center">
								<tr height=35 align="center">
									<td width="30%" align="left">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SCP List&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<select name="scplist" size="1" class="input-style2">
											<% out.print(optSCP); %>
										</select>
									</td>
									<td width="30%" align="center">
										<input type="checkbox" name="checkTime" value="on"<%= checkflag ? " checked" : "" %>  onclick="onCheckTime()" >Start and end date(YYYY.MM.DD)
									</td>
									<td width="30%" align="center">
										<img border="0" src="button/search.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:searchInfo()">&nbsp;
									</td>
								</tr>
								<tr>
									<td width="30%" align="left">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Start Date
										<input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">&nbsp;
									</td>
									<td width="30%" align="center">
										End  Date
										<input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:100px">&nbsp;
									</td>
									<td width="30%" align="center">
										<img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<%
							if(datelist == null || datelist.size()<1)
							{
							%>
							<table width="95%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2">
								<tr class="table-title1" align="center">
									<td height="30" width="30%" align="center">
										Stat date
									</td>
									<td height="30" width="30%" align="center" >
										Averagedur
									</td>
									<td height="30" width="30%" align="center">
										nonbuyuser
									</td>
								</tr>
								<tr align="center">
									<td align="center" colspan="3">
										No record matched the criteria
									</td>
								</tr>
							<%
							}
							else
							{
								int maxbuytimes = 0;
								for (int i = 0; i < pagecount; i++)
								{
									int form = (i*15)+1;
									int thispage = i+1;
									int to = thispage*15;
									if(to>size)
									{
										to = size;
									}
									String pageid = "page_"+thispage+"";
								%>
									<table width="95%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
										<tr class="table-title1"  align="center">
											<td height="30" width="30%" align="center">
												Stat date
											</td>
											<td height="30" width="30%" align="center" >
												Averagedur
											</td>
											<td height="30" width="30%" align="center">
												nonbuyuser
											</td>
										</tr>
								<%
									for(int j=form;j<=to;j++){
										String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
										HashMap map = (HashMap)datelist.get(j-1);
										out.print("<tr bgcolor=" +strcolor + " >");
										out.println("<td  align=\"center\">"+(String)map.get("statdate")+"</td>");
										out.println("<td  align=\"center\">"+(String)map.get("Averagedur")+"</td>");
										out.println("<td  align=\"center\">"+(String)map.get("nonbuyuser")+"</td>");
										out.println("</tr>");
									}
									if(size>15){
										%>
										<tr>
											<td width="100%" colspan="4">
												<table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
													<tr>
														<td>&nbsp;Total:<%= datelist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;Now on Page &nbsp;<%= thispage+"" %>&nbsp;</td>
														<td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
														<td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
														<td><img src="button/nextpage.gif" <%= i * 15 + 15 >= size ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
														<td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()"></td>
													</tr>
												</table>
											</td>
										</tr>
										<%
									}
									%></table><%
								}
							}
%>
							</table>
						</td>
					</tr>
				</table>
			</form>
<%
	}
	catch(Exception e) {
		Vector vet = new Vector();
		sysInfo.add(sysTime + operName + " Exception occurred in User Statistic");
		sysInfo.add(sysTime + operName + e.toString());
		vet.add("Error occurred in User Statistic");
		vet.add(e.getMessage());
		session.setAttribute("ERRORMESSAGE",vet);
%>
	<form name="errorForm" method="post" action="error.jsp">
		<input type="hidden" name="historyURL" value="StatUser.jsp"/>
	</form>
	<script language="javascript">
		document.errorForm.submit();
	</script>
	<%
	}
	%>
	</body>
</html>

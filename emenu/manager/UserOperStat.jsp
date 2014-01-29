<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.manStat" %>
<%@ page import="zxyw50.manStatUser"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.XlsNameGenerate"%>
<%@ page import="zxyw50.manSysPara" %>
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

        ArrayList opermodelist = null;
        HashMap   map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        Calendar showdate = Calendar.getInstance();
        showdate.add(Calendar.MONTH ,-1);
        SimpleDateFormat formate = new SimpleDateFormat("yyyy.MM.DD");
        String qrydate = formate.format(showdate.getTime());

        zxyw50.Purview purview = new zxyw50.Purview();
        if (purviewList.get("4-40") == null) {
            errmsg = "You have no access to this function!";//You have no access to this function
            flag = false;
        }
        if (operID  == null){
            errmsg = "Please log in first!";//Please log in to the system
            flag = false;
        }
        if(flag)
        {
            SortedMap out_map = null;
            String startday ="";
            String endday ="";
            Hashtable hash = null;
            String  optSCP = "";
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
            startday = request.getParameter("startday") == null ? "" : ((String)request.getParameter("startday")).trim();
            endday = request.getParameter("endday") == null ? "" : ((String)request.getParameter("endday")).trim();
            manStatUser statuser = new manStatUser();
            String  total ="";
            if(op.equals("search") || op.equals("bakdata"))
            {
                map.put("scp",scp);
                map.put("startday",startday);
                map.put("endday",endday);
                out_map = statuser.userOpenCancelStat(map);
                if(out_map == null) {
                	out_map = new TreeMap();
                }
            }
            if(op.equals("bakdata"))
            {
               // ArrayList al = (ArrayList)session.getAttribute("ResultSession");

                response.setContentType("application/msexcel");
                String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "userOper", XlsNameGenerate.STATISTIC_DAY);
                response.setHeader("Content-disposition","inline; filename=" + file_name);
                out.clear();
                out.println("<table border='1'>");
                out.println("<tr>");
                out.println("<td rowspan=\"2\"  align=center>Date</td>");
                out.println("<td align=center>Total</td>");
                out.println("<td colspan=\"2\" align=center>Mobile registration</td>");
                out.println("<td align=center>Fixed</td>");
                out.println("<td align=center>Total</td>");
                out.println("<td colspan=\"2\" align=center>Mobile Terminations</td>");
                out.println("<td align=\"center\">Total</td>");
                out.println("<td colspan=\"2\" align=\"center\">Mobile Subscriber</td>");
                out.println("<td align=\"center\">Fixed Subscriber</td>");
                out.println("<td colspan=\"3\" align=\"center\">Total chargeable subscribers</td>");
                out.println("<td colspan=\"3\" align=\"center\">Total trial subscribers</td>");
                out.println("<td colspan=\"3\" align=\"center\">SMS Opt Out</td>");
                out.println("</tr>");
                out.println("<tr>");
                out.println("<td align=center>Registration</td>");
                out.println("<td align=center>prepaid</td>");
                out.println("<td align=center>postpaid</td>");
                out.println("<td align=center>Registration</td>");
                out.println("<td align=center>Terminations</td>");
                out.println("<td align=center>prepaid</td>");
                out.println("<td align=center>postpaid</td>");
                out.println("<td align=center>Subscriber</td>");
                out.println("<td align=center>prepaid</td>");
                out.println("<td align=center>postpaid</td>");
                out.println("<td align=center>fixed/mioVoice</td>");
                out.println("<td align=center>mobile prepaid</td>");
                out.println("<td align=center>mobile postpaid</td>");
                out.println("<td align=center>fixed/mioVoice</td>");
                out.println("<td align=center>mobile prepaid</td>");
                out.println("<td align=center>mobile postpaid</td>");
                out.println("<td align=center>fixed/mioVoice</td>");
                out.println("<td align=center>Total</td>");
                out.println("<td align=center>prepaid</td>");
                out.println("<td align=center>postpaid</td>");
                out.println("</tr>");

                Iterator iter = out_map.entrySet().iterator();
                while(iter.hasNext()) {
                	Map.Entry entry = (Map.Entry)iter.next();
                	String date = (String)entry.getKey();
                	HashMap data_map = (HashMap)entry.getValue();
                	String[] keys = new String[]{"20", "20-1", "20-2", "20-3", "21", "21-1", "21-2",
            			 "25", "25-2", "25-1", "25-0", "25-2-1", "25-1-1",  "25-0-1",  "25-2-0", "25-1-0", "25-0-0",
            			 "26", "26-2", "26-1"};
                	out.print("<tr>");
                	out.print("<td align=center>" + date + "</td>");
                	for(int i = 0; i < keys.length; i ++) {
                		int val = statuser.getMapValue(data_map, keys[i]);
                		out.print("<td align=center>" + val + "</td>");
                	}
                	out.print("</tr>");
                }
                out.println("</table>");
                return;
            }
            int thepage = 0 ;
            int pagecount = 0;
            int size=0;
            if(out_map == null || out_map.entrySet().size() < 1) {
            	size =-1;
            }
            else {
                size = out_map.entrySet().size();
            }
            int num = 15;
            pagecount = size/num;
            if(size%num>0)
            pagecount = pagecount + 1;
            if(pagecount==0)
            pagecount = 1;
            ArrayList scplist = statuser.getScpList();
            for (int i = 0; i < scplist.size(); i++)
            optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
            %>

<html>
    <head>
        <title>Tendency Statistic</title>
        <link rel="stylesheet" type="text/css" href="style.css">
    </head>
    <SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
    <body background="background.gif" class="body-style1" onload="loadpage(document.forms[0])" >

        <script language="javascript">

        function loadpage(pform){
            firstPage();
            var temp = "<%= scp %>";
            for(var i=0; i<pform.scplist.length; i++){
                if(pform.scplist.options[i].value == temp){
                    pform.scplist.selectedIndex = i;
                    break;
                }
            }
            var sTime = "<%=startday %>";
            if(sTime=='')
            {
                inputTime();
            }
        }
        function inputTime(){
            var fm = document.inputForm;
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
        function checkInfo ()
        {
            var fm = document.inputForm;
            var tmp = '';
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
                alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM.DD format');//结束时间输入错误,\r\n请按YYYY.MM.DD输入结束时间!
                fm.endday.focus();
                return false;
            }
            if (! checktrue2(fm.endday.value)) {
                alert('end time cannot be later than the current time!');//结束时间不能大于当前时间
                fm.startday.focus();
                return false;
            }
            if (! compareDate2(fm.startday.value,fm.endday.value)) {
                alert('Start time should be prior to the end time!');//起始时间不能大于结束时间
                fm.startday.focus();
                return false;
            }
            fm.start.value = tmp = trim(fm.startday.value);
            fm.end.value = tmp = trim(fm.endday.value);
            return true;
        }

        function searchInfo ()
        {
            var fm = document.inputForm;
            if (! checkInfo())
            return;
            fm.op.value = 'search';
            fm.target="_self";
            fm.submit();
        }

        function WriteDataInExcel()
        {
            if (! checkInfo())
            return;
            var fm = document.inputForm;
            fm.op.value = 'bakdata';
            fm.target="top";
            fm.submit();
        }

        function onpage(num)
        {
            var obj  = eval("page_" + num);
            obj.style.display="block";
            document.forms[0].thepage.value = num;
        }

        function offpage(num)
        {
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

        function toPage(value)
        {
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

        function endPage()
        {
            var thePage = document.forms[0].thepage.value;
            var pageCount = parseInt(document.forms[0].pagecount.value);
            offpage(thePage);
            onpage(pageCount)
            return true;
        }
        </script>
        <form name="inputForm" method="post" action="UserOperStat.jsp">
            <input type="hidden" name="pagecount" value="<%= pagecount %>" />
            <input type="hidden" name="thepage" value="<%= thepage+1 %>" />
            <input type="hidden" name="start" value="<%= startday + "" %>" />
            <input type="hidden" name="end" value="<%= endday + "" %>"/>
            <input type="hidden" name="op" value="">
            <script language="JavaScript">
                if(parent.frames.length>0)
                parent.document.all.main.style.height="900";
            </script>
            <table border="0" width="98%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
                <tr >
                    <td width=500 height="26"  align="center" class="text-title" background="image/n-9.gif">User Oper Stat</td>
                </tr>

                <!-- 查询体 -->
                <tr>
                    <td align="center">
                        <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="500"  align="left">
                            <tr height=35>
                                <td>
                                    &nbsp;&nbsp;SCP List&nbsp;
                                    <select name="scplist" size="1" class="input-style2">
                                        <% out.print(optSCP); %>
                                    </select>&nbsp;&nbsp;&nbsp;
                                </td>
                                <td>
                                    &nbsp;&nbsp;<img border="0" src="button/search.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:searchInfo()">
                                        &nbsp;&nbsp;<img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()">
                                </td>
                            </tr>
                            <tr height=35>
                                <td>
                                    &nbsp;&nbsp;Start Date
                                    <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">YYYY.MM.DD&nbsp;
                                </td>
                                <td> &nbsp;&nbsp;End Date
                                    <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:100px">YYYY.MM.DD&nbsp;
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                    <%
                        int  record = 0;
                        for (int i = 0; i < pagecount; i++)
                        {
                            String pageid = "page_"+Integer.toString(i+1);
                    %>

                        <table width="95%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
                            <tr class="table-title1" align="center">
                                <td height="30" rowspan="2" align="center">
                                    Date
                                </td>
                                <td align=center>Total</td>
                				<td colspan=2 align=center>Mobile registration</td>
                				<td align=center>Fixed</td>
                				<td align=center>Total</td>
                				<td colspan=2 align=center>Mobile Terminations</td>
                				<td align=center>Total</td>
                				<td colspan=2 align=center>Mobile Subscriber</td>
                				<td align=center>Fixed Subscriber</td>
                				<td colspan=3 align=center>Total chargeable subscribers</td>
                				<td colspan=3 align=center>Total trial subscribers</td>
                				<td colspan=3 align=center>SMS Opt Out</td>
                            </tr>
                            <tr class="table-title1" align="center">
                                <td align=center height=30>Registration</td>
                				<td align=center>prepaid</td>
                				<td align=center>postpaid</td>
                				<td align=center>Registration</td>
                				<td align=center>Terminations</td>
                				<td align=center>prepaid</td>
                				<td align=center>postpaid</td>
                				<td align=center>Subscriber</td>
                				<td align=center>prepaid</td>
                				<td align=center>postpaid</td>
                				<td align=center>fixed/mioVoice</td>
                				<td align=center>mobile prepaid</td>
				                <td align=center>mobile postpaid</td>
                				<td align=center>fixed/mioVoice</td>
				                <td align=center>mobile prepaid</td>
                				<td align=center>mobile postpaid</td>
				                <td align=center>fixed/mioVoice</td>
                				<td align=center>Total</td>
				                <td align=center>prepaid</td>
                				<td align=center>postpaid</td>
                            </tr>
                            <%
                            if(size==0)
                            {
                            %>
                            <tr>
                                <td align="center" colspan="11">No record matched the criteria</td>
                            </tr>
                            <%
                            }
                            else if(size>0)
                            {
                                if(i==(pagecount-1))
                                record = size ;
                                else
                                record = (i+1)*num;;
                                Object[] array = out_map.values().toArray();
                                for(int j=i*num;j<record;j++)
                                {
                                    String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;

                                    map = (HashMap)array[j];

                                    String[] keys = new String[]{"20", "20-1", "20-2", "20-3", "21", "21-1", "21-2",
            			 "25", "25-2", "25-1", "25-0", "25-2-1", "25-1-1",  "25-0-1",  "25-2-0", "25-1-0", "25-0-0",
            			 "26", "26-2", "26-1"};
                                   	out.print("<tr bgcolor=" +strcolor + ">");
                                   	out.print("<td align=center>" + map.get("date") + "</td>");
                                   	for(int m = 0; m < keys.length; m ++) {
                                   		int val = statuser.getMapValue(map, keys[m]);
                                   		out.print("<td align=center>" + val + "</td>");
                                   	}
                                   	out.print("</tr>");
                                }
                                //session.setAttribute("ResultSession",arraylist);
                            %>
                            <%
                            if (size > num)
                            {
                            %>
                            <tr>
                                <td width="100%" colspan="11">
                                    <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
                                        <tr>
                                            <td>&nbsp;Total:<%= size %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
                                            <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
                                            <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
                                            <td><img src="button/nextpage.gif" <%= i * num + num >= size ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
                                            <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <%}
                            }%>
                        </table>
                    <%
                    }
                    %>
                    </td>
                </tr>
            </table>
        </form>
        <%
        }
        else
        {
        %>
        <script language="javascript">
            alert("<%=  errmsg  %>");
            document.URL = 'enter.jsp';
        </script>
        <%
        }
    }
    catch(Exception e)
    {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in User Oper Stat");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in User Oper Stat");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
    %>
    <form name="errorForm" method="post" action="error.jsp">
        <input type="hidden" name="historyURL" value="UserOperStat.jsp">
    </form>
    <script language="javascript">
        document.errorForm.submit();
    </script>
    <%
    }
    %>
    </body>
</html>

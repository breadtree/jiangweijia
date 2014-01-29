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
        if (purviewList.get("4-42") == null) {
            errmsg = "You have no access to this function!";//You have no access to this function
            flag = false;
        }
        if (operID  == null){
            errmsg = "Please log in first!";//Please log in to the system
            flag = false;
        }
        if(flag)
        {
            ArrayList data_list = null;
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
                data_list = statuser.grpUserStat(map);
                if(data_list == null) {
                	data_list = new ArrayList();
                }
            }
            if(op.equals("bakdata"))
            {
               // ArrayList al = (ArrayList)session.getAttribute("ResultSession");

                response.setContentType("application/msexcel");
                String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "grpUserChangeStat", XlsNameGenerate.STATISTIC_MONTH);
                response.setHeader("Content-disposition","inline; filename=" + file_name);
                out.clear();
                out.println("<table border='1'>");
                out.println("<tr>");
                out.println("<td align=middle height=30>Date to</td>");
                out.println("<td align=middle>Total New Add</td>");
                out.println("<td align=middle>Total Termination</td>");
                out.println("<td align=middle>Total nett add</td>");
                out.println("<td align=middle>Total Subscribers</td>");
                
                out.println("</tr>");
                				
                Iterator iter = data_list.iterator ();
                while(iter.hasNext()) {
                    String[] data = (String[])iter.next();
                    out.print("<tr>");                	
                    for(int i = 0; i < data.length; i ++) {                            
                        out.print("<td align=center>" + data[i] + "</td>");
                    }
                    out.print("</tr>");
                }                
                out.println("</table>");
                return;
            }
            int thepage = 0 ;
            int pagecount = 0;
            int size=0;
            if(data_list == null || data_list.size() < 1) {
            	size =-1;
            }
            else {
                size = data_list.size();
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
           fm.endday.disabled = false;
           fm.startday.disabled = false;
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
        function checkInfo ()
        {
            var fm = document.inputForm;
            var tmp = '';
            if (trim(fm.startday.value) == '') {
                alert('Please enter the start time!');//请输入起始时间
                fm.startday.focus();
                return false;
            }
            if (! checkDate1(fm.startday.value)) {
                alert('Invalid start time entered. \r\n Please enter the start time in the YYYY.MM.DD format');//起始时间输入错误,\r\n请按YYYY.MM.DD输入起始时间!
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
                alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM.DD format');//结束时间输入错误,\r\n请按YYYY.MM.DD输入结束时间!
                fm.endday.focus();
                return false;
            }
            if (! checktrue1(fm.endday.value)) {
                alert('end time cannot be later than the current time!');//结束时间不能大于当前时间
                fm.startday.focus();
                return false;
            }
            if (! compareDate1(fm.startday.value,fm.endday.value)) {
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
        <form name="inputForm" method="post" action="grpUserChangeStat.jsp">
            <input type="hidden" name="pagecount" value="<%= pagecount %>" />
            <input type="hidden" name="thepage" value="<%= thepage+1 %>" />
            <input type="hidden" name="start" value="<%= startday + "" %>" />
            <input type="hidden" name="end" value="<%= endday + "" %>"/>
            <input type="hidden" name="op" value="">
            <script language="JavaScript">
                if(parent.frames.length>0)
                parent.document.all.main.style.height="900";
            </script>
            <table border="0" width="60%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
                <tr >
                    <td width=500 height="26"  align="center" class="text-title" background="image/n-9.gif">
					Group User Stat</td>
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
                                    <input type="text" name="startday" value="<%= startday %>" maxlength="10" class="input-style0" style="width:100px">YYYY.MM&nbsp;
                                </td>
                                <td> &nbsp;&nbsp;End Date
                                    <input type="text" name="endday" value="<%= endday %>" maxlength="10" class="input-style0" style="width:100px">YYYY.MM&nbsp;
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
                            <tr class=table-title1 align=middle>
                                        <td align=middle height=30>Date to</td>
                                        <td align=middle>Total New Add</td>
                                        <td align=middle>Total Termination</td>
                                        <td align=middle>Total nett add</td>
                                        <td align=middle>Total Subscribers</td>
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
                                for(int j=i*num;j<record;j++)
                                {
                                    String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                                    
                                    String[] data = (String[])data_list.get(j);

                                   
                                   	out.print("<tr bgcolor=" +strcolor + ">");
                                   	
                                   	for(int m = 0; m < data.length; m ++) {                                   		
                                   		out.print("<td align=center>" + data[m] + "</td>");
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
        sysInfo.add(sysTime + operName + " Exception occurred in Group User change Stat");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in Group User change Stat");
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

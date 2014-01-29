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
        ArrayList[] arraylist_all = null;
        ArrayList arraylist_prepaid = null;  //移动预付费用户数据
        ArrayList arraylist_postpaid = null;  //移动后付费用户数据
        ArrayList arraylist_fixed = null;  //固定用户数据
        ArrayList opermodelist = null;
        String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");  //音乐盒
        String giftbag   = CrbtUtil.getConfig("giftname","giftbag");   //大礼包
        String ringdisplay = CrbtUtil.getConfig("ringdisplay","ringtone"); //铃音名称
        HashMap   map  = new HashMap();
        String    errmsg = "";
        String    queryType = "";
        int       queryMode = 0;
        boolean   flag =true;
        Calendar showdate = Calendar.getInstance();
        showdate.add(Calendar.MONTH ,-1);
        SimpleDateFormat formate = new SimpleDateFormat("yyyy.MM");
        String qrydate = formate.format(showdate.getTime());
        String[] desc=
        {
            "Mobile prepaid subscribers with:",
            "Mobile PostPaid subscribers with:",
            "Mobile fixed subscribers with:"
        };
        zxyw50.Purview purview = new zxyw50.Purview();
        if (purviewList.get("4-35") == null)
        {
            errmsg = "You have no access to this function!";//You have no access to this function
            flag = false;
        }
        if (operID  == null)
        {
            errmsg = "Please log in first!";//Please log in to the system
            flag = false;
        }
        if(flag)
        {
            String startday = qrydate;
            String endday = qrydate;
            Hashtable hash = null;
            String  optSCP = "";
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
            manStatUser statuser = new manStatUser();
            String  total ="";
            if(op.equals("search") || op.equals("bakdata"))
            {
                startday = request.getParameter("start") == null ? qrydate : ((String)request.getParameter("start")).trim();
                endday= request.getParameter("end") == null ? qrydate : ((String)request.getParameter("end")).trim();
                map.put("scp",scp);
                map.put("startday",startday);
                map.put("endday",endday);
                map.put("beginIndex","16");
                map.put("endIndex","23");
                arraylist_all = statuser.tendencyStat(map);
                arraylist_prepaid = arraylist_all[0];  //移动预付费用户数据
                arraylist_postpaid = arraylist_all[1];//移动后付费用户数据
                arraylist_fixed = arraylist_all[2]; //固定用户数据
            }
            if(op.equals("bakdata"))
            {
                ArrayList[] listbak = new ArrayList[3];
                /*listbak[0] = (ArrayList) session.getAttribute("date_prepaid");
                listbak[1] = (ArrayList) session.getAttribute("date_postpaid");
                listbak[2] = (ArrayList) session.getAttribute("date_fixed");*/
                listbak[0] = arraylist_prepaid;
                listbak[1] = arraylist_postpaid;
                listbak[2] = arraylist_fixed;

                response.setContentType("application/msexcel");
                String file_name = XlsNameGenerate.get_xls_filename(startday, endday, "tendency", XlsNameGenerate.STATISTIC_MONTH);
                response.setHeader("Content-disposition","inline; filename=" + file_name);
                out.clear();
                out.println("<table border='1'>");
                String tdInformat = "<td align='center' style='mso-number-format:\"\\@\"'>";
                for(int i=0;i<3;i++)
                {
                    out.println("<tr><td colspan=\"6\"></td></tr>");
                    out.println("<tr><td colspan=\"6\">"+desc[i]+"</td></tr>");
                    out.println("<tr>");
                    out.println("<td>Month</td>");
                    out.println("<td>1 tone purchase</td>");
                    out.println("<td>2 tones purchase</td>");
                    out.println("<td>Gift Ringtone</td>");
                    out.println("<td>Fast Tracks</td>");
                    out.println("<td>Magnifique</td>");
                    out.println("</tr>");
                    ArrayList li = listbak[i];
                    for (int j = 0; li!=null && j <listbak[i].size(); j++)
                    {
                        HashMap mapdetail = (HashMap)li.get(j);
                        out.print(tdInformat+(String)mapdetail.get("statdate")+"</td>");
                        out.print("<td align=center>"+(String)mapdetail.get("16")+"</td>");
                        out.print("<td align=center>"+(String)mapdetail.get("17")+"</td>");
                        out.print("<td align=center>"+(String)mapdetail.get("22")+"</td>");
                        String stat18=mapdetail.get("18")==null?"0":(String)mapdetail.get("18");
                        String stat19=mapdetail.get("19")==null?"0":(String)mapdetail.get("19");
                        int stattotal = Integer.parseInt(stat18)+Integer.parseInt(stat19);
                        out.print("<td align=center>"+stattotal+"</td>");
                        out.print("<td align=center>"+(String)mapdetail.get("23")+"</td>");
                        out.print("</tr>");
                    }
                }
                out.println("</table>");
                return;
            }
            // 固定用户数据
            int thepage_fixed = 0 ;
            int pagecount_fixed = 0;
            int size_fixed=0;
            if(arraylist_fixed==null)
            size_fixed =-1;
            else
            size_fixed = arraylist_fixed.size();
            pagecount_fixed = size_fixed/10;
            if(size_fixed%10>0)
            pagecount_fixed = pagecount_fixed + 1;
            if(pagecount_fixed==0)
            pagecount_fixed = 1;

            // 移动后付费用户数据
            int thepage_postpaid = 0 ;
            int pagecount_postpaid = 0;
            int size_postpaid=0;
            if(arraylist_postpaid==null)
            size_postpaid =-1;
            else
            size_postpaid = arraylist_postpaid.size();
            pagecount_postpaid = size_postpaid/10;
            if(size_postpaid%10>0)
            pagecount_postpaid = pagecount_postpaid + 1;
            if(pagecount_postpaid==0)
            pagecount_postpaid = 1;

            // 移动预付费用户数据
            int thepage_prepaid = 0 ;
            int pagecount_prepaid = 0;
            int size_prepaid=0;
            if(arraylist_prepaid==null)
            size_prepaid =-1;
            else
            size_prepaid = arraylist_prepaid.size();
            pagecount_prepaid = size_prepaid/10;
            if(size_prepaid%10>0)
            pagecount_prepaid = pagecount_prepaid + 1;
            if(pagecount_prepaid==0)
            pagecount_prepaid = 1;

            ArrayList scplist = statuser.getScpList();
            for (int i = 0; i < scplist.size(); i++)
            {
                optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
            }
%>

<html>
    <head>
        <title>Tendency Statistic</title>
        <link rel="stylesheet" type="text/css" href="style.css">
    </head>
    <SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
    <body background="background.gif" class="body-style1" onload="loadpage(document.forms[0])" >

        <script language="javascript">
        function loadpage(pform)
        {
            firstPage('prepaid');
            firstPage('postpaid');
            firstPage('fixed');
            var temp = "<%= scp %>";
            for(var i=0; i<pform.scplist.length; i++)
            {
                if(pform.scplist.options[i].value == temp)
                {
                    pform.scplist.selectedIndex = i;
                    break;
                }
            }
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
                alert('Invalid end time entered. \r\n Please enter the end time in the YYYY.MM format');//结束时间输入错误,\r\n请按YYYY.MM输入结束时间!
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
        function onpage(usertype,num)
        {
            if(usertype=='prepaid')
            {
                var obj_prepaid  = eval("page_prepaid_" + num);
                obj_prepaid.style.display="block";
                document.forms[0].thepage_prepaid.value = num;
            }
            if(usertype=='postpaid')
            {
                var obj_postpaid  = eval("page_postpaid_" + num);
                obj_postpaid.style.display="block";
                document.forms[0].thepage_postpaid.value = num;
            }
            if(usertype=='fixed')
            {
                var obj_fixed  = eval("page_fixed_" + num);
                obj_fixed.style.display="block";
                document.forms[0].thepage_fixed.value = num;
            }
        }

        function offpage(usertype,num)
        {
            if(usertype=='prepaid')
            {
                var obj  = eval("page_prepaid_" + num);
                obj.style.display="none";
            }
            if(usertype=='postpaid')
            {
                var obj  = eval("page_postpaid_" + num);
                obj.style.display="none";
            }
            if(usertype=='fixed')
            {
                var obj  = eval("page_fixed_" + num);
                obj.style.display="none";
            }
        }
        function firstPage(usertype)
        {
            if(usertype=='prepaid')
            {
                if(parseInt(document.forms[0].pagecount_prepaid.value)==0)
                return;
                var thePage_prepaid = document.forms[0].thepage_prepaid.value;
                offpage('prepaid',thePage_prepaid);
                onpage('prepaid',1);
                return true;
            }
            if(usertype=='postpaid')
            {
                if(parseInt(document.forms[0].pagecount_postpaid.value)==0)
                return;
                var thePage_postpaid = document.forms[0].thepage_postpaid.value;
                offpage('postpaid',thePage_postpaid);
                onpage('postpaid',1);
                return true;
            }
            if(usertype=='fixed')
            {
                if(parseInt(document.forms[0].pagecount_fixed.value)==0)
                return;
                var thePage_fixed = document.forms[0].thepage_fixed.value;
                offpage('fixed',thePage_fixed);
                onpage('fixed',1);
                return true;
            }
        }

        function toPage(usertype,value)
        {
            if(usertype=='prepaid')
            {
                var thePage = parseInt(document.forms[0].thepage_prepaid.value);
                var pageCount = parseInt(document.forms[0].pagecount_prepaid.value);
                var index = thePage+value;
                if(index > pageCount || index<0)
                return;
                if(index!=thePage){
                    offpage('prepaid',thePage);
                    onpage('prepaid',index);
                }
                return true;
            }
            if(usertype=='postpaid')
            {
                var thePage = parseInt(document.forms[0].thepage_postpaid.value);
                var pageCount = parseInt(document.forms[0].pagecount_postpaid.value);
                var index = thePage+value;
                if(index > pageCount || index<0)
                return;
                if(index!=thePage){
                    offpage('postpaid',thePage);
                    onpage('postpaid',index);
                }
                return true;
            }
            if(usertype=='fixed')
            {
                var thePage = parseInt(document.forms[0].thepage_fixed.value);
                var pageCount = parseInt(document.forms[0].pagecount_fixed.value);
                var index = thePage+value;
                if(index > pageCount || index<0)
                return;
                if(index!=thePage){
                    offpage('fixed',thePage);
                    onpage('fixed',index);
                }
                return true;
            }
        }

        function endPage(usertype)
        {
            if(usertype=='prepaid')
            {
                var thePage = document.forms[0].thepage_prepaid.value;
                var pageCount = parseInt(document.forms[0].pagecount_prepaid.value);
                offpage('prepaid',thePage);
                onpage('prepaid',pageCount)
                return true;
            }
            if(usertype=='postpaid')
            {
                var thePage = document.forms[0].thepage_postpaid.value;
                var pageCount = parseInt(document.forms[0].pagecount_postpaid.value);
                offpage('postpaid',thePage);
                onpage('postpaid',pageCount)
                return true;
            }
            if(usertype=='fixed')
            {
                var thePage = document.forms[0].thepage_fixed.value;
                var pageCount = parseInt(document.forms[0].pagecount_fixed.value);
                offpage('fixed',thePage);
                onpage('fixed',pageCount)
                return true;
            }
        }
        </script>
        <form name="inputForm" method="post" action="tendencyStat.jsp">
            <input type="hidden" name="pagecount_prepaid" value="<%= pagecount_prepaid %>" />
            <input type="hidden" name="pagecount_postpaid" value="<%= pagecount_postpaid %>"/>
            <input type="hidden" name="pagecount_fixed" value="<%= pagecount_fixed %>"/>

            <input type="hidden" name="thepage_prepaid" value="<%= thepage_prepaid+1 %>"/>
            <input type="hidden" name="thepage_postpaid" value="<%= thepage_postpaid+1 %>"/>
            <input type="hidden" name="thepage_fixed" value="<%= thepage_fixed+1 %>"/>

            <input type="hidden" name="start" value="<%= startday + "" %>"/>
            <input type="hidden" name="end" value="<%= endday + "" %>"/>
            <input type="hidden" name="op" value=""/>
            <script language="JavaScript">
                if(parent.frames.length>0)
                    parent.document.all.main.style.height="900";
            </script>

            <table border="0" width="98%" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
                <tr >
                    <td height="26"  align="center" class="text-title">Tendency Statistic</td>
                </tr>
                <!-- 查询体 -->
                <tr>
                    <td align="center">
                        <table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="93%"  align="center">
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
                                    <input type="text" name="startday" value="<%= startday %>" maxlength="7" class="input-style0" style="width:100px">YYYY.MM&nbsp;
                                </td>
                                <td> &nbsp;&nbsp;End Date
                                    <input type="text" name="endday" value="<%= endday %>" maxlength="7" class="input-style0" style="width:100px">YYYY.MM&nbsp;
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <!-- 结果体 -->
                <tr>
                    <td>
                        Mobile prepaid subscribers with:<br />
                        <!-- 移动预付费用户数据 -->
                        <%
                        //session.setAttribute("date_prepaid",arraylist_prepaid);
                        int  record_prepaid = 0;
                        for (int i = 0; i < pagecount_prepaid; i++)
                        {
                            String pageid = "page_prepaid_"+Integer.toString(i+1);
                        %>
                        <table width="95%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
                            <tr class="table-title1" align="center">
                                <td height="30" width="20%" align="center">Month</td>
                                <td height="30" width="18%" align="center" >1 tone purchase</td>
                                <td height="30" width="18%" align="center" >2 tones purchase</td>
                                <td height="30" width="18%" align="center" >Gift <%=ringdisplay %></td>
                                <td height="30" width="18%" align="center" >Fast Tracks</td>
                                <td height="30" width="18%" align="center" >Magnifique</td>
                            </tr>
                            <%
                            if(size_prepaid==0)
                            {
                            %>
                            <tr>
                                <td align="center" colspan="6">No record matched the criteria</td>
                            </tr>
                            <%
                            }
                            else if(size_prepaid>0)
                            {
                                if(i==(pagecount_prepaid-1))
                                record_prepaid = size_prepaid ;
                                else
                                record_prepaid = (i+1)*10;
                                for(int j=i*10;j<record_prepaid;j++)
                                {
                                    String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                                    map = (HashMap)arraylist_prepaid.get(j);
                                    out.print("<tr bgcolor=" +strcolor + ">");
                                    out.print("<td align=left>"+(String)map.get("statdate")+"</td>");
                                    out.print("<td align=center>"+(String)map.get("16")+"</td>");
                                    out.print("<td align=center>"+(String)map.get("17")+"</td>");
                                    out.print("<td align=center>"+(String)map.get("22")+"</td>");
                                    String stat18=map.get("18")==null?"0":(String)map.get("18");
                                    String stat19=map.get("19")==null?"0":(String)map.get("19");
                                    int stattotal = Integer.parseInt(stat18)+Integer.parseInt(stat19);
                                    out.print("<td align=center>"+stattotal+"</td>");
                                    out.print("<td align=center>"+(String)map.get("23")+"</td>");
                                    out.print("</tr>");
                                }
                                if (arraylist_prepaid.size() > 10)
                                {
                                %>
                                <tr>
                                    <td width="100%" colspan="10">
                                        <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
                                            <tr>
                                                <td>&nbsp;Total:<%= arraylist_prepaid.size() %>,&nbsp;&nbsp;<%= pagecount_prepaid %>&nbsp;page(s),&nbsp;Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
                                                <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage('prepaid')" alt=""></td>
                                                <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage('prepaid',-1)\"" %> alt=""></td>
                                                <td><img src="button/nextpage.gif" <%= i * 10 + 10 >= arraylist_prepaid.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage('prepaid',1)\"" %> alt=""></td>
                                                <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage('prepaid')" alt=""></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            <%
                                }
                            }
                            %>
                        </table>
                        <%
                        }
                        %>
                        <!-- 移动后付费用户数据 -->
                        Mobile PostPaid subscribers with:<br />
                        <%
                       // session.setAttribute("date_postpaid",arraylist_postpaid);
                        int  record_postpaid = 0;
                        for (int i = 0; i < pagecount_postpaid; i++)
                        {
                            String pageid = "page_postpaid_"+Integer.toString(i+1);
                        %>
                        <table width="95%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
                            <tr class="table-title1" align="center">
                                <td height="30" width="20%" align="center">Month</td>
                                <td height="30" width="18%" align="center" >1 tone purchase</td>
                                <td height="30" width="18%" align="center" >2 tones purchase</td>
                                <td height="30" width="18%" align="center" >Gift <%=ringdisplay %></td>
                                <td height="30" width="18%" align="center" >Fast Tracks</td>
                                <td height="30" width="18%" align="center" >Magnifique</td>
                            </tr>
                            <%
                            if(size_postpaid==0){
                            %>
                            <tr>
                                <td align="center" colspan="6">No record matched the criteria</td>
                            </tr>
                            <%
                            }
                            else if(size_postpaid>0)
                            {
                                if(i==(pagecount_postpaid-1))
                                record_postpaid = size_postpaid ;
                                else
                                record_postpaid = (i+1)*10;
                                for(int j=i*10;j<record_postpaid;j++)
                                {
                                    String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                                    map = (HashMap)arraylist_postpaid.get(j);
                                    out.print("<tr bgcolor=" +strcolor + ">");
                                    out.print("<td align=left>"+(String)map.get("statdate")+"</td>");
                                    out.print("<td align=center>"+(String)map.get("16")+"</td>");
                                    out.print("<td align=center>"+(String)map.get("17")+"</td>");
                                    out.print("<td align=center>"+(String)map.get("22")+"</td>");
                                    String stat18=map.get("18")==null?"0":(String)map.get("18");
                                    String stat19=map.get("19")==null?"0":(String)map.get("19");
                                    int stattotal = Integer.parseInt(stat18)+Integer.parseInt(stat19);
                                    out.print("<td align=center>"+stattotal+"</td>");
                                    out.print("<td align=center>"+(String)map.get("23")+"</td>");
                                    out.print("</tr>");
                                }
                                if (arraylist_postpaid.size() > 10)
                                {
                                %>
                                <tr>
                                    <td width="100%" colspan="10">
                                        <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
                                            <tr>
                                                <td>&nbsp;Total:<%= arraylist_postpaid.size() %>,&nbsp;&nbsp;<%= pagecount_postpaid %>&nbsp;page(s),&nbsp;Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
                                                <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage('postpaid')" alt=""></td>
                                                <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage('postpaid',-1)\"" %> alt=""></td>
                                                <td><img src="button/nextpage.gif" <%= i * 10 + 10 >= arraylist_postpaid.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage('postpaid',1)\"" %> alt=""></td>
                                                <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage('postpaid')" alt=""></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            <%
                                }
                            }
                            %>
                        </table>
                        <%
                        }
                        %>
                        <!-- 固定用户数据 -->
                         Mobile fixed subscribers with:<br />
                        <%
                        //session.setAttribute("date_fixed",arraylist_fixed);
                        int  record_fixed = 0;
                        for (int i = 0; i < pagecount_fixed; i++)
                        {
                            String pageid = "page_fixed_"+Integer.toString(i+1);
                        %>
                        <table width="95%" border="0" cellspacing="1" cellpadding="2" align="center"  class="table-style2" id="<%= pageid %>" style="display:none" >
                            <tr class="table-title1" align="center">
                                <td height="30" width="20%" align="center">Month</td>
                                <td height="30" width="18%" align="center" >1 tone purchase</td>
                                <td height="30" width="18%" align="center" >2 tones purchase</td>
                                <td height="30" width="18%" align="center" >Gift <%=ringdisplay %></td>
                                <td height="30" width="18%" align="center" >Fast Tracks</td>
                                <td height="30" width="18%" align="center" >Magnifique</td>
                            </tr>
                            <%
                            if(size_fixed==0){
                            %>
                            <tr>
                                <td align="center" colspan="6">No record matched the criteria</td>
                            </tr>
                            <%
                            }
                            else if(size_fixed>0)
                            {
                                if(i==(pagecount_fixed-1))
                                record_fixed = size_fixed ;
                                else
                                record_fixed = (i+1)*10;
                                for(int j=i*10;j<record_fixed;j++)
                                {
                                    String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                                    map = (HashMap)arraylist_fixed.get(j);
                                    out.print("<tr bgcolor=" +strcolor + ">");
                                    out.print("<td align=left>"+(String)map.get("statdate")+"</td>");
                                    out.print("<td align=center>"+(String)map.get("16")+"</td>");
                                    out.print("<td align=center>"+(String)map.get("17")+"</td>");
                                    out.print("<td align=center>"+(String)map.get("22")+"</td>");
                                    String stat18=map.get("18")==null?"0":(String)map.get("18");
                                    String stat19=map.get("19")==null?"0":(String)map.get("19");
                                    int stattotal = Integer.parseInt(stat18)+Integer.parseInt(stat19);
                                    out.print("<td align=center>"+stattotal+"</td>");
                                    out.print("<td align=center>"+(String)map.get("23")+"</td>");
                                    out.print("</tr>");
                                }
                                if (arraylist_fixed.size() > 10)
                                {
                                %>
                                <tr>
                                    <td width="100%" colspan="10">
                                        <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
                                            <tr>
                                                <td>&nbsp;Total:<%= arraylist_fixed.size() %>,&nbsp;&nbsp;<%= pagecount_fixed %>&nbsp;page(s),&nbsp;Now on Page &nbsp;<%= i+1 %>&nbsp;</td>
                                                <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage('fixed')" alt=""></td>
                                                <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage('fixed',-1)\"" %> alt=""></td>
                                                <td><img src="button/nextpage.gif" <%= i * 10 + 10 >= arraylist_fixed.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage('fixed',1)\"" %> alt=""></td>
                                                <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage('fixed')" alt=""></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            <%
                                }
                            }
                            %>
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
        sysInfo.add(sysTime + operName + " Exception occurred in Tendency statistic");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in Tendency statistic");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
    %>
        <form name="errorForm" method="post" action="error.jsp">
            <input type="hidden" name="historyURL" value="tendencyStat.jsp">
        </form>
        <script language="javascript">
            document.errorForm.submit();
        </script>
    <%
    }
    %>
    </body>
</html>

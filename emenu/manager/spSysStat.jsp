<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara"%>
<%@ page import="zxyw50.manStat"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<script language="JavaScript">
    function  initform(fm){
      if(parseInt(fm.checkflag.value)==1)
          fm.checkTime.checked = true;
     else
         fm.checkTime.checked = false;
     onCheckTime();
    }


	function changeSP(){
	 	document.inputForm.op.value="search";
	 	document.inputForm.target="_self";
		document.inputForm.submit();
	}
</script>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	 String op = request.getParameter("op")==null?"0":(String)request.getParameter("op");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String spIndex = (String)request.getParameter("sp")==null?"*":(String)request.getParameter("sp");

	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

	try {
       Hashtable hash = null;
       String  errmsg = "";
       boolean flag =true;
       	zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
       else  if (purviewList.get("4-6") == null  || (!purview.CheckOperatorRightAllSerno(session,"4-6"))) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
       if(flag ){
       if(op.equals("bakdata")){
        	ArrayList al=(ArrayList)session.getAttribute("ResultSession");

    		response.setContentType("application/msexcel");
		response.setHeader("Content-disposition","inline; filename=sp_sys_stat.xls");
             	out.clear();
             	out.println("<table border='1'>");
    		out.println("<tr><td>SP code</td><td>ordered ringtones</td><td>Number of ringtones never being ordered</td><td >Total number of ringtones(piece)</td><td >Ringtone ordering ratio(%)</td><td >Total number of ringtone uploads(times)</td><td >Total size of ringtones (MB)</td><td>Number of passed verifications(times)</td><td >Number of failed verifications(times)</td><td >Passed verification ratio (%)</td><td >Total service incoming last month (" +majorcurrency+ ")</td></tr>");

            	for (int i = 0; i <al.size(); i++) {
			hash = (Hashtable)al.get(i);
			String strfee = (String)hash.get("fee")==null?"":(String)hash.get("fee");
			if(strfee.length()==0){
					out.println("<td align=right>"+strfee+"</td>");
			}
			else{
				//	float fee = Float.parseFloat(strfee);
					//out.println("<td align=right>"+Float.toString(fee/(float)100)+"</td>");
				//	strfee=Float.toString(fee/(float)100);
                                strfee=displayFee(strfee);
			}
                  	out.println("<tr><td>"+(String)hash.get("spcode")+"</td><td>"+(String)hash.get("buyrings")+"</td><td>"+(String)hash.get("nobuyrings")+"</td><td>"+(String)hash.get("ringnum")+"</td><td>"+(String)hash.get("scale")+"</td><td>"+(String)hash.get("uploadnum")+"</td><td>"+(String)hash.get("totalsize")+"</td><td>"+(String)hash.get("checkrings")+"</td><td>"+(String)hash.get("nocheckrings")+"</td><td>"+(String)hash.get("checkscale")+"</td><td>"+strfee+"</td></tr>");

               	}
               	out.println("</table>");
                al.clear();
        	return;
      	    }
	   	 manSysPara syspara = new manSysPara();
	   	 manStat    manstat = new manStat();
		 ArrayList spInfo = syspara.getSPInfo();
         ArrayList map = manstat.spSysStatAll(spIndex);

        int  recordcount = 15;
        int thepage = 0 ;
        int pagecount = 0;
        int size=0;
        if(map.size()>0){
             hash = (Hashtable)map.get(0);
             if(hash.size()==0)
                size = 0;
             else
                size = map.size();
       }
        pagecount = size/recordcount;
        if(size%recordcount>0)
           pagecount = pagecount + 1;
        if(size==0)
           pagecount=1;
        //System.out.println("size="+size);
        //System.out.println("pagecount="+pagecount);
        //System.out.println(map);
%>

<html>
<head>
<title>Service development statistics</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1"  onload="firstPage()">

<script language="JavaScript">

	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>




<script language="JavaScript">
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

    function WriteDataInExcel(){
 <% if(map==null || map.size()<1){ %>
      alert("No Stat.data for export!");
      return;
 <% }else{%>
      var fm = document.inputForm;
      fm.op.value = 'bakdata';
      fm.target="top";
      fm.submit();
  <%}%>
   }
</script>
<form name="inputForm" method="post">
<input type="hidden" name="op" value="">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">

<table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2" height="400" align="center">
   <tr>
   <td width="100%" valign="top" align="right">
   <table width="100%" class="table-style2">
   <tr >
          <td height="26"  align="center" class="text-title"  background="image/n-9.gif">SP system statistics</td>
   </tr>
   <tr>
   <td align="right"><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()" title="export in excel file"></td>
   </tr>
   <tr>
         <td   align="right">SP List
<select name="sp" class="select-style1"  onChange="javascript:changeSP()" >
<option value="*">-All SP-</option>
<%
          	    for (int i = 0; i < spInfo.size(); i++) {
                HashMap map1 = (HashMap)spInfo.get(i);
				String spdex = (String)map1.get("spindex");
				if (spIndex.equals(spdex)){
%>
             				 <option value="<%= (String)map1.get("spindex") %>" selected><%= (String)map1.get("spname") %></option>
<%
            }else{
%>
							<option value="<%= (String)map1.get("spindex") %>" ><%= (String)map1.get("spname") %></option>
<%
}
}
%>
</select>
</td>
   </tr>
   <tr>
    <td align="center" valign="top">
     <%

        int  record = 0;
        for (int i = 0; i < pagecount; i++) {
          String pageid = "page_"+Integer.toString(i+1);
     %>

      <table border="1" width="100%" cellspacing="0" cellpadding="0" class="table-style2" id="<%= pageid %>" style="display:none"  >
        <tr class="tr-ring">
            <td height="50" align="center"><span TITLE="SP code">SP code</span></td>
			<td height="50"align="center"><span TITLE="the number of the ordered ringtones">ordered </span></td>
			<td height="50"align="center"><span TITLE="the number of never ordered ringtones">0 ordered</span></td>
			<td height="50"align="center"><span TITLE="Total number of ringtones">Total</span></td>
			<td height="50"align="center"><span TITLE="Ringtone ordering ratio(%)">Ratio(%)</span></td>
			<td height="50"align="center"><span TITLE="Total number of ringtone uploads">upload</span></td>
			<td height="50"align="center"><span TITLE="Total size of ringtones (MB)">size(MB)</span></td>
			<td height="50"align="center"><span TITLE="Number of passed verifications(times)">passed</span></td>
			<td height="50"align="center"><span TITLE="Number of failed verifications(times)">failed</span></td>
			<td height="50"align="center"><span TITLE="Passed verification ratio (%)">Pass(%)</span></td>
			<td height="50"align="center"><span TITLE="Total service incoming last month (<%=majorcurrency%>)">Income</span></td>
		</tr>
		<%
   			if(size==0){
			%>
			<tr><td class="table-style2" align="center" colspan="10">No record matched the criteria</td>
			</tr>
			<%
			}else if(size>0){
			if(i==(pagecount-1))
               record = size - (pagecount-1)*recordcount;
            else
               record = recordcount;
		   for(int j=0;j<record;j++){
                String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
				hash = (Hashtable)map.get(i*recordcount + j);
		%>
		  <tr bgcolor="<%= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" %>">
		  <td height="20"><%= (String)hash.get("spcode") %></td>
          <td height="20"><%= (String)hash.get("buyrings") %></td>
          <td height="20"><%= (String)hash.get("nobuyrings") %></td>
          <td height="20"><%= (String)hash.get("ringnum") %></td>
          <td height="20" align="right"><%= (String)hash.get("scale") %></td>
          <td height="20" align="right"><%= (String)hash.get("uploadnum") %></td>
          <td height="20" align="right"><%= (String)hash.get("totalsize") %></td>
		  <td height="20" align="right"><%= (String)hash.get("checkrings") %></td>
		  <td height="20" align="right"><%= (String)hash.get("nocheckrings") %></td>
		  <td height="20" align="right"><%= (String)hash.get("checkscale") %></td>
		  <%
		  	String strfee = (String)hash.get("fee")==null?"":(String)hash.get("fee");
			if(strfee.length()==0){
					out.println("<td align=right>"+strfee+"</td>");
			}
			else{
				//	float fee = Float.parseFloat(strfee);
					out.println("<td align=right>"+displayFee(strfee)+"</td>");

			}
	     }
      session.setAttribute("ResultSession",map);
		 %>
        </tr>
        <%
            if(size>0){
        %>
		<tr>
         <td width="100%" colspan="11">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td >Total:<%= size %>,&nbsp;&nbsp;&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s)&nbsp;,on Page&nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()" title="to first page"></td>
              <td><img src="button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>  title="to pre page"></td>
              <td><img src="button/nextpage.gif" <%= i * recordcount + recordcount >= size ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %> title="to next page"></td>
              <td><img src="button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()" title="to last page"></td>
            </tr>
          </table>
          </td>
         </tr>
         <% }
         }
     %>
     </td>
     </tr>
     </table>
<%         }
%>

      </table>
    </td>
  </tr>
  </table>
  </tr>
  </td>
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
        sysInfo.add(sysTime + operName + " Exception occurred in querying the statistics on the SP services!");//sp业务统计查询过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in querying the statistics on the SP services!");//sp业务统计查询过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spSysStat.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

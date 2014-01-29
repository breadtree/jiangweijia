<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysRing"%>
<%@ include file="../pubfun/JavaFun.jsp" %>




<%
  //  response.addHeader("Cache-Control", "no-cache");
 //   response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
	 String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");

	 String hdlist        = request.getParameter("hdlist");
	 String scplist       = request.getParameter("scplist") == null ? "133" : transferString((String)request.getParameter("scplist")).trim();
 	 String subservice    = request.getParameter("subservice") == null ? "0" : transferString((String)request.getParameter("subservice")).trim();
	 String usertype      = request.getParameter("usertype")==null?"0":transferString((String)request.getParameter("usertype")).trim();

	 Vector vet=null;
  	 manSysRing sysring = new manSysRing();

    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        String  errmsg = "";
        boolean flag =true;
        zxyw50.Purview purview = new zxyw50.Purview();

       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
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
		vet = sysring.getHdUsernumber(hdlist,scplist,subservice,usertype);


		if("bakdata".equals(op))
		{	//导出到文�?
			response.setContentType("APPLICATION/OCTET-STREAM");
    		response.setHeader("Content-Disposition","attachment; filename=\"usernumber.txt\"");
    		out.clear();
    		for(int i=0; i< vet.size(); i++)
    		{
    			Hashtable hash = (Hashtable)vet.get(i);
    			out.println(hash.get("usernumber"));
    		}
    			return;
      }


		int thepage = 0 ;
      int pagecount = 0;
      int records = 20;
      int size=0;
      if(vet==null)
      	size =-1;
      else
         size = vet.size();
      //平行显示5�?
      int COLUMNS = 5;

      pagecount = size/(records * COLUMNS);
      if(size%records>0)
         pagecount = pagecount + 1;
      if(pagecount==0)
         pagecount = 1;

%>
<html>
<head>
<title>User Number Query</title>
<link rel="stylesheet" type="text/css" href="style.css">

</head>
<body background="background.gif" class="body-style1" >

<script language="javascript">

	function WriteDataInExcel(){
 <% if(vet.size()<1){ %>
      alert("No Stat.data for export!");
      return;
 <% }else{%>
      var fm = document.forms[0];
      fm.op.value = 'bakdata';
      fm.target='_parent';
      fm.submit();
      fm.target='_self';
  <%}%>
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
  function offpage(num){
    var obj = eval("page_" + num);
    obj.style.display="none";
  }


  function toPage(value){
    var fm = document.forms[0];
    var thePage = parseInt(fm.thepage.value);
    var pageCount = parseInt(fm.pagecount.value);


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

  function onBack()
  {
		var str='marketCount.jsp?objSort=1&hdlist=<%=hdlist%>&scplist=<%=scplist%>&subservice=<%=subservice%>&usertype=<%=usertype%>';
  		window.location.href = str ;
  }

</script>

<form name="InputForm" method="post" action="marketCountDetail.jsp">
<input type="hidden" name="op"         value="<%= op%>">
<input type="hidden" name="hdlist"     value="<%= hdlist%>">
<input type="hidden" name="scplist"    value="<%= scplist%>">
<input type="hidden" name="subservice" value="<%= subservice%>">
<input type="hidden" name="usertype"   value="<%= usertype%>">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<script language="JavaScript">

	if(parent.frames.length>0)
			parent.document.all.main.style.height=600;
</script>

<table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2" >
  <tr>
    <td valign="top" height="35">
      <table class="table-style2" width="100%" align="center">
		<tr >
        	<td height="26" colspan=2 class="text-title" align="center" >User number Query</td>
        	<td align="right"><img src="button/back.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onBack()"></td>
         <td><img border="0" src="button/daochu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:WriteDataInExcel()"></td>

      </tr>
    </table>
    </td>
  </tr>
  <tr>
  <td align="center">
<%
        int  record = 0;
        for (int i = 0; i < pagecount; i++) {
            String pageid = "page_"+Integer.toString(i+1);
%>

     <table width="100%" border="0" cellspacing="1" cellpadding="2"  class="table-style2" id="<%= pageid %>" <%= i == 0 ? "" : "style=\"display:none\"" %>>
         <tr class="table-title1" height="26">
          <td width="20%" align="center"><span class="style1">User number</span></td>
          <td width="20%" align="center"><span class="style1">User number</span></td>
          <td width="20%" align="center"><span class="style1">User number</span></td>
          <td width="20%" align="center"><span class="style1">User number</span></td>
          <td width="20%" align="center"><span class="style1">User number</span></td>
         </tr>
<%
                if(size==0){
%>
         <tr><td class="table-style2" align="center" colspan="10">There are no records meeting the condition!</td>
	 </tr>
<%
                }
                else if(size>0){

		    				if(i==(pagecount-1))
                        record = size - (pagecount-1)*records*COLUMNS;
                    else
                        record = records*COLUMNS;
                    for(int j=0;j<record;j=j+COLUMNS){
                        String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                        out.print("<tr bgcolor=" +strcolor + ">");
                        for (int l = j; l < j + COLUMNS; l++){
                          if ((i*records*COLUMNS + l + 1) > vet.size()){
                              out.print("");
                          }
                          else{
                          		Hashtable hash = (Hashtable)vet.get(i*records*COLUMNS + l);
                              out.print("<td align=center>"+ hash.get("usernumber")+"</td>");
                              out.print("</td>");
                          }
                        }
                        out.print("</tr>");
                    }//for

 %>

        <tr>
        <td width="100%" colspan="10">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
<%
	if(pagecount>1)
	{
%>
              <td >&nbsp;Total:<%= vet.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;&nbsp;now on page&nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
              <td><img src="../button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
              <td><img src="../button/nextpage.gif" <%= i * records * COLUMNS + records >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
              <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()"></td>
<%}%>

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
        Vector vet1 = new Vector();
        sysInfo.add(sysTime + operName + ",Error occurs during get user number(s)!");
        sysInfo.add(sysTime + operName + e.toString());
        vet1.add("Error occurs during get user number(s)!");
        vet1.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet1);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="marketCount.jsp?objSort=1&hdlist=<%=hdlist%>&scplist=<%=scplist%>&subservice=<%=subservice%>&usertype=<%=usertype%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>




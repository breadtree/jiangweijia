<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.ManGroup" %>
<%@ page import="zxyw50.group.dataobj.*" %>
<%@ page import="zxyw50.group.context.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    boolean blexist = false;
    //change by wxq 2005.05.31 for version 3.16.01
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String groupindex,groupid,groupname;
    if (mode.equals("manager")){
        groupindex = request.getParameter("groupindex") == null ? "" : request.getParameter("groupindex");
        groupid = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
        groupname = request.getParameter("groupname") == null ? "" : transferString(request.getParameter("groupname"));
    }else{
        groupindex = (String)session.getAttribute("GROUPINDEX");
        groupid = (String)session.getAttribute("GROUPID");
        groupname =  (String)session.getAttribute("GROUPNAME");
    }
    //end
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    //add by wxq 2005.06.07 for version 3.16.01
    String userNumber = request.getParameter("userNumber") == null ? "" : request.getParameter("userNumber");
    boolean isInGroup = false;
    //查询集团内全部成员
    String closeid = "*";
    //end
    try {
        String  errMsg = "";
        boolean flag =true;
        if (operID  == null){
            errMsg = "Please log in to the system first!";
            flag = false;
        }
        else if (purviewList.get("12-12") == null) {
            //如果mode的值为manager,表明是管理员进入,并且已经通过了审核,允许进入
            if (mode.equals("manager")){
                blexist = false;
            }
            else{
                errMsg = "You have no access to the function";
                blexist = true;
            }
        }
        if(!flag){
%>
<script language="javascript">
   alert("<%=  errMsg  %>");
   document.URL = 'enter.jsp';
</script>
<%
        }
        else{
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            Group grp = new Group();
            grp.setGroupIndex(groupindex);
            if (op.equals("search")){
                isInGroup = grp.getGroupContext().isUserInGroup(userNumber);
            }
            ArrayList arraylist = new ArrayList();
            if(!groupid.equals("")){
                grp.setGroupId(groupid);
                grp.getGroupContext().loadGroupingMember(closeid);
                ArrayList grpList = grp.getGroupingMember();
                arraylist = grp.getGroupingMember();
            }
            int thepage = 0 ;
            int pagecount = 0;
            int records = 20;
            int size=0;
            if(arraylist==null)
                size =-1;
            else
                size = arraylist.size();
            //平行显示5列
            pagecount = size/(records * 5);
            if(size%records>0)
                pagecount = pagecount + 1;
            if(pagecount==0)
                pagecount = 1;
%>
<html>
<head>
<title>Group member detail statistic </title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body class="body-style1">

<script language="javascript">
  //限定只能输入数字
  function numbersOnly(field,event){
    var key,keychar;
    if(window.event){
      key = window.event.keyCode;
    }
    else if (event){
      key = event.which;
    }
    else{
      return true
    }
    keychar = String.fromCharCode(key);
    if((key == null) || (key == 0) || (key == 8)|| (key == 9) || (key == 13) || (key == 27)){
      return true;
    }
    else if(('0123456789').indexOf(keychar) > -1){
      return true;
    }
    else {
      alert('Please input digit!');
      return false;
    }
  }

  function toPage (page) {
    document.InputForm.page.value = page;
    document.InputForm.submit();
  }

  function searchUser () {
    var fm = document.InputForm;
    if (fm.userNumber.value == ''){
      alert('Please input the user number to be queried!');
      return;
    }
    fm.op.value = 'search';
    fm.submit();
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
<form name="InputForm" method="post" action="grpMemberDetailStat.jsp">
<input type="hidden" name="op" value="<%= op%>">
<input type="hidden" name="pagecount" value="<%= pagecount %>">
<input type="hidden" name="thepage" value="<%= thepage+1 %>">
<!--change by wxq 2005.06.16-->
<input type="hidden" name="mode" value="<%= mode %>"/>
<input type="hidden" name="groupid" value="<%= groupid %>"/>
<input type="hidden" name="groupindex" value="<%= groupindex %>"/>
<input type="hidden" name="groupname" value="<%= groupname %>"/>
<!--end-->
<script language="JavaScript">
  if(parent.frames.length>0)
    parent.document.all.main.style.height=530;
</script>
<table border="0" width="100%" cellspacing="0" cellpadding="0" class="table-style2" >
  <tr>
    <td valign="top" height="35">
      <table border="0" width="77%" cellspacing="0" cellpadding="0" class="table-style2">
        <tr>
          <td>
            &nbsp;&nbsp;<b>Input user number:</b>
          </td>
          <td>
            <input type="text" name="userNumber" value="" maxlength="20" size="20" onkeypress="return numbersOnly(this);"/>
          </td>
          <td align="left">
            <img border="0" src="../button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchUser()">
          </td>
        </tr>
        <tr id="userResult" <%= op.equals("search") == true ? "" : "style=\"display:none\"" %>>
          <td align="left" colspan="3">&nbsp;
          <font size="3"><b>Query result:<font color="red"><%= userNumber %><%= isInGroup == true ? " Belong to this group" : " Not belong to this group"%></font></b></font>
          </td>
        </tr>
      </table>
      <table class="table-style2" width="100%" align="center">
	<tr >
        <td height="26" colspan=2 class="text-title" align="center" ><%= groupname %> Group member detail query statistic</td>
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
                if(size==0 && !groupid.equals("")){
%>
         <tr><td class="table-style2" align="center" colspan="10">There are no records meeting the condition!</td>
	 </tr>
<%
                }
                else if(size>0){
		    if(i==(pagecount-1))
                        record = size - (pagecount-1)*records*5;
                    else
                        record = records*5;
                    for(int j=0;j<record;j=j+5){
                        String strcolor= j % 2 == 0 ? "#FFFFFF" :  "E6ECFF" ;
                        out.print("<tr bgcolor=" +strcolor + ">");
                        for (int l = j; l < j + 5; l++){
                          if ((i*records*5 + l + 1) > arraylist.size()){
                              out.print("");
                          }
                          else{
                              out.print("<td align=center>"+arraylist.get(i*records*5 + l)+"</td>");
                              out.print("</td>");
                          }
                        }
                        out.print("</tr>");
                    }//for
					if( arraylist.size() > records * 5){
 %>
        <tr>
        <td width="100%" colspan="10">
          <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
              <td class="table-style2">&nbsp;Total:<%= arraylist.size() %>,&nbsp;&nbsp;<%= pagecount %>&nbsp;page(s),&nbsp;&nbsp;now on page&nbsp;<%= i+1 %>&nbsp;</td>
              <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:firstPage()"></td>
              <td><img src="../button/prepage.gif"<%= i == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(-1)\"" %>></td>
              <td><img src="../button/nextpage.gif" <%= i * records * 5 + records >= arraylist.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(1)\"" %>></td>
              <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:endPage()"></td>
            </tr>
          </table>
        </td>
      </tr>
<%
	}
%>
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
        sysInfo.add(sysTime + operName + "is abnormal during the group member detail query statistic!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the group member detail query statistic!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpMemberDetailStat.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>&amp;groupname=<%=groupname%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>

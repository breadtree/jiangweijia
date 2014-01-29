<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Operator Management</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<script src="../../pubfun/JsFun.js"></script>
</head>
<body class="body-style1">
<%
    try {
        String operID = (String)session.getAttribute("OPERID");
        ArrayList list = new ArrayList();
        HashMap map = new HashMap();
        String operflag = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String tempname = request.getParameter("opername") == null ? "" : (String)request.getParameter("opername");
        String name = tempname.trim();
        String serflag = request.getParameter("serflag") == null ? "0" : (String)request.getParameter("serflag");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
        if ( operID != null && purviewList.get("5-1") != null){
           if("search".equals(operflag)) {
             list = purview.sortChildOperators2(operID,name,serflag);
%>
<script language="javascript">
parent.buttonFrame.mm.style.display = "block";
parent.buttonFrame.add.style.display = "block";
parent.buttonFrame.back.style.display = "none";
parent.buttonFrame.document.view.pageflag.value = "";
</script>
<%
           } else {
             list = purview.sortChildOperators(operID);
           }
           if (list == null)
              list = new ArrayList();

           int records = 30;
           int pages = list.size()/records;
           if(list.size()%records>0)
              pages = pages + 1;

          String idstr = "";
%>
<script language="javascript">
   // 更新,将用户列表更新。
   function refresh () {
      parent.buttonFrame.document.view.operName.value = '';
      parent.buttonFrame.document.view.serviceKey.value = '';
      parent.buttonFrame.document.view.serviceName.value = '';
      parent.buttonFrame.document.view.unlock.disabled = true;
      parent.buttonFrame.document.view.del.disabled = true;
      parent.buttonFrame.document.view.attr.disabled = true;
      parent.buttonFrame.document.view.signOut.disabled = true;
      parent.groupFrame.document.view.operID.value = '';
      parent.currentFrame.document.view.operID.value = '';
      document.view.submit();
   }

   function refresh2 (name,serflag) {
      parent.buttonFrame.document.view.operName.value = '';
      parent.buttonFrame.document.view.serviceKey.value = '';
      parent.buttonFrame.document.view.serviceName.value = '';
      parent.buttonFrame.document.view.unlock.disabled = true;
      parent.buttonFrame.document.view.del.disabled = true;
      parent.buttonFrame.document.view.attr.disabled = true;
      parent.buttonFrame.document.view.signOut.disabled = true;

      document.view.opername.value = name;
//      document.view.serflag.value = serflag;
//      document.view.op.value = 'search';
      parent.groupFrame.refresh();
      parent.currentFrame.refresh();
      document.view.submit();
   }

   // 双击指定用户的时候发生的动作
   function viewOper (operID,operName,operStat,idForm) {
      var tempID = parent.buttonFrame.document.view.idid.value;
      document.getElementById(idForm).bgColor = '#FF7700';
      if((tempID!=null) && (tempID!='') && (tempID!=idForm)) {
        document.getElementById(tempID).bgColor = '';
      }
      document.view.operID.value = operID;
      if (parent.buttonFrame.checkWin() == 'no') {
         parent.buttonFrame.document.view.operID.value = operID;
         parent.buttonFrame.document.view.operName.value = operName;
         parent.buttonFrame.document.view.serviceName.value = '';
         parent.buttonFrame.document.view.signOut.disabled = true;
         parent.buttonFrame.document.view.del.disabled = false;
         parent.buttonFrame.document.view.attr.disabled = false;
         parent.buttonFrame.document.view.member.disabled = false;
         parent.buttonFrame.document.view.signOut.disabled = true;
         if(parseInt(operStat)==0){
           parent.buttonFrame.document.view.unlock.disabled = true;

         }
         else{
           parent.buttonFrame.document.view.unlock.disabled = false;

         }
         parent.groupFrame.document.view.operID.value = operID;
         parent.groupFrame.refresh();
         parent.currentFrame.document.view.operID.value = operID;
         parent.buttonFrame.document.view.idid.value = idForm;
         parent.currentFrame.refresh();
      }
      if (operID == '<%= operID %>') {
         parent.buttonFrame.document.view.unlock.disabled = true;
         parent.buttonFrame.document.view.del.disabled = true;
         parent.buttonFrame.document.view.attr.disabled = true;
         parent.buttonFrame.document.view.signOut.disabled = true;
      }
      else
	   {
	  parent.buttonFrame.document.view.signOut.disabled = false;
	   }
   }

   function toPage (page) {
      document.view.page.value = page;

      parent.buttonFrame.document.view.unlock.disabled = true;
      parent.buttonFrame.document.view.del.disabled = true;
      parent.buttonFrame.document.view.attr.disabled = true;
      parent.buttonFrame.document.view.signOut.disabled = true;
      parent.buttonFrame.document.view.member.disabled = true;
      parent.buttonFrame.document.view.operName.value = "";
      parent.buttonFrame.document.view.serviceName.value = "";


      parent.groupFrame.refresh();
      parent.currentFrame.refresh();
      parent.buttonFrame.document.view.idid.value = '';
      document.view.submit();
   }

   function goPage(){
      var fm = document.view;
      var pages = parseInt(fm.pages.value);
      var thepage =parseInt(trim(fm.gopage.value));
      if(thepage==''){
         alert("Please specify the value of the page to go to!")
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!")
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!")
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      toPage(thepage);
   }

   function searchRing() {
     var fm = document.view;
     fm.op.value = 'search';
     fm.page.value = 0;

      parent.buttonFrame.document.view.unlock.disabled = true;
      parent.buttonFrame.document.view.del.disabled = true;
      parent.buttonFrame.document.view.attr.disabled = true;
      parent.buttonFrame.document.view.signOut.disabled = true;
      parent.buttonFrame.document.view.operName.value = "";
      parent.buttonFrame.document.view.serviceName.value = "";

      parent.groupFrame.refresh();
      parent.currentFrame.refresh();
      parent.buttonFrame.document.view.idid.value = '';

     document.view.submit();
   }
</script>
<form name="view" method="post" action="operList.jsp">
<input type="hidden" name="operID" value="">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="op" value="<%= operflag %>">

<table border="1" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style2" height=hei >
  <tr align="center" class="table-title1">
  Operator name<input type="text" name="opername" value="<%= name %>" maxlength="30" size="15" class="input-style7" >
  <br>Operator type
      <select name="serflag">
        <option value="0" selected="selected">System operator</option>
        <option value="1">SP operator</option>
        <option value="2">Group operator</option>
		<!-- Added for ccs module -->
		<option value="3">CCS operator</option>
      </select>
      <img src="../button/search.gif" alt="Search operator" onmouseover="this.style.cursor='pointer'" onclick="javascript:searchRing()">
  </tr><br>
<script language="javascript">
var serflagValue = '<%=serflag%>';
document.view.serflag.value = serflagValue;
</script>
  <tr class="table-title1" >
    <td width="50" height="24">Login name</td>
    <td width="80" height="24">Full name</td>
    <td width="100" height="24">Description</td>
    <td width="80" height="24">Creator</td>
    <td width="80" height="24">Operator status</td>
  </tr>
<script language="JavaScript">
	if(parent.parent.frames.length>0){
		var hei;

<%
        int temp = records-((thepage+1) * records-list.size());
	if(list!=null && (list.size()<=12||temp<12)){
%>
	hei = 400;
<%
	}else if (list!=null && temp>12 && temp<records) {
%>
	hei=400+(<%=temp%>*25);
<%
        } else {
%>
         hei=20*50;
<%
        }
%>
		parent.parent.document.all.main.style.height=hei+150;

		}
</script>
<%
        for (int i = thepage * records; i < thepage * records +records && i < list.size(); i++) {
            map = (HashMap)list.get(i);
            idstr = "table_color"+i;
%>
  <tr  id="<%=idstr%>"  bgcolor="" ondblclick="javascript:viewOper('<%= (String)map.get("OPERID") %>','<%= (String)map.get("OPERNAME")%>','<%= (String)map.get("OPERSTATUS")%>','<%=idstr%>')">
    <td height="22"><%= (String)map.get("OPERNAME") %>&nbsp;</td>
    <td height="22" align="center"><%= (String)map.get("OPERALLNAME") %>&nbsp;</td>
    <td height="22" align="center"><%= (String)map.get("OPERDESCRIPTION") %>&nbsp;</td>
    <td height="22" align="center"><%= (String)map.get("CREATORNAME") %>&nbsp;</td>
<%
     int stat = 0;
     stat = Integer.parseInt((String)map.get("OPERSTATUS"));
     String strTemp = "Normal";//正常
     if (stat ==1)
       strTemp = "Lock";//锁定
     else if(stat == 2)
       strTemp = "Blacklist";//黑名单
     else  if(stat == 3)
       strTemp = "Disable";//禁止
     else if(stat>9)
       strTemp = "Blacklist";//黑名单
     out.println("<td height=22 align=\"center\">"+strTemp + "&nbsp;</td>");
     out.println("</tr>");
     }
%>
<%
        if (list.size() > records) {
%>
  <tr>
      <table border="0" cellspacing="1" cellpadding="1" align="center" class="table-style2">
        <tr>
          <td>&nbsp;<%= list.size() %>&nbsp;entries in total&nbsp;<%= list.size()%records==0?list.size()/records:list.size()/records+1 %>&nbsp;pages&nbsp;&nbsp;You are now on the page of&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../../button/firstpage.gif" onmouseover="this.style.cursor='pointer'" onclick="javascript:toPage(0)"></td>
          <td><img src="../../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='pointer'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../../button/nextpage.gif"<%= thepage * records + records >= list.size() ? "" : " onmouseover=\"this.style.cursor='pointer'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../../button/endpage.gif" onmouseover="this.style.cursor='pointer'" onclick="javascript:toPage(<%= (list.size() - 1) / records %>)"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >Page&nbsp;</td>
             <td> <input style=text value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../../button/go.gif" onmouseover="this.style.cursor='pointer'" onclick="javascript:goPage()"  ></td>
            </tr>
            </table>
          </td>
       </tr>
      </table>
  </tr>

<%
        }
%>
</table>
</form>
<%

        }
        else {

          if(operID== null){
              %>
              <script language="javascript">
                    alert( "Please log in first!");
                    parent.document.location.href = '../enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no right to access this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
%>
<table border="1" width="100%" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5" height=400>
  <tr>
    <td>Error:<%= e.toString() %></td>
  </tr>
</table>
<%
    }
%>
<script language="javascript">
   if (document.view.operID.value != '') {
      parent.groupFrame.refresh();
      parent.currentFrame.document.view.operID.value = document.view.operID.value;
      parent.currentFrame.refresh();
   }
</script>
</body>
<html>

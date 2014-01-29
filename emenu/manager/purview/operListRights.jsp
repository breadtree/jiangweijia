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
<title>Authorize</title>
<link rel="stylesheet" type="text/css" href="../style.css">
  <script src="../../pubfun/JsFun.js"></script>
<script language="javascript">
   // 双击指定用户的时候发生的动作
   function viewOper (operID,operName,idForm) {
      var fm = document.inputForm;
      var tempID = fm.idid.value;
      //alert('idForm:'+idForm+"\n"+"tempId: "+tempID);
      document.getElementById(idForm).bgColor = '#FF9900';
      if((tempID!=null) && (tempID!='') && (tempID!=idForm)) {
        //alert("tempid2: "+tempID);
        document.getElementById(tempID).bgColor = '';
      }

      parent.allotFrame.document.view.operID.value = operID;
      parent.bmFrame.document.view.operID.value = operID;
      parent.allotFrame.document.view.operName.value = operName;
      fm.idid.value = idForm;
      parent.bmFrame.document.view.memberRight.disabled = false;
      parent.allotFrame.document.view.submit();
   }

   function toPage (page) {
      document.inputForm.page.value = page;

      parent.allotFrame.document.view.operID.value = "";
      parent.allotFrame.document.view.operName.value = "";
      parent.allotFrame.document.view.submit();
      document.inputForm.idid.value = '';
      parent.bmFrame.document.view.memberRight.disabled = true;
      document.inputForm.submit();
   }

   function goPage(){
      var fm = document.inputForm;
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
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!!")
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      toPage(thepage);
   }

   function searchRing() {
     var fm = document.inputForm;
     fm.op.value = 'search';
     fm.page.value = 0;

      parent.allotFrame.document.view.operID.value = "";
      parent.allotFrame.document.view.operName.value = "";
      parent.allotFrame.document.view.submit();
      document.inputForm.idid.value = '';

     document.inputForm.submit();
   }
</script>
</head>

<body class="body-style1">
<%
    try {
        String operID = (String)session.getAttribute("OPERID");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        String operflag = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String name = request.getParameter("opername") == null ? "" : (String)request.getParameter("opername");
        String serflag = request.getParameter("serflag") == null ? "0" : (String)request.getParameter("serflag");
        ArrayList list = new ArrayList();
        HashMap map = new HashMap();
        int records = 30;//每页显示的记录数
        if (operID != null)
            if("search".equals(operflag)) {
             list = purview.sortChildOperators2(operID,name,serflag);
           } else {
             list = purview.sortChildOperators(operID);
           }
        if (list == null)
            list = new ArrayList();

        int pages = list.size()/records;
        if(list.size()%records>0)
            pages = pages + 1;

        String idstr = "";
%>
<form name="inputForm" action="operListRights.jsp" method="POST">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="op" value="<%= operflag %>">
<input type="hidden" name="idid" value="">

<table  border="1" bordercolorlight="#000000" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style1" height=hei>
  <tr align="center" class="table-title1" >
   Operator name<br>
      <input type="text" name="opername" value="<%= name %>" maxlength="30" size="15" class="input-style7" ><br>
   Operator type<br>
      <select name="serflag">
        <option value="0" selected="selected">System operator</option>
        <option value="1">Sp operator</option>
        <option value="2">Group operator</option>
        <!-- Added for ccs module -->
	   <option value="3">CCS operator</option>
      </select>
      <img src="../button/search.gif" alt="Search operator" onmouseover="this.style.cursor='pointer'" onclick="javascript:searchRing()">
  </tr><br>
<script language="javascript">
var serflagValue = '<%=serflag%>';
document.inputForm.serflag.value = serflagValue;
</script>
  <tr class="table-title1">
    <td width="90" height="24">Login name</td>
    <td width="100" height="24">Full name</td>
  </tr>
<script language="JavaScript">
	if(parent.parent.frames.length>0){
		var hei;
<%
	if(list!=null && list.size()>25){
%>
	hei = 20*50+100;
<%
	}else{
%>
	hei=600;
<%
}
%>
		parent.parent.document.all.main.style.height=hei;
		}
</script>
<%
        for (int i = thepage * records; i < thepage * records +records && i < list.size(); i++) {
            map = (HashMap)list.get(i);
            idstr = "table_color"+i;
%>
  <tr id="<%=idstr%>" bgcolor="" <%= operID.equals((String)map.get("OPERID")) ? "" : "ondblclick=\"javascript:viewOper('" + (String)map.get("OPERID") + "','" + (String)map.get("OPERNAME") + "','"+idstr+"')\"" %>>
    <td height="22" ><%= (String)map.get("OPERNAME") %>&nbsp;</td>
    <td height="22" ><%= (String)map.get("OPERALLNAME") %>&nbsp;</td>
  </tr>
<%
        }
%>
<%
        if (list.size() > records) {
%>
  <tr>
      <table border="0" cellspacing="1" cellpadding="1" align="center" class="table-style2">
        <tr>
           &nbsp;<%= list.size() %>&nbsp;entries in total&nbsp;<%= list.size()%records==0?list.size()/records:list.size()/records+1 %>&nbsp;page&nbsp;&nbsp;You are now on the page of&nbsp;<%= thepage + 1 %>&nbsp;
        </tr>
        <tr>
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
    catch (Exception e) {
%>
<table border="1" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5">
  <tr>
    <td height="24" colspan="2">Error:<%= e.toString() %></td>
  </tr>
</table>
<%
    }
%>
</table>
</form>
</body>
</html>

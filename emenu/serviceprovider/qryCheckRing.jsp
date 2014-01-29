<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.CrbtUtil" %>


<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    String issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice","0");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String spIndex = (String)session.getAttribute("SPINDEX");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	 String colorName = (String)session.getAttribute("COLORNAME")==null?"":(String)session.getAttribute("COLORNAME");

	 String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


    try {
       String  errmsg = "";
       boolean flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
       else if (spIndex  == null || spIndex.equals("-1")){
          errmsg = "Sorry, you are not an SP administrator!";//Sorry,you are not the SP administrator
          flag = false;
       }
       else if (purviewList.get("9-7") == null ) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
       if(flag){
          String checkflag ="0";
          String sortBy = "uploadtime";
          int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
          Vector vet = new Vector();
          Hashtable hash = new Hashtable();
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();

          if(op.equals("search")){
              checkflag = request.getParameter("checkflag") == null ? "0" : (String)request.getParameter("checkflag");
              sortBy = request.getParameter("searchmodel") == null ? "uploadtime" : (String)request.getParameter("searchmodel");
          }
          hash.put("spindex",spIndex);
          hash.put("checkflag",checkflag);
          hash.put("sortby",sortBy);
          vet = db.qryCheckRing(hash);
%>


<html>
<head>
<link href="../manager/style.css" type="text/css" rel="stylesheet">
<title>Query SP ringtones for approval</title>
<style type="text/css">
<!--
.style1 {color: #000000;}
-->
</style>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="initform(document.forms[0])">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<script language="javascript">

   function searchRing(){
      document.inputForm.page.value = 0;
      document.inputForm.op.value = "search";
      document.inputForm.submit();

   }

    function searchInfo () {
      var fm = document.inputForm;
      if(fm.checkflag.selectedIndex==-1){
         alert("Please select an approval type");//请选择审核类型
         return;
      }
      fm.page.value = 0;

      fm.op.value = 'search';
      fm.submit();
   }

   function  initform(fm){
     var checkflag = "<%= checkflag %>";
	 len = fm.checkflag.length;
     if( len >=0){
        fm.checkflag.selectedIndex = 0;
        for(var i=0; i<len; i++)
          if(fm.checkflag.options[i].value == checkflag){
            fm.checkflag.selectedIndex = i;
            break;
          }
     }
     var temp = "<%= sortBy %>";
     len = fm.searchmodel.length;
     if( len >=0){
        fm.searchmodel.selectedIndex = 0;
        for(var i=0; i<len; i++)
          if(fm.searchmodel.options[i].value == temp){
            fm.searchmodel.selectedIndex = i;
            break;
          }
     }
   }

   function toPage (page) {
      document.inputForm.page.value = page;

      document.inputForm.op.value = 'search';

      document.inputForm.submit();
   }

   function ringInfo (ringid) {
      infoWin = window.open('ringInfo.jsp?ringid=' + ringid,'infoWin','width=400, height=340');
   }
</script>
<form name="inputForm" method="post" action="qryCheckRing.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="sortby" value="<%= sortBy %>">

<table width="521" cellspacing="0" cellpadding="0" border="0" class="table-style2" height="600" align="center">

  <tr>
    <td height="50" align="center">
      <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="100%">
        <tr>
            <td colspan="3" align="center" class="text-title" background="image/n-9.gif" height="26">Query SP <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s for approval</td>
		 </tr>
		  <tr>
          <td  width="50%">Approval type
            <select name="checkflag" class="select-style1" >
              <option value="0" >Content/Price approval</option>
              <option value="1" >Content approval</option>
              <option value="2" >Price approval</option>
            </select>
          </td>
          <td  width="40%">Sort
            <select name="searchmodel" class="select-style1" >
              <option value="ringid">Ringtone code</option>
              <option value="ringlabel">Ringtone name</option>
              <%if("1".equals(issupportmultipleprice)){%>
              <option value="ringfee2">Daily Price</option><%}%>
              <option value="ringfee"><%if("1".equals(issupportmultipleprice)){%>Monthly<%}%> Price</option>
              <option value="uploadtime">Upload Date</option>
            </select>
          </td>
		  <td width="11%" ><img src="../button/search.gif" border="0" onclick="javascript:searchInfo()" onmouseover="this.style.cursor='hand'"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="100%" valign="top" >
      <table border="0" cellspacing="1" cellpadding="1" width="100%" class="table-style2">
        <tr  class="tr-ring">
          <td width="15%" height="24" align="center"><span title="">Code</span></td>
          <td width="25%" height="24" align="center"><span title="">Name</span></td>
          <td width="25%" height="24" align="center"><span title=""><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></span></td>
          <%if("1".equals(issupportmultipleprice)){%>
          <td width="15%" height="24" align="center"><span title="">Daily Price(<%=majorcurrency%>)</span></td><%}%>
          <td width="15%" height="24" align="center"><span title=""><%if("1".equals(issupportmultipleprice)){%>Monthly<%}%> Price(<%=majorcurrency%>)</span></td>
          <td width="20%" height="24" align="center"><span title="">Upload Date</span></td>
        </tr>
<%
        if(vet.size()>0){
		int count = vet.size() == 0 ? 15 : 0;
        for (int i = thepage * 15; i < thepage * 15 + 15 && i < vet.size(); i++) {
            hash = (Hashtable)vet.get(i);
            count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "#f5fbff" : "" %>">
          <td align="center" ><%= (String)hash.get("ringid") %></td>
          <td><%= (String)hash.get("ringlabel") %></td>
          <td ><%= (String)hash.get("ringauthor") %></td>
          <%if("1".equals(issupportmultipleprice)){%>
          <td >&nbsp;<%= displayFee((String)hash.get("ringfee2")) %></td><%}%>
          <td >&nbsp;<%= displayFee((String)hash.get("ringfee")) %></td>

          <td align="center" ><%= (String)hash.get("uploadtime") %></td>
        </tr>
<%
        }

          if (vet.size() > 15) {
%>
  <tr>
    <td width="100%" colspan="5"  valign="middle" align="right">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2" width="100%">
        <tr align="right">
          <td width="74%">&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%15==0?vet.size()/15:vet.size()/15+1 %>&nbsp;pages&nbsp;&nbsp;You are now on Page &nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td width="6%"><img src="../button/firstpage.gif" width="45" height="19" onclick="javascript:toPage(0)" onmouseover="this.style.cursor='hand'"></td>
          <td width="7%"><img src="../button/prepage.gif" width="45" height="19"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td width="6%"><img src="../button/nextpage.gif" width="45" height="19"<%= thepage * 15 + 15 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td width="7%"><img src="../button/endpage.gif" width="45" height="19" onclick="javascript:toPage(<%= (vet.size() - 1) / 15 %>)" onmouseover="this.style.cursor='hand'"></td>
        </tr>
      </table>
    </td>
  </tr>
<%
        }
%>
      </table>
    </td>
  </tr>
<%


		}else{
%>
<tr>
	<td width="50%" align="center" colspan="7">
	No matched ringtone is found now!
	</td>
</tr>
<%
}%>
</table>
</form>
<%
        }
        else {
%>
<script language="javascript">
   var errmsg = '<%= operID!=null?errmsg:"Please log in to the system first!"%>';
   alert(errmsg);
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ",Exception occurred in querying SP ringtones for approval!");//SP待审核铃音查询过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Exception occurred in querying SP ringtones for approval!");//SP待审核铃音查询过程出现异常!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="qryCheckRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

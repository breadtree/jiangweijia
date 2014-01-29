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
       else if (purviewList.get("9-3") == null ) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
       if(flag){
          String allIndex = "-1";
          String sortBy = "uploadtime";
          int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
          Vector vet = new Vector();
          Hashtable hash = new Hashtable();
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
          if(op.equals("search")){
              allIndex = request.getParameter("index") == null ? "" : (String)request.getParameter("index");
              sortBy = request.getParameter("searchmodel") == null ? "uploadtime" : (String)request.getParameter("searchmodel");
          }
          hash.put("spindex",spIndex);
          hash.put("allindex","-1");
          hash.put("sortby",sortBy);
          vet = db.spUncheckRing(hash);
%>


<html>
<head>
<link href="../manager/style.css" type="text/css" rel="stylesheet">
<title>Ringtone Rank</title>
<style type="text/css">
<!--
.style1 {color: #000000}
-->
</style>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="initform(document.forms[0])">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<script language="javascript">
   // É¾³ý×Ö·û´®µÄ×ó±ß¿Õ¸ñ
   function leftTrim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = str;
      var i = 0;
      for (i = 0; i < str.length; i++) {
         if (tmp.substring(0,1) == ' ')
            tmp = tmp.substring(1,tmp.length);
         else
            return tmp;
      }
   }

   // É¾³ý×Ö·û´®µÄÓÒ±ß¿Õ¸ñ
   function rightTrim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = str;
      var i = 0;
      for (i = str.length - 1; i >= 0; i--) {
         if (tmp.substring(tmp.length - 1,tmp.length) == ' ')
            tmp = tmp.substring(0,tmp.length - 1);
         else
            return tmp;
      }
   }

   // É¾³ý×Ö·û´®µÄÁ½±ß¿Õ¸ñ
   function trim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = leftTrim(str);
      return rightTrim(tmp);
   }

   function searchRing(){
      document.inputForm.page.value = 0;
      document.inputForm.op.value = "search";
      document.inputForm.submit();

   }

   function  initform(fm){

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
      document.inputForm.searchmodel.value = '<%=sortBy%>';
      document.inputForm.op.value = "search";
      document.inputForm.submit();
   }

   function ringInfo (ringid) {
      infoWin = window.open('ringInfo.jsp?ringid=' + ringid,'infoWin','width=400, height=340');
   }
</script>
<form name="inputForm" method="post" action="spUncheckRing.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="sortby" value="<%= sortBy %>">

<table width="521" cellspacing="0" cellpadding="0" border="0" class="table-style2" height="600" align="center">

  <tr>
    <td width="100%" height="50">
      <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="100%">
        <tr>
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Query Refused SP <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s</td>
        </tr>
        <tr>
          <td align="right" width="50%">Sort
            <select name="searchmodel" class="select-style1" onchange="javascript:searchRing()">
              <option value="ringid">Ringtone code</option>
              <option value="ringlabel">Ringtone name</option>
              <%if("1".equals(issupportmultipleprice)){%>
              <option value="ringfee2">Daily Price</option><%}%>
              <option value="ringfee"><%if("1".equals(issupportmultipleprice)){%>Monthly<%}%> Price</option>

              <option value="uploadtime">Upload Date</option>
            </select>
          </td>

        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td width="100%" valign="top">
      <table border="0" cellspacing="1" cellpadding="1" width="100%" class="table-style2">
        <tr  class="tr-ring">
          <td width="10%" height="24" align="center"><span title="Ringtone Code">Code</span></td>
          <td width="18%" height="24" align="center"><span title="Ringtone name">Name</span></td>
          <%if("1".equals(issupportmultipleprice)){%>
          <td width="10%" height="24" align="center"><span title="Ringtone Daily Price(<%=majorcurrency%>)">Daily Price(<%=majorcurrency%>)</span></td><%} %>
          <td width="10%" height="24" align="center"><span title="Ringtone <%if("1".equals(issupportmultipleprice)){%>Monthly<%} %> Price(<%=majorcurrency%>)"><%if("1".equals(issupportmultipleprice)){%>Monthly <%} %>Price(<%=majorcurrency%>)</span></td>

          <td width="14%" height="24" align="center"><span title="Uploading Date">Upload Date</span></td>
          <td width="25%" height="24" align="center"><span title="The reason of refusal">Reason for Refusal</span></td>
        </tr>
<%
        if(vet.size()>0){
		int count = vet.size() == 0 ? 15 : 0;
        for (int i = thepage * 15; i < thepage * 15 + 15 && i < vet.size(); i++) {
            hash = (Hashtable)vet.get(i);
            count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "#f5fbff" : "" %>">
          <td><%= (String)hash.get("ringid") %></td>
          <td><%= (String)hash.get("ringlabel") %></td>
          <%if("1".equals(issupportmultipleprice)){%>
          <td ><%= displayFee((String)hash.get("ringfee2")) %></td><%}%>
          <td ><%= displayFee((String)hash.get("ringfee")) %></td>
          <td ><%= (String)hash.get("uploadtime") %></td>
          <td ><%= (String)hash.get("refusecomment") %></td>
        </tr>
<%
        }
%>
      </table>
    </td>
  </tr>
<%
        if (vet.size() > 15) {
%>
  <tr>
    <td width="50%" valign="middle" align="right">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2" width="100%">
        <tr align="right">
          <td width="74%">&nbsp;<%= vet.size() %>&nbsp;entries in &nbsp;<%= vet.size()%15==0?vet.size()/15:vet.size()/15+1 %>&nbsp;pages&nbsp;&nbsp;You are now on Page &nbsp;<%= thepage + 1 %>&nbsp;</td>
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
		}else{
%>
<tr>
	<td width="50%" align="center" colspan="7">
	No Ringtone Data!
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
        sysInfo.add(sysTime + operName + ",Exception occurred in querying failed SP ring back tones!");//ÉóºËÎ´¹ýÁåÒô²éÑ¯¹ý³Ì³öÏÖÒì³£
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(",Exception occurred in querying failed SP ring back tones!");//ÉóºËÎ´¹ýÁåÒô¹ý³Ì³öÏÖÒì³£
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spUncheckRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.QryXbase" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>



<%@ include file="../pubfun/JavaFun.jsp" %>
<script src="../pubfun/JsFun.js"></script>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
      String issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice","0");
	  String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

	String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
	int largessflag = 0;
	if(disLargess.equals("1"))
		largessflag = 1;
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String spIndex = (String)session.getAttribute("SPINDEX");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String colorName = (String)session.getAttribute("COLORNAME")==null?"":(String)session.getAttribute("COLORNAME");
    String xbaseenable = CrbtUtil.getConfig("xbaseenable","0");
    String isSmartPriceFlag = CrbtUtil.getConfig("isSmartPriceFlag","0");
	
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
       else if (purviewList.get("9-2") == null) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
       if(flag){
          String allIndex = "-1";
          String sortBy = "buytimes";
          int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
          ArrayList vet = new ArrayList();
          Hashtable hash = new Hashtable();
          String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();


          if(op.equals("search")){
              allIndex = request.getParameter("index") == null ? "" : (String)request.getParameter("index");
              sortBy = request.getParameter("searchmodel") == null ? "buytimes" : (String)request.getParameter("searchmodel");
          }
          hash.put("searchvalue",spIndex);
          hash.put("searchkey","sp");
          hash.put("sortby",sortBy);
          if(xbaseenable.equals("1")){
          QryXbase qryRing = new QryXbase();
          vet = qryRing.searchRing(hash);
          } else{
             ColorRing colorring  =  new ColorRing();
             vet = colorring.searchRing(hash);
          }

        int pages = vet.size()/15;
        if(vet.size()%15>0)
            pages = pages + 1;
%>


<html>
<head>
<link href="../manager/style.css" type="text/css" rel="stylesheet">
<title>Ring back tone rank</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="initform(document.forms[0])">

<script language="javascript">

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


   function tryListen(ringID,ringName,ringAuthor,mediatype) {
     var tryURL = '../manager/tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
     if(trim(mediatype)=='1'){
       preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
     }else if(trim(mediatype)=='2'){
       preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
     }else if(trim(mediatype)=='4'){
       tryURL = '../manager/tryView.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
       preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
     }

   }

   function ringInfo (ringid) {
      infoWin = window.open('ringInfo.jsp?ringid=' + ringid,'infoWin','width=400, height=380');
   }

function ringInfoAlt (ringid, buytimes,largesstimes) {
					//  document.URL ='ringInfo.jsp?ringid=' + ringid + '&libid=' + libid;
				 var url ='ringInfoAlt.jsp?ringid=' + ringid + '&ringtype=1&fromCCS=true'+ '&buytimes=' + buytimes + '&largesstimes=' + largesstimes;
                    window.showModalDialog(url,window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-500)/2)+";dialogTop:"+((screen.height-500)/2)+";dialogHeight:500px;dialogWidth:500px");
	}

   function goPage(){
  var fm = document.inputForm;
  var pages = parseInt(fm.pages.value);
  var thispage = parseInt(fm.page.value);
  var thepage =parseInt(trim(fm.gopage.value));

  if(thepage==''){
    alert("Please specify the value of the page to go to!")
    fm.gopage.focus();
    return;
  }
  if(!checkstring('0123456789',thepage)){
    alert("he value of the page to go to can only be a digital number!")
    fm.gopage.focus();
    return;
  }
  if(thepage<=0 || thepage>pages ){
    alert("Incorrect range of page value,"+"(page 1~page "+pages+")!")
    fm.gopage.focus();
    return;
  }
  thepage = thepage -1;
  if(thepage==thispage){
    alert("This page has been displayed currently. Please re-specify a page!")
    fm.gopage.focus();
    return;
  }
  toPage(thepage);
}


</script>
<form name="inputForm" method="post" action="spRingList.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="sortby" value="<%= sortBy %>">
<script language="JavaScript">
	if(parent.frames.length>0){
	var hei;
	hei = 500;
	parent.document.all.main.style.height= hei;
		}
</script>
<table width="521" cellspacing="0" cellpadding="0" border="0" class="table-style2" height=hei align="center">

  <tr>
    <td width="100%" >
      <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="100%" align="left">
        <tr>
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">SP <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> sort</td>
        </tr>
          <tr>
          <td align="right">Sort
            <select name="searchmodel" class="select-style1" onchange="javascript:searchRing()">
              <option value="ringid">Ringtone code</option>
              <option value="ringlabel">Ringtone name</option>
              <option value="singgername"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
              <%if("1".equals(issupportmultipleprice)){%>
              <option value="ringfee2">Daily Price</option><%} %>
              <option value="ringfee"><%if("1".equals(issupportmultipleprice)){%>Monthly<%} %> Price</option>
              <option value="buytimes">Number of orders</option>
            <% if(largessflag!=1){%>
              <option value="largesstimes">Number of Gifts</option>
            <%}%>
              <option value="uploadtime">Time to lib.</option>
            </select>
          </td>

        </tr>
      </table>
    </td>
  </tr>
  <tr >
    <td width="100%" align="left">
      <table border="0" cellspacing="1" align="left" cellpadding="1" width="100%" class="table-style2">
        <tr class="tr-ringList">
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone code">Code</span></font></div>
                  </td>
                  <td height="30">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone name">Name</span></font></div>
                  </td>
                  <td height="30" >
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone Singer"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></span></font></div>
                  </td>
                   <%if("1".equals(issupportmultipleprice)){%>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone Daily Price(<%=majorcurrency%>)">Daily Price(<%=majorcurrency%>)</span></font></div>
                  </td>
                  <%} if ("0".equals(isSmartPriceFlag)) { %>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone  <%if("1".equals(issupportmultipleprice)){%>Monthly <%} %>Price(<%=majorcurrency%>)"> <%if("1".equals(issupportmultipleprice)){%>Monthly <%} %>Price(<%=majorcurrency%>)</span></font></div>
                  </td>
                <%}%>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Number of orders">Orders</span></font></div>
                  </td>
        <% if(largessflag!=1){%>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Number of gifts">Gift</span></font></div>
                  </td>
       <%}%>
				  <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Listen the ringtone">Listen</span></font></div>
                </td>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Ringtone Information">Info</span></font></div>
                </td>
              </tr>
<%
        int size = vet.size();
        if(size==0){
%>
	<tr><td colspan="8" align="center">No Data!</td></tr>
<%
        }else{
        HashMap map = null;
        int count = vet.size() == 0 ? 15 : 0;
        for (int i = thepage * 15; i < thepage * 15 + 15 && i < vet.size(); i++) {
            map = (HashMap)vet.get(i);
            count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "#f5fbff" : "" %>">
          <td><%= (String)map.get("ringid") %></td>
          <td><%= displayRingName((String)map.get("ringlabel")) %></td>
          <td><%= displayRingAuthor((String)map.get("ringauthor")) %></td>
          <%if("1".equals(issupportmultipleprice)){%>
          <td align="center"><%= displayFee((String)map.get("ringfee2")) %></td>
         <%} if ("0".equals(isSmartPriceFlag)) { %>
          <td align="center"><%= displayFee((String)map.get("ringfee")) %></td>
          <%}%>
          <td align="center"><%= (String)map.get("buytimes") %></td>
       <% if(largessflag!=1){%>
          <td align="center"><%= (String)map.get("largesstimes") %></td>
       <% }%>

        <td height="20">
          <div align="center">
             <font class="font-ring">
              <%
                  String strPhoto="../image/play.gif";
                  String strMediatype=(String)map.get("mediatype");
                  if("2".equals(strMediatype))
                  {
                    strPhoto="../image/play1.gif";
                  }
                  else if("4".equals(strMediatype))
                  {
                    strPhoto="../image/play2.gif";
                  }
                  else
                  {
                    strPhoto="../image/play.gif";
                  }
              %>
            <img src="<%= strPhoto %>"  height='15'  width='15' alt="Preview" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)map.get("ringid") %>','<%= (String)map.get("ringlabel") %>','<%= (String)map.get("ringauthor") %>','<%= (String)map.get("mediatype") %>')">
            </font>
           </div>
        </td>
	<% if ("1".equals(isSmartPriceFlag)) { %>
	    <td height="20" align="center"><img src="../image/info.gif"  height='15'  width='15' alt="Ringtone Information" onMouseOver="this.style.cursor='hand'" onClick="javascript:ringInfoAlt('<%= (String)map.get("ringid") %>','<%= (String)map.get("buytimes") %>','<%= (String)map.get("largesstimes") %>')">
        </td>
		  <%}else{%>
          <td align="center"><img src="../image/info.gif" alt="Details" width="15" height="15" onclick="javascript:ringInfo('<%= (String)map.get("ringid") %>')" onmouseover="this.style.cursor='hand'"></td>
         <%}%>
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
    <td width="95%">
      <table border="0" cellspacing="1" cellpadding="1" align="left" class="table-style2">
        <tr>
  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              &nbsp;<%= vet.size() %>&nbsp;entries in &nbsp;<%= vet.size()%15==0?vet.size()/15:vet.size()/15+1%>&nbsp;pages&nbsp;You are now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" width="45" height="19" onclick="javascript:toPage(0)" onmouseover="this.style.cursor='hand'"></td>
          <td><img src="../button/prepage.gif" width="45" height="19"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif" width="45" height="19"<%= thepage * 15 + 15 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" width="45" height="19" onclick="javascript:toPage(<%= (vet.size() - 1) / 15 %>)" onmouseover="this.style.cursor='hand'"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >Page&nbsp;</td>
             <td> <input style=text value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../button/go.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:goPage()"  ></td>
            </tr>
            </table>
          </td>
       </tr>
      </table>
    </td>
  </tr>
<%
        }
        }
%>
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
        sysInfo.add(sysTime + operName + ",Exception occurred in querying the ring back tone rank!");//铃音排行榜查询过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Exception occurred in querying the ring back tone rank!");//铃音排行榜查询过程出现异常
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spRingList.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title><%= colorName %> System</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="loadpage(document.forms[0])" >
<%
	 String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 int ratio = Integer.parseInt(currencyratio);


    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
    String giftbag   = CrbtUtil.getConfig("giftname","giftbag");

    try {
            if (operID != null && purviewList.get("4-25") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword you input have exceeded the limit,please re-enter!");
        String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
        String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
        String musictype = request.getParameter("musictype") == null ? "" : (String)request.getParameter("musictype");
        String errortype = request.getParameter("errortype") == null ? "" : (String)request.getParameter("errortype");

        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        ArrayList vet = new ArrayList();

        HashMap hash = new HashMap();
        if(searchkey.equals("sp"))
            hash.put("searchvalue",spindex);
        else
            hash.put("searchvalue",searchvalue);
        hash.put("searchkey",searchkey);
        hash.put("musictype",musictype);
        hash.put("spPage",spindex);
        hash.put("errortype",errortype);
        ColorRing  colorring = new ColorRing();
        vet = colorring.searchMusic(hash);

        int pages = vet.size()/25;
        if(vet.size()%25>0)
          pages = pages + 1;

        manSysPara syspara = new manSysPara();
        ArrayList spInfo = new ArrayList();
        spInfo = syspara.getSPInfo();
        HashMap map = new HashMap();
%>
<script language="javascript">
   var datasource;
   function loadpage(pform){
      var sTmp = "<%=  searchkey  %>";
      if(sTmp=='sp'){
         document.all('id_spshow').style.display= 'block';
         var value  = <%=  spindex  %>;
         document.forms[0].spindex.value = value;
      }
     else
        document.all('id_keyshow').style.display= 'block';
   }

  function modeChange(){
      if(document.forms[0].searchkey.value=='sp'){
         document.all('id_keyshow').style.display= 'none';
         document.all('id_spshow').style.display= 'block';
      }
      else{
         document.all('id_keyshow').style.display= 'block';
         document.all('id_spshow').style.display= 'none';
      }
   }

   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }

   function searchRing (sortby) {
      fm = document.inputForm;
      if (sortby.length > 0)
         fm.sortby.value = sortby;
//      if (trim(fm.searchvalue.value) == '') {
//         alert('请输入查询条件!');
//         fm.searchvalue.focus();
//         return;
//      }
      if (trim(fm.searchvalue.value) != '') {
          if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringgroup'){
             alert("Ringgroup code can only be a digital number!");
              fm.searchvalue.focus();
              return;
          }
          if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
              //alert('请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!');
              alert("Please input the right upload time in the ****.**.** format,and the upload time cannot be later than current time!");
              fm.searchvalue.focus();
              return;
          }
      }
      fm.page.value = 0;
      fm.submit();
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
      if(thepage==thispage){
         alert("This page has been displayed currently. Please re-specify a page!")
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
</script>
<script language="JavaScript">
	var hei=600;
	if(parent.frames.length>0){

<%
	if(vet==null || vet.size()<15 || vet.size()==15){
%>
	hei = 600;
<%
	}else if(vet.size()>15 && vet.size()<25){
%>
	hei = 600 + (<%= vet.size()%>-15)*20;

<%
	}else{
%>
	hei = 900;

<%
}
%>
	parent.document.all.main.style.height=hei;
    }

</script>
<form name="inputForm" method="post" action="qryMusic.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
<tr>
          <td height="26" colspan="2" align="center" class="text-title"  background="image/n-9.gif">Query SP RingGroup</td>
        </tr>
<tr>
    <td width="100%">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
		  <td>
            Select type
            <select size="1" name="searchkey" class="select-style1"  onchange="modeChange();" >
              <option value="ringgroup">ringgroup code</option>
              <option value="grouplabel">ringgroup name</option>
              <option value="sp">ringgroup provider</option>
              <option value="uploadtime">Upload time</option>
            </select>
          </td>
          <td id="id_keyshow" style="display:none" >Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="20" class="input-style7" >
          </td>
          <td id="id_spshow" style="display:none">
	    ringgroup provider
	    <select name="spindex" class="input-style1"  >
             <option value=0 > All ringgroup provider</option>
	     <%
                String tmpp=" ";
                 for (int i = 0; i < spInfo.size(); i++) {
                     map = (HashMap)spInfo.get(i);
                     if(spindex.trim().equalsIgnoreCase((String)map.get("spindex") ))
                       tmpp=" selected ";
                     out.println("<option value="+(String)map.get("spindex") +tmpp+">" + (String)map.get("spname") + "</option>");
                 }
         %>
	     </select>
	     </td>
             </tr>
             <tr>
             <td>Ringgroup type
               <select name="musictype">
               <option value="" selected>All type</option>
               <option value="1" <%=musictype.equals("1")?"selected":""%> ><%=musicbox%></option>
               <option value="2" <%=musictype.equals("2")?"selected":""%> ><%=giftbag%></option>
               </select>
          </td>
                    <td>State type
           <select name="errortype">
             <option value="" selected>All type</option>
             <option value="1" <%=errortype.equals("1")?"selected":""%> >Current month number exception</option>
             <option value="2" <%=errortype.equals("2")?"selected":""%> >Current month not refresh</option>
           </select>
          </td>
          <td><img src="../button/search.gif" alt="Search <%=musicbox%>" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
        </tr>
        <tr>
          <td colspan="4">
              &nbsp;
          </td>
        </tr>
      </table>
    </td>
  </tr>
<script language="javascript">
   if ('<%= searchkey %>' != '-1')
      document.inputForm.searchkey.value = '<%= searchkey %>';
</script>
  <tr>
    <td width="100%" align="center">
      <table width="99%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style2">
         <tr class="tr-ring">
                <td height="30" width="60">
                    <div align="center"><span title="Ringgroup code">Code</span></div>
                  </td>
                  <td height="30" width="120">
                    <div align="center"><span title="Ringgroup name">Name</span></div>
                  </td>
                  <td height="30" width="60" >
                    <div align="center"><span title="Ringgroup Provider">Provider</span></div>
                  </td>
                  <td height="30" width="60">
                    <div align="center"><span title="Ringgroup Price(<%=minorcurrency%>)">Price</span></div>
                  </td>
                  <td height="30" width="60">
                    <div align="center"><span title="Total Ringtone number">Total</span></div>
                  </td>
                  <td height="30" width="60">
                    <div align="center"><span title="Current ringtone number">Current</span></div>
                  </td>
              </tr>

<%
        int count = vet.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;

%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">

        <td height="20"><%= (String)hash.get("ringgroup") %></td>
        <td height="20"><%= (String)hash.get("grouplabel") %></td>
        <td height="20"><%= displaySpName((String)hash.get("spname")) %></td>
        <td height="20"><%= displayRingAuthor((String)hash.get("ringfee")) %></td>
        <td height="20"><%= displayRingAuthor((String)hash.get("ringcnt")) %></td>
        <td height="20"><%= displayRingAuthor((String)hash.get("curcnt")) %></td>
        </tr>
<%
         }
        if (vet.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;&nbsp;You are now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
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
%>


</table>
</form>
<%
        }
        else {
          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    parent.document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no access to this function!");//Sorry,you have no access to this function!
              </script>
              <%
              }
         }
    }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + "Exception occourred in the ringgroup query!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Error occourred in the ringgroup query!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="qryMusic.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

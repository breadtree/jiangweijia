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
<%    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
     //add by gequanmin 2005-07-05
    //String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
String userday = CrbtUtil.getConfig("uservalidday","0");
String isAdRing = CrbtUtil.getConfig("isshowad","0");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title><%= colorName %> System</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<base target="_self">
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

	  String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

    try {
            if (true) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword you input exceeds the limit,please re-enter!");//您输入的关键字长度超出限制,请重新输入!
//        String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
        String sortby =  "" ;
        //String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
        //String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
        String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        ArrayList vet = new ArrayList();
        Hashtable hash1 = new Hashtable();
        HashMap hash = new HashMap();

        hash1.put("searchvalue",searchvalue);
        hash1.put("searchkey",searchkey);
        hash1.put("sortby",sortby);
       // hash1.put("libid",libid );
        ColorRing  colorring = new ColorRing();
        vet = colorring.searchGreetingToneToManager(hash1);

        int pages = vet.size()/25;
        if(vet.size()%25>0)
          pages = pages + 1;

%>
<script language="javascript">

   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }

   function tryListen (ringID,ringName,ringAuthor) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }
 function checkvalidate(str){
   var currentDate = new Date();
	  str  = trim(str);
      if (str.length == 0)
         return true;
      if(str.length!=10)
        return false;
	  var month = (parseInt(currentDate.getMonth())+1).toString();
	  if(month.length==1)
	  	month = '0'+month;
		var day = currentDate.getDate().toString();
		if(day.length==1)
		day = '0'+day;
      var nowDate = currentDate.getYear() + month + day;
	  var get1Date = str.substring(0,4) + str.substring(5,7) + str.substring(8,10);
	  if (get1Date - nowDate < 0){

	  return false;
	  }
	  return true;
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
          if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
              alert('Ringtone code can only be a digital number!');//Ringtone code仅能为数字!
              fm.searchvalue.focus();
              return;
          }
          if(trim(fm.searchkey.value)=='validityTime' && (!checkDate2(fm.searchvalue.value)|| !checkvalidate(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
             // alert('请按照****.**.**的格式输入正确的入库时间!并且该时间不能早于当前时间!');
              alert("Please input the validity time in the ****.**.** format,and the validity time cannot be earlier than current time!");
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
   function editRing (ringid,libid) {
//       var libid = document.inputForm.ringlib.value;
     var result =  window.showModalDialog('greetingToneInfo.jsp?libid='+libid+'&ringid=' + ringid,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:410px");
     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
   }
   function delRing (ringid,libid,ringlabel) {
//       var libid = document.inputForm.ringlib.value;
     var result =  window.showModalDialog('delRing.jsp?libid='+libid+'&ringid=' + ringid+'&ringlabel='+ringlabel,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:410px");
     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
   }

 function confirm (ringid) {
     window.returnValue = ringid;
	 window.opener.document.inputForm.ringid.value = ringid;
     window.close();
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
<form name="inputForm" method="post" action="greetingToneSearch.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="ringlib" value="0">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr>
    <td width="100%">
    <table width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td width="10"></td>
		  <td>
            Select type
            <select size="1" name="searchkey" class="select-style5"  style="width:140px">
              <option value="ringid">Greeting Tone code</option>
              <option value="ringlabel">Greeting Tone name</option>

              <option value="validityTime">Validity time</option>
            </select>
          </td>
          <td id="id_keyshow" >Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" style="width:80px">
          </td>

          <td><img src="../button/search.gif" alt="Search Greeting Tone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
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
      <table width="98%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><span title="Greeting Tone code">Code</span></font></div>
                  </td>
                  <td height="30" width="120">
                    <div align="center"><font color="#FFFFFF"><span title="Greeting Tone name">Name</span></font></div>
                  </td>

                  <td height="30"  width="60"  >
                    <div align="center"><font color="#FFFFFF"><span title="Singer">Singer</span></font></div>
                  </td>

                  <td height="30" width="120" >
                    <div align="center"><font color="#FFFFFF"><span title="Copyright period of validity">Validity</span></font></div>
                  </td>

		 <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Confirm</font></div>
                 </td>
              </tr>

        <tr>

        <td height="20"><span style="color:blue">0</span></td>
        <td height="20"><span style="color:blue">Do not active Greeting Tone</span></td>

        <td height="20"></td>

        <td height="20"></td>

        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/icon_search.gif" alt="Confirm" onmouseover="this.style.cursor='hand'" onclick="javascript:confirm('0')"></font></div></td>

        </tr>

<%
        int count = vet.size() == 0 ? 25 : 0;
        String isadflag = "";
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
        if("1".equals((String)hash.get("isadflag"))){
              isadflag = "Yes";
            }else{
              isadflag = "No";
            }
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">

        <td height="20"><%= (String)hash.get("ringid") %></td>
        <td height="20"><%= displayRingName((String)hash.get("ringlabel")) %></td>

        <td height="20"><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>

        <td height="20"><%= (String)hash.get("validtime") %></td>

        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/icon_search.gif" alt="Confirm" onmouseover="this.style.cursor='hand'" onclick="javascript:confirm('<%= (String)hash.get("ringid") %>')"></font></div></td>

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
          <td>&nbsp;Total:<%= vet.size() %>,&nbsp&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;page(s).&nbsp;&nbsp;Now on Page &nbsp;<%= thepage + 1 %>&nbsp;</td>
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
                   alert( "Sorry,you have no access to this function!");
              </script>
              <%
              }
         }
    }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + "Exception occourred in the management of Greeting Tone!");// 系统铃音管理过程出现异常!
        sysInfo.add(sysTime + e.toString());
       // vet.add("系统铃音管理过程出现错误!");
        vet.add("Error occourred in the management of Greeting Tone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="greetingToneSearch.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.*" %>
<%@page import="zte.zxyw50.util.JCalendar"%>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
int isfarsicalendar = zte.zxyw50.util.CrbtUtil.getConfig("isfarsicalendar", 0);
JCalendar cal = new JCalendar();
public String jcalendar(String str){
	if(isfarsicalendar == 1){
		str = cal.gregorianToPersian(str); 
	}	
	return str;
}
%>
<%
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    // added to show multiple prices
    int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String isSmartPriceFlag = CrbtUtil.getConfig("isSmartPriceFlag","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","Ringtone producer");
    ringsourcename=transferString(ringsourcename);
    //add end
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
	 String userday = CrbtUtil.getConfig("uservalidday","0");
	 String isAdRing = CrbtUtil.getConfig("isshowad","0");

	  String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

int ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia",0);
int isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage",0);
int imageup = zte.zxyw50.util.CrbtUtil.getConfig("imageup",0);

String audioring = zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio");
String videoring = zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video");
String photoring = zte.zxyw50.util.CrbtUtil.getConfig("photoring","Photo");
String ringablealias1 = CrbtUtil.getConfig("ringablealias1","0");
String ringablealias2 = CrbtUtil.getConfig("ringablealias2","0");

// add for starhub
String ring_name = CrbtUtil.getConfig("ringName","name");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title><%= colorName %>&nbsp;System</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="loadpage(document.forms[0])" >
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    try {
            if (operID != null && purviewList.get("2-3") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();
		zxyw50.Purview purview = new zxyw50.Purview();
    	Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword length you entered has exceeded the limit. Please re-enter!");//您输入的关键字长度超出限制,请重新输入!
//        String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
        String sortby =  "" ;
        String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
        String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
        String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
        String mediatype = request.getParameter("mediatype") == null ? "" : (String)request.getParameter("mediatype");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        ArrayList vet = new ArrayList();
        Hashtable hash1 = new Hashtable();
        HashMap hash = new HashMap();
        if(searchkey.equals("sp"))
            hash1.put("searchvalue",spindex);
        else
            hash1.put("searchvalue",searchvalue);
        hash1.put("searchkey",searchkey);
        hash1.put("sortby",sortby);
        hash1.put("libid",libid );
        hash1.put("mediatype",mediatype );
        ColorRing  colorring = new ColorRing();
        vet = colorring.searchRingToManager(hash1);

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

  function ringInfo (ringid, buytimes,largesstimes) {
					//  document.URL ='ringInfo.jsp?ringid=' + ringid + '&libid=' + libid;
	var url ='ringInfo1.jsp?ringid=' + ringid + '&ringtype=1&fromCCS=true'+ '&buytimes=' + buytimes + '&largesstimes=' + largesstimes;
     window.showModalDialog(url,window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-500)/2)+";dialogTop:"+((screen.height-500)/2)+";dialogHeight:500px;dialogWidth:500px");
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

 function searchCatalog(){
     var dlgLeft = event.screenX;
     var dlgTop = event.screenY;
     var result =  window.showModalDialog("treeDlg.html",window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+dlgLeft+";dialogTop:"+dlgTop+";dialogHeight:250px;dialogWidth:215px");
//     alert(result);
     if(result){
         var name = getRingLibName(result);
//         alert("qw");
         document.inputForm.ringlib.value=result;
         //     alert(name);
         document.inputForm.ringcatalog.value=name;
         searchRing('');
     }
 }

 function getRingLibName(id){
     for(var i = 0;i<datasource.length;i++){
        var row =  datasource[i];
        if(row[0] == id)
           return row[2];
     }
     return "All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> categories";//全部铃音类别
 }
   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }
<%--
   function tryListen (ringID,ringName,ringAuthor) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }
--%>
   function tryListen(ringID,ringName,ringAuthor,mediatype) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
      if(trim(mediatype)=='1'){
               preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = 'tryView.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
   }

   function searchRing (sortby) {
      fm = document.inputForm;
      if (sortby.length > 0)
         fm.sortby.value = sortby;
//      if (trim(fm.searchvalue.value) == '') {
//         alert('Please input the query condition!');
//         fm.searchvalue.focus();
//         return;
//      }
      if (trim(fm.searchvalue.value) != '') {
          if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
              alert('A <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code can only be a digital number!');//Ringtone code仅能为数字
              fm.searchvalue.focus();
              return;
          }
          if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
              alert('Please enter the correct ****.**.** format time when it was added to the database! And this time cannot be later than the current time!');//请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!
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
         alert("Please specify the value of the page to go to!")//Please specify the value of the page to go to!
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!")//The value of the page to go to can only be a digital number
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!")//alert("转到的页码值范围不正确  页）!
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("This page has been displayed currently. Please re-specify a page!")//This page has been displayed currently. Please re-specify a page!
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
   function editRing (ringid,libid) {
//       var libid = document.inputForm.ringlib.value;
//由于存储过程参数的变化，libid存放的实际上是ringlibcode
     var result = ""; 
	 <% if ( ringablealias1.equalsIgnoreCase("1") || ringablealias2.equalsIgnoreCase("1") || sysfunction.get("2-66-0")== null ) { %>
		result =  window.showModalDialog('ringInfo.jsp?libid='+libid+'&ringid=' + ringid,window,"scroll:auto;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-450)/2)+";dialogHeight:510px;dialogWidth:410px");
	 <% } else { %>
		result = window.showModalDialog('ringInfo.jsp?libid='+libid+'&ringid=' + ringid,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:320px;dialogWidth:410px");
	 
	 <% } %>

     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
   }
   function delRing (ringid,libid,ringlabel) {
//       var libid = document.inputForm.ringlib.value;
//由于存储过程参数的变化，libid存放的实际上是ringlibcode
     var result =  window.showModalDialog('delRing.jsp?libid='+libid+'&ringid=' + ringid+'&ringlabel='+ringlabel,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:260px;dialogWidth:410px");
     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
     }
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
<form name="inputForm" method="post" action="ringEdit1.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="ringlib" value="0">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<%
        Vector ringLib = sysring.getRingLibraryInfo();
%>
  <script language="JavaScript">
  //modify by gequanmin 2005-07-05
   <%if("1".equals(usedefaultringlib)){%>
   datasource = new Array(<%=ringLib.size()+2%>);
   <%}else{%>
   datasource = new Array(<%=ringLib.size()+1%>);
  <%}%>
  var root = new Array("0","-1","All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> categories","0");
  datasource[0] = root;
   <%if("1".equals(usedefaultringlib)){%>
  root = new Array("503","0","Default <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library","1");
  datasource[1] = root;
  <%
   for(int i = 0;i<ringLib.size();i++){
      Hashtable table = (Hashtable)ringLib.get(i);%>
      var data = new Array('<%=(String)table.get("ringlibid")%>','<%=((String)table.get("parentidnex"))%>','<%=(String)table.get("ringliblabel")%>','<%=(String)table.get("isleaf")%>');
      datasource[<%=i+2%>] = data;
  <%}}else{
    for(int j= 0;j<ringLib.size();j++){
      Hashtable table = (Hashtable)ringLib.get(j);
    %>
     var data = new Array('<%=(String)table.get("ringlibid")%>','<%=((String)table.get("parentidnex"))%>','<%=(String)table.get("ringliblabel")%>','<%=(String)table.get("isleaf")%>');
      datasource[<%=j+1%>] = data;
    <%}}%>
  </script>
<tr>
    <td width="100%">
    <table  width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td width="10"></td>
		  <td>
             Select type
            <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();" style="width=100px" >
              <option value="ringid">Code</option>
              <option value="ringlabel"><%=ring_name%></option>
              <option value="singgername"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
              <option value="sp">Content Provider</option>
              <option value="uploadtime">Time into lib.</option>
              <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
               <option value="ringsource"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> producer</option>
               <%}%>
            </select>
          </td>
          <td id="id_keyshow" style="display:none" >Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
          </td>
          <td id="id_spshow" style="display:none">
	    <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider
	    <select name="spindex" class="input-style1"  >
             <option value=0 >All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> providers</option>
	     <%
                 for (int i = 0; i < spInfo.size(); i++) {
                     map = (HashMap)spInfo.get(i);
                     out.println("<option value="+(String)map.get("spindex") + ">" + (String)map.get("spname") + "</option>");
                 }
         %>
	     </select>
	     </td>
         <%if(isimage==1){%>
         <td>Mediatype
           <select name="mediatype" class="select-style5" >
             <option value="" <%="".equals(mediatype)?"selected":""%> >All Mediatype</option>
             <option value="1" <%="1".equals(mediatype)?"selected":""%> ><%=audioring%></option>
             <%if(ismultimedia == 1){%>
             <option value="2" <%="2".equals(mediatype)?"selected":""%> ><%=videoring%></option>
             <option value="3" <%="3".equals(mediatype)?"selected":""%> ><%=audioring%>/<%=videoring%></option>
             <%}%>
             <%if(imageup == 1){%>
             <option value="4" <%="4".equals(mediatype)?"selected":""%> ><%=photoring%></option>
             <%}%>
           </select>
         </td>
         <%} %>
          <td>Type of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>
              <input type="text" name="ringcatalog" readonly value="All ringtone categories" maxlength="20" class="input-style7"  onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()" >
          </td>
          <td><img src="../button/search.gif" alt="Find ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
        </tr>
        <tr>
          <td colspan="4">&nbsp;
              
          </td>
        </tr>
      </table>
    </td>
  </tr>
<script language="javascript">
   if ('<%= searchkey %>' != '-1')
      document.inputForm.searchkey.value = '<%= searchkey %>';
      document.inputForm.ringlib.value='<%=libid%>';
     var name = getRingLibName('<%=libid%>');
     document.inputForm.ringcatalog.value=name;

</script>
  <tr>
    <td width="100%" align="center">
      <table width="98%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone code">Code</span></font></div>
                  </td>
                  <td height="30" width="100">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone name"><%=ring_name%></span></font></div>
                  </td>

                   <td height="30" width="60" >
                     <div align="center"><font color="#FFFFFF"><span title="Ringtone provider">Content Provider</span></font></div>
                   </td>
                    <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
                    <td height="30" width="60" >
                      <div align="center"><font color="#FFFFFF"><%=ringsourcename%></font></div>
                    </td>
                    <%}%>
                  <td height="30"  width="60"  >
                    <div align="center"><font color="#FFFFFF"><span title="Singer"><%=CrbtUtil.getConfig("authorname","Singer")%></span></font></div>
                  </td>
                <%if(userday.equalsIgnoreCase("1"))
                    {%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF"><span title="Period of User Validity">User Validity</span></font></div>
                  </td>
                 <%}%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF"><span title="Period of Validity">Validity</span></font></div>
                  </td>
                  <%if("1".equals(isAdRing)){%>
                  <td height="30" width="50">
                    <div align="center"><font color="#FFFFFF"><span title="Ad ringtone or not">Ad ringtone</span></font></div>
                    </td>
                  <%}
                  if(issupportmultipleprice == 1){%>
		         <td height="30" width="45">
		         <div align="center"><font color="#FFFFFF"><span title="Price(<%= majorcurrency %>)"> Daily Price(<%= majorcurrency %>)</span></font></div>
		        </td>
		        <%}
		        if ("1".equals(isSmartPriceFlag)) { %>
				   <td height="30" width="45">
                      <div align="center"><font color="#FFFFFF"><span title="Ringtone Info.">Info.</span></font></div>
                  </td>
				  <% } else { %>
		  <td height="30" width="45">
		      <div align="center"><font color="#FFFFFF"><span title="Price(<%= majorcurrency %>)"><% if(issupportmultipleprice == 1){%>Monthly<%}%> Price(<%= majorcurrency %>)</span></font></div>
                  </td>
                 <% } %>
		  <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Listen the ringtone">Preview</span></font></div>
                </td>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Delete the ringtone ">Delete</span></font></div>
                </td>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="Edit the ringtone">Edit</span></font></div>
                </td>
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
        <td height="20"><%= displaySpName((String)hash.get("ringsource")) %></td>
        <!--取ringsource字段-->
        <%if(useringsource.equals("1")){%>
        <td height="20"><%=displaySpName((String)hash.get("producer"))%></td>
        <%}%>
        <td height="20"><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>
        <%if(userday.equalsIgnoreCase("1"))
         {%>
        <td height="20"  align="center"><%= (String)hash.get("uservalidday") %></td>
      <%}%>
        <td height="20"><%= jcalendar((String)hash.get("validtime")) %></td>
      <%if("1".equals(isAdRing)){%>
         <td height="20"><%= isadflag%></td>
         <%}
           if(issupportmultipleprice == 1 ){%>
		  <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee2")) %></div></td>
         <%}if ("1".equals(isSmartPriceFlag)) { %>
     <td height="20" align="center"><img src="../image/info.gif"  height='15'  width='15' alt="Ringtone Information" onMouseOver="this.style.cursor='hand'" onClick="javascript:ringInfo('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("buytimes") %>','<%= (String)hash.get("largesstimes") %>')">
		 </td>
   <% } else { %>
      <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
		  <% } %>
        <td height="20">
          <div align="center">
            <font class="font-ring">
              <%
                  String strPhoto="../image/play.gif";
                  String strMediatype=(String)hash.get("mediatype");
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
            <img src="<%= strPhoto %>"  height='15'  width='15' alt="Preview" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("ringauthor") %>','<%= (String)hash.get("mediatype") %>')">
            </font>
          </div>
        </td>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/delete.gif" height='15'  width='15' alt="Delete" onMouseOver="this.style.cursor='hand'" onclick="javascript:delRing('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlibcode") %>','<%= (String)hash.get("ringlabel") %>')"></font></div></td>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/edit.gif"   height='15'  width='15' alt="Edit" onmouseover="this.style.cursor='hand'" onclick="javascript:editRing('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlibcode") %>')"></font></div></td>
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
          <td>&nbsp;Total:<%= vet.size() %>,&nbsp;&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;page(s)&nbsp;&nbsp;Now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
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
                    alert( "Please log in first!");//Please log in to the system
                    parent.document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
              <%
              }
         }
    }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + " Exception occurred in managing system ringtones!");//系统铃音管理过程出现异常
        sysInfo.add(sysTime + e.toString());
        vet.add("Error occurred in managing system ringtones!");//系统铃音管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="ringEdit1.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

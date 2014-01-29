<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@page import="zte.zxyw50.util.JCalendar"%>
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
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
	String userday = CrbtUtil.getConfig("uservalidday","0");
	String isAdRing = CrbtUtil.getConfig("isshowad","0");
     // added for daily and monthly prices 
     int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
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
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Ringtone search</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="loadpage(document.forms[0])" >
  <base target="_self">
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    try {
            if (operID != null && purviewList.get("2-3") != null) {
        sysTime = SocketPortocol.getSysTime() + "--";
        manSysRing sysring = new manSysRing();
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        String oper = request.getParameter("oper") == null ? "" : transferString((String)request.getParameter("oper"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword you input exceed the limit,please re-enter!");//您输入的关键字长度超出限制,请重新输入!
//        String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
        String sortby =  "" ;
        String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
        String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
        String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
        String mediatype = request.getParameter("mediatype") == null ? "" : (String)request.getParameter("mediatype");
        String hidemediatype = request.getParameter("hidemediatype") == null ? "" : (String)request.getParameter("hidemediatype");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        if(hidemediatype.equals("1")){
          mediatype = "1";
        }
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
     return "All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category";
 }
   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }

  /* function tryListen (ringID,ringName,ringAuthor) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }*/
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

      if (trim(fm.searchvalue.value) != '') {
          if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
             // alert('Ringtone code仅能为数字!');
              alert("The ringtone code must be a digital number!");
              fm.searchvalue.focus();
              return;
          }
          if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
              //alert('请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!');
              alert("Please input the upload time in the ****.**.** format,and the upload time cannot be later than current time!");
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
         alert("Please specify the value of the page to go to!");
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!");
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!");
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("This page has been displayed currently. Please re-specify a page!");
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
   function confirm (ringlib,skey,svalue,index,ringindex) {
     var log = getRingLibName(ringlib);
     //window.returnValue = ringlib+'@'+skey+'@'+svalue+'@'+index+'@'+ringindex+'@'+log;
	  window.opener.document.inputForm.ringlib.value = ringlib;
	  window.opener.document.inputForm.searchkey.value = skey;
	  window.opener.document.inputForm.searchvalue.value = svalue;
	  window.opener.document.inputForm.spindex.value = index;
	  window.opener.document.inputForm.ringcatalog.value = log;
	  window.opener.parent.ringReplace.document.URL = "springReplace.jsp?ringlibid="+ringlib+"&ringindex="+ringindex;
     window.close();
   }

   function delRing (ringid,libid,ringlabel) {
     var result =  window.showModalDialog('delRing.jsp?libid='+libid+'&ringid=' + ringid+'&ringlabel='+ringlabel,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:410px");
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
<form name="inputForm" method="post" action="ringSearch1.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="ringlib" value="0">

<table width="551" border="0" cellspacing="0" cellpadding="0" align="center">

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
  var root = new Array("0","-1","All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category","0");
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
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td width="10"></td>
		  <td>
           Select type
            <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();" style="width:140px">
              <option value="ringid"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</option>
              <option value="ringlabel"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></option>
              <option value="singgername"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
              <option value="sp">Content provider</option>
              <option value="uploadtime">Upload time</option>
            </select>
          </td>
          <td id="id_keyshow" style="display:none" >Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
          </td>
          <td id="id_spshow" style="display:none">
	    Ringtone provider
	    <select name="spindex" class="input-style1"  >
             <option value=0 > All ringtone provider</option>
	     <%
                 for (int i = 0; i < spInfo.size(); i++) {
                     map = (HashMap)spInfo.get(i);
                     out.println("<option value="+(String)map.get("spindex") + ">" + (String)map.get("spname") + "</option>");
                 }
         %>
	     </select>
	     </td>
          <%if(isimage==1){%>
          <%if(!hidemediatype.equals("1")){%>
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
          <%}else{%>
          <input type="hidden" name="mediatype" value="1">
            <input type="hidden" name="hidemediatype" value="1">
              <% }%>
        <%}%>
          <td><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category
              <input type="text" name="ringcatalog" readonly="readonly" value="All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category" maxlength="20" class="input-style7" >
          </td>

          <td><img src="../button/search.gif" alt="Search ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
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
    <td width="100%" align="left">
      <table width="95%" border="0" cellspacing="1" cellpadding="1" align="left" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</font></div>
                  </td>
                  <td height="30" width="120">
                    <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></font></div>
                  </td>
                  <td height="30" width="80" >
                    <div align="center"><font color="#FFFFFF">Content provider</font></div>
                  </td>
                  <td height="30"  width="60"  >
                    <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","name")%></font></div>
                  </td>
                 <%if(userday.equalsIgnoreCase("1"))
                    {%>
                  <td height="30" width="60" >
                    <div align="center"><font color="#FFFFFF">Subscriber  expiration date</font></div>
                  </td>
   <%}%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF">Copyright expiration date</font></div>
                  </td>
                   <%if("1".equals(isAdRing)){%>
                  <td height="30" width="60">
                    <div align="center"><font color="#FFFFFF">Advertisement ringtone or not</font></div>
                    </td>
                  <%}%>
				  <%if(issupportmultipleprice == 1){%>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF">Daily Price(<%=majorcurrency%>)</font></div>
                  </td>
				  <%}%>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><%if(issupportmultipleprice == 1){%>Monthly<%}%> Price(<%=majorcurrency%>)</font></div>
                  </td>
               <!--  <%if(ismultimedia == 1 && !hidemediatype.equals("1")){%> -->
		       <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Try-listen</font></div>
                </td>
               <td height="30" width="20" style="display: none">
                  <div align="center"><font color="#FFFFFF">Mediatype</font></div>
                </td>
             <!--   <%}%>  --> 
                <%if(!oper.equals("manager") ){%>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">OK</font></div>
                </td>
               <%}%>
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
        <td height="20"><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>
          <%if(userday.equalsIgnoreCase("1"))
         {%>
        <td height="20"  align="center"><%= (String)hash.get("uservalidday") %></td>
<%}%>
          <td height="20"><%= (String)hash.get("validtime") %></td>
          <%if("1".equals(isAdRing)){%>
         <td height="20"><%= isadflag%></td>
         <%}%>
		 <%if(issupportmultipleprice == 1){%>
        <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee2")) %></div></td>
		  <%}%>
       <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
     <!--  <%if(ismultimedia == 1 && !hidemediatype.equals("1")){%> -->
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
           <%
             String mediashow = (String)hash.get("mediatype");
            if(mediashow.equals("1")){
              mediashow = zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio");
            }
            if(mediashow.equals("2")){
              mediashow = zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video");
            }
            if(mediashow.equals("4")){
              mediashow = zte.zxyw50.util.CrbtUtil.getConfig("photoring","Photo");
            }%>
                <td height="30" width="20" style="display: none">
                  <div align="center"><%= mediashow%></div>
                </td>
       <!-- <%}%> -->
           <%if(!oper.equals("manager") ){%>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../image/icon_search.gif" alt="Select this ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:confirm('<%= libid %>','<%=searchkey%>','<%=searchvalue%>','<%=spindex%>','<%=(String)hash.get("ringindex")%>')"></font></div></td>
            <%}%>

        </tr>
<%
         }
        if (vet.size() > 25) {
%>
       </table>
    </td>
  </tr>
  <tr>
    <td width="95%" align="left">
      <table border="0" cellspacing="1" cellpadding="1" align="left" class="table-style2">
        <tr>
          <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
        </tr>
        <tr>
          <td colspan="6" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
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
        sysInfo.add(sysTime + "It is abnormal during the tone management!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Error occurs during the system tone management!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="ringSearch1.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

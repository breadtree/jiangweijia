<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>
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
<%!
    private Vector getStrVector(String sStr){
	   Vector vet = new Vector();
       if (sStr == null)
           return vet;
       int index = 0;
       String  temp = sStr;
       String  temp1 ="";
       index = sStr.indexOf("|");
       while(index > 0) {
           temp1 = temp.substring(0,index);
           if(index < temp.length())
               temp = temp.substring(index+1);
           vet.addElement(temp1.substring(0,index));
           index = 0;
           if (temp.length() > 0)
               index  = temp.indexOf("|");
      }
      return vet;
  }

    public String showRingName(String str)
    {
    	String tmpStr = str;
    	if(tmpStr.length()>20)
    		tmpStr=tmpStr.substring(0,20)+" "+tmpStr.substring(20,tmpStr.length());
    	return tmpStr;
	}
%>



<%
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
	String userday = CrbtUtil.getConfig("uservalidday","0");
    String isSmartPriceFlag = CrbtUtil.getConfig("isSmartPriceFlag","0");

	  String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
    //法电彩像版本新增
    int ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia",0);
    int isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage",0);
    int imageup = zte.zxyw50.util.CrbtUtil.getConfig("imageup",0);
     int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);


    String audioring = zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio");
    String videoring = zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video");
    String photoring = zte.zxyw50.util.CrbtUtil.getConfig("photoring","Photo");
	String singer_name = CrbtUtil.getConfig("authorname", "Singer");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Manage ringtones</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="loadpage(document.forms[0])" >
<%
    String jName = (String)application.getAttribute("JNAME");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    try {
        if (operID != null && purviewList.get("2-8") != null) {
        sysTime = ColorRing.getSysTime() + "--";
        manSysRing sysring = new manSysRing();
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword's lenght which you entered is too long,please re-enter!");//您输入的关键字长度超出限制,请重新输入!
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

         if (op.equals("hide")) {
             Vector vetRing = new Vector();
             Vector sysRing = new Vector();
             Vector ringInfo = new Vector();
             int ringCount = 0;
             Hashtable result = new Hashtable();
             String ringid = request.getParameter("ringList") == null ? "" : transferString((String)request.getParameter("ringList")).trim();
             String ringname = request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel")).trim();
             vetRing = getStrVector(ringid);
             Vector vetName = getStrVector(ringname);
%>
<script language="javascript">
  function loadpage(pform){
  }
   function onBack() {
      var fm = document.inputForm;
      fm.op.value ="";
      fm.submit();
   }
</script>
<form name="inputForm" method="post" action="ringHide.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="spindex" value="<%= spindex %>">
<input type="hidden" name="searchvalue" value="<%= searchvalue %>">
<input type="hidden" name="searchkey" value="<%= searchkey %>">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="ringlib" value="<%= libid %>">
<table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
 <tr>
    <td><img src="../manager/image/004.gif" width="346" height="15"></td>
 </tr>
 <tr >
    <td background="../manager/image/006.gif">
    <table width="340" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
    <tr>
        <td colspan=2>&nbsp;</td>
    </tr>
   <tr>
   <td align="center" colspan=2>
      <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
      <tr class="tr-ringlist" >
        <td width="20%" align="center"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> No.</td>
        <td width="30%" align="center" ><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
        <td width="10%" align="center" >SCP</td>
        <td width="40%" align="center">Execution result</td>
      </tr>
      <%
         ArrayList  rList = new ArrayList();
         Hashtable stmp =  null;
         zxyw50.Purview purview = new zxyw50.Purview();
         for(int i=0;i<vetRing.size();i++){
           ringid = vetRing.get(i).toString();
           rList = sysring.hideRing(ringid,3);
           for(int j=0;j<rList.size();j++){
             String color = j == 0 ? "E6ECFF" :"#FFFFFF" ;
             stmp = (Hashtable)rList.get(j);
             out.print("<tr bgcolor='"+color+"'>");
             if(j==0){
               out.print("<td >"+ringid+"</td>");
               out.print("<td >"+showRingName(vetName.get(i).toString())+"</td>");
             }
             else{
                 out.print("<td >&nbsp;</td>");
                 out.print("<td >&nbsp;</td>");
             }
             out.print("<td >" + (String)stmp.get("scp")+ "</td>");
             String sRet = (String)stmp.get("result");
             if(sRet.equals("0"))
                out.print("<td >Success</td>");
             else
                out.print("<td >Failure ," + (String)stmp.get("reason") +"</td>");
             out.print("</tr>");
           }
           if(getResultFlag(rList)){
              HashMap map = new HashMap();
              map.put("OPERID",operID);
              map.put("OPERNAME",operName);
              map.put("OPERTYPE","207");
              map.put("RESULT","1");
              map.put("PARA1",ringid);
              map.put("PARA2",vetName.get(i).toString());
              map.put("PARA3","ip:"+request.getRemoteAddr());
              sysInfo.add(sysTime + operName + " hide ringtone " + ringid + " Success");
              purview.writeLog(map);
           } else
              sysInfo.add(sysTime + operName + " hide ringtone" + ringid + " Failure");

        }
      %>

      </table>
      <tr>
      <td align="center" colspan=2>
      	   <br/>
          <img src="../manager/button/back.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:onBack()">
      </td>
      </tr>
  </table>
  <tr>
     <td><img src="../manager/image/005.gif" width="346" height="15"></td>
  </tr>
 </table>
 </td>
 </tr>
 </table>
</form>
<%
            }
            else {

        hash1.put("searchkey",searchkey);
        hash1.put("sortby",sortby);
        hash1.put("libid",libid );
        hash1.put("mediatype",mediatype );
        ColorRing  colorring = new ColorRing();
        vet = colorring.searchRingToManager(hash1);

        manSysPara syspara = new manSysPara();
        ArrayList spInfo = new ArrayList();
        spInfo = syspara.getSPInfo();
        HashMap map = new HashMap();

        int rowcount = 0;
        int pages = vet.size()/25;
        if(pages > thepage)
            rowcount = 25;
        else
          rowcount = vet.size()- pages * 25 ;
       if(vet.size()==0) rowcount = 0;

       	if(vet.size()%25>0)
          pages = pages + 1;
%>
<script language="javascript">

   var v_ringid = new Array(<%= rowcount + "" %>);
   var v_ringlabel = new Array(<%= rowcount + "" %>);
<%
            for (int i =0 ; i <  rowcount; i++) {
                hash = (HashMap)vet.get( thepage * 25 +i );
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
<%
            }
%>



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
     return "Total ringtong's sort";
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
      if (trim(fm.searchvalue.value) != '') {
          if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
              alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code can only be a digital number!');
              fm.searchvalue.focus();
              return;
          }
          if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
              //请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!
              alert("Please enter the correct time format as '****.**.**', and the enter time can't later than current time!");
              fm.searchvalue.focus();
              return;
          }
      }
      fm.page.value = 0;
      fm.op.value = "";
      fm.submit();
   }


   function goPage(){
      var fm = document.inputForm;
      var pages = parseInt(fm.pages.value);
      var thispage = parseInt(fm.page.value);
      var thepage =parseInt(trim(fm.gopage.value));

      if(thepage==''){
         alert("Please enter the target page's number!");//Please specify the value of the page to go to!
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The number of target page can only be a digital number!");//The value of the page to go to can only be a digital number!
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("The number of target page isn't correct!");//Incorrect range of page value to go to,"+"(page 1~page "+pages+")!!
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("Now page is your wanted page,please enter another number of target page!");//This page has been displayed currently. Please re-specify a page!
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
    function oncheckbox(sender,ringid,ringlabel){
       var fm = document.inputForm;
       var ringList = fm.ringList.value;
       var ringLabel = fm.ringLabel.value;
       var ringValue = "";
       var ringname = "";
       if(sender.checked){
           fm.ringList.value = ringList + ringid  + "|";
           fm.ringLabel.value = ringLabel + ringlabel  + " |";
           return;
       }
       var idd = ringList.indexOf("|");
       var idd1= ringLabel.indexOf("|");
	   while( idd > 0){
	      if(ringList.substring(0,idd)==ringid){
	         ringValue = ringValue + ringList.substring(idd+1);
	         ringname = ringname + ringLabel.substring(idd1 + 1);
	         break;
	      }
	      ringValue = ringValue +  ringList.substring(0,idd) + '|';
	      ringname = ringname +  ringLabel.substring(0,idd1) + '|';
	      ringList = ringList.substring(idd + 1);
	      ringLabel = ringLabel.substring(idd1 + 1);
	      idd =-1;
	      idd1 =-1;
	      if(ringList.length>1){
	         idd  = ringList.indexOf("|");
	         idd1 = ringLabel.indexOf("|");
	      }
	   }
	   fm.ringList.value = ringValue;
	   fm.ringLabel.value = ringname;
           fm.selectall.checked = false;
	   return;
   }

   function onSelectAll(){
      var fm = document.inputForm;
      var ringlist = "";
      var ringlabel = "";
      if(fm.selectall.checked){
         for(var i=0;i<v_ringid.length; i++){
            eval('document.inputForm.crbt'+v_ringid[i]).checked = true;
            ringlist = ringlist +v_ringid[i] + '|';
            ringlabel = ringlabel +v_ringlabel[i] + '|';
         }
      }
      else {
          for(var i=0;i<v_ringid.length; i++)
            eval('document.inputForm.crbt'+v_ringid[i]).checked = false;
      }
      fm.ringList.value = ringlist;
      fm.ringLabel.value = ringlabel;
      return;
   }

   function onHide() {
      var fm = document.inputForm;
      if(fm.ringList.value ==''){
          alert('Select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be hidden!');//选择您要隐藏的铃音
          return;
      }
      fm.op.value = 'hide';
      fm.submit();
   }

   function ringInfo (ringid, buytimes,largesstimes) {
					//  document.URL ='ringInfo.jsp?ringid=' + ringid + '&libid=' + libid;
				 var url ='ringInfo1.jsp?ringid=' + ringid + '&ringtype=1&fromCCS=true'+ '&buytimes=' + buytimes + '&largesstimes=' + largesstimes;
                    window.showModalDialog(url,window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-500)/2)+";dialogTop:"+((screen.height-500)/2)+";dialogHeight:500px;dialogWidth:500px");
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
<form name="inputForm" method="post" action="ringHide.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="ringList" value="" >
<input type="hidden" name="ringLabel" value="">
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
  var root = new Array("0","-1","Total <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>'s sort","0");
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
  <tr >
       <td height="26"  align="center" class="text-title"  background="image/n-9.gif">Hide <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
</tr>
<tr>
    <td width="100%">
    <table  width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td width="10"></td>
		  <td>
             Select type
            <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();"  style="width:120px">
              <option value="ringid"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</option>
              <option value="ringlabel"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></option>
              <option value="singgername"><%=singer_name%></option>
              <option value="sp">Content Provider</option>
              <option value="uploadtime">Time into Lib.</option>
            </select>
          </td>
          <td id="id_keyshow" style="display:none" >Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style2" style="width:80px" >
          </td>
          <td id="id_spshow" style="display:none">
	    Content Provider
	    <select name="spindex" class="input-style1"  >
             <option value=0 > All provider</option>
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
          <td><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> sort
              <input type="text" name="ringcatalog" readonly value="All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> sort" maxlength="20" class="input-style7"  onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()" >
          </td>
          <td><img src="../button/search.gif" alt="search ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
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
                <td height="30" width="30">
                  <div align="center"><font color="#FFFFFF"><span title="Hidden flag">Flag</span></font></div>
                </td>
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone code">Code</span></font></div>
                  </td>
                  <td height="30" width="120">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone name"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringName","Name")%></span></font></div>
                  </td>
                  <td height="30" width="80" >
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone provider">Content Provider</span></font></div>
                  </td>
                  <td height="30"  width="60"  >
                    <div align="center"><font color="#FFFFFF"><%=singer_name%></font></div>
                  </td>
                  <%if(userday.equalsIgnoreCase("1"))
                    {%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF">Validity</font></div>
                  </td>
                 <%}%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF"><span title="Period of copyright validity">Copyright validity</span></font></div>
                  </td>
                  <%if(issupportmultipleprice == 1){%>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone Price(<%=majorcurrency%>)">Daily Price(<%=majorcurrency%>)</span></font></div>
                  </td>
                  <%}if ("1".equals(isSmartPriceFlag)) { %>
				  <td height="30" width="20">
                      <div align="center"><font color="#FFFFFF"><span title="Ringtone Info.">Info.</span></font></div>
                  </td>
			   <% } else { %>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone Price(<%=majorcurrency%>)"> <%if(issupportmultipleprice == 1){%>Monthly <%}%>Price(<%=majorcurrency%>)</span></font></div>
                  </td>
                   <% }%>
		  <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Listen</font></div>
                </td>
              </tr>

<%
        int count = vet.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
            String sRing =  (String)hash.get("ringid");
            String sRingName = (String)hash.get("ringlabel");

%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td align="center"> <input type='checkbox'  name='<%= "crbt"+(String)hash.get("ringid") %>'  onclick='<%= "oncheckbox(this,\""+ sRing + "\",\""+ sRingName + "\")" %>'> </td>
        <td height="20"><%= (String)hash.get("ringid") %></td>
        <td height="20"><%= displayRingName((String)hash.get("ringlabel")) %></td>
        <td height="20"><%= displaySpName((String)hash.get("ringsource")) %></td>
        <td height="20"><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>
             <%if(userday.equalsIgnoreCase("1"))
         {%>
        <td height="20"  align="center"><%= (String)hash.get("uservalidday") %></td>
          <%}%>
       <td height="20"><%= jcalendar((String)hash.get("validtime")) %></td>
        <%if(issupportmultipleprice == 1){%>
       <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee2")) %></div></td> 
          <%}if ("1".equals(isSmartPriceFlag)) { %>
	   <td  height="20" align="center"> <div align="center"><img src="../image/info.gif"  height='15'  width='15' alt="Ringtone Information" onMouseOver="this.style.cursor='hand'" onClick="javascript:ringInfo('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("buytimes") %>','<%= (String)hash.get("largesstimes") %>')"></div>
	   </td>
	 <% } else { %>
      <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
     <% } %>
        <td height="20">
          <div align="center">
            <font class="font-ring"">
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
            <img src="<%= strPhoto %>"  height='15'  width='15' alt="Pre-listen this ringtone" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("ringauthor") %>','<%= (String)hash.get("mediatype") %>')">
            </font>
          </div>
        </td>
        </tr>
<%
         }
         if(vet.size()==0 && !op.equals("")){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="8" height="20" >No ring satisfy the condition,please re-enter the search condition!</td>
         </tr>
        <%
        }
         else if(vet.size()>0){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="9"  height="40"  width="100%">
              <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2" width="98%">
              <tr>
               &nbsp; &nbsp; &nbsp; &nbsp; <input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select all&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <img src="button/hide.gif" alt="Hidden the system ringtone" onmouseover="this.style.cursor='hand'" onClick="javascript:onHide()" > </td>
              </tr>
              </table>
           </td>
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
          <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
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
                    alert( "Please log in first!");
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
        sysInfo.add(sysTime + " Exception occurred in hiddening system ringtones!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Error occurred in hiddening system ringtones!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp" >
<input type="hidden" name="historyURL" value="ringHide.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

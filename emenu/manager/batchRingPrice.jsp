
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.group.util.DateUtil" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.group.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    
    int isCombodia =  zte.zxyw50.util.CrbtUtil.getConfig("isCombodia",0);
    if(isCombodia ==1){
%>
<%}%>
<%!
   private Vector getVector(String sStr){
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
   private boolean isThisRing(Vector vet, String ringid){
      boolean flag = false;
      if(vet == null || ringid == null)
         return flag;
      int j = vet.size();
      for(int i=0;i<j; i++)
         if(ringid.equals((String)vet.get(i))){
            flag = true;
            break;
         }
     return flag;
   }
%>


<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Order ringtones</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="loadpage(document.forms[0])" >
<%
String userday = CrbtUtil.getConfig("uservalidday","0");
String openprint = CrbtUtil.getConfig("openprint","0");
 //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
	String isSmartPriceFlag = CrbtUtil.getConfig("isSmartPriceFlag","0");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String xbaseenable = application.getAttribute("xbaseenable")==null? "" : ((String)application.getAttribute("xbaseenable")).trim();

    int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
	 String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");

	 String usecalling =zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0");
	 int ratio = Integer.parseInt(currencyratio);

         int isallow = 0;
         String forbidstarttime = CrbtUtil.getConfig("forbidstarttime","9");
         String forbidendtime = CrbtUtil.getConfig("forbidendtime","19");
         java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("HH");
         String sDatetime = format.format(new java.util.Date());
         if( (Integer.parseInt(sDatetime) >= Integer.parseInt(forbidstarttime))
                && (Integer.parseInt(sDatetime) < Integer.parseInt(forbidendtime)) ){
         }
         else
         {
         isallow = 1;
         }
		 String singer_name = CrbtUtil.getConfig("authorname", "Singer");
		 String ring_display = CrbtUtil.getConfig("ringdisplay","ringtone");
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
      if (operID != null && purviewList.get("2-33") != null) {
        manSysRing sysring = new manSysRing();
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword length you entered has exceeded the limit. Please re-enter!");//您输入的关键字长度超出限制,请重新输入!
        String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
        String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
        String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
        String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        String dailyprice = request.getParameter("dailyprice") == null ? "0" : ((String)request.getParameter("dailyprice")).trim();
         String monthlyprice = request.getParameter("monthlyprice") == null ? "0" : ((String)request.getParameter("monthlyprice")).trim();
        String sRingList = request.getParameter("ringList") == null ? "" : ((String)request.getParameter("ringList")).trim();
        Vector vetRing = getVector(sRingList);
        String sRingLabel =  request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel"));
        ArrayList vet = new ArrayList();
        Hashtable hash1 = new Hashtable();
        HashMap hash = new HashMap();
        if(!op.equals("")){
          if(searchkey.equals("sp"))
              hash1.put("searchvalue",spindex);
          else
              hash1.put("searchvalue",searchvalue);
          hash1.put("searchkey",searchkey);
          hash1.put("sortby",sortby);
          hash1.put("libid",libid );
         if(isCombodia ==1){
          hash1.put("mediatype","1" );
          }
          else{
          hash1.put("mediatype","3" );
          }
          ColorRing  colorring = new ColorRing();
          vet = colorring.searchRingToManager(hash1);
        }

        int rowcount = 0;
        int pages = vet.size()/15;
        if(pages > thepage)
            rowcount = 15;
        else
          rowcount = vet.size()- pages * 15 ;
       if(vet.size()==0) rowcount = 0;

       	if(vet.size()%15>0)
          pages = pages + 1;


        String userNumber = (String)session.getAttribute("USERNUMBER");
        manSysPara syspara = new manSysPara();
        ArrayList spInfo = new ArrayList();
        spInfo = syspara.getSPInfo();
        HashMap map = new HashMap();
%>
<script language="javascript">
   var v_ringid = new Array(<%= rowcount + "" %>);
   var v_ringlabel = new Array(<%= rowcount + "" %>);
<%
   for (int i =0 ; i <  rowcount; i++)
  {
   hash = (HashMap)vet.get( thepage * 15 +i );
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
<%
  }
%>
   function loadpage(pform){
      var sTmp = "<%=  searchkey  %>";
      if(sTmp=='sp'){
         document.all('id_spshow').style.display= 'block';
         var value  = <%=  spindex  %>;
         document.forms[0].spindex.value = value;
      }
     else
        document.all('id_keyshow').style.display= 'block';

     document.inputForm.ringlib.value='<%=libid%>';
     var name = getRingLibName('<%=libid%>');
     document.inputForm.ringcatalog.value=name;
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
      document.forms[0].searchvalue.value = '';
      document.forms[0].spindex.value = '0';
   }

   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.op.value = 'search';
      document.inputForm.submit();
   }

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
    if(fm.searchkey.value!='sp'){
       if ((trim(fm.searchvalue.value) == '') && trim(fm.searchkey.value)=='ringfee'){
          alert("Please enter query criteria!");//请输入查询条件
          fm.searchvalue.focus();
          return;
       }
       if (!CheckInputStr(fm.searchvalue,'query criteria')){
         fm.searchvalue.focus();
         return  ;
       }
	  if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
	  	alert("A <%=ring_display%> code can only be a digital number!");//Ringtone code仅能为数字
		  fm.searchvalue.focus();
		  return;
	  }
	  if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringfee'){
	  	alert("The unit of a <%=ring_display%> price is <%=minorcurrency%>. Only numeric values are accepted. Please re-enter!");//铃音价格单位为分,只能为数字,请重新输入!
		  fm.searchvalue.focus();
		  return;
	  }
	  if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
	  	alert("Please enter the correct ****.**.** format time when it was added to the database! And this time cannot be later than the current time!");//请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!
		  fm.searchvalue.focus();
		  return
	  }
	  if(trim(fm.searchkey.value)=='uploadtime1' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
	  	alert("Please enter the correct ****.**.** format time before it was added to the database! And this time cannot be later than the current time!");//请按照****.**.**的格式输入查询入库日期之前铃音的时间!并且该时间不能大于当前时间!
		  fm.searchvalue.focus();
		  return
	  }
	  if(trim(fm.searchkey.value)=='uploadtime2' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
	  	alert("Please enter the correct ****.**.** format time after it was added to the database! And this time cannot be later than the current time!");//请按照****.**.**的格式输入查询入库日期之后铃音的时间!并且该时间不能大于当前时间!
		  fm.searchvalue.focus();
		  return
	  }
	}

      fm.page.value = 0;
      fm.ringList.value  = '';
      fm.ringLabel.value = '';
      fm.op.value = 'search';
      fm.submit();
   }


   function goPage(){
      var fm = document.inputForm;
      var pages = parseInt(fm.pages.value);
      var thispage = parseInt(fm.page.value);
      var thepage =trim(fm.gopage.value);

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
      thepage =parseInt(trim(fm.gopage.value));
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
    //       window.status = fm.ringList.value;
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

  function  onBatchModify(){
     fm = document.inputForm;
       
     var isallow = '<%=isallow%>';
     if(isallow != '1'){
         alert("The operation's forbidden time is between  "+ <%=forbidstarttime%>+ " and "+<%=forbidendtime%>+" o'clock!" );
         return;
     }
     
     
     var monthlyprice = trim(fm.monthlyprice.value);
     if (!checkstring('0123456789',monthlyprice)) {
         alert("price can only be a digital number!");
         fm.monthlyprice.focus();
         return;
     }
	 if(monthlyprice == ''){
		 fm.monthlyprice.value=0;

	 }
	 var conf = 'List of <%=ring_display%>s to be modified to price '+ monthlyprice + ':\n\n';
     if(<%=issupportmultipleprice%> == 1){
      var  dailyprice = trim(fm.dailyprice.value);
         if (!checkstring('0123456789',dailyprice)) {
         alert("price can only be a digital number!");
         fm.dailyprice.focus();
         return;
     }
	 if(dailyprice == ''){
		 fm.dailyprice.value=0;

	 }
	 dailyprice=parseInt(fm.dailyprice.value,10);
	 monthlyprice = parseInt(fm.monthlyprice.value,10);
     if(monthlyprice <= dailyprice){
	 alert("Monthly price should be greater than Daily price");
	 fm.dailyprice.focus();
         return;
     }
	 conf = 'List of <%=ring_display%>s to be modified to monthly price '+ monthlyprice + '  and daily price '+ dailyprice + ':\n\n';
	 }
  
     var ringList=trim(fm.ringList.value);
     if(ringList==''){
        alert("Please select the <%=ring_display%>s to be modified!" );//请选择用户  要订购的铃音
        return;
     }
     var ringArray =  ringList.split('|');
     var labelArray = fm.ringLabel.value.split('|');
     for(var i=0; i<ringArray.length-1; i++ )
       conf = conf + eval(i+1) + '. ' + ringArray[i] + '--' + labelArray[i] + '\n';

     conf = conf + " \n" + eval(ringArray.length-1) + " <%=ring_display%>(s) in total,Are you sure?";//共 首,您确认吗？
     if(!confirm(conf))
        return;
	 <%-- if(fm.setr.checked)
		 fm.setring.value='1'; --%>
//	 fm.setring.value = fm.setr.value;
     fm.op.value = 'addring';
     fm.action = 'batchRingPriceMod.jsp';
     fm.submit();
  }

  function searchCatalog(){
     var dlgLeft = event.screenX;
     var dlgTop = event.screenY;
     var result =  window.showModalDialog("treeDlg.html",window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-200)/2)+";dialogTop:"+((screen.height-200)/2)+";dialogHeight:250px;dialogWidth:215px");
     if(result){
         var name = getRingLibName(result);
         document.inputForm.ringlib.value=result;
         document.inputForm.ringcatalog.value=name;
     }
 }

 function getRingLibName(id){
     for(var i = 0;i<datasource.length;i++){
        var row =  datasource[i];
        if(row[0] == id)
           return row[2];
     }
     return "All sort of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>";
 }

   function ringInfo (ringid, buytimes,largesstimes) {
					//  document.URL ='ringInfo.jsp?ringid=' + ringid + '&libid=' + libid;
				 var url ='ringInfo1.jsp?ringid=' + ringid + '&ringtype=1&fromCCS=true'+ '&buytimes=' + buytimes + '&largesstimes=' + largesstimes;
                    window.showModalDialog(url,window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-500)/2)+";dialogTop:"+((screen.height-500)/2)+";dialogHeight:500px;dialogWidth:500px");
	}


</script>
<script language="JavaScript">
	var hei=550;
	if(parent.frames.length>0){

<%
	if(vet==null || vet.size()<15 || vet.size()==15){
%>
	hei = 550;
<%
	}else if(vet.size()>15 && vet.size()<15){
%>
	hei = 550 + (<%= vet.size()%>-10)*20;

<%
	}else{
%>
	hei = 850;

<%
}
%>
	parent.document.all.main.style.height=hei;
	}

</script>


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
  var root = new Array("0","-1","All sort of <%=ring_display%>","0");
  datasource[0] = root;
   <%if("1".equals(usedefaultringlib)){%>
  root = new Array("503","0","Default <%=ring_display%> library","1");
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


<form name="inputForm" method="post" action="batchRingPrice.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="ringList" value="<%= sRingList %>" >
<input type="hidden" name="ringLabel" value="<%= sRingLabel %>">
<input type="hidden" name="ringlib" value="0">
<input type="hidden" name="op" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
<tr >
    <td height="26"  align="center" class="text-title" background="image/n-9.gif">Batch Modify Ring Price</td>
</tr>
<tr>
    <td  width="100%" align="center">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="98%" align="center">
    <tr>
	  <td width="45%" >
            Select type
            <select size="1" name="searchkey" onchange="modeChange();" class="input-style7" style="width:150" >
              <option value="ringlabel"><%=ring_display+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></option>
              <option value="ringid"><%=ring_display%> code</option>
              <option value="sp"><%=ring_display%> provider</option>
              <option value="singgername"><%=singer_name%></option>
              <option value="ringfee"><%=ring_display%> price</option>
              <option value="uploadtime">Time into Lib.</option>
              <option value="uploadtime1">Time into Lib. < </option>
              <option value="uploadtime2">Time into Lib. > </option>
            </select>
          </td>
          <td id="id_keyshow" style="display:none" >Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
          </td>
          <td id="id_spshow" style="display:none">
	       <%=ring_display%> provider
	      <select name="spindex" class="input-style1"  >
             <option value=0 selected > All <%=ring_display%> providers</option>
	       <%
                 for (int i = 0; i < spInfo.size(); i++) {
                     map = (HashMap)spInfo.get(i);
                     out.println("<option value="+(String)map.get("spindex") + ">" + (String)map.get("spname") + "</option>");
                 }
          %>
	     </select>
	     </td>
        </tr>
        <tr>
         <td><%=ring_display%> type
              <input type="text" name="ringcatalog" readonly value="All sort of <%=ring_display%>" maxlength="20" class="input-style7"  onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()" >
          </td>
          <td >Sort
            <select size="1" name="sortby" class="select-style1" onchange="javascript:document.inputForm.sortby.value = this.value">
              <option value="ringid"     ><%=ring_display%> Code</option>
              <option value="ringlabel"  ><%=ring_display+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></option>
              <option value="singgername"><%=singer_name%></option>
              <option value="ringsource" ><%=ring_display%> Provider</option>
              <option value="ringfee"    ><%=ring_display%> Price</option>
              <option value="buytimes"   >Number of user orders</option>
              <option value="largesstimes" >Number of as presents</option>
              <option value="uploadtime"   >Time into Lib.</option>
            </select>
           &nbsp;<img src="button/search.gif" alt="Find <%=ring_display%>" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
         </tr>
      </table>
   </td>
  </tr>
<script language="javascript">
   if ('<%= searchkey %>' != '-1')
      document.inputForm.searchkey.value = '<%= searchkey %>';
   if ('<%= sortby %>' != '')
      document.inputForm.sortby.value = '<%= sortby %>';
  <%
  if(openprint.equalsIgnoreCase("1")&&(vet!=null || vet.size() >0)){
         manPrint pt = new manPrint();
         pt.settableStyle("width='100%' align='center' border='0' cellspacing='0' cellpadding='0' class='../table-style2'");
         pt.setprintData(vet);
         session.setAttribute("filedkey","ringid");
         String fileds[] = new String[3];
         fileds[0] = "ringid";
         fileds[1] = "ringlabel";
         fileds[2] = "ringfee";
         session.setAttribute("fileds",fileds);
         session.setAttribute("printobj",pt);
   }%>
</script>
  <tr>
    <td width="100%" align="center">
      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="30">
                  <div align="center"><font color="#FFFFFF"><span title="Check and buy this ringtone for user">Select</span></font></div>
                </td>
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone code">Code</span></font></div>
                  </td>
                  <td height="30">
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone name"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></span></font></div>
                  </td>
                  <td height="30" >
                    <div align="center"><font color="#FFFFFF"><span title="Ringtone's singer"><%=singer_name%></span></font></div>
                  </td>
                  		 <% if ("1".equals(isSmartPriceFlag)) { %>
                  <td height="30" width="40">
                      <div align="center"><font color="#FFFFFF"><span title="Ringtone Info.">Info.</span></font></div>
                  </td>
		         <% } 
                  else 
                   {
                       if(issupportmultipleprice == 1)
                           {%>
				   <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Price(<%=majorcurrency%>)">Daily Price (<%=majorcurrency%>)</span></font></div>
                  </td>
                  <%}
                    else
                     {
                   %>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Price(<%=majorcurrency%>)"><%if(issupportmultipleprice == 1){%>Monthly<%}%> Price (<%=majorcurrency%>)</span></font></div>
                  </td>
<%
}
                  }
%>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF"><span title="Times of orders">Orders</span></font></div>
                  </td>
                         <%if(userday.equalsIgnoreCase("1"))
                    {%>
                  <td height="30" width="50">
                    <div align="center"><font color="#FFFFFF">Subscriber<br>validity(day)</font></div>
                  </td>
              <%}%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF"><span title="copyright validity">Copyright</span></font></div>
                  </td>
                <%if(isCombodia ==0){%>
       	            <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF"><span title="listen this ringtone">Listen</span></font></div>
                </td>
               <%}%>
              </tr>
<%
        int count = vet.size() == 0 ? 15 : 0;
        for (int i = thepage * 15; i < thepage * 15 + 15 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
            String sRing =  (String)hash.get("ringid");
            String sRingName = (String)hash.get("ringlabel");
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td align="center"> <input type='checkbox'  <%=  isThisRing(vetRing, sRing)?"checked":""  %>   name='<%= "crbt"+(String)hash.get("ringid") %>'  onclick='<%= "oncheckbox(this,\""+ sRing + "\",\""+ sRingName + "\")" %>'> </td>
        <td height="20"><%= (String)hash.get("ringid") %></td>
        <td height="20"><%= displayRingName((String)hash.get("ringlabel")) %></td>
        <td height="20"><%= displayRingAuthor((String)hash.get("ringauthor")) %></td>
 <% if ("1".equals(isSmartPriceFlag)) { %>
		 <td height="20" align="center"><img src="../image/info.gif"  height='15'  width='15' alt="Ringtone Information" onMouseOver="this.style.cursor='hand'" onClick="javascript:ringInfo('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("buytimes") %>','<%= (String)hash.get("largesstimes") %>')">
		  </td>
   <% } else { %>
         <%if(issupportmultipleprice == 1){%>
		 <td height="20" align="center">
         <div align="center"><%= displayFee((String)hash.get("ringfee2")) %></div></td>
		 <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
          <%}
         else
	     {
         %>
        <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
<%
}
        }
%>
        <td height="20" align="center">
          <div align="center"><%= (String)hash.get("buytimes") %></div></td>
                  <%if(userday.equalsIgnoreCase("1"))
                 {
                  long long1 = 0 ,long2 = 0 ;
                  String tmp1=hash.get("validtime")==null?"":(String)hash.get("validtime");
                  String tmp2=hash.get("uservalidday")==null?"0":(String)hash.get("uservalidday");
                 if(!tmp1.trim().equalsIgnoreCase("")&&!tmp1.trim().equalsIgnoreCase("null"))
                 long1 =  DateUtil.diffDate(DateUtil.toDate(tmp1),DateUtil.getCurrentDate());
                 if(!tmp2.trim().equalsIgnoreCase("")&&!tmp2.trim().equalsIgnoreCase("null"))
                 long2 = Long.parseLong(tmp2);
                 if(long1<long2)
                    long2 = long1;
                    %>
                <td height="20"  align="center"><%=long2+"" %></td>
             <%}%>
          <td height="20"><%= (String)hash.get("validtime") %></td>
 <%if(isCombodia ==0){%>         
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
         <%}%>
        </tr>
<%
         }
         if(vet.size()==0 && !op.equals("")){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="9" height="20" >No <%=ring_display%> found! Please re-enter your query conditions!</td>
         </tr>
        <%
        }
         else if(vet.size()>0){
         %>
                  <input type="hidden" name="setring" value="0">
		  <br>
		  <table align="left" class="table-style2" >
           <tr>
            <td>
            <input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select All
            </td>
			</tr>
            <%if(issupportmultipleprice == 1){%>			
			<tr>
			<td>
			Ring Daily Price (<%=minorcurrency%>)</td><td> <input type="text" name="dailyprice" value="" maxlength="9" >
			</td>
			</tr>
			<%}%>
			<tr>
			<td>
			Ring <%if(issupportmultipleprice == 1){%>Monthly  <%}%> Price (<%=minorcurrency%>)</td><td><input type="text" name="monthlyprice" value="" maxlength="9">
			</td> 
			<td>
           &nbsp;<img src="button/change.gif" alt="Buy the selected <%=ring_display%>(s) for user" onmouseover="this.style.cursor='hand'" onClick="javascript:onBatchModify()" > </td>
          </tr>
		  </table>
        <%
         }
%>
  </table>
  <%   if (vet.size() > 15) { %>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;Total:<%= vet.size() %>,&nbsp;&nbsp;<%= vet.size()%15==0?vet.size()/15:vet.size()/15+1%>&nbsp;page(s),&nbsp;&nbsp;Now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 15 + 15 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 15 %>)"></td>
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
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime +  "Errors occurred in batch modify ringtone price!");//铃音搜索过程出现异常
        sysInfo.add(sysTime + e.toString());
        vet.add("Errors occurred in batch modify ringtone price! ");//铃音搜索过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="batchRingPrice.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

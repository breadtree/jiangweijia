<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Transform personal ringtone to system ringtone</title>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" >
<%
	//String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

	String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");

	String userday = CrbtUtil.getConfig("uservalidday","0");
    String sysTime = "";
     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String xbaseenable = application.getAttribute("xbaseenable")==null? "" : ((String)application.getAttribute("xbaseenable")).trim();
    try {
      sysTime = SocketPortocol.getSysTime() + "--";
      if (operID != null && purviewList.get("13-8") != null) {
        manSysRing sysring = new manSysRing();
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        String scp = request.getParameter("scplist") == null ? "" : (String)request.getParameter("scplist");
        if(checkLen(searchvalue,40))
        	throw new Exception("The keyword you entered is too longer,please re-enter!");//您输入的关键字长度超出限制,请重新输入!
        String sortby = "uploadtime";
        String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        String phone = request.getParameter("phone") == null ? "" : ((String)request.getParameter("phone")).trim();
        ArrayList vet = new ArrayList();
        HashMap  hash1 = new HashMap();
        HashMap hash = new HashMap();
        if(!op.equals("")){
          hash1.put("scp",scp);
          hash1.put("searchvalue",searchvalue);
          hash1.put("searchkey",searchkey);
          hash1.put("sortby",sortby);
          vet = sysring.getPersonalRing(hash1);
        }
        int rowcount = 0;
        int pages = vet.size()/25;
        if(pages > thepage)
            rowcount = 25;
        else
          rowcount = vet.size()- pages * 25 ;
       if(vet.size()==0) rowcount = 0;
       if(vet.size()%25>0)
           pages = pages + 1;
        String userNumber = (String)session.getAttribute("USERNUMBER");
        HashMap map = new HashMap();

        String  optSCP ="";
        ArrayList scplist = sysring.getScpList();
        for (int i = 0; i < scplist.size(); i++) {
               if(i==0 && scp.equals(""))
                  scp = (String)scplist.get(i);
               if(scp.equals((String)scplist.get(i)))
                 optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " selected > " + (String)scplist.get(i)+ " </option>";
               else
                  optSCP = optSCP + "<option value=" + (String)scplist.get(i) + "  > " + (String)scplist.get(i)+ " </option>";
           }
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
   function modeChange(){
      document.forms[0].searchvalue.value = '';
      document.forms[0].searchvalue.focus();
   }

   function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.op.value = 'search';
      document.inputForm.submit();
   }

   function tryListen (ringID,ringName,ringAuthor) {
       var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor;
       preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }

   function searchRing (sortby) {
      fm = document.inputForm;
      if (sortby.length > 0)
         fm.sortby.value = sortby;

    if(trim(fm.searchvalue.value!='')){
      if (trim(fm.searchvalue.value) == '') {
         alert("Please enter the query condition!");//请输入查询条件!
         fm.searchvalue.focus();
         return;
      }
      if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
	  	alert("The ringtone code only can be a digital number!");//Ringtone code仅能为数字!
		  fm.searchvalue.focus();
		  return;
      }
       if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
	  	  alert('Please enter the correct ****.**.** format time when it was added to the database! And this time cannot be later than the current time!');//请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!
		  fm.searchvalue.focus();
		  return
	  }
	  if(trim(fm.searchkey.value)=='uploadtime1' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
	  	alert('Please enter the correct ****.**.** format time before it was added to the database! And this time cannot be later than the current time!');//请按照****.**.**的格式输入正确的入库之前的时间!并且该时间不能大于当前时间!
		  fm.searchvalue.focus();
		  return
	  }
	  if(trim(fm.searchkey.value)=='uploadtime2' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
	  	alert('Please enter the correct ****.**.** format time after it was added to the database! And this time cannot be later than the current time!');//请按照****.**.**的格式输入正确的入库之后的时间!并且该时间不能大于当前时间!
		  fm.searchvalue.focus();
		  return
	  }
	}

      fm.page.value = 0;
      fm.op.value = 'search';
      fm.submit();
   }
   function goPage(){
      var fm = document.inputForm;
      var pages = parseInt(fm.pages.value);
      var thispage = parseInt(fm.page.value);
      var thepage =parseInt(trim(fm.gopage.value));

      if(thepage==''){
         alert("Please specify the value of the page to go to!");//Please specify the value of the page to go to!
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!");//The value of the page to go to can only be a digital number
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!");//alert("转到的页码值范围不正确  页）!
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("This page has been displayed currently. Please re-specify a page!");//This page has been displayed currently. Please re-specify a page!
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
	   return;
   }

  function checkInfo(){
     var fm =  document.inputForm;
     var value = trim(fm.price.value);
     if(value == ''){
         alert("Please enter the ringtone's price for subscrbier order!");//请输入铃音价格,以便用户订购或赠送时收费!
          fm.price.focus();
          return false;
      }
      if(!checkstring('0123456789',value)){
          alert("The util of ringtone's price is <%=minorcurrency%>, and it only can be a digital number,Please re-enter! ");//铃音价格单位为分,只能是整型数字,请重新输入!
          fm.price.focus();
          return false;
      }
    <%//begin add 用户有效期
        if(userday.equalsIgnoreCase("1")){
          %>
          //begin add 用户有效期
          var tmp1 = trim(fm.uservalidday.value);
          if ( tmp1 == '') {
            alert('Please input ringtone validity of period!');//请输入铃音用户有效期
            fm.uservalidday.focus();
            return ;
          }
          if (!checkstring('0123456789',tmp1)) {
            alert('Ringtone subscriber validity of period can only be a digital number!');//铃音用户有效期只能为数字!
            fm.uservalidday.focus();
            return ;
          }
      //end
      <%}%>
     value = trim(fm.validate.value);
     if(value == ''){
          alert("Please enter the period of validity!");//请输入铃音有效期!
          fm.validate.focus();
          return false;
      }
       if(!checkDate2(value)){
          alert("The period of validity isn't correct, please re-enter!");//铃音有效期输入不正确,请重新输入
          fm.validate.focus();
          return false;
      }
      if(checktrue2(value)){
          alert("The period of validity can't latter than current time,please re-enter!");//铃音有效期不能低于当前时间,请重新输入
          fm.validate.focus();
          return false;
      }
      if(checktrueyear(value,'<%=expireTime%>')){
         alert("The period of validity can't larger than <%=expireTime%> ,please re-enter!");//铃音有效期不能大于....,请重新输入!
          fm.validate.focus();
          return ;
      }
      if(fm.ringlib.value ==''){
         alert("Please choose the sort of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>!");//请选择铃音分类!
         return false;
      }
      return true;
  }

  function  onCollection(){
     var fm = document.inputForm;
     var ringList = trim(fm.ringList.value);
     if(ringList==''){
        alert("Please select the personal ringtone which you want to transform it to system ringtone!");//请选择要转化为系统铃音的用户个人铃音!
        return;
     }
     if(!checkInfo())
        return;
     var ringArray =  ringList.split('|');
     var labelArray = fm.ringLabel.value.split('|');

     var conf = "The list of transform ringtone\n\n";//本次要转化为系统铃音的列表:
     for(var i=0; i<ringArray.length-1; i++ )
       conf = conf + eval(i+1) + '. ' + ringArray[i] + '--' + labelArray[i] + '\n';
     conf = conf + " \n" + eval(ringArray.length-1) + "enters in total,Are you confirm?";
     if(!confirm(conf))
        return;
     fm.action = 'ringUpdateEnd.jsp';
     fm.submit();
  }


  function searchCatalog(){
     var dlgLeft = event.screenX;
     var dlgTop = event.screenY;
     var result =  window.showModalDialog("treeDlg.html",window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+dlgLeft+";dialogTop:"+dlgTop+";dialogHeight:250px;dialogWidth:215px");
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
	hei = 600 + (<%= vet.size()%>-10)*20;

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
<form name="inputForm" method="post" action="ringUpdate.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="ringList" value="">
<input type="hidden" name="ringLabel" value="">
<input type="hidden" name="ringlib" value="">
<input type="hidden" name="op" value="">
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
  var root = new Array("0","-1","All sort of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>","0");
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

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2">
<tr >
    <td height="40"  align="center" class="text-title">Transform personal ringtone to system ringtone</td>
</tr>
<tr>
    <td  width="100%" align="center">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="98%" align="center">
    <tr>
      <td >SCP&nbsp;&nbsp;<br>
             <select name="scplist" size="1" class="select-style0" style="width:140px" >
              <% out.print(optSCP); %>
             </select>
      </td>
	  <td >
            &nbsp;&nbsp;&nbsp;Type of query <br>
            <select size="1" name="searchkey" class="select-style0" style="width:140px" onchange="modeChange();">
              <option value="ringlabel">Ringtone name</option>
              <option value="ringid">Ringtone code</option>
              <option value="singgername">Singer name</option>
              <option value="uploadtime">Time into Lib.</option>
              <option value="uploadtime1"> &lt;Time into Lib.</option>
              <option value="uploadtime2"> &gt;Time into Lib.</option>
            </select>
          </td>
          <td >&nbsp;&nbsp;&nbsp;Keyword<br>&nbsp;&nbsp;
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
          </td>
          <td><img src="button/search.gif" alt="Search ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
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
      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="table-style4">
         <tr class="tr-ringlist">
                <td height="30" width="30">
                  <div align="center"><font color="#FFFFFF">Transform flag</font></div>
                </td>
                <td height="30" width="80">
                    <div align="center"><font color="#FFFFFF">Ringtone code</font></div>
                  </td>
                  <td height="30" width="140" >
                    <div align="center"><font color="#FFFFFF">Ringtone name</font></div>
                  </td>
                  <td height="30"  width="80" >
                    <div align="center"><font color="#FFFFFF">Singer</font></div>
                  </td>
                  <td height="30" width="60">
                    <div align="center" ><font color="#FFFFFF">Upload time</font></div>
                  </td>
       	            <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Listen</font></div>
                </td>
              </tr>
<%
        int count = vet.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash = (HashMap)vet.get(i);
            count++;
%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td align="center"> <input type='checkbox'  name='<%= "crbt"+(String)hash.get("ringid") %>'  onclick="oncheckbox(this,'<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>')" > </td>
        <td height="20"><%= (String)hash.get("ringid") %></td>
        <td height="20"><%= displayRingName((String)hash.get("ringlabel")) %></td>
        <td height="20"><%= displayRingAuthor((String)hash.get("singgername")) %></td>
        <td height="20" align="center">
          <div align="center"><%= (String)hash.get("uploadtime") %></div></td>
        <td height="20">
          <div align="center"><font class="font-ring""><img src="../image/play.gif" alt="Try-listen this ringtone" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("singgername") %>')"></font></div></td>
        </tr>
<%
         }
         if(vet.size()==0 && !op.equals("")){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="8" height="20" >No ringtones match the conditions,please re-enter the query conditions!</td>
         </tr>
        <%
        }
         else if(vet.size()>0){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="6"  height="100"  width="100%">
              <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2" width="98%">
              <tr>
               <td colspan=2 height="40">&nbsp; <input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select All&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <font class="font">System ringtone property setting</font></td>
              </tr>
              <tr>
                  <td >  Ringtone price&nbsp; <input type="text" name="price" value="" maxlength="20" class="input-style7"> </td>
                  <td >  Period of validity&nbsp; <input type="text" name="validate" value="" maxlength="20" class="input-style7"> </td>
              </tr>
                      <%//begin add 用户有效期
        if(userday.equalsIgnoreCase("1")){
        %>
        <tr>
          <td > Sort of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>&nbsp; <input type="text" name="ringcatalog" onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()"  class="input-style7" readonly > </td>
          <td >Subscriber validity of period(day)&nbsp;&nbsp;<input type="text" name="uservalidday" value="0" maxlength="4" class="input-style7"></td>
        </tr>
        <tr>
          <td colspan="2" ><img src="button/update.gif" alt="Transform personal ringtone to system ringtone" onmouseover="this.style.cursor='hand'" onClick="javascript:onCollection()" > </td>
          </tr>
        <%}else{%>
        <tr>
          <td ><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category&nbsp; <input type="text" name="ringcatalog" onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()"  class="input-style7" readonly > </td>
            <td ><img src="button/update.gif" alt="Transform personal ringtone to system ringtone" onmouseover="this.style.cursor='hand'" onClick="javascript:onCollection()" > </td>
            </tr>
            <%}%>
              </table>
           </td>
         </tr>
        <%
         }
%>
  </table>
  <%   if (vet.size() > 25) { %>
  <tr>
    <td width="100%">
      <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
        <tr>
          <td>&nbsp;<%= vet.size() %>&nbsp;enters in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on Page&nbsp;<%= thepage + 1 %>&nbsp;</td>
          <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
          <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
          <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
          <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
        </tr>
        <tr>
          <td colspan="5" align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >page&nbsp;</td>
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
                    alert( "Please log in first!");
                    document.URL = 'enter.jsp';
              </script>
        <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "Sorry,you have no ringt to access this function!");
              </script>
            <%

        }
    }
  }
   catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime +  " Exception occurred in searching ringtone!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Errors occurred in searching ringtone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringUpdate.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

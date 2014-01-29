<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
        String useringsource=CrbtUtil.getConfig("useringsource","0");
        String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
        String searchvalue = "";
        String searchkey = "";
        String spindex = "0";
        String sortby =  "" ;

        manSysPara syspara = new manSysPara();
        manSysRing sysring = new manSysRing();
        ArrayList spInfo = new ArrayList();
        spInfo = syspara.getSPInfo();
        HashMap map = new HashMap();
%>
<html>
<head>
<title>Ringtone replacement</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<script src="../pubfun/JsFun.js"></script>
<script>
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
     return "All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category";//全部铃音类别
 }

 function searchRing (sortby) {
      fm = document.inputForm;
      if (sortby.length > 0)
         fm.sortby.value = sortby;

      if (trim(fm.searchvalue.value) != '') {
          if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
              alert('The ringtone code should be in the digit format only!');//Ringtone code仅能为数字!
              fm.searchvalue.focus();
              return;
          }
          if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
              alert('Please input the correct upload time in the format ****.**.**, and the time should not be later than current time!');//请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!
              fm.searchvalue.focus();
              return;
          }
      }

     var skey = fm.searchkey.value;
     var svalue = fm.searchvalue.value;
     var spindex = fm.spindex.value;
     var ringlib = fm.ringlib.value;
     var ringcatalog = fm.ringcatalog.value;

     if(ringlib==0){
       alert("Please select <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category!");//请选择铃音类别!
       return;
     }

	  var appendContent="ringSearch1.jsp?hidemediatype=1&searchkey="+skey+"&searchvalue="+svalue+"&spindex="+spindex+"&ringlib="+ringlib+"&ringcatalog="+ringcatalog;
	 var result =  window.open(appendContent,'mywin','left=20,top=20,width=600,height=700,toolbar=1,resizable=0,scrollbars=yes,location=1');

     /*var result =  window.showModalDialog('ringSearch1.jsp?hidemediatype=1&searchkey='+skey+'&searchvalue='+svalue+'&spindex='+spindex+'&ringlib='+ringlib+'&ringcatalog='+ringcatalog,
     window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       var str = trim(result);
       var str_arr = new Array();
       var key = new Array();
       var value = new Array();
       var index = new Array();
       var log = new Array();

       str_arr = str.split('@');

       fm.searchkey.value = str_arr[1];
       fm.searchvalue.value = str_arr[2];
       fm.spindex.value = str_arr[3];
       fm.ringlib.value = str_arr[0];
       fm.ringcatalog.value = str_arr[5];
       if(str_arr[1]=='sp') {
         document.all('id_keyshow').style.display= 'none';
         document.all('id_spshow').style.display= 'block';
       }
       parent.ringReplace.document.URL = "springReplace.jsp?ringlibid="+str_arr[0]+"&ringindex="+str_arr[4]+"&hidemediatype=1";
     }*/
     }
 </script>
<body background="background.gif" class="body-style1" onload="loadpage(document.forms[0])">
<form name="inputForm" method="post" action="">
<input type="hidden" name="ringlib" value="0">

<table  border="0" align="center" class="table-style2" height="100%" width="80%">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> replacement</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr valign="center">
    <td>
      <table  width="98%" border="0" cellspacing="1" cellpadding="1" class="table-style2">
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
  var root = new Array("0","-1","All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category","0");//全部铃音类别
  datasource[0] = root;
   <%if("1".equals(usedefaultringlib)){%>
  root = new Array("503","0","Default <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library","1");//默认铃音库
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
          <td width="10"></td>
		  <td>
            Select type
            <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();" style="width:120px">
              <option value="ringid"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</option>
              <option value="ringlabel"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></option>
              <option value="singgername"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
              <option value="sp"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider</option>
              <option value="uploadtime">Upload time</option>
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
             <option value=0 >All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider</option>
	     <%
                 for (int i = 0; i < spInfo.size(); i++) {
                     map = (HashMap)spInfo.get(i);
                     out.println("<option value="+(String)map.get("spindex") + ">" + (String)map.get("spname") + "</option>");
                 }
         %>
	     </select>
	     </td>
          <td><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category
              <input type="text" name="ringcatalog" readonly value="All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category" maxlength="20" class="input-style7"  onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()" >
          </td>
          <td><img src="../button/search.gif" alt="Search ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
        </tr>
        <tr>
          <td colspan="4">
              &nbsp;
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
</body>
</html>

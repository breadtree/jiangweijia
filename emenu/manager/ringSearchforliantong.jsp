<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String disLargess = (String)application.getAttribute("DISLARGESS")==null?"":(String)application.getAttribute("DISLARGESS");
    String sysTime = "";
    manSysPara syspara = new manSysPara();
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
    //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
	String userday = CrbtUtil.getConfig("uservalidday","0");
	String isAdRing = CrbtUtil.getConfig("isshowad","0");
	
	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	//String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
	
%>
<%!    private Vector StrToVector(String str){
	  int index = 0;
	  String  temp = str;
	  String  temp1 ="";
	  Vector ret = new Vector();
	  if (str.length() ==0)
	      return ret;
	  index = str.indexOf("|");
   	  while(index >= 0){
	      if(index==0)
	         temp1 = "&nbsp;";
	      else
	         temp1 = temp.substring(0,index);
	      ret.addElement(temp1);
		  if(index < temp.length())
		     temp = temp.substring(index+1);
		  else
		     break;
		  index = 0;
		  if (temp.length() > 0)
		     index  = temp.indexOf("|");
	  }
	  return ret;
  }

%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Search ringtone</title>
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
        ColorRing colorring=new ColorRing();
        ArrayList rList = new ArrayList();
        String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
        String oper = request.getParameter("oper") == null ? "" : transferString((String)request.getParameter("oper"));
        if(checkLen(searchvalue,40))
        	throw new Exception("The length of keywords you input exceeds the limit,please re-enter!");
//        String sortby = request.getParameter("sortby") == null ? "buytimes" : (String)request.getParameter("sortby");
        String sortby =  "" ;
        String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
        String spindex = request.getParameter("spindex") == null ? "0" : (String)request.getParameter("spindex");
        String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        ArrayList vet = new ArrayList();
        Hashtable hash1 = new Hashtable();
        HashMap hash = new HashMap();
        HashMap hashlog = new HashMap();
         HashMap mapnew= new HashMap();
         if (op.equals("add")) {
                 String sRingList = request.getParameter("ringlist") == null ? "" : ((String)request.getParameter("ringlist")).trim();
                 Vector vetRing = null;
                   vetRing = StrToVector(sRingList);
                   Hashtable result = new Hashtable();
                   String sNumber = "";
                   for(int i=0;i<vetRing.size()-1;i++){
                     sNumber = vetRing.get(i).toString();
                     System.out.println(sNumber);
                     int maxnumber=colorring.getmaxspecialorder();
                      mapnew.put("optype",1+"");
                      mapnew.put("ringid",sNumber);
                      mapnew.put("rsubindex",maxnumber+"");
                      mapnew.put("boardtype",4+"");
                      rList = sysring.setSpecialArea(mapnew);
               // 准备写操作员日志
               if(getResultFlag(rList)){
                 zxyw50.Purview purview = new zxyw50.Purview();
                 hashlog.put("OPERID",operID);
                 hashlog.put("OPERNAME",operName);
                 hashlog.put("OPERTYPE","210");
                 hashlog.put("RESULT","1");
                 hashlog.put("PARA1", sNumber);//ringid);
                 hashlog.put("PARA2", maxnumber+"");//rsubindex);
                 hashlog.put("PARA3", "4");
                 hashlog.put("PARA4","ip:"+request.getRemoteAddr());
                 hashlog.put("DESCRIPTION","Add special area tone in batch");
                 purview.writeLog(hashlog);
               }
                 if(rList.size()>0){
                session.setAttribute("rList",rList);
                %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="ringSearchforliantong.jsp">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
          <%
              }
             }
            }

        if(searchkey.equals("sp"))
            hash1.put("searchvalue",spindex);
        else
            hash1.put("searchvalue",searchvalue);
        hash1.put("searchkey",searchkey);
        hash1.put("sortby",sortby);
        hash1.put("libid",libid );
        vet = colorring.searchRingforSpecial(hash1);
        int pages = vet.size()/25;
        if(vet.size()%25>0)
          pages = pages + 1;

        ArrayList spInfo = new ArrayList();
        spInfo = syspara.getSPInfo();
        HashMap map = new HashMap();
%>

<script language="javascript">
   var v_ringindex = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (HashMap)vet.get(i);
%>
   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
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

  function onSelectAll(){
     var fm = document.inputForm;
     var ringlist = "";
     if(fm.selectall.checked){
       for (var i = '<%= thepage * 25%>'; i < '<%= thepage * 25 + 25%>' && i < v_ringindex.length; i++){
         eval('document.inputForm.crbt'+v_ringindex[i]).checked = true;
         ringlist = ringlist + v_ringindex[i] + '|';
       }
     }
     else {
       for (var i = '<%= thepage * 25%>'; i < '<%= thepage * 25 + 25%>' && i < v_ringindex.length; i++)
       eval('document.inputForm.crbt'+v_ringindex[i]).checked = false;
     }
     fm.ringlist.value = ringlist;
     return;
   }
 function oncheckbox(sender,ringindex){
     var fm = document.inputForm;
     var ringlist = fm.ringlist.value;
     var ringvalue = "";
     var numbervalue = "";
     if(sender.checked){
       fm.ringlist.value = ringlist + ringindex  + "|";
       return;
     }
     var idd = ringlist.indexOf("|");
     while( idd > 0){
       if(ringlist.substring(0,idd)==ringindex){
         ringvalue = ringvalue + ringlist.substring(idd+1);
         break;
       }
       ringvalue = ringvalue +  ringlist.substring(0,idd) + '|';
       ringlist = ringlist.substring(idd + 1);
       idd =-1;
       if(ringlist.length>1)
       idd  = ringlist.indexOf("|");
     }
     fm.ringlist.value = ringvalue;
     eval('document.inputForm.selectall').checked = false;
     return;
   }


 function searchCatalog(){
     var dlgLeft = event.screenX;
     var dlgTop = event.screenY;
     var result =  window.showModalDialog("treeDlg.html",window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+dlgLeft+";dialogTop:"+dlgTop+";dialogHeight:250px;dialogWidth:215px");
     if(result){
         var name = getRingLibName(result);
         document.inputForm.ringlib.value=result;
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
     return "All ringtone category";//全部铃音类别
 }
   function toPage (page) {
      document.inputForm.page.value = page;
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
      if (trim(fm.searchvalue.value) != '') {
          if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
             // alert('Ringtone code仅能为数字!');
              alert("Ringtone code can only be a digital number");
              fm.searchvalue.focus();
              return;
          }
          if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
             // alert('请按照****.**.**的格式输入正确的入库时间!并且该时间不能大于当前时间!');
              alert("Please input the correct upload time in the ****.**.** format,and the upload time cannot be later than current time!");
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

   function confirm () {

      var fm = document.inputForm;
      fm.op.value = 'add';
      if(fm.ringlist.value == '') {
         alert('Please specify the tone to be added to the special area!');
         return;
      }
      fm.submit();

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


<form name="inputForm" method="post" action="ringSearchforliantong.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="ringlist" value="">
<input type="hidden" name="op" value="">

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
  var root = new Array("0","-1","All ringtone category","0");
  datasource[0] = root;
   <%if("1".equals(usedefaultringlib)){%>
  root = new Array("503","0","Default ringtone library","1");
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
            <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();" >
              <option value="ringid">Ringtone code</option>
              <option value="ringlabel">Ringtone name</option>
              <option value="singgername">Singer</option>
              <option value="sp">Ringtone provider</option>
              <option value="uploadtime">Upload time</option>
            </select>
          </td>
          <td id="id_keyshow" style="display:none" >Keyword
          <input type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
          </td>
          <td id="id_spshow" style="display:none">
	    Ringtone provider
	    <select name="spindex" class="input-style1"  >
             <option value=0 >All ringtone provider </option>
	     <%
                 for (int i = 0; i < spInfo.size(); i++) {
                     map = (HashMap)spInfo.get(i);
                     out.println("<option value="+(String)map.get("spindex") + ">" + (String)map.get("spname") + "</option>");
                 }
         %>
	     </select>
	     </td>
          <td>Ringtone category
              <input type="text" name="ringcatalog" readonly value="All ringtone category" maxlength="20" class="input-style7"  onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()" >
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
              <%if(!oper.equals("manager") ){%>
                <td height="30" width="20">
                  <div align="center"><font color="#FFFFFF">Select</font></div>
                </td>
               <%}%>
                <td height="30" width="70">
                    <div align="center"><font color="#FFFFFF">Ringtone code</font></div>
                  </td>
                  <td height="30" width="120">
                    <div align="center"><font color="#FFFFFF">Ringtone name</font></div>
                  </td>
                  <td height="30" width="80" >
                    <div align="center"><font color="#FFFFFF">Provider</font></div>
                  </td>
                  <td height="30"  width="60"  >
                    <div align="center"><font color="#FFFFFF">Singer</font></div>
                  </td>
                 <%if(userday.equalsIgnoreCase("1"))
                    {%>
                  <td height="30" width="60" >
                    <div align="center"><font color="#FFFFFF">Subscriber validity period (Day)</font></div>
                  </td>
   <%}%>
                  <td height="30" width="50" >
                    <div align="center"><font color="#FFFFFF">Copyright validity period (Day)</font></div>
                  </td>
                   <%if("1".equals(isAdRing)){%>
                  <td height="30" width="60">
                    <div align="center"><font color="#FFFFFF">Advertisement ringtone or not</font></div>
                    </td>
                  <%}%>
                  <td height="30" width="40">
                    <div align="center"><font color="#FFFFFF">Price(<%=majorcurrency%>)</font></div>
                  </td>
		  <td height="30" width="20" style="display:none">
                  <div align="center"><font color="#FFFFFF">Try-listen</font></div>
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
             <%if(!oper.equals("manager") ){
          out.println("<td align=center> <input type='checkbox' name='crbt"+(String)hash.get("ringid")+"'  onclick=oncheckbox(this,'" +(String)hash.get("ringid")+ "') ></font></td>");
          }%>
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

       <td height="20" align="center">
          <div align="center"><%= displayFee((String)hash.get("ringfee")) %></div></td>
        <td height="20" style="display:none">
          <div align="center"><font class="font-ring""><img src="../image/play.gif" alt="Try to listen this ringtone" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringid") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("ringauthor") %>')"></font></div></td>

        </tr>

<%
         }
 %>
          <tr>
            <td></td>
              <td width="20%" align="center" >
                <input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select all
              </td>
               <td width="25%" align="center"><img src="../button/sure.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:confirm()"></td>
          </tr>
 <%
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
          <td>&nbsp;<%= vet.size() %>&nbsp;entries in total &nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on page&nbsp;<%= thepage + 1 %>&nbsp;</td>
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
        e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + "It is abnormal during the tone management!");
        sysInfo.add(sysTime + e.toString());
        vet.add("Error occurs during the system tone management!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="ringSearchforliantong.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

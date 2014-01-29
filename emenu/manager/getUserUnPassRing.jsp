<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    private Vector StrToVector(String str){
	  int index = 0;
	  String  temp = str;
	  String  temp1 ="";
	  Vector ret = new Vector();

	  if (str.length() ==0)
	      return ret;
	  index = str.indexOf("|");
   	  while(index > 0){
	      temp1 = temp.substring(0,index);
		  if(index < temp.length())
		     temp = temp.substring(index+1);
		  ret.addElement(temp1);
		  index = 0;
		  if (temp.length() > 0)
		    index  = temp.indexOf("|");
	  }
	  return ret;
  }
%>
<html>
<head>
<title>Audit refuse person ringtone query</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">
<%
    String sysTime = "";
    String jName = (String)application.getAttribute("JNAME");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    //3.17.07
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"Ringtone":(String)application.getAttribute("RINGDISPLAY");
    String searchkey = request.getParameter("searchkey") == null ? "" : request.getParameter("searchkey");
    String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString(request.getParameter("searchvalue"));
    String validtype = request.getParameter("validtype") == null ? "" : request.getParameter("validtype");
    String oper_mode = request.getParameter("oper_mode") == null ? "search" : request.getParameter("oper_mode");
    String numberlist = request.getParameter("numberlist") == null ? "" : ((String)request.getParameter("numberlist")).trim();
    String ringlist = request.getParameter("ringlist") == null ? "" : ((String)request.getParameter("ringlist")).trim();
    int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        int operflag = 0;
        if (purviewList.get("6-3") != null)
           operflag = 1;

        if(operflag ==0 || operID==null){
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to the system first!" : "You have no access to this function!" %>');
	document.URL = 'enter.jsp';
</script>
<%
        }
        else if (operID != null) {
            String ringindex = request.getParameter("ringindex") == null ? "" : ((String)request.getParameter("ringindex")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String usernumber = request.getParameter("caranumber") == null ? "" : (String)request.getParameter("caranumber");

            // 铃音审核通过
            boolean checkflag =true;
            ArrayList rList = new ArrayList();
            Hashtable stmp = null;
            String title = "";
            if (!op.equals("")){
%>
<%
            }else{
              if(!op.equals("") && stmp !=null){
                  // 准备写操作员日志
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","402");
                  map.put("RESULT","1");
                  map.put("PARA1",op);
                  map.put("PARA2",(String)stmp.get("ringid"));
                  map.put("PARA3",(String)stmp.get("ringlabel"));
                  map.put("DESCRIPTION","");
                  purview.writeLog(map);
                }

           String  optSCP = "";
           manSysPara  syspara = new manSysPara();
           ArrayList scplist = syspara.getScpList();
           for (int i = 0; i < scplist.size(); i++) {
              if(i==0 && scp.equals(""))
                 scp = (String)scplist.get(i);
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
           }

            Vector vetSysLib = sysring.getRingLib();
            Vector vet  = new  Vector();
            Hashtable map_in = new Hashtable();
            //查询审核通过铃音
            map_in.put("operflag","1");
            map_in.put("ringtype","1");
            map_in.put("scp",scp);
            //查询参数
            map_in.put("searchkey",searchkey);
            map_in.put("searchvalue",searchvalue);
            if(searchkey.equals("uploadtime")){
              map_in.put("validtype",validtype);
            }else{
              map_in.put("validtype","");
            }
            if(!scp.equals("") && oper_mode.equals("search"))
               vet = sysring.getDIYCheckRing(map_in);

            int pages = vet.size()/25;
            if(vet.size()%25>0)
              pages = pages + 1;
            Hashtable hash = new Hashtable();

%>
<script language="javascript">
   var v_ringindex = new Array(<%= vet.size() + "" %>);
   var v_number = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("ringindex") %>';
   v_number[<%= i + "" %>] = '<%= (String)hash.get("usernumber") %>';
<%
            }
%>
   function initform(pform){
       var value = parseInt(pform.operflag.value);
//       disableButton(value);
       var temp = "<%= scp %>";
       for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }
   }

   function delRing () {
     alert();
     fm.op.value = "del";
     fm.submit();
   }


   function tryListen (ringindex,ringname,mediatype) {
      fm = document.inputForm;
      var tryURL = 'listenCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype='+mediatype;
      if(mediatype==1){
      preListen = window.open(tryURL,'try','width=400, height=200');
      }else if(mediatype==2){
        preListen = window.open(tryURL,'try','width=400, height=430');
      }else if(mediatype==4){
        tryURL = 'viewCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype='+mediatype;
        preListen = window.open(tryURL,'try','width=400, height=430');
      }
   }

   function ringInfo (ringid) {
      infoWin = window.open('checkRingInfo.jsp?ringid=' + ringid,'infoWin','width=400, height=340');
   }

   function onSCPChange(){
       document.inputForm.op.value = "";
       document.inputForm.submit();
   }
   function OnRadioCheck(){
      var fm = document.inputForm;
      if(fm.ischeck[0].checked){
          id_text.style.display = 'none';
          id_select.style.display = 'block';
      }
      else{
          id_text.style.display = 'block';
          id_select.style.display = 'none';
      }
   }

   //3.17.07
   function modeChange(){
     if(document.forms[0].searchkey.value=='uploadtime'){
       document.all('id_dateshow').style.display= 'block';
     }
     else{
       document.all('id_dateshow').style.display= 'none';
     }
   }
   function searchRing () {
     fm = document.inputForm;
     /**
     if (sortby.length > 0)
     fm.sortby.value = sortby;
     **/
     if (trim(fm.searchvalue.value) != '') {
       if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
         //alert('请按照YYYY.MM.DD的格式输入正确的入库时间!并且该时间不能大于当前时间!');
         alert("Please input the upload time in the YYYY.MM.DD format ,and the upload time cannot be later than current time!");
         fm.searchvalue.focus();
         return;
       }
       if (trim(fm.searchkey.value)=='uploadtime'){
         var value_search = trim(fm.searchvalue.value);
         if (fm.validtype.value == '0'){
           fm.searchvalue.value = value_search + ' 00:00:00';
         }else{
           fm.searchvalue.value = value_search + ' 23:59:59';
         }
       }
     }
     var check_value = fm.searchvalue.value;
     for (var i = 0;i<check_value.length;i++){
       var ch = check_value.charAt(i);
       if("'".indexOf(ch) == 0){
         //alert("输入的信息不能包含'号,请重新输入!");
         alert("The input information cannot include \"'\",please re-enter!");
         fm.searchvalue.value = '';
         fm.searchvalue.focus();
         return;
         break;
       }
     }
     fm.submit();
   }

   function onSelectAll(){
     var fm = document.inputForm;
     var ringlist = "";
     var numberlist = "";
     if(fm.selectall.checked){
       for(var i=0;i<v_ringindex.length; i++){
         eval('document.inputForm.crbt'+v_ringindex[i]).checked = true;
         ringlist = ringlist + v_ringindex[i] + '|';
         numberlist = numberlist + v_number[i] + '|';
       }
     }
     else {
       for(var i=0;i<v_ringindex.length; i++)
       eval('document.inputForm.crbt'+v_ringindex[i]).checked = false;
     }
     fm.ringlist.value = ringlist;
     fm.numberlist.value = numberlist;
     return;
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
   function toPage (page) {
     document.inputForm.page.value = page;
     document.inputForm.submit();
   }
   function oncheckbox(sender,ringindex,usernumber){
     var fm = document.inputForm;
     var ringlist = fm.ringlist.value;
     var numberlist = fm.numberlist.value;
     var ringvalue = "";
     var numbervalue = "";
     if(sender.checked){
       fm.ringlist.value = ringlist + ringindex  + "|";
       fm.numberlist.value = numberlist + usernumber + "|";
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

     var idd2 = numberlist.indexOf("|");
     while( idd2 > 0){
       if(numberlist.substring(0,idd2)==usernumber){
         numbervalue = numbervalue + numberlist.substring(idd2+1);
         break;
       }
       numbervalue = numbervalue +  numberlist.substring(0,idd2) + '|';
       numberlist = numberlist.substring(idd2 + 1);
       idd2 =-1;
       if(numberlist.length>1)
       idd2  = numberlist.indexOf("|");
     }
     return;
   }
</script>
<script language="JavaScript">
if(parent.frames.length>0)
  parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="getUserUnPassRing.jsp">
<input type="hidden" name="ringindex" value="">
<input type="hidden" name="operflag" value="<%= operflag %>">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="reasontext" value="">
<input type="hidden" name="caranumber" value="">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="op" value="">
<input type="hidden" name="ringlist" value="">
<input type="hidden" name="numberlist" value="">
<input type="hidden" name="oper_mode" value="<%=oper_mode%>">
<script language="JavaScript">
  if(parent.frames.length>0)
    parent.document.all.main.style.height="800";
</script>
<table border="0" width="377" align="center" cellspacing="0" cellpadding="0" class="table-style2">
  <tr align="center">
    <td>
      <table width="490" border="0" align="center" cellpadding="1" cellspacing="1" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Audit refuse person <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> query</td>
        </tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td height="35" colspan="2" >Please select SCP&nbsp; <select name="scplist" size="1" onchange="javascript:onSCPChange()" class="input-style1" style="width:120px">
              <% out.print(optSCP); %>
             </select>
          </td>
        </tr>
        <tr>
          <td width="100%" >
          <table width="100%" border="0" cellpadding="1" cellspacing="1" class="table-style2">
          <tr>
            <td width="100%" >
              <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="100%">
                <tr>
                  <td>Select type &nbsp;
                    <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();">
                      <option value="ringlabel"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</option>
                      <option value="usernumber">Subscriber number</option>
                      <option value="uploadtime">Upload time</option>
                    </select>
                  </td>
                  <td>Keyword
                    <input type="text" size="10" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
                  </td>
                  <td id="id_dateshow" style="display:none" width="20%">
                    <select name="validtype" size="1">
                    <%if(validtype.equals("0")){%>
                    <option value=0  selected="selected">Date before </option>
                    <option value=2> Date after</option>
                    <%}else if(validtype.equals("2")){%>
                    <option value=0>Date before</option>
                    <option value=2 selected="selected">Date after </option>
                    <%}else{%>
                    <option value=0>Date before </option>
                    <option value=2>Date after </option>
                    <%}%>
                    </select>
                  </td>
                </tr>
              </table>
            </td>
          <td width="51"><img src="button/search.gif" alt="Search ringtone for audit" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing()"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td >
      <table width="100%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
        <tr class="tr-ringlist">
          <td height="30">
            <div align="center"><font color="#FFFFFF">DIY <%=ringdisplay%> name</font></div>
          </td>
          <td height="30" width="70">
            <div align="center"><font color="#FFFFFF">Telephone number</font></div>
          </td>
          <td height="30" >
            <div align="center"><font color="#FFFFFF">Upload source</font></div>
          </td>
          <td height="30" >
            <div align="center"><font color="#FFFFFF">Audit time</font></div>
          </td>
          <td height="30">
            <div align="center"><font color="#FFFFFF">Unpass reason</font></div>
          </td>
        </tr>
<%
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
          hash = (Hashtable)vet.get(i);
          String  bgcl = i % 2 == 0 ? "#FFFFFF" : "E6ECFF" ;
          out.println("<tr bgcolor="+bgcl + ">");
          out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("ringlabel")+"</font></td>");
          out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("usernumber")+"</font></td>");
          out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("spname")+"</font></td>");
          out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("uploadtime")+"</font></td>");
          out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("refusecomment")+"</font></td>");
        }
        if (vet.size() == 0 && !oper_mode.equals("")){
%>
        <tr bgcolor="E6ECFF">
          <td class="table-style2" align="center" colspan="10">No record matched the criteria!</td>
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
          <td class="table-style2">&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1 %>&nbsp;pages&nbsp;&nbsp;You are now on Page &nbsp;<%= thepage+1 %>&nbsp;</td>
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
    </td>
  </tr>
 </table>
</form>
<script language="javascript">
var v_value = document.inputForm.searchvalue.value;
if ('<%= searchkey %>' != '-1'){
  document.inputForm.searchkey.value = '<%= searchkey == "" ? "ringlabel" : searchkey%>';
  if ('<%= searchkey%>' == 'uploadtime'){
    modeChange();
    if (v_value != ""){
      document.inputForm.searchvalue.value = v_value.substring(0,10);
    }
  }
}
</script>
<%
            }
        }
        else {
              if(operID== null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "You have no access to this function!");
              </script>
              <%

                   }

        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occourred in querying person ringtone which are not audit pass!");//查询审核未通过个人铃音过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + "Error occourred in querying person ringtone which are not audit pass!");//查询审核未通过个人铃音过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="getUserUnPassRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

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
<%!
    public Vector refuseComment() {
        Vector vet = new Vector();
        vet.add("The content are not health");//内容不健康
        vet.add("Exists politics problem");//存在政治问题
        vet.add("Maybe make other customer mistake"); //"可能造成其他客户误解"
        vet.add("Miscellaneous reasons");//其它原因
        return vet;
    }
%>
<html>
<head>
<title>Personal ringtone audit</title>
<link href="../manager/style.css" type="text/css" rel="stylesheet">
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
    String spIndex = (String)session.getAttribute("SPINDEX");//add by zh 3.22.01
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        int operflag = 0;
        if (spIndex  == null || spIndex.equals("-1")){
            %>
            <script language="javascript">
            alert("Sorry,you are not the SP administrator!");
            document.URL = 'enter.jsp';
</script>
            <%
        }

        if (purviewList.get("10-16") != null )
           operflag = 3;

        if(operflag ==0 || operID==null){
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to the system!" : "You have no access to this function!" %>');
	document.URL = 'enter.jsp';
</script>
<%
        }
        else if (operID != null) {
            String ringindex = request.getParameter("ringindex") == null ? "" : ((String)request.getParameter("ringindex")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String ringname = request.getParameter("ringname") == null ? "" : transferString((String)request.getParameter("ringname")).trim();
            String refusecomment = request.getParameter("reasontext") == null ? "": transferString((String)request.getParameter("reasontext")).trim();
            String usernumber = request.getParameter("caranumber") == null ? "" : (String)request.getParameter("caranumber");

            // 铃音审核通过
            boolean checkflag =true;
            ArrayList rList = new ArrayList();
            Hashtable stmp = null;
            String title = "";
            if (!op.equals("")){
              Vector vetRing = null;
              Vector vetNumber = null;
              vetNumber = StrToVector(numberlist);
              vetRing = StrToVector(ringlist);
              String c_title ="";
              if (op.equals("1")){
                c_title = "Audit pass";
                refusecomment = "";
              }
              else if (op.equals("2")){
                c_title = "Refuse to audit";//拒绝审核
              }
              int  records = vetRing.size();
%>
<script language="javascript">

    var records = <%= records %>;
    var hei = 600;
    if(records>10);
       hei = 600 + (records-10)*30;
    if(parent.frames.length>0)
	parent.document.all.main.style.height=hei;

   function initform(pform){
   }
   function onBack() {
      var fm = document.inputForm;
      fm.op.value ="";
      fm.submit();
   }
</script>
<form name="inputForm" method="post" action="checkUserRing.jsp">
<input type="hidden" name="op" value="">
<table  width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td><img src="image/007.gif" width="100%" height="15"></td>
  </tr>
 <tr >
    <td  background="image/009.gif" >
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td colspan=2 height=40 class="font" align="center" ><%= title %></td>
    </tr>
   <td align="center" colspan=2>
      <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
      <tr class="tr-ringlist">
        <td width="20%" align="center">Ringtone code</td>
        <td width="30%" align="center" >Ringtone name</td>
        <td width="10%" align="center" >SCP</td>
        <td width="40%" align="center">Result</td>
      </tr>
      <%
      try{
         ArrayList arrayCheckLog = new ArrayList();
         rList =  null;
         stmp =  null;
         String  sSpCode = "";
         for(int i=0;i<vetRing.size();i++){
           ringindex = vetRing.get(i).toString();
           usernumber = vetNumber.get(i).toString();
           //审核通过
           if (op.equals("1")){
             stmp = sysring.checkUserRingPass(pool,Integer.parseInt(ringindex),5,usernumber);
//             stmp = sysring.checkUserRingPass(pool,Integer.parseInt(ringindex),4,usernumber);
           }
           else if (op.equals("2")) //拒绝审核
             stmp = sysring.checkUserRingRefuse(Integer.parseInt(ringindex),refusecomment,usernumber);

             String color = i == 0 ? "E6ECFF" :"#FFFFFF" ;
             if(sSpCode == null || sSpCode.equals(""))
                sSpCode = (String)stmp.get("spcode");
             out.print("<tr bgcolor='"+color+"'>");
//             if(i==0){
               out.print("<td >"+(String)stmp.get("ringid")+"</td>");
               out.print("<td >"+(String)stmp.get("ringlabel")+"</td>");
//             }
//             else{
//                 out.print("<td >&nbsp;</td>");
//                 out.print("<td >&nbsp;</td>");
//             }
             out.print("<td >" + scp + "</td>");
             String sRet = "0";
             if (op.equals("1")){
               sRet = (String)stmp.get("ret");
             }
             if(sRet.equals("0"))
                out.print("<td >Success</td>");
             else
                out.print("<td >Fail</td>");
             out.print("</tr>");

           //增加日志部分
           int iLastStat = (String)stmp.get("laststat")==null?0:Integer.parseInt((String)stmp.get("laststat"));
           if(iLastStat==2 ||  op.equals("2") || op.equals("4")){
                 String  sTmp = "Check ok";
                 if(op.equals("2"))
                   sTmp = "Check Refused,Reason:" + refusecomment;

                 HashMap mapCheck = new HashMap();
                 mapCheck.put("ringid",(String)stmp.get("ringid"));
                 mapCheck.put("ringlabel",(String)stmp.get("ringlabel"));
                 mapCheck.put("operator",operName);
                 mapCheck.put("result",sTmp);
                 arrayCheckLog.add(mapCheck);
             }
            //填写操作员日志
            if(!op.equals("")){
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
                  map.put("DESCRIPTION",refusecomment);
                  purview.writeLog(map);
             }
        }
           if(arrayCheckLog.size()>0)
              sysring.writeCheckLog(sSpCode,arrayCheckLog);
        }
        catch(Exception ex){
       %>
       <script language="javascript">
          alert("<%= ex.getMessage() %>");
      </script>
      <%
         }
      %>
      </table>
      <tr>
      <td align="center" colspan=2>
          <img src="../manager/button/back.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:onBack()">
      </td>
      </tr>
  </table>

 </table>
</form>
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
                  map.put("DESCRIPTION",refusecomment);
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
            map_in.put("operflag",Integer.toString(operflag));
            map_in.put("ringtype","3");
            map_in.put("scp",scp);
            //查询参数
            map_in.put("searchkey",searchkey);
            map_in.put("searchvalue",searchvalue);
            if(searchkey.equals("uploadtime")){
              map_in.put("validtype",validtype);
            }else{
              map_in.put("validtype","");
            }
            map_in.put("spindex",spIndex);
            if(!scp.equals("") && oper_mode.equals("search"))
               vet = sysring.gerNeedCheckRing(map_in);

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
       disableButton(value);
       var temp = "<%= scp %>";
       for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }
   }

   function disableButton(value){
      var pform = document.inputForm;
      if(value ==0){
          pform.checkpass1.disabled  = true;
          pform.checkpass2.disabled  = true;
//          pform.checkpass3.disabled  = true;
//          pform.checkpass4.disabled  = true;
       }
       else if(value==1){
          pform.checkpass1.disabled  = false;
          pform.checkpass2.disabled  = false;
//          pform.checkpass3.disabled  = true;
//          pform.checkpass4.disabled  = true;

       }
       else if(value==2){
          pform.checkpass1.disabled  = true;
          pform.checkpass2.disabled  = true;
//          pform.checkpass3.disabled  = false;
//          pform.checkpass4.disabled  = false;

       }else if(value==3){
          pform.checkpass1.disabled  = false;
          pform.checkpass2.disabled  = false;
//          pform.checkpass3.disabled  = false;
//          pform.checkpass4.disabled  = false;
       }
   }


   function checkpass (opflag) {
      //opflag: 1:内容审核通过,2:内容审核拒绝,3:资费审核通过,4:资费审核拒绝
       var check_flag = 'false';
       var check_time = 0;
       fm = document.inputForm;
       var strcon = "";
       var strtemp = "";
       switch(opflag){
        case 1:
          strcon = "Please select the ringtone to audit";//请先选择要审核的铃音
          strtemp = "Are you sure this ringtone has passed the audit?";//您确认这条铃音通过审核吗
          break;
        case 2:
          strcon = "Please select the ringtone to be rejected in the auditing"; //请先选择拒绝通过审核的铃音
          strtemp = "Are you sure to refuse this ringtone to pass the audit?";//您确认拒绝这条铃音通过审核吗？
          if(!checkRefuse())
             return;
          break;
      }
//      if (fm.ringindex.value == '') {
//         alert(strcon);
//         return;
//      }
      if (v_ringindex.length == 0){
        alert('No ringtone is for audit!');//没有待审核的铃音
        return;
      }
      for (var i = '<%= thepage * 25%>'; i < '<%= thepage * 25 + 25%>' && i < v_ringindex.length; i++){
        if (eval('document.inputForm.crbt'+v_ringindex[i]).checked == true){
            check_flag = 'true';
            check_time = check_time + 1;
        }
      }
      if (check_flag == 'false'){
        alert('Please select the rigntone to audit!'); //请先选择要审核的铃音
        return;
      }
      if (check_time > 1){
        if (opflag == 1){
          strtemp = 'Are you sure you want to pass the audit of this ringtone?';//您确认这些铃音通过审核吗
        }else{
          strtemp = 'Are you sure you want to refuse the audit of this ringtone';//您确认拒绝这些铃音通过审核吗？
        }
      }
      if (confirm(strtemp) == 0)
         return;
      fm.op.value = opflag;
      fm.submit();
   }

   function checkRefuse () {
      fm = document.inputForm;
//      if (fm.ringindex.value == '') {
//         alert('请先选择要拒绝的铃音!');
//         return false;
//      }

      if(fm.ischeck[0].checked){
          if(fm.refusecomment.selectedIndex == -1){
             alert("Please select the rejection reason!");
             return false;
          }
          fm.reasontext.value = fm.refusecomment.options[fm.refusecomment.selectedIndex].text;
      } else {
          var value = trim(fm.reason.value);
          if(value == ''){
              alert("Please input the rejection reason!");
              fm.reason.focus();
              return false;
          }
          if(strlength(value)>100){
              alert("Rejection reason cannot be larger than 100 bytes,please re-enter!");//不能超过100个字节长度,请重新输入
              fm.reason.focus();
              return false;
          }
          fm.reasontext.value = fm.reason.value;
      }
      return true;
   }


   function tryListen (ringindex,ringname,mediatype) {
      fm = document.inputForm;
      var tryURL = '../manager/listenCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype='+ mediatype;
      if(trim(mediatype)=='1'){
      preListen =  window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = '../manager/viewCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype='+ mediatype;
            preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));;
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
         alert("Please input the upload time in the YYYY.MM.DD format,and the time cannot be later than current time!");
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
         alert("The input information cannot include ',please re-enter!");//输入的信息不能包含'号,请重新输入
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
       for (var i = '<%= thepage * 25%>'; i < '<%= thepage * 25 + 25%>' && i < v_ringindex.length; i++){
         eval('document.inputForm.crbt'+v_ringindex[i]).checked = true;
         ringlist = ringlist + v_ringindex[i] + '|';
         numberlist = numberlist + v_number[i] + '|';
       }
     }
     else {
       for (var i = '<%= thepage * 25%>'; i < '<%= thepage * 25 + 25%>' && i < v_ringindex.length; i++)
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
       alert("Please specify the value of the page to go to!");//Please specify the value of the page to go to
       fm.gopage.focus();
       return;
     }
     if(!checkstring('0123456789',thepage)){
       alert("The value of the page to go to can only be a digital number!")
       fm.gopage.focus();
       return;
     }
     if(thepage<=0 || thepage>pages ){
       alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!!")
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
     eval('document.inputForm.selectall').checked = false;

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
  parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="checkUserRing.jsp">
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
<table border="0" width="377" align="center" height="100%" cellspacing="0" cellpadding="0" class="table-style2">
  <tr valign="center">
    <td>
      <table width="490" border="0" align="center" cellpadding="1" cellspacing="1" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Personal ringtone audit</td>
        </tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td height="35" colspan="2" >SCP&nbsp;&nbsp; <select name="scplist" size="1" onchange="javascript:onSCPChange()" class="select-style5" style="width:120px">
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
                  <td>Type&nbsp;
                    <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();" style="width:120px">
                      <option value="ringlabel">Ringtone name</option>
                      <option value="usernumber">User number</option>
                      <option value="uploadtime">Upload time</option>
                    </select>
                  </td>
                  <td>Keyword
                    <input type="text" size="10" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
                  </td>
                  <td id="id_dateshow" style="display:none" width="20%">
                    <select name="validtype" size="1">
                    <%if(validtype.equals("0")){%>
                    <option value=0  selected="selected"> Date before</option>
                    <option value=2> Date after</option>
                    <%}else if(validtype.equals("2")){%>
                    <option value=0> Date before</option>
                    <option value=2 selected="selected"> Date after</option>
                    <%}else{%>
                    <option value=0>Date before</option>
                    <option value=2>Date after</option>
                    <%}%>
                    </select>
                  </td>
                </tr>
              </table>
            </td>
          <td width="51"><img src="image/search.gif" alt="Search audit ringtone " onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing()"></td>
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
            <div align="center"><font color="#FFFFFF"><span title="Mobile number">Mobile</span></font></div>
          </td>
          <td height="30" >
            <div align="center"><font color="#FFFFFF">Provider</font></div>
          </td>
          <td height="30" >
            <div align="center"><font color="#FFFFFF">Upload time</font></div>
          </td>
          <td height="30" width="20">
            <div align="center"><font color="#FFFFFF">Preview</font></div>
          </td>
          <td height="30" width="40">
            <div align="center"><font color="#FFFFFF">Select</font></div>
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
%>

          <td height="20" align="center">
          <div align="center">
            <font color="#CC9900">
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
            <img src="<%= strPhoto %>"  height='15'  width='15' alt="Pre-listen this ringtone" onmouseover="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringindex") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("mediatype") %>')">
            </font>
            </font>
          </div>
        </td>

<%
          out.println("<td align=center> <input type='checkbox' name='crbt"+(String)hash.get("ringindex")+"'  onclick='oncheckbox(this," + (String)hash.get("ringindex") + ",\"" + (String)hash.get("usernumber") + "\")' ></font></td>");
%>
          </tr>
<%
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
          <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on page&nbsp;<%= thepage + 1 %>&nbsp;</td>
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
  <tr>
    <td align="center" height=40>
      <table border="0" width="100%" class="table-style2" align="center">
        <tr>
          <tr></tr>
          <tr></tr>
          <td>
            <table border="0" width="100%" class="table-style2" align="center">
            <tr>
              <td width="20%" align="center" >
                <input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select all
              </td>
              <td width="20%" align="center" > Refuse:&nbsp;</td>
              <td width="40%">
                <input type="radio" checked name="ischeck" value="0" onclick="OnRadioCheck()" checked >Select
                <input type="radio" name="ischeck" value="1" onclick="OnRadioCheck()" >Input
              </td>
              <td width="20%" style='display:block' id="id_select" >
                <select name="refusecomment" class="input-style1">
                    <%
                    Vector refuseComment = refuseComment();
                    for (int i = 0; i < refuseComment.size(); i++) {
                      %>
                      <option value="<%= i %>"><%= (String)refuseComment.get(i) %></option>
                      <%
                      }
                      %>
                  </select>
                </td>
                <td width="20%" style="display:none" id="id_text" ><input type="text" name="reason" maxlength="100" value="" style="input-style1" ></td>
              </tr>
            </table>
          </td>
       </tr>
         <tr>
          <td align="center" colspan=2 height=40>
            <table border="0" width="100%" class="table-style2" align="center">
              <tr >
                <td width="20%" align="center" ><input type='button'  name="checkpass1" value="Pass" onclick="javascript:checkpass(1)"></td>
                <td width="20%" align="center" ><input type='button'  name="checkpass2"   value="Refuse"  onclick="javascript:checkpass(2)"></td>
                <td width="20%" align="center" ><input type='button'  name="r_fresh"   value="Refresh"  onclick="javascript:research()"></td>
              </tr>
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
document.inputForm.refusecomment.value = '-1';
var r_searchkey = "<%= searchkey %>";
var r_searchvalue = "<%= searchvalue %>";
var r_validtype = "<%= validtype %>";
var r_scp = "<%= scp %>";
var fm = document.inputForm;
function research(){
  fm.searchkey.value = r_searchkey;
  fm.searchvalue.value = r_searchvalue;
  fm.validtype.value = r_validtype;
  fm.scplist.value = r_scp;
  fm.submit();
}
</script>
<%
            }
        }
        else {
              if(operID== null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system!");
                    document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + "exception occurred in the personal ringtone audit!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + "error occurred in the personal ringtone audit!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="checkUserRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.CrbtUtil" %>

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
        vet.add("Refuse this ringtone");//该铃音拒绝通过审核
        vet.add("Invalid Ringtone property");//铃音属性配置不真确
        vet.add("Ringtone name exist");//Ringtone name已经存在
        vet.add("Unreasonable ringtone price");//铃音价格不合理
        vet.add("Blue ringtone");//黄色铃音
        vet.add("Reactionary ringtone");//反动铃音
        vet.add("Poor ringtone Quality");//铃音音质太差
        vet.add("Unable to play");//铃音无法播放
        vet.add("Other reasons");//其它原因


        vet.add("Refused ringtone");
        return vet;
    }
%>
<html>
<head>
<title>Batch verification of system ringtones</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])" >
<%
String uservalidday = CrbtUtil.getConfig("uservalidday","0") == null ? "0" : CrbtUtil.getConfig("uservalidday","0");
    String sysTime = "";
     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");
    ringsourcename=transferString(ringsourcename);
int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
    String ifpretone = CrbtUtil.getConfig("ifpretone","0");
    //add end
    String jName = (String)application.getAttribute("JNAME");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String audiflag=CrbtUtil.getConfig("audiflag","1");   //是否显示一次性审核通过按钮的标志
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

     int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
    String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        int operflag = 0; //0:无权限 1:内容审核,2:资费审核 3:内容审核和资费审核
        if (purviewList.get("6-7") != null)
           operflag = 1;
        if (purviewList.get("6-8") != null)
           operflag = operflag + 2;
        if(operflag ==0 || operID==null){
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to the system first!" : "You have no access to this function!" %>');
	document.URL = 'enter.jsp';
</script>
<%
        }
        else if (operID != null) {
         String sortby =  "" ;
           String validtype = request.getParameter("validtype") == null ? "1" : (String)request.getParameter("validtype");
           String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");
           String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
           String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
           String ringindex = "";
           String spIndex = (String)request.getParameter("spindex")==null?"0":(String)request.getParameter("spindex");
           String checktype = (String)request.getParameter("checktype")==null?"":(String)request.getParameter("checktype");
           String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
           String refusecomment = request.getParameter("reasontext") == null ? "": transferString((String)request.getParameter("reasontext")).trim();
            manSysPara  syspara = new manSysPara();
	    ArrayList spInfo = syspara.getSPInfo();

          //modify by ge quanmin  2005-06-09
           if(checktype.equals("")){
             if(operflag==1) checktype = "1";  //需作内容审核的
             else if(operflag==2) checktype = "2"; //需作资费审核的
             else if(operflag==3) checktype = "3"; //全部需审核的
           }
           if(!op.equals("")){
             String ringlist = request.getParameter("ringlist") == null ? "" : ((String)request.getParameter("ringlist")).trim();
             Vector vetRing = null;
             vetRing = StrToVector(ringlist);

             String title ="";
             if (op.equals("1")){
                title = "Pass content verification in a batch";
                refusecomment = "";
             }
             else if (op.equals("2"))
                title = "Refuse content verification in a batch";
             else if (op.equals("3")){
                refusecomment = "";
                title = "Pass tariff verification in a batch";
             } else if (op.equals("4"))
                title = "Refuse tariff verification in a batch";
              else if(op.equals("5")){
                refusecomment = "";
                title = "Once verification pass in a batch";
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
<form name="inputForm" method="post" action="checkBatchRing.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="sp" value="<%= spIndex %>" >
<input type="hidden" name="checktype" value="<%= checktype %>">
<table width="377" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="image/007.gif" width="377" height="15"></td>
  </tr>
 <tr >
    <td  background="image/009.gif" >
    <table width="370" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
    <tr>
        <td colspan=2 height=40 class="font" align="center" ><%= title %></td>
    </tr>
   <td align="center" colspan=2>
      <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
      <tr class="tr-ringlist">
        <td width="20%" align="center"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
        <td width="30%" align="center" ><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
        <td width="10%" align="center" >SCP</td>
        <td width="40%" align="center">Result</td>
      </tr>
      <%
         ArrayList arrayCheckLog = new ArrayList();
         ArrayList  rList =  null;
         Hashtable stmp =  null;
         String  sSpCode = "";
         for(int i=0;i<vetRing.size();i++){
           ringindex = vetRing.get(i).toString();
           if (op.equals("1"))    //内容审核通过
               rList = sysring.checkSysRingPass(pool,Integer.parseInt(ringindex),3);
           else if (op.equals("2")) //拒绝内容审核
               rList = sysring.checkSysRingRefuse(Integer.parseInt(ringindex),refusecomment,1);
           else if (op.equals("3"))  //资费审核通过
               rList = sysring.checkSysRingPass(pool,Integer.parseInt(ringindex),4);
           else if (op.equals("4"))  //拒绝资费审核
               rList = sysring.checkSysRingRefuse(Integer.parseInt(ringindex),refusecomment,1);
            //modify by ge quanmin  2005-06-09
           else if(op.equals("5")){
             rList = sysring.checkSysRingPass(pool,Integer.parseInt(ringindex),3); //内容审核通过
             rList = sysring.checkSysRingPass(pool,Integer.parseInt(ringindex),4);//资费审核通过
           }
           else if(op.equals("-1")) //铃音驳回
               rList = sysring.checkSysRingRefuse(Integer.parseInt(ringindex),refusecomment,2);

            for(int j=0;j<rList.size();j++){
             String color = j == 0 ? "E6ECFF" :"#FFFFFF" ;
             stmp = (Hashtable)rList.get(j);
             if(sSpCode == null || sSpCode.equals(""))
                sSpCode = (String)stmp.get("spcode");
             out.print("<tr bgcolor='"+color+"'>");
             if(j==0){
               out.print("<td >"+(String)stmp.get("ringid")+"</td>");
               out.print("<td >"+(String)stmp.get("ringlabel")+"</td>");
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
                out.print("<td >Fail," + (String)stmp.get("reason") +"</td>");
             out.print("</tr>");
           }

           //增加日志部分
           int iLastStat = (String)stmp.get("laststat")==null?0:Integer.parseInt((String)stmp.get("laststat"));
           if(iLastStat==2 ||  op.equals("2") || op.equals("4")){
                 String  sTmp = " Pass verification";
                 if(op.equals("2"))
                   sTmp = "Refuse content verification,Reason:" + refusecomment;
                 else  if(op.equals("4"))
                   sTmp = "Refuse tariff verification,Reason:" + refusecomment;

                 HashMap mapCheck = new HashMap();
                 mapCheck.put("ringid",(String)stmp.get("ringid"));
                 mapCheck.put("ringlabel",(String)stmp.get("ringlabel"));
                 mapCheck.put("operator",operName);
                 mapCheck.put("result",sTmp);
                 arrayCheckLog.add(mapCheck);
             }
            //填写操作员日志
            if(getResultFlag(rList)){
                  // 准备写操作员日志
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","404");
                  map.put("RESULT","1");
                  map.put("PARA1",op);
                  map.put("PARA2",(String)stmp.get("ringid"));
                  map.put("PARA3",(String)stmp.get("ringlabel"));
                  for(int j=0;j<spInfo.size();j++)
                  if(spIndex.equals(((HashMap)spInfo.get(j)).get("spindex"))){
                    map.put("PARA4",((HashMap)spInfo.get(j)).get("spname"));
                  }
                  map.put("DESCRIPTION",refusecomment+" ip:"+request.getRemoteAddr());
                  purview.writeLog(map);
             }
        }
        try{
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
  <tr>
    <td><img src="image/008.gif" width="377" height="15"></td>
  </tr>
 </table>
</form>
<%
          }
          else {
            Hashtable hash = new Hashtable();
            hash.put("operflag",checktype);
            hash.put("spindex",spIndex);
            hash.put("ringname","");
            if((!searchkey.equals("sp"))||(!searchkey.equals("check"))){
              if(searchkey.equals("validdate")){
            hash.put("searchvalue",searchvalue);
               hash.put("validtype",validtype);
            }else{
              hash.put("searchvalue",searchvalue);
              hash.put("validtype","");
            }
          }
            hash.put("searchkey",searchkey);
            hash.put("libid",libid);
            Vector vet = sysring.getSysCheckRing(hash);
            int    records = vet.size();
%>
<script language="javascript">
   var v_ringindex = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("ringindex") %>';
<%
            }
%>

   function disableButton(value){
      var pform = document.inputForm;
      var flagvalue= <%= audiflag %>;
      if(value ==0){
          pform.checkpass1.disabled  = true;
          pform.checkpass2.disabled  = true;
          pform.checkpass3.disabled  = true;
          pform.checkpass4.disabled  = true;
           if(flagvalue==1){
            pform.checkpass5.disabled  = true;
          }
       }
       else if(value==1){
          pform.checkpass1.disabled  = false;
          pform.checkpass2.disabled  = false;
          pform.checkpass3.disabled  = true;
          pform.checkpass4.disabled  = true;
          if(flagvalue==1){
            pform.checkpass5.disabled  = true;
          }

       }
       else if(value==2){
          pform.checkpass1.disabled  = true;
          pform.checkpass2.disabled  = true;
          pform.checkpass3.disabled  = false;
          pform.checkpass4.disabled  = false;
          if(flagvalue==1){
            pform.checkpass5.disabled  = true;
          }

       }else if(value==3){
          pform.checkpass1.disabled  = false;
          pform.checkpass2.disabled  = false;
          pform.checkpass3.disabled  = false;
          pform.checkpass4.disabled  = false;
          if(flagvalue==1){
            pform.checkpass5.disabled  = false;
          }
       }
   }
   function checkpass (opflag) {
     //opflag: 1:内容审核批量通过,2:内容审核批量拒绝,3:资费审核批量通过,4:资费审核批量拒绝,5:一次审核通过
       fm = document.inputForm;
       var strcon = "";
       var strtemp = "";
       switch(opflag){
        case 1:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that requires content verification";//请先选择要内容审核的铃音
          strtemp = "Are you sure you want to pass the content verification?";//您确认通过内容审核吗
          break;
        case 2:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that should be refused to pass the content verification";//请先选择拒绝通过内容审核的铃音
          strtemp = "Are you sure you refuse to pass the content verification?";//您确认拒绝通过内容审核吗
          if(!checkRefuse())
             return;
          break;
        case 3:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that requires tariff verification";//请先选择要资费审核的铃音
          strtemp = "Are you sure you want to pass the tariff verification?";//您确认通过资费审核吗
          break;
        case 4:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that should be refused to pass the tariff verification";//请先选择拒绝通过资费审核的铃音
          strtemp = "Are you sure you refuse to pass the tariff verification?";//您确认拒绝通过资费审核吗
          if(!checkRefuse())
             return;
          break;
        case 5:
         // strcon = "请先选择要审核的铃音";
         // strtemp = "您确认一次通过审核吗？";
            strcon ="please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that requires verification at first";
            strtemp = "Are you sure you want to pass the verification at one time?";
          break;
      }
      if (fm.ringlist.value == '') {
         alert(strcon);
         return;
      }
      if (confirm(strtemp) == 0)
         return;
      fm.op.value = opflag;
      fm.submit();
   }

   function checkRefuse () {
      fm = document.inputForm;
      if (fm.ringlist.value == '') {
         alert('Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be refused!');
         return false;
      }
      if(fm.ischeck[0].checked){
          if(fm.refusecomment.selectedIndex == -1){
             alert("Please select the reason of refuse!");
             return false;
          }
          fm.reasontext.value = fm.refusecomment.options[fm.refusecomment.selectedIndex].text;
      } else {
          var value = trim(fm.reason.value);
          if(value == ''){
              alert("Plese input the reason of refuse");
              fm.reason.focus();
              return false;
          }
            <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.reason.value,100)){
             alert("The reason of refuse can't be longer than 100 character,please re-enter!");
              fm.reason.focus();
              return false;
          }
        <%
        }
        else{
        %>
        if(strlength(value)>100){
              alert("The reason of refuse can't be longer than 100 character,please re-enter!");
              fm.reason.focus();
              return false;
          }
        <%}%>
          fm.reasontext.value = fm.reason.value;
      }
      return true;
   }
   function checkBack() {
      fm = document.inputForm;
      if (fm.ringlist.value == '') {
        // alert('请先选择要驳回的铃音!');
         alert('Please select the refused <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>!');
         return false;
      }
      if(fm.ischeck[0].checked){
          if(fm.refusecomment.selectedIndex == -1){
            // alert("请选择驳回原因!");
           alert('Please select the refusal reason!');
             return false;
          }
          fm.reasontext.value = fm.refusecomment.options[fm.refusecomment.selectedIndex].text;
      } else {
          var value = trim(fm.reason.value);
          if(value == ''){
              //alert("请输入驳回原因!");
              alert('Please select the refusal reason!');
              fm.reason.focus();
              return false;
          }
          if(strlength(value)>100){
              //alert("驳回原因不能超过100个字节长度,请重新输入!");
              alert("the refusal reason's length cannot large than 100 bytes");
              fm.reason.focus();
              return false;
          }
          fm.reasontext.value = fm.reason.value;
      }
      fm.op.value = -1 ;
      fm.submit();
   }
   function oncheckbox(sender,ringindex){
       var fm = document.inputForm;
       var ringlist = fm.ringlist.value;
       var ringvalue = "";
       if(sender.checked){
           fm.ringlist.value = ringlist + ringindex  + "|";
           return;
       }
       if(!sender.checked){
        fm.selectall.checked=false;
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
	   return;
   }

   function onSelectAll(){
      var fm = document.inputForm;
      var ringlist = "";
      if(fm.selectall.checked){
         for(var i=0;i<v_ringindex.length; i++){
            eval('document.inputForm.crbt'+v_ringindex[i]).checked = true;
            ringlist = ringlist + v_ringindex[i] + '|';
         }
      }
      else {
          for(var i=0;i<v_ringindex.length; i++)
            eval('document.inputForm.crbt'+v_ringindex[i]).checked = false;
      }
      fm.ringlist.value = ringlist;
      return;
   }

   function tryListen (ringindex,ringname,mediatype) {
      fm = document.inputForm;
      var tryURL = 'listenCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype='+ mediatype;
      if(trim(mediatype)=='1'){
      preListen =  window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = 'viewCheck.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype='+ mediatype;
            preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));;
   		}
   }

   function tryListenPreTone (ringindex,ringname) {
      fm = document.inputForm;
      var tryURL = 'listenCheckPreTone.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype=1';

      preToneListen =  window.open(tryURL,'tryPreTone','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));

   }

   function ringInfo (ringid) {
      infoWin = window.open('checkRingInfo.jsp?ringid=' + ringid,'infoWin','width=400, height=340');
   }

   function searchInfo () {
	  fm = document.inputForm;
      fm.op.value = '';
      fm.submit();
   }

   function initform(pform){
      var value= <%= checktype %>;
      disableButton(value);
   var value = parseInt(pform.operflag.value);
      disableButton(value);
      var sTmp = "<%=  searchkey  %>";
      if(sTmp=='sp'){
         this.id_spshow.style.display = 'block';
      }
      else if(sTmp=='check'){
         document.all('id_checkshow').style.display= 'block';
      }
      else if(sTmp=='validdate'){
        document.all('id_keyshow').style.display= 'block';
        document.all('id_dateshow').style.display= 'block';
      }
     else
        document.all('id_keyshow').style.display= 'block';

   }

   function modeChange(){
      if(document.forms[0].searchkey.value=='sp'){
         document.all('id_keyshow').style.display= 'none';
         document.all('id_spshow').style.display= 'block';
         document.all('id_checkshow').style.display= 'none';
         document.all('id_dateshow').style.display= 'none';
      }
      else if(document.forms[0].searchkey.value=='check'){
         document.all('id_keyshow').style.display= 'none';
         document.all('id_spshow').style.display= 'none';
         document.all('id_checkshow').style.display= 'block';
         document.all('id_dateshow').style.display= 'none';
      }
      else if(document.forms[0].searchkey.value=='validdate'){
       document.all('id_keyshow').style.display= 'block';
       document.all('id_dateshow').style.display= 'block';
       document.all('id_spshow').style.display= 'none';
       document.all('id_checkshow').style.display= 'none';
      }
      else{
         document.all('id_keyshow').style.display= 'block';
         document.all('id_spshow').style.display= 'none';
         document.all('id_checkshow').style.display= 'none';
         document.all('id_dateshow').style.display= 'none';
      }
       var fm = document.inputForm;
       fm.ringindex.value = '';
       fm.ringname.value = '';
       fm.ringlib.value = '0';
       fm.spindex.value = '0';
   }

    function searchCatalog(){
     var dlgLeft = event.screenX;
     var dlgTop = event.screenY;
     var searchkey = document.inputForm.searchkey.value;
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
     return "All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category";
 }

 function searchRing (sortby) {
      fm = document.inputForm;
      /**
      if (sortby.length > 0)
         fm.sortby.value = sortby;
      **/
      if (trim(fm.searchvalue.value) != '') {
          if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
             // alert('请按照YYYY.MM.DD的格式输入正确的入库时间!并且该时间不能大于当前时间!');
              alert('Invalid start time entered. \r\n Please enter the start time in the YYYY.MM.DD format');
              fm.searchvalue.focus();
              return;
          }
        if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
              //alert('请按照YYYY.MM.DD的格式输入正确的入库时间!并且该时间不能大于当前时间!');
              alert('Invalid start time entered. \r\n Please enter the start time in the YYYY.MM.DD format');
              fm.searchvalue.focus();
              return;
          }
      }

        if (trim(fm.searchkey.value)=='ringfee'){
          if (!checkstring('0123456789',trim(fm.searchvalue.value))) {
          //  alert('铃音价格只能为数字!');
            alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> price can only be a digital number!');
            fm.searchvalue.focus();
            return;
          }
        }
		   if (trim(fm.searchkey.value)=='ringfee2'){
          if (!checkstring('0123456789',trim(fm.searchvalue.value))) {
          //  alert('铃音价格只能为数字!');
            alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> price can only be a digital number!');
            fm.searchvalue.focus();
            return;
          }
        }
         if (trim(fm.searchvalue.value) != '') {
          if(trim(fm.searchkey.value)=='validdate' && (!checkDate2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
              //alert('请按照YYYY.MM.DD的格式输入正确的有效期时间!');
              alert('Invalid Period of Validity entered. \r\n Please enter the period of Validity in the YYYY.MM.DD format');
              fm.searchvalue.focus();
              return;
          }
        if(trim(fm.searchkey.value)=='validdate' && (!checkDate2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
              //alert('请按照YYYY.MM.DD的格式输入正确的有效期时间!');
              alert('Invalid Period of Validity entered. \r\n Please enter the period of Validity in the YYYY.MM.DD format');
              fm.searchvalue.focus();
              return;
          }
      }
      fm.submit();
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

</script>
<script language="JavaScript">

    var records = <%= records %>;
    var hei = 800;
    if(records>10);
       hei = 800 + (records-10)*28;
	if(parent.frames.length>0)
		parent.document.all.main.style.height=hei;
</script>
<form name="inputForm" method="post" action="checkBatchRing.jsp">
<input type="hidden" name="ringindex" value="">
<input type="hidden" name="operflag" value="<%= operflag %>">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="reasontext" value="">
<input type="hidden" name="ringlist" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="ringlib" value="0">
<table border="0" align="center"  cellspacing="0" cellpadding="0" class="table-style2" width="90%" >
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
  var root = new Array("0","-1","All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Category","0");
  datasource[0] = root;
   <%if("1".equals(usedefaultringlib)){%>
  root = new Array("503","0","Default <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Library","1");
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
    <td>
      <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2" width="70%" >
        <tr>
          <td align="center">
            <table width="490">
        <tr>
          <td height="26"  align="center" class="text-title"  valign="center" background="image/n-9.gif">Batch verification of system <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s</td>
        </tr>
        </table>
          </td>
        </tr>

        <tr>
          <td width="100%" >
          <table border="0" cellspacing="1" cellpadding="1" class="table-style2">
          <tr>
             <td>
             <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="80%">
        <tr>
        <tr></tr>
         <tr></tr>
          <td width="10"></td>
		  <td>
            Select Type
            <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();" style="width=120px" >
              <option value="ringlabel"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></option>
              <option value="check">Approval type</option>
              <option value="ringauthor"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
			  <%if(issupportmultipleprice == 1){%>
              <option value="ringfee2">Daily Price (<%=minorcurrency%>)</option>
			  <%}%>
              <option value="ringfee"> <%if(issupportmultipleprice == 1){%>Monthly <%}%>Price (<%=minorcurrency%>)</option>
              <option value="sp">Content Provider</option>
              <option value="validdate">Validity </option>
              <option value="uploadtime">Loading time</option>
               <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
               <option value="ringsource">Producer </option>
               <%}%>
            </select>
          </td>
          <td id="id_keyshow" style="display:none">Keyword
          <input type="text" size="10" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" >
          </td>
          <td id="id_spshow" style="display:none">
	    <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider
	    <select name="spindex" class="input-style1"  >
             <option value=0 >All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider </option>
              <%
                 for (int i = 0; i < spInfo.size(); i++) {

                   HashMap  map1 = (HashMap)spInfo.get(i);
                   String spdex = (String)map1.get("spindex");
                    if (spIndex.equals(spdex))
                     out.println("<option value= " + (String)map1.get("spindex") + " selected >" + (String)map1.get("spname") + "</option>");
				else
                     out.println("<option value="+(String)map1.get("spindex") + ">" + (String)map1.get("spname") + "</option>");
                 }
         %>
	     </select>
	     </td>


           <td id="id_dateshow" style="display:none" width="20%">
	    Type
	    <select name="validtype" size="1">
             <%if(validtype.equals("0")){%>
             <option value=0  selected="selected">Date before </option>
             <option value=1> Current date</option>
             <option value=2> Date after</option>
             <%}else if(validtype.equals("1")){%>
              <option value=0>Date before</option>
             <option value=1 selected="selected"> Current date</option>
             <option value=2>Date after</option>
             <%}else if(validtype.equals("2")){%>
              <option value=0> Date before</option>
             <option value=1>Current date</option>
             <option value=2 selected="selected">Date after</option>
             <%}%>
            </select>
               </td>

               <td id="id_checkshow" style="display:none">
	    The type for approval
	    <select name="checktype" class="input-style1"  >
	     <%
                if(operflag==1){
                  if(checktype.equals("1"))
                  out.println("<option value=1 selected > Content approval</option>");
                  else
                  out.println("<option value=1 > Content approval</option>");
                }
              if(operflag==2){
                if(checktype.equals("2")){
                  out.println("<option value=2 selected >Price approval</option>");
                }
                else
                out.println("<option value=2 >Price approval</option>");
              }
              if(operflag==3){
                if(checktype.equals("3")){
                  out.println("<option value=1 >Content approval</option>");
                  out.println("<option value=2 >Price approval</option>");
                  out.println("<option value=3 selected >All for approval</option>");
                } else if(checktype.equals("2")){
                  out.println("<option value=1 > Content approval</option>");
                  out.println("<option value=2 selected> Price approval</option>");
                  out.println("<option value=3  >All for approval</option>");
                }
                else{
                  out.println("<option value=1 > Content approval</option>");
                  out.println("<option value=2 >Price approval</option>");
                  out.println("<option value=3 >All for approval</option>");
                }
              }
               %>
               </select>
           </td>
          <td><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category
              <input type="text" name="ringcatalog" readonly value="All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category" maxlength="20" class="input-style7"  onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()" >
          </td>
        </tr>
      </table>
           </td>
          <td><img src="button/search.gif" alt="Query <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> for approval" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing()"></td>
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
        <tr >
        <td >
	   <table width="99%" border="0" cellspacing="1" cellpadding="1" align="center" class="table-style4">
            <tr class="tr-ringlist">
			   <td height="30" width="40">
                <div align="center"><font color="#FFFFFF">Verification<br>Flag</font></div></td>
              <td height="30" width="70">
                <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</font></div></td>
              <td height="30">
                <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></font></div></td>
              <td height="30" >
                <div align="center"><font color="#FFFFFF"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></font></div></td>
			   <td height="30" >
                <div align="center"><font color="#FFFFFF">Upload time</font></div></td>
                 <%if(("1").equals(uservalidday)){%>
                                <td height="30" width="40">
                <div align="center"><font color="#FFFFFF">Subscriber's period of validity(day)
               <% }%>
               <%if(issupportmultipleprice == 1){%>
             <td height="30" width="40">
                <div align="center"><font color="#FFFFFF">Daily Price<br>
                  (<%=majorcurrency%>)</font></div></td>
               <%}%>
               
             <td height="30" width="40">
                <div align="center"><font color="#FFFFFF"> <%if(issupportmultipleprice == 1){%>Monthly<%}%> Price<br>
                  (<%=majorcurrency%>)</font></div></td>
               <td height="30" width="20">
                <div align="center"><font color="#FFFFFF">Preview</font></div></td>
              <td height="30" width="20">
                <div align="center"><font color="#FFFFFF">Info</font></div></td>

             <%
             String pretonedisplay ="none";
             if(ifpretone.equals("1"))
             {
              pretonedisplay ="block";
             }
             %>
             <td style="display:<%=pretonedisplay%>" height="30" width="20">
                <div align="center"><font color="#FFFFFF">PreTone</font></div></td>

            </tr>
		    <%
		    for (int i=0; i < vet.size(); i++) {
               	hash = (Hashtable)vet.get(i);
             	String  bgcl = i % 2 == 0 ? "#FFFFFF" : "E6ECFF" ;
                String playurl = "";
          String mediatype=  (String)hash.get("mediatype");
          if(mediatype.equals("1"))
              playurl = "../image/play.gif";
          if(mediatype.equals("2"))
              playurl = "../image/play1.gif";
          if(mediatype.equals("4"))
              playurl = "../image/play2.gif";
             	out.println("<tr bgcolor="+bgcl + ">");
		   		out.println("<td align=center> <input type='checkbox' name='crbt"+(String)hash.get("ringindex")+"'  onclick='oncheckbox(this," + (String)hash.get("ringindex") + ")' ></font></td>");
		   		out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("ringid")+"</font></td>");
		   		out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("ringlabel")+"</font></td>");
		   		out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("ringauthor")+"</font></td>");
		   		out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("uploadtime")+"</font></td>");
                                if(("1").equals(uservalidday)){
                                  out.println("<td align=center> <font class='font-ring'>"+(String)hash.get("uservalidday")+"</font></td>");
                                }
               if(issupportmultipleprice == 1){
		   		String strfee2 = (String)hash.get("ringfee2");
				if(strfee2.length()==0)
		   			out.println("<td align=center>"+strfee2+"</td>");
		   		else{
		   			//float fee2= Float.parseFloat((String)hash.get("ringfee2"));
		   			out.println("<td align=center>"+displayFee(strfee2)+"</td>");
		   		}
		   		}
		   		String strfee = (String)hash.get("ringfee");
		   		if(strfee.length()==0)
		   			out.println("<td align=center>"+strfee+"</td>");
		   		else{
		   			//float fee = Float.parseFloat((String)hash.get("ringfee"));
		   			out.println("<td align=center>"+displayFee(strfee)+"</td>");
		   		}%>
		   		
		   		<td height="20" align="center">
                           <div align="center"> <font color="#CC9900"><font class="font-ring"><img src="<%=playurl%>"  height="15" width="15"  alt="Pre-listen this ringtone" onMouseOver="this.style.cursor='hand'" onClick="javascript:tryListen('<%= (String)hash.get("ringindex") %>','<%= (String)hash.get("ringlabel") %>','<%= (String)hash.get("mediatype") %>')"></font></font></div></td>
		   		 <td height="20" align="center">
                            <div align="center"> <font color="#CC9900"><font class="font-ring"><img src="../image/info.gif" height="15" width="15"  alt="Details" onmouseover="this.style.cursor='hand'" onclick="javascript:ringInfo('<%= (String)hash.get("ringid") %>')"></font></font></div></td>

                            <td style="display:<%=pretonedisplay%>" height="20" align="center">
                              <%if(hash.get("preflag").toString().equals("1")){%>
                           <div align="center"> <font color="#CC9900"><font class="font-ring"><img src="../image/play.gif"  height="15" width="15"  alt="Pre-listen this pretone" onMouseOver="this.style.cursor='hand'" onClick="javascript:tryListenPreTone('<%= (String)hash.get("ringindex") %>','<%= (String)hash.get("ringlabel") %>')">
                           </font></font></div>
                            <%}%>
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
               <td>   <table border="0" width="100%" class="table-style2" align="center">
                       <tr>
                           <td width="30%" align="center" >   <input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select All
                           <td width="40%" align="center" > Refuse:&nbsp;<input type="radio" checked name="ischeck" value="0" onclick="OnRadioCheck()" checked >Select
                                            <input type="radio" name="ischeck" value="1" onclick="OnRadioCheck()" >Input
                          </td>
                          <td width="40%"  height="22" style='display:block' id="id_select" >
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
                          <td height="22" style="display:none" id="id_text" ><input type="text" name="reason" maxlength="100" value="" style="input-style1" ></td>
                        </tr>
                        </table>
              </td>
              </tr>
              <tr >
                  <td >
                  <table border="0" width="100%" class="table-style2" align="center">
                  <tr>
                       <td width="30%" align="center" ><input type='button'  name="checkpass1" style="width:150px" value="Batch contents Pass" onclick="javascript:checkpass(1)"></td>
                      <td width="30%" align="center" ><input type='button'  name="checkpass2"  style="width:150px" value="Batch contents Refuse"  onclick="javascript:checkpass(2)"></td>
                      <td width="30%" align="center" ><input type='button'  name="checkpass3" style="width:150px" value="Batch price Pass" onclick="javascript:checkpass(3)"></td>
                   <tr>
                   <tr></tr>
                   <tr></tr>
                      <td  width="30%" align="center" ><input type='button'  name="checkpass4" style="width:150px" value="Batch price Refuse" onclick="javascript:checkpass(4)"></td>

                  <%
                  //modify by ge quanmin  2005-06-09
                  //如果配置允许显示和用户拥有内容审核和资费审核的权限时显示一次性审核
                  if((audiflag.equalsIgnoreCase("1")) &&(operflag==3)){
                  %>

                    <td width="30%" align="center" ><input type='button'  name="checkpass5" style="width:150px" value="Batch tariffs Pass" onclick="javascript:checkpass(5)"></td>
                  <%}%>
                      <td  width="35%" align="center" ><input type='button'  name="checkpass5" style="width:150px"  value="Refuse" onclick="javascript:checkBack()"></td>
                    </tr>
                  </table>
                  </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
 </td>
 </tr>
 </table>
</form>
<script language="javascript">
</script>
<%
           }
        }
        else {
              if(operID== null){
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
                   alert( "Sorry. You have no permission for this function!");//You have no access to this function!
              </script>
              <%

                   }

        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in verifying system ringtones in a batch!");//系统铃音批量审核过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + " Error occurred in verifying system ringtones in a batch!");//系统铃音批量审核出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="checkBatchRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public Vector refuseComment() {
        Vector vet = new Vector();
        vet.add("Refuse this ringtone");//该铃音拒绝通过审核
        vet.add("Invalid ringtone properties");//铃音属性配置不真确
        vet.add("Ringtone name exist");//Ringtone name已经存在
        vet.add("Unreasonable Price");//铃音价格不合理
        vet.add("Blue ringtone");//黄色铃音
        vet.add("Reactionary ringtone");//反动铃音
        vet.add("Poor ringtone Quality");//铃音音质太差
        vet.add("Other reason");//其它原因
       // vet.add("不明原因");
       // vet.add("Refused ringtone");
        return vet;
    }
%>
<html>
<head>
<title>System ringtone verification</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">
<%
   //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0); 
int ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia",0);
int imageup = zte.zxyw50.util.CrbtUtil.getConfig("imageup",0);
int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
String audioring = zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio");
String videoring = zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video");
String photoring = zte.zxyw50.util.CrbtUtil.getConfig("photoring","Photo");

//是否支持随意铃功能开关
ywaccess yes=new ywaccess();
String suiyi=yes.getPara(145);
String uservalidday = CrbtUtil.getConfig("uservalidday","0") == null ? "0" : CrbtUtil.getConfig("uservalidday","0");
    String sysTime = "";
    //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");
    ringsourcename=transferString(ringsourcename);

    String ifpretone = CrbtUtil.getConfig("ifpretone","0");
    //add end
    String jName = (String)application.getAttribute("JNAME");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        int     operflag = 0; //0:无权限 1:内容审核,2:资费审核 3:内容审核和资费审核
        if (purviewList.get("6-1") != null)
           operflag = 1;
        if (purviewList.get("6-2") != null)
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
             String searchkey = request.getParameter("searchkey") == null ? "ringlabel" : (String)request.getParameter("searchkey");

            String validtype = request.getParameter("validtype") == null ? "1" : (String)request.getParameter("validtype");
            String searchvalue = request.getParameter("searchvalue") == null ? "" : transferString((String)request.getParameter("searchvalue"));
            String sortby =  "" ;
            String libid = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");

			String sSelectMType = request.getParameter("selectmtype") == null ? "1" : (String)request.getParameter("selectmtype");

            String spindex=(String)request.getParameter("spindex")==null?"":(String)request.getParameter("spindex");
            String spindex2 = (String)request.getParameter("spindex")==null?"":(String)request.getParameter("spindex");
            String qryRingName = request.getParameter("qryRingName") == null ? "" : transferString((String)request.getParameter("qryRingName")).trim();
            String ringindex = request.getParameter("ringindex") == null ? "" : ((String)request.getParameter("ringindex")).trim();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String ringname = request.getParameter("ringname") == null ? "" : transferString((String)request.getParameter("ringname")).trim();
            String refusecomment = request.getParameter("reasontext") == null ? "": transferString((String)request.getParameter("reasontext")).trim();
            manSysPara  syspara = new manSysPara();
            ArrayList spInfo = syspara.getSPInfo();

            // 铃音审核通过
            int checkflag =0;
            ArrayList rList = new ArrayList();
            String    title = "";
            Hashtable tTmp = new Hashtable();
            if (op.equals("1")) {    //内容审核通过
                 title = "Content verification passed "+ringname;//内容审核通过
                 rList = sysring.checkSysRingPass(pool,Integer.parseInt(ringindex),13);
                 if(rList.size()>0)
                    tTmp = (Hashtable)rList.get(0);
                 checkflag = Integer.parseInt((String)tTmp.get("check"));
                 if(checkflag>0)
                   rList.clear();
                 refusecomment = "";
             }
            else if (op.equals("2")){ //拒绝内容审核
                rList = sysring.checkSysRingRefuse(Integer.parseInt(ringindex),refusecomment,1);
                title = "Refuse content verification "+ringname;
            }
            else if (op.equals("3")){  //资费审核通过
                rList = sysring.checkSysRingPass(pool,Integer.parseInt(ringindex),4);
                title = "Tariff verification passed "+ringname;//资费审核通过
                refusecomment = "";
            }
            else if (op.equals("4")){  //拒绝资费审核
                rList = sysring.checkSysRingRefuse(Integer.parseInt(ringindex),refusecomment,1);
                title = "Refuse tariff verification "+ringname;//拒绝资费审核
            }
            else if(op.equals("5")){   //内容审核强制通过,已确定名称存在重复
                rList = sysring.checkSysRingPass(pool,Integer.parseInt(ringindex),3);
                title = "Pass content verification forcedly "+ringname;//内容审核强制通过
            }else if(op.equals("-1")){ //铃音驳回
                rList = sysring.checkSysRingRefuse(Integer.parseInt(ringindex),refusecomment,2);
                title = " Pass refused ringtone "+ringname;
            }
            if(rList.size()>0){
               //填写日志
               Hashtable hashTmp = (Hashtable)rList.get(0);
               String  sSpCode = (String)hashTmp.get("spcode");
               int iLastStat = (String)hashTmp.get("laststat")==null?0:Integer.parseInt((String)hashTmp.get("laststat"));
               if(iLastStat==2 ||  op.equals("2") || op.equals("4") || op.equals("-1")){
                 String  sTmp = "verification passed";
                 if(op.equals("2"))
                   sTmp = "Refuse content verification,reason:" + refusecomment;
                 else  if(op.equals("4"))
                   sTmp = "Refuse tariff verification,reason:" + refusecomment;
                 else  if(op.equals("-1"))
                   sTmp = "Pass refused ringtone,reason:" + refusecomment;

                 HashMap mapCheck = new HashMap();
                 mapCheck.put("ringid",(String)hashTmp.get("ringid"));
                 mapCheck.put("ringlabel",(String)hashTmp.get("ringlabel"));
                 mapCheck.put("operator",operName);
                 mapCheck.put("result",sTmp);
                 ArrayList arrayCheckLog = new ArrayList();
                 arrayCheckLog.add(mapCheck);
                 try {
                    sysring.writeCheckLog(sSpCode,arrayCheckLog);
                 }
                catch(Exception ex){
                   sysInfo.add(sysTime + operName + "The system ringtone examines the record to fill in the failure");
                   sysInfo.add(sysTime + operName + ex.toString());
                }
              }
              //填写操作员日志
              if(getResultFlag(rList)){
                  // 准备写操作员日志
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","401");
                  map.put("RESULT","1");
                  map.put("PARA1",op);
                  map.put("PARA2",(String)hashTmp.get("ringid"));
                  map.put("PARA3",(String)hashTmp.get("ringlabel"));
                   for(int i=0;i<spInfo.size();i++)
                  if(spindex.equals(((HashMap)spInfo.get(i)).get("spindex"))){
                    map.put("PARA4",((HashMap)spInfo.get(i)).get("spname"));
                  }
                 map.put("DESCRIPTION",title+" ip:"+request.getRemoteAddr());
                  purview.writeLog(map);
                }
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="checkRing.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }

             //内容审核有名称重合
            if(checkflag>0){
     %>

<script language="javascript">
   function initform(pform){
      return;
   }
   function forcepass (opflag) {
      var fm = document.inputForm;
      var strtemp = "<%= ringname %>";
      if (confirm("Are you sure to pass the content verification of the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> \""+strtemp+"\" ?") == 0)//您确信将铃音  通过内容审核吗
         return;
      fm.op.value = 5;
      fm.submit();
   }

   function forcerefuse () {
      var fm = document.inputForm;
      if (!confirm('Are you sure that the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> should be refused to pass the content verification?'))//您确认这条铃音拒绝通过审核吗
         return;
      //fm.refuse.value = 2;
      fm.op.value = '2';
      fm.submit();
   }
   function forcecancel(){
      var fm = document.inputForm;
      fm.op.value = '';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
  <form name="inputForm" method="post" action="checkRing.jsp">
  <input type="hidden" name="ringindex" value="<%= ringindex %>">
  <input type="hidden" name="reasontext" value="<%= refusecomment %>">
  <input type="hidden" name="op" value="">
    <table border="0" align="center" width="100%" cellspacing="0" cellpadding="0" class="table-style2">
    <tr valign="center">
    <td>
      <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> content verification</td>
        </tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td height="22" >Verify <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name:&nbsp;<font class="font"><%= ringname %></font></td>
        </tr>
        <tr>
          <td height="22" >Result of content verification:&nbsp;<font class="font"><%= sysring.getStrmsg(checkflag) %></font></td>
        </tr>
        <tr>
          <td height="22" >Are you sure you want to pass the content verification of this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?</td>
        </tr>
         <tr>
          <td align="center" colspan=2 height=40>
            <table border="0" width="85%" class="table-style2" align="center">
              <tr >
                <td width="34%" align="center"><img src="button/pass.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:forcepass()"></td>
                <td width="33%" align="center"><img src="button/refuse.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:forcerefuse()"></td>
                <td width="33%" align="center"><img src="button/cancel.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:forcecancel()"></td>
              </tr>
            </table>
          </td>
        </tr>
       </table>
	 </td>
	 </tr>
	 </table>
</form>

    <%
         }
         else {
            Vector vetSysLib = sysring.getRingLib();
            Hashtable hash = new Hashtable();
            hash.put("operflag",operflag+"");
            hash.put("spindex",spindex);
            hash.put("ringname","");
            if(searchkey.equals("sp")){
              hash.put("searchvalue",spindex);
              hash.put("validtype","");
            }
            else if(searchkey.equals("validdate")){
              hash.put("searchvalue",searchvalue);
              hash.put("validtype",validtype);
            }
            else{
            hash.put("searchvalue",searchvalue);
              hash.put("validtype","");
            }
            hash.put("searchkey",searchkey);
            hash.put("libid",libid);
            hash.put("ringname",qryRingName);
            Vector vet = sysring.getSysCheckRing(hash);


%>
<script language="javascript">
   var v_allindex = new Array(<%= vetSysLib.size() + "" %>);
   var v_ringlibcode = new Array(<%= vetSysLib.size() + "" %>);
   var v_libname = new Array(<%= vetSysLib.size() + "" %>);
<%
            for (int i = 0; i < vetSysLib.size(); i++) {
                hash = (Hashtable)vetSysLib.get(i);
%>
   v_allindex[<%= i + "" %>] = '<%= (String)hash.get("allindex") %>';
   v_ringlibcode[<%= i + "" %>] = '<%= (String)hash.get("ringlibcode") %>';
   v_libname[<%= i + "" %>] = '<%= (String)hash.get("ringliblabel") %>';
<%
            }
%>

   var v_ringindex = new Array(<%= vet.size() + "" %>);
   var v_ringid = new Array(<%= vet.size() + "" %>);
   var v_usernumber = new Array(<%= vet.size() + "" %>);
   var v_spindex = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
   var v_ringauthor = new Array(<%= vet.size() + "" %>);
   var v_ringsource = new Array(<%= vet.size() + "" %>);
   var v_ringfee = new Array(<%= vet.size() + "" %>);
   if(<%=issupportmultipleprice%> == 1){
   var v_ringfee2 = new Array(<%= vet.size() + "" %>);
   }
   var v_ischeck = new Array(<%= vet.size() + "" %>);
   var v_ringallindex = new Array(<%= vet.size() + "" %>);
<%if(("1").equals(uservalidday)){%>
   var v_uservalidday = new Array(<%= vet.size() + "" %>);
<%}%>
   var v_validdate = new Array(<%= vet.size() + "" %>);
<%if(("1").equals(suiyi)){%>
   var v_isfreewill = new Array(<%= vet.size() + "" %>);
    var v_ringlong = new Array(<%= vet.size() + "" %>);
<%}%>
var v_mediatype = new Array(<%= vet.size() + "" %>);
var v_preflag = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("ringindex") %>';
    v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_usernumber[<%= i + "" %>] = '<%= (String)hash.get("usernumber") %>';
   v_spindex[<%= i + "" %>] = '<%= (String)hash.get("spindex") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
   v_ringauthor[<%= i + "" %>] = '<%= (String)hash.get("ringauthor") %>';
   v_ringsource[<%= i + "" %>] = '<%= (String)hash.get("ringsource") %>';
   v_ringfee[<%= i + "" %>] = '<%= (String)hash.get("ringfee") %>';
   if(<%=issupportmultipleprice%> == 1){
     v_ringfee2[<%= i + "" %>] = '<%= (String)hash.get("ringfee2") %>';
    }
   v_ischeck[<%= i + "" %>] = '<%= (String)hash.get("ischeck") %>';
   v_ringallindex[<%= i + "" %>] = '<%= (String)hash.get("allindex") %>';
<%if(("1").equals(uservalidday)){%>
   v_uservalidday[<%= i + "" %>] = '<%= (String)hash.get("uservalidday") %>';
<%}%>
v_validdate[<%= i + "" %>] = '<%= (String)hash.get("validdate") %>';
<%if(("1").equals(suiyi)){%>
   v_isfreewill[<%= i + "" %>] = '<%= (String)hash.get("isfreewill") %>';
   v_ringlong[<%= i + "" %>] = '<%= (String)hash.get("ringlong") %>';
<%}%>
v_mediatype[<%= i + "" %>] = '<%= (String)hash.get("mediatype") %>';
v_preflag[<%= i + "" %>] = '<%= (String)hash.get("preflag") %>';
<%
            }
%>

   function initform(pform){
       var value = parseInt(pform.operflag.value);
       disableButton(value);

       var sTmp = "<%=  searchkey  %>";
      if(sTmp=='sp'){
         document.all('id_spshow').style.display= 'block';
      }
       else if(sTmp=='validdate'){
         document.all('id_keyshow').style.display= 'block';
         document.all('id_dateshow').style.display= 'block';
       }
     else
        document.all('id_keyshow').style.display= 'block';
   }

   function disableButton(value){
      var pform = document.inputForm;
      if(value ==0){
          pform.checkpass1.disabled  = true;
          pform.checkpass2.disabled  = true;
          pform.checkpass3.disabled  = true;
          pform.checkpass4.disabled  = true;
       }
       else if(value==1){
          pform.checkpass1.disabled  = false;
          pform.checkpass2.disabled  = false;
          pform.checkpass3.disabled  = true;
          pform.checkpass4.disabled  = true;

       }
       else if(value==2){
          pform.checkpass1.disabled  = true;
          pform.checkpass2.disabled  = true;
          pform.checkpass3.disabled  = false;
          pform.checkpass4.disabled  = false;

       }else if(value==3){
          pform.checkpass1.disabled  = false;
          pform.checkpass2.disabled  = false;
          pform.checkpass3.disabled  = false;
          pform.checkpass4.disabled  = false;
       }
   }

   function selectRing () {
      var fm = document.inputForm;
      var index = fm.ringlist.value;
      var usernumber = '';
      if (index == null) {
         fm.ringlist.focus();
         return;
      }
      if (index == '')
         return;
      fm.ringindex.value = v_ringindex[index];
	  fm.ringid.value = v_ringid[index];
      usernumber = v_usernumber[index];
      var value  = usernumber;
      if(usernumber=="503")
          value = "Default <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library(503)";//Default ringtone library
      else if (usernumber.length <= 4) {
         for (var i = 0; i < v_ringlibcode.length; i++) {
            if (v_ringlibcode[i] == usernumber) {
               value = v_libname[i]+"("+v_ringlibcode[i]+")";
               break;
            }
         }
      }
      fm.usernumber.value = value;
      fm.spindex.value = v_spindex[index];
      fm.spindex2.value = v_spindex[index];
      fm.ringlabel.value = v_ringlabel[index];
      fm.ringauthor.value = v_ringauthor[index];
      fm.ringsource.value = v_ringsource[index];
      fm.ringfee.value = v_ringfee[index];
      if(<%=issupportmultipleprice%> == 1){
	  fm.ringfee2.value = v_ringfee2[index];
	  }
      fm.ringname.value = v_ringlabel[index];
<%if(("1").equals(uservalidday)){%>
      fm.uservalidday.value = v_uservalidday[index];
<%}%>
      fm.validdate.value = v_validdate[index];
      <%if(("1").equals(suiyi)){%>
        fm.isfreewill[v_isfreewill[index]].checked = true;
        if(fm.isfreewill[1].checked){
        document.all("ring_long").style.display="";
        }else{
        document.all("ring_long").style.display="none";
        }
      fm.ringlong.value = v_ringlong[index];
<%}%>
      // 法电彩像版本新增 by yuanshenhong
      fm.mediatype.value = v_mediatype[index];

      if(trim(v_mediatype[index]) == '1')
          fm.mediaTypeStr.value = '<%=audioring%>';
      else if(trim(v_mediatype[index]) == '2')
          fm.mediaTypeStr.value = '<%=videoring%>';
      else if(trim(v_mediatype[index]) == '4')
          fm.mediaTypeStr.value = '<%=photoring%>';

      //end

      // add 4.10.1
      <%if(ifpretone.equals("1")){%>
      if(v_preflag[index]=='1')
      {
       fm.checkpretone[0].checked = true;
       fm.pretonebutton.disabled =false;
      }
      else
      {
       fm.checkpretone[1].checked = true;
       fm.pretonebutton.disabled =true;
      }
      <%}%>
      // add end

      var operflag = fm.operflag.value;
      var value = v_ischeck[index];
      if(value==0)
          disableButton(operflag);
      else if(value==3){
          if(operflag==3 || operflag == 1)
             disableButton(2);
          else
             disableButton(0);
      }else if(value ==4){
          if(operflag==3 || operflag == 2)
              disableButton(1);
          else
             disableButton(0);
      }
      else
         disableButton(0);
   }
    function getRingLibName(id){
     for(var i = 0;i<datasource.length;i++){
        var row =  datasource[i];
        if(row[0] == id)
           return row[2];
     }
     return "All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category";//全部铃音类别
 }
   function checkpass (opflag) {
      //opflag: 1:内容审核通过,2:内容审核拒绝,3:资费审核通过,4:资费审核拒绝
       fm = document.inputForm;
       var strcon = "";
       var strtemp = "";
       switch(opflag){
        case 1:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that requires content verification";//请先选择要内容审核的铃音
          strtemp = "Are you sure you want to pass the content verification of this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?";//您确认这条铃音通过内容审核吗
          break;
        case 2:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that should be refused to pass the content verification";//请先选择拒绝通过内容审核的铃音
          strtemp = "Are you sure you refuse to pass the content verification of this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?";//您确认拒绝这条铃音通过内容审核吗
          if(!checkRefuse())
             return;
          break;
        case 3:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that requires tariff verification";//请先选择要资费审核的铃音
          strtemp = "Are you sure you want to pass the tariff verification of this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?";//您确认这条铃音通过资费审核吗
          break;
        case 4:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> that should be refused to pass the tariff verification";//请先选择拒绝通过资费审核的铃音
          strtemp = "Are you sure you refuse to pass the tariff verification of this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>?";//您确认拒绝这条铃音通过资费审核吗
          if(!checkRefuse())
            return;
          break;
      }
      if (fm.ringindex.value == '') {
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
      if (fm.ringindex.value == '') {
alert('Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be refused!');//请先选择要拒绝的铃音
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
              alert("Please input the reason of refuse!");
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

function modeChange(){

      if(document.forms[0].searchkey.value=='sp'){
         document.all('id_keyshow').style.display= 'none';
         document.all('id_dateshow').style.display= 'none';
         document.all('id_spshow').style.display= 'block';
      //   document.all('id_mtypeshow').style.display= 'none';
      }
      else if(document.forms[0].searchkey.value=='validdate'){
         document.all('id_keyshow').style.display= 'block';
         document.all('id_dateshow').style.display= 'block';
         document.all('id_spshow').style.display= 'none';
      //   document.all('id_mtypeshow').style.display= 'none';
      }
      else if(document.forms[0].searchkey.value=='mediatype'){
         document.all('id_keyshow').style.display= 'none';
         document.all('id_dateshow').style.display= 'none';
         document.all('id_spshow').style.display= 'none';
      //   document.all('id_mtypeshow').style.display= 'block';
      }
      else{
         document.all('id_keyshow').style.display= 'block';
         document.all('id_spshow').style.display= 'none';
          document.all('id_dateshow').style.display= 'none';
      //   document.all('id_mtypeshow').style.display= 'none';
      }
      var fm = document.inputForm;
      fm.ringindex.value = '';
      fm.ringname.value = '';
      fm.ringlib.value = '0';
      fm.spindex.value = '0';
   }
   function checkBack() {
      fm = document.inputForm;
      if (fm.ringindex.value == '') {
         //alert('请先选择要驳回的铃音!');
         alert("Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> you want to refuse!");
         return false;
      }
      if(fm.ischeck[0].checked){
          if(fm.refusecomment.selectedIndex == -1){
           //  alert("请选择驳回原因!");
             alert("Please select rejection reason!");
             return false;
          }
          fm.reasontext.value = fm.refusecomment.options[fm.refusecomment.selectedIndex].text;
      } else {
          var value = trim(fm.reason.value);
          if(value == ''){
             // alert("请输入驳回原因!");
              alert("Please input the rejection reason!");
              fm.reason.focus();
              return false;
          }
          if(strlength(value)>100){
             // alert("驳回原因不能超过100个字节长度,请重新输入!");
              alert("The rejection reason cannot be larger than 100 bytes,please re-enter!");
              fm.reason.focus();
              return false;
          }
          fm.reasontext.value = fm.reason.value;
      }
      fm.op.value = -1 ;
      fm.submit();
   }


   function tryListen () {
      fm = document.inputForm;
	   var ringindex = fm.ringindex.value;
      if (fm.ringindex.value == '') {
           alert('Please select a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> before preview!');//请先选择铃音,再试听!
         return;
      }

	   var ringname = fm.ringname.value;
	   var mediatype = fm.mediatype.value;

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


   function tryListenPreTone () {
      fm = document.inputForm;
	   var ringindex = fm.ringindex.value;
      if (fm.ringindex.value == '') {
           alert('Please select a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> before preview pretone!');//请先选择铃音,再试听!
         return;
      }

	   var ringname = fm.ringname.value;
	   var mediatype = fm.mediatype.value;

	   var tryURL = 'listenCheckPreTone.jsp?ringindex=' + ringindex + '&ringname='+ringname+'&mediatype=1';

           preToneListen =  window.open(tryURL,'tryPreTone','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));

   }

   function searchInfo () {
      fm = document.inputForm;
      if (!CheckInputStr(fm.qryRingName,'Ringtone name for audit')){
         fm.qryRingName.focus();
         return  ;
      }
      fm.op.value = '';
      fm.submit();
   }

function searchRing (sortby) {
      fm = document.inputForm;
      if (sortby.length > 0)
         fm.sortby.value = sortby;
      if (trim(fm.searchvalue.value) != '') {
        if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
         // alert('请按照YYYY.MM.DD的格式输入正确的入库时间!并且该时间不能大于当前时间!');
          alert("Please input right upload time with the format of YYYY.MM.DD,and the upload tiem cannot be later than current time!" );
          fm.searchvalue.focus();
          return  ;
        }
        if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
          //alert('请按照YYYY.MM.DD的格式输入正确的入库时间!并且该时间不能大于当前时间!');
          alert("Please input right upload time with the format of YYYY.MM.DD,and the upload tiem cannot be later than current time!");
          fm.searchvalue.focus();
          return;
        }
        if (trim(fm.searchkey.value)=='ringfee'){
          if (!checkstring('0123456789',trim(fm.searchvalue.value))) {
            //alert('铃音价格只能为数字!');
             alert('<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> price can only be a digital number!');
            fm.searchvalue.focus();
            return;
          }
        }
        if(<%=issupportmultipleprice%> == 1){
		 if (trim(fm.searchkey.value)=='ringfee2'){
          if (!checkstring('0123456789',trim(fm.searchvalue.value))){
            //alert('铃音价格只能为数字!');
             alert('<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> price can only be a digital number!');
            fm.searchvalue.focus();
            return;
      }
        }
       }
      }

      if (trim(fm.searchvalue.value) != '') {
        if(trim(fm.searchkey.value)=='validdate' && (!checkDate2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
         // alert('请按照YYYY.MM.DD的格式输入正确的有效期时间!');
          alert("Please input the right validity time in the YYYY.MM.DD format!");
          fm.searchvalue.focus();
          return;
        }
        if(trim(fm.searchkey.value)=='validdate' && (!checkDate2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
          //alert('请按照YYYY.MM.DD的格式输入正确的有效期时间!');
          alert("Please input the right validity time in the YYYY.MM.DD format!");
          fm.searchvalue.focus();
          return;
        }
      }
      fm.submit();
    }

 function searchCatalog(){
   var dlgLeft = event.screenX;
   var dlgTop = event.screenY;
   var result =  window.showModalDialog("treeDlg.html",window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+dlgLeft+";dialogTop:"+dlgTop+";dialogHeight:350px;dialogWidth:350px");
   if(result){
     var name = getRingLibName(result);
     document.inputForm.ringlib.value=result;
     document.inputForm.ringcatalog.value=name;
     searchRing('');
   }
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
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="checkRing.jsp">
<input type="hidden" name="ringindex" value="">
<input type="hidden" name="operflag" value="<%= operflag %>">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="reasontext" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="ringlib" value="0">
<input type="hidden" name="mediatype" value="">
<input type="hidden" name="ringid" value="">
<table border="0" align="center" height="450" cellspacing="0" cellpadding="0" class="table-style2">
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
<tr valign="center">
<td width="100%" colspan="2">
      <table border="0" align="center" cellspacing="1" cellpadding="1" width="80%" class="table-style2">
        <tr>
          <td height="26" colspan="6" align="center" class="text-title"  valign="center" background="image/n-9.gif">System <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> audit</td>
        </tr>
         <tr></tr>
		    <tr>
          <td width="10"></td>
			<td>
            Select type
            <select size="1" name="searchkey" class="select-style5"  onchange="modeChange();" style="width:150px">
              <option value="ringlabel"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></option>
              <option value="ringauthor"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></option>
			  <%if(issupportmultipleprice == 1){%>
              <option value="ringfee2"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Daily  price(<%=minorcurrency%>)</option>
			  <%}%>
			   <option value="ringfee"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%><%if(issupportmultipleprice == 1){%> Monthly <%}%> price (<%=minorcurrency%>)</option>
              <option value="sp"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider</option>
              <option value="validdate"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> validity</option>
              <option value="uploadtime">Upload time</option>
			<!--  <option value="mediatype">Mediatype</option>-->
            </select>
          </td>
          <td id="id_keyshow" style="display:none" >Keyword
          <input   size="10" type="text" name="searchvalue" value="<%= searchvalue %>" maxlength="30" class="input-style7" style="width:80px">
          </td>
          <td id="id_spshow" style="display:none">
	    <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider
	    <select name="spindex" class="input-style1"  >
             <option value=0 >All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider </option>
               <%
          	    for (int i = 0; i < spInfo.size(); i++) {
                HashMap map1 = (HashMap)spInfo.get(i);
				String spdex = (String)map1.get("spindex");
                   if (spindex2.equals(spdex))
                     out.println("<option value= " + (String)map1.get("spindex") + " selected >" + (String)map1.get("spname") + "</option>");
				else
                     out.println("<option value="+(String)map1.get("spindex") + ">" + (String)map1.get("spname") + "</option>");
                }
               %>
               </select>
               </td>


                <td id="id_dateshow"  style="display:none">
	    Date type
	    <select name="validtype"  size="1" class="input-style1"  style="width:90px">
              <%if(validtype.equals("0")){%>
              <option value=0 selected="selected"> Date before</option>
              <option value=1> Current day</option>
              <option value=2>Date after</option>
              <%}else if(validtype.equals("1")){%>
              <option value=0> Date before</option>
              <option value=1 selected="selected"> Current day</option>
              <option value=2> Date after</option>
              <%}else if(validtype.equals("2")){%>
              <option value=0> Date before</option>
              <option value=1> Current day</option>
              <option value=2 selected="selected">Date after</option>
              <%}%>
            </select>
               </td>
          <td><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category
              <input type="text" name="ringcatalog" readonly value="All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category" maxlength="20" class="input-style7"  onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()" >
                 </td>
          <td><img src="../button/search.gif" alt="Search ringtone" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing('')"></td>
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

<script language="javascript">
   if ('<%= searchkey %>' != '-1')
      document.inputForm.searchkey.value = '<%= searchkey %>';
</script>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td width=40% align="right">
            <select name="ringlist" size="12" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectRing()">
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i %>"><%= (String)hash.get("ringlabel") %></option>
<%
            }
%>
            </select>
          </td>
          <td width="60%"  align="center">
              <table border="0"  cellspacing="1" cellpadding="1" class="table-style2" align="center">
               <tr>
                 <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category</td>
                 <td height="22"><input type="text" name="usernumber" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right">SP</td>
                 <td height="22">
                 <select name="spindex2" disabled class="input-style1">
                    <option value="0"><%= jName %></option>
<%
            for (int i = 0; i < spInfo.size(); i++) {
                HashMap map1  = (HashMap)spInfo.get(i);
%>
                    <option value="<%= (String)map1.get("spindex") %>"><%= (String)map1.get("spname") %></option>
<%
                    }
%>
                 </select>
                 </td>
               </tr>
               <tr>
                 <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" " +zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
                 <td height="22"><input type="text" name="ringlabel" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></td>
                 <td height="22"><input type="text" name="ringauthor" disabled style="input-style1"></td>
               </tr>
                 <%
          String typeDisplay = "none";
         if("1".equals(useringsource)){
           typeDisplay = "";
                }
                %>
                <tr style="display:<%= typeDisplay %>" >
                  <td height="22" align="right"><%=ringsourcename%></td>
                  <td height="22"><input type="text" name="ringsource" disabled style="input-style1"></td>
                </tr>
                <%if(issupportmultipleprice == 1){%>
				 <tr>
                 <td height="22" align="right">Daily Price (<%=minorcurrency%>)</td>
                 <td height="22"><input type="text" name="ringfee2" disabled style="input-style1"></td>
               </tr>
               <%}%>

               <tr>
                 <td height="22" align="right"><%if(issupportmultipleprice == 1){%>Monthly<%}%> Price (<%=minorcurrency%>)</td>
                 <td height="22"><input type="text" name="ringfee" disabled style="input-style1"></td>
               </tr>
               <%if(("1").equals(uservalidday)){%>
                              <tr>
                 <td height="22" align="right">User validity(day)</td>
                 <td height="22"><input type="text" name="uservalidday" disabled style="input-style1"></td>
               </tr>
             <%} %>
               <tr>
                 <td height="22" align="right">Copyright validity</td>
                 <td height="22"><input type="text" name="validdate" disabled style="input-style1"></td>
               </tr>
               <%
               String mediatypeDisplay = "";
               if((ismultimedia==0)&&(imageup==0))
               {
                 mediatypeDisplay = "none";
               }
               %>
                <tr style="display:<%= mediatypeDisplay %>">
                 <td height="22" align="right">Mediatype</td>
                 <td height="22"><input type="text" name="mediaTypeStr" disabled style="input-style1"></td>
               </tr>
               <% String typeDisplay1 = "none";
               if("1".equals(suiyi))
               typeDisplay1 = "";
               %>
                 <tr style="display:<%= typeDisplay1 %>">
          <td align="right">If random <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="50%"><input type="radio" checked name="isfreewill" disabled value="0">No</td>
                <td width="50%"><input type="radio" name="isfreewill" disabled  value="1">Yess</td>
              </tr>
            </table>
          </td>
        </tr>

          <tr id="ring_long" style="display:none">
          <td align="right">Random <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(Second)</td>
          <td><input type="text" name="ringlong" value="" maxlength="4" class="input-style1"></td>
        <tr>
               <tr>
                <td height="22" align="right">Refuse type</td>
                <td>
                <table border="0" width="100%" class="table-style2">
                <tr align="center">
                  <td width="50%"><input type="radio" checked name="ischeck" value="0" onclick="OnRadioCheck()" checked >Select</td>
                  <td width="50%"><input type="radio" name="ischeck" value="1" onclick="OnRadioCheck()" >Input</td>
                 </tr>
                 </table>
                 </td>
               </tr>
               <tr>
                   <td height="22" align="right">Reason of refuse</td>
                   <td height="22" style='display:block' id="id_select" >
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
                  <td height="22" style="display:none" id="id_text" ><input type="text" name="reason" maxlength="100" value="" style="input-style1"></td>
                 </tr>
             <%
             String pretonedisplay ="none";
             if(ifpretone.equals("1"))
             {
              pretonedisplay ="block";
             }
             %>
                 <tr style="display:<%=pretonedisplay%>" align="center">
                  <td width="50%" align="right">Has pretone</td>
                  <td width="50%" align="left"><input type="radio" name="checkpretone" disabled="disabled" value="1">Yes
                     &nbsp;&nbsp;&nbsp;&nbsp;             <input type="radio" name="checkpretone" disabled="disabled" value="0">No</td>
                 </tr>

                 </table>
           </td>
           </tr>
         <tr>
          <td align="center" colspan=2 height=40>
            <table border="0" width="85%" class="table-style2" align="center">
              <tr >
                <td width="20%" align="center" ><input style="width:150px" type='button'  value="Preview" onclick="javascript:tryListen()"> </td>
                <td width="20%" align="center" ><input style="width:150px" type='button'  name="checkpass1" value="Content pass"     onclick="javascript:checkpass(1)"></td>
                <td width="20%" align="center" ><input style="width:150px" type='button'  name="checkpass2" value="Content refused"  onclick="javascript:checkpass(2)"></td>
              </tr>
              <tr>
                <td width="20%" align="center" ><input style="width:150px" type='button'  name="checkpass3" value="Charge passed" onclick="javascript:checkpass(3)"></td>
                <td width="20%" align="center" ><input style="width:150px" type='button'  name="checkpass4" value="Charge refused" onclick="javascript:checkpass(4)"></td>
                <td width="20%" align="center" ><input style="width:150px" type='button'  name="checkpass5" value="Refuse" onclick="javascript:checkBack()"></td>
              </tr>

              <tr style="display:<%=pretonedisplay%>">
                <td colspan="3" width="20%" align="left" ><input style="width:150px" type='button' name="pretonebutton"  value="Preview pretone" onclick="javascript:tryListenPreTone()""></td>
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
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
              <%

                   }

        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in verifying system ringtones!");//系统铃音审核过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + "Error occurred in verifying system ringtones!");//系统铃音审核出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="checkRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

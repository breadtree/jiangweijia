<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SpManage" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ page import="zxyw50.*" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Manage gift bag</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
   //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
    String giftbag   = CrbtUtil.getConfig("giftname","giftbag");
int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13

String musicgrpoper = CrbtUtil.getConfig("musicgrpoper","1");
String sysringgrpcheck ="0";
String musicprice = CrbtUtil.getConfig("musicprice","0");
String musicringnum = CrbtUtil.getConfig("musicringnum","0");
String sysTime = "";
Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
String operID = (String)session.getAttribute("OPERID");
String operName = (String)session.getAttribute("OPERNAME");
Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
String SpModSysRingGrpPrice =(String)application.getAttribute("SpModSysRingGrpPrice")==null?"0":(String)application.getAttribute("SpModSysRingGrpPrice");

String spIndex = (String)session.getAttribute("SPINDEX");
String spCode = (String)session.getAttribute("SPCODE");

String extra_giftbaginfo  = CrbtUtil.getConfig("extra_giftbaginfo","0");
String giftbagalias1  = CrbtUtil.getConfig("giftbagalias1","0");
String giftbagalias2  = CrbtUtil.getConfig("giftbagalias2","0");
String sLangLabel1 = CrbtUtil.getConfig("langlabel1","Arabic");
String sLangLabel2 = CrbtUtil.getConfig("langlabel2","French");

session.removeAttribute("RINGGROUP");
session.removeAttribute("GROUPLABEL");
String d1="0",d2="0",d3="0";
HashMap opmap = new HashMap();


	boolean bAuth = (purviewList.get("10-8")==null)?false:true;
   if( bAuth)
   {
    	//大礼包需要判断配置文件中ifShowGiftBag,避免直接URL访问大礼包功能
    	String ifShowGiftBag = CrbtUtil.getConfig("ifShowGiftBag","1");
    	if(!"1".equals(ifShowGiftBag))
    		bAuth = false;
   }
   

try {
  SpManage sysring = new SpManage();
  manSysPara syspara = new manSysPara();
  sysTime = sysring.getSysTime() + "--";
  if (operID != null && bAuth ) {
    HashMap map2 = new HashMap();
    map2 = syspara.getSysRingGrpParaInfo();
    if(map2!=null){
      d1=map2.get("d1")==null?"0":(String)map2.get("d1");
      d2=map2.get("d2")==null?"0":(String)map2.get("d2");
      d3=map2.get("d3")==null?"0":(String)map2.get("d3");
    }
    ArrayList list  = new ArrayList();
    HashMap map1 = new HashMap();
    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
    String grouplabel = request.getParameter("grouplabel") == null ? "" : transferString((String)request.getParameter("grouplabel")).trim();
    if(checkLen(grouplabel,40))
            	throw new Exception("The name of gift bag is too long,please re-enter!");//您输入的大礼包名称超过长度限制,请您重新输入!

    String ringcnt = request.getParameter("ringcnt") == null ? "0" : transferString((String)request.getParameter("ringcnt")).trim();
    if(ringcnt.trim().equals(""))
      ringcnt = "0";
    if(musicringnum.trim().equalsIgnoreCase("1"))
      ringcnt = d2 ;
    String ringfee = request.getParameter("ringfee") == null ? "0" : transferString((String)request.getParameter("ringfee")).trim();
    String isshow  = request.getParameter("isshow") == null ? "0" : transferString((String)request.getParameter("isshow")).trim();
    if(isshow.trim().equals(""))
      isshow = "0";
    String validdate = request.getParameter("validdate")==null?"":(String)request.getParameter("validdate");
    String ringgroup = request.getParameter("ringgroup") == null ? "" : transferString((String)request.getParameter("ringgroup")).trim();
            String description = request.getParameter("description") == null ? "" : transferString((String)request.getParameter("description")).trim();
    String title = "";
    String opcode = request.getParameter("opcode") == null ? "" : transferString((String)request.getParameter("opcode")).trim();
    String grplabelAlias1 = request.getParameter("grplabelAlias1") == null ? "" : transferString((String)request.getParameter("grplabelAlias1")).trim();
    String grplabelAlias2 = request.getParameter("grplabelAlias2") == null ? "" : transferString((String)request.getParameter("grplabelAlias2")).trim();          	
	String funcid = request.getParameter("funcid") == null ? "" : transferString((String)request.getParameter("funcid")).trim();          	
	
    ArrayList rList = new ArrayList();
    int  optype = 0;
    if (op.equals("add")){
      isshow = "1";
      optype = 0;
      opcode = "1";
                title = "Add gift bag:"+grouplabel;
    }
    if (op.equals("edit")){
      optype = 2;
	  if(funcid == null || funcid.equals("")){
            opcode = "4";
		  }
	  else{
      opcode = "3";
		  }
                title = "Edit gift bag:"+grouplabel;
    }
    else if (op.equals("del")) {
      optype = 1;
      opcode = "2";
      title = "Delete gift bag:"+grouplabel;
    }else if(op.equals("publish")){
      optype = 3;
      title = "Issue gift bag:"+grouplabel;
    }
    if(!op.equals("")){
      map1.put("spcode",spCode);
      map1.put("grouplabel",grouplabel);
      map1.put("ringcnt",ringcnt);
      map1.put("ringfee",ringfee);
      map1.put("isshow",isshow);
      map1.put("validdate",validdate );
      map1.put("ringgroup",ringgroup);
                map1.put("description",description);
      int ischeckop = 0 ,grpcheck=0;
      ischeckop = sysring.getSpOperischeck(spIndex);
      grpcheck = sysring.getMusiccheckStatus(spIndex,ringgroup);
      if(ischeckop>0&&grpcheck>0)
      sysringgrpcheck = "1";
       //增加大礼包
      if(optype==0){
        rList=sysring.addNewSysRingGroup(2,map1);
      }else if(optype==1){//删除大礼包
        if(sysringgrpcheck.equalsIgnoreCase("0")){
          rList=sysring.delSysRingGroup(ringgroup);
        }else{
          String mess="";
          manSysRing manring = new manSysRing();
          ArrayList ls = null;
          Hashtable tmp = null;
          opmap.put("operid",spIndex);
          opmap.put("opername",operName);
          opmap.put("opertype","101");
          opmap.put("status","0");
          opmap.put("ringid","");
          opmap.put("operdesc","");
          opmap.put("refusecomment","");
          opmap.put("ringfee",ringfee);
          opmap.put("ringlabel",grouplabel);
          opmap.put("singgername","");
          opmap.put("validdate",validdate);
          opmap.put("ringspell","");
          opmap.put("uservalidday","0");
          opmap.put("ringgroup",ringgroup);
          opmap.put("ringidnew","");
          opmap.put("ringcnt",ringcnt);
          ls = manring.addoperCheck(opmap);
          rList = ls ;
          for(int i=0;i<ls.size();i++){
            tmp = (Hashtable)ls.get(i);
            if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
              mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
          }
          if(mess.trim().equalsIgnoreCase(""))
            mess = "Insert approval data successfully";
          else
            mess = "Insert approval data,SCP failure:("+mess+")";
%>
<script language="JavaScript">
<%if(!mess.trim().equalsIgnoreCase("")){%>
window.alert('<%=mess%>');
<%}%>
window.returnValue = "yes";
</script>
<%
}
}else if(optype==2) //修改大礼包
{
  if(sysringgrpcheck.equalsIgnoreCase("0")){
    rList=sysring.modSysRingGroup(map1);
  }else{
    String mess="";
    manSysRing manring = new manSysRing();
    ArrayList ls = null;
    Hashtable tmp = null;
    opmap.put("operid",spIndex);
    opmap.put("opername",operName);
    opmap.put("opertype","100");
    opmap.put("status","0");
    opmap.put("ringid","");
    opmap.put("operdesc","");
    opmap.put("refusecomment","");
    opmap.put("ringfee",ringfee);
    opmap.put("ringlabel",grouplabel);
    opmap.put("singgername","");
    opmap.put("validdate",validdate);
    opmap.put("ringspell","");
    opmap.put("uservalidday","0");
    opmap.put("ringgroup",ringgroup);
    opmap.put("ringidnew","");
    opmap.put("ringcnt",ringcnt);
    opmap.put("isshow",isshow);
    ls = manring.addoperCheck(opmap);
    rList = ls;
    for(int i=0;i<ls.size();i++){
      tmp = (Hashtable)ls.get(i);
      if(!"0".equalsIgnoreCase(tmp.get("result").toString().trim()))
        mess+=tmp.get("scp").toString().trim()+"-"+tmp.get("reason").toString().trim()+" ";
    }
    if(mess.trim().equalsIgnoreCase(""))
      mess = "Insert approval data successfully";
    else
      mess = "Insert approval data,SCP failure:("+mess+")";
%>
<script language="JavaScript">
<%if(!mess.trim().equalsIgnoreCase("")){%>
window.alert('<%=mess%>');
<%}%>
window.returnValue = "yes";
</script>
<%
}
}else if(optype==3){
  rList = sysring.publishRingGroup(ringgroup);
}

if(getResultFlag(rList)){
  // 准备写操作员日志
  zxyw50.Purview purview = new zxyw50.Purview();
  HashMap map = new HashMap();
  map.put("OPERID",operID);
  map.put("OPERNAME",operName);
  map.put("OPERTYPE","1008");
  map.put("RESULT","1");
  map.put("PARA1",ringgroup);
  map.put("PARA2",grouplabel);
  map.put("PARA3",ringcnt);
                  map.put("PARA4","ip:"+request.getRemoteAddr());
  map.put("DESCRIPTION",title);
  purview.writeLog(map);
  
  if("1".equals(extra_giftbaginfo) && !("".equals(opcode))){
	if("1".equals(opcode)){
		ringgroup = (String)rList.get(1);
	   }
	if("4".equals(opcode)){
		opcode ="1";
	   }
	  HashMap mapAlias = new HashMap();
	  mapAlias.put("ringgroup",ringgroup);
	  mapAlias.put("grplabelAlias1",grplabelAlias1);
	  mapAlias.put("grplabelAlias2",grplabelAlias2);
	  mapAlias.put("opcode",opcode);
	  mapAlias.put("opflag","7");
	  mapAlias.put("grouplabel",grouplabel);
	  rList =sysring.updateMBJukeAliasInfo(mapAlias);
}
}

if(rList.size()>0){
  session.setAttribute("rList",rList);
%>
<form name="resultForm" method="post" action="result.jsp">
  <input type="hidden" name="historyURL" value="giftbag.jsp">
    <input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
<%if(sysringgrpcheck.equalsIgnoreCase("0")){%>
document.resultForm.submit();
<%}%>
</script>
</form>
<%
  }
}
//返回所有大礼包
 if(("1").equals(extra_giftbaginfo))
   {
      HashMap mapInfo = new HashMap();
	  mapInfo.put("spindex",spIndex);
	  mapInfo.put("type","2");
	  mapInfo.put("functype","7");
      list = sysring.getSysRingGroup(mapInfo);
    }else
	{
list = sysring.getSysRingGroup(spIndex,2);
    }
%>
<script language="javascript">
   var v_ringgroup = new Array(<%= list.size() + "" %>);
   var v_grouplabel = new Array(<%= list.size() + "" %>);
   v_ringcnt = new Array(<%= list.size() + "" %>);
   var v_ringfee = new Array(<%= list.size() + "" %>);
   var v_isshow = new Array(<%= list.size() + "" %>);
   var v_validdate = new Array(<%= list.size() + "" %>);
   var v_updatetime = new Array(<%= list.size() + "" %>);
   var v_description = new Array(<%= list.size() + "" %>)
   var v_ischeck = new Array(<%= list.size() + "" %>);
   var v_alias1  = new Array(<%= list.size() + "" %>);
   var v_alias2  = new Array(<%= list.size() + "" %>);
   var v_funcid  = new Array(<%= list.size() + "" %>);
<%
            for (int i = 0; i < list.size(); i++) {
                map1 = (HashMap)list.get(i);
          	String modifytime=((String)map1.get("modifytime")).trim();
          	String addtime=((String)map1.get("addtime")).trim();
          	String deletetime=((String)map1.get("deletetime")).trim();
          	if(modifytime.compareTo(addtime)<0)modifytime=addtime;
          	if(modifytime.compareTo(deletetime)<0)modifytime=deletetime;
%>
   v_ringgroup[<%= i + "" %>] = '<%= (String)map1.get("ringgroup") %>';
   v_grouplabel[<%= i + "" %>] = '<%= (String)map1.get("grouplabel") %>';
   v_ringcnt[<%= i + "" %>] = '<%= (String)map1.get("ringcnt") %>';
   v_ringfee[<%= i + "" %>] = '<%= (String)map1.get("ringfee") %>';
   v_isshow[<%= i + "" %>] = '<%= (String)map1.get("isshow") %>';
   v_validdate[<%= i + "" %>] = '<%= (String)map1.get("validdate") %>';
   v_updatetime[<%= i + "" %>] = '<%= modifytime %>';
   v_description[<%= i + "" %>] = "<%= JspUtil.convert((String)map1.get("description"))%>";
   v_ischeck[<%= i + "" %>] = '<%= (String)map1.get("ischeck") %>';
   v_alias1[<%= i + "" %>] = "<%= (String)map1.get("alias1")%>";
   v_alias2[<%= i + "" %>] = '<%= (String)map1.get("alias2") %>';
    v_funcid[<%= i + "" %>] = '<%= (String)map1.get("funcid") %>';
<%
            }
%>



   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.grouplabel.value = v_grouplabel[index];
      //fm.isshow[v_isshow[index]].checked = true;
      fm.isshow.value=v_isshow[index];
      if(trim(v_isshow[index])=='1')
        fm.isshow1.innerText='Yes';
      else
        fm.isshow1.innerText='No';
      fm.ringfee.value = v_ringfee[index];
      <%if(SpModSysRingGrpPrice.equals("0")){%>
        fm.ringfee.readOnly=true;
      <%}%>
      fm.ringgroup.value = v_ringgroup[index];
      fm.ringcnt.value = v_ringcnt[index];
      fm.validdate.value = v_validdate[index];
      fm.updatetime.value= v_updatetime[index];
      fm.description.value = v_description[index];
      fm.icheck.value=v_ischeck[index];
      if('<%=extra_giftbaginfo%>' == 1){
	 if('<%= giftbagalias1 %>' == 1)
	    fm.grplabelAlias1.value = v_alias1[index];
	 if('<%= giftbagalias2 %>' == 1)
	    fm.grplabelAlias2.value = v_alias2[index];
	  }
      fm.grouplabel.focus();
   }
  function mpublish()
  {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select <%=giftbag%> you want to issues.");
          return;
      }
      if(trim(fm.icheck.value)!='3')
      {
          alert("You can't issues <%=giftbag%> again.");
          return;
      }
      fm.op.value = 'publish';
      fm.submit();
  }
   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.grouplabel.value) == '') {
         alert("Please enter the name of <%=giftbag%>.");
         fm.grouplabel.focus();
         return flag;
      }
      if (!CheckInputStr(fm.grouplabel,'name of <%=giftbag%>')){
         fm.grouplabel.focus();
         return flag;
      }
      if (!CheckInputStr(fm.description,'description')){
         fm.description.focus();
         return flag;
      }
  <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.grouplabel.value,40)){
            alert("The <%=giftbag%> name should not exceed 40 bytes!");
             fm.grouplabel.focus();
            return;
          }
        <%
        }
        %>
<%if(!musicringnum.trim().equalsIgnoreCase("1")){%>
      if (! checkfee(trim(fm.ringcnt.value))) {
         alert("The number of ringtone in <%=giftbag%> is not correct!");
         fm.ringcnt.focus();
         return;
      }
<%}%>
      <%//if(musicringnum.trim().equalsIgnoreCase("0")
         //&&(!d2.trim().equalsIgnoreCase("0")||!d3.trim().equalsIgnoreCase("0"))){%>
         //var maxNum = <%//=d2.trim()%>;
         //var minNum = <%//=d3.trim()%>;
         //var curNum = trim(fm.ringcnt.value);
         //if(eval(curNum+'-'+minNum)<0||eval(curNum+'-'+maxNum)>0)
         //{
         //alert("The ringtone number in the <%=giftbag%> should be between'+minNum+'-'+maxNum+'!");
         //fm.ringcnt.focus();
         //return;
         //}
      <%//}%>
      if (! checkfee(trim(fm.ringfee.value))) {
         alert("The price of <%=giftbag%> is wrong!");
         fm.ringfee.focus();
         return;
      }
      <%if(!"0".equalsIgnoreCase(d1.trim())){%>
         var maxPrice = <%=d1.trim()%>;
         var curPrice = trim(fm.ringfee.value);
         if(eval(maxPrice+'-'+curPrice)<0)
         {
           alert("The <%=giftbag%> price surpasses the system upper limit!");
           fm.ringfee.focus();
           return ;
         }
      <%}%>
      <%if("1".equalsIgnoreCase(musicprice.trim())){%>
          var vprice = trim(fm.ringfee.value);
          if(vprice%50!=0||vprice==0)
          {
            alert("The <%=giftbag%> price should be 50 multiples");
            fm.ringfee.focus();
            return;
          }
      <%}%>
   	var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert("Please enter the validate of <%=giftbag%>!");
          fm.validdate.focus();
          return ;
      }
      if(!checkDate2(validdate)){
          alert("The validate is not correct,please re-enter!");
          fm.validdate.focus();
          return ;
      }
      if(checktrue2(validdate)){
          alert("The validate can not be earlier than current date,please re-enter!");
          fm.validdate.focus();
          return ;
      }
      var description=trim(fm.description.value);
       <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(description,50)){
            alert("It is too long the <%=giftbag%> description you input, please input again!");
            fm.description.focus();
            return;
          }
        <%
        }
        else{
        %>
        if(strlength(description)>50){
          alert("It is too long the <%=giftbag%> description you input, please input again!");
          fm.description.focus();
          return;
        }
     <%}%>
      flag = true;
      return flag;
   }



	function checkfee (fee) {
   	  if(fee.length==0)
			return false;
      var tmp = '';
      for (i = 0; i < fee.length; i++) {
         tmp = fee.substring(i, i + 1);
         if (tmp < '0' || tmp > '9')
            return false;
      }
      return true;
   }

   function checkName () {
      var fm = document.inputForm;
      var code = trim(fm.grouplabel.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_grouplabel.length; i++)
           if (code == v_grouplabel[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_grouplabel.length; i++)
           if (code == v_grouplabel[i] && i!=index)
             return true;
      }
	  else if(optype=='del')
	  	return true;
      return false;
   }


   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      if (checkName()) {
         alert("The name of <%=giftbag%> want to add already exist!");
         fm.grouplabel.focus();
         return;
      }
      fm.submit();
   }

   function editInfo () {
     var fm = document.inputForm;
      <%if("0".equalsIgnoreCase(musicgrpoper.trim())){%>
         if(trim(fm.icheck.value)=='2')
         {
           alert("Cannot modify the <%=giftbag%> which already verified passes!");
           return;
         }
      <%}%>
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the <%=giftbag%> first!");
          return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      if (checkName()) {
         alert("The name of <%=giftbag%> already existes!");
         fm.grouplabel.focus();
         return;
      }
	  if('<%=extra_giftbaginfo%>' == 1){
	     if(v_funcid[index]=='' || v_funcid[index]==null) {
	       fm.funcid.value="";
	      }else {
	     fm.funcid.value= v_funcid[index];
	     }
	  }
	  
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      <%if("0".equalsIgnoreCase(musicgrpoper.trim())){%>
         if(trim(fm.icheck.value)=='2')
         {
           alert("Cannot delete the <%=giftbag%> which already verified passes!");
           return;
         }
      <%}%>
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the <%=giftbag%> to delete!");
          return;
      }
     if (confirm("Are you sure to delete this <%=giftbag%>?") == 0)
     	 return;
     fm.op.value = 'del';
     fm.submit();
   }

	function memberInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the <%=giftbag%> to manage!");
          return;
      }
   document.location.href = 'giftbagMember.jsp?ringgroup='+v_ringgroup[index]+'&grouplabel='+v_grouplabel[index];
   }
   
   function f_c(){
   		var ss = document.inputForm.description.value;
     	var ii= ss.length;
     	if(ii>50)
     	{
       		alert('The allowed length is only 50 characters!');
       		document.inputForm.description.value = ss.substring(0,49);
     	}

  	}
   
   

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="giftbag.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="ringgroup" value="">
<input type="hidden" name="icheck" value="0">
<input type="hidden" name="ringcnt" value="0">
  <input type="hidden" name="isshow" value="">
   <input type="hidden" name="funcid" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Manage <%=giftbag%></td>
        </tr>
        <tr>
          <td rowspan=9>
            <select name="infoList" size="10" <%= list.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < list.size(); i++) {
                    map1 = (HashMap)list.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)map1.get("grouplabel") %></option>
<%
            }
%>
            </select>
           </td>
           <td align="right">Name of <%=giftbag%></td>
           <td><input type="text" name="grouplabel" value="" maxlength="40" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.areaname,'integer')"></td>
         </tr>
         <!--
         <tr >
            <td align="right">Numbers in <%=giftbag%></td>
            <td><input type="text" name="ringcnt" value="" maxlength="20" class="input-style1" <%=musicringnum.trim().equalsIgnoreCase("1")?"readonly":""%>></td>
         </tr>
         -->
		 <!--Added to support jukebox alias name -->
		 <%
		    if("1".equals(extra_giftbaginfo)){
		 %>
		       <% 
			       if("1".equals(giftbagalias1)){
		        %>
		           <tr>
		              <td align="right"><%=sLangLabel1+" "+giftbag%> name</td>
			          <td align="left"><input type="text" name="grplabelAlias1" value="" class="input-style1"></td>
		           </tr>
			   <%  }
			  if("1".equals(giftbagalias2)){
			   %>
			        <tr>
			           <td align="right"><%=sLangLabel2+" "+giftbag%> name</td>
				       <td align="left"><input type="text" name="grplabelAlias2" value=""  class="input-style1"></td>
			        </tr>
                <%
		            }
		    }
		 %>
		 <!-- ENDS -->
         <tr>
            <td align="right">Price(<%=minorcurrency%>)</td>
            <td><input type="text" name="ringfee" value="" maxlength="9" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.outprefix,'integer')"></td>
         </tr>
        <tr style="display:block">
            <td align="right">If show</td>
            <td><input type="text" name="isshow1" value="" readonly class="input-style1"/>
                    <!--
                    <td width="50%"><input type="radio" name="isshow" value="0" >No</td>
                    <td width="50%"><input type="radio" name="isshow" value="1" checked >Yes</td>
                      -->
            </td>
         </tr>
        <tr>
          <td align="right">Validity(yyyy.mm.dd)</td>
          <td><input type="text" name="validdate" value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Update Time(yyyy.mm.dd)</td>
          <td><input type="text" name="updatetime" readOnly value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Description</td>
          <td><textarea name="description" class="input-style1" rows="2"  onkeydown="f_c()"></textarea></td>
        </tr>

         <tr>
            <td colspan="2">
            <table border="0" width="100%" class="table-style2">
            <tr>
                 <td width="35%" align="center"><img src="../manager/button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                 <td width="35%" align="center"><img src="../manager/button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                 <td width="30%" align="center"><img src="../manager/button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
            </tr>
            <tr>     
                 <td width="35%" align="center"><img src="../manager/button/member.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:memberInfo()"></td>
                 <td width="35%" align="center"><img src="../manager/button/publish.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:mpublish()"></td>
                 <td width="30%" align="center"><img src="../manager/button/again.gif" onmouseover="this.style.cursor='hand'" onclick="window.location.href='giftbag.jsp'"></td><!--javascript:document.inputForm.reset()-->
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
                   alert( "Sorry,you have no right to access this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in managing gift bag!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Errors occurred in managing gift bag!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="giftbag.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

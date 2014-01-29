<%@page import="java.util.HashMap"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Hashtable"%>
<%@page import="zxyw50.manSysRing"%>
<%@page import="zxyw50.CrbtUtil"%>
<%@page import="java.io.*"%>
<%@include file="../pubfun/JavaFun.jsp"%>

<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
  public String getAllindex(String libid,List data)throws Exception {
    if("0".equals(libid))
       return "0";
       for(int i=0;i<data.size();i++){
         Map table = (Map)data.get(i);
         if(libid.equals(table.get("ringlibid")))
            return (String)table.get("allindex");
       }
       return libid;
  }
  public String display(HashMap map) throws Exception {
    try {
      String str = (String) map.get("cataindex");
      for (; str.length() < 4; )
        str += "-";
      return str + (String) map.get("description");
    }
    catch (Exception e) {
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data
    }
  }
%>
<html>
<head>
<title>Classified indexes management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT></head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">
<%
  //add by gequanmin 2005-07-05
  String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
  //add end
  String sysTime = "";
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  String ringcatalog = CrbtUtil.getConfig("ringcatalog", "0");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  try {
    manSysRing sysring = new manSysRing();
    sysTime = sysring.getSysTime() + "--";
    if (operID != null && purviewList.get("2-7") != null) {
      HashMap map = new HashMap();
      HashMap map1 = new HashMap();
      String op = request.getParameter("op") == null ? "" : transferString((String) request.getParameter("op")).trim();
      String allindex = request.getParameter("allindex") == null ? "" : transferString((String) request.getParameter("allindex")).trim();
      String cataindex = request.getParameter("cataindex") == null ? "" : transferString((String) request.getParameter("cataindex")).trim();
      String cataindextwo = request.getParameter("cataindextwo") == null ? "" : transferString((String) request.getParameter("cataindextwo")).trim();
      if(cataindextwo == null || cataindextwo.equals("")) cataindextwo = "0";
      String cataindexthree = request.getParameter("cataindexthree") == null ? "" : transferString((String) request.getParameter("cataindexthree")).trim();
      if(cataindexthree == null || cataindexthree.equals("")) cataindexthree = "0";
      String oldallindex = request.getParameter("oldallindex") == null ? "" : transferString((String) request.getParameter("oldallindex")).trim();
      String libid = request.getParameter("ringlib") == null ? "0" : (String) request.getParameter("ringlib");
      int optype = 0;
      // 准备写操作员日志
      zxyw50.Purview purview = new zxyw50.Purview();
      map.put("OPERID", operID);
      map.put("OPERNAME", operName);
      map.put("HOSTNAME", request.getRemoteAddr());
      map.put("SERVICEKEY", sysring.getSerkey());
      map.put("OPERTYPE", "28");
      map.put("RESULT", "1");
      map.put("PARA1","ip:"+request.getRemoteAddr());
      ArrayList rList = new ArrayList();
      String title = "";
      if (op.equals("add")) {
        optype = 1;
                title = "Add classified indexes";//增加分类索引
                map.put("DESCRIPTION","Add classified indexes " + allindex+",Serial number is"+cataindex);//增加分类索引  ,序号为
      }
      else if (op.equals("edit")) {
        optype = 2;
                 title = "Edit classified indexes";//Edit分类索引
                map.put("DESCRIPTION","Edit classified indexes" + allindex+",Serial number is"+cataindex);//Edit分类索引 ,序号为
      }
      else if (op.equals("del")) {
        allindex = oldallindex;
                 title = "Delete category index";//删除分类索引
        optype = 3;
                map.put("DESCRIPTION"," Delete category index " + allindex+",Serial number is"+cataindex);//删除分类索引
      }
      if (optype > 0) {
        map1.put("optype", optype + "");
        map1.put("allindex", allindex);
        map1.put("cataindex", cataindex);
        map1.put("ringid", "");
        if ("1".equals(ringcatalog)) {
        map1.put("rsubindex", "0");
        map1.put("thirdindex", "0");
        }
        if ("3".equals(ringcatalog)) {
          map1.put("rsubindex", cataindextwo);
          map1.put("thirdindex", "0");
        }
        if ("5".equals(ringcatalog)) {
          map1.put("rsubindex", cataindextwo);
          map1.put("thirdindex", cataindexthree);
        }
        map1.put("oldrsubindex", "0");
        map1.put("thirdindexold", "0");
        rList = sysring.setCatalogIndex(map1);
        purview.writeLog(map);
        if (rList.size() > 0) {
          session.setAttribute("rList", rList);
%>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="catalogIndex.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script></form>
<%
  }
  }
      ArrayList lstRingCatalog = sysring.getRingCatalogIndex();
 // ArrayList lstCatalog = sysring.getCatalogRoot();
%>
<script language="javascript">
   var v_allindex = new Array(<%= lstRingCatalog.size() + "" %>);
   var v_cataindex = new Array(<%= lstRingCatalog.size() + "" %>);
   var v_description = new Array(<%= lstRingCatalog.size() + "" %>);
   var v_rsubindex = new Array(<%= lstRingCatalog.size() + "" %>);
   var v_thirdindex = new Array(<%= lstRingCatalog.size() + "" %>);
<%
            for (int i = 0; i < lstRingCatalog.size(); i++) {
                map = (HashMap)lstRingCatalog.get(i);
%>
   v_allindex[<%= i + "" %>] = '<%= (String)map.get("allindex") %>';
   v_cataindex[<%= i + "" %>] = '<%= (String)map.get("cataindex") %>';
   v_description[<%= i + "" %>] = '<%= (String)map.get("description") %>';
   v_rsubindex[<%= i + "" %>] = '<%= (String)map.get("rsubindex") %>';
   v_thirdindex[<%= i + "" %>] = '<%= (String)map.get("thirdindex") %>';
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
      var value = v_allindex[index];
      fm.allindex.value = v_allindex[index];
      var len = fm.allindex.length;
      var flag = 0;
      if("3" == <%= ringcatalog %>){
        if(value==fm.allindex.value){
          flag = 1;
        }
        //var temp = v_cataindex[index];
        fm.oldallindex.value = v_allindex[index];
        fm.cataindex.value = v_cataindex[index];
        fm.cataindextwo.value = v_rsubindex[index];
        fm.allindextext.value = v_description[index];
      }
      else if("5" == <%= ringcatalog %>){
        if(value==fm.allindex.value){
          flag = 1;
        }
        //var temp = v_cataindex[index];
        fm.oldallindex.value = v_allindex[index];
        fm.cataindex.value = v_cataindex[index];
        fm.cataindextwo.value = v_rsubindex[index];
        fm.cataindexthree.value = v_thirdindex[index];
        fm.allindextext.value = v_description[index];
      }
      else{
        for(var i=0;i<len;i++){
          if(value==fm.allindex.options[i].value){
            flag =1;
            break;
          }
        }
        if(flag==0)
          i = 0;
        fm.allindex.selectedIndex = i;
        fm.cataindex.value = v_cataindex[index];
        fm.oldallindex.value = v_allindex[index];
      }

      if(flag==0)
      onbtnStat(2);
      else
      onbtnStat(1);

   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.allindex.value) == '') {
         alert('Please select a category of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>!');//请选择铃音分类!
         return flag;
      }
      var value = trim(fm.cataindex.value);
      if(value==''){
         alert("Please enter a category serial number!");//请输入分类序号
         fm.cataindex.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
          alert('The category serial number must be a digital number!');//分类序号必须是数字
          fm.cataindex.focus();
          return flag;
        }
      if(value > 9) {
          alert('The category serial number cannot be larger than 9!');
          fm.cataindex.focus();
          return flag;
        }

        if("3" == <%= ringcatalog %>){
        if(trim(fm.cataindextwo.value) == '0') {
          //alert('小类序号不能输入为0!');
          alert('The sub category serial number cannot be 0!');
          fm.cataindextwo.focus();
          return flag;
        }
        if (!checkstring('0123456789',trim(fm.cataindextwo.value) )) {
          //alert('小类序号必须是数字!');
          alert('The sub category serial number must be digital!');
          fm.cataindextwo.focus();
          return flag;
        }
        if(trim(fm.cataindextwo.value) > 9) {
          //alert('小类序号不能大于9!');
          alert('The sub category serial number cannot be larger than 9!');
          fm.cataindextwo.focus();
          return flag;
        }
      }
      if("5" == <%= ringcatalog %>){
        // 二级
        if(trim(fm.cataindextwo.value) == '0') {
          //alert('小类序号不能输入为0!');
          alert('The second class category serial number cannot be 0!');
          fm.cataindextwo.focus();
          return flag;
        }
        if (!checkstring('0123456789',trim(fm.cataindextwo.value)) ){
          //alert('小类序号必须是数字!');
          alert('The second class category serial number must be digital!');
          fm.cataindextwo.focus();
          return flag;
        }
        if(trim(fm.cataindextwo.value) > 9) {
          //alert('小类序号不能大于9!');
          alert('The second class category serial number cannot be larger than 9!');
          fm.cataindextwo.focus();
          return flag;
        }
        // 三级
         if(trim(fm.cataindexthree.value) == '0') {
          //alert('小类序号不能输入为0!');
          alert('The third class category serial number cannot be 0!');
          fm.cataindexthree.focus();
          return flag;
        }
        if (!checkstring('0123456789',trim(fm.cataindexthree.value))) {
          //alert('小类序号必须是数字!');
          alert('The third class category serial number must be digital!');
          fm.cataindexthree.focus();
          return flag;
        }
        if(trim(fm.cataindexthree.value) > 9) {
          //alert('小类序号不能大于9!');
          alert('The third class category serial number cannot be larger than 9!');
          fm.cataindexthree.focus();
          return flag;
        }
      }

      flag = true;
      return flag;
   }

   function checkCode () {
      var fm = document.inputForm;
      var code = trim(fm.cataindex.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_cataindex.length; i++)
           if (code == v_cataindex[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_cataindex.length; i++)
           if (code == v_cataindex[i] && i!=index)
             return true;
      }
      return false;
   }
   function checkIndex () {
      var fm = document.inputForm;
      var code = trim(fm.allindex.value);
      var optype = fm.op.value;
      if(optype=='add')
        for (i = 0; i < v_allindex.length; i++){
             if (code == v_allindex[i])
               return true;
        }
      return false;
   }

   function addInfo () {
      var fm = document.inputForm;
      if(fm.allindex.length<=1){
         alert("Sorry. You must configure <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> categories first!");//对不起,您必须先配置铃音分类!//
         return;
      }
      if(fm.allindex.value=='')
         fm.allindex.selectedIndex = 1;
      fm.op.value = 'add';
      onbtnStat(3);
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(fm.allindex.length<=1){
         alert("Sorry. You must configure <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> categories first!");//对不起,您必须先配置铃音分类!
         return;
      }
      if(index == -1){
          alert("Please select the category index to be edited!");//请选择您要Edit的分类索引
          return;
      }
      if(fm.allindex.value==''){
         alert("Sorry. This category no longer exists. Please delete the category index!");//对不起,分类已经不存在,请删除该分类索引!
         return;
      }
      fm.op.value = 'edit';
      onbtnStat(4);
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the category index to be deleted");//请选择您删除的分类索引
          return;
      }
     fm.op.value = 'del';
     onbtnStat(6);
     fm.submit();
   }

   function Confirm(){
     var fm = document.inputForm;
     if (! checkInfo()){
         return;
     }
     if(checkIndex()){
         alert('This <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category has been configured with an index');//
         return;
     }
      if("1" == <%= ringcatalog %>){
     if (checkCode()) {
         alert('Category index already exists!');//分类索引已经存在
         fm.cataindex.focus();
         return;
             }
      }
     onbtnStat(6);
     fm.submit();
   }

   function Cancel(){
      var fm = document.inputForm;
      selectInfo();
      if(fm.infoList.selectedIndex ==-1)
        onbtnStat(5);
    }

   function onbtnStat(stat){
     var fm  = document.inputForm;
     if(stat==0){  //初始化
        fm.allindex.disabled = true;
        fm.allindextext.disabled = true;
        fm.cataindex.disabled = true;
        fm.cataindextwo.disabled = true;
        fm.cataindexthree.disabled = true;

        fm.btnAdd.disabled = false;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = true;
        fm.btnConfirm.disabled = true;
        fm.btnCancel.disabled = true;
     }
     else if(stat==1){ //选中某条记录
        fm.allindex.disabled = true;
        fm.allindextext.disabled = true;
        fm.cataindex.disabled = true;
        fm.cataindextwo.disabled = true;
        fm.cataindexthree.disabled = true;

        fm.btnAdd.disabled = false;
        fm.btnEdit.disabled = false;
        fm.btnDelete.disabled = false;
        fm.btnConfirm.disabled = true;
        fm.btnCancel.disabled = true;
     }
     else if(stat==2){ //选中某记录但该分类已经不存在
        fm.allindex.disabled = true;
        fm.allindextext.disabled = true;
        fm.cataindex.disabled = true;
        fm.cataindextwo.disabled = true;
        fm.cataindexthree.disabled = true;

        fm.btnAdd.disabled = false;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = false;
        fm.btnConfirm.disabled = true;
        fm.btnCancel.disabled = true;
     }
     else if(stat==3){ //点击新增
        fm.allindex.disabled = false;
        fm.allindextext.disabled = false;
        fm.cataindex.disabled = false;
        fm.cataindextwo.disabled = false;
        fm.cataindexthree.disabled = false;

        fm.btnAdd.disabled = true;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = true;
        fm.btnConfirm.disabled = false;
        fm.btnCancel.disabled = false;
     }
     else if(stat==4){ //点击Edit
        fm.allindex.disabled = true;
        fm.allindextext.disabled = true;
        fm.cataindex.disabled = false;
        fm.cataindextwo.disabled = false;
        fm.cataindexthree.disabled = false;

        fm.btnAdd.disabled = true;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = true;
        fm.btnConfirm.disabled = false;
        fm.btnCancel.disabled = false;
     }
     else if(stat==5){ //取消
        fm.allindex.disabled = true;
        fm.allindextext.disabled = true;
        fm.cataindex.disabled = true;
        fm.cataindextwo.disabled = true;
        fm.cataindexthree.disabled = true;

        fm.btnAdd.disabled = false;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = true;
        fm.btnConfirm.disabled = true;
        fm.btnCancel.disabled = true;
     }
     else if(stat==6){ //确定
        fm.allindex.disabled = false;
        fm.allindextext.disabled = false;
        fm.cataindex.disabled = false;
        fm.cataindextwo.disabled = false;
        fm.cataindexthree.disabled = false;
     }
   }

   function initform(fm){
      onbtnStat(0);
   }


</script><script language="JavaScript">
 var datasource;
function searchCatalog(){
     var dlgLeft = event.screenX;
     var dlgTop = event.screenY;
     var result =  window.showModalDialog("treeDlg.html",window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+dlgLeft+";dialogTop:"+dlgTop+";dialogHeight:250px;dialogWidth:215px");
     //alert(result);
     if(result){
         var name = getRingLibName(result);
//         alert("qw");
         document.inputForm.allindextext.value=name;
         //     alert(name);
         document.inputForm.allindex.value=result;
         //searchRing('');
     }
 }
 function getRingLibName(id){
     for(var i = 0;i<datasource.length;i++){
        var row =  datasource[i];
        if(row[0] == id)
           return row[2];
     }
     return "All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Catalog";
 }
</script><script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script><form name="inputForm" method="post" action="catalogIndex.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldallindex" value="">
<input type="hidden" name="ringlib" value="<%= libid %>">
<%Vector ringLib = sysring.getRingLibraryInfo();%>
<script language="JavaScript">
  //modify by gequanmin 2005-07-05
   <%if("1".equals(usedefaultringlib)){%>
   datasource = new Array(<%=ringLib.size()+2%>);
   <%}else{%>
   datasource = new Array(<%=ringLib.size()+1%>);
  <%}%>
  var root = new Array("0","-1","All <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Catalog","0");
  datasource[0] = root;
   <%if("1".equals(usedefaultringlib)){%>
  root = new Array("503","0","the default <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library","1");
  datasource[1] = root;
  <%
   for(int i = 0;i<ringLib.size();i++){
      Hashtable table = (Hashtable)ringLib.get(i);%>
      var data = new Array('<%=(String)table.get("allindex")%>','<%=getAllindex(((String)table.get("parentidnex")),ringLib)%>','<%=(String)table.get("ringliblabel")%>','1');
      datasource[<%=i+2%>] = data;
  <%}}else{
    for(int j= 0;j<ringLib.size();j++){
      Hashtable table = (Hashtable)ringLib.get(j);
    %>
      var data = new Array('<%=(String)table.get("allindex")%>','<%=getAllindex(((String)table.get("parentidnex")),ringLib)%>','<%=(String)table.get("ringliblabel")%>','1');
      datasource[<%=j+1%>] = data;
    <%}}%>
  </script>
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Classified indexes management</td>
        </tr>
        <tr>
          <td rowspan="3">
            <select name="infoList" size="10" class="input-style1" onclick="javascript:selectInfo()" style="width:200">
            <%
              for (int i = 0; i < lstRingCatalog.size(); i++) {
                map = (HashMap) lstRingCatalog.get(i);
            %>
              <option value="<%= i + "" %>"><%= display(map) %>              </option>
            <%}            %>
            </select>
          </td>
        <%if ("1".equals(ringcatalog)) {        %>
          <td align="right" width="35%"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Category</td>
          <td>
          <input type="hidden" name="allindex" value="">
          <input type="text" name="allindextext" readonly value="Total <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Category" maxlength="20" class="input-style7" onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()">
          </td>
        </tr>
        <tr>
          <td align="right">Category serial number</td>
          <td>
            <input type="text" name="cataindex" value="" maxlength="2" class="input-style1">
            <input type="hidden" value="nodata" name="cataindextwo">
            <input type="hidden" value="nodata" name="cataindexthree">
          </td>
        </tr>
      <%} if ("3".equals(ringcatalog)) {      %>
        <td align="right" width="35%"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Category</td>
        <td>
          <input type="hidden" name="allindex" value="">
          <input type="hidden" value="nodata" name="cataindexthree">
          <input type="text" name="allindextext" readonly value="Total <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Category" maxlength="20" class="input-style7" onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()">
        </td>


  </tr>
  <tr>
    <td colspan="2">
    <table class="table-style2" width="100%">
    <tr>
    <td align="right" width="35%">Root category serial number</td>
    <td><input type="text" name="cataindex" value="" maxlength="2" size="3"></td>
  </tr>
  <tr>
    <td align="right">Sub category serial number</td>
    <td><input type="text" name="cataindextwo" value="" maxlength="2" size="3"></td>
  </tr>
    </table>
    </td>
  </tr>

 <%} if ("5".equals(ringcatalog)) {      %>
        <td align="right" width="35%"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Category</td>
        <td>
          <input type="hidden" name="allindex" value="">
          <input type="text" name="allindextext" readonly value="Total <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Category" maxlength="20" class="input-style7" onmouseover="this.style.cursor='hand'" onclick="javascript:searchCatalog()">
        </td>
  </tr>
  <tr>
    <td colspan="2">
    <table class="table-style2" width="100%">
    <tr>
    <td align="right" width="35%">Root category serial number</td>
    <td><input type="text" name="cataindex" value="" maxlength="2" size="3"></td>
  </tr>
  <tr>
    <td align="right">Second class category serial number</td>
    <td><input type="text" name="cataindextwo" value="" maxlength="2" size="3"></td>
  </tr>
  <tr>
    <td align="right">Third class category serial number</td>
    <td><input type="text" name="cataindexthree" value="" maxlength="2" size="3"></td>
  </tr>
    </table>
    </td>
  </tr>
<%}%>
  <tr>
    <td colspan="2">
      <table border="0" width="100%" class="table-style2">
        <tr align="center">
          <td width="20%" align="center">
            <input type="button" value='Add' name="btnAdd" onclick="javascript:addInfo()">
          </td>
          <td width="20%" align="center">
            <input type="button" value='Mod' name="btnEdit" onclick="javascript:editInfo()">
          </td>
          <td width="20%" align="center">
            <input type="button" value='Del' name="btnDelete" onclick="javascript:delInfo()">
          </td>
          <td width="20%" align="center">
            <input type="button" value='Confirm' name="btnConfirm" onclick="javascript:Confirm()">
          </td>
          <td width="20%" align="center">
            <input type="button" value='Cancel' name="btnCancel" onclick="javascript:Cancel()">
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
         <td  style="color: #FF0000" colspan=3 height=50> Notes: The category serial number must be an integer</td>
       </tr>
      </table>
    </td>
  </tr>
</table>
</td></tr></table></form>
<%
  } else {
    if (operID == null) {
%>
<script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script><%} else {%>
<script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//You have no access to this function!");
              </script><%
  }
  }
  } catch (Exception e) {
    Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in managing category indexes");//sub category index management过程出现异常
    sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing category indexes!");//sub category index management过程出现错误
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="catalogIndex.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script><%}%>
</body>
</html>

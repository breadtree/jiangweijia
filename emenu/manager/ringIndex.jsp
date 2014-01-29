<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
     public String display (HashMap map) throws Exception {
        try {
            String str = (String)map.get("rsubindex");
            for (; str.length() < 4; )
                str += "-";
            return str + (String)map.get("ringid");
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
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="initform(document.forms[0])">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing manring = new manSysRing();
        sysTime = manring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-7") != null) {
            HashMap map = new HashMap();
            HashMap map1= new HashMap();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String allindex = request.getParameter("allindex") == null ? "" : transferString((String)request.getParameter("allindex")).trim();
            String cataindex = request.getParameter("cataindex") == null ? "" : transferString((String)request.getParameter("cataindex")).trim();
            String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
            String rsubindex = request.getParameter("rsubindex") == null ? "" : transferString((String)request.getParameter("rsubindex")).trim();

            String oldallindex = request.getParameter("cataloglist") == null ? "" : transferString((String)request.getParameter("cataloglist")).trim();
            String oldrsubindex = request.getParameter("oldrsubindex") == null ? "" : transferString((String)request.getParameter("oldrsubindex")).trim();
            String oldringid = request.getParameter("oldringid") == null ? "" : transferString((String)request.getParameter("oldringid")).trim();
            int optype = 0;
            ArrayList rList = new ArrayList();
            String  title = "";
            if (op.equals("add")){
                optype = 11;
                oldrsubindex = "0";
                oldallindex = allindex;
                title = "Add classified indexes";//增加分类索引
            }
            else if (op.equals("edit")) {
                allindex = oldallindex;
                oldallindex = allindex;
                optype = 12;
                title = "Edit classified indexes";//Edit分类索引
              }
            else if (op.equals("del")) {
                optype = 13;
                allindex = oldallindex;
                ringid = oldringid;
                rsubindex = oldrsubindex;
                oldrsubindex = "0";
                title = "Delete classified index";//删除分类索引
             }
            if(optype>0){
               map1.put("optype",optype+"");
               map1.put("allindex",allindex);
               map1.put("cataindex",cataindex);
               map1.put("ringid",ringid);
               map1.put("rsubindex",rsubindex);
               map1.put("oldrsubindex",oldrsubindex);
               rList = manring.setCatalogIndex(map1);
             if(optype>0 && getResultFlag(rList)){
               // 准备写操作员日志
               zxyw50.Purview purview = new zxyw50.Purview();
               map = new HashMap();
               map.put("OPERID",operID);
               map.put("OPERNAME",operName);
               map.put("OPERTYPE","206");
               map.put("RESULT","1");
               map.put("PARA1",ringid);
               map.put("PARA2",rsubindex);
               map.put("PARA3",oldrsubindex);
               map.put("PARA4","ip:"+request.getRemoteAddr());
               map.put("DESCRIPTION",title);
            }
               if(rList.size()>0){
                session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="ringIndex.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
            }
            ArrayList  lstRingCatalog = manring.getRingCatalogIndex();
            ArrayList  lstCatalog = manring.getCatalogRoot();
            ArrayList  lstCatalogItem = new ArrayList();
            String firstallindex = "";
            if(lstRingCatalog.size()>0 ){
               map = (HashMap)lstRingCatalog.get(0);
               String temp = (String)map.get("allindex");
               if(temp!=null && !temp.equals(""))
                  firstallindex = temp;
            }
            if(oldallindex.equals(""))
                oldallindex = firstallindex;
            if(!oldallindex.equals("")){
               lstCatalogItem = manring.getRingCatalogRingIndex(oldallindex);
            }
            if(lstCatalogItem.size() == 0 && optype==13 && !firstallindex.equals("")){
                 lstCatalogItem = manring.getRingCatalogRingIndex(firstallindex);
            }
           //System.out.println("oldallindex2="+oldallindex);
%>
<script language="javascript">
   var v_cataindex = new Array(<%= lstCatalogItem.size() + "" %>);
   var v_ringid = new Array(<%= lstCatalogItem.size() + "" %>);
   var v_rsubindex = new Array(<%= lstCatalogItem.size() + "" %>);
<%
            for (int i = 0; i < lstCatalogItem.size(); i++) {
                map = (HashMap)lstCatalogItem.get(i);
%>
   v_cataindex[<%= i + "" %>] = '<%= (String)map.get("cataindex") %>';
   v_ringid[<%= i + "" %>] = '<%= (String)map.get("ringid") %>';
   v_rsubindex[<%= i + "" %>] = '<%= (String)map.get("rsubindex") %>';
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
      fm.cataindex.value = v_cataindex[index];
      fm.ringid.value = v_ringid[index];
      fm.rsubindex.value = v_rsubindex[index];
      fm.oldrsubindex.value =v_rsubindex[index];
      fm.oldringid.value = v_ringid[index];
      if(fm.allindex.value=='')
         onbtnStat(2);
      else
         onbtnStat(1);
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.allindex.value) == '') {
         alert('Please select the correct <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category!');//请选择正确的铃音分类
         return flag;
      }
      var value = trim(fm.cataindex.value);
      if(value==''){
         alert("Please enter the category serial number!");//请输入分类序号
         fm.cataindex.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The category serial number must be a digital number!');//分类序号必须是数字
         fm.areacode.focus();
         return flag;
      }
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please enter the ringtone code!");//请输入Ringtone code
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The Ringtone code must be a digital number!');//Ringtone code必须是数字
         fm.ringid.focus();
         return flag;
      }
      var value = trim(fm.rsubindex.value);
      if(value==''){
         alert("Please enter the serial number of a ringtone!");//请输入铃音序号
         fm.rsubindex.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The Ringtone No. must be a digital number!');//铃音序号必须是数字
         fm.rsubindex.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function checkCode () {
      var fm = document.inputForm;
      var code = trim(fm.rsubindex.value);
      var optype = fm.op.value;
      if(optype=='add'){
        if(fm.allindex.value == fm.cataloglist.value){
          for (i = 0; i < v_rsubindex.length; i++)
            if (code == v_rsubindex[i])
              return true;
        }
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_rsubindex.length; i++)
           if (code == v_rsubindex[i] && i!=index)
             return true;
      }
      return false;
   }

   function addInfo () {
      var fm = document.inputForm;
      if(fm.allindex.length<=1){
         alert("Sorry. You must configure ringtone categories first!");//对不起,您必须先配置铃音分类!
         return;
      }
      if(fm.allindex.selectedIndex==0 && fm.allindex.length>0)
         fm.allindex.selectedIndex=1;
      fm.op.value = 'add';
      onbtnStat(3);
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(fm.allindex.length<=1){
         alert("Sorry. You must configure ringtone categories first!");//对不起,您必须先配置铃音分类!
         return;
      }
      if(index == -1){
          alert("Please select the category index to be edited");//请选择您要Edit的分类铃音索引
          return;
      }
      if(fm.allindex.value==''){
         alert("Sorry. This category no longer exists. Please delete the category index!");//对不起,分类已经不存在,请删除该分类铃音索引!
         return;
      }
      fm.op.value = 'edit';
      onbtnStat(4);
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the category index to be deleted");//请选择您删除的分类铃音索引
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
     if (checkCode()) {
         alert('This ringtone serial number already exists!');//铃音序号已经存在
         fm.cataindex.focus();
         return;
     }
     onbtnStat(6);
     fm.submit();
   }

   function Cancel(){
      var fm = document.inputForm;
      selectInfo();
      changeIndex();
      if(fm.infoList.selectedIndex ==-1)
        onbtnStat(5);
    }

   function onCatalogChange(){
     var fm = document.inputForm;
     fm.op.value = '';
     fm.submit();
   }

   function initform(fm){
      var temp = "<%= oldallindex %>";
      if(temp!=''){
        var len = fm.cataloglist.length;
        for(var i=0; i<len; i++){
          if(fm.cataloglist.options[i].value==temp){
             fm.cataloglist.selectedIndex = i;
             break;
          }
        }
        len  = fm.allindex.length;
        for(var i=0; i<len; i++){
          if(fm.allindex.options[i].value==temp){
             fm.allindex.selectedIndex = i;
             break;
          }
        }
      }
      fm.allindex.disabled = true;
      fm.cataindex.disabled = true;
      onbtnStat(0);
   }

   function changeIndex(){
        var fm = document.inputForm;
        if(fm.cataloglist.length==0)
           return;
        var value = fm.cataloglist.value;
        var len  = fm.allindex.length;
        var flag = 0;
        for(var i=0; i<len; i++){
          if(fm.allindex.options[i].value==value){
             fm.allindex.selectedIndex = i;
             flag = 1;
             break;
          }
        }
        if(flag==0)
          fm.allindex.selectedIndex = 0;
   }

   function onbtnStat(stat){
     var fm  = document.inputForm;
     if(stat==0){  //初始化
        fm.allindex.disabled = true;
        fm.cataindex.disabled = true;
        fm.ringid.disabled = true;
        fm.rsubindex.disabled = true;

        fm.btnAdd.disabled = false;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = true;
        fm.btnConfirm.disabled = true;
        fm.btnCancel.disabled = true;
     }
     else if(stat==1){ //选中某条记录
        fm.allindex.disabled = true;
        fm.cataindex.disabled = true;
        fm.ringid.disabled = true;
        fm.rsubindex.disabled = true;

        fm.btnAdd.disabled = false;
        fm.btnEdit.disabled = false;
        fm.btnDelete.disabled = false;
        fm.btnConfirm.disabled = true;
        fm.btnCancel.disabled = true;
     }
     else if(stat==2){ //选中某记录但该分类已经不存在
        fm.allindex.disabled = true;
        fm.cataindex.disabled = true;
        fm.ringid.disabled = true;
        fm.rsubindex.disabled = true;

        fm.btnAdd.disabled = false;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = false;
        fm.btnConfirm.disabled = true;
        fm.btnCancel.disabled = true;
     }
     else if(stat==3){ //点击新增
        fm.allindex.disabled = false;
        fm.cataindex.disabled = false;
        fm.ringid.disabled = false;
        fm.rsubindex.disabled = false;

        fm.btnAdd.disabled = true;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = true;
        fm.btnConfirm.disabled = false;
        fm.btnCancel.disabled = false;
     }
     else if(stat==4){ //点击Edit
        fm.allindex.disabled = true;
        fm.cataindex.disabled = true;
        fm.ringid.disabled = false;
        fm.rsubindex.disabled = false;

        fm.btnAdd.disabled = true;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = true;
        fm.btnConfirm.disabled = false;
        fm.btnCancel.disabled = false;
     }
     else if(stat==5){ //取消
        fm.allindex.disabled = true;
        fm.cataindex.disabled = true;
        fm.ringid.disabled = true;
        fm.rsubindex.disabled = true;

        fm.btnAdd.disabled = false;
        fm.btnEdit.disabled = true;
        fm.btnDelete.disabled = true;
        fm.btnConfirm.disabled = true;
        fm.btnCancel.disabled = true;
     }
     else if(stat==6){ //确定
        fm.allindex.disabled = false;
        fm.cataindex.disabled = false;
        fm.ringid.disabled = false;
        fm.rsubindex.disabled = false;
     }
   }


</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="ringIndex.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldringid" value="">
<input type="hidden" name="oldrsubindex" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Classified indexes management</td>
        </tr>
        <td>
             <table width="100%" border=0  class="table-style2">
             <tr>
             <td  width="110" align="right">Select category index</td>
             <td width="122">
             <select name="cataloglist" size="1" onchange="javascript:onCatalogChange()" style="width:120px">
            <%
                for (int i = 0; i < lstRingCatalog.size(); i++) {
                    map = (HashMap)lstRingCatalog.get(i);
            %>
              <option value="<%= (String)map.get("allindex") %>"><%= (String)map.get("description")  %></option>
            <%
             }
            %>
            </select>
             </select>
             </td>
             </tr>
             <tr>
             <td colspan=2 align="center">
             <select name="infoList" size="6" <%= lstCatalogItem.size() == 0 ? "disabled " : "" %> style="width:200px" onclick="javascript:selectInfo()">
             <%
                for (int i = 0; i < lstCatalogItem.size(); i++) {
                    map = (HashMap)lstCatalogItem.get(i);
                    out.println("<option value="+Integer.toString(i)+" >" +display(map)+" </option>");
              }
             %>
             </select>
             </td>
             </tr>
             </table>
        </td>
        <td >
            <table width="100%" border =0 class="table-style2">
            <tr>
            <td  width="30%"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> category</td>
            <td  width="70%">
             <select  name="allindex" size="1" class="input-style1" style="width:150"  >
             <option value ="" >This category no longer exists </option>
             <%
                 for(int i=0; i<lstCatalog.size(); i++){
                             map = (HashMap)lstCatalog.get(i);
             %>
                <option value="<%= (String)map.get("allindex") %>"><%= (String)map.get("ringliblabel")  %></option>
             <%
              }
             %>
             </select>
            </td>
            </tr>
            <tr>
             <td >Category serial number</td>
             <td><input type="text" name="cataindex" value="" maxlength="2" class="input-style1"  ></td>
            </tr>
            <tr>
             <td >Ringtone code</td>
             <td><input type="text" name="ringid" value="" maxlength="20" class="input-style1"  ></td>
            </tr>
            <tr>
             <td >Ringtone serial number</td>
             <td><input type="text" name="rsubindex" value="" maxlength="2" class="input-style1"  ></td>
            </tr>
            <tr>
            <td colspan="2">
              <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="20%" align="center"><input type="button" value='Add' name="btnAdd" onclick="javascript:addInfo()"></td>
                <td width="20%" align="center"><input type="button" value='Modify' name="btnEdit" onclick="javascript:editInfo()"></td>
                <td width="20%" align="center"><input type="button" value='Delete' name="btnDelete" onclick="javascript:delInfo()"></td>
                <td width="20%" align="center"><input type="button" value='OK' name="btnConfirm" onclick="javascript:Confirm()"></td>
                <td width="20%" align="center"><input type="button" value='Cancel' name="btnCancel" onclick="javascript:Cancel()"></td>
              </tr>
              </table>
            </td>
            </tr>
            </table>
     </td>
     </tr>
     <tr>
         <td  style="color: #FF0000" colspan=2 height=50> Notes:Category Serial Number and Ringtone Serial Number are integers, while Ringtone Code is a digital string.</td>
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
                    alert( "Please log in first!");//Please log in to the system
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing category indexes!");//sub category index management过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing category indexes!");//sub category index management过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringIndex.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

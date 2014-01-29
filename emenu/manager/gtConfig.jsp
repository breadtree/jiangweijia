<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.zxywpub.*" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Area code management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-11") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            ArrayList rList  = new ArrayList();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String mscgt = request.getParameter("mscgt") == null ? "" : transferString((String)request.getParameter("mscgt")).trim();
            String mscname = request.getParameter("mscname") == null ? "" : transferString((String)request.getParameter("mscname")).trim();
            if(checkLen(mscname,40))
            	throw new Exception("The length of the MSC name you entered has exceeded the limit. Please re-enter!");//您输入的MSC名称长度超出限制,请重新输入!
            String oldmscgt = request.getParameter("oldmscgt") == null ? "" : transferString((String)request.getParameter("oldmscgt")).trim();

            int  optype =0;
            String title = "";
            String desc = "";
            if (op.equals("add")) {
                optype = 1;
                oldmscgt = mscgt;
                desc  = operName + "Add MSCGT constraints";//增加MSCGT限制"
                title = "Add MSCGT constraints " + mscgt;
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + "Edit MSCGT constraints";//EditMSCGT限制
                title = "Edit MSCGT constraints " + mscgt;
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + "Delete MSCGT constraints";//删除MSCGT限制
                title = "Delete MSCGT constraints " + mscgt;
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("newmscgt",mscgt);
                hash.put("oldmscgt",oldmscgt);
                hash.put("mscname",mscname);
                rList = syspara.setMscGt(hash);
                sysInfo.add(sysTime + desc);

                if(getResultFlag(rList)){
                  // 准备写操作员日志
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","313");
                  map.put("RESULT","1");
                  map.put("PARA1",oldmscgt);
                  map.put("PARA2",mscgt);
                  map.put("PARA3",mscname);
                  map.put("PARA4","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",title);
                  purview.writeLog(map);
                }

                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="gtConfig.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }

            vet = syspara.getMSCGTInfo();
%>
<script language="javascript">
   var v_mscgt = new Array(<%= vet.size() + "" %>);
   var v_mscname = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_mscgt[<%= i + "" %>] = '<%= (String)hash.get("mscgt") %>';
   v_mscname[<%= i + "" %>] = '<%= (String)hash.get("mscname") %>';
<%
            }
%>


   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if (index == -1 || index >= fm.infoList.length)
           return;
      fm.mscgt.value = v_mscgt[index];
      fm.oldmscgt.value = v_mscgt[index];
      fm.mscname.value = v_mscname[index];
      fm.mscgt.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.mscgt.value) == '') {
         alert('Please enter a MSC GT code!');//请输入MSC GT码!
         fm.mscgt.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.mscgt.value))) {
         alert('The MSC GT code must be a digital number. Please re-enter!');//MSC GT码必须是数字,请重新输入!
         fm.mscgt.focus();
         return flag;
      }
      if (trim(fm.mscname.value) == '') {
         alert('Please enter a MSC name!');
         fm.mscname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.mscname,'MSC name')){
         fm.mscname.focus();
         return  flag;
      }
      flag = true;
      return flag;
   }

   function checkCode () {
      var fm = document.inputForm;
      var code = trim(fm.mscgt.value);
      var optype  = fm.op.value;
      if(optype == "add"){
         for (i = 0; i < v_mscgt.length; i++)
            if (code == v_mscgt[i])
               return true;
      } else if(optype == "edit"){
        var index = fm.infoList.selectedIndex;
        for (i = 0; i < v_mscgt.length; i++)
              if (code == v_mscgt[i] && index !=i)
                 return true;
      }
      return false;
   }

   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      if (checkCode()) {
         alert('The MSC GT code to be added already exists!');//要增加的MSC GT码已经存在!
         fm.mscgt.focus();
         return;
      }
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      if(fm.infoList.length == 0){
          alert('Sorry. No MSC GT constraint can be modified!');//对不起,没有任何MSC GT限制可供修改!
          return false;
      }
      if(fm.infoList.selectedIndex == -1){
          alert('Please select the MSC GT constraint to be modified!');//请选择您要修改的MSC GT限制!
          return false;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      if (checkCode()) {
         alert('The MSC GT code constraint to be modified already exists!');//要修改的MSC GT码限制已经存在!
         fm.mscgt.focus();
         return;
      }
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      if(fm.infoList.length == 0){
          alert('Sorry. No MSC GT constraint can be deleted!');//对不起,没有任何MSC GT限制可供删除!
          return false;
      }
      if(fm.infoList.selectedIndex == -1){
          alert('Please select the MSC GT constraint to be deleted!');//请选择您要删除的MSC GT限制!
          return false;
      }
      fm.op.value = 'del';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="gtConfig.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldmscgt" value="">
<table width="450" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr background="image/n-9.gif">
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">MSC GT contraints management</td>
        </tr>
        <tr>
          <td rowspan="3">
            <select name="infoList" size="6" <%= vet.size() == 0 ? "disabled " : "" %> style="width:200px" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)hash.get("mscgt") %></option>
<%
            }
%>
            </select>
          </td>
          <td align="right">MSC GT code</td>
          <td><input type="text" name="mscgt" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">MSC name</td>
          <td><input type="text" name="mscname" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="25%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing MSC GT code constraints");//MSC GT码限制管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing MSC GT code constraints");//MSC GT码限制管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="gtConfig.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

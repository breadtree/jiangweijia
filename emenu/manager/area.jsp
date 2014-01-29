<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="com.zte.zxywpub.*" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%!

    public String display (Hashtable hash) throws Exception {
        try {
            String str = (String)hash.get("areacode");
            for (; str.length() < 8; )
                str += "-";
            return str + (String)hash.get("areaname");
        }
        catch (Exception e) {
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data
        }
    }
%>
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
        if (operID != null && purviewList.get("3-4") != null) {
            Vector vet = new Vector();
            ArrayList rList = new ArrayList();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String areacode = request.getParameter("oldareacode") == null ? "" : transferString((String)request.getParameter("oldareacode")).trim();
            String areaname = request.getParameter("areaname") == null ? "" : transferString((String)request.getParameter("areaname")).trim();
            if(checkLen(areaname,20))
            	throw new Exception("The length of the area name you entered has exceeded the limit. Please re-enter!");//您输入的地区名称长度超出限制,请重新输入!
            String newareacode = request.getParameter("areacode") == null ? "" : transferString((String)request.getParameter("areacode")).trim();


            int  optype =0;
            String title = "";
            String desc = "";
            if (op.equals("add")) {
                areacode = newareacode;
                optype = 1;
                desc  = operName + " Add calling service area " + areacode;//增加主叫服务区
                title = "Add calling service area";//增加主叫服务区
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + "Change calling service area"+ areacode;//更改主叫服务区
                title = "Change calling service area";//更改主叫服务区
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + " Delete calling service area " + areacode;//删除主叫服务区
                title = "Delete calling service area";//删除主叫服务区
             }
             if(optype>0){
                hash.put("optype",optype+"");
                hash.put("areacode",areacode);
                hash.put("newareacode",newareacode);
                hash.put("areaname",areaname);
                rList = syspara.setAreaCode(hash);
                sysInfo.add(sysTime + desc);
                if(getResultFlag(rList)){
                   // 准备写操作员日志
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","307");
                  map.put("RESULT","1");
                  map.put("PARA1",areacode);
                  map.put("PARA2",newareacode);
                  map.put("PARA3",areaname);
                  map.put("PARA4","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",title);
                  purview.writeLog(map);
                }
                if(rList.size()>0){
                  session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="area.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }
            vet = syspara.getAreaInfo();
%>
<script language="javascript">
   var v_areacode = new Array(<%= vet.size() + "" %>);
   var v_areaname = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_areacode[<%= i + "" %>] = '<%= (String)hash.get("areacode") %>';
   v_areaname[<%= i + "" %>] = '<%= (String)hash.get("areaname") %>';
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
      fm.areacode.value = v_areacode[index];
      fm.oldareacode.value = v_areacode[index];
      fm.areaname.value = v_areaname[index];
      fm.areacode.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.areacode.value) == '') {
         alert('Please enter an area code!');//请输入地区号
         fm.areacode.focus();
         return flag;
      }
      var value = trim(fm.areacode.value);
      if (!checkstring('0123456789',value)) {
         alert('The area code must be a digital number!');//地区号必须是数字
         fm.areacode.focus();
         return flag;
      }
      if (trim(fm.areaname.value) == '') {
         alert('Please enter an area name!');//请输入地区名
         fm.areaname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.areaname,'Area name')){
         fm.areaname.focus();
         return  flag;
      }
      fm.areacode.value = leftTrimt0(value);
      flag = true;
      return flag;
   }

   function checkCode () {
      var fm = document.inputForm;
      var code = trim(fm.areacode.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_areacode.length; i++)
           if (code == v_areacode[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_areacode.length; i++)
           if (code == v_areacode[i] && i!=index)
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
      if (checkCode()) {
         alert('The area code to be added already exists!');//要增加的地区号已经存在
         fm.areacode.focus();
         return;
      }
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the area code to be edited");//请选择您Edit的地区号
          return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      if (checkCode()) {
         alert('The new area code to be edited already exists!');//您要Edit的新地区号已经存在
         fm.areacode.focus();
         return;
      }
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the area code to be deleted");//请选择您删除的地区号
          return;
      }
     fm.op.value = 'del';
	  if (! checkCode()) {
         alert('The area code to be deleted does not exist');//要删除的地区号不存在
         fm.areacode.focus();
         return;
      }

      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="area.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldareacode" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Calling service area management</td>
        </tr>
        <tr>
          <td rowspan="3">
            <select name="infoList" size="6" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i + "" %>"><%= display(hash) %></option>
<%
            }
%>
            </select>
          </td>
          <td align="right">Area code of calling service area</td>
          <td><input type="text" name="areacode" value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Name of calling service area</td>
          <td><input type="text" name="areaname" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                  <td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>

        <tr>
         <td  style="color: #FF0000" colspan=2 height=50> Note: The first digit of the area code cannot be 0.</td>
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing calling service areas! ");//主叫服务区管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing calling service areas!");//主叫服务区管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="area.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

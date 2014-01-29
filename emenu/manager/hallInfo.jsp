<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="zxyw50.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@include file="../pubfun/JavaFun.jsp"%>

<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page"/>
<html>
<head>
<title>Business hall information management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT></head>
<body background="background.gif" class="body-style1">
<%
  String sysTime = "";
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  try {
    manSysPara syspara = new manSysPara();
    sysTime = syspara.getSysTime() + "--";
    if (operID != null && purviewList.get("3-21") != null) {
      //add by wxq  2005.06.08 for version 3.16.01
      String serviceKey = (String) session.getAttribute("SERVICEKEY");
      ArrayList serviceList = purview.getServiceList(serviceKey);
      String selectedServiceKey = (String) ((HashMap) serviceList.get(0)).get("SERVICEKEY");
      ArrayList paramList = purview.getServiceParamList(selectedServiceKey); // 权限范围列表
      HashMap map = (HashMap) paramList.get(0); //业务区查询参数
      ArrayList paramInfoList = purview.getServiceParamInfo(map);
      //end
      String op = request.getParameter("op") == null ? "" : transferString((String) request.getParameter("op")).trim();
      int optype = 0;
      String serareano = request.getParameter("serareano") == null ? "-1" : transferString((String) request.getParameter("serareano")).trim();
      String hallno = request.getParameter("hallno") == null ? "-1" : (String) request.getParameter("hallno");
      String hallname = request.getParameter("hallname") == null ? "0" : transferString((String) request.getParameter("hallname")).trim();
      String address = request.getParameter("address") == null ? "0" : transferString((String) request.getParameter("address")).trim();
      String zipcode = request.getParameter("zipcode") == null ? "0" : transferString((String) request.getParameter("zipcode")).trim();
      String telephone = request.getParameter("telephone") == null ? "0" : transferString((String) request.getParameter("telephone")).trim();
      String fax = request.getParameter("fax") == null ? "0" : transferString((String) request.getParameter("fax")).trim();
      String e_mail = request.getParameter("e_mail") == null ? "0" : transferString((String) request.getParameter("e_mail")).trim();
      // 准备写操作员日志
      HashMap map1 = new HashMap();
      map = new HashMap();
      String title = "";
      if (op.equals("add")) {
        optype = 1;
        title = "Add business hall";//增加营业厅
      }
      else if (op.equals("edit")) {
        if (!purview.CheckOperatorFunction(session, 3, 15, serareano, "-1", "-1", "-1")) {
          throw new Exception("You have no access to the business hall!");//您无权对该业务区进行操作!
        }
        optype = 3;
        title = "Edit business hall";//Edit营业厅
      }
      else if (op.equals("del")) {
        optype = 2;
        title = "Delete business hall";//删除营业厅
      }
      if (optype > 0) {
        map1.put("optype", optype + "");
        map1.put("serareano", serareano);
        map1.put("hallno", hallno);
        map1.put("hallname", hallname);
        map1.put("address", address);
        map1.put("zipcode", zipcode);
        //保留字段
        map1.put("province","");
        map1.put("telephone",telephone);
        map1.put("fax",fax);
        map1.put("e_mail",e_mail);
        syspara.setSmpHallInfo(map1,optype);

        map.put("OPERID", operID);
        map.put("OPERNAME", operName);
        map.put("OPERTYPE", "321");
        map.put("RESULT", "1");
        map.put("PARA1", serareano);
        map.put("PARA2", hallno);
        map.put("PARA3", hallname);
        map.put("PARA4", address);
        map.put("PARA5", title);
        map.put("PARA6","ip:"+request.getRemoteAddr());
        purview.writeLog(map);
      }
      /*
      Vector vet = syspara.getUserTypeInfo("1");
      String option = "";
      for (int i = 0; i < vet.size(); i++) {
        Hashtable table = (Hashtable) vet.elementAt(i);
        option += "<option value=" + (String) table.get("usertype") + " > " + (String) table.get("utlabel") + " </option>";
      }*/
      ArrayList hallList = new ArrayList();
      hallList = syspara.getHallInfo();
%>
<script language="javascript">
   var v_serareano = new Array(<%= hallList.size() + "" %>);
   var v_hallno = new Array(<%= hallList.size() + "" %>);
   var v_hallname = new Array(<%= hallList.size() + "" %>);
   var v_address = new Array(<%= hallList.size() + "" %>);
   var v_zipcode = new Array(<%= hallList.size() + "" %>);
   var v_telephone = new Array(<%= hallList.size() + "" %>);
   var v_fax = new Array(<%= hallList.size() + "" %>);
   var v_e_mail = new Array(<%= hallList.size() + "" %>);
<%
   for (int i = 0; i < hallList.size(); i++) {
       map = (HashMap)hallList.get(i);
%>
   v_serareano[<%= i + "" %>] = '<%= (String)map.get("serareano") %>';
   v_hallno[<%= i + "" %>] = '<%= (String)map.get("hallno") %>';
   v_hallname[<%= i + "" %>] = '<%= (String)map.get("hallname") %>';
   v_address[<%= i + "" %>] = '<%= ((String)map.get("address")).replaceAll("\\\\","\\\\\\\\").replaceAll("'","\\\\'") %>';
   v_zipcode[<%= i + "" %>] = '<%= (String)map.get("zipcode") %>';
   v_telephone[<%= i + "" %>] = '<%= (String)map.get("telephone") %>';
   v_fax[<%= i + "" %>] = '<%= (String)map.get("fax") %>';
   v_e_mail[<%= i + "" %>] = '<%= (String)map.get("e_mail") %>';
<%
            }
%>
  //限定只能输入数字
  function numbersOnly(field,event){
    var key,keychar;
    if(window.event){
      key = window.event.keyCode;
    }
    else if (event){
      key = event.which;
    }
    else{
      return true
    }
    keychar = String.fromCharCode(key);
    if((key == null) || (key == 0) || (key == 8)|| (key == 9) || (key == 13) || (key == 27)){
      return true;
    }
    else if(('0123456789').indexOf(keychar) > -1){
      return true;
    }
    else {
      alert('Please input a digit!');//请输入数字
      return false;
    }
  }


function selectInfo () {
  var fm = document.inputForm;
  var index = fm.infoList.value;
  if (index == null)
  return;
  if (index == '')
  return;
  fm.serareano.value = v_serareano[index];
  fm.hallno.value = v_hallno[index];
  fm.hallname.value = v_hallname[index];
  fm.address.value= v_address[index];
  fm.zipcode.value= v_zipcode[index];
  fm.telephone.value= v_telephone[index];
  fm.fax.value= v_fax[index];
  fm.e_mail.value= v_e_mail[index];
  fm.hallname.focus();
}

function checkInfo () {
  var fm = document.inputForm;
  var flag = false;
  var value = trim(fm.hallname.value);
  if (value == '') {
    //alert('请输入营业厅名称!');
    alert('Please input the business hall name!');
    fm.hallname.focus();
    return flag;
  }
  if (!CheckInputStr(fm.hallname,'Business hall name')){//营业厅名称
    fm.hallname.focus();
    return flag;
  }
  if(strlength(value)>20){
   // alert('营业厅名称超过规定的20个字节长度!');
    alert('Business hall name cannot be larger than 20 bytes!');
    fm.hallname.focus();
    return flag;
  }
  value = trim(fm.hallno.value);
  if (trim(value) == '') {
  //  alert('请输入该营业厅的编号!');
    alert('Please input the number of business hall!');
    fm.hallno.focus();
    return flag;
  }
  if (!checkstring('0123456789',value)) {
    //alert('营业厅的编号必须是数字!');
    alert('The business hall number must be a digital number!');
    fm.hallno.focus();
    return flag;
  }
  if (value == '0' || value == 0){
   // alert('营业厅的编号不能为0');
    alert('The business  hall number cannot be zone');
    fm.hallno.focus();
    return flag;
  }
  value = trim(fm.telephone.value);
  if (!checkstring('0123456789',value)) {
    //alert('联系电话必须是数字!');
    alert("Telephone number must be a digital number!");
    fm.telephone.focus();
    return flag;
  }
  value = trim(fm.fax.value);
  if (!checkstring('0123456789',value)) {
   // alert('传真必须是数字!');
    alert("The fax must be a digital number!");
    fm.fax.focus();
    return flag;
  }
  value = trim(fm.zipcode.value);
  if (!checkstring('0123456789',value)) {
   // alert('邮编必须是数字!');
    alert('The zip code must be a digital number!');
    fm.zipcode.focus();
    return flag;
  }
  value = trim(fm.address.value);
  if(strlength(value)>20){
   // alert('营业厅地址超过规定的20个字节长度!');
    alert('Business hall address cannot be larger than 20 bytes!');
    fm.address.focus();
    return flag;
  }
  
  //email中不能有单引号
  value = trim(fm.e_mail.value);
  if(value.indexOf('\'') != -1)
  {
  	alert('Email can not contain \' !');
  	fm.e_mail.focus();
  	return flag;
  }
  flag = true;
  return flag;
}

function checkName () {
  var fm = document.inputForm;
  var code = trim(fm.hallname.value);
  var optype = fm.op.value;
  if(optype=='add'){
    for (i = 0; i < v_hallname.length; i++)
    if (code == v_hallname[i])
    return true;
  }
  else if(optype=='edit'){
    var index = fm.infoList.selectedIndex;
    for (i = 0; i < v_hallname.length; i++)
    if (code == v_hallname[i] && i!=index)
    return true;
  }
  return false;
}


function addInfo () {
  var fm = document.inputForm;
  if (! checkInfo())
  return;
  fm.op.value = 'add';
  if (checkName()) {
    //alert('要增加的营业厅名称已经存在!');
    alert('The business hall no you want to add has existed!');
    fm.hallname.focus();
    return;
  }
  fm.submit();
}

function editInfo () {
  var fm = document.inputForm;
  var index = fm.infoList.selectedIndex;
  if(fm.infoList.length==0){
    //alert("没有任何营业厅可供Edit!");
    alert("No any business hall can be edited!");
    return;
  }
  if(index == -1){
   // alert("请选择您Edit的营业厅");
    alert("Please select the business hall you want to edit!");
    return;
  }
  if (! checkInfo())
  return;
  fm.op.value = 'edit';
  if (checkName()) {
    //alert('您要Edit的新营业厅名称已经存在!');
    alert('The new business hall name you want to edit has existed!');
    fm.hallname.focus();
    return;
  }
  fm.submit();
}

function delInfo () {
  var fm = document.inputForm;
  if(fm.infoList.length==0){
    //alert("没有任何营业厅可供删除!");
    alert("No any business hall can be deleted!");
    return;
  }
  var index = fm.infoList.selectedIndex;
  if(index == -1){
   // alert("请选择您删除的营业厅");
    alert('Please select the business hall you want to delete!');
    return;
  }
  fm.op.value = 'del';
  fm.submit();
}

</script><script language="JavaScript">
if(parent.frames.length>0)
  parent.document.all.main.style.height="600";
</script><form name="inputForm" method="post" action="hallInfo.jsp">
<input type="hidden" name="op" value="">
<table width="500" height="400" border="0" align="center" class="table-style2">
  <tr valign="middle">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Business hall management</td>
        </tr>
        <tr>
          <td width="45%" align="right">
            <select name="infoList" size="20" style="width:200px" onclick="javascript:selectInfo()">
            <%
              for (int i = 0; i < hallList.size(); i++) {
                map = (HashMap) hallList.get(i);
                out.println("<option value=" + Integer.toString(i) + ">" + (String) map.get("hallname") + "</option>");
              }
            %>
            </select>
          </td>
          <td width="55%">
            <table width="100%" border=0 class="table-style2">
              <tr height="35">
                <td align="right">Service area name</td>
                <td>
                  <select name="serareano" class="input-style1">
                  <%
                    for (int j = 0; j < paramInfoList.size(); j++) {
                      map = (HashMap) paramInfoList.get(j);
                      String value = (String)map.get("VALUE");
                      if (!value.equals("0")){
                  %>
                    <option value="<%= value %>"><%= (String)map.get("NAME") %>                    </option>
                  <%}
                }%>
                  </select>
                </td>
              </tr>
              <tr height="35">
                <td align="right">Business hall no</td>
                <td>
                  <input type="text" name="hallno" value="" maxlength="4" class="input-style1" onkeypress="return numbersOnly(this);">
                </td>
              </tr>
              <tr height="35">
                <td align="right">Business hall name</td>
                <td>
                  <input type="text" name="hallname" size="1" maxlength="20" class="input-style1">
                </td>
              </tr>
              <tr height="35">
                <td align="right">Address</td>
                <td>
                  <input type="text" name="address" value="" maxlength="20" class="input-style1">
                </td>
              </tr>
              <tr height="35">
                <td align="right">Zip code</td>
                <td>
                  <input type="text" name="zipcode" value="" maxlength="8" class="input-style1" onkeypress="return numbersOnly(this);">
                </td>
              </tr>
              <tr height="35">
                <td align="right">Telephone</td>
                <td>
                  <input type="text" name="telephone" value="" maxlength="20" class="input-style1" onkeypress="return numbersOnly(this);">
                </td>
              </tr>
              <tr height="35">
                <td align="right">Fax</td>
                <td>
                  <input type="text" name="fax" value="" maxlength="20" class="input-style1" onkeypress="return numbersOnly(this);">
                </td>
              </tr>
              <tr height="35">
                <td align="right">EMAIL</td>
                <td>
                  <input type="text" name="e_mail" value="" maxlength="40" class="input-style1">
                </td>
              </tr>
              <tr height="40">
                <td colspan="2">
                  <table border="0" width="100%" class="table-style2">
                    <tr>
                    <%if (purview.CheckOperatorRightAllSerno(session, "3-15")) {                    %>
                      <td width="25%" align="center">
                        <img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()">
                      </td>
                      <td width="25%" align="center">
                        <img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()">
                      </td>
                      <td width="25%" align="center">
                        <img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()">
                      </td>
                    <%} else {                    %>
                      <td width="25%" align="center">
                        <img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()">
                      </td>
                    <%}                    %>
                      <td width="25%" align="center">
                        <img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()">
                      </td>
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
<script language="JavaScript">

</script><%
  } else {
    if (operID == null) {
%>
<script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script><%} else {%>
<script language="javascript">
                   alert( "You have no access to this function!");
              </script><%
  }
  }
  } catch (Exception e) {
    Vector vet = new Vector();
    sysInfo.add(sysTime + operName + " exception occourred in the management of business hall!");
    sysInfo.add(sysTime + operName + e.toString());
    vet.add("Error occourred in the management of business hall!");
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="hallInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script><%}%>
</body>
</html>

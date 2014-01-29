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
<title>Group prefix management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT></head>
<body background="background.gif" class="body-style1" onload="init()">
<%
  String sysTime = "";
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  //add by wxq 2005.06.07 for version 3.16.01
  String enablegrphallno = CrbtUtil.getConfig("enablegrphallno","1");
  //end
  try {
    manSysPara syspara = new manSysPara();
    sysTime = syspara.getSysTime() + "--";
    if (operID != null && purviewList.get("11-8") != null) {
      //add by wxq  2005.06.08 for version 3.16.01
      String serviceKey = (String)session.getAttribute("SERVICEKEY");
      ArrayList serviceList = purview.getServiceList(serviceKey);
      String selectedServiceKey = (String)((HashMap)serviceList.get(0)).get("SERVICEKEY");
      ArrayList paramList = purview.getServiceParamList(selectedServiceKey);   // 权限范围列表
      HashMap map = (HashMap)paramList.get(0);   //业务区查询参数
      ArrayList paramInfoList = purview.getServiceParamInfo(map);
      //map = (HashMap)paramList.get(1);   //营业厅查询参数
      map = new HashMap();
      map.put("SWHERE","");
      map.put("PVALUEFIELD","hallno");
      if(purview.getDBType("133")==1)
        map.put("PTABLENAME","zxinsys.dbo.ser_pstn51_hall");
      else
        map.put("PTABLENAME","zxinsys.ser_pstn51_hall");
      map.put("PARAMORDER","1");
      map.put("PCFIELDNAME","Business hall");//营业厅
      //返回serareano与hallname字段,用‘@’进行拼接,以方便以后拆分数组时使用
      if(purview.getDBType("133")==1)
        map.put("PFIELDNAME"," convert(varchar,serareano)+'@'+hallname");
      else
        map.put("PFIELDNAME"," to_char(serareano)||'@'||hallname");
      ArrayList hallInfoList = purview.getServiceParamInfo(map);
      //end
      String op = request.getParameter("op") == null ? "" : transferString((String) request.getParameter("op")).trim();
      int optype = 0;
      String serareano = request.getParameter("serareano") == null ? "-1" : transferString((String) request.getParameter("serareano")).trim();
      String hallno = request.getParameter("hallno") == null ? "-1" : (String) request.getParameter("hallno");
      String oldgroupindex = request.getParameter("oldgroupindex") == null ? "0" : (String) request.getParameter("oldgroupindex");
      String groupindex = request.getParameter("groupindex") == null ? "0" : (String) request.getParameter("groupindex");
      // 准备写操作员日志
      Hashtable hash = new Hashtable();
      map = new HashMap();
      String title = "";
      if (op.equals("add")) {
        optype = 1;
        //title = "增加营业厅";
           title = "Add business hall";
      }
      else if (op.equals("edit")) {
        if (!purview.CheckOperatorFunction(session, 3, 15, serareano, "-1", "-1", "-1")) {
          throw new Exception("You have no access to operate on this business hall!");
        }
        optype = 3;
       // title = "Edit营业厅";
       title = "Edit business hall";
      }
      else if (op.equals("del")) {
        optype = 2;
        //title = "删除营业厅";
        title = "Delete business hall";
      }
      if (optype > 0) {
        hash.put("optype", optype + "");
        hash.put("serareano", serareano);
        hash.put("hallno", hallno);
        hash.put("groupindex",groupindex);
        hash.put("oldgroupindex",oldgroupindex);
        syspara.setGroupindex(hash);

        map.put("OPERID", operID);
        map.put("OPERNAME", operName);
        map.put("OPERTYPE", "1108");
        map.put("RESULT", "1");
        map.put("PARA1", serareano);
        map.put("PARA2", hallno);
        map.put("PARA3",groupindex);
        map.put("PARA4",oldgroupindex);
        map.put("PARA5",title);
        map.put("PARA6","ip:"+request.getRemoteAddr());
        purview.writeLog(map);
      }
      Vector vet = syspara.getUserTypeInfo("4");
      String option = "";
      for (int i = 0; i < vet.size(); i++) {
        Hashtable table = (Hashtable) vet.elementAt(i);
        option += "<option value=" + (String) table.get("usertype") + " > " + (String) table.get("utlabel") + " </option>";
      }

      ArrayList hallList = new ArrayList();
      hallList = syspara.getGroupindexManage();
%>
<!--add by wxq-->
<script language="javascript">
  //开始了漫长的动态关联hall与serarea脚本的生成
  var size = '<%= paramInfoList.size() +"" %>';
  //关联数组
  var where = new Array();
  //关联模式
  function comefrom(loca,locacity){
    this.loca = loca; this.locacity = locacity;
  }
<%
             HashMap tmpMap = new HashMap();
             String tmpName;
             //拆分拼接的hall字符串
             String[] tmpStr = null;
             //拼接hall信息所使用的StringBuffer
             StringBuffer sb = new StringBuffer();
             for (int k = 0; k < paramInfoList.size(); k++){
                 tmpMap = (HashMap)paramInfoList.get(k);
                 String tmpValue = (String)tmpMap.get("VALUE");
                 int sum = k - 1;
                 //value=0的记录集不需要
                 if (!tmpValue.equals("0")){
                     for (int l = 0; l < hallInfoList.size(); l++){
                         map = (HashMap)hallInfoList.get(l);
                         tmpName = (String)map.get("NAME");
                         String value = (String)map.get("VALUE");
                         //value=0的记录集不需要
                         if(!(value.equals("0"))){
                             tmpStr = tmpName.split("@");
                             String strSerareano = tmpStr[0];
                             String strHallname = tmpStr[1];
                             //关联hall与serarea的实现
                             if (strSerareano.equals(tmpValue)){
                                 sb.append(value).append("*").append(strHallname).append("|");
                             }//if
                         }//if
                     }//for
                     if (sb.toString().equals("")){
                         sb.append("-1* No business data").append("|");//没有营业厅数据
                     }
%>
  where[<%= sum + "" %>] = new comefrom('<%= tmpValue + "*" + (String)tmpMap.get("NAME") %>','<%= sb.toString() %>');
<%
                     //清空sb中的信息
                     sb = new StringBuffer();
                 }//if
             }//for
%>
//将hallno关联到serareano
function selTime() {
  with(document.inputForm.serareano) {
    var loca2 = options[selectedIndex].value;
  }
  for(i = 0;i < where.length;i ++) {
    if (where[i].loca.split("*")[0] == loca2) {
      loca3 = (where[i].locacity).split("|");
      var locaLength = loca3.length - 1;
      for(j = 0;j < locaLength;j++) {
        with(document.inputForm.hallno) {
          length = loca3.length - 1;
          options[j].text = loca3[j].split("*")[1];
          options[j].value = loca3[j].split("*")[0];
          var loca4=options[selectedIndex].value;
        }
      }
      break;
    }
  }
}
//初始化serareano与hallno
function init() {
  //alert(where.length);
  if(where.length>0)
  {
  with(document.inputForm.serareano) {
    length = where.length;

    for(k = 0;k < where.length;k++) {

    options[k].text = where[k].loca.split("*")[1];
    options[k].value = where[k].loca.split("*")[0];

   }
  }
  with(document.inputForm.hallno) {
    loca3 = (where[0].locacity).split("|");
    length = loca3.length - 1;
    for(l=0;l<length;l++) {
      options[l].text = loca3[l].split("*")[1];
      options[l].value = loca3[l].split("*")[0];
    }
  }
  }
}
</script>
<!--end-->
<script language="javascript">
   var v_groupindex = new Array(<%= hallList.size() + "" %>);
   var v_serareano = new Array(<%= hallList.size() + "" %>);
   var v_hallno = new Array(<%= hallList.size() + "" %>);
<%
   for (int i = 0; i < hallList.size(); i++) {
       map = (HashMap)hallList.get(i);
%>
   v_groupindex[<%= i + "" %>] = '<%= (String)map.get("groupindex") %>';
   v_serareano[<%= i + "" %>] = '<%= (String)map.get("serareano") %>';
   v_hallno[<%= i + "" %>] = '<%= (String)map.get("hallno") %>';
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
     // alert('请输入数字');
       alert('Please input a digit');
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
  fm.oldgroupindex.value = v_groupindex[index];
  fm.groupindex.value = v_groupindex[index];
  fm.serareano.value = v_serareano[index];
  selTime();
  fm.hallno.value = v_hallno[index];
}

function checkInfo () {
  var fm = document.inputForm;
  var flag = false;
  var value = trim(fm.groupindex.value);
  if (trim(value) == '') {
    //alert('请输入铃音前缀!');
     alert('Please input the Group prefix');
    fm.hallno.focus();
    return flag;
  }
  if (!checkstring('0123456789',value)) {
   // alert('铃音前缀必须是数字!');
    alert('The Group prefix must be a digit!');
    fm.hallno.focus();
    return flag;
  }
  value = fm.serareano.value;

  if(value=="")
  {
  alert("Please config the service area in the system data management first.");
  return flag;
  }

  if (value == '-1' || value == -1){
   // alert('请选择业务区');
   alert("Please select service area!");
    return flag;
  }
//  value = fm.hallno.value;
//  if (value == '-1' || value == -1){
//    alert('请选择营业厅');
//    return flag;
//  }
  flag = true;
  return flag;
}

function checkName () {
  var fm = document.inputForm;
  var code = trim(fm.groupindex.value);
  var optype = fm.op.value;
  if(optype=='add'){
    for (i = 0; i < v_groupindex.length; i++)
    if (code == v_groupindex[i]){
      return true;
    }
  }
  else if(optype=='edit'){
    var index = fm.infoList.selectedIndex;
    for (i = 0; i < v_groupindex.length; i++)
    if (code == v_groupindex[i] && i!=index)
    return true;
  }
  return false;
}


function addInfo () {
  var fm = document.inputForm;
  if (! checkInfo())
  return;
  fm.op.value = 'add';
  fm.oldgroupindex.value = '';
  if (checkName()) {
    //alert('要增加的铃音前缀已经存在!');
    alert("The ringtone prefix need to add has exist!");
    fm.hallno.focus();
    return;
  }
  fm.submit();
}

function editInfo () {
  var fm = document.inputForm;
  var index = fm.infoList.selectedIndex;
  fm.oldgroupindex.value = v_groupindex[index];
  if(fm.infoList.length==0){
   // alert("没有任何铃音前缀可供Edit!");
   alert("No ringtone prefix can be edited!");
    return;
  }
  if(index == -1){
    //alert("请选择您Edit的铃音前缀");
    alert("Please select the ringtone prefix you want to edit");
    return;
  }
  if (! checkInfo())
  return;
  fm.op.value = 'edit';
  if (checkName()) {
    //alert('您要Edit的新铃音前缀已经存在!');
    alert("The ringtone prefix you want to edit has existed!");
    fm.hallno.focus();
    return;
  }
  fm.submit();
}

function delInfo () {
  var fm = document.inputForm;
  if(fm.infoList.length==0){
  //  alert("没有任何铃音前缀可供删除!");
   alert("No any ringtone prefix can be deleted!");
    return;
  }
  var index = fm.infoList.selectedIndex;
  if(index == -1){
    //alert("请选择您删除的铃音前缀");
   alert("Please select the ringtone prefix you want to delete");
    return;
  }
  fm.op.value = 'del';
  fm.submit();
}
</script><script language="JavaScript">
if(parent.frames.length>0)
  parent.document.all.main.style.height="500";
</script><form name="inputForm" method="post" action="groupInHall.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldgroupindex" value="">
<table width="500" height="400" border="0" align="center" class="table-style2">
  <tr valign="middle">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Group prefix management</td>
        </tr>
        <tr>
          <td width="45%" align="right">
            <select name="infoList" size="8" style="width:200px" onclick="javascript:selectInfo()">
            <%
              for (int i = 0; i < hallList.size(); i++) {
                map = (HashMap) hallList.get(i);
                out.println("<option value=" + Integer.toString(i) + ">" + (String) map.get("groupindex") + "</option>");
              }
            %>
            </select>
          </td>
          <td width="55%">
            <table width="100%" border=0 class="table-style2">
              <tr height="35">
                <td align="right">Group prefix</td>
                <td>
                  <input type="text" name="groupindex" class="input-style1" value="" maxlength="15" onkeypress="return numbersOnly(this);">
                </td>
              </tr>
              <tr height="35">
                <td align="right">Service code</td>
                <td>
                  <select name="serareano" class="input-style1" onchange="selTime()">
                  </select>
                </td>
              </tr>
              <tr height="35" <%= enablegrphallno.equals("1") ? "" : "style=\"display:none\"" %>>
                <td align="right">Business hall no</td>
                <td>
                  <select name="hallno" class="input-style1" onchange="selTime()">
                  </select>
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
  <tr>
    <td>
      <table border="0" width="100%" class="table-style2" align="center">
        <tr>
          <td class="table-styleshow" background="image/n-9.gif" height="26">Notes:</td>
        </tr>
        <tr>
          <td class="table-styleshow">&nbsp;* Group prefix is relate to the service area,please don't delete or edit. <br/></td>
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
                   alert("Sorry,you have no access to this function!");
              </script><%
  }
  }
  } catch (Exception e) {
    e.printStackTrace();
    Vector vet = new Vector();
    sysInfo.add(sysTime + operName + " exception occurred in the process of business hall and group management!");//营业厅与集团管理过程出现异常!
    sysInfo.add(sysTime + operName + e.toString());
    //vet.add("Error occoured on the management of business hall and group management!");
    vet.add("Error occurred in the process of business hall and group management!");
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="groupInHall.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script><%}%>
</body>
</html>

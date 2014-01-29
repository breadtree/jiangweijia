<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="zxyw50.group.dataobj.*" %>
<%@ page import="zxyw50.group.context.*" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Group user grouping</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript" src="../pubfun/JsFun.js">
</script>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    //change by wxq 2005.05.31 for version 3.16.01
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String groupid;
    String groupindex;
    String groupname;
    if (mode.equals("manager")){
        groupindex = request.getParameter("groupindex") == null ? "" : request.getParameter("groupindex");
        groupid = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
        groupname = request.getParameter("groupname") == null ? "" : transferString(request.getParameter("groupname"));
    }else{
        groupindex = (String)session.getAttribute("GROUPINDEX");
        groupid = (String)session.getAttribute("GROUPID");
        groupname =  (String)session.getAttribute("GROUPNAME");
    }
    
    zxyw50.ManGroup mangroup = new zxyw50.ManGroup();
    Hashtable   mytable = mangroup.getGrpInfoByindex(groupindex);
    groupname = transferString((String)mytable.get("groupname"));
    
    
    
    //end
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String ringlibname = "Group grouping";
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY") == null ? "Ringtone " : (String)application.getAttribute("RINGDISPLAY");
    String errMsg = "";
    //分组索引
    String closeid = request.getParameter("closeid") == null ? "" : (String)request.getParameter("closeid");
    //分组名称
    String closedescrip = request.getParameter("closedescrip") == null ? "" : transferString((String)request.getParameter("closedescrip"));
    //分组Maximum number of members（暂时不使用,页面未显示,以后可根据需要随时放开）
    String maxusers = request.getParameter("maxusers") == null ? "" : (String)request.getParameter("maxusers");
    //操作描述信息
    String desc = "";
    try{
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        //用户操作码
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        boolean blexist = false;
        //判断用户是否有权限登陆
        //change by wxq 2005.06.13 for version 3.16.01
        //权限 code需要修改
        if (purviewList.get("12-11") == null){
            //如果mode的值为manager,表明是管理员进入,并且已经通过了审核,允许进入
            if (mode.equals("manager")){
                blexist = false;
            }
            else{
                errMsg = "You have no access to this function";
                blexist = true;
            }
        }
        //end
        if (!blexist && groupid != null && groupindex != null) {
            Group grp = new Group();
            grp.setGroupIndex(groupindex);
            grp.setGroupId(groupid);
            if (op.equals("add")){
                GroupGrouping grpGrouping = new GroupGrouping();
                grpGrouping.setClosedescrip(closedescrip);
                grpGrouping.setCloseid(Integer.parseInt(closeid));
                grpGrouping.setMaxusers(Integer.parseInt(maxusers));
                grpGrouping.setGroupid(groupid);
                grp.getGroupContext().addGroupGrouping(grpGrouping);
                desc = operName + " add group grouping";
            }
            if (op.equals("edit")){
                GroupGrouping grpGrouping = new GroupGrouping();
                grpGrouping.setClosedescrip(closedescrip);
                grpGrouping.setCloseid(Integer.parseInt(closeid));
                grpGrouping.setMaxusers(Integer.parseInt(maxusers));
                grpGrouping.setGroupid(groupid);
                grp.getGroupContext().editGroupGrouping(grpGrouping);
                desc = operName + " modify group grouping";
            }
            if (op.equals("del")){
                GroupGrouping grpGrouping = new GroupGrouping();
                grpGrouping.setCloseid(Integer.parseInt(closeid));
                grpGrouping.setMaxusers(Integer.parseInt(maxusers));
                grpGrouping.setClosedescrip(closedescrip);
                grpGrouping.setGroupid(groupid);
                grp.getGroupContext().removeGroupGrouping(grpGrouping);
                desc = operName + " delete group grouping";
            }
            sysInfo.add(sysTime + desc);
            if(!op.equals("")){
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                //需要修改
                map.put("OPERTYPE","1211");
                map.put("RESULT","1");
                map.put("PARA1",closeid);
                map.put("PARA2",closedescrip);
                map.put("PARA3",groupindex);
                map.put("PARA4",groupname);
                map.put("PARA5",desc);
                map.put("PARA6","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }
            grp.getGroupContext().loadGroupGrouping();
            
     
            
            GroupGrouping[] groupGrouping = grp.getGroupGrouping();
%>
<script language="javascript">
  var v_closeid = new Array(<%= groupGrouping.length + "" %>);
  var v_closedescrip = new Array(<%= groupGrouping.length + "" %>);
  //var v_maxusers = new Array(<%= groupGrouping.length + "" %>);
<%
            for (int i = 0; i < groupGrouping.length; i++) {
%>
  v_closeid[<%= i + "" %>] = '<%= groupGrouping[i].getCloseid() %>';
  v_closedescrip[<%= i + "" %>] = '<%= groupGrouping[i].getClosedescrip() %>';
  //v_maxusers[<%= i + "" %>] = '<%= groupGrouping[i].getMaxusers() %>';
<%
            }//for
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
      alert('Please input a digital number!');
      return false;
    }
  }

  function selectInfo () {
    var fm = document.inputForm;
    var index = fm.idlist.selectedIndex;
    if (index <0 || index >= v_closedescrip.length)
      return;
    fm.closedescrip.value = v_closedescrip[index];
    //fm.maxusers.value = v_maxusers[index];
    fm.closeid.value = v_closeid[index];
    fm.closedescrip.focus();
  }

  //增加新的集团分组
  function addInfo () {
    var fm = document.inputForm;
    fm.op.value = 'add';
    if (! checkInfo())
      return;
    fm.submit();
  }

  //修改已有的集团分组
  function editInfo () {
    var fm = document.inputForm;
    fm.op.value = 'edit';
    var index = fm.idlist.selectedIndex;
    //fm.closeid.value = v_closeid[index];
    if(fm.idlist.selectedIndex == -1) {
      alert('Please select the group grouping to be modified!');
      return;
    }
    if (!checkInfo())
      return;
    fm.submit();
  }

  //删除集团分组
  function delInfo () {
    var fm = document.inputForm;
    fm.op.value = 'del';
    var index = fm.idlist.selectedIndex;
    if(fm.idlist.selectedIndex == -1) {
     // alert('Please select the group grouping to be deleted!');
      return;
    }
    fm.closeid.value = v_closeid[index];
    if(!confirm('Are you sure to delete the group grouping?'))
      return ;
    fm.submit();
  }

  //分组成员管理
  function manageInfo(){
    var fm = document.inputForm;
    var index = fm.idlist.selectedIndex;
    var close_id = v_closeid[index];
    var close_desvrip = v_closedescrip[index];
    var group_index = '<%= groupindex %>';
    var op_mode = '<%= mode %>';
    if (index == '-1'){
      alert('Please select group!');
      return;
    }
    document.location.href = 'grpMember.jsp?closeid=' + close_id + '&amp;closedescrip=' + close_desvrip + '&amp;groupindex=' + group_index + '&amp;groupid=' + '<%= groupid %>' + '&amp;mode=' + op_mode;
  }

  //验证函数
  function checkInfo() {
    var fm = document.inputForm;
    var flag = false;
    //如果用户不输入最大分组用户数,则自动赋值为'0',表示不限制
    if (trim(fm.maxusers.value) == ''){
      fm.maxusers.value = 0;
    }
    if (trim(fm.closedescrip.value) == '') {
     // alert('请输入分组名称!');
       alert("Please input the group name");
      fm.closedescrip.focus();
      return flag;
    }
    if (!CheckInputStr(fm.closedescrip,'\u540D\u79F0'))
       return false;

//    if (!checkstring('0123456789',trim(fm.maxusers.value))) {
//      alert('最大用户数只能为数字!');
//      fm.maxusers.focus();
//      return flag;
//    }
    if (trim(fm.closeid.value) == ''){
      //alert('请输入分组序号');
      alert("Please input the group number");
      fm.closeid.focus();
      return flag;
    }else if(trim(fm.closeid.value) == '0'){
      alert('The grouping number should not be 0');
      fm.closeid.focus();
      return flag;
    }
    var optype  = fm.op.value;
    var value = fm.closedescrip.value;
    var closeid = fm.closeid.value;
    var flag = 0;
    var idFlag = 0;
    var isExist = 0;
    //判断是否重名,如果重名,设flag='1'
    //判断序号是否重复,如果重复,设idFlag='1'
    //修改分组信息时,不能修改序号,如果修改,设则isExist＝'1'
    if(optype == 'add'){ //添加
      for(var index=0; index < v_closedescrip.length; index++){
        if(v_closedescrip[index] == value){
          flag = 1;
          break;
        }
        if (v_closeid[index] == closeid){
          idFlag = 1;
          break;
        }
      }
    }
    else if(optype == 'edit'){//修改
      var select  = document.forms[0].idlist.selectedIndex;
      if (v_closeid[select] != closeid){
        isExist = 1;
      }
      for(var index=0; index < v_closedescrip.length; index++){
        if (v_closedescrip[index] == value && index != select){
          flag = 1;
          break;
        }
      }
    }
    if(flag == 1){
      alert("The grouping name exists already, please input it again!");
      document.forms[0].closedescrip.focus();
      return false;
    }
    if (idFlag == 1){
     // alert("分组序号已经存在,请重新输入!");
      alert("Grouping number exists already, please input it again!");
      document.forms[0].closeid.focus();
      return false;
    }
    if (isExist == 1){
      var select  = document.forms[0].idlist.selectedIndex;
      //alert("分组序号不能进行Edit!");
       alert("Grouping number cannot be edited");
      document.forms[0].closeid.focus();
      document.forms[0].closeid.value = v_closeid[select];
      return false;
    }
    flag = true;
    return flag;
  }
  </script>
  <script language="JavaScript">
    if(parent.frames.length>0)
      parent.document.all.main.style.height="400";
  </script>
  <form name="inputForm" action="" method="POST">
    <input type="hidden" name="op" value=""/>
    <!--change by wxq 2005.06.16-->
    <input type="hidden" name="mode" value="<%= mode %>"/>
    <input type="hidden" name="groupid" value="<%= groupid %>"/>
    <input type="hidden" name="groupindex" value="<%= groupindex %>"/>
    <input type="hidden" name="groupname" value="<%= groupname %>"/>
    <!--end-->
    <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
      <tr valign="middle">
        <td valign="top" bgcolor="#FFFFFF">
          <table width="70%" border="0" align="center" class="table-style2">
            <tr>
              <td colspan="5" align="center" class="text-title" background="../image/n-9.gif" height="26"><%= groupname %> Group user grouping</td>
            </tr>
            <tr>
              <td rowspan="6" align="center">
                <select name="idlist" size="10" <%= groupGrouping.length == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
            for (int i = 0; i < groupGrouping.length; i++) {
%>
                  <option value="<%= "" + groupGrouping[i].getCloseid()%>"><%= (String)groupGrouping[i].getClosedescrip() %></option>
<%
            }//for
%>
                </select>
              </td>
                <td align="right">&nbsp;Serial number</td>
                <td><input type="text" name="closeid" value="" maxlength="3" class="input-style1" onkeypress="return numbersOnly(this);"></td>
              </tr>
              <tr>
                <td align="right">&nbsp;Name</td>
                <td><input type="text" name="closedescrip" value="" maxlength="20" class="input-style1"></td>
              </tr>
              <tr style="display:none">
                <td align="right">&nbsp;Maximum number of members</td>
                <td><input type="text" name="maxusers" value="0" maxlength="5" class="input-style1" onkeypress="return numbersOnly(this);"></td>
              </tr>
              <tr>
                <td colspan="2">
                <table border="0" width="100%" class="table-style2">
                  <tr>
                    <td width="25%" align="center"><img src="../manager/button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                    <td width="25%" align="center"><img src="../manager/button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                    <td width="25%" align="center"><img src="../manager/button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                    <td width="25%" align="center"><img src="../manager/button/member.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:manageInfo()"></td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr valign="top">
        <td width="100%" align="center">
         <table width="70%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
           <tr>
             <td class="table-styleshow" background="../image/n-9.gif" height="26">
               Warning:
             </td>
            </tr>
            <tr>
              <td colspan="2">1.Choose one grouping and click "Delete" button to delete it.</td>
            </tr>
            <tr>
              <td colspan="2">2.Click the "manage" button to manager member.</td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </form>
<%
        }//if
        else {
%>
<script language="javascript">
   var errorMsg = '<%= groupid != null ? errMsg : "Please log in to the system first"%>';
   alert(errorMsg);
   document.location.href = 'enter.jsp';
</script>
<%
        }//else
    }//try
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + groupid + ringlibname+ " is abnormal during the procedure!");
        sysInfo.add(sysTime + groupid + e.toString());
        vet.add(ringlibname + " Error occurs during the procedure.");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpGrouping.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }//catch
%>
</body>
</html>

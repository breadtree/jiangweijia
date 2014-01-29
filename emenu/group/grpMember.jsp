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
<title>Group user grouping member management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript" src="../pubfun/JsFun.js"></script>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    //change by wxq 2005.05.31 for version 3.16.01
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String groupindex,groupid,groupname;
    if (mode.equals("manager")){
        groupindex = request.getParameter("groupindex") == null ? "" : request.getParameter("groupindex");
        groupid = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
        groupname = request.getParameter("groupname") == null ? "" : transferString(request.getParameter("groupname"));
    }else{
        groupindex = (String)session.getAttribute("GROUPINDEX");
        groupid = (String)session.getAttribute("GROUPID");
        groupname =  (String)session.getAttribute("GROUPNAME");
    }
    

    
    //end
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String ringlibname = "Group grouping management";
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY") == null ? "ringtone" : (String)application.getAttribute("RINGDISPLAY");
    String errMsg = "";
    //集团分组索引
    String closeid = request.getParameter("closeid") == null ? "" : request.getParameter("closeid");
    //集团分组名称
    String closedescrip = request.getParameter("closedescrip") == null ? "" : transferString(request.getParameter("closedescrip"));
    String desc = "";
    boolean blexist = false;
    //用户操作码
    String op = request.getParameter("op") == null ? "" : request.getParameter("op");
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        if (purviewList.get("12-11") == null)  {
            //如果mode的值为manager,表明是管理员进入,并且已经通过了审核,允许进入
            if (mode.equals("manager")){
                blexist = false;
            }
            else{
                errMsg = "You have no access to the function";
                blexist = true;
            }
        }
        if (!blexist && groupid != null && groupindex != null) {
            Group grp = new Group();
            grp.setGroupIndex(groupindex);
            grp.setGroupId(groupid);
            //user number数组
            String[] userNumbers = null;
            //user number
            String usernumber;
            //记录日志文件中的user number
            StringBuffer logSb = new StringBuffer();
            if (op.equals("add")){
                userNumbers = (String[])request.getParameterValues("outNumberList");
                desc = operName + " add group " + userNumbers.length +" members";
                for (int i = 0; i < userNumbers.length; i++){
                    usernumber = (String)userNumbers[i];
                    grp.getGroupContext().addGroupingMember(closeid,usernumber);
                    logSb.append("User number").append(i).append(":").append(usernumber);
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
                map.put("PARA3",usernumber);
                map.put("PARA4",groupname);
                map.put("PARA5","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }
                }
            }
            if (op.equals("remove")){
                userNumbers = (String[])request.getParameterValues("inNumberList");
                desc = operName + " remove group " + userNumbers.length +" members";
                for (int i = 0; i < userNumbers.length; i++){
                    usernumber = (String)userNumbers[i];
                    grp.getGroupContext().removeGroupingMember(closeid,usernumber);
                    logSb.append("User number ").append(i).append(":").append(usernumber);
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
                map.put("PARA3",usernumber);
                map.put("PARA4",groupname);
                map.put("PARA5","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }
                }
            }
            //查询集团该分组内成员
            grp.getGroupContext().loadGroupingMember(closeid);
            ArrayList grpList = grp.getGroupingMember();
            //查询集团组内未分组的成员
            String closeid_out = "0";
            grp.getGroupContext().loadGroupingMember(closeid_out);
            ArrayList outList = grp.getGroupingMember();
            sysInfo.add(sysTime + desc);
%>
<script language="javascript">
  //选择信息
  function selectInfo (mode) {
    var fm = document.inputForm;
    var in_index = fm.inNumberList.value;
    var out_index = fm.outNumberList.value;
    if (in_index == '' && mode == 'remove'){
      //alert('请先选择组内成员!');
      alert("Please select members in the group!");
      return;
    }
    if (out_index == '' && mode == 'add'){
      alert("Please select members outside the group!");
      //alert('请先选择组外成员!');
      return;
    }
    fm.op.value = mode;
    fm.submit();
  }
</script>
<form name="inputForm" action="grpMember.jsp" method="POST">
  <input type="hidden" name="op" value=""/>
  <input type="hidden" name="closeid" value="<%=closeid%>"/>
  <!--change by wxq 2005.06.17-->
  <input type="hidden" name="mode" value="<%=mode%>"/>
  <input type="hidden" name="groupid" value="<%=groupid%>"/>
  <input type="hidden" name="groupindex" value="<%=groupindex%>"/>
  <input type="hidden" name="closedescrip" value="<%=closedescrip%>"/>  
  <!--end-->
  <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
    <tr valign="top">
      <td width="100%">
        <table width="100%" cellspacing="1" cellpadding="2" border="0">
          <tr>
            <td width="100%" colspan="3" align="center">
              <b>
              <font size="2">Group grouping name:</font>
              <font size="2" color="#800000"><%= closedescrip %></font>
              </b>
            </td>
          </tr>
          <tr>
            <td width="45%" align="center"><font size="2"><b>Existing members in the group</b></font></td>
            <td width="10%" align="center">&nbsp;</td>
            <td width="45%" align="center"><font size="2"><b>Members not grouped in the group<b></font></td>
          </tr>
          <tr>
            <td align="center">
              <select multiple="multiple" name="inNumberList" size="5" class="select-style4">
<%
            for (int i = 0; i < grpList.size(); i++) {
            	
%>
                <option value="<%= grpList.get(i) %>"><%= grpList.get(i) %></option>
<%
            }//for
%>
              </select>
            </td>
            <td align="center"><br>
              <input type="button" value="<%="-->"%>"  onclick="selectInfo('remove')" name="inButton"/>
              <br>
              <input type="button" value="<%="<--"%>"  onclick="selectInfo('add')" name="outButton"/>
            </td>
            <td align="center">
              <select multiple="multiple" name="outNumberList" size="5"  class="select-style4">
<%
            for (int j = 0; j < outList.size(); j++) {
%>
                <option value="<%= outList.get(j) %>"><%= outList.get(j) %></option>
<%
            }//for
%>
              </select>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="../button/cancel.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.location.href='grpGrouping.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>'"
         alt="Back to the uper level">
      </td>
    </tr>
    <tr valign="top">
      <td width="100%">
        <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
          <tr>
            <td class="table-styleshow" background="image/n-9.gif" height="26">
             Help:
            </td>
          </tr>
          <tr>
            <td colspan="2">1.  Select member(s) to be moved outside the grouping, click "--&gt;" to finish the operation.</td>
          </tr>
          <tr>
            <td colspan="2">2.  Select member(s) to be moved inside the grouping, click "&lt;--" to finish the operation. </td>
          </tr>
          <tr>
            <td colspan="2">3.  Click "Cancel" to return to the upper level.</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>

</form>
<%
        }
        else{
%>
<script language="javascript">
   var errorMsg = '<%=groupid != null ? errMsg : "Please log in to the system first"%>';
   alert(errorMsg);
   document.location.href = 'enter.jsp';
</script>
<%
        }
    }catch (Exception e){
        Vector vet = new Vector();
        sysInfo.add(sysTime + groupid + ringlibname+ " is abnormal during the procedure!");
        sysInfo.add(sysTime + groupid + e.toString());
        vet.add(ringlibname + " Error occurs during the procedure!");
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

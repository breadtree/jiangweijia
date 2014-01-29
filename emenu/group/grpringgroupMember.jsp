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
<title>Group ringtone group member management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript" src="../pubfun/JsFun.js"></script>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Hashtable hash = new Hashtable();
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
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
    String ringlibname = "Group ringtone group member management";
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY") == null ? "ringtone" : (String)application.getAttribute("RINGDISPLAY");
    String errMsg = "";
    String optRingList = "";
    String optoutRingList = "";
    //集团ringtone组索引
    String ringgroup = request.getParameter("ringgroup") == null ? "" : request.getParameter("ringgroup");
    //集团ringtone组名称
    String grpLabel = request.getParameter("grpLabel") == null ? "" : transferString(request.getParameter("grpLabel"));    
    String desc = "";
    boolean blexist = false;
    //用户操作码
    String op = request.getParameter("op") == null ? "" : request.getParameter("op");
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        if (purviewList.get("12-13") == null)  {
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
            //ringtone数组
            String[] ringIDs = null;
            //ringtone
            String ringID;
            //记录日志文件中的user number
            StringBuffer logSb = new StringBuffer();
            if (op.equals("add")){
                ringIDs = (String[])request.getParameterValues("outNumberList");
                for (int i = 0; i < ringIDs.length; i++){
                    ringID = (String)ringIDs[i];
                     hash = new Hashtable();
                     Hashtable result = new Hashtable();
                     hash.put("opcode","01010967");
                     hash.put("optype","1");
                     hash.put("groupid",groupid);
                     hash.put("ringgroup",ringgroup);
                     hash.put("ringid",ringID);
                     hash.put("nringid",ringID);
                     result = SocketPortocol.send(pool,hash);
                     sysInfo.add(sysTime +"ringtone ID " +ringID+" add to "+ ringdisplay + " group successfully!");
                }
                desc = operName + "add group ringtone group " + ringIDs.length +" members";
            }
            if (op.equals("remove")){
                ringIDs = (String[])request.getParameterValues("inNumberList");
                for (int i = 0; i < ringIDs.length; i++){
                  ringID = (String)ringIDs[i];
                   hash = new Hashtable();
                     Hashtable result = new Hashtable();
                     hash.put("opcode","01010967");
                     hash.put("optype","2");
                     hash.put("groupid",groupid);
                     hash.put("ringgroup",ringgroup);
                     hash.put("ringid",ringID);
                     hash.put("nringid",ringID);
                     result = SocketPortocol.send(pool,hash);
                     sysInfo.add(sysTime +"ringtone ID " +ringID+" move "+ ringdisplay + " group successfully!");
                }
               // desc = operName + "remove group ringtoneintra-group " + ringIDs.length +" members";
               desc = operName + " remove intra-group ringtone " + ringIDs.length +" members in the group";
            }
            //查询 group 该ringtoneintra-groupringtone
            grp.getGroupContext().loadGroupRingGroupMember(ringgroup);
            GroupRinggroupMember[] grpList = grp.getgroupRinggroupMember();
            if(grpList==null)
               grpList=new GroupRinggroupMember[0];
            //查询属于集团,但是不属于当前ringtone组的ringtone
            grp.getGroupContext().loadGroupringnotinRinggroup(ringgroup);
             GroupRinggroupMember[] outList = grp.getgroupRinggroupMember();
             if(outList==null)
             outList=new GroupRinggroupMember[0];
            sysInfo.add(sysTime + desc);
            if(!op.equals("")){
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                //需要修改
                map.put("OPERTYPE","1214");
                map.put("RESULT","1");
                map.put("PARA1",ringgroup);
                map.put("PARA2",grpLabel);
                map.put("PARA3",logSb.toString());
                map.put("PARA4",groupname);
                map.put("PARA5","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
            }
%>
<script language="javascript">
  //选择信息
  function selectInfo (mode) {
    var fm = document.inputForm;
    var in_index = fm.inNumberList.value;
    var out_index = fm.outNumberList.value;
    if (in_index == '' && mode == 'remove'){
      alert('Please select the intra-group ringtone!');
      return;
    }
    if (out_index == '' && mode == 'add'){
      alert('Please select the inter-group ringtone!');
      return;
    }
    fm.op.value = mode;
    fm.submit();
  }
</script>
<form name="inputForm" action="grpringgroupMember.jsp" method="POST">
  <input type="hidden" name="op" value=""/>
  <input type="hidden" name="ringgroup" value="<%=ringgroup%>"/>
  <!--change by wxq 2005.06.17-->
  <input type="hidden" name="mode" value="<%=mode%>"/>
  <input type="hidden" name="groupid" value="<%=groupid%>"/>
  <input type="hidden" name="groupindex" value="<%=groupindex%>"/>
  <input type="hidden" name="grpLabel" value="<%=grpLabel%>"/>
  
  <!--end-->
  <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
    <tr valign="top">
      <td width="100%">
        <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style3">
          <tr>
            <td width="100%" colspan="3" align="center">
              <b>
              <font size="4">Group ringtone group name:</font>
              <font size="4"><%= grpLabel %></font>
              </b>
            </td>
          </tr>
          <tr>
            <td width="45%" align="center">Ringtone existing in intra-group ringtone</td>
            <td width="10%" align="center">&nbsp;</td>
            <td width="45%" align="center">Ringtone  not add to ringtone group</td>
          </tr>
          <tr>
            <td align="center">
              <select multiple="multiple" name="inNumberList" size="5" class="select-style4">
<%
            for (int i = 0; i < grpList.length;i++) {
               String cridTmp = grpList[i].getRingid();
               String filname = grpList[i].getRinglabel();
               optRingList = optRingList + "<option value=" + cridTmp +">" +cridTmp+"----"+ filname + "</option>";
            }//for
            if(!optRingList.equals(""))
            out.println(optRingList);
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
            for (int j = 0; j < outList.length; j++) {
              String cridTmp = outList[j].getRingid();
               String filname =outList[j].getRinglabel();
               optoutRingList = optoutRingList + "<option value=" + cridTmp +">"+cridTmp+ "----"+ filname + "</option>";
            }//for
             if(!optoutRingList.equals(""))
            out.println(optoutRingList);
%>
              </select>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="../button/cancel.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.location.href='grpringgroup.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>'" alt="Return to the upper level.">
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
            <td colspan="2">1.  Select member(s) to be moved outside the ringtone grouping, click "--&gt;" to finish the operation;</td>
          </tr>
          <tr>
            <td colspan="2">2.  Select member(s) to be moved inside the ringtone grouping, click "&lt;--" to finish the operation; </td>
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
        sysInfo.add(sysTime + groupid + ringlibname+ " is abnormal during the procedure");
        sysInfo.add(sysTime + groupid + e.toString());
        vet.add(ringlibname + " Error occurs during the procedure");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="grpringgroup.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }//catch
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="zxyw50.group.dataobj.*" %>
<%@ page import="zxyw50.group.context.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ include file="../sParam.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");   
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Group ringtone group management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">

<%
          String sysTime = "";
          Hashtable hash = new Hashtable();
          String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
          String groupid;
          String groupindex;
          String groupname;
          int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
        if (mode.equals("manager")){
        groupindex = request.getParameter("groupindex") == null ? "" : request.getParameter("groupindex");
        groupid = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
        
        
        groupname = request.getParameter("groupname") == null ? "" : transferString(request.getParameter("groupname"));
        }else{
        groupindex = (String)session.getAttribute("GROUPINDEX");
        groupid = (String)session.getAttribute("GROUPID");
        groupname =  (String)session.getAttribute("GROUPNAME");
       }
        Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String errMsg = "";
        String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
	String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))  ringdisplay = "ringtone";
        Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String crid = request.getParameter("crid") == null ? "" : ((String)request.getParameter("crid")).trim();
        String grouplabel = request.getParameter("grouplabel") == null ? "" : transferString(((String)request.getParameter("grouplabel")).trim());
        if(checkLen(grouplabel,40))
           	throw new Exception("You input " + ringdisplay +"group name exceeds the length limit,please re-enter!");//组名称超过长度限制,请您重新输入
         GroupRinggroupMember[] grpmemList=new GroupRinggroupMember[0];
         boolean blexist = false;
        //判断用户是否有权限登陆
        //权限 code需要修改/同group目录下index.jsp中的权限
        if (purviewList.get("12-13") == null){
            //如果mode的值为manager,表明是管理员进入,并且已经通过了审核,允许进入
            if (mode.equals("manager")){
                blexist = false;
            }
            else{
                errMsg = "You have no access to this function!";
                blexist = true;
            }
        }
        //end
        if (!blexist&&groupid != null&&groupindex!=null) {
             Group grp = new Group();
	     grp.setGroupIndex(groupindex);
             grp.setGroupId(groupid);
            // 如果是增加ringtone组
            if (op.equals("add")) {
              ywaccess yes=new ywaccess();
              int newgroupindex = yes.getMaxIndex(13);
              String strindex="99";
            hash = new Hashtable();
            Hashtable result = new Hashtable();
            hash.put("opcode","01010966");
            hash.put("optype","1");
            hash.put("groupid",groupid);
            hash.put("ringgroup",""+newgroupindex);
            hash.put("grouplabel",grouplabel);
            result = SocketPortocol.send(pool,hash);
            sysInfo.add(sysTime + groupid + " add " + ringdisplay + " group successfully!");
            }
            // 如果是删除ringtone组
            if (op.equals("del")) {
             //查询集团该ringtone组内是否有ringtone
            grp.getGroupContext().loadGroupRingGroupMember(crid);
            grpmemList = grp.getgroupRinggroupMember();
                // 如果ringtone组内没有ringtone,直接删除
                if (grpmemList.length==0)
                    op = "delend";
            }
            // 如果是删除ringtone组,已经被确认
            if (op.equals("delend")) {
            hash = new Hashtable();
            Hashtable result = new Hashtable();
            hash.put("opcode","01010966");
            hash.put("optype","2");
            hash.put("groupid",groupid);
            hash.put("ringgroup",crid);
            hash.put("grouplabel",grouplabel);
            result = SocketPortocol.send(pool,hash);
            sysInfo.add(sysTime + groupid + " delete " + ringdisplay + " group successfully!");
            }
            // 如果是修改ringtone组
            if (op.equals("set")) {
            hash = new Hashtable();
            Hashtable result = new Hashtable();
            hash.put("opcode","01010966");
            hash.put("optype","3");
            hash.put("groupid",groupid);
            hash.put("ringgroup",crid);
            hash.put("grouplabel",grouplabel);
            result = SocketPortocol.send(pool,hash);
            sysInfo.add(sysTime + groupid + " modify " + ringdisplay + "group successfully!");
            }
            // 查询ringtone组信息
            grp.getGroupContext().loadGroupRingGroup();
            GroupRinggroup[] groupringgroup=grp.getGroupRinggroup();
            if (op.equals("del")) {
%>

<form name="inputForm" method="post" action="grpringgroup.jsp">
<input type="hidden" name="crid" value="<%= crid %>">
<input type="hidden" name="op" value="delend">
<input type="hidden" name="mode" value="<%= mode%>">
<input type="hidden" name="groupid" value="<%= groupid%>">
<input type="hidden" name="groupindex" value="<%= groupindex%>">

  <table width="<%=sTabWidth%>" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td valign="top" bgcolor="#FFFFFF"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td background="../image/home_r4_c11.gif"> <table width="540" border="0" cellspacing="0" cellpadding="0" height="125" align="center">
                <tr>
                  <td background="../image/c.jpg"> <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="540" height="125">
                      <param name=movie value="../image/block%5B1%5D.swf">
                      <param name=quality value=high>
                      <param name="wmode" value="transparent">
                      <embed src="../image/block%5B1%5D.swf" quality=high pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="540" height="125" wmode="transparent">
                      </embed> </object></td>
                </tr>
              </table></td>
          </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td> <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>

           <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
                  <table border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                      <td>
				                          <!-- % pageContext.include("myRingToolbar.jsp"); %>  -->
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
              <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
                <tr>
                  <td width="28"><img src="../image/home_r14_c3.gif" width="28" height="31"></td>
                  <td background="../image/home_r14_c5bg.gif"><font color="#006600"><b></b>
                    <b><font class="font"> <%= ringdisplay%> intra-group ringtone information</font></b></font></td>
                  <td width="12"><img src="../image/home_r14_c5.gif" width="12" height="31"></td>
                </tr>
              </table>
              <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
                <tr valign="top">
                  <td width="100%">
                    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="table-style3">
                      <%
               for (int i = 0; i < grpmemList.length; i++) {
%>
              <tr><td colspan="2"><%= (String)grpmemList[i].getRingid()+"-----"+(String)grpmemList[i].getRinglabel()%></td></tr>
<%
                }
%>
                      <tr>
                        <td colspan="2"><br> </td>
                      </tr>
                      <tr>
                        <td width="50%" align="center"><img src="../button/sure.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:document.inputForm.submit()"></td>
                        <td width="50%" align="center"><img src="../button/cancel.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:document.inputForm.op.value='';document.inputForm.submit()"></td>
                      </tr>
                    </table>

                  </td>
                </tr>
                <tr valign="top">
                  <td width="100%"> <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
                      <tr>
                        <td class="table-styleshow" background="../image/n-9.gif" height="26">
                          warning:</td>
                      </tr>
                         <tr>
                        <td>1.After the deletion of you selected <%=ringdisplay%> group, all relevant information is lost;</td>
                      </tr>
                      <tr>
                        <td>2.Click <OK> to delete the designated <%=ringdisplay%> group and relevant information;</td>
                      </tr>
                      <tr>
                        <td>3.Click <Cancel>. No information is deleted. Return to the group management.</td>
                      </tr>
                        </table></td>
                </tr>
              </table></td>
          </tr>
        </table>
        <p>&nbsp;</p></td>
    </tr>
  </table>
  </form>
<script language="javascript">
alert("You selected <%=ringdisplay%> ringtone members in the group to delete. If you are sure to delete it, Please delete members of the group first.You can click <Cancel> without deletion of the <%=ringdisplay%> group.");
   //alert('您选择删除的<%=ringdisplay%>组内有ringtone成员,\r\n确认删除请先删除<%=ringdisplay%>组内成员,\r\n您可以选择“取消”而不删除该<%=ringdisplay%>组!');
</script>
<%
            }
            else {
%>
<script language="javascript">
   var v_ringgroup = new Array(<%= groupringgroup.length+ "" %>);
   var v_grouplabel = new Array(<%= groupringgroup.length+ "" %>);
<%
            for (int i = 0; i < groupringgroup.length;i++) {
%>
   v_ringgroup[<%= i + "" %>] = '<%=groupringgroup[i].getRinggroup() %>';
   v_grouplabel[<%= i + "" %>] = '<%=groupringgroup[i].getGrouplabel() %>';
<%
            }
%>

   var   ringdisplay = "<%=  ringdisplay  %>";
   function addGroup () {
      var fm = document.inputForm;
      if (trim(fm.grouplabel.value) == '') {
        // alert('请输入新增的' + ringdisplay + '组名称!');
         alert('Please input the new ' + ringdisplay +' group name!');
         fm.grouplabel.focus();
         return;
      }
      if (!CheckInputStr(fm.grouplabel,ringdisplay +' group name'))
         return;
       <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.grouplabel.value,40)){
            alert("The group name should not exceed 40 bytes!");
            fm.grouplabel.focus();
            return;
          }
        <%
        }
        %>
      fm.op.value = 'add';
      fm.submit();
   }

   function delGroup () {
      var fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert('Please delete the ' + ringdisplay + 'group first!');
         fm.grouplabel.focus();
         return;
      }
      //if (confirm('您确认要删除这个'+ ringdisplay + '组吗?') == 0)
       if (confirm('Are you sure to delete the '+ ringdisplay + ' group?') == 0)
         return;
      fm.op.value = 'del';
      fm.submit();
   }

   function setGroup () {
      var fm = document.inputForm;
      if (trim(fm.grouplabel.value) == '') {
       // alert('请输入需要修改的' + ringdisplay + '组!');
        alert("Please input the "+ ringdisplay + " group to modify!");
         fm.grouplabel.focus();
         return;
      }
       <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.grouplabel.value,40)){
            alert("The group name should not exceed 40 bytes!");
            fm.grouplabel.focus();
            return;
          }
        <%
        }
        %>
      fm.op.value = 'set';
      fm.submit();
   }

   function selectGroup () {
      var fm = document.inputForm;
      var index = fm.grouplist.value;
      if (index == null)
         return;
      if (index == '') {
         fm.grouplabel.focus();
         return;
      }
      fm.grouplabel.value = v_grouplabel[index];
      fm.grpLabel.value = v_grouplabel[index];
      fm.crid.value = v_ringgroup[index];
      fm.ringgroup.value = v_ringgroup[index];
      fm.grouplabel.focus();
   }

   function member () {
      fm = document.inputForm;
      var op_mode = '<%= mode %>';
      var group_index = '<%= groupindex %>';
      if (trim(fm.crid.value) == '') {
         alert('Please select the '+ ringdisplay + 'group!');
         fm.grouplabel.focus();
         return;
      }

      document.URL = 'grpringgroupMember.jsp?ringgroup='+fm.crid.value + '&grpLabel='+fm.grpLabel.value+ '&amp;groupindex=' + group_index +'&amp;groupid=<%=groupid %>&amp;mode=' + op_mode;
   }


</script>
<form name="inputForm" method="post" action="grpringgroup.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="crid" value="">
<input type="hidden" name="mode" value="<%= mode %>"/>
<input type="hidden" name="groupid" value="<%= groupid %>"/>
<input type="hidden" name="groupindex" value="<%= groupindex %>"/>
<input type="hidden" name="grpLabel" value="">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td> <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>

           <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
                  <table border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                      <td>
                       <!-- % pageContext.include("myRingToolbar.jsp"); %>  -->
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
      <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
                <tr>
                  <td width="28"><img src="../image/home_r14_c3.gif" width="28" height="31"></td>
                  <td background="../image/home_r14_c5bg.gif"><font color="#006600"><b></b>
                    <b><font class="font"> <%=  ringdisplay  %> group management</font></b></font></td>
                  <td width="12"><img src="../image/home_r14_c5.gif" width="12" height="31"></td>
                </tr>
              </table>
  <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
    <tr valign="top">
      <td width="100%"> <table width="100%" border="0" cellpadding="2" cellspacing="1" class="table-style3">
          <tr>
            <td rowspan="4"> <select name="grouplist" size="6" class="select-style3" <%= groupringgroup.length == 0 ? "disabled " : "" %>onclick="javascript:selectGroup()">
                <%
            for (int i = 0; i < groupringgroup.length; i++) {

%>
                <option value="<%= i + "" %>"><%= groupringgroup[i].getRinggroup()+ "--------" + groupringgroup[i].getGrouplabel() %></option>
                <%
            }
%>
              </select> </td>
            <td align="right">Group number &nbsp;</td>
            <td><%= groupid %></td>
          </tr>
          <tr>
            <td align="right"><%=  ringdisplay  %>Group ID&nbsp;</td>
            <td><input type="text" name="ringgroup" value="" disabled class="input-style1"></td>
          </tr>
          <tr>
            <td align="right"><%=  ringdisplay  %>Group name&nbsp;</td>
            <td><input type="text" name="grouplabel" value="" maxlength="40" class="input-style1"></td>
          </tr>
          <tr>
            <td colspan="2"> <table border="0" width="100%" class="table-style2">
                <tr>
                  <td width="25%" align="center"><img src="../manager/button/member.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:member()"></td>
                  <td width="25%" align="center"><img src="../manager/button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addGroup()"></td>
                  <td width="25%" align="center"><img src="../manager/button/change.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:setGroup()"></td>
                  <td width="25%" align="center"><img src="../manager/button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delGroup()"></td>
                </tr>
              </table></td>
          </tr>
        </table>

      </td>
    </tr>
      <tr valign="top">
          <td width="100%"> <table width="98%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
              <tr >
                <td class="table-styleshow" background="../image/n-9.gif" height="26" bgcolor="#FFFFFF">
                 Help Info:</td>
              </tr>
          <tr>
          
            <td>1.  The <%=ringdisplay%> group consists of a number of items.  It is played in the group randomly.</td>
          </tr>

          <tr>
            <td>2.  Input <%=  ringdisplay  %> group name, and click "Add" to add a group.</td>
          </tr>
          <tr>
            <td>3.  Select a <%=  ringdisplay  %> group, and click "Manage" to manage the <%=ringdisplay%> group.</td>
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
        }
        else {
%>
<script language="javascript">
 	alert('Please log in to the system first!');
<%	session.setAttribute("USERNUMBER",null); %>
	parent.document.location.href = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + groupid + ringdisplay  + " is abnormal during the group management!");
        sysInfo.add(sysTime + groupid + e.toString());
        vet.add( ringdisplay + " Error occurs during the group management!");
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
    }
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.phoneAdm" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public String display(String groupName, String ringLabel) {
        String str = "";
        int len = (groupName.getBytes()).length;
        for (int i = 0; i < 20 - len; i++)
            str = str ;
        return groupName + str + ringLabel;
    }
%>
<html>
<head>
<title>Manage calling numbers group</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">

<%
    String sysTime = "";
    String craccount = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        if (operID != null && purviewList.get("13-11") != null){
            String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
            craccount = request.getParameter("craccount") == null ? "" : ((String)request.getParameter("craccount")).trim();
            manSysPara msp = new manSysPara();
            if(!msp.isAdUser(craccount)){
            zxyw50.Purview purview = new zxyw50.Purview();
            if(!purview.CheckOperatorRight(session,"13-11",craccount)){
            	throw new Exception("You have no right to manage this subsciber!");
            }
//            String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
            String groupid = request.getParameter("groupid") == null ? "" : ((String)request.getParameter("groupid")).trim();
            String grouplabel = request.getParameter("grouplabel") == null ? "" : transferString(((String)request.getParameter("grouplabel")).trim());

            Hashtable hash = new Hashtable();
            Vector vetCallingGroup = new Vector();
            Vector useInfo = new Vector();
            Hashtable tmp = new Hashtable();
            Hashtable result = new Hashtable();

            HashMap map = new HashMap();
            // zxyw50.Purview purview = new zxyw50.Purview();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","511");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2",groupid);
            map.put("PARA3",grouplabel);
            map.put("PARA4","ip:"+request.getRemoteAddr());
            phoneAdm  phoneadm = new phoneAdm();
            if(checkLen(grouplabel,40))
            	throw new Exception("The name of your inputted calling number group is too long in length! Please re-enter!");//您输入的主叫号码组名称长度超过限制,请重新输入
            if (op.equals("add")) {
                hash.put("usernumber",craccount);
                hash.put("grouplabel",grouplabel);
                hash.put("opermode","1");
                hash.put("ipaddress",request.getRemoteAddr());
                hash.put("opersource",operName);
                phoneadm.addCallingGroup(hash);
                sysInfo.add(sysTime + operName + " add user " + craccount + "\'s calling number group " + grouplabel );//增加用户  主叫号码组
                map.put("DESCRIPTION", "Add" );
                purview.writeLog(map);
            }
            // 如果是删除铃音组
            if (op.equals("del")) {
                hash.put("usernumber",craccount);
                hash.put("callinggroup",groupid);
                hash.put("opersource",operName);
                useInfo = phoneadm.getCallingGroupUseInfo(hash);
                // 如果主叫号码组内没有主叫号码,直接删除
                if (useInfo.size() == 0)
                    op = "delend";
            }
            // 如果是删除铃音组,已经被确认
            if (op.equals("delend")) {
                hash.put("usernumber",craccount);
                hash.put("callinggroup",groupid);
                hash.put("opermode","1");
                hash.put("opersource",operName);
                hash.put("ipaddress",request.getRemoteAddr());
                phoneadm.delCallingGroup(hash);
                sysInfo.add(sysTime + operName + " delete user " + craccount + "\'s calling number group " + groupid );//"删除用户" + craccount + "删除主叫号码组" + groupid );
                map.put("DESCRIPTION","Delete");
                purview.writeLog(map);
            }
            // 如果是修改铃音组
            if (op.equals("set")) {
                hash.put("usernumber",craccount);
                hash.put("callinggroup",groupid);
                hash.put("grouplabel",grouplabel);
                hash.put("opermode","1");
                hash.put("ipaddress",request.getRemoteAddr());
                hash.put("opersource",operName);
                phoneadm.editCallingGroup(hash);
                sysInfo.add(sysTime + operName + " modify user " + craccount + "\'s calling number group " + groupid );//"修改用户" + craccount + "删除主叫号码组" + groupid
                map.put("DESCRIPTION","edit" );
                purview.writeLog(map);
            }

            // 获得主叫号码组信息
            vetCallingGroup = phoneadm.getCallingGroup(craccount);
            if (op.equals("del")) {
%>
<form name="inputForm" method="post" action="phoneGroupEnd.jsp">
<input type="hidden" name="groupid" value="<%= groupid %>">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="op" value="delend">
<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
 <tr >
          <td height="26"  align="center" class="text-title" background="../image/n-9.gif"><%= craccount %>--Delete number group</td>
</tr>
 <tr >
          <td height="10"  align="center" class="text-title" >&nbsp;</td>
</tr>
<tr>
     <td valign="top" bgcolor="#FFFFFF">
     <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
     <tr valign="top">
     <td width="100%">
          <table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="table-style2">
          <tr><td colspan="2" height=30 >Name of number group:<font class="font" ><%= grouplabel %></font></td></tr>
          <tr><td colspan="2" height=30 >Current usage status:</td></tr>
          <%
               for (int i = 0; i < useInfo.size(); i++) {
          %>
           <tr><td colspan="2" style="color: #FF0000" >&nbsp;&nbsp;<%= i+1 %>. <%= (String)useInfo.get(i) %></td></tr>
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
      <td width="100%">
          <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
          <tr>
          <td class="table-styleshow" background="../../image/n-9.gif" height="26">
          Warning Info:</td>
            </tr>
            <tr>
              <td>1.Numbers in the group will all be deleted after you delete the selected number group;</td>
            </tr>
            <tr>
              <td>2.Click "Ok" to delete the selected number group and all its relevant information; </td>
            </tr>
            <tr>
              <td>3.Click "Cancel" to give up and return to Number Group Management.</td>
            </tr>
            </table>
	</td>
    </tr>
    </table>
</td>
</tr>
</table>
</form>
<script language="javascript">
   alert('The number group you wish to delete contains still numbers. \r\n If the number group is deleted, all numbers in it will then be lost. \r\n You can choose "Cancel" to give up.');
</script>
<%
            }
            else {
%>
<script language="javascript">
   var v_groupid = new Array(<%= vetCallingGroup.size() + "" %>);
   var v_grouplabel = new Array(<%= vetCallingGroup.size() + "" %>);
<%
            for (int i = 0; i < vetCallingGroup.size(); i++) {
                hash = (Hashtable)vetCallingGroup.get(i);
%>
   v_groupid[<%= i + "" %>] = '<%= (String)hash.get("callinggroup") %>';
   v_grouplabel[<%= i + "" %>] = '<%= (String)hash.get("grouplabel") %>';
<%
            }
%>


   function addGroup () {
      var fm = document.inputForm;
      if (trim(fm.grouplabel.value) == '') {
         alert('Please enter the new number group name!');//请输入新增的主叫号码组名称
         fm.grouplabel.focus();
         return;
      }
     if (!CheckInputStr(fm.grouplabel,'Name of calling number group'))
         return;
    if(!(/[ -}]/.test(fm.grouplabel.value)))
    {
      alert("Illegal character input!");
      fm.grouplabel.focus();
      fm.grouplabel.select();
      return false;
    }
     if(findGroup(0)){
         alert('The number group you entered has existed. Please re-enter!');//您输入的主叫号码组已经存在,请重新输入!
         fm.grouplabel.focus();
        return;
     }
      fm.op.value = 'add';
      fm.submit();
   }
   function findGroup (flag) {
      var fm = document.inputForm;
      var grouplabel = trim(fm.grouplabel.value);
      if(flag==0){
       for (i = 0; i < v_grouplabel.length; i++) {
         if (grouplabel == leftTrim(v_grouplabel[i])){
            return true;
          }
       }
      }else if(flag==1){
         var  groupid = fm.groupid.value;
         for (i = 0; i < v_grouplabel.length; i++) {
           if (grouplabel == leftTrim(v_grouplabel[i]) && groupid!=v_groupid[i])
              return true;
         }
      }
      return false;
   }
   function delGroup () {
      var fm = document.inputForm;
      if (trim(fm.groupid.value) == '') {
         alert('Please first select the number group you wish to delete!');//请先选择需要删除的主叫号码组
         fm.grouplabel.focus();
         return;
      }
      if (! confirm('Are you sure you want to delete this number group?'))//您是否确认删除这个主叫号码组
         return;
      fm.op.value = 'del';
      fm.submit();
   }
   function setGroup () {
      var fm = document.inputForm;
      if (trim(fm.groupid.value) == '') {
         alert('Please select the number group to be modified!');
         fm.grouplabel.focus();
         return;
      }
      if (trim(fm.grouplabel.value) == '') {
         alert('Please enter the number group to be modified!');//请输入需要修改的主叫号码组
         fm.grouplabel.focus();
         return;
      }
      if (!CheckInputStr(fm.grouplabel,'Name of number group'))
         return;
    if(!(/[ -}]/.test(fm.grouplabel.value)))
         {
           alert("Illegal character input!");
           fm.grouplabel.focus();
           fm.grouplabel.select();
           return false;
         }
      if(findGroup(1)){
         alert('The number group you wish to modify has existed. Please re-enter!');
         fm.grouplabel.focus();
         return;
     }
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
      fm.groupid.value = v_groupid[index];
      fm.grouplabel.focus();
   }

   function onBack(){
     location.href = "phoneGroup.jsp";
   }


   function member () {
      fm = document.inputForm;
	  if (trim(fm.groupid.value) == '') {
		 alert('Please first select the number group you wish to manage!');//请先选择需要维护的主叫号码组
		 fm.grouplabel.focus();
		 return;
	  }
	  var memberURL = 'phoneMember.jsp?phonegroup=' + fm.groupid.value + "&craccount=" + fm.craccount.value;
      window.open(memberURL,'member','width=550, height=300,top='+((screen.height-300)/2)+',left='+((screen.width-550)/2));
   }
</script>
<form name="inputForm" method="post" action="phoneGroupEnd.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="groupid" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<table border="0" align="center" height="400" width="90%" class="table-style2" >
  <tr valign="center">
  <td>
  <table border="0" align="center" class="table-style2">
      <tr >
          <td height="26" colspan=2 align="center" class="text-title" background="../image/n-9.gif"><%= craccount %>--Manage numbers group</td>
      </tr>
      <tr >
          <td height="15" colspan=2 align="center" >&nbsp;</td>
      </tr>
      <tr valign="top">
      <td width="100%">
          <table width="100%"  border="0" class="table-style2" cellpadding="2" cellspacing="1" >
           <tr>
           <td rowspan="3">
             <select name="grouplist" size="6" class="select-style3" <%= vetCallingGroup.size() == 0 ? "disabled " : "" %>onclick="javascript:selectGroup()">
                            <%
             for (int i = 0; i < vetCallingGroup.size(); i++) {
                tmp = (Hashtable)vetCallingGroup.get(i);
                if (! ((String)tmp.get("callinggroup")).equals("0")) {
             %>
                   <option value="<%= i + "" %>"><%= display((String)tmp.get("grouplabel"),"") %></option>
             <%
                }
             }
             %>
             </select> </td>
            <td align="right" width=95 >Subscriber number:</td>
            <td><%= craccount %></td>
           </tr>
           <tr>
           <td align="right" width="15%">Number group name&nbsp;</td>
           <td width="35%">
             <input type="text" name="grouplabel" value="" maxlength="40" class="input-style1">
           </td>
           </tr>

          <tr>
            <td colspan="2"> <table border="0" width="100%" class="table-style2">
                <tr>
                  <td width="20%" align="center"><img src="../button/member.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:member()"></td>
                  <td width="20%" align="center"><img src="../button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addGroup()"></td>
                  <td width="20%" align="center"><img src="../button/change.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:setGroup()"></td>
                </tr>
                <tr>
                  <td width="20%" align="center"><img src="../button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delGroup()"></td>
                  <td width="20%" align="center"></td>
                  <td width="20%" align="center"><img src="../button/back.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onBack()"></td>
                </tr>
              </table></td>
          </tr>
         <tr>
          <td colspan=3>
          <table border="0" width="100%" class="table-style2">
            <tr>
                <td class="table-styleshow" background="../image/n-9.gif" height="26">
                  Notes:</td>
              </tr>
              <tr>
                <td style="color: #FF0000">1.Number Group Management allows you to play the same ringback tone for all numbers within the group; </td>
              </tr>
              <tr>
              <td style="color: #FF0000">2.To add, modify and delete a calling number, choose a number group and click "Manage";</td>
              </tr>
              <tr>
              <td style="color: #FF0000">3.Deletion of a number group will result in the deletion of all numbers within this group. </td>
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
            }else{
%>
                 <script language="javascript">
                   var str = 'Sorry! the number ' +<%= craccount %>+' you entered is ad subscriber,can not use the system!';
                   alert(str);
                   document.URL = 'phoneGroup.jsp';
                 </script>
<%
            }
        }
        else {
            if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = '../enter.jsp';
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
        sysInfo.add(sysTime + craccount +  ",Exception occurred in managing ringtone groups!");//铃音群组管理过程出现异常
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add( "Error occurred in managing ringtone groups!");//铃音群组管理错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/phoneGroup.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

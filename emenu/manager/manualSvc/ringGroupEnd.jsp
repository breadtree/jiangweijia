<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Ringtone group management</title>
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
    int isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage",0);
    int ismultimedia = zte.zxyw50.util.CrbtUtil.getConfig("ismultimedia",0);
    int imageup = zte.zxyw50.util.CrbtUtil.getConfig("imageup",0);
    try {
        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null && purviewList.get("13-10") != null){
          boolean flag = false;
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        craccount = request.getParameter("craccount") == null ? "" : ((String)request.getParameter("craccount")).trim();
         manSysPara msp = new manSysPara();
        if(!msp.isAdUser(craccount)){
        zxyw50.Purview purview = new zxyw50.Purview();
        if(!purview.CheckOperatorRight(session,"13-10",craccount)){
            	throw new Exception("You have no right to manage this subsciber!");
        }
        String crid = request.getParameter("crid") == null ? "" : ((String)request.getParameter("crid")).trim();
        String grouplabel = request.getParameter("grouplabel") == null ? "" : transferString(((String)request.getParameter("grouplabel")).trim());
        String mediatype = request.getParameter("mediatype") == null ? "1" : transferString(((String)request.getParameter("mediatype")).trim());
        if(checkLen(grouplabel,40))
           	throw new Exception("The length of the ringtone group name you entered has exceeded the length limit. Please re-enter!");//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Æ³ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½!
        Hashtable hash = new Hashtable();
        Vector vetRingGroup = new Vector();
        Vector useInfo = new Vector();
        Hashtable tmp = new Hashtable();
        Hashtable result = new Hashtable();
        ringAdm ringadm = new ringAdm();

            // Èç¹ûÊÇÔö¼ÓÁåÒô×é
            HashMap map = new HashMap();
            //zxyw50.Purview purview = new zxyw50.Purview();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","510");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2",crid);
            map.put("PARA3",grouplabel);
            map.put("PARA4","ip:"+request.getRemoteAddr());
            if (op.equals("add")) {
                hash.put("usernumber",craccount);
                hash.put("grouplabel",grouplabel);
                hash.put("mediatype",mediatype);
                ringadm.addRingGroup(hash);
                sysInfo.add(sysTime + operName + " add user " + craccount + ",ringtone group " + grouplabel ); //Ôö¼ÓÓÃ»§  ÁåÒô×é
                map.put("DESCRIPTION","Add" );
                purview.writeLog(map);

            }
            // Èç¹ûÊÇÉ¾³ýÁåÒô×é
            if (op.equals("del")) {
                useInfo = ringadm.getRingUseInfo(craccount,crid,"2");
                // Èç¹ûÁåÒô×éÃ»ÓÐ±»Ê¹ÓÃ,Ö±½ÓÉ¾³ý
                if (useInfo.size() == 0)
                    op = "delend";
            }
            // Èç¹ûÊÇÉ¾³ýÁåÒô×é,ÒÑ¾­±»È·ÈÏ
            if (op.equals("delend")) {
                hash.put("usernumber",craccount);
                hash.put("ringgroup",crid);
                hash.put("ipaddr",request.getRemoteAddr());
                ringadm.delRingGroup(hash);
                sysInfo.add(sysTime + operName + " delete user " + craccount + ",ringtone group " + crid );//É¾³ýÓÃ»§  ÁåÒô×é
                map.put("DESCRIPTION",operName + " delete user " + craccount + ",ringtone group " + crid );//É¾³ýÓÃ»§  ÁåÒô×é
                purview.writeLog(map);
            }
            // Èç¹ûÊÇÐÞ¸ÄÁåÒô×é
            if (op.equals("set")) {
                hash.put("usernumber",craccount);
                hash.put("ringid",crid);
                hash.put("ringlabel",grouplabel);
                ringadm.editRingGroup(hash);
                sysInfo.add(sysTime + operName + " modify user " + craccount + ",ringtone group " + crid );//ÐÞ¸ÄÓÃ»§  ÁåÒô×é
                map.put("DESCRIPTION","edit");
                purview.writeLog(map);

            }
            // ²éÑ¯ÁåÒô×éÐÅÏ¢
            vetRingGroup = (Vector)ringadm.getUserRingGroup(craccount);
            if (op.equals("del")) {

%>
<form name="inputForm" method="post" action="ringGroupEnd.jsp">
<input type="hidden" name="crid" value="<%= crid %>">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="op" value="delend">
<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
 <tr >
          <td height="26"  align="center" class="text-title" background="../image/n-9.gif"><%= craccount %>--Delete ringtone group</td>
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
          <tr><td colspan="2" height=30 >Ringtone group name:<font class="font" ><%= grouplabel %></font></td></tr>
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
           <td width="50%" align="center"><img src="../../button/sure.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:document.inputForm.submit()"></td>
           <td width="50%" align="center"><img src="../../button/cancel.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:document.inputForm.op.value='';document.inputForm.submit()"></td>
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
              <td>1. When the selected ringtone group has been deleted, all relevant information are also be lost.</td>
            </tr>
            <tr>
              <td>2.Click the OK button to delete the selected ringtone group and all relevant information.</td>
            </tr>
            <tr>
              <td>3.By clicking the Cancel button, no information will be deleted and it will return to the Ringtone Group Management</td>
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
   alert('The ringtone group you want to delete is still in use. \r\n If this ringtone group is deleted, all related info will be lost. \r\n You select Cancel to cancel deleting this ringtone!');//ï¿½ï¿½Ñ¡ï¿½ï¿½É¾ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ê¹ï¿½ï¿?\r\nï¿½ï¿½ï¿½É¾ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½é½«ï¿½á¶ªÊ§ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ï?\r\nï¿½ï¿½ï¿½ï¿½ï¿½Ñ¡ï¿½ï¿½È¡ï¿½ï¿½ï¿½É¾ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿?
</script>
<%
            }
            else {
%>
<script language="javascript">
   var v_ringgroup = new Array(<%= vetRingGroup.size() + "" %>);
   var v_grouplabel = new Array(<%= vetRingGroup.size() + "" %>);
   var v_mediatype = new Array(<%= vetRingGroup.size() + "" %>);
<%
            for (int i = 0; i < vetRingGroup.size(); i++) {
                hash = (Hashtable)vetRingGroup.get(i);
%>
   v_ringgroup[<%= i + "" %>] = '<%= (String)hash.get("ringgroup") %>';
   v_grouplabel[<%= i + "" %>] = '<%= (String)hash.get("grouplabel") %>';
   v_mediatype[<%= i + "" %>] = '<%= (String)hash.get("mediatype") %>';
<%
            }
%>

   function addGroup () {
      var fm = document.inputForm;
      if (trim(fm.grouplabel.value) == '') {
         alert("Please enter the new ringtone group name to be added!");//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
         fm.grouplabel.focus();
         return;
      }
      if (!CheckInputChar1(fm.grouplabel,"Ringtone group name"))//ÁåÒô×éÃû³Æ
         return;
      fm.op.value = 'add';
<%if(isimage != 1){%>
      fm.mediatype.value="1";
<%}%>
      fm.submit();
   }

   function delGroup () {
      var fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert("Please select the ringtone group to be deleted!");//ÇëÏÈÑ¡ÔñÐèÒªÉ¾³ýµÄÁåÒô×é
         fm.grouplabel.focus();
         return;
      }
      if (confirm("Are you sure to delete this ringtone group?") == 0)//ÄúÈ·ÈÏÒªÉ¾³ýÕâ¸öÁåÒô×éÂð£¿
         return;
      fm.op.value = 'del';
      fm.submit();
   }

   function setGroup () {
      var fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert('Please select the ringtone group to be modified!');
         fm.grouplabel.focus();
         return;
      }
      if (trim(fm.grouplabel.value) == '') {
         alert("please enter the ringtone group to be modified!");//ÇëÊäÈëÐèÒªÐÞ¸ÄµÄÁåÒô×é
         fm.grouplabel.focus();
         return;
      }
      if (!CheckInputChar1(fm.grouplabel,"Name of ringtone group"))
         return;
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
      fm.mediatype.value = v_mediatype[index];
      fm.grouplabel.focus();
   }

   function onBack(){
     location.href = "ringGroup.jsp";
   }


   function member () {
      fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert("Please select Manage Ringtone Groups first!");//ÇëÏÈÑ¡ÔñÒª¹ÜÀíÁåÒô×é
         fm.grouplabel.focus();
         return;
      }
	  var memberURL = 'ringMember.jsp?ringgroup=' + fm.crid.value + '&grpLabel='+fm.grpLabel.value +"&craccount=" + fm.craccount.value+"&mediatype="+ fm.mediatype.value;
      window.open(memberURL,'member','width=580, height=330,top='+((screen.height-330)/2)+',left='+((screen.width-580)/2));
   }
</script>
<form name="inputForm" method="post" action="ringGroupEnd.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="crid" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="grpLabel" value="">
<table border="0" align="center" height="400" width="90%" class="table-style2" >
  <tr valign="center">
  <td>
  <table border="0" align="center" class="table-style2">
      <tr >
          <td height="26" colspan=2 align="center" class="text-title" background="../image/n-9.gif"><%= craccount %>--Ringtone group management</td>
      </tr>
      <tr >
          <td height="15" colspan=2 align="center" >&nbsp;</td>
      </tr>
      <tr valign="top">
      <td width="100%">
          <table width="100%"  border="0" class="table-style2" cellpadding="2" cellspacing="1" >
           <tr>
                 <td rowspan="4"><select name="grouplist" size="8" class="input-style1" style="width:200"  <%= vetRingGroup.size() == 0 ? "disabled " : "" %>onclick="javascript:selectGroup()">
                    <%
            for (int i = 0; i < vetRingGroup.size(); i++) {
                tmp = (Hashtable)vetRingGroup.get(i);
%>
                <option value="<%= i + "" %>"><%= (String)tmp.get("ringgroup") + "--------" + (String)tmp.get("grouplabel") %></option>
                <%
            }
%>
              </select> </td>
            <td align="right" width=95 >The subscriber number &nbsp;</td>
            <td><%= craccount %></td>
          </tr>
          <tr>
            <td align="right" width=95 >Ringtone group ID&nbsp;</td>
            <td><input type="text" name="ringgroup" value="" disabled class="input-style1"></td>
          </tr>
          <tr>
            <td align="right" width=95 >Ringtone group name&nbsp;</td>
            <td><input type="text" name="grouplabel" value="" maxlength="40" class="input-style1"></td>
          </tr>

          <%if(isimage== 1){%>
          <tr>
            <td align="right" width=95 >Mediatype&nbsp;</td>
            <td>
            <select name="mediatype" class="select-style1">
              <option value="1"><%=zte.zxyw50.util.CrbtUtil.getConfig("audioring","Audio")%></option>
              <%if(ismultimedia == 1){%>
              <option value="2"><%=zte.zxyw50.util.CrbtUtil.getConfig("videoring","Video")%></option>
             <% }%>
             <%if(imageup ==  1){%>
             <option value="4"><%=zte.zxyw50.util.CrbtUtil.getConfig("photoring","Photo")%></option>
             <% }%>
            </select>
            </td>
          </tr>
         <% }else{%>
         <input type="hidden" name="mediatype" >
        <% }%>

          <tr>
            <td colspan="2"> <table border="0" width="100%" class="table-style2">
                <tr>
                  <td width="20%" align="center"><img src="../button/member.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:member()"></td>
                  <td width="20%" align="center"><img src="../button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addGroup()"></td>
                  <td width="20%" align="center"><img src="../button/change.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:setGroup()"></td>
                  <td width="20%" align="center"><img src="../button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delGroup()"></td>
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
                <td style="color: #FF0000">1.A ringtone group is formed by many ringtones; ringtones within the group are played in order or randomly;</td>
              </tr>
               <tr>
                   <td style="color: #FF0000">2.To modify the name of  ringtone group, click "Change".</td>
               </tr>
              <tr>
                <td style="color: #FF0000">3.To add a ringtone group, enter the ringtone group name and click "Add";</td>
              </tr>
              <tr>
                <td style="color: #FF0000">4.To manage ringtones within a group, choose the ringtone group and click "Manage";</td>
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
                   document.URL = 'ringGroup.jsp';
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
        sysInfo.add(sysTime + craccount +  "Exception occurred in managing ringtone groups!");//ÁåÒôÈº×é¹ÜÀí¹ý³Ì³öÏÖÒì³£
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add( "Error in managing ringtone groups!");//ÁåÒôÈº×é¹ÜÀí´íÎó
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/ringGroup.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

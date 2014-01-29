<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.group.dataobj.*" %>
<%@ page import="zxyw50.group.context.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<html>
<head>
<title>Group ringtone management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript" src="../pubfun/JsFun.js"></script>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
	//add by sunqi 2006-06-14
	 String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");
         int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
   //add by ge quanmin 2005-07-08 for version 3.18.01
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","Ringtone provider");
    ringsourcename=transferString(ringsourcename);
    //add end
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
     //change by wxq 2005.05.31 for version 3.16.01
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String groupindex,groupid;
    if (mode.equals("manager")){
        groupindex = request.getParameter("groupindex") == null ? "" : request.getParameter("groupindex");
        groupid = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
    }else{
        groupindex = (String)session.getAttribute("GROUPINDEX");
        groupid = (String)session.getAttribute("GROUPID");
    }
    //end
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String allowUp = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
    boolean flag = (Integer.parseInt(allowUp) == 1)?true:false;
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String ifcopyring = (String)application.getAttribute("IFCOPYRING")==null?"1":(String)application.getAttribute("IFCOPYRING");
    String ringlibname = "Group ringtone management";
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
	if(ringdisplay.equals(""))
          ringdisplay = "ringtone";
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String ringid = request.getParameter("crid") == null ? "" : (String)request.getParameter("crid");
        String ringLabel = request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel"));
        if(checkLen(ringLabel,40))
        	throw new Exception("You input " + ringdisplay + " 's length of the name exceeds the limit, please input it again!");
        String ringauthor = request.getParameter("ringauthor") == null ? "" : transferString((String)request.getParameter("ringauthor"));
        String ringsource = request.getParameter("ringsource") == null ? "" : transferString((String)request.getParameter("ringsource"));
	String ringspell = request.getParameter("ringspell") == null ? "" : (String)request.getParameter("ringspell");
        String mediatype = request.getParameter("mediatype") == null ? "1" : (String)request.getParameter("mediatype");
        String errMsg="";
      boolean blexist = false;
	if (purviewList.get("12-2") == null)  {
            //如果mode的值为manager,表明是管理员进入,并且已经通过了审核,允许进入
            if (mode.equals("manager")){
                blexist = false;
            }
            else{
		errMsg = "Have no access to this function";
                blexist = true;
           }
        }
        if (!blexist&&groupid != null&&groupindex!=null) {
             Group grp = new Group();
	     grp.setGroupIndex(groupindex);
             ringAdm ringadm = new ringAdm();
	   zxyw50.Purview purview = new zxyw50.Purview();
           HashMap map = new HashMap();
           map.put("OPERID",operID);
           map.put("OPERNAME",operName);
           map.put("OPERTYPE","2001");
           map.put("RESULT","1");
	ArrayList  rList = new ArrayList();
            // 如果是Edit铃声标签
            if(op.equals("edit")) {

                RingDescInfo aRing = new RingDescInfo();
                aRing.setRingid(ringid);
                aRing.setLable(ringLabel);
//                grp.getGroupContext().editGroupRing(aRing);
		manSysRing sysring = new manSysRing();
		Hashtable hash = new Hashtable();
                    hash.put("usernumber",groupid);
                    hash.put("ringid",ringid);
                    hash.put("ringlabel",ringLabel);
                    hash.put("ringfee","0");
                    hash.put("ringauthor",ringauthor);
		    hash.put("ringsource",ringsource);
                    hash.put("ringspell",ringspell);
                    hash.put("validdate",expireTime);
                    hash.put("iffree","-1");
                    hash.put("uservalidday","0");
                    hash.put("mediatype",mediatype);
                    rList = sysring.editSysRingLabel(hash);
                sysInfo.add(sysTime + groupid + " modify " + ringdisplay + "information successfully!");
		map.put("PARA1",groupid);
                map.put("PARA2",ringid);
                map.put("PARA3","Edit ringtone");
                map.put("PARA4","ip:"+request.getRemoteAddr());
                map.put("DESCRIPTION","Modify " +ringdisplay+  ":" + ringLabel );
        	 purview.writeLog(map);
                    if(rList.size()>0){
                      session.setAttribute("rList",rList);
                    }

            }
            // 如果是删除ringtone
            if (op.equals("del")) {
                boolean used = grp.getGroupContext().isRingUseing(ringid);
                // 如果ringtone没有被使用,直接删除
                if (!used)
                    op = "delend";
            }
            // 如果是删除ringtone,已经被确认
            if (op.equals("delend")) {
                RingDescInfo aRing = new RingDescInfo();
                aRing.setRingid(ringid);
                aRing.setLable(ringLabel);
//                RingDescInfo[] aRings = new RingDescInfo[]{
//			aRing
//                };
//                grp.getGroupContext().removeGroupRings(aRings);
			manSysRing sysring = new manSysRing();
			Hashtable hash = new Hashtable();
                    hash.put("opcode","01010203");
                    hash.put("craccount",groupid);
                    hash.put("crid",ringid);
                    hash.put("ret1","");
                    hash.put("ringidtype","1");
                                     hash.put("opmode","1");
                    hash.put("ipaddr",request.getRemoteAddr().trim());
            hash.put("mediatype",mediatype);
                    Hashtable result = SocketPortocol.send(pool,hash);
                    sysInfo.add(sysTime + groupid + "Delete " + ringdisplay + "successfully!");
		    map.put("PARA1",groupid);
                    map.put("PARA2",ringid);
                    map.put("PARA3","Delete ringtone");
                    map.put("PARA4","ip:"+request.getRemoteAddr());
                    map.put("DESCRIPTION","Delete " +ringdisplay+  ":" + ringLabel );
        	    purview.writeLog(map);
            }
            // 查询个人ringtone
//            result = SocketPortocol.send(pool,hash);
//            vetRing = (Vector)result.get("data");
            if (op.equals("del")) {
%>
<form name="inputForm" method="post" action="editRing.jsp">
<input type="hidden" name="crid" value="<%= ringid %>">
<input type="hidden" name="op" value="delend">
<!--add by wxq 2005.07.21-->
<input type="hidden" name="mode" value="<%= mode %>"/>
<input type="hidden" name="groupid" value="<%= groupid %>"/>
<input type="hidden" name="groupindex" value="<%= groupindex %>"/>
<!--end-->
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
      <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
        <tr>
          <td width="28"><img src="../image/home_r14_c3.gif" width="28" height="31"></td>
          <td background="../image/home_r14_c5bg.gif"><font color="#006600"><b></b>
            <b><font class="font"> <%= ringlibname %>-><%= ringdisplay %> Delete</font></b></font></td>
          <td width="12"><img src="../image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style3" align="center">
        <tr valign="top">
              <tr><td colspan="2" align="center">The tone is being used!</td>
              </tr>
              <tr><td colspan="2"><br></td></tr>
              <tr>
                <td width="50%" align="right"><img src="../manager/button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.submit()"> &nbsp;&nbsp;</td>
                <td width="50%" > &nbsp;&nbsp;<img src="../manager/button/cancel.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.op.value='';document.inputForm.submit()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr valign="top">
        <td width="95%" align="center">
         <table width="95%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
           <tr>
                <td class="table-styleshow" background="../image/n-9.gif" height="26">
                  Warning:</td>
              </tr>

              <tr>
                <td colspan="2">1. relevant information is lost after the deletion of selected item. </td>
              </tr>
              <tr>
                <td colspan="2">2.Click <OK> to delete the specified and all relevant information;</td>
              </tr>
              <tr>
                <td colspan="2">3.Click <Cancel> to cancel the deletion and return to edit it.</td>
              </tr>
            </table></td>
        </tr>
  </table>
</form>
<script language="javascript">
   alert('The selected item for deletion is being used,\r\nif you delete it, all relevant information is lost,\r\nYou can click <Cancel> to abort the deletion!');
</script>
<%
            }
            else {
            grp.getGroupContext().loadGroupRingLibrary();
            RingInfo[] vetRing = (RingInfo[])grp.getRingLibrary();
            if(vetRing==null)
	            vetRing = new RingInfo[0];
%>

<script language="javascript">
   var v_ringid = new Array(<%= vetRing.length + "" %>);
   var v_ringlabel = new Array(<%= vetRing.length + "" %>);
   var v_ringauthor = new Array(<%= vetRing.length + "" %>);
   var v_ringsource = new Array(<%= vetRing.length + "" %>);
   var v_ringspell = new Array(<%= vetRing.length + "" %>);
   var v_mediatype = new Array(<%= vetRing.length + "" %>);
<%
            for (int i = 0; i < vetRing.length; i++) {

%>
   v_ringid[<%= i + "" %>] = '<%= vetRing[i].getRingid() %>';
   v_ringlabel[<%= i + "" %>] = '<%= vetRing[i].getFileName()%>';
   v_ringauthor[<%= i + "" %>] = '<%= vetRing[i].getRingauthor()%>';
   v_ringsource[<%= i + "" %>] = '<%= vetRing[i].getRingsource()%>';
   v_ringspell[<%= i + "" %>] = '<%= vetRing[i].getRingspell() %>';
   v_mediatype[<%= i + "" %>] = '<%= vetRing[i].getMediatype() %>';
<%
            }
%>

   var   ringdisplay = "<%=  ringdisplay  %>";
   function selectPersonalRing () {
      var fm = document.inputForm;
      var index = fm.personalRing.value;
      if (index == null)
         return;
      if (index == '') {
         fm.ringLabel.focus();
         return;
      }
      fm.crid.value = v_ringid[index];
      fm.ringLabel.value = v_ringlabel[index];
      fm.ringauthor.value = v_ringauthor[index];
      fm.ringsource.value = v_ringsource[index];
      fm.ringspell.value = v_ringspell[index];
      fm.mediatype.value = v_mediatype[index];
      fm.ringLabel.focus();
   }

   function edit () {
      var fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert('Please choose '+ringdisplay+' to edit.');
         return;
      }
      if (trim(fm.ringLabel.value) == '') {
         alert('Please choose '+ringdisplay+' to edit.');
         return;
      }
      if (!CheckInputStr(fm.ringLabel,ringdisplay+' name'))
         return;

      if (trim(fm.ringspell.value) == '') {
         alert('Please input ringtone spell!');
         fm.ringspell.focus();
         return;
      }
      if (!CheckInputChar1(fm.ringspell, 'Ringtone spell'))
         return;
      <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.ringLabel.value,40)){
            alert("The ringtone name should not exceed 40 bytes!");
            fm.ringLabel.focus();
            return;
          }
          if(!checkUTFLength(fm.ringspell.value,20)){
            alert("The ringspell should not exceed 20 bytes!");
            fm.ringspell.focus();
            return;
          }
          if(!checkUTFLength(fm.ringauthor.value,40)){
            alert("The Singer name should not exceed 40 bytes!");
            fm.ringauthor.focus();
            return;
          }
        <%
        }
        %>
      fm.op.value = 'edit';
      fm.submit();
   }

   function del () {
      var fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert('Please choose '+ringdisplay+' to delete.');
         return;
      }
      if (! confirm('Are you sure to delete this '+ ringdisplay + '?'))
         return;
      fm.op.value = 'del';
      fm.submit();
   }

   function tryListen () {
      fm = document.inputForm;
      var  index = fm.personalRing.selectedIndex;
      if (trim(fm.crid.value) == '') {
         alert('Please choose '+ringdisplay+' first,then listen.');
         return;
      }
      var tryURL = '../manager/tryListen.jsp?ringid=' + fm.crid.value+'&ringname='+v_ringlabel[index]+'&ringauthor='+v_ringauthor[index] + '&usernumber=&mediatype='+v_mediatype[index];
      if(trim(v_mediatype[index])=='1'){
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(v_mediatype[index])=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(v_mediatype[index])=='4'){
        tryURL = '../tryView.jsp?ringid=' + fm.crid.value+'&ringname='+v_ringlabel[index]+'&ringauthor='+v_ringauthor[index] + "'&usernumber=&mediatype="+v_mediatype[index];
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
   }

   function ringInfo () {
      fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert('Please choose '+ ringdisplay + ' first.');
         return;
      }
      infoWin = window.open('ringInfo.jsp?usernumber=<%= groupid %>&ringid=' + fm.crid.value,'infoWin','width=400, height=330');
   }
</script>


<form name="inputForm" method="post" action="editRing.jsp">
<input type="hidden" name="crid" value="">
<input type="hidden" name="op" value="">
<!--change by wxq 2005.06.16-->
<input type="hidden" name="mode" value="<%= mode %>"/>
<input type="hidden" name="groupid" value="<%= groupid %>"/>
<input type="hidden" name="groupindex" value="<%= groupindex %>"/>
<!--end-->
<input type="hidden" name="mediatype" value=""/>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<table width="551" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
      <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
        <tr>
          <td width="28"><img src="../image/home_r14_c3.gif" width="28" height="31"></td>
          <td background="../image/home_r14_c5bg.gif"><font color="#006600"><b></b>
            <b><font class="font"> <%= ringlibname %></font></b></font></td>
          <td width="12"><img src="../image/home_r14_c5.gif" width="12" height="31"></td>
        </tr>
      </table>
      <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
        <tr valign="top">
          <td width="100%"> <table width="100%" border="0" cellpadding="2" cellspacing="1" class="table-style3">
              <tr>
                 <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
                 <td rowspan="5">
                  <%}else{%>
                   <td rowspan="4">
                  <%}%>
                <select name="personalRing" size="8" <%= vetRing.length == 0 ? "disabled " : "" %>onchange="javascript:selectPersonalRing()" class="select-style3">
                    <%
                for (int i = 0; i < vetRing.length; i++) {

                    String cridTmp = vetRing[i].getRingid();
                    String filname = vetRing[i].getFileName();
%>
                    <option value="<%= i + "" %>"><%= cridTmp + "--------" + filname %></option>
                    <%
            }
%>
                  </select> </td>
                <td align="right">Group code&nbsp;</td>
                <td><%= groupid %></td>
              </tr>
              <tr>
                <td align="right" valign="middle"><%= ringdisplay %> Name&nbsp;</td>
                <td valign="middle"><input type="text" name="ringLabel" value="" maxlength="40" class="input-style1"></td>
              </tr>
        <tr>
          <td align="right" valign="middle">The spell of ringtone</td>
          <td valign="middle"><input type="text" name="ringspell"  maxlength="40" class="input-style1"></td>
        </tr>
              <tr>
                <td align="right" valign="middle">Singer&nbsp;</td>
                <td valign="middle"><input type="text" name="ringauthor" value="" maxlength="40"  readonly="readonly" class="input-style1" ></td>
              </tr>
      <%
             String typeDisplay = "none";
         if("1".equals(useringsource)){
           typeDisplay = "";
         }
       %>
              <tr style="display:<%=typeDisplay%>">
                <td align="right" valign="middle"><%=ringsourcename%>&nbsp;</td>
                <td valign="middle"><input type="text" name="ringsource" value="" maxlength="40" readonly="readonly" class="input-style1" ></td>
              </tr>

              <tr>
                <td colspan="2"> <table border="0" width="100%" class="table-style2">
                    <tr>
                        <!--
                      <td width="25%" align="center"><img src="../button/info.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:ringInfo()"></td>
                          -->
                      <td width="25%" align="center"><img src="../manager/button/trylisten.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:tryListen()"></td>
                      <td width="25%" align="center"><img src="../manager/button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:edit()"></td>
                      <td width="25%" align="center"><img src="../manager/button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:del()"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
        <tr valign="top">
          <td width="100%"> <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
              <tr>
                <td class="table-styleshow" background="../image/n-9.gif" height="26">
                  Help information:</td>
              </tr>

              <tr>
                <td colspan="2">1.  After delete <%= ringdisplay %> , the ringtone of group time period is deleted too.</td>
              </tr>
              <tr>
                <td colspan="2">2.  After the deletion request is handled, it will take effective in 24 hours.</td>
              </tr>
            </table></td>
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
   var errorMsg = '<%= groupid!=null?errMsg:"Please log in to the system first!"%>';
	alert(errorMsg);
   document.location.href = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + groupid + ringlibname+ " exception occurs in the procedure!");
        sysInfo.add(sysTime + groupid + e.toString());
        vet.add(ringlibname + " the procedure is abnormal!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="editRing.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

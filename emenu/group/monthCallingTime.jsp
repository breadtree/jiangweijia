<%@page import="java.io.*"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="zxyw50.SocketPortocol"%>
<%@page import="com.zte.socket.imp.pool.SocketPool"%>
<%@page import="zxyw50.group.dataobj.*"%>
<%@page import="zxyw50.group.util.StringUtil"%>
<%@page import="zxyw50.group.context.*"%>
<%@ page import="zxyw50.CrbtUtil" %>
<%@page import="java.lang.*" %>
<%@include file="../pubfun/JavaFun.jsp"%>

<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.callingTime" scope="page"/>
<jsp:setProperty name="db" property="*"/>
<html>
<head>
<title>Group monthly time period tone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript" src="../pubfun/JsFun.js"></script>
<script language="Javascript" src="../manager/calendar.js"></script>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
  String sysTime = "";
   //�Ƿ�ʹ�ü���ģʽ���� add by ge quanmin 3.19
    String usegrpmode = CrbtUtil.getConfig("usegrpmode","0");
  //     Group grp1 = new Group();
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  //change by wxq 2005.05.31 for version 3.16.01
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
  //end
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  String allowUp = (String) application.getAttribute("ALLOWUP") == null ? "0" : (String) application.getAttribute("ALLOWUP");
  boolean flagm = (Integer.parseInt(allowUp) == 1) ? true : false;
  String colorName = (String) application.getAttribute("COLORNAME") == null ? "" : (String) application.getAttribute("COLORNAME");
  String ifcopyring = (String) application.getAttribute("IFCOPYRING") == null ? "1" : (String) application.getAttribute("IFCOPYRING");
  String allowVpn = (String) application.getAttribute("ALLOWVPN") == null ? "1" : (String) application.getAttribute("ALLOWVPN");
  String ringdisplay = (String) application.getAttribute("RINGDISPLAY") == null ? "" : (String) application.getAttribute("RINGDISPLAY");
  if (ringdisplay.equals("")) ringdisplay = "ringtone";
  boolean bljiling =  "3".equals(CrbtUtil.getConfig("providercode","0"))?true:false;
  String userringtype = request.getParameter("userringtype") == null ? "0" : request.getParameter("userringtype");
  String label = "1".equals(userringtype) ? "Calling" : "Called";
  int modefee = 0;
  //(String)((Hashtable)session.getAttribute("USERSTATUS")).get("FUNCFEE3")==null?0:Integer.parseInt((String)((Hashtable)session.getAttribute("USERSTATUS")).get("FUNCFEE3"));
  
   //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
  
  
  try {
      String strOption = "";
      String optRingList = "";
      int listCount = 0;
      SocketPool pool = (SocketPool) application.getAttribute("SOCKETPOOL");
      sysTime = SocketPortocol.getSysTime() + "--";
      String op = request.getParameter("op") == null ? "" : (String) request.getParameter("op");
      String crid = request.getParameter("crid") == null ? "" : (String) request.getParameter("crid");
      Hashtable result1 = new Hashtable();
      String errMsg = "";
      boolean blexist = false;
      String operDesc = "";
      String maxtimes = "";
      if (purviewList.get("12-10") == null) {
            //���mode��ֵΪmanager,�����ǹ���Ա����,�����Ѿ�ͨ�������,��������
            if (mode.equals("manager")){
                blexist = false;
            }
            else{
                errMsg = "You have no access to this function";//��Ȩ���ʴ˹���
                blexist = true;
            }
      }
      if (!blexist && groupid != null) {
         //���ϵͳʹ�ü���ģʽ����
        if("1".equals(usegrpmode)){
           Hashtable hash = null;
           ManGroup mangroup = new ManGroup();
           hash = mangroup.getGrpInfoByindex(groupindex);
           String grpmode=(String)hash.get("grpmode");
           maxtimes = (String)hash.get("maxtimes");
           if("1".equals(grpmode)){
           %>
  <script language="javascript">
   var errorMsg = 'You cannot perform monthly time period tone setting in Mode a!';
	alert(errorMsg);
        history.back();
        document.location.href="../manager/grpChoice.jsp?title=Month period ringtone setting&amp;target=monthCallingTime.jsp&amp;purview=11-13";
  </script>
          <%
           }
        }
        Group grp = new Group();
        grp.setGroupIndex(groupindex);
        grp.setGroupId(groupid);
        //add by wxq 2005.06.21 for version 3.16.01
        //2:��time period
        grp.setCallingType("2");
        //
        StringBuffer sb = new StringBuffer("");
        grp.getGroupContext().loadGroupGrouping();
        GroupGrouping[] groupGrouping = grp.getGroupGrouping();
        for(int i = 0; i < groupGrouping.length; i++){
            sb.append("<option value=" + groupGrouping[i].getCloseid() + ">" + (String)groupGrouping[i].getClosedescrip() + "</option>");
        }//for
        String groupstr = sb.toString();
          //add by ge quanmin 2005.07.11 for version 3.18.01
            StringBuffer sb2 = new StringBuffer("");
            grp.getGroupContext().loadGroupRingGroup();
            GroupRinggroup[] groupRinggroup=grp.getGroupRinggroup();
             for(int j= 0; j < groupRinggroup.length; j++){
                //modify by ge quanmin 2005-07-13 ���ǽ��г���ringtone��ringtone��
                grp.getGroupContext().loadGroupRingGroupMember(groupRinggroup[j].getRinggroup());
                  GroupRinggroupMember[] grpmemList = grp.getgroupRinggroupMember();
                if(grpmemList.length>0){
                sb2.append("<option value=" + groupRinggroup[j].getRinggroup() + ">" + (String)groupRinggroup[j].getGrouplabel() + "</option>");
                }
              }//for
            String ringgroupstr = sb2.toString();
            //���ringtone����
            String ringgroup=StringUtil.isEmpty(request.getParameter("ringgroup"))? "" : request.getParameter("ringgroup");
        String callingNum = request.getParameter("callingNum") == null ? "a" : request.getParameter("callingNum");
            if(callingNum.trim().equalsIgnoreCase(""))
               callingNum = "a";
        String ringID = StringUtil.isEmpty(request.getParameter("ringID")) ? "" : request.getParameter("ringID");
        String startTime = StringUtil.isEmpty(request.getParameter("startTime")) ? "-1" : request.getParameter("startTime");
        String endTime = StringUtil.isEmpty(request.getParameter("endTime")) ? "-1" : request.getParameter("endTime");
        String startday = StringUtil.isEmpty(request.getParameter("startday")) ? "a" : request.getParameter("startday");
        String startmonthday = request.getParameter("startmonthday") == null ? "" : request.getParameter("startmonthday");
        String endmonthday = request.getParameter("endmonthday") == null ? "" : request.getParameter("endmonthday");
        String endday = StringUtil.isEmpty(request.getParameter("endday")) ? "a" : request.getParameter("endday");
        String userNumber = StringUtil.isEmpty(request.getParameter("callingNum")) ? "a" : request.getParameter("callingNum");
            if(userNumber.trim().equalsIgnoreCase(""))
               userNumber = "a";
        boolean isgroup = request.getParameter("isgroup") == null ? false : (request.getParameter("isgroup").equals("1") ? true : false);
        if (isgroup)
            callingNum = request.getParameter("group") == null ? "a" : request.getParameter("group");
            userNumber = callingNum;
            String setno = request.getParameter("setno") == null ? "" : (String) request.getParameter("setno");
            String ringDate = "0";
            int index = ringID.indexOf("~");
            String ringidtype = "1";
            if (index > 0) {
                ringidtype = ringID.substring(0, index);
                ringID = ringID.substring(index + 1);
            }
            String timeDecrip = "";
            if (op.equals("add")) {
                timeDecrip = StringUtil.isEmpty(request.getParameter("timeDecrip")) ? "" : transferString((String) request.getParameter("timeDecrip"));
                if (checkLen(timeDecrip, 20))
                    throw new Exception("You input time period " + ringdisplay + " name exceeds the length limit,please re-enter!");// ���Ƴ�����������,������������
                if (callingNum.length() == 0)
                    callingNum = "";
                   //�ж��Ƿ�ʹ�õ�ringtone��
               boolean isringgroup =request.getParameter("isringgroup") ==null?false:(request.getParameter("isringgroup").equals("1")?true:false);
                Hashtable hash = new Hashtable();
                hash.put("opcode", "01010962");
                hash.put("craccount", groupid);
                //������õ���ringtone��������ringtone����
                if(isringgroup){
                hash.put("crid",ringgroup);
                }else{
                  hash.put("crid",ringID);
                }
                hash.put("callingnum", callingNum);
                hash.put("starttime", startTime);
                hash.put("endtime", endTime);
                hash.put("startdate", startday);
                hash.put("enddate", endday);
                hash.put("startweek", "01");
                hash.put("endweek", "07");
                hash.put("startday", startmonthday);
                hash.put("endday", endmonthday);
                if (callingNum.equals("") || callingNum.equals("a"))
                    hash.put("callingtype", "0");
                else if (isgroup)
                    hash.put("callingtype", "2");
                else
                    hash.put("callingtype", "1");
                hash.put("settype", "52");
                hash.put("opertype", "1");
                //�����ʹ��ringtone�������ò�ͬ��ringidtype
                if(isringgroup){
                 hash.put("ringidtype","2");
                }
                else{
                  hash.put("ringidtype",ringidtype);
                }
                hash.put("description", "YLI-" + timeDecrip);
                hash.put("setno", "");
                hash.put("setpri", "");
                result1 = SocketPortocol.send(pool, hash);
                operDesc = "Nes add group month period " + ringdisplay;//����������time period
                sysInfo.add(sysTime + groupid + " add group month period " + ringdisplay + " setting successfully!");
            }//if (add)
            else if (op.equals("del")) {
                String closeid = request.getParameter("group") == null ? "a" : request.getParameter("group");
                timeDecrip = request.getParameter("timeDecrip") == null ? "" : transferString((String)request.getParameter("timeDecrip"));
                Hashtable hash = new Hashtable();
                RingDescInfo rinfo = new RingDescInfo();
                rinfo.setRingid(ringID);
                GroupPersonalTimerRing ring = new GroupPersonalTimerRing();
                ring.setUserNumber(userNumber);
                ring.setCloseid(closeid);
                ring.setRing(rinfo);
                ring.setStartTime(startTime);
                ring.setEnddate(endday);
                ring.setStartdate(startday);
                ring.setEndTime(endTime);
                ring.setDescription(timeDecrip);
                operDesc = "Delete group month period " + ringdisplay;
                grp.getGroupContext().removeGroupTimerRings(new GroupPersonalTimerRing[]{ring});
                sysInfo.add(sysTime + groupid + " delete group month period " + ringdisplay +" successfully!");
            }//if (del)
            else if (op.equals("edit")) {
                timeDecrip = request.getParameter("timeDecrip") == null ? "" : transferString((String) request.getParameter("timeDecrip"));
                if (callingNum.length() == 0)
                    callingNum = "";
                 //�ж��Ƿ�ʹ�õ�ringtone��
                boolean isringgroup =request.getParameter("isringgroup") ==null?false:(request.getParameter("isringgroup").equals("1")?true:false);
                Hashtable hash = new Hashtable();
                hash.put("opcode", "01010962");
                hash.put("craccount", groupid);
                 //������õ���ringtone��������ringtone����
                if(isringgroup){
                hash.put("crid",ringgroup);
                }else{
                  hash.put("crid",ringID);
                }
                hash.put("callingnum", callingNum);
                hash.put("starttime", startTime);
                hash.put("endtime", endTime);
                hash.put("startdate", startday);
                hash.put("enddate", endday);
                hash.put("startweek", "01");
                hash.put("endweek", "07");
                hash.put("startday", startmonthday);
                hash.put("endday", endmonthday);
                if (callingNum.equals("") || callingNum.equals("a"))
                    hash.put("callingtype", "0");
                else if (isgroup)
                    hash.put("callingtype", "2");
                else
                    hash.put("callingtype", "1");
                hash.put("settype", "52");
                hash.put("opertype", "0");
                  //�����ʹ��ringtone�������ò�ͬ��ringidtype
                if(isringgroup){
                 hash.put("ringidtype","2");
                }
                else{
                  hash.put("ringidtype",ringidtype);
                }
                hash.put("description", timeDecrip);
                String setpri = request.getParameter("setpri") == null ? "" : (String) request.getParameter("setpri");
                hash.put("setno", "");
                hash.put("setpri", "");
                result1 = SocketPortocol.send(pool, hash);
                operDesc = "Modify group month period " + ringdisplay;//�޸ļ�����time period
                sysInfo.add(sysTime + groupid + " modify group month period " + ringdisplay + " setting successfully!");
          }//if (edit)
          if (!op.equals("")) {
              zxyw50.Purview purview = new zxyw50.Purview();
              HashMap map = new HashMap();
              map.put("OPERID", operID);
              map.put("OPERNAME", operName);
              map.put("OPERTYPE", "1210");
              map.put("RESULT", "1");
              map.put("PARA1",timeDecrip);
              map.put("PARA2",callingNum);
              map.put("PARA3",ringID);
              map.put("PARA4",groupid);
              map.put("PARA5",operDesc);
              map.put("PARA6","ip:"+request.getRemoteAddr());
              purview.writeLog(map);
          }//if
          // ��ѯ����ringtone
          grp.getGroupContext().loadGroupRingLibrary();
          RingDescInfo[] rings = grp.getRingLibrary();
          if (rings == null)
              rings = new RingDescInfo[0];
          for (int i = 0; i < rings.length; i++) {
              String cridTmp = rings[i].getRingid();
              String filname = rings[i].getFileName();
              if (!cridTmp.startsWith("99"))
                  optRingList = optRingList + "<option value=" + cridTmp + ">" + filname + "</option>";
          }//for
          //��ѯ����time period ringtone����
          grp.getGroupContext().loadAllGroupTimerRings();
          GroupPersonalTimerRing[] timers = grp.getAllTimerrings();
          if (timers == null)
              timers = new GroupPersonalTimerRing[0];
          if (timers.length > 0) {
%>
<script language="javascript">
        var s_vTimeDecrip = new Array(<%= timers.length + "" %>);
        var s_vRingID = new Array(<%= timers.length + "" %>);
        var s_vRingGroup=new Array(<%= timers.length + "" %>);
	    var s_vStartTime = new Array(<%= timers.length + "" %>);
        var s_vEndTime = new Array(<%= timers.length + "" %>);
        var s_vStartDate = new Array(<%= timers.length + "" %>);
        var s_vEndDate = new Array(<%= timers.length + "" %>);
        //change by wxq 2005.06.21 for version 3.16.01
        var s_vCallingNum  = new Array(<%= timers.length + "" %>);
        var s_vCallingtype  = new Array(<%= timers.length + "" %>);
        var s_vStartday  = new Array(<%= timers.length + "" %>);
        var s_vEndday  = new Array(<%= timers.length + "" %>);
        var s_vSetno  = new Array(<%= timers.length + "" %>);
        var s_vSetpri  = new Array(<%= timers.length + "" %>);
        var s_vringidtype=new Array(<%=timers.length+""%>)
        //end
<%
              for (int i = 0; i < timers.length; i++) {
          strOption = strOption + "<option value=" + Integer.toString(i)+">" + timers[i].getDescription()+ "</option>";
%>
        s_vTimeDecrip[<%= i + "" %>] = '<%= timers[i].getDescription() %>';
         <%if ((timers[i].getRing()==null) && (timers[i].getRinggrp()==null)){%>
          s_vRingID[<%= i + "" %>] = ' ';
        <%}else if (timers[i].getRing()!=null){%>
          s_vRingID[<%= i + "" %>] = '<%= timers[i].getRing().getRingid() %>';
        <%}else if (timers[i].getRinggrp()!=null){%>
          s_vRingGroup[<%= i + "" %>] = '<%= timers[i].getRinggrp().getRinggroup()%>';
        <%}%>
		
        s_vStartTime[<%= i + "" %>] = '<%= timers[i].getStartTime()%>';
        s_vEndTime[<%= i + "" %>] = '<%= timers[i].getEndTime()%>';
        s_vStartDate[<%= i + "" %>] = '<%= timers[i].getStartdate()%>';
        s_vEndDate[<%= i + "" %>] = '<%= timers[i].getEnddate() %>';
        //change by wxq 2005.06.21 for version 3.16.01
        <%if ((timers[i].getCallingnum().equals("")) && (timers[i].getCloseid().equals("0"))){%>
          s_vCallingNum[<%= i + "" %>] = ' ';
        <%}else if (!(timers[i].getCallingnum().equals(""))){%>
          s_vCallingNum[<%= i + "" %>] = '<%= timers[i].getCallingnum() %>';
        <%}else if (!(timers[i].getCloseid().equals("0"))){%>
          s_vCallingNum[<%= i + "" %>] = '<%= timers[i].getCloseid() %>';
        <%}%>
        s_vCallingtype[<%= i + "" %>] = '<%= timers[i].getCloseid() %>';
        s_vStartday[<%= i + "" %>] = '<%= timers[i].getStartday() %>';
        s_vEndday[<%= i + "" %>] = '<%= timers[i].getEndday() %>';
        s_vSetno[<%= i + "" %>] = '<%= timers[i].getSetno() %>';
        s_vSetpri[<%= i + "" %>] = '<%= timers[i].getSetpri() %>';
        s_vringidtype[<%= i + "" %>] = '<%= timers[i].getRingidtype()%>';
			
        //end
<%
              }//for
          }//if
%>
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="650";
</script>
<form name="inputForm" method="post" action="monthCallingTime.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="startTime" value="">
<input type="hidden" name="endTime" value="">
<input type="hidden" name="oldcrid" value="">
<input type="hidden" name="userringtype" value="<%=userringtype%>">
<!--change by wxq 2005.06.16-->
<input type="hidden" name="setpri" value="">
<input type="hidden" name="setno" value="">
<input type="hidden" name="mode" value="<%= mode %>"/>
<input type="hidden" name="groupid" value="<%= groupid %>"/>
<input type="hidden" name="groupindex" value="<%= groupindex %>"/>
<input type="hidden" name="groupname" value="<%= groupname %>"/>
<!--end-->
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
      <table width="95%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
        <tr>
                  <td width="7"><img src="../image/home_r14_c3.gif" width="7" height="32"></td>
                  <td background="../image/home_r14_c5bg.gif"><font color="#006600">
                    <b><font class="font">Month period <%= ringdisplay %></font></b></font></td>
                  <td width="27"><img src="../image/home_r14_c5.gif" width="27" height="32"></td>
        </tr>
      </table>
      <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
        <tr valign="top">
          <td width="100%">
            <table width="100%" border="0" class="table-style3" cellpadding="2" cellspacing="1">
              <tr>
                <td rowspan="10">
                  <select name="selTimeList" size="12" onchange="javascript:onselectTimeList()" class="select-style4">
                  <% if (!strOption.equals("")) out.println(strOption); %>
                  </select>
                </td>
                <td align="right" valign="middle">Name</td>
                <td valign="middle">
                  <input type="text" name="timeDecrip" value="" maxlength="20" class="input-style1">
                </td>
              </tr>
               <tr>
              <td colspan="2" align="left" style="padding-left:72px;">
				 <input type="radio" onclick="firechange(2);"  value="2" checked name="isgroup">for all caller&nbsp;&nbsp; <!--Added for MobiTel by Srinivas -->
                  <input type="radio" name="isgroup" value="0" onclick="firechange(0);">Group member number<br/>
                  <input type="radio" name="isgroup" value="1" onclick="firechange(1);" >Group member grouping
                </td>
              </tr>
              <tr>
                <td align="right" valign="middle" style="display:none" id="grpmemnumber">Group member number(grouping)</td>
                <td valign="middle">
                  <select style="display:none" name="group" size="1" class="select-style1" >
                    <%= groupstr %>
                  </select>
                  <input type="text" name="callingNum" value="" maxlength="20" class="input-style1" style="display:none">
                </td>
              </tr>

                <!--add by ge quanmin 2005-07-11-->
                       <tr>
                        <td colspan="2" align="right">
                          <input type="radio"  onclick="ringtypechange(0)" value="0" checked name="isringgroup">Group ringtone&nbsp;&nbsp;&nbsp;&nbsp;
                          <input type="radio"  onclick="ringtypechange(1)" name="isringgroup" value="1">Group ringtone grouping&nbsp;&nbsp;
                        </td>
                      </tr>
              <tr>
                <td align="right" valign="middle"><%= ringdisplay %>(Group) select</td>
                <td valign="middle">
                  <select name="ringID" size="1" class="select-style1" style="width:220px">
                  <%if (!optRingList.equals("")) out.println(optRingList);                  %>
                  </select>
                    <select style="display:none" name="ringgroup" size="1" class="select-style1" >
                     <%= ringgroupstr %>
                     </select>
                </td>
              </tr>
              <tr>
                <td align="right" valign="middle">Each month start day</td>
                <td valign="middle">
                  <select name="startmonthday" size="1" class="input-style5">
<%
        for (int j = 1; j <= 31; j++)
            out.println("<option value=" + j + ">" + String.valueOf(j) + "</option>");
%>
                  </select>&nbsp;end day&nbsp;
                  <select name="endmonthday" size="1" class="input-style5">
<%
        for (int j = 1; j <= 31; j++)
            out.println("<option " + (j == 31 ? "selected " : "") + "value=" + j + ">" + String.valueOf(j) + "</option>");
%>
                  </select>
                </td>
              </tr>
              <tr>
                <td align="right" valign="center">Start time</td>
                <td valign="center">
                  <select name="startHour" class="input-style5">
<%
        for (int j = 0; j < 24; j++)
            out.println("<option value=" + String.valueOf(j) + ">" + String.valueOf(j) + "</option>");
%>
                  </select>
                  <select name="startMinute" class="input-style5">
<%
        for (int j = 0; j < 60; j++)
            out.println("<option value=" + String.valueOf(j) + ">" + String.valueOf(j) + "</option>");
%>
                  </select>
                  <select name="startSecond" class="input-style5">
<%
        for (int j = 0; j < 60; j++)
            out.println("<option value=" + String.valueOf(j) + ">" + String.valueOf(j) + "</option>");
%>
                  </select><br/>
				   Hour&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Minute&nbsp;&nbsp;Second
                </td>
              </tr>
              <tr>
                <td align="right" valign="center">End time</td>
                <td valign="center">
                  <select name="endHour" class="input-style5">
<%
        for (int j = 0; j < 24; j++)
            out.println("<option value=" + String.valueOf(j) + ">" + String.valueOf(j) + "</option>");
%>
                  </select>
                  <select name="endMinute" class="input-style5">
<%
        for (int j = 0; j < 60; j++)
            out.println("<option value=" + String.valueOf(j) + ">" + String.valueOf(j) + "</option>");
%>
                  </select>
                  <select name="endSecond" class="input-style5">
<%
        for (int j = 0; j < 60; j++)
            out.println("<option value=" + String.valueOf(j) + ">" + String.valueOf(j) + "</option>");
%>
                  </select></br> Hour&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Minute&nbsp;&nbsp;Second
                </td>
              </tr>
              <tr>
                <td align="right">Start date</td>
                <td valign="center">
                  <input type="text" name="startday" value="" maxlength="10" class="input-style1" readonly onclick="OpenDate(startday);">
                </td>
              </tr>
              <tr>
                <td align="right">End date</td>
                <td valign="center">
                  <input type="text" name="endday" value="" maxlength="10" class="input-style1" readonly onclick="OpenDate(endday);">
                </td>
              </tr>
              <tr>
                <td colspan="4" style="padding-left:280px;">
                  <img src="../manager/button/add.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:addTime()">
                  &nbsp;&nbsp;&nbsp;
                  <img src="../manager/button/change.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:editTime()">
                  &nbsp;&nbsp;&nbsp;
                  <img src="../manager/button/del.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:delTime()">
                </td>
              </tr>
            </table>
          </td>
        </tr>
               <tr valign="top">
          <td width="100%"> <table width="98%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
              <tr >
                <td class="table-styleshow" background="../image/n-9.gif" height="26" bgcolor="#FFFFFF">
                 Help:</td>
              </tr>
<%
        if(bljiling){
%>
                      <tr>
                        <td>1.  The setting of each month period can allow you to play the special tone in a time period of each month;
                       </td>
                      </tr>
                      <tr>
                        <td>2.  If the <%=label%> number is a fixed number, Please input 0 + area code + fixed number
                         <% if(allowVpn.equals("1")){ %>, if the short number is the <%=label%> number,input the short number directly <%}%>;  </td>
                      </tr>
                      <tr>
                        <td>3.  If <%=label%> number is null, play the special ringtone in the set time period every day ;</td>
                      </tr>
                      <tr>
                        <td>4.  If the start and end date of the time period is not configured, the system default start/end date is from "2000.01.01" to "2999.01.01";
                        </td>
                      </tr>
                        <td>5.  The start/end time of the time period is in the 24 hour mode, For example, "21:30:00", the total number of tones should not exceed <%= ("0".equals(userringtype)?(String)((Hashtable)session.getAttribute("USERSTATUS")).get("maxnumber"):(String)((Hashtable)session.getAttribute("USERSTATUS")).get("maxnumber1")) %>;
                        </td>
                      </tr>
                      <tr>
                        <td>
                          6.  Start date of each month and end date of each indicate that the system plays the set special ringtone on the day each month;
                        </td>
                      </tr>
                      <tr>
                        <td>
                          7.  The setting of each month period can allow you to play the set special ringtone in a time period of each month.
                        </td>
                      </tr>
<%
        }//if
        else{
%>
                      <tr>
                        <td>1.  The  setting of each month period can allow you to play the special tone in a time period of each month;</td>
                      </tr>
                      <tr>
                        <td>2.  If the <%=label%> number is a fixed number, please input 0 + area code + fixed number. <% if(allowVpn.equals("1")){ %>,if the short number is <%=label%> numberinput the short number directly. <%}%>; </td>
                      </tr>

				  <tr>

                  <td>3.  If <%=label%> number is null, play the special <%= ringdisplay %> in the set time period every day.
                  </td>
                  </tr>
                  <tr>
                  <td>4.  If the start and end date of the time period is not configured, the system default start/end date is from "2000.01.01" to "2999.01.01";
                   </td>
                   </tr>
                  <td>5.  The start/end time of the time period is in the 24 hour mode, For example, "21:30:00", up to <%= maxtimes%> time periods can be set;
                  </td>
                </tr>
                <tr>
                  <td>
                  6.  Start date of each month and end date of each indicate that the system plays the set special tone on the day each month;
                  </td>
                </tr>
                <tr>
                  <td>
                  7.  Time period <%= ringdisplay %> name is unique and can not be modified.
                  </td>
                </tr>
<%
        }//else
%>
                     </table>

                  </td>
                </tr>
      </table>
    </td>
  </tr>
</table>
</td></tr></table></form>

<script language="Javascript">
   document.inputForm.endHour.value = '23';
   document.inputForm.endMinute.value = '59';
   document.inputForm.endSecond.value = '59';
   function firechange(n){
      if(n == 0){
         document.all("group").style.display= 'none';
	       document.all("callingNum").value="";
         document.all("callingNum").style.display= 'block';
   		   document.getElementById("grpmemnumber").style.display= 'block'; //Adedd for MobiTel by Srinivas
  		   document.all("callingNum").value="";//Adedd for MobiTel by Srinivas
	    }else  if(n == 2){ //Adedd for MobiTel by Srinivas
	       document.all("group").style.display= 'none';
		   document.all("callingNum").style.display= 'none';
   		   document.getElementById("grpmemnumber").style.display= 'none'; 
  		   document.all("callingNum").value="";
      }else{
         document.all("group").style.display= 'block';
	     document.all("group").value="";
         document.all("callingNum").style.display= 'none';
  		 document.getElementById("grpmemnumber").style.display= 'block'; //Adedd for MobiTel by Srinivas
      }
    }
   var  ringdisplay = "<%=  ringdisplay  %>";
   function onselectTimeList(){
     var fm = document.inputForm;
     var index = fm.selTimeList.selectedIndex;
     if(index==-1)
       return;
     fm.timeDecrip.value = s_vTimeDecrip[index];
      var isringgroup=parseInt(s_vringidtype[index])-1;
      if (isringgroup.toString() == '0'){
       ringtypechange(0);
       fm.isringgroup[0].checked = true;
     }
     else{
       ringtypechange(1);
       fm.isringgroup[1].checked = true;
     }
     var temp = s_vCallingNum[index];
     var isgroup = s_vCallingtype[index];
    if (isgroup == '0'){
	 	if(temp ==' ') { // Added for MobiTel
		 firechange(2);
		 fm.isgroup[0].checked = true; 
	     }//end of added
	   else {
         firechange(0);
         fm.isgroup[1].checked = true; // changed 0 to 1 for MobiTel
         fm.callingNum.value = trim(temp);
       }
     }else { 
         firechange(1);
         fm.isgroup[2].checked = true; 
	     fm.group.value = trim(temp);
       }
     fm.ringID.value = s_vRingID[index];
     fm.ringgroup.value=s_vRingGroup[index];
     setTime(s_vStartTime[index],1);
     setTime(s_vEndTime[index],2);
     fm.startday.value = s_vStartDate[index];
     fm.endday.value = s_vEndDate[index];
     fm.startmonthday.value = s_vStartday[index];
     fm.endmonthday.value = s_vEndday[index];
     fm.setpri.value = s_vSetpri[index];
     fm.setno.value = s_vSetno[index];
     fm.timeDecrip.focus();
   }
   
   function checkInput(){
      var pform = document.inputForm;
      var  name = "";
      name = trim(pform.timeDecrip.value);
      if(name == ""){
         alert("The name should not be null, please input it again!");
         return false;
      }
      if (!CheckInputStr(pform.timeDecrip,'Week period name'))
         return;
	
       <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(pform.timeDecrip.value,20)){
            alert("The name should not exceed 20 bytes!");
            pform.timeDecrip.focus();
            return;
          }
        <%
        }
        %>
      var temp="<%=  listCount %>";
      var flag = 0;
      for(var i=0; i<parseInt(temp); i++)
       if(s_vTimeDecrip[i]==name){
         flag = 1;
         break;
       }
     if(flag ==1) {
        alert("The name you input is repeated, please input it again!");
        pform.timeDecrip.focus();
        return false;
     }

     return true;
   }
   
   function checkCallingNum()
   {
     var pform = document.inputForm;
     var numbervalue="";
     numbervalue=pform.callingNum.value;
     if(pform.isgroup[1].checked){  //changed 0 to 1 for MobiTel
       if(numbervalue == ""){ //Added for MobiTel[5.09.01] by Srinivas
	   		alert("Please enter the Group member number!");
			 return false;
	   }//end of added
       if(numbervalue!=""){
         if (!checkstring('0123456789',numbervalue)){
           alert("The Group member number should be in the digit format, please input it again!");
           return false;
         }
         if(isMobile(numbervalue)){
           if(numbervalue.length < 6){
             alert("The Group member number length is incorrect, please input it again!");
             return false;
           }
         }else{

           if(numbervalue.length<8||numbervalue.length>13){
             alert("The Group member number length is incorrect, please input it again!");
             return false;
           }
         }
   }
   }
     else  if(!pform.isgroup[0].checked){  //Added for MobiTel{ 
       if(pform.group.value == ""){
         alert("Please select the Group member grouping!");
         return false;
       }
     }
     return true;
   }
   function addTime() {
      var fm = document.inputForm;
      if(fm.ringID.length == 0){
         alert("You have not order any "+ ringdisplay +". Please order first.");
         return false;
      }
	  if(!checkInput())
         return false;
	 
	 
    if(!checkCallingNum())
         return false;
	      
      <% if(db.getParameter(52)==0){ //ԭ�ȵ�%>
        if (fm.isgroup[1].checked){  //changed 0 to 1 for MobiTel
          if (fm.callingNum.value!='' && ! checkPhone()) {
            alert('The group member number should be the mobile number!');
            fm.callingNum.focus();
            return false;
          }
          if(fm.callingNum.value.length>8){//�̶��绰
            makePhone();
          }
        }
      <%}%>
         
      if(fm.isringgroup[0].checked == true)
		{//ѡ��������
			if(fm.ringID.selectedIndex ==-1)
			{
			 	alert("Please choose "+ ringdisplay +" first.");
        	 	return false;
        	}
		}
		else
		{//ѡ����������
			if(fm.ringgroup.selectedIndex ==-1)
			{
			 	alert("Please choose choose "+ ringdisplay +" group first.");
        	 	return false;
        	}
		}

  var startday = fm.startday.value;
      var endday   = fm.endday.value;
 if (startday == ''){
        alert('Please input the start date!');
        return;
      }
      if(startday!=''&& endday=='' ){
        alert("Please input the end date!");
        return;
      }
      if(startday!=''){
         if(!checktrue2(endday)){
            alert("The end date should be later than today");
            return;
         }
         if(!compareDate2(startday,endday)){
            alert("The end date should be later than the start date!");
            return;
        	}
		}      
          
         
      var fee=<%= modefee %>;
      if(fee>0){
           if(!confirm("It will cost "+ fee +" <%=minorcurrency%> to add this time period "+ringdisplay+"! Are you sure?"))
              return;
      }
      fm.op.value = 'add';
      fm.submit();
   }

   function editTime () {
      var pform = document.inputForm;
      if(pform.selTimeList.length ==0){
        alert('No available time period '+ ringdisplay +'!');
        return;
      }
      if(pform.selTimeList.selectedIndex == -1){
         alert('Please choose the time period '+ ringdisplay +' to edit.');
         return;
      }

      if(pform.ringID.length == 0){
         alert("You have not order any "+ ringdisplay +",please order first.");
         return false;
      }
      
      if(pform.isringgroup[0].checked == true)
		{//ѡ��������
			if(pform.ringID.selectedIndex ==-1)
			{
			 	alert("Please choose "+ ringdisplay +" first.");
        return false;
      }
		}
		else
		{//ѡ����������
			if(pform.ringgroup.selectedIndex ==-1)
			{
			 	alert("Please choose "+ ringdisplay +" group.");
        	 	return false;
        	}
		}
		
		   
      var str1 =  makeTime(pform.startHour.value,pform.startMinute.value,pform.startSecond.value);
      var str2 =  makeTime(pform.endHour.value,pform.endMinute.value,pform.endSecond.value);
      if(str1>str2){
        alert("The start time is later than the end time.Please input again.");
        return false;
      }
      var cmp_index = pform.selTimeList.selectedIndex;
      //�Ѿ����ڵļ��ų�Ա���ͣ�0�����ֻ����̶��绰���û�������������ŷ����
      var cmp_isgroup = s_vCallingtype[cmp_index];
      //��ǰ�ļ��ų�Ա��Ա����
      if (pform.isgroup[0].checked){
        var cur_isgroup = 0;
      }
      else{
        var cur_isgroup = 1;
      }

      //CMPƽ̨�������޸�
      //����Ѿ����ڵļ��ų�Ա����Ϊ0����ʾΪ�ֻ����̶��绰���û�
      if (cmp_isgroup == 0){
        if (cmp_isgroup != cur_isgroup){
          alert('Can not edit the Group member number.');
          return false;
        }
        //�ж��Ѿ����ڵ��ֻ����뼯�ŷ�����Ƿ�һ��
        if(trim(pform.callingNum.value) != trim(s_vCallingNum[cmp_index]) ){
          alert('Can not edit the Group member number.');
          pform.callingNum.value = s_vCallingNum[cmp_index];
          return false;
        }
      }
      //����Ϊ���ŷ����û�
      else{
        //��ʱ���жϵ�ǰ���ų�Ա�����Ƿ�Ϊ1����
        if (cur_isgroup != '1'){
          alert('The Group member number can NOT be edit.');
          pform.isgroup.value = cmp_isgroup;
          return false;
        }
			
        //�жϼ��ŷ�������Ѿ����ڵļ��ŷ�����Ƿ�һ��
        if(trim(pform.group.value) != trim(cmp_isgroup)){
          alert('The Group grouping number can NOT be edit.');
          return false;
        }
      }
//      if(pform.callingNum.value.length>8){//�̶��绰
//        makePhone();
//      }
      pform.startTime.value = str1;
      pform.endTime.value = str2;
      var startday = pform.startday.value;
      var endday   = pform.endday.value;
      if(startday!=''&& endday=='' ){
          alert("Please input the end date!");
          return;
      }
      if(endday!=''&& startday=='' ){
          alert("Please input the start date!");
          return;
      }
      if(startday!=''){
         if(!checktrue2(endday)){
            alert("The end date should be later than today!");
            return;
         }
         if(!compareDate2(startday,endday)){
            alert("The end date should be later than the start date.");
            return;
        }
     }
      var startmonthday = pform.startmonthday.value;
      var endmonthday   = pform.endmonthday.value;
      if(parseInt(startmonthday) > parseInt(endmonthday)){
        //alert("ÿ�¿�ʼ�ղ��ܱȽ���������");
        alert("The start day of month should be earlier than the end day.");
        return;
      }


      var fee=<%= modefee %>;
      if(fee>0 && pform.oldcrid.value != pform.ringID.value){
           //if(!confirm("����ʱ���"+ ringdisplay +"��Ҫ����"+ fee/100 + "Ԫ��\n��ȷ�ϸ��ĸ�ʱ���"+ ringdisplay +"��" ))
           if(!confirm("It will cost "+fee+" <%=minorcurrency%> to modify time period "+ringdisplay+"!\n Are you sure?"))
              return;
      }
      pform.op.value = 'edit';
      pform.submit();
   }
   function checkPhone () {
      var fm = document.inputForm;
      var phone = trim(fm.callingNum.value);
    if(fm.isgroup[1].checked){
         return true;
      }

      if (!checkstring('0123456789',phone))
            return false;

      return true;
   }
   //�Զ��ڳ�;���Ų�Ϊ0�Ĺ̶�����ǰ��0
   function makePhone () {
      var fm = document.inputForm;
     if(fm.isgroup[1].checked)
         return;
      var phone = trim(fm.callingNum.value);
      var c;
      var d;
      d = phone.substring(0,1);
      c = phone.substring(0,2);
      //alert("phone="+phone+";d="+d+";c="+c);
      var f = isMobile(phone);
/*      if( f=='true' && d!='0' && phone!=''){
         phone  = 0 + phone ;
         fm.callingNum.value = phone;
      }
*/
      return true;
   }
   function setTime(strTime,flag){
      var fm = document.inputForm;
      if(strTime == "" || strTime =="-1")
         return "";
      var startTime = parseInt(strTime);
      var hour = Math.floor(startTime / 10000);
      var min =  Math.floor((startTime-hour*10000) / 100);
      var sec  = startTime % 100;
//      var hour = strTime.substring(0,2);
//      var min =  strTime.substring(3,5);
//      var sec  = strTime.substring(6,8);
     if(flag==1){
        fm.startHour.value = hour;
        fm.startMinute.value = min;
        fm.startSecond.value = sec;
     }else if(flag==2){
        fm.endHour.value = hour;
        fm.endMinute.value = min;
        fm.endSecond.value = sec;
     }
   }

  function makeTime(hour,minute,second){
     if(hour<10)
        hour = '0' + hour;
     if(minute<10)
        minute = '0' + minute;
     if(second<10)
        second = '0' + second;
     var  ret = hour+":"+minute+":"+second;
     return ret;
  }


   function checkInput(){
      var pform = document.inputForm;
      var  name = "";
      name = trim(pform.timeDecrip.value);
      if(name == ""){
         //alert("���Ʋ���Ϊ�գ����������룡");
         alert("Name can not be null,please input again.");
         return false;
      }
      if (!CheckInputStr(pform.timeDecrip,'Time period name'))
         return;
         <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(pform.timeDecrip.value,20)){
            alert("The name should not exceed 20 bytes!");
            pform.timeDecrip.focus();
            return;
          }
        <%
        }
        %>
      var temp="<%=  listCount %>";
      var flag = 0;
      for(var i=0; i<parseInt(temp); i++)
       if(s_vTimeDecrip[i]==name){
         flag = 1;
         break;
       }
     if(flag ==1) {
        //alert("������������Ѿ��ظ������������룡");
        alert("Your input name exist.Please input again.");
        pform.timeDecrip.focus();
        return false;
     }

     if(pform.ringID.value.selectedIndex ==-1){
        alert("Please choose "+ ringdisplay +" first.");
        return false;
      }

      var str1 =  makeTime(pform.startHour.value,pform.startMinute.value,pform.startSecond.value);
      var str2 =  makeTime(pform.endHour.value,pform.endMinute.value,pform.endSecond.value);
	  if(str1>str2){
	  		alert("The start time can NOT be later than the end time.Please input again.");
			return false;
	  }
	  
     if (pform.isgroup[0].checked){
     	/* 
	  		if (pform.callingNum.value!='' && ! checkPhone()) {
         	//alert('���ų�Ա����ֻ�������ֻ��ţ�');
         	alert('The group member number should be the Mobile number.');
         	pform.callingNum.focus();
         	return false;
      	}
        if(pform.callingNum.value.length>8){//�̶��绰
          makePhone();
        }
      */  
      }
      
      pform.startTime.value = str1;
      pform.endTime.value = str2;

      var startday = pform.startday.value;
      var endday   = pform.endday.value;
      if(startday!=''&& endday=='' ){
          alert("Please input The end date!");
          return;
      }
      if(endday!=''&& startday=='' ){
          alert("Please input the start Date!");
          return;
      }
      if(startday!=''){
//         if(!checktrue2(startday)){
//            alert("The start date can NOT be earlier than today.");
//            return;
//         }
         if(!checktrue2(endday)){
            alert("The end date can NOT be earlier than today.");
            return;
         }
         if(!compareDate2(startday,endday)){
            alert("The end date can NOT be earlier than the start date.");
            return;
         }

      }
      var startmonthday = pform.startmonthday.value;
      var endmonthday   = pform.endmonthday.value;
      if(parseInt(startmonthday) > parseInt(endmonthday)){
        alert("The start day of each month can NOT be later than the end day.");
        return;
      }
	  return true;

   }
   function delTime() {
      var fm = document.inputForm;
      if(fm.selTimeList.length ==0){   
        alert('No available time period '+ ringdisplay +' to delete.');
        return;
      }

      if(fm.selTimeList.selectedIndex == -1){
         alert('Please choose time period '+ ringdisplay +' to delete.');
         return;
      }

      if (! confirm('Are you sure to delete this time period '+ ringdisplay +'?'))
         return;
      fm.op.value = 'del';
      fm.submit();
   }   


   function checktrue2(str){
     var currentDate = new Date();
     if (str.length == 0)
       return true;
     if(str.length!=10)
       return false;
     var month = (parseInt(currentDate.getMonth())+1).toString();
     if(month.length==1)
       month = '0'+month;
     var day = currentDate.getDate().toString();
     if(day.length==1)
       day = '0'+day;
     var nowDate = currentDate.getYear() + month + day;
     var get1Date = str.substring(0,4) + str.substring(5,7) + str.substring(8,10);
     if (get1Date - nowDate < 0)
       return false;
     return true;
   }

   function compareDate2 (beginDate, endDate) {
     beginDate = beginDate.substring(0,4) + beginDate.substring(5,7)+beginDate.substring(8,10) ;
     endDate = endDate.substring(0,4) + endDate.substring(5,7)+endDate.substring(8,10);
     if ((beginDate - endDate) >0)
       return false;
     return true;
   }
    function ringtypechange(n){
    if(n==0){
      document.all("ringgroup").style.display= 'none';
      document.all("ringID").style.display= 'block';
    }else{
       document.all("ringgroup").style.display= 'block';
       document.all("ringID").style.display= 'none';
    }
  }

</Script>
<%
    }//if
    else {
%>
<script language="javascript">
   var errorMsg = '<%= groupid!=null?errMsg:"Please log in to the system first"%>';
     alert(errorMsg);
     parent.document.location.href = 'enter.jsp';
</script>
<%
    }//else
  }//try
  catch (Exception e) {
    Vector vet = new Vector();
    sysInfo.add(sysTime + groupid + " group time period every month " + ringdisplay + " setting is abnormal!");
    sysInfo.add(sysTime + groupid + e.getMessage());
    vet.add("Group time period every month " + ringdisplay + " setting is abnormal!");
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
    //e.printStackTrace();
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="monthCallingTime.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>&amp;groupname=<%=groupname%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
  }//catch
%>
</body>
</html>
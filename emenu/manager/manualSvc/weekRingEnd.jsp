<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>


<%@ include file="../../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.callingTime" scope="page" />
<jsp:setProperty name="db" property="*" />

<html>
<head>
<title>Manage week period of time ringtone</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
<script language="Javascript" src="../calendar.js"></script>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">

<%
	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	int ratio = Integer.parseInt(currencyratio);




String ringdisplay = application.getAttribute("RINGDISPLAY")==null?"ringtone":(String)application.getAttribute("RINGDISPLAY");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
String userringtype = request.getParameter("userringtype") == null ? "" : request.getParameter("userringtype");
    String craccount = "";
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    int     modefee   = 0;
    String usertype="0";//用户类型

    try {
      sysTime = db.getSysTime() + "--";
      if (operID != null && purviewList.get("13-13") != null) {
      craccount = request.getParameter("craccount") == null ? "" : request.getParameter("craccount");
      manSysPara msp = new manSysPara();
      if(!msp.isAdUser(craccount)){
	zxyw50.Purview purview = new zxyw50.Purview();
            if(!purview.CheckOperatorRight(session,"13-2",craccount)){
            	throw new Exception("You have no right to manage this subsciber!");
            }
            if(!userringtype.equals("")){
           //存储取的用户信息
         Hashtable userinfo=new Hashtable();
         userAdm adm1 = new userAdm();
         userinfo=adm1.getUserInfo(craccount);
         String lockid=(String)userinfo.get("lockid");
         String lockid1=(String)userinfo.get("lockid1");

         if(lockid.equals("0")&&lockid1.equals("0"))
              usertype="2";//用户为主,被叫用户
           if(lockid.equals("0")&&(!lockid1.equals("0")))
              usertype="0";//用户为被叫用户
           if(!lockid.equals("0")&&lockid1.equals("0"))
              usertype="1";//用户为主叫用户
         }
           if(!userringtype.equals(usertype)&&!usertype.equals("2") ){
             throw new Exception("The Service type you select  differ from the subscriber's service type!");
          }
      String strOption = "";
      String optRingList = "";
      int    listCount = 0;
      SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
      String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
      String crid = request.getParameter("crid") == null ? "" : (String)request.getParameter("crid");
      Hashtable result1 = new Hashtable();
      String callingNum = request.getParameter("callingNum") == null ? "a" : request.getParameter("callingNum");
      String ringID = request.getParameter("ringID") == null ? "" : request.getParameter("ringID");
        int index = ringID.indexOf("~");
        String ringidtype = "1";
        if(index>0){
          ringidtype = ringID.substring(0,index);
          ringID=ringID.substring(index+1);
        }
      String startTime = request.getParameter("startTime") == null ? "-1" : request.getParameter("startTime");
      String endTime = request.getParameter("endTime") == null ? "-1" : request.getParameter("endTime");
      String startday  = request.getParameter("startday") == null ? "" : request.getParameter("startday");
      String endday = request.getParameter("endday") == null ? "" : request.getParameter("endday");
      String ringDate = "0" ;
        String startmonthday  = request.getParameter("startmonthday") == null ? "" : request.getParameter("startmonthday");
        String endmonthday = request.getParameter("endmonthday") == null ? "" : request.getParameter("endmonthday");

        boolean isgroup = request.getParameter("isgroup") ==null?false:(request.getParameter("isgroup").equals("1")?true:false);
        if(isgroup)
            callingNum = request.getParameter("group") == null ? "a" : request.getParameter("group");
        if(callingNum.trim().equalsIgnoreCase("")||callingNum.trim().equalsIgnoreCase("a"))
        {
          callingNum = "";
          isgroup = false;
        }
        phoneAdm  phoneadm = new phoneAdm();
        Vector vetCallingGroup = phoneadm.getCallingGroup(craccount);
        StringBuffer sb = new StringBuffer("");
        for(int i =0;i<vetCallingGroup.size();i++){
          Map m = (Map)vetCallingGroup.get(i);
          sb.append(" <option value='"+(String)m.get("callinggroup")+"'>"+(String)m.get("grouplabel")+"</option>");
        }
        String groupstr = sb.toString();
        String setno = request.getParameter("setno") == null ? "" : (String)request.getParameter("setno");
      String  sDesc = "";
       String timeDecrip = "";
      if(op.equals("add")){
         timeDecrip = request.getParameter("timeDecrip") == null ? "" : transferString((String)request.getParameter("timeDecrip"));
         if(checkLen(timeDecrip,20))
         	throw new Exception("The name of week time ringtone is too long,please re-enter!");//您输入的每周time segmentRingtone name超过长度限制,请您重新输入!

         if(callingNum.length()==0)
		   	callingNum = "";
         Hashtable hash = new Hashtable();
                hash.put("opcode","01010947");
                hash.put("craccount",craccount);
                hash.put("crid",ringID);
                hash.put("callingnum",callingNum);
                hash.put("starttime",startTime);
                hash.put("endtime",endTime);
                hash.put("startdate",startday);
                hash.put("enddate",endday);
                hash.put("startweek",startmonthday);
                hash.put("endweek",endmonthday);
                hash.put("startday","01");
                hash.put("endday","31");
                if(callingNum.equals(""))
                   if("1".equals(userringtype))
                     hash.put("callingtype","100");
                   else
                     hash.put("callingtype","0");
                else if(isgroup)
                   if("1".equals(userringtype))
                     hash.put("callingtype","102");
                   else
                     hash.put("callingtype","2");
                else
                   if("1".equals(userringtype))
                     hash.put("callingtype","101");
                   else
                     hash.put("callingtype","1");
                hash.put("settype","1");
                hash.put("opertype","1");
//                if(ringID.indexOf("99")==0)
//                   hash.put("ringidtype","2");
//                else
                hash.put("ringidtype",ringidtype);
                hash.put("description","ZLI-"+timeDecrip);
                hash.put("setno","");
                hash.put("setpri","");

         result1 = SocketPortocol.send(pool,hash);
         sysInfo.add(sysTime + craccount + " add week time ringtone sucessfully!");//新增每周time segment铃音配置成功!
         sDesc = "Add";
      } else if(op.equals("del")){
         timeDecrip = request.getParameter("curName") == null ? "" : transferString((String)request.getParameter("curName"));
         Hashtable hash = new Hashtable();
           hash.put("usernumber",craccount);
           hash.put("timeDecrip",timeDecrip);
           hash.put("setno",(setno.equals("")?"-1":setno));
           hash.put("opermode","1");
           hash.put("ipaddress",operName);
         db.delCallingTime(hash);
         sysInfo.add(sysTime + craccount + " delete week time ringtone successfully!");
         sDesc = "Delete";
      } else if(op.equals("edit")){
         timeDecrip = request.getParameter("curName") == null ? "" : transferString((String)request.getParameter("curName"));
         if(callingNum.length()==0)
		   	  callingNum = "";
         Hashtable hash = new Hashtable();
                hash.put("opcode","01010947");
                hash.put("craccount",craccount);
                hash.put("crid",ringID);
                hash.put("callingnum",callingNum);
                hash.put("starttime",startTime);
                hash.put("endtime",endTime);
                hash.put("startdate",startday);
                hash.put("enddate",endday);
                hash.put("startweek",startmonthday);
                hash.put("endweek",endmonthday);
                hash.put("startday","01");
                hash.put("endday","31");
                if(callingNum.equals(""))
                   if("1".equals(userringtype))
                     hash.put("callingtype","100");
                   else
                     hash.put("callingtype","0");
                else if(isgroup)
                   if("1".equals(userringtype))
                     hash.put("callingtype","102");
                   else
                     hash.put("callingtype","2");
                else
                   if("1".equals(userringtype))
                     hash.put("callingtype","101");
                   else
                     hash.put("callingtype","1");
                hash.put("settype","1");
                hash.put("opertype","0");
//                if(ringID.indexOf("99")==0)
//                   hash.put("ringidtype","2");
//                else
                hash.put("ringidtype",ringidtype);
                hash.put("description",timeDecrip);
                String setpri = request.getParameter("setpri") == null ? "" : (String)request.getParameter("setpri");
                hash.put("setno",setno);
                hash.put("setpri",setpri);

         //System.out.println(hash.toString());
         result1 = SocketPortocol.send(pool,hash);
         sDesc = "Edit";
         sysInfo.add(sysTime + craccount + " modify week time ringtone successfully!");
      }
      //填写日志
      if(!op.equals("")){
         // zxyw50.Purview purview = new zxyw50.Purview();
          HashMap map = new HashMap();
          map.put("OPERID",operID);
          map.put("OPERNAME",operName);
          map.put("OPERTYPE","513");
          map.put("RESULT","1");
          map.put("PARA1",craccount);
          map.put("PARA2",timeDecrip);
          map.put("PARA3",callingNum);
          map.put("PARA4",ringID);
          map.put("PARA5",startmonthday);
          map.put("PARA6",endmonthday);
          map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
          purview.writeLog(map);
      }

        // 查询个人铃音
        Hashtable hash = new Hashtable();
        Hashtable tmp = new Hashtable();
        Vector vetRing = new Vector();
        Hashtable ret = new Hashtable();
        if(!craccount.equals("")){
//           hash.put("opcode","01010301");
//           hash.put("craccount",craccount);
//           hash.put("ret1","");
//           ret = SocketPortocol.send(pool,hash);
            userAdm adm = new userAdm();
            ret = adm.queryPersonalRing(craccount);

           vetRing = (Vector)ret.get("data");
        }
        for (int i = 0; i < vetRing.size(); i++) {
           tmp = (Hashtable)vetRing.get(i);
           String cridTmp = (String)tmp.get("crid");
           String filname = (String)tmp.get("filename");
           String ringidtype1 = (String)tmp.get("ringidtype");
//           if(!cridTmp.startsWith("99"))
             optRingList = optRingList + "<option value=" +ringidtype1+"~"+ cridTmp +">" + filname + "</option>";
        }
		optRingList = optRingList + "<option value=\"1~0000000000\"> normal ring back tone</option>";
        //查询个人time segment铃音设置
//        Vector vTimeDecrip = new Vector();
//        Vector vCallingNum = new Vector();
//        Vector vRingID = new Vector();
//        Vector vStartTime = new Vector();
//        Vector vEndTime = new Vector();
//        Vector vRingDate = new Vector();

        ArrayList list =  new ArrayList();
        HashMap result = new HashMap();
		if(!craccount.equals(""))
		   list = db.getUserTimeList(craccount,3,userringtype);
		listCount = list.size();
		if(list.size()>0){
%>
<script language="javascript">
        var s_vTimeDecrip = new Array(<%= list.size() + "" %>);
        var s_vCallingNum = new Array(<%= list.size() + "" %>);
        var s_vRingID = new Array(<%= list.size() + "" %>);
        var s_vStartTime = new Array(<%= list.size() + "" %>);
        var s_vEndTime = new Array(<%= list.size() + "" %>);
        var s_vRingDate = new Array(<%= list.size() + "" %>);
        var s_vStartDate = new Array(<%= list.size() + "" %>);
        var s_vEndDate = new Array(<%= list.size() + "" %>);
        var s_vSetNo = new Array(<%= list.size() + "" %>);
        var s_vSetPri = new Array(<%= list.size() + "" %>);
        var s_vStartDay = new Array(<%= list.size() + "" %>);
        var s_vEndDay = new Array(<%= list.size() + "" %>);


<%
        for (int i = 0; i < list.size(); i++) {
          result = (HashMap)list.get(i);
          strOption = strOption + "<option value=" + Integer.toString(i)+">" + (String)result.get("timedescrip") + "</option>";
%>
        s_vTimeDecrip[<%= i + "" %>] = '<%= (String)result.get("timedescrip") %>';
        s_vCallingNum[<%= i + "" %>] = '<%= (String)result.get("callingnum") %>';
        s_vRingID[<%= i + "" %>] = '<%= (String)result.get("ringid") %>';
        s_vStartTime[<%= i + "" %>] = '<%= (String)result.get("starttime") %>';
        s_vEndTime[<%= i + "" %>] = '<%= (String)result.get("endtime") %>';
        s_vRingDate[<%= i + "" %>] = '<%= (String)result.get("startdate") %>';
        s_vStartDate[<%= i + "" %>] = '<%= (String)result.get("startdate") %>';
        s_vEndDate[<%= i + "" %>] = '<%= (String)result.get("enddate") %>';
        s_vSetNo[<%= i + "" %>] = '<%= (String)result.get("setno") %>';
        s_vSetPri[<%= i + "" %>] = '<%= (String)result.get("setpri") %>';
        s_vStartDay[<%= i + "" %>] = '<%= (String)result.get("startweek") %>';
        s_vEndDay[<%= i + "" %>] = '<%= (String)result.get("endweek") %>';

<%   } }  %>
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="750";
</script>
<form name="inputForm" method="post" action="weekRingEnd.jsp">
<input type="hidden" name="curName" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="startTime" value="">
<input type="hidden" name="endTime" value="">
<input type="hidden" name="oldcrid" value="">
<input type="hidden" name="setpri" value="">
<input type="hidden" name="setno" value="">
<input type="hidden" name="userringtype" value="<%=userringtype%>">
<table border="0" align="center" height="400" width="90%" class="table-style2" >
  <tr valign="center">
  <td>
  <table border="0" align="center" class="table-style2">
      <tr >
          <td height="26" colspan=2 align="center" class="text-title" background="../image/n-9.gif">Manage week period of time ringtone--<%= craccount %></td>
      </tr>
      <tr >
          <td height="15" colspan=2 align="center" >&nbsp;</td>
      </tr>
      <tr valign="top">
                  <td width="100%">
                    <table width="100%"  border="0" class="table-style2" cellpadding="2" cellspacing="1" >
                      <tr>
                        <td rowspan="11">
                          <select name="selTimeList" size="22" <%= list.size() == 0 ? "disabled " : "" %> onchange="javascript:onselectTimeList()" class="input-style1" style="width:220">
                            <% if(!strOption.equals("")) out.println(strOption); %>
                          </select>
                        </td>
                        <td align="right" valign="center">Name</td>
                        <td valign="center">
                          <input type="text" name="timeDecrip" value="" maxlength="20"   class="input-style1">
                        </td>
                      </tr>
                       <tr>
                        <td colspan="2" align="right">
                        <input type="radio" onclick="firechange(0);"  value="0" checked name="isgroup"><%=userringtype.equals("0")?"Calling":"Called"%> number&nbsp;&nbsp;<input type="radio" onclick="firechange(1);" name="isgroup" value="1"><%=userringtype.equals("0")?"Calling":"Called"%> group
                        </td>
                      </tr>
                      <tr>
                        <td align="right" valign="center">Number(group)</td>
                        <td valign="center">
                          <select style="display:none" name="group" size="1" class="select-style1" >
                                <%out.println(groupstr);%>
                              </select>

                          <input  type=text name="callingNum"  maxlength="20" class="input-style1"  >
                        </td>
                      </tr>
                      <tr>
                        <td align="right" valign="center">Ringtone</td>
                        <td valign="center">
                          <select name="ringID" size="1" class="select-style1">
                            <% if(!optRingList.equals("")) out.println(optRingList); %>
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td align="right" valign="center"><span title="Start day of week">Start day</span></td>
                        <td valign="center">
                          <select name="startmonthday" size="1" class="input-style5">
                            <%
                               for(int j=1;j<=7;j++)
                                  out.println("<option value="+(j<10?("0"+j):""+j) + ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select><span title="End day of week">&nbsp;End day&nbsp;</span><select name="endmonthday" size="1" class="input-style5">
                            <%
                               for(int j=1;j<=7;j++)
                                  out.println("<option "+(j==7?"selected ":"") +"value="+(j<10?("0"+j):""+j) + ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td align="right" valign="center"><span title="Start time of a day">Start time</span></td>
                        <td valign="center">
                          <select  name="startHour" class="input-style5">
                            <%
                               for(int j=0;j<24;j++)
                                  out.println("<option value="+(j<10?("0"+j):""+j) + ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
                          <select  name="startMinute" class="input-style5">
                            <%
                               for(int j=0;j<60;j++)
                                  out.println("<option value="+(j<10?("0"+j):""+j) + ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
                          <select  name="startSecond" class="input-style5">
                            <%
                               for(int j=0;j<60;j++)
                                  out.println("<option value="+(j<10?("0"+j):""+j) + ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
                          <br/>
                          Hour   Minunte  Second
                        </td>
                      </tr>
                      <tr>
                        <td align="right" valign="center"><span title="End time of day">End time</span></td>
                        <td valign="center">
                          <select  name="endHour" class="input-style5">
                            <%
                               for(int j=0;j<24;j++)
                                  out.println("<option "+(j==23?"selected ":"") +"value="+(j<10?("0"+j):""+j) + ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
                          <select  name="endMinute" class="input-style5">
                            <%
                               for(int j=0;j<60;j++)
                                  out.println("<option "+(j==59?"selected ":"") +"value="+(j<10?("0"+j):""+j) + ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
                          <select  name="endSecond" class="input-style5">
                            <%
                               for(int j=0;j<60;j++)
                                  out.println("<option "+(j==59?"selected ":"") +"value="+(j<10?("0"+j):""+j) + ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
                        </td>
                      </tr>
                      <tr>
                      <td align="right" >Start date</td>
                      <td valign="center">
                       <input type="text" name="startday" value="2000.01.01" maxlength="10" class="input-style1" readonly onclick="OpenDate(startday);">
                      </td>
                      </tr>
                      <tr>
	                  <td align="right">End date</td>
	                  <td valign="center">
                       <input type="text" name="endday" value="2999.12.31" maxlength="10" class="input-style1"  readonly onclick="OpenDate(endday);">
                      </td>
                      </tr>
                      <tr style="display:none">
                        <td align="right" valign="center">Remember date</td>
                        <td valign="center">
                          <input type="text" name="ringDate" value="" maxlength="40" class="input-style1">
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2" align="center">
                          <img src="../button/add.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:addTime()">&nbsp;&nbsp;
                          <img src="../button/change.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:editTime()">&nbsp;&nbsp;
                          <img src="../button/del.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:delTime()">&nbsp;&nbsp;
                          <img src="../button/back.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:onBack()">
                        </td>
                      </tr>
                    </table>

                  </td>
                </tr>
         <tr>
          <td colspan=2>
          <table border="0" width="100%" class="table-style2">
            <tr>
                <td class="table-styleshow" background="../image/n-9.gif" height="26">
                  Notes:</td>
              </tr>
              <tr>
                <td style="color: #FF0000">1.The week period ring back tone setting enables you to play your special ring back tone within a time period of days you specify.</td>
              </tr>
              <tr>
                <td style="color: #FF0000">2.If the <%=userringtype.equals("0")?"Calling":"Called"%> number is a fixed phone number, please enter 0+area code+fixed phone number.</td>
              </tr>
              <tr>
                <td style="color: #FF0000">3.If the Start Date and End Date are not specified, they will be from 2000.01.01 to 2999.01.01 by default.</td>
              </tr>
			  <tr>
                <td style="color: #FF0000">4.Week period ring back tones have higher priority than the ring back tone for the specified <%=userringtype.equals("0")?"Calling":"Called"%> number (group). That is, when a subscriber, whose number has been added as the special <%=userringtype.equals("0")?"Calling":"Called"%> number or a member in the <%=userringtype.equals("0")?"Calling":"Called"%> number group, calls you within the time period that you set a special ring back tone for, the period ring back tone, rather than that specified for the specified <%=userringtype.equals("0")?"Calling":"Called"%> number or <%=userringtype.equals("0")?"Calling":"Called"%> number group, will be played.</td>
              </tr>
              <tr>
                <td style="color: #FF0000">5.The name of the week period period ring back tone must be unique and change is not allowed.</td>
              </tr>
           </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<Script language="Javascript">
    function firechange(n){
      if(n == 0){//\u00D6÷\u00BD\u00D0\u00BA\u00C5\u00C2\u00EB
         document.all("group").style.display= 'none';
         document.all("callingNum").value="";
         document.all("callingNum").style.display= 'block';
      }else{
         document.all("group").style.display= 'block';
         document.all("group").value="";
         document.all("callingNum").style.display= 'none';
      }
    }
   function onCraccountPress(evn) {
    var   charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
    if (charCode == 13){
       document.forms[0].craccount.blur();
       onSearch();
       return;
     }
     return;
   }

   function onSearch(){
      var fm = document.inputForm;
      var checkvalue = trim(fm.craccount.value);

      if(checkvalue == ''){
          alert("Please enter the subscriber you want to operate!");//请输入您要操作的User number
          return ;
      }
      if(!checkstring('0123456789',checkvalue)){
          alert("The subscriber only can be a digital number!");//User number只能是数字字符串
          return ;
      }
      if(checkvalue.length<7){
         alert("The subscriber is not correct,please re-enter!");//User number输入不正确,请重新输入!
         return;
      }
      fm.op.value='search';
      fm.submit();
   }


   function onselectTimeList(){
      var fm = document.inputForm;
      var index = fm.selTimeList.selectedIndex;
      if(index==-1)
        return;
      fm.timeDecrip.value = s_vTimeDecrip[index];
      if(!(s_vCallingNum[index].length>9) && s_vCallingNum[index].length>0){ //vpn去掉0
        var temp = '';
        if(trim(s_vCallingNum[index])!='')
          temp = leftTrim(s_vCallingNum[index]);
        fm.group.value = temp;
        if(fm.group.value){
           firechange(1);
           fm.isgroup[1].checked = true;
           fm.group.value = temp;
        }else{
          firechange(0);
          fm.isgroup[0].checked = true;
          fm.callingNum.value = temp;
        }
      }else{
        var temp = trim(s_vCallingNum[index]);
         fm.group.value = temp;
        if(fm.group.value){
           firechange(1);
           fm.isgroup[1].checked = true;
           fm.group.value = temp;
        }else{
          firechange(0);
          fm.isgroup[0].checked = true;
          fm.callingNum.value = temp;
        }
      }

      fm.curName.value = s_vTimeDecrip[index];
      var str = s_vRingID[index];
      var len =0;
      var flag = 0;
      len = fm.ringID.length;
      for(var i=0; i<len; i++)
        if(fm.ringID.options[i].value.indexOf(str)>=0){
          flag =1;
          break;
        }
      if(flag==0)
	 i=-1;
  	fm.ringID.selectedIndex = i;
  	fm.oldcrid.value = fm.ringID.value;
      	setTime(s_vStartTime[index],1);
      	setTime(s_vEndTime[index],2);
      	fm.ringDate.value =  s_vRingDate[index];
      	fm.startday.value =  s_vStartDate[index];
      	fm.endday.value =  s_vEndDate[index];
        setDayOrWeek(s_vStartDay[index],1);
        setDayOrWeek(s_vEndDay[index],2);
       fm.setpri.value =   s_vSetPri[index];
       fm.setno.value =   s_vSetNo[index];

      	fm.timeDecrip.focus();
   }
   function setDayOrWeek(day,n){
     var temp = ""+day;
     if(temp.length == 1)
       temp = "0"+day;
     if(n ==1){
       document.inputForm.startmonthday.value = temp;
     }else
       document.inputForm.endmonthday.value = temp;
   }
   function addTime () {
      var fm = document.inputForm;
      if(fm.ringID.length == 0){
         alert("You did not order any ringtone. Please order first.");//您当前没有定购任何    请先定购
         return false;
      }
      if(!checkInput())
         return false;
      if(!checkCallingNum())
         return false;
      var fee=<%= modefee %>;
      if(fee>0){
           if(!confirm("You will be charged "+ fee/<%=ratio%> + " <%=majorcurrency%>!\nAre you sure to add the week period ringtone?" ))
              return;
      }
      fm.op.value = 'add';
      fm.submit();
   }
   function editTime () {
      var pform = document.inputForm;
      if(pform.selTimeList.length ==0){
        alert("There is no period ring back tone that can be changed.");
        return;
      }
      if(pform.selTimeList.selectedIndex == -1){
         alert("Please select the ringtone you want to change!");//请选择您要更改的time segment
         return;
      }

      if(pform.ringID.length == 0){
         alert("You did not order any ringtone. Please order  first.");//您当前没有定购任何    请先定购
         return false;
      }
      if(pform.ringID.selectedIndex ==-1){
        alert("Please select ringtone!");//请先选择
        return false;
      }
      var str1 =  makeTime(pform.startHour.value,pform.startMinute.value,pform.startSecond.value);
      var str2 =  makeTime(pform.endHour.value,pform.endMinute.value,pform.endSecond.value);
	  if(str1>str2){
	  	alert("The start time cannot be later than the stop time. Please re-enter");//起始时间大于截至时间,请重新输入
		return false;
	  }
	  <%--
	  if (pform.callingNum.value!='' && ! checkPhone()) {
         alert("A calling number can only be a digital number!");//主叫号码只允许输入数字
         pform.callingNum.focus();
         return false;
      }--%>
      if(!checkCallingNum())
         return false;
     if(pform.callingNum.value.length>8)//固定电话
      	 makePhone();
	  pform.startTime.value = str1;
	  pform.endTime.value = str2;

	  var startday = pform.startday.value;
      var endday   = pform.endday.value;
      if(startday!=''&& endday=='' ){
          alert("Please enter the end date!");//请输入结束日期
          return;
      }
      if(endday!=''&& startday=='' ){
          alert("Please enter the start date!");//请输入起始日期
          return;
      }
      if(startday!=''){
         if(!checktrue2(endday)){
            alert("The end date cannot be earlier than the present date!");//结束日期不能小于当前日期
            return;
         }
         if(!compareDate2(startday,endday)){
            alert("The start date cannot be later than the end date!");//起始日期不能比结束日期晚
            return;
        }
     }
      var startmonthday = pform.startmonthday.value;
      var endmonthday   = pform.endmonthday.value;
      if(startmonthday>endmonthday){
        alert("The start day  can't be later than the end day!");//每月开始日不能比结束日晚!
        return;
      }

      var fee=<%= modefee %>;
      if(fee>0 && pform.oldcrid.value != pform.ringID.value){
           if(!confirm("You will be charged "+ fee/<%=ratio%> + " <%=majorcurrency%>.\nAre you sure to change the period ringtone?" ))
              return;
      }
      pform.timeDecrip.value = pform.curName.value;
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
   //自动在长途区号不为0的固定号码前加0
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
      
/*      
      var f = isMobile(phone);
      if(  f=='true' && d!='0' && phone!=''){
         phone  = 0 + phone ;
         fm.callingNum.value = phone;
      }
*/      
      
      return true;
   }
   function checkCallingNum()
   {
     var pform = document.inputForm;
     var numbervalue="";
     numbervalue=pform.callingNum.value;
     if(pform.isgroup[0].checked){
       if(numbervalue!=""){
         if (!checkstring('0123456789',numbervalue)){
           alert("The <%=userringtype.equals("0")?"Calling":"Called"%> number should be in the digit format, please input it again!");
           return false;
         }
         if(isMobile(numbervalue)){
           if(numbervalue.length < 6){
             alert("The <%=userringtype.equals("0")?"Calling":"Called"%> number length is incorrect, please input it again!");
             return false;
           }
         }else{
           //固定电话号码
           if(numbervalue.length<8||numbervalue.length>13){
             alert("The <%=userringtype.equals("0")?"Calling":"Called"%> number length is incorrect, please input it again!");
             return false;
           }
         }
       }
     }
     else{
       if(pform.group.value == ""){
         alert("Please select the <%=userringtype.equals("0")?"Calling":"Called"%> number group!");
         return false;
       }
     }
     return true;
   }
   function setTime(strTime,flag){
      var fm = document.inputForm;
      if(strTime == "" || strTime =="-1")
         return "";
//      var startTime = parseInt(strTime);
//      var hour = Math.floor(startTime / 10000);
//      var min =  Math.floor((startTime-hour*10000) / 100);
//      var sec  = startTime % 100;
      var hour = strTime.substring(0,2);
      var min =  strTime.substring(3,5);
      var sec  = strTime.substring(6,8);
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
     var  ret = hour+":"+minute+":"+second;
//     if(hour<10)
//        ret = '0' + hour;
//     else
//        ret = hour;
//     if(minute<10)
//        ret = ret + '0' + minute;
//     else
//        ret = ret + minute;
//     if(second<10)
//        ret = ret + '0' + second;
//     else
//        ret = ret + second;
     return ret;

  }


   function checkInput(){
      var pform = document.inputForm;
      var  name = "";
      name = trim(pform.timeDecrip.value);
      if(name == ""){
         alert("Name cannot be null! Please re-enter!");//名称不能为空,请重新输入
         return false;
      }
      if (!CheckInputStr(pform.timeDecrip,'Week period name'))
         return;
      var temp="<%=  listCount %>";
      var flag = 0;
      for(var i=0; i<parseInt(temp); i++)
       if(s_vTimeDecrip[i]==name){
         flag = 1;
         break;
       }
     if(flag ==1) {
        alert("The name you entered has been repeated. Please re-enter!");//您输入的名称已经重复,请重新输入
        pform.timeDecrip.focus();
        return false;
     }

     if(pform.ringID.value.selectedIndex ==-1){
        alert("Please select <%=ringdisplay%>!");
        return false;
      }

      var str1 =  makeTime(pform.startHour.value,pform.startMinute.value,pform.startSecond.value);
      var str2 =  makeTime(pform.endHour.value,pform.endMinute.value,pform.endSecond.value);
	  if(str1>str2){
	  	alert("The start time cannot be later than the stop time. Please re-enter");//起始时间大于截至时间,请重新输入
		return false;
	  }
	  if (pform.callingNum.value!='' && ! checkPhone()) {
         alert("A calling number can only be a digital number!");//主叫号码只允许输入数字
         pform.callingNum.focus();
         return false;
      }
      if(pform.callingNum.value.length>8)//固定电话
      	 makePhone();
	  pform.startTime.value = str1;
	  pform.endTime.value = str2;

      var startday = pform.startday.value;
      var endday   = pform.endday.value;
      if(startday!=''&& endday=='' ){
          alert("Please enter the end date!");//请输入结束日期
          return;
      }
      if(endday!=''&& startday=='' ){
          alert("Please enter the start date!");//请输入起始日期
          return;
      }
      if(startday!=''){
//         if(!checktrue2(startday)){
//            alert("起始日期不能小于当前日期!");
//            return;
//         }
         if(!checktrue2(endday)){
            alert("The end date cannot be earlier than the present date!");//结束日期不能小于当前日期
            return;
         }
         if(!compareDate2(startday,endday)){
            alert("The start date cannot be later than the end date!");//起始日期不能比结束日期晚
            return;
         }

      }
      var startmonthday = pform.startmonthday.value;
      var endmonthday   = pform.endmonthday.value;
      if(startmonthday>endmonthday){
        alert("The start day of week can't be later than the end day of week!");//每月开始日不能比结束日晚!
        return;
      }
	  return true;

   }
   function delTime() {
      var fm = document.inputForm;
      if(fm.selTimeList.length ==0){
        alert("There is no time period ringtone that can be deleted!");//没有可供删除的time segment
        return;
      }

      if(fm.selTimeList.selectedIndex == -1){
         alert("Please select the time period ringtone that you want to deleted!");//请选择需要删除的time segment
         return;
      }

      if (! confirm("Are you sure to delete the time period ringtone ?"))//您是否确认删除这条time segment
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

   function onBack(){
     document.URL='weekRing.jsp';
  }

</Script>
<%
        }else {
%>
           <script language="javascript">
                   var str = 'Sorry! the number ' +<%= craccount %>+' you entered is ad subscriber,can not use the system!';
                   alert(str);
                   document.URL = 'weekRing.jsp';
            </script>
<%
        }
        }
        else {
%>
<script language="javascript">
 	alert('Please log in first!');
	document.location.href = '../enter.jsp';
</script>
<%
       }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount + " Exception occurred in managing week period ringtone!");
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add("Errors occurred in managing week period ringtone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/weekRing.jsp?userringtype=<%=userringtype%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

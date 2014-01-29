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
<title>Ringtones for commemoration days</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
<script language="Javascript" src="../calendar.js"></script>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">

<%
String ringdisplay = application.getAttribute("RINGDISPLAY")==null?"Ringtone":(String)application.getAttribute("RINGDISPLAY");
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
    
    
    String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 int ratio = Integer.parseInt(currencyratio);
    
    
    
    try {
      sysTime = db.getSysTime() + "--";
      if (operID != null && purviewList.get("13-6") != null) {
      craccount = request.getParameter("craccount") == null ? "" : request.getParameter("craccount");
      manSysPara msp = new manSysPara();
      if(!msp.isAdUser(craccount)){
      zxyw50.Purview purview = new zxyw50.Purview();
      if(!purview.CheckOperatorRight(session,"13-6",craccount)){
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
      craccount = request.getParameter("craccount") == null ? "" : request.getParameter("craccount");
      boolean isgroup = request.getParameter("isgroup") ==null?false:(request.getParameter("isgroup").equals("1")?true:false);
      phoneAdm  phoneadm = new phoneAdm();
      Vector vetCallingGroup = phoneadm.getCallingGroup(craccount);
      StringBuffer sb = new StringBuffer("");
      for(int i =0;i<vetCallingGroup.size();i++){
          Map m = (Map)vetCallingGroup.get(i);
          sb.append(" <option value='"+(String)m.get("callinggroup")+"'>"+(String)m.get("grouplabel")+"</option>");
     }
      String groupstr = sb.toString();

       String callingNum = request.getParameter("callingNum") == null ? "" : request.getParameter("callingNum");
        if(isgroup)
            callingNum = request.getParameter("group") == null ? "" : request.getParameter("group");
         if(callingNum.trim().equalsIgnoreCase(""))
           callingNum = "";
       String ringID = request.getParameter("ringID") == null ? "" : request.getParameter("ringID");
        int index = ringID.indexOf("~");
        String ringidtype = "1";
        if(index>0){
          ringidtype = ringID.substring(0,index);
          ringID=ringID.substring(index+1);
        }
       String ringDate = request.getParameter("ringDate") == null ? "" : request.getParameter("ringDate");
       String  sDesc = "";
       String timeDecrip = "";
       String setno = request.getParameter("setno") == null ? "" : (String)request.getParameter("setno");
        if(op.equals("add")){
           timeDecrip = request.getParameter("timeDecrip") == null ? "" : transferString((String)request.getParameter("timeDecrip"));
           if(checkLen(timeDecrip,20))
           	 throw new Exception("The name of ringtone for the commemoration day you entered has exceeded the length limit. Please re-enter!");//您输入的纪念日Ringtone name超过长度限制,请您重新输入!

           String startTime = "-1";
           String endTime = "-1";

           if(callingNum.length()==0)
		   	  callingNum = "";
           Hashtable hash = new Hashtable();
//           hash.put("opcode","01010933");
//           hash.put("craccount",craccount);
//           hash.put("crid",ringID);
//           hash.put("phone",callingNum);
//           hash.put("date",ringDate);
//           hash.put("desc",timeDecrip);
//           hash.put("isgroup",new Boolean(isgroup));
                hash.put("opcode","01010947");
                hash.put("craccount",craccount);
                hash.put("crid",ringID);
                hash.put("callingnum",callingNum);
                hash.put("starttime","00:00:00");
                hash.put("endtime","23:59:59");
                hash.put("startdate",ringDate);
                hash.put("enddate",ringDate);
                hash.put("startweek","01");
                hash.put("endweek","07");
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
                hash.put("settype","4");
                hash.put("opertype","1");
//                if(ringID.indexOf("99")==0)
//                   hash.put("ringidtype","2");
//                else
                   hash.put("ringidtype",ringidtype );
                hash.put("description","JLR-"+timeDecrip);
                hash.put("setno","");
                hash.put("setpri","");


           result1 = SocketPortocol.send(pool,hash);
           sysInfo.add(sysTime + craccount + "Commemoration day ringtone added successfully!!");//新增纪念日铃音成功
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
           sDesc = "Delete";
           sysInfo.add(sysTime + craccount + " Commemoration day ringtone deleteed successfully!");//删除纪念日铃音成功
        } else if(op.equals("edit")){
           timeDecrip = request.getParameter("curName") == null ? "" : transferString((String)request.getParameter("curName"));
           if(checkLen(timeDecrip,20))
           	 throw new Exception("The name of ringtone for the commemoration day you entered has exceeded the length limit. Please re-enter!");//您输入的纪念日Ringtone name超过长度限制,请您重新输入!
           String startTime = "-1";
           String endTime = "-1";

           if(callingNum.length()==0)
		   	callingNum = "";
           Hashtable hash = new Hashtable();
//           hash.put("opcode","01010936");
//           hash.put("craccount",craccount);
//           hash.put("crid",ringID);
//           hash.put("phone",callingNum);
//           hash.put("date",ringDate);
//           hash.put("desc",timeDecrip);
//           hash.put("isgroup",new Boolean(isgroup));
           //System.out.println(hash);
                hash.put("opcode","01010947");
                hash.put("craccount",craccount);
                hash.put("crid",ringID);
                hash.put("callingnum",callingNum);
                hash.put("starttime","00:00:00");
                hash.put("endtime","23:59:59");
                hash.put("startdate",ringDate);
                hash.put("enddate",ringDate);
                hash.put("startweek","01");
                hash.put("endweek","07");
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
                hash.put("settype","4");
                hash.put("opertype","0");
//                if(ringID.indexOf("99")==0)
//                   hash.put("ringidtype","2");
//                else
                   hash.put("ringidtype",ringidtype);
                hash.put("description",timeDecrip);
                String setpri = request.getParameter("setpri") == null ? "" : (String)request.getParameter("setpri");
                hash.put("setno",setno);
                hash.put("setpri",setpri);

           result1 = SocketPortocol.send(pool,hash);
           sysInfo.add(sysTime + craccount + ",Commemoration day ringtone modified successfully!");//修改纪念日铃音配置成功
           sDesc = "Edit";
        }
         //填写日志
       if(!op.equals("")){
//          zxyw50.Purview purview = new zxyw50.Purview();
          HashMap map = new HashMap();
          map.put("OPERID",operID);
          map.put("OPERNAME",operName);
          map.put("OPERTYPE","507");
          map.put("RESULT","1");
          map.put("PARA1",craccount);
          map.put("PARA2",timeDecrip);
          map.put("PARA3",callingNum);
          map.put("PARA4",ringID);
          map.put("PARA5",ringDate);
          map.put("DESCRIPTION",sDesc+" ip:"+request.getRemoteAddr());
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

        //查询个人纪念日铃音设置
        Vector vTimeDecrip = new Vector();
        Vector vCallingNum = new Vector();
        Vector vRingID = new Vector();
        Vector vStartTime = new Vector();
        Vector vEndTime = new Vector();
        Vector vRingDate = new Vector();

        ArrayList list =  new ArrayList();
        HashMap result = new HashMap();
		if(!craccount.equals(""))
		    list = db.getUserTimeList(craccount,2,userringtype);
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
        var s_vSetNo = new Array(<%= list.size() + "" %>);
        var s_vSetPri = new Array(<%= list.size() + "" %>);

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
        s_vSetNo[<%= i + "" %>] = '<%= (String)result.get("setno") %>';
        s_vSetPri[<%= i + "" %>] = '<%= (String)result.get("setpri") %>';

<%   } }  %>
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="550";
</script>
<form name="inputForm" method="post" action="dateRingEnd.jsp">
<input type="hidden" name="curName" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="op" value="">
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
          <td height="26" colspan=2 align="center" class="text-title" background="../image/n-9.gif">Ringtone management on the basis of commemoration day--<%= craccount %></td>
      </tr>
      <tr >
          <td height="15" colspan=2 align="center" >&nbsp;</td>
      </tr>
      <tr valign="top">
                  <td width="100%">
                    <table width="100%"  border="0" class="table-style2" cellpadding="2" cellspacing="1" >
                      <tr>
                        <td rowspan="10">
                          <select name="selTimeList" size="12" <%= list.size() == 0 ? "disabled " : "" %> onchange="javascript:onselectTimeList()" class="input-style1" style="width:250">
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
                        <input type="radio" onclick="firechange(0);"  value="0" checked name="isgroup"><%=userringtype.equals("0")?"Calling":"Called"%> number&nbsp;&nbsp;<input type="radio" onclick="firechange(1);" name="isgroup" value="1"><%=userringtype.equals("0")?"Calling":"Called"%> number group
                        </td>
                      </tr>
                     <tr>
                        <td align="right" valign="center"><%=userringtype.equals("0")?"Calling":"Called"%> number(group)</td>
                        <td valign="center">
                          <select style="display:none" name="group" size="1" class="select-style1" >
                                <%out.println(groupstr);%>
                              </select>

                          <input  type=text name="callingNum"  maxlength="20" class="input-style1"  >
                        </td>
                      </tr>
                      <tr>
                        <td align="right" valign="center">Select ringtone</td>
                        <td valign="center">
                          <select name="ringID" size="1" class="select-style1">
                            <% if(!optRingList.equals("")) out.println(optRingList); %>
                          </select>
                        </td>
                      </tr>
                      <tr style="display:none">
                        <td align="right" valign="center">Start time</td>
                        <td valign="center">
                          <input type="text" name="startTime"  maxlength="40" class="input-style1" value="">
                        </td>
                      </tr>
                      <tr style="display:none">
                        <td align="right" valign="center">Expiration time</td>
                        <td valign="center">
                          <input type="text" name="endTime"  maxlength="40" class="input-style1" value="">
                        </td>
                      </tr>
                      <tr>
                        <td align="right" valign="center">Commemoration day</td>
                        <td valign="center">
                          <input type="text" name="ringDate" value="" maxlength="40" class="input-style1" readonly onclick="OpenDate(ringDate)">
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2" align="center" width=100% > <img src="../button/add.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:addTime()">&nbsp;&nbsp;
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
                <td style="color: #FF0000">1. Setup of Commemoration Day Ringtone allows you to set and play special ringtones for the special <%=userringtype.equals("0")?"calling":"called"%> numbers on special days (such as Birthday). </td>
              </tr>
              <tr>
                <td style="color: #FF0000">2.If the <%=userringtype.equals("0")?"calling":"called"%> number is a fixed phone number, please enter 0+area code+ fixed phone number;</td>
              </tr>
              <tr>
                <td style="color: #FF0000">3.The commemoration day format is "YYYY.MM.DD", "2004.01.05" for example. Click the input box of Commemoration Day and choose the year, month and day accordingly from the popup calendar;</td>
              </tr>
			  <tr>
                <td style="color: #FF0000">4.Setup of Commemoration Day Ringtone has higher priority over the setup of time period and <%=userringtype.equals("0")?"calling":"called"%> number (or  <%=userringtype.equals("0")?"calling":"called"%> number group) ringtones;</td>
              </tr>
              <tr>
                <td style="color: #FF0000">5.The name of commemoration day ringtone is unique and unmodifiable.</td>
              </tr>
           </table>
          </td>
        </tr>
              </table>
            </td>
          </tr>
        </table>
  <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
      <td>&nbsp; </td>
  </tr>
  <tr>
      <td>&nbsp; </td>
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
          alert("Please enter the subscriber number to perform your operation");//请输入您要操作的User number
          return ;
      }
      if(!checkstring('0123456789',checkvalue)){
          alert("A subscriber number can only be a digital string");//User number只能是数字字符串
          return ;
      }
      if(checkvalue.length<7){
         alert("The subscriber number entered is incorrect. Please re-enter!");//User number输入不正确,请重新输入
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
         if(!(s_vCallingNum[index].length>9) && s_vCallingNum[index].length>0){ //vpn\u00D3\u00C3\u00BB§\u00CF\u00D4\u00CA\u00BE\u00C8\u00A5\u00B5\u00F40
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
      fm.startTime.value = getTimeStr(s_vStartTime[index]);
      fm.endTime.value =  getTimeStr(s_vEndTime[index]);
      fm.ringDate.value =  s_vRingDate[index];
      fm.setpri.value =   s_vSetPri[index];
      fm.setno.value =   s_vSetNo[index];
      fm.timeDecrip.focus();

   }
   function addTime () {
      var fm = document.inputForm;
      if(fm.ringID.length == 0){
         alert("You haven't order any ringtone yet. Please order a ringtone first!");//您当前没有定购任何铃音,请先定购铃音
         return false;
      }
      if(!checkInput())
         return false;
      if(!checkCallingNum())
         return false;
      var fee=<%= modefee %>;
      if(fee>0){
           if(!confirm("You will be charged "+ fee/<%=ratio%> + " <%=majorcurrency%> for adding the commemoration day ringtone!  \N Are you sure you want to continue?" ))//"增加纪念日铃音需要交纳"+ fee/100 + "元!\n您确认增加该纪念日铃音吗？"
              return;
      }

      fm.op.value = 'add';
      fm.submit();
   }
   function editTime () {
      var pform = document.inputForm;
      if(pform.selTimeList.length ==0){
        alert("No modifiable commemoration day ringtone!");//没有可供更改的纪念日铃音
        return;
      }
      if(pform.selTimeList.selectedIndex == -1){
         alert("Please select the commemoration day ringtone you wish to modify!");//请选择需要更改的纪念日铃音
         return;
      }
      if(pform.ringID.length == 0){
         alert("You haven't order any ringtone yet. Please order a ringtone first!");//您当前没有定购任何铃音,请先定购铃音
         return false;
      }

      if(pform.ringID.selectedIndex ==-1){
        alert("Please select a ringtone first!");//请先选择铃音
        return false;
      }
      var str3 =  trim(pform.ringDate.value);
      if(str3==''){
         alert("Please enter a commemoration day");//请输入纪念日期
         pform.ringDate.focus();
         return false;
      }
	  if(checkdate(str3)==2){
	  	alert("The specified commemoration day cannot be earlier than the current time!");//设定的纪念日期不能小于当前时间
	  	pform.ringDate.focus();
		return false;
	  }<%--
	  if (pform.callingNum.value!='' && ! checkPhone()) {
         alert("A calling number can only be a digital number!");//主叫号码只允许输入数字
         pform.callingNum.focus();
         return false;
      }--%>
      if(!checkCallingNum())
         return false;
      if(pform.callingNum.value.length>8)//固定电话
      	makePhone();

      var fee=<%= modefee %>;
      if(fee>0 && pform.oldcrid.value != pform.ringID.value){
           if(!confirm("You will be charged "+ fee/<%=ratio%> + " <%=majorcurrency%> for changing the commemoration day ringtone! \n Are you sure you want to continue?" ))//更改纪念日铃音需要交纳"+ fee/100 + "元!\n您确认更改该纪念日铃音吗？
              return;
      }
      pform.timeDecrip.value = pform.curName.value;
      pform.op.value = 'edit';
      pform.submit();
   }
   function getTimeStr(strTime){
      if(strTime == "" || strTime =="-1")
         return "";
      var str = "00:00:00";
      var startTime = parseInt(strTime);
      var hour = Math.floor(startTime / 10000);
      if(hour<10)
        str = "0" + hour+":";
      else
        str =  hour+":";
      var min =  Math.floor((startTime-hour*10000) / 100);
      if(min<10)
        str = str+"0"+min+":";
      else
        str = str + min + ":";
      var sec  = startTime % 100;
      if(sec<10)
        str = str + "0" + sec;
      else
        str = str + sec;
      return str;
   }

   //判断日期值是否正确
   function checkdate (str) {
      str = trim(str);
      if (str.length == 0)
         return 1;
      if (str == null || str == '' || str.length != 10 || str.split('.',3).length!=3)
         return 0;
      year = str.substring(0,4);
      month = str.substring(5,7) - 1;
      day = str.substring(8,10);
      if (isNaN(year) || isNaN(month) || isNaN(day))
         return 0;
      var tmpDate = new Date(year,month,day);
      if (tmpDate.getFullYear() != year || tmpDate.getMonth() != month)
         return 0;

	  var get1Date = str.substring(0,4) + str.substring(5,7) + str.substring(8,10);
	  var currentDate = new Date();
	  var month = (parseInt(currentDate.getMonth())+1).toString();
	  var day1 = (currentDate.getDate()).toString();
	  if(month.length==1)
	  	month = '0'+month;
      if(day1.length==1)
	  	day1 = '0'+day1;
      var nowDate = currentDate.getYear() + month + day1;
	  if (get1Date - nowDate < 0){
		 return 2;
		 }
      return 1;
   }


   function checkInput(){
      var pform = document.inputForm;
      var  name = "";
      name = trim(pform.timeDecrip.value);
      if(name == ""){
         alert("Name cannot be null! Please re-enter!");//名称不能为空,请重新输入
         return false;
      }
      if (!CheckInputStr(pform.timeDecrip,'Name of commemoration day'))//纪念日名称
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
      var str3 =  trim(pform.ringDate.value);
      if(str3==''){
         alert("Please enter a commemoration day");//请输入纪念日期
            return false;
      }
	  if(checkdate(str3)==2){
	  	alert("The specified commemoration day cannot be earlier than the current time!");//设定的纪念日期不能小于当前时间
		return false;
	  }
	  if (pform.callingNum.value!='' && ! checkPhone()) {
         alert("A calling number can only be a digital number!");//主叫号码只允许输入数字
         pform.callingNum.focus();
         return false;
      }
      if(pform.callingNum.value.length>8)//固定电话
      	makePhone();
      return true;

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
      if( f=='true' && d!='0' && phone!=''){
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
   function delTime() {
      var fm = document.inputForm;
      if(fm.selTimeList.length ==0){
        alert("No removable commemoration day ringtone!");//没有可供删除的纪念日铃音
        return;
      }
      if(fm.selTimeList.selectedIndex == -1){
         alert("Please select the commemoration day ringtone you wish to delete!");//请选择需要删除的纪念日铃音
         return;
      }

      if (! confirm("Are you sure you want to delete this commemoration day ringtone?"))//您是否确认删除这条纪念日铃音
         return;
      fm.op.value = 'del';
      fm.submit();
   }
   function onBack(){
     document.URL='dateRing.jsp';
  }

</Script>
<%
        }else{
%>
              <script language="javascript">
                   var str = 'Sorry! the number ' +<%= craccount %>+' you entered is ad subscriber,can not use the system!';
                   alert(str);
                   document.URL = 'dateRing.jsp';
             </script>
<%
        }
        }
        else {
%>
<script language="javascript">
 	alert("Please log in first!");//请先登录
	document.location.href = '../enter.jsp';
</script>
<%
       }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount + ",Exception occurred in managing the subscriber's ringtones for commemoration days!");//用户纪念日铃音管理出现异常
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add("Exception occurred in managing the subscriber's ringtones for commemoration days!");//用户纪念日铃音管理出现异常
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/dateRing.jsp?userringtype=<%=userringtype%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

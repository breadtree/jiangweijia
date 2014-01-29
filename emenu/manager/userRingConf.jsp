<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.phoneAdm" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.callingTime" scope="page" />
<jsp:setProperty name="db" property="*" />
<%!
	public String display(String callingNum, String ringLabel) {
        String str = "";
        int len = callingNum.length();
        if(!(len>9) && callingNum.substring(0,1).equals("0")){//vpn用户
        	callingNum = callingNum.substring(1,len);
        }

        for (int i = 0; i < 20 - len; i++)
            str = str + "-";
        if(ringLabel == "")
           return callingNum;
        return callingNum + str + ringLabel;
    }
%>

<html>
<head>
<title>Query user-set ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body class="body-style1" >
<%
    String userringtype= "0";
    String colorphotoname = zte.zxyw50.util.CrbtUtil.getConfig("colorphotoname","Color Photo Show");
	String usecalling = CrbtUtil.getConfig("usecalling","0");
	String isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String craccount = (String)request.getParameter("usernumber");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String menuFlag = request.getParameter("menuFlag") == null ? "0" : request.getParameter("menuFlag");
	// add for star hub
	String display_style = CrbtUtil.getConfig("IsStarhub", "0").equals("1") ? "style=display:none" : "";
    String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
	try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        phoneAdm phoneadm = new phoneAdm();
        ringAdm  ringadm  = new ringAdm();
        sysTime = ringadm.getSysTime() + "--";
        Vector vetRing = new Vector();
        Vector vetRingGroup = new Vector();
        ArrayList list =  new ArrayList();
        Vector vetCallingGroup = new Vector();
        Hashtable result = new Hashtable();
        HashMap map  = new HashMap();
        Hashtable tmp = null;
        Hashtable hash = new Hashtable();
        String strOption = "";
		if (operID != null && purviewList.get("1-6") != null) {
            if (craccount != null && !craccount.equals("")) {
				// 查询个人铃音
		 zxyw50.Purview purview = new zxyw50.Purview();
            	 if(!purview.CheckOperatorRight(session,"1-6",craccount)){
               		throw new Exception("You hava no right to manager this subscriber!");
            	 }
//                hash.put("opcode","01010301");
//                hash.put("craccount",craccount);
//                hash.put("ret1","");
//                result = SocketPortocol.send(pool,hash);
                userAdm adm = new userAdm();
                result = adm.queryPersonalRing(craccount);
                userringtype = request.getParameter("userringtype")==null?"2":request.getParameter("userringtype");
                vetRing = (Vector)result.get("data");
                switch(Integer.parseInt(menuFlag)){
                  case 1:
                  Hashtable defaultRing = new Hashtable();
                  defaultRing = ringadm.getDefaultRing(craccount,userringtype);
                  String defultID = (String)defaultRing.get("defaultring");
                  int flag = 0;
                  for (int i = 0; i < vetRing.size(); i++) {
                    tmp = (Hashtable)vetRing.get(i);
                    String crid11 = (String)tmp.get("crid");
                    if(defultID.equals(crid11)){
                      flag = 1;
                      strOption  = strOption + "<option value="+ (String)tmp.get("crid") + " selected >" + (String)tmp.get("filename") +"</option>";
                    }
                    else
                    strOption  = strOption + "<option value="+ (String)tmp.get("crid") + " >" + (String)tmp.get("filename") +"</option>";
                  }
                  if(flag == 0)
                               strOption = "<option value='' selected  >No default ringtone has been set now</option>" + strOption;
                  break;
                  case 2: //铃音群组
                     vetRingGroup = ringadm.getUserRingGroup(craccount);
                     break;
                  case 3: //time segment铃音
                     list = db.getUserTimeList(craccount,1,userringtype);
                     break;
                  case 4: //纪念日铃音
                     list = db.getUserTimeList(craccount,2,userringtype);
                     break;
                  case 6: //主叫号码组
                     vetCallingGroup = phoneadm.getCallingGroup(craccount);
                     break;
                  default:
                     break;
                }
             }

 %>
 <script language="javascript">
   //铃音库铃音
   var v_ringid = new Array(<%= vetRing.size() + "" %>);
   var v_ringlabel = new Array(<%= vetRing.size() + "" %>);
   var v_ringauthor = new Array(<%= vetRing.size() + "" %>);
   var v_ringsource = new Array(<%= vetRing.size() + "" %>);
   var v_mediatype = new Array(<%= vetRing.size() + "" %>);
<%
            for (int i = 0; i < vetRing.size(); i++) {
                hash = (Hashtable)vetRing.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("crid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("filename") %>';
   v_ringauthor[<%= i + "" %>] = '<%= (String)hash.get("author") %>';
   v_ringsource[<%= i + "" %>] = '<%= (String)hash.get("supplier") %>';
   v_mediatype[<%= i + "" %>] = '<%= (String)hash.get("mediatype") %>';
  
<%
            }
%>


   //铃音组
   var v_ringgroup = new Array(<%= vetRingGroup.size() + "" %>);
   var v_rgrouplabel = new Array(<%= vetRingGroup.size() + "" %>);
<%
            for (int i = 0; i < vetRingGroup.size(); i++) {
                hash = (Hashtable)vetRingGroup.get(i);
%>
   v_ringgroup[<%= i + "" %>] = '<%= (String)hash.get("ringgroup") %>';
   v_rgrouplabel[<%= i + "" %>] = '<%= (String)hash.get("grouplabel") %>';
<%
            }
%>

        //time segment纪念日铃音
        var s_vTimeDecrip = new Array(<%= list.size() + "" %>);
        var s_vCallingNum = new Array(<%= list.size() + "" %>);
        var s_vRingID = new Array(<%= list.size() + "" %>);
        var s_vStartTime = new Array(<%= list.size() + "" %>);
        var s_vEndTime = new Array(<%= list.size() + "" %>);
        var s_vRingDate = new Array(<%= list.size() + "" %>);
        var s_vStartDate = new Array(<%= list.size() + "" %>);
        var s_vEndDate = new Array(<%= list.size() + "" %>);
        var s_vStartDay = new Array(<%= list.size() + "" %>);
        var s_vEndDay = new Array(<%= list.size() + "" %>);
        var s_vStartWeek = new Array(<%= list.size() + "" %>);
        var s_vEndWeek = new Array(<%= list.size() + "" %>);
<%
        for (int i = 0; i < list.size(); i++) {
          map = (HashMap)list.get(i);
%>
        s_vTimeDecrip[<%= i + "" %>] = '<%= (String)map.get("timedescrip") %>';
        s_vCallingNum[<%= i + "" %>] = '<%= (String)map.get("callingnum") %>';
        s_vRingID[<%= i + "" %>] = '<%= (String)map.get("ringid") %>';
        s_vStartTime[<%= i + "" %>] = '<%= (String)map.get("starttime") %>';
        s_vEndTime[<%= i + "" %>] = '<%= (String)map.get("endtime") %>';
        s_vRingDate[<%= i + "" %>] = '<%= (String)map.get("startdate") %>';
        s_vStartDate[<%= i + "" %>] = '<%= (String)map.get("startdate") %>';
        s_vEndDate[<%= i + "" %>] = '<%= (String)map.get("enddate") %>';
        s_vStartDay[<%= i + "" %>] = '<%= (String)map.get("startday") %>';
        s_vEndDay[<%= i + "" %>] = '<%= (String)map.get("endday") %>';
        s_vStartWeek[<%= i + "" %>] = '<%= (String)map.get("startweek") %>';
        s_vEndWeek[<%= i + "" %>] = '<%= (String)map.get("endweek") %>';
<%   }   %>

   //主叫号码组
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



   function searchRing () {
      fm = document.inputForm;
      var value = trim(fm.usernumber.value);
      if (value == '') {
         alert('Please enter a number first!');//请先输入号码
         fm.usernumber.focus();
         return;
      }
      if (value.length<=5) {
         alert('The <%=user_number%> entered is incorrect. Please re-enter!');//User number输入不正确,请重新输入
         fm.usernumber.focus();
         return;
      }
      fm.submit();
   }

   function tryListen () {
      fm = document.inputForm;
      if (fm.craccount.value == '')
         return;
      if (fm.crid.value == '') {
         alert('Please select a ringtone before pre-listening!');//请先选择铃音,再试听!
         return;
      }
      var tryURL = 'tryListen.jsp?ringid=' + fm.crid.value;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }


   function selmenu(flag){
      var fm = document.inputForm;
      var value = trim(fm.usernumber.value);
      if (trim(value) == '') {
         alert('Please enter the <%=user_number%> to be queried!');//请输入您要查询的User number
         fm.usernumber.focus();
         return;
      }
      if (!checkstring('0123456789',value)) {
         alert('The <%=user_number%> can only be a digital number!');//User number只允许输入数字
         fm.usernumber.focus();
         return;
      }
	  if(value<5){
	  	alert('Please enter the correct <%=user_number%>!');//请输入正确的User number
		fm.usernumber.focus();
		return;
	  }
	  fm.menuFlag.value = flag;
	  document.inputForm.submit();
   }

   function showmenu(flag){
	  document.all.menu1.style.backgroundColor='A0E0E0';
	  document.all.menu2.style.backgroundColor='A0E0E0';
	  document.all.menu3.style.backgroundColor='A0E0E0';
	  document.all.menu4.style.backgroundColor='A0E0E0';
	  document.all.menu6.style.backgroundColor='A0E0E0';

	  document.all('main01').style.display='none';
	  document.all('main02').style.display='none';
	  document.all('main03').style.display='none';
	  document.all('main04').style.display='none';
	  document.all('main06').style.display='none';

	  switch (flag){
	    case 0:
	           break;
	    case 1:
	        document.all.menu1.style.backgroundColor='eeeeff';
	        document.all('main01').style.display='block';
	        break;
	    case 2:
	        document.all.menu2.style.backgroundColor='eeeeff';
	        document.all('main02').style.display='block';
	        break;
	    case 3:
	        document.all.menu3.style.backgroundColor='eeeeff';
	        document.all('main03').style.display='block';
	        break;
	    case 4:
	        document.all.menu4.style.backgroundColor='eeeeff';
	        document.all('main04').style.display='block';
	        break;
	    case 6:
	        document.all.menu6.style.backgroundColor='eeeeff';
	        document.all('main06').style.display='block';
	        break;
	    default:
	        document.all.menu1.style.backgroundColor='eeeeff';
	        document.all('main01').style.display='block';
	        break;
	  }
   }

   function selectPersonalRing () {
      var fm = document.inputForm;
      var index = fm.personalRing.value;
      if (index == null)
         return;
      if (index == '') {
         return;
      }
      fm.userring.value = v_ringid[index];
      fm.ringLabel.value = v_ringlabel[index];
      fm.ringauthor.value = v_ringauthor[index];
      fm.ringsource.value = v_ringsource[index];
	  if(v_mediatype[index] == 1){
	  fm.mediatype.value='Audio';
   }
	  else if(v_mediatype[index] == 2){
	   fm.mediatype.value='Video';}
   }

   function selectGroup () {
      var fm = document.inputForm;
      var index = fm.grouplist.value;
      if (index == null)
         return;
      if (index == '') {
         return;
      }
      fm.grouplabel.value = v_grouplabel[index];
      fm.ringgroup.value = v_ringgroup[index];
   }


   function onselectDateList(){
      var fm = document.inputForm;
      var index = fm.selDateList.selectedIndex;
      if(index==-1)
        return;
      fm.dateDecrip.value = s_vTimeDecrip[index];
      var  tmp = trim(s_vCallingNum[index]);
      if(!(tmp.length>9) && tmp.length>0) //vpn用户显示去掉0
      	fm.dateCallingNum.value = leftTrim(tmp);
      else
      	fm.dateCallingNum.value = tmp;
      var str = s_vRingID[index];
      var len =0;
      var flag = 0;
      len = fm.dateRing.length;
      for(var i=0; i<len; i++)
        if(fm.dateRing.options[i].value.indexOf(str)>=0){
          flag =1;
          break;
        }
      if(flag==0)
	   i=-1;
      fm.dateRing.selectedIndex = i;
      fm.ringDate.value =  s_vRingDate[index];
   }

   function onselectTimeList(){
      var fm = document.inputForm;
      var index = fm.selTimeList.selectedIndex;
      if(index==-1)
        return;
      fm.timeDecrip.value = s_vTimeDecrip[index];
     var  tmp = trim(s_vCallingNum[index]);
     if(!(tmp.length>9) && tmp.length>0) //vpn用户显示去掉0
      	fm.timeCallingNum.value = leftTrim(tmp);
      else
      	fm.timeCallingNum.value = tmp;
      var str = s_vRingID[index];
      var len =0;
      var flag = 0;
      len = fm.timeRing.length;
      for(var i=0; i<len; i++)
        if(fm.timeRing.options[i].value.indexOf(str)>=0){
          flag =1;
          break;
        }
      if(flag==0)
	  	i=-1;
  	  fm.timeRing.selectedIndex = i;
      setTime(s_vStartTime[index],1);
      setTime(s_vEndTime[index],2);
      fm.startday.value =  s_vStartDate[index];
      fm.endday.value =  s_vEndDate[index];
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
      hour = leftTrimZero(hour);
      min = leftTrimZero(min);
      sec = leftTrimZero(sec);
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

   function leftTrimZero (str) {
      var tmp = str;
      if (tmp.substring(0,1) == '0')
         tmp = tmp.substring(1,tmp.length);
      return tmp;
   }

   function selectGroup () {
      var fm = document.inputForm;
      var index = fm.callgrouplist.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.phonegroup.value = v_groupid[index];
      fm.callgrouplabel.value = v_grouplabel[index];
   }


   function selectRingGroup () {
      var fm = document.inputForm;
      var index = fm.ringgrouplist.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.grouplabel.value = v_rgrouplabel[index];
      fm.ringgroup.value = v_ringgroup[index];
   }


   function onPhoneMember(){
      var fm = document.inputForm;
      var operURL = 'phoneMember.jsp?phonegroup=' + fm.phonegroup.value + '&usernumber='+ fm.usernumber.value;
      preListen = window.open(operURL,'phonemember','width=400, height=300');
   }

   function onRingMember(){
      var fm = document.inputForm;
      var operURL = 'ringMember.jsp?ringgroup=' + fm.ringgroup.value + '&usernumber='+ fm.usernumber.value;
      window.open(operURL,'ringmember','width=400, height=300');
   }



</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="userRingConf.jsp">
<input type="hidden" name="phonegroup" value="">
<input type="hidden" name="menuFlag" value="<%= menuFlag %>">
<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center" class="table-style2" >
  <tr align="center">
  <td>
       <table width="80%" border="0" class="table-style2" >
       <tr >
          <td height="26"  align="center" class="text-title" background="image/n-9.gif" >Query user-set <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
       </table>
   </td>
   </tr>
   <tr align="center">
   <td >
        <table border="0" cellspacing="0" cellpadding="0" class="table-style2">
         <tr>
          <td  height=40 ><%=user_number%>&nbsp;&nbsp;<input type="text" name="usernumber" value="<%= craccount == null ? "" : craccount %>" maxlength="20" class="input-style1">
          &nbsp;&nbsp;Service type&nbsp;&nbsp;
           <select name="userringtype"  class="input-style1" style="width:150" >
           <option <%=userringtype.equals("0")?"selected":""%> value=0 >Called service</option>
         <%if("1".equals(usecalling)){%>
           <option <%=userringtype.equals("1")?"selected":""%> value=1 >Calling service</option>
        <%}%>
           <!--<option <%=userringtype.equals("2")?"selected":""%> value=2 >Calling/called service</option>-->
		<%if("1".equals(isimage)){%>
           <option <%=userringtype.equals("3")?"selected":""%> value=3 ><%= colorphotoname %></option>
           </select>
        <%}%>
        </td>
        </tr>
        <tr>
        <td >
              <table border="0" cellspacing="0" cellpadding="2"  class="table-style1">
                <tr>
	    	  <td onmousedown=selmenu(1)  id="menu1" width="90" style="BORDER-RIGHT: 2px outset; BORDER-TOP: rgb(227,227,227) 2px outset; BORDER-LEFT: rgb(227,227,227) 2px outset; BORDER-BOTTOM: rgb(255,255,255) 1px inset; BACKGROUND-COLOR: #a0e0e0" onmouseover="this.style.cursor='hand'" title="Library <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>">
	    	   Library <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>
	    	  </td>
              <td onmousedown=selmenu(2) <%=display_style%> id="menu2" width="90" style="BORDER-RIGHT: 2px outset; BORDER-TOP: rgb(227,227,227) 2px outset; BORDER-LEFT: rgb(227,227,227) 2px outset; BORDER-BOTTOM: rgb(255,255,255) 1px inset; BACKGROUND-COLOR: #a0e0e0" onmouseover="this.style.cursor='hand'" title="<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group">
	    	   <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group
	    	  </td>
	    	   <td onmousedown=selmenu(3)  id="menu3" width="90" style="BORDER-RIGHT: 2px outset; BORDER-TOP: rgb(227,227,227) 2px outset; BORDER-LEFT: rgb(227,227,227) 2px outset; BORDER-BOTTOM: rgb(255,255,255) 1px inset; BACKGROUND-COLOR: #a0e0e0" onmouseover="this.style.cursor='hand'" title="<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s for time-periods">
	    	    Time-periods
	    	  </td>
	    	  <td onmousedown=selmenu(4) <%=display_style%> id="menu4" width="90" style="BORDER-RIGHT: 2px outset; BORDER-TOP: rgb(227,227,227) 2px outset; BORDER-LEFT: rgb(227,227,227) 2px outset; BORDER-BOTTOM: rgb(255,255,255) 1px inset; BACKGROUND-COLOR: #a0e0e0"  onmouseover="this.style.cursor='hand'" title="<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s for commemoration days">
	    	    Commemoration days
	    	  </td>
	    	  <td onmousedown=selmenu(6)  id="menu6" width="90" style="BORDER-RIGHT: 2px outset; BORDER-TOP: rgb(227,227,227) 2px outset; BORDER-LEFT: rgb(227,227,227) 2px outset; BORDER-BOTTOM: rgb(255,255,255) 1px inset; BACKGROUND-COLOR: #a0e0e0" onmouseover="this.style.cursor='hand'" title="Calling number group">
	    	    Calling number group
	    	  </td>
             </tr>
             </table>
        </td>
        </tr>
		<tr id="main01" style="DISPLAY: none">
		<td  >
		    <table borderColor="#e0e0e0" cellSpacing="0" cellPadding="0" bgColor="#f0f8ff" border="1" style="BORDER-RIGHT: rgb(128,128,128) 2px outset; OVERFLOW: auto; BORDER-LEFT: rgb(192,192,192) 2px outset; WIDTH: 100%; BORDER-BOTTOM: rgb(128,128,128) 2px outset;  BACKGROUND-COLOR: #eeeeff" class="table-style2">
            <tr>
			  <td colspan=3 height=50>
			   &nbsp;Default ringtone&nbsp;&nbsp;&nbsp;&nbsp; <select name="crid" class="select-style1" disabled style='width:350px'>
                            <%  out.print(strOption); %>
                          </select>
			  </td>
			</tr>
			<tr>
             <td rowspan="5" align="center" width="40%">
               Ringtones in personal libraries (Group)<br>
                <select name="personalRing" size="8" <%= vetRing.size() == 0 ? "disabled " : "" %>onclick="javascript:selectPersonalRing()" class="select-style1">
                 <%
                   if(menuFlag.equals("1"))
                    for (int i = 0; i < vetRing.size(); i++) {
                       tmp = (Hashtable)vetRing.get(i);
                       out.println("<option value=" + String.valueOf(i) + ">" + (String)tmp.get("crid") + "--------" + (String)tmp.get("filename") + "</option>" );
                    }
                  %>
                  </select>
				  </td>
                <td align="right" width="20%">Ringtone code&nbsp;</td>
                <td width="30%"><input type="text" name="userring" value="" maxlength="40" class="input-style1" disabled></td>
              </tr>
              <tr>
                <td align="right" valign="center">Ringtone name&nbsp;</td>
                <td valign="center"><input type="text" name="ringLabel" value="" maxlength="40" class="input-style1" disabled></td>
              </tr>
              <tr>
                <td align="right" valign="center">Singer&nbsp;</td>
                <td valign="center"><input type="text" name="ringauthor" value="" maxlength="40" class="input-style1" disabled=""></td>
              </tr>
              <tr>
                <td align="right" valign="center">Ringtone provider&nbsp;</td>
                <td valign="center"><input type="text" name="ringsource" value="" maxlength="40" class="input-style1" disabled=""></td>
              </tr>
			  <tr>
			  <td align="right" valign="center">Media Type&nbsp;</td>
               <td valign="center"><input type="text" name="mediatype" value="" maxlength="30" class="input-style1" disabled=""></td>
			  </tr>
              </table>
		 </td>
		</tr>

		<tr id="main02" style="DISPLAY: none">
		<td>
		     <table borderColor="#e0e0e0" cellSpacing="0" cellPadding="0" bgColor="#f0f8ff" border="1" style="BORDER-RIGHT: rgb(128,128,128) 2px outset; OVERFLOW: auto; BORDER-LEFT: rgb(192,192,192) 2px outset; WIDTH: 100%; BORDER-BOTTOM: rgb(128,128,128) 2px outset;  BACKGROUND-COLOR: #eeeeff" class="table-style2" >
             <tr>
              <td rowspan="4" align="center" width="40%" >
                <select name="ringgrouplist" size="10" class="select-style1" <%= vetRingGroup.size() == 0 ? "disabled " : "" %>onchange="javascript:selectRingGroup()" ondblclick="javascript:onRingMember();" >
                <%
                 if(menuFlag.equals("2")){
                    for (int i = 0; i < vetRingGroup.size(); i++) {
                      tmp = (Hashtable)vetRingGroup.get(i);
                      out.println("<option value=" + String.valueOf(i) + " >" +  (String)tmp.get("ringgroup") + "--------" + (String)tmp.get("grouplabel") + "</option>" );
                     }
                }
               %>
              </select> </td>
            <td align="right" width="20%">The subscriber number &nbsp;</td>
            <td width="30%"><%= craccount %></td>
          </tr>
          <tr>
            <td align="right">Ringtone group ID&nbsp;</td>
            <td><input type="text" name="ringgroup" value=""  class="input-style1" disabled ></td>
          </tr>
          <tr>
            <td align="right">Ringtone group name&nbsp;</td>
            <td><input type="text" name="grouplabel" value="" maxlength="40" class="input-style1" disabled ></td>
	      </tr>
		  <tr>
                  <td colspan=2 >&nbsp;&nbsp;Note: To query the info of the existing ringtones in a ringtone group, double click the group in the left-side list.</td>
	      </tr>
        </table>
		</td>
		</tr>

        <tr id="main03" style="DISPLAY: none">
        <td>
              <table borderColor="#e0e0e0" cellSpacing="0" cellPadding="0" bgColor="#f0f8ff" border="1" style="BORDER-RIGHT: rgb(128,128,128) 2px outset; OVERFLOW: auto; BORDER-LEFT: rgb(192,192,192) 2px outset; WIDTH: 100%; BORDER-BOTTOM: rgb(128,128,128) 2px outset;  BACKGROUND-COLOR: #eeeeff" class="table-style2" >
              <tr>
                <td rowspan="10" align="center" width="40%" >
                  <select name="selTimeList" size="14" <%= list.size() == 0 ? "disabled " : "" %>onchange="javascript:onselectTimeList()" class="select-style1">
                  <%
                     if(menuFlag.equals("3")){
                        for (int i = 0; i < list.size(); i++) {
                          map = (HashMap)list.get(i);
                          out.println("<option value=" + String.valueOf(i) + " >" + (String)map.get("timedescrip") + "</option>" );
                         }
                     }
                 %>
                  </select>
                </td>
                <td align="right" valign="center" width="15%">Name</td>
                <td valign="center" width="35%">
                  <input type="text" name="timeDecrip" value="" maxlength="20"   class="input-style1" disabled >
                </td>
              </tr>
              <tr> </tr>
              <tr>
                <td align="right" valign="center">Calling number</td>
                <td valign="center" >
                  <input type="text" name="timeCallingNum" value="" maxlength="20" class="input-style1" disabled >
                </td>
              </tr>
              <tr>
                <td align="right" valign="center">Select ringtone</td>
                <td valign="center">
                  <select name="timeRing" size="1" class="select-style1" disabled >
                    <%
                      for (int i = 0; i < vetRing.size(); i++) {
                          tmp = (Hashtable)vetRing.get(i);
                          out.println("<option value=" + (String)tmp.get("crid") + " >" + (String)tmp.get("filename") +"</option>");
                      }
                     %>
                  </select>
                </td>
              </tr>
              <tr>
                <td align="right" valign="center">Start time</td>
                <td valign="center">
                  <select  name="startHour" class="input-style5" disabled >
                    <%
                       for(int j=0;j<24;j++)
                          out.println("<option value="+String.valueOf(j) + ">" + String.valueOf(j) + "</option>" );
                    %>
                  </select>Hour
                  <select  name="startMinute" class="input-style5" disabled >
                    <%
                       for(int j=0;j<60;j++)
                          out.println("<option value="+String.valueOf(j) + ">" + String.valueOf(j) + "</option>" );
                    %>
                  </select>Minute
                  <select  name="startSecond" class="input-style5" disabled >
                    <%
                       for(int j=0;j<60;j++)
                          out.println("<option value="+String.valueOf(j) + ">" + String.valueOf(j) + "</option>" );
                    %>
                  </select>
                </td>
              </tr>
              <tr>
                <td align="right" valign="center">Expiration time</td>
                <td valign="center">
                  <select  name="endHour" class="input-style5" disabled >
                    <%
                       for(int j=0;j<24;j++)
                          out.println("<option value="+String.valueOf(j) + ">" + String.valueOf(j) + "</option>" );
                    %>
                  </select>Hour
                  <select  name="endMinute" class="input-style5" disabled >
                    <%
                       for(int j=0;j<60;j++)
                          out.println("<option value="+String.valueOf(j) + ">" + String.valueOf(j) + "</option>" );
                    %>
                  </select>Minute
                  <select  name="endSecond" class="input-style5" disabled >
                    <%
                       for(int j=0;j<60;j++)
                          out.println("<option value="+String.valueOf(j) + ">" + String.valueOf(j) + "</option>" );
                    %>
                  </select>
                </td>
              </tr>
              <tr>
               <td align="right" >Start Date</td>
               <td valign="center">
                <input type="text" name="startday" maxlength="10" class="input-style1" disabled >
               </td>
               </tr>
               <tr>
	           <td align="right">End Date</td>
	           <td valign="center">
                <input type="text" name="endday"  maxlength="10" class="input-style1" disabled >
               </td>
               </tr>
              </table>
        </td>
        </tr>


        <tr id="main04" style="DISPLAY: none">
        <td>
              <table borderColor="#e0e0e0" cellSpacing="0" cellPadding="0" bgColor="#f0f8ff" border="1" style="BORDER-RIGHT: rgb(128,128,128) 2px outset; OVERFLOW: auto; BORDER-LEFT: rgb(192,192,192) 2px outset; WIDTH: 100%; BORDER-BOTTOM: rgb(128,128,128) 2px outset;  BACKGROUND-COLOR: #eeeeff" class="table-style2" >
              <tr>
                <td rowspan="10" align="center" width="40%">
                  <select name="selDateList" size="10" <%= list.size() == 0 ? "disabled " : "" %> onchange="javascript:onselectDateList()" class="select-style1">
                   <%
                     if(menuFlag.equals("4")){
                        //list = db.getUserTimeList(craccount,2,"2");
                        for (int i = 0; i < list.size(); i++) {
                          map = (HashMap)list.get(i);
                          out.println("<option value=" + String.valueOf(i) + " >" + (String)map.get("timedescrip") + "</option>" );
                         }
                     }
                 %>
                  </select>
                </td>
                <td align="right" valign="center" width="20%">Name</td>
                <td valign="center" width="30%">
                  <input type="text" name="dateDecrip" value="" maxlength="20"   class="input-style1" disabled >
                </td>
              </tr>
              <tr> </tr>
              <tr>
                <td align="right" valign="center">Calling number</td>
                <td valign="center">
                  <input type="text" name="dateCallingNum" value="" maxlength="20" class="input-style1" disabled >
                </td>
              </tr>
              <tr>
                <td align="right" valign="center">Select ringtone</td>
                <td valign="center">
                  <select name="dateRing" size="1" class="select-style1" disabled >
                   <%
                      for (int i = 0; i < vetRing.size(); i++) {
                          tmp = (Hashtable)vetRing.get(i);
                          out.println("<option value=" + (String)tmp.get("crid") + " >" + (String)tmp.get("filename") +"</option>");
                      }
                     %>
                  </select>
                </td>
              </tr>
              <tr>
                <td align="right" valign="center">Commemoration day</td>
                <td valign="center">
                  <input type="text" name="ringDate" value="" maxlength="40" class="input-style1" disabled >
                </td>
              </tr>
              </table>
        </td>
        </tr>





        <tr id="main06" style="DISPLAY: none">
        <td>
             <table borderColor="#e0e0e0" cellSpacing="0" cellPadding="0" bgColor="#f0f8ff" border="1" style="BORDER-RIGHT: rgb(128,128,128) 2px outset; OVERFLOW: auto; BORDER-LEFT: rgb(192,192,192) 2px outset; WIDTH: 100%; BORDER-BOTTOM: rgb(128,128,128) 2px outset;  BACKGROUND-COLOR: #eeeeff" class="table-style2" >
                      <tr>
                          <td rowspan="4" align="center" width="40%">
                          <select name="callgrouplist" size="10" class="select-style1" <%= vetCallingGroup.size() == 0 ? "disabled " : "" %>onclick="javascript:selectGroup()" ondblclick="javascript:onPhoneMember();" >
                          <%
                            if(menuFlag.equals("6")){
                               for (int i = 0; i < vetCallingGroup.size(); i++) {
                                 tmp = (Hashtable)vetCallingGroup.get(i);
                                 if (! ((String)tmp.get("callinggroup")).equals("0"))
                                    out.println("<option value=" + String.valueOf(i) + " >" + display((String)tmp.get("grouplabel"),"") + "</option>");
                               }
                            }
                           %>
                          </select> </td>
                              <td align="right" width="20%">The subscriber number &nbsp;</td>
                              <td width="30%"><%= craccount %></td>
                      </tr>
                      <tr>
                              <td align="right" width="20%">Calling number group name&nbsp;</td>
                              <td width="30%">
                                <input type="text" name="callgrouplabel" value="" maxlength="40" class="input-style1" disabled >
                              </td>
                      </tr>
					 <tr>
                       <td colspan=2 >&nbsp;&nbsp;Note: To query the info of all the existing calling numbers of a calling number group, double click the group in the left-side list.</td>
	                </tr>
                    </table>
        </td>
        </tr>
	  </table>
   </td>
   </tr>
   </table>
   <script language="JavaScript">
	showmenu(<%= menuFlag %>);
  </script>

</form>
<%
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                   alert( "Please log in to the system first!");//Please log in to the system
                   document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + "Exception occurred in settings the subscriber ringtone querying!");//用户铃音设置查询过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in settings the subscriber ringtone querying!");//用户铃音设置查询过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="userRingConf.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.ywaccess" %>

<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.callingTime" scope="page" />
<jsp:setProperty name="db" property="*" />

<html>
<head>
<title>Default Time period Ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="Javascript" src="calendar.js"></script>
</head>
<body topmargin="0" leftmargin="0" class="body-style1"  onload="formLoad()">

<%
    String userringtype = request.getParameter("userringtype") == null ? "" : request.getParameter("userringtype");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String ringdisplay = application.getAttribute("RINGDISPLAY")==null?"Ringtone":(String)application.getAttribute("RINGDISPLAY");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    int modefee = 0;
    String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
    String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
    String currencyratio = CrbtUtil.getConfig("currencyratio","100");
    int ratio = Integer.parseInt(currencyratio);
    String prefVal = (String)request.getParameter("prefixType")==null?"":(String)request.getParameter("prefixType");
    String settype = request.getParameter("settype") == null ? "" : request.getParameter("settype");
    int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
    try {
      sysTime = db.getSysTime() + "--";
      if (operID != null && purviewList.get("2-34") != null) {
          ywaccess yw = new ywaccess();
	  int prefLen = yw.getParameter(20106);
	  zxyw50.Purview purview = new zxyw50.Purview();
      /* if(!purview.CheckOperatorRight(session,"2-34",craccount)){
            	throw new Exception("You have no right to manage this subsciber!");
            }
      */
      String strOption = "";
      String optRingList = "";
      int    listCount = 0;
      SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
      String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
      String crid = request.getParameter("crid") == null ? "" : (String)request.getParameter("crid");
      Hashtable result1 = new Hashtable();
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
      String setpri = request.getParameter("setpri") == null ? "" : (String)request.getParameter("setpri");
      String ringDate = "0" ;
      String setno = request.getParameter("setno") == null ? "" : (String)request.getParameter("setno");
      String  sDesc = "";
      String timeDecrip = "";
      String sCalledtype = "0000";
      if(!prefVal.equals(""))
      {
	      sCalledtype = "0002";
      }
      else
      {
          prefVal = "";
	  }

      if(op.equals("add")){
         timeDecrip = request.getParameter("timeDecrip") == null ? "" : transferString((String)request.getParameter("timeDecrip"));
         if(checkLen(timeDecrip,20))
         	throw new Exception("The time period ringtone name you inputted is too long in length. Please re-enter!");//您输入的time segmentRingtone name超过长度限制,请您重新输入!

     Hashtable hash = new Hashtable();
     hash.put("opcode","01010621");
	 hash.put("crid",ringID);
     hash.put("callingnum","");  // empty
     hash.put("starttime",startTime);
	 hash.put("endtime",endTime);
	 hash.put("startdate",startday);
	 hash.put("enddate",endday);
	 hash.put("startweek","01");
	 hash.put("endweek","07");
	 hash.put("startday","01");
	 hash.put("endday","31");
     hash.put("callingtype","0000");
     if("2000.01.01".equals(startday)&&"2999.12.31".equals(endday))
	     hash.put("settype","3");
     else
	     hash.put("settype","4");
	 hash.put("opertype","01");
	 hash.put("ringidtype","1"); //现在的ring只设置单个铃音, only single ring can be set currently. (?)
	 hash.put("description",timeDecrip);
    hash.put("callednumber",prefVal); //input the prefix of called number or keep it as blank.
	 hash.put("calledtype",sCalledtype); // 0002 or 0000
	 hash.put("setno",""); // make sure the value is correct when modifying and deleting.
	 hash.put("setpri","");
     result1 = SocketPortocol.send(pool,hash);
	 sysInfo.add(sysTime + prefVal + " add time period ringtone successfully!");//新增time segment铃音配置成功
         sDesc = "Add";
      } else if(op.equals("del")){
         timeDecrip = request.getParameter("curName") == null ? "" : transferString((String)request.getParameter("curName"));
         Hashtable hash = new Hashtable();
	 hash.put("opcode","01010621");
	 hash.put("crid",ringID);
	 hash.put("callingnum","");  // empty
	 hash.put("starttime",startTime);
	 hash.put("endtime",endTime);
	 hash.put("startdate",startday);
	 hash.put("enddate",endday);
	 hash.put("startweek","01");
	 hash.put("endweek","07");
	 hash.put("startday","01");
	 hash.put("endday","31");
	 hash.put("callingtype","0000");
	 if("2000.01.01".equals(startday)&&"2999.12.31".equals(endday))
	     hash.put("settype","3");
	 else
	     hash.put("settype","4");
	 hash.put("opertype","03");
     hash.put("ringidtype","1"); //现在的ring只设置单个铃音, only single ring can be set currently. (?)
	 hash.put("description",timeDecrip);
     hash.put("callednumber",prefVal); //input the prefix of called number or keep it as blank.
	 hash.put("calledtype",sCalledtype); // 0002 or 0000
     hash.put("setno",(setno.equals("")?"-1":setno)); // make sure the value is correct when modifying and deleting.
	 hash.put("setpri",setpri);
     result1 = SocketPortocol.send(pool,hash);
	 sysInfo.add(sysTime + prefVal + " delete time period ringtone successfully!");//删除time segment铃音成功
     sDesc = "Delete";

      } else if(op.equals("edit")){
         timeDecrip = request.getParameter("curName") == null ? "" : transferString((String)request.getParameter("curName"));
           if(checkLen(timeDecrip,20))
           	 throw new Exception("The name of ringtone for the commemoration day you entered has exceeded the length limit. Please re-enter!");//您输入的纪念日Ringtone name超过长度限制,请您重新输入!
       Hashtable hash = new Hashtable();
     hash.put("opcode","01010621");
     hash.put("crid",ringID);
	 hash.put("callingnum","");  // empty
	 hash.put("starttime",startTime);
 	 hash.put("endtime",endTime);
	 hash.put("startdate",startday);
	 hash.put("enddate",endday);
	 hash.put("startweek","01");
     hash.put("endweek","07");
	 hash.put("startday","01");
	 hash.put("endday","31");
	 hash.put("callingtype","0000");
	 if("2000.01.01".equals(startday)&&"2999.12.31".equals(endday))
	    hash.put("settype","3");
	 else
	    hash.put("settype","4");
	 hash.put("opertype","02");
 	 hash.put("ringidtype","1"); //现在的ring只设置单个铃音, only single ring can be set currently. (?)
	 hash.put("description",timeDecrip);
     hash.put("callednumber",prefVal); //input the prefix of called number or keep it as blank.
	 hash.put("calledtype",sCalledtype); // 0002 or 0000
	 hash.put("setno",setno);// make sure the value is correct when modifying and deleting.
     hash.put("setpri",setpri);
     result1 = SocketPortocol.send(pool,hash);
     sysInfo.add(sysTime + prefVal + " modify time period ringtone succussfully!");//修改time segment铃音配置成功!
     sDesc = "Edit";
      }
      //填写日志
      if(!op.equals("")){
          HashMap map = new HashMap();
          map.put("OPERID",operID);
          map.put("OPERNAME",operName);
          map.put("OPERTYPE","506");
          map.put("RESULT","1");
          map.put("PARA1",prefVal);
          map.put("PARA2",timeDecrip);
          map.put("PARA3","");
          map.put("PARA4",ringID);
          map.put("PARA5",startTime);
          map.put("PARA6",endTime);
          map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
          purview.writeLog(map);
      }

        // 查询个人铃音
        Hashtable hash = new Hashtable();
        Hashtable tmp = new Hashtable();
        ArrayList list =  new ArrayList();
        HashMap result = new HashMap();
		 list = db.querySysTimeRing(settype);
		listCount = list.size();
		if(list.size()>0){
%>
<script language="javascript">
        var s_vTimeDecrip = new Array(<%= list.size() + "" %>);
        var s_vCallingNum = new Array(<%= list.size() + "" %>);
        var s_vCalledNum = new Array(<%= list.size() + "" %>);
        var s_vRingID = new Array(<%= list.size() + "" %>);
        var s_vStartTime = new Array(<%= list.size() + "" %>);
        var s_vEndTime = new Array(<%= list.size() + "" %>);
        var s_vRingDate = new Array(<%= list.size() + "" %>);
        var s_vStartDate = new Array(<%= list.size() + "" %>);
        var s_vEndDate = new Array(<%= list.size() + "" %>);
        var s_vSetNo = new Array(<%= list.size() + "" %>);
        var s_vSetPri = new Array(<%= list.size() + "" %>);

<%
        for (int i = 0; i < list.size(); i++) {
          result = (HashMap)list.get(i);
          strOption = strOption + "<option value=" + Integer.toString(i)+">" + (String)result.get("timedescrip") + "</option>";
%>
        s_vTimeDecrip[<%= i + "" %>] = '<%= (String)result.get("timedescrip") %>';
        s_vCallingNum[<%= i + "" %>] = '<%= (String)result.get("callingnum") %>';
	s_vCalledNum[<%= i + "" %>] = '<%= (String)result.get("callednum") %>';
        s_vRingID[<%= i + "" %>] = '<%= (String)result.get("ringid") %>';
        s_vStartTime[<%= i + "" %>] = '<%= (String)result.get("starttime") %>';
        s_vEndTime[<%= i + "" %>] = '<%= (String)result.get("endtime") %>';
        s_vRingDate[<%= i + "" %>] = '<%= (String)result.get("startdate") %>';
        s_vStartDate[<%= i + "" %>] = '<%= (String)result.get("startdate") %>';
        s_vEndDate[<%= i + "" %>] = '<%= (String)result.get("enddate") %>';
        s_vSetNo[<%= i + "" %>] = '<%= (String)result.get("setno") %>';
        s_vSetPri[<%= i + "" %>] = '<%= (String)result.get("setpri") %>';

<%   } }  %>
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="700";
</script>
<form name="inputForm" method="post" action="systimeperiod.jsp">
<input type="hidden" name="curName" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="startTime" value="">
<input type="hidden" name="endTime" value="">
<input type="hidden" name="oldcrid" value="">
<input type="hidden" name="setpri" value="">
<input type="hidden" name="setno" value="">
<input type="hidden" name="settype" value="<%= settype%>">
<input type="hidden" name="userringtype" value="<%=userringtype%>">
<input id="res" type="hidden" name="result" value=""/>
<table border="0" align="center" height="400" width="90%" class="table-style2" >
  <tr valign="center">
  <td>
  <table border="0" align="center" class="table-style2">
      <tr >
          <td height="26" colspan=2 align="center" class="text-title" background="image/n-9.gif">Time period</td>
      </tr>
      <tr >
          <td height="15" colspan=2 align="center" >&nbsp;</td>
      </tr>
      <tr valign="top">
                  <td width="100%">
                    <table width="100%"  border="0" class="table-style2" cellpadding="2" cellspacing="1" >
                      <tr>
                        <td rowspan="10">
                          <select name="selTimeList" size="14" <%= list.size() == 0 ? "disabled " : "" %> onChange="javascript:onselectTimeList()" class="input-style1" style="width:250">
                            <% if(!strOption.equals("")) out.println(strOption); %>
                          </select>
                   </td>
						  <tr>
						   <td align="right" valign="center">Name</td>
                        <td valign="center">
                          <input type="text" name="timeDecrip" value="" maxlength="20"   class="input-style1">
          </td>
						</tr>

                       <td colspan="2" align="center">
                        <input type="radio" onClick="firechange(0);"  value="0" checked name="isgroup">All the Subscriber
						<input type="radio" onClick="firechange(1);" value="1" name="isgroup" >
						Prefix Type
					   </td>
					   </tr>

				   <tr>
				     <td align="right" valign="center">Prefix</td>
                       <td valign="center">
                          <input type="text" name="prefixType" value="" maxlength="20"   class="input-style1">                       </td>
				   </tr>

                      <tr>
                        <td align="right" valign="center">Select ringtone</td>
                        <td align="left">
                          <input type="text" name="ringID" value="<%=ringID%>" readonly class="input-style1" maxlength="20"><img src="../image/query.gif" onMouseOver="this.style.cursor='pointer'" onClick=
						  "javascript:queryInfo()">                        </td>
                      </tr>

                      <tr>
                        <td align="right" valign="center">Start time</td>
                        <td valign="center">
                          <select  name="startHour" class="input-style5">
                            <%
                               for(int j=0;j<24;j++)
                                  out.println("<option value="+j+ ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
                          <select  name="startMinute" class="input-style5">
                            <%
                               for(int j=0;j<60;j++)
                                  out.println("<option value="+j + ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
                          <select  name="startSecond" class="input-style5">
                            <%
                               for(int j=0;j<60;j++)
                                  out.println("<option value="+j+ ">" + String.valueOf(j) + "</option>" );
                            %>
                          </select>
						  <br/>
                          Hour  Minute Second						  </td>
                      </tr>
                      <tr>
                        <td align="right" valign="center">End time</td>
                        <td valign="center">
                          <select  name="endHour" class="input-style5">
                            <%
                               for(int j=0;j<24;j++)
                               {
                                 if(j==23)
                                  out.println("<option value="+j + " selected>" + String.valueOf(j) + "</option>" );
                                 else
                                  out.println("<option value="+j + ">" + String.valueOf(j) + "</option>" );
                                }
                                  %>
                          </select>
                          <select  name="endMinute" class="input-style5">
                            <%
                               for(int j=0;j<60;j++)
                               {
                                 if(j==59)
                                  out.println("<option value="+j + " selected>" + String.valueOf(j) + "</option>" );
                                 else
                                  out.println("<option value="+j + ">" + String.valueOf(j) + "</option>" );
                                }%>
                          </select>
                          <select  name="endSecond" class="input-style5">
                            <%
                               for(int j=0;j<60;j++)
                               {
                                  if(j==59)
                                  out.println("<option value="+j + " selected>" + String.valueOf(j) + "</option>" );
                                  else
                                  out.println("<option value="+j+ ">" + String.valueOf(j) + "</option>" );
                                }
                                  %>
                          </select>
						  <br/>
                          Hour  Minute Second						  </td>
                      </tr>
                      <tr>
                      <td align="right" >Start Date</td>
                      <td valign="center">
                       <input type="text" name="startday" value="2000.01.01" maxlength="10" class="input-style1" readonly onClick="OpenDate(startday);">                      </td>
                      </tr>
                      <tr>
	                  <td align="right">End Date</td>
	                  <td valign="center">
                       <input type="text" name="endday" value="2999.12.31" maxlength="10" class="input-style1"  readonly onClick="OpenDate(endday);">                      </td>
                      </tr>

                      <tr style="display:none">
                        <td align="right" valign="center">Commemoration day</td>
                        <td valign="center">
                          <input type="text" name="ringDate" value="" maxlength="40" class="input-style1">                        </td>
                      </tr>

                      <tr>
                        <td colspan="2" align="center">
                          <img src="button/add.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:addTime()">&nbsp;&nbsp;
                          <img src="button/change.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:editTime()">&nbsp;&nbsp;
                          <img src="button/del.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:delTime()">&nbsp;&nbsp;
                          <img src="button/back.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:onBack()">                        </td>
                      </tr>
                    </table>

                  </td>
                </tr>
         <tr>
          <td colspan=2>
          <table border="0" width="100%" class="table-style2">
            <tr>
                <td class="table-styleshow" background="image/n-9.gif" height="26">
                  Notes:</td>
              </tr>
              <tr>
                <td style="color: #FF0000">1.Setup of Time Period Ringtone allows you to play special ringtones at special time periods of a day.</td>
              </tr>
              <tr>
                <td style="color: #FF0000">2.If the <%=userringtype.equals("0")?"calling":"called"%> number is a fixed phone number, please enter 0+area code+fixed phone number.</td>
              </tr>
              <tr>
                <td style="color: #FF0000">3.Start date and end date. If left blank, the default will be from "2000.01.01" to "2999.01.01".</td>
              </tr>
			  <tr>
                <td style="color: #FF0000">4.Setup of Time Period Ringtone has higher priority than that of the setup of <%=userringtype.equals("0")?"calling":"called"%> number (<%=userringtype.equals("0")?"calling":"called"%> number group) ringtones. This means, if the ringtone for <%=userringtype.equals("0")?"calling":"called"%> number (<%=userringtype.equals("0")?"calling":"called"%> number group) is also set at the set time period, the ringtone for the time period takes precedence.</td>
              </tr>
              <tr>
                <td style="color: #FF0000">5.The name of the time period ringtone is unique and can NOT be modified.</td>
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
      if(n == 0){
   	     document.inputForm.prefixType.value = "";
         document.inputForm.prefixType.disabled = true;

      }else{
         document.inputForm.prefixType.disabled = false;
		 document.inputForm.prefixType.focus();
      }
    }

function formLoad()
{
		 var fm = document.inputForm;
		  fm.curName.value = "";
		  fm.isgroup[0].checked = true;
		  document.inputForm.prefixType.disabled = true;
		  fm.prefixType.value = "";
		  fm.ringID.value = "";
}

   function onselectTimeList(){
      var fm = document.inputForm;
      var index = fm.selTimeList.selectedIndex;
      if(index==-1)
        return;
      fm.timeDecrip.value = s_vTimeDecrip[index];
      if(s_vCalledNum[index].length>1)
	   {
                fm.prefixType.value = s_vCalledNum[index];
				fm.isgroup[1].checked = true;
   	           document.inputForm.prefixType.disabled = false;
	   }
	   else
	   {
		       fm.prefixType.value = "";
			   fm.isgroup[0].checked = true;
			   document.inputForm.prefixType.disabled = true;
	   }
      fm.curName.value = s_vTimeDecrip[index];
      var str = s_vRingID[index];
      var len =0;
      var flag = 0;
      fm.ringID.value = str;
  	   fm.oldcrid.value = fm.ringID.value;
      	setTime(s_vStartTime[index],1);
      	setTime(s_vEndTime[index],2);
      	fm.ringDate.value =  s_vRingDate[index];
      	fm.startday.value =  s_vStartDate[index];
      	fm.endday.value =  s_vEndDate[index];
       fm.setpri.value =   s_vSetPri[index];
       fm.setno.value =   s_vSetNo[index];
      fm.timeDecrip.focus();
   }
   function addTime () {
      var fm = document.inputForm;
      if(fm.ringID.length == 0){
         alert("You haven't purchased any ringtone. Please purchase <%=ringdisplay%> first!");
         return false;
      }
      if(!checkInput())
         return false;

      var fee=<%= modefee %>;
      if(fee>0){
           if(!confirm("You will be charged "+ fee/<%=ratio%> + "<%=majorcurrency%> for adding the time period ringtone!  \N Are you sure you want to continue?" ))
              return;
      }
      fm.op.value = 'add';
      fm.submit();
   }
   function editTime () {
      var pform = document.inputForm;
      if(pform.selTimeList.length ==0){
        alert("No modifiable time period ringtone!");//没有可供更改的time segment铃音
        return;
      }
      if(pform.selTimeList.selectedIndex == -1){
         alert("Please select the time period ringtone you wish to modify! ");//请选择您要更改的time segment铃音
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
	   if(pform.isgroup[1].checked == true)
	   {
		 if (pform.prefixType.value=='')
		   {
                alert("Please Input Prefix!")
                pform.prefixType.focus();
				return false;
		   }
	   }
	   if (pform.prefixType.value!='')
	   {
	   if (! checkPhone()) {
         alert("A Prefix number can only be a digital number!");//主叫号码只允许输入数字
         pform.prefixType.value="";
         pform.prefixType.focus();
         return false;
      }
	  if ((pform.prefixType.value.length < <%=prefLen%>) || (pform.prefixType.value.length > <%=prefLen%>))
      {
         alert("A Prefix length should be "+ <%=prefLen%>+ "!");//主叫号码只允许输入数字
         pform.prefixType.value="";
         pform.prefixType.focus();
         return false;
       }
	   }
      var str1 =  makeTime(pform.startHour.value,pform.startMinute.value,pform.startSecond.value);
      var str2 =  makeTime(pform.endHour.value,pform.endMinute.value,pform.endSecond.value);
	  if(str1>str2){
	  	alert("The start time cannot be later than the stop time. Please re-enter");//起始时间大于截至时间,请重新输入
		return false;
	  }

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
      var fee=<%= modefee %>;
      if(fee>0 && pform.oldcrid.value != pform.ringID.value){
           if(!confirm("You will be charged "+ fee/<%=ratio%> + " <%=majorcurrency%> for modifying the time period ringtone!  \N Are you sure you want to continue?" ))
              return;
      }
      pform.timeDecrip.value = pform.curName.value;
      pform.op.value = 'edit';
      pform.submit();
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
		alert("Name cannot be null! Please re-enter!");//名称不能为空,请重新输入
         return false;
      }
      if (!CheckInputStr(pform.timeDecrip,"Time period name"))//time segment名称
      return;
      var temp="<%=  listCount %>";
	  var flag = 0;
      for(var i=0; i<parseInt(temp); i++){
		 if(s_vTimeDecrip[i]==name){
		 flag = 1;
         break;
      }
	  }
     if(flag ==1) {
        alert("The name you entered has been repeated. Please re-enter!");//您输入的名称已经重复,请重新输入
        pform.timeDecrip.focus();
        return false;
     }
      <%
        if(ifuseutf8 == 1){
          %>
          if(!checkUTFLength(pform.timeDecrip.value,20)){
            alert("The name should not exceed 40 bytes!");
            pform.timeDecrip.focus();
            return;
          }
      <%}%>
     if(pform.ringID.value ==""){
        alert("Please select <%=ringdisplay%> ringtone!");
        return false;
      }
      var str1 =  makeTime(pform.startHour.value,pform.startMinute.value,pform.startSecond.value);
      var str2 =  makeTime(pform.endHour.value,pform.endMinute.value,pform.endSecond.value);
	  if(str1>str2){
	  	alert("The start time cannot be later than the stop time. Please re-enter");//起始时间大于截至时间,请重新输入
		return false;
	  }
     if(pform.isgroup[1].checked == true)
	   {
		 if (pform.prefixType.value=='')
		   {
                alert("Please Input Prefix!")
                pform.prefixType.focus();
				return false;
		   }
	   }

	  if (pform.prefixType.value!='')
	   {
	    if (! checkPhone()) {
         alert("A Prefix number can only be a digital number!");//主叫号码只允许输入数字
         pform.prefixType.value="";
         pform.prefixType.focus();
         return false;
        }
	  if ((pform.prefixType.value.length < <%=prefLen%>) || (pform.prefixType.value.length > <%=prefLen%>))
		  {
         alert("A Prefix length should be "+ <%=prefLen%>+ "!");//主叫号码只允许输入数字
         pform.prefixType.value="";
         pform.prefixType.focus();
         return false;
         }
	   }
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
	  return true;
   }


   function delTime() {
      var fm = document.inputForm;
      if(fm.selTimeList.length ==0){
        alert("No time period ringtone can be deleted!");//没有可供删除的time segment铃音
        return;
      }

      if(fm.selTimeList.selectedIndex == -1){
         alert("Please select the time period ringtone you wish to delete!");//请选择需要删除的time segment铃音!
         return;
      }

	  var str1 =  makeTime(fm.startHour.value,fm.startMinute.value,fm.startSecond.value);
      var str2 =  makeTime(fm.endHour.value,fm.endMinute.value,fm.endSecond.value);
	  if(str1>str2){
	  	alert("The start time cannot be later than the stop time. Please re-enter");//起始时间大于截至时间,请重新输入
		return false;
	  }

	  fm.startTime.value = str1;
	  fm.endTime.value = str2;

	  if(fm.isgroup[1].checked == true)
	   {
		 if (fm.prefixType.value=='')
		   {
                alert("Please Input Prefix!")
                fm.prefixType.focus();
				return false;
		   }
	   }
        if (fm.prefixType.value!='')
	   {
	    if (! checkPhone()) {
         alert("A Prefix number can only be a digital number!");//主叫号码只允许输入数字
         fm.prefixType.value="";
         fm.prefixType.focus();
         return false;
        }
	  if ((fm.prefixType.value.length < <%=prefLen%>) || (fm.prefixType.value.length > <%=prefLen%>))
		  {
         alert("A Prefix length should be "+ <%=prefLen%>+ "!");//主叫号码只允许输入数字
         fm.prefixType.value="";
         fm.prefixType.focus();
         return false;
         }
	   }

      if (! confirm("Are you sure you want to delete this time period ringtone?"))//您是否确认删除这条time segment铃音
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
      var nowDate = currentDate.getFullYear() + month + day;
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
     document.location.href='setsystimering.jsp';
  }

   function queryInfo() {
	  var fm = document.inputForm;
     var sresult = "";
     var agt=navigator.userAgent.toLowerCase();
     var is_ie=(agt.indexOf("msie")!=-1 && document.all);
     if(is_ie)
    {
     //sresult = window.showModalDialog('ringSearch3.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
	 sresult =  window.open('ringSearch3.jsp','window','left=20,top=20,width=600,height=550,toolbar=1,resizable=0,scrollbars=yes,location=1');  
	 }
	else
    {
		netscape.security.PrivilegeManager.enablePrivilege('UniversalBrowserWrite');
		window.open('ringSearch3.jsp','window','modal=YES,resizable=YES,scrollbars=YES,status=0,left='+((screen.width-560)/2)+',top='+((screen.height-700)/2)+',width=600px,height=700px'); ;
        sresult = fm.result.value;

   }
     /*if(sresult){

        document.inputForm.ringID.value=sresult;
       }*/
       }
      function checkPhone () {
	  var fm = document.inputForm;
      var phone = trim(fm.prefixType.value);
	  if (!checkstring('0123456789',phone))
            return false;

      return true;
   }

</Script>
<%
        }
        else {
%>
<script language="javascript">
 	alert("Please log in first!");//请先登录
	document.location.href = 'enter.jsp';
</script>
<%
       }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + prefVal + "Exception occurred in the ringtone management on the basis of time period!");//用户time segment铃音管理出现异常
        sysInfo.add(sysTime + prefVal + e.toString());
        vet.add("Exception occurred in the ringtone management on the basis of time period!");//用户time segment铃音管理出现异常
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="systimeperiod.jsp?settype=3">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

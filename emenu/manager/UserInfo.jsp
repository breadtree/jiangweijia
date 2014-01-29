<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manUser"%>
<%@ page import="zxyw50.CrbtUtil"%>
<%@ page import="zxyw50.manSysPara"%>


<%@ page contentType="text/html; " language="java" import="java.sql.*" errorPage="" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
	// add for starhub
	boolean is_starhub = CrbtUtil.getConfig("IsStarhub", "0").equals("1") ? true : false;
	// added  for Mobitel 
	int isMobitel = zte.zxyw50.util.CrbtUtil.getConfig("isMobitel",0);
	String display_style = is_starhub ? "style=display:none" : "";
	String disable_str = is_starhub ? "disabled" : "";
	String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
%>

<html>
<head>
<title>Modify subscriber profile</title>

<link href="style.css" type="text/css" rel="stylesheet">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>

<body>
<script language="JavaScript">
	function queryInfo(){
		var usernum = trim(document.inputForm.userNumber.value);
		if(!isUserNumber(usernum,'userNumber')){//User number
			document.inputForm.userNumber.focus();
			return;
		}
		document.inputForm.opflag.value='1'; //查询
		document.inputForm.submit();
   	}

	function editInfo(){
	   var fm = document.inputForm;
           /*
	   var value = trim(fm.serviceKey.value);
	   if(fm.isIN.value==1 && value==""){
	      alert("IN subscribers must enter the service key");
	      fm.serviceKey.focus();
	      return;
	   }
	   if(value!='' && !checkstring('0123456789',value)){
             alert('The service key can only be digital');
             fm.serviceKey.focus();
             return;
          }
          value = trim(fm.scpGT.value);
          if( value!='' && !checkstring('0123456789',value)){
            alert('Only a digital string can be entered!');
            fm.scpGT.focus();
            return;
          }*/
          fm.opflag.value='2';  //修改
          fm.submit();
	}

//以下的逻辑是：如果是预付费用户，则必定是智能网用户
	function restIntChange()
	{
		var fm = document.inputForm;
		var value = fm.restInt.value;
		if(value==1)
			fm.isIN.value=1;
	}

	function isINChange()
	{
		var fm = document.inputForm;
		var restint = fm.restInt.value;
		if(restint==1)
		{
			alert("If the user is a Prepaid service subscriber,he/she is the IN service subscriber too.");
			fm.isIN.value=1;
		}
	}

</script>
<%
        String sysTime = "";
	String operID = (String)session.getAttribute("OPERID");
        String operName = (String)session.getAttribute("OPERNAME");
	Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
        Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String craacount = (String)request.getParameter("userNumber")==null?"":(String)request.getParameter("userNumber").trim();
	String opflag = (String)request.getParameter("opflag")==null?"":(String)request.getParameter("opflag").trim();
	String restInt = (String)request.getParameter("restInt")==null?"":(String)request.getParameter("restInt").trim();
	String serviceKey = (String)request.getParameter("serviceKey")==null?"":(String)request.getParameter("serviceKey").trim();
	String isIN = (String)request.getParameter("isIN")==null?"":(String)request.getParameter("isIN").trim();
	String scpGT = (String)request.getParameter("scpGT")==null?"":(String)request.getParameter("scpGT").trim();
	Hashtable hash1 = new Hashtable();
        String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
	String isgroup = (String)application.getAttribute("ISGROUP")==null?"1":(String)application.getAttribute("ISGROUP");
// 法电彩像版本新增  by yuanshenhong
String colorphotoname = zte.zxyw50.util.CrbtUtil.getConfig("colorphotoname","Color Photo Show");
String usecalling =CrbtUtil.getConfig("usecalling","0");
String isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");
// end
	try{
		manUser manuser = new manUser();
		sysTime = manuser.getSysTime() + "--";
		Vector result = new Vector();
		String  errmsg = "";
        boolean flag =true;
        if (operID  == null){
           errmsg = "Please log in to the system first!";//Please log in to the system
           flag = false;
        }
        else if (purviewList.get("1-3") == null) {
          errmsg = "You have no right to access function!";//You have no access to this function
          flag = false;
        }
        if(flag){
        	    zxyw50.Purview purview = new zxyw50.Purview();
		    if(opflag.compareTo("2")==0){
            		if(!purview.CheckOperatorRight(session,"1-3",craacount)){
               			throw new Exception("You have no right to manager this subscriber!");
            		}
		    	Hashtable hash2 = new Hashtable();
		    	hash2.put("userNumber",craacount);
		    	if(serviceKey==null)
		    		serviceKey="";
		    	hash2.put("serviceKey",serviceKey);
		    	if(scpGT==null)
		    		scpGT="";
		    	hash2.put("scpGT",scpGT);
		    	if(restInt==null)
		    		restInt="";
		    	hash2.put("preFlag",restInt);
		    	if(isIN==null)
		    		isIN="";
		    	hash2.put("isIN",isIN);


                        String usertype=(String)request.getParameter("usertype");
            if(usertype==null)
            	usertype="";
                        String usertype1=(String)request.getParameter("usertype1");
            if(usertype1==null)
            	usertype1="";
			String usertype3=(String)request.getParameter("usertype3");
			if(usertype3==null)
			usertype3="";

                        String group = (String)request.getParameter("group");
                        if(group!=null&&!group.trim().equals(""))
                                	usertype=group;
				if(usertype==null)
					throw new Exception("The subscriber type is unknown!");
				hash2.put("usertype",usertype);
			if("1".equals(usecalling)){
                                hash2.put("usertype1",usertype1);
			}
			if("1".equals(isimage.trim())){
				hash2.put("usertype3",usertype3);
			}
		    	manuser.editDesUserInfo(hash2);
                      // 准备写操作员日志
                 //     zxyw50.Purview purview = new zxyw50.Purview();
                      HashMap map = new HashMap();
                      map.put("OPERID",operID);
                      map.put("OPERNAME",operName);
                      map.put("OPERTYPE","106");
                      map.put("RESULT","1");
                      map.put("PARA1",craacount);
                      map.put("PARA2","ip:"+request.getRemoteAddr());
                      purview.writeLog(map);
%>
<script language="JavaScript">
	alert('Subscriber profile modified successfully!');//用户信息修改成功
</script>
<%
		result = manuser.getDesUserInfo(craacount,19);
		hash1 = (Hashtable)result.get(0);
		}
		else if(opflag.compareTo("1")==0){
            		if(!purview.CheckOperatorRight(session,"1-3",craacount)){
               			throw new Exception("You have no right to manager this subscriber!");
            		}
			result = manuser.getDesUserInfo(craacount,31);
			hash1 = (Hashtable)result.get(0);

		}

%>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="650";
</script>
<form name="inputForm" method="post" action="UserInfo.jsp">
<input name="opflag" type="hidden" id="opflag">
<input name="group" type="hidden" id="group" value="">
<table width="440"  border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr valign="center">
    <td align="center">
      <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="table-style2">
        <tr>
            <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif"> Modify subscriber profile</td>
        </tr>
        <tr>
          <td height="22" align="right" width="40%"><%=user_number%></td>
          <td height="22"><input type="text" name="userNumber" value="<%= craacount==null?"":craacount %>" maxlength="20" class="input-style1"
<%          if( craacount!=null && craacount.length()>0 && hash1.size()>0)
					out.print(" readonly ");
				%>></td>
        </tr>
<%
	if( craacount!=null && craacount.length()>0 && hash1.size()>0){
                %>

<%
         String user2 = (String)hash1.get("usertype_sub0");
         Vector  userlist =null;
         manSysPara  sysPara = new manSysPara();
         int usersize=0;
         Hashtable users = null;
		if((user2!=null) && !"".equals(user2)){
        %>
		<tr>
          <td height="22" align="right">Called service type</td>
          <td height="22">
          	<select  name="usertype" class="input-style1" style="<%= hash1.size()>0?"":"display:none"%>">
<%

				userlist = sysPara.getUserTypeInfo("1");
   			usersize = userlist.size();
				String nextMonthType=(String)hash1.get("nusertype_sub0");
				for(int i=0;i<usersize;i++)
				{
		users = (Hashtable)userlist.get(i);
					String user1 = (String)users.get("usertype");

					if(nextMonthType!=null && nextMonthType.equals(user1))
						nextMonthType = (String)users.get("utlabel");

		if(user1!=null && user1.equals(user2)){

	%>
					<option value="<%=(String)users.get("usertype") %>" selected><%=(String)users.get("utlabel") %></option>
           <%
		   }else{
		         if(isMobitel == 1){
		         }else{
		   %>
					<option value="<%=(String)users.get("usertype") %>" ><%=(String)users.get("utlabel") %></option>
		   <%}
		   }
				}
		   	%>
		   </select>
        </tr>
        <tr>
        		<td height="22" align="right">Called service type of next month</td>
			<td height="22"><%=nextMonthType%></td>
        </tr>
<%		}

        if("1".equals(usecalling.trim())){
   	    user2 = (String)hash1.get("usertype_sub1");
		if((user2!=null) && !"".equals(user2)){
		userlist = sysPara.getUserTypeInfo("2");
		usersize = userlist.size();
        %>

		<tr>
          <td height="22" align="right" >Calling service type</td>
          <td height="22">
		      <select  name="usertype1" class="input-style1" style="<%= hash1.size()>0?"":"display:none"%>">
              <%
		      String nextMonthType=(String)hash1.get("nusertype_sub1");
			  for(int i=0;i<usersize;i++){
			 	   users = (Hashtable)userlist.get(i);
				   String user1 = (String)users.get("usertype");
				   if(nextMonthType!=null && nextMonthType.equals(user1))
				       nextMonthType = (String)users.get("utlabel");
				   if(user1!=null && user1.equals(user2)){
			  %>
				   <option value="<%=(String)users.get("usertype") %>" selected><%=(String)users.get("utlabel") %></option>
			  <%
			       }else{
			  %>
				   <option value="<%=(String)users.get("usertype") %>" ><%=(String)users.get("utlabel") %></option>
			  <%
			       }
			  }
			  %>
			  </select>
        </tr>
        <tr>
          <td height="22" align="right">Calling service type for next month</td>
          <td height="22"><%=nextMonthType%></td>
        </tr>
        <%}
        }
		if("1".equals(isimage.trim())){
			user2 = (String)hash1.get("usertype_sub4");
		if((user2!=null) && !"".equals(user2))
  		{
				userlist = sysPara.getUserTypeInfo("16");
				usersize = userlist.size();
%>

		<tr>
			<td height="22" align="right" >Image service type</td>
			<td height="22">
			<select  name="usertype3" class="input-style1" style="<%= hash1.size()>0?"":"display:none"%>">
<%
			String nextMonthType=(String)hash1.get("nusertype_sub4");
	for(int i=0;i<usersize;i++){
          users = (Hashtable)userlist.get(i);
         String user1 = (String)users.get("usertype");
			if(nextMonthType!=null && nextMonthType.equals(user1))
				nextMonthType = (String)users.get("utlabel");
          if(user1!=null && user1.equals(user2)){
	%>
        <option value="<%=(String)users.get("usertype") %>" selected><%=(String)users.get("utlabel") %></option>
           <%
		   }else{
		   %>
                   <option value="<%=(String)users.get("usertype") %>" ><%=(String)users.get("utlabel") %></option>
		   <%
		   }
	}
		   %>
		   </select>
		    </td>
        </tr>
        <tr>
			<td height="22" align="right">Image service type for next month</td>
			<td height="22"><%= nextMonthType %></td>
        </tr>
<%
 	}
        }
%>
		<tr>

          <td height="22" align="right">Account opening mode</td>
          <td height="22"><input type="text" name="openway" value="<%= (String)hash1.get("activeid")==null?"":(String)hash1.get("activeid") %>" maxlength="6" class="input-style1"  disabled ></td>
        </tr>
		<tr>
          <td height="22" align="right">Total number of existing ringtones in the personal ringtone library</td>
          <td height="22"><input type="text" name="customring" value="<%= (String)hash1.get("ringNum")==null?"":(String)hash1.get("ringNum") %>" maxlength="5" class="input-style1"  disabled ></td>
        </tr>
        <tr>
          <td height="22" align="right">Number of calling number groups</td>
          <td height="22"><input type="text" name="totalring" value="<%= (String)hash1.get("callinggroup")==null?"":(String)hash1.get("callinggroup") %>" maxlength="5" class="input-style1"  disabled ></td>
        </tr>
        <tr <%=display_style%>>
          <td height="22" align="right">Number of ringtone groups</td>
          <td height="22"><input type="text" name="ringgrpnum" value="<%= (String)hash1.get("ringgrpNum")==null?"":(String)hash1.get("ringgrpNum") %>" maxlength="5" class="input-style1"  disabled ></td>
        </tr>
        <tr <%=display_style%>>
          <td height="22" align="right">Total of set phone numbers</td>
          <td height="22"><input type="text" name="callingnum" value="<%= (String)hash1.get("callingNum")==null?"":(String)hash1.get("callingNum") %>" maxlength="5" class="input-style1"  disabled ></td>
        </tr>
		<tr>
          <td height="22" align="right">Prepaid service subscriber</td>
          <td height="22">
            <select name=restInt style="width:150" class="input-style1" onchange="restIntChange()" <%=disable_str%>>
              <%
                 int restInt1 = Integer.parseInt((String)hash1.get("restint1")==null?"0":(String)hash1.get("restint1"));
                 if(restInt1==1){
                   out.println("<option value=0>NO</option>");
                   out.println("<option value=1 selected>YES</option>");
                 }
                 else{
                    out.println("<option value=0 selected>NO</option>");
                    out.println("<option value=1 >YES</option>");
                 }
              %>
            </select>
          </td>
        </tr>
		<tr <%=display_style%>>
          <td height="22" align="right">IN service subscriber</td>
          <td height="22">
          <select name=isIN style="width:150" class="input-style1" onchange="isINChange()" >
            <%
                 int isIN1 = Integer.parseInt((String)hash1.get("isIN")==null?"0":(String)hash1.get("isIN"));
                 if(isIN1==1){
                   out.println("<option value=0>NO</option>");
                   out.println("<option value=1 selected>YES</option>");
                 }
                 else{
                    out.println("<option value=0 selected>NO</option>");
                    out.println("<option value=1 >YES</option>");
                 }
             %>
           </select>
		   </td>
        </tr>
        <!--
        <tr>
          <td height="22" align="right">Serivce key (digits)</td>
          <td height="22"><input type="text" name="serviceKey" value="<%= (String)hash1.get("serviceKey")==null?"":(String)hash1.get("serviceKey") %>" maxlength="8" class="input-style1"></td>
        </tr>
		<tr>
          <td height="22" align="right">SCP GT (digits)</td>
          <td height="22"><input type="text" name="scpGT" value="<%= (String)hash1.get("scpGT")==null?"":((String)hash1.get("scpGT")).trim() %>" maxlength="26" class="input-style1"></td>
        </tr>
        -->
        <input type="hidden" name="serviceKey" value="" />
        <input type="hidden" name="scpGT" value="" />
<%
	}
         %>

		<tr align="center">
          <td colspan="3">
            <table border="0" width="75%" class="table-style2">
              <tr align="center">
                 <td align="center"><img src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:queryInfo()"></td>
            <%
	if( craacount!=null && craacount.length()>0 && hash1.size()>0){
%>
			    <td align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>

                 <td  align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
            <%}%>  </tr>
            </table>
          </td>
        </tr>
		<tr>
		<td colspan="2" class="table-styleshow" background="image/n-9.gif" height="28">Notes:</td>
  </tr>
  <%  if(areacode.equals("3")){
  %>
    <tr>
      <td style="color: #FF0000">1.Format of PHS <%=user_number%>: 0+area code+actual number.</td>
    </tr>
   <% } else {%>
    <tr>
      <td colspan="2" height="20" style="color: #FF0000">1.<%=user_number%>: Mobile Phone Number.</td>
    </tr>
  <% } %>
  <tr>
    <td colspan="2" height="20" style="color: #FF0000">2.Click the Search button, modify subscriber profile</td>
  </tr>
  <tr>
     <td colspan="2" height="20" style="color: #FF0000">3.You cannot click the Edit button to modify Subscriber Type, PPS Subscriber, Service Key,IN Service Subscriber or SCP GT options, unless the subscriber profile is found by query.</td>
  </tr>
   <tr>
     <td colspan="2" height="20" style="color: #FF0000">4.If you modify subscriber's type,it will  be effective in the next month.</td>
  </tr>
      </table>
    </td>
  </tr>


</table>
</form>
<%
        }
        else {
%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script>
<%
       }
   }
	catch(Exception e) {
	Vector vet1 = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in modifying subscriber profile!");//用户基本信息更改过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet1.add("Error occurred in modifying subscriber profile!");//用户基本信息更改过程出现错误
        vet1.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet1);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="UserInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<% }
%>
</body>
</html>

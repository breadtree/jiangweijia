<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.RingQuery" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
	zxyw50.Purview purview = new zxyw50.Purview();
	Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ringid = "";
    String  optSCP = "";
    String    errmsg = "";
   try {
        boolean   flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
      if (purviewList.get("3-41") == null &&  sysfunction.get("3-41-0")!= null) {
            errmsg = "Sorry,you have no access to this function!";//You have no access to this function!
            flag = false;
          }
		 //flag=true;
		 if(flag){
		 	RingQuery ringQuery=new RingQuery();
		 	ArrayList list = new ArrayList();
 			list = ringQuery.getManagerInfoList();
			int result=-1;
			int totalCount=Integer.parseInt(CrbtUtil.getConfig("manageinfocount","10"));
			int resultCount = ringQuery.getManagerInfoCount();
			String userName = (String)request.getParameter("userName");
			String del = (String)request.getParameter("del");
			if(del!=null && del.equals("true")){
				String number = (String)request.getParameter("userNumber");
				int delResult=ringQuery.deletemanageUserInfo(number);
				list = ringQuery.getManagerInfoList();
				resultCount = ringQuery.getManagerInfoCount();
			}else if(userName!=null){
				 String userNumber = (String)request.getParameter("userNumber");
				 String userType = (String)request.getParameter("userType");
				 
				 HashMap map=new HashMap();
				 map.put("usernumber",userNumber);
 				 map.put("username",userName);
				 map.put("usertype",userType);
				 result=ringQuery.updatemanageUserInfo(map);
				 list = ringQuery.getManagerInfoList();
				 resultCount = ringQuery.getManagerInfoCount();
			}
			 
%>

<script src="../pubfun/JsFun.js"></script>

<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>CRBT</title>
</head>
<script>

function checkInternationalPhone(strPhone){
	var bracket=3;
	strPhone=trim(strPhone);
	if(strPhone.indexOf("+")>1) return false;
	if(strPhone.indexOf("-")!=-1)bracket=bracket+1;
	if(strPhone.indexOf("(")!=-1 && strPhone.indexOf("(")>bracket)return false;
	var brchr=strPhone.indexOf("(");
	if(strPhone.indexOf("(")!=-1 && strPhone.charAt(brchr+2)!=")")return false;
	if(strPhone.indexOf("(")==-1 && strPhone.indexOf(")")!=-1)return false;
	//s=stripCharsInBag(strPhone,validWorldPhoneChars);
	return true;
}
	
	function delInfo(usernumber){
		var del=confirm('Are you sure to delete this user');
		if(del){
			var fm=document.inputForm;
			fm.del.value=true;
			fm.userNumber.value=usernumber;
			fm.submit();
		}
	}
	
	function checkInfo(){
		
 		var fm=document.inputForm;
        
		if (fm.userType.value==0){
			<%if(resultCount>=totalCount){%> 
				alert("You have exceeded the manager info limit.");
				return false;
			<%}%>
		 }
        
	    if (fm.userNumber.value == '') {
	     	alert("Please Enter Phone Number");
			fm.userNumber.focus();
			return false;
	    }
		if (fm.userName.value == '') {
	   	 alert("Please Enter Name");
		 fm.userName.focus();
		  return false;
	    }
		if (fm.userNumber.value.length>0) {
	  	  if (checkInternationalPhone(fm.userNumber.value)==false){
			alert("Please Enter a Valid Phone Number");
			fm.userNumber.value="";
			fm.userNumber.focus();
			return false;
		  }
	    }
		fm.submit();
	}
	
	function AllowOnlyIntegers()
	  {    
		 var keyCode = event.keyCode;
		 if((keyCode>=48 && keyCode<=57))
		 {			
		  event.returnValue = true;
		 }
		 else
		 {
		  event.returnValue = false;
		 }   
	  }
</script>
<body topmargin="0" leftmargin="0" class="body-style1" >
<form name="inputForm" method="post" action="spManageInfo.jsp" onSubmit="checkInfo();">
	<input type="hidden" name="del">
	<table border="0" width="500" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
		<tr >
			  <td height="20"  align="center">&nbsp;</td>
	   </tr>
	   <tr >
			  <td height="26"  align="center" class="text-title"  background="image/n-9.gif" >Manager Info </td>
	   </tr>
	   <tr >
			  <td height="20"  align="center">&nbsp;</td>
	   </tr>
  </table>
  	<p class="text-error">
  	  <%if(result!=-1){%>
		<%if(result==1){%>
			Updated successfully.
		    <%}else if(result==4){%>
			Number already exist.
		<%}else if(result==5){%>
			Exceeded the limit for manager info	
		    <%}%>
        <%}%>
 
  </p>
  	<table border="0" cellspacing="0" cellpadding="0"  class="table-style2" width="93%"  align="center">
    
     <tr height=35>
       <td width="19%">User Number : </td>
       <td width="81%"> <label>
         <input name="userNumber" type="text" class="td02" onKeyPress="AllowOnlyIntegers();" maxlength="20">
       </label></td>
     </tr>
     
     <tr height=35>
       <td>User Name : </td>
       <td><input name="userName" type="text" class="td02" maxlength="40"></td>
     </tr>
     
     <tr height=35>
       <td>User Type </td>
       <td><select name="userType" id="userType">
	   			<option value="0" selected="selected">Default</option>
				<option value="1">SMS Report Staffs</option>
	   		</select>
		</td>
     </tr>
     <tr height=35>
       <td>&nbsp;</td>
       <td>&nbsp;</td>
     </tr>
     <tr height=35>
       <td><label></label></td>
       <td>
	   	<button value="Submit" class="submitBtn" type="button" onClick="checkInfo();"><span>Submit</span></button>
	 </td>
     </tr>
    
  </table>
 
</form>
	<%if(list.size()>0){%>
	<table width="100%" border="0" cellpadding="1" cellspacing="1" class="table-style2">
		<tr class="table-title1" height="25">
			<td width="40%" align="center">User Name</td>
			<td width="40%" align="center">User Number</td>
			<td width="40%" align="center">User Type</td>
			<td width="20%" align="center">Delete</td>
		</tr>
		<%for(int i=0;i<list.size();i++){
			HashMap hash = (HashMap)list.get(i);
			String userType=(String)hash.get("usertype");
			if(userType.equals("1"))
				userType="SMS Report Staffs";
			else
				userType="Default";
		%>
			<tr bgcolor="<%= i % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
				<td align="center"><%=(String)hash.get("username")%></td>
				<td align="center"><%=(String)hash.get("usernumber")%></td>
				<td align="center"><%=userType%></td>
				<td align="center"><img src="../image/delete.gif" height='15'  width='15' alt="Delete" onMouseOver="this.style.cursor='hand'"
						onClick="javascript:delInfo('<%= (String)hash.get("usernumber") %>','<%= (String)hash.get("username") %>');"/></td>
			</tr>
		<%}%>
</table>
	<%}%>
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
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occourred in the Stat.of subscriber feed back info!");// 用户铃音活动统计操作查询过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        //vet.add("用户铃音活动统计操作查询过程出现错误!");
        vet.add("Error occourred in the Stat.of subscriber feedback!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="queryDyRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

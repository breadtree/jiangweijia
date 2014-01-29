<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>RBT Black Prefix</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">

<%
	String sysTime = "";
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
    	manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null &&  purviewList.get("3-44") != null) { 
            Vector vet = new Vector();
            ArrayList rList  = new ArrayList();
			ArrayList blackList  = new ArrayList();
            HashMap hash = new HashMap();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String blackPrefNum = request.getParameter("blackprefnum") == null ? "" : transferString((String)request.getParameter("blackprefnum")).trim();
            int  optype =0;
            String desc = "";
            if (op.equals("add")) {
                optype = 1;
				desc  = operName + "Add RBT Black Prefix";
    	    }
            else if (op.equals("del")){
                optype = 2;
				desc  = operName + "Delete RBT Black Prefix";
            }
            if(optype==1 || optype==2 ){
                hash.put("optype",optype+"");
                hash.put("blackPrefNum",blackPrefNum);
                rList = syspara.addDeleteRBTBlackPrefix(hash); // To add/delete the prefixes to the block list.
                sysInfo.add(sysTime + desc);
            }
            if(!op.equals("")&& getResultFlag(rList)) {
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","344");
                map.put("RESULT","1");
                map.put("PARA1","");
                map.put("PARA2","");
                map.put("PARA3","");
                map.put("PARA4","");
                map.put("PARA5",blackPrefNum);
                purview.writeLog(map);
            }
            if(rList.size()>0){
                session.setAttribute("rList",rList);
%>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="RBTBlackPrefix.jsp">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
<%
			}
            blackList = (ArrayList)syspara.getRBTBlackPrefixInfo(); // To get the blocked prefixes.
%>
<script language="javascript">
	var v_blackprefnum = new Array(<%= blackList.size() + "" %>);
<%
	for (int i = 0; i < blackList.size(); i++) {
		String blackPrefix = (String)blackList.get(i);
%>
		v_blackprefnum[<%= i + "" %>] = '<%=blackPrefix%>';
<%
	}
%>

	function selectInfo () {
		var fm = document.inputForm;
        var index = fm.infoList.selectedIndex;
        if (index ==-1)
        	return;
		fm.blackprefnum.value =  v_blackprefnum[index];
	}
 
    function checkInfo () {
    	var fm = document.inputForm;
	    if(fm.blackprefnum.value == ''){
			alert("The value of the prefix should not be empty!")
			fm.blackprefnum.focus();
			return;
		}
		if(!isInt(fm.blackprefnum.value)){
			alert("The value of the prefix can only be numeric!")
			fm.blackprefnum.focus();
			return;
		}
		/*if(!lengthCheck(fm.blackprefnum.value,4)){
			alert("The prefix length should be 4 charaters!")
			fm.blackprefnum.focus();
			return;	
		}*/
		return true;
	}
	
	function isInt(num){
		var objRegExp = /(^\d+$)/; //Regular expression to check the numbers
		return objRegExp.test(num);
	}
	
	/*function lengthCheck(ChkStr,ChkLen){
		var l=strlength(ChkStr);
		if(l!=ChkLen)
		    return;
		return true;
	}*/
    
	function addInfo () {
    	var fm = document.inputForm;
	 	if (! checkInfo())
        	return;
		fm.op.value = 'add';
		fm.submit();
	}

	function delInfo () {
    	var fm = document.inputForm;
      	if (trim(fm.blackprefnum.value) == '') {
        	alert("Please select a prefix first!");
         	return;
      	}
        fm.op.value = 'del';
        fm.submit();
	}
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>

<form name="inputForm" method="post" action="RBTBlackPrefix.jsp">
<input type="hidden" name="op" value="">
<table width="80%" height="400" border="0" align="center" class="table-style2">
 <tr valign="center">
  <td>
   <table width="100%" border="0" align="center" class="table-style2">
    <tr>
     <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">RBT Black Prefix</td>
    </tr>
    <tr>
     <td rowspan="5">
      <select name="infoList" size="8" <%= blackList.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
		for (int i = 0; i < blackList.size(); i++) {
%>
       <option value="<%= i + "" %>"><%= (String)blackList.get(i) %></option>
<%
		}
%>
      </select>
     </td>
     <td align="right">Number Prefix</td>
     <td><input type="text" name="blackprefnum" value="" maxlength="40" class="input-style1"></td>
    </tr>
    <tr>
     <td colspan="2">
      <table border="0" width="100%" class="table-style2">
       <tr>
        <td width="25%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
        <td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
        <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
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
        else {
			if(operID == null){
%>
<script language="javascript">
	alert( "Please log in first!");//Please log in to the system.
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing RBT Black Prefix!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing RBT Black Prefix!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
 <input type="hidden" name="historyURL" value="RBTBlackPrefix.jsp">
</form>
<script language="javascript">
	document.errorForm.submit();
</script>
<%
	}
%>
</body>
</html>

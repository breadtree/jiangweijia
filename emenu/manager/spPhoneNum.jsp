<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@page import="com.zte._utillog.SysOut"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="com.zte.tao.IModelData" %>
<%@ page import="zte.zxyw50.CRBTContext" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>


<html>
<head>
<title>SP phone numbers management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	try {
    	ywaccess yw = new ywaccess();
        manSysRing sysring = new manSysRing();
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if(operID != null  && purviewList.get("3-49") != null) {
        	ColorRing colorring = new ColorRing();	
		    ArrayList vet = new ArrayList();
            ArrayList rList  = new ArrayList();
            Hashtable hash = new Hashtable();
			String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
			String promolist = request.getParameter("promolist") == null ? "-1" : transferString((String)request.getParameter("promolist")).trim();
			String UserType = request.getParameter("UserType") == null ? "" : transferString((String)request.getParameter("UserType")).trim();
			String freedays = request.getParameter("freedays") == null ? "0" : transferString((String)request.getParameter("freedays")).trim();
			String createdate = request.getParameter("createdate") == null ? "" : transferString((String)request.getParameter("createdate")).trim();
			String expiredate = request.getParameter("expiredate") == null ? "" : transferString((String)request.getParameter("expiredate")).trim();
			String discount = request.getParameter("discount") == null ? "0" : transferString((String)request.getParameter("discount")).trim();
            String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
            String temList = request.getParameter("temList") == null ? "" : transferString((String)request.getParameter("temList")).trim();
            String spList = request.getParameter("spList") == null ? "0" : transferString((String)request.getParameter("spList")).trim();
            String usernumber = request.getParameter("usernumber") == null ? "" : transferString((String)request.getParameter("usernumber")).trim();
            String NumList = request.getParameter("NumList") == null ? "" : transferString((String)request.getParameter("NumList")).trim();
            String realNum = request.getParameter("realNum") == null ? "" : transferString((String)request.getParameter("realNum")).trim();
            
            String optype = "";
            String  sTmp = "";
            String  title = "";
            HashMap map = new HashMap();
            
            int supportRingpromo = 0;
            String  sDesc = "";
            if (op.equals("add")) {
                optype = "1";
               	sTmp = sysTime + operName + "add SP phone numbers";
                title = "add SP phone numbers ";
                sDesc = "add";
             }
            else if (op.equals("del")) {
                optype = "2";
                sTmp = sysTime + operName + " delete SP phone numbers";
                title = "delete SP phone numbers ";
                sDesc = "delete";
            }
            if(!op.equals("")){
              if( op.equals("add") || op.equals("del")){
            	  if(op.equals("del")){
            		  usernumber =  realNum;
            	  }
                hash.put("spList",spList);
                hash.put("usernumber",usernumber);
			    hash.put("optype",optype);
			    hash.put("operName",operName);
               	rList = sysring.modspPhoneinf(hash);
              }
              if(getResultFlag(rList)){
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","349");
                  map.put("RESULT","1");
			      map.put("PARA1",spList);
                  map.put("PARA2",usernumber);
                  map.put("PARA3",optype);
                  map.put("PARA4",operName);
                  map.put("PARA5","");
                  map.put("PARA6","");
                  map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                  zxyw50.Purview purview = new zxyw50.Purview();
                  purview.writeLog(map);
                }
                sysInfo.add(sTmp);
                if(rList.size()>0){
					session.setAttribute("rList",rList);
	
					
                %>
<form name="resultForm" method="post" action="result.jsp">
	<input type="hidden" name="historyURL" value="spPhoneNum.jsp?spList=<%=spList%>">
	<input type="hidden" name="title" value="<%= title %>">
	<script language="javascript">
		document.resultForm.submit();
	</script>
</form>
<%
   }
 } 
         ArrayList spVet = new ArrayList();
         spVet = syspara.getSPInfo();	
         HashMap spMap = new HashMap();
         String seletFlag = "";
         String optSP = "";
         optSP = "<option "+(spList.equals("0") ? "selected" : "") + " value=0> SMAP </option>";
         for (int i = 0; i < spVet.size(); i++) {
        	 spMap = (HashMap)spVet.get(i);
             if(spList.equals((String)spMap.get("spindex"))){
            	 seletFlag = "selected";
             }else{
            	 seletFlag = "";
             }
             optSP = optSP + "<option "+seletFlag+" value=" + (String)spMap.get("spindex") + " > " + (String)spMap.get("spindex")+"--"+(String)spMap.get("spname")+ " </option>";
          }                           
		 vet = colorring.getSpPhoneNum(spList);
%>


<script language="javascript">
   var v_usernumber = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                map = (HashMap)vet.get(i);
%>
   v_usernumber[<%= i + "" %>] = '<%= (String)map.get("usernumber") %>';
<%
            }
%>
</script>


<script language="javascript">

	function checkInfo () {
	  var fm = document.inputForm;
	  var flag = false;
	  
	  if(trim(fm.spList.value)=='') {
		alert("Please select SP!");
		return flag;
	  }
	  
	  	  if(trim(fm.usernumber.value)=='') {
		  alert("Please Input Phone Number");
		  return flag;
	  }
	  	  
      if(!checkstring('0123456789',trim(fm.usernumber.value))){
         alert("Phone Number should be the digit character string, please input it again!");
         return false;
      }
	  	  
   flag = true;
   return flag;
}


function addInfo () {
	var fm = document.inputForm;
	var addV;
	if (!checkInfo())
		return;
	fm.op.value = 'add';
	fm.target="_self";
  	fm.submit();
}
function delInfo () {
	var fm = document.inputForm;
	if(fm.NumList.selectedIndex == -1) {
		alert('Please select the Phone Number to delete!');
		return;
	}
    if(!confirm("Are you sure you want to delete the Phone Number?")) {
		return;
	}
	fm.op.value = 'del';
	fm.target="_self";
  	fm.submit();
}

 function queryInfo() {
 
	     var result =  window.open('proRingSearch.jsp?hidemediatype=1&mediatype=1','mywin','left=20,top=20,width=600,height=550,toolbar=1,resizable=0,scrollbars=yes');

  }


function selectInfo () {
      var fm = document.inputForm;
      var index = fm.NumList.value;
      if (index == null)
         return;
      if (index == '') {
         return;
      }
      fm.usernumber.value = v_usernumber[index];
      fm.realNum.value = v_usernumber[index];
}

function selectSp(){
	document.inputForm.submit();
}


</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		 parent.document.all.main.style.height="750";
</script>
<form name="inputForm" method="post" action="spPhoneNum.jsp">
<input type="hidden" name="op" value="" />
<input type="hidden" name="backUserType" />
<input type="hidden" name="backRingId" />
<input type="hidden" name="ringid" />
<input type="hidden" name="temList" />
<input type="hidden" name="realNum"/>
<table width="100%" height="400" border="0" align="center" class="table-style2">
  <tr valign="top">
          <td height="26" align="center" class="text-title" background="image/n-9.gif">SP phone numbers management</td>
        </tr>
  <tr valign="center">
    <td>
      <table width="514" border="0" align="center" class="table-style2">
         <tr>         
         <td align="right" >SP</td>
          <td valign="top"  width="126">
            <select name="spList"  class="input-style1" style="width:180px;" onchange="javascript:selectSp();">
			<%
			out.print(optSP);		
			%>
            </select>
          </td>
		 </tr>
        <tr>
          <td valign="top" rowspan="8" width="126" colspan="2">
            <select name="NumList" size="20" class="input-style1" style="width:200px;" onclick="javascript:selectInfo();">
			<%
            for (int i = 0; i < vet.size(); i++) {
                map = (HashMap)vet.get(i);
%>
          <option value="<%= i + ""%>"><%= (String)map.get("usernumber")%></option>
<%
        }	
			%>
            </select>
          </td>
		 </tr>
		 <tr>
          <td align="right" width="177">Phone Number</td>
          <td width="197">
          <input type="text" name="usernumber" value="" maxlength="10" class="input-style1" size="20"></td>
        </tr>
		<tr>
          <td colspan="3" width="520">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td align="center">
                <img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()" width="45" height="19"></td>
               <td align="center">
                <img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()" width="45" height="19"></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr >
          <td height="26" colspan="3" width="508" >
           <table border="0" width="100%" class="table-style2">
			  <tr style="color: #FF0000">
				  <td height="26" background="image/n-9.gif"><span class="style1"> &nbsp;&nbsp;Notes:</span></td>
			  </tr>
              <tr style="color: #0000FF">
               <td >1. Select SP.</td>
              </tr>
			  <tr style="color: #0000FF">
               <td >2. Input Phone Number. </td>
              </tr>
              <tr style="color: #0000FF">
               <td >3. Phone Number should be the digit. </td>
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
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in SP manager phone numbers!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in SP manager phone numbers!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spPhoneNum.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

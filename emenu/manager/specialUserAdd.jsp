<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%@ include file="../pubfun/JavaFun.jsp" %>


<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page"/>
<html>
<head>
<title>Special User</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script src="../pubfun/JsFun.js"></script>
</head>
<base target="_self">
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%

    String sysTime = "";
 	 manProductCode  productCode = new manProductCode();

    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");;
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");


    String op   = request.getParameter("op") == null ? "" : request.getParameter("op");
    String disabled = "";
    String readonly = "";

    String usernumber = request.getParameter("usernumber") == null ? "" : request.getParameter("usernumber");
    String bflag      = request.getParameter("bflag") == null ? "" : request.getParameter("bflag");
    String para1      = request.getParameter("para1") == null ? "" : request.getParameter("para1");
    String para2      = request.getParameter("para2") == null ? "" : request.getParameter("para2");
	// add for starhub
	String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
    try {
    	String  errmsg = "";
   		boolean flag=true;
	    if (operID  == null){
         	errmsg = "Please log in to the system first!";//Please log in to the system
           	flag = false;
        }
        else if (purviewList.get("1-20") == null) {
          	errmsg = "You have no right to access function!";//You have no access to this function
          	flag = false;
        }
    	if(!flag)
    		throw new Exception(errmsg);


        sysTime = productCode.getSysTime() + "--";
        HashMap map = new HashMap();

        Hashtable hash = new Hashtable();
        ArrayList rList  = new ArrayList();

        hash.put("usernumber",usernumber);
       	hash.put("bflag"     ,bflag);
        hash.put("para1"     ,para1);
        hash.put("para2"     ,para2);

        if(op.equals("add")){
            int optype = 0;
            String  sTmp = "";
            String  title = "";
            map = new HashMap();
            hash.put("optype","1"); //Ìí¼ÓÐÂ¼ÍÂ¼
            rList = productCode.setSpecialUser(hash);

            sTmp = sysTime + operName + " add Special User";
            title = "Add Special User: " + usernumber;


            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","120");
            map.put("RESULT","1");
            map.put("PARA1",usernumber);
            map.put("PARA2","2");
            map.put("PARA3"," ");
            map.put("PARA4","IP:"+request.getRemoteAddr());
            map.put("DESCRIPTION","Add");
            purview = new zxyw50.Purview();
            purview.writeLog(map);


            sysInfo.add(sTmp);
            String msg = JspUtil.generateResultList(rList);
            if(!msg.equals("")){
                msg = msg.replace('\n',' ');
                throw new Exception(msg);
            }
            %>
            <script language="JavaScript">
                window.returnValue = "yes";
                window.close();
            </script>
        <%
          }


%>
<script language="JavaScript">
function addInfo () {
	var fm = document.inputForm;
    if (! checkInfo())
    	return;
    fm.op.value = 'add';
    fm.submit();
}

function checkInfo () {
	var fm = document.inputForm;

	var value = trim(fm.usernumber.value);
    if (value=='') {
    	alert('Please enter usernumber!');
        fm.usernumber.focus();
        return false;
    }

  	if(!checkstring('0123456789',value))
  	{
  		alert("Usernumber must be a digital number!");
  		fm.usernumber.focus();
  		return;
	}

    value = trim(fm.para1.value);
    if (value=='') {
    	alert('Please enter parameter1!');
        return false;
    }
  	if(!checkstring('0123456789',value))
  	{
  		alert("Parameter1 must be a digital number!");
  		fm.para1.focus();
  		return;
	}


    return true;
}

function ok(){
  addInfo();
}


function cancel(){
  window.returnValue = "no";
  window.close();
}



</script>

<form name="inputForm" method="post" action="specialUserAdd.jsp">
<input type="hidden" name="op" value="">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>
      <br><br>
      <table  width="100%"  border="0">
      <tr>
          <td width="100%" align="center" valign="middle">
              <div id="hintContent" >
      <table border="0" align="center" class="table-style2">
         <tr>
          <td height="22" align="left" valign="middle" width="30%" ><%=user_number%></td>
          <td height="22" valign="middle" width="70%" ><input type="text" name="usernumber" value="" maxlength="20" class="input-style1" ></td>
        </tr>

        <tr style="display:none">
          <td height="22" align="left" valign="middle">bflag</td>
          <td height="22" align="left" valign="middle"><input type="text" name="bflag" value="2" maxlength="20" class="input-style1" >
          </td>
        </tr>

         <tr>
          <td height="22" align="left" valign="middle" width="30%" >parameter1</td>
          <td height="22" valign="middle" width="70%" ><input type="text" name="para1" value="" maxlength="8" class="input-style1" ></td>
        </tr>

        <tr>
          <td height="22" align="left" valign="middle" width="30%" >parameter2</td>
          <td height="22" valign="middle" width="70%" ><input type="text" name="para2" value="" maxlength="20" class="input-style1" ></td>
        </tr>

      </table>
              </div>
          </td>
      </tr>

      <tr>
          <td width="100%" align="center" height="16" >

              <img src="button/sure.gif" alt="Confirm" onmouseover="this.style.cursor='hand'" onclick="javascript:ok()" >

                &nbsp;&nbsp;
              <img src="button/cancel.gif" alt="Cancel" onmouseover="this.style.cursor='hand'" onclick="javascript:cancel()" >
        </td>
          </tr>



	<tr >
   	<td>
      	<table border="0" width="90%" class="table-style2" align="center">
              <tr>
               <td>Notes:</td>
              </tr>

              <tr>
               <td >&nbsp;1. The <%=user_number%> and parameter1 are required.</td>
              </tr>
              </tr>
              <tr>
               <td >&nbsp;2. The parameter1 is open/cancel mode,.</td>
              </tr>
              <tr>
               <td >&nbsp;3. The parameter2 is no use.</td>
              </tr>
        </table>
   	</td>
	</tr>
</table>
</form>

<%



    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in adding special user");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in adding special user!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("Exception occurred in adding special user, <%= e.getMessage() %>");
   window.close();
</script>
<%
    }
%>
</body>
</html>

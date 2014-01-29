<%@page import="java.io.*"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Hashtable"%>
<%@include file="../pubfun/JavaFun.jsp"%>
<%@page import="zxyw50.JspUtil"%>
<%@page import="zxyw50.SocketPortocol"%>
<%@page import="zxyw50.bulletin.*"%>
<%@page import="zxyw50.group.util.*"%>


<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="Javascript1.2" src="calendar.js"></script><html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>Notice information management</title>
</head>
<body  background="background.gif" topmargin="0" leftmargin="0" >
<%
   String sysTime = "";
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  List arraylist = null;
  try {
    zxyw50.Purview purview = new zxyw50.Purview();
    String errmsg = "";
    boolean flag = true;
    HashMap   map  = new HashMap();
    if (purviewList.get("15-5") == null) {
      errmsg = "You have no access to this function!";
      flag = false;
    }
    if (operID == null) {
      errmsg = "Please log in to the system first!";
      flag = false;
    }
    if (flag) {

       String usernumber =request.getParameter("usernumber") == null?"":  transferString((String)request.getParameter("usernumber")).trim();
       String opercode =request.getParameter("opercode") == null?"":  transferString((String)request.getParameter("opercode")).trim();
       String stype=request.getParameter("utype") == null?"":  transferString((String)request.getParameter("utype")).trim();
       String crbtid= request.getParameter("crbtid")==null?"-1": (String)request.getParameter("crbtid").trim();	
       String maxtime= request.getParameter("maxtime")==null?"10": transferString((String)request.getParameter("maxtime").trim());	
       String param1 = request.getParameter("para1") == null ? "" : transferString((String)request.getParameter("para1")).trim();
      
       String param2 = request.getParameter("para2") == null ? "" : transferString((String)request.getParameter("para2")).trim();
       String param3 = request.getParameter("para3") == null ? "" : transferString((String)request.getParameter("para3")).trim();
       String param4 = request.getParameter("para4") == null ? "" : transferString((String)request.getParameter("para4")).trim();
       String param5 = request.getParameter("para5") == null ? "" : transferString((String)request.getParameter("para5")).trim();
       String param6 = request.getParameter("para6") == null ? "" : transferString((String)request.getParameter("para6")).trim();
       String param7 = request.getParameter("para7") == null ? "" : transferString((String)request.getParameter("para7")).trim();
       String param8 = request.getParameter("para8") == null ? "" : transferString((String)request.getParameter("para8")).trim();
       String param9 = request.getParameter("para9") == null ? "" : transferString((String)request.getParameter("para9")).trim();
       String param10 = request.getParameter("para10") == null ? "" : transferString((String)request.getParameter("para10")).trim();
       String param11 = request.getParameter("para11") == null ? "" : transferString((String)request.getParameter("para11")).trim();
       String param12 = request.getParameter("para12") == null ? "" : transferString((String)request.getParameter("para12")).trim();
       String param13 = request.getParameter("para13") == null ? "" : transferString((String)request.getParameter("para13")).trim();
       String param14 = request.getParameter("para14") == null ? "" : transferString((String)request.getParameter("para14")).trim();
       String param15 = request.getParameter("para15") == null ? "" : transferString((String)request.getParameter("para15")).trim();
       String param16 = request.getParameter("para16") == null ? "" : transferString((String)request.getParameter("para16")).trim();
       String param17 = request.getParameter("para17") == null ? "" : transferString((String)request.getParameter("para17")).trim();
       String param18 = request.getParameter("para18") == null ? "" : transferString((String)request.getParameter("para18")).trim();
       String param19 = request.getParameter("para19") == null ? "" : transferString((String)request.getParameter("para19")).trim();
       String param20 = request.getParameter("para20") == null ? "" : transferString((String)request.getParameter("para20")).trim();


    
     if (request.getParameter("cmd")!=null && request.getParameter("cmd").equals("1")) {//ÐÂÔö
            manCRBT  mancrbt = new manCRBT();
            map.put("crbtid",crbtid);
            map.put("utype",stype);
            map.put("usernumber",usernumber);
            map.put("maxtime",maxtime);
            map.put("opercode",opercode);
            map.put("para1",param1);
            map.put("para2",param2);
            map.put("para3",param3);
            map.put("para4",param4);
            map.put("para5",param5);
            map.put("para6",param6);
            map.put("para7",param7);
            map.put("para8",param8);
            map.put("para9",param9);
            map.put("para10",param10);
            map.put("para11",param11);
            map.put("para12",param12);
            map.put("para13",param13);
            map.put("para14",param14);
            map.put("para15",param15);
            map.put("para16",param16);
            map.put("para17",param17);
            map.put("para18",param18);
            map.put("para19",param19);
            map.put("para20",param20);
            mancrbt.insertsyncdata(map);


            map.clear();
            sysInfo.add(sysTime + operName + "Data is synchronized successfully in the new CRBT center!");
               map.put("OPERID",operID);
               map.put("OPERNAME",operName);
               map.put("OPERTYPE","703");
               map.put("RESULT","1");
             map.put("PARA1",usernumber);
             map.put("PARA2",opercode);
             map.put("PARA3","0");
             map.put("PARA4","0");
             map.put("PARA5",crbtid+"");
             map.put("PARA6","ip:"+request.getRemoteAddr());
             map.put("DESCRIPTION","Data is synchronized successfully in the new CRBT center");
             purview.writeLog(map);
            %>
            <script  language="javascript">
            	alert("Succeeded in adding new synchronization data!");
            </script>
          <%
          }
%>
<script language="javascript">


function acttype(){
      var fm = document.inputForm;
      if(fm.dsputype.value=="1"){
        fm.crbtid.disabled=true;
      }else{
        fm.crbtid.disabled=false;
        
      }	
      fm.utype.value=fm.dsputype.value; 

}
   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
     
      
      if (trim(fm.utype.value) == '1') {
         if(trim(fm.usernumber.value)==""){
         alert('Please input subscriber number!');
         fm.usernumber.focus();
         return flag;
         }
      }
      if(trim(fm.opercode.value)==""){
      	alert("Please input operation code!");
      	fm.opercode.focus();
      	return flag;
      }
      if (!checkstring('0123456789',trim(fm.opercode.value))) {
         alert('The operation code should be in the digit format only!');
         fm.opercode.focus();
         return flag;
      }
      
      flag = true;
      return flag;
   }

   function act () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.cmd.value = '1';
      fm.submit();
   }
</script><script language="JavaScript">
	var hei=900;
	parent.document.all.main.style.height=hei;
</script>
<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0" class="table-style2">
  <tr>
    <td height="40" align="center" class="text-title">Data synchronization in CRBT center</td>
  </tr>
<tr>
  <td width="100%">
    <table border="0" cellPadding="0" cellSpacing="0" width="100%" class="table-style1">
      <tr>
        <td>
            <table border="0" cellPadding="0" cellSpacing="0" width="526">
            <tr>
              <td align="middle">
                <a name="leaveword">
                    <br>
                <form method="post" name="inputForm" action="synccrbt.jsp">
                <input type="hidden" name="cmd" value="">
                  <table align="center" border="0" cellPadding="0" cellSpacing="0" class="table-style2">
                      <tr>
                            <td  colspan="2" valign="top">Data type:
                         <select name="dsputype" size="1"  onChange="acttype()">
                            <option value="0">System data</option>
                            <option value="1">Subscriber data</option>
                         </select>
                         <input type="hidden" name="utype" value="<%=stype%>">
                         <td>Operation code:</td><td><input type="text" name="opercode"  maxlength="10" size="10">
                        </td>
                        </tr><tr>
                        <td>
                            Number:</td><td>
                           <input type="text" name="usernumber" size="20" value="<%=usernumber %>">
                        </td><td>
                         CRBT center</td><td><select name="crbtid" size="1">
         <option value="0">All CRBT center<</value>
         <%for(int i=1;i<21;i++){%>
          	<option value="<%=i%>"><%=i%></option>
          <%}%>
                         </select>
                        </td>
                        </tr>
                        <tr>
                          <td >
                          Valid duration:</td><td colspan="3">
                          <input type="text" name="maxtime" value="<%=maxtime %>" maxlength="19" >(minute)
                         </td>
                          
                        </tr>
                        <tr><td > 
                         Parameter 1:</td><td><input type="text" name="para1" value="<%=param1 %>">
                          </td><td > 
                         Parameter 2:</td><td><input type="text" name="para2" value="<%=param2 %>">
                         </td></tr>
			<tr><td > 
                         Parameter 3:</td><td><input type="text" name="para3" value="<%=param3 %>">
                          </td><td > 
                         Parameter 4:</td><td><input type="text" name="para4" value="<%=param4 %>">
                         </td></tr><tr><td > 
                         Parameter 5:</td><td><input type="text" name="para5" value="<%=param5 %>">
                          </td><td > 
                        Parameter 6:</td><td><input type="text" name="para6" value="<%=param6 %>">
                         </td></tr><tr><td > 
                         Parameter 7:</td><td><input type="text" name="para7" value="<%=param7 %>">
                          </td><td > 
                         Parameter 8:</td><td><input type="text" name="para8" value="<%=param8 %>">
                         </td></tr><tr><td > 
                         Parameter 9:</td><td><input type="text" name="para9" value="<%=param9 %>">
                          </td><td > 
                         Parameter 10:</td><td><input type="text" name="para10" value="<%=param10 %>">
                         </td></tr><tr><td > 
                         Parameter 11:</td><td><input type="text" name="para11" value="<%=param11 %>">
                          </td><td > 
                         Parameter 12:</td><td><input type="text" name="para12" value="<%=param12 %>">
                         </td></tr><tr><td > 
                         Parameter 13:</td><td><input type="text" name="para13" value="<%=param13 %>">
                          </td><td > 
                         Parameter 14:</td><td><input type="text" name="para14" value="<%=param14 %>">
                         </td></tr><tr><td > 
                         Parameter 15:</td><td><input type="text" name="para15" value="<%=param15 %>">
                          </td><td > 
                         Parameter 16:</td><td><input type="text" name="para16" value="<%=param16 %>">
                         </td></tr><tr><td > 
                         Parameter 17:</td><td><input type="text" name="para17" value="<%=param17 %>">
                          </td><td > 
                         Parameter 18:</td><td><input type="text" name="para18" value="<%=param18 %>">
                         </td></tr><tr><td > 
                         Parameter 19:</td><td><input type="text" name="para19" value="<%=param19 %>">
                          </td><td > 
                         Parameter 20:</td><td><input type="text" name="para20" value="<%=param20 %>">
                         </td></tr>                        <tr>
                        <tr>
                        <td colspan="2">
                          <img alt="OK" src="../image/confirm.gif" onmouseover="this.style.cursor='hand'" onclick="act();" />
                          &nbsp;&nbsp;&nbsp;
                          <img alt="Cancel" src="../image/cancel.gif" onmouseover="this.style.cursor='hand'" onclick="doCancel();" />
                          <br>
                            </td>
                        </tr>
                  </table>
                </form>
                </a>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </td>
</tr>
</table><%} else {%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script><%
  }
  } catch (Exception e) {
    Vector vet = new Vector();
    sysInfo.add(sysTime + operName + "t is abnormal during CRBT center data synchronization!");
    sysInfo.add(sysTime + operName + e.toString());
    vet.add("Error occurs in CRBT center data synchronization!");
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="synccrbt.jsp">
</form>
<script language="javascript">
    document.errorForm.submit();
</script><%}%>
</body>
</html>

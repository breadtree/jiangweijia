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
<title>Ring on Demand Config</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");

	int ifuseutf8        = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0);

	String supportdemand = zte.zxyw50.util.CrbtUtil.getConfig("supportdemand","0");
	String SupportADringtone = zte.zxyw50.util.CrbtUtil.getConfig("supportadringtone","0");

    String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	zxyw50.Purview purview = new zxyw50.Purview();
	Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ArrayList rList  = new ArrayList();
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
       if(operID != null && purviewList.get("1-55") !=null  &&  sysfunction.get("1-55-0")== null){ //OBD Feature
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String service = request.getParameter("service") == null ? "0" : transferString((String)request.getParameter("service")).trim();
            String callingNumber = request.getParameter("callingNumber") == null ? "0" : transferString((String)request.getParameter("callingNumber")).trim();
            String count = request.getParameter("count") == null ? "" : transferString((String)request.getParameter("count")).trim();
            String validDays = request.getParameter("validDays") == null ? "" : transferString((String)request.getParameter("validDays")).trim();
            String delaygap = request.getParameter("delaygap") == null ? "0" : transferString((String)request.getParameter("delaygap")).trim();
           String condition = "";

            int  optype =0;
            String title = "";
            String desc = "";
            if (op.equals("edit")) {
                optype = 3;
                desc  = operName + "Modify Ring On Demand Config";
                title = "Modify Ring On Demand Config";
            }

            if(optype>0) {
                hash.put("service",service+"");
                hash.put("callingNumber",callingNumber);
                hash.put("count",count);
                hash.put("validDays",validDays);
                hash.put("delaygap",delaygap);
                
                rList = syspara.setRingOnDemandConfig(hash);
                sysInfo.add(sysTime + desc);

                if(getResultFlag(rList)) {
                   HashMap map = new HashMap();
                   map.put("OPERID",operID);
                   map.put("OPERNAME",operName);
                   map.put("OPERTYPE","301");
                   map.put("RESULT","1");
                   map.put("PARA1",service);
                   map.put("PARA2",callingNumber);
                   map.put("PARA4",count);
                   map.put("PARA5",validDays);
                   map.put("PARA7",delaygap);
                   map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                   purview.writeLog(map);
                }
                if(rList.size()>0){
                session.setAttribute("rList",rList);
					%>
					<form name="resultForm" method="post" action="result.jsp">
					<input type="hidden" name="historyURL" value="RingDemandConfig.jsp">
					<input type="hidden" name="title" value="<%= title %>">
					<script language="javascript">
					   document.resultForm.submit();
					</script>
					</form>
					<%
               }
             }
             vet=syspara.getRingOnDemandConfig(condition);
			 if(vet.size()>0) {
				 Hashtable oRetHash =  new Hashtable();

				 oRetHash = (Hashtable)vet.get(0);
                 if("0".equals(supportdemand) && "1".equals(SupportADringtone)) {
					 oRetHash = (Hashtable)vet.get(1);
				 }
                 service = (String)oRetHash.get("opertype");
				 callingNumber = (String)oRetHash.get("callingnumber");
				 count = (String)oRetHash.get("ringoutcnt");
				 validDays = (String)oRetHash.get("validdays");
				 delaygap = (String)oRetHash.get("minituesdelay");
				 
			 }
%>
<script language="javascript">
   var v_opertype=new Array(<%= vet.size() + "" %>);
   var v_callingnumber = new Array(<%= vet.size() + "" %>);
   var v_ringoutcnt = new Array(<%= vet.size() + "" %>);
   var v_validdays = new Array(<%= vet.size() + "" %>);
   var v_firstdelay = new Array(<%= vet.size() + "" %>);
   var v_minituesdelay = new Array(<%= vet.size() + "" %>);
   var v_constpara = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_opertype[<%= i + "" %>] = '<%= (String)hash.get("opertype") %>';
   v_callingnumber[<%= i + "" %>] = '<%= (String)hash.get("callingnumber") %>';
   v_ringoutcnt[<%= i + "" %>] = '<%= (String)hash.get("ringoutcnt") %>';
   v_validdays[<%= i + "" %>] = '<%= (String)hash.get("validdays") %>';
   v_firstdelay[<%= i + "" %>] = '<%= (String)hash.get("firstdelay") %>';
   v_minituesdelay[<%= i + "" %>] = '<%= (String)hash.get("minituesdelay") %>';
   v_constpara[<%= i + "" %>] = '<%= (String)hash.get("constpara") %>';

<%
            }
%>

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if(trim(fm.callingNumber.value)=='') {
          alert('Please enter calling number');
		  fm.callingNumber.focus();
		  return flag;
	  }else if(trim(fm.count.value)=='') {
          alert('Please enter Ring out Counts');
		  fm.count.focus();
		  return flag;
	  }else if(trim(fm.validDays.value)=='') {
          alert('Please enter Valid days');
		  fm.validDays.focus();
		  return flag;
	  }else if(trim(fm.delaygap.value)=='') {
          alert('Please enter Delay Between Calls');
		  fm.delaygap.focus();
		  return flag;
	 }
	  
	  if(!checkstring('0123456789',trim(fm.callingNumber.value))) {
         alert('Calling number can contain only digits!');
         fm.callingNumber.focus();
         return flag; 
	  }else if(!checkstring('0123456789',trim(fm.count.value))) {
          alert('Ring out Counts can contain only digits!');
		  fm.count.focus();
		  return flag;
	  }else if(!checkstring('0123456789',trim(fm.validDays.value))) {
          alert('Valid days can contain only digits!');
		  fm.validDays.focus();
		  return flag;
	 }else if(!checkstring('0123456789',trim(fm.delaygap.value))) {
          alert('Delay Between Calls can contain only digits!');
		  fm.delaygap.focus();
		  return flag;
	  }

      flag = true;
      return flag;
   }

   function editInfo () {
      var fm = document.inputForm;
      fm.op.value = 'edit';

	  if (! checkInfo())
         return;
      fm.submit();
   }

   function resetPage () {
     var fm = document.inputForm;
     var found = 0;
     for (var i = 0; i < v_opertype.length && found==0; i++) {
           if(fm.service.value == v_opertype[i]) {
		fm.callingNumber.value = v_callingnumber[i];
        fm.count.value = v_ringoutcnt[i];
		fm.validDays.value = v_validdays[i];
		fm.delaygap.value = v_minituesdelay[i];
		found = 1; 
            }else{
                fm.callingNumber.value = '';
	        fm.count.value = '';
                fm.validDays.value = '';
	        fm.delaygap.value = '';
	        }
     }

   }

   function change(){
       var fm = document.inputForm;
	   var found = 0;
       for (var i = 0; i < v_opertype.length && found==0; i++) {
			if(fm.service.value == v_opertype[i]) {
				fm.callingNumber.value = v_callingnumber[i];
                fm.count.value = v_ringoutcnt[i];
				fm.validDays.value = v_validdays[i];
				fm.delaygap.value = v_minituesdelay[i];
				
				found = 1; 
            }else{
				fm.callingNumber.value = '';
               fm.count.value = '';
				fm.validDays.value = '';
				fm.delaygap.value = '';

			}
	   }
	   return;
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="RingDemandConfig.jsp">
<input type="hidden" name="op" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="middle">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Ring on Demand Config</td>
        </tr>
        <tr>
		<td align="right">&nbsp;Service</td>
		<td>
			<select size="1" name="service" class="select-style1" onChange="javascript:change()">
			
				<option value=2>IVR Advertisement</option>
			
			</select>
		</td>
        </tr>
		<tr>
          <td align="right">&nbsp;Calling Number</td>
          <td><input type="text" name="callingNumber" value="<%= callingNumber %>" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">&nbsp;Ring Out Counts</td>
          <td><input type="text" name="count" value="<%= count %>" maxlength="3" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Valid Days</td>
          <td><input type="text" name="validDays" value="<%= validDays %>" maxlength="3" class="input-style1" ></td>
        </tr>
        <tr>
          <td align="right">Delay Between Calls</td>
          <td><input type="text" name="delaygap" value="<%= delaygap %>" maxlength="3" class="input-style1" ></td>
        </tr>
        <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="25%" align="right"><img src="button/edit.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:editInfo()"></td>
                <td width="25%" align="left"><img src="button/again.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:resetPage()"></td>
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
				      alert( "Please log in to the system first!");
					  document.URL = 'enter.jsp';
				  </script>
				  <%
            } else {
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing Ring On Demand!");//IP管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing Ring On Demand!");//IP管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
		%>
		<form name="errorForm" method="post" action="error.jsp">
		<input type="hidden" name="historyURL" value="RingDemandConfig.jsp">
		</form>
		<script language="javascript">
		   document.errorForm.submit();
		</script>
		<%
    }
%>
</body>
</html>

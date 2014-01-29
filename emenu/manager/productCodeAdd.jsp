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
<title>Product Code</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<base target="_self">
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%
	//String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


    String sysTime = "";
 	 manProductCode  productCode = new manProductCode();

    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");;
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");


    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String op   = request.getParameter("op") == null ? "" : request.getParameter("op");
    String disabled = "";
    String readonly = "";

    String prodcode = request.getParameter("prodcode") == null ? "" : request.getParameter("prodcode");
    String opertype = request.getParameter("opertype") == null ? "" : request.getParameter("opertype");
    String spcode   = request.getParameter("spcode") == null ? "000" : request.getParameter("spcode");
    String description   = request.getParameter("description") == null ? "" : request.getParameter("description");

    if("query".equals(mode))
    	disabled=" disabled ";
    if("edit".equals(mode))
    	readonly=" readonly ";



   if ("query".equals(mode) || "edit".equals(mode)){
		prodcode = request.getParameter("productcode") == null ? "" : request.getParameter("productcode");
		Hashtable ht= productCode.getProductCodeInfo(prodcode);
		opertype    = (String)ht.get("opertype");
		spcode      = (String)ht.get("spcode");
		description = (String)ht.get("description");
		
		if(description!=null)
			description=description.replaceAll("\\\\","\\\\\\\\").replaceAll("'","\\\\'");
	}

    try {
                String  errmsg = "";
    	 	boolean flag=true;
	    	if (operID  == null){
         	errmsg = "Please log in to the system first!";//Please log in to the system
           	flag = false;
        	}
        	else if (purviewList.get("3-29") == null) {
          	errmsg = "You have no right to access function!";//You have no access to this function
          	flag = false;
        	}
    	  	if(!flag)
    	  		throw new Exception(errmsg);


        	sysTime = productCode.getSysTime() + "--";
        	HashMap map = new HashMap();

        	Hashtable hash = new Hashtable();
        	ArrayList rList  = new ArrayList();

                hash.put("prodcode",prodcode);
        	hash.put("opertype",opertype);
               hash.put("spcode",spcode);
               hash.put("description",description);

        if(op.equals("add")){
            int optype = 0;
            String  sTmp = "";
            String  title = "";
            map = new HashMap();
            hash.put("opcode","1"); //添加新纪录
            rList = productCode.setProductCode(hash);

            sTmp = sysTime + operName + " add Product Code";
            title = "Add Product Code: " + prodcode;

            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","329");
            map.put("RESULT","1");
            map.put("PARA1",prodcode);
            map.put("PARA2",opertype);
            map.put("PARA3",spcode);
            map.put("PARA4",description);
            map.put("DESCRIPTION","Add,ip:"+request.getRemoteAddr());
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
          if (op.equals("edit")){
            hash.put("opcode","2"); //修改纪录
            rList = productCode.setProductCode(hash);

            //写操作员日志

            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","329");
            map.put("RESULT","1");
            map.put("PARA1",prodcode);
            map.put("PARA2",opertype);
            map.put("PARA3",spcode);
            map.put("PARA4",description);

            map.put("DESCRIPTION","Edit,ip:"+request.getRemoteAddr());
            purview = new zxyw50.Purview();
            purview.writeLog(map);

            sysInfo.add("Edit Product Code:"+prodcode+" information success");
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

		var value = trim(fm.prodcode.value);
      if (value=='') {
         alert('Please enter Product Code!');
         fm.prodcode.focus();
         return false;
      }
      if (!CheckInputStr(fm.prodcode,'Product Code')){
         fm.prodcode.focus();
         return  false;
      }

      value = trim(fm.description.value);
      if (value=='') {
         alert('Please enter description!');
         return false;
      }


      return true;
}

function ok(){
  addInfo();
}

function edit(){
  var fm = document.inputForm;
  if (! checkInfo()){
    return;
  }
  fm.op.value = 'edit';
  fm.submit();
}
function cancel(){
  window.returnValue = "no";
  window.close();
}



</script>

<form name="inputForm" method="post" action="productCodeAdd.jsp">
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
          <td height="22" align="left" valign="middle" width="30%" >Product Code</td>
          <td height="22" valign="middle" width="70%" ><input type="text" name="prodcode" value="" maxlength="20" class="input-style1" <%=(disabled+readonly)%>></td>
        </tr>

        <tr>
          <td height="22" align="left" valign="middle">Oper Type</td>
          <td height="22" align="left" valign="middle">
            <%if(mode.equals("edit")){%>
              <input type="hidden" name="opertype" value="" readonly>
            <%
            	if("1".equals(opertype))
            		out.print("CMT Monthly Subscription Fee");
            	else if("2".equals(opertype))
            		out.print("Corporate CMT Monthly Subscription");
            	else if("3".equals(opertype))
            		out.print("Monthly Content Fee");
            	else if("4".equals(opertype))
            		out.print("Juke Box");
            	else if("5".equals(opertype))
            		out.print("Music Station");            		            		            		
            }else{%>
          	<select name="opertype" size="1" class="input-style1" style="width:230" <%=disabled%>>
          		<option value="1">CMT Monthly Subscription Fee</option>
          		<option value="2">Corporate CMT Monthly Subscription</option>
          		<option value="3" >Monthly Content Fee</option>
          		<option value="4">Juke Box</option>
          		<option value="5">Music Station</option>
          	</select>
            <%}%>
          </td>
        </tr>

        <tr>
            <td align="left"  height="22" >spcode</td>
           <td>
<select name="spcode" size="1" class="input-style1" <%=disabled%>>
<%
		manSysPara syspara = new manSysPara();
		String systemspcode = syspara.getSpCode("0");
%>
		<option value="<%=systemspcode%>"><%=systemspcode +"---System" %></option>
<%		
		ArrayList  vet = syspara.getSPInfo();
      for (int i = 0; i < vet.size(); i++) {
          map = (HashMap)vet.get(i);
%>
    <option value="<%=(String)map.get("spcode") %>"><%= (String)map.get("spcode") + "---" + (String)map.get("spname") %></option>
<%
            }
%>
            </select>
           </td>
        </tr>
        <tr>
           <td align="left"  height="22" >Description</td>
         
      
		<%if(!"query".equals(mode)){ %>
<td><input type="text" name="description" value="" maxlength="20" class="input-style1" style="width:230"></td>
	  </table>
              </div>
          </td>
      </tr>
      <tr>
          <td width="100%" align="center" height="16" >
            <%if("edit".equals(mode)){%>
              <img src="button/edit.gif" alt="Edit" onmouseover="this.style.cursor='hand'" onclick="javascript:edit()" >
            <%}else{ %>
              <img src="button/sure.gif" alt="Confirm" onmouseover="this.style.cursor='hand'" onclick="javascript:ok()" >
            <%} %>
                &nbsp;&nbsp;
              <img src="button/cancel.gif" alt="Cancel" onmouseover="this.style.cursor='hand'" onclick="javascript:cancel()" >
        </td>
          </tr>

<%}else{ %>
   <td><input type="text" name="description" value="" maxlength="20" class="input-style1" style="width:230" <%=disabled%>></td>
   </table>
              </div>
          </td>
      </tr>
  <tr>
    <td width="100%" align="center" height="16" >
      <img src="button/back.gif" alt="Back" onmouseover="this.style.cursor='hand'" onclick="javascript:window.close();" >
    </td>
  </tr>
<%} %>


</table>
</form>
<%if ("query".equals(mode) || "edit".equals(mode)){
%>
<script language="JavaScript">
	var fm = document.inputForm;
	fm.prodcode.value = '<%=prodcode%>';
	fm.opertype.value = '<%=opertype%>';
	fm.spcode.value = '<%=spcode%>';
	fm.description.value = '<%=description%>';

</script>
<%}
  if("".equals(mode))
  {
%>

<%
  }


    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in visit product code");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in visit product code!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("Exception occurred,prodcode='<%= prodcode%>',<%= e.getMessage() %>");
   window.close();
</script>
<%
    }
%>
</body>
</html>

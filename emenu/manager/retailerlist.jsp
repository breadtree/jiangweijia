<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Retaillist management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js" type=""></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    // add for starhub
	String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
	try {
        ArrayList rList  = new ArrayList();
        List retaillist = new ArrayList();
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        //配置权限？？？？？
        if (operID != null && purviewList.get("1-51") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
			Map hashRetailer = null;
			int	isMobitel = zte.zxyw50.util.CrbtUtil.getConfig("isMobitel",0);
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String retailnum = request.getParameter("retailnum") == null ? "" : transferString((String)request.getParameter("retailnum")).trim();
			String ringfee = request.getParameter("ringfee") == null ? "0" : transferString((String)request.getParameter("ringfee")).trim();
            String filename = request.getParameter("filename") == null ? "" :transferString((String)request.getParameter("filename")).trim();
            int  optype =0;
            String title = "";
            String desc = "";
            String retailfromdb = null;
            if (op.equals("add")) {

                optype = 1;
                desc  = operName + " Add Retailer ";
                title = "Add Retailer";//增加黑名单
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + "Delete Retailer";//删除黑名单
                title = "Delete Retailer";//删除黑名单
             }
			 else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + "Edit Retailer";//删除黑名单
                title = "Edit Retailer";//删除黑名单
             }
             else if(op.equals("batchadd")){
                 optype = 4;
                 desc = operName + " add retailer in batch";//批量增加黑名单
                 title = "Add Retailer in batch";//批量增加黑名单
             }
             if(optype>0){
                 //单个操作
                 if(optype==1 || optype ==2 || optype ==3){
                     hash.put("optype",optype+"");
                     hash.put("retailnum",retailnum);
					 hash.put("ringfee",ringfee);
					 hash.put("openmode","18");
					 hash.put("opensource",operName);
                     retaillist.add(hash);
                 }else{//批量操作,读文件
                     retaillist = syspara.getRetailList(filename,operName);
                 }

                rList = syspara.setRetailer(retaillist);
                sysInfo.add(sysTime + desc);
                Hashtable rHash = null;
              /*  for(int i= 0;i<rList.size();i++){
                    rHash = (Hashtable)rList.get(i);
                    if(rHash !=null && (rHash.get("result")).toString().equals("0")){
                        zxyw50.Purview purview = new zxyw50.Purview();
                   HashMap map = new HashMap();
                   map.put("OPERID",operID);
                   map.put("OPERNAME",operName);
                   map.put("OPERTYPE","109");
                   map.put("RESULT","1");
                   map.put("PARA1",retailnum);
                   map.put("PARA2","ip:"+request.getRemoteAddr());
                   map.put("DESCRIPTION",title);
                   purview.writeLog(map);
                    }
                }*/

                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="retailerresult.jsp?optype=<%=optype%>">
<input type="hidden" name="historyURL" value="retailerlist.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }
           vet = syspara.getRetailInfo();
%>
<script language="javascript">
   var v_retailnum = new Array(<%= vet.size() + "" %>);
   var v_ringfee = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
	              hashRetailer = (Map)vet.get(i);
                 retailfromdb = (String) hashRetailer.get("usernumber");
				 ringfee = (String) hashRetailer.get("ringfee");
%>
   v_retailnum[<%= i + "" %>] = '<%= retailfromdb %>';
   v_ringfee[<%= i + "" %>] = '<%= ringfee %>';
 


<%
            }
%>

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.retaillist.selectedIndex;
      if (index <0 || index >=v_retailnum.length)
         return;
      fm.retailnum.value = v_retailnum[index];
      <%if(isMobitel == 0){%>
	  fm.ringfee.value = v_ringfee[index];
	 fm.ringfee.focus();
      <%}%>
   }


   function checkInfo () {
      var fm = document.inputForm;
      var value = trim(fm.retailnum.value);
      if(!isUserNumber(value,'<%=user_number%>')){
            fm.retailnum.focus();
            return false;
      }
      return true;
   }

   function addInfo () {
      var fm = document.inputForm;
      fm.op.value = 'add';
      if (! checkInfo())
         return;
      <%if(isMobitel == 0){%> 
	 if(fm.ringfee.value =='')
	 {
	   alert("Please input the Retailer Discount Fee");
	   return;
	 }
	 if (!checkstring('0123456789',fm.ringfee.value))
		{
			alert('The Retailer Discount Fee must be a digital number!');
			fm.catakey.focus();
         return;
	   }
	   <%}%>
	 fm.submit();
   }

   
   function editInfo () {
      var fm = document.inputForm;
      var index = fm.retaillist.selectedIndex;
	  	  if(fm.retaillist.length==0)
		{
         alert("Sorry. You must Configure the Retail List first!");
         return;
      }
      if(index == -1){
          alert("You must select the Retail List first");
          return;
      }
	  if(fm.ringfee.value =='')
	  {
	   alert("Please input the Retailer Discount Fee");
	   return;
	  }
	 if (!checkstring('0123456789',fm.ringfee.value))
		{
			alert('The Retailer Discount Fee must be a digital number!');
			fm.catakey.focus();
			return;
	   }
	   if( fm.retailnum.value == v_retailnum[index] && fm.ringfee.value == v_ringfee[index])
	   {
          alert("Please change the Retailer Discount Fee to Perform the Modify Operation");
          return;
      }
	  if(fm.retailnum.value != v_retailnum[index])
	   {
          alert("Please change only the Retailer Discount Fee");
		  fm.retailnum.value = v_retailnum[index];
          return;
	   }
	
	  fm.op.value = 'edit';
	  fm.submit();
    
   }

   function delInfo () {
      var fm = document.inputForm;
     var index = fm.retaillist.selectedIndex;
	   if(fm.retaillist.length==0){
         alert("Sorry. You must Configure the Retail List first!");
         return;
      }
      if(index == -1){
          alert("You must select the Retail List first");
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }

   function selectFile() {
      var fm = document.inputForm;
      var uploadURL = 'retailupload.jsp';
      uploadRing = window.open(uploadURL,'RetailbatchUpload','width=400, height=200');
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.filename.value = name;
      fm.tfile.value = label;
   }

   function batchadd() {
       var fm = document.inputForm;
        if (fm.tfile.value.length == '')
		{
         alert('Please select a .txt file first');
         return;
        }
       fm.op.value = 'batchadd';
       fm.submit();
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="retailerlist.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="filename" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Open Retail list management</td>
        </tr>
        <tr>
          <td rowspan="6" align="center">
            <select name="retaillist" size="10" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                       hashRetailer = (Map)vet.get(i);
                       retailfromdb =(String) hashRetailer.get("usernumber");
			      	   ringfee = (String) hashRetailer.get("ringfee");
			      	   if(isMobitel == 0){

			      	  %>
              <option value="<%= retailfromdb  %>"><%= retailfromdb %>--<%= ringfee %></option>
<%
            }else{
%>
              <option value="<%= retailfromdb  %>"><%= retailfromdb %></option>
             <%}} %>
            </select>
          </td>
          <td align="right">&nbsp;<%=user_number%></td>
          <td><input type="text" name="retailnum" value="" maxlength="30" class="input-style1"></td>
		  </tr>
		  <%if(isMobitel == 0){%>
		  <tr>
		  <td align="right">&nbsp;Retailer Discount Fee</td>
	      <td><input type="text" name="ringfee" value="" maxlength="5" class="input-style1"></td>
         </tr>
         <%}%>
		 <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td width="33%" align="center"><img src="button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <%if(isMobitel == 0){%>
				 <td width="33%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
				 <%}%>
                 <td width="33%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="33%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <br>
      <br>
      <br>
      <table align="center" class="table-style2" width="100%" border="0">
          <tr >
          <td height="26" colspan="4" align="center" class="text-title" background="image/n-9.gif">Add Retaillist users in batch</td>
        </tr>
        <tr>
            <td align="right">&nbsp;File name</td>
                <td><input type="text" name="tfile" value="" maxlength="30" class="input-style1"> </td>
                <td ><img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"> &nbsp;&nbsp;</td>
                <td ><img src="button/upload.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:batchadd()"></td>
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
                    alert( "Please log in to the system first!");//Please log in to the system!
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no access to this function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "It is abnormal during the retaillist management procedure!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the retaillist management procedure!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="retailerlist.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

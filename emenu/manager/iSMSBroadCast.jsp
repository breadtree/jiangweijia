<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.RingQuery" %>

<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
     public String display (Map map) throws Exception {
        try {
            String str = (String)map.get("rsubindex");
            for (; str.length() <= 11; )
                str += "-";
            return str + (String)map.get("ringid");
        }
        catch (Exception e) {
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data
        }
    }
%>
<html>
<head>
<title>Short Ringcode</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    Purview purview = new Purview();
    Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
    String operMode ="";
    try {
        ColorRing  colorring = new ColorRing();
        manSysRing sysring = new manSysRing();
		RingQuery ringQuery = new RingQuery();
        sysTime = sysring.getSysTime() + "--";
		  //if (operID != null) {
        if (operID != null && purviewList.get("2-72") != null && sysfunction.get("2-72-0")== null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            Hashtable htable = new Hashtable();
			ArrayList finalResult=new ArrayList();
			
            Hashtable hash = null;
            String op = request.getParameter("op") == null ? "0" : transferString((String)request.getParameter("op")).trim();
			operMode = request.getParameter("smsList") == null ? "0" : transferString((String)request.getParameter("smsList")).trim();
			String rank = request.getParameter("rsubindex") == null ? "0" : transferString((String)request.getParameter("rsubindex")).trim(); 
            String ringId = request.getParameter("ringid") == null ? "0" : transferString((String)request.getParameter("ringid")).trim();
            String fileName = request.getParameter("filename") == null ? "" : transferString((String)request.getParameter("filename")).trim();
			boolean fileUploadResult=true;
			int optype = 0;
     		List vet = null;
            String title = "";
			//System.out.println("op : "+op);
            if (op.equals("add")){
                optype = 1;
                title = "Add ringtone";//增加推荐铃音
            }
            else if (op.equals("del")) {
                optype = 2;
                title = "Delete ringtone";//删除推荐铃音
            }else if (op.equals("getInfo")) {
				 optype = 0;
				 operMode = request.getParameter("smsList") == null ? "0" : transferString((String)request.getParameter("smsList")).trim();
				 //vet = ringQuery.getISMSRingTones(Integer.parseInt(operMode));
			}else if (op.equals("addFile")) {
				optype = 1;
				
				htable.put("operType",optype+"");
				htable.put("operMode",operMode);
				htable.put("fileName",fileName);
				rList = ringQuery.setISMSNumbers(htable);
			
				for(int i=0;i<rList.size();i++){
					if(fileUploadResult){
						int res=Integer.parseInt((String)rList.get(i));
						//System.out.println("rList : "+rList.get(i));
						if(res!=0){
							fileUploadResult=false;
						}
					}
				}
				
			}else if (op.equals("delFile")) {
				optype = 2;
            	htable.put("operType",optype+"");
				htable.put("operMode",operMode);
				htable.put("fileName",fileName);
				rList = ringQuery.setISMSNumbers(htable);
			}
            if(optype>0 && !ringId.equals("")){
                htable.put("operType",optype+"");
		        htable.put("operMode",operMode);
			    htable.put("rank",rank);
			    htable.put("ringId",ringId); 
			    htable.put("ringType","1");
			    rList = ringQuery.setISMSRingTones(htable);
				
				
		    }
			if(operMode!=null){
				vet = ringQuery.getISMSRingTones(Integer.parseInt(operMode));
			}
			
           
 %>
<script language="javascript">
   var v_ringid = new Array(<%= vet.size() + "" %>);
   var v_rsubindex = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_rsubindex[<%= i + "" %>] = '<%= (String)hash.get("rsubindex") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
<%
            }
%>

 
	  //alert(document.getElementById('user').style.display='block');
	 
	  
 function selectListInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.ringid.value = v_ringid[index];
      fm.ringlabel.value = v_ringlabel[index];
      fm.rsubindex.value = v_rsubindex[index];
      fm.oldrsubindex.value =v_rsubindex[index];
      fm.oldringid.value = v_ringid[index];
   }
   
   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.smsList.value;
	  
	  <%if(!operMode.equals("") && operMode!=null && !operMode.equals("0")){%>
	  	index='<%=operMode%>';
	  <%}%>
	  
	  //alert(document.getElementById('user').style.display='block');
	  
	  
      if(index=='91' || index=='92' || index=='93'){
	  	document.getElementById('ring').style.display='block';
		//document.getElementById('ringId').style.display='block';
		document.getElementById('user').style.display='none';
		document.getElementById('but1').style.display='none';
		document.getElementById('but').style.display='block';
	  }
	  else if(index=='95'){
	  	document.getElementById('ring').style.display='block';
		document.getElementById('but1').style.display='block';
		document.getElementById('user').style.display='block';
		document.getElementById('but').style.display='block';
		
		
	  }
	 else if(index=='96'){
	  	document.getElementById('ring').style.display='none';
		document.getElementById('user').style.display='block';
		document.getElementById('but1').style.display='block';
		document.getElementById('but').style.display='none';
	  }
	  
	  
	  if(index=='-1'){
	  	  document.getElementById('ring').style.display='none';
		  document.getElementById('user').style.display='none';
	  	  document.getElementById('but').style.display='none';
  		  document.getElementById('but1').style.display='none';
	  }
	  fm.op.value = 'getInfo';
	  fm.submit();
	 
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      
      if(fm.smsList.value == -1){
        alert("Please select the iSMS Type.");
        fm.smsList.focus();
        return flag;
      }
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please enter the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code!");//请输入Ringtone code
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code must be a digital number!');//Ringtone code必须是数字
         fm.ringid.focus();
         return flag;
      }
      var value = trim(fm.rsubindex.value);
      if(value==''){
         alert("Please enter the serial number of a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>!");//请输入铃音序号
         fm.rsubindex.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> No. must be a digital number!');//铃音序号必须是数字
         fm.rsubindex.focus();
         return flag;
      }
      
      flag = true;
      return flag;
   }
   
    function checkFileInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.filename1.value);
	   var index = trim(fm.smsList.value); 
      if(value==''){
         alert("Please select a file!");//请输入File
         //fm.filename1.focus();
         return flag;
      }
	  var ringSize='<%=vet.size()%>';
	 // alert(ringSize);
	  if(ringSize==0 && index=='95'){
	  	 alert("Please upload ring tones before uploading file!");//请输入File
		 return flag;
	  }
	  
      flag = true;
      return flag;
   }

	function addInfo () {
		var fm = document.inputForm;
		 if(!checkInfo()){
			return ;
		 }else{
		 	 fm.op.value = 'add';
			 fm.submit();
		 }
		 
	}
	
	function addFileInfo () {
		var fm = document.inputForm;
		 if(!checkFileInfo()){
			return ;
		 }else{
		 	 fm.op.value = 'addFile';
			 fm.submit();
		 }
		 
	}		

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be deleted");//请选择您删除的推荐铃音
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }


	 function delFileInfo () {
		 var fm = document.inputForm;
			 if(!checkFileInfo()){
				return ;
			 }else{
				 fm.op.value = 'delFile';
				 fm.submit();
			 }
	 }
	
   function getAddInfo (ringid,subindex) {
     var fm = document.inputForm;
     fm.oldrsubindex.value = subindex;
     fm.oldringid.value = ringid;
     fm.op.value = 'add';
     fm.submit();
   }
   function getEditInfo (newringid,ringid,subindex) {
     var fm = document.inputForm;
     fm.oldrsubindex.value = subindex;
     fm.oldringid.value = ringid;
     fm.newringid.value = newringid;
     
     fm.op.value = 'edit';
     fm.submit();
   }
   
   function queryInfo() {
     var result =  window.showModalDialog('ringSearch.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       document.inputForm.ringid.value=result;
     }
   }
   
   function selectFile() {
      var fm = document.inputForm;
      var uploadURL = 'iSMSUpload.jsp';
      uploadRing = window.open(uploadURL,'iSMSFileUpload','width=400, height=220');
   }
   
   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.filename1.value = label;
      fm.filename.value = name;
   }
   
   function resetForm(){
    var smsListVal= fm.smsList.value;
    document.inputForm.reset();
    fm.smsList.value = smsListVal;
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="iSMSBroadCast.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldrsubindex" value="">
<input type="hidden" name="oldringid" value="">	
<input type="hidden" name="filename" value="<%=fileName%>">
<table width="440" height="100" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="4" align="center" class="text-title" background="image/n-9.gif">Manage iSMS Broadcast</td>
        </tr>
		<tr >
		  <td align="center">&nbsp;</td>
		  <td align="center" class="text-error">&nbsp;</td>
		  </tr>
		  <%if(op.equals("addFile")){%>
			<tr >
			  <td colspan="2" align="center" class="text-error">
				<%if(!fileUploadResult){%>Error occured while uploading.<%}else{%>Updated Successfully.<%}%>
			   </td>
			  </tr>
		 <%}%>
		<tr >
		  <td width="28%" align="center">iSMS Type </td>
        	<td width="73%">
              <select name="smsList" class="input-style1" style="width:80px" onChange="javascript:selectInfo()">
	   		    <option value="-1" selected>Select</option>
            	<option value="91">&nbsp;iSMS1</option>
				<option value="92">&nbsp;iSMS2</option>
				<option value="93">&nbsp;iSMS3</option>
				<option value="95">&nbsp;iSMS4</option>
				<option value="96">&nbsp;iSMS5</option>
            </select>        </td>
           </tr>
		   
		   <tr id="user" style="display:none">
			  <td align="center" width="28%" height="40">File</td>
			  <td width="73%"><input type="text" name="filename1" value="" disabled class="input-style1">&nbsp;<img src="button/file.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:selectFile()">			  </td>
		   </tr>
		   
		   <tr id="but1" style="display:none">
			 <td width="28%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:addFileInfo()"></td>
			<!--td width="25%" align="center"><img src="button/edit.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:editInfo()"></td-->
			 <td width="73%"><img src="button/del.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:delFileInfo()"></td>
		  </tr>
			</table>     </td>
     </tr>
	 
	  <tr valign="center">
  <td  id="ring" style="display:none">
         <table width="100%" border="0" align="center" class="table-style2">
        
        
        <tr>
          <td align="center">&nbsp;</td>
          <td height='100%'>&nbsp;</td>
        </tr>
        <td align="center">
             <select name="infoList" size="8" <%= vet.size() == 0 ? "disabled " : "" %>  class="input-style1" style="width:180px" onclick="javascript:selectListInfo()">
             <%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);
                    out.println("<option value="+Integer.toString(i)+" >" +display(hash)+" </option>");
              }
             %>
             </select>        </td>
        <td height='100%'>
            <table width="100%" border =0 class="table-style2" height='100%'>
            <tr>
             <td width="30%" align=right >Queue number</td>
             <td><input type="text" name="rsubindex" value="" maxlength="6" class="input-style1"></td>
            </tr>
            <tr>
             <td width="30%" align=right ><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
             <td><input type="text" name="ringlabel" value="" maxlength="6" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
             <td><input type="text" name="ringid" value="" maxlength="20" class="input-style1" readonly="true"><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:queryInfo()"></td>
            </tr>
            <tr>
            <td colspan="2" align="center">
              <table border="0" width="100%" class="table-style2"  align="center">
              <tr>
                 <!--td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:addInfo()"></td-->
                <!--td width="25%" align="center"><img src="button/edit.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:editInfo()"></td-->
                 <!--td width="25%" align="center"><img src="button/del.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:delInfo()"></td-->
                 <!--td width="25%" align="center"><img src="button/again.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:document.inputForm.reset()"></td-->
              </tr>
              </table>            </td>
            </tr>
            </table>     </td>
     </tr>
     </table>     </td>
     </tr>
	  <tr >
	    <td align="center">
			<table>
	<tr id="but" style="display:none">
		 <td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:addInfo()"></td>
		<!--td width="25%" align="center"><img src="button/edit.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:editInfo()"></td-->
		 <td width="25%" align="center"><img src="button/del.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:delInfo()"></td>
		 <td width="25%" align="center"><img src="button/again.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:resetForm();"></td>
	  </tr>
</table>

		
		</td>
	    <td align="center">&nbsp;</td>
    </tr>
     
     </table>
  </td>
  </tr>
</table>
</form>

<script>
<%if(!operMode.equals("") && operMode!=null && !operMode.equals("0") ){%>
	  	var index1='<%=operMode%>';
		var fm = document.inputForm;
        fm.smsList.value = index1;
      if(index1=='91' || index1=='92' || index1=='93'){
	  	document.getElementById('ring').style.display='block';
		//document.getElementById('ringId').style.display='block';
		document.getElementById('user').style.display='none';
		document.getElementById('but1').style.display='none';
		document.getElementById('but').style.display='block';
	  }
	  else if(index1=='95'){
	  	document.getElementById('ring').style.display='block';
		document.getElementById('but1').style.display='block';
		document.getElementById('user').style.display='block';
		document.getElementById('but').style.display='block';
		
		
	  }
	 else if(index1=='96'){
	  	document.getElementById('ring').style.display='none';
		document.getElementById('user').style.display='block';
		document.getElementById('but1').style.display='block';
		document.getElementById('but').style.display='none';
	  }
	  
	  
	  if(index1=='-1'){
	  	  document.getElementById('ring').style.display='none';
		  document.getElementById('user').style.display='none';
	  	  document.getElementById('but').style.display='none';
  		  document.getElementById('but1').style.display='none';
	  }
	 <%}%>
</script>


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
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in managing the short ringcode ringtones!");//最新推荐铃音管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing the short ringcode ringtones!");//最新推荐铃音管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="iSMSBroadCast.jsp?smsList=<%=operMode%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

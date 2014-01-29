<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Prefix management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1"  onload="JavaScript:initform(document.forms[0])" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
//法国电信彩像办版本新增 by yuanshenhong
    String usecalling =CrbtUtil.getConfig("usecalling","0");
	String isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");
	// String usecalling = CrbtUtil.getConfig("usecalling","0");
	
    try {
        manSysPara syspara = new manSysPara();
        
        //子业务表
   	Vector vetSubservice = syspara.getSubService();
   	String subservice    = request.getParameter("subservice") == null ? "" : transferString((String)request.getParameter("subservice")).trim();
 		
 		if("".equals(subservice))
   	{
   		Hashtable tmpHash;
   		//取第一个子业务:被叫彩铃
      	tmpHash = (Hashtable)vetSubservice.get(0);
      	subservice = (String)tmpHash.get("subservice");
   	}
   
        
        String  optSCP = "";
        sysTime = syspara.getSysTime() + "--";
        zxyw50.Purview purview = new zxyw50.Purview();
        if (operID != null && purviewList.get("3-15") != null) {
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            int    optype = 0;
            String serareano = request.getParameter("serareano") == null ? "0" : transferString((String)request.getParameter("serareano")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
            String serareaname = request.getParameter("serareaname") == null ? "" : transferString((String)request.getParameter("serareaname")).trim();
            String maxuser = request.getParameter("maxuser") == null ? "0" : transferString((String)request.getParameter("maxuser")).trim();
            String usertype = request.getParameter("usertype") == null ? "0" : transferString((String)request.getParameter("usertype")).trim();
            String usertype1 = request.getParameter("usertype1") == null ? "0" : transferString((String)request.getParameter("usertype1")).trim();
            // 暂时不支持group service，所以特令usertype2 = 0
			// String usertype2 = request.getParameter("usertype2") == null ? "0" : transferString((String)request.getParameter("usertype2")).trim();
            String usertype2 = "1";
			String usertype3 = request.getParameter("usertype3") == null ? "0" : transferString((String)request.getParameter("usertype3")).trim();

            String newserareano = "-1";


            // 准备写操作员日志

            HashMap map1 = new HashMap();
            HashMap map = new HashMap();
            String  title = "";

            if (op.equals("add")){
                optype = 1;
                serareano = "0";
                title = "Add service area";
            }
            else if (op.equals("edit")) {
                if(!purview.CheckOperatorFunction(session,3,15,serareano,"-1","-1","-1")){
            	  throw new Exception("You have no right to manage this service area");//您无权对该业务区进行操作!
          	}
                optype = 3;

                title = "Edit service area";
            }
            else if (op.equals("del")) {
                optype = 2;
                title = "Delete service area";

            }
            if(optype>0){
               map1.put("optype",optype+"");
               map1.put("scp",scp);
               map1.put("serareano",serareano);
               map1.put("newserareano",newserareano);
               map1.put("serareaname",serareaname);
               map1.put("maxuser",maxuser);
               map1.put("usertype",usertype);
               map1.put("usertype1",usertype1);
			   map1.put("usertype2",usertype2);
               map1.put("usertype3",usertype3);
               if(optype ==1)
                   syspara.addSerArea(map1);
               else if(optype==2)
                   syspara.delSerArea(map1);
               else if(optype==3)
                   syspara.editSerArea(map1);

               map.put("OPERID",operID);
               map.put("OPERNAME",operName);
               map.put("OPERTYPE","304");
               map.put("RESULT","1");
               map.put("PARA1",serareano);
               map.put("PARA2",scp);
               map.put("PARA3",serareaname);
               map.put("PARA4",maxuser);
               map.put("DESCRIPTION",title+" ip:"+request.getRemoteAddr());
               purview.writeLog(map);
            }
            Vector vet = syspara.getUserTypeInfo(subservice);
            String option="";
            for(int i=0;i<vet.size();i++){
              Hashtable table = (Hashtable)vet.elementAt(i);
              option +="<option value=" + (String)table.get("usertype") + " > " + (String)table.get("utlabel")+ " </option>";
            }
            ArrayList scplist = syspara.getScpList();
            for (int i = 0; i < scplist.size(); i++) {
               if(i==0 && scp.equals(""))
                  scp = (String)scplist.get(i);
               optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
            }
           ArrayList serviceList = new ArrayList();
           if(!scp.equals(""))
                serviceList = syspara.getServiceArea(scp);
%>
<script language="javascript">
   var v_serareano = new Array(<%= serviceList.size() + "" %>);
   var v_serareaname = new Array(<%= serviceList.size() + "" %>);
   var v_maxuser = new Array(<%= serviceList.size() + "" %>);
   var v_usertype = new Array(<%= serviceList.size() + "" %>);
   var v_usertype1 = new Array(<%= serviceList.size() + "" %>);
   var v_usertype2 = new Array(<%= serviceList.size() + "" %>);
   var v_usertype3 = new Array(<%= serviceList.size() + "" %>);
<%
   for (int i = 0; i < serviceList.size(); i++) {
         map = (HashMap)serviceList.get(i);
%>
   v_serareano[<%= i + "" %>] = '<%= (String)map.get("serareano") %>';
   v_serareaname[<%= i + "" %>] = '<%= (String)map.get("serareaname") %>';
   v_maxuser[<%= i + "" %>] = '<%= (String)map.get("maxuser") %>';
   v_usertype[<%= i + "" %>] = '<%= (String)map.get("usertype") %>';
   v_usertype1[<%= i + "" %>] = '<%= (String)map.get("usertype1") %>';
   v_usertype2[<%= i + "" %>] = '<%= (String)map.get("usertype2") %>';
   v_usertype3[<%= i + "" %>] = '<%= (String)map.get("usertype3") %>';
<%
            }
%>


   function initform(pform){
     var temp = "<%= scp %>";
      for(var i=0; i<pform.scplist.length; i++){
        if(pform.scplist.options[i].value == temp){
           pform.scplist.selectedIndex = i;
           break;
        }
     }

   }

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.serareano.value = v_serareano[index];
      fm.serareaname.value = v_serareaname[index];
      fm.maxuser.value = v_maxuser[index];
      fm.usertype.value= v_usertype[index];
      fm.usertype1.value= v_usertype1[index];
	  fm.usertype2.value= v_usertype2[index];
      fm.usertype3.value= v_usertype3[index];
      fm.serareaname.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.serareaname.value);
	  if (value == '') {
         alert('Please enter the service area name!');//请输入业务区名称
         fm.serareaname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.serareaname,'service area name')){
         fm.serareaname.focus();
         return flag;
      }
        <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.serareaname.value,20)){
            alert("The service area name should not exceed 20 bytes!");
            fm.serareaname.focus();
            return;
          }
        <%
        }else{
          %>
          if(strlength(value)>20){
            alert('The length of the service area name has exceeded the specified 20 characters!');//业务区名称超过规定的20个字节长度!
            fm.serareaname.focus();
            return flag;
          }
         <%}%>
      value = trim(fm.maxuser.value);
      if (trim(value) == '') {
         alert('Please enter the maximum number of subscribers allowed in this service area!');//请输入该业务区的最大用户数
         fm.maxuser.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The maximum number of subscribers must be a digital number!');//最大用户数必须是数字
         fm.maxuser.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function checkName () {
      var fm = document.inputForm;
      var code = trim(fm.serareaname.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_serareaname.length; i++)
           if (code == v_serareaname[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_serareaname.length; i++)
           if (code == v_serareaname[i] && i!=index)
             return true;
      }
      return false;
   }


   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      if (checkName()) {
         alert('The service area name to be added already exists!');//要增加的业务区名称已经存在
         fm.serareaname.focus();
         return;
      }
      fm.serareano.value = 0;
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(fm.infoList.length==0){
          alert("No service area can be edited!");//没有任何业务区可供Edit
          return;
      }
      if(index == -1){
          alert("Please select the service area to be edited");//请选择您Edit的业务区
          return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      if (checkName()) {
         alert('The new service area name to be edited already exists!');//您要Edit的新业务区名称已经存在
         fm.serareaname.focus();
         return;
      }
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      if(fm.infoList.length==0){
          alert("No service area can be deleted!");//没有任何业务区可供删除
          return;
      }
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the service area to be deleted");//请选择您删除的业务区
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }

    function onSCPChange(){
       document.inputForm.op.value = "";
       document.inputForm.submit();
   }
	function selectSub()
	{
	 	var fm = document.inputForm;
	 	if(fm.subservice.value=='<%=subservice%>')
	 		return false;
		fm.submit();
	}


</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="serviceArea.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="serareano" value="">
<table width="500" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Manage service areas</td>
        </tr>
        <tr>
        <td width="45%" align="right">
          &nbsp; SCP&nbsp;&nbsp; <select name="scplist" size="1" onchange="javascript:onSCPChange()" style="width:160px">
              <% out.print(optSCP); %>
             </select>
             <select name="infoList" size="12"  style="width:200px" onclick="javascript:selectInfo()">
             <%
                for (int i = 0; i < serviceList.size(); i++) {
                    map = (HashMap)serviceList.get(i);
                 out.println("<option value=" + Integer.toString(i) + ">" + (String)map.get("serareaname") + "</option>");
               }
            %>
            </select>
        </td>
        <td width="55%">
            <table width="100%" border =0 class="table-style2" >
            <tr height="35">
            <td align="right" >Name of<br>service area</td>
            <td><input type="text" name="serareaname" value="" maxlength="20" class="input-style1" ></td>
            </tr>
            <tr height="35" >
            <td align="right">Maximum number<br>of subscribers</td>
            <td>
             <input type="text" name="maxuser" value="" maxlength="6" class="input-style1" ></td>
            </tr>
            
<!--            
            <tr height="35">  
            	<td align="right">Sub Service</td>
          		<td>
          			<select name="subservice" size="1" <%= vetSubservice.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectSub()">
<%
                		for (int i = 0; i < 2; i++) {
                    		Hashtable hash = (Hashtable)vetSubservice.get(i);
%>
              			<option value="<%=(String)hash.get("subservice") %>"
              				<%=((String)hash.get("subservice")).equals(subservice)?" selected ":""%>
              			><%= (String)hash.get("description") %></option>
<%
            			}
%>
            		</select>
          	</td>
        	</tr>
-->            
            
            
            <tr height="35" >
            <td align="right">Called subscriber type</td>
            <td>
              <select name="usertype" size="1"  class="input-style1">
                 <% out.print(option); %>
           </select>
            </td>
            </tr>
          <tr style="<%=("1".equals(usecalling)?"display:block":"display:none")%>">
			  <td align="right">Calling Subscriber type</td>
            <td>
              <select name="usertype1" size="1"  class="input-style1">
                 		<%
                 		 option="";
                 		 vet = syspara.getUserTypeInfo("2");
            			 for(int i=0;i<vet.size();i++){
              					Hashtable table = (Hashtable)vet.elementAt(i);
              					option +="<option value=" + (String)table.get("usertype") + " > " + (String)table.get("utlabel")+ " </option>";
            			 }
            			 out.print(option); 
                 		 %>
           </select>
            </td>
            </tr>
           
           <tr style="display:none">
			  <td align="right">Group Subscriber type</td>
			  <td>
				  <select name="usertype2" size="1"  class="input-style1">
					  <%
					  option="";
					  vet = syspara.getUserTypeInfo("4");
					  for(int i=0;i<vet.size();i++){
						  Hashtable table = (Hashtable)vet.elementAt(i);
						  option +="<option value=" + (String)table.get("usertype") + " > " + (String)table.get("utlabel")+ " </option>";
					  }
					  out.print(option);
					  %>
					  </select>
				  </td>
			  </tr>

			  <tr style="<%=("1".equals(isimage)?"display:block":"display:none")%>">
			  <td align="right">Image Subscriber type</td>
			  <td>
				  <select name="usertype3" size="1"  class="input-style1">
					  <%
					  option="";
					  vet = syspara.getUserTypeInfo("16");
					  for(int i=0;i<vet.size();i++){
						  Hashtable table = (Hashtable)vet.elementAt(i);
						  option +="<option value=" + (String)table.get("usertype") + " > " + (String)table.get("utlabel")+ " </option>";
					  }
					  out.print(option);
					  %>
					  </select>
				  </td>
			  </tr>
           
            <tr height="40">
             <td colspan="2">
               <table border="0" width="100%" class="table-style2">
                 <tr>
                <%if(purview.CheckOperatorRightAllSerno(session,"3-15")){ %>
                   <td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                   <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                   <td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
		<%}else{%>
                   <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <%}%>
                   <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
                 </tr>
               </table>
             </td>
            </tr>
            </table>
     </td>
     </tr>
      <tr>
          <td colspan="2" style="color: #FF0000">&nbsp;&nbsp;&nbsp;Notes:
        The maximum number of subscribers set to "0" indicates there is no limit for the number of subscribers in the serivce area.
      </td>
      </tr>
     </table>
 </td>
 </tr>
 </table>
</form>

<script language="JavaScript">

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
        sysInfo.add(sysTime + operName + "Exception occurred in managing service areas!");//业务区管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing service areas!");//业务区管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="serviceArea.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>


</body>
</html>

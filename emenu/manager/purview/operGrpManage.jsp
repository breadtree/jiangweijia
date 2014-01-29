<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public String transferString(String str) throws Exception {
      return str;
    }
%>

<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%

    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String spIndex = (String)session.getAttribute("SPINDEX");
    String spCode = (String)session.getAttribute("SPCODE");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    try {
       String  errmsg = "";
       boolean flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";//Please log in to the system
          flag = false;
       }
       else if (purviewList.get("5-3") == null) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
       if(flag){
        String serviceKey = (String)session.getAttribute("SERVICEKEY");
        String  optOperGroup = "";
        String  optServiceList = "";
        //serviceKey = "all";
        ArrayList serviceList = purview.getServiceList(serviceKey);
        String selectedServiceKey = (String)request.getParameter("serviceKey");
        String operGrpID = request.getParameter("operGroup") == null ? "" : (String)request.getParameter("operGroup");
        String operate = request.getParameter("operate") == null ? "" : (String)request.getParameter("operate");        // 动作代号
        String grpScript = request.getParameter("grpScript") == null ? "" : transferString((String)request.getParameter("grpScript"));  // 要增加的操作员描述
        HashMap map = new HashMap();
        // 判断选定的业务键,如果没有,赋初值
        if (selectedServiceKey == null)
            if (serviceList.size() > 0)
                selectedServiceKey = (String)((HashMap)serviceList.get(0)).get("SERVICEKEY");
            else
                selectedServiceKey = serviceKey;
        if (selectedServiceKey.equalsIgnoreCase("all"))
            selectedServiceKey = (String)((HashMap)serviceList.get(0)).get("SERVICEKEY");

        //增加一个操作员组
        if (operate.equalsIgnoreCase("add"))
            purview.addOperGrp(selectedServiceKey,grpScript,Integer.parseInt(operID));
        //修改一个操作员组
        if (operate.equalsIgnoreCase("mod"))
            purview.updateOperGrp(selectedServiceKey,operGrpID,grpScript);
        // 删除一个操作员组
        if (operate.equalsIgnoreCase("del"))
            purview.delOperGrp(selectedServiceKey,Integer.parseInt(operGrpID));

        ArrayList funcGrp = purview.getFuncGrp(selectedServiceKey);
        Vector lststr=new Vector();
        lststr = purview.oper_grpscriptqry(serviceKey,operID);
        int colcount = purview.oper_grpscriptqryrows();
        int size = lststr.size()/colcount;
        for(int i=0;i<lststr.size();i=i+colcount){
           optOperGroup = optOperGroup + "<option value='" + lststr.get(i) +"' >" + lststr.get(i+1) + "</option>";
        }

        for (int i = 0; i < serviceList.size(); i++) {
            map = (HashMap)serviceList.get(i);
            String serv = (String)map.get("SERVICEKEY");
            if(serv.equals(selectedServiceKey))
              optServiceList = optServiceList + "<option value=" +  (String)map.get("SERVICEKEY") +" selected >" + (String)map.get("DESCRIPTION") + "</option>";
            else
              optServiceList = optServiceList + "<option value=" +  (String)map.get("SERVICEKEY") +" >" + (String)map.get("DESCRIPTION") + "</option>";
        }
  %>


<HTML>
<head>
   <title>Untitled</title>
<link rel="stylesheet" href="../style.css" type="text/css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<BODY topmargin="0" leftmargin="0" onload="initform(this.document.forms[0])">
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="480";
</script>

<Script language="javascript">
   var v_grpscript = new Array(<%= size + "" %>);
   var v_creatorid = new Array(<%= size + "" %>);
  <%
        int j = 0;
        for(int i=0;i<lststr.size();i=i+colcount){
  %>
    v_grpscript[<%= j + "" %>] = '<%= lststr.get(i+1) %>';
    v_creatorid[<%= j + "" %>] = '<%= lststr.get(i+2) %>';
  <%
    j = j+1;

  } %>
  function initform(pform){
	 document.forms[0].bModify.disabled = true;
	 document.forms[0].bDelete.disabled = true;
	 document.forms[0].bConfirm.disabled = true;
	 document.forms[0].bCancel.disabled = true;
	 document.forms[0].grpScript.disabled = true;
	 if(document.forms[0].operGroup.length>0){
	  document.forms[0].operGroup.selectedIndex = 0;
	  onOperGroup();
	 }
  }
  function actAdd(){

	 document.forms[0].operate.value = "add";
	 document.forms[0].grpIndex.value = document.forms[0].operGroup.selectedIndex;
	 document.forms[0].bAdd.disabled = true;
	 document.forms[0].bConfirm.disabled = false;
	 document.forms[0].bModify.disabled = true;
	 document.forms[0].bDelete.disabled = true;
	 document.forms[0].bCancel.disabled = false;
	 document.forms[0].grpScript.value = "";
	 document.forms[0].grpScript.innertext = "";
	 document.forms[0].operGroup.selectedIndex = -1;
	 document.forms[0].grpScript.disabled = false;
	 document.forms[0].grpScript.focus();
	 return true;
  }

  function actModify(){
     var select = parseInt(document.forms[0].operGroup.selectedIndex);
     document.forms[0].grpIndex.value = select;
     if(select == -1){
         alert("Please select the operator group to be modified!");//请选择您要修改的操作员组!
     	return false;
     }
     document.forms[0].operate.value = "mod";
     document.forms[0].bAdd.disabled = true;
     document.forms[0].bConfirm.disabled = false;
     document.forms[0].bModify.disabled = true;
     document.forms[0].bDelete.disabled = true;
     document.forms[0].bCancel.disabled = false;
     document.forms[0].grpScript.disabled = false;
     document.forms[0].grpScript.focus();
     return true;
  }

  function actDelete() {
      var select = parseInt(document.forms[0].operGroup.selectedIndex);
	  if(select == -1)
	  {
	      alert("Please select the operator group to be deleted!");//请选择您要删除的操作员组
	  	return false;
	  }
	  if(confirm("Are you sure you want to delete this operator group?"))//您确定要删除该操作员组吗
	  {
	      document.forms[0].operate.value = "del";
	  	  document.forms[0].submit();
	  }
  }
  function actConfirm() {

	  if(!checkInput())
	     return false;
	  document.forms[0].submit();
  }



  function onOperGroup(){
	 var select = parseInt(document.forms[0].operGroup.selectedIndex);
	 if(select==-1)
	    return;
	 var createid = v_creatorid[select];
	 document.forms[0].grpScript.value = v_grpscript[select] ;
	 if(createid>0){
	    document.forms[0].grpScript.disabled = false;
	    document.forms[0].bModify.disabled = false;
	    document.forms[0].bDelete.disabled = false;
	    document.forms[0].bAdd.disabled = false;
        document.forms[0].bCancel.disabled = true;
	    document.forms[0].bConfirm.disabled = true;
	}
	else{
	   document.forms[0].grpScript.disabled = true;
       document.forms[0].bModify.disabled = true;
       document.forms[0].bDelete.disabled = true;
       document.forms[0].bAdd.disabled = false;
       document.forms[0].bCancel.disabled = true;
       document.forms[0].bConfirm.disabled = true;
	}
  }

  function checkInput(){
     var value = document.forms[0].grpScript.value;
     if( value == ""){
	     alert("Please enter the operator group name");//请输入操作员组名称
	     document.forms[0].grpScript.focus();
	     return false;
	 }
        if (!CheckInputStr(document.forms[0].grpScript,'name of operator group')){
           document.forms[0].grpScript.focus();
           return false;
        }
	 if(strlength(value)>40){
	     alert("The length of the operator group name has exceeded 40 bytes");//操作员组名称长度已超过40个字节!
	     document.forms[0].grpScript.focus();
	     return false;
	 }
	 var select  = document.forms[0].operGroup.selectedIndex;
         var flag = 0;
        if(select ==-1){  //添加操作员组
          for(var index=0; index<v_grpscript.length;index++){
           if(v_grpscript[index] == value){
             flag = 1;
             break;
          }
        }
    }
    else   //修改
      for(var index=0; index<v_grpscript.length;index++){
        if(v_grpscript[index] == value && index!=<%=j%>){
            flag = 1;
            break;
        }
       }
     if(flag == 1){
        alert("This operator group name already exists. Please re-enter!");//操作员组名称已经存在,请重新输入!
        document.forms[0].grpScript.focus();
        return false;
     }
     return true;

  }

  function actCancel(){
    document.forms[0].operGroup.selectedIndex = parseInt(document.forms[0].grpIndex.value);
    onOperGroup();
    document.forms[0].bAdd.disabled = false;
	document.forms[0].bConfirm.disabled = true;
	document.forms[0].bModify.disabled = true;
	document.forms[0].bDelete.disabled = true;
	document.forms[0].bCancel.disabled = true;
	document.forms[0].grpScript.disabled = true;
  }
</script>

<form name="inForm" method="post" action="operGrpManage.jsp">
  <table height="400" align="center" cellSpacing="0" cellPadding="0" border="0"  >
    <tr>
	<td width="100%" valign="middle">
	<table width="100%" border="0">
	<tr>
      <td colspan="2" height="26" align="center" class="text-title" valign="middle" background="../image/n-9.gif" >Operator group management</td>
    </tr>
    <tr>
      <td width="39%" align="center" valign="top" >
	  <table border="0">
          <tr>
            <td align="center" class="table-style1">Operator group list </td>
          </tr>
          <tr>
            <td align="center" height="100%"> <select name="operGroup" style="WIDTH: 130px; HEIGHT: 180px" size=10  onchange="onOperGroup()">
                <% out.print(optOperGroup); %>
              </select> </td>
          </tr>
      </table></td>
      <td width="61%" valign="top">
	  <table height="195" border="0" bordercolor="#E1F5FD"  class="table-style2">
          <tr>
            <td width="87" height="30" valign="bottom"> Management System </td>
            <td width="161" HEIGHT="30" valign="bottom"> <select name="serviceKey" disabled class="input-style1">
                <% out.println(optServiceList); %>
              </select> </td>
          </tr>

          <tr>
            <td height="46"  valign="bottom"> Operator group </td>
            <TD HEIGHT="46" valign="bottom"> <input name="grpScript" size="20" Maxlength="40"  class="input-style1">
            </td>
          </tr>

          <tr >
            <TD HEIGHT="104"   colspan="2" valign="bottom">
            	<input type="button" name="bAdd"    value="Add"    onClick="actAdd()"    class="button-style4" >
               <input type="button" name="bModify" value="Modify" onClick="actModify()" class="button-style5" >
               <input type="button" name="bDelete" value="Delete" onClick="actDelete()" class="button-style5" >
            <br/> <br/> <br/>
               <input type="button" name="bConfirm" value=" OK "  onClick="actConfirm()" class="button-style5" >
               <input type="button" name="bCancel" value="Cancel" onClick="actCancel()"  class="button-style5" >
            	<input type="hidden" name="operate" value="-1"> <input type="hidden" name="grpIndex" value="-1">
            </td>
          </tr>
        </table></td>
    </tr>
	</table>
	</td></tr>
  </table>
</center>
</form>
</body>
</html>
<%
        }
        else {
            if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    document.location.href = '../enter.jsp';
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
   catch (Exception e) {
%>
<html>
<body>
<table border="1" width="100%" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style1">
  <tr>
    <td colspan="2">Error:<%= e.toString() %></td>
  </tr>
</table>
</body>
</html>
<%
    }
%>
</body>
</html>

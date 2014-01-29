<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%!
   public String display (HashMap map) throws Exception {
        try {
            String str = (String)map.get("areacode");
            for (; str.length() < 10; )
                str += "-";
            return str + (String)map.get("areaname");
        }
        catch (Exception e) {
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data!
        }
    }
%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Incoming/outgoing prefix management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" onload="JavaScript:initform(document.forms[0])" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (purviewList.get("3-13") == null) {
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to the system first!" : "No access to this function!" %>');//Please log in to the system  无权访问此功能
    document.URL = 'enter.jsp';
</script>
<%
        }
        else if (operID != null) {
            ArrayList list  = new ArrayList();
            HashMap map1 = new HashMap();
			String  optSCP = "";
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String scp = request.getParameter("scplist") == null ? "" : ((String)request.getParameter("scplist")).trim();
			String newareacode = request.getParameter("areacode") == null ? "" : transferString((String)request.getParameter("areacode")).trim();
            String areaname = request.getParameter("areaname") == null ? "" : transferString((String)request.getParameter("areaname")).trim();
            if(checkLen(areaname,20))
            	throw new Exception("The length of the called area name you entered has exceeded the limit of 20 bytes. Please re-enter!");//您输入的被叫地区名称长度超出20字节限制,请重新输入!
            String inprefix = request.getParameter("inprefix") == null ? "" : transferString((String)request.getParameter("inprefix")).trim();
            String outprefix = request.getParameter("outprefix") == null ? "" : transferString((String)request.getParameter("outprefix")).trim();
            String areacode = request.getParameter("oldareacode") == null ? "" : transferString((String)request.getParameter("oldareacode")).trim();
            int  optype =0;
            String title = "";
            String desc = "";
            if (op.equals("add")) {
                optype = 1;
                areacode = newareacode;
                desc  = operName + "Add incoming/outgoing prefix";//增加出入局前缀
                title = " Add incoming/outgoing prefix " + areacode;//增加出入局前缀
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + " Edit incoming/outgoing prefix";//Edit出入局前缀
                title = " Edit incoming/outgoing prefix " + areacode;//Edit出入局前缀
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + " Delete incoming/outgoing prefix";//删除出入局前缀
                title = " Delete incoming/outgoing prefix " + areacode;//删除出入局前缀
             }
             if(optype>0){
                map1.put("scp",scp);
                map1.put("optype",optype+"");
                map1.put("areacode",areacode);
                map1.put("newareacode",newareacode);
                map1.put("areaname",areaname);
                map1.put("inprefix",inprefix);
                map1.put("outprefix",outprefix);
                syspara.setAreaPrefix(map1);
                sysInfo.add(sysTime + desc);

                // 准备写操作员日志
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","315");
                map.put("RESULT","1");
                map.put("PARA1",areacode);
                map.put("PARA2",newareacode);
                map.put("PARA3",scp);
                map.put("PARA4",areaname);
                map.put("PARA5", inprefix);
                map.put("PARA6", outprefix);
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
             }


            ArrayList scplist = syspara.getScpList();
            for (int i = 0; i < scplist.size(); i++) {
               if(i==0 && scp.equals(""))
                  scp = (String)scplist.get(i);
               optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
            }
            if(!scp.equals(""))
              list = syspara.getAreaPrefix(scp);
%>
<script language="javascript">
   var v_areacode = new Array(<%= list.size() + "" %>);
   var v_areaname = new Array(<%= list.size() + "" %>);
   var v_inprefix = new Array(<%= list.size() + "" %>);
   var v_outprefix = new Array(<%= list.size() + "" %>);
<%
            for (int i = 0; i < list.size(); i++) {
                map1 = (HashMap)list.get(i);
%>
   v_areacode[<%= i + "" %>] = '<%= (String)map1.get("areacode") %>';
   v_areaname[<%= i + "" %>] = '<%= (String)map1.get("areaname") %>';
   v_inprefix[<%= i + "" %>] = '<%= (String)map1.get("inprefix") %>';
   v_outprefix[<%= i + "" %>] = '<%= (String)map1.get("outprefix") %>';
<%
            }
%>

    function leftTrimtt (str) {
      var tmp = str;
      var i = 0;
      for (i = 0; i < str.length; i++) {
         if (tmp.substring(0,1) == '0')
            tmp = tmp.substring(1,tmp.length);
         else
            return tmp;
      }
   }

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
      fm.areacode.value = v_areacode[index];
      fm.oldareacode.value = v_areacode[index];
      fm.areaname.value = v_areaname[index];
      fm.inprefix.value = v_inprefix[index];
      fm.outprefix.value = v_outprefix[index];
      fm.areacode.focus();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.areacode.value) == '') {
         alert('Please enter the called area code!');//请输入被叫地区区号
         fm.areacode.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.areacode.value))) {
         alert('The called area code must be a digital number!');//被叫地区区号必须是数字
         fm.areacode.focus();
         return flag;
      }
      if (trim(fm.areaname.value) == '') {
         alert('Please enter an area name!');
         fm.areaname.focus();
         return flag;
      }
      if (!CheckInputStr(fm.areaname,'The name of called area')){
         fm.areaname.focus();
         return  flag;
      }
      if (trim(fm.inprefix.value) == '') {
         alert('Please enter the incoming prefix!');//请输入入局前缀
         fm.inprefix.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.inprefix.value))) {
         alert('The incoming prefix must be a digital number!');//入局前缀必须是数字
         fm.inprefix.focus();
         return flag;
      }
      if (fm.outprefix.value!='' && !checkstring('0123456789',trim(fm.outprefix.value))) {
         alert('The outgoing prefix must be a digital number!');//出局前缀必须是数字
         fm.outprefix.focus();
         return flag;
      }

      var value = trim(fm.areacode.value);
      if(value=='0000000000'.substring(0,value.length)){
        // alert('被叫地区区号不能为0!');
         alert('The called area code cannot be 0!');
         fm.areacode.focus();
         return flag;
      }
      fm.areacode.value = leftTrimtt(value);

      flag = true;
      return flag;
   }

   function checkCode () {
      var fm = document.inputForm;
      var code = trim(fm.areacode.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_areacode.length; i++)
           if (code == v_areacode[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_areacode.length; i++)
           if (code == v_areacode[i] && i!=index)
             return true;
      }
	  else if(optype=='del')
	  	return true;
      return false;
   }
   function checkName () {
      var fm = document.inputForm;
      var code = trim(fm.areaname.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_areaname.length; i++)
           if (code == v_areaname[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_areaname.length; i++)
           if (code == v_areaname[i] && i!=index)
             return true;
      }
	  else if(optype=='del')
	  	return true;
      return false;
   }


   function addInfo () {
      var fm = document.inputForm;
      if (! checkInfo())
         return;
      fm.op.value = 'add';
      if (checkCode()) {
         alert('The area code to be added already exists!');//要增加的地区号已经存在
         fm.areacode.focus();
         return;
      }
      if (checkName()) {
         alert('The new area name to be added already exists!');//您要新增的地区名称已经存在
         fm.areaname.focus();
         return;
      }
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the area code to be edited");//请选择您Edit的地区号
          return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      if (checkCode()) {
         alert('The new area code to be edited already exists!');//您要Edit的新地区号已经存在
         fm.areacode.focus();
         return;
      }
      if (checkName()) {
         alert('The new area name to be edited already exists!');//您要Edit的新地区名称已经存在
         fm.areaname.focus();
         return;
      }
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the area code to be deleted");//请选择您删除的地区号
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }
   function onSCPChange(){
       document.inputForm.op.value = "";
       document.inputForm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="areaprefix.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldareacode" value="">
<table width="90%" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Incoming/outgoing prefix management</td>
        </tr>
        <tr>
            <td  width=40% align="left" > SCP Select
              <select name="scplist" size="1" onChange="javascript:onSCPChange()" style="width:140">
                <% out.print(optSCP); %>
              </select>
              <br>
			<select name="infoList" size="8" <%= list.size() == 0 ? "disabled " : "" %> style="width:200px"  onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < list.size(); i++) {
                    map1 = (HashMap)list.get(i);
%>
              <option value="<%= i + "" %>"><%= display(map1) %></option>
<%
               }
%>
            </select>
         </td>
         <td width=60%>
             <table border="0" width="100%"  celspan="5" class="table-style2" >
             <tr>
               <td align="right">Called area code</td>
               <td><input type="text" name="areacode" value="" maxlength="10" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.areaname,'integer')"></td>
             </tr>
             <tr>
               <td align="right">Called area name</td>
               <td><input type="text" name="areaname" value="" maxlength="20" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.inprefix,'')"></td>
             </tr>
             <tr>
               <td align="right">Incoming prefix</td>
               <td><input type="text" name="inprefix" value="" maxlength="10" class="input-style1" onKeyPress="return OnKeyPress(event,document.inputForm.outprefix,'integer')"></td>
             </tr>
             <tr>
               <td align="right">Outgoing prefix</td>
               <td><input type="text" name="outprefix" value="" maxlength="10" class="input-style1" ></td>
             </tr>
             <tr>
               <td colspan="2">
                 <table border="0" width="100%" class="table-style2">
                   <tr>
                       <td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                     <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                     <td width="25%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                     <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
                   </tr>
                 </table>
               </td>
             </tr>
            </table>
       </td>
       </tr>
        <tr>
         <td  style="color: #FF0000" colspan=2 height=23> Notes:</td>
       </tr>
	   <tr>
         <td  style="color: #FF0000" colspan=2 height=23> &nbsp;&nbsp;1. The first digit of the called area code cannot be 0;</td>
       </tr>
	   <tr>
         <td  style="color: #FF0000" colspan=2 height=23> &nbsp;&nbsp;2. In a multi-SCP environment, different SCPs are configured with different called area codes.</td>
       </tr>
      </table>
    </td>
    </tr>
    </table>
</form>
<%
        }
        else {
%>
<script language="JavaScript">
   alert('Please log in to the system first!');//Please log in to the system
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in managing incoming/outgoing prefixes!");//出入局前缀管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing incoming/outgoing prefixes!");//出入局前缀管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="areaprefix.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

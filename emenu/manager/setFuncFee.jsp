<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>



<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Configure paid items</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
   //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);


    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = SocketPortocol.getSysTime() + "--";
        if (operID != null && purviewList.get("3-17") != null) {
            ArrayList list  = new ArrayList();
            ArrayList rList  = new ArrayList();
            HashMap map1 = new HashMap();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String funcid = request.getParameter("funcid") == null ? "0" : transferString((String)request.getParameter("funcid")).trim();
            String iffee = request.getParameter("iffee") == null ? "0" : transferString((String)request.getParameter("iffee")).trim();
            String funcfee = request.getParameter("funcfee") == null ? "0" : transferString((String)request.getParameter("funcfee")).trim();
            String desc = request.getParameter("desc") == null ? "" : transferString((String)request.getParameter("desc")).trim();
            if (op.equals("edit")) {
                map1.put("funcid",funcid);
                map1.put("iffee",iffee);
                map1.put("funcfee",funcfee);
                rList = syspara.setFuncFee(map1);
                if(getResultFlag(rList)){
                   zxyw50.Purview purview = new zxyw50.Purview();
                   HashMap map = new HashMap();
                   map.put("OPERID",operID);
                   map.put("OPERNAME",operName);
                   map.put("OPERTYPE","317");
                   map.put("RESULT","1");
                   map.put("PARA1",desc);
                   map.put("PARA2",iffee);
                   map.put("PARA3",funcfee);
                   map.put("PARA4","ip:"+request.getRemoteAddr());
                   purview.writeLog(map);
                }
                sysInfo.add(sysTime + operName + "Modify charge items:'"+ desc +"'successfully!");
            }
            if(rList.size()>0){
               session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="setFuncFee.jsp">
<input type="hidden" name="title" value="<%= desc %> configure charge items">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
            }
            list = syspara.getFuncFee();
%>
<script language="javascript">
   var v_funcid = new Array(<%= list.size() + "" %>);
   var v_iffee = new Array(<%= list.size() + "" %>);
   var v_funcfee = new Array(<%= list.size() + "" %>);
   var v_funcdesc = new Array(<%= list.size() + "" %>);
<%
            for (int i = 0; i < list.size(); i++) {
                map1 = (HashMap)list.get(i);
%>
   v_funcid[<%= i + "" %>] = '<%= (String)map1.get("funcid") %>';
   v_iffee[<%= i + "" %>] = '<%= (String)map1.get("iffee") %>';
   v_funcfee[<%= i + "" %>] = '<%= (String)map1.get("funcfee") %>';
   v_funcdesc[<%= i + "" %>] = '<%= (String)map1.get("funcdesc") %>';
<%
            }
%>

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if (index == -1 || index>v_funcid.length)
         return;
      fm.funcdesc.value = v_funcdesc[index];
      fm.desc.value = v_funcdesc[index];
      fm.funcid.value = v_funcid[index];
      fm.iffee[v_iffee[index]].checked = true;
      fm.funcfee.value = v_funcfee[index];
      if(fm.iffee[0].checked)
         fm.funcfee.disabled = true;
      else
         fm.funcfee.disabled = false;
   }

   function onIfFee(){
      var fm = document.inputForm;
      if(fm.iffee[0].checked)
          fm.funcfee.disabled = true;
      else {
         fm.funcfee.disabled = false;
         if(trim(fm.funcfee.value)=='')
           fm.funcfee.value = 500;
         fm.funcfee.focus();
      }
      var index = fm.infoList.selectedIndex;
      if (index == -1 || index>v_funcid.length)
         return;
      fm.funcfee.value = v_funcfee[index];
   }

   function editInfo () {
      var fm = document.inputForm;
      var len = fm.infoList.length;
      if(len==0)
         return;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the charge item to be configured");//请选择您要配置的收费项
          return;
      }
      if(fm.iffee[1].checked){
        var value = trim(fm.funcfee.value);
        if(value ==''){
           alert("Please enter an amount of charge!");//请输入收费金额
           fm.funcfee.focus();
           return;
        }
        if(!checkstring('0123456789',value)){
           alert("The amount of charge can only be a digital number. Please re-enter!");//收费金额只能为数字,请重新输入!
           fm.funcfee.focus();
           return;
        }
      }
      fm.op.value = "edit";
      fm.funcfee.disabled =false;
      fm.submit();
   }


</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="setFuncFee.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="funcid" value="">
<input type="hidden" name="desc" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Configure paid items</td>
        </tr>
        <tr>
          <td rowspan="4">
            <select name="infoList" size="6" <%= list.size() == 0 ? "disabled " : "" %> style="width:180px"  class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < list.size(); i++) {
                    map1 = (HashMap)list.get(i);
%>
              <option value="<%= String.valueOf(i) %>"><%= (String)map1.get("funcdesc") %></option>
<%
            }
%>
            </select>
          </td>
          <td align="right">Name of<br>charge item</td>
          <td><input type="text" name="funcdesc" value="" maxlength="20" class="input-style1" disabled ></td>
        </tr>
        <tr>
          <td align="right">Charge or not</td>
          <td>
             <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="50%"><input type="radio" checked name="iffee" value="0" onclick="onIfFee()" >Free</td>
                <td width="50%"><input type="radio" name="iffee" value="1" onclick="onIfFee()" >Charge</td>
              </tr>
            </table>
           </td>
        </tr>
        <tr>
          <td align="right">Charge (<%=minorcurrency%>)</td>
          <td><input type="text" name="funcfee" value="" maxlength="5" class="input-style1" ></td>
        </tr>
        <tr>
          <td colspan="2" align="center">
            <img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()">
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
                   alert( "Sorry. You have no right for this function!");//Sorry,you have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in configuring charge items!");//收费项目配置过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in configuring charge items!");//收费项目配置过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="setFuncFee.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

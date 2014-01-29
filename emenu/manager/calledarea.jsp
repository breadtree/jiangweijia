<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="zxyw50.manSysPara" %>
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
<body class="body-style1" onload="JavaScript:initform(document.forms[0])">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-14") != null) {
            Hashtable hash = new Hashtable();
            ArrayList rList  = new ArrayList();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String provincecode = request.getParameter("provincelist") == null ? "" : transferString((String)request.getParameter("provincelist")).trim();
            HashMap map = null;
            if (op.equals("edit")) {
                String areacode = request.getParameter("areacode") == null ? "" : transferString((String)request.getParameter("areacode")).trim();
                String areaname = request.getParameter("arealabel") == null ? "" : transferString((String)request.getParameter("arealabel")).trim();
                String bflag = request.getParameter("bflag") == null ? "0" : transferString((String)request.getParameter("bflag")).trim();
                hash.put("areacode",areacode);
                hash.put("bflag",bflag);
                rList = syspara.editCalledArea(hash);
                sysInfo.add(sysTime + operName + " Called service area edited successfully!");

                if(getResultFlag(rList)){
                   // 准备写操作员日志
                   zxyw50.Purview purview = new zxyw50.Purview();
                   map  = new HashMap();
                   map.put("OPERID",operID);
                   map.put("OPERNAME",operName);
                   map.put("OPERTYPE","316");
                   map.put("RESULT","1");
                   map.put("PARA1",areacode);
                   map.put("PARA2",bflag);
                   map.put("PARA3","ip:"+request.getRemoteAddr());
                   purview.writeLog(map);
                }
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="calledarea.jsp">
<input type="hidden" name="title" value="Edit called service area --<%= areaname %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
            }
            ArrayList provinceList = syspara.getProvince();
            String    optProvince = "";
            String    optCalledArea = "";
            boolean flag = false;
            ArrayList areaList = new ArrayList();

            if(provincecode.equals(""))
               flag = true;
            for (int i = 0; i < provinceList.size(); i++) {
               map = (HashMap)provinceList.get(i);
               if(flag){
                   if(i==0 || ((String)map.get("bflag")).equals("1"))
                     provincecode = (String)map.get("provincecode");
               }
               optProvince = optProvince + "<option value=" + (String)map.get("provincecode") + " > " + (String)map.get("provincename")+ " </option>";
            }

            if(!provincecode.equals("")){
              areaList = syspara.getCalledArea(provincecode);
             
              for (int i = 0; i < areaList.size(); i++) {
                 map = (HashMap)areaList.get(i);
                 optCalledArea = optCalledArea + "<option value=" + (String)map.get("areacode") + " > " + (String)map.get("areaname") + " </option>";
              }
            }
%>
<script language="javascript">
   var v_areacode = new Array(<%= areaList.size() + "" %>);
   var v_areaname = new Array(<%= areaList.size() + "" %>);
   var v_bflag = new Array(<%= areaList.size() + "" %>);
<%
   for (int i = 0; i < areaList.size(); i++) {
         map = (HashMap)areaList.get(i);
%>
   v_areacode[<%= i + "" %>] = '<%= (String)map.get("areacode") %>';
   v_areaname[<%= i + "" %>] = '<%= (String)map.get("areaname") %>';
   v_bflag[<%= i + "" %>] = '<%= (String)map.get("bflag") %>';
<%
            }
%>
   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if (index <0 || index >=v_areacode.length)
          return;
      fm.areacode.value = v_areacode[index];
      fm.areaname.value = v_areaname[index];
      fm.arealabel.value = v_areaname[index];
      fm.bflag[v_bflag[index]].checked = true;
   }

   function initform(pform){
      var temp = "<%= provincecode %>";
      for(var i=0; i<pform.provincelist.length; i++){
        if(pform.provincelist.options[i].value == temp){
           pform.provincelist.selectedIndex = i;
           break;
        }
     }
   }
   function editInfo () {
      var fm = document.inputForm;
      if(fm.provincelist.selectedIndex ==-1){
        alert("Please select a province!");//请选择省份
        return false;
      }
      if(fm.infoList.length ==0){
        alert("No called area can be modified!");//没有被叫地区可供修改!
        return false;
      }
      if(fm.infoList.selectedIndex ==-1){
        alert("Please select a called area");//请选择被叫地区!
        return false;
      }
      fm.op.value = 'edit';
      fm.areacode.disabled = false;
      fm.submit();
   }
   function onProvinceChange(){
       document.inputForm.submit();
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="calledarea.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="arealabel" value="">
<table width="100%" height="450" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Called service area management</td>
        </tr>
        <tr>
        <td width="40%">
             <table width="100%" border=0  class="table-style2">
             <tr>
             <td width="100" align="right"><span title="Please select a province">Province</span></td>
             <td width="152">
             <select name="provincelist" size="1" onchange="javascript:onProvinceChange()" style="width:120px">
              <% out.print(optProvince); %>
             </select>
             </td>
             </tr>
             <tr>
             <td colspan=2 align="center">
             <select name="infoList" size="6"  style="width:200px" onclick="javascript:selectInfo()">
             <% out.print(optCalledArea);   %>
             </select>
             </td>
             </tr>
             </table>
        </td>
        <td width="60%">
            <table width="100%" border =0 class="table-style2">
            <tr>
            <td align="right" width="30%">Area No.</td>
            <td><input type="text" name="areacode" value="" maxlength="11" class="input-style1" disabled ></td>
            </tr>
            <tr>
            <td align="right">Area name</td>
            <td><input type="text" name="areaname" value="" maxlength="11" class="input-style1" disabled ></td>
            </td>
            </tr>
            <tr>
            <td align="right">Ringtone restriction</td>
            <td>
             <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="50%"><input type="radio" checked name="bflag" value="0">Restriction</td>
                <td width="50%"><input type="radio" name="bflag" value="1">No restriction</td>
              </tr>
            </table>
            </td>
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
                   alert( "Sorry. You have no permission for this function!");//You have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in managing called service areas!");//被叫服务区域管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing called service areas!");//被叫服务区域管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="calledarea.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

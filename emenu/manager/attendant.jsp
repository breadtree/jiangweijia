<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%!
    public String display (HashMap map) throws Exception {
        try {
            String str = (String)map.get("attendnumber");
            for (; str.length() < 8; )
                str += "-";
            return str + (String)map.get("description");
        }
        catch (Exception e) {
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data
        }
    }
%>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Operator management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-12") != null) {
            ArrayList list  = new ArrayList();
            ArrayList rList  = new ArrayList();
            HashMap map1 = new HashMap();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String attendnumber = request.getParameter("attendnumber") == null ? "" : transferString((String)request.getParameter("attendnumber")).trim();
            String description = request.getParameter("description") == null ? "" : transferString((String)request.getParameter("description")).trim();
            if(checkLen(description,40))
            	throw new Exception("The length of the operator name you entered has exceeded the limit. Please re-enter!");//您输入的话务员名称长度超出限制,请重新输入!
            String attindex = request.getParameter("attindex") == null ? "" : transferString((String)request.getParameter("attindex")).trim();
            int  optype= 0;
            String title = "";
            String desc = "";
            if (op.equals("add")) {
                optype = 1;
                attindex = "";
                desc  = operName + "Add operator" + attendnumber;//增加话务员
                title = "Add operator" + attendnumber;//增加话务员
            }
            else if (op.equals("edit")) {
                optype = 3;
                desc  = operName + " Change operator" + attendnumber;//更改话务员
                title = "Change operator" + attendnumber;//更改话务员
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + "Delete operator" + attendnumber;//
                title = "Delete operator " + attendnumber;//删除话务员
            }
            if(optype>0){
                map1.put("optype",optype+"");
                map1.put("attendnumber",attendnumber);
                map1.put("description",description);
                map1.put("attindex",attindex);
                rList = syspara.setAttendant(map1);

                sysInfo.add(sysTime + desc);

                if(getResultFlag(rList)){
                  // 准备写操作员日志
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","314");
                  map.put("RESULT","1");
                  map.put("PARA1",attindex);
                  map.put("PARA2",attendnumber);
                  map.put("PARA3",description);
                  map.put("PARA4","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",title);
                  purview.writeLog(map);
                }

                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="attendant.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }

            list = syspara.getAttendant();
            //System.out.println(list);
%>
<script language="javascript">
   var v_attendnumber = new Array(<%= list.size() + "" %>);
   var v_description = new Array(<%= list.size() + "" %>);
   var v_attindex = new Array(<%= list.size() + "" %>);
<%
            for (int i = 0; i < list.size(); i++) {
                map1 = (HashMap)list.get(i);
%>
   v_attendnumber[<%= i + "" %>] = '<%= (String)map1.get("attendnumber") %>';
   v_description[<%= i + "" %>] = '<%= (String)map1.get("description") %>';
   v_attindex[<%= i + "" %>] = '<%= (String)map1.get("attindex") %>';
<%
            }
%>

   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if (index == -1 || index>v_attindex.length)
         return;
      fm.attendnumber.value = v_attendnumber[index];
      fm.description.value = v_description[index];
      fm.attindex.value = v_attindex[index];
      fm.attendnumber.focus();
   }


   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      if (trim(fm.attendnumber.value) == '') {
         alert('Please enter the operator number!');//请输入话务员号码
         fm.attendnumber.focus();
         return flag;
      }
      if (!checkstring('0123456789',trim(fm.attendnumber.value))) {
         alert('The operator number must be a digital number!');//话务员号码必须是数字
         fm.attendnumber.focus();
         return flag;
      }
      if (trim(fm.description.value) == '') {
         alert('Please enter the operator name!');
         fm.description.focus();
         return flag;
      }
      if (!CheckInputStr(fm.description,'operator name')){
         fm.description.focus();
         return  flag;
      }
      flag = true;
      return flag;
   }

   function checkCode () {
      var fm = document.inputForm;
      var code = trim(fm.attendnumber.value);
      var optype = fm.op.value;
      if(optype=='add'){
        for (i = 0; i < v_attendnumber.length; i++)
           if (code == v_attendnumber[i])
             return true;
      }
      else if(optype=='edit'){
         var index = fm.infoList.selectedIndex;
         for (i = 0; i < v_attendnumber.length; i++)
           if (code == v_attendnumber[i] && i!=index)
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
         alert('The telephonist to be added already exists!');
         fm.attendnumber.focus();
         return;
      }
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      var len = fm.infoList.length;
      if(len==0)
         return;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the telephonist to be edited");
          return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';

      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      var len = fm.infoList.length;
      if(len==0)
         return;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the telephonist to be deleted");
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="attendant.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="attindex" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">Operator management</td>
        </tr>
        <tr>
          <td rowspan="3">
            <select name="infoList" size="6" <%= list.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < list.size(); i++) {
                    map1 = (HashMap)list.get(i);
%>
              <option value="<%= (String)map1.get("attendnumber") %>"><%= (String)map1.get("attendnumber") %></option>
<%
            }
%>
            </select>
          </td>
          <td align="right">Operator number</td>
          <td><input type="text" name="attendnumber" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Operator name</td>
          <td><input type="text" name="description" value="" maxlength="40" class="input-style1"></td>
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing operators!");//话务员管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing operators");//话务员管理过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="attendant.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

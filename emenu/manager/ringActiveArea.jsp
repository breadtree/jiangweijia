<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.group.util.StringUtil" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Special active area ringtone management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="Javascript1.2" src="calendar.js"></script>
</head>
<body background="background.gif" class="body-style1" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    // add for starhub
	String active_name = CrbtUtil.getConfig("activeName", "active");
	try {
        ColorRing  colorring = new ColorRing();
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-16") != null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            HashMap map1= new HashMap();
            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String actno = request.getParameter("actno") == null ? "" : transferString((String)request.getParameter("actno")).trim();
            String actname = request.getParameter("actname") == null ? "" : transferString((String)request.getParameter("actname")).trim();
            String acttitle = request.getParameter("acttitle") == null ? "" : transferString((String)request.getParameter("acttitle")).trim();
            String actcontent = request.getParameter("actcontent") == null ? "" : transferString((String)request.getParameter("actcontent")).trim();
            String startdate = request.getParameter("startdate") == null ? "" : transferString((String)request.getParameter("startdate")).trim();
            String enddate = request.getParameter("enddate") == null ? "" : transferString((String)request.getParameter("enddate")).trim();
            String responser = request.getParameter("responser") == null ? "" : transferString((String)request.getParameter("responser")).trim();
            String actmanager = request.getParameter("actmanager") == null ? "" : transferString((String)request.getParameter("actmanager")).trim();
            String telephone = request.getParameter("responser") == null ? "" : transferString((String)request.getParameter("telephone")).trim();
            String wavno = request.getParameter("wavno") == null ? "" : transferString((String)request.getParameter("wavno")).trim();
            String rsubindex = "0";
            String oldrsubindex = request.getParameter("oldrsubindex") == null ? "" : transferString((String)request.getParameter("oldrsubindex")).trim();
            String oldactno = request.getParameter("oldactno") == null ? "" : transferString((String)request.getParameter("oldactno")).trim();
            int optype = 0;
            String title = "";
            if (op.equals("add")){
                optype = 1;
                //title = "增加活动专区铃音";
                 title = "Add special active area ringtone";
            }
            else if (op.equals("del")) {
                optype = 2;
                actno  = oldactno;
                rsubindex = oldrsubindex;
               // title = "删除活动专区铃音";
                title = "Delete special active area ringtone";
            }else if(op.equals("edit")) {
                optype = 3;
                actno  = oldactno;
                rsubindex = oldrsubindex;
               // title = "修改活动专区铃音";
                title = "Modify special active area ringtone";
            }
            if(optype>0){
               map1.put("optype",optype+"");
               map1.put("actno",actno);
               map1.put("actname",actname);
               map1.put("acttitle",acttitle);
               map1.put("actcontent",actcontent);
               map1.put("startdate",startdate);
               map1.put("enddate",enddate);
               map1.put("responser",responser);
               map1.put("actmanager",actmanager);
               map1.put("telephone",telephone);
               map1.put("rsubindex",rsubindex);
               map1.put("wavno",wavno);
               rList = sysring.setActiveArea(map1);
               // 准备写操作员日志
               if(getResultFlag(rList)){
                 zxyw50.Purview purview = new zxyw50.Purview();
                 map.put("OPERID",operID);
                 map.put("OPERNAME",operName);
                 map.put("OPERTYPE","216");
                 map.put("RESULT","1");
                 map.put("PARA1",actno);
                 map.put("PARA2",actname);
                 map.put("PARA3",rsubindex);
                 map.put("PARA4","ip:"+request.getRemoteAddr());
                 map.put("DESCRIPTION",title);
                 purview.writeLog(map);
               }
               if(rList.size()>0){
                session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="ringActiveArea.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }


            }
            List vet = null;
            vet = sysring.getActiveArea();
 %>
<script language="javascript">
   var v_actno = new Array(<%= vet.size() + "" %>);
   var v_actname = new Array(<%= vet.size() + "" %>);
   var v_acttitle = new Array(<%= vet.size() + "" %>);
   var v_actcontent = new Array(<%= vet.size() + "" %>);
   var v_startdate = new Array(<%= vet.size() + "" %>);
   var v_enddate = new Array(<%= vet.size() + "" %>);
   var v_responser = new Array(<%= vet.size() + "" %>);
   var v_actmanager = new Array(<%= vet.size() + "" %>);
   var v_telephone = new Array(<%= vet.size() + "" %>);
   var v_wavno = new Array(<%= vet.size() + "" %>);
   var v_rsubindex = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Map)vet.get(i);
%>
   v_actno[<%= i + "" %>] = '<%= (String)hash.get("actno") %>';
   v_actname[<%= i + "" %>] = '<%= (String)hash.get("actname") %>';
   v_acttitle[<%= i + "" %>] = '<%= (String)hash.get("acttitle") %>';
   v_actcontent[<%= i + "" %>] = "<%= JspUtil.convert((String)hash.get("actcontent"))%>";
   v_startdate[<%= i + "" %>] = '<%= (String)hash.get("startdate") %>';
   v_enddate[<%= i + "" %>] = '<%= (String)hash.get("enddate") %>';
   v_responser[<%= i + "" %>] = '<%= (String)hash.get("responser") %>';
   v_actmanager[<%= i + "" %>] = '<%= (String)hash.get("actmanager") %>';
   v_telephone[<%= i + "" %>] = '<%= (String)hash.get("telephone") %>';
   v_wavno[<%= i + "" %>] = '<%= (String)hash.get("wavno") %>';
   v_rsubindex[<%= i + "" %>] = '<%= (String)hash.get("rsubindex") %>';
<%

            }
%>


   function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '')
         return;
      fm.actno.value = v_actno[index];
      fm.actname.value = v_actname[index];
      fm.acttitle.value = v_acttitle[index];
      fm.actcontent.value = v_actcontent[index];
      fm.startdate.value = v_startdate[index];
      fm.enddate.value = v_enddate[index];
      fm.responser.value = v_responser[index];
      fm.actmanager.value = v_actmanager[index];
      fm.telephone.value = v_telephone[index];
      fm.wavno.value = v_wavno[index];
      fm.oldrsubindex.value =v_rsubindex[index];
      fm.oldactno.value = v_actno[index];

   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.actno.value);
      if(value==''){
         //alert("请输入活动编号!");
         alert("Please input the activity number!");
         fm.actno.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
        // alert('活动编号必须是数字!');
         alert("The activity number must be a digital number!");
         fm.actno.focus();
         return flag;
      }
      var value = trim(fm.actname.value);
      if (value == '') {
         alert("The activity name can't be empty!");
         //alert('活动名称不能为空!');
         fm.actname.focus();
         return flag;
      }
      var value = trim(fm.acttitle.value);
      if (value == '') {
        // alert('活动主题不能为空!');
         alert('The activity title cannot be empty!');
         fm.acttitle.focus();
         return flag;
      }
      var value = trim(fm.actcontent.value);
      if (value == '') {
         //alert('活动内容不能为空!');
         alert('Active title cannot be empty!');
         fm.actcontent.focus();
         return flag;
      }
      if(parseInt(value.length) > 100){
        alert("The length of activity content cannot be larger than 100 bytes!");
       // alert("活动内容的长度不能超过50个汉字!");
        fm.actcontent.focus();
        return flag;
      }
      var value = trim(fm.startdate.value);
      if (value == '') {
         alert("Start date cannot be empty!");
         //alert('活动起始日期不能为空!');
         fm.startdate.focus();
         return flag;
      }
      var value = trim(fm.enddate.value);
      if (value == '') {
         alert("End date cannot be empty!");
        // alert('活动结束日期不能为空!');
         fm.enddate.focus();
         return flag;
      }
      var value = trim(fm.wavno.value);
      if(value==''){
         alert("Please input the wav number for the IVR!");
         //alert("请输入IVR中对应的音号!");
         fm.wavno.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
        // alert('IVR中对应的音号必须是数字!');
         alert("The wav number of IVR must be a digital number!");
         fm.wavno.focus();
         return flag;
      }
      var value = trim(fm.telephone.value);
      if(value==''){
         alert("Please input the Telephone number!");
         //alert("请输入IVR中对应的音号!");
         fm.telephone.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {

         alert("The Telephone number  must be a digital number!");
         fm.telephone.focus();
         return flag;
      }
      if (!CheckInputStr(fm.actcontent,'\u6D3B\u52A8\u5185\u5BB9')){
         fm.actcontent.focus();
         return flag;
      }

      flag = true;
      return flag;
   }

   function addInfo () {
      var fm = document.inputForm;
      if(!checkInfo())
        return;
      fm.op.value = 'add';
      fm.submit();
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(fm.infoList.length==0){
        // alert("对不起,您必须先配置活动专区铃音!");
         alert("Sorry,please configure the special active area ringtone first!");
         return;
      }
      if(index == -1){
          alert("Please select the special active area ringtone you want to edit!");
         // alert("请选择您要Edit的活动专区铃音");
          return;
      }
      if(!checkInfo())
        return;
      fm.op.value = 'edit';
      fm.submit();
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          //alert("请选择您删除的活动专区铃音");
          alert("Please select the specail active area ringtone you want to delete!");
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }
   function member () {
      fm = document.inputForm;
      if (trim(fm.actno.value) == '') {
         //alert('请先选择要管理的活动专区!');
          alert('Please select the special active area you want to manage!');
         return false;
      }
      document.URL = 'ringActiveMember.jsp?actno='+fm.actno.value;
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="700";
</script>
<form name="inputForm" method="post" action="ringActiveArea.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldrsubindex" value="">
<input type="hidden" name="oldactno" value="">
<table width="455" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Special <%=active_name%> area <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> management</td>
        </tr>
        <td align="center" width="44%">
             <select name="infoList" size="18" <%= vet.size() == 0 ? "disabled " : "" %> class="input-style1" style="width:200px" onclick="javascript:selectInfo()">
             <%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Map)vet.get(i);%>
                    <option value="<%= Integer.toString(i)%>"><%= (String)hash.get("actno") + "--------" + (String)hash.get("actname") %></option>
              <%}
             %>
             </select>
        </td>
        <td height='100%' width="53%">
            <table width="106%" border =0 class="table-style2" height='100%'>
            <tr>
             <td width="30%" align=right><%=active_name%> number</td>
             <td width="66%"><input type="text" name="actno" value="" maxlength="10" class="input-style1"></td>
            </tr>
            <tr>
             <td width="30%" align=right><%=active_name%> name</td>
             <td width="66%"><input type="text" name="actname" value="" maxlength="40" class="input-style1"></td>
            </tr>
            <tr>
             <td width="30%" align=right><%=active_name%> subject</td>
             <td width="66%"><input type="text" name="acttitle" value="" maxlength="100" class="input-style1"></td>
            </tr>
             <tr>
             <td width="30%" align=right><%=active_name%> content</td>
             <td width="66%"><textarea name="actcontent" class="input-style1" rows="3"></textarea></td>
            </tr>
			 <tr>
             <td width="30%" align=right>Start time</td>
             <td width="66%"><input type="text" name="startdate" value="" maxlength="20" class="input-style1"  readonly onclick="OpenDate(startdate);"></td>
            </tr>
			<tr>
             <td width="30%" align=right>End time</td>
             <td width="66%"><input type="text" name="enddate" value="" maxlength="20" class="input-style1" readonly onclick="OpenDate(enddate);"></td>
            </tr>
            <tr>
             <td width="30%" align=right>Sponsor</td>
             <td width="66%"><input type="text" name="responser" value="" maxlength="40" class="input-style1"  ></td>
            </tr>
            <tr>
             <td width="30%" align=right>Principal</td>
             <td width="66%"><input type="text" name="actmanager" value="" maxlength="20" class="input-style1"  ></td>
            </tr>
            <tr>
             <td width="30%" align=right>Telephone</td>
             <td width="66%"><input type="text" name="telephone" value="" maxlength="20" class="input-style1"  ></td>
            </tr>
            <tr>
             <td width="30%" align=right>IVR diaphone number</td>
             <td width="66%"><input type="text" name="wavno" value="" maxlength="9" class="input-style1"  ></td>
            </tr>
            <tr>
            <td colspan="2" align="center">
            <table border="0" width="100%" class="table-style2"  align="center">
              <tr>
              	<td width="20%" align="left">&nbsp;&nbsp;<img src="button/member.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:member()"></td>
                <td width="20%" align="left">&nbsp;<img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="20%" align="left">&nbsp;<img src="button/change.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <td align="left">&nbsp;<img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
              </tr>
            </table>
            </td>
            </tr>
            </table>
     </td>
     </tr>
     </table>
     <table border="0" width="100%" class="table-style2">
            <tr>
                <td class="table-styleshow" background="image/n-9.gif" height="26">
                  Notes:</td>
              </tr>
              <tr>
                <td style="color: #FF0000">1.<%=active_name%> number modify invalidity while modifying special active area.</td>
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
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no access to this function!");//Sorry,you have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
       e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occourred in the management of special active area!");//活动专区铃音管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        //vet.add("活动专区铃音管理过程出现错误!");
        vet.add("Error occourred in the management of special active area!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringActiveArea.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

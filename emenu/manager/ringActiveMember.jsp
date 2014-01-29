<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.ColorRing" %>
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
            for (; str.length() < 6; )
                str += "-";
            return str + (String)map.get("ringid");
        }
        catch (Exception e) {
            throw new Exception ("Obtain incorrect data!");//Obtain incorrect data!
        }
    }
%>
<html>
<head>
<title>Special active area ringtone management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String actno = request.getParameter("actno") == null ? "" : transferString((String)request.getParameter("actno")).trim();
    String rsubindex = request.getParameter("subindex") == null ? "" : transferString((String)request.getParameter("subindex")).trim();
    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
    String oldrsubindex = request.getParameter("oldrsubindex") == null ? "" : transferString((String)request.getParameter("oldrsubindex")).trim();
    String oldringid = request.getParameter("oldringid") == null ? "" : transferString((String)request.getParameter("oldringid")).trim();
    String ringindex = request.getParameter("ringindex") == null ? "" : transferString((String)request.getParameter("ringindex")).trim();
    try {
        ColorRing  colorring = new ColorRing();
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            HashMap map1= new HashMap();
            Map hash = null;
            int optype = 0;
            String title = "";
            if (op.equals("add")){
                optype = 1;
                title = "Add active ringtone";//增加活动铃音
            }
            else if (op.equals("del")) {
                optype = 2;
                title = "Delete active ringtone";//删除活动铃音
            }
            else if (op.equals("edit")) {
                optype = 3;
                title = "Modify active ringtone";//修改活动铃音
            }

            if(optype>0){
               map1.put("optype",optype+"");
               map1.put("ringid",oldringid);
               map1.put("oldrsubindex",oldrsubindex);
               map1.put("rsubindex",rsubindex);
               map1.put("actno",actno);
               map1.put("ringindex",ringindex);
               rList = sysring.setActiveRing(map1);

                // 准备写操作员日志
                if(getResultFlag(rList)){
                  zxyw50.Purview purview = new zxyw50.Purview();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","217");
                  map.put("RESULT","1");
                  map.put("PARA1",oldringid);
                  map.put("PARA2",oldrsubindex);
                  map.put("PARA3",actno);
                  map.put("PARA4","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",title);
                  purview.writeLog(map);
                }
               if(rList.size()>0){
                 session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="ringActiveMember.jsp?actno=<%= actno %>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
            }
            List vet = null;
            vet = sysring.getActiveRingInfo(Integer.parseInt(actno));
 %>
<script language="javascript">
   var v_actno = new Array(<%= vet.size() + "" %>);
   var v_rsubindex = new Array(<%= vet.size() + "" %>);
   var v_ringindex = new Array(<%= vet.size() + "" %>);
   var v_ringid = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Map)vet.get(i);
%>
   v_actno[<%= i + "" %>] = '<%= (String)hash.get("actno") %>';
   v_rsubindex[<%= i + "" %>] = '<%= (String)hash.get("rsubindex") %>';
   v_ringindex[<%= i + "" %>] = '<%= (String)hash.get("ringindex") %>';
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
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
      fm.ringid.value = v_ringid[index];
      fm.ringlabel.value = v_ringlabel[index];
      fm.rsubindex.value = v_rsubindex[index];
      fm.oldrsubindex.value =v_rsubindex[index];
      fm.subindex.value = v_rsubindex[index];
      fm.oldringid.value = v_ringid[index];
      fm.ringindex.value = v_ringindex[index];
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.ringid.value);
      if(value==''){
        // alert("请输入Ringtone code!");
          alert("Please input the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code!");
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
        // alert('Ringtone code必须是数字!');
         alert("<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code must be a digital number!");
         fm.ringid.focus();
         return flag;
      }
      var value = trim(fm.rsubindex.value);
      if(value==''){
         //alert("请输入铃音序号!");
         alert("Please input the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> serial number!");
         fm.rsubindex.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> serial number must be a digital number!');
        // alert('铃音序号必须是数字!');
         fm.rsubindex.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function addInfo () {
     window.open('ringActiveAreaMemberAdd.jsp','ringActiveAreaAdd','width=400, height=280,top='+((screen.height-280)/2)+',left='+((screen.width-400)/2));
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(fm.infoList.length==0){
        // alert("对不起,您必须先配置活动铃音!");
         alert("Sorry,you must configure the activity <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> first!");
         return;
      }
      if(index == -1){
         // alert("请选择您要Edit的活动铃音!");
          alert("Please select the activity <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> you want to edit!");
          return;
      }
     var editURL = 'ringActiveAreaMemberMod.jsp?ringid=' +fm.ringid.value +'&ringlabel='+fm.ringlabel.value + '&rsubindex='+fm.oldrsubindex.value +'&actno='+fm.actno.value;
     window.open(editURL,'ringActiveAreaEdit','width=400, height=300,top='+((screen.height-300)/2)+',left='+((screen.width-400)/2));
   }



   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          //alert("请选择您删除的活动铃音");
          alert("Please select the active <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> you want to delete!");
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }

   function getAddInfo (ringid,subindex) {
     var fm = document.inputForm;
     fm.oldrsubindex.value = subindex;
     fm.subindex.value = subindex;
     fm.oldringid.value = ringid;
     fm.op.value = 'add';
     fm.submit();
   }
   function getEditInfo (ringid,subindex) {
     var fm = document.inputForm;
     fm.oldrsubindex.value = subindex;
     fm.oldringid.value = ringid;
     fm.op.value = 'edit';
     fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="ringActiveMember.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldrsubindex" value="">
<input type="hidden" name="oldringid" value="">
<input type="hidden" name="actno" value="<%=actno%>">
<input type="hidden" name="ringindex" value="">
<input type="hidden" name="subindex" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> management of activity area</td>
        </tr>
        <td align="center">
             <select name="infoList" size="8" <%= vet.size() == 0 ? "disabled " : "" %> class="input-style1" style="width:200px" onclick="javascript:selectInfo()">
             <%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Map)vet.get(i);
                    %><option value= "<%=Integer.toString(i)%>"><%= (String)hash.get("ringid") + "----" + (String)hash.get("ringlabel") %></option>
              <%}
             %>
             </select>
        </td>
        <td height='100%'>
            <table width="100%" border =0 class="table-style2" height='100%'>
            <tr>
             <td width="30%" align=right >Rank serial number</td>
             <td><input type="text" name="rsubindex" value="" maxlength="6" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right ><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
             <td><input type="text" name="ringlabel" value="" maxlength="6" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
             <td><input type="text" name="ringid" value="" maxlength="20" class="input-style1" disabled ></td>
            </tr>
            <tr>
            <td colspan="2" align="center">
              <table border="0" width="100%" class="table-style2"  align="center">
              <tr>
                <td width="20%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="20%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
                <td width="20%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="25%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
                <td width="20%" align="center"><a href="ringActiveArea.jsp"><img src="button/back.gif" onmouseover="this.style.cursor='hand'" border="0"></a></td>
              </tr>
              </table>
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
                    alert( "Please log in to the system first!");
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
        sysInfo.add(sysTime + operName + " exception occourred in the management of special active area ringtone! ");//活动专区铃音管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
         vet.add("Error occourred in the management of special active area ringtone!");
       // vet.add("活动专区铃音管理过程出现错误!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringActiveMember.jsp?actno=<%= actno %>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

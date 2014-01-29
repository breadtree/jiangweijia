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
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data
        }
    }
%>
<html>
<head>
<title>Manage latest recommended ringtones</title>
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
    try {
        ColorRing  colorring = new ColorRing();
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-7") != null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            HashMap map1= new HashMap();
            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String oldrsubindex = request.getParameter("oldrsubindex") == null ? "" : transferString((String)request.getParameter("oldrsubindex")).trim();
            String oldringid = request.getParameter("oldringid") == null ? "" : transferString((String)request.getParameter("oldringid")).trim();
            int optype = 0;

            String title = "";
            if (op.equals("add")){
                optype = 1;
                title = "Add new ringtones";//增加推荐铃音
            }
            else if (op.equals("del")) {
                optype = 2;
                title = "Delete new ringtones";//删除推荐铃音
            }
            else if (op.equals("edit")) {
                optype = 3;
                title = "Modify new ringtones";//修改推荐铃音
            }

            int newboardtype = zte.zxyw50.util.CrbtUtil.getConfig("ifnewreleases",7);
            if(newboardtype==1){
        		newboardtype=150;
        	}
        	else{
        		newboardtype=7;//7==5;
        	}
            if(optype>0){            	
               map1.put("optype",optype+"");
               map1.put("ringid",oldringid);
               map1.put("rsubindex",oldrsubindex);
	       	   map1.put("boardtype",newboardtype+"");//boardtype=150 or 5 new hits
               rList = sysring.setRecommend(map1);

                // 准备写操作员日志
                if(getResultFlag(rList)){
                  zxyw50.Purview purview = new zxyw50.Purview();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","209");
                  map.put("RESULT","1");
                  map.put("PARA1",oldringid);
                  map.put("PARA2",oldrsubindex);
                  map.put("PARA3","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",title);
                  purview.writeLog(map);
                }
               if(rList.size()>0){
                 session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="newReleases.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
<%     }
    }
    List vet = null;
    vet = sysring.ringSortBoard(newboardtype);
 %>
<script language="javascript">
   var v_ringid = new Array(<%= vet.size() + "" %>);
   var v_rsubindex = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Map)vet.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_rsubindex[<%= i + "" %>] = '<%= (String)hash.get("rsubindex") %>';
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
      fm.oldringid.value = v_ringid[index];
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
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

   function addInfo () {
     window.open('ringRecommendAdd.jsp','ringRecommendAdd','width=400, height=280,top='+((screen.height-280)/2)+',left='+((screen.width-400)/2));
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(fm.infoList.length==0){
         alert("Sorry. You must configure recommended <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s first!");//对不起,您必须先配置推荐铃音!
         return;
      }
      if(index == -1){
          alert("Please select the recommended <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be edited");//请选择您要Edit的推荐铃音
          return;
      }
     var editURL = 'ringRecommendMod.jsp?ringid=' +fm.ringid.value +'&ringlabel='+fm.ringlabel.value + '&rsubindex='+fm.oldrsubindex.value;
     window.open(editURL,'ringRecommendEdit','width=400, height=300,top='+((screen.height-300)/2)+',left='+((screen.width-400)/2));
   }



   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the recommended <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be deleted");//请选择您删除的推荐铃音
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }

   function getAddInfo (ringid,subindex) {
     var fm = document.inputForm;
     fm.oldrsubindex.value = subindex;
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
<form name="inputForm" method="post" action="newReleases.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldrsubindex" value="">
<input type="hidden" name="oldringid" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Manage New <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s</td>
        </tr>
        <td align="center">
             <select name="infoList" size="8" <%= vet.size() == 0 ? "disabled " : "" %> class="input-style1" style="width:200px" onclick="javascript:selectInfo()">
             <%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Map)vet.get(i);
                    out.println("<option value="+Integer.toString(i)+" >" +display(hash)+" </option>");
              }
             %>
             </select>
        </td>
        <td height='100%'>
            <table width="100%" border =0 class="table-style2" height='100%'>
            <tr>
             <td width="30%" align=right >Queue number</td>
             <td><input type="text" name="rsubindex" value="" maxlength="6" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right ><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+ zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
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
                   alert( "Sorry. You have no permission for this function!");//Sorry,you have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in managing the latest recommended ringtones!");//最新推荐铃音管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing the latest recommended ringtones!");//最新推荐铃音管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="newReleases.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

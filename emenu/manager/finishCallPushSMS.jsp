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
            String str = (String)map.get("ringid");
            str += "--";
            return str + (String)map.get("ringlabel");
        }
        catch (Exception e) {
            throw new Exception ("Incorrect data obtained!");//Obtain incorrect data
        }
    }
%>
<html>
<head>
<title>Finished Call Push SMS</title>
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
        if (operID != null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            HashMap map1= new HashMap();
            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            //String oldrsubindex = request.getParameter("oldrsubindex") == null ? "" : transferString((String)request.getParameter("oldrsubindex")).trim();
            String sRingid = request.getParameter("sRingid") == null ? "" : transferString((String)request.getParameter("sRingid")).trim();
			
            int optype = 0;

            String title = "";
            if (op.equals("add")){
                optype = 1;
                title = "Add Call Push SMS";
            }
            else if (op.equals("del")) {
                optype = 2;
                title = "Delete Call Push SMS";
            }
            else if (op.equals("edit")) {
                optype = 3;
                title = "Modify Call Push SMS";
            }

            if(optype>0){
               map1.put("optype",optype+"");
               map1.put("ringid",sRingid);
               map1.put("rsubindex","0");//using old method so passing rsubindex as 0. It does not have any meaning.
		       map1.put("boardtype","157");
               rList = sysring.setRecommend(map1);

			if(getResultFlag(rList)){
                  zxyw50.Purview purview = new zxyw50.Purview();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","209"); // TO-DO change the opertype
                  map.put("RESULT","1");
                  map.put("PARA1",sRingid);
                  map.put("PARA2","");
                  map.put("PARA3","ip:"+request.getRemoteAddr());
                  map.put("DESCRIPTION",title);
                  purview.writeLog(map);
                }
               if(rList.size()>0){
                 session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="finishCallPushSMS.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }


            }
            List vet = null;
            vet = sysring.ringSortBoard(157);
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
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please enter the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code!");
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code must be a digital number!');
         fm.ringid.focus();
         return flag;
      }
      flag = true;
      return flag;
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the  <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be deleted"); 
          return;
      }
	 fm.sRingid.value = fm.ringid.value;
     fm.op.value = 'del';
     fm.submit();
   }

   function getAddInfo () {
     var fm = document.inputForm;
     //fm.oldrsubindex.value = subindex;
	 if(fm.ringid.value == "")
	 {
	   alert("Please select the ringtone first ");
	   return;
	 }
     fm.sRingid.value = fm.ringid.value;
     fm.op.value = 'add';
     fm.submit();
   }
   
   function queryInfo() {
      var result =  window.showModalDialog('ringSearch.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       document.inputForm.ringid.value=result;
       document.inputForm.ringlabel.value='';
     }
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="400";
</script>
<form name="inputForm" method="post" action="finishCallPushSMS.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldrsubindex" value="">
<input type="hidden" name="sRingid" value=""> 
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Finish Call Push SMS</td>
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
            <!--<tr>
             <td width="30%" align=right >Queue number</td>
             <td><input type="text" name="rsubindex" value="" maxlength="6" class="input-style1"  disabled ></td>
            </tr>-->
            <tr>
             <td width="30%" align=right ><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> Title</td>
             <td><input type="text" name="ringlabel" value="" maxlength="6" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
             <td><input type="text" name="ringid" value="" maxlength="20" class="input-style1" disabled ><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:queryInfo()"></td>
            </tr>
            <tr>
            <td colspan="2" align="center">
              <table border="0" width="100%" class="table-style2"  align="center">
              <tr>
                <td width="25%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:getAddInfo()"></td>
                <!--<td width="25%" align="center"><img src="button/edit.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:editInfo()"></td> -->
                <td width="25%" align="center"><img src="button/del.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:delInfo()"></td>
                <td width="25%" align="center"><img src="button/again.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:document.inputForm.reset()"></td>
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
        sysInfo.add(sysTime + operName + " Exception occurred in managing the Finished Call Push SMS!");//最新推荐铃音管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing the Finished Call Push SMS!");//最新推荐铃音管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="finishCallPushSMS.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

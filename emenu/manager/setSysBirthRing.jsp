<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.*" %>
<%@ page import="java.io.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<%!
     public String display (Map map) throws Exception {
        try {
            String str = (String)map.get("ringid") + "--" + (String)map.get("ringlable");
            return str;
        }
        catch (Exception e) {
            throw new Exception ("Obtain incorrect data.");//Obtain incorrect data!
        }
    }
%>
<html>
<head>
<title>Set system present ringtone</title>
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
        if (operID != null && purviewList.get("2-29") != null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            Hashtable map1= new Hashtable();
            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
            String rsubindex = "0";
            String oldrsubindex = request.getParameter("oldrsubindex") == null ? "" : transferString((String)request.getParameter("oldrsubindex")).trim();
            String oldringid = request.getParameter("oldringid") == null ? "" : transferString((String)request.getParameter("oldringid")).trim();
            int optype = 0;
            String title = "";
            String opcode = "1";
            if (op.equals("add")){
                optype = 1;
                title = "Add birthday present ringtone";
            }
            else if (op.equals("del")) {
                optype = 2;
                opcode = "2";
//                ringid  = oldringid;
//                rsubindex = oldrsubindex;
                title = "Delete birthday present ringtone";
            }
            if(optype>0){
               map1.put("ringid",ringid);
               map1.put("type","100");
               map1.put("opcode",opcode);
               map1.put("para1","0");
               map1.put("newringid","0");
               rList = sysring.setSysDefaultRing(map1);
               // 准备写操作员日志
               if(getResultFlag(rList)){
                 zxyw50.Purview purview = new zxyw50.Purview();
                 map.put("OPERID",operID);
                 map.put("OPERNAME",operName);
                 map.put("OPERTYPE","215");
                 map.put("RESULT","1");
                  map.put("PARA1",ringid);
                 map.put("PARA2",rsubindex);
                 map.put("PARA3","ip:"+request.getRemoteAddr());
                 map.put("DESCRIPTION",title);
                 purview.writeLog(map);
               }
               if(rList.size()>0){
                session.setAttribute("rList",rList);
              %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="setSysBirthRing.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }


            }
            List vet = null;
            vet = sysring.querySysDefaultRing(100);//query birthday ring
            String str_label="",str_id="";
            if(vet.size()>0){
              hash = (Map)vet.get(0);
              str_label=(String)hash.get("ringlable");
              str_id=(String)hash.get("ringid");
            }
 %>
<script language="javascript">
   var v_ringid = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
   var v_rsubindex = new Array(<%= vet.size() + "" %>);

<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Map)vet.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlable") %>';
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
      fm.ringid.value = v_ringid[index];
      fm.ringlabel.value = v_ringlabel[index];
//      fm.rsubindex.value = v_rsubindex[index];
      fm.oldrsubindex.value =v_rsubindex[index];
      fm.oldringid.value = v_ringid[index];
   }

   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var value = trim(fm.ringid.value);
      if(value==''){
         alert("Please input tone code!");
         fm.ringid.focus();
         return flag;
      }
      if (!checkstring('0123456789',value)) {
         alert('The tone code must be in the digit format!');
         fm.ringid.focus();
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
   function queryInfo() {
	var result =  window.showModalDialog('ringSearch.jsp?hidemediatype=1&mediatype=1',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       document.inputForm.ringid.value=result;
      }
     }
   

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the birthday present <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be deleted");
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
<form name="inputForm" method="post" action="setSysBirthRing.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldrsubindex" value="">
<input type="hidden" name="oldringid" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Set birthday <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
        </tr>
        <td align="center">
             <select name="infoList" size="5" <%= vet.size() == 0 ? "disabled " : "" %> class="input-style1" style="width:200px" onclick="javascript:selectInfo()">
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
             <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></td>
             <td><input type="text" name="ringlabel" value="<%=str_label%>" maxlength="40" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
             <td><input type="text" name="ringid" value="<%=str_id%>" maxlength="20" class="input-style1"  ><img src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()">
             </td>
            </tr>
            <tr>
                <!--
             <td  style="color: #FF0000" colspan=2 height=30> &nbsp;&nbsp;Note: "Sequence number" is the character string in the digit format. </td>
             -->
            </tr>
            <tr>
            <td colspan="2" align="center">
              <table border="0" width="100%" class="table-style2"  align="center">
              <tr>
                <td width="50%" align="center"><img src="button/sure.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                  <!--
                <td width="50%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                  -->
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
                   alert("Sorry,you have no access to this function!");//Sorry,you have no access to this function!
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "It is abnormal during the setting of birthday present tone!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the setting of birthday present tone!");//设置系统赠送铃音过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="setSysBirthRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

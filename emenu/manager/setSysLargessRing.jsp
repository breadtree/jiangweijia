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
        manSysPara syspara = new manSysPara();
        Vector vet1 = syspara.getUserTypeInfo("1");
        String option="";
        for(int i=0;i<vet1.size();i++){
          Hashtable table = (Hashtable)vet1.elementAt(i);
          option +="<option value=" + (String)table.get("usertype") + " > " + (String)table.get("utlabel")+ " </option>";
        }
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-15") != null) {
            ArrayList rList = new ArrayList();
            HashMap map = new HashMap();
            Hashtable map1= new Hashtable();
            Map hash = null;
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
            String usertype = request.getParameter("usertype") == null ? "" : transferString((String)request.getParameter("usertype")).trim();
            String rsubindex = "0";
            String oldrsubindex = request.getParameter("oldrsubindex") == null ? "" : transferString((String)request.getParameter("oldrsubindex")).trim();
            String oldringid = request.getParameter("oldringid") == null ? "" : transferString((String)request.getParameter("oldringid")).trim();
			String userIndex = request.getParameter("userIndex") == null ? "" : transferString((String)request.getParameter("userIndex")).trim();
            int optype = 0;
            String title = "";
            String opcode = "1";
            if (op.equals("add")){
                optype = 1;
                title = "Add system present ringtone";
            }
            else if (op.equals("del")) {
                optype = 2;
                opcode = "2";
//                ringid  = oldringid;
//                rsubindex = oldrsubindex;
                title = "Delete system present ringtone";
            }
            if(optype>0){
               map1.put("ringid",ringid);
               map1.put("type","1");
               map1.put("opcode",opcode);
               map1.put("para1",usertype);
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
<input type="hidden" name="historyURL" value="setSysLargessRing.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }


            }
            List vet = null;
			if(op.equals("search"))
			{
			    vet = sysring.queryUserDefaultRing(1,usertype);
			}
			else
			{vet = sysring.querySysDefaultRing(1);//系统赠送铃音
			}
 %>
<script language="javascript">
   var v_ringid = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
   var v_rsubindex = new Array(<%= vet.size() + "" %>);
   var v_usertype = new Array(<%= vet.size() + "" %>);

<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Map)vet.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlable") %>';
   v_rsubindex[<%= i + "" %>] = '<%= (String)hash.get("rsubindex") %>';
   v_usertype[<%= i + "" %>] = '<%= (String)hash.get("para1") %>';
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
      fm.usertype.value = v_usertype[index];
//      fm.rsubindex.value = v_rsubindex[index];
      fm.oldrsubindex.value =v_rsubindex[index];
      fm.oldringid.value = v_ringid[index];
   }

   function SearchUserRing () {
      var fm = document.inputForm;
      fm.op.value = "search";
      fm.userIndex.value = fm.usertype.selectedIndex;
      fm.submit();
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
	 /* var result =  window.open('ringSearch.jsp?hidemediatype=1&mediatype=1','mywin','left=20,top=20,width=600,height=550,toolbar=1,resizable=0,scrollbars=yes');
	 return;*/
   }

   function editInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(fm.index.length==0){
         alert("Sorry, you must configure the system present tone firstly!");//对不起,您必须先配置系统赠送铃音!
         return;
      }
      if(index == -1){
          alert("Please select the system present tone to be edited!");//请选择您要Edit的系统赠送铃音
          return;
      }
      if(!checkInfo())
        return;
      fm.submit();
      fm.op.value = 'edit';
   }

   function delInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.selectedIndex;
      if(index == -1){
          alert("Please select the system present ringtone to be deleted");
          return;
      }
     fm.op.value = 'del';
     fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="setSysLargessRing.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="oldrsubindex" value="">
<input type="hidden" name="oldringid" value="">
<input type="hidden" name="userIndex" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">New Subscriber Free <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
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
             <td width="30%" align=right><span title="User type">Type</span></td>
             <td>
              <select name="usertype" size="1"  class="input-style1" onchange="javascript:SearchUserRing()">
                 <% out.print(option); %>
           </select>
             </td>
            </tr>
            <tr>
             <td width="30%" align=right><span title="Ringtone name"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringName","name")%></span></td>
             <td><input type="text" name="ringlabel" value="" maxlength="40" class="input-style1"  disabled ></td>
            </tr>
            <tr>
             <td width="30%" align=right><span title="Ringtone code">Code</span></td>
             <td><input type="text" name="ringid" value="" readonly="readonly" maxlength="20" class="input-style1"  ><img src="../image/query.gif" alt="Click here,browse and select"  onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()">
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
                <td width="34%" align="center"><img src="button/add.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
                <td width="33%" align="center"><img src="button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delInfo()"></td>
                <td width="33%" align="center"><img src="button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
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
<script>

 document.inputForm.usertype.selectedIndex = '<%= userIndex %>';
</script>
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
        sysInfo.add(sysTime + operName + "It is abnormal during the setting of system present tone!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the setting of system present tone!");//设置系统赠送铃音过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="setSysLargessRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
   private Vector StrToVector(String str){
	  int index = 0;
	  String  temp = str;
	  String  temp1 ="";
	  Vector ret = new Vector();

	  if (str.length() ==0)
	      return ret;
	  index = str.indexOf("|");
   	  while(index > 0){
	      temp1 = temp.substring(0,index);
		  if(index < temp.length())
		     temp = temp.substring(index+1);
		  ret.addElement(temp1);
		  index = 0;
		  if (temp.length() > 0)
		    index  = temp.indexOf("|");
	  }
	  return ret;
  }

%>
<html>
<head>
<title>Transfer system ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body background="background.gif" class="body-style1">
<%
     //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    //add end
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        if (operID != null && purviewList.get("2-5") != null) {
           //modify by gequanmin 2005-07-05
          String ringlibid1="";
          String ringlibid2="";
          String Pos1="";
          String Pos2="";
          if("1".equals(usedefaultringlib)){
          ringlibid1 = request.getParameter("ringlibid1") == null ? "503" : transferString((String)request.getParameter("ringlibid1")).trim();
          ringlibid2 = request.getParameter("ringlibid2") == null ? "503" : transferString((String)request.getParameter("ringlibid2")).trim();
          Pos1 = request.getParameter("Pos1") == null ? "Default "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " library" : transferString((String)request.getParameter("Pos1")).trim();
          Pos2 = request.getParameter("Pos2") == null ? "Default "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+ " library" : transferString((String)request.getParameter("Pos2")).trim();
          }else{
          ringlibid1 = request.getParameter("ringlibid1") == null ? "" : transferString((String)request.getParameter("ringlibid1")).trim();
          ringlibid2 = request.getParameter("ringlibid2") == null ? "" : transferString((String)request.getParameter("ringlibid2")).trim();
          Pos1 = request.getParameter("Pos1") == null ? "" : transferString((String)request.getParameter("Pos1")).trim();
          Pos2 = request.getParameter("Pos2") == null ? "" : transferString((String)request.getParameter("Pos2")).trim();
          }
           String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
           if(op.equals("move")){  //铃音迁移
              String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
              String ringlibid = request.getParameter("ringlibid") == null ? "" : transferString((String)request.getParameter("ringlibid")).trim();
              //System.out.println("move:ringid="+ringid);
              //System.out.println("move:ringlibid="+ringlibid);
              Vector vetRing = StrToVector(ringid);
              String mode = request.getParameter("mode");
  %>
<script language="javascript">
   function onBack() {
      var fm = document.inputForm;
      fm.op.value ="";
      fm.submit();
   }
   function searchRing () {
      fm = document.inputForm;
      fm.submit();
   }

</script>

<form name="inputForm" method="post" action="ringMove.jsp">
<input type="hidden" name="ringlibid1" value="<%= ringlibid1 %>">
<input type="hidden" name="ringlibid2" value="<%= ringlibid2 %>">
<input type="hidden" name="Pos1" value="<%= Pos1 %>">
<input type="hidden" name="Pos2" value="<%= Pos2 %>">
<input type="hidden" name="op" value="">

 <table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
 <tr>
    <td><img src="image/004.gif" width="346" height="15"></td>
 </tr>
 <tr >
    <td background="image/006.gif">
    <table width="340" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
    <td align="center" >
      <%
         if(mode.equals("1")){
      %>
        <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> transferred from "<%= Pos1  %>" to "<%= Pos2 %>"
     <%
      }
         else
         {
      %>
       <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> transferred from "<%= Pos2  %>" to "<%= Pos1 %>"
      <% } %>
   </td>
   </tr>
   <tr>
   <td align="center">
      <table width="90%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
      <tr class="tr-ringlist">
        <td width="20%" align="center">Serial number</td>
        <td width="20%" align="center" ><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> No.</td>
        <td width="10%" align="center" >SCP</td>
        <td width="50%" align="center">Execution result</td>
      </tr>

      <%
         ArrayList  rList = new ArrayList();
         Hashtable stmp =  null;
         zxyw50.Purview purview = new zxyw50.Purview();
         for(int i=0;i<vetRing.size();i++){
           ringid = vetRing.get(i).toString();
           rList = sysring.ringMove(ringid,ringlibid);
           for(int j=0;j<rList.size();j++){
             String color = j == 0 ? "E6ECFF" :"#FFFFFF" ;
             stmp = (Hashtable)rList.get(j);
             out.print("<tr bgcolor='"+color+"'>");
             if(j==0){
                out.print("<td align=center>"+Integer.toString(i+1)+"</td>");
                out.print("<td >"+ringid+"</td>");
             }
             else{
                 out.print("<td >&nbsp;</td>");
                 out.print("<td >&nbsp;</td>");
             }
             out.print("<td >" + (String)stmp.get("scp")+ "</td>");
             String sRet = (String)stmp.get("result");
             if(sRet.equals("0"))
                out.print("<td  align=center>Success</td>");
             else
                out.print("<td align=center >Failure ," + (String)stmp.get("reason") +"</td>");
             out.print("</tr>");
           }
           if(getResultFlag(rList)){
              HashMap map = new HashMap();
              map.put("OPERID",operID);
              map.put("OPERNAME",operName);
              map.put("OPERTYPE","204");
              map.put("RESULT","1");
              map.put("PARA1",ringid);
              map.put("PARA2",ringlibid);
              map.put("PARA3","ip:"+request.getRemoteAddr());
              sysInfo.add(sysTime + operName + " transfer ringtone " + ringid +"successfully");//迁移铃音成功
               purview.writeLog(map);
           }
           else
               sysInfo.add(sysTime + operName + " transfer ringtone " + ringid + "failed");//迁移铃音失败
        }
      %>

      </table>
      <tr>
      <td align="center" >
          <img src="button/back.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:onBack()">
      </td>
      </tr>
  </table>
  <tr>
     <td><img src="image/005.gif" width="346" height="15"></td>
  </tr>
 </table>
 </td>
 </tr>
 </table>
</form>
<%
       }
       else {
            Vector vetRing1 = new Vector();
            Vector vetRing2 = new Vector();
            Hashtable hash = new Hashtable();

            // 查询系统铃音
            //modify by gequanmin 2005-07-05
            if((!ringlibid1.equals("")) &&(ringlibid1!=null)){
              vetRing1 = sysring.getSysRing(ringlibid1);
            }
            if((!ringlibid2.equals("")) &&(ringlibid2!=null)){
              vetRing2 = sysring.getSysRing(ringlibid2);
            }
%>
<script language="javascript">

   function searchRing () {
      fm = document.inputForm;
      fm.submit();
   }

   function tryListen () {
      fm = document.inputForm;
      if (fm.crid.value == '') {
         alert('Please select a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> before preview!');//请先选择铃音,再试听!
         return;
      }
      var tryURL = 'tryListen.jsp?ringid=' + fm.crid.value;
      preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
   }

   function onMoveDown(){
       fm = document.inputForm;
       if(fm.personalRing1.selectedIndex==-1){
          alert("Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be transferred!");//请选择您要迁移的铃音
          return ;
       }
       if(fm.ringlibid2.value==''){
          alert("Please select the category position where the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> will be placed!");//请选择该铃音放置分类位置
          return ;
       }

       if(fm.ringlibid1.value== fm.ringlibid2.value){
          alert("No transfer is allowed in the same category!");//同一分类间不允许转移
          return ;
       }

       var ringid = '';
       var len = fm.personalRing1.length;
       for(var i=0;i<len;i++){
           if(fm.personalRing1.options[i].selected)
              ringid = ringid + fm.personalRing1.options[i].value +"|";
       }
       document.inputForm.op.value='move';
       document.inputForm.mode.value='1';

       fm.ringid.value= ringid;
       fm.ringlibid.value = fm.ringlibid2.value;
       document.inputForm.submit();
   }

   function onMoveUp(){
       fm = document.inputForm;
       if(fm.personalRing2.selectedIndex==-1){
          alert("Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be transferred!");//请选择您要迁移的铃音
          return ;
       }
       if(fm.ringlibid1.value==''){
          alert("Please select the category position where the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> will be placed!");//请选择该铃音放置分类位置
          return ;
       }
       if(fm.ringlibid1.value== fm.ringlibid2.value){
          alert("No transfer is allowed in the same category!");//同一分类间不允许转移
          return ;
       }

       var ringid = '';
       var len = fm.personalRing2.length;
       for(var i=0;i<len;i++){
           if(fm.personalRing2.options[i].selected)
              ringid = ringid + fm.personalRing2.options[i].value +"|";
       }
       document.inputForm.op.value='move';
       fm.ringid.value= ringid;
       document.inputForm.mode.value='2';
       fm.ringlibid.value = fm.ringlibid1.value;
       document.inputForm.submit();
   }


</script>
<form name="inputForm" method="post" action="ringMove.jsp">
<input type="hidden" name="ringlibid1" value="<%= ringlibid1 %>">
<input type="hidden" name="ringlibid2" value="<%= ringlibid2 %>">
<input type="hidden" name="ringlibid" value="">
<input type="hidden" name="ringid" value="">
<input type="hidden" name="Pos1" value="<%= Pos1 %>">
<input type="hidden" name="Pos2" value="<%= Pos2 %>">
<input type="hidden" name="mode" value="1">
<input type="hidden" name="op" value="">

<table width="100%"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
<tr>
    <td align="center">
        <table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
          <tr>
    <td><img src="image/004.gif" width="346" height="15"></td>
    </tr>
    <tr >
    <td background="image/006.gif" align="center" class="table-style2">
        <table width="340" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
        <tr valign="top">
        <tr>
           <td height=20>
             Current category:<%= Pos1 %>
           </td>
        </tr>
        <tr>
        <td colspan="2"  align="center">
            <select name="personalRing1" size="12" <%= vetRing1.size() == 0 ? "disabled " : "" %> class="input-style1" style="width: 240;" multiple>
<%
                Hashtable tmp = new Hashtable();
                for (int i = 0; i < vetRing1.size(); i++) {
                    tmp = (Hashtable)vetRing1.get(i);
%>
               <option value="<%= (String)tmp.get("ringid") %>"><%= (String)tmp.get("ringid") + "---" + (String)tmp.get("ringlabel") %></option>
<%
                }
%>
            </select>
          </td>
        </tr>
        </table>
     </td>
     <tr>
     <td><img src="image/005.gif" width="346" height="15"></td>
     </tr>
     </table>
     <tr>
     <td height=30>&nbsp;

     </td>
     </tr>
     <tr>
     <td align="center">
        <table border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0" >
        <tr>
        <td style="color: #FF0000" align="center" >
           Use the Ctrl or Shift key to select multiple lines of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s to be transferrred
           <br/><br/>
        </td>
        <tr>
        <td align="center" >
           <img src="button/down.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:onMoveDown()">
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           <img src="button/up.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:onMoveUp()">
        </td>
        </tr>
        </table>
     </td>
     </tr>
     <tr>
     <td height=30>&nbsp;

     </td>
     </tr>
     <tr>
     <td height=10>
        <table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
          <tr>
     <td><img src="image/004.gif" width="346" height="15"></td>
     </tr>
     <tr >
     <td background="image/006.gif">
          <table width="340" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
          <tr>
             <td colspan=2  >Current category:<%= Pos2 %></td>
          </tr>
          <tr>
          <td colspan="2"  align="center">
              <select name="personalRing2" size="12" <%= vetRing2.size() == 0 ? "disabled " : "" %> class="input-style1" style="width: 240;" multiple>
<%
                for (int i = 0; i < vetRing2.size(); i++) {
                    tmp = (Hashtable)vetRing2.get(i);
%>
               <option value="<%= (String)tmp.get("ringid") %>"><%= (String)tmp.get("ringid") + "---" + (String)tmp.get("ringlabel") %></option>
<%
                }
%>
              </select>
           </td>
           </tr>
          </table>
    </td>
    </tr>
    <tr>
     <td><img src="image/005.gif" width="346" height="15"></td>
     </tr>
    </table>
</td>
</tr>
</table>
</form>
<%
        }
       }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    parent.document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + "Exception occurred in transferring system ringtones!");//系统铃音转移过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + "Error occurred in transferring system ringtones!");//系统铃音转移过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="ringMove.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

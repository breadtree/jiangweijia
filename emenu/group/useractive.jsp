<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.group.dataobj.*" %>
<%@ page import="zxyw50.group.context.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ include file="../sParam.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!    private Vector StrToVector(String str){
	  int index = 0;
	  String  temp = str;
	  String  temp1 ="";
	  Vector ret = new Vector();
	  if (str.length() ==0)
	      return ret;
	  index = str.indexOf("|");
   	  while(index >= 0){
	      if(index==0)
	         temp1 = "&nbsp;";
	      else
	         temp1 = temp.substring(0,index);
	      ret.addElement(temp1);
		  if(index < temp.length())
		     temp = temp.substring(index+1);
		  else
		     break;
		  index = 0;
		  if (temp.length() > 0)
		     index  = temp.indexOf("|");
	  }
	  return ret;
  }

%>
<html>
<head>
<title>Group user activating/suspending</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">

<%
          String sysTime = "";
          int optype = 0;
          String desc = null;
          String title = null;
          ArrayList rList = null;
          Hashtable hash = new Hashtable();
          String operID = (String) session.getAttribute("OPERID");
          String operName = (String) session.getAttribute("OPERNAME");
          manSysPara syspara = new manSysPara();
          String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
          String groupid;
          String groupindex;
          String groupname;
          String oper_type="";
        if (mode.equals("manager")){
        groupindex = request.getParameter("groupindex") == null ? "" : request.getParameter("groupindex");
        groupid = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
        groupname = request.getParameter("groupname") == null ? "" : transferString(request.getParameter("groupname"));
        oper_type="1121";
      }else{
        groupindex = (String)session.getAttribute("GROUPINDEX");
        groupid = (String)session.getAttribute("GROUPID");
        groupname =  (String)session.getAttribute("GROUPNAME");
        oper_type="2004";
       }
        Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	String errMsg = "";
        Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    try {
        Vector vet=new Vector();
        HashMap hash1 = new HashMap();
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        boolean blexist = false;
        //权限 code需要修改/同group目录下index.jsp中的权限
        if (purviewList.get("12-15") == null){
            //如果mode的值为manager,表明是管理员进入,并且已经通过了审核,允许进入
            if (mode.equals("manager")){
                blexist = false;
            }
            else{
                errMsg = "You have no access to the function";
                blexist = true;
            }
        }
        //end
        if (!blexist&&groupid != null&&groupindex!=null) {
             Group grp = new Group();
	     grp.setGroupIndex(groupindex);
             grp.setGroupId(groupid);

              if (op.equals("active")) {
                 optype = 1;
                 desc = operName + "Activate the group user";
                 title = "Activate the group user";
                  }
              else if (op.equals("pause")) {
                 optype = 2;
                 desc = operName + "Suspend the group user";
                  title = "Suspend the group user";
                 }
            if(optype>0){
              //Activate the group user
              if (op.equals("active")) {
                String sUserList = request.getParameter("userlist") == null ? "" : ((String)request.getParameter("userlist")).trim();
                Vector vetRing = null;
                vetRing = StrToVector(sUserList);
                Hashtable result = new Hashtable();
                String sNumber = "";
                for(int i=0;i<vetRing.size()-1;i++){
                  sNumber = vetRing.get(i).toString();
                  rList= syspara.pausegrpuser(sNumber,groupid,optype);
                     // 准备写操作员日志
                   if (getResultFlag(rList)) {
                   zxyw50.Purview purview = new zxyw50.Purview();
                   HashMap map = new HashMap();
                   map.put("OPERID", operID);
                   map.put("OPERNAME", operName);
                   map.put("OPERTYPE", oper_type);
                   map.put("RESULT", "1");
                   map.put("PARA1", sNumber);
                   map.put("PARA2", groupid);
                   map.put("PARA3","ip:"+request.getRemoteAddr());
                   purview.writeLog(map);
        }
                }
              }
              //Suspend the group user
              else if (op.equals("pause")) {
                String inputusernumber=request.getParameter("inputusernumber") == null ? "" : ((String)request.getParameter("inputusernumber")).trim();
                rList= syspara.pausegrpuser(inputusernumber,groupid,optype);
                   // 准备写操作员日志
                 if (getResultFlag(rList)) {
                 zxyw50.Purview purview = new zxyw50.Purview();
                 HashMap map = new HashMap();
                 map.put("OPERID", operID);
                 map.put("OPERNAME", operName);
                 map.put("OPERTYPE", oper_type);
                 map.put("RESULT", "1");
                 map.put("PARA1", inputusernumber);
                 map.put("PARA2", groupid);
                 map.put("PARA3","ip:"+request.getRemoteAddr());
                 purview.writeLog(map);
        }
              }

            }
            // 查询集团暂停的用户
            grp.getGroupContext().loadGroupPauseUser();
            vet=grp.getgroupPauseUser();
             int rowcount = 0;
            int pages = vet.size()/25;
            if(pages > thepage)
              rowcount = 25;
            else
              rowcount = vet.size()- pages * 25 ;
            if(vet.size()==0) rowcount = 0;
            if(vet.size()%25>0)
            pages = pages + 1;
%>
<script language="javascript">
   var v_UserNumber = new Array(<%= rowcount + "" %>);
<%
   for (int i =0 ; i <  vet.size(); i++) {
                hash1 = (HashMap)vet.get(i);

%>
   v_UserNumber[<%= i + "" %>] = '<%= (String)hash1.get("usernumber") %>';
<%
    }
%>
function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.submit();
   }
function goPage(){
      var fm = document.inputForm;
      var pages = parseInt(fm.pages.value);
      var thispage = parseInt(fm.page.value);
      var thepage =parseInt(trim(fm.gopage.value));

      if(thepage==''){
         alert("Please specify the value of the page to go to!")
         fm.gopage.focus();
         return;
      }
      if(!checkstring('0123456789',thepage)){
         alert("The value of the page to go to can only be a digital number!")
         fm.gopage.focus();
         return;
      }
      if(thepage<=0 || thepage>pages ){
         alert("ncorrect range of page value to go to,"+"(page 1~page "+pages+")"+"(1~"+pages+"page)!")
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("The page is displayed now, please re-specify the page!")
         fm.gopage.focus();
         return;
      }
      toPage(thepage);
   }
 function oncheckbox(sender,userNumber){
       var fm = document.inputForm;
       var userList = fm.userlist.value;
       var sTmp = "";
       if(sender.checked == false){
         fm.selectall.checked = false;
       }
       if(sender.checked){
           fm.userlist.value = userList + userNumber  + "|";
           return;
       }
       var idd = userList.indexOf("|");
       while( idd > 0){
	      if(userList.substring(0,idd)==userNumber){
	         sTmp = sTmp + userList.substring(idd+1);
	         break;
	      }
	      sTmp = sTmp +  userList.substring(0,idd) + '|';
	      userList = userList.substring(idd + 1);
	      idd =-1;
	      if(userList.length>1)
	         idd  = userList.indexOf("|");
	   }
	   fm.userlist.value = sTmp;
	   return;
   }

  function activeuser () {
      var fm = document.inputForm;
      fm.op.value = 'active';
      if(fm.userlist.value == '') {
         alert('Please select the group user to be activated!');
         return;
      }
      if(!confirm("Are you sure to activate these group users?"))
         return ;
      fm.submit();
   }
    function pauseuser () {
      var fm = document.inputForm;
      if(fm.inputusernumber.value == '') {
         alert('Please input the group user numbers to be suspended!');
         return;
      }
      var inputusernumbervalue=trim(fm.inputusernumber.value);
       if (!checkstring('0123456789',inputusernumbervalue)){
       alert('The group user number should be in the digit format only!');
       return;
       }
      if(!confirm("Are you sure to suspend the user?"))
         return ;
      fm.op.value = 'pause';
      fm.submit();
   }

    function onSelectAll(){
      var fm = document.inputForm;
      var userList = "";
      if(fm.selectall.checked){
         for(var i = '<%= thepage * 25%>'; i < '<%= thepage * 25 + 25%>' && i < v_UserNumber.length; i++){
            eval('document.inputForm.crbt'+v_UserNumber[i]).checked = true;
            userList = userList +v_UserNumber[i] + '|';
         }

      }
      else {
          for(var i = '<%= thepage * 25%>'; i < '<%= thepage * 25 + 25%>' && i < v_UserNumber.length; i++)
          eval('document.inputForm.crbt'+v_UserNumber[i]).checked = false;
      }
      fm.userlist.value = userList;
      return;
   }
</script>
<%
     if (rList != null && rList.size() > 0) {
        session.setAttribute("rList", rList);
%>
<form name="resultForm" method="post" action="../manager/result.jsp">
<input type="hidden" name="historyURL" value="../group/useractive.jsp?groupindex=<%=groupindex%>&groupid=<%=groupid%>&mode=<%=mode%>">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script></form>
<%}%>
<script language="JavaScript">
	if(parent.frames.length>0)
        parent.document.all.main.style.height="650";
</script>
<form name="inputForm" method="post" action="useractive.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="userlist" value="">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="mode" value="<%= mode %>"/>
<input type="hidden" name="groupid" value="<%= groupid %>"/>
<input type="hidden" name="groupindex" value="<%= groupindex %>"/>
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="../image/n-9.gif">Group user activation</td>
        </tr>
        <tr>
          <td  width="100%" align="center" colspan="2">

   </td>
  </tr>
  <tr>
    <td width="100%" align="center" colspan="2">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center" class="table-style4">
         <tr class="tr-ringlist">
               <td height="30" width="20%">
                  <div align="center"><font color="#FFFFFF">selection flag</font></div>
                </td>
                <td height="30" width="40%">
                  <div align="center"><font color="#FFFFFF">user number</font></div>
                </td>
              </tr>
<%
   int count = vet.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash1 = (HashMap)vet.get(i);
            count++;
%>
   <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td align="center"> <input type='checkbox'  name='<%="crbt"+(String)hash1.get("usernumber") %>'  onclick=oncheckbox(this,'<%= (String)hash1.get("usernumber") %>') > </td>
        <td height="20" align="center" ><%= (String)hash1.get("usernumber") %></td>
         </tr>
<%
}
if(vet.size()==0 && !op.equals("")){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="3" height="20" >There are no user can meet the condition!</td>
         </tr>
        <%
        }
         else if(vet.size()>0){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="3"  height="40"  width="100%">
              <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2" width="98%">
              <tr>
               <td width=120 align="center" >&nbsp;&nbsp;&nbsp;<input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select all</td>
               <td align="center">&nbsp;&nbsp;&nbsp;&nbsp;<img src="../manager/button/active.gif" alt="Activate/Suspend the group user" onmouseover="this.style.cursor='hand'" onClick="javascript:activeuser()" > </td>
              </tr>
              </table>
           </td>
         </tr>
        <%
         }
%>
  </table>
  <%   if (vet.size() > 25) { %>
  <tr>
    <td width="100%" align="center" colspan="2">
      <table border="0" cellspacing="1" cellpadding="1" align="center" class="table-style2"  width="100%">
        <tr>
		    <td align="right">
		    <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
			<tr>
               <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on page&nbsp;<%= thepage + 1 %>&nbsp;</td>
               <td><img src="../button/firstpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(0)"></td>
               <td><img src="../button/prepage.gif"<%= thepage == 0 ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage - 1) + ")\"" %>></td>
               <td><img src="../button/nextpage.gif"<%= thepage * 25 + 25 >= vet.size() ? "" : " onmouseover=\"this.style.cursor='hand'\" onclick=\"javascript:toPage(" + (thepage + 1) + ")\"" %>></td>
               <td><img src="../button/endpage.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:toPage(<%= (vet.size() - 1) / 25 %>)"></td>
             </tr>
			 </table>
		     </td>
		</tr>
        <tr>
          <td  align="right" >
            <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2">
            <tr>
             <td >Page&nbsp;</td>
             <td> <input style=text value="<%= String.valueOf(thepage+1) %>" name="gopage" maxlength=5 class="input-style4" > </td>
             <td ><img src="../button/go.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:goPage()"  ></td>
            </tr>
            </table>
          </td>
       </tr>
      </table>
  </td>

        </tr>
     <%}%>
      </table>

      <br>
      <br>
      <br>
      <table align="center" class="table-style2" width="100%" border="0">
          <tr >
          <td height="26" colspan="4" align="center" class="text-title" background="../image/n-9.gif">Suspend group users</td>
        </tr>
        <tr>
            <td align="right">&nbsp;user number: </td>
                <td><input type="text" name="inputusernumber" value="" maxlength="30" class="input-style1"> </td>
                <td ><img src="../manager/button/pause.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:pauseuser()"></td>

        </tr>
         <tr valign="top">
          <td width="100%" colspan="3"> <table width="98%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
              <tr >
                <td class="table-styleshow" background="../image/n-9.gif" height="26" bgcolor="#FFFFFF">
                 Help:</td>
              </tr>
          <tr>
            <td>1.  Input the group user number to be suspended, click "Suspend" to suspend the group user;</td>
          </tr>
          <tr>
            <td>2.  Select one or multiple group users to be suspended, click "Activate" to activate the selected group user.</td>
          </tr>
      </table>
    </td>
  </tr>
</table>
  </form>
<%
        }
        else {
%>
<script language="javascript">
 	alert('Please log in to the system first!');
<%	session.setAttribute("USERNUMBER",null); %>
	parent.document.location.href = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + groupid +" is abnormal during the group user activation/suspension management!");
        sysInfo.add(sysTime + groupid + e.toString());
        vet.add("Error occourred in the group user activation/suspend management!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="useractive.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

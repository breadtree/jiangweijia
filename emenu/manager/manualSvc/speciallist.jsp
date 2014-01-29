<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.manUser" %>

<%@ include file="../../pubfun/JavaFun.jsp" %>
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
<title>Special list management</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js" type=""></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        ArrayList rList  = new ArrayList();
        HashMap map = new HashMap();
        HashMap hash1 = new HashMap();
        List speciallist = new ArrayList();
        manSysPara syspara = new manSysPara();
        manUser manuser = new manUser();
        sysTime = syspara.getSysTime() + "--";
        //配置权限？？？？？
        if (operID != null && purviewList.get("13-19") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String specialnum = request.getParameter("special") == null ? "" : transferString((String)request.getParameter("special")).trim();
            String limittimes = request.getParameter("limittimes") == null ? "" : transferString((String)request.getParameter("limittimes")).trim();
            String filename = request.getParameter("filename") == null ? "" :transferString((String)request.getParameter("filename")).trim();
            String sUserNumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();
            int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
            String specialtype = request.getParameter("specialtype") == null ? "" : transferString((String)request.getParameter("specialtype")).trim();
            String flag = request.getParameter("flag") == null ? "" : transferString((String)request.getParameter("flag")).trim();
            String scp = request.getParameter("scplist") == null ? "" : (String)request.getParameter("scplist");
            int  optype =0;
            String title = "";
            String desc = "";
            String  optSCP ="";
            ArrayList scplist = manuser.getScpList();
            for (int i = 0; i < scplist.size(); i++) {
              if(i==0 && scp.equals(""))
              scp = (String)scplist.get(i);
              if(scp.equals((String)scplist.get(i)))
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " selected > " + (String)scplist.get(i)+ " </option>";
              else
              optSCP = optSCP + "<option value=" + (String)scplist.get(i) + "  > " + (String)scplist.get(i)+ " </option>";
            }
            if (op.equals("add")) {
                optype = 1;
                desc  = operName + " add special list";
                title = "Add special list";
            }
            else if (op.equals("del")) {
                optype = 2;
                desc  = operName + "Delete special list";
                title = "Delete special list";
             }
             else if(op.equals("batchadd")){
                 optype = 3;
                 desc = operName + " add special list in batch";
                 title = "Add special list in batch";
             }
             if(optype>0){
                 //单个操作
                 if(optype==1){
                     hash.put("optype",optype+"");
                     hash.put("specialnum",specialnum);
                     hash.put("limittimes",limittimes);
                     hash.put("specialtype",specialtype);
                     speciallist.add(hash);
                 }else if(optype ==2){//删除特殊名单
                   String sUserList = request.getParameter("userlist") == null ? "" : ((String)request.getParameter("userlist")).trim();
                   Vector vetRing = null;
                   vetRing = StrToVector(sUserList);
                   Hashtable result = new Hashtable();
                   String sNumber = "";
                   for(int i=0;i<vetRing.size()-1;i++){
                     hash = new Hashtable();
                     sNumber = vetRing.get(i).toString();
                     hash.put("optype",optype+"");
                     hash.put("specialnum",sNumber);
                     hash.put("limittimes","0");
                     hash.put("specialtype",flag);
                     speciallist.add(hash);
                   }
                 }else{//批量操作,读文件
                     speciallist = syspara.getSpecialList(filename);
                 }
                rList = syspara.setSpecial(speciallist);
                sysInfo.add(sysTime + desc);
                Hashtable rHash = null;
                for(int i= 0;i<rList.size();i++){
                    rHash = (Hashtable)rList.get(i);
                    if(rHash !=null && (rHash.get("result")).toString().equals("0")){
                        zxyw50.Purview purview = new zxyw50.Purview();
                   map.put("OPERID",operID);
                   map.put("OPERNAME",operName);
                   map.put("OPERTYPE","516");
                   map.put("RESULT","1");
                   map.put("PARA1",specialnum);
                   map.put("PARA2",limittimes);
                   map.put("PARA3",specialtype);
                   map.put("PARA4","ip:"+request.getRemoteAddr());
                   map.put("DESCRIPTION",title);
                   purview.writeLog(map);
                    }
                }

                if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="../result.jsp">
<input type="hidden" name="historyURL" value="manualSvc/speciallist.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
             }
             if(op.equals("search")){
               vet = syspara.getSpecialInfo(flag,sUserNumber,scp);
             }
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
   for (int i =0 ; i <  rowcount; i++) {
                hash1 = (HashMap)vet.get( thepage * 25 +i );
%>
   v_UserNumber[<%= i + "" %>] = '<%= (String)hash1.get("specialnum") %>';
<%
    }
%>
   var datasource;
   function modeChange(){
      document.forms[0].searchvalue.value = '';
      document.forms[0].searchvalue.focus();
   }
function toPage (page) {
      document.inputForm.page.value = page;
      document.inputForm.op.value = 'search';
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
         alert("Incorrect range of page value to go to,"+"(page 1~page "+pages+")!!")
         fm.gopage.focus();
         return;
      }
      thepage = thepage -1;
      if(thepage==thispage){
         alert("This page has been displayed currently. Please re-specify a page!")
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

   function searchRing () {
      var fm = document.inputForm;
      var  sTmp  = '';
      sTmp = trim(fm.usernumber.value);
      if(sTmp!='' ){
         if(!checkstring('0123456789',sTmp)){
              alert('User number prefix must be a digital number,please re-enter!');//前缀必须是数字,请重新输入
              fm.usernumber.focus();
	      return
         }
      }
      if(sTmp =='' ){
        alert('Please input user number prefix!');
        fm.usernumber.focus();
        return
      }
      fm.page.value = 0;
      fm.op.value = 'search';
      fm.submit();
   }

   function checkInfo () {
      var fm = document.inputForm;
      var value = trim(fm.special.value);
      if(!isUserNumber(value,'User number')){
            fm.special.focus();
            return false;
      }
     if(!checkstring('0123456789',trim(fm.limittimes.value))){
       alert('The restriction times should be in the digit format only!');//限制次数只能为数字
       fm.limittimes.focus();
       return false;
     }
     if(trim(fm.limittimes.value) == ""){
       alert('The restriction times should not be in null!');//限制次数不能为空
       fm.limittimes.focus();
       return false;
     }
     if(fm.limittimes.value.length>10){
       alert('The restriction times exceeds the range!');//限制次数已超出范围
       fm.limittimes.focus();
       return false;
     }
     return true;
   }

   function addInfo () {
      var fm = document.inputForm;
      fm.op.value = 'add';
      if (! checkInfo())
         return;
      fm.submit();
   }

   function editInfo (specialnum,limittimes,specialtype) {
     var result =  window.showModalDialog('specialInfo.jsp?specialnum='+specialnum+'&limittimes='+limittimes+'&specialtype='+specialtype,window,"scroll:no;resizable:no;status:no;dialogLeft:"+((screen.width-410)/2)+";dialogTop:"+((screen.height-250)/2)+";dialogHeight:250px;dialogWidth:410px");
     if(result&&(result=='yes')){
         var thispage = parseInt(document.inputForm.page.value);
         toPage(thispage);
      }
   }

   function delInfo () {
      var fm = document.inputForm;
      fm.op.value = 'del';
      if(fm.userlist.value == '') {
         alert('Please select the special list to be deleted first!');//请先选择要删除的特殊名单
         return;
      }
      if(!confirm("Are you sure to delete the special list?"))//您确信要删除该特殊名单吗
         return ;
      fm.submit();
   }

   function selectFile() {
      var fm = document.inputForm;
      var uploadURL = 'specialupload.jsp';
      uploadRing = window.open(uploadURL,'specialbatchUpload','width=400, height=200');
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.filename.value = name;
      fm.tfile.value = label;
   }

   function batchadd() {
       var fm = document.inputForm;
       if(fm.tfile.value == ''){
         alert("Please select files in batch!");
         fm.tfile.focus();
         return;
       }
       fm.op.value = 'batchadd';
       fm.submit();
   }

   function radioclick(){
     var fm = document.inputForm;
     fm.limittimes.value = "0";
     fm.limittimes.style.display = 'none';
   }
   function radioclick1(){
     var fm = document.inputForm;
     fm.limittimes.value = "";
     fm.limittimes.style.display = 'block';
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="650";
</script>
<form name="inputForm" method="post" action="speciallist.jsp">
<input type="hidden" name="page" value="<%= thepage %>">
<input type="hidden" name="pages" value="<%= pages %>">
<input type="hidden" name="userlist" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="filename" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="../image/n-9.gif">Special list management</td>
        </tr>
        <tr>
          <td  width="100%" align="center" colspan="2">
    <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="100%" align="center">
    <tr>
        <td align="right" height="26">&nbsp;Special list name</td>
		<td width="33%" height="26"><input type="text" name="special" value="" maxlength="30" class="input-style1" style="width:120"></td>
          <td align="right" width="11%" height="26">Restriction times</td>
		<td width="30%" height="26"><input type="text" name="limittimes" value="" maxlength="30" class="input-style1" style="display:block,width:120"></td>

                <td width="11%" align="center" rowspan="2"><img src="../button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addInfo()"></td>
          </td>
    </tr>
    <tr>
        <td align="right">Restriction type</td>
        <td colspan="3"><input type="radio" value="1" name="specialtype" onclick="radioclick1()" checked>Download times&nbsp;&nbsp;<input type="radio" value="2" name="specialtype" onclick="radioclick()">Present limit</td>
    </tr>
    <tr>
    <td height="40"><br><br><br></td>
    </tr>
    <tr >
      <td height="23" colspan="5" align="center" class="text-title" background="../image/n-9.gif">Query special list</td>
    </tr>
    <tr>
          <td align="right">SCP select</td><td><select name="scplist" size="1" style="width:120px">
              <% out.print(optSCP); %>
             </select>
           </td>
      <td width="11%" align="right">User number prefix</td><td width="30%"><input type="text" name="usernumber" value="<%= sUserNumber %>" maxlength="30" class="input-style1" style="width:120" >
      </td>
      <td rowspan="2"><img src="../button/search.gif" alt="Search" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing()"></td>
    </tr>
    <tr>
      <td align="right" width="12%">Restriction type</td><td width="33%">
        <select name="flag" size="1" style="width:120px">
        <option value="1">Download time</option>
        <option value="2" <% if(flag.equals("2")){%>selected<%}%>>Present limit</option>
        </select>
      </td>
    <td></td>
    <td></td>
    </tr>
      </table>
   </td>
  </tr>
  <tr>
    <td width="100%" align="center" colspan="2">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center" class="table-style4">
         <tr class="tr-ringlist">
               <td height="30" width="10%">
                  <div align="center"><font color="#FFFFFF">Selection flag</font></div>
                </td>
                <td height="30" width="30%">
                  <div align="center"><font color="#FFFFFF">User number</font></div>
                </td>
                <td height="30" width="30%">
                    <div align="center"><font color="#FFFFFF">Restriction times</font></div>
                </td>
                <td height="30" width="30%">
                    <div align="center"><font color="#FFFFFF">Restriction type</font></div>
                </td>
                <td height="30">
                  <div align="center"><font color="#FFFFFF">Edit</font></div>
                </td>
              </tr>
<%
        int count = vet.size() == 0 ? 25 : 0;
        for (int i = thepage * 25; i < thepage * 25 + 25 && i < vet.size(); i++) {
            hash1 = (HashMap)vet.get(i);
            count++;
            String tem = (String)hash1.get("specialtype");
            if(tem.equals("1"))
              tem = "Downlaod times";
            else
              tem = "Present times";

%>
        <tr bgcolor="<%= count % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
        <td align="center"> <input type='checkbox'  name='<%= "crbt"+(String)hash1.get("specialnum") %>'  onclick=oncheckbox(this,'<%= (String)hash1.get("specialnum") %>') > </td>
        <td height="20" align="center" ><%= (String)hash1.get("specialnum") %></td>
        <td height="20" align="center"><%= (String)hash1.get("limittimes") %></td>
        <td height="20" align="center"><%= tem %></td>
        <td height="20">
          <div align="center"><font class="font-ring"><img src="../../image/edit.gif" alt="Edit" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo('<%= (String)hash1.get("specialnum") %>','<%= (String)hash1.get("limittimes") %>','<%= (String)hash1.get("specialtype")%>')"></font></div>
        </td>
         </tr>
<%
         }
         if(vet.size()==0 && !op.equals("")){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="5" height="20" >No record matched the criteria!</td>
         </tr>
        <%
        }
         else if(vet.size()>0){
         %>
         <tr bgcolor="FFFFFF" >
           <td align="center" colspan="5"  height="40"  width="100%">
              <table border="0" cellspacing="1" cellpadding="1" align="right" class="table-style2" width="98%">
              <tr>
               <td width=70 align="center" >&nbsp;&nbsp;&nbsp;<input type='checkbox' name='selectall'  onclick="javascript:onSelectAll()">Select all</td>
               <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="../button/del.gif" alt="Delete special user" onmouseover="this.style.cursor='hand'" onClick="javascript:delInfo()" > </td>
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
               <td>&nbsp;<%= vet.size() %>&nbsp;entries in total&nbsp;<%= vet.size()%25==0?vet.size()/25:vet.size()/25+1%>&nbsp;pages&nbsp;&nbsp;You are now on page &nbsp;<%= thepage + 1 %>&nbsp;</td>
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
          <td height="26" colspan="4" align="center" class="text-title" background="../image/n-9.gif">Add special list in batch</td>
        </tr>
        <tr>
            <td align="right">&nbsp;File name </td>
                <td><input type="text" name="tfile" value="" maxlength="30" class="input-style1" disabled> </td>
                <td ><img src="../button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"></td>
                <td ><img src="../button/upload.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:batchadd()"></td>
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
                    alert( "Please log in to the system!");
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
        sysInfo.add(sysTime + operName + " exception occurred in  special list management!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("exception occurred in  special list management!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/speciallist.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Account opening via Manual Operator Position</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"> </SCRIPT>
<SCRIPT language="JavaScript" src="../calendar.js"> </SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
        String usecalling = CrbtUtil.getConfig("usecalling","0");
        String userringtype = "0";
    //\u7F3A\u7701\u5BC6\u7801
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String passLen = (String)application.getAttribute("PASSLEN")==null?"0":(String)application.getAttribute("PASSLEN");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
    String ccpasswd = (String)application.getAttribute("CCPASSWD")==null?"0":(String)application.getAttribute("CCPASSWD");
    String provider = (String)application.getAttribute("PROVIDERCODE")==null?"0":(String)application.getAttribute("PROVIDERCODE");
    String rejectpwd = (String)application.getAttribute("REJECTPWD")==null?"0":(String)application.getAttribute("REJECTPWD");
    String ifNeedAccountBirthday = CrbtUtil.getConfig("ifNeedAccountBirthday","0");
    String defaultPasswd = "111111";
    if(!rejectpwd.equals("0") && !rejectpwd.equals(""))
       defaultPasswd = rejectpwd;
    String  craccount = "";
    manSysPara msp = new manSysPara();
    try {
       String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
       if (operID != null && purviewList.get("13-1") != null) {
	     if(op.equals("open")){
	         craccount = request.getParameter("craccount") == null ? "" : request.getParameter("craccount");
               if(!msp.isAdUser(craccount)){


        if("1".equals(usecalling)){
            userringtype = request.getParameter("userringtype") == null ? request.getParameter("userringtype1") : request.getParameter("userringtype");
        }
		 zxyw50.Purview purview = new zxyw50.Purview();
            	 if(!purview.CheckOperatorRight(session,"13-1",craccount)){
               		throw new Exception("You have no right to manage this subscriber!");
            	 }
	         String cardPass = request.getParameter("newcardpass") == null ? "" : (String)request.getParameter("newcardpass");
             if(ccpasswd.equals("0"))
                 cardPass = defaultPasswd;
//             ColorRing colorRing = new ColorRing();
//             if(colorRing.searchUser(craccount)) {
//             	throw new Exception("Profile of user "+ colorName +" has existed!");
//           	 }
             //\u83B7\u53D6\u7528\u6237\u72B6\u6001\u4FE1\u606F
             Hashtable hash = new Hashtable();
             Hashtable result= new Hashtable();
             hash.put("craccount",craccount);
             hash.put("passwd",cardPass);
             hash.put("level","1");  //\u666E\u901A\u7528\u6237
             hash.put("opcode","01010101");

             hash.put("userringtype",userringtype);

             hash.put("opmode","6");
             hash.put("ipaddr",operName);
             SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
             result = SocketPortocol.send(pool,hash);
             //modify birthday
             if(ifNeedAccountBirthday.equals("1"))
            {
               userAdm useradm = new userAdm();
               Hashtable tablebir = new Hashtable();
               tablebir.put("phone",craccount);
               tablebir.put("birthday",request.getParameter("birthday")==null?"":request.getParameter("birthday").toString().trim());

               try{
               	useradm.setUserBirthday(tablebir);
               }catch(Exception e)
               {
               }
            }
             // \u51C6\u5907\u5199\u64CD\u4F5C\u5458\u65E5\u5FD7
           //  zxyw50.Purview purview = new zxyw50.Purview();
             HashMap map = new HashMap();
             map.put("OPERID",operID);
             map.put("OPERNAME",operName);
             map.put("OPERTYPE","501");
             map.put("RESULT","1");
             map.put("PARA1",craccount);
             map.put("PARA2","ip:"+request.getRemoteAddr());
             purview.writeLog(map);
             String noticeMsg = "";
             if(provider.equals("1")){
                  noticeMsg = craccount + ",Account opening request has been accepted! The system will inform you of the result via SMS within 24 hours.";//\u5F00\u6237\u8BF7\u6C42\u5DF2\u88AB\u53D7\u7406,\u7CFB\u7EDF\u5C06\u572824\u5C0F\u65F6\u5185\u4EE5\u77ED\u4FE1\u65B9\u5F0F\u901A\u77E5\u5176\u5F00\u6237\u7ED3\u679C!
                  sysInfo.add(sysTime +operName + ",Manual Operator Position user " + craccount);//\u4EBA\u5DE5\u53F0\u7528\u6237
             }
             else{
                     noticeMsg = "The system is responsing the opening request of account " +craccount + "! The service will be available after 24 hours!";//"\u7CFB\u7EDF\u6B63\u5728\u5904\u7406" +craccount + "\u5F00\u6237\u8BF7\u6C42,\u7528\u6237\u53EF\u572824\u5C0F\u65F6\u4EE5\u540E\u4F7F\u7528\u4E1A\u52A1!"
	             sysInfo.add(sysTime +operName + ",Manual Operator Position user " + craccount);//\u4EBA\u5DE5\u53F0\u7528\u6237
	        }
	        %>
            <script language="javascript">
              var str = "<%= craccount %>"+" opening successful!"//\u7528\u6237\u5F00\u6237\u6210\u529F
                   alert(str);
                  </script>
               <%
               }
         }
    %>
<script language="javascript">
   var  ccpasswd = <%=  ccpasswd %>;
   function changePwd () {
      var fm = document.inputForm;
      var value = trim(fm.craccount.value);
      if (!isUserNumber(value,'The subscriber number ')) {
         fm.craccount.focus();
         return;
      }
      if(ccpasswd==1){
         if (document.inputForm.newcardpass.value=='') {
            alert('Please enter the password!');//\u8BF7\u8F93\u5165\u5BC6\u7801
            fm.newcardpass.focus();
            return;
         }
         if (!checkstring('0123456789',document.inputForm.newcardpass.value)) {
            alert('The password can only contain digits!');//The password can only contain digits
            fm.craccount.focus();
            return;
         }

         var intFlag = <%= passLen.equals("1")?1:0%>;
         if (document.inputForm.newcardpass.value.length < <%=CrbtUtil.getMinPassword() %>||
	         document.inputForm.newcardpass.value.length > <%=CrbtUtil.getMaxPassword() %>) {
             alert('<%=CrbtUtil.getPasswrodAlertMsg()%>');
             document.inputForm.newcardpass.focus();
             return;
         }
         if (fm.newcardpass.value != fm.concardpass.value) {
            alert('The password does not match the Confirm Password!');//\u5BC6\u7801\u4E0E\u786E\u8BA4\u5BC6\u7801\u4E0D\u4E00\u81F4
            fm.concardpass.focus();
            return;
         }
      }
      value = trim(document.inputForm.birthday.value);
      if(!checktrue2(value)){
        alert('Birthday should not be later than current date!');
        document.inputForm.birthday.focus();
        return;
      }
      fm.op.value = 'open';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="cardOpen.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="userringtype1" value="<%=userringtype%>">
<table border="0" align="center" height="400" width="300" class="table-style2" >
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">Manual Operator<br>Position user</td>
        </tr>
        <tr >
          <td height="15" colspan="2" align="center" >&nbsp;</td>
        </tr>
        <tr style="<%=("1".equals(usecalling)?"display:block":"display:none")%>">
          <td align="right">Service Type</td>
          <td>
           <select name="userringtype"  class="input-style1" style="width:150" >
           <option <%=("0".equals(userringtype)?"selected":"")%> value=0 >Called Service</option>
           <option <%=("1".equals(userringtype)?"selected":"")%> value=1 >Calling Service</option>
           		<!--<option <%=("2".equals(userringtype)?"selected":"")%> value=2 >Calling/Called Service</option>-->
           </select>
          </td>
        </tr>
        <tr>
          <td align="right">Account opening number</td>
          <td ><input type="text" name="craccount" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tbody style=<%= ccpasswd.equals("1")?"display:block":"display:none" %> >
        <tr>
          <td align="right">New Password</td>
          <td><input type="password" name="newcardpass" value="" maxlength="<%= CrbtUtil.getMaxPassword() %>" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Confirm password</td>
          <td><input type="password" name="concardpass" value="" maxlength="<%= CrbtUtil.getMaxPassword() %>" class="input-style1"></td>
        </tr>
        </tbody>
        <tr style="display:<%=ifNeedAccountBirthday.equals("1")?"":"none"%>">
          <td height="22" align="right">Birthday</td>
          <td>
            <input type="text" name="birthday" value="" class="input-style1" maxlength="10" readonly onclick="OpenDate(birthday);">
          </td>
        </tr>
        <tr>
          <td colspan="2" height=30 >
            <table border="0" width="80%" class="table-style2" align="center">
              <tr>
                <td width="50%" align="center"><img src="../button/kaihu.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:changePwd()"></td>
                <td width="50%" align="center"><img src="../button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
              </tr>
            </table>
          </td>
        </tr>
         <tr>
          <td align="right" colspan=2>&nbsp;</td>
        </tr>
        <tr>
          <td colspan=2>
          <table border="0" width="100%" class="table-style2">
            <tr>
                <td class="table-styleshow" background="../image/n-9.gif" height="26">
                  Notes:</td>
              </tr>
              <tr>
                <td style="color: #FF0000"><%= areacode.equals("3")?"1.  Format of the PHS Account Opening Number: 0+area code+actual number.":"1.  Account Opening Number: Mobile phone number" %>;</td>
              </tr>
              <!--
               <tr>
                <td style="color: #FF0000">2.  Only real time subscriber can set birthday when open account. Pre-real time subscriber can not set birthady;
                </td>
              </tr>
              -->
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
                    document.URL = '../enter.jsp';
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
        sysInfo.add(sysTime + operName + ", An error occurred for Manual Operator Position user " + craccount+ "!");//\u4EBA\u5DE5\u53F0\u7528\u6237  \u51FA\u73B0\u9519\u8BEF
        sysInfo.add(sysTime +  e.toString());
        vet.add(operName + ", An error occurred for Manual Operator Position user " + craccount+ "!");//\u4EBA\u5DE5\u53F0\u7528\u6237  \u51FA\u73B0\u9519\u8BEF
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/cardOpen.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>

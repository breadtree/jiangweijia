<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.phoneAdm" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%@ include file="../../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<jsp:useBean id="db" class="zxyw50.callingTime" scope="page" />
<jsp:setProperty name="db" property="*" />

<%!
	public String display(String callingNum, String ringLabel) {
        String str = "";
        int len = callingNum.length();
        if(!(len>9) && callingNum.substring(0,1).equals("0")){//vpn用户
        	callingNum = callingNum.substring(1,len);
        }

        for (int i = 0; i < 20 - len; i++)
            str = str + "-";
        return callingNum + str + ringLabel;
    }
%>
<html>
<head>
<title>Calling Number Management</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
<script language="Javascript" src="../calendar.js"></script>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String craccount = "";
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    int     modefee =0;
    
    String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 int ratio = Integer.parseInt(currencyratio);
    
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
      if (operID != null && purviewList.get("13-8") != null) {
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        craccount = request.getParameter("craccount") == null ? "" : ((String)request.getParameter("craccount")).trim();
        String phone = request.getParameter("phone") == null ? "" : ((String)request.getParameter("phone")).trim();
        String crid = request.getParameter("crid") == null ? "" : ((String)request.getParameter("crid")).trim();
        String phonelabel = request.getParameter("phonelabel") == null ? "" : transferString(((String)request.getParameter("phonelabel")).trim());
        Hashtable hash = new Hashtable();
        Vector vetRing = new Vector();
        Vector vetCallingNum = new Vector();
        Hashtable tmp = new Hashtable();
        Hashtable personalRing = new Hashtable();
        Hashtable result = new Hashtable();



        if (!op.equals("") ) {
            String  sDesc = "";
            if(checkLen(phonelabel,20))
            	throw new Exception("The name of your inputted calling party name is too long in length! Please re-enter!");//您输入的主叫名称长度超过限制,请重新输入!
            // 如果是增加电话号码
            if (op.equals("add")) {
                hash.put("opcode","01010201");
                hash.put("craccount",craccount);
                hash.put("phone",phone);
                hash.put("groupid","");
                hash.put("phonelabel",phonelabel);
                hash.put("crid",crid);
                result = SocketPortocol.send(pool,hash);
                sysInfo.add(sysTime + craccount + " added calling number successfully!");//增加主叫电话号码成功
                sDesc =  "Add";
            }
            // 如果是删除铃音电话号码
            if (op.equals("del")) {
                hash.put("opcode","01010202");
                hash.put("craccount",craccount);
                if(checkP(phone))
                	phone = "0"+phone;
                hash.put("phone",phone);
                hash.put("ret1","");
                result = SocketPortocol.send(pool,hash);
                sDesc =  "delete" ;
                sysInfo.add(sysTime + craccount + " deleted calling number successfully!");//删除主叫电话号码成功
            }
            // 如果是修改电话铃音设置
            if (op.equals("set")) {
                hash.put("opcode","01010919");
                hash.put("craccount",craccount);
                if(checkP(phone))
                	phone = "0"+phone;
                hash.put("phone",phone);
                hash.put("phonelabel",phonelabel);
                hash.put("groupid","");
                hash.put("crid",crid);
                result = SocketPortocol.send(pool,hash);
                sysInfo.add(sysTime + craccount + " modify calling number ringtone successfully!");//修改主叫电话号码铃音成功!
                sDesc =  "edit" ;
            }

            zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","508");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2",phone);
            map.put("PARA3",phonelabel);
            map.put("PARA4",crid);
            map.put("PARA5","ip:"+request.getRemoteAddr());
            map.put("DESCRIPTION",sDesc);
            purview.writeLog(map);

        }
         // 查询个人铃音
        if(!craccount.equals("")){
//            hash.put("opcode","01010301");
//            hash.put("craccount",craccount);
//            hash.put("ret1","");
//            result = SocketPortocol.send(pool,hash);
            userAdm adm = new userAdm();
            result = adm.queryPersonalRing(craccount);

            vetRing = (Vector)result.get("data");
                 // 将铃音信息填入HASH中
            for (int i = 0; i < vetRing.size(); i++) {
                tmp = (Hashtable)vetRing.get(i);
                personalRing.put((String)tmp.get("crid"),(String)tmp.get("filename"));
            }
            // 获得主叫号码与对应铃声
           phoneAdm  phoneadm = new phoneAdm();
           vetCallingNum = phoneadm.getCallingNumInfo(craccount);
      }
%>
<script language="javascript">
   var v_ringlabel = new Array(<%= vetRing.size() + "" %>);
   var v_ringauthor = new Array(<%= vetRing.size() + "" %>);
<%
            for (int i = 0; i < vetRing.size(); i++) {
                hash = (Hashtable)vetRing.get(i);
%>
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("filename") %>';
   v_ringauthor[<%= i + "" %>] = '<%= (String)hash.get("author") %>';
<%
            }
%>
   var v_callingnum = new Array(<%= vetCallingNum.size() + "" %>);
   var v_cnumlabel = new Array(<%= vetCallingNum.size() + "" %>);
   var v_ringid = new Array(<%= vetCallingNum.size() + "" %>);
<%
            int   jm = 0;
            for (int i = 0; i < vetCallingNum.size(); i++) {
                hash = (Hashtable)vetCallingNum.get(i);
                String groupid = (String)hash.get("callinggroup");
                if(groupid.equals("0")){   //去除主叫号码组的主叫号码
%>
   v_callingnum[<%= jm + "" %>] = '<%= (String)hash.get("callingnum") %>';
   v_cnumlabel[<%= jm + "" %>] = '<%= (String)hash.get("cnumlabel") %>';
   v_ringid[<%= jm + "" %>] = '<%= (String)hash.get("ringid") %>';
<%
                 jm = jm +1;
               }

            }
%>

   function checkPhone () {
      var fm = document.inputForm;
      var phone = trim(fm.phone.value);
      if (!checkstring('0123456789',phone))
            return false;

      return true;
   }

   function onCraccountPress(evn) {
    var   charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
    if (charCode == 13){
       document.forms[0].craccount.blur();
       onSearch();
       return;
     }
     return;
   }
   //自动在长途区号不为0的固定号码前加0
   function makePhone () {
      var fm = document.inputForm;
      var phone = trim(fm.phone.value);
      var c;
      var d;
      d = phone.substring(0,1);
      c = phone.substring(0,2);
      //alert("phone="+phone+";d="+d+";c="+c);
      
/*      
      var f = isMobile(phone);
      if( f=='true' && d!='0' ){
         phone  = 0 + phone ;
         fm.phone.value = phone;
      }
*/      
      
      
      return true;
   }


   function addPhone () {
      var fm = document.inputForm;
      if (trim(fm.phone.value) == '') {
         alert('Please enter the new calling number to be added!');//请输入新增的主叫号码
         fm.phone.focus();
         return;
      }
      if (! checkPhone()) {
         alert('A calling number can only be a digital number!');//主叫号码只允许输入数字
         fm.phone.focus();
         return;
      }
	  if(fm.phone.value.length<2){
	  	alert('Please enter the correct phone number!');//请输入正确的电话号码
		fm.phone.focus();
		return;
	  }
      if(fm.phone.value.length>8)
      makePhone();
      if (findPhone()) {
         alert('The number to be added already exists. Unable to add this number!');//要添加的号码已经存在,不能添加
         fm.phone.focus();
         return;
      }
      if (!CheckInputStr(fm.phonelabel,'Calling party name'))//主叫名称
         return;

      var fee=<%= modefee %>;
      if(fee>0){
           if(!confirm("You will be charged "+ fee/<%=ratio%> + " <%=majorcurrency%> for adding the calling number!  \N Are you sure you want to continue?" ))
              return;
      }

      fm.op.value = 'add';
      fm.crid.disabled = false;
      fm.submit();
   }

   function findPhone () {
      var fm = document.inputForm;
      var phone = trim(fm.phone.value);
      var listPhone;
      for (i = 0; i < v_callingnum.length; i++) {
         if (phone == leftTrim(v_callingnum[i]))
            return true;
      }
      return false;
   }

   function delPhone () {
      var fm = document.inputForm;
      if (trim(fm.phone.value) == '') {
         alert("Please enter the calling number to be deleted!");//请输入需要删除的主叫号码
         fm.phone.focus();
         return;
      }
      if (! findPhone()) {
         alert("The number to be deleted has not been set. Unable to delete this number!");//要删除的号码没有设置,不能删除
         fm.phone.focus();
         return;
      }
      if (! confirm("Are you sure to delete this calling number?"))//您是否确认删除这个主叫号码
         return;
      fm.op.value = 'del';
      fm.crid.disabled = false;
      fm.submit();
   }

   function setPhone () {
      var fm = document.inputForm;
       var index = fm.phonelist.value;
       if (index == null || index == ''){
          alert("Please select the calling number to be modified!");//请选择您要更改的主叫号码
          return;
       }
      if (trim(fm.phone.value) == '') {
         alert("Please enter the calling number to be modified!");//请输入需要修改的主叫号码
         fm.phone.focus();
         return;
      }
      if(fm.phone.value.length>8)//固定电话
      makePhone();
      if (! findPhone()) {
         alert("The calling number cannot be modified.");//主叫号码不能修改
         fm.phone.focus();
         return;
      }
      if (!CheckInputStr(fm.phonelabel,"Calling party name"))//主叫名称
         return;

      if( v_ringid[index]!=fm.crid.value){
         var fee=<%= modefee %>;
         if(fee>0){
            if(!confirm("You will be charged "+ fee/<%=ratio%> + " <%=majorcurrency%> for modifying the ringback tone for the calling number!  \N Are you sure you want to continue?" ))//"更改主叫号码对应的主叫铃音(组),需要交纳"+ fee/100 + "元!\n您确认吗？"
               return;
         }
      }
      fm.op.value = 'set';
      fm.crid.disabled = false;
      fm.submit();
   }

   function selectPhone () {
      var fm = document.inputForm;
      var index = fm.phonelist.value;
      if (index == null)
         return;
      if (index == '') {
         fm.phone.focus();
         return;
      }
      if(!(v_callingnum.length>9))  //vpn用户显示去掉0
      	 fm.phone.value = leftTrim(v_callingnum[index]);
      else
          fm.phone.value = v_callingnum[index];
      fm.phonelabel.value = v_cnumlabel[index];
      fm.crid.value = v_ringid[index];
      fm.phone.focus();
   }

   function onBack(){
       document.URL = 'phoneRing.jsp';
  }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="phoneRingEnd.jsp">
<input type="hidden" name="curName" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="startTime" value="">
<input type="hidden" name="endTime" value="">
<input type="hidden" name="oldcrid" value="">
<table border="0" align="center" height="400" width="90%" class="table-style2" >
  <tr valign="center">
  <td>
  <table border="0" align="center" class="table-style2">
      <tr >
          <td height="26" colspan=3 align="center" class="text-title" background="../image/n-9.gif">Manage calling numbers--<%= craccount %></td>
      </tr>
      <tr >
          <td height="15" colspan=2 align="center" >&nbsp;</td>
      </tr>
      <tr valign="top">
                  <td width="100%">
                    <table width="100%"  border="0" class="table-style2" cellpadding="2" cellspacing="1" >
                      <tr>
                        <td rowspan="4">
                          <select name="phonelist" size="10" class="input-style1"  style="width:230" <%= vetCallingNum.size() == 0 ? "disabled " : "" %>onclick="javascript:selectPhone()">
                            <%
            int j = 0;
            for (int i = 0; i < vetCallingNum.size(); i++) {
                tmp = (Hashtable)vetCallingNum.get(i);
                String groupid = (String)tmp.get("callinggroup");
                if(groupid.equals("0")){   //去除主叫号码组的主叫号码

%>
                            <option value="<%= j + "" %>"><%= display((String)tmp.get("callingnum"),(String)personalRing.get((String)tmp.get("ringid"))) %></option>
                            <%
                   j = j+1;
                }
            }
%>
                          </select>
                        </td>
                        <td align="right">Calling number&nbsp;</td>
                        <td><input type="text" name="phone" value="" maxlength="20" class="input-style1"></td>
                      </tr>
                      <tr>
                        <td align="right">Calling party name&nbsp;</td>
                        <td><input type="text" name="phonelabel" value="" maxlength="20" class="input-style1"></td>
                      </tr>
                      <tr>
                        <td align="right">Calling party ringtone&nbsp;</td>
                        <td> <select name="crid" class="select-style1">
                            <%
            for (int i = 0; i < vetRing.size(); i++) {
                tmp = (Hashtable)vetRing.get(i);
%>
                            <option value="<%= (String)tmp.get("crid") %>"><%= (String)tmp.get("filename") %></option>
                            <%
            }
%>
                          </select> </td>
                      </tr>
                      <tr>
                        <td colspan="2" width=100% > <table border="0" width="100%" class="table-style2">
                            <tr>
                              <td width="25%" align="center"><img src="../button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addPhone()"></td>
                              <td width="25%" align="center"><img src="../button/change.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:setPhone()"></td>
                              <td width="25%" align="center"><img src="../button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delPhone()"></td>
                              <td width="25%" align="center"><img src="../button/back.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:onBack()"></td>
                            </tr>
                          </table></td>
                      </tr>
                    </table>
                  </td>
                </tr>
             <tr>
          <td colspan=2>
          <table border="0" width="100%" class="table-style2">
            <tr>
                <td class="table-styleshow" background="../image/n-9.gif" height="26">
                  Notes:</td>
              </tr>
              <tr>
                <td style="color: #FF0000">1.Calling Number Management allows you to set a specific ringtone (group) for a specific calling number;</td>
              </tr>
              <tr>
                <td style="color: #FF0000">2.If the calling number is a fixed phone number, please enter 0+area code+fixed phone number.</td>
              </tr>
           </table>
          </td>
        </tr>
              </table>
            </td>
          </tr>
        </table>
  <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
      <td>&nbsp; </td>
  </tr>
  <tr>
      <td>&nbsp; </td>
  </tr>
</table>
</form>
<%
        }
        else {
%>
<script language="javascript">
 	alert('Please log in first!');//请先登录
	document.location.href = '../enter.jsp';
</script>
<%
       }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount + "Exception occurred in managing calling numbers!");//主叫号码管理出现异常
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add("Exception occurred in managing calling numbers!");//主叫号码管理出现异常
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/phoneRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

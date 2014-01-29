<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="zxyw50.phoneAdm" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Number group member management</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
    String sysTime = "";
    String craccount = request.getParameter("craccount") == null ? "" : ((String)request.getParameter("craccount")).trim();
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String phonegroup = request.getParameter("phonegroup") == null ? "" : ((String)request.getParameter("phonegroup")).trim();
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String allowVpn = (String)application.getAttribute("ALLOWVPN")==null?"1":(String)application.getAttribute("ALLOWVPN");
    String ringdisplay = " Ringtone ";//铃音
    try {
         phoneAdm  phoneadm = new phoneAdm();
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
		String phone = request.getParameter("phone") == null ? "" : ((String)request.getParameter("phone")).trim();
        String phonelabel = request.getParameter("phonelabel") == null ? "" : transferString(((String)request.getParameter("phonelabel")).trim());
        Hashtable hash = new Hashtable();
        Hashtable groupInfo = new Hashtable();
        ArrayList lstGroupPhone = null;
        HashMap map = null;
        Hashtable result = null;
        if (craccount != null) {
            if (op.equals("add")) {
                hash.put("craccount",craccount);
       //         if(!(phone.length()>9) &&(phone.length()>2)&& !(phone.substring(0,2).equals("13"))&&!(phone.substring(0,1).equals("0")))
       //         	phone = "0"+phone;
                hash.put("phone",phone);
                hash.put("groupid",phonegroup);
                hash.put("phonelabel",phonelabel);
                phoneadm.addCallingGroupMember(hash);
                sysInfo.add(sysTime + craccount + " added  number successfully!");
            }
            // 如果是删除铃音电话号码
            if (op.equals("del")) {
                hash.put("craccount",craccount);
    //            if(!(phone.length()>9) &&(phone.length()>2)&& !(phone.substring(0,2).equals("13"))&&!(phone.substring(0,1).equals("0")))
    //            	phone = "0"+phone;
                hash.put("phone",phone);
                hash.put("groupid",phonegroup);
                phoneadm.delCallingGroupMember(hash);
                sysInfo.add(sysTime + craccount + " deleted number successfully!");
            }
            // 如果是修改电话铃音设置
            if (op.equals("set")) {
                hash.put("craccount",craccount);
      //          if(!(phone.length()>9) &&(phone.length()>2)&& !(phone.substring(0,2).equals("13"))&&!(phone.substring(0,1).equals("0")))
      //          	phone = "0"+phone;
        	hash.put("phone",phone);
                hash.put("phonelabel",phonelabel);
                hash.put("groupid",phonegroup);
                phoneadm.editCallingGroupMember(hash);
                sysInfo.add(sysTime + craccount + " modifies number successfully!");
            }

            // 查询主叫号码组成员信息
            hash.clear();
            hash.put("usernumber",craccount);
            hash.put("phonegroup",phonegroup );
            lstGroupPhone = phoneadm.getPhoneFromGroup(hash);
            groupInfo = phoneadm.getCallingGroupInfo(craccount,phonegroup);
            %>
<script language="javascript">
   var v_callingnum = new Array(<%= lstGroupPhone.size() + "" %>);
   var v_cnumlabel = new Array(<%= lstGroupPhone.size() + "" %>);
<%
            for (int i = 0; i < lstGroupPhone.size(); i++) {
                map = (HashMap)lstGroupPhone.get(i);
%>
   v_callingnum[<%= i + "" %>] = '<%= (String)map.get("callingnum") %>';
   v_cnumlabel[<%= i + "" %>] = '<%= (String)map.get("cnumlabel") %>';
<%
               }
%>

   function checkPhone () {
      var fm = document.inputForm;
      var phone = trim(fm.phone.value);
      if (!checkstring('0123456789',phone))
            return false;

      return true;
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
         alert("Please enter the new number to be added!");
         fm.phone.focus();
         return;
      }
      if (! checkPhone()) {
         alert("A number can only be a digital number!");//主叫号码只允许输入数字
         fm.phone.focus();
         return;
      }
	  if(fm.phone.value.length<2){
	  	alert("Please enter the correct phone number!");//请输入正确的电话号码
		fm.phone.focus();
		return;
	  }
      if(fm.phone.value.length>8)
      makePhone();
      if (findPhone()) {
         alert("The number to be added already exists. Unable to add this number!");//要添加的号码已经存在,不能添加
         fm.phone.focus();
         return;
      }
      if (!CheckInputStr(fm.phonelabel,'Number name'))
         return;

      fm.op.value = 'add';
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
         alert("Please enter the number to be deleted!");//请输入需要删除的主叫号码
         fm.phone.focus();
         return;
      }
      if (! findPhone()) {
         alert("The number to be deleted has not been set. Unable to delete this number!");//要删除的号码没有设置,不能删除
         fm.phone.focus();
         return;
      }
      if (! confirm("Are you sure to delete this number?"))//您是否确认删除这个主叫号码
         return;
      fm.op.value = 'del';
      fm.submit();
   }

   function editPhone () {
      var fm = document.inputForm;
       var index = fm.phonelist.value;
       if (index == null || index == ''){
          alert("Please select the number to be modified!");//请选择您要更改的主叫号码
          return;
       }
      if (trim(fm.phone.value) == '') {
         alert("Please enter the number to be modified!");//请输入需要修改的主叫号码
         fm.phone.focus();
         return;
      }
      if(fm.phone.value.length>8)//固定电话
      makePhone();
      if (! findPhone()) {
         alert("Number "+fm.phone.value + " is not an existing member number! No modification!");//要修改主叫号码没有设置,不能更改
         fm.phone.focus();
         return;
      }
      if (!CheckInputStr(fm.phonelabel,'Number name'))
         return;
      fm.op.value = 'set';
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
      if(!(v_callingnum[index].length>9)) //vpn用户显示去掉0
      	fm.phone.value = leftTrim(v_callingnum[index]);
      else
      	fm.phone.value = v_callingnum[index];
      fm.phonelabel.value = v_cnumlabel[index];
      fm.phone.focus();
   }
   function back () {
     location.href = 'phoneGroup.jsp';
   }


</script>
<form name="inputForm" method="post" action="phoneMember.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="craccount" value="<%= craccount %>">
<input type="hidden" name="phonegroup" value="<%= phonegroup %>" >

  <table width="551" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
  <td valign="top" bgcolor="#FFFFFF">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
      <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table-style2" align="center">
          <tr>
              <td width="28"><img src="../../image/home_r14_c3.gif" width="28" height="31"></td>
              <td background="../../image/home_r14_c5bg.gif"><font color="#006600"><b></b>
                <b><font class="font"> <%= craccount %>-- Number Group Member Management</font></b></font></td>
              <td width="12"><img src="../../image/home_r14_c5.gif" width="12" height="31"></td>
          </tr>
          </table>
	     <table width="95%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
         <tr valign="top">
         <td width="100%">
              <table width="100%" border="0" cellpadding="2" cellspacing="1" class="table-style3">
              <tr>
			  <td colspan="3">The number group you are editing is:&nbsp;&nbsp;<%= (String)groupInfo.get("grouplabel") %></td>
              </tr>
			  <tr>
              <td rowspan="3">
                <select name="phonelist" size="8" <%= lstGroupPhone.size() == 0 ? "disabled " : "" %>onclick="javascript:selectPhone()" class="select-style3">
                <%
                for (int i = 0; i < lstGroupPhone.size(); i++) {
                    map = (HashMap)lstGroupPhone.get(i);
%>
                    <option value="<%= i + "" %>"><%= (String)map.get("callingnum") %></option>
                    <%
            }
%>
                  </select> </td>
                <td align="right">Number&nbsp;</td>
                <td><input type="text" name="phone" value="" maxlength="20" class="input-style1"></td>
              </tr>
              <tr>
                <td align="right" >Name&nbsp;</td>
                <td > <input type="text" name="phonelabel" value="" maxlength="20" class="input-style1"></td>
              </tr>
              <tr>
                <td colspan="2"> <table border="0" width="100%" class="table-style2">
                    <tr>
                      <td width="25%" align="center"><img src="../button/add.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:addPhone()"></td>
                      <td width="25%" align="center"><img src="../button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editPhone()"></td>
                      <td width="25%" align="center"><img src="../button/del.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:delPhone()"></td>
                      <td width="25%" align="center"><img src="../button/close.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:window.close()"></td>
                    </tr>
                  </table></td>
              </tr>
            </table>
        </td>
        </tr>
        <tr valign="top">
          <td width="100%"> <table width="100%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
              <tr>
                <td class="table-styleshow" background="../../image/n-9.gif" height="26">
                  Help information:</td>
              </tr>
              <tr>
                  <tr>
                    <td>1.For all the numbers in number groups,<%= ringdisplay %> are to be set and decided by the number groups;</td>
                  </tr>
                  <tr>
                    <td>2.If the number is a PSTN number, please enter 0+ area code+ PSTN number.<% if(allowVpn.equals("1")){%>To set a short number to be the number, enter directly the short number<%}%>;   </td>
                  </tr>
           </table></td>
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
%>
<script language="javascript">
   alert("Please log in first!");//请先登录
parent.document.location.href = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount + "Exception occurred during number group member management!");//主叫号码组成员管理过程出现异常!
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add("Error occurred during number group member management!");//主叫号码组成员管理错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/phoneMember.jsp?phonegroup=<%=  phonegroup %>&craccount=<%=  craccount %>" >
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

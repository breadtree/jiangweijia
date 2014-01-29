<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public Vector refuseComment() {
        Vector vet = new Vector();
        vet.add("Refuse it");
        vet.add("Invalid property");
        vet.add("Name exist");
        vet.add("Unreasonable price");//铃音(组)价格不合理
        vet.add("Unknown reason");//不明原因
        return vet;
    }
%>
<html>
<head>
<title>Operation audit</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
<%
     int issupportmultipleprice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice",0);
	 String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 int ratio = Integer.parseInt(currencyratio);




//onload="initform(document.forms[0])"
//String uservalidday = CrbtUtil.getConfig("uservalidday","0") == null ? "0" : CrbtUtil.getConfig("uservalidday","0");
    String sysTime = "";
    String qryRingName = request.getParameter("qryRingName") == null ? "" : transferString((String)request.getParameter("qryRingName")).trim();
        String jName = (String)application.getAttribute("JNAME");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
     String spIndex = (String)request.getParameter("sp")==null?"":(String)request.getParameter("sp");
    try {
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        ArrayList rList = new ArrayList();
        int     operflag = 0; //0:无权限 1:有
        if (purviewList.get("6-12") != null)
           operflag = 1;
        if(operflag ==0 || operID==null){
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to the system first!" : "You have no acess to the function!" %>');
	document.URL = 'enter.jsp';
</script>
<%
        }
        else if (operID != null) {
            zxyw50.Purview purview = new zxyw50.Purview();
            String seqno = request.getParameter("seqno") == null ? "" : ((String)request.getParameter("seqno")).trim();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String refusecomment = request.getParameter("reasontext") == null ? "" : transferString((String)request.getParameter("reasontext")).trim();
String grpid = request.getParameter("grpid") == null ? "" : ((String)request.getParameter("grpid")).trim();
            if (op.equals("0")){ //审核不通过
                rList = sysring.operCheckMusic("2",Integer.parseInt(seqno),refusecomment);
            // 准备写操作员日志
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","612");
            map.put("RESULT","1");
            map.put("PARA1",seqno);
            map.put("PARA2","2");
            map.put("PARA3",spIndex);
            map.put("PARA4",refusecomment);
            map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
            }
            else if (op.equals("1")){  //审核通过
                rList = sysring.operCheckMusic("1",Integer.parseInt(seqno),"Pass ");
            // 准备写操作员日志
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","612");
            map.put("RESULT","1");
            map.put("PARA1",seqno);
            map.put("PARA2","1");
            map.put("PARA3",spIndex);
            map.put("PARA4",refusecomment);
            map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
            }
            if(rList.size()>0){
             session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="checkmusicoper.jsp">
<input type="hidden" name="title" value="The system ringtone group operation audit">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%}
            manSysPara  syspara = new manSysPara();
             ArrayList spInfo = syspara.getSPInfo();
            Hashtable hash = new Hashtable();
            hash.put("queryflag","0");
            hash.put("spindex",spIndex);
            hash.put("ringname",qryRingName);
            Vector vet = sysring.getSysMusicCheckOper(hash);



%>
<script language="javascript">
   var v_spindex = new Array(<%= vet.size() + "" %>);
   var v_ringlabel = new Array(<%= vet.size() + "" %>);
   var v_ringauthor = new Array(<%= vet.size() + "" %>);
   if(<%=issupportmultipleprice%> == 1){
    var v_ringfee2 = new Array(<%= vet.size() + "" %>);
    var v_oldringfee2 = new Array(<%= vet.size() + "" %>);
    }
   var v_ringfee = new Array(<%= vet.size() + "" %>);
   var v_seqno = new Array(<%= vet.size() + "" %>);
   var v_validdate = new Array(<%= vet.size() + "" %>);
   var v_uservalidday = new Array(<%= vet.size() + "" %>);
   var v_oldringlabel = new Array(<%= vet.size() + "" %>);
   var v_oldringauthor = new Array(<%= vet.size() + "" %>);
   var v_oldringfee = new Array(<%= vet.size() + "" %>);
   var v_oldvaliddate = new Array(<%= vet.size() + "" %>);
   var v_opertype = new Array(<%= vet.size() + "" %>);
   var v_olduservalidday = new Array(<%= vet.size() + "" %>);
   var v_grplabel = new Array(<%= vet.size() + "" %>);
   var v_grptype = new Array(<%= vet.size() + "" %>);
   var v_grpid = new Array(<%= vet.size() + "" %>);

<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_spindex[<%= i + "" %>] = '<%= (String)hash.get("operid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
   v_ringauthor[<%= i + "" %>] = '<%= (String)hash.get("singgername") %>';
    if(<%=issupportmultipleprice%> == 1){
    v_ringfee2[<%= i + "" %>] = '<%= (String)hash.get("ringfee2") %>';
    }
   v_ringfee[<%= i + "" %>] = '<%= (String)hash.get("ringfee") %>';
   v_seqno[<%= i + "" %>] = '<%= (String)hash.get("seqno") %>';
   v_validdate[<%= i + "" %>] = '<%= (String)hash.get("validdate") %>';
   v_uservalidday[<%= i + "" %>] = '<%= (String)hash.get("uservalidday") %>';
   v_oldringlabel[<%= i + "" %>] = '<%= (String)hash.get("oldringlabel") %>';
   v_oldringauthor[<%= i + "" %>] = '<%= (String)hash.get("oldringauthor") %>';
    if(<%=issupportmultipleprice%> == 1){
    v_oldringfee2[<%= i + "" %>] = '<%= (String)hash.get("oldringfee2") %>';
    }
   v_oldringfee[<%= i + "" %>] = '<%= (String)hash.get("oldringfee") %>';
   v_oldvaliddate[<%= i + "" %>] = '<%= (String)hash.get("oldvaliddate") %>';
   v_opertype[<%= i + "" %>] = '<%= (String)hash.get("opertype") %>';
   v_olduservalidday[<%= i + "" %>] = '<%= (String)hash.get("olduservalidday") %>';
v_grplabel[<%= i + "" %>] = '<%= (String)hash.get("grouplabel") %>';
v_grptype[<%= i + "" %>] = '<%= (String)hash.get("ringgrptype") %>';
v_grpid[<%= i + "" %>] = '<%= (String)hash.get("ringgroup") %>';

<%
            }
%>
   function selectRing () {
      var fm = document.inputForm;
      var index = fm.ringlist.value;
      //fm.ringindex.value = '';
      if (index == null) {
         fm.ringlist.focus();
         return;
      }
      if (index == '')
         return;
      fm.seqno.value = v_seqno[index];
      fm.spindex.value = v_spindex[index];
      fm.ringlabel.value = v_ringlabel[index];
      fm.ringauthor.value = v_ringauthor[index];
       if(<%=issupportmultipleprice%> == 1){
        fm.ringfee2.value = v_ringfee2[index];
        }
      fm.ringfee.value = v_ringfee[index];
      fm.validdate.value = v_validdate[index];
      fm.uservalidday.value = v_uservalidday[index];
      fm.oldringlabel.value = v_oldringlabel[index];
      fm.oldringauthor.value = v_oldringauthor[index];
      if(<%=issupportmultipleprice%> == 1){
       fm.oldringfee2.value = v_oldringfee2[index];
       }
      fm.oldringfee.value = v_oldringfee[index];
      fm.oldvaliddate.value = v_oldvaliddate[index];
      fm.olduservalidday.value = v_olduservalidday[index];
      fm.grplabel.value = v_grplabel[index];

      if(v_grptype[index]=='1')
      fm.grptype.value = 'Music box'; //音乐盒
      if(v_grptype[index]=='2')
      fm.grptype.value = 'Big gift';  //大礼包
      fm.grpid.value = v_grpid[index];
      if(v_opertype[index]=='0')
      fm.opertype.value = 'Modify'; //修改
      if(v_opertype[index]=='1')
      fm.opertype.value = 'Delete'; //删除
      if(v_opertype[index]=='100')
      fm.opertype.value = 'Modify ringtone group information';//修改铃音组信息
      if(v_opertype[index]=='101')
      fm.opertype.value = 'Delete system ringtone group';//删除系统铃音组
      if(v_opertype[index]=='102')
      fm.opertype.value = 'Add ringtone group member';//增加铃音组成员
      if(v_opertype[index]=='103')
      fm.opertype.value = 'Modify ringtone group member';//修改铃音组成员
      if(v_opertype[index]=='104')
      fm.opertype.value = 'Delete ringtone group member';//删除铃音组成员
   }

   function checkpass (opflag) {
      //opflag: 1:审核通过,0:审核拒绝
       fm = document.inputForm;
       var strcon = "";
       var strtemp = "";
       switch(opflag){
        case 1:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group) for operation audit";//请先选择要操作审核的铃音(组)
          strtemp = "Are you sure this <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group) have passed the operation audit?";//您确认这条铃音(组)通过操作审核吗？
          break;
        case 0:
          strcon = "Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group) that passed the operation audit";//请先选择拒绝通过操作审核的铃音(组)
          strtemp = "Are you sure that you refuse the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to pass the operation audit?";//您确认拒绝这条铃音(组)通过操作审核吗？
          if(!checkRefuse())
           return;
          break;
      }
      if (trim(fm.seqno.value) == '') {
         alert(strcon);
         return;
      }
      if (confirm(strtemp) == 0)
         return;
      fm.op.value = opflag;
      fm.submit();
   }

   function checkRefuse () {
      fm = document.inputForm;
      if (fm.seqno.value == '') {
         alert('Please select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to refuse!');//请先选择要拒绝的铃音!
         return false;
      }
      if(fm.ischeck[0].checked){
          if(fm.refusecomment.selectedIndex == -1){
             alert("Please select the rejection reason!");//请选择Rejection reason!
             return false;
          }
          fm.reasontext.value = fm.refusecomment.options[fm.refusecomment.selectedIndex].text;
      } else {
          var value = trim(fm.reason.value);
          if(value == ''){
              alert("Please input the rejection reason!");//请输入Rejection reason!
              fm.reason.focus();
              return false;
          }
          if(strlength(value)>100){
              alert("The rejection reason  cannot larger than 100 bytes,please re-enter!");//Rejection reason不能超过100个字节长度,请重新输入!
              fm.reason.focus();
              return false;
          }
          fm.reasontext.value = fm.reason.value;
      }
      return true;
   }

   function searchInfo () {
      fm = document.inputForm;
      if (!CheckInputStr(fm.qryRingName,'The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name for audit')){ //待审核Ringtone name
         fm.qryRingName.focus();
         return  ;
      }
      fm.op.value = '';
      fm.submit();
   }
   function OnRadioCheck(){
      var fm = document.inputForm;
      if(fm.ischeck[0].checked){
          id_text.style.display = 'none';
          id_select.style.display = 'block';
      }
      else{
          id_text.style.display = 'block';
          id_select.style.display = 'none';
      }
   }

</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="800";
</script>
<form name="inputForm" method="post" action="checkmusicoper.jsp">
<input type="hidden" name="seqno" value="">
  <input type="hidden" name="grpid" value="">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="reasontext" value="">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" cellspacing="0" cellpadding="0" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">System <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group operation audit</td>
        </tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr >
        <td colspan=2>
		    <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2" width="95%">
		    <tr>
			<td >Please select SP</td>
			<td>
               <select name="sp" class="select-style1"  >
               <option value="">-All SP-</option>
               <%
          	    String str = "";
          	    for (int i = 0; i < spInfo.size(); i++) {
                HashMap map1 = (HashMap)spInfo.get(i);
				String spdex = (String)map1.get("spindex");
				if (spIndex.equals(spdex))
				   str = "<option value= " + (String)map1.get("spindex") + " selected >" + (String)map1.get("spname") + "</option>";
				else
				   str = "<option value= " + (String)map1.get("spindex") + " >" + (String)map1.get("spname") + "</option>";

                  out.println(str);
                }
               %>
               </select>
               </td>
               </tr>
               <tr>
                 <td >The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group) name for audit</td>
                 <td><input type="text" name="qryRingName" value="<%= qryRingName %>" maxlength="20" class="input-style1">
                     <img border="0" src="button/search.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:searchInfo()">
                 </td>
               </tr>
			   </table>
         </td>
		 </tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td width=40% align="right">
            <select name="ringlist" size="28" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectRing()">
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i %>"><%= (String)hash.get("ringlabel") %></option>
<%
            }
%>
            </select>
          </td>
          <td width="60%">
              <table border="0"  cellspacing="1" cellpadding="1" class="table-style2">
               <tr>
                 <td height="22" align="right">SP</td>
                 <td height="22">
                 <select name="spindex" disabled class="input-style1">
                    <option value="0"><%= jName %></option>
<%
            for (int i = 0; i < spInfo.size(); i++) {
                HashMap map1  = (HashMap)spInfo.get(i);
%>
                    <option value="<%= (String)map1.get("spindex") %>"><%= (String)map1.get("spname") %></option>
<%
                    }
%>
                 </select>
                 </td>
               </tr>
                <tr>
                 <td align="right">Operation type for approval</td>
                 <td><input type="text" name="opertype" disabled value="" maxlength="20" class="input-style1">
                 </td>
               </tr>
                <tr>
                 <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group name</td>
                 <td><input type="text" name="grplabel" disabled value="" maxlength="20" class="input-style1">
                 </td>
               </tr>
                <tr>
                 <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> group type</td>
                 <td><input type="text" name="grptype" disabled value="" maxlength="20" class="input-style1">
                 </td>
               </tr>
               <tr>
                 <td height="22" align="right">Original <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group) name</td>
                 <td height="22"><input type="text" name="oldringlabel" disabled style="input-style1"></td>
               </tr>
                 <tr>
                 <td height="22" align="right">Old  <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></td>
                 <td height="22"><input type="text" name="oldringauthor" disabled style="input-style1"></td>
               </tr>
               <%if(issupportmultipleprice == 1){%>
               <tr>
                 <td height="22" align="right">Old  <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group)Daily price(fee)</td>
                 <td height="22"><input type="text" name="oldringfee2" disabled style="input-style1"></td>
               </tr>
               <%}%>
               <tr>
                 <td height="22" align="right">Old  <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group) <%if(issupportmultipleprice == 1){%>Monthly <%}%> price(fee)</td>
                 <td height="22"><input type="text" name="oldringfee" disabled style="input-style1"></td>
               </tr>

                <tr>
                 <td height="22" align="right">Old  subscriber's period of validity</td>
                 <td height="22"><input type="text" name="olduservalidday" disabled style="input-style1"></td>
               </tr>
                <tr>
                 <td height="22" align="right">Copyright's period of validity</td>
                 <td height="22"><input type="text" name="oldvaliddate" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group) name</td>
                 <td height="22"><input type="text" name="ringlabel" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%></td>
                 <td height="22"><input type="text" name="ringauthor" disabled style="input-style1"></td>
               </tr>
               <tr style="display:none">
                 <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> provider</td>
                 <td height="22"><input type="text" name="ringsource" disabled style="input-style1"></td>
               </tr>
               <%if(issupportmultipleprice == 1){%>
               <tr>
                 <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group)Daily price(<%=minorcurrency%>)</td>
                 <td height="22"><input type="text" name="ringfee2" disabled style="input-style1"></td>
				 </tr>
				 <%}%>
               <tr>
                 <td height="22" align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>(group) <%if(issupportmultipleprice == 1){%>Monthly <%}%> price(<%=minorcurrency%>)</td>
                 <td height="22"><input type="text" name="ringfee" disabled style="input-style1"></td>
               </tr>

                <tr>
                 <td height="22" align="right">Subscriber's period of validity</td>
                 <td height="22"><input type="text" name="uservalidday" disabled style="input-style1"></td>
               </tr>
                <tr>
                 <td height="22" align="right">Copyright's period of validity</td>
                 <td height="22"><input type="text" name="validdate" disabled style="input-style1"></td>
               </tr>
               <tr>
                <td height="22" align="right">Refuse</td>
                <td>
                <table border="0" width="100%" class="table-style2">
                <tr align="center">
                  <td width="50%"><input type="radio" checked name="ischeck" value="0" onclick="OnRadioCheck()" checked >Select</td>
                  <td width="50%"><input type="radio" name="ischeck" value="1" onclick="OnRadioCheck()" >Input</td>
                 </tr>
                 </table>
                 </td>
               </tr>
               <tr>
                   <td height="22" align="right">Refused reason</td>
                   <td height="22" style='display:block' id="id_select" >
                   <select name="refusecomment" class="input-style1">
                 <%
                   Vector refuseComment = refuseComment();
                   for (int i = 0; i < refuseComment.size(); i++) {
                  %>
                     <option value="<%= i %>"><%= (String)refuseComment.get(i) %></option>
                  <%
                   }
                  %>
                  </select>
                 </td>
                  <td height="22" style="display:none" id="id_text" ><input type="text" name="reason" maxlength="100" value="" style="input-style1"></td>
                 </tr>
                 </table>
           </td>
           </tr>
         <tr>
          <td align="center" colspan=2 height=40>
            <table border="0" width="85%" class="table-style2" align="center">
              <tr >
                <td width="20%" align="center" ><input type='button'  name="checkpass1" value="Audit pass" onclick="javascript:checkpass(1)"></td>
                <td width="20%" align="center" ><input type='button'  name="checkpass2"   value="Audit not pass"  onclick="javascript:checkpass(0)"></td>
                </tr>
            </table>
          </td>
        </tr>
      </table>
 </td>
 </tr>
 </table>
</form>
<script language="javascript">
</script>
<%
        }
    }
    catch(Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occour on the audit of system ringtone audit!");//系统铃音审核过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + " error occour on the audit of system ringtone audit!");//系统铃音审核出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="checkmusicoper.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

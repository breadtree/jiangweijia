<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public Vector refuseComment() {
        Vector vet = new Vector();
        vet.add("Refuse this Discount");//
        vet.add("Invalid Discount property");//套餐属性配置不正确
        vet.add("Invalid Discount name");
        vet.add("Unreasonable Discount price");//套餐价格不合理
        vet.add("Unknown reason");
        return vet;
    }
%>
<html>
<head>
<title>SP Discount audit</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
    String sysTime = "";
    String jName = (String)application.getAttribute("JNAME");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing sysring = new manSysRing();
        sysTime = sysring.getSysTime() + "--";
        int     operflag = 0; //0:无权限
        if (purviewList.get("6-14") != null)
           operflag = 1;
        if(operflag ==0 || operID==null){
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to system first!" : "You have no access to the function!" %>');
	document.URL = 'enter.jsp';
</script>
<%
        }
        else if (operID != null) {
            String spIndex = (String)request.getParameter("sp")==null?"0":(String)request.getParameter("sp");
            String qryDiscountName = request.getParameter("qryDiscountName") == null ? "" : transferString((String)request.getParameter("qryDiscountName")).trim();
            String discountid = request.getParameter("discountid") == null ? "" : ((String)request.getParameter("discountid")).trim();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String refusecomment = request.getParameter("reasontext") == null ? "": transferString((String)request.getParameter("reasontext")).trim();
            manSysPara  syspara = new manSysPara();
            ArrayList spInfo = syspara.getSPInfo();

            // 铃音审核通过
            int checkflag =0;
            ArrayList rList = new ArrayList();
            String    title = "SP Discount audit";
            Hashtable tTmp = new Hashtable();
            if (op.equals("1")) {    //审核通过
                 rList = sysring.checkDiscount("1",discountid,"Audit passed");
             }
            else if (op.equals("2")){ //审核拒绝
                rList = sysring.checkDiscount("2",discountid,refusecomment);
            }
            if(rList.size()>0){
              //填写操作员日志
              if(getResultFlag(rList)){
                  // 准备写操作员日志
                  zxyw50.Purview purview = new zxyw50.Purview();
                  HashMap map = new HashMap();
                  map.put("OPERID",operID);
                  map.put("OPERNAME",operName);
                  map.put("OPERTYPE","614");
                  map.put("RESULT","1");
                  map.put("PARA1",op);
                  map.put("PARA2",discountid);
                   for(int i=0;i<spInfo.size();i++)
                  if(spIndex.equals(((HashMap)spInfo.get(i)).get("spindex"))){
                    map.put("PARA3",((HashMap)spInfo.get(i)).get("spname"));
                  }
                 map.put("DESCRIPTION",refusecomment+" ip:"+request.getRemoteAddr());
                  purview.writeLog(map);
                }
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="checkdiscount.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
            HashMap hash = new HashMap();
            hash.put("spindex",spIndex);
            hash.put("discountname",qryDiscountName);
            Vector vet = sysring.getCheckDiscount(hash);

%>
<script language="javascript">

   var v_spindex = new Array(<%= vet.size() + "" %>);
   var v_discountid = new Array(<%= vet.size() + "" %>);
   var v_discountname = new Array(<%= vet.size() + "" %>);
   var v_rentfee = new Array(<%= vet.size() + "" %>);
   var v_freerings = new Array(<%= vet.size() + "" %>);
    var v_isshow  = new Array(<%= vet.size() + "" %>);
   var v_bflag =new Array(<%= vet.size() + "" %>);
   var v_expiredate  = new Array(<%= vet.size() + "" %>);
   var v_discountdesc  = new Array(<%= vet.size() + "" %>);
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (HashMap)vet.get(i);
%>
   v_discountid[<%= i + "" %>] = '<%= (String)hash.get("discountid") %>';
   v_spindex[<%= i + "" %>] = '<%= (String)hash.get("spindex") %>';
   v_discountname[<%= i + "" %>] = '<%= (String)hash.get("discountname") %>';
   v_rentfee[<%= i + "" %>] = '<%= (String)hash.get("rentfee") %>';
   v_freerings[<%= i + "" %>] = '<%= (String)hash.get("freerings") %>';
    v_isshow[<%= i + "" %>] = '<%= (String)hash.get("isshow") %>';
   v_bflag[<%= i + "" %>] = '<%= (String)hash.get("bflag") %>';
   v_expiredate[<%= i + "" %>] = '<%= (String)hash.get("expiredate") %>';
   v_discountdesc[<%= i + "" %>] ='<%= JspUtil.convert((String)hash.get("discountdesc")) %>';
<%
            }
%>
   function selectRing () {
      var fm = document.inputForm;
      var index = fm.ringlist.value;
      if (index == null) {
         fm.ringlist.focus();
         return;
      }
      if (index == '')
         return;
      fm.discountid.value = v_discountid[index];
      fm.spindex.value = v_spindex[index];
      fm.discountname.value = v_discountname[index];
      fm.rentfee.value = v_rentfee[index];
      fm.freerings.value = v_freerings[index];
      fm.isshow[v_isshow[index]].checked = true;
      fm.bflag[v_bflag[index]].checked = true;
      fm.expiredate.value = v_expiredate[index];
      fm.discountdesc.value=v_discountdesc[index];
   }

   function checkpass (opflag) {
      //opflag: 1:通过,2:拒绝
       fm = document.inputForm;
       var strcon = "";
       var strtemp = "";
       switch(opflag){
        case 1:
          strcon = "Please select the package you want to audit!";//请先选择要审核的套餐
          //strtemp = "您确认这条套餐通过审核吗？";
          strtemp = "Are you sure this package has passed the audit?";//您确认这条套餐通过审核吗？
          break;
        case 2:
         // strcon = "请先选择拒绝通过审核的套餐";
          strcon = "Please select the package you want to refuse";//请先选择拒绝通过审核的套餐
          strtemp = "Are you confirm your refused package has passed the audit";//您确认拒绝这条套餐通过审核吗？
          if(!checkRefuse())
             return;
          break;
      }
      if (fm.discountid.value == '') {
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
      if (fm.discountid.value == '') {
         //alert('请先选择要拒绝的套餐!');
         alert('Please select the package you want to refuse');
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
              alert("Please select the rejection reason!");//请输入Rejection reason!
              fm.reason.focus();
              return false;
          }
          if(strlength(value)>100){
              //alert("Rejection reason不能超过100个字节长度,请重新输入!");
              alert("The rejection reason cannot be larger than 100 bytes,please re-enter!");
              fm.reason.focus();
              return false;
          }
          fm.reasontext.value = fm.reason.value;
      }
      return true;
   }

   function searchInfo () {
      fm = document.inputForm;
      if (!CheckInputStr(fm.qryDiscountName,'The ringtone package name for approval')){ // 待审核套餐名称
         fm.qryDiscountName.focus();
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
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="checkdiscount.jsp">
<input type="hidden" name="discountid" value="">
<input type="hidden" name="reasontext" value="">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" cellspacing="0" cellpadding="0" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">SP Discount audit</td>
        </tr>
        <tr>
          <td height="15" colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr >
        <td colspan=2>
		    <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2" width="95%">
		    <tr>
			<td >&nbsp;&nbsp;&nbsp;&nbsp;Please select SP</td>
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
                 <td >&nbsp;&nbsp;&nbsp;&nbsp;The ringtone Discount for approval</td>
                 <td><input type="text" name="qryDiscountName" value="<%= qryDiscountName %>" maxlength="20" class="input-style1">
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
            <select name="ringlist" size="20" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectRing()">
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (HashMap)vet.get(i);
%>
              <option value="<%= i %>"><%= (String)hash.get("discountname") %></option>
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
                 <td height="22" align="right">Discount name</td>
                 <td height="22"><input type="text" name="discountname" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right">Discount price(ripee)</td>
                 <td height="22"><input type="text" name="rentfee" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right">Order ringtone num</td>
                 <td height="22"><input type="text" name="freerings" disabled style="input-style1"></td>
               </tr>
                <tr style="display:block">
            <td align="right">Display or not</td>
            <td >
                <table border="0" width="100%" class="table-style2">
                  <tr align="center">
                    <td width="50%"><input type="radio" name="isshow" value="0" >No</td>
                    <td width="50%"><input type="radio" name="isshow" value="1" checked >Yes</td>
                  </tr>
                </table>
            </td>
         </tr>

            <tr style="display:block">
            <td align="right">Take effect or not</td>
            <td >
                <table border="0" width="100%" class="table-style2">
                  <tr align="center">
                    <td width="50%"><input type="radio" name="bflag" value="0" >Invalid</td>
                    <td width="50%"><input type="radio" name="bflag" value="1" checked >Valid</td>
                  </tr>
                </table>
            </td>
         </tr>
        <tr>
          <td align="right">Expire date(yyyy.mm.dd)</td>
          <td><input type="text" name="expiredate" value="" maxlength="10" class="input-style1"></td>
        </tr>

         <tr>
         <td align="right">Description</td>
         <td colspan="2">
         <p>
         <textarea name="discountdesc"  rows="3"></textarea>
         </p>
         </td>
         <tr>
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
                <td width="20%" align="center" ></td>
                <td width="20%" align="center" ><input type='button'  style="width:150px" name="checkpass1" value="Pass" onclick="javascript:checkpass(1)"></td>
                <td width="20%" align="center" ><input type='button'  style="width:150px" name="checkpass2"   value="Refused"  onclick="javascript:checkpass(2)"></td>
                <td width="20%" align="center" ></td>
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
        else {
              if(operID== null){
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
                   alert( "Sorry. You have no permission for this function!");
              </script>
              <%

                   }

        }
    }
    catch(Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occurred  in SP package for approval");//套餐审核过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + "Error occurred  in SP package for approval");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="checkdiscount.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

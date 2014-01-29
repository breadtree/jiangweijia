<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.JspUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<%!
    public Vector refuseComment() {
        Vector vet = new Vector();
        vet.add("Refuse this discount"); //该套餐审核不通过
        vet.add("Invalid Discount property");//套餐属性配置不正确
        vet.add("Discount name exist");//套餐名称已经存在
        vet.add("Unreasonable price");//套餐价格不合理
        vet.add("Unknown reason"); //不明原因
        return vet;
    }
%>
<html>
<head>
<title>Discount operation audit</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1" >
<%
	String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	int ratio = Integer.parseInt(currencyratio);




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
        if (purviewList.get("6-15") != null)
           operflag = 1;
        if(operflag ==0 || operID==null){
%>
<script language="javascript">
    alert('<%= operID == null ? "Please log in to the system first!" : "Sorry. You have no permission for this function!" %>');
	document.URL = 'enter.jsp';
</script>
<%
        }
        else if (operID != null) {
            zxyw50.Purview purview = new zxyw50.Purview();
            String seqno = request.getParameter("seqno") == null ? "" : ((String)request.getParameter("seqno")).trim();
            String op = request.getParameter("op") == null ? "" : ((String)request.getParameter("op")).trim();
            String refusecomment = request.getParameter("reasontext") == null ? "" : transferString((String)request.getParameter("reasontext")).trim();
            String discountid = request.getParameter("discountid") == null ? "" : ((String)request.getParameter("discountid")).trim();
            if (op.equals("0")){ //审核不通过
                rList = sysring.checkDiscountrefuse(Integer.parseInt(seqno),operName,refusecomment);
            // 准备写操作员日志
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","615");
            map.put("RESULT","1");
            map.put("PARA1",seqno);
            map.put("PARA2","2");
            map.put("PARA3",spIndex);
            map.put("PARA4",refusecomment);
            map.put("PARA5","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
            }
            else if (op.equals("1")){  //审核通过
                rList = sysring.checkDiscountpass(Integer.parseInt(seqno),operName);
            // 准备写操作员日志
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","615");
            map.put("RESULT","1");
            map.put("PARA1",seqno);
            map.put("PARA2","1");
            map.put("PARA3",spIndex);
            map.put("PARA4",refusecomment);
            map.put("PARA5","ip:"+request.getRemoteAddr());
            purview.writeLog(map);
            }
            if(rList.size()>0){
             session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="checkdiscountoper.jsp">
<input type="hidden" name="title" value="SP Discount operation audit">
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
            Vector vet = sysring.getDiscountCheckOper(hash);
%>
<script language="javascript">
   var v_spindex = new Array(<%= vet.size() + "" %>);
   var v_seqno = new Array(<%= vet.size() + "" %>);
   var v_opertype = new Array(<%= vet.size() + "" %>);
   var v_discountid= new Array(<%= vet.size() + "" %>);

   var v_discountname = new Array(<%= vet.size() + "" %>);
   var v_olddiscountname = new Array(<%= vet.size() + "" %>);
   var v_rentfee = new Array(<%= vet.size() + "" %>);
   var v_oldrentfee = new Array(<%= vet.size() + "" %>);
   var v_freerings = new Array(<%= vet.size() + "" %>);
   var v_oldfreerings = new Array(<%= vet.size() + "" %>);
   var v_isshow = new Array(<%= vet.size() + "" %>);
   var v_oldisshow = new Array(<%= vet.size() + "" %>);
   var v_bflag = new Array(<%= vet.size() + "" %>);
   var v_oldbflag = new Array(<%= vet.size() + "" %>);
   var v_expiredate = new Array(<%= vet.size() + "" %>);
   var v_oldexpiredate = new Array(<%= vet.size() + "" %>);
   var v_discountdesc = new Array(<%= vet.size() + "" %>);
   var v_olddiscountdesc = new Array(<%= vet.size() + "" %>);

<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_spindex[<%= i + "" %>] = '<%= (String)hash.get("operid") %>';
   v_seqno[<%= i + "" %>] = '<%= (String)hash.get("seqno") %>';
   v_opertype[<%= i + "" %>] = '<%= (String)hash.get("opertype") %>';
   v_discountid[<%= i + "" %>] = '<%= (String)hash.get("discountid") %>';

   v_discountname[<%= i + "" %>] = '<%= (String)hash.get("discountname") %>';
   v_olddiscountname[<%= i + "" %>] = '<%= (String)hash.get("olddiscountname") %>';
   v_rentfee[<%= i + "" %>] = '<%= (String)hash.get("rentfee") %>';
   v_oldrentfee[<%= i + "" %>] = '<%= (String)hash.get("oldrentfee") %>';
   v_freerings[<%= i + "" %>] = '<%= (String)hash.get("freerings") %>';
   v_oldfreerings[<%= i + "" %>] = '<%= (String)hash.get("oldfreerings") %>';
   v_isshow[<%= i + "" %>] = '<%= (String)hash.get("isshow") %>';
   v_oldisshow[<%= i + "" %>] = '<%= (String)hash.get("oldisshow") %>';
   v_bflag[<%= i + "" %>] = '<%= (String)hash.get("bflag") %>';
   v_oldbflag[<%= i + "" %>] = '<%= (String)hash.get("oldbflag") %>';
   v_expiredate[<%= i + "" %>] = '<%= (String)hash.get("expiredate") %>';
   v_oldexpiredate[<%= i + "" %>] = '<%= (String)hash.get("oldexpiredate") %>';
   v_discountdesc[<%= i + "" %>] = '<%= JspUtil.convert((String)hash.get("discountdesc"))%>';
   v_olddiscountdesc[<%= i + "" %>] = '<%=JspUtil.convert((String)hash.get("olddiscountdesc"))%>';

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
      fm.seqno.value = v_seqno[index];
      fm.spindex.value = v_spindex[index];
      fm.discountid.value = v_discountid[index];
      fm.discountname.value = v_discountname[index];
      fm.olddiscountname.value = v_olddiscountname[index];
      fm.rentfee.value = v_rentfee[index];
      fm.oldrentfee.value = v_oldrentfee[index];
      fm.oldfreerings.value = v_oldfreerings[index];
      fm.freerings.value = v_freerings[index]=='0'?v_oldfreerings[index]:v_freerings[index];
      fm.expiredate.value = v_expiredate[index];
      fm.oldexpiredate.value = v_oldexpiredate[index];
      fm.discountdesc.value = v_discountdesc[index];
      fm.olddiscountdesc.value = v_olddiscountdesc[index];
      if(v_opertype[index]=='0')
      fm.opertype.value = 'Modify SP discount information';
      if(v_opertype[index]=='1')
      fm.opertype.value = 'Delete SP discount';

      if(v_oldisshow[index]=='1') {
        fm.oldisshow[1].checked = true;
      } else if(v_oldisshow[index]=='0') {
        fm.oldisshow[0].checked = true;
      }

      if(v_isshow[index]=='1') {
        fm.isshow[1].checked = true;
      } else if(v_isshow[index]=='0') {
        fm.isshow[0].checked = true;
      }

      if(v_oldbflag[index]=='1') {
        fm.oldbflag[1].checked = true;
      } else if(v_oldbflag[index]=='0') {
        fm.oldbflag[0].checked = true;
      }

      if(v_bflag[index]=='1') {
        fm.bflag[1].checked = true;
      } else if(v_bflag[index]=='0') {
        fm.bflag[0].checked = true;
      }
   }
   function checkpass (opflag) {
      //opflag: 1:审核通过,0:审核拒绝
       fm = document.inputForm;
       var strcon = "";
       var strtemp = "";
       switch(opflag){
        case 1:
         //strcon = "请先选择要操作审核的套餐";
          strcon = "Please select the discount you want to operation audit.";
         // strtemp = "您确认这条套餐通过操作审核吗？";
          strtemp = "Are you sure this discounthave pass the operation audit?";
          break;
        case 0:
         // strcon = "请先选择拒绝通过操作审核的套餐";
            strcon = "Please select the discount you will refuse to pass the  operation audit.";
         // strtemp = "您确认拒绝这条套餐通过操作审核吗？";
            strtemp =" Are you sure you want to refuse this discount to pass the operation audit?"; 
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
         //alert('请先选择要操作审核的套餐');
         alert('Please select the discount you want to operation audit');
         return false;
      }
      if(fm.ischeck[0].checked){
          if(fm.refusecomment.selectedIndex == -1){
            // alert("请选择Rejection reason!");
             alert('Please select the reason of refuse!');
             return false;
          }
          fm.reasontext.value = fm.refusecomment.options[fm.refusecomment.selectedIndex].text;
      } else {
          var value = trim(fm.reason.value);
          if(value == ''){
             // alert("请输入Rejection reason!");
               alert("Please input the reason of refuse!");
              fm.reason.focus();
              return false;
          }
          if(strlength(value)>100){
              //alert("Rejection reason不能超过100个字节长度,请重新输入!");
              alert("The reason of refuse can't be larger than 100 bytes ,please re-enter!");
              fm.reason.focus();
              return false;
          }
          fm.reasontext.value = fm.reason.value;
      }
      return true;
   }

   function searchInfo () {
      fm = document.inputForm;
      if (!CheckInputStr(fm.qryRingName,'The discount name for approval')){
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
<form name="inputForm" method="post" action="checkdiscountoper.jsp">
<input type="hidden" name="seqno" value="">
 <input type="hidden" name="discountid" value="">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="reasontext" value="">
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" cellspacing="0" cellpadding="0" class="table-style2">
  <tr valign="center">
    <td>
      <table border="0" align="center" cellspacing="1" cellpadding="1" class="table-style2">
        <tr>
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">SP Discount operation audi</td>
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
                 <td >Discount name for audit</td>
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
            <select name="ringlist" size="34" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectRing()">
<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
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
                 <td align="right">Operation type for approval</td>
                 <td><input type="text" name="opertype" disabled value="" maxlength="20" class="input-style1">
                 </td>
               </tr>
               <tr>
                 <td height="22" align="right">Original Discount name</td>
                 <td height="22"><input type="text" name="olddiscountname" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right">Original Discount rentfee(fee)</td>
                 <td height="22"><input type="text" name="oldrentfee" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right">Original Discount ringtone number</td>
                 <td height="22"><input type="text" name="oldfreerings" disabled style="input-style1"></td>
               </tr>
               <tr style="display:block">
                   <td align="right">Original Discount display</td>
                   <td >
                <table border="0" width="100%" class="table-style2">
                  <tr align="center">
                    <td width="50%"><input type="radio" name="oldisshow" value="0" >No</td>
                    <td width="50%"><input type="radio" name="oldisshow" value="1" checked>Yes</td>
                  </tr>
                </table>
            </td>
         </tr>
                <tr style="display:block">
            <td align="right">Original Discount state</td>
            <td >
                <table border="0" width="100%" class="table-style2">
                  <tr align="center">
                    <td width="50%"><input type="radio" name="oldbflag" value="0" >Invalidation</td>
                    <td width="50%"><input type="radio" name="oldbflag" value="1" checked >Valid</td>
                  </tr>
                </table>
            </td>
         </tr>
               <tr>
                 <td height="22" align="right">The original Discount expire time</td>
                 <td height="22"><input type="text" name="oldexpiredate" disabled style="input-style1"></td>
               </tr>
        <tr>
         <td align="right">Original description</td>
         <td colspan="2">
         <p>
         <textarea name="olddiscountdesc"  rows="3"></textarea>
         </p>
         </td>
         <tr>
               <tr>
                 <td height="22" align="right">Discount name</td>
                 <td height="22"><input type="text" name="discountname" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right">Monthly rent of the discount (<%=minorcurrency%>)</td>
                 <td height="22"><input type="text" name="rentfee" disabled style="input-style1"></td>
               </tr>
               <tr>
                 <td height="22" align="right">Discount ringtone number</td>
                 <td height="22"><input type="text" name="freerings" disabled style="input-style1"></td>
               </tr>
              <tr style="display:block">
                   <td align="right">Discount display</td>
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
            <td align="right">Discount state</td>
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
                 <td height="22" align="right">Discount expire time </td>
                 <td height="22"><input type="text" name="expiredate" disabled style="input-style1"></td>
               </tr>
                <tr>
         <td align="right">Discount describe</td>
         <td colspan="2">
         <p>
         <textarea name="discountdesc"  rows="3"></textarea>
         </p>
         </td>
         <tr>
               <tr>
                <td height="22" align="right">Refuse </td>
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
                <td width="20%" align="center" ><input type='button'  name="checkpass2"   value="Audit refused"  onclick="javascript:checkpass(0)"></td>
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
        sysInfo.add(sysTime + operName + " Exception occurred in the audit of system ringtone!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + " Exception occurred in the audit of system ringtone!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
</form>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="checkdiscountoper.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

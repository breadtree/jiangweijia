<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>


<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Manage subscriber charge types</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%

	 String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 int ratio = Integer.parseInt(currencyratio);

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

    try {
        manSysPara syspara = new manSysPara();

        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-38") != null) {

            Vector vet = new Vector();
            ArrayList rList  = new ArrayList();
            Hashtable hash = new Hashtable();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
            String usertype = request.getParameter("usertype") == null ? "" : transferString((String)request.getParameter("usertype")).trim();
            String subservice = request.getParameter("subservice") == null ? "" : transferString((String)request.getParameter("subservice")).trim();
            String utlabel = request.getParameter("utlabel") == null ? "" : transferString((String)request.getParameter("utlabel")).trim();
            String monthfee = request.getParameter("monthfee") == null ? "" : transferString((String)request.getParameter("monthfee")).trim();
            String monthfeediscount = request.getParameter("monthfeediscount") == null ? "" : transferString((String)request.getParameter("monthfeediscount")).trim();
            String nmonthfeediscount = request.getParameter("nmonthfeediscount") == null ? "" : transferString((String)request.getParameter("nmonthfeediscount")).trim();
            String commencement = request.getParameter("commencement") == null ? "" : transferString((String)request.getParameter("commencement")).trim();
            String ringfeediscount = request.getParameter("ringfeediscount") == null ? "" : transferString((String)request.getParameter("ringfeediscount")).trim();
            String nringfeediscount = request.getParameter("nringfeediscount") == null ? "" : transferString((String)request.getParameter("nringfeediscount")).trim();
            String commencement1 = request.getParameter("commencement1") == null ? "" : transferString((String)request.getParameter("commencement1")).trim();
            String taxrate = request.getParameter("taxrate") == null ? "" : transferString((String)request.getParameter("taxrate")).trim();

            // 单位是万分之一，要作*100+10000处理
            if(taxrate!=null&&taxrate.trim().length()>0)
            {
             // float b = Float.parseFloat(taxrate)*100+10000;
              double b =Double.parseDouble(taxrate)*100+10000;
             taxrate = String.valueOf((new Float(b)).intValue());

            }
            String logdescripion = request.getParameter("logdescripion") == null ? "" : transferString((String)request.getParameter("logdescripion")).trim();

            String opcode = "1";

            if(op.trim().equals("add"))
            {
              opcode = "1";
            }
            else if(op.trim().equals("del"))
            {
              opcode = "2";
            }
            else if(op.trim().equals("edit"))
            {
              opcode = "3";
            }

            hash.put("opcode",opcode);
            hash.put("usertype",usertype);
            hash.put("subservice",subservice);
            hash.put("utlabel",utlabel);
            hash.put("monthfee",monthfee);
            hash.put("monthfeediscount",monthfeediscount);
            hash.put("nmonthfeediscount",nmonthfeediscount);
            hash.put("commencement",commencement);
            hash.put("ringfeediscount",ringfeediscount);
            hash.put("nringfeediscount",nringfeediscount);
            hash.put("commencement1",commencement1);
            hash.put("taxrate",taxrate);


            String title = "";
            String sDEsc = "";
            if (op.equals("add")) {

            }
            else if (op.equals("edit")) {
                rList = syspara.editUserTypeCharge(hash);
                title = "Edit subscriber charge type:" + utlabel;
                sDEsc = "Edit";
                sysInfo.add(sysTime + operName + "Subscriber charge type edited successfully!");//Edit用户计费类型成功
            }
            else if (op.equals("del")) {


            }

             // 准备写操作员日志
            if(!op.equals("") && getResultFlag(rList)){
               zxyw50.Purview purview = new zxyw50.Purview();
               HashMap map = new HashMap();
               map.put("OPERID",operID);
               map.put("OPERNAME",operName);
               map.put("OPERTYPE","338");
               map.put("RESULT","1");
               map.put("PARA1",monthfee);
               map.put("PARA2",monthfeediscount);
               map.put("PARA3",nmonthfeediscount);
               map.put("PARA4",ringfeediscount);
               map.put("PARA5",nringfeediscount);
               map.put("PARA6",taxrate);
               map.put("DESCRIPTION",logdescripion);
               purview.writeLog(map);
            }
            if(rList.size()>0){
                session.setAttribute("rList",rList);
            %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="userTypeCharge.jsp">
<input type="hidden" name="title" value="<%= title %>">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
            <%
               }
            vet = syspara.getUserTypeCharge();
%>
<script language="javascript">

   var v_usertype = new Array(<%= vet.size() + "" %>);
   var v_subservice = new Array(<%= vet.size() + "" %>);
   var v_utlabel = new Array(<%= vet.size() + "" %>);
   var v_monthfee = new Array(<%= vet.size() + "" %>);
   var v_monthfeediscount = new Array(<%= vet.size() + "" %>);
   var v_nmonthfeediscount = new Array(<%= vet.size() + "" %>);
   var v_commencement = new Array(<%= vet.size() + "" %>);
   var v_ringfeediscount = new Array(<%= vet.size() + "" %>);
   var v_nringfeediscount = new Array(<%= vet.size() + "" %>);
   var v_commencement1 = new Array(<%= vet.size() + "" %>);
   var v_taxrate = new Array(<%= vet.size() + "" %>);
   var v_logdescripion = new Array(<%= vet.size() + "" %>);

<%
            for (int i = 0; i < vet.size(); i++) {
                hash = (Hashtable)vet.get(i);
%>
   v_usertype[<%= i + "" %>] = '<%= (String)hash.get("usertype") %>';
   v_subservice[<%= i + "" %>] = '<%= (String)hash.get("subservice") %>';
   v_utlabel[<%= i + "" %>] = '<%= (String)hash.get("utlabel") %>';
   v_monthfee[<%= i + "" %>] = '<%= (String)hash.get("monthfee") %>';
   v_monthfeediscount[<%= i + "" %>] = '<%= (String)hash.get("monthfeediscount") %>';
   v_nmonthfeediscount[<%= i + "" %>] = '<%= (String)hash.get("nmonthfeediscount") %>';
   v_commencement[<%= i + "" %>] = '<%= (String)hash.get("commencement") %>';
   v_ringfeediscount[<%= i + "" %>] = '<%= (String)hash.get("ringfeediscount") %>';
   v_nringfeediscount[<%= i + "" %>] = '<%= (String)hash.get("nringfeediscount") %>';
   v_commencement1[<%= i + "" %>] = '<%= (String)hash.get("commencement1") %>';
   v_taxrate[<%= i + "" %>] = '<%= (String)hash.get("taxrate") %>';
   v_logdescripion[<%= i + "" %>] = v_utlabel[<%= i + "" %>]+','+v_monthfee[<%= i + "" %>] +','+v_monthfeediscount[<%= i + "" %>] + ','+ v_nmonthfeediscount[<%= i + "" %>]+','+v_commencement[<%= i + "" %>]+','+v_ringfeediscount[<%= i + "" %>] +','+ v_nringfeediscount[<%= i + "" %>]+','+v_commencement1[<%= i + "" %>]+','+v_taxrate[<%= i + "" %>];

<%
            }
%>

    function selectInfo () {
      var fm = document.inputForm;
      var index = fm.infoList.value;
      if (index == null)
         return;
      if (index == '') {

         return;
      }
      fm.usertype.value = v_usertype[index];
      fm.subservice.value = v_subservice[index];
      fm.utlabel.value = v_utlabel[index];
      fm.monthfee.value = v_monthfee[index];
      fm.monthfeediscount.value = v_monthfeediscount[index];
      fm.nmonthfeediscount.value = v_nmonthfeediscount[index];
      fm.commencement.value = v_commencement[index];
      fm.ringfeediscount.value = v_ringfeediscount[index];
      fm.nringfeediscount.value = v_nringfeediscount[index];
      fm.commencement1.value = v_commencement1[index];
      fm.taxrate.value = v_taxrate[index];
      fm.logdescripion.value = v_logdescripion[index];

   }


   function checkInfo () {
      var fm = document.inputForm;
      var flag = false;
      var tmp;
      tmp = trim(fm.monthfee.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The monthfee can only be digital number!');//月租费只能为数字
         fm.monthfee.focus();
         return flag;
      }
      if(tmp<0){
         alert('The monthfee cannot be negative!');//月租费不能为负数
         fm.monthfee.focus();
         return flag;
      }
      tmp = trim(fm.monthfeediscount.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The monthfee discount can only be digital number!');
         fm.monthfeediscount.focus();
         return flag;
      }
      if(tmp<0||tmp>100){
         alert('The monthfee discount should be between 0 and 100');//月租费不能为负数
         fm.monthfeediscount.focus();
         return flag;
      }
      tmp = trim(fm.nmonthfeediscount.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The next monthfee discount can only be digital number!');
         fm.nmonthfeediscount.focus();
         return flag;
      }
      if(tmp<0||tmp>100){
         alert('The next monthfee discount should be between 0 and 100');//月租费不能为负数
         fm.nmonthfeediscount.focus();
         return flag;
      }
      if (trim(fm.commencement.value) == '') {
         alert("Please input the next monthfee discount effect date!");
         fm.commencement.focus();
         return flag;
      }
      if (! checkDate2(fm.commencement.value)) {
        alert("The next monthfee discount effect date input error,\r\n please input start time in the YYYY.MM.DD format!");
        fm.commencement.focus();
         return flag;
      }
      if(checktrue2(fm.commencement.value)){
        alert('The next monthfee discount effect date should be later than the current time. Please re-enter!');//有效期不能低于当前时间,请重新输入
        fm.commencement.focus();
        return flag;
      }

      tmp = trim(fm.ringfeediscount.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The ringfee discount can only be digital number!');
         fm.ringfeediscount.focus();
         return flag;
      }
      if(tmp<0||tmp>100){
         alert('The ringfee discount should be between 0 and 100');
         fm.ringfeediscount.focus();
         return flag;
      }
      tmp = trim(fm.nringfeediscount.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert('The next ringfee discount can only be digital number!');
         fm.nringfeediscount.focus();
         return flag;
      }
      if(tmp<0||tmp>100){
         alert('The next ringfee discount should be between 0 and 100');
         fm.nringfeediscount.focus();
         return flag;
      }
      if (trim(fm.commencement1.value) == '') {
         alert("Please input the next ringfee discount effect date!");
         fm.commencement1.focus();
         return false;
      }
      if (! checkDate2(fm.commencement1.value)) {
        alert("The next ringfee discount effect date input error,\r\n please input start time in the YYYY.MM.DD format!");
        fm.commencement1.focus();
         return false;
      }
     if(checktrue2(fm.commencement1.value)){
        alert('The next ringfee discount effect date should be later than the current time. Please re-enter!');//有效期不能低于当前时间,请重新输入
        fm.commencement1.focus();
        return flag;
      }
      var value = trim(fm.taxrate.value);
     if(!(/^[1-9]{1}[0-9]{0,1}\.[0-9]{0,2}$/.test(value))
     && !(/^0\.[0-9]{0,2}$/.test(value))
     && !(/^[1-9]{1}[0-9]{0,1}$/.test(value)))
     {
       alert("The tax Rate must be a positive integer less than 100 or a decimal fraction like xx.xx");
       fm.taxrate.focus();
       return false;
     }


      flag = true;
      return flag;
   }


   function editInfo () {
      var fm = document.inputForm;

      var index = fm.infoList.value;
      if (index == null)
      {
        alert("Please choose the type you want to edit");
        return;
      }
      if (index == '') {
        alert("Please choose the type you want to edit");
         return;
      }
      if (! checkInfo())
         return;
      fm.op.value = 'edit';
      fm.submit();
   }


</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="800";
</script>
<form name="inputForm" method="post" action="userTypeCharge.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="usertype" value="">
<input type="hidden" name="subservice" value="">
<input type="hidden" name="utlabel" value="">
<input type="hidden" name="logdescripion" value="">

<table width="440" height="400" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="table-style2">

        <tr >
          <td height="26" colspan="3" align="center" class="text-title" background="image/n-9.gif">User charge type management</td>
        </tr>
        <tr>

          <td rowspan="9" valign="top">
            <select name="infoList" size="20" <%= vet.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectInfo()">
<%
                for (int i = 0; i < vet.size(); i++) {
                    hash = (Hashtable)vet.get(i);
%>
              <option value="<%= i + "" %>"><%= (String)hash.get("utlabel") %></option>
<%
            }
%>
            </select>
          </td>
        </tr>

        <tr>
          <td height="22" align="right">monthfee(<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="monthfee" value="" maxlength="6" class="input-style1" ></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="monthfee discount">monthfee discount</span></td>
          <td height="22"><input type="text" name="monthfeediscount" value="" maxlength="3" class="input-style1">%</td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="next monthfee discount">next monthfee discount</span></td>
          <td height="22"><input type="text" name="nmonthfeediscount" value="" maxlength="3" class="input-style1">%</td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="next monthfee discount effect date">next monthfee discount effect date</span></td>
          <td height="22"><input type="text" name="commencement" value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="ringfee discount">ringfee discount</span></td>
          <td height="22"><input type="text" name="ringfeediscount" value="" maxlength="3" class="input-style1">%</td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="next ringfee discount">next ringfee discount</span></td>
          <td height="22"><input type="text" name="nringfeediscount" value="" maxlength="3" class="input-style1">%</td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="next ringfee discount effect date">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;next ringfee discount effect date</span></td>
          <td height="22"><input type="text" name="commencement1" value="" maxlength="10" class="input-style1"></td>
        </tr>
        <tr>
          <td height="22" align="right"><span title="tax rate">tax rate</span></td>
          <td height="22"><input type="text" name="taxrate" value="" maxlength="6" class="input-style1">%</td>
        </tr>

        <tr align="center">
          <td colspan="3">
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
              <td width="25%" align="center"><img src="button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
              </tr>
            </table>
          </td>
        </tr>
        <!--
        <tr>
          <td colspan="3" > <table border="0" width="100%" class="table-style2">
              <tr><td height=10 > &nbsp;&nbsp;</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;Notes:</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. The modified month-rent will take effect in NEXT month.</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. The max-number of day's ringtone orders,-1:No limit,0:Means can't order;</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. The max-number of getting password in one day,-1:No limit,0:Means can't get password;</td></tr>
              <tr><td style="color: #FF0000" > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. Cannot modify rental type when modify user type.</td></tr>
              </table>
           </td>
          </tr>
         -->
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
                    document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + "Exception occurred in managing subscriber charge types!");//用户计费类型管理过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in managing subscriber charge types!");//用户计费类型管理过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="userTypeCharge.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>


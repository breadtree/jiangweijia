<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
            ywaccess oYwAccess = new ywaccess();
    int cmpval = oYwAccess.getParameter(52);
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
<title>Modify SP ringtone validity</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">

<%
	String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");

	String userday = CrbtUtil.getConfig("uservalidday","0");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String spIndex = (String)session.getAttribute("SPINDEX");
    String spCode ="";
	String spname = "";
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
		manSysRing sysring = new manSysRing();
		sysTime = sysring.getSysTime() + "--";

		String errMsg="";
		boolean alertflag=false;
		if (spIndex  == null || spIndex.equals("-1")){
			errMsg = "Sorry, you are not an SP administrator!";//Sorry,you are not the SP administrator
			alertflag=true;
		}
        else if (purviewList.get("10-4") == null)  {
			errMsg = "No access to this function.";//无权访问此功能
			alertflag=true;
        }

        else if (operID != null) {
		  Hashtable tmph = new Hashtable();
	      String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
          String craccount = request.getParameter("ringlibid") == null ? "" : transferString((String)request.getParameter("ringlibid"));
          String ringlibcode = request.getParameter("ringlibcode") == null ? "" : transferString((String)request.getParameter("ringlibcode"));
          String Pos = request.getParameter("Pos") == null ? "" : transferString((String)request.getParameter("Pos"));

		  Hashtable hash = new Hashtable();
          Hashtable tmp = new Hashtable();
          Vector vetRing = new Vector();
 		  int ringCount = 0;
          Hashtable result = new Hashtable();

		  if(Pos.equals(""))
		     Pos = "Please select a category of ringtones";//请选择铃音分类
          if (op.equals("edit")) {
             String ringid = request.getParameter("ringid") == null ? "" : transferString((String)request.getParameter("ringid")).trim();
             String ringlibid = request.getParameter("ringlibid") == null ? "" : transferString((String)request.getParameter("ringlibid")).trim();
             String ringname = request.getParameter("ringname") == null ? "" : transferString((String)request.getParameter("ringname")).trim();
             String validdate = request.getParameter("validdate") == null ? "" : (String)request.getParameter("validdate");
             vetRing = StrToVector(ringid);
String uservalidday = request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday");
             Vector vetName = StrToVector(ringname);
%>

<script language="javascript">
   function onBack() {
      var fm = document.inputForm;
      fm.op.value ="";
      fm.submit();
   }
</script>

<form name="inputForm" method="post" action="springDate.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="Pos" value="<%= Pos %>">
<input type="hidden" name="ringlibid" value="<%= ringlibid %>">

 <table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
 <tr>
    <td><img src="../manager/image/004.gif" width="346" height="15"></td>
 </tr>
 <tr >
    <td background="../manager/image/006.gif">
    <table width="340" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
    <td align="center" > Category is<%= Pos  %>,Validity is<%= uservalidday %>,Expiration of ringtone is<%= validdate %>
   </td>
   </tr>
   <tr>
   <td align="center">
      <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
      <tr class="tr-ringlist">
        <td width="20%" align="center">Ringtone No.</td>
        <td width="30%" align="center" >Ringtone name</td>
        <td width="10%" align="center" >SCP</td>
        <td width="40%" align="center">Execution result</td>
      </tr>
      <%

         ArrayList  rList  = new ArrayList();
         Hashtable stmp =  null;
         zxyw50.Purview purview = new zxyw50.Purview();
         for(int i=0;i<vetRing.size();i++){
           ringid = vetRing.get(i).toString();
           rList = db.modRingDate(ringid,validdate,uservalidday);//uservalidday
           for(int j=0;j<rList.size();j++){
             String color = j == 0 ? "E6ECFF" :"#FFFFFF" ;
             stmp = (Hashtable)rList.get(j);
             out.print("<tr bgcolor='"+color+"'>");
             if(j==0){
               out.print("<td >"+ringid+"</td>");
               out.print("<td >"+vetName.get(i).toString()+"</td>");
             }
             else{
                 out.print("<td >&nbsp;</td>");
                 out.print("<td >&nbsp;</td>");
             }
             out.print("<td >" + (String)stmp.get("scp")+ "</td>");
             String sRet = (String)stmp.get("result");
             if(sRet.equals("0"))
                out.print("<td >Success</td>");
             else
                out.print("<td >Failure ," + (String)stmp.get("reason") +"</td>");
             out.print("</tr>");
           }
           if(getResultFlag(rList)){
               HashMap map = new HashMap();
               map.put("OPERID",operID);
               map.put("OPERNAME",operName);
               map.put("OPERTYPE","1002");
               map.put("RESULT","1");
               map.put("PARA1",ringid);
               map.put("PARA2",validdate);
               map.put("PARA3","ip:"+request.getRemoteAddr());
               purview.writeLog(map);
               sysInfo.add(sysTime + operName + " change the validity of ringtone " + ringid +" to "+uservalidday+"And Expiration to"+validdate +"successfully!");
           }
           else sysInfo.add(sysTime + operName + " change the validity of ringtone " + ringid +" to "+uservalidday+"And Expiration to"+validdate +"failure!");
        }
      %>

      </table>
      <tr>
      <td align="center" >
          <img src="../manager/button/back.gif" onmouseover="this.style.cursor='hand'" onclick="Javascript:onBack()">
      </td>
      </tr>
  </table>
  <tr>
     <td><img src="../manager/image/005.gif" width="346" height="15"></td>
  </tr>
 </table>
 </td>
 </tr>
 </table>

</form>
<%
            }
            else {
            // 查询铃音
            if(craccount==null || craccount.length()==0)
				craccount="-1";
		  hash = new Hashtable();
		  hash.put("spindex",spIndex);
		  hash.put("ringlibid",craccount);

		  hash.put("sortby","buytimes");
		  vetRing = db.spManRingList(hash);
          ringlibcode = "";

          Hashtable hLib=  sysring.getRingLibraryNode(craccount);

          if(hLib!=null && hLib.size()>0)

              ringlibcode = (String)hLib.get("ringlibcode");

%>
<script language="javascript">
   var v_ringid = new Array(<%= vetRing.size() + "" %>);
   var v_ringlabel = new Array(<%= vetRing.size() + "" %>);
   var v_validdate = new Array(<%= vetRing.size() + "" %>);
       <%if(userday.equalsIgnoreCase("1"))
                    {%>
var v_uservalidday = new Array(<%= vetRing.size() + "" %>);
<%}%>
<%
            for (int i = 0; i < vetRing.size(); i++) {
                hash = (Hashtable)vetRing.get(i);
%>
   v_ringid[<%= i + "" %>] = '<%= (String)hash.get("ringid") %>';
   v_ringlabel[<%= i + "" %>] = '<%= (String)hash.get("ringlabel") %>';
   v_validdate[<%= i + "" %>] = '<%= (String)hash.get("validate") %>';
       <%if(userday.equalsIgnoreCase("1"))
                    {%>
v_uservalidday[<%= i + "" %>] = '<%= (String)hash.get("uservalidday") %>';
<%}%>
<%
            }
%>


   function selectSysRing () {
      var fm = document.inputForm;
      var index = fm.personalRing.selectedIndex;
      if (index == -1)
         return;
      fm.validdate.value = v_validdate[index];
             <%if(userday.equalsIgnoreCase("1"))
                    {%>
fm.uservalidday.value = v_uservalidday[index];
<%}%>
   }

    function edit () {
      var fm = document.inputForm;
      if(fm.ringlibid.value =='-1'){
          alert('Please select a ringtone library!');
          return;
      }
      if(fm.personalRing.selectedIndex ==-1){
          alert("Please select the ring back tone you want to edit!");
          return;
      }
             <%if(userday.equalsIgnoreCase("1"))
                    {%>
      //begin add validity
      var tmp1 = trim(fm.uservalidday.value);
      if ( tmp1 == '') {
         alert("Please input user validate!");
         fm.uservalidday.focus();
         return ;
      }
      if (!checkstring('0123456789',tmp1)) {
         alert('user validate must be numeral!');
         fm.uservalidday.focus();
         return ;
      }
      //end
     <%}%>
      var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert("Please enter an expiration date");
          fm.validdate.focus();
          return;
      }
      if(!checkDate2(validdate)){
          alert("The expiration date entered is incorrect. Please re-enter!");//铃音有效期输入不正确,请重新输入
          fm.validdate.focus();
          return ;
      }
      if(checktrue2(validdate)){
          alert("The expiration date cannot be earlier than the current time. Please re-enter!");//铃音有效期不能低于当前时间,请重新输入
          fm.validdate.focus();
          return ;
      }

      if(checktrueyear(validdate,'<%=expireTime%>')){
         alert("The expiration date cannot be larger than <%=expireTime%>, please re-enter!");
          fm.validdate.focus();
          return ;
      }
       var ringid = '';
       var ringname='';
       var len = fm.personalRing.length;
       for(var i=0;i<len;i++){
           if(fm.personalRing.options[i].selected){
              ringid = ringid + fm.personalRing.options[i].value +"|";
              ringname = ringname +  v_ringlabel[i] + "|";
           }
       }
       fm.ringid.value= ringid;
       fm.ringname.value= ringname;
       fm.op.value = 'edit';
       fm.submit();
   }


</script>
<form name="inputForm" method="post" action="springDate.jsp">
<input type="hidden" name="ringid" value="">
<input type="hidden" name="ringname" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="Pos" value="<%= Pos %>">
<input type="hidden" name="ringlibcode" value="<%= ringlibcode %>">
<input type="hidden" name="ringlibid" value="<%= craccount == null ? "" : craccount %>">
<table width="377" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
	<tr>
    <td><img src="../manager/image/007.gif" width="377" height="15"></td>
  </tr>
  <tr>
    <td background="../manager/image/009.gif" width="377">
      <table border="0" align="center" class="table-style2" width="377">
        <tr>
        <td colspan=2 align="center"><%= Pos %></td>
        </tr>
        <tr>
          <td colspan="2" align="center">
            <select name="personalRing" size="8" <%= vetRing.size() == 0 ? "disabled " : "" %> onchange="javascript:selectSysRing()" class="input-style1" style="width: 240;" multiple >
<%
                for (int i = 0; i < vetRing.size(); i++) {
                    tmp = (Hashtable)vetRing.get(i);
%>
              <option value="<%= (String)tmp.get("ringid") %>" ><%= (String)tmp.get("ringid") + "---" +  (String)tmp.get("ringlabel") %></option>
<%
            }
%>
            </select>
          </td>
        </tr>
               <%if(userday.equalsIgnoreCase("1"))
                    {%>
         <%//begin add validity%>
        <tr>
          <td align="right">Validity(days)</td>
          <td><input type="text" readonly  name="uservalidday" value="0" maxlength="4" class="input-style0"></td>
        </tr>
        <%}//end%>
        <tr>
          <td height="22" align="right">Validate(yyyy.mm.dd)</td>
          <td height="22"><input type="text" name="validdate"  maxlength="10" class="input-style0"></td>
        </tr>
        <tr>
          <td colspan="2" align="center">
                 <img src="../button/edit.gif" width="45" height="19" onclick="javascript:edit()" onmouseover="this.style.cursor='hand'">
          </td>
        </tr>
        <tr>
        <td height="22" colspan=2 >
        <table border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0" >
        <tr>
        <td style="color: #FF0000"  >
         &nbsp; &nbsp;Note:
        </td>
        </tr>
        <tr>
        <td style="color: #FF0000"  >
         &nbsp; &nbsp; 1.	Select the ringtone, enter the period of validity in the box provided, and click Edit to apply the changes.
        </td>
        </tr>
        <td style="color: #FF0000"  >
         &nbsp; &nbsp; 2.	Press &lt;Ctrl&gt; or &lt;Shift&gt; and click, can select several ringtones.
        </td>
        </tr>
        <tr>
        <td style="color: #FF0000" >
          &nbsp;&nbsp;&nbsp; 3.	If several ringtones are selected, the new validity period will be applied to all selections.
        </td>
        </tr>
        </table>
     </td>
     </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td><img src="../manager/image/008.gif" width="377" height="15"></td>
  </tr>
</table>
</form>
<%
            }
        }else{
			errMsg = "Please log in to the system first!";
			alertflag=true;
        }if(alertflag==true){
%>
<script language="javascript">
   var errorMsg = '<%= operID!=null?errMsg:"Please log in to the system first!"%>';
   alert(errorMsg);
   parent.document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ",Exception occurred in modifying SP ring back tones validity!");//SP铃音有效期修改过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add(operName + ",Exception occurred in modifying SP ring back tones validity!");//SP铃音有效期修改过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="springDate.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

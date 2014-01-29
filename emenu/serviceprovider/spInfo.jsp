<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.CrbtUtil" %>

<%@include file="../pubfun/JavaFun.jsp"%>

<jsp:useBean id="db" class="zxyw50.SpManage" scope="page" />
<jsp:setProperty name="db" property="*" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    String sysTime = "";
     //add by gequanmin 2005-08-11 for version 3.19.01
    String usediscount = CrbtUtil.getConfig("usediscount","0");
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String spIndex = (String)session.getAttribute("SPINDEX");
String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();

    try {
       String  errmsg = "";
       boolean flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
       else if (spIndex  == null || spIndex.equals("-1")){
          errmsg = "Sorry, you are not an SP administrator!";//Sorry,you are not the SP administrator
          flag = false;
       }
       else if (purviewList.get("9-5") == null) {
         errmsg = "You have no access to this function!";//You have no access to this function
         flag = false;
       }
       if(flag){
         String spcode = "";
          String maxnumber = "";
          String spname = "";
          String ischeck = "";
          String spcent = "";
          String curnumber = "";
          String url = "";
          String corpname = "";
          String faxnumber = "";
          String phonenumber = "";
          String postno ="";
          String linkman = "";
          String customer = "";
          String corpaddress ="";
          String isopcheck = "";
          String ifextra = "";
          String extraspcode = "";
          String discountcheck="";
          String discountopercheck="";

         if(op.trim().equalsIgnoreCase("edit"))
         {
           manSysPara syspara = new manSysPara();
            spcode = request.getParameter("spcode") == null ? "" : transferString((String)request.getParameter("spcode")).trim();
            maxnumber = request.getParameter("maxnumber") == null ? "" : transferString((String)request.getParameter("maxnumber")).trim();
            spname = request.getParameter("spname") == null ? "" : transferString((String)request.getParameter("spname")).trim();
            ischeck = request.getParameter("checkStat") == null ? "0" : transferString((String)request.getParameter("checkStat")).trim();
            spcent = request.getParameter("spcent") == null ? "0" : transferString((String)request.getParameter("spcent")).trim();
            curnumber = request.getParameter("curnumber") == null ? "" : transferString((String)request.getParameter("curnumber")).trim();
            url = request.getParameter("url") == null ? "" : transferString((String)request.getParameter("url")).trim();
            corpname = request.getParameter("corpname") == null ? "" : transferString((String)request.getParameter("corpname")).trim();
            faxnumber = request.getParameter("faxnumber") == null ? "" : transferString((String)request.getParameter("faxnumber")).trim();
            phonenumber = request.getParameter("phonenumber") == null ? "" : transferString((String)request.getParameter("phonenumber")).trim();
            postno = request.getParameter("postno") == null ? "" : transferString((String)request.getParameter("postno")).trim();
            linkman = request.getParameter("linkman") == null ? "" : transferString((String)request.getParameter("linkman")).trim();
            customer = request.getParameter("customer") == null ? "" : transferString((String)request.getParameter("customer")).trim();
            corpaddress = request.getParameter("corpaddress") == null ? "" : transferString((String)request.getParameter("corpaddress")).trim();
            ifextra = request.getParameter("ifextra") == null ? "0" : transferString((String)request.getParameter("ifextra")).trim();
            extraspcode = request.getParameter("extraspcode") == null ? "" : transferString((String)request.getParameter("extraspcode")).trim();
           isopcheck = request.getParameter("isopcheck") == null ? "0" : transferString((String)request.getParameter("isopcheck")).trim();
            discountcheck = request.getParameter("discountcheck") == null ? "0" : transferString((String)request.getParameter("discountcheck")).trim();
            discountopercheck = request.getParameter("discountopercheck") == null ? "0" : transferString((String)request.getParameter("discountopercheck")).trim();
              Hashtable hash = new Hashtable();
               hash.put("optype","3");
                hash.put("spcode",spcode);
                hash.put("maxnumber",maxnumber);
                hash.put("spname",spname);
                hash.put("ischeck",ischeck);
                hash.put("spcent",spcent);
                hash.put("url",url);
                hash.put("spindex",spIndex);
                hash.put("corpname",corpname);
                hash.put("faxnumber",faxnumber);
                hash.put("phonenumber",phonenumber);
                hash.put("postno",postno);
                hash.put("linkman",linkman);
                hash.put("customer",customer);
                hash.put("corpaddress",corpaddress);
                hash.put("isopcheck",isopcheck);
                hash.put("ifextra",ifextra);
                hash.put("extraspcode",extraspcode);
                hash.put("discountcheck",discountcheck);
                hash.put("discountopercheck",discountopercheck);
                syspara.setSP(hash);
         }
         Hashtable map = new Hashtable();
         map = db.getSPConf(spIndex);
         spname = (String)map.get("spname");
         curnumber = (String)map.get("curnumber");
         maxnumber = (String)map.get("maxnumber");
         ischeck = (String)map.get("ischeck");
         spcent = (String)map.get("spcent");
         spcode = (String)map.get("spcode");
         url    = (String)map.get("url");
        corpname = (String)map.get("corpname") ;
        faxnumber = (String)map.get("faxnumber");
        phonenumber = (String)map.get("phonenumber");
        postno = (String)map.get("postno") ;
        linkman = (String)map.get("linkman") ;
        customer = (String)map.get("customer");
        corpaddress = (String)map.get("corpaddress") ;
        extraspcode = (String)map.get("extraspcode") ;
        ifextra = (String)map.get("ifextra") ;
        isopcheck = (String)map.get("isopcheck") ;
        discountcheck=(String)map.get("discountcheck") ;
        discountopercheck=(String)map.get("discountopercheck") ;

 %>
<html>
<head>
<title>SP Management</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
  <SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="javascript">
     function checkUrl () {
      var fm = document.inputForm;
      var value = trim(fm.url.value);
      if(value!=''){
         if(value.substring(0,7)=='http://'){
            var len = value.length;
            value = value.substring(7,len);
            fm.url.value = value;
         }
      }
   }
   function editInfo () {
      var fm = document.inputForm;
      checkUrl();
//      var tmp1 = trim(fm.faxnumber.value);
//          if (!checkstring('0123456789',tmp1)) {
//            alert("The fax must be digital number!");
//            fm.faxnumber.focus();
//            return ;
//          }
//          tmp1 = trim(fm.phonenumber.value);
//          if (!checkstring('0123456789',tmp1)) {
//            alert("The telephone number must be digital number!");
//            fm.phonenumber.focus();
//            return ;
//          }
//          tmp1 = trim(fm.postno.value);
//          if (!checkstring('0123456789',tmp1)) {
//            alert("The zip code must be digital number!");
//            fm.postno.focus();
//            return ;
//          }
      fm.op.value = 'edit';
      fm.submit();
   }

</script>


</head>
<body background="background.gif" class="body-style1" >
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="spInfo.jsp" >
<input type="hidden" name="op" value="">
<table border="0" align="center" height="400" width="500" >
 <tr>
      <td width="100%" valign="middle"> <table width="100%">
          <tr>
            <td colspan="3" align="center" class="text-title" background="image/n-9.gif" height="26">SP Setting Info</td>
          </tr>
          <tr valign="top">
            <td> <table border="0" align="center" class="table-style2"  width="100%">
                <tr>
                  <td  width="50%" align="right">SP&nbsp;&nbsp;Code:</td>
                  <td width="50%"><input type="text" name="spcode" value="<%= spcode %>" maxlength="2" class="input-style1" readonly ></td>
                </tr>
                <tr>
                  <td  width="50%" align="right">SP&nbsp;&nbsp;name:</td>
                  <td width="50%"><input type="text" name="spname" value="<%= spname %>" maxlength="36" class="input-style1"  readonly></td>
                </tr>
                <tr>
                  <td  width="50%" align="right">Number of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s:</td>
                  <td width="50%"><input type="text" name="curnumber" value="<%= curnumber %>" class="input-style1"   readonly></td>
                </tr>
                <tr>
                  <td width="50%" align="right">Maximum number of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>s:</td>
                  <td width="50%"><input type="text" name="maxnumber" value="<%= maxnumber %>" maxlength="5" class="input-style1" readonly></td>
                </tr>
                <tr>
                  <td  width="50%" align="right">Verification or not:</td>
                  <td width="50%">
                      <input type="hidden" name="checkStat" value="<%=ischeck.trim()%>"><%=ischeck.trim().equals("1")?"Verification":"Not Verification"%> </td>
                </tr>
                <tr>
                  <td  width="50%" align="right">Approval or not:</td>
                  <td width="50%" ><input type="hidden" name="isopcheck" value="<%=isopcheck.trim()%>"><%=isopcheck.trim().equals("1")?"Approval":"Not Approval"%> </td>
               </tr>
                <tr>
                  <td  width="50%" align="right">Settlement proportion (%):</td>
                  <td width="50%"><input type="text" name="spcent" value="<%= spcent %>" maxlength="5" class="input-style1"   readonly></td>
                </tr>
               <tr>
          <td align="right">Company Name</td>
          <td><input type="text" name="corpname" value="<%= corpname %>" maxlength="50" class="input-style1"></td>
                 </tr>
                <tr>
                   <td align="right">Website Address:</td>
                   <td><input type="text" name="url" value="<%= url %>" maxlength="60" class="input-style1" ></td>
                </tr>
                      <tr>
          <td align="right">Fax</td>
          <td><input type="text" name="faxnumber" value="<%= faxnumber %>" maxlength="12" class="input-style1"></td>
       </tr>
        <tr>
          <td align="right">Telephone</td>
          <td><input type="text" name="phonenumber" value="<%= phonenumber %>" maxlength="12" class="input-style1"></td>
       </tr>
        <tr>
          <td align="right">Post</td>
          <td><input type="text" name="postno" value="<%= postno %>" maxlength="6" class="input-style1"></td>
       </tr>
        <tr>
          <td align="right">Service contact person</td>
          <td><input type="text" name="linkman" value="<%= linkman %>" maxlength="20" class="input-style1"></td>
       </tr>
               <tr>
          <td align="right">Customer contact person</td>
          <td><input type="text" name="customer" value="<%= customer %>" maxlength="20" class="input-style1"></td>
       </tr>
                <tr>
          <td align="right">Company Address</td>
          <td><input type="text" name="corpaddress" value="<%= corpaddress %>" maxlength="60" class="input-style1"></td>
       </tr>
                 <tr>
                  <td  width="50%" align="right">Exterior SP or not:</td>
                  <td width="50%"><input type="hidden" name="ifextra" value="<%=ifextra.trim()%>"><%=ifextra.trim().equals("1")?"Yes":"No"%> </td>
                </tr>
                  <tr>
          <td align="right">Exterior SP code</td>
          <td><input type="text" name="extraspcode" readonly value="<%= extraspcode %>" maxlength="60" class="input-style1"></td>
                </tr>
        <% String typeDisplay = "none";
         if("1".equals(usediscount))
           typeDisplay = "";
        %>
          <tr style="display:<%= typeDisplay %>">
                  <td  width="50%" align="right">Check Discount or not:</td>
                  <td width="50%">
                      <input type="hidden" name="discountcheck" value="<%=discountcheck.trim()%>"><%=discountcheck.trim().equals("1")?"Yes":"No"%> </td>
          </tr>
          <tr style="display:<%= typeDisplay %>">
                  <td  width="50%" align="right">Check Discount operation:</td>
                  <td width="50%" ><input type="hidden" name="discountopercheck" value="<%=discountopercheck.trim()%>"><%=discountopercheck.trim().equals("1")?"Yes":"No"%> </td>
         </tr>
              </table></td>
          </tr>

         <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
<td width="25%" align="center"><img src="../manager/button/edit.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:editInfo()"></td>
</tr>
            </table>
          </td>
        </tr>
        </table></td>
  </tr>
</table>
</form>
<%
        }
        else {
%>
<script language="javascript">
   var errmsg = '<%= operID!=null?errmsg:"Please log in to the system first!"%>';
   alert(errmsg);
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ",Exception occurred in querying SP information!");//SP配置信息查询过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in querying SP information!");//SP配置信息查询过程出现错误!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="spInfo.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

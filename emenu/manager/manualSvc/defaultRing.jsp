<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.ringAdm" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.callingTime" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Default ringtone setting</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<SCRIPT language="JavaScript" src="../../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1" onload="initform()" >

<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String craccount = "";
    String userringtype = request.getParameter("userringtype") == null ? "" : request.getParameter("userringtype");
    String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
    int     modefee   = 0;
    String usertype="0";//用户类型

    String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 int ratio = Integer.parseInt(currencyratio);
    String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");

    try {
      sysTime = ringAdm.getSysTime() + "--";
      if (operID != null && purviewList.get("13-4") != null) {
         boolean flags = false;

         craccount = request.getParameter("craccount") == null ? "" : request.getParameter("craccount");
         if("search".equals(op)){
          manSysPara msp = new manSysPara();
          flags = msp.isAdUser(craccount);
         }
         if(!flags) {
         zxyw50.Purview purview = new zxyw50.Purview();
         if(!craccount.equals("")){
            if(!purview.CheckOperatorRight(session,"13-4",craccount)){
            	throw new Exception("You have no right to manage this subsciber!");
            }
         if(!userringtype.equals("")){
           //存储取的用户信息
         Hashtable userinfo=new Hashtable();
         userAdm adm1 = new userAdm();
         userinfo=adm1.getUserInfo(craccount);
         String lockid=(String)userinfo.get("lockid");
         String lockid1=(String)userinfo.get("lockid1");

         if(lockid.equals("0")&&lockid1.equals("0"))
              usertype="2";//用户为主,被叫用户
           if(lockid.equals("0")&&(!lockid1.equals("0")))
              usertype="0";//用户为被叫用户
           if(!lockid.equals("0")&&lockid1.equals("0"))
              usertype="1";//用户为主叫用户
         }
           if(!userringtype.equals(usertype)&&!usertype.equals("2") ){
             throw new Exception("The Service type you select  differ from the subscriber's service type!");
          }
         }
         SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");

         String crid = request.getParameter("crid") == null ? "" : (String)request.getParameter("crid");
        int index = crid.indexOf("~");
        String ringidtype = "1";
        if(index>0){
          ringidtype = crid.substring(0,index);
          crid=crid.substring(index+1);
        }
         Hashtable hash = new Hashtable();
         Hashtable tmp = new Hashtable();
         Vector vetRing = new Vector();
         Hashtable defaultRing = new Hashtable();
         Hashtable result = new Hashtable();
      if(op.equals("set")){
          hash.put("opcode","01010947");
          hash.put("craccount",craccount);
          hash.put("crid",crid);
          hash.put("callingnum","");
          hash.put("starttime","00:00:00");
          hash.put("endtime","23:59:59");
          hash.put("startdate","2000.01.01");
          hash.put("enddate",expireTime);
          hash.put("startweek","01");
          hash.put("endweek","07");
          hash.put("startday","01");
          hash.put("endday","31");
          hash.put("callingtype","0");
          if("1".equals(userringtype))
             hash.put("callingtype","100");
          hash.put("settype","0");
          //                if(setno==null||setno.equals(""))
          //                    hash.put("opertype","1");
          //                else
          hash.put("opertype","0");
//          if(crid.indexOf("99")==0)
//             hash.put("ringidtype","2");
//          else
             hash.put("ringidtype",ringidtype);
          hash.put("description","");
          hash.put("setno","");
          hash.put("setpri","");
          result = SocketPortocol.send(pool,hash);

           // 准备写操作员日志
            //zxyw50.Purview purview = new zxyw50.Purview();
            HashMap map = new HashMap();
            map.put("OPERID",operID);
            map.put("OPERNAME",operName);
            map.put("OPERTYPE","505");
            map.put("RESULT","1");
            map.put("PARA1",craccount);
            map.put("PARA2",crid);
            map.put("PARA3","ip:"+request.getRemoteAddr());
            purview.writeLog(map);


      %>
<script language="JavaScript">
	alert("User "+ "<%= craccount %>" + "\'s default ringtone has been reset successfully!");//用户  的默认铃音已重新设置成功
</script>
<%
           sysInfo.add(sysTime + operName + "," + craccount  +"\'s personal default ringtone modified successfully!");//修改   个人默认铃音成功
           op = "search";
      }

      // 查询个人铃音
      String strOption = "";
      String defultID = "";
      if(!craccount.equals("")){
            ringAdm ringadm = new ringAdm();
//            hash.put("opcode","01010301");
//            hash.put("craccount",craccount);
//            hash.put("ret1","");
//            result = SocketPortocol.send(pool,hash);
        userAdm adm = new userAdm();
        result = adm.queryPersonalRing(craccount);
            vetRing = (Vector)result.get("data");
            defaultRing = ringadm.getDefaultRing(craccount,userringtype);
            defultID = (String)defaultRing.get("defaultring");
            int flag = 0;
            for (int i = 0; i < vetRing.size(); i++) {
               tmp = (Hashtable)vetRing.get(i);
               String crid11 = (String)tmp.get("crid");
               String ringidtype1 = (String)tmp.get("ringidtype");
               if(defultID.equals(crid11)){
                  flag = 1;
                  strOption  = strOption + "<option value="+ringidtype1+"~"+ (String)tmp.get("crid") + " selected >" + (String)tmp.get("filename") +"</option>";
               }
               else
                 strOption  = strOption + "<option value="+ ringidtype1+"~"+(String)tmp.get("crid") + " >" + (String)tmp.get("filename") +"</option>";
           }
		   if(defultID.equals("0000000000")){
				  flag = 1;
				  strOption  = strOption + "<option value=1~0000000000" + " selected >normal ring back tone</option>";
		   }
		   else
		   {
			   strOption  = strOption + "<option value=1~0000000000" + " >normal ring back tone</option>";
		   }
           if(flag == 0)
              strOption = "<option value='' selected >No default ringtone has been set now</option>" + strOption;
      }
%>
<script language="JavaScript">
   if(parent.frames.length>0)
	parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="defaultRing.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="defultID" value="<%= defultID %>" >
<table border="0" align="center" height="400" width="300" class="table-style2" >
  <tr valign="center">
  <td>
  <table border="0" align="center" class="table-style2" width="100%" >
    <tr >
          <td height="26"  align="center" class="text-title" background="../image/n-9.gif"   >Default ringtone setting</td>
      </tr>
      <tr valign="top">
                  <td width="100%">
                    <table width="100%"  border="0" class="table-style2" cellpadding="2" cellspacing="1" align="center">
               <%
        //add by wuxiang 2005-4-14
        String usecalling = CrbtUtil.getConfig("usecalling","0");
        %>
        <tr style="<%=("1".equals(usecalling)?"display:block":"display:none")%>">
          <br>
          <td  align="right" >&nbsp;&nbsp;Service Type
           <select name="userringtype"  class="input-style1" style="width:150" >
           <%if(userringtype.equals("0")){%>
            <option selected="selected" value=0 >Called Service</option>
           <%}else if(userringtype.equals("1")){%>
            <option selected="selected" value=1 >Calling Service</option>
           <%}else{%>
           <option  value=0 >Called Service</option>
           <option  value=1 >Calling Service</option>
           <%}%>
           </select>
          </td>
        </tr>
        <%//end add%>
                      <tr>
                        <td height=50  align="right" >Number of subscriber <input type="text" name="craccount" value="<%= craccount %>" maxlength="20"   class="input-style1" onKeyPress="return onCraccountPress(event)" >
                        </td>
                      </tr>
                      <tr>
                         <td style=<%= op.equals("")?"display:block":"display:none" %> align="center" height=40 >
                           <table border="0" width="80%" class="table-style2" align="center">
                           <tr>
                           <td width="50%" align="center"><img src="../button/search.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:onSearch()"></td>
                           <td width="50%" align="center"><img src="../button/again.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:document.inputForm.reset()"></td>
                           </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td  style=<%= craccount.equals("")?"display:none":"display:block" %> >Default ringtone&nbsp;
                        <select name="crid" class="select-style1" style="width:300px">
                            <%  out.print(strOption); %>
                          </select>
                      </td>
                      </tr>
                      <tr>
                        <td  align="center" style=<%= craccount.equals("")?"display:none":"display:block" %> height=40 >
                            <table width="80%" align="center" border="0" class="table-style2" cellpadding="2" cellspacing="1" >
                            <tr>
                            <td width=50% align="center">
                                <img src="../button/change.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:doSure()">
                            </td>
                             <td width=50% align="center">
                                <img src="../button/back.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:onBack()">
                            </td>
                            </tr>
                            </table>
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

   function initform(){
      var option = "<%= op %>";
      if(option=='search')
          document.forms[0].craccount.disabled = true;
   }

   function onBack(){
      document.forms[0].op.value = "";
      document.URL='defaultRing.jsp';
    //  document.forms[0].submit();
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

   function onSearch(){
      var fm = document.inputForm;
      var checkvalue = trim(fm.craccount.value);

      if(checkvalue == ''){
          alert("Please enter the subscriber number to perform your operation");//请输入您要操作的User number
          return ;
      }
      if(!checkstring('0123456789',checkvalue)){
          alert("A subscriber number can only be a digital string");//User number只能是数字字符串
          return ;
      }
      if(checkvalue.length<7){
         alert("The subscriber number entered is incorrect. Please re-enter!");//User number输入不正确,请重新输入
         return;
      }

      fm.op.value='search';
      fm.submit();
   }

   function doSure() {
      fm = document.inputForm;
      if (trim(fm.crid.value) == '') {
         alert("Please select a ringtone before you set your default ringtone!");//请先选择铃音,再进行默认铃音设置!
         return;
      }
      if(fm.defultID.value ==fm.crid.value){
         alert("Please select a new ringtone before you set your default ringtone!");//请选择新的铃音,再进行默认铃音设置!
         return;
      }
      var fee=<%= modefee %>;
      if(fee>0){
           if(!confirm("You will be charged "+ fee/<%=ratio%> + " <%=majorcurrency%> for setting the new default ringtone!  \N Are you sure you want to continue?" ))//"设置新的默认铃音需要交纳"+ fee/100 + "元!\n您确认吗？"
              return;
      }
      fm.craccount.disabled = false;
      fm.op.value='set';
      fm.submit();
   }
</script>
<%
        }else{
 %>
              <script language="javascript">
                   var str = 'Sorry! the number ' +<%= craccount %>+' you entered is ad subscriber,can not use the system!';
                   alert(str);
                   document.URL = 'defaultRing.jsp';
             </script>
 <%
        }
        }
        else {
%>
<script language="javascript">
 	alert("Please log in first!");//请先登录
	document.location.href = '../enter.jsp';
</script>
<%
       }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + craccount + ", Exception occurred in setting the subscriber's default ringtone");//用户默认铃音设置出现异常
        sysInfo.add(sysTime + craccount + e.toString());
        vet.add("Exception occurred in setting the subscriber's default ringtone!");//用户默认铃音设置出现异常
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="../error.jsp">
<input type="hidden" name="historyURL" value="manualSvc/defaultRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

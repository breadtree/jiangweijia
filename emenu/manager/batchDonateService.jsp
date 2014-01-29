
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="zxyw50.manstream"%>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.userDonation" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<HTML>
<HEAD>
<TITLE>Batch gift service</TITLE>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</HEAD>
<BODY topmargin="0" leftmargin="0" >
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="600";
</script>
<table border="0" align="center" height="300" width="500" class="table-style2" >
   <tr>
      <td>
<%
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");

%>
<%
try {

  if (operID != null && purviewList.get("1-10") != null) {
     sysTime = SocketPortocol.getSysTime() + "--";
     if(op.equals("saveasfile")){
        Date date =new Date();
        java.text.SimpleDateFormat formatdate=new java.text.SimpleDateFormat("yyyyMMdd");
        String filename=formatdate.format(new Date())+"_GiftService.txt";
    	response.setContentType("APPLICATION/OCTET-STREAM");
    	response.setHeader("Content-Disposition","attachment; filename=\""+filename+"\"");
        ArrayList arra=(ArrayList)session.getAttribute("tempsession");
        HashMap tmap=null;
    	out.clear();
    	out.println("phone number,result");
	for(int k=0;k<arra.size();k++){
          tmap=(HashMap)arra.get(k);
          out.println(tmap.get("phone").toString()+","+tmap.get("result").toString());
          //tmap.clear();
	}
        //arra.clear();
        return;
     }
     else if(op.equals("first")){
%>
      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif"><%=zxyw50.CrbtUtil.getConfig("ringdisplay", "Ringtone")%> Subscription Promo Package</td>
        </tr>
      </table>
<form name="inForm" method="POST" action="batchDonateService.jsp" ENCTYPE="multipart/form-data">
  <input type="hidden" name="op" value="">
  <table align="center" class="table-style2">
     <tr>
       <td valign="top" align="right">Free Period (days)&nbsp;</td>
       <td align="left">
         <input type="text" name="donationtime" value="60">
        </td>
      </tr>
      <tr>
         <td align="right">Batch File</td>
         <td ><input type="hidden" name="cmd1" value="0"><INPUT TYPE="FILE" NAME="UPFILE1" SIZE="40"></td>
      </tr>
      <tr>
        <td align="center" colspan="2">
          <img src="button/sure.gif" onClick="actup()">
        </td>
      </tr>
  </table>
</form>
      <table border="0" width="100%" class="table-style2">
        <tr>
                <td class="table-styleshow" background="image/n-9.gif" height="26">
                  Notes:</td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            <p>1. The format of files to be imported is that of the text data file *.txt.</p>
          </td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            <p>2. The imported file is composed of 1 field, i.e. phone.Format of imported file [example]:<br>
              &nbsp;&nbsp;&nbsp;&nbsp;3048000118<br>
              &nbsp;&nbsp;&nbsp;&nbsp;3048000119</p>
          </td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            3. The maximum size of the file should not be larger than 20KB!
          </td>
        </tr>
      </table>
<script DEFER language="JavaScript1.2">

function actup(){
  if(document.inForm.donationtime.value==''){
    alert('Please enter the period of donation!');
    document.inForm.donationtime.focus();
    return false;
  }
  if(!checkstring('0123456789',document.inForm.donationtime.value)){
    alert("The period of donation can only contain digits,Please re-enter!");//\u53EA\u80FD\u4E3A\u6570\u5B57\u5B57\u7B26\u4E32\uFF0C\u8BF7\u91CD\u65B0\u8F93\u5165\uFF01
    document.inForm.donationtime.focus();
    return false;
  }
  var fname=document.inForm.UPFILE1.value;
  var fext;
  if(fname=="")
  {
     alert("Please Select the file!");
     return false;
  }
  else{
      fext=fname.substring(fname.lastIndexOf('.'));
      if(fext=='.txt'){
        document.inForm.op.value="importfile";
        document.inForm.submit();
      }else{
        alert('The format of file should  be \'*.txt\'!');
        return false;
      }
  }
}
</script>
<%  }//op.equals("first")
    else{//batch ring setting
      ArrayList arrayResult=new ArrayList();
      try{
        int contentlen=request.getContentLength();
        if(contentlen>(20*1024))
          throw new Exception("The  maximum size of the file should not be larger than 20KB! ");
     	ServletInputStream instream=request.getInputStream();
       manstream mstream=new manstream();
       Vector vet=mstream.getfilephoneinfo(instream,"@,@|");
        String donationtime=mstream.getParameter.get("donationtime")==null?"60":mstream.getParameter.get("donationtime").toString().trim();
        HashMap tMap=null;
        HashMap mapResult=new HashMap();
        String  craccount = "";
        userAdm  useradm = new userAdm();
        HashMap userInfo = null;
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        Hashtable hash = new Hashtable();
        Hashtable result = new Hashtable();
        String clientip=request.getRemoteAddr();
        userDonation udonation = new userDonation();
        for(int i=0;i<vet.size();i++){
          HashMap mapret=new HashMap();
          tMap=(HashMap)vet.get(i);
          craccount=tMap.get("1")==null?"":tMap.get("1").toString().trim();
          int lockid = -1;
          try{
            userInfo  = useradm.getCardinfo(craccount);
            lockid = Integer.parseInt((String)userInfo.get("lockid"));
          }catch(Exception e){
            lockid = -1;
          }
          if(lockid==0){//If subscriber exist
            if(mapret==null)mapret=new HashMap();
            mapret.put("phone",craccount);
            mapret.put("result","The account has existed!");
            arrayResult.add(mapret);
            continue;
          }
          if(!useradm.isNumber(craccount)){
            if(mapret==null)mapret=new HashMap();
            mapret.put("phone",craccount);
            mapret.put("result","The account number must be digital!");
            arrayResult.add(mapret);
            continue;
          }
          try{
            hash.put("opcode","01010963");
            hash.put("craccount","0000");
            hash.put("recvnumber",craccount);
            hash.put("opmode","1");
            hash.put("ipaddr",clientip);
            hash.put("userringtype","0");
            hash.put("presenttime",donationtime);
            result = SocketPortocol.send(pool,hash);
            if(mapret==null)
              mapret=new HashMap();
            mapret.put("phone",craccount);
            mapret.put("result","Success");
            arrayResult.add(mapret);
          }catch(Exception ee){
             if(mapret==null)mapret=new HashMap();
             mapret.put("phone",craccount);
             mapret.put("result",ee.getMessage());
             arrayResult.add(mapret);
          }
        }//for recycle end
        zxyw50.Purview purview = new zxyw50.Purview();
        HashMap map = new HashMap();
        map.put("OPERID",operID);
        map.put("OPERNAME",operName);
        map.put("HOSTNAME",request.getRemoteAddr());
        map.put("SERVICEKEY",useradm.getSerkey());
        map.put("OPERTYPE","117");
        map.put("RESULT","1");
        map.put("PARA1",donationtime);
        map.put("PARA2",craccount);
        map.put("DESCRIPTION","Donationt service in batches via web Operator");
        purview.writeLog(map);
       if(vet!=null)vet.clear();
      }catch(Exception e1){
     	e1.printStackTrace();
       throw e1;
      }
%>
<form name="inForm" method="POST" action="batchDonateService.jsp">
      <input type="hidden" name="op" value="saveasfile">

      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">The result of gifting service</td>
        </tr>
        <tr >
          <td height="15" colspan="2" align="center" >&nbsp;</td>
        </tr>
      </table>
      <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
      <tr class="tr-ringlist">
        <td width="30%" align="center">Account number</td>
        <td width="70%" align="center">Result</td>
      </tr>
<%
      HashMap maptemp=null;
      for(int k=0;k<arrayResult.size();k++){
        maptemp=(HashMap)arrayResult.get(k);
        out.println("<tr bgcolor='"+(k%2==0?"E6ECFF" :"#FFFFFF")+"'>");
        out.println("<td>"+maptemp.get("phone")+"</td>");
        out.println("<td>"+maptemp.get("result")+"</td>");
        out.println("</tr>");
      }
      session.setAttribute("tempsession",arrayResult);
      session.setMaxInactiveInterval(600);//10 minutes
%>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3" align="center">
          <%if(arrayResult.size()>0){%>
          <input type="button" name="saveas" value="Save as file" onclick="saveasfile()">
          <%}else out.println("No error occurred!");%>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           <input type="button" value="Return" onclick="f_return()">
        </td></tr>
      </table>
</form>
<script DEFER language="JavaScript1.2">
function saveasfile(){
  document.inForm.target="_parent";
  //document.inForm.saveas.disabled=true;
  document.inForm.submit();
}

function f_return(){
  window.location.href="batchDonateService.jsp?op=first";
}
</script>
<%
    }////batch account
  }//operID != null && purviewList.get("13-1") != null
  else {
        if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//请先登录系统
                    document.URL = 'enter.jsp';
              </script>
        <%
         }
         else{
         %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//对不起，您没有权限操作该功能！
              </script>
            <%
        }
  }
}
    catch(Exception e) {
        e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + ", An error occurred for batch donation service!");//
        sysInfo.add(sysTime +  e.toString());
        vet.add(operName + ", An error occurred for batch donation service!");//
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="batchDonateService.jsp?op=first">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
      </td>
   </tr>
</table>
</BODY>
</HTML>

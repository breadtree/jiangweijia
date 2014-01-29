<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.ywaccess" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%
String userday = CrbtUtil.getConfig("uservalidday","0");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
    ywaccess oYwAccess = new ywaccess();
    int cmpval = oYwAccess.getParameter(52);

    //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

	String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");
%>
<html>
<head>
<title>Edit greeting tone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script language="JavaScript">


   function checkfee (fee) {
      var tmp = '';
      for (i = 0; i < fee.length; i++) {
         tmp = fee.substring(i, i + 1);
         if (tmp < '0' || tmp > '9')
            return false;
      }
      return true;
   }

   function edit () {
      var fm = document.inputForm;
      if (trim(fm.ringLabel.value) == '') {
         alert('Please enter a ringtone name!');//������Ringtone name
         fm.ringLabel.focus();
         return;
      }
      if (!CheckInputStr(fm.ringLabel,'Ringtone name')){
         fm.ringLabel.focus();
         return;
      }
      if (trim(fm.ringspell.value) == '') {
         alert('Please enter the spelling of a ringtone name');//����������ƴ��
         fm.ringspell.focus();
         return;
      }
      if(!CheckInputChar1(fm.ringspell,'Ringtone spelling')){
      	fm.ringspell.focus();
      	return;
      }
      if (trim(fm.ringauthor.value) == '') {
         alert('Please enter an singer name');//������Singer name
         fm.ringauthor.focus();
         return;
      }


      var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert('Please enter an expiration date');//������������Ч��
          fm.validdate.focus();
          return ;
      }
      if(!checkDate2(validdate)){
          alert('The expiration date entered is incorrect. Please re-enter!');//������Ч�����벻��ȷ,����������
          fm.validdate.focus();
          return ;
      }
      if(checktrue2(validdate)){
          alert('The expiration date cannot be earlier than the current time. Please re-enter!');//������Ч�ڲ��ܵ��ڵ�ǰʱ��,����������
          fm.validdate.focus();
          return ;
      }

      if(checktrueyear(validdate,'<%=expireTime%>')){
         alert("The expiration date cannot be latter than '<%=expireTime%>'. Please re-enter!");
          fm.validdate.focus();
          return ;
      }

      fm.op.value = 'edit';
      fm.submit();
   }

function ok(){
  edit();
}
function cancel(){
  window.returnValue = "no";
  window.close();
}
</script>
</head>
<base target="_self">
<body topmargin="0" leftmargin="0" class="body-style1"  background="background.gif" >
<%

    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String ringid = request.getParameter("ringid") == null ? "" : ((String)request.getParameter("ringid")).trim();
    String libid =  request.getParameter("libid") == null ? "503" : ((String)request.getParameter("libid")).trim();
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
    if(operName == null ||"".equals(operName)||session.getAttribute("SPCODE")!=null)
               //throw new Exception("����Ȩʹ�ô˹��ܻ���ĵ�½��Ϣ�ѹ���!");
                 throw new Exception("You have no access to the system or your login info have expired!");
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        if(op.equals("edit")){
            String crid = request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid");
            String craccount = libid;
            String ringLabel = request.getParameter("ringLabel") == null ? "" : transferString((String)request.getParameter("ringLabel"));




            if(checkLen(ringLabel,40))
               throw new Exception("The length of the ringtone name you entered has exceeded the limit. Please re-enter!");//�������Ringtone name���ȳ�������,����������!
            String ringauthor = request.getParameter("ringauthor") == null ? "" : transferString((String)request.getParameter("ringauthor"));
          if(checkLen(ringauthor,40))
        	throw new Exception("The length of the singer name you entered has exceeded the limit. Please re-enter!");//�������Singer name���ȳ�������,����������!
         String ringsource = request.getParameter("ringsource") == null ? "" : transferString((String)request.getParameter("ringsource"));
         if(checkLen(ringsource,40))
        	throw new Exception("The length of the ringtone provider name you entered has exceeded the limit. Please re-enter!");//������������ṩ�����Ƴ��ȳ�������,����������!
          String price = request.getParameter("price") == null ? "0" : (String)request.getParameter("price");
          String validdate = request.getParameter("validdate") == null ? "" : (String)request.getParameter("validdate");
          String ringspell = request.getParameter("ringspell") == null ? "" : (String)request.getParameter("ringspell");
String uservalidday = request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday");
           manSysRing manring = new manSysRing();
                ArrayList rList = null;
                Hashtable hash = new Hashtable();
                String iffree = "-1";
                hash.put("usernumber",craccount);
                hash.put("ringid",crid);
                hash.put("ringlabel",ringLabel);
                hash.put("ringfee",price);
                hash.put("ringauthor",ringauthor);
                hash.put("ringsource",ringsource);
                hash.put("validdate",validdate);

                hash.put("uservalidday",uservalidday);

                hash.put("ringspell",ringspell);
                hash.put("iffree",iffree);
                rList = manring.editSysRingLabel(hash);
                sysInfo.add(sysTime + operName + "Greeting Tone info modified successfully!");//�޸�������Ϣ�ɹ�
                String msg = JspUtil.generateResultList(rList);
                if(!msg.equals("")){
                   msg = msg.replace('\n',' ');
                   throw new Exception(msg);
                }
                // ׼��д����Ա��־
                zxyw50.Purview purview = new zxyw50.Purview();
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("SERVICEKEY",manring.getSerkey());
                map.put("OPERTYPE","232");
                map.put("RESULT","1");
                map.put("PARA1",crid);
                map.put("PARA2",ringLabel);
                map.put("PARA3",price);
                map.put("PARA4",validdate);
                map.put("DESCRIPTION","Modify "+"ip:"+request.getRemoteAddr() );
                purview.writeLog(map);

                %>
                <script language="JavaScript">
                window.returnValue = "yes";
                window.close();
                </script>
        <%}else{
        ColorRing colorRing = new ColorRing();
        // ��ѯ������Ϣ
        Map hash = (Map)colorRing.getRingInfo(ringid);
        if(hash==null||hash.size()<=0)
        	throw new Exception("Ringtone record does not exist!");//������¼�Ѳ�����

%>
<form name="inputForm" method="post" action="greetingToneInfo.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="libid" value="<%=libid%>">
<table width="100%" cellspacing="0" cellpadding="0" border="0" class="table-style2">
  <tr>
    <td>
      <br />
      <table  width="100%"  border="0">
      <tr>
          <td width="100%" align="center" valign="middle">
              <div id="hintContent" >
      <table border="0" align="center" class="table-style2">
         <tr>
          <td height="22" align="left" valign="center">Ringtone code</td>
          <td height="22" valign="center"><input type="text" name="ringid"  value="<%=(String)hash.get("ringid")%>" maxlength="20" class="input-style0"  readonly="readonly" ></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center">Ringtone name</td>
          <td height="22" valign="center"><input type="text" name="ringLabel"  value="<%=(String)hash.get("ringlabel")%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center">Spelling of ringtone</td>
          <td height="22" valign="center"><input type="text" name="ringspell"  value="<%=(String)hash.get("ringspell")%>" maxlength="20" class="input-style0"></td>
        </tr>
        <tr>
          <td height="22" align="left" valign="center">Singer name</td>
          <td height="22" valign="center"><input type="text" name="ringauthor" value="<%=(String)hash.get("ringauthor")%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr style="display:none">
          <td height="22" align="left" style="display:none" >Ringtone provider</td>
          <td height="22" valign="center"><input type="hidden" name="ringsource"  value="<%=(String)hash.get("ringsource")%>"  maxlength="40" class="input-style0"></td>
        </tr>
        <tr style="display:none">
           <td height="22" align="left" valign="center">Free trial of ringtones</td>
           <td  align="center"><input type="radio" name="iffree" value="0" onclick="onIffreeCheck()">No &nbsp;&nbsp;
            <input type="radio" name="iffree" value="1" onClick="onIffreeCheck()">Yes</td>
        </tr>
        <tr style="display:none">
          <td height="22" align="left">Ringtone price (<%=minorcurrency%>)</td>
          <td height="22"><input type="text" name="price" maxlength="5" value="<%=(String)hash.get("ringfee")%>"  class="input-style0"></td>
        </tr>

        <tr>
          <td height="22" align="left">Period of copyright(yyyy.mm.dd)</td>
          <td height="22"><input type="text" name="validdate"  value="<%=(String)hash.get("validtime")%>"  maxlength="10" class="input-style0"></td>
        </tr>

      </table>
              </div>
          </td>
      </tr>
      <tr>
          <td width="100%" align="center" height="16" align="center">
              <img src="button/sure.gif" alt="OK" onmouseover="this.style.cursor='hand'" onclick="javascript:ok()" >
                  &nbsp;&nbsp;
              <img src="button/cancel.gif" alt="Cancel" onmouseover="this.style.cursor='hand'" onclick="javascript:cancel()" >
        </td>
          </tr>
        </table>

    </td>
  </tr>
</table>
</form>
<%
}
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " Exception occurred in editing Greeting Tone " + ringid + "!");//Edit����  �����쳣
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error in editing this Greeting Tone!");//Edit��������
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<script language="javascript">
   alert("Exception occurred in editing Greeting Tone <%= ringid%> :<%= e.getMessage() %>");//Edit����  �����쳣
   window.close();
</script>
<%
    }
%>
</body>
</html>

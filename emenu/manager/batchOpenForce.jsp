
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="zxyw50.manstream"%>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.manUser" %>
<%@ page import="zxyw50.ColorRing" %>
<%@ page import="zxyw50.manSysPara" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>

<HTML>
<HEAD>
<TITLE>Batch open account focely</TITLE>
<link rel="stylesheet" type="text/css" href="style.css">
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
    String passLen = (String)application.getAttribute("PASSLEN")==null?"0":(String)application.getAttribute("PASSLEN");
    String areacode = (String)application.getAttribute("AREACODE")==null?"1":(String)application.getAttribute("AREACODE");
    String ccpasswd = (String)application.getAttribute("CCPASSWD")==null?"0":(String)application.getAttribute("CCPASSWD");
    String provider = (String)application.getAttribute("PROVIDERCODE")==null?"0":(String)application.getAttribute("PROVIDERCODE");
    String rejectpwd = (String)application.getAttribute("REJECTPWD")==null?"0":(String)application.getAttribute("REJECTPWD");
    String defaultPasswd = "111111";
    if(!rejectpwd.equals("0") && !rejectpwd.equals(""))
       defaultPasswd = rejectpwd;

    String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");

%>
<%
try {

  if (operID != null && purviewList.get("1-9") != null) {
     sysTime = SocketPortocol.getSysTime() + "--";
     if(op.equals("saveasfile")){
        Date date =new Date();
        java.text.SimpleDateFormat formatdate=new java.text.SimpleDateFormat("yyyyMMdd");
        String filename=formatdate.format(new Date())+"_ADD_Err.txt";
    	response.setContentType("APPLICATION/OCTET-STREAM");
    	response.setHeader("Content-Disposition","attachment; filename=\""+filename+"\"");
        ArrayList arra=(ArrayList)session.getAttribute("tempsession");
        HashMap tmap=null;
    	out.clear();
    	out.println("phone number,operation type,result");
	for(int k=0;k<arra.size();k++){
          tmap=(HashMap)arra.get(k);
          out.println(tmap.get("phone").toString()+","+tmap.get("type").toString()+","+tmap.get("result").toString());
          //tmap.clear();
	}
        //arra.clear();
        return;
     }
     else if(op.equals("first")){
       ColorRing colorRing=new ColorRing();
       manSysPara syspara = new manSysPara();
       Vector ringlist=colorRing.getRingListSimple();
       Vector userType=syspara.getUserTypeInfo();
%>

      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">Batch account opening/cancellation </td>
        </tr>
      </table>

<form name="inForm" method="POST" action="batchOpenForce.jsp" ENCTYPE="multipart/form-data">
  <input type="hidden" name="op" value="">
  <table align="center" class="table-style2">
     <tr>
       <td valign="top" align="right" width="20%">Operation type&nbsp;</td>
       <td align="left" width="80%">
         <select name="opertype" style="width:300px">
            <option value="1">Open an account</option>
            <option value="2">Cancel an account</option>
         </select>
        </td>
      </tr>
     <tr>
       <td valign="top" align="right">Subscriber type&nbsp;</td>
       <td align="left">
         <select name="usertype" style="width:300px">
<%
         for(int i=0;i<userType.size();i++){
           Hashtable hashTmp=(Hashtable)userType.get(i);
%>
            <option value="<%=hashTmp.get("usertype")%>"><%=hashTmp.get("utlabel")%></option>
<%
           if(hashTmp!=null) hashTmp.clear();
         }
%>
         </select>
        </td>
      </tr>
     <tr>
       <td valign="top" align="right">Ring list&nbsp;</td>
       <td align="left">
         <select name="ringlist" style="width:300px" size="10">
<%
         for(int i=0;i<ringlist.size();i++){
           HashMap map=(HashMap)ringlist.get(i);
%>
            <option value="<%=map.get("ringid")%>"><%=map.get("ringid")%>--<%=map.get("ringlabel")%></option>
<%
           if(map!=null)map.clear();
         }
         if(ringlist!=null)ringlist.clear();
         if(userType!=null)userType.clear();
%>

         </select>
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
                  Note:</td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            <p>1. The format of files to be imported is that of the text data files *.txt.</p>
          </td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            <p>2. For account opening,an imported file is composed of 2 fields, i.e. phone and <br>&nbsp;&nbsp;&nbsp;
                  pay mode.The second field should be pay mode,can be pre or post.<br>
              &nbsp;&nbsp;&nbsp;&nbsp;Format of imported file [example],Separating the two field by comma:<br>
              &nbsp;&nbsp;&nbsp;&nbsp;3048000118,pre<br>
              &nbsp;&nbsp;&nbsp;&nbsp;3048000119,post</p>
          </td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">
            <p>3. For account cancellation,an imported file is composed of 1 fields, i.e. phone.<br>
              &nbsp;&nbsp;&nbsp;&nbsp;Format of imported file [example]:<br>
              &nbsp;&nbsp;&nbsp;&nbsp;3048000118<br>
              &nbsp;&nbsp;&nbsp;&nbsp;3048000119</p>
          </td>
        </tr>
        <tr>
          <td height="20" style="color: #FF0000">

            4. The maximum size of the file should not be larger than 20KB!

          </td>
        </tr>
      </table>
<script DEFER language="JavaScript1.2">

function actup(){
  if(document.inForm.opertype.value==1&&document.inForm.ringlist.value==''){
    alert('Please select ring!');
    document.inForm.ringlist.focus();
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
    else{//batch account
      ArrayList arrayResult=new ArrayList();
      try{
        int contentlen=request.getContentLength();
        if(contentlen>(20*1024))
          throw new Exception("The  maximum size of the file should not be larger than 20KB! ");
     	ServletInputStream instream=request.getInputStream();
       manstream mstream=new manstream();
       Vector vet=mstream.getfilephoneinfo(instream,",");
        if(mstream.getParameter.get("opertype")==null)
          throw new Exception("Operation type error!");
        String opertype = mstream.getParameter.get("opertype").toString().trim();//1,open account  2,cancel account

        if(opertype.equals("1")&&mstream.getParameter.get("ringlist")==null)
          throw new Exception("Ring id error!");
        String ringid=mstream.getParameter.get("ringlist")==null?"":mstream.getParameter.get("ringlist").toString().trim();
        if(opertype.equals("1")&&mstream.getParameter.get("usertype")==null)
          throw new Exception("Subscriber type error!");
        String usertype=mstream.getParameter.get("usertype")==null?"1":mstream.getParameter.get("usertype").toString().trim();
        String strSub=null;
        if(opertype.equals("1"))
          strSub = "Account";
        else if(opertype.equals("2"))
          strSub = "Cancel";
        else
          throw new Exception("Operation type error!");
        Hashtable result= new Hashtable();
        HashMap tMap=null;
        HashMap mapResult=new HashMap();
        String  craccount = "";
        String  oldcraccount=null;
        String  paymode=null;
        manUser manuser = new manUser();
        userAdm  useradm = new userAdm();
        HashMap userInfo = null;
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        for(int i=0;i<vet.size();i++){
          oldcraccount="";
          HashMap mapret=new HashMap();
          tMap=(HashMap)vet.get(i);
          craccount=tMap.get("1")==null?"":tMap.get("1").toString().trim();
          paymode=tMap.get("2")==null?"":tMap.get("2").toString().trim();
          try{
            if(opertype.equals("1")){
              paymode=paymode.toLowerCase();
              if(paymode.equals("pre"))
                paymode="1";
              else if(paymode.equals("post"))
                paymode="0";
              else{
                mapret.put("phone",craccount);
                mapret.put("type",strSub);
                mapret.put("result","Pay mode error!");
                arrayResult.add(mapret);
                continue;
              }
            }
            oldcraccount=craccount;
            if(craccount.length()<4){
               mapret.put("phone",craccount);
               mapret.put("type",strSub);
               mapret.put("result","Error number!");
               arrayResult.add(mapret);
               continue;
            }
            int lockid = -1;
            try{
              userInfo  = useradm.getCardinfo(craccount);
              lockid = Integer.parseInt((String)userInfo.get("lockid"));
            }catch(Exception e){
              lockid = -1;
            }
            if(opertype.equals("1")){// Open account
              if(lockid==1){//if the subscriber is suspended, Send active request
                 /*
                 Hashtable hash = new Hashtable();
                 hash.put("opcode","01010701");
                 hash.put("craccount",craccount);
                 hash.put("passwd","");
                 hash.put("op","1");//1 active
                 hash.put("opmode","1");
                 hash.put("ipaddr",operName);
                 result = SocketPortocol.send(pool,hash);
                 sysInfo.add(sysTime +" Operator "+ operName +" has opened(active) the account "+ craccount + " successfully!");//管理员  开户 成功
                 */
                 mapret.put("phone",oldcraccount);
                 mapret.put("type",strSub);
                 mapret.put("result","The subscriber is the suspended subscriber!");
              }else if(lockid==0){//normal subscriber
            	 mapret.put("phone",oldcraccount);
                 mapret.put("type",strSub);
             	 mapret.put("result","The subscriber has existed,and the status is normal!");
              }else{
                Hashtable hash = new Hashtable();
                hash.put("usernumber",craccount);
                hash.put("inflag",0+"");
                hash.put("serkey",1+"");
                hash.put("usertype",usertype);
                hash.put("scpgt",1+"");
                hash.put("cardpass",defaultPasswd);
                hash.put("restint",paymode);//default is prepaid
                hash.put("operator",operName);
                hash.put("ipaddr",request.getRemoteAddr());
                hash.put("ringid",ringid);//
                manuser.changeCardUseAddRing(hash);
                sysInfo.add(sysTime +" Operator "+ operName +" has opened the account "+ craccount + " in batches successfully!");
                //mapret.put("phone",oldcraccount);
                //mapret.put("type",strSub);
                //mapret.put("result","Success to account!");
                mapret=null;
              }
            }else if(opertype.equals("2")){//cancel account
                if(lockid==0||lockid==1){
                   manuser.delCard(craccount,operName,request.getRemoteAddr());
                   sysInfo.add(sysTime +operName+ " Account Cancellation "+craccount +" in batches successfully!");
                   //mapret.put("phone",oldcraccount);
                   //mapret.put("type",strSub);
                   //mapret.put("result","Success to cancel account !");
                   mapret=null;
                }
                else{
                   mapret.put("phone",oldcraccount);
                   mapret.put("type",strSub);
                   mapret.put("result","The subscriber does not existed!");
                }
            }else{
               mapret.put("phone",oldcraccount);
               mapret.put("type",strSub);
               mapret.put("result","Unknow operation type "+strSub+"!");
            }
            if(mapret!=null)
              arrayResult.add(mapret);
          }catch(Exception ee){
             //ee.printStackTrace();
             if(mapret==null)mapret=new HashMap();
             mapret.put("phone",oldcraccount);
             mapret.put("type",strSub);
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
        map.put("OPERTYPE","46");
        map.put("RESULT","1");
        map.put("DESCRIPTION","Batch Account/cancel forcely via web Operator");
        purview.writeLog(map);
/////////////////////\u5199\u65E5\u5FD7\u6587\u4EF6
/*
	Date date =new Date();
        java.text.SimpleDateFormat formatdate=new java.text.SimpleDateFormat("yyyyMMddHHmmss");
        StringBuffer filename=new StringBuffer("batchAccountForce_");
        filename.append(formatdate.format(new Date()));
        filename.append(operName);
        String filepath="C:/zxin10/weblog/"+filename.toString()+".log";
        FileOutputStream outstream=new FileOutputStream(filepath,true);
        String stmp=sysTime+operName+","+request.getRemoteAddr()+",batch account/cancel!\r\n";
        StringBuffer sb=new StringBuffer(stmp);
        HashMap maptt=null;
        for(int i=0;i<arrayResult.size();i++){
          maptt=(HashMap)arrayResult.get(i);
          sb.append(maptt.get("phone"));
          sb.append(" ");
          sb.append(maptt.get("type"));
          sb.append(":");
          sb.append(maptt.get("result"));
          sb.append("\r\n");
        }
        outstream.write(sb.toString().getBytes());
        outstream.close();
        */
/////////////////////
       if(vet!=null)vet.clear();
      }catch(Exception e1){
     	e1.printStackTrace();
       throw e1;
      }

%>
<form name="inForm" method="POST" action="batchOpenForce.jsp">
      <input type="hidden" name="op" value="saveasfile">

      <table border="0" align="center" class="table-style2" width=100% >
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">Failed result of batch account opening/cancellation</td>
        </tr>
        <tr >
          <td height="15" colspan="2" align="center" >&nbsp;</td>
        </tr>
      </table>
      <table width="98%" border="1" align="center" cellpadding="1" cellspacing="1"  class="table-style2" >
      <tr class="tr-ringlist">
        <td width="20%" align="center">Account number</td>
        <td width="20%" align="center">Operation type</td>
        <td width="60%" align="center">Result</td>
      </tr>
<%
      HashMap maptemp=null;
      for(int k=0;k<arrayResult.size();k++){
        maptemp=(HashMap)arrayResult.get(k);
        out.println("<tr bgcolor='"+(k%2==0?"E6ECFF" :"#FFFFFF")+"'>");
        out.println("<td>"+maptemp.get("phone")+"</td>");
        out.println("<td>"+maptemp.get("type")+"</td>");
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
  window.location.href="batchOpenForce.jsp?op=first";
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
        sysInfo.add(sysTime + operName + ", An error occurred for batch account!");//
        sysInfo.add(sysTime +  e.toString());
        vet.add(operName + ", An error occurred for batch account!");//
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="batchOpenForce.jsp?op=first">
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

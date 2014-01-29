<%@page import="java.lang.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@ page import="zxyw50.SocketPortocol"%>
<%@page import="zxyw50.manSysPara"%>
<%@page import="zxyw50.manUser"%>
<%@page import="zxyw50.CrbtUtil"%>
<%@page import="zxyw50.*" %>
<%@page import="zxyw50.group.dao.*" %>
<%@page import="com.zte.jspsmart.upload.*"%>
<%@ page import="com.zte.socket.imp.pool.SocketPool"%>

<%@include file="../pubfun/JavaFun.jsp"%>
<%
  response.addHeader("Cache-Control", "no-cache");
  response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Batch account opening</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js" type=""></SCRIPT></head>
<body background="background.gif" class="body-style1">
<%
  int isSmart = zte.zxyw50.util.CrbtUtil.getConfig("isSmart",0);
  boolean isopened = false;
  String sysTime = "";
  int ret = 0;
  Vector sysInfo = (Vector) application.getAttribute("SYSINFO");
  String operID = (String) session.getAttribute("OPERID");
  String operName = (String) session.getAttribute("OPERNAME");
  Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable) session.getAttribute("PURVIEW");
  //add by zh 2005-09-07
    long intervaltime =Long.parseLong(CrbtUtil.getConfig("intervaltime","1000")) ;
    //add end
    String usecalling  = zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0");
    String isimage = zte.zxyw50.util.CrbtUtil.getConfig("isimage", "0");
    String colorphotoname = zte.zxyw50.util.CrbtUtil.getConfig("colorphotoname","Color Photo Show");
    //ifChooseRingWhenOpen值为1，走接口机扣费，为0走存储过程，第一个月不扣费并设置为缺省铃音。
    String  ifChooseRingWhenOpen =  CrbtUtil.getConfig("ifChooseRingWhenOpen","0");
    String IMSURL =zte.zxyw50.util.CrbtUtil.getConfig("IMSURL","0");
    int isCombodia =  zte.zxyw50.util.CrbtUtil.getConfig("isCombodia",0);
    boolean is_starhub = CrbtUtil.getConfig("IsStarhub", "0").equals("1") ? true : false;

  try {
     ArrayList rList = null;
    Hashtable result = new Hashtable();
    List acctopenlist = null;
    manSysPara syspara = new manSysPara();
    manUser manuser = new manUser();
    sysTime = syspara.getSysTime() + "--";
    //配置权限？？？？？
    if (operID != null && purviewList.get("1-10") != null) {
      Vector vet = new Vector();
      int width =0;
      int per = 0;
      Hashtable hash = null;
      String op = request.getParameter("op") == null ? "" : transferString((String) request.getParameter("op")).trim();
      //String localfilename = request.getParameter("tfilename") == null ? "" : transferString((String) request.getParameter("tfilename")).trim();
      String filename = request.getParameter("filename") == null ? "" : transferString((String) request.getParameter("filename")).trim();
       int order = request.getParameter("order") == null ? -1: Integer.parseInt((String)request.getParameter("order"));
      int optype = 0;
      String userType = request.getParameter("userType") == null ? "0" : (String) request.getParameter("userType").trim();
      if(userType.trim().equalsIgnoreCase(""))
         userType = "0";
      String ringid = request.getParameter("ringid") == null ?"" :request.getParameter("ringid").toString().trim();
      String bj     = request.getParameter("bj") == null ?"1" :request.getParameter("bj").toString();




      String title = "";
      String desc = "";
      //String blackfromdb = null;
      if (op.equals("syn97")) {
        optype = 1;
        desc = operName + " Synchroniztion 97 mode batch account opening";
        title = "Batch account opening";
      }
      else if (op.equals("nosyn97")) {
        optype = 2;
        desc = operName + " Synchroniztion 97 mode batch account opening";
        title = "Batch account opening";
      }
      if(op.equals("saveasfile")){
        response.setContentType("APPLICATION/OCTET-STREAM");
    	response.setHeader("Content-Disposition","attachment; filename=\"account_result.txt\"");
        List arra=(ArrayList)session.getAttribute("rList");
        Map tmap=null;
    	out.clear();
    	out.println("Subscriber number        account opening result          ");
	for(int k=0;k<arra.size();k++){
          tmap=(Hashtable)arra.get(k);
          out.println(tmap.get("acctnum").toString()+","+tmap.get("result").toString());
          tmap.clear();
	}
        arra.clear();
        return;
      }
      if (op.equals("first")) {
%>
<table border="0" align="center" class="table-style2" width=100%>
    <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Batch account opening</td>
    </tr>
    <tr>
        <td height="15" colspan="2" align="center">&nbsp;</td>
    </tr>
</table>
<form name="inputForm" method="POST" action="batchopenaccount.jsp" >
<input type="hidden" name="filename" value="">
<input type="hidden" name="op" value="">
<input type="hidden" name="ringlabel" value="">
<input type="hidden" name="userType" value="0">
<table align="center"  class="table-style2" border="0">
    <tr >
        <td  colspan="2">File name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="text" name="filename1" value="" disabled class="input-style1">
       <img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"> &nbsp;&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" style="display:<%= isCombodia==1?"none":""%>"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code&nbsp;&nbsp;
        <input type="text" name="ringid" value="" maxlength="20" class="input-style1" readonly ><img src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo()">
      </td>
    </tr>
     <tr style="<%=(("1".equals(usecalling)||"1".equals(isimage))?"display:block":"display:none")%>">
        <td  colspan="2">Account opening type
        		<input type="radio" name="bj" value="1" checked  onclick="bclk('0');">Called</input>
            <%if("1".equals(zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0"))){%>
        		<input type="radio" name="bj" value="2" onclick="bclk('1');">Calling</input>
            <%}%>
            <!--<input type="radio" name="bj" value="2" onclick="bclk('2');">Calling and called</input>-->
            <%if("1".equals(zte.zxyw50.util.CrbtUtil.getConfig("isimage","0"))){%>
                <input type="radio" name="bj" value="16" onclick="bclk('3');"><%=colorphotoname%> </input>
            <% }%>
      </td>
    </tr>
    <tr>
        <td align="center" style="display:<%= isCombodia==1?"none":""%>">
            <img src="button/icon_zjkh.gif" onClick="actupnosyn()">
        </td>
        <%String showboss = "";
        if(is_starhub)
        { showboss ="none";
        }%>
        <td align="center" style="display:<%=showboss%>">
            <img src="button/icon_bosskh.gif" onClick="actupsyn()">
        </td>
    </tr>

</table>
</form>



<script language="JavaScript1.2">
function check(){
    var fname=document.inputForm.UPFILE1.value;
  var fext;
  if(fname=="")
  {
     alert("Please Select the file!");
     return false;
  }
  else{
      fext=fname.substring(fname.lastIndexOf('.'));
      if(fext=='.txt' || fext == '.TXT' || fext == 'TXt' ||fext == 'TxT' || fext=='Txt'||fext=='tXT'|| fext =='tXt' || fext=='txT'){
        return true;
      }else{
        alert('The format of file should  be \'*.txt\'!');
        return false;
      }
  }
}

function actupnosyn(){
    var value = document.inputForm.filename1.value;
  if(trim(value)==""){
      //alert("请先选择批量开户文件,谢谢!");
      alert("Please select batch account opening file first!");
      return;
  }
  document.inputForm.op.value="nosyn97";
  document.inputForm.submit();
}

function bclk(avar)
{
  document.inputForm.userType.value=avar;
}

function actupsyn(){
    var value = document.inputForm.filename1.value;
  if(trim(value)==""){
      //alert("请先选择批量开户文件,谢谢!");
      alert("Please select batch account opening file first!");
      return;
  }
  document.inputForm.op.value="syn97";
  document.inputForm.submit();
}
function selectFile() {
      var fm = document.inputForm;
      var uploadURL = 'batchopenaccountupload.jsp';
      uploadRing = window.open(uploadURL,'batchopenaccountupload','width=400, height=220');
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.filename1.value = label;
      fm.filename.value = name;
   }

   function queryInfo() {
     var result =  window.showModalDialog('ringSearch.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       document.inputForm.ringid.value=result;
     }
   }
</script><%
  } else if(optype>0) { //optype ==first

  if(order == -1){//第一次处理文件
    rList = new ArrayList();
    session.setAttribute("rList",rList);
    acctopenlist = syspara.getAcctList(filename,0, application);
    session.setAttribute("acctopenlist",acctopenlist);
    int acctcnt = acctopenlist.size();
    session.setAttribute("totalcnt", new Integer(acctcnt));
    %>
 <form name="inputForm" method="post" action="batchopenaccount.jsp">
<input type="hidden" name="op" value="<%=op %>">
<input type="hidden" name="order" value="<%= (order + 1) + "" %>">
  <input type="hidden" name="userType" value="<%=userType%>">
<input type="hidden" name="ringid" value="<%=ringid%>">
<table border="0" align="center" class="table-style2" width=100%>
    <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">Batch account opening result</td>
    </tr>
    <tr>
        <td height="15" colspan="2" align="center">&nbsp;</td>
    </tr>
</table>
<table width="98%" border="1" align="center" cellpadding="1" cellspacing="1" class="table-style2">
    <tr class="tr-ringlist">
        <td width="30%" align="center">Subscriber number</td>
        <td width="70%" align="center">Account opening result</td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
</table>
</form>
<script language="javascript">
<%
if((order+1)<acctopenlist.size()){
%>
   document.inputForm.submit();
<%
}
%>
</script>
    <%
  }else{
      acctopenlist = (ArrayList)session.getAttribute("acctopenlist");
      width=(int)((float)(order+1)/acctopenlist.size()*300f);
      int dot = (int)(((float)(order+1)/acctopenlist.size())*100);
      per = dot>100?100:dot;
      rList = (ArrayList)session.getAttribute("rList");
      if(order <acctopenlist.size()){

      String acctnum = null;
      String passwd = null;
      String imsurl= "0";
      String sLevel = "1";
    //可以在函数中处理所有异常,待考虑
    try {
      if (optype == 1) {
        hash = (Hashtable)acctopenlist.get(order);
        acctnum = hash.get("usernumber").toString();
        passwd = hash.get("cardpass").toString();
	sLevel = hash.get("level")==null?"1":hash.get("level").toString(); 
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        hash = new Hashtable();
        hash.put("opcode","01010101");
        hash.put("craccount",acctnum);
        hash.put("level",sLevel);
        hash.put("opmode","6");           //人工台
        hash.put("ipaddr",operName);
        //System.out.println("userType="+userType);
        hash.put("userringtype",userType);
        hash.put("passwd",passwd);
        SocketPortocol.send(pool,hash);
	ret = 0;
        result.put("acctnum",acctnum);
        result.put("result","Account opening successful");
        if(rList != null){
           rList.add(result);
      }
      }
      else if(optype == 2) {
           //开户
		  boolean imsUrlStatus = true;
		  String sfailReason = "";
          hash = (Hashtable)acctopenlist.get(order);
          acctnum = hash.get("usernumber").toString().trim();
          passwd = hash.get("cardpass").toString();
          sLevel = hash.get("level")==null?"1":hash.get("level").toString(); 
		  if("1".equals(IMSURL)){
	  imsurl = hash.get("imsUrl").toString();
			sfailReason ="URL Format is not correct. It should contain @ and . characters"; 
		
			if((imsurl.indexOf(',')) >= 0)
			{
					imsUrlStatus = false;
					sfailReason ="URL Format is not correct. It cannot contain , characters"; 
					
			 }
			else if((imsurl.indexOf('@')<0) || (imsurl.indexOf('.')<0))
			{
					imsUrlStatus = false;
					sfailReason ="URL Format is not correct. It should contain @ and . characters"; 
			
			}
			else if((imsurl.indexOf('@')==0) || (imsurl.indexOf('.')==0))
		  {
					imsUrlStatus = false;
					sfailReason ="URL Format is not correct @ or . cannot be the first characters"; 
		
			}
		 }
					
		  if(imsurl.equals("0")||(imsUrlStatus==true))
		  {
          SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
          hash = new Hashtable();
          hash.put("opcode","01010101");
          hash.put("craccount",acctnum);
          hash.put("level",sLevel);
          hash.put("opmode","b");         //管理员
          hash.put("ipaddr",operName);
          hash.put("userringtype",userType);
          hash.put("passwd",passwd);
          SocketPortocol.send(pool,hash);


          // set default ring 2006.05.09
          if(ringid.length()>1){

           	if(!"1".equals(ifChooseRingWhenOpen))
           	{
          		//sunqi:20060510 本段改为调用存储过程
             	try
             	{
          	 		//manUser manuser= new manUser();
          	 		Hashtable hashuser = new Hashtable();
          	 		hashuser.put("usernumber",acctnum);
          	 		hashuser.put("rsubindex","0");
          	 		hashuser.put("ringid",ringid);
          	 		hashuser.put("ringidtype","1");
          	 		hashuser.put("playstarttime","0");
          	 		hashuser.put("playendtime","0");
          	 		hashuser.put("flag",bj);
          	 		manuser.setDefaultRing(hashuser);
          	 	}catch(Exception e)
          	 	{
          	 		System.out.println("set default ring failed.usernumber:"+acctnum);
          	 	}
          	}
          	else
          	{
          		//为1，走接口机，开户订购铃音就扣费
          		hash.put("opcode","01010905");
            	hash.put("craccount",acctnum);
            	hash.put("crid",ringid);
            	hash.put("opmode","6");      //人工台
            	hash.put("ipaddr",operName);
            	hash.put("ringidtype","1");
            	hash.put("ret1","1");
          		try  {
          			//订购有可能失败，例如订购的是已经赠送的铃音
          			SocketPortocol.send(pool,hash);
          		}catch (Exception e)
          		{
          		}

          		//设置为缺省铃音
             	hash.put("opcode","01010947");
             	hash.put("craccount",acctnum);
             	hash.put("crid",ringid);
             	hash.put("callingnum","");
             	hash.put("starttime","00:00:00");
             	hash.put("endtime","23:59:59");
             	hash.put("startdate","2000.01.01");
             	hash.put("enddate","2999.12.31");
             	hash.put("startweek","01");
             	hash.put("endweek","07");
             	hash.put("startday","01");
             	hash.put("endday","31");
             	hash.put("callingtype","0");
             	if("1".equals(userType))
                {
               	hash.put("callingtype","100");
                }
                // add color photo
                if("3".equals(userType))
                {
               	hash.put("callingtype","110");
                }
             	hash.put("settype","0");
             	hash.put("opertype","0");
             	hash.put("ringidtype","1");
             	hash.put("description","");
             	hash.put("setno","");
             	hash.put("setpri","");
             	SocketPortocol.send(pool,hash);
          	}
          }
      ret = 0;
       result.put("acctnum",acctnum);
       result.put("result","Account opening successful");
       if(rList != null){
           rList.add(result);
       }
	 //Added to update imsUrl
	  if("1".equals(IMSURL)){

		   manuser.updateimsurl(acctnum,imsurl);
				
	  }
	   
	   
      }// end of ims 
	  	else
		  {
				 System.out.println("IMS URL:"+imsurl);
				  result.put("acctnum",acctnum);
					result.put("result",sfailReason);
       if(rList != null){
           rList.add(result);
       }

         }
      }//end optype == 2
      }

    catch (Exception e) {
		//Added by srinivas for V5.04.09 [Smart] on 26-05-2011 for
		//smart send close account if order ring failed
		if(isSmart==1) {//if smart send close account if order ring failed
		try{
		hash = new Hashtable();
		hash.put("opcode","01010102");
		hash.put("userringtype",userType);
		hash.put("craccount",acctnum);
		hash.put("passwd","");
		hash.put("opmode","b");
		hash.put("ipaddr",operName);
		hash.put("reason","Ringtone order failed after open account");
		SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
		SocketPortocol.send(pool,hash);
		}catch(Exception ex){
			System.out.println(operName + " Error occurred in cancelling the account " + acctnum +" !");
		}
	  }
	 //End od close account send
      e.printStackTrace();
        ret = 1;
        result.put("acctnum",acctnum);
        result.put("result","Account opening fail:"+e.getMessage());
        rList.add(result);

    }
    Thread.currentThread().sleep(intervaltime);
     session.setAttribute("rList",rList);
      }
      %>
<form name="inputForm" method="post" action="batchopenaccount.jsp">
<input type="hidden" name="op" value="<%=op %>">
<input type="hidden" name="order" value="<%= (order + 1) + "" %>">
<input type="hidden" name="userType" value="<%=userType%>">
<input type="hidden" name="ringid" value="<%=ringid%>">
<table>
  <tr>
	  <td ><table><tr><td width="<%=width%>" bgcolor="#56ef45"></td><td><%=per%>%&nbsp;</td></tr></table></td>
  </tr>
  <tr>
	  <td><%=width==300?"Excute batch account opening operation finished!":"Executing batch account opening operation ,please wait..."%></td>
  </tr>
</table>
<table border="0" align="center" class="table-style2" width=100%>
    <tr>
        <td height="26" colspan="2" align="center" class="text-title" background="../image/n-9.gif">Excute account opening result</td>
    </tr>
    <tr>
        <td height="15" colspan="2" align="center">&nbsp;</td>
    </tr>
</table>
<table width="98%" border="1" align="center" cellpadding="1" cellspacing="1" class="table-style2">
    <tr class="tr-ringlist">
        <td width="30%" align="center">Subscriber number</td>
        <td width="70%" align="center">Account opening result</td>
    </tr>
<%
  Map maptemp = null;
  for (int k = 0; k < rList.size(); k++) {
    maptemp = (Hashtable) rList.get(k);
    out.println("<tr bgcolor='" + (k % 2 == 0 ? "E6ECFF" : "#FFFFFF") + "'>");
    out.println("<td>" + maptemp.get("acctnum") + "</td>");
    out.println("<td>" + maptemp.get("result") + "</td>");
    out.println("</tr>");
  }
%>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
</table>

</form>
<script language="javascript">
<%
if((order+1)<acctopenlist.size()){
%>
   document.inputForm.submit();
<%
}
%>
</script>
  <%
  }
  if(order+1 == acctopenlist.size()){
    isopened = true;
  session.removeAttribute("acctcnt");
  session.removeAttribute("acctopenlist");
  }
%>
<script language="JavaScript">
       if(parent.frames.length>0)
       parent.document.all.main.style.height="400";
</script>

<form name="inputForm1" method="post" action="batchopenaccount.jsp">
<input type="hidden" name="op" value="saveasfile">
<table width="98%" border="1" align="center" cellpadding="1" cellspacing="1" class="table-style2">
    <tr>
        <td colspan="2" align="center">
            <input type="button" name="saveas" value="Save as file" <%if(!isopened){%> disabled="disabled""true" <%}else{%> disable="false" <%}%>onclick="saveasfile()">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" value="Back" onclick="f_return()">
        </td>
    </tr>
</table>
</form>
<script>
function saveasfile(){
  document.inputForm1.target="_parent";
  document.inputForm1.saveas.disabled=true;
  document.inputForm1.submit();
}

function f_return(){
  window.location.href="batchopenaccount.jsp?op=first";
}
</script>
<%
  }
if(ret ==0){
    // 准备写操作员日志
    zxyw50.Purview purview = new zxyw50.Purview();
    HashMap map = new HashMap();
    map.put("OPERID", operID);
    map.put("OPERNAME", operName);
    map.put("OPERTYPE", "110");
    map.put("RESULT", "1");
    map.put("PARA1","ip:"+request.getRemoteAddr());
    map.put("DESCRIPTION", title);
    purview.writeLog(map);
}

%>

<%
   //batch acct
  } else { //operID != null && purviewList.get("13-1") != null
    if (operID == null) {
%>
<script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script><%} else {%>
<script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//You have no access to this function!");
              </script><%
  }
  }
  } catch (Exception e) {
    Vector vet = new Vector();
    sysInfo.add(sysTime + operName + " exception occurred on  batch account opening!");
    sysInfo.add(sysTime + operName + e.toString());
    vet.add("Error occurred on  batch account opening ");
    vet.add(e.getMessage());
    session.setAttribute("ERRORMESSAGE", vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="batchopenaccount.jsp?op=first">
</form>
<script language="javascript">
   document.errorForm.submit();
</script><%}%>
</body>
</html>

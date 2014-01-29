<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.*" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="com.zte.zxywpub.*" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Group ringtone uploading</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="body-style1">
<%
String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");
int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
String useeditringid = CrbtUtil.getConfig("useeditringid","0");
   //add by ge quanmin 2005-07-07
 String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","Ringtone producer");
     ringsourcename=transferString(ringsourcename);
//end
String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String allowUp = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
	boolean flagm = (Integer.parseInt(allowUp) == 1)?true:false;
	String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String ifcopyring = (String)application.getAttribute("IFCOPYRING")==null?"1":(String)application.getAttribute("IFCOPYRING");
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
    //change by wxq 2005.05.31 for version 3.16.01
    String mode = request.getParameter("mode") == null ? "" : request.getParameter("mode");
    String groupindex,groupid,groupname;
    if (mode.equals("manager")){
        groupindex = request.getParameter("groupindex") == null ? "" : request.getParameter("groupindex");
        groupid = request.getParameter("groupid") == null ? "" : request.getParameter("groupid");
        groupname = request.getParameter("groupname") == null ? "" : transferString(request.getParameter("groupname"));
    }else{
        groupindex = (String)session.getAttribute("GROUPINDEX");
        groupid = (String)session.getAttribute("GROUPID");
        groupname =  (String)session.getAttribute("GROUPNAME");
    }
    //end
    String uploadfee = (String)session.getAttribute("UPLOADFEE");
    if(uploadfee==null || uploadfee.equals(""))
      uploadfee = "1.0";
	 if(ringdisplay.equals(""))
        ringdisplay = "ringtone";
        
        
   //String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);        
        
        
    try {
        manSysRing sysring = new manSysRing();
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = sysring.getSysTime() + "--";
        String op = request.getParameter("op") == null ? null : (String)request.getParameter("op");
        int isMCCI = zte.zxyw50.util.CrbtUtil.getConfig("isMCCI",0);
        ywaccess yes=new ywaccess();
        String suiyi=yes.getPara(145);
        int flag = 0;
      String errMsg = "";
      boolean blexist = false;
	if (purviewList.get("12-1") == null)  {
	 //如果mode的值为manager,表明是管理员进入,并且已经通过了审核,允许进入
            if (mode.equals("manager")){
                blexist = false;
            }
            else{
        //errMsg = "You have no access to the function";
               errMsg ="You have no access to this function";
                blexist = true;
            }
        }
if (!blexist&&groupindex != null&&groupid!=null) {
            Hashtable hash = new Hashtable();
            manSysPara syspara = new manSysPara();
            ArrayList spInfo = syspara.getGrpSPInfo();
            if (op != null) {
                //  uploadringtone
                SocketPortocol portocol = new SocketPortocol();
                 //change by wxq 2005.06.06
                hash.put("opcode","01010993");
                hash.put("craccount",groupid);
                hash.put("own","8");
                hash.put("path","/tmp");
                String ringname = request.getParameter("ringname") == null ? null : transferString((String)request.getParameter("ringname"));
                //ringtone名称
                if(checkLen(ringname,40))
                	throw new Exception("The input " + ringdisplay + " name 's length exceeds the limit, please input it again!");
         hash.put("ringname",ringname);
                //File name
                String filename = request.getParameter("ringfile") == null ? null : transferString((String)request.getParameter("ringfile"));
                hash.put("filename",filename);
                String auther = request.getParameter("ringauthor") == null ? "*" : transferString((String)request.getParameter("ringauthor"));
		String ringspell = request.getParameter("ringspell") == null ? "" : (String)request.getParameter("ringspell");
                if(checkLen(auther,40))
                	throw new Exception("The length of singer name exceeds the limit, please input it again!");
                hash.put("auther",auther);
                //根据3.16.01版本修改,现在传入一个形同“xxx|xxxx”的字符串,然后进行拆分
                String supplier = request.getParameter("sp") == null ? null : transferString((String)request.getParameter("sp"));
                String ringSource=request.getParameter("ringsource") == null ? null : transferString((String)request.getParameter("ringsource"));
                 String spcode,price;
                if (!supplier.equals("")){
                    String[] strTmp = supplier.split(":");
                    spcode = strTmp[0];
                    price = strTmp[1];
                }
                else{
                    spcode = "";
                    price = "";
                }
                hash.put("spcode",spcode);
                hash.put("price",price);
               if(checkLen(ringSource,40))
                  //throw new Exception("您输入的" + ringsourcename + "超过长度限制,请重新输入!");
                    throw new Exception("The input "+ ringsourcename +"Exceeds the length limit, please input it again!");
                hash.put("uservalidday",request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday"));
                //hash.put("isfreewill","00");
                hash.put("supplier",ringSource);
                //hash.put("ringlib","");
                hash.put("ringid",request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid"));
                hash.put("expiredate",expireTime);
                hash.put("ftpaddr",portocol.getFtpAddr());
                hash.put("ftpuser",portocol.getFtpUser());
                hash.put("ftppwd",portocol.getFtpPass());
                hash.put("authnamee",ringspell);
                hash.put("opmode","1");
	        hash.put("ipaddr",request.getRemoteAddr());
	         // Added for MCCI- V5.14.01 .. Set tone requirement [By Srinivas]
	            hash.put("isfreewill",request.getParameter("isfreewill")== null?"00":("0"+(String)request.getParameter("isfreewill"))); 
	           
                // 法电彩像版本增加 by yuanshenhong
                String mediatype = "1";
                String filetype = "1";
                //Added to support amr files for MCCI
                int pos = filename.lastIndexOf(".");
                String subfix = filename.substring(pos);
                if(subfix.equals(".amr")){
                  mediatype = "1";
                  filetype ="128";
                }
                
                /*    如果需要支持彩像功能，取消注释
                int pos = fileName.lastIndexOf(".");
                String subfix = fileName.substring(pos);
                //a)媒体类型：1音频2视频4图像
                //b)媒体文件类型：1 wav文件，2 mov文件，4gif文件，8jpg文件，16bmp文件
                if (subfix.equals(".wav")) {
                  mediatype = "1";
                  filetype = "1";
                }
                if (subfix.equals(".3gp")) {
                  mediatype = "2";
                  filetype = "2";
                }
                if (subfix.equals(".gif")) {
                  mediatype = "4";
                  filetype = "4";
                }
                if (subfix.equals(".jpg")) {
                  mediatype = "4";
                  filetype = "8";
                }
                if ( subfix.equals(".bmp")) {
                  mediatype = "4";
                  filetype = "16";
                }
                if ( subfix.equals(".txt")) {
                  mediatype = "4";
                  filetype = "32";
                }*/
                hash.put("mediatype", mediatype);
                hash.put("filetype", filetype);
                // end
                hash.put("preflag", "0");
                hash.put("prefilename", "");
                ftpclass myFTP = new com.zte.zxywpub.ftpclass(portocol.getFtpAddr(),portocol.getFtpUser(),portocol.getFtpPass());
                //  uploadringtone到FTP临时目录
               if (! myFTP.uploadto("/tmp",filename,false,portocol.getWavDir() + "/tmp/" + filename))
                 throw new Exception("Uploading tones to the FTP fails!");
                SocketPortocol.send(pool,hash);
                //sysring.ringUpload(pool,hash);
                sysInfo.add(sysTime + groupname + " upload " + ringdisplay + " successfully!");

            zxyw50.Purview purview = new zxyw50.Purview();
        	HashMap map = new HashMap();
	        map.put("OPERID",operID);
            map.put("OPERNAME",operName);
	        map.put("OPERTYPE","2000");
	        map.put("RESULT","1");
             map.put("PARA1",ringname);
            map.put("PARA2",auther);
            map.put("PARA3",ringspell);
            map.put("PARA4",groupid);
            map.put("PARA5","ip:"+request.getRemoteAddr());
	        purview.writeLog(map);
%>
<script language="javascript">
   alert('<%=  ringdisplay  %> upload  successfully!');
</script>
<%
            }
%>

<form method="post" name="inputForm" action="ringUpload.jsp">
<input type="hidden" name="ringfile" value="">
<input type="hidden" name="op" value="">
<!--change by wxq 2005.06.17-->
<input type="hidden" name="mode" value="<%=mode%>"/>
<input type="hidden" name="groupid" value="<%=groupid%>"/>
<input type="hidden" name="groupindex" value="<%=groupindex%>"/>
<input type="hidden" name="groupname" value="<%=groupname%>"/>
<!--end-->
	<table align="center" border="0" cellPadding="0" cellSpacing="0" height="530" width="100%" id="table1">
		<tr>
			<td bgColor="#ffffff" vAlign="top">
			<table border="0" cellPadding="0" cellSpacing="0" width="100%" id="table2">
				<tr>
					<td>
					<table border="0" cellPadding="0" cellSpacing="0" width="100%" id="table3">
						<tr>
							<td>
							<table border="0" cellPadding="0" cellSpacing="0" width="100%" id="table4">
								<tr>
									<td> </td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			<table align="center" border="0" cellPadding="0" cellSpacing="0" class="table-style2" width="95%" id="table5">
				<tr>
					<td width="28">
				  <img height="31" src="../image/home_r14_c3.gif" width="28">
            </td>
					<td background="../image/home_r14_c5bg.gif">
              <font color="#006600"><b><font class="font">Group <%=ringdisplay%> upload</font></b></font>
            </td>
					<td width="12">
					 <img height="31" src="../image/home_r14_c5.gif" width="12">
            </td>
				</tr>
			</table>
			<table align="center" border="0" cellPadding="2" cellSpacing="2" class="table-style2" width="95%" id="table6">
				<tr vAlign="top">
					<td width="100%">
					<table border="0" cellPadding="2" cellSpacing="1" class="table-style3" width="100%" id="table7">
						<tr>
							<td align="right">Group number&nbsp;</td>
							<td><%=groupid %></td>
						</tr>
                                                                <%if(useeditringid.equalsIgnoreCase("1")){%>
                <tr>
          <td align="right">Ringtone ID&nbsp;</td>
          <td>
           <input type="text" name="ringid" value="" maxlength="20" class="input-style1" >
          </td>
        </tr>
        <%}%>
						<tr>
							<td align="right">File name&nbsp;</td>
				 <td><input class="input-style1" disabled name="filename"></td>
						</tr>
						<tr>
                  <td align="right"><%=ringdisplay%> Name&nbsp;</td>
						 <td><input class="input-style1" maxLength="40" name="ringname"></td>
						</tr>
	        <tr>
          <td align="right" >The spell of ringtone&nbsp;</td>
          <td ><input type="text" name="ringspell" class="input-style1" maxLength="20"></td>
        </tr>
						<tr>
							<td align="right">Singer&nbsp;</td>
							<td><input class="input-style1" maxLength="40" name="ringauthor"></td>
						</tr>
         <%
          String typeDisplay = "none";
         if(useringsource.equals("1"))
         typeDisplay="";
         %>
         <tr style="display:<%= typeDisplay %>">
           <td align="right"><%=ringsourcename%></td>
           <td><input type="text" name="ringsource" value="" maxlength="40" class="input-style1"></td>
         </tr>
						 <tr>
                  <td align="right">SP&nbsp;</td>
							<td>
						 <select class="input-style1" name="sp">
<%
               for (int i = 0; i < spInfo.size(); i++) {
                  HashMap map1 = (HashMap)spInfo.get(i);
%>
                      <option value="<%= (String)map1.get("spcode") %>:<%= (String)map1.get("para1") %>"><%= (String)map1.get("spname") %>---<%= (String)map1.get("para1") %>(<%=minorcurrency%>)</option>
<%
               }
%>
                    </select>
                  </td>
						</tr>
		<%String dispIsfreewill = "none";
         if("1".equals(suiyi))
        	dispIsfreewill = "";
        %>
      <tr style="display:<%= dispIsfreewill %>">
          <td align="right">Is it will ringtone or not</td>
          <td>
            <table border="0" width="100%" class="table-style2">
              <tr align="center">
                <td width="50%"><input type="radio"  checked name="isfreewill" value="1">Yes</td>
                <td width="50%"><input type="radio"  name="isfreewill" value="0">No</td>
              </tr>
            </table>
          </td>
        </tr>
						
						<tr>
							<td colSpan="2">
							<table border="0" class="table-style2" width="100%" id="table8">
								<tr>
									<td align="right" width="50%">
 <img onclick="javascript:selectFile()" onmouseover="this.style.cursor='hand'" src="../button/file.gif" style="CURSOR: hand">
                        </td>
									<td width="50%">
									  <img onclick="javascript:upload()" onmouseover="this.style.cursor='hand'" src="../button/upload.gif" style="CURSOR: hand">
                        </td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				        <tr valign="top">
     <td width="100%">
       <table width="98%" cellspacing="1" cellpadding="2" border="0" class="table-style2">
              <tr >
                <td class="table-styleshow" background="../image/n-9.gif" height="26" bgcolor="#FFFFFF">
                 Help:</td>
              </tr>
						<tr>
                  <td>1.  Before upload <%=ringdisplay%>, please select <%=ringdisplay%> file, then click "file" button;</td>
						</tr>
						<tr>
                  <td>2.  Before click  "upload" button, please input <%=ringdisplay%> name.</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</form>
<%
        }
        else {
%>
<script language="javascript">
   var errorMsg = '<%= groupindex!=null?errMsg:"Please log in to the system first!"%>';
	alert(errorMsg);
	document.location.href = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + groupname + ringdisplay + " is abnormal during the uploading!");
        sysInfo.add(sysTime + groupname + e.toString());
        vet.add(ringdisplay + " error occurs during the uploading!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="ringUpload.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>&amp;groupindex=<%=groupindex%>&amp;groupname=<%=groupname%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>

</body>
</html>
<script language="javascript">
   var   ringdisplay = "<%=  ringdisplay  %>";
   function upload () {
      var fm = document.inputForm;
           <%if(useeditringid.equalsIgnoreCase("1")){%>
             if (trim(fm.ringid.value) != '') {
            var tmp2 = trim(fm.ringid.value);
      if (!checkstring('0123456789',tmp2) || tmp2 == '') {
         alert('Ringtone ID should be in the digit format only!');
         fm.ringid.focus();
         return;
         }
      }
   <%}%>
      if (trim(fm.filename.value) == '') {
         alert('Please select ' + ringdisplay + ' file!');
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringname.value) == '') {
         alert('Please input ' + ringdisplay + ' name!');
         fm.ringname.focus();
         return;
      }
      if (!CheckInputStr(fm.ringname, ringdisplay + ' name'))
         return;

       if (trim(fm.ringspell.value) == '') {
         alert('Please input the spell of ringtone!');
         fm.ringspell.focus();
         return;
      }
      if (!CheckInputChar1(fm.ringspell, 'The spell of ringtone'))
         return;

     if (trim(fm.ringauthor.value) == '') {
         alert('Please input the artist!');
         fm.ringauthor.focus();
         return;
      }
      if (!CheckInputStr(fm.ringauthor,'Singer'))
         return;
       <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.ringname.value,40)){
            alert("The ringtone name should not exceed 40 bytes!");
            fm.ringname.focus();
            return;
          }
          if(!checkUTFLength(fm.ringspell.value,20)){
            alert("The ringspell should not exceed 20 bytes!");
            fm.ringspell.focus();
            return;
          }
          if(!checkUTFLength(fm.ringauthor.value,40)){
            alert("The Singer name should not exceed 40 bytes!");
            fm.ringauthor.focus();
            return;
          }
        <%
        }
        %>
        //modify by ge quanmin 2005-07-07
      <%if(useringsource.equals("1")){%>
       if (trim(fm.ringsource.value) == '') {
         alert('Please input the ringtone producer!');
         fm.ringsource.focus();
         return;
      }
     if (!CheckInputStr(fm.ringsource,ringdisplay + 'producer'))
       return;
    <%}%>
      fm.filename.disabled = false;
      fm.op.value = 'upload';
      fm.submit();
   }

   function selectFile () {
      uploadRing = window.open('upload.jsp?mode=<%=mode%>&amp;groupid=<%=groupid%>','upload','width=500, height=220');
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.ringfile.value = name;
      fm.filename.value = label;
      fm.ringname.value = label.substring(0,label.length - 4);
   }
</script>

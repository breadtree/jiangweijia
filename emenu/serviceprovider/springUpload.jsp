<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<script src="../pubfun/JsFun.js"></script>
<html>
<head>
<title>Upload system ringtone</title>
<link rel="stylesheet" type="text/css" href="../manager/style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
	//String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);
	String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");

int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
String userday = CrbtUtil.getConfig("uservalidday","0");
String useeditringid = CrbtUtil.getConfig("useeditringid","0");
//是否支持随意铃功能开关
ywaccess yes=new ywaccess();
String suiyi=yes.getPara(145);

//在支持Input manually铃音id的情况下是否需要输入铃音前缀
String useeditringidprefix=CrbtUtil.getConfig("useeditringidprefix","0");

 //add by ge quanmin 2005-07-07
 String useringsource=CrbtUtil.getConfig("useringsource","0");
 String ringsourcename=CrbtUtil.getConfig("ringsourcename","Privoder");
 ringsourcename=transferString(ringsourcename);
//end
  String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ringlibid = request.getParameter("ringlibid") == null ? "" : (String)request.getParameter("ringlibid");
    String ringablealias1 = CrbtUtil.getConfig("ringablealias1","0");
    String ringablealias2 = CrbtUtil.getConfig("ringablealias2","0");
    String sLangLabel1 = CrbtUtil.getConfig("langlabel1","Arabic");
    String sLangLabel2 = CrbtUtil.getConfig("langlabel2","French");
    int isSupportMultiplePrice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice", 0);
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String spIndex = (String)session.getAttribute("SPINDEX");
	String spCode = (String)session.getAttribute("SPCODE");
	String ringlibname = request.getParameter("ringlibname") == null ? "" : transferString((String)request.getParameter("ringlibname"));
        String spmix = request.getParameter("spmix") ==null?"":request.getParameter("spmix").toString().trim();
        SpManage spm=new SpManage();
        String springidprefix=spm.getSpRingIDPrefix(spIndex,"1");
	try {
	    Hashtable hash   = new Hashtable();
	    zxyw50.Purview purview = new zxyw50.Purview();
	    Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
        ColorRing colorRing = new ColorRing();
        ArrayList rList = null;
        manSysRing sysring = new manSysRing();
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = SocketPortocol.getSysTime() + "--";
        String op = request.getParameter("op") == null ? null : (String)request.getParameter("op");
        int flag = 0;
		String errMsg="";
		boolean alertflag=false;
		if (spIndex  == null || spIndex.equals("-1")){
			errMsg = "Sorry, you are not an SP administrator!";//Sorry,you are not the SP administrator
			alertflag=true;
		}
        else if (purviewList.get("10-1") == null)  {
			errMsg = "No access to this function.";//无权访问此功能
			alertflag=true;
        }
        else if (operID != null) {
            if (op != null) {
                SocketPortocol portocol = new SocketPortocol();
       			String ftpaddr = portocol.getFtpAddr();
                 // add color photo show
                 String mediatype = "";
                 String filetype = "";

                String ftpuser = portocol.getFtpUser();
                String ftppwd = portocol.getFtpPass();
                String filename = request.getParameter("ringfile") == null ? null : transferString((String)request.getParameter("ringfile"));
                if(spmix.equals("spmix"))
                  filename = operName+"_mix.wav";
                int pos = filename.lastIndexOf(".");
                String subfix = filename.substring(pos);
                //filetype = subfix;
                //a)媒体类型：1音频2视频4图像
                //b)媒体文件类型：1 wav文件，2 mov文件，4gif文件，8jpg文件，16bmp文件,32 txt
                if (subfix.equals(".wav")) {
                  mediatype = "1";
                  filetype = "1";
                }
                if (subfix.equals(".mov")) {
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
                }
                if ( subfix.equals(".3gp")) {
                          mediatype = "2";
                          filetype = "64";
				}     
                if ( subfix.equals(".amr")) {
                    mediatype = "1";
                    filetype = "128";
			   }  
               com.zte.zxywpub.ftpclass myFTP = null;
                myFTP = new com.zte.zxywpub.ftpclass(portocol.getFtpAddr(),portocol.getFtpUser(),portocol.getFtpPass());
                // 上传铃音到FTP临时目录
                System.out.println("springupload.jsp:filename="+portocol.getWavDir() + "/tmp/" + filename);
                if (! myFTP.uploadto("/tmp",filename,false,portocol.getWavDir() + "/tmp/" + filename))
                  throw new YW50Exception("Uploading the ring back tone through FTP failed!");//上传铃音到FTP过程中失败
                hash.put("opcode","01010993");
                hash.put("spcode",transferString(spCode));
                hash.put("craccount",request.getParameter("ringlibcode") == null ? null : (String)request.getParameter("ringlibcode"));
                hash.put("own","1");
                hash.put("filename",filename);
                String ringname = request.getParameter("ringname") == null ? null : transferString((String)request.getParameter("ringname"));
                if(checkLen(ringname,40))
                   throw new Exception("The name of the ring back tone you entered is too long. Please re-enter!");//您输入的Ringtone name长度超过限制,请重新输入!
                hash.put("ringname",ringname);
				hash.put("ringlabel",ringname);
       	        String auther = request.getParameter("ringauthor") == null ? null : transferString((String)request.getParameter("ringauthor"));
       	        if(checkLen(auther,40))
       	        	throw new Exception("The length of the Singer name you entered has exceeded the limit. Please re-enter!");//您输入的Singer name长度超过限制,请重新输入!
                hash.put("auther",auther);
       	        hash.put("price",request.getParameter("price") == null ? null : (String)request.getParameter("price"));
                hash.put("ftpuser",ftpuser);
			    hash.put("ftppwd",ftppwd);
				hash.put("path","/tmp");
		        hash.put("ftpaddr",ftpaddr);
		        String supplier = request.getParameter("ringsource")==null?"":transferString((String)request.getParameter("ringsource"));
		        if(checkLen(supplier,40))
		        	throw new Exception("The name of the SP you entered is too long. Please re-enter!");//您输入的铃音提供商长度超过限制,请重新输入
                hash.put("supplier",supplier);
		        hash.put("authnamee",request.getParameter("ringpell") == null ? null : transferString((String)request.getParameter("ringpell")));
                hash.put("expiredate",request.getParameter("validdate") == null ? null : transferString((String)request.getParameter("validdate")));
                hash.put("opmode","1");
             //begin add validity
            hash.put("uservalidday",request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday"));
            //end
            hash.put("ringid",request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid"));
			    hash.put("ipaddr",request.getRemoteAddr());
            //增加随意铃相关字段
            hash.put("isfreewill",request.getParameter("isfreewill") == null ? "00" : ("0"+(String)request.getParameter("isfreewill")));

            hash.put("mediatype", mediatype);
            hash.put("filetype", filetype);

          hash.put("preflag", "0");
          hash.put("prefilename", "");
          hash.put("price2",request.getParameter("price2") == null ? "0" : (String)request.getParameter("price2"));
		  Hashtable receive = new Hashtable();
            receive =  SocketPortocol.send(pool,hash);
                sysInfo.add(sysTime + operName + "System ringtone uploaded successfully!");//上传系统铃音成功
%>
<script language="javascript">
   alert("Ringtone uploaded successfully!");//铃音上传成功
</script>
<%
                // 准备写操作员日志
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","1000");
                if(spmix.equals("spmix"))
                  map.put("OPERTYPE","1012");
                map.put("RESULT","1");
                map.put("PARA1",ringname);
                map.put("PARA2",ringlibid);
                map.put("PARA3",auther);
                map.put("PARA4",(String)request.getParameter("validdate"));
                map.put("PARA5",(String)request.getParameter("price"));
                map.put("PARA6","ip:"+request.getRemoteAddr());
                purview.writeLog(map);

				// Extra Ring Information
				if(sysfunction.get("2-66-0")== null ) { 
		
					String resRingID =  receive.get("crid")==null ? "" : receive.get("crid").toString().trim();
					System.out.println("resRingID====================> "+resRingID); // to-do remove
					if(resRingID.equals("")) { 
						throw new Exception(" Problem while ringtone upload. Ring ID is Empty.");
				   }
  				    hash.put("extraringid",resRingID);
					hash.put("extraRingOpcode", "1"); // 1 - add - opCode
					hash.put("opflag", "3"); // opFlag
					hash.put("language", request.getParameter("language") == null ? "" : transferString((String)request.getParameter("language")));
					hash.put("alias1", request.getParameter("ringalias1") == null ? "" : transferString((String)request.getParameter("ringalias1"))); // para2
					hash.put("alias2", request.getParameter("ringalias2") == null ? "" : transferString((String)request.getParameter("ringalias2"))); // para3
					hash.put("albumid", request.getParameter("albumid") == null ? "" : transferString((String)request.getParameter("albumid"))); //  para8
					hash.put("movieid", request.getParameter("movieid") == null ? "" : transferString((String)request.getParameter("movieid"))); //  para9
					hash.put("hiderecovertime", request.getParameter("hidetime") == null ? "" : transferString((String)request.getParameter("hidetime"))); //  para7
				//	hash.put("mediatype",  request.getParameter("mediatype") == null ? "" : transferString((String)request.getParameter("mediatype"))); //??? 
				//	hash.put("filetype",  request.getParameter("filetype") == null ? "" : transferString((String)request.getParameter("filetype"))); // ???

					System.out.println(" ExtraringInfo -------------- > albumid - "+(String)hash.get("albumid")+" movieid - "+(String)hash.get("movieid")+" alias1 - "+(String)hash.get("alias1")+" alias2 - "+(String)hash.get("alias2")+" hiderecovertime - "+(String)hash.get("hiderecovertime")+" "); // Remove this

					rList = colorRing.updateExtraRingInformation(hash);
					sysInfo.add(sysTime + operName + "Extra ringtone information modified successfully!");
					String msg = JspUtil.generateResultList(rList);
					if(!msg.equals("")){
					   msg = msg.replace('\n',' ');
					   throw new Exception(msg);
            }
              }
            }

            String Pos = "";
        	String ringlibcode = "";
			if(ringlibid.length()>0){
        	Hashtable hLib=  sysring.getRingLibraryNode(ringlibid);
        	if(hLib!=null && hLib.size()>0){
        	Pos = Pos + (String)hLib.get("ringliblabel");
        	ringlibcode = ringlibcode + (String)hLib.get("ringlibcode");

        }
            }
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
	  var dailyPrice="0";
     <%if(useeditringid.equalsIgnoreCase("1")){%>
             if (trim(fm.ringid.value) != '') {
            var tmp2 = trim(fm.ringid.value);
      if (!checkstring('0123456789',tmp2) || tmp2 == '') {
         alert("Ringtone ID must be digital number");
         fm.ringid.focus();
         return;
         }
      }
   <%}%>

      if (trim(fm.ringlibname.value) == '') {
         alert("Please select a ringtone library!");//
         return;
      }
      if (trim(fm.filename.value) == '') {
         alert("Please select a ringtone file first!");//请先选择铃音文件
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringname.value) == '') {
         alert("Please enter a ringtone name!");//请输入Ringtone name
         fm.ringname.focus();
         return;
      }
      if (!CheckInputStr(fm.ringname,'ringtone name')){
         fm.ringname.focus();
         return  ;
      }
      if (trim(fm.ringpell.value) == '') {
         alert("Please enter the spelling or ab. of the ringtone name.");//请输入铃音拼音
         fm.ringpell.focus();
         return;
      }
      if(!CheckInputChar1(fm.ringpell,'Spelling of ringtone')){
      	fm.ringpell.focus();
      	return;
      }
      if(trim(fm.ringauthor.value)==''){
      	alert("Please enter the name of Singer!");
      	fm.ringauthor.focus();
      	return;
      }
      if (!CheckInputStr(fm.ringauthor,'name of Singer!')){
         fm.ringauthor.focus();
         return  ;
      }
      <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.ringname.value,40)){
            alert("The ringtone name should not exceed 40 bytes!");
            fm.ringname.focus();
            return;
          }
          if(!checkUTFLength(fm.ringpell.value,20)){
            alert("The ringspell should not exceed 20 bytes!");
            fm.ringpell.focus();
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
         alert("Please input provider name");
         fm.ringsource.focus();
         return;
      }
      if (!CheckInputStr(fm.ringsource,'Provider')){
        fm.ringsource.focus();
        return  ;
      }
    <%}%>
      var tmp = trim(fm.price.value);
      if (!checkstring('0123456789',tmp) || tmp == '') {
         alert("The price must be digital number!");//铃音价格只能为数字
         fm.price.focus();
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
                      alert("User validate must be digital number!");
                      fm.uservalidday.focus();
                      return ;
                    }
                    //end
                   <%}%>
      var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert("Please enter an expiration date");//请输入铃音有效期
          fm.validdate.focus();
          return ;
      }
      if(!checkDate2(validdate)){
          alert("The copyright expiration date entered is incorrect. Please re-enter!");//铃音有效期输入不正确,请重新输入
          fm.validdate.focus();
          return;
      }
      if(checktrue2(validdate)){
          alert("The copyright expiration date can not be earlier than current date,please re-enter!");
          fm.validdate.focus();
          return ;
      }

      if(checktrueyear(validdate,'<%=expireTime%>')){
         alert("The copyright expiration date can not be latter than <%=expireTime%>, please re-enter!");
          fm.validdate.focus();
          return ;
      }
	  
 <%     if (sysfunction.get("2-66-0")== null ) { // ring additional information
	  %>
			 var hiderecoverdate = trim(fm.hidetime.value);
			 // if(hiderecoverdate==''){
			//	  alert('Please enter hide or recover date');//请输入铃音有效期
			//	  fm.hidetime.focus();
			//	  return ;
			 // }
			 if(hiderecoverdate != ''){
			  if(!checkDate2(hiderecoverdate)){
				  alert('The hide or recover date entered is incorrect. Please re-enter!');//铃音有效期输入不正确,请重新输入
				  fm.hidetime.focus();
				  return ;
			  }
			  if(checktrue2(hiderecoverdate)){
				  alert('The hide or recover date cannot be earlier than the current time. Please re-enter!');//铃音有效期不能低于当前时间,请重新输入
				  fm.hidetime.focus();
				  return ;
			  }

			  if(checktrueyear(hiderecoverdate,'<%=expireTime%>')){
				 alert("The hide or recover date cannot be latter than '<%=expireTime%>'. Please re-enter!");
				  fm.hidetime.focus();
				  return ;
			  }  
			 }

			  if(fm.mediatype.value == ''){
				alert("Please enter ringtone mediatype in digits!");
				return;
			  }

			  if(fm.filetype.value == ''){
				alert("Please enter ringtone filetype in digits!");
          return ;
      }

			 // if(fm.album.value == ''){
			//	alert("Please choose album!");
			//	return;
			 // }

			 // if(fm.movie.value == ''){
			//	alert("Please choose movie!");
		//		return;
		//	  }
	  
	  <% } if(ringablealias1.equalsIgnoreCase("1")){
          %>
		// if(fm.ringalias1.value == ''){
		//	alert("Please enter ringtone alias1 !");
	//		return;
	//	  }
	  
     <% } if(ringablealias2.equalsIgnoreCase("1")){ %>
	//	if(fm.ringalias2.value == ''){
	//		alert("Please enter ringtone alias2 !");
	//		return;
	//	  }
     <% }
	 if(isSupportMultiplePrice==1) { 
		 %>
       dailyPrice=trim(fm.price2.value);
      if (!checkstring('0123456789',dailyPrice) || dailyPrice == '') {
         alert("The daily price must be digital number!");//铃音价格只能为数字
         fm.price2.focus();
         return;
      }
	  <%
	 }
	  %>

      fm.ringlibcode.disabled = false;
      fm.filename.disabled = false;
      fm.price.disabled = false;
      fm.op.value = 'upload';
      fm.submit();
   }

   function selectFile () {
      var fm = document.inputForm;
      var uploadURL = 'spupload.jsp?ringlibid=' + fm.ringlibid.value;
      uploadRing = window.open(uploadURL,'upload','width=400, height=230');
   }

   function selectLib () {
      var fm = document.inputForm;
      var lib = fm.ringlibid.value;
      fm.price.disabled = false;
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.ringfile.value = name;
      fm.filename.value = label;
      fm.ringname.value = label.substring(0,label.length - 4);
   }

   function queryInfo(type) {
     var result =  window.showModalDialog('../manager/albumMovie.jsp?type='+type,window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
		 var res = result.split("#");
// 		 alert(" res[] ------- "+res);
		 if(type ==1) {
		     document.inputForm.albumid.value=res[0];
			 document.inputForm.album.value=res[1];
		 } else {
		     document.inputForm.movieid.value=res[0];
	 	     document.inputForm.movie.value=res[1];
		 }
	 }
   }
</script>

<form name="inputForm" method="post" action="springUpload.jsp">
<input type="hidden" name="ringfile" value="">
<input type="hidden" name="ringlibid" value="<%= ringlibid %>">
<input type="hidden" name="op" value="">
<input type="hidden" name="albumid" value="">
<input type="hidden" name="movieid" value="">

<table width="346" border="0" align="center" cellpadding="0" cellspacing="0" class="table-style2">
	<tr>
    <td><img src="../manager/image/004.gif" width="346" height="15"></td>
  </tr>
  <tr >
    <td background="../manager/image/006.gif" width="346">
      <table width="100%" border="0" class="table-style2">
        <%if(useeditringid.equalsIgnoreCase("1")){%>
                <tr>
          <td align="right">Ringtone ID</td>
          <%if("1".equals(useeditringidprefix)){%>
          <td>
            <input type="text" name="ringid" value=<%=springidprefix%> maxlength="20" class="input-style1" >
          </td>
          <%}else{%>
          <td>
           <input type="text" name="ringid" value="" maxlength="20" class="input-style1" >
          </td>
          <%}%>
        </tr>
        <%}%>
        <tr>
          <td align="right">Ringtone  library</td>
          <td>
           <input type="text" name="ringlibname" value="<%= Pos %>" maxlength="40" class="input-style1" disabled>
          </td>
        </tr>
        <tr>
          <td align="right">Category code</td>
          <td><input type="text" name="ringlibcode" value="<%= ringlibcode %>" disabled class="input-style1" ></td>
        </tr>
        <tr>
          <td align="right">Filename</td>
          <td><input type="text" name="filename" value="<%=spmix.equals("spmix")?"mix.wav":""%>" disabled class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Ringtone name</td>
          <td><input type="text" name="ringname" value="" maxlength="40" class="input-style1"></td>
        </tr>
		<% if(ringablealias1.equalsIgnoreCase("1")) { %>
         <tr>
          <td align="right"><%=sLangLabel1+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
          <td ><input type="text" name="ringalias1"  value=""  maxlength="40" class="input-style1"></td>
        </tr>
		<% }
		 if(ringablealias2.equalsIgnoreCase("1")) { 
		%>
         <tr>
          <td  align="right"><%=sLangLabel2+" "+zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
          <td ><input type="text" name="ringalias2"  value=""  maxlength="40" class="input-style1"></td>
        </tr>
		<% }%>
         <tr>
          <td align="right">Spelling of ringtone</td>
          <td><input type="text" name="ringpell" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right">Singer name</td>
          <td><input type="text" name="ringauthor" value="" maxlength="40" class="input-style1"></td>
        </tr>
        <%if(useringsource.equals("1")){//modify by ge quanmin 2005-07-07%%>
         <tr>
           <td align="right"><%=ringsourcename%></td>
           <td><input type="text" name="ringsource" value="" maxlength="40" class="input-style1"></td>
         </tr>
         <%}%>
        <%if(isSupportMultiplePrice==1) { %>
        <tr>
          <td align="right">Ringtone daily price (<%=minorcurrency%>)</td>
          <td ><input type="text" name="price2"  value=""  maxlength="9" class="input-style1"></td>
   		</tr>
   		<%}%>
        <tr>
          <td align="right">Ringtone <%if(isSupportMultiplePrice==1) {%> monthly <%}%> price (<%=minorcurrency%>)</td>
          <td><input type="text" name="price" value="" maxlength="9" class="input-style1"></td>
        </tr>
        
        <%if(userday.equalsIgnoreCase("1")) {%>
      <tr>
         <td align="right">Validity(days)</td>
              <td><input type="text" name="uservalidday" value="0" maxlength="4" class="input-style1"></td>
       </tr>
          <%}%>
        <tr>
          <td align="right">Copyright Validity(yyyy.mm.dd)</td>
          <td><input type="text" name="validdate" value="" maxlength="10" class="input-style1"></td>
        </tr>
           <% String typeDisplay = "none";
         if("1".equals(suiyi))
           typeDisplay = "";
        %>
     <tr style="display:<%= typeDisplay %>">
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
		<%
		   if (sysfunction.get("2-66-0")== null ) { // ring additional information
		  %>
		<tr>
          <td  align="right">Media Type</td>
          <td ><input type="number" name="mediatype"  value=""  maxlength="10" class="input-style1"></td>
        </tr>
		<tr>
          <td align="right">File Type</td>
          <td ><input type="number" name="filetype"  value=""  maxlength="10" class="input-style1"></td>
        </tr>
		<tr>
          <td align="right">Album</td>
          <td ><input type="text" name="album"  value=""  maxlength="40" class="input-style1" readonly><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo(1)"></td>
        </tr>
		<tr>
          <td align="right">Movie</td>
          <td ><input type="text" name="movie"  value=""  maxlength="40" class="input-style1" readonly><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo(2)"></td>
        </tr>
		<tr>
          <td align="right">Language</td>
          <td ><input type="text" name="language"  value=""  maxlength="40" class="input-style1"></td>
        </tr>
		<tr>
          <td  align="right">Hide or Recover Time (yyyy.mm.dd)</td>
          <td ><input type="text" name="hidetime"  value=""  maxlength="10" class="input-style1"></td>
        </tr>
		<% }
		%>
        <tr>
         <tr>
          <td colspan="2">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <%if(!spmix.equals("spmix")){%>
                <td width="30%" align="right"><img src="../button/file.gif" width="45" height="19" onclick="javascript:selectFile()" onmouseover="this.style.cursor='hand'"> &nbsp;&nbsp;</td>
                <%}else{%><input type="hidden" name="spmix" value="spmix"><%}%>
                <td width="70%" align="center">&nbsp;&nbsp;&nbsp;&nbsp;<img src="../button/upload.gif" width="45" height="19" onclick="javascript:upload()" onmouseover="this.style.cursor='hand'"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td><img src="../manager/image/008.gif" width="345" height="15"></td>
  </tr>
  <tr>
  		<td><br/>
  		Note:"Spelling of ringtone" means the abbreviation of the ringtone name.It is used to sort ringtones in user's web for some non-alphabet language.<br/><br/>
  		For example,ringtone name is "love",you can input "l" or "lo" etc. as abbreviation.Then user can find it by letter "L".
  		</td>
  </tr>
</table>
</form>

<script language="javascript">
   document.inputForm.ringlibid.value = '<%= ringlibid %>';
   selectLib();
</script>
<%
        }
        else {
			errMsg = "Please log in to the system first!";
			alertflag=true;
        }if(alertflag==true){
%>
<script language="javascript">
   var errorMsg = '<%= operID!=null?errMsg:"Please log in to the system first!"%>';
   alert(errorMsg);
   parent.document.URL = 'enter.jsp';
</script>
<%  }
    }

    catch(Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occurred in uploading the ringtone!");//铃音上载过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading the ringtone!");//铃音上载过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="<%=spmix.equals("spmix")?"mixtune.jsp":"ringUpload.html"%>">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

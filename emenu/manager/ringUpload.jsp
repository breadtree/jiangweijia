<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="com.zte.jspsmart.upload.*" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@page import="zte.zxyw50.util.JCalendar"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Upload system ringtone</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
	//String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
   String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	//String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	//int ratio = Integer.parseInt(currencyratio);

	String expireTime = CrbtUtil.getConfig("expireTime","2099.12.31");

   String ifpretone = CrbtUtil.getConfig("ifpretone","0");
int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
String userday = CrbtUtil.getConfig("uservalidday","0");
 //add by gequanmin 2005-07-05
    String usedefaultringlib = CrbtUtil.getConfig("usedefaultringlib","1");
    String useringsource=CrbtUtil.getConfig("useringsource","0");
    String ringsourcename=CrbtUtil.getConfig("ringsourcename","ringtone producer");
    ringsourcename=transferString(ringsourcename);
    //add end
String useeditringid = CrbtUtil.getConfig("useeditringid","0");
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String ringablealias1 = CrbtUtil.getConfig("ringablealias1","0");
    String ringablealias2 = CrbtUtil.getConfig("ringablealias2","0");
	String sLangLabel1 = CrbtUtil.getConfig("langlabel1","Arabic");
	String sLangLabel2 = CrbtUtil.getConfig("langlabel2","French");
        String isSmart = CrbtUtil.getConfig("isSmart", "0");
  int isSupportMultiplePrice = zte.zxyw50.util.CrbtUtil.getConfig("issupportmultipleprice", 0);
    //modify by gequanmin 2005-07-05
    String ringlibid="";
     if("1".equals(usedefaultringlib)){
        ringlibid = request.getParameter("ringlibid") == null ? "503" : (String)request.getParameter("ringlibid");
    }else{
       ringlibid = request.getParameter("ringlibid") == null ? "" : (String)request.getParameter("ringlibid");
    }
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    try {
        manSysRing sysring = new manSysRing();
	    zxyw50.Purview purview = new zxyw50.Purview();
        ColorRing colorRing = new ColorRing();
	    Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
        ArrayList rList = null;
        SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
        sysTime = sysring.getSysTime() + "--";
        String op = request.getParameter("op") == null ? null : (String)request.getParameter("op");
        int isMCCI = zte.zxyw50.util.CrbtUtil.getConfig("isMCCI",0);
        int flag = 0;
        
        ywaccess yes=new ywaccess();
        String suiyi=yes.getPara(145);
        
        if (operID != null && purviewList.get("2-2") != null) {
            Vector vet = new Vector();
            Hashtable hash = new Hashtable();
            vet = sysring.getRingLib();
            if (op != null) {
                // 上传铃音
                SocketPortocol portocol = new SocketPortocol();
                int isfarsicalendar = zte.zxyw50.util.CrbtUtil.getConfig("isfarsicalendar", 0);
                String validdate = request.getParameter("validdate") == null ? null : transferString((String)request.getParameter("validdate"));
                if(isfarsicalendar == 1){
                	JCalendar cal = new JCalendar();
                	validdate = cal.persianToGregorian(validdate); 
            	}
                hash.put("usernumber",request.getParameter("ringlibcode") == null ? null : (String)request.getParameter("ringlibcode"));
                hash.put("ringtype","1");
                String ringlabel = request.getParameter("ringname") == null ? null : transferString((String)request.getParameter("ringname"));
                if(checkLen(ringlabel,40))
                	throw new Exception("The length of the ringtone name you entered has exceeded the limit. Please re-enter!");//您输入的Ringtone name长度超出限制,请重新输入!
                hash.put("ringlabel",ringlabel);
                hash.put("filename",request.getParameter("ringfile") == null ? null : transferString((String)request.getParameter("ringfile")));
                String auther = request.getParameter("ringauthor") == null ? null : transferString((String)request.getParameter("ringauthor"));
                if(checkLen(auther,40))
                	throw new Exception("The length of the singer name you entered has exceeded the limit. Please re-enter!");//您输入的Singer name长度超过限制,请重新输入!
                hash.put("auther",auther);
                String supplier = request.getParameter("ringsource") == null ? null : transferString((String)request.getParameter("ringsource"));
                if(checkLen(supplier,40))
                	throw new Exception("The length of the ringtone provider name you entered has exceeded the limit. Please re-enter!");//您输入的铃音提供商名称长度超出限制,请重新输入!
                hash.put("supplier",supplier);
	
		   if(isSmart.equals("0"))
                      {
                hash.put("price",request.getParameter("price") == null ? null : (String)request.getParameter("price"));
                      }
                    if(isSmart.equals("1"))
                      {
                           //Added by Neetika for Smart
			    hash.put("price","0000");
                      }
                
                hash.put("ringspell",request.getParameter("ringpell") == null ? null : transferString((String)request.getParameter("ringpell")));
                //begin add 用户有效期
                hash.put("uservalidday",request.getParameter("uservalidday") == null ? "0" : (String)request.getParameter("uservalidday"));
                //end
                hash.put("ringid",request.getParameter("ringid") == null ? "" : (String)request.getParameter("ringid"));
                hash.put("validdate",validdate);
                hash.put("opmode","1");
                hash.put("ipaddr",request.getRemoteAddr());
                hash.put("isfreewill",request.getParameter("isfreewill")== null?"00":("0"+(String)request.getParameter("isfreewill"))); // Added for MCCI- V5.14.01 .. Set tone requirement [By Srinivas]

                // add 07.09.27 4.10.1
                String preflag = "0";
                String prefilename = request.getParameter("preringfile")==null? "":request.getParameter("preringfile").trim();
                if(prefilename.length()>0)
                {
                preflag ="1";
                }
                hash.put("preflag", preflag);
                hash.put("prefilename", prefilename);
                hash.put("price2", request.getParameter("price2") == null ? "0" : (String)request.getParameter("price2"));
               //System.out.println("11hash="+hash);
               String resRingID = sysring.ringUpload(pool,hash);
	         if( (isSmart.equals("1")) && (!resRingID.equals("")) )
				{
					sysring.procfee(resRingID,(String)request.getParameter("price"));
				}
                sysInfo.add(sysTime + operName + "System ringtone uploaded successfully!");//上传系统铃音成功
%>
<script language="javascript">
   alert('<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> uploaded successfully!');//铃音上传成功
</script>
<%
                // 准备写操作员日志
                HashMap map = new HashMap();
                map.put("OPERID",operID);
                map.put("OPERNAME",operName);
                map.put("OPERTYPE","202");
                map.put("RESULT","1");
                map.put("PARA1",ringlabel);
                map.put("PARA2",ringlibid);
                map.put("PARA3",auther);
                map.put("PARA4",validdate);
                map.put("PARA5",(String)request.getParameter("price"));
                map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                purview.writeLog(map);
			
				//Extra Ring Information
				if(ringablealias1.equalsIgnoreCase("1") || ringablealias2.equalsIgnoreCase("1") || sysfunction.get("2-66-0")== null ) {  
				     if(resRingID.equals("")) { 
				        throw new Exception("Error: Additional information could not be updated!");
			        }
					hash.put("extraringid",resRingID);
					hash.put("extraRingOpcode", "1"); // 1 - add - opCode
					hash.put("opflag", "3"); // opFlag
					hash.put("language", request.getParameter("lang") == null ? "" : transferString((String)request.getParameter("lang"))); // para1
					hash.put("alias1", request.getParameter("ringalias1") == null ? "" : transferString((String)request.getParameter("ringalias1"))); // para2
					hash.put("alias2", request.getParameter("ringalias2") == null ? "" : transferString((String)request.getParameter("ringalias2"))); // para3
					hash.put("albumid", request.getParameter("albumid") == null ? "" : transferString((String)request.getParameter("albumid"))); //  para8
					hash.put("movieid", request.getParameter("movieid") == null ? "" : transferString((String)request.getParameter("movieid"))); //  para9
					hash.put("hiderecovertime", request.getParameter("hidetime") == null ? "" : transferString((String)request.getParameter("hidetime"))); //  para7
					hash.put("mediatype",  request.getParameter("mediatype") == null ? "" : transferString((String)request.getParameter("mediatype"))); //??? 
					hash.put("filetype",  request.getParameter("filetype") == null ? "" : transferString((String)request.getParameter("filetype"))); // ???

					
					System.out.println(" ExtraringInfo -------------- > albumid - "+(String)hash.get("albumid")+" movieid - "+(String)hash.get("movieid")+" alias1 - "+(String)hash.get("alias1")+" alias2 - "+(String)hash.get("alias2")+" mediatype - "+(String)hash.get("mediatype")+" filetype - "+(String)hash.get("filetype")+" hiderecovertime - "+(String)hash.get("hiderecovertime")+" "); // Remove this

					rList = colorRing.updateExtraRingInformation(hash);
					sysInfo.add(sysTime + operName + "Extra ringtone information modified successfully!");
					String msg = JspUtil.generateResultList(rList);
					if(!msg.equals("")){
					   msg = msg.replace('\n',' ');
					   throw new Exception(msg);
					}
            }
            }
            //modify by gequanmin 2005-07-05
            String Pos="";
            String ringlibcode="";
            if("1".equals(usedefaultringlib)){
               Pos= "Default " +zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")+" library";
               ringlibcode = "503";
            }
            if((ringlibid!=null) &&(!ringlibid.equals(""))){
            Hashtable hLib=  sysring.getRingLibraryNode(ringlibid);
            if(hLib!=null && hLib.size()>0){
                Pos = (String)hLib.get("ringliblabel");
                ringlibcode = (String)hLib.get("ringlibcode");
            }
         }
%>
<script language="javascript">
   function upload () {
      var fm = document.inputForm;
           <%if(useeditringid.equalsIgnoreCase("1")){%>
             if (trim(fm.ringid.value) != '') {
            var tmp2 = trim(fm.ringid.value);
      if (!checkstring('0123456789',tmp2) || tmp2 == '') {
         alert('<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID can only be a digital number!');
         fm.ringid.focus();
         return;
         }
      }
   <%}%>
      if (trim(fm.filename.value) == '') {
         alert('Please select a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> file first!');//请先选择铃音文件
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringlibid.value) == '') {
         alert('Please select a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library!');
         return;
      }
      if (trim(fm.ringname.value) == '') {
         alert('Please enter a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name!');//请输入Ringtone name
         fm.ringname.focus();
         return;
      }
      if (!CheckInputStr(fm.ringname,'<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name')){
         fm.ringname.focus();
         return;
      }
      if (trim(fm.ringpell.value) == '') {
         alert('Please enter the spelling of a <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name');//请输入铃音拼音
         fm.ringpell.focus();
         return;
      }
      if(!CheckInputChar1(fm.ringpell,"Ringtong name's spelling")){
      	fm.ringpell.focus();
      	return;
      }
      if (trim(fm.ringauthor.value) == '') {
         alert('Please enter an <%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name');//请输入Singer name
         fm.ringauthor.focus();
         return;
      }
      if (!CheckInputStr(fm.ringauthor,'<%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name')){
         fm.ringauthor.focus();
         return;
      }
       <%
        if(ifuseutf8 == 1){
          %>
          if(!checkUTFLength(fm.ringname.value,40)){
            alert("The ringtone name should not exceed 40 bytes! ");
            fm.ringname.focus();
            return;
          }
          if(!checkUTFLength(fm.ringpell.value,20)){
            alert("The Spelling should not exceed 20 bytes! ");
            fm.ringpell.focus();
            return;
          }
          if(!checkUTFLength(fm.ringauthor.value,40)){
            alert("The Singer name should not exceed 40 bytes! ");
            fm.ringauthor.focus();
            return;
          }
        <%}%>
      //modify by ge quanmin 2005-07-07
      <%if(useringsource.equals("1")){%>
       if (trim(fm.ringsource.value) == '') {
         alert('Please input the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> producer name!');//请输入ringtone producer名称!
         fm.ringsource.focus();
         return;
      }
      if (!CheckInputStr(fm.ringsource,'<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> producer')){
         fm.ringsource.focus();
         return;
      }
     <%}%>
      var tmp = trim(fm.price.value);
      if ( tmp == '') {
         alert('Please enter a price');//请输入铃音价格
         fm.price.focus();
         return ;
      }
      if (!checkstring('0123456789',tmp)) {
         alert('<%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> price can only be a digital number!');//铃音价格只能为数字
         fm.price.focus();
         return ;
      }
     <%//begin add 用户有效期
        if(userday.equalsIgnoreCase("1")){
          %>
          //begin add 用户有效期
          var tmp1 = trim(fm.uservalidday.value);
          if ( tmp1 == '') {
            alert('Please enter an expiration date!');
            fm.uservalidday.focus();
            return ;
          }
          if (!checkstring('0123456789',tmp1)) {
            alert('The <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> subscriber validity of period can only be a digital number!');//铃音用户有效期只能为数字
            fm.uservalidday.focus();
            return ;
          }
      //end
      <%}%>
      var validdate = trim(fm.validdate.value);
      if(validdate==''){
          alert('Please enter an expiration date');//请输入铃音有效期
          fm.validdate.focus();
          return ;
      }
      if(!checkDate2(validdate)){
          alert('The expiration date entered is incorrect. Please re-enter!');//铃音有效期输入不正确,请重新输入
          fm.validdate.focus();
          return ;
      }
      /*if(checktrue2(validdate)){
          alert('The expiration date cannot be earlier than the current time. Please re-enter!');//铃音有效期不能低于当前时间,请重新输入
          fm.validdate.focus();
          return ;
      }*/


      if(checktrueyear(validdate,'<%=expireTime%>')){
      	 alert('The expiration date cannot be later than <%=expireTime%>,please re-enter!');
          fm.validdate.focus();
          return ;
      }

 <%     if (sysfunction.get("2-66-0")== null ) { // ring additional information. TO-DO confirm which all required field are manadatory or optional and uncheck below code acccordingly.
	  %>
			 var hiderecoverdate = trim(fm.hidetime.value);
			//  if(hiderecoverdate==''){
			//	  alert('Please enter hide or recover date'); 
			//	  fm.hidetime.focus();
			//	  return ;
			//  }
			if(hiderecoverdate != ''){
			  if(!checkDate2(hiderecoverdate)){
				  alert('The  hide or recover  date entered is incorrect. Please re-enter!'); 
				  fm.hidetime.focus();
				  return ;
			  }
			  if(checktrue2(hiderecoverdate)){
				  alert('The  hide or recover  date cannot be earlier than the current time. Please re-enter!'); 
				  fm.hidetime.focus();
				  return ;
			  }

			  if(checktrueyear(hiderecoverdate,'<%=expireTime%>')){
				 alert("The  hide or recover  date cannot be latter than '<%=expireTime%>'. Please re-enter!");
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
				return;
			  }
			 if (fm.lang.value != '' ){
	             if(!CheckInputStr(fm.lang,'language')){
                    fm.lang.focus();
                    return;
                  }	
	          }

			//  if(fm.album.value == ''){
			//	alert("Please choose album!");
			//	return;
			//  }

			//  if(fm.movie.value == ''){
			//	alert("Please choose movie!");
			//	return;
			//  }
	  
	  <% } if(ringablealias1.equalsIgnoreCase("1")){
          %>
		// if(fm.ringalias1.value == ''){
		//	alert("Please enter ringtone alias1 !");
		//	return;
		 // }
	  
     <% } if(ringablealias2.equalsIgnoreCase("1")){ %>
		//if(fm.ringalias2.value == ''){
		//	alert("Please enter ringtone alias2 !");
	//		return;
		//  }
     <% }%> 

      fm.ringlibcode.disabled = false;
      fm.filename.disabled = false;
      fm.price.disabled = false;
      fm.price2.disabled = false;
      fm.op.value = 'upload';
      fm.submit();
   }

   function selectFile () {
      var fm = document.inputForm;
      var uploadURL = 'upload.jsp?ringlibid=' + fm.ringlibid.value;
      uploadRing = window.open(uploadURL,'upload','width=400, height=230');
   }

  function selectPreFile () {
      var fm = document.inputForm;
      var uploadURL = 'uploadPreTone.jsp';
      uploadRing = window.open(uploadURL,'uploadpre','width=400, height=230');
   }


   function selectLib () {
      var fm = document.inputForm;
      var lib = fm.ringlibid.value;
      if (lib == 501 || lib == 502 || lib == 503) {
         fm.price.value = '0';
         fm.price2.value = '0';
         fm.price.disabled = true;
         fm.price2.disabled = true;
      }
      else {
         fm.price.disabled = false;
         fm.price2.disabled = false;
      }
   }

   function getRingName (name, label) {
      var fm = document.inputForm;
      fm.ringfile.value = name;
      fm.filename.value = label;
      fm.ringname.value = label.substring(0,label.length - 4);
   }

    function getPreRingName (name, label) {
      var fm = document.inputForm;
      fm.preringfile.value = name;
      fm.prefilename.value = label;
   }

     function queryInfo(type) {
      var result =  window.showModalDialog('albumMovie.jsp?type='+type,window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
 		 var res = result.split("#");
 //		 alert(" res[] ------- "+res);
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

<form name="inputForm" method="post" action="ringUpload.jsp">
<input type="hidden" name="ringfile" value="">
<input type="hidden" name="preringfile" value="">
<input type="hidden" name="ringlibid" value="<%= ringlibid %>">
<input type="hidden" name="op" value="">
<input type="hidden" name="albumid" value="">
<input type="hidden" name="movieid" value="">

  <table width="346"  border="0" align="center" class="table-style2" cellpadding="0" cellspacing="0">
    <tr>
    <td><img src="image/004.gif" width="346" height="15"></td>
  </tr>
  <tr >
    <td background="image/006.gif">
    <table width="340" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
    <td>
      <table  border="0" align="center" class="table-style2">
                <%if(useeditringid.equalsIgnoreCase("1")){%>
                <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> ID</td>
          <td>
           <input type="text" name="ringid" value="" maxlength="20" class="input-style1" >
          </td>
        </tr>
        <%}%>
       <tr valign="top">
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> library</td>
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
          <td><input type="text" name="filename" value="" disabled class="input-style1"></td>
        </tr>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
          <td><input type="text" name="ringname" value="" maxlength="40" class="input-style1"></td>
        </tr>
       
		<% if(ringablealias1.equalsIgnoreCase("1")) { %>
		 <tr>
          <td align="right"><%=sLangLabel1%> <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
          <td ><input type="text" name="ringalias1"  value=""  maxlength="40" class="input-style1"></td>
        </tr>
		<% }
		 if(ringablealias2.equalsIgnoreCase("1")) { 
		%>
		<tr>
          <td  align="right"><%=sLangLabel2%> <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> name</td>
          <td ><input type="text" name="ringalias2"  value=""  maxlength="40" class="input-style1"></td>
        </tr>
		<% }%>
         <tr>
          <td align="right">Spelling of <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
          <td><input type="text" name="ringpell" value="" maxlength="20" class="input-style1"></td>
        </tr>
        <tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("authorname","Singer")%> name</td>
          <td><input type="text" name="ringauthor" value="" maxlength="40" class="input-style1"></td>
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

        
		<tr <%if(isSupportMultiplePrice==1) { %>style="display:block" <%}else{%>style="display:none" <%}%>>
		    <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> daily price(<%=minorcurrency%>)</td>
			<td><input type="text" name="price2" value="" maxlength="9" class="input-style1" /></td>
		</tr>
	<tr>
          <td align="right"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> <% if(isSupportMultiplePrice==1) { %>monthly <%}%> price (<%=minorcurrency%>)</td>
          <td><input type="text" name="price" value="" maxlength="9" class="input-style1"></td>
        </tr>
        
        <%//begin add 用户有效期
        if(userday.equalsIgnoreCase("1")){
        %>
        <tr>
          <td align="right">Period of Validity(day)</td>
          <td><input type="text" name="uservalidday" value="0" maxlength="4" class="input-style1"></td>
        </tr>
        <%}//end%>
        <tr>
          <td align="right">Copyright Period of Validity(yyyy.mm.dd)</td>
          <td><input type="text" name="validdate" value="" maxlength="10" class="input-style1"></td>
        </tr>

        <%
          String pretoneDisplay = "none";
        if(ifpretone.equals("1"))
           pretoneDisplay="";
        %>
        <tr style="display:<%= pretoneDisplay %>">
          <td align="right">Pretone Filename</td>
          <td><input type="text" name="prefilename" value="" disabled class="input-style1"></td>
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
          <td  align="right">Hide or Recover Time (yyyy.mm.dd)</td>
          <td ><input type="text" name="hidetime"  value=""  maxlength="10" class="input-style1"></td>
        </tr>
		<tr>
		    <td align="right">Language</td>
			<td><input type="text" name="lang" value="" maxlength="40" class="input-style1" /></td>
		</tr>
		<% } 
        
        String dispIsfreewill = "none";
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
          <td colspan="3">
            <table border="0" width="100%" class="table-style2">
              <tr>
                <td align="right"><img src="button/file.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectFile()"> &nbsp;&nbsp;</td>

                <td  align="center" style="display:<%= pretoneDisplay %>"><img src="button/pretonefile.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:selectPreFile()"> &nbsp;&nbsp;</td>

                <td >&nbsp;&nbsp;&nbsp;&nbsp;<img src="button/upload.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:upload()"></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td><img src="image/005.gif" width="346" height="15"></td>
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

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//Please log in to the system
                    parent.document.URL = 'enter.jsp';
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
        sysInfo.add(sysTime + operName + "Exception occurred in uploading the ringtone!");//铃音上载过程出现异常
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurred in uploading the ringtone!");//铃音上载过程出现错误
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp" target="_parent">
<input type="hidden" name="historyURL" value="ringUpload.html">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

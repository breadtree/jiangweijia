<%@ page import="zte.zxyw50.user.service.UserDomainService" %>
<%@ page import="com.zte.tao.constant.SessionConstant" %>
<%@ page import="zte.zxyw50.UserAccount" %>
<%@ page import="zte.zxyw50.user.domain.UserStatusDO" %>
<%@include file="../base/i18n.jsp"%>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
int isDiyRing = zte.zxyw50.util.CrbtUtil.getConfig("isDiyRing",0);
String ringdisplay = zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay","Ringtone");

UserAccount user = (UserAccount)session.getAttribute(SessionConstant.USER_INFO);
UserStatusDO status = (UserStatusDO)session.getAttribute("USERSTATUS");
String craccount  = user.getUserID();
long allindex  = user.getAllindex();
ArrayList aList= new ArrayList();

	try{
		 UserDomainService userdomain = new UserDomainService();
		 aList = userdomain.getPernalring(craccount,allindex);
		//System.out.println("----alist****"+aList);
	  }catch(Exception e){
		System.out.println("Error occurred during DIY Ringtone Upload "+e.getMessage());
	}

%>
<html>
<head>
<link href="../style.css" type="text/css" rel="stylesheet">
<link rel="stylesheet" href="css/diyRecorder.css" type="text/css" >
<link rel="stylesheet" href="css/slider.css" type="text/css" >
<script src="js/jquery-min.js" language="javascript"	type="text/javascript"> </script>
<script src="js/jquery-ui.min.js" language="javascript"	type="text/javascript"> </script>
<script src="js/diyRecord.js" language="javascript" type="text/javascript"></script>
<script src="../base/JsFun.js" language="javascript" type="text/javascript"></script>
</head>
<body>
<div class="gray_box width640">
	 <div class="tr"><span class="tl"><span class="table_title"><i18n:message key="UserMSG0015400" /></span></span></div>
	 	<div class="m">
	    	<div class="content">
	    		<!-- h3><i18n:message key="UserMSG0015400" /></h3-->
	    		<!-- start  -->
	    		<center>
	    		<div class="mainpanel">
					<!-- Preview player UI-->
					<div id="diy_player">	
						<div id="recSongSlider"></div>
						<div id="songTime"><span id="cur_time_rec">00:00</span>/<span id="total_time_rec">00:00</span></div>
						<table cellpadding="0" cellspacing="0"  border="0" id="button_container_prev" width="400">
							<tr>
								<td width="52" class="button play_prev disabled" title="<i18n:message key="UserMSG0015401" />"></td>
								<td width="52" class="button stop_prev disabled" title="<i18n:message key="UserMSG0015402" />"></td>
								<td width="52" class="button rec_prev" title="<i18n:message key="UserMSG0015403" />"></td>
								<td width="107" class="speaker"><!-- space for speaker and microphone --></td>
								<td width="135" class="mini_sliders" valign="top">
									<div id="volSlider"></div>
							</td>
								
							</tr>
						</table>
						<div id="message_prev" class="msg_txt_prev" >
							<!-- <h3>Recording Success!</h3>
							If you like it, you can now upload it or try again if you dislike it. -->
						</div>
						<table cellpadding="0" cellspacing="0" border="0" id="button_container" width="415" style="padding:0;margin:0">
							<tr>
								<td>&nbsp;</td>
								<td class="button retry_btn disabled" title="<i18n:message key="UserMSG0015404" />"></td>
								<td width="12"></td>
								<td class="button upload_btn disabled" title="<i18n:message key="UserMSG0015405" />"></td>
								<td>&nbsp;</td>
							</tr>
						</table>
					</div>
	    		</div>
	    		</center>
	    		<div id="userInputMask" style="display:none"></div>
	    		<div id="userInput">
	    			<table cellpadding="5" cellspacing="5" border="0">
	    				<tr>
	    					<td colspan="2" id="errMsg" style="display:none"></td>
	    				</tr>
	    				<tr>
	    					<td colspan="2"><i18n:message key="UserMSG0015406" /></td>
	    				</tr>
	    				<tr>
	    					<td>*<i18n:message key="UserMSG0015407" />:&nbsp;</td>
	    					<td><input type="text" maxlength="4" name="code" id="smscode" onkeypress="$('#errMsg').text('')"></td>
	    				</tr>
	    				<tr>
	    					<td colspan="2"><center><button class="submitBtn" title="<i18n:message key="UserMSG0015408" />" onclick="proceedUpload()"><span><i18n:message key="UserMSG0015409" /></span></button>&nbsp;<button class="submitBtn" title="<i18n:message key="UserMSG0059917" />" onclick="hideUserInput()"><span><i18n:message key="UserMSG0059917" /></span></button></center></td>
	    				</tr>
	    			</table>
	    			
	    				
	    		</div>
	    		<!-- ends -->
	    		
	    		<!--[if IE]>
				<OBJECT classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" name="diyRec"
					WIDTH = 1 HEIGHT = 1  codebase="http://java.sun.com/update/1.5.0/jinstall-1_5_0-windows-i586.cab#Version=1,5,0,0">
					<PARAM NAME = CODE VALUE = "com.zte.karaoke.client.DIYRecorder" >
					<PARAM NAME = CODEBASE VALUE = "." >
					<PARAM NAME = ARCHIVE VALUE = "kar.jar,karlib.jar" >
					<PARAM NAME="type" VALUE="application/x-java-applet;version=1.5">
					<PARAM NAME="MAYSCRIPT" VALUE="true">
					<COMMENT>
					<EMBED type="application/x-java-applet;version=1.5" java_CODE = "com.zte.karaoke.client.DIYRecorder" 
					CODEBASE = "." WIDTH = 1 HEIGHT = 1  java_ARCHIVE="kar.jar,karlib.jar" 
					id="diyRec" mayscript="mayscript"  pluginspage="http://java.sun.com/products/plugin/index.html#download">
					<NOEMBED>No Java Support</NOEMBED>
					</EMBED>
					</COMMENT>
				</OBJECT>
		<![endif]-->
		<![if !IE]>
				<APPLET
			        CODEBASE = "."
			        ARCHIVE = "kar.jar,karlib.jar"
			        CODE = "com.zte.karaoke.client.DIYRecorder.class" 
			        NAME = "diyRec"
			        ID="diyRec"
			        WIDTH = 1  HEIGHT = 1
			        ALIGN = alignment
			        VSPACE = 0  HSPACE = 0  >
    			<PARAM NAME = "MAYSCRIPT" VALUE = "mayscript">
    			<PARAM NAME = "type" VALUE = "application/x-java-applet;version=1.5">

			    </APPLET>
				
		<![endif]>
		
		<script>
			function uploadConfirm(){
				var ret = confirm('<i18n:message key="UserMSG0046616" />\n\n<i18n:message key="UserMSG0046617" />');
				return ret;
			}
			
			function uploadRecResult(result,code){
		      if(result!=null){
		          if(code=='1'){
		              alert("<i18n:message key='UserMSG0046609' />");
		
		          }else if(code == '2'){
		              alert('<%= getArgMsg(request,"UserMSG0046610","1",ringdisplay)%>');
		          }else{
                      alert(result);
		          }
		       }
		       else{
		    	   alert("<i18n:message key='UserMSG0015431' />");
		       }
		       hideUserInput();
		     }
		     
		     function showUserInput(){
			 	$("#userInputMask").show();
			    $("#userInput").fadeIn();
			}
			
			function hideUserInput(){
			    $("#userInput").fadeOut("fast",function(){$("#userInputMask").hide()});
			}
		     
		     
			$(function(){
				$('.submitBtn').hover(
					// mouseover
					function(){ $(this).addClass('submitBtnHover'); },
					
					// mouseout
					function(){ $(this).removeClass('submitBtnHover'); }
				);	
			
				
			});	
			
   var   ringdisplay = "<%=  ringdisplay  %>";
   function proceedUpload(){
	//hideUserInput();
	var code = $.trim($('#smscode').val());
	if(code == ""){
		showErr("<i18n:message key='UserMSG0046619' />");
		return;
	}
	if(!checkstring("0123456789",code)){
    	  showErr("<i18n:message key='UserMSG0046620' />");
          return;
    }
    
    var codeList = "<%=aList%>";
    codeList=eval(codeList.replace(/=/g,":")); //convert codeList to an associative array 
    
    for(i=0;i<codeList.length;i++){
    	if(codeList[i].code==code){
    		showErr("<i18n:message key='UserMSG0046621' />");
    		return;
    	}
    }
    
	getMyApp("diyRec").setCode(code);
	getMyApp("diyRec").recFinish();
	}
	
	function showErr(msg){
		$("#errMsg").css("color","red").text(msg).show();
		$('#smscode').focus();
	}

			
		</script>
	    		<center>
	    			<button class="submitBtn" onclick="javascript:history.back()"><span><i18n:message key="UserMSG0059913" /></span></button>
	    		</center>
	    	</div>
        </div>
     <div class="br"><span class="bl"></span></div>
   </div>
</body>
</html>

<%@include file="../base/i18n.jsp"%>
<%@ include file="../pubfun/JavaFun.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><i18n:message key="UserMSG0015410" /></title>
		<meta name="author" content="Irshad" />
	
<%
	int isKaraokeMusicRecord = zte.zxyw50.util.CrbtUtil.getConfig("isKaraokeMusicRecord",0);
	String ringdisplay = zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay","Ringtone");
	
	if(isKaraokeMusicRecord != 1){%>
		<script>
			alert('<i18n:message key="UserMSG0015411" />');
		</script>
		</head>
	<%}else{%>
	<!--  Main page show here -->
		<script src="js/jquery-min.js" language="javascript"	type="text/javascript"> </script>
		<script src="js/jquery-ui.min.js" language="javascript"	type="text/javascript"> </script>
		
		<script src="js/script.js" language="javascript" type="text/javascript"></script>
		<script src="js/record.js" language="javascript" type="text/javascript"></script>
		<script src="js/preview.js" language="javascript" type="text/javascript"></script>
		<script type="text/javascript" src="js/jquery.jscrollpane.min.js"></script>
		<script type="text/javascript" src="js/jquery.mousewheel.js"></script>
		
		<!-- styles needed by jScrollPane -->
		<link type="text/css" href="css/jquery.jscrollpane.css" rel="stylesheet" media="all" />
		<link rel="stylesheet" href="css/karplayer.css" type="text/css" >
		<link rel="stylesheet" href="css/slider.css" type="text/css" >
	</head>
	<body>
		<!-- div id="preloaderCurtain"><div id="preloaderProgress"></div></div-->
		<table id="table_main" width="629" height="437" border="0" cellpadding="0" cellspacing="0" align="center">
			<tr>
				<td colspan="2" class="steps">
					<ul>
						<li id="first"><i18n:message key="UserMSG0015412" /></li>
						<li id="second" class="small inactive"><i18n:message key="UserMSG0015413" /></li>
						<li id="third" class="inactive"><i18n:message key="UserMSG0015414" /></li>
					</ul>
				</td>
			</tr>
			<tr>
				<td rowspan="2" class="leftpanel" valign="top">
				  	<div id="songList">
				  	 <div class="header">
					   <table cellpadding="0" cellspacing="0" border=0>
						<tr>
							<th width="80%" align="left"><i18n:message key="UserMSG0015415" /></th>
							<th><i18n:message key="UserMSG0015416" /></th>
						</tr>
						</table>
					  </div>
					 <div class="scroll-pane">
						<%pageContext.include("songList.jsp"); %>
					</div>
					</div>
				</td>
				<td class="rightpanel" id="rightpanel">
					<!-- Preview player UI-->
					<div id="prev_player" style="display:none">	
						<div id="prevSongSlider"></div>
						<div id="songTime"><span id="cur_time_prev">00:00</span>/<span id="total_time_prev">00:00</span></div>
						<table cellpadding="0" cellspacing="0"  border="0" id="button_container_prev" width="400">
							<tr>
								<td width="52" class="button play_prev" title="<i18n:message key="UserMSG0015417" />"></td>
								<td width="52" class="button pause" title="<i18n:message key="UserMSG0015418" />"></td>
								<td width="52" class="button stop_prev" title="<i18n:message key="UserMSG0015419" />"></td>
								<td width="107"><!-- space for speaker and microphone --></td>
								<td width="135" class="mini_sliders" valign="top">
									<div id="volSlider"></div>
							</td>
								
							</tr>
						</table>
						<div id="message_prev" class="msg_txt_prev">
							<h3><i18n:message key="UserMSG0015420" /></h3>
							<i18n:message key="UserMSG0015421" />
						</div>
						<table cellpadding="0" cellspacing="0" border="0" id="button_container" width="415" style="padding:0;margin:0">
							<tr>
								<td>&nbsp;</td>
								<td class="button retry_btn" title="<i18n:message key="UserMSG0015422" />"></td>
								<td width="12"></td>
								<td class="button upload_btn" title="<i18n:message key="UserMSG0015423" />"></td>
								<td>&nbsp;</td>
							</tr>
						</table>
						<div class="stat_txt" id="prev_status" style="display:none"><img src="images/ajax-loader.gif" border="0" style="float:left"/>&nbsp;&nbsp;<i18n:message key="UserMSG0015444"/></div>
					</div>
					<!-- Preview UI ends here -->
					<div class="right">
						<div id="message" class="msg_txt"><img src="images/arrow.png" style="float:left">&nbsp;<i18n:message key="UserMSG0015424" />...</div>
						<div id="message1" class="msg_txt push" style="display:none;"></div>
						<div id="loading"><img src="images/ajax-loader.gif" border="0" style="float:left"/>&nbsp;&nbsp;<i18n:message key="UserMSG0015425" />...</div>
						<div class="stat_txt"><div id="status" style="display:none"><i18n:message key="UserMSG0015426" /></div> </div>
					</div>
				</td>
			</tr>
			<tr>
				<td class="player_console">
				  <div id="rec_player"  style="display:none">	
					<div id="songSlider">
					</div>
					<div id="songTime"><span id="cur_time">00:00</span>/<span id="total_time">00:00</span></div>
					<table cellpadding="0" cellspacing="0" id="button_container" width="415">
						<tr>
							<td class="button play" title="<i18n:message key="UserMSG0015427" />"></td>
							<td class="button stop disabled" title="<i18n:message key="UserMSG0015428" />"></td>
							<td class="button record" title="<i18n:message key="UserMSG0015429" />..."></td>
							<td width="35"><!-- space for speaker and microphone -->	</td>
							<td width="115" class="mini_sliders">
								<div id="bgVolSlider"></div>
								<div id="micVolSlider"></div>
							</td>
							<td class="button finish_btn disabled" title="<i18n:message key="UserMSG0015430" />"></td>
						</tr>
					</table>
					</div>
				</td>
			</tr>
		</table>
		
		<!--[if IE]>
			<OBJECT classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" name="karApp"
					WIDTH = 1 HEIGHT = 1  codebase="http://java.sun.com/update/1.5.0/jinstall-1_5_0-windows-i586.cab#Version=1,5,0,0">
					<PARAM NAME = CODE VALUE = "com.zte.karaoke.client.KaraokeMixer" >
					<PARAM NAME = CODEBASE VALUE = "." >
					<PARAM NAME = ARCHIVE VALUE = "kar.jar,karlib.jar" >
					<PARAM NAME="type" VALUE="application/x-java-applet;version=1.5">
					<PARAM NAME="MAYSCRIPT" VALUE="true">
					<COMMENT>
					<EMBED type="application/x-java-applet;version=1.5" java_CODE = "com.zte.karaoke.client.KaraokeMixer" 
					CODEBASE = "." WIDTH = 1 HEIGHT = 1  java_ARCHIVE="kar.jar,karlib.jar" 
					id="karApp" mayscript="mayscript"  pluginspage="http://java.sun.com/products/plugin/index.html#download">
					<NOEMBED>No Java Support</NOEMBED>
					</EMBED>
					</COMMENT>
				</OBJECT> 
		<![endif]-->
		<![if !IE]>
				<APPLET
			        CODEBASE = "."
			        ARCHIVE = "kar.jar,karlib.jar"
			        CODE = "com.zte.karaoke.client.KaraokeMixer.class" 
			        NAME = "karApp"
			        ID="karApp"
			        WIDTH = 1  HEIGHT = 1
			        ALIGN = alignment
			        VSPACE = 0  HSPACE = 0  >
    <PARAM NAME = "MAYSCRIPT" VALUE = "mayscript">
    <PARAM NAME = "type" VALUE = "application/x-java-applet;version=1.5">

    </APPLET>
				
		<![endif]>
		
		</body>
		
		<script>
			function uploadConfirm(){
				var ret = confirm('<i18n:message key="UserMSG0046616" />\n\n<i18n:message key="UserMSG0046617" />');
				return ret;
			}
			
			function uploadResult(result,code){
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
		       $('#prev_status').hide();
		     }
		     
		     
		     
		</script>
	
	<!-- main page ends -->
	<%}%>

/**
 * Preview Page Javascript Functionalities
 */

var isPrevPlaying = false;
var isPaused = false;

/* declare vars to hold elements*/
var $prevPlayBtn;
var $prevStopBtn;
var $pauseBtn;
var $uploadBtn;
var $retryBtn;

 /*
  Flow :
   Javascript to Applet
 */
 
$(function(){
	$prevPlayBtn = $('.play_prev','#prev_player');
	$prevStopBtn = $('.stop_prev','#prev_player');
	$pauseBtn = $('.pause','#prev_player');
	$retryBtn = $('.retry_btn','#prev_player');
	$uploadBtn =  $('.upload_btn','#prev_player');
	
	//$pauseBtn.hide();
	
	$prevPlayBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		
		if(isPrevPlaying){
			 return false;
		}
		else if(isPaused){
			getMyApp("karApp").resumeMixedTone();
		}
		else{
			getMyApp("karApp").playMixedTone();
			isPrevPlaying = true;
		}
		setPrevButtonStates('play');
	});
	
	$prevStopBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		getMyApp("karApp").stopMixedTone();
		isPrevPlaying = false;
		isPaused = false;
		setPrevButtonStates('stop');
		doStopMixedPlayBack();
	});
	
	$pauseBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		if(!isPrevPlaying){
			return false;
		}
		else{
			getMyApp("karApp").pauseMixedTone();
			isPrevPlaying = false;
			isPaused = true;
		}
		setPrevButtonStates('pause');
	});
	
	$retryBtn.click(function(){
		//if(confirm("<i18n:message key='UserMSG0015433' />")){
		if(confirm("Previous recorded data will be lost. Proceed?")){
		getMyApp("karApp").recordAgain();
		isPrevPlaying = false;
		isPlaying = false;
		isRecorded = false;
		hidePreviewUI();
		initRecorderUI();
		}
	});
	
	$uploadBtn.click(function(){
	if($(this).hasClass('disabled')) return false;
		if(uploadConfirm()){
			$('#prev_status').show();
			disableBtn($uploadBtn);
			isPrevPlaying = false;
			isPlaying = false;
			isRecorded = true;
			getMyApp("karApp").upload();
		}
	});
	
});


function doMixProgressChange(param){
	//showInStatus('Song Progress:'+param +"%");
	getMyApp("karApp").setMixedProgress(param);
}

function doMixVolChange(param){
	//showInStatus('Preview Volume:'+param +"%");
	getMyApp("karApp").setMixedVolume(param);
	
}


/*
Flow :
 Applet to Javascript 
 
*/

function doStopMixedPlayBack() {
	moveMixProgress(0);
	dispMixCurrTime("00:00");
}


function dispMixPlayTime(param) {
	$("#total_time_prev").html(param);
}

function dispMixCurrTime(param) {
	$("#cur_time_prev").html(param);
}

function moveMixProgress(param) {
	$("#prevSongSlider").slider( "option", "value", param );
}

/***util methods*/
function setPrevButtonStates(whichBtn){
	switch(whichBtn){
		case 'play':
			enableBtn($pauseBtn);
			enableBtn($prevStopBtn); 
			disableBtn($prevPlayBtn);
			break;
		case 'pause':
			enableBtn($prevStopBtn);
			enableBtn($prevPlayBtn);
			disableBtn($pauseBtn); 
			break;
		case 'stop':
			enableBtn($prevPlayBtn);
			disableBtn($prevStopBtn);
			disableBtn($pauseBtn);
			break;
		default:
			enableBtn($prevPlayBtn);
			disableBtn($prevStopBtn);
			disableBtn($pauseBtn);
			enableBtn($uploadBtn);
	}
}

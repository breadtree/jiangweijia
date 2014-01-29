/**
 * Record Page Javascript Functionalities 
 */

var isRecorded = false;
var isPlaying = false;

/* declare vars to hold elements*/
var $playBtn;
var $stopBtn;
var $recBtn;
var $finBtn;

 /*
  Flow :
   Javascript to Applet
 */
 
$(function(){
	$playBtn = $('.play','#rec_player');
	$stopBtn = $('.stop','#rec_player');
	$recBtn = $('.record','#rec_player');
	$finBtn = $('.finish_btn','#rec_player');
	
	$playBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		getMyApp("karApp").playBg();
		setButtonStates('play');
		isPlaying = true;
	});
	
	$stopBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		getMyApp("karApp").stopBg();
		doStopPlayBack();
		setButtonStates('stop');
	});
	
	$recBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		getMyApp("karApp").recordVoicePrev();
		isPlaying = false;
		isRecorded = true;
		setButtonStates('rec');
	});
	
	$finBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		getMyApp("karApp").recComplete();
		isPlaying = false;
		isRecorded = true;
		initPreview();
	});
	
});


function initPlayer(param){
    getMyApp("karApp").playerInit(param);
    doRecVolChange(70); //set def rec volume
    doKarVolChange(70); //set def bg volume
    //playerReady(); //TODO:remove after testing
}
 

function doProgressChange( param){
	showInStatus('Song Progress:'+param +"%");
	getMyApp("karApp").setProgress(param);
}

function doRecVolChange( param){
	showInStatus('Record Volume:'+param +"%");
	getMyApp("karApp").setRecVolume(param);
}

function doKarVolChange( param){
	showInStatus('Karaoke Volume:'+param +"%");
	getMyApp("karApp").setBGVolume(param);
}


/*
Flow :
 Applet to Javascript 
*/

function doStopPlayBack(param) {
	isPlaying = false;
	moveProgress(0);
	dispCurrTime("00:00");
	setButtonStates('stop');
}

function dispPlayTime(param) {
	$("#total_time").html(param);
}

function dispCurrTime(param) {
	$("#cur_time").html(param);
}

function moveProgress(param) {
	//document.getElementById('sliderVal').innerHTML=param;
	$("#songSlider").slider( "option", "value", param );
}


function playerReady(param){   //called when song loading is finished..
	initRecorderUI();
}


/***util methods*/
function showInStatus(txt){
	$('#status').html(txt).fadeIn(350,function(){$(this).fadeOut(350)});
}

 function getMyApp(appName) {
    if (navigator.appName.indexOf ("Microsoft") !=-1) {
        return window[appName];
    } else {
        return document[appName];
    }
}

function setButtonStates(whichBtn){
	if(whichBtn == 'none'){
		//initial state
		isPlaying = false;
		isRecorded = false;
		
		enableBtn($playBtn);
		enableBtn($recBtn);
		disableBtn($stopBtn);
		disableBtn($finBtn);
		
		return;
	}
	
	switch(whichBtn){
		case 'play':
			enableBtn($stopBtn);
			disableBtn($playBtn); 
			disableBtn($recBtn);
			disableBtn($finBtn);
			break;
		case 'stop':
			if(isRecorded){
				enableBtn($finBtn);
				disableBtn($recBtn);
				disableBtn($stopBtn); 
				disableBtn($playBtn);
			}
			else{
				enableBtn($playBtn);
				enableBtn($recBtn);
				disableBtn($stopBtn); 
				disableBtn($finBtn);
			}
			break;
		case 'rec':
			isRecorded = true;
			enableBtn($stopBtn);
			disableBtn($playBtn); 
			disableBtn($recBtn);
			disableBtn($finBtn);
			break;
		default:
			enableBtn($playBtn);
			enableBtn($recBtn);
			disableBtn($stopBtn);
			disableBtn($finBtn);
	}
}

function disableBtn(button){
	button.addClass("disabled");
}

function enableBtn(button){
	button.removeClass("disabled");
}

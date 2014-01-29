/**
 * Record Page Javascript Functionalities 
 */
var isDiyRecorded = false;
var isDiyPlaying = false;
/*
  Flow :
   Javascript to Applet
 */
 


/*
Flow :
 Applet to Javascript 
 Javascript to Flex 
 
*/

//Record Methods

function doRecStop(param) {
	//alert("doStopPlayBack :" +param);
	moveRecProgress(0);
	dispRecCurrTime("00:00");
	setPrevButtonStates('stop');
	isDiyRecorded=false;
	
}

function dispRecPlayTime(param) {
	//alert("dispRecPlayTime"+param);
	$("#total_time_rec").html(param);
}

function dispRecCurrTime(param) {
	//alert("dispRecCurrTime"+param);
	$("#cur_time_rec").html(param);
	
}

function moveRecProgress(param) {
	$("#recSongSlider").slider( "option", "value", param );
}

//Preview Methods

function doStopPlayBack() {
	setPrevButtonStates('stop');
}


function dispPlayBackPlayTime(param) {
	dispRecPlayTime(param);
}

function dispPlayBackCurrTime(param) {
	dispRecCurrTime(param);
}

function movePlayBackProgress(param) {
	moveRecProgress(param);
}

function dispErrorMsg(param) {
	alert(param);
}

/**************************/
/**
 * Preview Page Javascript Functionalities
 */


/* declare vars to hold elements*/
var $PlayBtn;
var $StopBtn;
var $RecBtn;
var $uploadBtn;
var $retryBtn;

 /*
  Flow :
   Javascript to Applet
 */
 
$(function(){
	$PlayBtn = $('.play_prev','#diy_player');
	$StopBtn = $('.stop_prev','#diy_player');
	$RecBtn = $('.rec_prev','#diy_player');
	$retryBtn = $('.retry_btn','#diy_player');
	$uploadBtn =  $('.upload_btn','#diy_player');
	
	
	$PlayBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		
		getMyApp("diyRec").playBack();
		setPrevButtonStates('play');
		
	});
	
	$StopBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		
		if(isDiyRecorded){
			getMyApp("diyRec").stopRec();
			isDiyRecorded=false;
			$("#recSongSlider").slider( "option", "disabled", false );
		}
		else{
			getMyApp("diyRec").stopPlayBack();
		}
		setPrevButtonStates('stop');
		
	});
	
	$RecBtn.click(function(){
		if($(this).hasClass('disabled')) return false;
		
		getMyApp("diyRec").record();
		isDiyRecorded=true;
		setPrevButtonStates('rec');
	});
	
	$retryBtn.click(function(){
	if($(this).hasClass('disabled')) return false;
	if(confirm("Previous recorded data will be lost. Proceed?")){
			getMyApp("diyRec").retryRecord();
			isDiyRecorded=false;
			setPrevButtonStates('retry');
		}
		
	});
	
	$uploadBtn.click(function(){
	if($(this).hasClass('disabled')) return false;
		setPrevButtonStates('upload');
		showUserInput();
	});
	
	
	$(".button").hover(
			function(){
				if($(this).hasClass('disabled')) return false;
				var $newimg = $(this).css('background-image').replace('.png', '_hot.png');
				$(this).css('background-image',$newimg);
			},
			function(){
				var $newimg = $(this).css('background-image').replace('_hot.png', '.png');
				$(this).css('background-image',$newimg);
			}
	);
	
});


/***util methods*/
	
function setPrevButtonStates(whichBtn){
	switch(whichBtn){
		case 'play':
			enableBtn($StopBtn);
			disableBtn($PlayBtn);
			//TODO:enable slider
			break;
		case 'stop':
			enableBtn($PlayBtn);
			enableBtn($retryBtn);
			enableBtn($uploadBtn);
			disableBtn($StopBtn);
			disableBtn($RecBtn);
			break;
		case 'rec':
			enableBtn($StopBtn);
			disableBtn($PlayBtn);
			disableBtn($RecBtn);
			disableBtn($uploadBtn);
			disableBtn($retryBtn);
			//todo:disable slider
			break;
		case 'upload':
			disableBtn($uploadBtn);
		default:
			enableBtn($RecBtn);
			disableBtn($PlayBtn);
			disableBtn($StopBtn);
			disableBtn($uploadBtn);
			disableBtn($retryBtn);
	}
}

function getMyApp(appName) {
    if (navigator.appName.indexOf ("Microsoft") !=-1) {
        return window[appName];
    } else {
        return document[appName];
    }
}
function disableBtn(button){
	button.addClass("disabled");
}

function enableBtn(button){
	button.removeClass("disabled");
}


/********slider inits********/
$(function(){
	$.extend($.ui.slider.defaults, {
		range: "min",
		animate: true
	});

	$("#recSongSlider").slider({
			value: 0,
			disabled: true,
			stop: function(event, ui){
				getMyApp("diyRec").setPlayBackProgress(ui.value);
			}
		});
		
	$("#volSlider").slider({
		value: 70,
		stop: function(event, ui){
			if(isDiyRecorded){
				getMyApp("diyRec").setRecVolume(ui.value);
			}
			else{
				getMyApp("diyRec").setPlayBackVolume(ui.value);
			}
			
		}
	});
});

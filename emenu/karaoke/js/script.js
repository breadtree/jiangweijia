$(function(){
	/****** preload images           */
	
	/*var preloaderTotal = 0;
    var preloaderLoaded = 0;
    var preloaderCurrent = null;

    $('#preloaderCurtain')
        .bind('preloaderStart', function(){
            $(this)
                .show();
            $('*')
                .filter(function(e){
                    if($(this).css('background-image') != 'none'){
                        preloaderTotal++;
                        return true;
                    }
                })
                .each(function(index){
                    preloaderCurrent = new Image();
                    preloaderCurrent.src = $(this).css('background-image').slice(5, -2);
                    preloaderCurrent.onload = function(e){
                        preloaderLoaded++;
                        if(preloaderLoaded == preloaderTotal - 1){
                            $('#preloaderCurtain')
                                .trigger('preloaderComplete')
                        }
                        $('#preloaderCurtain')
                            .trigger('preloaderProgress')
                    };
                });
        })
        .bind('preloaderComplete', function(){
            $(this)
                .fadeOut(500)
            startAnimation();
        })
        .bind('preloaderProgress', function(e){
            $('#preloaderProgress')
                .css('opacity', 0.25 + (preloaderLoaded / preloaderTotal))
                .text(Math.floor((preloaderLoaded / preloaderTotal) * 100) + '%');
        })
        .trigger('preloaderStart');*/
		
   /******  preload ends   */	

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
	
	$.extend($.ui.slider.defaults, {
		range: "min",
		animate: true
	});
	
	$("#bgVolSlider").slider({
			value: 70,
			slide: function(event, ui) {
				if(ui.value < 10){
				    return false;
				 } 
				//doKarVolChange(ui.value);
			},
			stop: function(event, ui){
				doKarVolChange(ui.value);
			}
	});
	
	$("#micVolSlider").slider({
			value: 70,
			slide: function(event, ui) {
				if(ui.value < 10){
				    return false;
				 } 
				//doRecVolChange(ui.value);
			},
			stop: function(event, ui){
				doRecVolChange(ui.value);
				
			}
	});
	
	
	$("#songSlider").slider({
			value: 0,
			disabled: true, 
			slide: function(event, ui) {
				//doProgressChange(ui.value);
			},
			stop: function(event, ui){
				doProgressChange(ui.value);
			}
	});
	
		
	$("#prevSongSlider").slider({
		value: 0,
		slide: function(event, ui) {
			//doMixProgressChange(ui.value);
		},
		stop: function(event, ui){
			doMixProgressChange(ui.value);
		}
	});
	
	$("#volSlider").slider({
		value: 70,
		slide: function(event, ui) {
			//doMixVolChange(ui.value);
		},
		stop: function(event, ui){
			doMixVolChange(ui.value);
		}
	});
	
	
	$('.scroll-pane').jScrollPane();
	
	
	//initPreview();
	
				
});

/**
 * This method initializes the UI needed for performing the record operations.
 */
function initRecorderUI(){
	hideLoading();
	$("#rightpanel").removeClass("rightpanel").addClass("rightpanel02");
	$(".steps").addClass("steps02");
	$("#rec_player").slideDown("fast");
	$("#second").removeClass("inactive");
	$("#message1").show();
	$("#message").hide();
	$(".right").show();
	setButtonStates('none');
	
}

function initPreview(){
	$("#rightpanel").removeClass("rightpanel02").addClass("rightpanel03");
	$(".steps").removeClass("steps02").addClass("steps03");
	$(".right").hide();
	$("#third").removeClass("inactive");
	$("#rec_player").slideUp("fast",function(){$("#prev_player").slideDown("fast");});
	setPrevButtonStates();
}

function hidePreviewUI(){
	$("#prev_player").slideUp("fast");
	$(".steps").removeClass("steps03");
	$("#rightpanel").removeClass("rightpanel03");
	$("#third").addClass("inactive");
}

function showLoading(){
	$("#rec_player").hide();
	$("#loading").show();
	$("#rightpanel").removeClass("rightpanel02").addClass("rightpanel");
	$("#message").hide();
}

function hideLoading(){
	$("#loading").fadeOut();
	$("#message").show();
}

function initRecord(ringid,ringtype,ringname){
	$("#message1").text(ringname);
 	showLoading();
 	
 	var responsMsg= $.ajax({
		url: "/colorring/karaoke/karDownload?ringid="+ringid+"&ringtype="+ringtype,
		cache:false,
		type:"POST",
		async:false,
		contentType:"application/x-www-form-urlencoded;charset=UTF-8"
	  }).responseText;
   
	 	 
	 if($.trim(responsMsg).indexOf("http://")>=0){
		 initPlayer($.trim(responsMsg))
		 //To hide preview page and show the record page  when user clicks on another song to  record in song list 
			hidePreviewUI();	
			initRecorderUI();
	  }
	  else {
		alert("Cannot record songs now.\nPlease try again later!");
		//var temp = '<i18n:message key="UserMSG0015434" />\n <i18n:message key="UserMSG0015435"/>  ';
			//alert(temp); 
			hideLoading();
			$("#message").show();
			return false;
	 }
 	
 }
 

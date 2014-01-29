var ringdisplay='ringtone';
   function onMore1(){
       location.href="ringboard.jsp?searchvalue=5";
   }
   function onMore3(){
     location.href="ringboard.jsp?searchvalue=3";
   }
   function onMore2(){
     location.href="ringboard.jsp?searchvalue=2";
   }
  function tryListen (ringID,ringName,ringAuthor,mediatype,ringtype){
    var tryURL = 'trylisten.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
    if(ringtype)
    	tryURL += '&ringtype=' + ringtype;
    if(trim(mediatype)=='1'){
    window.open(tryURL,'try','width=400, height=260');
  }
   else if (trim(mediatype)=='2'){
		window.open(tryURL,'try','width=400, height=430');
   }
   else if (trim(mediatype)=='4'){
   	tryURL = 'tryview.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
   	if(ringtype)
    	tryURL += '&ringtype=' + ringtype;
    window.open(tryURL,'try','width=400, height=450');
   }
  }

  function doSubmit(url){
		//alert(url);
		document.location.href = url;
  }

  function goBack(url){
   /* if(window.opener){
       window.close();
       return;
    }*/
    if(url&&url!=''){
        //document.location.href =url;
        window.location= url;
    }else{
        if(parent.frames.length>0){
            document.location.href='main.jsp'
        }else
            document.location.href = 'index.jsp';
    }
  }

  function ringInfo(ringid, ringtype){
  	var rurl = 'ringinfo.jsp?ringid=' + ringid;
  	if (ringtype && ringtype=='3'){
  			rurl += '&ringtype=' + ringtype;
  	}
    window.open(rurl,'infoWin','width=498, height=346, top='+(screen.height-355)/2 + ',left='+(screen.width-400)/2);
  }
/**
     *add buytimes ,largesstimes in input parameters
   */
  function ringInfo1(ringid,buytimes,largesstimes,ringtype){
  	var rurl = 'ringinfo.jsp?ringid=' + ringid + '&buytimes=' + buytimes + '&largesstimes=' + largesstimes ;
  	if (ringtype && ringtype=='3'){
  			rurl += '&ringtype=' + ringtype;
  	}
    window.open(rurl,'infoWin','width=498, height=346, top='+(screen.height-355)/2 + ',left='+(screen.width-400)/2);
  }

	/**
		* 显示音乐盒/大礼包的详细信息
		* grouptype 1 音乐盒  2 大礼包
		* groupid 铃音组ID
		**/
  function ringGroupInfo(grouptype, groupid)
  {
     document.location.href ='sysringgrpdetail.jsp?action=1&grouptype=' + grouptype + '&groupid=' + groupid;
  }

  /**
  	* 订购音乐盒/大礼包操作
  	* op 操作类型 1 仅显示详细信息 2 订购  3赠送
  	* grouptype 1 音乐盒  2 大礼包
		* groupid 铃音组ID
  	**/
  function ringGroupDetail(op, grouptype, groupid,isUserLib)
  {
  		var reqUrl = '/colorring/ringgroupdetail.action?action=' + op + '&grouptype=' + grouptype + '&groupid=' + groupid+'&isUserLib='+isUserLib;
  		doSubmit(reqUrl);
  }

	/**
	* 订购铃音操作
	* ringid 铃音ID
		* ringidtype 铃音类型1铃音2铃音组3系统铃音组
       **/
	function buyRing(ringid, ringidtype, grouptype)
	{
			var reqUrl = '/colorring/buyringtip.action?ringid='+ringid+'&ringidtype='+ringidtype +'&grouptype='+grouptype;
			//var results = xmlRequest(reqUrl);
			doSubmit(reqUrl);
			//为0时查询成功,提示用户的确认信息
//      if (results[0] == 0 && confirm(results[1]))
//			{
//      		//开始订购操作
//      		doSubmit('/colorring/buyring.action?ringidtype=' + ringidtype +'&ringid=' + ringid);
//    	}
	}

	/**
		* 打开铃音赠送页面
		* ringid 铃音ID
		* ringidtype 铃音类型
		* grouptype 铃音组类型
		**/
	function openLargess(ringid, ringidtype, grouptype)
	{
			var reqUrl = '/colorring/openlargess.action?ringid='+ringid+'&ringidtype='+ringidtype +'&grouptype='+grouptype;
			doSubmit(reqUrl);
			//var results = xmlRequest(reqUrl);
			//if (results[0] == 0)
			//{
			//	window.open('largessring.jsp?ringid='+ringid+'&ringidtype='+ringidtype +'&grouptype='+grouptype,'largessring','width=400,height=260,toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0');
			//}
	}

	/**
  	* 赠送音乐盒/大礼包操作
  	* grouptype 1 音乐盒  2 大礼包
		* groupid 铃音组ID
  	**/
	function buyRingGroup(grouptype, groupid)
  {
  		var reqUrl = '/colorring/buyringgrp.action?action=3&grouptype=' + grouptype + '&groupid=' + groupid;
  		doSubmit(reqUrl);
  }

	/**
		* 赠送铃音
		*	receivenumber 接收方号码
		* ringid 铃音ID
		* ringidtype 铃音类型
		* grouptype 铃音组类型
		**/
  function largessRing(receivenumber, ringid, ringidtype, grouptype, leaveword)
  {
  	var reqUrl = '/colorring/largessringtip.action?receivenumber=' + receivenumber + '&ringid='+ringid+'&ringidtype='+ringidtype +'&grouptype='+grouptype;
  	var results = xmlRequest(reqUrl);
			//为0时查询成功,提示用户的确认信息
        if (results && results[0] == 0 && confirm(results[1])){
		//赠送系统铃音组
	  if (ringidtype == 3){
		reqUrl = '/colorring/largessringgroup.action?receiver=' + receivenumber + '&ringid=' +
										ringid + '&leaveword=' + leaveword + '&ringidtype=' + ringidtype;

	  }
	  else
	 {
			//赠送铃音
	  reqUrl = '/colorring/largessring.action?receiver=' + receivenumber + '&ringid=' + ringid + '&leaveword=' + leaveword;
	 }
	 results = xmlRequest(reqUrl);
	//赠送成功,提示用户并返回到原页面
	 if (results && results[0] == 0)
	{
	  alert(ringdisplay+' send successfully!\n The sent '+ringdisplay+' has been saved to the receiver  personal '+ringdisplay+
            ' libarary, and it will be listened after the receiver set the default '+ringdisplay+' .');
						//返回原页面
						//history.go(-2);
	}
      }
  }

  function refresh(action, number, ringID){
		parent.refresh(number);
		//action 0 仅登录 1 购买  2 赠送
		if (action == 1)//购买
		{
		   	//collection(ringID);
		}
		else if (action == 2)//赠送
		{
			//largess(ringID);
		}
  }

  function myfavorite(op,ringid){
      if(op==1)//add
      {
      	 var url = '/colorring/favorite.action?ringid=' + ringid+'&op='+op;
      	 doSubmit(url);
         //window.open(url,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
      else if(op==2)//del favorite
      {
      	 var url = '/colorring/rmfavorite.action?ringid=' + ringid+'&op='+op;
         doSubmit(url);
      }
   }



function checkIPList(sendObj)
 {
    if( sendObj.value =="")
        return true;
    var ipArray=sendObj.value.split(",");
    for(var ipi=0;ipi<ipArray.length;ipi++){
       if(!checkVarIP(ipArray[ipi])){
            alert("Input of IP address is illegal!");
            sendObj.select();
			sendObj.focus();
			return false;
       }

       for(ipj=ipi;ipj<(ipArray.length-1);ipj++){

            if(ipArray[ipi]==ipArray[ipj+1]){
                alert("Input the same IP address. It is illegal!");
                sendObj.select();
			    sendObj.focus();
			    return false;
            }
       }
    }
    return true;

 }
//检查变量的IP地址合法性
function checkVarIP(sIPAddress)
{
    var ymdArray = sIPAddress.split(".");

	if (ymdArray.length != 4)
		return false;

	for (var i = 0; i < ymdArray.length; i++)
	{
		if (ymdArray[i].length == 0 || isNaN(ymdArray[i]))
			return false;

		if(!checkstring("0123456789",ymdArray[i]))
		    return false;

		if (parseInt(ymdArray[i]) < 0 || parseInt(ymdArray[i]) > 255)
			return false;

	}
	return true;
}

  function checkIPAdress(Sender)
  {
    var field = Sender.value;
  	var ymdArray = field.split(".");

	if (ymdArray.length != 4)
	{
		alert("Input of IP address is illegal!");
		Sender.select();
		Sender.focus();
		return false;
	}
	for (var i = 0; i < ymdArray.length; i++)
	{
		if (ymdArray[i].length == 0 || isNaN(ymdArray[i]))
		{
			alert("Input of IP address is illegal!");
			Sender.select();
			Sender.focus();
			return false;
		}

		if (parseInt(ymdArray[i]) < 0 || parseInt(ymdArray[i]) > 255)
		{
			alert("Input of IP address is illegal!");
			Sender.select();
			Sender.focus();
			return false;
		}
	}
	return true;

  }
  //检查输入是否合法,不包括汉字
  function CheckInputChar(Sender)
  {
  	var i = 0;
	var sValue = Sender.value;
	for( i = 0; i < sValue.length;  i++)
	{
		var sChar = sValue.charAt(i);
		if (((sChar < 'A') || (sChar > 'Z')) && ((sChar < 'a') || (sChar > 'z')) &&
			((sChar < '0') || (sChar > '9')) && (sChar != '_') && (sChar != '@')&& (sChar != '-')&& (sChar != '(')&& (sChar != ')')&& (sChar != '[')&& (sChar != ']') && (sChar != '*')&& (sChar != '$')&& (sChar != '{')&& (sChar != '}')&& (sChar != '!')&& (sChar != '#')
			 && (sChar != '.') &&(sChar!=' '))
		{
			alert("It does not contain the character ' "+sChar+" '!");
			Sender.select();
			Sender.focus();
			return false;
		}
	}
	return true;
  }


  //检查输入是否合法,不包括汉字
  function CheckInputChar1(Sender,strName)
  {
  	var i = 0;
	var sValue = Sender.value;
	for( i = 0; i < sValue.length;  i++)
	{
		var sChar = sValue.charAt(i);
		if (((sChar < 'A') || (sChar > 'Z')) && ((sChar < 'a') || (sChar > 'z')) &&
			((sChar < '0') || (sChar > '9')) && (sChar != '_') && (sChar != '@')&& (sChar != '-')&& (sChar != '(')&& (sChar != ')')&& (sChar != '[')&& (sChar != ']') && (sChar != '*')&& (sChar != '$')&& (sChar != '{')&& (sChar != '}')&& (sChar != '!')&& (sChar != '#')
			 && (sChar != '.') &&(sChar!=' '))
		{
			alert(strName +" cannot  contain the character ' "+sChar+" '!");
			Sender.select();
			Sender.focus();
			return false;
		}
	}
	return true;
  }

  //检查输入是否合法,包括汉字
  function CheckInputStr(Sender,strName)
  {
  	var i = 0;
	var sValue = Sender.value;
	for( i = 0; i < sValue.length;  i++)
	{
		var sChar = sValue.charAt(i);
		if (((sChar < 'A') || (sChar > 'Z')) && ((sChar < 'a') || (sChar > 'z')) &&
			((sChar < '0') || (sChar > '9')) && (sChar != '_') && (sChar != '@') && (sChar != '-')
			 && (sChar != '.') &&(sChar!=' ') && (sValue.charCodeAt(i)>0) && (sValue.charCodeAt(i)<255) )
		{
			alert(strName +" should not contain illegal character ' "+sChar+" '!");
			Sender.select();
			Sender.focus();
			return false;
		}
	}
	return true;
  }




  //键盘响应函数
   function OnKeyPress(evn,Next_ActiveControl,SenderType)
  {
    var
        charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
    status = charCode;
	if (charCode == 13)
	{
		Next_ActiveControl.select();
		Next_ActiveControl.focus();
		return false;
	}
	switch (SenderType.toUpperCase())
	{
		case 'int'.toUpperCase():
   			if ((charCode < 48) || (charCode > 57)){
				return false;
			}
			break;

		case 'float'.toUpperCase():
			var i = 0;
   			if ((charCode != 46) && (charCode < 48) || (charCode > 57)){
				evn.KeyCode = 0;
				return false;
			} else if (charCode == 46){
				if (Sender.value == "")
					return false;
			    else{
				    for(var i = 0; i < Sender.value.length; i++){
					    var sChar = Sender.value.charAt(i);
					    if (sChar == '.') return false;
				    }
			    }
			}
		break;

		case 'date'.toUpperCase():
		    if (((charCode < 48) || (charCode > 57)) && (charCode!=45)){
				return false;
			}
		break;
		default:
			break;

	}

    return true;

}
//键盘响应函数:输入密码
  function onPassword(evn) {
    var   charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
    if (charCode == 13){
       document.forms[0].password.blur();
      userLogin();
      }

  }

function checkstring(checkstr,userinput)
{
  var allValid = true;
  for (i = 0;i<userinput.length;i++)
  {
    ch = userinput.charAt(i);
    if(checkstr.indexOf(ch) == -1)
    {
      allValid = false;
      break;
    }
  }

  if (!allValid) return (false);
  else return (true);
}


 // 删除字符串的左边空格

   function leftTrim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = str;
      var i = 0;
      for (i = 0; i < str.length; i++) {
         if (tmp.substring(0,1) == ' ')
            tmp = tmp.substring(1,tmp.length);
         else
            return tmp;
      }
      return tmp;
   }

   // 删除字符串的右边空格

   function rightTrim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = str;
      var i = 0;
      for (i = str.length - 1; i >= 0; i--) {
         if (tmp.substring(tmp.length - 1,tmp.length) == ' ')
            tmp = tmp.substring(0,tmp.length - 1);
         else
            return tmp;
      }
      return tmp;
   }

   // 删除字符串的两边空格

   function trim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = leftTrim(str);
      return rightTrim(tmp);
   }

//判断日期值是否正确(年.月)

   function checkDate1 (str) {
      str  = trim(str);
      if (str.length == 0)
         return true;
      if(str.length!=7)
        return false;
	  year = str.substring(0,4);
	  month = str.substring(5,7) - 1;
	  if (isNaN(year) || isNaN(month))
         return false;
      var tmpDate = new Date(year,month);
	  if (tmpDate.getFullYear() != year || tmpDate.getMonth() != month)
         return false;
	  return true;
   }
//判断截至时间是否大于当前时间(年.月)

   function checktrue1(str){
      str  = trim(str);
      if (str.length == 0)
         return true;
      if(str.length!=7)
        return false;
      var currentDate = new Date();
	  var month = (parseInt(currentDate.getMonth())+1).toString();
	  if(month.length==1)
	  	month = '0'+month;
      var nowDate = currentDate.getYear() + month;
	  var get1Date = str.substring(0,4) + str.substring(5,7);
	  if (get1Date - nowDate > 0){

	  return false;
	  }
	  return true;
   }
 //判断截至时间是否大于当前时间(年.月.日)

   function checktrue2(str){
   var currentDate = new Date();
	  str  = trim(str);
      if (str.length == 0)
         return true;
      if(str.length!=10)
        return false;
	  var month = (parseInt(currentDate.getMonth())+1).toString();
	  if(month.length==1)
	  	month = '0'+month;
		var day = currentDate.getDate().toString();
		if(day.length==1)
		day = '0'+day;
      var nowDate = currentDate.getYear() + month + day;
	  var get1Date = str.substring(0,4) + str.substring(5,7) + str.substring(8,10);
	  if (get1Date - nowDate > 0){

	  return false;
	  }
	  return true;
   }
   //判断截至时间是否大于等于当前时间(年.月.日)

   function checktrue22(str){
   var currentDate = new Date();
	  str  = trim(str);
      if (str.length == 0)
         return true;
      if(str.length!=10)
        return false;
	  var month = (parseInt(currentDate.getMonth())+1).toString();
	  if(month.length==1)
	  	month = '0'+month;
		var day = currentDate.getDate().toString();
		if(day.length==1)
		day = '0'+day;
      var nowDate = currentDate.getYear() + month + day;
	  var get1Date = str.substring(0,4) + str.substring(5,7) + str.substring(8,10);
	  if (get1Date - nowDate >= 0){

	  return false;
	  }
	  return true;
   }
   //add by gequanmin 2005.06.30
  //判断截铃音有效期是否大于2099.12.31(年.月.日)

   function checktrue2099(str){
     str  = trim(str);
      if(str.length!=10)
        return false;
   var endDate = "2099.12.31";
   if (str > endDate){
	  return true;
	  }
	  return false;
   }
   
   //add by sunqi 2006.06.14
  //判断截铃音有效期是否大于给定的日期,如2099.12.31(年.月.日),注意,不判断输入参数的有效性.

   function checktrueyear(str,endDate)
   {
     	str  = trim(str);
      if(str.length!=10)
        return false;
   	if (str > endDate){
	  		return true;
	  	}
	  	return false;
   }   
   

   //判断截至时间是否大于当前时间(年.月.日.时)

   function checktrue3(str){
   var currentDate = new Date();
	  str  = trim(str);
      if (str.length == 0)
         return true;
      if(str.length!=13)
        return false;
	  var month = (parseInt(currentDate.getMonth())+1).toString();
	  if(month.length==1)
	  	month = '0'+month;
		var day = currentDate.getDate().toString();
		if(day.length==1)
		day = '0'+day;
      var hour = currentDate.getHours();
      if(hour<10)
         hour  = '0' + hour;
      var nowDate = currentDate.getYear() + month + day + hour;
	  var get1Date = str.substring(0,4) + str.substring(5,7) + str.substring(8,10) + str.substring(11,13) ;
	  if (get1Date - nowDate > 0){

	  return false;
	  }
	  return true;
   }
//判断两个日期是否超过一个月


  function checktrue4(str1,str2){
  	var str1year = str1.substring(0,4);
  	var str1mon  = str1.substring(5,7);
  	var str1day  = str1.substring(8,10);
  	var str2year = str2.substring(0,4);
  	var str2mon  = str2.substring(5,7);
  	var str2day  = str2.substring(8,10);
  	if(str1year == str2year){
  		if(str1mon == str2mon){
  			return true;
  		}
  		else if(str2mon - str1mon == 1){
  			if(str1day - str2day > 0){
  				return true;
  			}else{
  				return false;
  			}
  		}
  		else{
  			return false;
  		}
  	} 	
  	else{
  		return false;
  	}
  	return true;
  }
  //判断两个日期是否超过一年


	function checktrue5(str1,str2){
		var str1year = str1.substring(0,4);
  	var str1mon  = str1.substring(5,7);
  	var str2year = str2.substring(0,4);
  	var str2mon  = str2.substring(5,7);
  	if(str1year == str2year){
  		return true;
  	}
  	else if(str2year - str1year == 1){
  		if(str2mon - str1mon < 0){
  			return true;	
  		}else{
  			return false;
  		}
  	}else{
  		return false;
  	}  	
  	return true;
  }


  //判断日期值是否正确（年.月.日）

   function checkDate2 (str) {
      str = trim(str);
      if (str.length == 0)
         return true;
      if (str == null || str == '' || str.length != 10)
         return false;
      year = str.substring(0,4);
      month = str.substring(5,7) - 1;
      day = str.substring(8,10);

      if(str.substring(4,5)!='.' || str.substring(7,8)!='.')
         return false;
      if (isNaN(year) || isNaN(month) || isNaN(day))
         return false;
      var tmpDate = new Date(year,month,day);
      if (tmpDate.getFullYear() != year || tmpDate.getMonth() != month)
         return false;
	  return true;
   }

  //判断日期值是否正确（年.月.日.时）

   function checkDate3 (str) {
      str = trim(str);
      if (str.length == 0)
         return true;
      if(str.length!=13)
        return false;
      if (str == null || str == '' )
         return false;
	  year = str.substring(0,4);
	  month = str.substring(5,7) - 1;
	  day = str.substring(8,10);
	  hour = str.substring(11,13);
	  if (isNaN(year) || isNaN(month)||isNaN(day))
         return false;
      var tmpDate = new Date(year,month,day);
	  if (tmpDate.getFullYear() != year || tmpDate.getMonth() != month || hour<0 || hour>23)
         return false;
      return true;
   }
  //判断起止日期输入是否正确(年.月)


   function compareDate1 (beginDate, endDate) {
      beginDate = trim(beginDate);
      endDate = trim(endDate);
      if ((! checkDate1(beginDate)) || (! checkDate1(endDate)))
         return false;
      beginDate = beginDate.substring(0,4) + beginDate.substring(5,7) ;
      endDate = endDate.substring(0,4) + endDate.substring(5,7);
      if ((beginDate - endDate) >0)
         return false;
      return true;
   }
	//判断起止日期输入是否正确(年.月.日)


   function compareDate2 (beginDate, endDate) {
      beginDate = trim(beginDate);
      endDate = trim(endDate);
      if ((! checkDate2(beginDate)) || (! checkDate2(endDate)))
         return false;
      beginDate = beginDate.substring(0,4) + beginDate.substring(5,7)+beginDate.substring(8,10) ;
      endDate = endDate.substring(0,4) + endDate.substring(5,7)+endDate.substring(8,10);
       if ((beginDate - endDate) >0)
         return false;
      return true;
   }
   //判断起止日期输入是否正确(年.月.日.时)


   function compareDate3 (beginDate, endDate) {
      beginDate = trim(beginDate);
      endDate = trim(endDate);
      if ((! checkDate3(beginDate)) || (! checkDate3(endDate)))
         return false;
      beginDate = beginDate.substring(0,4) + beginDate.substring(5,7)+beginDate.substring(8,10)+beginDate.substring(11,13) ;
      endDate = endDate.substring(0,4) + endDate.substring(5,7)+endDate.substring(8,10)+endDate.substring(11,13) ;
      if ((beginDate - endDate)> 0)
         return false;
      return true;
   }
   //得到字符串的长度（汉字按2个字符计）


function strlength(str){
  var l=str.length;
  var n=l;
  for(var i=0;i<l;i++)if(str.charCodeAt(i)<0||str.charCodeAt(i)>255)n++;
  return n;
}

//检查字符串长度是否超过指定长度
function checkLength(ChkStr,ChkLen){
  var l=strlength(ChkStr);
  if(l>ChkLen)l=-1;
  return l;
}

 function getMonthDays(year,month){
    var days = -1;
    if(year<1900 || year>3000 || month<0 || month>12)
      return days ;
    if(month==1|| month == 3 || month==5 || month==7 || month==8 || month==10 || month==12)
      days =31;
    else if(month==4|| month == 6 || month==9|| month==11)
       days =30;
    else if(month==2){
        days = 28;
        if((year%4==0 && year%100>0) || (year %400==0))
           days = 29;
    }
    return days;
 }


  function leftTrimt0 (str) {
      var tmp = str;
      var i = 0;
      for (i = 0; i < str.length; i++) {
         if (tmp.substring(0,1) == '0')
            tmp = tmp.substring(1,tmp.length);
         else
            return tmp;
      }
   }

   //检查字符串是否是Email格式

   function isEmail(strEmail) {
     return (strEmail.search(/^\w+((-\w+)|(\.\w+))*\@\w+((\.|-)\w+)*\.\w+$/) != -1);
   }
   //检查字符串是否是身份证


   function isPersonID(strInteger) {
     var PersonDate="";
     if(strInteger.length==15){
       PersonDate="19"+strInteger.substring(6,8)+"."+strInteger.substring(8,10)+"."+strInteger.substring(10,12);
       if(isDate(PersonDate))return true;
     }else if(strInteger.length==18){
       PersonDate=strInteger.substring(6,10)+"."+strInteger.substring(10,12)+"."+strInteger.substring(12,14);
       if(isDate(PersonDate))return true;
     }
     return false;
   }
   //检查字符串是否是日期格式


   function isDate(strDate) {
     if(strDate.search(/^\d{4}(\.|-|\/)(0[1-9]|1[0-2])(\.|-|\/)([0-2]\d|3[0-1])$/) == -1){
       return false;
     }
     var myyear=strDate.substring(0,4);
     var mymonth=strDate.substring(5,7);
     var myday=strDate.substring(8,10);
     var mynewday = new Date(myyear,mymonth-1,myday);
     if(((myyear-mynewday.getYear())%100)==0)if(mymonth==(mynewday.getMonth()+1))if(myday==mynewday.getDate())return true;
     return false;
   }

   //检查User number是否正确

   function isUserNumber(usernumber,numbername){
      usernumber =  trim(usernumber);
      if(numbername=='')
         numbername = 'MS number';
      if(usernumber==''){
         alert(numbername+" can not be blank,please re-enter!");//不能为空,请输入
         return false;
      }
      if(!checkstring('0123456789',usernumber)){
         alert(numbername+" should be the digit character string, please input it again!");
         return false;
      }
      if(usernumber.length<7){
         alert("The length of"+numbername+" is not enough, please input it again!");
         return false;
      }
/*      
      var tmp = usernumber.substring(0,2);
      if((tmp!='13' && tmp!='14' && tmp!='15') && (usernumber.charAt(0)!='0')){
         alert("The input format of "+numbername+" is 0+area code+number.please re-enter!");
         //alert(numbername+"的输入格式是: 0 + 区号 + 号码,请重新输入!");
         return false;
      }
*/      
      return true;
   }


   //输出制定长度字符串,不足前加0

   function getStringFormat(str,len){
     var  sTmp = "" + str;
     if(str.length > len)
        return sTmp;
     while(sTmp.length < len )
        sTmp = '0' + sTmp;
     return sTmp;
   }

  //获取当前日期字符串

  function getCurrentDate(){
   var today = new Date();
   return today.getYear() + '.' + getStringFormat(today.getMonth()+1,2) + '.' + getStringFormat(today.getDate(),2);
  }
  //to get the start date 10 days prior to the (current date)end date - ForV5.10.01(KPIMonitor)
  function getDatepriordays(days){
	   var today= new Date(); 
		//today.setDate(today.getDate()-1)
		var dayOfTheWeek=today.getDay();
		var calendarDays = days;
		var deliveryDay = dayOfTheWeek + days;
		if (deliveryDay >= 6) {
			days -= 6 - dayOfTheWeek; //deduct this-week days
			//calendarDays += 2; //count this coming weekend
			//alert("calendarDays1=====>"+calendarDays);
			//deliveryWeeks = Math.floor(days / 5); how many whole weeks?
			//alert("deliveryWeeks=====>"+deliveryWeeks);
			//calendarDays += deliveryWeeks * 2; two days per weekend per week
			}
		today.setTime(today.getTime() + calendarDays * 24 * 60 * 60 * 1000);    		
		var theyear=today.getYear() 
		var themonth=today.getMonth()+1 
		var theday=today.getDate()     		  
		return theyear + '.' + getStringFormat(themonth,2) + '.' + getStringFormat(theday,2);
	} 
  //To get the days difference between start date and end date- ForV5.10.01(KPIMonitor)
  function days_between(d1,d2,days) {
	  	var ONE_DAY = 1000 * 60 * 60 * 24;        	
	  	var dt1 = Date.parse(d1.replace(/\./g,"/"));
	  	var dt2 = Date.parse(d2.replace(/\./g,"/"));
	  	var date1 = new Date(dt1);
	  	var date2 = new Date(dt2);
	  	var difference_ms = Math.abs(date1.getTime() - date2.getTime());
	  	var diffDays = Math.round(difference_ms/ONE_DAY)
	  	if( diffDays > days ){
	  	alert('Start date and End date duration period should not exceeds '+ days +'days!');
	  	return false;
	  	}
	  	return true;
	  	} 
  //获取制定月前的日期字符串

  function getMonthPriorDate(months){
   var today = new Date();
   var year = today.getYear();
   year = year - Math.floor(months/12);
   var month = today.getMonth() + 1 - months%12;
    if(month<=0){
      month = 12 + month ;
      year = year - 1;
    }
    return year + '.' + getStringFormat(month,2) + '.01';
 }

 // 检查号码是否是‘13’、‘148’,‘159’开头的手机号

 function isMobile(number){
    var flag = 'false';
    var tmp = number.substring(0,2);
    number =  trim(number);
    if((tmp!='13' && tmp!='14' && tmp!='15')){
       flag = 'true';
    }
    return flag;
 }


function checkUTFLength(countValue, maxLength) {
        //var countMe = document.getElementById("someText").value
        var escapedStr = encodeURI(countValue)
        if (escapedStr.indexOf("%") != -1) {
            var count = escapedStr.split("%").length - 1
            if (count == 0) count++  //perverse case; can't happen with real UTF-8
            var tmp = escapedStr.length - (count * 3)
            count = count + tmp
        } else {
            count = escapedStr.length
        }
        if(maxLength < count){
          return false;
        }else{
          return true;
        }
     }

  // To get the yesterday date
  function getYeserdayDate(){
		var today= new Date() 
		today.setDate(today.getDate()-1) 
		  
		var theyear=today.getYear() 
		var themonth=today.getMonth()+1 
		var theyesterday=today.getDate() 
		  
		return theyear + '.' + getStringFormat(themonth,2) + '.' + getStringFormat(theyesterday,2);
	}

function getMonthPriorDate1(startDate,endDate,months){
	   startDate = trim(startDate);
	   endDate = trim(endDate);
	  if(startDate.length<=7)
	 {
	   var startDa = startDate.substring(0,4) + "." +startDate.substring(5,7)
	   var year = parseInt(endDate.substring(0,4),10);
	   year = year - Math.floor(months/12);
	   var month = parseInt(endDate.substring(5,7),10) + 1 - months%12;
	    if(month<=0){
	      month = 12 + month ;
	      year = year - 1;
	    }
	    var startD = year + '.' + getStringFormat(month,2);
	    if(startDa < startD){
	      return false;
	    }
	  }
	else
	  {

	   var startDa = startDate;
	   var year = parseInt(endDate.substring(0,4),10);
	   year = year - Math.floor(months/12);
	   var month = parseInt(endDate.substring(5,7),10) - months%12;
	    if(month<=0){
	      month = 12 + month ;
	      year = year - 1;
	    }
		var days=parseInt(endDate.substring(8,10),10);

	    var startD = year + '.' + getStringFormat(month,2)+ '.' + getStringFormat(days,2);
	    if(startDa < startD){
	      return false;
	    }
	  }
	    return true;
	 }

//added by Pavan Kishore
//To validate YYYY.MM.DD format of Date
function isValidDate(dateStr) {
	var datePat = /^(\d{4})(\.)(\d{1,2})(\.)(\d{1,2})$/; // requires 4 digit year
	var matchArray = dateStr.match(datePat); // is the format ok?
	if (matchArray == null) {
		//alert(dateStr + " Date is not in a valid format.Please enter the date in YYYY.MM.DD format.")
		return false;
	}
	month = matchArray[3]; // parse date into variables
	day = matchArray[5];
	year = matchArray[1];
	var d = new Date();
	var curr_date = d.getDate();
	var curr_month = (d.getMonth()+1);
	var curr_year = d.getFullYear();
	if (year >curr_year){
		//alert("Year should not be greater than the current Year.");
		return false;
	}
	if (year ==curr_year){
		if (month >curr_month){
			//alert("Date should not be greater than the current Date.");
			//alert("Month should not be greater than the current Month.");
			return false;
		}
		if (month ==curr_month){
			if (day >curr_date){
				//alert("Date should not be greater than the current Date.");
				return false;
			}
		}
	}
	if (month < 1 || month > 12) { // check month range
//		alert("Month must be between 1 and 12.");
		return false;
	}
	if (day < 1 || day > 31) {
//		alert("Day must be between 1 and 31.");
		return false;
	}
	if ((month==4 || month==6 || month==9 || month==11) && day==31) {
//		alert("Month "+month+" doesn't have 31 days!")
		return false;
	}
	if (month == 2) { // check for february 29th
		var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
		if (day>29 || (day==29 && !isleap)) {
//			alert("February " + year + " doesn't have " + day + " days!");
			return false;
		}
	}
	return true;
}

//added by Pavan Kishore
//To validate YYYY.MM format of Date
function isValidMonthlyDate(dateStr) {
	var datePat = /^(\d{4})(\.)(\d{1,2})$/; // requires 4 digit year
	var matchArray = dateStr.match(datePat); // is the format ok?
	if (matchArray == null) {
		//alert(dateStr + " Date is not in a valid format.Please enter the date in YYYY.MM format.")
		return false;
	}
	month = matchArray[3]; // parse date into variables
	year = matchArray[1];
	var d = new Date();
	var curr_date = d.getDate();
	var curr_month = (d.getMonth()+1);
	var curr_year = d.getFullYear();
	if (year >curr_year){
		return false;
	}
	if (year ==curr_year){
		if (month >curr_month){
			return false;
		}
	}
	if (month < 1 || month > 12) { // check month range
//		alert("Month must be between 1 and 12.");
		return false;
	}
	return true;
}
//added by Pavan Kishore
//This method will return No of Days Difference between given start and end Date. 
function getDateDiffDays(startDate, endDate) {
if (isValidDate(startDate)) {
	   	if (endDate ==null||endDate == ''|| endDate =='undefined') {
			var currentDate = new Date();
			endDate =currentDate.getYear() +"."+(currentDate.getMonth()+1)+"."+currentDate.getDate();
		} 
		if (isValidDate(endDate)) {
			var datePat = /^(\d{4})(\.)(\d{1,2})(\.)(\d{1,2})$/; // requires 4 digit year
			var startDateArray = startDate.match(datePat); // is the format ok?
			var month = startDateArray [3]; // parse date into variables
			var day = startDateArray [5];
			var year = startDateArray [1];
			var endDateArray = endDate.match(datePat); // is the format ok?
			var month1 = endDateArray[3]; // parse date into variables
			var day1 = endDateArray[5];
			var year1 = endDateArray[1];
			var sDate = new Date(year,month-1,day);
			var eDate = new Date(year1,month1-1,day1);
			var diff = eDate.getTime()-sDate.getTime();
			if (diff <0) {
				return -1;
			}
			var one_day = 1000*60*60*24;
			return (Math.ceil(diff/one_day)+1);
		}
	}
	return -1;
}
function validateQueryStatDateMaxLimit(startDate, endDate, weekMonth, limit) {
	
	if (weekMonth == "Monthly") {
		if (startDate == null || startDate == "" || startDate == 'undefined') {
			alert('Please Enter Start Month');
			return false;
		}
		var datePat = /^(\d{4})(\.)(\d{1,2})$/; // requires 4 digit year
		var matchArray = startDate.match(datePat); // is the format ok?
		if (matchArray == null) {
			alert( "Start Month is not in a valid format.Please enter the date in YYYY.MM format.")
			return false;
		}
		if (isValidMonthlyDate(startDate)==true) {
			// End Date is manadatory
			if (endDate == null || endDate == "" || endDate == 'undefined') {
				alert('Please Enter End Month');
				return false;
			}
			var matchArray1 = endDate.match(datePat); // is the format ok?
			if (matchArray1 == null) {
				alert( " End Month is not in a valid format.Please enter the date in YYYY.MM format.")
				return false;
			}
			if (isValidMonthlyDate(endDate)==true) {
				var startDateArray = startDate.match(datePat); // is the format ok?
				// is the format ok?
				var month = startDateArray[3]; // parse date into variables
				var year = startDateArray[1];
				var endDateArray = endDate.match(datePat); // is the format ok?
				var month1 = endDateArray[3]; // parse date into variables
				var year1 = endDateArray[1];
				month1= trim(month1);
				year1= trim(year1);
				var eMonth1= month1;//parseInt(month1);
				var eyear1= year1;////parseInt(year1);
				var d = new Date();
				var curr_date = d.getDate();
				var curr_month = d.getMonth()+1;
				var curr_year=d.getFullYear();
				if (curr_year== eyear1){
					if (curr_month==eMonth1){
						if (curr_date < 10) {
							endDate = endDate + ".0"+curr_date;
						} else {
							endDate = endDate+curr_date;
						}
					} else  if (curr_month>eMonth1){
						if (eMonth1==2){
							var isleap = (eyear1 % 4 == 0 && (eyear1 % 100 != 0 || eyear1 % 400 == 0));
							if (isleap){
								endDate = endDate + ".29";
							} else {
								endDate = endDate + ".28";
							}
							
						}else {
							if (eMonth1==4||eMonth1==6||eMonth1==9||eMonth1==11){
								endDate = endDate + ".30";
							}else {
								endDate = endDate + ".31";
							}
						}
					}
				} else if (curr_year> eyear1){
					if (eMonth1==2){
							var isleap = (eyear1 % 4 == 0 && (eyear1 % 100 != 0 || eyear1 % 400 == 0));
							if (isleap){
								endDate = endDate + ".29";
							} else {
								endDate = endDate + ".28";
							}
							
						}else {
							if (eMonth1==4||eMonth1==6||eMonth1==9||eMonth1==11){
								endDate = endDate + ".30";
							}else {
								endDate = endDate + ".31";
							}
						}
					
				}
				var diff = getDateDiffDays(startDate + ".01", endDate);
				if (diff > 0) {
					diff = 0;
					if (year == year1) {
						diff = month1 - month + 1;
					} else if (year1 > year) {
						diff = month1 - month + 1 + 12 * (year1 - year);
					}
					if (diff > limit) {
						alert("Search Months should not exceeds more than " + limit
								+ " months.");
						return false;
					}
					return true;
				} else {
					alert("Start Month should be prior to the End Month.");
					return false;
				}
			} else {
				alert('End Month cannot be later than Current Month.');
					return false;
			}
		} else {
			alert("Start Month cannot be later than  Current Month.");
			return false;
		}
	} else if (weekMonth == "Daily") {
		if (startDate == null || startDate == "" || startDate == 'undefined') {
			alert('Please Enter Start Date');
			return false;
		}
		var datePat = /^(\d{4})(\.)(\d{1,2})(\.)(\d{1,2})$/; // requires 4 digit year
		var matchArray = startDate.match(datePat); // is the format ok?
		if (matchArray == null) {
			alert( " Start Date is not in a valid format.Please enter the date in YYYY.MM.DD format.")
			return false;
		}
		if (isValidDate(startDate)) {
			if (endDate == null || endDate == "" || endDate == 'undefined') {
				alert('Please Enter End Date');
				return false;
			}
			var matchArray1 = endDate.match(datePat); // is the format ok?
			if (matchArray1 == null) {
				alert( " End Date is not in a valid format.Please enter the date in YYYY.MM.DD format.")
				return false;
			}
			if (isValidDate(endDate)) {
				var diff = getDateDiffDays(startDate, endDate);
				if (diff > limit) {
					alert("Search Dates should not exceeds more than " + limit
							+ "  days.");
					return false;
				} else if (diff < 0){
					alert("Start Date should be prior to the End Date.");
					return false;
				} else {
					return true;
				}
			}else {
				alert("End Date cannot be later than or equal to Current Date.");
				return false;
			}
			
		} else {
			alert("Start Date cannot be later than or equal to Current Date.");
			return false;
		}
	} else {
		return false;
	}
}

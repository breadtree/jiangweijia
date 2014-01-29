<script language="javascript" type="">

function checkIPList(sendObj)
 {
    if( sendObj.value =="")
        return true;
    var ipArray=sendObj.value.split(",");
    for(var ipi=0;ipi<ipArray.length;ipi++){
       if(!checkVarIP(ipArray[ipi])){
            alert("<i18n:message key='UserMSG0058400' />");
            sendObj.select();
			sendObj.focus();
			return false;
       }

       for(ipj=ipi;ipj<(ipArray.length-1);ipj++){

            if(ipArray[ipi]==ipArray[ipj+1]){
                alert("<i18n:message key='UserMSG0058401' />");
                sendObj.select();
			    sendObj.focus();
			    return false;
            }
       }
    }
    return true;

 }
//��������IP��ַ�Ϸ���
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
		alert("<i18n:message key='UserMSG0058400' />");
		Sender.select();
		Sender.focus();
		return false;
	}
	for (var i = 0; i < ymdArray.length; i++)
	{
		if (ymdArray[i].length == 0 || isNaN(ymdArray[i]))
		{
			alert("<i18n:message key='UserMSG0058400' />");
			Sender.select();
			Sender.focus();
			return false;
		}

		if (parseInt(ymdArray[i]) < 0 || parseInt(ymdArray[i]) > 255)
		{
			alert("<i18n:message key='UserMSG0058400' />");
			Sender.select();
			Sender.focus();
			return false;
		}
	}
	return true;

  }
  //��������Ƿ�Ϸ�,����������
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
			alert("<i18n:message key='UserMSG0058402' /> ' "+sChar+" '!");
			Sender.select();
			Sender.focus();
			return false;
		}
	}
	return true;
  }


  //��������Ƿ�Ϸ�,����������
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
			alert(strName +" <i18n:message key='UserMSG0058403' /> ' "+sChar+" '!");
			Sender.select();
			Sender.focus();
			return false;
		}
	}
	return true;
  }

  //��������Ƿ�Ϸ�,��������
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
			alert(strName +" <i18n:message key='UserMSG0058404' /> ' "+sChar+" '!");
			Sender.select();
			Sender.focus();
			return false;
		}
	}
	return true;
  }




  //������Ӧ����
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
//������Ӧ����:��������
  function onPassword(evn) {
    var   charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
    if (charCode == 13){
       document.forms[0].password.blur();
      userLogin();
      }

  }
	function onPassword1(evn) {
	var   charCode = (navigator.appName == "Netscape") ? evn.which : evn.keyCode;
	if (charCode == 13){
	   document.forms[1].password.blur();
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


 // ɾ���ַ�������߿ո�
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

   // ɾ���ַ������ұ߿ո�
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

   // ɾ���ַ��������߿ո�
   function trim (str) {
      if (typeof(str) != 'string')
         return '';
      var tmp = leftTrim(str);
      return rightTrim(tmp);
   }

//�ж�����ֵ�Ƿ���ȷ(��.��)
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
//�жϽ���ʱ���Ƿ���ڵ�ǰʱ��(��.��)
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
      var nowDate = currentDate.getFullYear() + month;
	  var get1Date = str.substring(0,4) + str.substring(5,7);
	  if (get1Date - nowDate > 0){

	  return false;
	  }
	  return true;
   }
 //�жϽ���ʱ���Ƿ���ڵ�ǰʱ��(��.��.��)
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
      var nowDate = currentDate.getFullYear() + month + day;
	  var get1Date = str.substring(0,4) + str.substring(5,7) + str.substring(8,10);
	  if (get1Date - nowDate > 0){

	  return false;
	  }
	  return true;
   }
   //�жϽ���ʱ���Ƿ���ڵ��ڵ�ǰʱ��(��.��.��)
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
      var nowDate = currentDate.getFullYear() + month + day;
	  var get1Date = str.substring(0,4) + str.substring(5,7) + str.substring(8,10);
	  if (get1Date - nowDate >= 0){

	  return false;
	  }
	  return true;
   }
   //add by gequanmin 2005.06.30
  //�жϽ�������Ч���Ƿ����2099.12.31(��.��.��)
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
  //�жϽ�������Ч���Ƿ���ڸ���������,��2099.12.31(��.��.��),ע��,���ж������������Ч��.
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


   //�жϽ���ʱ���Ƿ���ڵ�ǰʱ��(��.��.��.ʱ)
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
      var nowDate = currentDate.getFullYear() + month + day + hour;
	  var get1Date = str.substring(0,4) + str.substring(5,7) + str.substring(8,10) + str.substring(11,13) ;
	  if (get1Date - nowDate > 0){

	  return false;
	  }
	  return true;
   }
//�ж����������Ƿ񳬹�һ����
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
  //�ж����������Ƿ񳬹�һ��
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


  //�ж�����ֵ�Ƿ���ȷ����.��.�գ�
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

  //�ж�����ֵ�Ƿ���ȷ����.��.��.ʱ��
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
  //�ж���ֹ���������Ƿ���ȷ(��.��)
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
	//�ж���ֹ���������Ƿ���ȷ(��.��.��)
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
   //�ж���ֹ���������Ƿ���ȷ(��.��.��.ʱ)
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
   //�õ��ַ����ĳ��ȣ����ְ�2���ַ��ƣ�
function strlength(str){
  var l=str.length;
  var n=l;
  for(var i=0;i<l;i++)if(str.charCodeAt(i)<0||str.charCodeAt(i)>255)n++;
  return n;
}

//����ַ��������Ƿ񳬹�ָ������
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

   //����ַ����Ƿ���Email��ʽ
   function isEmail(strEmail) {
     return (strEmail.search(/^\w+((-\w+)|(\.\w+))*\@\w+((\.|-)\w+)*\.\w+$/) != -1);
   }
   //����ַ����Ƿ������֤
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
   //����ַ����Ƿ������ڸ�ʽ
   function isDate(strDate) {
     if(strDate.search(/^\d{4}(\.|-|\/)(0[1-9]|1[0-2])(\.|-|\/)([0-2]\d|3[0-1])$/) == -1){
       return false;
     }
     var myyear=strDate.substring(0,4);
     var mymonth=strDate.substring(5,7);
     var myday=strDate.substring(8,10);
     var mynewday = new Date(myyear,mymonth-1,myday);
     if(((myyear-mynewday.getFullYear())%100)==0)if(mymonth==(mynewday.getMonth()+1))if(myday==mynewday.getDate())return true;
     return false;
   }

   //���User number�Ƿ���ȷ
   function isUserNumber(usernumber,numbername){
      usernumber =  trim(usernumber);
      if(numbername=='')
         numbername = 'MS number';
      if(usernumber==''){
         alert(numbername+" <i18n:message key='UserMSG0058405' />");//����Ϊ��,������
         return false;
      }
      if(!checkstring('0123456789',usernumber)){
         alert(numbername+" <i18n:message key='UserMSG0058406' />");
         return false;
      }
      if(usernumber.length<7){
         alert("<i18n:message key='UserMSG0058407' />"+numbername+" <i18n:message key='UserMSG0058408' />");
         return false;
      }
/*
      var tmp = usernumber.substring(0,2);
      if((tmp!='13' && tmp!='14' && tmp!='15') && (usernumber.charAt(0)!='0')){
         alert("The input format of "+numbername+" is 0+area code+number.please re-enter!");
         //alert(numbername+"�������ʽ��: 0 + ���� + ����,����������!");
         return false;
      }
*/
      return true;
   }


   //����ƶ������ַ���,����ǰ��0
   function getStringFormat(str,len){
     var  sTmp = "" + str;
     if(str.length > len)
        return sTmp;
     while(sTmp.length < len )
        sTmp = '0' + sTmp;
     return sTmp;
   }

  //��ȡ��ǰ�����ַ���
  function getCurrentDate(){
   var today = new Date();
   return today.getFullYear() + '.' + getStringFormat(today.getMonth()+1,2) + '.' + getStringFormat(today.getDate(),2);
  }

  //��ȡ�ƶ���ǰ�������ַ���
  function getMonthPriorDate(months){
   var today = new Date();
   var year = today.getFullYear();
   year = year - Math.floor(months/12);
   var month = today.getMonth() + 1 - months%12;
    if(month<=0){
      month = 12 + month ;
      year = year - 1;
    }
    return year + '.' + getStringFormat(month,2) + '.01';
 }

 // �������Ƿ��ǡ�13������148��,��159����ͷ���ֻ���
 function isMobile(number){
    var flag = 'false';
    var tmp = number.substring(0,2);
    number =  trim(number);
    if((tmp!='13' && tmp!='14' && tmp!='15')){
       flag = 'true';
    }
    return flag;
 }


</script>

   
if(!TimerManager)
  var TimerManager =  new TimerManager_();

function TimerManager_(){
    this.List = new Array();
    this.push = function (aForm){
       this.List[aForm.name] = aForm;
    }
    this.get1 = function(name1){
        var form = this.List[name1];
        return form;
    }
    this.get = function(parentName,name1,name2,width,edit){
        var form = this.List[name1];
        if(!form){
           form = new minute(parentName,name1,name2,width,edit);
           document.write(form);
        }
        return form;
    }
    this.remove = function(key){
        this.List[key] = null;
    }
}
function minute(parentName,name,fName,width,editable)
{
        this.parentname = parentName;
	this.name = name;
        TimerManager.push(this);
        this.width=width;
	this.fName = fName || "m_input";
	this.timer = null;
	this.fObj = null;
        if(editable == false)
        this.editable = editable;
        else
        this.editable = true;

	this.toString = function()
	{
		var objDate = new Date();
		var sMinute_Common = "class=\"m_input\" maxlength=\"2\" name=\""+this.fName+"\" onfocus=\"javascript:TimerManager.get1('"+this.name+"').setFocusObj(this)\"  onblur=\"javascript:TimerManager.get1('"+this.name+"').setItemTime(this)\" onkeyup=\"javascript:TimerManager.get1('"+this.name+"').prevent(this)\" onkeypress=\"if (!/[0-9]/.test(String.fromCharCode(event.keyCode)))event.keyCode=0\" onpaste=\"return false\" ondragenter=\"return false\"";
		var sButton_Common = "class=\"m_arrow\" onfocus=\"javascript:this.blur()\" onmouseup=\"javascript:TimerManager.get1('"+this.name+"').controlTime()\" disabled"
		var str = "";
		str += "<table border=\"0\"  width=\""+this.width+"\" cellspacing=\"0\" cellpadding=\"0\">"
		str += "<tr>"
		str += "<td>"
		str += "<div class=\"m_frameborder\" >"
		str += "<input "
                if(!this.editable)
		str += "readonly "
                str += " radix=\"24\" value=\""+this.formatTime(objDate.getHours())+"\" "+sMinute_Common+">:"
		str += "<input "
                if(!this.editable)
		str += "readonly "
		str += " radix=\"60\" value=\""+this.formatTime(objDate.getMinutes())+"\" "+sMinute_Common+">:"
		str += "<input "
                if(!this.editable)
		str += "readonly "
		str += " radix=\"60\" value=\""+this.formatTime(objDate.getSeconds())+"\" "+sMinute_Common+">"
		str += "</div>"
		str += "</td>"
		str += "<td>"
		str += "<table border=\"0\" cellspacing=\"2\" cellpadding=\"0\">"
		str += "<tr><td><button id=\""+this.fName+"_up\" "+sButton_Common+">5</button></td></tr>"
		str += "<tr><td><button id=\""+this.fName+"_down\" "+sButton_Common+">6</button></td></tr>"
		str += "</table>"
		str += "</td>"
		str += "</tr>"
		str += "</table>"
                str += "<script>TimerManager.get1('"+this.name+"').initTime(); </script>"
		return str;
	}
	this.play = function()
	{
		this.timer = setInterval(this.name+".playback()",1000);
	}
	this.formatTime = function(sTime)
	{
		sTime = ("0"+sTime);
		return sTime.substr(sTime.length-2);
	}
        this.initTime = function(){
                var item = eval("document."+this.parentname+"."+this.name);
                item.value=this.getTime();
        }
	this.playback = function()
	{
		var objDate = new Date();
		var arrDate = [objDate.getHours(),objDate.getMinutes(),objDate.getSeconds()];
		var objMinute = document.getElementsByName(this.fName);
		for (var i=0;i<objMinute.length;i++)
		{
			objMinute[i].value = this.formatTime(arrDate[i])
		}
	}
	this.prevent = function(obj)
	{
		clearInterval(this.timer);
		this.setFocusObj(obj);
		var value = parseInt(obj.value,10);
		var radix = parseInt(obj.radix,10)-1;
		if (obj.value>radix||obj.value<0)
		{
			obj.value = obj.value.substr(0,1);
		}
	}
	this.controlTime = function(cmd)
	{
		event.cancelBubble = true;
		if (!this.fObj) return;
		clearInterval(this.timer);
		var cmd = event.srcElement.innerText=="5"?true:false;
		var i = parseInt(this.fObj.value,10);
		var radix = parseInt(this.fObj.radix,10)-1;
		if (i==radix&&cmd)
		{
			i = 0;
		}
		else if (i==0&&!cmd)
		{
			i = radix;
		}
		else
		{
			cmd?i++:i--;
		}
		this.fObj.value = this.formatTime(i);
		this.fObj.select();
	}
	this.setItemTime = function(obj)
	{
		obj.value = this.formatTime(obj.value);
                var item = eval("document."+this.parentname+"."+this.name);
                item.value=this.getTime();
	}
        this.setTime = function(aTime){
        	var objDate = new Date();
		var arrDate = [objDate.getHours(),objDate.getMinutes(),objDate.getSeconds()];
                if(aTime.length == 6){
                    arrDate[0] = aTime.substr(0,2);
                    arrDate[1] = aTime.substr(2,2);
                    arrDate[2] = aTime.substr(4,2);
                }else if(aTime.length == 8){
                    arrDate[0] = aTime.substr(0,2);
                    arrDate[1] = aTime.substr(3,2);
                    arrDate[2] = aTime.substr(6,2);
                }
		var objMinute = document.getElementsByName(this.fName);
		for (var i=0;i<objMinute.length;i++)
		{
			objMinute[i].value = this.formatTime(arrDate[i])
		}
                var item = eval("document."+this.parentname+"."+this.name);
                item.value=this.getTime();
        }
	this.setFocusObj = function(obj)
	{

          if(!this.editable)
             return;
          document.getElementById(this.fName+"_up").disabled = document.getElementById(this.fName+"_down").disabled  =false;
          this.fObj = obj;
	}
	this.getTime = function()
	{
		var arrTime = new Array(2);
		for (var i=0;i<document.getElementsByName(this.fName).length;i++)
		{
			arrTime[i] = document.getElementsByName(this.fName)[i].value;
		}
		return arrTime.join(":");
	}
}
function calendar(name,fName)
{
	this.name = name;
	this.fName = fName || "calendar";
	this.year = new Date().getFullYear();
	this.month = new Date().getMonth();
	this.date = new Date().getDate();
	//private
	this.toString = function()
	{
		var str = "";
		str += "<table border=\"0\" cellspacing=\"3\" cellpadding=\"0\" onselectstart=\"return false\">";
		str += "<tr>";
		str += "<td>";
		str += this.drawMonth();
		str += "</td>";
		str += "<td align=\"right\">";
		str += this.drawYear();
		str += "</td>";
		str += "</tr>";
		str += "<tr>";
		str += "<td colspan=\"2\">";
		str += "<div class=\"c_frameborder\">";
		str += "<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" class=\"c_dateHead\">";
		str += "<tr>";
		str += "<td>Sunday</td><td>Monday</td><td>Tuesday</td><td>Wednesday</td><td>Thursday</td><td>Friday</td><td>Saturday</td>";
		str += "</tr>";
		str += "</table>";
		str += this.drawDate();
		str += "</div>";
		str += "</td>";
		str += "</tr>";
		str += "</table>";
		return str;
	}
	//private
	this.drawYear = function()
	{
		var str = "";
		str += "<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">";
		str += "<tr>";
		str += "<td>";
		str += "<input class=\"c_year\" maxlength=\"4\" value=\""+this.year+"\" name=\""+this.fName+"\" id=\""+this.fName+"_year\" readonly>";
		//DateField
		str += "<input type=\"hidden\" name=\""+this.fName+"\" value=\""+this.date+"\" id=\""+this.fName+"_date\">";
		str += "</td>";
		str += "<td>";
		str += "<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\">";
		str += "<tr>";
		str += "<td><button class=\"c_arrow\" onfocus=\"this.blur()\" onclick=\"event.cancelBubble=true;document.getElementById('"+this.fName+"_year').value++;"+this.name+".redrawDate()\">5</button></td>";
		str += "</tr>";
		str += "<tr>";
		str += "<td><button class=\"c_arrow\" onfocus=\"this.blur()\" onclick=\"event.cancelBubble=true;document.getElementById('"+this.fName+"_year').value--;"+this.name+".redrawDate()\">6</button></td>";
		str += "</tr>";
		str += "</table>";
		str += "</td>";
		str += "</tr>";
		str += "</table>";
		return str;
	}
	//priavate
	this.drawMonth = function()
	{
		var aMonthName = ["January","February","March","April","May","June","July","August","September","October","November","December"];
		var str = "";
		str += "<select class=\"c_month\" name=\""+this.fName+"\" id=\""+this.fName+"_month\" onchange=\""+this.name+".redrawDate()\">";
		for (var i=0;i<aMonthName.length;i++) {
			str += "<option value=\""+(i+1)+"\" "+(i==this.month?"selected":"")+">"+aMonthName[i]+"</option>";
		}
		str += "</select>";
		return str;
	}
	//private
	this.drawDate = function()
	{
		var str = "";
		var fDay = new Date(this.year,this.month,1).getDay();
		var fDate = 1-fDay;
		var lDay = new Date(this.year,this.month+1,0).getDay();
		var lDate = new Date(this.year,this.month+1,0).getDate();
		str += "<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" id=\""+this.fName+"_dateTable"+"\">";
		for (var i=1,j=fDate;i<7;i++)
		{
			str += "<tr>";
			for (var k=0;k<7;k++)
			{
				str += "<td><span"+(j==this.date?" class=\"selected\"":"")+" onclick=\""+this.name+".redrawDate(this.innerText)\">"+(isDate(j++))+"</span></td>";
			}
			str += "</tr>";
		}
		str += "</table>";
		return str;

		function isDate(n)
		{
			return (n>=1&&n<=lDate)?n:"";
		}
	}
	//public
	this.redrawDate = function(d)
	{
		this.year = document.getElementById(this.fName+"_year").value;
		this.month = document.getElementById(this.fName+"_month").value-1;
		this.date = d || this.date;
		document.getElementById(this.fName+"_year").value = this.year;
		document.getElementById(this.fName+"_month").selectedIndex = this.month;
		document.getElementById(this.fName+"_date").value = this.date;
		if (this.date>new Date(this.year,this.month+1,0).getDate()) this.date = new Date(this.year,this.month+1,0).getDate();
		document.getElementById(this.fName+"_dateTable").outerHTML = this.drawDate();
	}
	//public
	this.getDate = function(delimiter)
	{
		if (!delimiter) delimiter = "/";
		var aValue = [this.year,(this.month+1),this.date];
		return aValue.join(delimiter);
	}
}


function splitString(str,separator)
{
   if (!(str)) return new Array(0);
   if (!(separator)) return new Array(str);
   var List = new Array(0);
   var tmpStr = "";
   var index = 0;
   while (str)
   {  index = str.indexOf(separator);
      if (index < 0)    //没有找到
      { List.push(str);
        str = null;
        break;
      }
      else if (index ==0)  // 分隔符号前面没有其它字符
         str = str.substr(index + separator.length);
      else
      {    tmpStr = str.substring(0,index);
           List.push(tmpStr);
      	   str = str.substr(index + separator.length);
      }
   }
   return List;
}

function saveRowSet(aUrl,aRowSets){
   if (aRowSets == null || aRowSets.length == 0){
     // alert("没有设置需要保存的数据集!");
     alert("No any data is set to save!");
      return ;
   }
   var tmpstr  = "<?xml version ='1.0' encoding ='UTF-8'?>\n\n<ROOT>"
   for(var i =0 ; i < aRowSets.length;i ++)
       tmpstr = tmpstr + aRowSets[i].toXml();
   tmpstr = tmpstr   + "</ROOT>";
//   alert(tmpstr);
//   alert(aUrl);
   var domdoc=PostInfotoServer(aUrl,tmpstr);
   return domdoc;
}

function showMessage(point,str){  alert(point + ":" +str);}
function showDebugger(point,str){  alert(point + ":" +str);}
function showWarnning(point,str){  alert(point + ":" +str);}
function showError(point,str){  alert(point + ":" +str);}


function messagebox(hintContent){
     return window.showModalDialog("messagebox.htm",hintContent,"scroll:no;resizable:no;status:no;dialogHeight:150px;dialogWidth:300px");
}


function indexOfArray(arr,data)
{ var result = -1;
  if(arr)
   for(var i=0;i<arr.length;i++)
   { //alert(i+ '---' + data +'---' + arr.toString());
     if (arr[i] == data)
     {
       result =  i;
       break;
     }
   }
  //alert( result + '---' + arr.toString() + '---' + data );
  return result;
}

function arrayRemove(a,index)
{
    for(var i=index;i<a.length -1;i++)
      a[i] = a[i +1];
    a.length = a.length - 1;
    return a;
}
function arrayRemoveNoSort(a,index)
{
    a[index] = a[a.length - 1];
    a.pop();
    return a;
}

function getXmlNodeFromStr(str)
{
      var xml= new ActiveXObject("Msxml.DOMDocument");
      xml.async = false;
      xml.load(str);
      return xml.documentElement;
}

/**------------------------------------------------------------------------
 Browser detect
 currently supported browser:
 ie5.5+ netscape7.1+ mozilla1.4+ firefox0.8+ safari1.2.1+
------------------------------------------------------------------------*/


var agt = navigator.userAgent.toLowerCase();
var is_ie = (agt.indexOf("msie") != -1);
var is_ie5 = (agt.indexOf("msie 5") != -1);
var is_opera = (agt.indexOf("opera") != -1);
var is_mac = (agt.indexOf("mac") != -1);
var is_gecko = (agt.indexOf("gecko") != -1);
var is_safari = (agt.indexOf("safari") != -1);

//------------------------------------------------------------------------
// Communication with server
//------------------------------------------------------------------------

function CreateXmlHttpReq() {

  var xmlhttp = null;
  if (is_ie) {
    // Guaranteed to be ie5 or ie6
    var control = (is_ie5) ? "Microsoft.XMLHTTP" : "Msxml2.XMLHTTP";

    try {
      xmlhttp = new ActiveXObject(control);
    } catch (ex) {
      // TODO: better help message
      alert("You need to enable active scripting and activeX controls");
    }

  } else {
    // Mozilla
    xmlhttp = new XMLHttpRequest();
  }

  return xmlhttp;
}
function showDelayMessage(){
	msgWindow=open("","serverDelayMessage",'top='+((screen.height-40)/2)+',left='+((screen.width-250)/2)+'toolbar=0,directories=0,width=250,height=40, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=n o, status=no,menubar=0');
	var message ="<table cellspacing=\"2\" cellpadding=\"2\" width=\"100%\" border=\"0\" height=\"95%\" valign=\"middle\" style=\"font-family:MS Sans Serif; font-size:8px;\">"
        message+= "<tr><td align=\"right\"><img border=\"0\" src=\"/colorring/base/image/busy.gif\"></td>"
        message+= "<td ><span id=\"msgTextSpan\" style=\"FONT-WEIGHT: bold;FONT-SIZE: 11px;FONT-FAMILY: verdana\">"
        message+= "Being processed, please wait...</span></td></tr></table>"
        msgWindow.document.write(message);
        return msgWindow;
}

function xmlRequest(url){
	var aUrl =  MODULE_NAME +url;
  	var domdoc = PostInfotoServer(aUrl,null);
  
   	if(domdoc){
		var result = domdoc.getElementsByTagName("MSG");
    	var failed = false;
        if(result){
        	var size = result.length;
            var info = "";
            for(var i =0;i<size;i++){
            	var v = result.item(i).attributes.getNamedItem("TYPE");;
                if(v.nodeValue=='ERROR')
                	failed = true;
                info += result.item(i).text+"\n";
            }
          	if(info!='')
            	showMessage('Help information:'+info);
            }
           
            if(!failed){
                var result = domdoc.getElementsByTagName("DATA").item(0);     
                var children = result.childNodes;
                var size = children.length;
                var results = new Array(size);
                for(var i =0;i<size;i++){
                    var value = children.item(i).text;
                    results[i] = value;
                }
                return results;
            }
        }
}

//sunqi 2006-06-16,提供一个可以替代xmlRequest()的等价方法,接口不变
function xmlRequest1(reqUrl)
{
	var Http = CreateXmlHttpReq();
	//var Dom = new ActiveXObject("Microsoft.XMLDOM"); 
	var Dom = new ActiveXObject("Msxml.DOMDocument");
	Http.open("POST",reqUrl,false);
	Http.SetRequestHeader("content-Type","text/xml;charset=UTF-8");
	//post方式
	//Http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	
	Http.send();                      //开始发送数据
    Dom.async=false;                  //设置为同步方式获取数据
    Dom.loadXML(Http.responseText);
    if(Dom.parseError.errorCode != 0) //检查是否发生获取数据时错误
    {
		return ;
    }
    else
    {
		var result = Dom.getElementsByTagName("DATA").item(0);
   		var children = result.childNodes;
   		var size = children.length;
      	var results = new Array(size);
      	for(var i =0;i<size;i++){
      		var value = children.item(i).text;
         	results[i] = value;
      	}
      	return results;
		/*
			也可以这样:
		var results = new Array(2);
		results[0]= Dom.documentElement.childNodes.item(0).text ;
		results[1]= Dom.documentElement.childNodes.item(1).text ;
		但这样要求返回信息必须为有两个<RESULT >,第一个表示是否成功(0成功),第二个是info
		<DATA>
			<RESULT >0</RESULT>
			<RESULT >Info</RESULT>
		</DATA>
		*/
	}
}



function PostInfotoServer(url,xml){
    if(url==null)
       return;
     var v= showDelayMessage();
//    var XMLSender = new ActiveXObject("Microsoft.XMLHTTP");
    var XMLSender = CreateXmlHttpReq();
    XMLSender.Open("POST",url,false);
//      goole usecase
//    XMLSender.Open("POST",url,true);
    XMLSender.SetRequestHeader("content-Type","text/xml;charset=UTF-8");
    if(xml ==null)
        XMLSender.send();
    else
        XMLSender.send((xml));
         
    var xmldata = getXmlNodeFromStr(XMLSender.responseXML);
    v.close();
    return xmldata;
}


/**
 * 获取最高级的window对象
 */
function getTopWin()
{
  if (window.name == "WebFrameSet")
  {
    return window;
  }
  var w = window;
  if (window == window.parent)
  {
    if (window.opener)
    {
        w = window.opener;
    }
    else
    {
        return window;
    }
  }
  else
  {
    w = window.parent;
  }
  while (w.opener && (w != w.opener))
  {
    if (w.name == "WebFrameSet")
    {
      return w;
    }
    w = w.opener;
  }
  return w;
}

//对条件字符串中的特殊字符进行编码
function g_ConditonStrEncode(pStr)
{
   if(pStr==null || pStr=="") return pStr;

   var reStr = pStr;
   //对"%"进行转化
   reStr = reStr.replace(/%/g,'%25');
   //对"="进行转化
   reStr = reStr.replace(/=/g,'%3D');
   //对"+"进行转化
   reStr = reStr.replace(/[+]/g,'%2B');

   return reStr;
}

function g_ConditonStrDecode(pStr)
{
   if(pStr==null || pStr=="") return pStr;

   var reStr = pStr;
   //对"%"进行转化
   reStr = reStr.replace('%25','%');
   //对"="进行转化
   reStr = reStr.replace('%3D','=');
   //对"+"进行转化
   reStr = reStr.replace('%2B','+');

   return reStr;
}

function compare(str1,str2){
    if(str1 == null &&str2 == null)
        return true;
    if(str1 == null ||str2 == null)
        return false;
    if(str1 == str2)
        return true;
    return false;
}
//进行特殊字符替换
function g_CheckAndTransStr(str)
  {
    str = str.toString();
    if(str=="") return str;
    strArray=str.split("&");
    tmpStr=strArray[0];
    if(strArray.length>1)
	for(i=1;i<strArray.length;i++)
    {
      tmpStr+="&amp;";
      tmpStr+=strArray[i];
    }
    str=tmpStr;
    while(str.indexOf(">")>=0)
    {
      index=str.indexOf(">");
      str=str.substring(0,index)+"&gt;"+str.substring(index+1,str.length);
    }
    while(str.indexOf("<")>=0)
    {
      index=str.indexOf("<");
      str=str.substring(0,index)+"&lt;"+str.substring(index+1,str.length);
    }
    while(str.indexOf("'")>=0)
    {
      index=str.indexOf("'");
      str=str.substring(0,index)+"&apos;"+str.substring(index+1,str.length);
    }
    while(str.indexOf('"')>=0)
    {
      index=str.indexOf('"');
      str=str.substring(0,index)+"&quot;"+str.substring(index+1,str.length);
    }
    return str;
  }



function checkKey(key){
    if(key==2){//number
        var keyCode = window.event.keyCode;
        if ((keyCode >=48 && keyCode <=57))
	    return true;
        window.event.returnValue = false;
        return false;
    }else if(key==3){//float
        var keyCode = window.event.keyCode;
        if ((keyCode >=48 && keyCode <=57)||(keyCode == 46))
	    return true;
        window.event.returnValue = false;
        return false;
    }else if(key==4){//int
        var keyCode = window.event.keyCode;
        if ((keyCode >=48 && keyCode <=57))
	    return true;
        window.event.returnValue = false;
        return false;
    }
}
function g_getStringLength(str){
  if(str == null)
     return 0;
  var len = 0;
  for(var i=0;i<str.length;i++)
    if(str.charCodeAt(i) > 255)
      len =len + 2;
    else
      len = len + 1;
  return len;
}

function verifyText(str,minlen,maxlen){
    if( maxlen !=-1){
        if(g_getStringLength(str) > maxlen)
        return "Data exceeds the length limit:" + maxlen +" Characters!";
    }
    if( minlen !=-1){
        if(g_getStringLength(str) < minlen)
        return "The minimal data length is:" + minlen +" Characters!";
    }
    var keyCode;
    for(var i=0; i < str.length; i++)
    {
	keyCode = str.charCodeAt(i);
	if ((keyCode == 38)||(keyCode == 39)||(keyCode == 60))
	{
	   return "Contain illegal character :'"+str.substr(i,1)+"'!!";
	}
    }

}
function clearMessage(){
    if(document.all("messagearea"))
        document.all("messagearea").innerText="";
}
function showMessage(message){
    if(document.all("messagearea")){
        document.all("messagearea").innerText=message;
    }else if(trim(message)!='')
    alert(message);
}

function verifyFloat(str,maxlen){
    if( maxlen !=-1){
        if (str.length > maxlen )
        return "Data exceeds the length limit:" + maxlen +" Characters!";
    }
    var keyCode;
    for(var i=0; i < str.length; i++)
    {
	keyCode = str.charCodeAt(i);
        if (!((keyCode >=48 && keyCode <=57)||(keyCode == 46)))
	{
	    return "Contain illegal character :'"+str.substr(i,1)+"'!!";
    	}
    }
}
function verifyInt(str,maxlen){
    if( maxlen !=-1){
        if (str.length > maxlen )
        return  "Data exceeds the length limit:" + maxlen +" Characters!"
    }
    var keyCode;
    for(var i=0; i < str.length; i++)
    {
	keyCode = str.charCodeAt(i);
        if (!((keyCode >=48 && keyCode <=57)))
	{
	     return "Contain illegal character :'"+str.substr(i,1)+"'!!";
    	}
    }
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
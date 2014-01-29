<script language="javascript" type="">
/********************************************************************
时间:2004-01-01
作者:Smart
功能:日历式日期选择控件
********************************************************************/
/*基本参数*/
var Frw=150; //日历宽度
var Frh=165; //日历高度
var Frs=4;     //影子大小
var Hid=true;//日历是否打开
/*创建框架*/
document.writeln('<Div id=Calendar Author=smart  scrolling="no" frameborder=0 style="border:0px solid #EEEEEE ;position: absolute; width: '+Frw+'; height: '+Frh+'; z-index: 0; filter :\'progid:DXImageTransform.Microsoft.Shadow(direction=135,color=#AAAAAA,strength='+Frs+')\' ;display: none"></Div>');
/*取得今日日期*/
function GetTodayDate()
{
   today= new Date();
   y= today.getFullYear();
   m= (today.getMonth() + 1);
   if (m<10)
   {
     m='0'+m;
   }
   d= today.getDate();
   if (d<10)
   {
     d='0'+d;
   }
return y+'.'+m+'.'+d
}
/*输入今天日期*/
function SetTodayDate(InputBox)
{
  HiddenCalendar();
  InputBox.value=GetTodayDate();
}
/*取某年某月第一天的星期值(月份-1)*/
function GetFirstWeek(The_Year,The_Month)
{
  return (new Date(The_Year,The_Month-1,1)).getDay()
}
/*取某年某月中总天数*/
function GetThisDays(The_Year,The_Month)
{
  return (new Date(The_Year,The_Month,0)).getDate()
}
/*取某年某月上个月中总天数*/
function GetLastDays(The_Year,The_Month)
{
  return (new Date(The_Year,The_Month-1,0)).getDate()
}
/*判断是否是闰年*/
function RunNian(The_Year)
{
 if ((The_Year%400==0) || ((The_Year%4==0) && (The_Year%100!=0)))
  return true;
 else
  return false;
}
/* 判断日期(YYYY-MM-DD)的日期是否正确 */
function DateIsTrue(asDate){
 var lsDate  = asDate + "";
 var loDate  = lsDate.split(".");
 if (loDate.length!=3) return false;
 var liYear  = parseFloat(loDate[0]);
 var liMonth = parseFloat(loDate[1]);
 var liDay   = parseFloat(loDate[2]);
 if ((loDate[0].length>4)||(loDate[1].length>2)||(loDate[2].length>2)) return false;
 if (isNaN(liYear)||isNaN(liMonth)||isNaN(liDay)) return false;
 if ((liYear<1800)||(liYear>2500)) return false;
 if ((liMonth>12)||(liMonth<=0))   return false;
 if (GetThisDays(liYear,liMonth)<liDay) return false;
 return !isNaN(Date.UTC(liYear,liMonth,liDay));
}
/*取某年某月的周值*/
function GetCountWeeks(The_Year,The_Month)
{
 var Allday;
 Allday = 0;
 if (The_Year>2000)
 {

  for (i=2000 ;i<The_Year; i++)
   if (RunNian(i))
    Allday += 366;
   else
    Allday += 365;
  for (i=2; i<=The_Month; i++)
  {
   switch (i)
   {
      case 2 :
       if (RunNian(The_Year))
        Allday += 29;
       else
        Allday += 28;
       break;
      case 3 : Allday += 31; break;
      case 4 : Allday += 30; break;
      case 5 : Allday += 31; break;
      case 6 : Allday += 30; break;
      case 7 : Allday += 31; break;
      case 8 : Allday += 31; break;
      case 9 : Allday += 30; break;
      case 10 : Allday += 31; break;
      case 11 : Allday += 30; break;
      case 12 :  Allday += 31; break;
   }
  }
 }
return (Allday+6)%7;
}
/*输入框显示*/
function InputValue(InputBox,Year,Month,Day)
{
  if (Month<10)
  {
    Month='0'+Month
  }
  if (Day<10)
  {
    Day='0'+Day
  }
  InputBox.value=Year+"."+Month+"."+Day
}
//上一月
function ForwardMonth(InputBox,Year,Month,Day)
{
    Month=Month-1;
    if (Month<1)
    {
        Month=12;
        Year=Year-1;
        if (Year<1800)
            Year=2500;
    }
  Day=((GetThisDays(Year,Month)<Day)?GetThisDays(Year,Month):Day)
  Hid=false;
  ShowCalendar(InputBox,Year,Month,Day)
}
//下一月
function NextMonth(InputBox,Year,Month,Day)
{
    Month=Month+1;
    if (Month>12)
    {
        Month=1;
        Year=Year+1;
        if (Year>2500)
            Year=1800;
    }
  Day=((GetThisDays(Year,Month)<Day)?GetThisDays(Year,Month):Day)
  Hid=false;
  ShowCalendar(InputBox,Year,Month,Day)
}
//上一年
function ForwardYear(InputBox,Year,Month,Day)
{
    Year=Year-1;
    if (Year<1800)
        Year=2500;
  Day=((GetThisDays(Year,Month)<Day)?GetThisDays(Year,Month):Day)
  Hid=false;
  ShowCalendar(InputBox,Year,Month,Day)
}
//下一年
function NextYear(InputBox,Year,Month,Day)
{
    Year=Year+1;
    if (Year>2500)
        Year=1800;
  Day=((GetThisDays(Year,Month)<Day)?GetThisDays(Year,Month):Day)
  Hid=false;
  ShowCalendar(InputBox,Year,Month,Day)
}
/*其它事件显示日历*/
function OpenDate(where)
{
 //GetCalendar(where)  //v5.06.03 onwards using jquery calender, so commented out
}
/*根据输入框中的日期显示日历*/
function GetCalendar(where)
{
    Hid=false;
    var Box_Name=where.name;
    var Box_value=where.value;
    if (DateIsTrue(Box_value))
    {
    loDate  = Box_value.split(".");
    Y= parseFloat(loDate[0]);
    M= parseFloat(loDate[1]);
    D= parseFloat(loDate[2]);
    ShowCalendar(where,Y,M,D);
    }
  else
  {
    today= new Date();
    y= today.getFullYear();
    m= (today.getMonth() + 1);
    d=today.getDate();
    ShowCalendar(where,y,m,d);
  }
}

/*隐藏日历*/
function HiddenCalendar()
{
    document.all.Calendar.style.display="none";
}
function CloseCalendar()
{
  if (Hid)
    document.all.Calendar.style.display="none";
  Hid=true;
}
/*显示日历*/
function ShowCalendar(InputBox,The_Year,The_Month,The_Day)
{
    var Now_Year=(The_Year==null?2004:The_Year);
    var Now_Month=(The_Month==null?1:The_Month);
    var Now_Day=(The_Day==null?1:The_Day);
    var Box_Name='window.document.all.'+InputBox.name;
    var fw=GetFirstWeek(Now_Year,Now_Month);
    var ld=GetLastDays(Now_Year,Now_Month);
    var td=GetThisDays(Now_Year,Now_Month);
    var isnd=false;//是否是下个月的日期
    var d=1,w=1;
    var Fmshow;
    var Frl,Frt,Winw,Winh;

    if(Now_Month<10)
    	Now_Month ="0"+Now_Month;

/*显示的位置*/
Winw=document.body.offsetWidth;
Winh=document.body.offsetHeight;
Frl=InputBox.getBoundingClientRect().left-2;
Frt=InputBox.getBoundingClientRect().top+InputBox.clientHeight;
if (((Frl+Frw+Frs)>Winw)&&(Frw+Frs<Winw))
  Frl=Winw-Frw-Frs;
if ((Frt+Frh+Frs>Winh)&&(Frh+Frs<Winh))
  Frt=Winh-Frh-Frs;
document.all.Calendar.style.display="";
document.all.Calendar.style.left=Frl-50;
document.all.Calendar.style.top=Frt;
//显示日历内容
Fmshow="\n<table onselectstart=\"return false;\" border='0' cellpadding='0' cellspacing='0' bgcolor='#395592' width='100%' style=\"color:white;font-weight:bolder;border:0px solid\">"+"\n<tr>\n";
Fmshow+="<td class=\"showtd\">";
Fmshow+="<img src='image/menu_ico4.gif' border='0' alt='Last Year' style='cursor:hand' onclick=\"ForwardYear (window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+Now_Day+")\">";
Fmshow+="</td>\n";
Fmshow+="<td class=\"showtd\" vAlign=middle align='center'>&nbsp;";
Fmshow+=Now_Year;
Fmshow+="</td>\n";
Fmshow+="<td class=\"showtd\" vAlign=middle align='center'>";
Fmshow+="&nbsp;Year&nbsp;";
Fmshow+="</td>\n";
Fmshow+="<td class=\"showtd\">";
Fmshow+="<img src='image/menu_ico2.gif' border='0' alt='Next Year' style='cursor:hand' onclick=\"NextYear (window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+Now_Day+")\">";
Fmshow+="</td>\n";
Fmshow+="<td class=\"showtd\">";
Fmshow+="<img src='image/menu_ico4.gif' border='0' alt='Last Month' style='cursor:hand' onclick=\"ForwardMonth (window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+Now_Day+")\">";
Fmshow+="</td>\n";
Fmshow+="<td class=\"showtd\" vAlign=middle align='center'>&nbsp;";
Fmshow+=Now_Month;
Fmshow+="</td>\n";
Fmshow+="<td class=\"showtd\" vAlign=middle align='center'>";
Fmshow+="&nbsp;Month&nbsp;";
Fmshow+="</td>\n";
Fmshow+="<td class=\"showtd\">";
Fmshow+="<img src='image/menu_ico2.gif' border='0' alt='Next Month' style='cursor:hand' onclick=\"NextMonth (window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+Now_Day+")\">";
Fmshow+="</td>"+"\n";
Fmshow+="</tr>"+"\n";
Fmshow+="</table>"+"\n";
Fmshow+="<table onselectstart=\"return false;\" border='0' cellpadding='2' cellspacing='1' width='100%' bgcolor='#CCCCCC'>"+"\n";
Fmshow+="<tr bgcolor='#F5F5F5'>"+"\n";
Fmshow+="<td class=\"showtd\"><center><i18n:message key='UserMSG0058100' /></center></td>"+"\n";
Fmshow+="<td class=\"showtd\"><center><i18n:message key='UserMSG0058101' /></center></td>"+"\n";
Fmshow+="<td class=\"showtd\"><center><i18n:message key='UserMSG0058102' /></center></td>"+"\n";
Fmshow+="<td class=\"showtd\"><center><i18n:message key='UserMSG0058103' /></center></td>"+"\n";
Fmshow+="<td class=\"showtd\"><center><i18n:message key='UserMSG0058104' /></center></td>"+"\n";
Fmshow+="<td class=\"showtd\"><center><i18n:message key='UserMSG0058105' /></center></td>"+"\n";
Fmshow+="<td class=\"showtd\"><center><font color='#FF0000'><i18n:message key='UserMSG0058106' /></font></center></td>"+"\n";
Fmshow+="</tr>"+"\n";
//如果本月第一天是星期一或星期天.应加上七.保证可以看到上个月的日期
    if (fw<2)
      tf=fw+7;
    else
      tf=fw;
      Fmshow+="<tr bgcolor='#FFFFFF'>"+"\n";
      //第一行上月日期
      for (l=(ld-tf+2);l<=ld;l++)
      {
        Fmshow+="<td class=\"showtd\"  onclick=\"ForwardMonth (window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+l+")\" style='cursor:hand'><center><font color='#BBBBBB'>"+l+"</font></center></td>"+"\n";
        w++;
      }
      //第一行本月日期
      for (f=tf;f<=7;f++)
      {
         //星期天但非输入日期
         if (((w%7)==0)&&(d!=Now_Day))
           Fmshow+="<td class=\"showtd\" onMouseOver=\"this.style.background=\'#E1E1E1\'\" onMouseOut=\"this.style.background=\'#FFFFFF\'\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\" style='cursor:hand'><center><font color='#FF0000'>"+d+"</font></center></td>"+"\n";
         //日期为输入日期
         else if (d==Now_Day)
           Fmshow+="<td class=\"showtd\" style=\"background:#420042;cursor:hand\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\"><center><font color='#FFFFFF'>"+d+"</font></center></td>"+"\n";
         //其它
         else
           Fmshow+="<td class=\"showtd\" onMouseOver=\"this.style.background=\'#E1E1E1\'\" onMouseOut=\"this.style.background=\'#FFFFFF\'\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\" style='cursor:hand'><center>"+d+"</center></td>"+"\n";
        d++;
        w++;
      }
      Fmshow+="</tr>"+"\n";
    w=1;
    for (i=2;i<7;i++)
    {
      Fmshow+="<tr bgcolor='#FFFFFF'>"+"\n";
      for (j=1;j<8;j++)
      {
         if (isnd)//下个月的日期
         Fmshow+="<td class=\"showtd\" style='cursor:hand' onclick=\"NextMonth (window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+")\"><center><font color='#BBBBBB'>"+d+"</font></center></td>"+"\n";
         else//本月的日期
        {
           //星期天但非输入日期
           if (((w%7)==0)&&(d!=Now_Day))
             Fmshow+="<td class=\"showtd\" onMouseOver=\"this.style.background=\'#E1E1E1\'\" onMouseOut=\"this.style.background=\'#FFFFFF\'\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\" style='cursor:hand'><center><font color='#FF0000'>"+d+"</font></center></td>"+"\n";
           //日期为输入日期
           else if (d==Now_Day)
             Fmshow+="<td class=\"showtd\" style=\"background:#420042;cursor:hand\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\"><center><font color='#FFFFFF'>"+d+"</font></center></td>"+"\n";
           //其它
           else
             Fmshow+="<td class=\"showtd\" onMouseOver=\"this.style.background=\'#E1E1E1\'\" onMouseOut=\"this.style.background=\'#FFFFFF\'\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\" style='cursor:hand'><center>"+d+"</center></td>"+"\n";
        }
        //判断是否为本月的日期
        if (d==td)
        {
          isnd=true;
          d=0;
        }
        w++;
        d++;
      }
      Fmshow+="</tr>"+"\n";
    }
Fmshow+="</table>"+"\n";
Fmshow+="<table onselectstart=\"return false;\" cellpadding='1' cellspacing='0' bgcolor='#F5F5F5' width='100%'>"+"\n<tr>\n";
Fmshow+="<td class=\"showtd\" title=\"<i18n:message key='UserMSG0058107' />"+GetTodayDate()+"\" style=\"cursor:hand\" onclick=\"SetTodayDate(window.document.all."+InputBox.name+")\">";
Fmshow+="<font color=red><i18n:message key='UserMSG0058107' /></font>"+GetTodayDate();
Fmshow+="</td>\n";
Fmshow+="<td class=\"showtd\">";
Fmshow+="<img src='image/menu_ico3.gif' border='0' alt='Close' style='cursor:hand' onclick=\"HiddenCalendar()\">";
Fmshow+="</td>\n";
Fmshow+="</tr>\n";
document.all.Calendar.innerHTML=Fmshow;
document.all.Calendar.style.display="";
}
document.onclick = CloseCalendar;
</script>

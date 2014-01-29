<script language="javascript" type="">
/********************************************************************
ʱ��:2004-01-01
����:Smart
����:����ʽ����ѡ��ؼ�
********************************************************************/
/*��������*/
var Frw=150; //�������
var Frh=165; //�����߶�
var Frs=4;     //Ӱ�Ӵ�С
var Hid=true;//�����Ƿ��
/*�������*/
document.writeln('<Div id=Calendar Author=smart  scrolling="no" frameborder=0 style="border:0px solid #EEEEEE ;position: absolute; width: '+Frw+'; height: '+Frh+'; z-index: 0; filter :\'progid:DXImageTransform.Microsoft.Shadow(direction=135,color=#AAAAAA,strength='+Frs+')\' ;display: none"></Div>');
/*ȡ�ý�������*/
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
/*�����������*/
function SetTodayDate(InputBox)
{
  HiddenCalendar();
  InputBox.value=GetTodayDate();
}
/*ȡĳ��ĳ�µ�һ�������ֵ(�·�-1)*/
function GetFirstWeek(The_Year,The_Month)
{
  return (new Date(The_Year,The_Month-1,1)).getDay()
}
/*ȡĳ��ĳ����������*/
function GetThisDays(The_Year,The_Month)
{
  return (new Date(The_Year,The_Month,0)).getDate()
}
/*ȡĳ��ĳ���ϸ�����������*/
function GetLastDays(The_Year,The_Month)
{
  return (new Date(The_Year,The_Month-1,0)).getDate()
}
/*�ж��Ƿ�������*/
function RunNian(The_Year)
{
 if ((The_Year%400==0) || ((The_Year%4==0) && (The_Year%100!=0)))
  return true;
 else
  return false;
}
/* �ж�����(YYYY-MM-DD)�������Ƿ���ȷ */
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
/*ȡĳ��ĳ�µ���ֵ*/
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
/*�������ʾ*/
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
//��һ��
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
//��һ��
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
//��һ��
function ForwardYear(InputBox,Year,Month,Day)
{
    Year=Year-1;
    if (Year<1800)
        Year=2500;
  Day=((GetThisDays(Year,Month)<Day)?GetThisDays(Year,Month):Day)
  Hid=false;
  ShowCalendar(InputBox,Year,Month,Day)
}
//��һ��
function NextYear(InputBox,Year,Month,Day)
{
    Year=Year+1;
    if (Year>2500)
        Year=1800;
  Day=((GetThisDays(Year,Month)<Day)?GetThisDays(Year,Month):Day)
  Hid=false;
  ShowCalendar(InputBox,Year,Month,Day)
}
/*�����¼���ʾ����*/
function OpenDate(where)
{
 //GetCalendar(where)  //v5.06.03 onwards using jquery calender, so commented out
}
/*����������е�������ʾ����*/
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

/*��������*/
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
/*��ʾ����*/
function ShowCalendar(InputBox,The_Year,The_Month,The_Day)
{
    var Now_Year=(The_Year==null?2004:The_Year);
    var Now_Month=(The_Month==null?1:The_Month);
    var Now_Day=(The_Day==null?1:The_Day);
    var Box_Name='window.document.all.'+InputBox.name;
    var fw=GetFirstWeek(Now_Year,Now_Month);
    var ld=GetLastDays(Now_Year,Now_Month);
    var td=GetThisDays(Now_Year,Now_Month);
    var isnd=false;//�Ƿ����¸��µ�����
    var d=1,w=1;
    var Fmshow;
    var Frl,Frt,Winw,Winh;

    if(Now_Month<10)
    	Now_Month ="0"+Now_Month;

/*��ʾ��λ��*/
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
//��ʾ��������
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
//������µ�һ��������һ��������.Ӧ������.��֤���Կ����ϸ��µ�����
    if (fw<2)
      tf=fw+7;
    else
      tf=fw;
      Fmshow+="<tr bgcolor='#FFFFFF'>"+"\n";
      //��һ����������
      for (l=(ld-tf+2);l<=ld;l++)
      {
        Fmshow+="<td class=\"showtd\"  onclick=\"ForwardMonth (window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+l+")\" style='cursor:hand'><center><font color='#BBBBBB'>"+l+"</font></center></td>"+"\n";
        w++;
      }
      //��һ�б�������
      for (f=tf;f<=7;f++)
      {
         //�����쵫����������
         if (((w%7)==0)&&(d!=Now_Day))
           Fmshow+="<td class=\"showtd\" onMouseOver=\"this.style.background=\'#E1E1E1\'\" onMouseOut=\"this.style.background=\'#FFFFFF\'\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\" style='cursor:hand'><center><font color='#FF0000'>"+d+"</font></center></td>"+"\n";
         //����Ϊ��������
         else if (d==Now_Day)
           Fmshow+="<td class=\"showtd\" style=\"background:#420042;cursor:hand\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\"><center><font color='#FFFFFF'>"+d+"</font></center></td>"+"\n";
         //����
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
         if (isnd)//�¸��µ�����
         Fmshow+="<td class=\"showtd\" style='cursor:hand' onclick=\"NextMonth (window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+")\"><center><font color='#BBBBBB'>"+d+"</font></center></td>"+"\n";
         else//���µ�����
        {
           //�����쵫����������
           if (((w%7)==0)&&(d!=Now_Day))
             Fmshow+="<td class=\"showtd\" onMouseOver=\"this.style.background=\'#E1E1E1\'\" onMouseOut=\"this.style.background=\'#FFFFFF\'\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\" style='cursor:hand'><center><font color='#FF0000'>"+d+"</font></center></td>"+"\n";
           //����Ϊ��������
           else if (d==Now_Day)
             Fmshow+="<td class=\"showtd\" style=\"background:#420042;cursor:hand\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\"><center><font color='#FFFFFF'>"+d+"</font></center></td>"+"\n";
           //����
           else
             Fmshow+="<td class=\"showtd\" onMouseOver=\"this.style.background=\'#E1E1E1\'\" onMouseOut=\"this.style.background=\'#FFFFFF\'\" onClick=\"InputValue(window.document.all."+InputBox.name+","+Now_Year+","+Now_Month+","+d+");HiddenCalendar()\" style='cursor:hand'><center>"+d+"</center></td>"+"\n";
        }
        //�ж��Ƿ�Ϊ���µ�����
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

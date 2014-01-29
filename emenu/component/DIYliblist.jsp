<%@ page import="zte.zxyw50.UserAccount" %>
<%@ page import="com.zte.tao.constant.SessionConstant" %>
<%@include file="../../base/included.jsp"%>
<%@ include file="../../pubfun/JavaFun.jsp" %>

<%
String grouptype = request.getParameter("grouptype") == null ? "3" : request.getParameter("grouptype");
boolean islogin = session.getAttribute(com.zte.tao.constant.SessionConstant.USER_INFO) != null;
boolean showLargess = grouptype.equals("2");
String ringText = grouptype.equals("2") ? "giftname" : "ringBoxName";
String ringTexttmp = "DIY Music Box";
zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringBoxName", "musicbox");
request.setAttribute("showLargess", Boolean.toString(showLargess));
request.setAttribute("islogin", Boolean.toString(islogin));
request.setAttribute("grouptype", grouptype);
request.setAttribute("ringText", ringText);
boolean hidebutton = "false".equals(request.getParameter("hidebutton"))? false:true; 
System.out.println("***hidebutton***"+hidebutton);
com.zte.tao.util.URLStack urls = (com.zte.tao.util.URLStack)session.getAttribute("URLINFOS");
if(urls == null){
  urls = new com.zte.tao.util.URLStack();
  session.setAttribute("URLINFOS",urls);
}
urls.push(request);
UserAccount user = (UserAccount)session.getAttribute(SessionConstant.USER_INFO);
String allindex = (String)String.valueOf(user.getAllindex());
System.out.println("allindex=="+allindex);

String tempcode=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0056020","1",ringTexttmp);
String tempname=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0056000","1",ringTexttmp);
String mcurrencytemp1 =getArgMsg(request,"UserMSG0056021","1", "(\\"+zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+")");
String mcurrencytemp2 =getArgMsg(request,"UserMSG0056021","1", "(\\"+zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+"/"+getArgMsg(request,"UserMSG0056022","1")+")");
String DIYmscBoxDisp = zte.zxyw50.util.CrbtUtil.getDbStr(request,"DIYmscBoxDisp","DIY Music Box");
 
%>
 <table id="FrmUser" align="center" width="100%" border = "0" class="table-style4" cellpadding="0" cellspacing="0" >
 <tr>
 <td>
 <zte:table name="diymusicboxtable"  model="musicbox"  condition="a.allindex = $allindex and a.ringgrptype=3"
      url="initeditring.action" shareControl="false"  initial="true" oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')" evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'E6ECFF')"  showBottom="true"
      pageRows="ognl: $request.getParameter('pagerows')" rowNO="ognl:@RingViewHelper@isshowRowNum()"  dynamic="true" css="ognl:@RingViewHelper@getParameterValue($request, 'css', 'table-style4')"  titleCss="ognl:@RingViewHelper@getParameterValue($request, 'titleCss', 'tr-ringlist2')"
      cellpadding="0" cellspacing="1" titleAlign="center" titleValign="center" >
      <zte:tablefield css="ringlist-td" fieldName="allindex" text="" mappedName="allindex" visible="false"/>
      <zte:tablefield css="ringlist-td" fieldName="grouplabel" text='<%= getArgMsg(request,"UserMSG0070051","1",DIYmscBoxDisp) %>' mappedName="grouplabel"/>
	  <zte:tablefield css="ringlist-td"  fieldName="ringgroup" text='<%= getArgMsg(request,"UserMSG0070050","1",DIYmscBoxDisp) %>' mappedName="ringgroup"/>
      <zte:tablefield css="ringlist-td"  fieldName="ringfee" text="<%=mcurrencytemp1 %>" mappedName="ringfee" cellRender="zte.zxyw50.render.RingfeeCellRender()"/>
      <zte:tablefield css="ringlist-td" hand="true"   fieldName="modify" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0008712','1')" img="image/info.gif"  align="center"  imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0008712','1')"   onClick="javascript:ringGroupDetail(1,3,'@ringgroup@',1)" />
	  <zte:tablefield css="ringlist-td"  hand="true" visible="false" fieldName="largess" text="" img="image/largess.gif" align="center"  imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0008717','1')" onClick="javascript:allowedtogift('@ringgroup@','3','@validdate@')"/>
      <zte:tablefield css="ringlist-td" hand="true"  fieldName="edit" text="Edit" img="image/edit.gif" align="center"  imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0008722','1')"   onClick="javascript:allowedtoEdit(3,'@ringgroup@','@validdate@','@cataindex@','@ringcnt@','@spindex@','1')"/>
      <zte:tablefield css="ringlist-td" hand="true"  fieldName="delete" text="Delete" img="image/delete.gif" align="center"  imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0008713','1')"   onClick="javascript:del_DIYMBox('@ringgroup@','@grouplabel@',3)"/>
      <zte:tablebottom border="0"  cellpadding="0" cellspacing="0" css="table-style10" imgUrl="/base/image/"/>
    </zte:table>  
    </td>
    </tr>
	</table>
  
	<table id="FrmCCS"  align="center" width="100%">
	<tr>
	<td>
 <zte:table name="ccsdiymusicboxtable"  model="musicbox"  condition="a.allindex = $allindex and a.ringgrptype=3"
      url="logonccs.action" shareControl="false"  initial="true" oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')" evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'E6ECFF')"  showBottom="true"
      pageRows="20" rowNO="ognl:@RingViewHelper@isshowRowNum()"  dynamic="true" css="ognl:@RingViewHelper@getParameterValue($request, 'css', 'table-style4')"  titleCss="ognl:@RingViewHelper@getParameterValue($request, 'titleCss', 'tr-ringlist')"
      cellpadding="0" cellspacing="0" titleAlign="left" titleValign="center" >
      <zte:tablefield css="ringlist-td" fieldName="allindex" text="" mappedName="allindex" visible="false"/>
      <zte:tablefield css="ringlist-td" style="width:35%;text-align:left;" fieldName="grouplabel"  text="Title" mappedName="grouplabel"/>
	  <zte:tablefield css="ringlist-td" style="width:20%;text-align:left;" fieldName="ringgroup" text="Music Box Code" mappedName="ringgroup"/>
      <zte:tablefield css="ringlist-td" style="width:10%;text-align:left;" fieldName="ringfee" text="Charges" mappedName="ringfee" cellRender="zte.zxyw50.render.RingfeeCellRenderM1()"/>
      
	  <zte:tablefield css="ringlist-td" style="width:10%;text-align:left;" hand="true" visible="false" fieldName="largess" text="" img="image/largess.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0008717','1')" onClick="javascript:allowedtogift('@ringgroup@','3','@validdate@')"/>


      
      <zte:tablebottom border="0"  cellpadding="0" cellspacing="0" css="table-style10" imgUrl="/base/image/"/>
    </zte:table>  
	</td>
	</tr>
	</table>
<script>
<%	if(hidebutton==false)
 {
 %>
    var div_tone = document.getElementById("FrmUser");
	div_tone.style.display = "none";
 <% } 
    else
	{%>
    var div_toneCCS = document.getElementById("FrmCCS");
    div_toneCCS.style.display = "none";
<%	}
 %>
</script>
  

<script>
function allowedtoEdit(grouptype,groupid,validda,cataindex,ringcnt,spindex,isUserLib) {
         var today= new Date();
            buy=validda.split('.');
         var validate=new Date();          
            validate.setYear(buy[0]);
            validate.setMonth(buy[1]-1);
            validate.setDate(buy[2]);	 
 		 var days_left = days_in_between(today, validate);
	      
         if(days_left>30) {
             document.location.href ="DIYringgrpdetail.jsp?action=2&grouptype=" + grouptype + "&groupid=" + groupid + "&cataindex=" + cataindex + "&ringcnt=" + ringcnt +"&spindex="+spindex+"&isUserLib="+isUserLib;
		 } else {
			   alert("Sorry, you are unable Perform any operation on this '<%=DIYmscBoxDisp%>' as it will expire on "+validate);
		 }
}

function days_in_between(date1, date2) {

    // The number of milliseconds in one day
    var ONE_DAY = 1000 * 60 * 60 * 24

    // Convert both dates to milliseconds
    var date1_ms = date1.getTime()
    var date2_ms = date2.getTime()

    // Calculate the difference in milliseconds
    var difference_ms = Math.abs(date1_ms - date2_ms)
    
    // Convert back to days and return
    return Math.round(difference_ms/ONE_DAY)

}

function del_DIYMBox(ringid,ringlabel,ringidtype){
        var url ;
        url =  "/colorring/findringhasused.action?ringid="+ringid+"&ringidtype="+ringidtype;
        var results = xmlRequest(url);
        if(results){
            if( results[0]=='false'){
                if(confirm('<i18n:message key="UserMSG0008703" />'))
               dodelete_DIY(ringid,ringidtype);
                else
                    return;
            }else{
            	 var hint = '<%= getArgMsg(request,"UserMSG0008704","1",DIYmscBoxDisp) %>\r\n<%= getArgMsg(request,"UserMSG0008707","1",DIYmscBoxDisp) %>';
                 if(confirm(hint)){
                     dosubmiturl(ringid,ringidtype);
                 }else{
                     return;
                 }
           }
        }
    }

    function dodelete_DIY(ringid,ringidtype){
         url ="/colorring/delpersonring.action?ringid="+ringid+"&ringidtype="+ringidtype;
         if(ringidtype==3){
             document.diymusicboxtable.action=url;
             document.diymusicboxtable.submit();
         }else{
             document.diymusicboxtable.action=url;
             document.diymusicboxtable.submit();
         }

    }

</script>

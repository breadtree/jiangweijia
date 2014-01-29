<%@include file="../../base/included.jsp"%>
<%@ include file="../../pubfun/JavaFun.jsp" %>

<%
String grouptype = request.getParameter("grouptype") == null ? "3" : request.getParameter("grouptype");
String mainmusic = request.getParameter("mainmusic") == null ? "0" : request.getParameter("mainmusic");
boolean islogin = session.getAttribute(com.zte.tao.constant.SessionConstant.USER_INFO) != null;
boolean showLargess = grouptype.equals("2");
String ringText = grouptype.equals("2") ? "giftname" : "ringBoxName";
String ringTexttmp = zte.zxyw50.util.CrbtUtil.getDbStr(request,"DIYmscBoxDisp","DIY Music Box");
zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringBoxName", "musicbox");
request.setAttribute("showLargess", Boolean.toString(showLargess));
request.setAttribute("islogin", Boolean.toString(islogin));
request.setAttribute("grouptype", grouptype);
request.setAttribute("ringText", ringText);
com.zte.tao.util.URLStack urls = (com.zte.tao.util.URLStack)session.getAttribute("URLINFOS");
if(urls == null){
  urls = new com.zte.tao.util.URLStack();
  session.setAttribute("URLINFOS",urls);
}
urls.push(request);
//zte.zxyw50.colorring.util.RingViewHelper.getConfigText(ringText);\u539F\u6765\u901A\u8FC7\u6B64\u7C7B\u83B7\u53D6\u94C3\u97F3\u76D2\u5927\u793C\u5305db\u914D\u7F6E

String tempcode=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0056020","1",ringTexttmp);
String tempname=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0056000","1",ringTexttmp);
String mcurrencytemp1 =getArgMsg(request,"UserMSG0056021","1", "(\\"+zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+")");
String mcurrencytemp2 =getArgMsg(request,"UserMSG0056021","1", "(\\"+zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+"/"+getArgMsg(request,"UserMSG0056022","1")+")");
 
%>

<zte:table initial="true" name="colorring_ringgrplist_DIY" condition="s50sysringgrp.ringgrptype=$grouptype and s50sysringgrp.isshow=1 order by s50sysringgrp.uploadtime desc"
    model="RingGroupList" shareControl="false"  oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')" evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'FBF6B1')"
    showBottom="ognl: $request.getParameter('showturnpage')" pageRows="ognl: $request.getParameter('pagerows')" rowNO="ognl:@RingViewHelper@isshowRowNum()" 
    css="table-style4"  titleCss="tr-ringlist" rowCss="font-ring"  cellpadding="2" cellspacing="0"
    titleAlign="center" titleValign="center">
  <zte:tablefield cellRender="zte.zxyw50.render.LimitStringCellRender(40)" fieldName="grouplabel" text='<%= getArgMsg(request,"UserMSG0070051","1",ringTexttmp) %>' mappedName="name"  style="width:50%;padding-left:10px;"/>
  <zte:tablefield visible="ognl:@RingViewHelper@isVisible($request, 'showringgroupid')" fieldName="ringgroup" text='<%= getArgMsg(request,"UserMSG0070050","1",ringTexttmp) %>' mappedName="ringid"/>
  <zte:tablefield visible="ognl:@RingViewHelper@isVisible($request, 'showspname')" fieldName="spname" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056600','1')" mappedName="spname"/>
  <%
 
  if(grouptype.equals("2")){ %>
  <zte:tablefield visible="ognl:@RingViewHelper@isVisible($request, 'showgiftvaliddate')" cellRender="zte.zxyw50.render.DateValidate(@validdate@)" fieldName="validdate" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056601','1')" mappedName="validdate"/>
   <% }else{ %>
  <zte:tablefield visible="ognl:@RingViewHelper@isVisible($request, 'showgiftvaliddate')" cellRender="zte.zxyw50.render.DateValidate(@validdate@)" fieldName="validdate" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056601','1')" mappedName="validdate"/>
   <%}%>
  <zte:tablefield visible="ognl:@RingViewHelper@isVisible($request, 'showringgrpcnt')" fieldName="ringcnt" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056602','1')" mappedName="ringcnt"/>
  <%
  
  if(grouptype.equals("2")){ %>
  <zte:tablefield cellRender="zte.zxyw50.render.RingfeeCellRender()" fieldName="ringfee" text="<%=mcurrencytemp1%>" mappedName="price"/>
   <% }else{ %>
  <zte:tablefield cellRender="zte.zxyw50.render.RingfeeCellRender()" fieldName="ringfee" text="<%=mcurrencytemp2%>" mappedName="price"/>
 <%}%>
  <zte:tablefield fieldName="buytimes" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056603','1')" mappedName="buytimes"/>
  <zte:tablefield hand="true" fieldName="buy" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056604','1')" img="image/buy.gif"  imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056607','1')" align="center"   onClick="javascript:allowedtogift(3, '@ringid@','@validdate@','@cataindex@','@ringcnt@','@spindex@')" visible="true"/>
  <zte:tablefield visible="ognl:$request.getAttribute('showLargess')" hand="true" fieldName="largess" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056605','1')" img="image/largess.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056608','1')" onClick="ognl:ringGroupDetail(3, {$request.getAttribute('grouptype')}, '@ringid@')"/>
  <zte:tablefield hand="true" fieldName="info" text="Listen" img="image/play.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056609','1')"   onClick="ognl:ringGroupInfo({$request.getAttribute('grouptype')}, '@ringid@')" visible="false"/>
  <zte:tablebottom border="0"  cellpadding="0" width="100%" cellspacing="0" css="table-style2" imgUrl="/base/image/">
  </zte:tablebottom>
</zte:table>

<script>
function allowedtogift(grouptype,groupid,validda,cataindex,ringcnt,spindex) {
         var today= new Date();
            buy=validda.split('.');
         var validate=new Date();          
            validate.setYear(buy[0]);
            validate.setMonth(buy[1]-1);
            validate.setDate(buy[2]);	 
 		 var days_left = days_between(today, validate);
	     
         if(days_left>30) {
			 
            var confirmURL='/colorring/diyringgrouplist.action?action=2&grouptype=' + grouptype + '&groupid=' + groupid + '&cataindex=' + cataindex + '&ringcnt=' + ringcnt +'&spindex='+spindex+'&mainmusic=<%=mainmusic%>'; 
			 window.open(confirmURL,'main');

		 } else {
			   alert("Sorry, you are unable to purchase this '<%=ringTexttmp%>' as it will expire on "+validda);
		 }
}

function days_between(date1, date2) {

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
</script>

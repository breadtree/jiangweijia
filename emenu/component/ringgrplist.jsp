<%@include file="../../base/included.jsp"%>
<%@ include file="../../pubfun/JavaFun.jsp" %>
<%
String grouptype = request.getParameter("grouptype") == null ? "1" : request.getParameter("grouptype");
boolean islogin = session.getAttribute(com.zte.tao.constant.SessionConstant.USER_INFO) != null;
boolean showLargess = grouptype.equals("2");
String ringText = grouptype.equals("2") ? "giftname" : "ringBoxName";
String ringTexttmp = grouptype.equals("2") ? zte.zxyw50.util.CrbtUtil.getDbStr(request,"giftname", "Gift-Bag"): zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringBoxName", "musicbox")+"<br>";
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
String mcurrencytemp2 =getArgMsg(request,"UserMSG0056021","1", "(\\"+zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+")");
String mcurrencytemp3 =getArgMsg(request,"UserMSG0056027","1", "(\\"+zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+")");
String mcurrencytemp4 =getArgMsg(request,"UserMSG0056027","1", "(\\"+zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+")");
%>
<zte:table initial="true" name="colorring_ringgrplist" condition="s50sysringgrp.ringgrptype=$grouptype and s50sysringgrp.isshow=1 order by s50sysringgrp.uploadtime desc"
    model="RingGroupList" shareControl="true"  oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')" evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'FBF6B1')"
    showBottom="ognl: $request.getParameter('showturnpage')" pageRows="ognl: $request.getParameter('pagerows')"
    css="table-style4"  titleCss="tr-ringlist" rowCss="font-ring" cellpadding="2" cellspacing="0"
    titleAlign="center" titleValign="center">
  <zte:tablefield css="ringlist-td" fieldName="ringgroup" text="<%=tempcode%>" mappedName="ringid"/>
  <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.LimitStringCellRender(16)" fieldName="grouplabel" text="<%=tempname%>" mappedName="name"/>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'showspname')" fieldName="spname" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056600','1')" mappedName="spname"/>
  <%if(grouptype.equals("2")){ %>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'showgiftvaliddate')" fieldName="validdate" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056601','1')" mappedName="validdate"/>
   <% }else{ %>
  <zte:tablefield css="ringlist1-td" visible="true" fieldName="validdate" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056601','1')" mappedName="validdate"/>
   <%}%>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'showringgrpcnt')" fieldName="ringcnt" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056602','1')" mappedName="ringcnt"/>
  <%if(grouptype.equals("2")){ %>  
  <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.RingfeeCellRender()" fieldName="ringfee" text="<%=mcurrencytemp1%>" mappedName="price"/>
   <% }else{ %>   
   <zte:tablefield css="ringlist1-td" cellRender="zte.zxyw50.render.RingfeeCellRender()" fieldName="ringfee" text="<%=mcurrencytemp2%>" mappedName="price"/>
 <%}%>
  <zte:tablefield css="ringlist1-td" fieldName="buytimes" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056603','1')" mappedName="buytimes"/>
  <zte:tablefield css="ringlist1-td" hand="true" fieldName="buy" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056604','1')" img="image/buy.gif"  imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056607','1')"   onClick="ognl:ringGroupDetail(2, {$request.getAttribute('grouptype')}, '@ringid@')"/>
  <zte:tablefield css="ringlist1-td" visible="ognl:$request.getAttribute('showLargess')" hand="true" fieldName="largess" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056605','1')" img="image/largess.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056608','1')" onClick="ognl:ringGroupDetail(3, {$request.getAttribute('grouptype')}, '@ringid@')"/>
  <zte:tablefield css="ringlist1-td" hand="true" fieldName="info" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056606','1')" img="image/info.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056609','1')"   onClick="ognl:ringGroupInfo({$request.getAttribute('grouptype')}, '@ringid@')"/>
  <zte:tablebottom border="0"  cellpadding="2" width="100%" cellspacing="0" css="table-style2" imgUrl="/base/image/">
  </zte:tablebottom>
</zte:table>

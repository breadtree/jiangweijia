<%@include file="./../base/included.jsp"%>
<%
String ringdisplaytemp = zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "ringtone");
String ringCodetemp=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0056020","1",ringdisplaytemp);
String ringNametemp=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0038308","1",ringdisplaytemp);
String mcurrencytemp = "(\\"+zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+")";
String mpricetemp=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0056021","1",mcurrencytemp);
com.zte.tao.util.URLStack urls = (com.zte.tao.util.URLStack)session.getAttribute("URLINFOS");
String isMyFavorite = zte.zxyw50.util.CrbtUtil.getDbStr(request,"ismyfavorite","0");
if(urls == null){
	urls = new com.zte.tao.util.URLStack();
	session.setAttribute("URLINFOS",urls);
}
urls.push(request);
//ognl:@authorname@
//ognl:@RingViewHelper@getMessage($request,'UserMSG0056024','Artist')
%>
<zte:table initial="true" name="colorring_ringlist" condition="ognl:@RingViewHelper@getRingListCondition($request)" url="ognl: $request.getParameter('url')"
    model="ognl:@RingViewHelper@getRingListModel($request)" shareControl="ognl:@RingViewHelper@isCacheable($request)"
    oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')"
    evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'E6ECFF')"
    showBottom="ognl: $request.getParameter('showturnpage')" pageRows="ognl: $request.getParameter('pagerows')"
    dynamic="true" rowNO="ognl:@RingViewHelper@isshowRowNum()"  css="ognl:@RingViewHelper@getParameterValue($request, 'css', 'table-style4')"  titleCss="ognl:@RingViewHelper@getParameterValue($request, 'titleCss', 'tr-ringlist')"  cellpadding="2" cellspacing="0"
    titleAlign="center" titleValign="center">
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'showringsubindex')" fieldName="ringsubindex" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056001','1')" mappedName="order"/>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'showringid')" fieldName="ringid" text="<%=ringCodetemp%>" mappedName="ringid"/>
  <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.LimitStringCellRender('limtnamelen')" fieldName="ringlabel" text="<%=ringNametemp%>" mappedName="name"/>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'showsingger')"  text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056024','')" cellRender="zte.zxyw50.render.LimitStringCellRender('limtsingernamelen')" fieldName="singgername"  mappedName="singgername"/>  
  <zte:tablefield css="ringlist1-td" cellRender="zte.zxyw50.render.RingfeeCellRender()" fieldName="ringfee" text="<%=mpricetemp%>" mappedName="price"/>   
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'showvaliddate')" fieldName="validdate" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056003','1')" mappedName="validdate"/>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'totalbuytimes')" align="center" fieldName="buytimes" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056004','1')" mappedName="buytimes"/>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'apartbuytimes')" align="center" fieldName="buytimes1" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056004','1')" mappedName="order"/>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'showlargesstimes')" fieldName="largesstimes" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056005','1')" mappedName="largesstimes"/>
  <zte:tablefield css="ringlist1-td" visible="ognl:@RingViewHelper@isVisible($request, 'showspname')" fieldName="spname" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056006','1')" mappedName="spname"/>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'showuploadtime')" fieldName="uploadtime" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056007','1')" mappedName="uploadtime"/>
  <zte:tablefield css="ringlist1-td" hand="true" fieldName="mediatype" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056008','1')" cellRender="zte.zxyw50.render.ImgDynCellRender('@mediatype@')" imgDyn="true" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056008','1')"   onClick="javascript:tryListen('@ringid@','@name@','@singgername@','@mediatype@')" mappedName="mediatype"/>
  <zte:tablefield css="ringlist1-td" visible="ognl:@RingViewHelper@isVisible($request, 'buy')"  hand="true" fieldName="buy" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056009','1')" img="image/buy.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056015','1')"   onClick="javascript:buyRing('@ringid@', '1', '-1')"/>
  <zte:tablefield css="ringlist1-td" visible="ognl:@RingViewHelper@isVisible($request, 'showlargess')" hand="true" fieldName="largess" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056010','1')" img="image/largess.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056016','1')" onClick="javascript:openLargess('@ringid@', '1', '-1',false)"/>
  <zte:tablefield css="ringlist1-td" visible="ognl:@RingViewHelper@isVisible($request, 'showinfo')" hand="true" fieldName="info" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056011','1')" img="image/info.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056017','1')" onClick="javascript:ringInfo1('@ringid@','@buytimes@','@largesstimes@')"/>
  <%if(isMyFavorite.equals("1")){ %>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'favorite')" hand="true" fieldName="favorite" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056012','1')" img="image/collection-add.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056018','1')"  onClick="javascript:myfavorite(1,'@ringid@')"/>
  <zte:tablefield css="ringlist-td" visible="ognl:@RingViewHelper@isVisible($request, 'rmfavorite')" hand="true" fieldName="rmfavorite" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056013','1')" img="image/collection-del.gif"  imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056019','1')"   onClick="javascript:myfavorite(2,'@ringid@')"/>
  <%}%>
  <zte:tablebottom border="0"  cellpadding="2" width="100%" cellspacing="0" css="table-style2" imgUrl="/base/image/">
  </zte:tablebottom>
</zte:table>

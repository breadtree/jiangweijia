<%@include file="../../base/included.jsp"%>
<%@ include file="../../pubfun/JavaFun.jsp" %>
<%
String ringdisplaytemp=zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdispUpper", "Ringtone");
String tmpcode = getArgMsg(request,"UserMSG0056904","1");
String tmpname = ringdisplaytemp+" "+getArgMsg(request,"UserMSG0056905","1");
%>
<table width="100%" border="0" cellspacing="1" cellpadding="1" class="table-style4" align="center">
<tr>
<td>
<zte:table initial="true" name="colorring_DIYgrpinfo" model="ognl:@UserViewHelper@getDIYgroupringInfo($session)" 
     condition="ognl:@RingViewHelper@GetConditionForDIYMusicBox($request)" shareControl="false"  dynamic="true" oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')"
    evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'FBF6B1')"
    showBottom="ognl: $request.getParameter('showturnpage')" pageRows="ognl: $request.getParameter('pagerows')" rowNO="ognl:@RingViewHelper@isshowRowNum()"  css="ognl:@RingViewHelper@getParameterValue($request, 'css', 'table-style4')"   titleCss="ognl:@RingViewHelper@getParameterValue($request, 'titleCss', 'tr-ringlist')" rowCss="font-ring" cellpadding="0" cellspacing="0"
    titleAlign="left" titleValign="center">
  <zte:tablefield cellRender="zte.zxyw50.render.SongAndArtistRender(@singerid@)" fieldName="ringlabel" text='<%="&nbsp;&nbsp;&nbsp;"+tmpname%>' mappedName="ringlabel" style="width:65%;padding-left:10px"/>
   <zte:tablefield fieldName="ringid" text="<%=tmpcode%>" mappedName="ringid" />
  <zte:tablefield fieldName="singgername" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056900','1')" mappedName="singgername" visible="false"/>
  <zte:tablefield cellRender="zte.zxyw50.render.ValidataDayCellRender(@uservalidday@)" fieldName="validdate" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056901','1')" mappedName="validdate" visible="false"/>
  <zte:tablefield hand="true" fieldName="mediatype" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056008','1')" cellRender="zte.zxyw50.render.ImgDynCellRender('@mediatype@')" imgDyn="true" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056903','1')" onClick="javascript:tryListen('@ringid@','@ringlabel@','@singgername@','@mediatype@')" mappedName="mediatype"/>
  <zte:tablebottom border="0"  cellpadding="0" width="100%" cellspacing="0" css="table-style2" imgUrl="/base/image/">
  </zte:tablebottom>
</zte:table>
</td>
</tr>
</table>

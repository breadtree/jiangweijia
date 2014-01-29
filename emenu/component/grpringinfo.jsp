<%@include file="../../base/included.jsp"%>
<%@ include file="../../pubfun/JavaFun.jsp" %>
<%
String ringdisplaytemp=zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "CRBT");
String tmpcode = ringdisplaytemp+" "+getArgMsg(request,"UserMSG0056904","1");
String tmpname = ringdisplaytemp+" "+getArgMsg(request,"UserMSG0056905","1");
%>
<zte:table initial="true" name="colorring_grpinfo" condition="s50sysringgrpmem.ringgroup='$groupid' order by s50sysringgrpmem.csubindex"
    model="GroupRingInfo" shareControl="false"  oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')"
    evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'E6ECFF')"
    showBottom="ognl: $request.getParameter('showturnpage')" pageRows="ognl: $request.getParameter('pagerows')"
    css="table-style4"  titleCss="tr-ringlist1" rowCss="font-ring" cellpadding="2" cellspacing="0"
    titleAlign="center" titleValign="center">
  <zte:tablefield css="ringlist-td" style="width:120px"  fieldName="ringid" text="<%=tmpcode%>" mappedName="ringid"/>
  <zte:tablefield css="ringlist-td" style="width:180px" cellRender="zte.zxyw50.render.LimitStringCellRender(16)" fieldName="ringlabel" text="<%=tmpname%>" mappedName="ringlabel"/>
  <zte:tablefield css="ringlist-td" style="width:60px" fieldName="singgername" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056900','1')" mappedName="singgername"/>
  <zte:tablefield css="ringlist1-td" style="width:80px" cellRender="zte.zxyw50.render.ValidataDayCellRender(@uservalidday@)" fieldName="validdate" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056901','1')" mappedName="validdate"/>
  <zte:tablefield css="ringlist1-td" style="width:50px" hand="true" fieldName="mediatype" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0056008','1')" cellRender="zte.zxyw50.render.ImgDynCellRender('@mediatype@')" imgDyn="true" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0056903','1')" onClick="javascript:tryListen('@ringid@','@ringlabel@','@singgername@','@mediatype@')"mappedName="mediatype"/>
  <zte:tablebottom border="0"  cellpadding="2" width="100%" cellspacing="0" css="table-style2" imgUrl="/base/image/">
  </zte:tablebottom>
</zte:table>

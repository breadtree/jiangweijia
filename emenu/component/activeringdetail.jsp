<%@include file="../../base/included.jsp"%>
<%
boolean islogin = session.getAttribute(com.zte.tao.constant.SessionConstant.USER_INFO) != null;
request.setAttribute("islogin", Boolean.toString(islogin));
    com.zte.tao.util.URLStack urls = (com.zte.tao.util.URLStack)session.getAttribute("URLINFOS");
    if(urls == null){
      urls = new com.zte.tao.util.URLStack();
      session.setAttribute("URLINFOS",urls);
    }
    urls.push(request);
String ringdisplay = zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "Ringtone");
String ringcode = zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0057806","",ringdisplay);
String ringname = zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0057807","",ringdisplay);
String mcurrencytemp = "(\\"+zte.zxyw50.util.CrbtUtil.getDbStr(request,"majorcurrency", "")+")";
String ringprice = zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0057808","",mcurrencytemp);

    //<zte:tablefield fieldName="ringid" text="ognl:@ringdispaly@code" mappedName="ringid"/>
    //<zte:tablefield cellRender="zte.zxyw50.render.LimitStringCellRender(16)" fieldName="ringlabel" text="ognl:@ringdispaly@name" mappedName="ringlabel"/>
    //<zte:tablefield cellRender="zte.zxyw50.render.RingfeeCellRender()" fieldName="ringfee" text="ognl:Price(@majorcurrency@)" mappedName="ringfee"/>
%>
<script language="JavaScript" src="../crbt.js" ></script>
<link href="../style.css" type="text/css" rel="stylesheet">
<zte:table initial="true" name="colorring_activeringdetail" condition="s50activityring.actno = $actno order by s50activityring.seqno"
    model="ActiveRingInfo" shareControl="false"  oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')"
    evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'E6ECFF')"
    showBottom="true" pageRows="10" titleCss="ognl:@RingViewHelper@getParameterValue($request, 'titleCss', 'ringlist-title')" css="ognl:@RingViewHelper@getParameterValue($request, 'css', 'ringlist-table')" width="100%"
     cellpadding="2" cellspacing="0"
    titleAlign="center" titleValign="center">
  <zte:tablefield css="ringlist-td" fieldName="seqno" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057800','1')" mappedName="seqno"/>
  <zte:tablefield css="ringlist-td" fieldName="ringid" text="<%= ringcode%>" mappedName="ringid"/>
  <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.LimitStringCellRender(16)" fieldName="ringlabel" text="<%= ringname%>" mappedName="ringlabel"/>
  <zte:tablefield css="ringlist-td" fieldName="ringauthor" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057801','1')" mappedName="ringauthor"/>
  <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.RingfeeCellRender()" fieldName="ringfee" text="<%= ringprice%>" mappedName="ringfee"/>
  <zte:tablefield css="ringlist-td" hand="true" fieldName="mediatype" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057802','1')" cellRender="zte.zxyw50.render.ImgDynCellRender('@mediatype@')" imgDyn="true" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0057802','1')" onClick="javascript:tryListen('@ringid@','@name@','@singgername@','@mediatype@')"mappedName="mediatype"/>
  <zte:tablefield css="ringlist1-td" hand="true" fieldName="buy" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057803','1')" img="image/buy.gif" onClick="javascript:buyRing('@ringid@', '1', '-1')"/>
  <zte:tablefield css="ringlist1-td" hand="true" fieldName="largess" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057804','1')" img="image/largess.gif" onClick="javascript:openLargess('@ringid@', '1', '-1',false)"/>
  <zte:tablefield css="ringlist1-td" hand="true" fieldName="info" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057805','1')" img="image/info.gif" onClick="ringInfo('@ringid@')"/>
  <zte:tablebottom border="0"  cellpadding="2" width="100%" cellspacing="0" css="table-style2" imgUrl="/base/image/">
  </zte:tablebottom>
</zte:table>

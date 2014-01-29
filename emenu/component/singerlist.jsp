<%@include file="../../base/included.jsp"%>
<%
String ringdisplaytemp = zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "CRBT");
String singertemp = zte.zxyw50.util.CrbtUtil.getDbStr(request,"authorname", "singer");
String authorname=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0056301","1",singertemp);
String infotemp=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0056302","1",ringdisplaytemp);
%>
<script language="JavaScript" src="../crbt.js"></script>
<script language="JavaScript">
function ringBySinger(singer,singerid){
  document.inputForm.singername.value=singer;
  document.inputForm.singerid.value=singerid;
  document.inputForm.searchmodel.value='2';
  document.inputForm.submit();
}
</script>
<link href="../style.css" type="text/css" rel="stylesheet">
<zte:table initial="true" name="colorring_singerlist" condition="ognl:@RingViewHelper@getSingerListCondition($request)"
    model="s50singer" shareControl="false"  oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')" evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'FBF6B1')"
    showBottom="true" pageRows="ognl: $request.getParameter('pagerows')" css="table-style4" titleCss="tr-ringlist" rowCss="font-ring" cellpadding="2" cellspacing="0"
    titleAlign="center" titleValign="center">
  <zte:tablefield css="ringlist-td" style="width:42%" fieldName="singgername" text="<%=singertemp%>" mappedName="singgername" hand="true" onClick="JavaScript:alert('@singgername@')"/>
  <zte:tablefield css="ringlist-td" style="width:42%" cellRender="zte.zxyw50.render.LimitStringCellRender(50)" fieldName="descrip" text="<%=authorname%>" mappedName="descrip"/>
  <zte:tablefield css="ringlist-td" style="width:16%" css="ringlist1-td" hand="true" align="center" fieldName="info" text="<%=infotemp%>" img="image/info.gif" onClick="JavaScript:ringBySinger('@singgername@','@singerid@')"/>
  <zte:tablebottom border="0"  cellpadding="2" width="100%" cellspacing="0" css="table-style2" imgUrl="/base/image/">
  </zte:tablebottom>
</zte:table>

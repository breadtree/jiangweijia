<%@ page import="com.zte.tao.util.JspUtil" %>
<%
String time_type = JspUtil.getSafeParameter("timetype",request);
    HashMap hmCallinggroup = (HashMap)request.getAttribute("hmCallinggroup");
    if(hmCallinggroup!=null &&hmCallinggroup.size() > 0 ){
       session.setAttribute("sesshmCallinggroup",hmCallinggroup);
    }
%>
<%@include file="/base/included.jsp" %>
<style type="text/css">
<%
if ("es".equals(getZteLocale(request).getLanguage()))
{
%>
.table-style4 {
    font-family: Arial;
    font-size: 9pt;
    empty-cells: show;
    margin-top: 0;
    margin-left: 0;
	width: 610px;
	background:url(image/tr_bg1.gif) repeat;
	border-bottom:1px solid #ccc;
	/*text-align:left;*/
	color:#ffffff;
	height:30px !important;
}
<%
}
%>
</style>
<zte:table name="callingtimetable" model="ognl:@UserViewHelper@getCallingtimeModel($session)"  condition="ognl:@UserViewHelper@getTimeCallingCond($session,$request,true)"
      shareControl="false" url="ognl:@RingViewHelper@getParameterValue($request, 'targeturl', 'callingtimetable.jsp')" initial="true" oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')"
      evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'FBF6B1')"  showBottom="true"
      pageRows="5"  dynamic="true" css="table-style4"  titleCss="tr-ringlist" width="610"
      cellpadding="2" cellspacing="1" border="0" titleAlign="center" titleValign="center">
      <zte:tablefield css="ringlist-td" fieldName="allindex" text="" mappedName="allindex" visible="false"/>
      <zte:tablefield css="ringlist-td" fieldName="setno" text="" mappedName="setno" visible="false"/>
      <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.GroupLabelCellRender(@callingtype@,$request)" fieldName="callingNum" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057500','1')" style="word-wrap:break-word;word-break:break-all; "mappedName="callingnum"/>
      <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.RingNameCellRender(@allindex@,@ringidtype@,$request)" fieldName="ringname" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057501','1')" style="word-wrap:break-word;word-break:break-all;"mappedName="ringid" />
      <zte:tablefield css="ringlist-td" fieldName="timedescrip" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057502','1')" style="word-wrap:break-word;word-break:break-all;"mappedName="timedescrip"/>

      <zte:tablefield css="ringlist-td" visible="ognl:@UserViewHelper@isTimeCallingItemHidden($request,'2&6&7')" fieldName="starttime" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057503','1')" mappedName="starttime"/>
      <zte:tablefield css="ringlist-td" visible="ognl:@UserViewHelper@isTimeCallingItemHidden($request,'2&6&7')" fieldName="endtime" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057504','1')" mappedName="endtime"/>

      <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.JcalendarCellRender()" visible="ognl:@UserViewHelper@isTimeCallingItemHidden($request,'2&6&7')" fieldName="startdate" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057505','1')" mappedName="startdate"/>
      <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.JcalendarCellRender()" visible="ognl:@UserViewHelper@isTimeCallingItemHidden($request,'2&6&7')" fieldName="enddate" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057506','1')" mappedName="enddate"/>

      <zte:tablefield css="ringlist-td"  cellRender="zte.zxyw50.render.JcalendarCellRender()" visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,2)" fieldName="enddate1" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057507','1')" mappedName="enddate"/>

      <zte:tablefield css="ringlist-td" visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,4)" fieldName="startday" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057508','1')" mappedName="startday"/>
      <zte:tablefield css="ringlist-td" visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,4)" fieldName="endday" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057509','1')" mappedName="endday"/>

      <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.WeekDayCellRender()" visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,3)" fieldName="startweek" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057510','1')" mappedName="startweek"/>
      <zte:tablefield css="ringlist-td" cellRender="zte.zxyw50.render.WeekDayCellRender()" visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,3)" fieldName="endweek" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057511','1')" mappedName="endweek"/>

      <zte:tablefield css="ringlist-td" visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,5)" fieldName="startmothday" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057512','1')" mappedName="startmonday"/>
      <zte:tablefield css="ringlist-td" visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,5)" fieldName="endmonthday" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057513','1')" mappedName="endmonday"/>

      <zte:tablefield css="ringlist-td" visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,7)" cellRender="zte.zxyw50.render.TimeRingSettingRender()" fieldName="settype" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057514','1')" mappedName="settype"/>
      <%
      if (!time_type.equals("7")){
      %>
      <zte:tablefield css="ringlist1-td" hand="true" fieldName="modify" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057515','1')" img="image/edit.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0057518','1')" onClick="javascript:goto(@allindex@,@setno@,true)"/>
      <%
      }else{
      %>
      <zte:tablefield css="ringlist1-td" hand="true"  fieldName="modify" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057515','1')" img="image/edit.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0057518','1')" onClick="javascript:settime('@setno@','@ringid@','@ringidtype@','@playendtime@','@settype@','@callingtype@','@callingnum@','@startdate@','@enddate@')"/>
      <%
      }
      %>
      <zte:tablefield css="ringlist1-td" hand="true" fieldName="delete" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057516','1')" img="image/delete.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0057519','1')"     onClick="javascript:deltime('@timedescrip@',@setno@)"/>
      <zte:tablefield css="ringlist-td" hand="true" visible="ognl:@UserViewHelper@isTimeCallingItemShown($request,7)" fieldName="info" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057517','1')" img="image/info.gif" imgAlt="ognl:@RingViewHelper@getMessage($request,'UserMSG0057520','1')"  onClick="javascript:setinfo(@setno@)"/>
      <zte:tablebottom border="0"  cellpadding="2" cellspacing="0" css="table-style10" imgUrl="/base/image/"/>
</zte:table>

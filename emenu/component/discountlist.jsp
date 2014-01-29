<%@include file="/base/included.jsp"%>
<%
    boolean islogin = session.getAttribute(com.zte.tao.constant.SessionConstant.USER_INFO) != null;
    request.setAttribute("islogin", Boolean.toString(islogin));
    com.zte.tao.util.URLStack urls = (com.zte.tao.util.URLStack)session.getAttribute("URLINFOS");
    if(urls == null){
      urls = new com.zte.tao.util.URLStack();
      session.setAttribute("URLINFOS",urls);
    }
    urls.push(request);
%>
<script language="JavaScript" src="../crbt.js" ></script>
<link href="../style.css" type="text/css" rel="stylesheet">
<zte:table initial="true" name="colorring_discountlist" condition=""
    model="DiscountList" shareControl="true"  oddBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'oddBgcolor', 'FFFFFF')" evenBgcolor="ognl:@RingViewHelper@getParameterValue($request, 'evenBgcolor', 'FBF6B1')" showBottom="true"
    pageRows="20" css="ognl:@RingViewHelper@getParameterValue($request, 'css', 'table-style3')"  titleCss="ognl:@RingViewHelper@getParameterValue($request, 'titleCss', 'ringlist-title')" rowCss="font-ring" cellpadding="2" cellspacing="1"
    titleAlign="center" titleValign="center">
  <zte:tablefield fieldName="discountid" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057200','1')" mappedName="discountid"/>
  <zte:tablefield cellRender="zte.zxyw50.render.LimitStringCellRender(16)" fieldName="discountname" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057201','1')" mappedName="discountname"/>
  <zte:tablefield fieldName="spname" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057202','1')" mappedName="spname"/>
  <zte:tablefield fieldName="freerings" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057203','1')" mappedName="freerings"/>
  <zte:tablefield cellRender="zte.zxyw50.render.RingfeeCellRender()" fieldName="rentfee" text="ognl:Monthly rental<br>(@majorcurrency@)" mappedName="rentfee"/>
  <zte:tablefield cellRender="zte.zxyw50.render.LimitStringCellRender(16)" fieldName="discountdesc" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057204','1')" mappedName="discountdesc"/>
  <zte:tablefield hand="true" fieldName="buy" text="ognl:@RingViewHelper@getMessage($request,'UserMSG0057205','1')" img="image/buy.gif" onClick="beforeorder('@discountid@','@spname@')"/>
  <zte:tablebottom border="0"  cellpadding="2" width="100%" cellspacing="0" css="table-style2" imgUrl="/base/image/">
  </zte:tablebottom>
</zte:table>
<script>
    function beforeorder(discountid,spname){
        var fm = document.colorring_discountlist;
        url =  "/colorring/finddiscountexited.action?discountid="+discountid+"&spname="+spname;
        var results = xmlRequest(url);
        if(results){
           if(results[0]=='true' && trim(results[1])!=''){
                if(confirm('<i18n:message key="UserMSG0054200" />'+results[1]+',<i18n:message key="UserMSG0054201" />')){
                    url = "/colorring/orderdiscount.action?discountid="+discountid+"&spname="+spname;
                    results = xmlRequest(url);
                }else {
                    return;
                }
            }else if(results[0] == 'false'){
                 url = "/colorring/orderdiscount.action?discountid="+discountid+"&spname="+spname;
                 results = xmlRequest(url);
            }
            if(results){
                if(results[0]=='success'){
                    alert("<i18n:message key='UserMSG0054202' />");
                }
            }
        }
    }
</script>

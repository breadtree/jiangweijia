<%@ taglib uri="/WEB-INF/taglibs-i18n.tld" prefix="i18n" %>
<%@ page import="com.zte.tao.util.*" %>
<%@ page import="com.zte.tao.config.*" %>
<%@ page import="java.util.*" %>
<%@ page import="zte.zxyw50.util.WebUtils" %>
 <%

  if(request.getSession().getAttribute("ZteCrbtLocale")==null){
    String langcfg1[] =TaoUtil.getLangPool();
    Locale locale=new Locale("","");
	locale=com.zte.tao.config.TaoUtil.StringToLocale(langcfg1[0]);
	WebUtils.setCookie( response,"ZteCrbtLocale",locale.toString());
	WebUtils.setLocale((HttpServletRequest) request, (HttpServletResponse) response, locale);
  }
  %>
<i18n:bundle baseName="com.zte.i18nres.txtres.userjsp" localeRef="ZteCrbtLocale" id="ZTECrbtI18NUserBase"/>

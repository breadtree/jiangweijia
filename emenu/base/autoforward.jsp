<%@ page import="java.util.*" %>
<%@ page import="com.zte.tao.util.StringUtil" %>
<%@ page import="com.zte.tao.util.JspUtil" %>
<%@include file="/base/i18n.jsp" %>
<%@ include file="../pubfun/JavaFun.jsp" %>
<%
   response.setContentType("text/html; charset="+com.zte.tao.config.TaoUtil.getCharset("UTF-8"));
   String uriname = request.getRequestURI();
   uriname = StringUtil.deleteHead(uriname,request.getContextPath());
   int dotpos=uriname.lastIndexOf(".");
   String  sFileName="";
   String  sExtName="";
   if(dotpos==-1){
     sFileName="index";
     sExtName=".jsp";
   }
   else{
     sFileName=uriname.substring(0,dotpos);
     sExtName=uriname.substring(dotpos);
   }

   //Process the parameters
   Map parameters = request.getParameterMap();
   String paraList = JspUtil.buildURLQueryString(parameters);

   //get the language
   String localeLanguage=getZteLocale(request).toString();
   String forwardURI= sFileName+"_"+localeLanguage +sExtName+paraList;
%>
  <jsp:forward page="<%=forwardURI%>" />

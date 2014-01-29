<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.zxywpub.*" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>System ringtone group parameter management</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body background="background.gif" class="body-style1">
<%
	 String majorcurrency = CrbtUtil.getConfig("majorcurrency","$");
	 String minorcurrency = CrbtUtil.getConfig("minorcurrency","penny");
	 String currencyratio = CrbtUtil.getConfig("currencyratio","100");
	 int ratio = Integer.parseInt(currencyratio);

	     //音乐盒与大礼包名字
    String musicbox  = CrbtUtil.getConfig("ringBoxName","musicbox");
    String giftbag   = CrbtUtil.getConfig("giftname","giftbag");
    String sysringgrpenable = CrbtUtil.getConfig("sysringgrpenable","0");
    String ifShowGiftBag = CrbtUtil.getConfig("ifShowGiftBag","0");


    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String m1="0",m2="0",m3="0",d1="0",d2="0",d3="0";
    HashMap hmap = new HashMap();
    try {
        manSysPara syspara = new manSysPara();
        sysTime = syspara.getSysTime() + "--";
        if (operID != null && purviewList.get("3-23") != null) {
            HashMap hs = new HashMap();
            ArrayList rList  = new ArrayList();
            String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
             m1 = request.getParameter("m1") == null ? "0" : transferString((String)request.getParameter("m1")).trim();
             hs.put("m1",m1);
             m2 = request.getParameter("m2") == null ? "0" : transferString((String)request.getParameter("m2")).trim();
             hs.put("m2",m2);
             m3 = request.getParameter("m3") == null ? "0" : transferString((String)request.getParameter("m3")).trim();
             hs.put("m3",m3);
             d1 = request.getParameter("d1") == null ? "0" : transferString((String)request.getParameter("d1")).trim();
             hs.put("d1",d1);
             d2 = request.getParameter("d2") == null ? "0" : transferString((String)request.getParameter("d2")).trim();
             hs.put("d2",d2);
             d3 = request.getParameter("d3") == null ? "0" : transferString((String)request.getParameter("d3")).trim();
             hs.put("d3",d3);
            if (op.equals("edit")) {
                rList = syspara.setSysRingGrpInfo(hs);
                sysInfo.add(sysTime + operName + " edit system ringtone group parameter successfully!");//Edit系统铃音组参数成功!
                // 准备写操作员日志
                if(getResultFlag(rList)){
                    zxyw50.Purview purview = new zxyw50.Purview();
                    HashMap map = new HashMap();
                    map.put("OPERID",operID);
                    map.put("OPERNAME",operName);
                    map.put("OPERTYPE","323");
                    map.put("RESULT","1");
                    map.put("PARA1",m1);
                    map.put("PARA2",m2);
                    map.put("PARA3",m3);
                    map.put("PARA4",d1);
                    map.put("PARA5",d2);
                    map.put("PARA6",d3);
                    map.put("DESCRIPTION","ip:"+request.getRemoteAddr());
                    purview.writeLog(map);
                }
                if(rList.size()>0){
                  session.setAttribute("rList",rList);
                %>
<form name="resultForm" method="post" action="result.jsp">
<input type="hidden" name="historyURL" value="musicParaSet.jsp">
<input type="hidden" name="title" value="System ringtone group parameter">
<script language="javascript">
   document.resultForm.submit();
</script>
</form>
              <%
               }
            }
            hmap = syspara.getSysRingGrpParaInfo();
            if(hmap!=null && hmap.size() >0)
            {
              m1 = hmap.get("m1")==null?"0":(String)hmap.get("m1");
              m2 = hmap.get("m2")==null?"0":(String)hmap.get("m2");
              m3 = hmap.get("m3")==null?"0":(String)hmap.get("m3");
              d1 = hmap.get("d1")==null?"0":(String)hmap.get("d1");
              d2 = hmap.get("d2")==null?"0":(String)hmap.get("d2");
              d3 = hmap.get("d3")==null?"0":(String)hmap.get("d3");
            }
%>
<script language="javascript">
	function checkfee (fee) {
   	  if(fee.length==0)
			return false;
      var tmp = '';
      for (i = 0; i < fee.length; i++) {
         tmp = fee.substring(i, i + 1);
         if (tmp < '0' || tmp > '9')
            return false;
      }
      return true;
   }
   function doSure () {
      var fm = document.inputForm;
      <%if("1".equals(sysringgrpenable)){%>
      if(!checkfee(fm.m1.value))
      {
       // alert('音乐盒价格上限只能为数字!');
         alert("Music box upper limit price can only be a digital number!");
        return ;
      }
      if(!checkfee(fm.m2.value))
      {
       // alert('音乐盒最大铃音数只能为数字!');
        alert("Music box max ringtone number can only be a digital number!");
        return ;
      }
      if(!checkfee(fm.m3.value))
      {
       // alert('音乐盒最少铃音数只能为数字!');
      alert("Music box min ringtone number can only be a digital number!");

        return ;
      }
      var m2= trim(fm.m2.value);
      var m3= trim(fm.m3.value);
      if(eval(m2+'>0'))
      {
      	 if(eval(m3+'>'+m2))
      	 {
           //alert('音乐盒最少铃音数不能大于最大铃音数!');
           alert('Music box min ringtone number cannot be larger max ringtone number!');//音乐盒最少铃音数不能大于最大铃音数!
           return ;
      	 }
      }
      <%}if("1".equals(ifShowGiftBag)){%>
      if(!checkfee(fm.d1.value))
      {
        //alert('大礼包价格上限只能为数字!');
        alert("Big gift price upper limit can only be a digital number!");
        return ;
      }
      if(!checkfee(fm.d2.value))
      {
       // alert('大礼包最大铃音数只能为数字!');
        alert("Big gift max ringtone number can only be a digital number!");
        return ;
      }
      if(!checkfee(fm.d3.value))
      {
       // alert('大礼包最少铃音数只能为数字!');
        alert("Big gift min ringtone number can only be a digital number!");
        return ;
      }
      var d2= trim(fm.d2.value);
      var d3= trim(fm.d3.value);
      if(eval(d2+'>0'))
      {
      	 if(eval(d3+'>'+d2))
      	 {
           //alert('大礼包最少铃音数不能大于最大铃音数!');
           alert('Gig gift min ringtone number cannot be larger max ringtone number!');//音乐盒最少铃音数不能大于最大铃音数!
            return ;
      	 }
      }
      <%}%>
      fm.op.value = 'edit';
      fm.submit();
   }
</script>
<script language="JavaScript">
	if(parent.frames.length>0)
		parent.document.all.main.style.height="500";
</script>
<form name="inputForm" method="post" action="musicParaSet.jsp">
<input type="hidden" name="op" value="">
<table width="440" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
    <td>
      <table width="100%" border="0" align="center" class="table-style2">
        <tr>
          <td colspan="4" height="26" align="center" background="image/n-9.gif" class="text-title" >Parameter management of system tone group</td>
        </tr>
        <tr>
         <%if("1".equals(sysringgrpenable)){%>
          <td align="right"><%=musicbox%> price upper limit(<%=minorcurrency%>):</td>
          <td align="left"><input type="text" name="m1" value="<%=m1%>" size="10"/></td>
           <%}if("1".equals(ifShowGiftBag)){%>
          <td align="right"><%=giftbag%> price upper limit(<%=minorcurrency%>)</td>
          <td align="left"><input type="text" name="d1" value="<%=d1%>" size="10"/></td>
          <%}%>
          </tr>
        <tr >
        <%if("1".equals(sysringgrpenable)){%>
          <td align="right"><%=musicbox%> max ringtone number:</td>
          <td align="left"><input type="text" name="m2" value="<%=m2%>" size="10"/></td>
          <%}if("1".equals(ifShowGiftBag)){%>
          <td align="right"><%=giftbag%> max ringtone number:</td>
          <td align="left"><input type="text" name="d2" value="<%=d2%>" size="10"/></td>
           <%}%>
          </tr>
        </tr>
        <tr >
         <%if("1".equals(sysringgrpenable)){%>
          <td align="right"><%=musicbox%> min ringtone number:</td>
          <td align="left"><input type="text" name="m3" value="<%=m3%>" size="10"/></td>
          <%}if("1".equals(ifShowGiftBag)){%>
          <td align="right"><%=giftbag%> min ringtone number:</td>
          <td align="left"><input type="text" name="d3" value="<%=d3%>" size="10"/></td>
          <%}%>
          </tr>
        </tr>
        <tr>
          <td colspan="4" align="center"><img src="button/sure.gif" onmouseover="this.style.cursor='hand'" onclick="javascript:doSure()"></td>
        </tr>
      </table>
      <!--
      <br>
      Note:<br>
         1.If the price upper limit of the music box or gift-bag is set to 0, the system does not restrict the user input price<br>
         2.f the maximum or minimum tone number of the <%=musicbox%> or <%=giftbag%>  is set to 0, the system does not restrict the tone number input by the user.      -->
    </td>
  </tr>
</table>
</form>
<%
        }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");
                    document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry,you have no access to the function!");
              </script>
              <%

              }
         }
    }
    catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "Exception occourred in the paramter management of system ringtone group! ");//系统铃音组参数管理过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occourred in the paramter management of system ringtone group!");//系统铃音组参数管理过程出现异常!
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="musicParaSet.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

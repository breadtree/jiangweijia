<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.HashMap" %>

<%@ page import="zxyw50.manSysRing" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>

<jsp:useBean id="mansys" class="zxyw50.manSysRing" scope="request"/>

<html>
  <head>
    <meta http-equiv="Content-Language" content="zh-cn">
    <title>Ring Promo Launch</title>
    <link rel="stylesheet" type="text/css" href="style.css">
	<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
	<script language="Javascript" src="../manager/calendar.js"></script>
    <script language="javascript">
		function addRingPromo()
	    {
			var fm = document.ringForm;
			var js_launchDate = fm.launchDate.value;
			var js_endDate = fm.endDate.value;
			
			if( !isNaN(js_launchDate) )
			{
				alert("Please enter Launch Date!");
				fm.launchDate.focus();
				return false;
			}
			else if( !isNaN(js_endDate) )
			{
				alert("Please enter End Date!");
				fm.endDate.focus();
				return false;
			}
			
			if( !compareDate2(js_launchDate,js_endDate) )
			{
				alert("Lauch date should be prior to end date");
				fm.launchDate.focus();
				return false;
			}
			if( checktrue22(js_launchDate) )
			{
				alert('Launch date cannot be prior to current date!');//起始时间不能大于当前时间
				fm.launchDate.focus();
				return false;
			}
			if( checktrue22(js_endDate) )
			{
				alert('End date cannot be prior to current date!');//起始时间不能大于当前时间
				fm.endDate.focus();
				return false;
			}
			fm.action="ringPromoLaunch.jsp?goto=add";
			fm.submit();
		}
	
	  	function deleteRingPromo()
	  	{
			var fm = document.ringForm;
			fm.action="ringPromoLaunch.jsp?goto=delete";
			fm.submit();
	  	}
	  
	   	function updateRingPromo()
	  	{	
			var fm = document.ringForm;
			var js_launchDate = fm.launchDate.value;
			var js_endDate = fm.endDate.value;
					
			if( !compareDate2(js_launchDate,js_endDate) )
			{
				alert("Lauch date should be prior to end date");
				fm.launchDate.focus();
				return false;
			}
			if( checktrue22(js_launchDate) )
			{
				alert('Launch date cannot be prior to current date!');//起始时间不能大于当前时间
				fm.launchDate.focus();
				return false;
			}
			if( checktrue22(js_endDate) )
			{
				alert('End date cannot be prior to current date!');//起始时间不能大于当前时间
				fm.endDate.focus();
				return false;
			}
			fm.action="ringPromoLaunch.jsp?goto=update";
			fm.submit();
	  }
    </script>
	</head>

<%
	 HashMap getringMap = new HashMap();
	 getringMap = mansys.getRingPromoLaunch(); 	 //getting the ring promo launch values from mansysring class
%>

<%
	 String launchDate = request.getParameter("launchDate") == null ? "" : request.getParameter("launchDate").toString().trim();
	 String endDate = request.getParameter("endDate") == null ? "" : request.getParameter("endDate").toString().trim();
	 
	 HashMap ringMap = new HashMap();
     ringMap.put("launchDate",launchDate);
	 ringMap.put("endDate",endDate);
%>
   <body>
<%
	Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
	String operID = (String)session.getAttribute("OPERID");
	String operName = (String)session.getAttribute("OPERNAME");
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	try 
	{
		if (operID != null && purviewList.get("2-67") != null) 
		{
	
			String submit_method=(String)request.getParameter("goto");
			System.out.println("goto : " +submit_method);
			int flag=0;//if flg=1 then add data
						//if flg=2 then update data
						//if flg=3 then delete data
			int result=-1;	
			if(submit_method!=null && "add".equalsIgnoreCase(submit_method))
			{
				flag = 1;
				result = mansys.addupdatedeleteRingPromoLaunch(ringMap,flag);//call add method of mansysring
				System.out.println("result======="+result);
				if( result == 1)
				{
%>
<script type="text/javascript">
	alert("Ring promo date added successfully!");
</script>
<%				}
				getringMap = mansys.getRingPromoLaunch();
			}
			if(submit_method!=null && "update".equalsIgnoreCase(submit_method))
			{
				System.out.println("goto3: ");//call update method of mansysring
				flag = 2;
				result = mansys.addupdatedeleteRingPromoLaunch(ringMap,flag);
				System.out.println("result======="+result);
				if( result == 1)
				{
%>
<script type="text/javascript">
	alert("Ring promo date updated successfully!");
</script>		
<%				}
				getringMap = mansys.getRingPromoLaunch();
			}
			if(submit_method!=null && "delete".equalsIgnoreCase(submit_method))
			{
				flag = 3;
				result = mansys.addupdatedeleteRingPromoLaunch(ringMap,flag);//call delete method of mansysring
				System.out.println("result======="+result);
				if( result == 1)
				{
%>
<script type="text/javascript">
	alert("Ring promo date deleted successfully!");
</script>
<%
				}
				getringMap = mansys.getRingPromoLaunch();
			}
			

%>

  <form name="ringForm" method="post" action="">
    <table width="535" border="0" cellspacing="0" cellpadding="0" align="center">
     <tr>
      <td valign="top">
	  <!-- Title begin -->
         <table width="535" border="0" align="center" class="table-style2">
		  <tr>
		  <td>&nbsp;</td>
		  </tr>
		   <tr>
             <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Ring Promo Launch </td>
		   </tr>
         </table>
      <!-- Title end -->
	
<% 
	//retrieving the ring promo launch values from mansysring class
	String ringLaunchDate = getringMap.get("launchDate")== null ? "" : (String)getringMap.get("launchDate").toString().trim();
	String ringEndDate = getringMap.get("endDate")== null ? "" : (String)getringMap.get("endDate").toString().trim();
%>
<table>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
</table>
<table width="346" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="image/004.gif" width="346" height="15"></td>
  </tr>
  <tr>
    <td background="image/006.gif"><table width="340" border="0" align="center" cellpadding="2" cellspacing="2">
      <tr>
        <td><table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="table-style2">
              <tr> 
                <td align="right" width="25%">&nbsp;Launch Date</td>
                <td align="left"> 
					<input type="text" name="launchDate" value="<%=ringLaunchDate%>" class="input-style1" readonly onclick="OpenDate(launchDate);"> 
                </td>
             </tr>
             <tr> 
                <td align="right" width="25%">&nbsp;End Date</td>
                <td align="left">
					<input type="text" name="endDate"  value="<%=ringEndDate%>" class="input-style1" readonly onclick="OpenDate(endDate);"> 
                </td>
             </tr>
             <tr> 
               <td align="right"> 
<%
	if (getringMap.size() <= 0)
	{
%>
               <img src="button/add.gif"  align="right" width="45" height="19" onMouseOver="this.style.cursor='hand'" onclick="javascript:addRingPromo()"> 
<%  
    }
	else
	{
%>
 			     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
            <td align="left">
			  <img src="button/refresh.gif" align="middle" width="45" height="19" onMouseOver="this.style.cursor='hand'"  onclick="javascript:updateRingPromo()"> 
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
              <img src="button/del.gif" align="middle" width="45" height="19" onMouseOver="this.style.cursor='hand'"  onclick="javascript:deleteRingPromo()"> 
            </td>
<%
	}
%>
          </tr>
         </table> 
               
                </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td><img src="image/005.gif" width="346" height="15"></td>
  </tr>
  </table>
        </td>
      </tr>
     </table>
    </td>
   </tr>
  </table>
 </form>
<%     }
        else {

          if(operID == null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system first!");//请先登录系统
                    parent.document.URL = 'enter.jsp';
              </script>
              <%
                      }
                      else{
               %>
              <script language="javascript">
                   alert( "Sorry. You have no permission for this function!");//对不起，您没有权限操作该功能！
              </script>
              <%

              }
         }	
	}
    catch(Exception e) 
	{
    	e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(e.toString());
        vet.add("Error occurred in mixing ring!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
  <form name="errorForm" method="post" action="error.jsp">
    <input type="hidden" name="historyURL" value="ringPromoLaunch.jsp">
  </form>
  <script language="javascript">
  	 document.errorForm.submit();
  </script>
<%
    }
%>
</body>
</html>

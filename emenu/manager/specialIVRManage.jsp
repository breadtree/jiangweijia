<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.RingQuery" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
	Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
	zxyw50.Purview purview = new zxyw50.Purview();
	Hashtable sysfunction = purview.getSysFunction() == null ? new Hashtable() : purview.getSysFunction();
    String sysTime = "";
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String  optSCP = "";
    String  errmsg = "";
   try {
       boolean   flag =true;
       if (operID  == null){
          errmsg = "Please log in to the system first!";
          flag = false;
       }
      if (purviewList.get("3-42") == null &&  sysfunction.get("3-42-0")== null) {
            errmsg = "Sorry,you have no access to this function!";//You have no access to this function!
            flag = false;
          }
		 //flag=true;
		 if(flag){
		 	RingQuery ringQuery=new RingQuery();
			String ivrCat = (String)request.getParameter("ivrCat");
			if(ivrCat==null || ivrCat.equals(""))
				ivrCat="1";
			Vector prefixList = new Vector();
			Vector langList = new Vector();
			Vector prefixDetails = new Vector();
			langList=ringQuery.getLanguage();
			String optIpList="";
			String prefixlistDetails="";
			String ivrPrefix = (String)request.getParameter("prefixlist");
			if(ivrCat!=null){
				
				prefixList=ringQuery.getCallPrefixInfo(ivrCat);
			}
			
		    for (int i = 0; i < prefixList.size(); i++) {
		       Hashtable hash = (Hashtable)prefixList.get(i);
			   String selected="";
			   if(ivrPrefix!=null && ivrPrefix.equals((String)hash.get("prefix")))
			   	  selected="selected='selected'";
		       optIpList = optIpList + "<option value=" + (String)hash.get("prefix") + " "+selected+">  " + (String)hash.get("prefix")+ " </option>";
		    }
			
			//String bflag = (String)request.getParameter("bflag");
			if(ivrPrefix!=null){
				prefixDetails=ringQuery.getPrefixIVRDetails(ivrPrefix,ivrCat);
			}
			 for (int i = 0; i < prefixDetails.size(); i++) {
		       HashMap hash = (HashMap)prefixDetails.get(i);
			   String selected="";
			   //if(ivrPrefix!=null && ivrPrefix.equals((String)hash.get("prefix")))
			   	  //selected="selected='selected'";
				  if(ivrCat.equals("1")){
				  	 prefixlistDetails = prefixlistDetails + "<option value=" + (String)hash.get("prefix")+"-"+(String)hash.get("dial")+"-"+(String)hash.get("singerid") + " "+selected+">  " + (String)hash.get("prefix")+ " - "+(String)hash.get("langname")+" - "+(String)hash.get("singername")+" </option>";
				  }else  if(ivrCat.equals("2")){
				  	 prefixlistDetails = prefixlistDetails + "<option value=" + (String)hash.get("prefix")+"-"+(String)hash.get("ringid") + " "+selected+">  " + (String)hash.get("prefix")+ " - "+(String)hash.get("ringlabel")+" </option>";
				  }
		      
		    }
			
			//Adding or modify or delete 
			String opType = (String)request.getParameter("opType");
			String result = null;
			if(opType!=null && !opType.equals("")){
				opType = (String)request.getParameter("opType");
				String pre = (String)request.getParameter("prefix");
				String dial = (String)request.getParameter("dial");
				String bflag = (String)request.getParameter("ivrCat");//bflag
				String singerid = (String)request.getParameter("singerid");
				String ringid = (String)request.getParameter("ringid");
				String oldDial = (String)request.getParameter("oldDial");
				
				HashMap map = new HashMap();
				
				
				map.put("optype",opType);
				map.put("prefix",pre);
				map.put("dial",dial);
				map.put("bflag",bflag);
				map.put("singerid",singerid);
				map.put("ringid",ringid);
				map.put("oldDial",oldDial);
				ArrayList updateResult = ringQuery.updatePrefixIVRDetails(map);
				Hashtable resultHash=new Hashtable();
				resultHash=(Hashtable)updateResult.get(0);
				
				result=(String)resultHash.get("reason");
				result = result.substring(result.indexOf(":")+1,result.length());
				if(((String)resultHash.get("result")).equals("0"))
						 	result="Updated Successfully";
				prefixDetails=ringQuery.getPrefixIVRDetails(ivrPrefix,ivrCat);
				 prefixlistDetails="";
				for (int i = 0; i < prefixDetails.size(); i++) {
				   HashMap hash = (HashMap)prefixDetails.get(i);
				   String selected="";
				   //if(ivrPrefix!=null && ivrPrefix.equals((String)hash.get("prefix")))
					  //selected="selected='selected'";
					 
					  if(ivrCat.equals("1")){
						 prefixlistDetails = prefixlistDetails + "<option value=" + (String)hash.get("prefix")+"-"+(String)hash.get("dial")+"-"+(String)hash.get("singerid") + " "+selected+">  " + (String)hash.get("prefix")+ " - "+(String)hash.get("langname")+" - "+(String)hash.get("singername")+" </option>";
					  }else  if(ivrCat.equals("2")){
						 prefixlistDetails = prefixlistDetails + "<option value=" + (String)hash.get("prefix")+"-"+(String)hash.get("ringid") + " "+selected+">  " + (String)hash.get("prefix")+ " - "+(String)hash.get("ringlabel")+" </option>";
					  }
				  
				}
			}
			
%>

<script src="../pubfun/JsFun.js"></script>

<html>
<head>
<link href="style.css" type="text/css" rel="stylesheet">
<title>CRBT</title>
</head>
<script>

function getPrefix(){
	var fm = document.inputForm;
	fm.submit();
}
function selectInfo () {
   var fm = document.inputForm;
   
   fm.submit();
}
function selectListInfo () {
   var fm = document.inputForm;
  
   var selValue=fm.prefixListDetails.value;
   <% if(ivrCat.equals("1")){%>
		var splitVar = selValue.split("-",3)
	    fm.singerid.value=splitVar[2];
	    fm.prefix.value=splitVar[0];
	    fm.dial.options[splitVar[1]].selected=true;
		fm.oldDial.value=splitVar[1];
   <%}else  if(ivrCat.equals("2")){%>
		var splitVar = selValue.split("-",2)
	    fm.ringid.value=splitVar[1];
	    fm.prefix.value=splitVar[0];
   <%}%>
   
   
}
function choosecode()
{
	 var fm = document.inputForm;
	 var result =  window.showModalDialog('singersearch.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
	 if(result){
       document.inputForm.singerid.value=result;
     }
}

 function queryInfo() {
 	 var fm = document.inputForm;
     var ringResult =  window.showModalDialog('ringSearch.jsp',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(ringResult){
       fm.ringid.value=ringResult;
     }
   }
   
   function doSubmit(type){
	 var fm = document.inputForm;
	 fm.opType.value=type;
	  if (fm.prefix.value == '') {
	  	alert("Please select a Prefix from the above list");//validating the prefix
		 fm.prefix.focus();
         return;
      }
	 <% if(ivrCat.equals("1")){%>
	  	 if (fm.dial.value == '' || fm.dial.value == '-1') {
			alert("Please select a language");//validating the lang
			 fm.dial.focus();
			 return;
		  }
		   if (fm.singerid.value == '') {
			alert("Please select a Artist");//validating the artsit
			 fm.singerid.focus();
			 return;
		  }
	 <%}else  if(ivrCat.equals("2")){%>
	 	 if (fm.ringid.value == '') {
			alert("Please select a ring tone");//validating the ring tone
			 fm.ringid.focus();
			 return;
		  }
	 <%}%>
	 fm.submit();
   }
</script>
<body topmargin="0" leftmargin="0" class="body-style1" >
<form name="inputForm" method="post" action="specialIVRManage.jsp" >
	<input type="hidden" name="opType">
	<input type="hidden" name="oldDial" >
	<table border="0" width="500" align="center" cellspacing="0" cellpadding="0" class="table-style2" >
		<tr >
			  <td height="20" colspan="2"  align="center">&nbsp;</td>
	   </tr>
	   <tr >
			  <td height="26" colspan="2"  align="center"  background="image/n-9.gif" class="text-title" >Special IVR management </td>
	   </tr>
	   <tr >
	     <td height="20" colspan="2"  align="center" class="text-error"><%if(result!=null){%><%=result%><%}%></td>
      </tr>
	   <tr >
	     <td width="153" height="20"  align="center">IVR</td>
         <td width="347"  align="left">
			 <select name="ivrCat" onChange="getPrefix();" id="ivrCat">
			   <option value="1" <%if(ivrCat!=null && ivrCat.equals("1")){%> selected="selected"<%}%>>Artist IVR</option>
			   <option value="2"  <%if(ivrCat!=null && ivrCat.equals("2")){%> selected="selected"<%}%>>Popular Song IVR</option>
		 </select>		 </td>
      </tr>
	  <%if(prefixList.size()>0){%>
	   <tr >
	     <td height="20"  align="center">&nbsp;</td>
	     <td align="center">&nbsp;</td>
      </tr>
	   <tr >
	   	<td height="20"  align="center">Call Prefix</td>
	     <td align="left">
		 	<select name="prefixlist" size="6" <%= prefixList.size() == 0 ? "disabled " : "" %> style="width:200px" onclick="javascript:selectInfo()">
              <% out.print(optIpList); %>
         </select>		 </td>
      </tr>
	  <%}%>
	   <tr >
	     <td height="20" colspan="2"  align="center">&nbsp;</td>
      </tr>
	   <tr >
			  <td height="20" colspan="2"  align="center">
			  
			  	<table border="0" width="500" align="center" cellspacing="0" cellpadding="0"  id="mainTable" >
						 <tr >
			  				<td height="20"   align="center">
								<select name="prefixListDetails" size="6" class="table-style2" style="width:200px;margin-left:20px" <%= prefixList.size() == 0 ? "disabled " : "" %> onclick="javascript:selectListInfo()">
              <% out.print(prefixlistDetails); %>
             </select>
							</td>
							<td height="20" align="center" class="table-style2">
								<table border="0" width="278" align="center" cellspacing="0" cellpadding="0">
									<tr >
									  <td width="97" height="20"   align="center" class="table-style2">Prefix</td>
									  <td width="189"   align="left" height="30">
									    <input name="prefix" id="prefix" type="text" readonly="true">
									  </td>
								  </tr>
								  <tr>
								  	<td colspan="2" id="table1" >
										<table border="0" width="286" align="right" cellspacing="0" cellpadding="0"  >
											<tr >
												  <td width="98" height="20"   align="center" class="table-style2">Language</td>
												  <td width="188" height="30"   align="left">
													<select class="table-style2" name="dial">
														<option value="-1">Select</option>
														<%for(int i=0;i<langList.size();i++){
															 HashMap hash = (HashMap)langList.get(i);
															int dial = Integer.parseInt((String)hash.get("dial"));
														%>
															<option value="<%=dial%>"><%=(String)hash.get("langname")%></option>
														<%}%>
														
													</select>
											  </td>
										  </tr>
												<tr >
												  <td height="20"   align="center" class="table-style2">Artist</td>
												  <td   align="left" height="30">
													<input type="text" name="singerid" readonly="true">
													<img src="../image/query.gif" name="qrybtn" onMouseOver="this.style.cursor='hand'" onClick="javascript:choosecode()"/>
												</td>
											  </tr>
									  </table>
									</td>
								  </tr>
									
									
								  <tr>
								  	<td colspan="2">
										<table border="0" width="278" align="center" cellspacing="0" cellpadding="0" style="display:none" id="table2" >
											<tr >
											  <td height="20" width="98"  align="center" class="table-style2">Ring</td>
											  <td width="188"  align="left" height="30">
												<input type="text" name="ringid" value="" maxlength="20" class="input-style1"><img  height="15" src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onClick="javascript:queryInfo()">
											</td>
										  </tr>
											<tr >
											  <td height="20"   align="center">&nbsp;</td>
											  <td   align="center" class="table-style2">&nbsp;</td>
										  </tr>
											
										</table>
									</td>
								  </tr>
									<tr >
			  							<td height="20"   align="center">&nbsp;</td>
									    <td   align="center" class="table-style2"><label>
									      <input type="button" name="Submit" value="Add" class="table-style2" onClick="doSubmit(1);">
									    
								        <input type="button" name="Submit2" value="Delete" class="table-style2" onClick="doSubmit(2);">

								        <input type="button" name="Submit3" value="Modify" class="table-style2" onClick="doSubmit(3);">
</label></td>
									</tr>
								</table>
								
								
						   </td>
						</tr>
				</table>
			  </td>
	   </tr>
  </table>
  	
</form>
<script>
	 <%if(ivrPrefix!=null  && !ivrPrefix.equals("")){%>	
	 	var fm = document.inputForm;
		fm.prefix.value=fm.prefixlist.value;
	 	  <% if(ivrCat.equals("1")){%>
			   document.getElementById('table1').style.display='block';
			   document.getElementById('table2').style.display='none';
		   <%}else if(ivrCat.equals("2")){%>
			  document.getElementById('table1').style.display='none';
			  document.getElementById('table2').style.display='block';
		   <%}%>
	<%}%>
</script>
	
<%
        }
        else {
%>
<script language="javascript">
   alert("<%=  errmsg  %>");
   document.URL = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + " exception occourred in the Stat.of subscriber feed back info!");// 用户铃音活动统计操作查询过程出现异常!
        sysInfo.add(sysTime + operName + e.toString());
        //vet.add("用户铃音活动统计操作查询过程出现错误!");
        vet.add("Error occourred in the Stat.of subscriber feedback!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="queryDyRing.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

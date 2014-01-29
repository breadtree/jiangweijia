<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Vector" %>

<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>

<%@ page import="zxyw50.manUser" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.manSysPara" %>

<%@ page import="zxyw50.CrbtUtil" %>
<%@ page import="zxyw50.group.util.StringUtil" %>

<%@ include file="../pubfun/JavaFun.jsp" %>
<%@ include file="../base/includedman.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");

    manSysPara syspara = new manSysPara();
    //Added by Srinivas Rao.K on 18-05-2011, for 5.04.09[smart] for interactive SMS sale activity
    String isInteractiveSmsPurchase=syspara.getParaValue(26150);
	session.setAttribute("isInteractiveSmsPurchase",isInteractiveSmsPurchase);
	//end of added
%>

<html>
<head>
<title>Short message marketing activity</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
<script src="../base/common.js"></script>
<script src="../crbt.js"></script>
</head>

<body background="background.gif" class="body-style1" onLoad="init()">
  <script language="javascript">
  function init(){
    var fm = document.inputForm;
	var isInteractiveSmsPurchase = '<%=isInteractiveSmsPurchase%>';
	if(isInteractiveSmsPurchase != 1){ 
    if(fm.str.value==""){
      ;
    }else{
      if(typeof(fm.suoRingid.length) == "undefined"){
        if (fm.ischeck.checked){
          fm.suoRingid.style.display = 'block';
        }else{
          fm.suoRingid.style.display = 'none';
        }
      }else if (fm.ischeck.checked){
        for(var i=0;i<fm.suoRingid.length;i++){
          fm.suoRingid[i].style.display = 'block';
        }
      }else{
        for(var i=0;i<fm.suoRingid.length;i++){
          fm.suoRingid[i].style.display = 'none';
        }
      }
    }
		}
    if(fm.actType[0].checked){
      document.getElementById("table1").style.display  = 'block';
      document.getElementById("table3").style.display  = 'block';
      document.getElementById("table4").style.display  = 'none';
     // this.table3.style.display = 'block';
    //  this.table4.style.display = 'none';
    }else{
	  document.getElementById("table1").style.display  = 'none';
      document.getElementById("table3").style.display  = 'none';
      document.getElementById("table4").style.display  = 'block';
     // this.table1.style.display = 'none';
    //  this.table3.style.display = 'none';
   //   this.table4.style.display = 'block';
    }
	
  }
  </script>
  
  <%
    // add for starhub
    String user_number = CrbtUtil.getConfig("userNumber", "Subscriber number");
    String usecalling  = zte.zxyw50.util.CrbtUtil.getConfig("usecalling","0");
    String isimage  = zte.zxyw50.util.CrbtUtil.getConfig("isimage","0");
    manSysRing sysring = new manSysRing();
    manUser manuser = new manUser();
    String marketcount = CrbtUtil.getConfig("marketcount","5");
    int ifuseutf8 = zte.zxyw50.util.CrbtUtil.getConfig("ifuseutf8", 0); //4.13
    String sysTime = sysring.getSysTime() + "--";
    int stopDate = Integer.parseInt(sysTime.substring(11,13));
    String hringid = request.getParameter("hringid") == null ? "" : ((String)request.getParameter("hringid")).trim();
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String objSort = request.getParameter("objSort") == null ? "3" : ((String)request.getParameter("objSort")).trim();
    String hdlist = request.getParameter("hdlist") == null ? "" : ((String)request.getParameter("hdlist")).trim();
    String usernumber = request.getParameter("usernumber") == null ? "" : ((String)request.getParameter("usernumber")).trim();
    String scp = request.getParameter("scplist") == null ? "" : transferString((String)request.getParameter("scplist")).trim();
    String ischeck = request.getParameter("ischeck") == null ? "0" : ((String)request.getParameter("ischeck")).trim();
    String listfile = request.getParameter("listfile") == null ? "" : (String)request.getParameter("listfile");
    String filename = request.getParameter("filename") == null ? "" : (String)request.getParameter("filename");
    String ringlist = request.getParameter("ringlist") == null ? "" : transferString((String)request.getParameter("ringlist"));
    String messageend = request.getParameter("messageend") == null ? "" : transferString((String)request.getParameter("messageend"));
    String messagestart = request.getParameter("messagestart") == null ? "" : transferString((String)request.getParameter("messagestart"));
    String actType = request.getParameter("actType") == null ? "" : transferString((String)request.getParameter("actType"));
    String op = request.getParameter("op") == null ? "" : transferString((String)request.getParameter("op")).trim();
    String smsmsg = request.getParameter("smsmsg") == null ? "" : transferString((String)request.getParameter("smsmsg")).trim();
    
    String msg = "";
    String str = "";
    String label = "";
    
    //Added by Srinivas Rao.K on 18-05-2011, for 5.04.09[smart] for interactive SMS sale activity
	String style = "display:block";
	if(isInteractiveSmsPurchase.equals("1")){
		style = "display:none";
	}
	//end of added
	
    if(op.equals("again")){
      session.removeAttribute("ringlist");
      session.removeAttribute("ringlabel");
      ischeck = "0";
    }
    
    String suoringids [] = request.getParameterValues("suoRingid");
    String ringidlabel[] = StringUtil.split(ringlist,"#");

    if(!ringlist.equals("")){
	   //Added by Srinivas Rao.K on 18-05-2011, for 5.04.09[smart] for interactive SMS sale activity
	    if(isInteractiveSmsPurchase.equals("1") && "1".equals(actType)){ 
    		if(str == null) 
    			str = "";
       		if(label == null) 
       			label = "";
        	if(ringidlabel.length==2){
	            str = str + ringidlabel[0];
	            label = label + ringidlabel[1];
       		}
        }//end of added
		else{
      str = (String)session.getAttribute("ringlist");
      label = (String)session.getAttribute("ringlabel");
	        if(str == null) 
	        	str = "";
	        if(label == null) 
	        	label = "";
      if(ringidlabel.length==2){
        str = str + ringidlabel[0];
        label = label + ringidlabel[1];
      }
   		}
      ringlist = "";
    }else{
      str = (String)session.getAttribute("ringlist");
      label = (String)session.getAttribute("ringlabel");
      if(str == null) str = "";
      if(label == null) label = "";
    }
	
    String [] strs = StringUtil.split(str,"|");
    String [] labels = StringUtil.split(label,"|");
    if(op.equals("del")){
		String rings[] = StringUtil.split(str,"|");
		str = "";
		for(int i=0;i<rings.length-1;i++){
			if(rings[i].equals(hringid)){
			   continue;
			}else{
				str = str+rings[i]+"|";
			}
		}
%>
<form name="resultForm" method="post" action="marketCount.jsp">
<input type="hidden" name="usernumber" value="<%=usernumber%>">
<input type="hidden" name="messagestart" value="<%=messagestart%>">
<input type="hidden" name="messageend" value="<%=messageend%>">

<script language="javascript">
	document.resultForm.submit();
</script>
</form>
<%
	}
	
    session.setAttribute("ringlist",str);
    session.setAttribute("ringlabel",label);
    
    int order = request.getParameter("order") == null ? -1 : Integer.parseInt((String)request.getParameter("order"));
    String optSCP = "";
    ArrayList scplist = syspara.getScpList();
    for (int i = 0; i < scplist.size(); i++) {
      if(i==0 && scp.equals(""))
      scp = (String)scplist.get(i);
      optSCP = optSCP + "<option value=" + (String)scplist.get(i) + " > " + (String)scplist.get(i)+ " </option>";
    }
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    
    Vector vetSubservice = syspara.getSubService();
    String subservice    = request.getParameter("subservice") == null ? "" : 
                                transferString((String)request.getParameter("subservice")).trim();
	if("".equals(subservice))
   {
   	//取第一个子业务
      Hashtable tmpHash = (Hashtable)vetSubservice.get(0);
      subservice = (String)tmpHash.get("subservice");
   }
   String usertype    = request.getParameter("usertype") == null ? "" : 
                          transferString((String)request.getParameter("usertype")).trim();
	Vector vetUsertype = syspara.getUserTypeInfo(subservice);
    
    try {
      sysTime = sysring.getSysTime() + "--";
      if (operID != null && purviewList.get("1-16") != null) {
        HashMap map1 = new HashMap();
        if(order == -1){
      %>


<script language="JavaScript">
	if(parent.frames.length>0)
          parent.document.all.main.style.height="600";
</script>
<form name="inputForm" method="post" action="marketCount.jsp">
<input type="hidden" name="op" value="">
<input type="hidden" name="hringid" value="<%=hringid%>">
<input type="hidden" name="order" value="-1">
<input type="hidden" name="listfile" value="<%=listfile%>">
<input type="hidden" name="filename" value="<%=filename%>">
<input type="hidden" name="ringlist" value="<%=ringlist%>">
<input type="hidden" name="str" value="<%=str%>">
<input id="res" type="hidden" name="result" value=""/>
<table width="90%" height="400" border="0" align="center" class="table-style2">
  <tr valign="center">
  <td>
         <table width="100%" border="0" align="center" class="table-style2">
        <tr >
          <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Short message marketing activity</td>
        </tr>
        <tr >
          <td height="26" colspan="2" >
          <input type="radio" value="1" name="actType" <%if(!"2".equals(actType)){%> checked<%}%> onClick="actclick()"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> activity<input type="radio" value="2" name="actType" onClick="actclick()" <%if("2".equals(actType)){%> checked<%}%>>Non <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> activity          </td>
        </tr>
        <td align="center">        </td>
        <td height='100%'>
            <table id="table1" width="100%" border ="0" class="table-style2" style="display:block">
              <tr> 
                <td   colspan="2" width="40%"> Short message prefix&nbsp;                </td>
                <td width="60%"><input type="text" name="messagestart" value="<%= messagestart%>" maxlength="100" class="input-style7" size=35 ></td>
              </tr>
            </table>
            <table width="100%" border = "0" class="table-style2">
            <tr>
              <td width="35%"  height="26"><input type="radio" name="objSort" value="1" onClick="selectClick()" <%if("1".equals(objSort)){%> checked<%}%>><%=user_number%> segment</td>
              <td align="left" height="26"><input type="radio" name="objSort" value="2" onClick="selectClick()" <%if("2".equals(objSort)){%> checked<%}%>>File list&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                           <input type="radio" name="objSort" value="3" onClick="selectClick()" <%if(!"1".equals(objSort) && !"2".equals(objSort)){%>checked<%}%>><%=user_number%></td>
            </tr>
            <%if("1".equals(objSort)){%>
            <tr>
              <td  height="41" rowspan="5">Transmitting object</td>
              <td width="727" height="16">
                SCP:&nbsp;<select name="scplist" size="1" onChange="javascript:onSCPChange()" style="width:150px">
                <% out.print(optSCP); %>
                </select>                </td>
            </tr>
            <tr>
              <td width="727" height="18">
                Segment:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="hdlist" value="<%= hdlist%>" maxlength="20" class="input-style1"></td>
            </tr>

        		<tr>
          		<td width="727" height="16">Subservice:
          			<select name="subservice" size="1" <%= vetSubservice.size() == 0 ? "disabled " : "" %>class="input-style1" onclick="javascript:selectSub()">
<%
					

                for (int i = 0; i < vetSubservice.size(); i++) {
                	  //不支持group,plus

                    Hashtable hash = (Hashtable)vetSubservice.get(i);
                    if(!((String)hash.get("subservice")).equals("4")&&!((String)hash.get("subservice")).equals("8"))
                    {
             if(((String)hash.get("subservice")).equals("2"))
             {if(usecalling.equals("0"))
              continue;
               }
            else if(((String)hash.get("subservice")).equals("16"))
             {if(isimage.equals("0"))
              continue;
               }
%>
              		<option value="<%=(String)hash.get("subservice") %>"
              			<%=((String)hash.get("subservice")).equals(subservice)?" selected ":""%>
              			><%= (String)hash.get("description") %></option>
<%
            	}
 }
%>
            		</select>          		</td>
        		</tr>
            
            
          <tr>
          	<td width="727" height="16">User type:&nbsp;&nbsp;
            <select name="usertype" size="1" class="input-style1" >
				<% if(vetUsertype.size()>1)
					{%>
            	<option value="-1">All </option>
            	<%}%>
<%
                for (int i = 0; i < vetUsertype.size(); i++) {
                    Hashtable hash = (Hashtable)vetUsertype.get(i);
%>
              <option value="<%=(String)hash.get("usertype")+ "" %>"
              		<%=((String)hash.get("usertype")).equals(usertype)?" selected ":""%>
              >
              	<%= (String)hash.get("utlabel") %>              </option>
<%
            }
%>
            </select>          </td>
         </tr>
          
         <tr>
         	<td align="center">
         		<img border="0" src="button/search.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:searchUser()">         	</td>
         </tr>  
            
            
            <% }else if("2".equals(objSort)){%>
            <tr>
              <td  height="51">Transmitting object</td>
              <td width="727" height="51"><input type="text" name="filetext" size="20" class="input-style1" value="<%= filename%>" disabled>&nbsp;<img src="button/file.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:selectFile()"></td>
            </tr>
            <% }else{%>
            <tr>
              <td  height="26">Transmitting object</td>
              <td width="727" height="26"><input type="text" name="usernumber" value="<%=usernumber%>" maxlength="20" class="input-style1"></td>
            </tr>
            <% }%>
            </table>
            <table id="table3" width="422" border ="0" class="table-style2" style="display:block">
            <tr>
             <td width="155" align="right" height="27">Query <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%></td>
             <td align="left"><img src="button/query.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:queryInfo()"></td>
            </tr>
            <tr class="tr-ringlist">
             <td width="155" align="center" height="27"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code</td>
             <td width="257" align="center" height="27" style="<%=style%>">Abbreviated code</td>
	     <td width="257" align="center" height="27">Delete</td>
            </tr>
            <%
			//Added by Srinivas Rao.K on 18-05-2011, for 5.04.09[smart] for interactive SMS sale activity
			 if(isInteractiveSmsPurchase.equals("1")){
				if(str.length() > 0){
	    %>
			  <tr  bgcolor="FFFFFF"%>
               <td width="155" height="27" align="center"><%= str%><input type="hidden" name="ringid" value="<%= str%>">	</td>
			   
			   <td width="257" height="27" align="center">
				<img src="../image/delete.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:deleteInfo('<%= str%>')">
			   </td>
			  </tr>
			<%}
			}else if(strs != null){
              for(int i=0;i<strs.length-1;i++){%>
                <tr  bgcolor="<%= (i-1) % 2 == 0 ? "FFFFFF" : "E6ECFF" %>">
                  <td width="155" height="27" align="center"><%= strs[i]%><input type="hidden" name="ringid" value="<%= strs[i]%>"></td>
                  <td width="257" height="27" align="center" style="<%=style%>"><input type="text" name="suoRingid" value="" maxlength="20" class="input-style1" size="20" style="display:none"></td>
				    <td width="257" height="27" align="center"><img src="../image/delete.gif" onMouseOver="this.style.cursor='pointer'" onClick="javascript:deleteInfo('<%=strs[i]%>')"></td>
							   
				    
                </tr>
                <% }
                }
            %>
            <tr style="<%=style%>">
            <td width="155" align=right height="27"><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> code type</td>
             <td width="257" height="27"><input type="checkbox" name="ischeck" value="1" <%if("1".equals(ischeck)){%> checked<%}%> onClick="ringidcheck()">Abbreviated code            </tr>
            <tr>
            <td colspan="2" align="center" height="27">
              <table border="0" width="100%" class="table-style2"  align="center" height="38">
                    <tr> 
                      <td width="35%" > Short message suffix&nbsp;                      </td>
                      <td width="65%"  ><input type="text" name="messageend" value="<%= messageend%>" maxlength="100" class="input-style7" size=35 ></td>
                    </tr>
                  </table>              </td>
            </tr>
            </table>
            <table id="table4" width="422" border =0 class="table-style2" height='106' style="display:none">
            <tr>
            	<td>
            		<textarea name="smsmsg" rows="8" cols="57"></textarea>            	</td>
            </tr>
			</table>
              <table width="422" border =0 class="table-style2">
              <tr>
                <td align="right"><div align="center">&nbsp;&nbsp;</div></td>
              </tr>
              </table>

              <br>
              <br>
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<img src="button/send.gif" onMouseOver="this.style.cursor='pointer'" alt="Send" onClick="javascript:addInfo()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="button/again.gif" onMouseOver="this.style.cursor='pointer'" alt="Reset" onClick="javascript:again()"></td>
     </tr>
     </table>
</form>

<%
    }
else if(order == 0){
      session.removeAttribute("ringlist");
      session.removeAttribute("ringlabel");
      //新增事件******************
      int optype = 0;
      String title = "";
      if (op.equals("add")){
        optype = 1;
        title = "Short message marketing activity";
      }
      Vector log = new Vector();
      if(optype>0){
        //Added by Srinivas Rao.K on 18-05-2011, for 5.04.09[smart] for interactive SMS sale activity
        if("1".equals(actType)){
        	if(isInteractiveSmsPurchase.equals("1") && "1".equals(actType)){ 
			  msg += (1+"Code is:")+str + "," +label+";";
          }//end of added
		  else{
          if(ischeck.equals("1")){
            for(int i=0;i<suoringids.length;i++){
              msg += (i+1+"Code is:")+suoringids[i] + "," +labels[i]+";";
            }
          }else{
            for(int i=0;i<strs.length-1;i++){
              msg += (i+1+"Code is:")+strs[i] + "," +labels[i]+";";
            }
          }
        }
          msg = messagestart + msg + messageend;
        }else{
          msg = smsmsg;
        }
        Vector vet = new Vector();
        Hashtable hashtabel = new Hashtable();
        //操作日志
        Vector list = new Vector();
        Hashtable rTem = new Hashtable();
        if(objSort.equals("1")){//选择业务区号段
          try{
            //list = sysring.getHdUsernumber(hdlist,scp);
            list = sysring.getHdUsernumber(hdlist,scp,subservice,usertype);
            
          }catch(YW50Exception e1e1){
            log.add(e1e1.getMessage());
          }
          for(int i=0;i<list.size();i++){
            rTem = (Hashtable)list.get(i);
            try{
              if(i%100 == 0 && i != 0){
                Thread thread = new Thread();
                thread.sleep(1000);
                thread.start();
              }
			 
             //Added by Srinivas Rao.K on 18-05-2011, for 5.04.09[smart] for interactive SMS sale activity
			  if(isInteractiveSmsPurchase.equals("1")&& "1".equals(actType)){
				manuser.sendMessage2((String)rTem.get("usernumber"),msg,str,1);
			  }//end of added
			  else{
              manuser.sendMessage((String)rTem.get("usernumber"),msg);
			  }
              log.add("Subscriber"+(String)rTem.get("usernumber")+" transmit successfully");
              zxyw50.Purview purview = new zxyw50.Purview();
              map1 = new HashMap();
              map1.put("OPERID",operID);
              map1.put("OPERNAME",operName);
              map1.put("OPERTYPE","116");
              map1.put("RESULT","1");
              map1.put("PARA1",(String)rTem.get("usernumber"));
              map1.put("PARA2","ip:"+request.getRemoteAddr());
              map1.put("DESCRIPTION",title);
              purview.writeLog(map1);
            }catch(YW50Exception e1){
              log.add("Subscriber "+(String)rTem.get("usernumber")+":"+e1.getMessage());
            }
          }
        }
        else if(objSort.equals("3")){//选择单个用户,输入User number
          try{
        	//Added by Srinivas Rao.K on 18-05-2011, for 5.04.09[smart] for interactive SMS sale activity
			if(isInteractiveSmsPurchase.equals("1")&& "1".equals(actType)){
            	manuser.sendMessage2(usernumber,msg,str,1);
			}//end of added
			else{
            manuser.sendMessage(usernumber,msg);
			}
            log.add("Subscriber"+usernumber+":transmit successfully");
            zxyw50.Purview purview = new zxyw50.Purview();
            map1 = new HashMap();
            map1.put("OPERID",operID);
            map1.put("OPERNAME",operName);
            map1.put("OPERTYPE","116");
            map1.put("RESULT","1");
            map1.put("PARA1",usernumber);
            map1.put("PARA2","ip:"+request.getRemoteAddr());
            map1.put("DESCRIPTION",title);
            purview.writeLog(map1);
          }catch(YW50Exception e1){
            log.add("Subscriber "+usernumber+":"+e1.getMessage());
          }
        }
        else if (objSort.equals("2")){
          if (listfile.length() > 0){
            vet = sysring.analyseLargessNum(listfile);
          }
          for(int i=0;i<vet.size();i++){
            try{
              if(i%100 == 0 && i != 0){
                Thread thread = new Thread();
                thread.sleep(1000);
                thread.start();
              }
              
            //Added by Srinivas Rao.K on 18-05-2011, for 5.04.09[smart] for interactive SMS sale activity
			if(isInteractiveSmsPurchase.equals("1")&& "1".equals(actType)){
				 manuser.sendMessage2(vet.elementAt(i)+"",msg,str,1);
			}//end of added
			else{
              manuser.sendMessage(vet.elementAt(i)+"",msg);
			}
			
              log.add("Subscriber "+vet.elementAt(i)+":transmit successfully");
              zxyw50.Purview purview = new zxyw50.Purview();
              map1 = new HashMap();
              map1.put("OPERID",operID);
              map1.put("OPERNAME",operName);
              map1.put("OPERTYPE","116");
              map1.put("RESULT","1");
              map1.put("PARA1",vet.elementAt(i)+"");
              map1.put("PARA2","ip:"+request.getRemoteAddr());
              map1.put("DESCRIPTION",title);
              purview.writeLog(map1);
            }catch(Exception e1){
              log.add("Subscriber"+vet.elementAt(i)+":"+e1.getMessage());
            }
          }
        }
      } %>
<form name="inputForm" method="post" action="marketCount.jsp">
<input type="hidden" name="order" value="<%= (order + 1) + "" %>">
<input type="hidden" name="str" value="">
<table border="0" align="center" class="table-style2" style="display:none">
  <tr align="center">
    <td>
      <input type="radio" value="1" name="actType" checked><%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> activity&nbsp;&nbsp;&nbsp;<input type="radio" value="2" name="actType">None <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> activity</table>
    </td>
  </tr>
</table>
<table id="table1" style="display:none"></table>
<table id="table3" style="display:none"></table>
<table id="table4" style="display:none"></table>
<table border="0" height="100%" align="center" >
  <tr valign="center">
    <td>
      <table border="0" align="center" class="table-style2">
        <%if(log.size()>0){
        for(int i=0;i<log.size();i++){
        %>
        <tr align="center">
          <td align="center" ><%=(String)log.elementAt(i)%> </td>
        </tr>
        <% } }else{%>
        <tr>
          <td align="center" height="22" >No available subscriber number can be transmitted!</td>
        </tr>
       <% }%>
        <tr>
          <td align="center"><a href="marketCount.jsp"><img src="button/back.gif" onMouseOver="this.style.cursor='pointer'" border="0"></a></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
  <%
    }
    }
    else {
      if(operID == null){
        %>
        <script language="javascript">
        alert( "Please log in to the system first!");
        document.location.href = 'enter.jsp';
        </script>
        <%
      }
      else{
        %>
        <script language="javascript">
          alert( "Sorry,you have no access to this function!");
          </script>
          <%

        }
      }
      }
      catch(Exception e) {
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + "It is abnormal during the short message marketing!");
        sysInfo.add(sysTime + operName + e.toString());
        vet.add("Error occurs during the short message marketing!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
        %>
        <form name="errorForm" method="post" action="error.jsp">
          <input type="hidden" name="historyURL" value="marketCount.jsp">

        </form>
        <script language="javascript">
        document.errorForm.submit();
        </script>
        <%
      }

      %>
      </body>
    </html>


<script language="javascript">

	function checkInvalidchars(msg,desc)
	  {
		for( i = 0; i < msg.length;  i++)
		{
			var sChar = msg.charAt(i);
			if (sChar=='|' ||  sChar=='"')
			{
				alert(desc +" cannot include the character "+sChar);
				return false;
			}
		}
		return true;
	}
	  

var XmlHttp=CreateXmlHttpReq();

function checkInfo () {
  var fm = document.inputForm;
  var msg = fm.smsmsg.value;
  var msgsuffix = fm.messageend.value;
  var msgprefix = fm.messagestart.value;
  
  var flag = false;
  if(<%=objSort%> == "1" && trim(fm.hdlist.value) == ""){
    alert("Please input the transmitting <%=user_number%> segment!");
    fm.hdlist.focus();
    return flag;
  }
//  if(<%=objSort%> == "1" &&  (trim(fm.hdlist.value)).length < 7){
//    alert("输入的用户号段长度不能小于7!");
//    fm.hdlist.focus();
//    return flag;
//  }

	//用户号段必须是数字
  if(<%=objSort%> == "1" &&  (!checkstring('0123456789',fm.hdlist.value))) {
  		alert('<%=user_number%> segment must be digits.');
      fm.hdlist.focus();
      return;
      
  }


  if(<%=objSort%> == "2" &&  trim(fm.filetext.value) == ""){
    alert('Please select the directory file first!');//请先选择目录文件!
    return;
  }
  if(<%=objSort%> == "3" && trim(fm.usernumber.value) == ""){
    alert("Please input the transmitting <%=user_number%> segment!");//请输入发送的User number!
    return flag;
  }
  if (<%=objSort%> == "3" && !checkstring('0123456789',trim(fm.usernumber.value))) {
    alert('<%=user_number%> must be in the digit format!');//User number必须是数字!
    fm.usernumber.focus();
    return flag;
  }
  if(fm.actType[0].checked){
    if(fm.ischeck.checked == true){
      if(typeof(fm.suoRingid.length) == "undefined"){
        if(fm.suoRingid.value == ""){
          alert("Please input the corresponding abbreviated code!");//请输入对应的缩位编码!
          return flag;
        }
      }else{
        for(var i=0;i<fm.suoRingid.length;i++){
          if(fm.suoRingid[i].value == ""){
            alert("Please input the corresponding abbreviated code!")
            return flag;
          }
        }
      }
    }
    <%
        if(ifuseutf8 == 1){
        %>
        if(!checkUTFLength(fm.messagestart.value,60)){
          alert("The message prefix's max length is 60!");//请输入需要发送的短信信息!
          fm.messagestart.focus();
          return flag;
        }
		
        if(!checkUTFLength(fm.messageend.value,60)){
          alert("The message suffix's max length is 60!");//请输入需要发送的短信信息!
          fm.messageend.focus();
          return flag;
        }
        <%
        }
        %>
    var tem = '<%= str%>';
    if(tem == ""){
      alert("Please query and select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%> to be transmitted!");//请先查询选择要发送的铃音!
      return flag;
    }
    var tem1 = tem.split("|");
    if(tem1.length-1>5){
      alert("The number of tones exceeds the limit. Refill it and query and select the <%=zte.zxyw50.util.CrbtUtil.getConfig("ringdisplay","ringtone")%>!");//铃音数量超出限制,点击重填按钮,重新查询选择铃音!
      return flag;
    }
  }
  if(fm.actType[1].checked){
    if(fm.smsmsg.value==""){
      alert("Please input the short message to be transmitted!");//请输入需要发送的短信信息!
      fm.smsmsg.focus();
      return flag;
    }
	if(!checkInvalidchars(msg,'short message')){
		return false;
	}
     <%
        if(ifuseutf8 == 1){
        %>

     if(!checkUTFLength(fm.smsmsg.value,160)){
      alert("The short message's max length is 160!");//请输入需要发送的短信信息!
      fm.smsmsg.focus();
      return flag;
    }

        <%
        }
        else{
        %>
    if(fm.smsmsg.value.length > 160){
      alert("The short message's max length is 160!");//请输入需要发送的短信信息!
      fm.smsmsg.focus();
      return flag;
    }

 <%}%>
  }
  if(!checkInvalidchars(msgprefix,'short message prefix')){
		return false;
  }
  if(!checkInvalidchars(msgsuffix,'short message suffix')){
		return false;
  }
  flag = true;
  return flag;
}

   function addInfo () {
      var fm = document.inputForm;
      if(!checkInfo())
        return;
      fm.op.value = 'add';
      
      

      if(fm.objSort[0].checked)
      {
      	var reqUrl = 'marketCountResult.jsp?op=querycount&hdlist='+fm.hdlist.value+'&scplist='+fm.scplist.value+'&subservice=<%=subservice%>&usertype='+fm.usertype.value;
     		XmlHttp.Open("POST",reqUrl,true);
      	XmlHttp.send(null);
      	XmlHttp.onreadystatechange=ServerProcess;
      	//等待服务器返回信息后才能继续提交      	
      }
      else
      {
         fm.order.value = "0";
      	fm.submit();
      }
   }
   
   
    function ServerProcess()
    {
    	var fm = document.inputForm;
    	var count = -1;
      if (XmlHttp.readystate==4 || XmlHttp.readystate=='complete')
      {
      	var users = XmlHttp.responseText;

      	try {
      		var count= parseInt(users);
      	}
      	catch (ex) {
      		count = -1;
      	}
      	
      	if(count < 0)
      	{
      		//未从服务器获得满足条件的号码数量,或者出错
      		if(confirm("Error in getting user numbers from server. Are you sure to send SMS still?"))
      		{
      			fm.order.value = "0";
        			document.inputForm.submit();
      		}
      	}
      	else if(count==0)
      	{
      		alert("There are no user numbers, so need not send SMS.");
      		return;
      	}
      	else
      	{
      		var str="There are "+ count +" user numbers in total. ";
      		if(count>100)
      			str +="It will cost some time to send SMS to them. ";
      		str +="Are you sure to send?";
      		
      		if(confirm(str))
      		{
      			fm.order.value = "0";
        			document.inputForm.submit();
        		}
        		else
        			fm.order.value = "-1";
        	}	
      }
    		
      
    }
   
   
   
   
   
   function again () {
      var fm = document.inputForm;
      fm.op.value = 'again';
      fm.reset();
      fm.submit();
   }
  
   function queryInfo() {
     var fm = document.inputForm;
       var sresult = "";
       var agt=navigator.userAgent.toLowerCase();
       var is_ie=(agt.indexOf("msie")!=-1 && document.all);
	   if(is_ie)
	{
     sresult =  window.open('ringSearchmore.jsp','ringWindow',"width=700, height=600,toolbar=yes,scrollbars=yes");	 
	 }
	else
  {
  netscape.security.PrivilegeManager.enablePrivilege('UniversalBrowserWrite');
window.open('ringSearchmore.jsp',window,'modal=YES,resizable=NO,scrollbars=NO,status=0,left='+((screen.width-560)/2)+',top='+((screen.height-700)/2)+',width=600px,height=700px'); ;
sresult = fm.result.value;
	}
     if(sresult){
       document.inputForm.ringlist.value = sresult;
       document.inputForm.submit();
     }
   }

   function selectClick(){
     var fm = document.inputForm;
     fm.submit();
   }
   function ringidcheck(){
     var fm = document.inputForm;
     var tem = '<%= str%>';
     if(tem == ""){
       fm.ischeck.checked = false;
       alert("Please query the short message to be transmitted!");//请先查询选择要发送的铃音!
     }else{
       if(typeof(fm.suoRingid.length) == "undefined"){
         if (fm.ischeck.checked){
           fm.suoRingid.style.display = 'block';
         }else{
           fm.suoRingid.style.display = 'none';
         }
       }else if (fm.ischeck.checked){
         for(var i=0;i<fm.suoRingid.length;i++){
           fm.suoRingid[i].style.display = 'block';
         }
       }else{
         for(var i=0;i<fm.suoRingid.length;i++){
           fm.suoRingid[i].style.display = 'none';
         }
       }
     }
   }
   function selectFile() {
      var fm = document.inputForm;
      var uploadURL = 'marketUpload.jsp';
      uploadRing = window.open(uploadURL,'marketUpload','width=400, height=200');
   }
   function getListName (name, label) {
      var fm = document.inputForm;
      fm.listfile.value = name;
      fm.filetext.value = label;
      fm.filename.value = label;
   }
   function actclick(){
     var fm = document.inputForm;
     if(fm.actType[0].checked){
     document.getElementById("table1").style.display  = 'block';
      document.getElementById("table3").style.display  = 'block';
      document.getElementById("table4").style.display  = 'none';
     }else{
	  document.getElementById("table1").style.display  = 'none';
      document.getElementById("table3").style.display  = 'none';
      document.getElementById("table4").style.display  = 'block';

     }
   }
   function onSCPChange(){
     document.inputForm.op.value = "";
     document.inputForm.submit();
   }
   
   function selectSub()
	{
	 	var fm = document.inputForm;
	 	if(fm.subservice.value=='<%=subservice%>')
	 		return false;
		fm.submit();
	}
	
	function searchUser()
	{
		var fm = document.inputForm;
      if(trim(fm.hdlist.value).length == 0)
      {
      	alert("Please input the transmitting <%=user_number%> segment!");
    		fm.hdlist.focus();
    		return;
      }
		//打开新页面
		var url='marketCountDetail.jsp?hdlist='+fm.hdlist.value+'&scplist='+fm.scplist.value+'&subservice=<%=subservice%>&usertype='+fm.usertype.value;
		//window.open(url,'search','width=600, height=500,top='+((screen.height-200)/2)+',left='+((screen.width-200)/4));
		document.location.href = url;
	}
   
	  	 //Added by Srinivas Rao.K on 18-05-2011, for 5.04.09[smart] to delete the selected ringtones
		 function deleteInfo(ringId){
		  var fm = document.inputForm;
		  fm.hringid.value=ringId;
		   fm.op.value = 'del';
			   if(!confirm("Are you sure to delete this ringtone?")) 
                 return ;
            fm.submit();
		  
		   }
//end of added
   
 </script>

   

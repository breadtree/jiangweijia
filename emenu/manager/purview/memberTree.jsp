<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="purview" class="zxyw50.Purview" scope="page" />
<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<title>Operator management</title>
<link rel="stylesheet" type="text/css" href="../style.css">
<script src="../../pubfun/JsFun.js"></script>
<script type="text/javascript" src="../dtree2.js"></script>
</head>
<body class="body-style1">
<%
    try {
        String operID = request.getParameter("operID")==null?(String)session.getAttribute("OPERID"):request.getParameter("operID");
        String memberID = request.getParameter("memberID");
        ArrayList list = new ArrayList();
        HashMap map = new HashMap();
        String operflag = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
        String operType = request.getParameter("operType");
        String tempname = request.getParameter("opername") == null ? "" : (String)request.getParameter("opername");
        String name = tempname.trim();
        String serflag = request.getParameter("serflag") == null ? "0" : (String)request.getParameter("serflag");
        int thepage = request.getParameter("page") == null ? 0 : Integer.parseInt((String)request.getParameter("page"));
        Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");

        if ( operID != null && purviewList.get("5-1") != null){
           if("search".equals(operflag)) {
             list = purview.sortChildOperators2(operID,name,serflag);
           } else {
             list = purview.sortChildOperators(operID);
           }
           if (list == null)
              list = new ArrayList();

          String idstr = "";

%>
<script language="javascript">
   // 更新,将用户列表更新。
   function refresh () {
      parent.buttonFrame.document.view.operName.value = '';
      parent.buttonFrame.document.view.serviceKey.value = '';
      parent.buttonFrame.document.view.serviceName.value = '';
      parent.buttonFrame.document.view.unlock.disabled = true;
      parent.buttonFrame.document.view.del.disabled = true;
      parent.buttonFrame.document.view.attr.disabled = true;
      parent.buttonFrame.document.view.signOut.disabled = true;
      parent.groupFrame.document.view.operID.value = '';
      parent.currentFrame.document.view.operID.value = '';
      document.view.submit();
   }

   function refresh2 (name,serflag) {
      parent.buttonFrame.document.view.operName.value = '';
      parent.buttonFrame.document.view.serviceKey.value = '';
      parent.buttonFrame.document.view.serviceName.value = '';
      parent.buttonFrame.document.view.unlock.disabled = true;
      parent.buttonFrame.document.view.del.disabled = true;
      parent.buttonFrame.document.view.attr.disabled = true;
      parent.buttonFrame.document.view.signOut.disabled = true;

      document.view.opername.value = name;
      parent.groupFrame.refresh();
      parent.currentFrame.refresh();
      //goto('%=memberID%>','','0');
      document.view.operID.value = <%=memberID%>;
      document.view.submit();
   }

   function showMessage(point,str){  alert(point + ":" +str);}
function showDebugger(point,str){  alert(point + ":" +str);}
function showWarnning(point,str){  alert(point + ":" +str);}
function showError(point,str){  alert(point + ":" +str);}

var agt = navigator.userAgent.toLowerCase();
var is_ie = (agt.indexOf("msie") != -1);
var is_ie5 = (agt.indexOf("msie 5") != -1);
var is_opera = (agt.indexOf("opera") != -1);
var is_mac = (agt.indexOf("mac") != -1);
var is_gecko = (agt.indexOf("gecko") != -1);
var is_safari = (agt.indexOf("safari") != -1);
var d = new dTree('d');

//指定用户的时候发生的动作
   function viewOper (operID,operName,operStat) {
      document.view.operID.value = operID;
      var statFlag = d.getStatFlag(operID);

      if (parent.buttonFrame.checkWin() == 'no') {
         parent.buttonFrame.document.view.operID.value = operID;
         parent.buttonFrame.document.view.operName.value = operName;
         parent.buttonFrame.document.view.operStat.value = operStat;
         parent.buttonFrame.document.view.serviceName.value = '';
         parent.buttonFrame.document.view.signOut.disabled = true;
         parent.buttonFrame.document.view.del.disabled = false;
         parent.buttonFrame.document.view.attr.disabled = false;
         parent.buttonFrame.document.view.signOut.disabled = true;
         if(parseInt(operStat)==0)
             parent.buttonFrame.document.view.unlock.disabled = true;
         else
             parent.buttonFrame.document.view.unlock.disabled = false;
         parent.groupFrame.document.view.operID.value = operID;
         parent.groupFrame.refresh();
         parent.currentFrame.document.view.operID.value = operID;
         parent.currentFrame.refresh();
      }
      if (operID == '<%= operID %>') {
         parent.buttonFrame.document.view.unlock.disabled = true;
         parent.buttonFrame.document.view.del.disabled = true;
         parent.buttonFrame.document.view.attr.disabled = true;
         parent.buttonFrame.document.view.signOut.disabled = true;
      }
      if(statFlag==0)
             parent.buttonFrame.document.view.unlock.disabled = true;
         else
             parent.buttonFrame.document.view.unlock.disabled = false;
   }
function xmlRequest(url){
  var MODULE_NAME = "";
  var aUrl =  MODULE_NAME +url;
  var domdoc = PostInfotoServer(aUrl,null);

   if(domdoc){
            var result = domdoc.getElementsByTagName("MSG");
            var failed = false;
            if(result){
                var size = result.length;
                var info = "";
                for(var i =0;i<size;i++){
                    var v = result.item(i).attributes.getNamedItem("TYPE");;
                    if(v.nodeValue=='ERROR')
                        failed = true;
                    info += result.item(i).text+"\n";
                }
          if(info!='')
                  showMessage('Error:'+info);
            }
            if(!failed){
                var result = domdoc.getElementsByTagName("DATA").item(0);
                var children = result.childNodes;
                var size = children.length;
                var results = new Array(size);
                for(var i =0;i<size;i++){
                    var value = children.item(i).text;
                    results[i] = value;
                }
                return results;
            }
        }
}

function PostInfotoServer(url,xml){
    if(url==null)
       return;
    var v= showDelayMessage();

    var XMLSender = CreateXmlHttpReq();
    XMLSender.Open("POST",url,false);
    XMLSender.SetRequestHeader("content-Type","text/xml;charset=UTF-8");
    if(xml ==null)
        XMLSender.send();
    else
        XMLSender.send((xml));

    var xmldata = getXmlNodeFromStr(XMLSender.responseXML);

    v.close();

    return xmldata;
}

function CreateXmlHttpReq() {
  var xmlhttp = null;
  if (is_ie) {
    // Guaranteed to be ie5 or ie6
    var control = (is_ie5) ? "Microsoft.XMLHTTP" : "Msxml2.XMLHTTP";
    try {
      xmlhttp = new ActiveXObject(control);
    } catch (ex) {
      // TODO: better help message
      alert("You need to enable active scripting and activeX controls");
    }

  } else {
    // Mozilla
    xmlhttp = new XMLHttpRequest();
  }
  return xmlhttp;
}

function showDelayMessage(){
	msgWindow=open("","serverDelayMessage",'top='+((screen.height-40)/2)+',left='+((screen.width-250)/2)+'toolbar=0,directories=0,width=250,height=40, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=n o, status=no,menubar=0');
	var message ="<table cellspacing=\"2\" cellpadding=\"2\" width=\"100%\" border=\"0\" height=\"95%\" valign=\"middle\" style=\"font-family:MS Sans Serif; font-size:8px;\">"
        message+= "<tr><td align=\"right\"><img border=\"0\" src=\"../image/busy.gif\"></td>"
        message+= "<td ><span id=\"msgTextSpan\" style=\"FONT-WEIGHT: bold;FONT-SIZE: 11px;FONT-FAMILY: verdana\">"
        message+= "Running,just wait a moment...</span></td></tr></table>"
        msgWindow.document.write(message);
        return msgWindow;
}

function getXmlNodeFromStr(str) {
      var xml= new ActiveXObject("Msxml.DOMDocument");
      xml.async = false;
      xml.load(str);
      return xml.documentElement;
}

function goto(id,pid,flag){
  var node = d.get(id);
  if(node != null &&(node.loaded==true))
      return;
  var url = "/colorring/action?id="+id+"&flag="+flag+"&pid="+pid;
  var xmlresult = xmlRequest(url);
  if(node != null){
    node.loaded = true;
    d.setIcon(id);
  }
  if((xmlresult!=null)&&(xmlresult!='')){
    var len = xmlresult.length;
    if(xmlresult) {
      for(var i=0;i<len;i++){
        addTree(xmlresult[i]);
      }
      document.all("head1").innerHTML  = d.toString();
      d.openAll();
    }else{
      alert('error!');
      return;
    }
  } else {
    document.all("head1").innerHTML  = d.toString();
    d.openAll();
    return;
  }
}


function addTree(str) {

    var str = trim(str);
//    alert('tree str: '+str);
    var id = '';
    var pid = '';
    var name = '';
    var operstatus = '';

    var str_arr = new Array();
    str_arr = str.split(',');

    id = str_arr[0];
    pid = str_arr[1];
    name = str_arr[2];
    operstatus = str_arr[3];
    name2 = str_arr[4];

     d.add(id,pid,name,"javascript:viewOper('"+id+"','"+name2+"','"+operstatus+"')","","","","","","javascript:goto('"+id+"','"+pid+"','')",operstatus);

}

function delNode(id) {
   d.remove(id);
   document.all("head1").innerHTML  = d.toString();
   d.openAll();
}

function setName(id,name) {
   d.setName(id,name);
   document.all("head1").innerHTML  = d.toString();
   d.openAll();
}

function setStatFlag(id,stat) {
  d.setStatFlag(id,stat);
  document.all("head1").innerHTML  = d.toString();
}
</script>
<form name="view" method="post" action="memberTree.jsp" >
<input type="hidden" name="operID" value="">
<input type="hidden" name="memberID" value="<%=memberID%>">
<input type="hidden" name="op" value="<%= operflag %>">

<table border="1" width="100%" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style2" height=hei >
  <tr align="center">

      <input type="text" style="display:none" name="opername" value="<%= name %>" maxlength="30" size="15" class="input-style7" >


      <select name="serflag" style="display:none">
        <option value="0" selected="selected">System operator</option>
        <option value="1">Sp operator</option>
        <option value="2">Group operator</option>
      </select>

  </tr><br>
<script language="javascript">
var serflagValue = '<%=serflag%>';
document.view.serflag.value = serflagValue;
</script>

<div id="head1"> </div>

</table>
<%
if("init".equals(operType)){
%>
<script language="javascript">
      goto('<%=operID%>','','0');
</script>
<%}%>

</form>
<%

        }
        else {

          if(operID== null){
              %>
              <script language="javascript">
                    alert( "Please log in to the system!");
                    parent.document.location.href = '../enter.jsp';
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
%>
<table border="1" width="100%" bordercolorlight="#77BEEE" bordercolordark="#ffffff" cellspacing="0" cellpadding="0" class="table-style5" height=400>
  <tr>
    <td>Error:<%= e.toString() %></td>
  </tr>
</table>
<%
    }
%>
<script language="javascript">
   if (document.view.operID.value != '') {
      parent.groupFrame.refresh();
      parent.currentFrame.document.view.operID.value = document.view.operID.value;
      parent.currentFrame.refresh();
   }
</script>
</body>
<html>

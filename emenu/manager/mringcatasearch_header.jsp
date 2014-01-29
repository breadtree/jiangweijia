<%@ page import="zte.zxyw50.util.CrbtUtil"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="zte.zxyw50.CRBTContext" %>
<%@ page import="com.zte.tao.IModelData" %>
<%@ page import="com.zte.tao.util.JspUtil" %>
<%@ page import="java.io.*" %>
<%@ page import="zxyw50.*" %>
<%!
//private IModelData[] catelog = CRBTContext.queryCatalog(true); //查询铃音分类信息
private Vector getChildNode(String strIndex){
  IModelData[] catelog = CRBTContext.queryCatalog(true);
  Vector childVct = new Vector();
  if (catelog != null)
  {
    for(int i=0; i<catelog.length;i++){
      if(strIndex.equals(catelog[i].getFieldValue("parentindex")))
      {
        childVct.add(catelog[i]);
      }
    }
  }
  return childVct;
}

   public String showLibName(String str)
    {
    	String tmpStr = str;
    	if(tmpStr.length()>18)
    		tmpStr=tmpStr.substring(0,16)+"..";
    	return tmpStr;
	}
%>
<%
String colorName = zte.zxyw50.util.CrbtUtil.getDbStr(request,"colorname", "CRBT");
String ringdisplay = zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "ringback tone");
String cursp = JspUtil.getSafeParameter("spselect", request, "0");
IModelData[] spInfo = CRBTContext.querySpInfo(true); //查询SP信息
String subindex = JspUtil.getSafeParameter("subindex", request, "0");
String nodename =request.getParameter("nodename")==null?"":request.getParameter("nodename");
String buy =request.getParameter("buy")==null?"true":request.getParameter("buy");
String showlargess =request.getParameter("showlargess")==null?"true":request.getParameter("showlargess");
String ringlib = request.getParameter("ringlib") == null ? "0" : (String)request.getParameter("ringlib");
System.out.println("***********ringlib="+ringlib);
System.out.println("***********cursp="+cursp);
int laysize = 0;
%>

<style type="text/css">
<!--
.content{
   background-image:url(../image/catalog.gif);
   background-repeat:no-repeat;
   width:200px;
   height:21px;
   border:0px solid #333333;}

.content2{
   background-image:url(../image/up.gif);
   background-repeat:no-repeat;
   width:125px;
   height:19px;
   font-size:12px;
   text-align: center;
   border:0px solid #333333;
   color:#000000;
   }

.content3{
	visibility:hidden;
	position:absolute;
   width:110px;
   height:21px;
   font-size:12px;
   text-align: center;
   border:0px;}

.style1 {
	font-family: "宋体",arial,verdana;
	font-size:12px;
	line-height:19px;
	height:19px;
	width:100px;
	background-color: #cfe394;
	border: 1px solid #fff;
	cursor: hand;
	padding:3px;
}
.header1{
	font-family: arial,verdana,sans;
	font-size:12px;
	line-height:19px;
	color:#000000;
}
-->
</style>

<script language="javascript">
function showLayer(num)
{
  var name = "Layer" + num;
  var tempLayer = document.all[name];
  if ( tempLayer == null )
  {
    return;
  }
  tempLayer.style.left = document.body.scrollLeft+event.clientX-event.offsetX+4;
  tempLayer.style.top = document.body.scrollTop+event.clientY-event.offsetY+20;
  tempLayer.style.visibility = "visible";
}

function hiddenLayer(num)
{
  var name = "Layer" + num;
  var tempLayer = document.all[name];
  if ( tempLayer == null )
  {
    return;
  }
  if((window.event.toElement==null) || (window.event.toElement.id!= tempLayer.id && window.event.toElement.id!="link"))
  {
    tempLayer.style.visibility=  "hidden";
  }
}

function onRootClick(leafindex,nodename,layer,ringlibid){
  fm = document.inputForm;
  var ss ;
  if(leafindex==0)
  {
    ss = fm.laysize.value;
    //alert(ss);
    for (var i=0;i<ss;i++)
    {
        //var menu = window.eval('window.Layer'+ i)
        var menu = document.getElementById("Layer" + i);
        if (menu.id==layer)
        {
            continue;
        }
        menu.style.display ='none';
    }
    var menu =   window.eval(layer);
    if (menu.style.display=='none')
    {
        menu.style.display="";
    }
	else
    {
        menu.style.display='none';
    }
    return;
  }
  fm.subindex.value = leafindex;
  fm.nodename.value = nodename;
  fm.ringlib.value = ringlibid;
  fm.page.value=0;
  document.inputForm.submit();
}

function showM(id,event)
{
var x =  document.all[id];
  x.style.left = document.body.scrollLeft+event.clientX-event.offsetX;
  x.style.top = document.body.scrollTop+event.clientY-event.offsetY+15;
  x.style.visibility = "visible";
}

function hiddenM(id,event)
{
var x =  document.all[id];
if ( x == null )
  {
    return;
  }
 // window.status = 'x='+x.id + '==to='+window.event.toElement.id;
 /*
 add temporalily---
 */
 if(!/msie/i.test(navigator.userAgent)){
    Event.prototype.__defineGetter__("srcElement",function(){
		var node=this.target;
		while(node.nodeType != 1)node=node.parentNode;
		return node;
	});
	Event.prototype.__defineGetter__("fromElement",function(){// 返回鼠标移出的源节点
        var node;
        if(this.type == "mouseover")
            node = this.relatedTarget;
        else if(this.type == "mouseout")
            node = this.target;
        if(!node)return;
        while(node.nodeType != 1)node=node.parentNode;
        return node;
        });
    Event.prototype.__defineGetter__("toElement",function(){// 返回鼠标移入的源节点
        var node;
        if(this.type == "mouseout")
            node = this.relatedTarget;
        else if(this.type == "mouseover")
            node = this.target;
        if(!node)return;
        while(node.nodeType != 1)node=node.parentNode;
        return node;
        });
}
 /*
--- add temporalily
 */
  if((event.toElement==null) || (event.toElement.id!= x.id && event.toElement.id!="links"))
  {
      x.style.visibility = "hidden";
  }
}
</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <form name="inputForm" method="post" action="mringcatasearch.jsp">
  <input type="hidden" name="subindex" value="<%=subindex%>"/>
  <input type="hidden" name="ringlib" value="<%=ringlib%>"/>
  <input type="hidden" name="nodename" value="<%=nodename%>"/>
  <input type="hidden" name="spindex" value="<%=cursp%>"/>
  <input type="hidden" name="buy" value="<%=buy%>"/>
  <input type="hidden" name="showlargess" value="<%=showlargess%>"/>
  <tr>
	 <td height="26"  align="center" class="text-title"  background="image/n-9.gif">Query By Category</td>
	 <%//@include file="../common_header.jsp"%>
    </td>
  </tr>
  <tr>
    <td>
      <table width="100" align="center" border="0" cellpadding="1" cellspacing="0" height="50" class="table-style2">
        <%
        Vector nodeVct = getChildNode("0");
        for (int i = 0; i < nodeVct.size(); i++) {
            laysize++;
          IModelData node = (IModelData) nodeVct.get(i);
          String index = node.getFieldValue("allindex");
          String ringlibid = node.getFieldValue("ringlibid");
          String nodeName = node.getFieldValue("ringliblabel");
          String isleaf = node.getFieldValue("ifleafnod");
          Vector childVct = getChildNode(ringlibid);
          String layer = "Layer" + String.valueOf(i);
          if (i % 4 == 0) {
          %>
          <tr>
        <%}
        String leafindex = "0";
        if ("1".equals(isleaf) && childVct.size() == 0)
        {
          leafindex = index;
        }
        %>
        <td id="button0" height="22" valign="top" align="right">
          <table width="129" border="0" cellspacing="0" cellpadding="0"  height="22" class="chn" >
            <tr>
              <td  align="center" class="content" onMouseOver="this.style.cursor='pointer'" onclick="onRootClick('<%= leafindex %>','<%= nodeName %>','<%= layer %>','<%=ringlibid%>')"><%= showLibName(nodeName) %></td>
            </tr>
            <tr>
                <td>
                 <table  id="<%= layer %>" width="100%" border="0" cellspacing="1" cellpadding="3" style="display:none ">
              <%
              if (childVct.size() > 0) {
                for (int j = 0; j < childVct.size(); j++) {
                  IModelData childNode = (IModelData) childVct.get(j);
                  String childIndex = childNode.getFieldValue("allindex");
                  String childName = childNode.getFieldValue("ringliblabel");
				  String childringlibid = childNode.getFieldValue("ringlibid");
                  String ref = "ringLibInfo.jsp?allindex=" + childIndex + "&parentindex=" + index + "&Pos=" + ringdisplay + "classified base-->" + nodeName;
                  Vector csVct = getChildNode(childNode.getFieldValue("ringlibid"));
                  String csid = layer +"-CS-" + j ;
            %>
              <tr id="link">
                <td class="content2" id="link" align="center">
                    <% if(csVct.size()>0){

                    %>
                    <div id="<%=csid%>" class="content3" onmouseout="hiddenM('<%=csid%>',event)">
                    <%for (int k = 0; k < csVct.size(); k++) {
                        IModelData csNode = (IModelData) csVct.get(k);
                        String csIndex = csNode.getFieldValue("allindex");
                        String csName = csNode.getFieldValue("ringliblabel");
						String csLibid = csNode.getFieldValue("ringlibid");
                        out.println(" <a id='links' class=style1 href='mringcatasearch.jsp?subindex="+ csIndex+"&nodename="+ csName+
                        "&buy="+buy+"&showlargess="+showlargess+
                        "&sp="+cursp+"&ringlib="+csLibid+"&page=0'>"+showLibName(csName)+"</a><br>");
                    } %>
                    </div>
                    <a onmouseover="showM('<%=csid%>',event)" onmouseout="hiddenM('<%=csid%>',event)">
                        <%= showLibName(childName) %></a>
                    <% }else{%>
                    <a href="mringcatasearch.jsp?page=0&subindex=<%= childIndex %>&nodename=<%= childName %>&sp=<%= cursp%>&buy=<%= buy%>&showlargess=<%= showlargess%>&ringlib=<%=childringlibid%>" id="link">
                        <%= showLibName(childName) %></a>
                    <%} %>
                    </td>
                  </tr>
                  <%}}%>
                </table>
                </td>
            </tr>

           </table>

            </td>
            <%if ((i + 1) % 4 == 0) {%>
          </tr>
          <%}}%>
        </table>
    </td>
  </tr>
  <tr>
    <td>
      <table border="0" cellspacing="1" cellpadding="1" class="table-style2" width="95%" style="display:none">
        <tr>
          <td align="right"><i18n:message key='UserMSG0032500' />
            <select name="spselect" class="select-style4" onChange="javascript:submit()">
              <option value="0">-<%= zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0032501","1",ringdisplay) %>-</option>
              <%
              for (int i = 0; i < spInfo.length; i++) {
                String spindex = spInfo[i].getFieldValue("spindex");
                if (cursp.equals(spindex)) {
                %>
                <option value="<%=spindex%>" selected><%=spInfo[i].getFieldValue("spname")%></option>
                <%}else{%>
                <option value="<%=spindex%>"><%= spInfo[i].getFieldValue("spname") %></option>
                <%}}%>
              </select>
            </td>
          </tr>
        </table>
      </td>
  </tr>
  <tr>
    <td width="95%" align="center">
      <%if (nodename.length() > 0) { %>
    <table width="95%">
      <tr>
        <td class="table-style2"><font class="header1"><strong><%= nodename%></strong> <%=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0032503","1",zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "ringtone"))%></font></td>
      </tr>
    </table>
    <%}else{%>
    <table width="95%">
      <tr>
        <td class="table-style2">
          <font class="header1"><%= nodename%></strong> <%=zte.zxyw50.colorring.util.RingViewHelper.getArgMsg(request,"UserMSG0032504","1",zte.zxyw50.util.CrbtUtil.getDbStr(request,"ringdisplay", "ringtone"))%></font>
        </td>
      </tr>
    </table>
    <%}%>
  </td>
</tr>
<input type="hidden" name="laysize" value="<%=laysize%>"/>
</table>

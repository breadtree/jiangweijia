<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="zxyw50.manSysRing" %>
<%@ page import="zxyw50.userAdm" %>
<%@ page import="zxyw50.*" %>
<%@ page import="zxyw50.SocketPortocol" %>
<%@ page import="com.zte.socket.imp.pool.SocketPool" %>
<%@ page import="zxyw50.CrbtUtil" %>
<%@ include file="../sParam.jsp" %>
<%@ include file="../pubfun/JavaFun.jsp" %>

<%
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Expires", "Thu,  01 Jan   1970 00:00:01 GMT");
%>
<html>
<head>
<meta http-equiv="Content-Language" content="zh-cn">
<title>Service donation</title>
<link rel="stylesheet" type="text/css" href="style.css">
<SCRIPT language="JavaScript" src="../pubfun/JsFun.js"></SCRIPT>
</head>
<body topmargin="0" leftmargin="0" class="framed">
<%
    Vector sysInfo = (Vector)application.getAttribute("SYSINFO");
    String operID = (String)session.getAttribute("OPERID");
    String operName = (String)session.getAttribute("OPERNAME");
    String sysTime = "";
    Hashtable purviewList = session.getAttribute("PURVIEW") == null ? new Hashtable() : (Hashtable)session.getAttribute("PURVIEW");
    String allowUp = (String)application.getAttribute("ALLOWUP")==null?"0":(String)application.getAttribute("ALLOWUP");
    String colorName = (String)application.getAttribute("COLORNAME")==null?"":(String)application.getAttribute("COLORNAME");
    String ringdisplay = (String)application.getAttribute("RINGDISPLAY")==null?"":(String)application.getAttribute("RINGDISPLAY");
    String initial = request.getParameter("initial") == null ? "" : request.getParameter("initial").toString().trim();
    if(initial.equals("1")){
      session.removeAttribute("ringMap1");
      session.removeAttribute("ringMap2");
    }
    String pictureOrFlash = zxyw50.CrbtUtil.getConfig("pictureOrFlash","1");
    if(ringdisplay.equals(""))  ringdisplay = "Ringtone";
    String mixtunepath="";

    try {
      ColorRing coloring = new ColorRing();
      SocketPool pool = (SocketPool)application.getAttribute("SOCKETPOOL");
      sysTime = SocketPortocol.getSysTime() + "--";
      String op = request.getParameter("op") == null ? "" : (String)request.getParameter("op");
      String firstRing = request.getParameter("firstRing") == null ? "" : request.getParameter("firstRing").toString().trim();
      String secondRing = request.getParameter("secondRing") == null ? "" : request.getParameter("secondRing").toString().trim();
      Hashtable result = new Hashtable();
      HashMap ringMap1,ringMap2;
      if (operID != null && purviewList.get("2-28") != null) {
        String basepath = CrbtUtil.getConfig("wavdir","/home/zxin10/was/tomcat/webapps/ROOT/colorring/wav");
        basepath = basepath.substring(0,basepath.length()-4);
        basepath=basepath+"/";
        mixtunepath = basepath+"wav/tmp/"+operName+"_mix.wav";
        manSysRing sysring = new manSysRing();
        if (op.equals("download")) {
          if(firstRing.equals("")&&secondRing.equals(""))
            throw new Exception("The two ring can not be empty at the same time!");
          if(!firstRing.equals("")){
            ringMap1 = (HashMap)coloring.getRingInfo(firstRing);

            if(ringMap1.size()<5)
              throw new Exception("Can not search the ring information!");
            try{
              String path1 = sysring.tryListen(pool,ringMap1.get("ringindex").toString().trim(),"");

              ringMap1.put("ringUrl",path1);
            }catch(Exception e){
              e.printStackTrace();
              throw new Exception("Failed to download ring."+e.getMessage());
            }
            session.setAttribute("ringMap1",ringMap1);

          }
          if(!secondRing.equals("")){
            ringMap2 = (HashMap)coloring.getRingInfo(secondRing);
            if(ringMap2.size()<5)
              throw new Exception("Can not search the ring information!");
            try{
              String path1 = sysring.tryListen(pool,ringMap2.get("ringindex").toString().trim(),"");
              ringMap2.put("ringUrl",path1);
            }catch(Exception e){
              throw new Exception("Failed to download ring.");
            }
            session.setAttribute("ringMap2",ringMap2);

           }

        }
        else if(op.equals("mix")){
            ringMap1 = (HashMap)session.getAttribute("ringMap1");
            ringMap2 = (HashMap)session.getAttribute("ringMap2");
            String path1 = ringMap1.get("ringUrl").toString().trim();
            String path2 = ringMap2.get("ringUrl").toString().trim();

            //System.out.println("dll path="+System.getProperty("java.library.path"));
            //System.out.println("basepath="+basepath);
            //System.out.println("path1="+basepath+path1);
            //System.out.println("path2="+basepath+path2);
            AudioMix mixdll = new AudioMix();
            int ret=mixdll.UnionWave(mixtunepath, basepath+path1,basepath+path2,0.5f);
            //int ret=AudioMixDll.UnionWaveFile2AlawJ("I:/tian.wav", 0.5f, "I:/114.wav","I:/111.wav");
%>
<script language="javascript">
   alert('<%=ret>0?"Succeed to mix the tunes":"Failed to mix the tunes!"%>');//上传成功
</script>
<%
           zxyw50.Purview purview = new zxyw50.Purview();
           HashMap map = new HashMap();
           map.put("OPERID",operID);
           map.put("OPERNAME",operName);
           map.put("OPERTYPE","229");
           map.put("RESULT","1");
           map.put("PARA1",ringMap1.get("ringid"));
           map.put("PARA2",ringMap2.get("ringid"));
           purview.writeLog(map);
            //System.out.println("11111111 ret=="+ret);
        }
        else if(op.equals("upload")){
          Hashtable hash = new Hashtable();
          SocketPortocol portocol = new SocketPortocol();
          hash.put("usernumber","craccount");
          hash.put("ringtype","3");
          String ringlabel = request.getParameter("ringname") == null ? "No" : transferString((String)request.getParameter("ringname"));
          if(checkLen(ringlabel,40))
            throw new Exception("The length of the " + ringdisplay + "name you entered is too long. Please re-enter!");
          hash.put("ringlabel",ringlabel);
          hash.put("filename","craccount" + "_mix.wav");
          String auther = request.getParameter("ringauthor") == null ? "*" : transferString((String)request.getParameter("ringauthor"));
          if(checkLen(auther,40))
            throw new Exception("The name of the artist you entered is too long. Please re-enter!");
          hash.put("auther",auther);
          hash.put("supplier","User");
          hash.put("price",(String)((Hashtable)session.getAttribute("USERSTATUS")).get("priceofupload"));
          hash.put("validdate","");
          hash.put("ringspell","");
          hash.put("opmode","1");
	   hash.put("ipaddr",request.getRemoteAddr());

          hash.put("preflag", "0");
          hash.put("prefilename", "");
          String ringid = sysring.ringUpload(pool,hash);
          hash.clear();
          //System.out.println("1111111111111111 ringid="+ringid);
          Hashtable tt = new Hashtable();
          tt.put("ringid",ringid);
          tt.put("mixflag","1");
          new userAdm().setRingMix(tt);
          tt.clear();
          sysInfo.add(sysTime + operName + " upload " + ringdisplay + " successfully!");
%>
<script language="javascript">
   alert('<%=  ringdisplay  %> upload successfully!!');//上传成功
</script>
<%

        }
        else{
           op = "0";
        }

%>
<script language="javascript">
var   ringdisplay = "<%=  ringdisplay  %>";
// 删除字符串的左边空格
function leftTrim (str) {
  if (typeof(str) != 'string')
  return '';
  var tmp = str;
  var i = 0;
  for (i = 0; i < str.length; i++) {
    if (tmp.substring(0,1) == ' ')
    tmp = tmp.substring(1,tmp.length);
    else
    return tmp;
  }
}
// 删除字符串的右边空格
function rightTrim (str) {
  if (typeof(str) != 'string')
  return '';
  var tmp = str;
  var i = 0;
  for (i = str.length - 1; i >= 0; i--) {
    if (tmp.substring(tmp.length - 1,tmp.length) == ' ')
    tmp = tmp.substring(0,tmp.length - 1);
    else
    return tmp;
  }
}
// 删除字符串的两边空格
function trim (str) {
  if (typeof(str) != 'string')
  return '';
  var tmp = leftTrim(str);
  return rightTrim(tmp);
}


  function queryInfo(i) {
     var result =  window.showModalDialog('ringSearch.jsp?mediatype=3',window,"scroll:yes;resizable:yes;status:no;dialogLeft:"+((screen.width-560)/2)+";dialogTop:"+((screen.height-700)/2)+";dialogHeight:700px;dialogWidth:600px");
     if(result){
       if(i==1)
        document.inputForm.firstRing.value=result;
       else
        document.inputForm.secondRing.value=result;
         }
	// var appendContent="ringSearch.jsp?hidemediatype=1&mediatype=1&MixtuneRingId="+i;
	// var result =  window.open(appendContent,'mywin','left=20,top=20,width=600,height=550,toolbar=1,resizable=0,scrollbars=yes,location=1');
     }


   function download(){
     fm = document.inputForm;
     if(trim(fm.firstRing.value)=='' &&trim(fm.secondRing.value)==''){
       alert('The two ring cannot be empty at the same time!');
       fm.firstRing.focus();
       return;
     }
     fm.op.value = "download";
     fm.submit();
   }

   function mixtune(){
     fm = document.inputForm;
     fm.op.value = "mix";
     fm.submit();
   }

   function tryListen(ringID,ringName,ringAuthor,mediatype) {
      var tryURL = 'tryListen.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
      if(trim(mediatype)=='1'){
               preListen = window.open(tryURL,'try','width=400, height=200,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='2'){
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }else if(trim(mediatype)=='4'){
        tryURL = 'tryView.jsp?ringid=' + ringID+'&ringname='+ringName+'&ringauthor='+ringAuthor+'&mediatype='+mediatype;
              preListen = window.open(tryURL,'try','width=400, height=430,top='+((screen.height-200)/2)+',left='+((screen.width-400)/2));
      }
   }

   function listenMix(){
     Listenmix = window.open('tryListenCom.jsp?ringpath=wav/tmp/<%=operName%>_mix.wav','Try','width=400, height=200');
   }

   function upload(){
     fm = document.inputForm;
     if(trim(fm.ringname.value)==''){
       alert('The ring name can not be empty!');
       fm.ringname.focus();
       return;
     }
     if(trim(fm.ringauthor.value)==''){
       alert('The Artist can not be empty!');
       fm.ringauthor.focus();
       return;
     }
     if (!CheckInputStr(fm.ringname, 'Ring name'))
       return;
     if (!CheckInputStr(fm.ringauthor, 'Artist'))
       return;
     fm.op.value = "upload";
     fm.submit();
   }

</script>

<script language="JavaScript">
  if(parent.frames.length>0)
    parent.document.all.main.style.height="800";
</script>
<form name="inputForm" method="post" action="mixtune.jsp">
<input type="hidden" name="op" value="<%= op %>">
  <table width="535" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td valign="top">
<!-- Title begin -->
            <table width="70%" border="0" align="center" class="table-style2">
		<tr>
                  <td height="16" >&nbsp;</td>
		</tr>
		<tr>
                 <td height="26" colspan="2" align="center" class="text-title" background="image/n-9.gif">Mix Tune</td>
		</tr>
            </table>
<!-- Title end -->
              <table width="100%" cellspacing="2" cellpadding="2" border="0" class="table-style2" align="center">
                <tr valign="top">
                  <td width="100%" align="center">
                    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" class="table-style3">
                      <tr>
                        <td width="40%" height="20"><B>Step one,select the ring.</B></td>
                        <td width="70%"></td>
                      <tr>
                      <tr>
                        <td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The first ring</td>
                        <td align="left">
                          <input type="text" name="firstRing" value="<%=firstRing%>" readonly class="input-style1" maxlength="20">
                            <img src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo(1)">
                          </td>
                      </tr>
                      <tr>
                        <td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The second ring</td>
                        <td align="left"><input type="text" name="secondRing" readonly value="<%=secondRing%>" class="input-style1" maxlength="20">
                          <img src="../image/query.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:queryInfo(2)">
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2" height="20"><B>Step two,download the ring.</B></td>
                      <tr>
                      <tr>
                        <td align="left" colspan="2"><img src="../button/downtune.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:download()"></td>
                      </tr>
<%
             if(session.getAttribute("ringMap1")!=null || session.getAttribute("ringMap2")!=null){
%>
             <tr><td colspan="2">
                  <table width="98%" border="0" cellspacing="1" cellpadding="2" class="table-style4" align="center">
                     <tr class="tr-ringlist">
                      <td height="20" width="80">
                        <div align="center"><font color="#FFFFFF">Ring code</font></div></td>
                      <td height="20" width="160">
                        <div align="center"><font color="#FFFFFF">Ring name</font></div></td>
                      <td height="20" width="120">
                        <div align="center"  ><font color="#FFFFFF">Artist</font></div>
                      </td>
                      <td height="20" width="80">
                        <div align="center"><font color="#FFFFFF">Pre-listen</font></div></td>
                      <td height="20" width="110">
                        <div align="center"><font color="#FFFFFF">Description</font></div></td>
                    </tr>
<%
                if(session.getAttribute("ringMap1")!=null){
                  ringMap1 = (HashMap)session.getAttribute("ringMap1");

%>
                   <tr bgcolor="#FFFFFF">
                     <td><%=ringMap1.get("ringid")%></td>
                     <td><%=ringMap1.get("ringlabel")%></td>
                     <td><%=ringMap1.get("ringauthor")%></td>
                     <td align="center"><img src="../image/play.gif" alt="Pre-listen <%= ringdisplay %>" onmouseover="this.style.cursor='hand'" onclick="javascript:tryListen('<%= (String)ringMap1.get("ringid") %>','<%= ((String)ringMap1.get("ringlabel")).replaceAll("'"," ") %>','<%= (String)ringMap1.get("ringauthor") %>','<%= (String)ringMap1.get("mediatype") %>')"></td>
                     <td>First ring</td>
                   </tr>
<%
                }
                if(session.getAttribute("ringMap2")!=null){
                  ringMap2 = (HashMap)session.getAttribute("ringMap2");
%>
                   <tr bgcolor="#FFFFFF">
                     <td><%=ringMap2.get("ringid")%></td>
                     <td><%=ringMap2.get("ringlabel")%></td>
                     <td><%=ringMap2.get("ringauthor")%></td>
                     <td align="center"><img src="../image/play.gif" alt="Pre-listen <%= ringdisplay %>" onmouseover="this.style.cursor='hand'" onclick="javascript:tryListen('<%= (String)ringMap2.get("ringid") %>','<%= ((String)ringMap2.get("ringlabel")).replaceAll("'"," ") %>','<%= (String)ringMap2.get("ringauthor") %>','<%= (String)ringMap2.get("mediatype") %>')"></td>
                     <td>Second ring</td>
                   </tr>
<%              }%>
                </table>
              </td>
            </tr>
            <tr>
              <td colspan="2" height="20"><B>Step three,mix the ring.</B></td>
            <tr>
            <tr>
              <td align="left" colspan="2">
                 <img src="../image/mixtune.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:mixtune()">&nbsp;&nbsp;&nbsp;&nbsp;
                <%if(new File(mixtunepath).exists()){%>
                 <img src="../button/listenmix.gif" onMouseOver="this.style.cursor='hand'" onclick="javascript:listenMix()">
                <%}%>
              </td>
            </tr>
      <%if(new File(mixtunepath).exists()){%>
            <tr>
              <td colspan="2" height="40"><B>Step four,upload the mix-ring.</B></td>
            </tr>
<!--  upload begin-->
            <tr>
              <td colspan="2" height="300" width="100%">
                <iframe width="175" height="100%" frameborder=0 src="ringUploadTreeMix.jsp" name="ringUploadTree" scrolling="auto"></iframe>
                <iframe width="345" height="100%" scrolling="no" frameborder=0 src="ringUploadMix.jsp" name="ringUpload"></iframe>
              </td>
            </tr>

<!--   upload ends-->
      <%}%>
  <%}%>

            <tr>
              <td colspan="2" align="center" height="15">&nbsp;</td>
            </tr>
            <tr valign="top">
               <td width="100%" colspan="2">
                 <table width="100%" cellspacing="1" cellpadding="2" border="0" bgcolor="#E1F2FF" class="table-style3">
                   <tr>
                      <td class="table-styleshow" height="26">Help information:</td>
                  </tr>
                  <tr>
                     <td>Please do the operation according to the step.</td>
                  </tr>
                 </table>
                 </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        </td>
    </tr>
  </table>
  </form>
<%
        }
        else {
%>
<script language="javascript">
 	alert('Please log in first!');
	parent.document.location.href = 'enter.jsp';
</script>
<%
        }
    }
    catch(Exception e) {
      e.printStackTrace();
        Vector vet = new Vector();
        sysInfo.add(sysTime + operName + colorName + ",Exception occurred in mixing ring!");
        sysInfo.add(e.toString());
        vet.add("Error occurred in mixing ring!");
        vet.add(e.getMessage());
        session.setAttribute("ERRORMESSAGE",vet);
%>
<form name="errorForm" method="post" action="error.jsp">
<input type="hidden" name="historyURL" value="mixtune.jsp">
</form>
<script language="javascript">
   document.errorForm.submit();
</script>
<%
    }
%>
</body>
</html>

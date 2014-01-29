<%@page import="zte.zxyw50.CRBTContext" %>
<%@page import="com.zte.tao.IModelData" %>

<script language="javascript">
    function loadpage(){
      document.inputForm.searchkey.value = '<%= searchkey %>';
      document.inputForm.sortby.value = '<%= sortby %>';
      var sTmp = "<%=  searchkey  %>";
      if(sTmp=='sp'){
         document.all('id_spshow').style.display= 'block';
         document.all('id_keyshow').style.display= 'none';
         document.inputForm.spindex.value = "<%=  searchvalue  %>";
      }
     else
     {
       document.all('id_keyshow').style.display= 'block';
       document.all('id_spshow').style.display= 'none';
       document.inputForm.searchvalue.value = "<%=  searchvalue  %>";
     }
   }

    function modeChange(){
      if(document.inputForm.searchkey.value=='sp'){
        document.all('id_keyshow').style.display= 'none';
        document.all('id_spshow').style.display= 'block';
      }
      else{
        document.all('id_keyshow').style.display= 'block';
        document.all('id_spshow').style.display= 'none';
      }
    }

    var   ringdisplay = "<%=ringdisplay%>";
    function searchRing () {
      fm = document.inputForm;
      if(document.inputForm.searchkey.value=='sp'){
        fm.searchvalue.value = fm.spindex.value;
      }else{
        if (trim(fm.searchvalue.value) == '') {
          alert("Please enter the querying condition!");
          fm.searchvalue.focus();
          return;
        }
        if(!checkstring('0123456789',trim(fm.searchvalue.value)) && trim(fm.searchkey.value)=='ringid'){
          alert(ringdisplay + "A code must be a numeral!");
          fm.searchvalue.focus();
          return;
        }
        if(trim(fm.searchkey.value)=='uploadtime' && (!checkDate2(fm.searchvalue.value)|| !checktrue2(fm.searchvalue.value)||fm.searchvalue.value.split('.',3).length!=3)){
          alert("Please enter correct warehousing time in the format of ****.**.**! The warehousing time should be no greater than the current time!");
          fm.searchvalue.focus();
          return;
        }
        var valueStr = trim(fm.searchvalue.value);
        var num1 = valueStr.indexOf("'");
        var num2 = valueStr.indexOf("\"");
        var num3 = valueStr.indexOf("\'");
        var num4 = valueStr.indexOf("\'");
        var num5 = valueStr.indexOf("\"");
        var num6 = valueStr.indexOf("\"");
        if(num1>=0||num2>=0||num3>=0||num4>=0||num5>=0||num6>=0){
          alert("Neither a single quotation mark nor a double quotation mark can be entered!");
          fm.searchvalue.focus();
          return;
        }
        // 3.17.01
        if((trim(fm.searchkey.value)=='ringfee')&&(!checkfee(fm.searchvalue.value))){
          alert("Enter the price unit fen! It should not be null or less than 0!");
          fm.searchvalue.focus();
          return ;
        }
      }
      fm.submit();
    }

    function checkfee(str) {
      str = trim(str);
      isNum = str.indexOf(".");
      if(isNaN(str)){
        return false;
      }
      if(str==null||str==""){
        return false;
      }
      if(parseInt(str)<0){
        return false;
      }
      if(isNum>0){
        //alert(isNum);
        return false;
      }
      return true;
    }
    </script>

    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <form name="inputForm" method="post" action="ringsearch.jsp">
          <tr>
            <td valign="top" bgcolor="#FFFFFF">
              <%@include file="common_header.jsp" %>
            </td>
          </tr>
          <tr>
            <td width="100%">
              <table border="0" cellspacing="1" cellpadding="1" class="table-style2">
                <tr>
                  <td width="10"></td>
                  <td>Select a type
                    <select size="1" id="searchkey" name="searchkey" class="select-style5" onchange="modeChange();">
                      <option value="ringid"><%=  ringdisplay  %> Code</option>
                      <option value="ringlabel"><%=  ringdisplay  %> Name</option>
                      <option value="singgername">Singer</option>
                      <option value="sp"><%=  ringdisplay  %> Provider</option>
                      <option value="uploadtime">Time to Lib</option>
                      <option value="ringfee"><%=  ringdisplay  %> Price</option>
                    </select></td>
                  <td id="id_keyshow" style="display:none">Keyword
                    <input type="text" name="searchvalue" maxlength="40" class="input-style1" >
                    </td>
                    <td id="id_spshow" style="display:none">Ringback tone provider
                      <select name="spindex" class="input-style1">
                        <option value=0 > all ringback tone providers</option>
                        <%
                        IModelData[] spInfo = CRBTContext.querySpInfo(true);
                        for (int i = 0; i < spInfo.length; i++) {
                          out.println("<option value="+spInfo[i].getFieldValue("spindex") + ">" + spInfo[i].getFieldValue("spname") + "</option>");
                        }
                        %>
                        </select></td>
                      <td>Sort
                        <select size="1" name="sortby" class="select-style1" onchange="javascript:document.inputForm.sortby.value = this.value">
                          <option value="ringid"><%=  ringdisplay  %> Code</option>
                          <option value="ringlabel"><%=  ringdisplay  %> Name</option>
                          <option value="singgername">Singer</option>
                          <option value="ringfee">Price</option>
                          <option value="buytimes">Subscription times</option>
                          <% if(disLargess!=1){%>
                          <option value="largesstimes">Presentation times</option>
                          <%}%>
                          <option value="uploadtime">Time to Lib</option>
                        </select></td>
                      <td><img src="button/search.gif" alt="Search <%=  ringdisplay  %>" onmouseover="this.style.cursor='hand'" onclick="javascript:searchRing()"></td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </form>
            </table>
<script language="javascript">
  loadpage();
</script>


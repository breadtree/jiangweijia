<html><style type="text/css">
<!--
body {
	margin-left: 0px;
}
-->
</style>
<body bgcolor="#ffffff">
<form name="view">
  <input type="hidden" name="operID" value="">
<table border="0">
  <tr>
    <td id="m1" style="display:block"><input type="button" name="memberRight" value="View" onClick="javascript:detail()" disabled></td>
    <td id="b1" style="display:none"><input type="button" name="back2" value="Return" class="button-style1" onClick="javascript:goback()"></td>
  </tr>
</table>
</form>


<script language="javascript">
function detail() {
  var opid = document.view.operID.value;
  m1.style.display = "none";
  b1.style.display = "block";
  parent.allotFrame.document.view.operID.value = "";
  parent.allotFrame.document.view.operName.value = "";
  parent.allotFrame.document.view.submit();
  parent.operFrame.document.location.href = "memberTreeRights.jsp?operID="+opid+"&memberID="+opid+"&operType=init";
}

function goback() {
  m1.style.display = "block";
  b1.style.display = "none";
  document.view.memberRight.disabled = true;
  parent.allotFrame.document.view.operID.value = "";
  parent.allotFrame.document.view.operName.value = "";
  parent.allotFrame.document.view.submit();
  parent.operFrame.document.location.href = "operListRights.jsp";
}
</script>
</body>
</html>

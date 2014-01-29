<% String mmHTML = zte.zxyw50.util.CrbtUtil.getDbStr(request,"htmlname");
if ((mmHTML == null) || (mmHTML == "")) {
mmHTML = "<html>";
}
out.print(mmHTML);
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="./js/jquery.min.js"></script>
<script type="text/javascript">
$(function(){
	$('.submitBtn').hover(
		// mouseover
		function(){ $(this).addClass('submitBtnHover'); },
		
		// mouseout
		function(){ $(this).removeClass('submitBtnHover'); }
	);	

	
});	
</script>
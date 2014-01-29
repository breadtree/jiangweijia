//
function MM_pop(fileurl){
    if (fileurl.options[fileurl.selectedIndex].value != "")
		window.open(fileurl.options[fileurl.selectedIndex].value,"_blank","toolbar=yes,location=yes,menubar=yes,scrollbars=yes,resizable=yes,left=50,height=500,width=700");
	return true;
}
//

///////////////////////////Floating banner begin//////////////////////////////
//用户变量
var oWhere = document.body;
var OptionText = new Array();
OptionText[0] = "--请选择各分公司--";
OptionText[1] = "CSDN.net";
OptionText[2] = "蓝色理想";
OptionText[3] = "PcHome";
OptionText[4] = "MSDN.com";
//下拉菜单主体
var selectDiv = document.createElement("table");
var selectDivTR = selectDiv.insertRow();
var defaultValueTD = selectDivTR.insertCell();
var arrow = selectDivTR.insertCell();
with(selectDiv)cellSpacing=0,cellPadding=0,border=0,className="selectDiv";
with(defaultValueTD)innerText = OptionText[0],className="defaultSelect";
with(arrow)innerText=6,className="arrow";
oWhere.appendChild(selectDiv);
//外层Div
var optionDiv = document.createElement("div");
//设置下拉菜单选项的坐标和宽度
with(optionDiv.style) {
	var select = selectDiv;
	var xy = getSelectPosition(select);
	pixelLeft = xy[0];
	pixelTop = xy[1]+select.offsetHeight;
	width = selectDiv.offsetWidth;
	optionDiv.className = "optionDiv";
}
//下拉菜单内容
var Options = new Array();
for (var i=0;i<OptionText.length;i++) {
	Options[i] = optionDiv.appendChild(document.createElement("div"));
}
for (i=0;i<Options.length;i++) {
	Options[i].innerText = OptionText[i];
}
oWhere.appendChild(optionDiv);

/*事件*/
//禁止选择文本
selectDiv.onselectstart = function() {return false;}
optionDiv.onselectstart = function() {return false;}
//下拉菜单的箭头
arrow.onmousedown = function() {
	this.setCapture();
	this.style.borderStyle="inset";
}
arrow.onmouseup = function() {
	this.style.borderStyle="outset";
	this.releaseCapture();
}
arrow.onclick = function() {
	event.cancelBubble = true;
	optionDiv.style.visibility = optionDiv.style.visibility=="visible"?"hidden":"visible";
}
document.onclick = function() {
	optionDiv.style.visibility = "hidden";
}
defaultValueTD.onclick = function() {
	event.cancelBubble = true;
	optionDiv.style.visibility = optionDiv.style.visibility=="visible"?"hidden":"visible";
}
//移动Option时的动态效果
for (i=0;i<Options.length;i++) {
	Options[i].attachEvent("onmouseover",function(){moveWithOptions("highlight","white")});
	Options[i].attachEvent("onmouseout",function(){moveWithOptions("","")});
	Options[i].attachEvent("onmouseup",selectedText);
}
function moveWithOptions(bg,color) {
	with(event.srcElement) {
		style.backgroundColor = bg;
		style.color = color;
	}
}
function selectedText() {
	with(event.srcElement) {
		defaultValueTD.innerText = innerText;
	}
	with(defaultValueTD.style)background="highlight",color="white";
}
/*通用函数*/
//获取对象坐标
function getSelectPosition(obj) {
	var objLeft = obj.offsetLeft;
	var objTop = obj.offsetTop;
	var objParent = obj.offsetParent;
	while (objParent.tagName != "BODY") {
		objLeft += objParent.offsetLeft;
		objTop += objParent.offsetTop;
		objParent = objParent.offsetParent;
	}
	return([objLeft,objTop]);
}
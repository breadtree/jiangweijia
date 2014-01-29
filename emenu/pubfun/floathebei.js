self.onError=null;
currentX = currentY = 0;
whichIt = null;
lastScrollX = 0; lastScrollY = 0;
NS = (document.layers) ? 1 : 0;
IE = (document.all) ? 1: 0;
<!-- STALKER CODE -->
function heartBeat() {
if(IE) { diffY = document.body.scrollTop; diffX = document.body.scrollLeft; }
if(diffY != lastScrollY) {
percent = .1 * (diffY - lastScrollY);
if(percent > 0) percent = Math.ceil(percent);
else percent = Math.floor(percent);
if(IE){
  document.all.dangdang2.style.pixelTop += percent;
}
lastScrollY = lastScrollY + percent;
}
if(diffX != lastScrollX) {
percent = .1 * (diffX - lastScrollX);
if(percent > 0) percent = Math.ceil(percent);
else percent = Math.floor(percent);
if(IE){
  document.all.dangdang2.style.pixelLeft += percent;
}
lastScrollX = lastScrollX + percent;
}
}

function checkFocus(x,y) {
stalkerx2 = document.dangdang2.pageX;
stalkery2 = document.dangdang2.pageY;
stalkerwidth2 = document.dangdang2.clip.width;
stalkerheight2 = document.dangdang2.clip.height;
if( (x > stalkerx2 && x < (stalkerx2+stalkerwidth2)) && (y > stalkery2 && y < (stalkery2+stalkerheight2))) return true;
else return false
}
function grabIt(e) {
if (IE){
whichIt = event.srcElement;
while (whichIt.id.indexOf("dangdang2") == -1) {
whichIt = whichIt.parentElement;
if (whichIt == null) { return true; }
}
whichIt.style.pixelLeft = whichIt.offsetLeft;
whichIt.style.pixelTop = whichIt.offsetTop;
currentX = (event.clientX + document.body.scrollLeft);
currentY = (event.clientY + document.body.scrollTop);
}
return true;
}
function moveIt(e) {
if (whichIt == null) { return false; }
if(IE) {
newX = (event.clientX + document.body.scrollLeft);
newY = (event.clientY + document.body.scrollTop);
distanceX = (newX - currentX); distanceY = (newY - currentY);
currentX = newX; currentY = newY;
whichIt.style.pixelLeft += distanceX;
whichIt.style.pixelTop += distanceY;
if(whichIt.style.pixelTop < document.body.scrollTop) whichIt.style.pixelTop = document.body.scrollTop;
if(whichIt.style.pixelLeft < document.body.scrollLeft) whichIt.style.pixelLeft = document.body.scrollLeft;
if(whichIt.style.pixelLeft > document.body.offsetWidth - document.body.scrollLeft - whichIt.style.pixelWidth - 20) whichIt.style.pixelLeft = document.body.offsetWidth - whichIt.style.pixelWidth - 20;
if(whichIt.style.pixelTop > document.body.offsetHeight + document.body.scrollTop - whichIt.style.pixelHeight - 5) whichIt.style.pixelTop = document.body.offsetHeight + document.body.scrollTop - whichIt.style.pixelHeight - 5;
event.returnValue = false;
}
return false;
}
function dropIt() {
whichIt = null;
return true;
}
if(IE) {
document.onmousedown = grabIt;
document.onmousemove = moveIt;
document.onmouseup = dropIt;
}
if(NS || IE) action = window.setInterval("heartBeat()",1);

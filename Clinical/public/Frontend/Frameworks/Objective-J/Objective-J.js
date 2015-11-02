var ObjectiveJ={};
(function(_1,_2){
if(!Object.create){
Object.create=function(o){
if(arguments.length>1){
throw new Error("Object.create implementation only accepts the first parameter.");
}
function F(){
};
F.prototype=o;
return new F();
};
}
if(!Object.keys){
Object.keys=(function(){
var _3=Object.prototype.hasOwnProperty,_4=!({toString:null}).propertyIsEnumerable("toString"),_5=["toString","toLocaleString","valueOf","hasOwnProperty","isPrototypeOf","propertyIsEnumerable","constructor"],_6=_5.length;
return function(_7){
if(typeof _7!=="object"&&typeof _7!=="function"||_7===null){
throw new TypeError("Object.keys called on non-object");
}
var _8=[];
for(var _9 in _7){
if(_3.call(_7,_9)){
_8.push(_9);
}
}
if(_4){
for(var i=0;i<_6;i++){
if(_3.call(_7,_5[i])){
_8.push(_5[i]);
}
}
}
return _8;
};
})();
}
if(!Array.prototype.indexOf){
Array.prototype.indexOf=function(_a){
"use strict";
if(this===null){
throw new TypeError();
}
var t=new Object(this),_b=t.length>>>0;
if(_b===0){
return -1;
}
var n=0;
if(arguments.length>1){
n=Number(arguments[1]);
if(n!=n){
n=0;
}else{
if(n!==0&&n!=Infinity&&n!=-Infinity){
n=(n>0||-1)*Math.floor(Math.abs(n));
}
}
}
if(n>=_b){
return -1;
}
var k=n>=0?n:Math.max(_b-Math.abs(n),0);
for(;k<_b;k++){
if(k in t&&t[k]===_a){
return k;
}
}
return -1;
};
}
if(!this.JSON){
JSON={};
}
(function(){
function f(n){
return n<10?"0"+n:n;
};
if(typeof Date.prototype.toJSON!=="function"){
Date.prototype.toJSON=function(_c){
return this.getUTCFullYear()+"-"+f(this.getUTCMonth()+1)+"-"+f(this.getUTCDate())+"T"+f(this.getUTCHours())+":"+f(this.getUTCMinutes())+":"+f(this.getUTCSeconds())+"Z";
};
String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(_d){
return this.valueOf();
};
}
var cx=new RegExp("[\\u0000\\u00ad\\u0600-\\u0604\\u070f\\u17b4\\u17b5\\u200c-\\u200f\\u2028-\\u202f\\u2060-\\u206f\\ufeff\\ufff0-\\uffff]","g");
var _e=new RegExp("[\\\\\\\"\\x00-\\x1f\\x7f-\\x9f\\u00ad\\u0600-\\u0604\\u070f\\u17b4\\u17b5\\u200c-\\u200f\\u2028-\\u202f\\u2060-\\u206f\\ufeff\\ufff0-\\uffff]","g");
var _f,_10,_11={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r","\"":"\\\"","\\":"\\\\"},rep;
function _12(_13){
_e.lastIndex=0;
return _e.test(_13)?"\""+_13.replace(_e,function(a){
var c=_11[a];
return typeof c==="string"?c:"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4);
})+"\"":"\""+_13+"\"";
};
function str(key,_14){
var i,k,v,_15,_16=_f,_17,_18=_14[key];
if(_18&&typeof _18==="object"&&typeof _18.toJSON==="function"){
_18=_18.toJSON(key);
}
if(typeof rep==="function"){
_18=rep.call(_14,key,_18);
}
switch(typeof _18){
case "string":
return _12(_18);
case "number":
return isFinite(_18)?String(_18):"null";
case "boolean":
case "null":
return String(_18);
case "object":
if(!_18){
return "null";
}
_f+=_10;
_17=[];
if(Object.prototype.toString.apply(_18)==="[object Array]"){
_15=_18.length;
for(i=0;i<_15;i+=1){
_17[i]=str(i,_18)||"null";
}
v=_17.length===0?"[]":_f?"[\n"+_f+_17.join(",\n"+_f)+"\n"+_16+"]":"["+_17.join(",")+"]";
_f=_16;
return v;
}
if(rep&&typeof rep==="object"){
_15=rep.length;
for(i=0;i<_15;i+=1){
k=rep[i];
if(typeof k==="string"){
v=str(k,_18);
if(v){
_17.push(_12(k)+(_f?": ":":")+v);
}
}
}
}else{
for(k in _18){
if(Object.hasOwnProperty.call(_18,k)){
v=str(k,_18);
if(v){
_17.push(_12(k)+(_f?": ":":")+v);
}
}
}
}
v=_17.length===0?"{}":_f?"{\n"+_f+_17.join(",\n"+_f)+"\n"+_16+"}":"{"+_17.join(",")+"}";
_f=_16;
return v;
}
};
if(typeof JSON.stringify!=="function"){
JSON.stringify=function(_19,_1a,_1b){
var i;
_f="";
_10="";
if(typeof _1b==="number"){
for(i=0;i<_1b;i+=1){
_10+=" ";
}
}else{
if(typeof _1b==="string"){
_10=_1b;
}
}
rep=_1a;
if(_1a&&typeof _1a!=="function"&&(typeof _1a!=="object"||typeof _1a.length!=="number")){
throw new Error("JSON.stringify");
}
return str("",{"":_19});
};
}
if(typeof JSON.parse!=="function"){
JSON.parse=function(_1c,_1d){
var j;
function _1e(_1f,key){
var k,v,_20=_1f[key];
if(_20&&typeof _20==="object"){
for(k in _20){
if(Object.hasOwnProperty.call(_20,k)){
v=_1e(_20,k);
if(v!==_2f){
_20[k]=v;
}else{
delete _20[k];
}
}
}
}
return _1d.call(_1f,key,_20);
};
cx.lastIndex=0;
if(cx.test(_1c)){
_1c=_1c.replace(cx,function(a){
return "\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4);
});
}
if(/^[\],:{}\s]*$/.test(_1c.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,""))){
j=eval("("+_1c+")");
return typeof _1d==="function"?_1e({"":j},""):j;
}
throw new SyntaxError("JSON.parse");
};
}
}());
var _21=/([^%]+|%(?:\d+\$)?[\+\-\ \#0]*[0-9\*]*(.[0-9\*]+)?[hlL]?[cbBdieEfgGosuxXpn%@])/g,_22=/(%)(?:(\d+)\$)?([\+\-\ \#0]*)([0-9\*]*)((?:.[0-9\*]+)?)([hlL]?)([cbBdieEfgGosuxXpn%@])/;
_2.sprintf=function(_23){
var _23=arguments[0],_24=_23.match(_21),_25=0,_26="",arg=1;
for(var i=0;i<_24.length;i++){
var t=_24[i];
if(_23.substring(_25,_25+t.length)!==t){
return _26;
}
_25+=t.length;
if(t.charAt(0)!=="%"){
_26+=t;
}else{
if(t==="%%"){
_26+="%";
}else{
var _27=t.match(_22);
if(_27.length!==8||_27[0]!==t){
return _26;
}
var _28=_27[1],_29=_27[2],_2a=_27[3],_2b=_27[4],_2c=_27[5],_2d=_27[6],_2e=_27[7];
if(_29===_2f||_29===null||_29===""){
_29=arg++;
}else{
_29=Number(_29);
}
var _30=null;
if(_2b=="*"){
_30=arguments[_29];
}else{
if(_2b!==""){
_30=Number(_2b);
}
}
var _31=null;
if(_2c===".*"){
_31=arguments[_29];
}else{
if(_2c!==""){
_31=Number(_2c.substring(1));
}
}
var _32=(_2a.indexOf("-")>=0),_33=(_2a.indexOf("0")>=0),_34="";
if(/[bBdiufeExXo]/.test(_2e)){
var num=Number(arguments[_29]),_35="";
if(num<0){
_35="-";
}else{
if(_2a.indexOf("+")>=0){
_35="+";
}else{
if(_2a.indexOf(" ")>=0){
_35=" ";
}
}
}
if(_2e==="d"||_2e==="i"||_2e==="u"){
var _36=String(Math.abs(Math.floor(num)));
_34=_37(_35,"",_36,"",_30,_32,_33);
}
if(_2e=="f"){
var _36=String((_31!==null)?Math.abs(num).toFixed(_31):Math.abs(num)),_38=(_2a.indexOf("#")>=0&&_36.indexOf(".")<0)?".":"";
_34=_37(_35,"",_36,_38,_30,_32,_33);
}
if(_2e==="e"||_2e==="E"){
var _36=String(Math.abs(num).toExponential(_31!==null?_31:21)),_38=(_2a.indexOf("#")>=0&&_36.indexOf(".")<0)?".":"";
_34=_37(_35,"",_36,_38,_30,_32,_33);
}
if(_2e=="x"||_2e=="X"){
var _36=String(Math.abs(num).toString(16));
var _39=(_2a.indexOf("#")>=0&&num!=0)?"0x":"";
_34=_37(_35,_39,_36,"",_30,_32,_33);
}
if(_2e=="b"||_2e=="B"){
var _36=String(Math.abs(num).toString(2));
var _39=(_2a.indexOf("#")>=0&&num!=0)?"0b":"";
_34=_37(_35,_39,_36,"",_30,_32,_33);
}
if(_2e=="o"){
var _36=String(Math.abs(num).toString(8));
var _39=(_2a.indexOf("#")>=0&&num!=0)?"0":"";
_34=_37(_35,_39,_36,"",_30,_32,_33);
}
if(/[A-Z]/.test(_2e)){
_34=_34.toUpperCase();
}else{
_34=_34.toLowerCase();
}
}else{
var _34="";
if(_2e==="%"){
_34="%";
}else{
if(_2e==="c"){
_34=String(arguments[_29]).charAt(0);
}else{
if(_2e==="s"||_2e==="@"){
_34=String(arguments[_29]);
}else{
if(_2e==="p"||_2e==="n"){
_34="";
}
}
}
}
_34=_37("","",_34,"",_30,_32,false);
}
_26+=_34;
}
}
}
return _26;
};
function _37(_3a,_3b,_3c,_3d,_3e,_3f,_40){
var _41=(_3a.length+_3b.length+_3c.length+_3d.length);
if(_3f){
return _3a+_3b+_3c+_3d+pad(_3e-_41," ");
}else{
if(_40){
return _3a+_3b+pad(_3e-_41,"0")+_3c+_3d;
}else{
return pad(_3e-_41," ")+_3a+_3b+_3c+_3d;
}
}
};
function pad(n,ch){
return Array(MAX(0,n)+1).join(ch);
};
CPLogDisable=false;
var _42="Cappuccino";
var _43=["fatal","error","warn","info","debug","trace"];
var _44=_43[3];
var _45={};
for(var i=0;i<_43.length;i++){
_45[_43[i]]=i;
}
var _46={};
CPLogRegister=function(_47,_48,_49){
CPLogRegisterRange(_47,_43[0],_48||_43[_43.length-1],_49);
};
CPLogRegisterRange=function(_4a,_4b,_4c,_4d){
var min=_45[_4b];
var max=_45[_4c];
if(min!==_2f&&max!==_2f&&min<=max){
for(var i=min;i<=max;i++){
CPLogRegisterSingle(_4a,_43[i],_4d);
}
}
};
CPLogRegisterSingle=function(_4e,_4f,_50){
if(!_46[_4f]){
_46[_4f]=[];
}
for(var i=0;i<_46[_4f].length;i++){
if(_46[_4f][i][0]===_4e){
_46[_4f][i][1]=_50;
return;
}
}
_46[_4f].push([_4e,_50]);
};
CPLogUnregister=function(_51){
for(var _52 in _46){
for(var i=0;i<_46[_52].length;i++){
if(_46[_52][i][0]===_51){
_46[_52].splice(i--,1);
}
}
}
};
function _53(_54,_55,_56){
if(_56==_2f){
_56=_42;
}
if(_55==_2f){
_55=_44;
}
var _57=(typeof _54[0]=="string"&&_54.length>1)?_2.sprintf.apply(null,_54):String(_54[0]);
if(_46[_55]){
for(var i=0;i<_46[_55].length;i++){
var _58=_46[_55][i];
_58[0](_57,_55,_56,_58[1]);
}
}
};
CPLog=function(){
_53(arguments);
};
for(var i=0;i<_43.length;i++){
CPLog[_43[i]]=(function(_59){
return function(){
_53(arguments,_59);
};
})(_43[i]);
}
var _5a=function(_5b,_5c,_5d){
var now=new Date(),_5e;
if(_5c===null){
_5c="";
}else{
_5c=_5c||"info";
_5c="["+CPLogColorize(_5c,_5c)+"]";
}
_5d=_5d||"";
if(_5d&&_5c){
_5d+=" ";
}
_5e=_5d+_5c;
if(_5e){
_5e+=": ";
}
if(typeof _2.sprintf=="function"){
return _2.sprintf("%4d-%02d-%02d %02d:%02d:%02d.%03d %s%s",now.getFullYear(),now.getMonth()+1,now.getDate(),now.getHours(),now.getMinutes(),now.getSeconds(),now.getMilliseconds(),_5e,_5b);
}else{
return now+" "+_5e+": "+_5b;
}
};
CPLogConsole=function(_5f,_60,_61,_62){
if(typeof console!="undefined"){
var _63=(_62||_5a)(_5f,_60,_61),_64={"fatal":"error","error":"error","warn":"warn","info":"info","debug":"debug","trace":"debug"}[_60];
if(_64&&console[_64]){
console[_64](_63);
}else{
if(console.log){
console.log(_63);
}
}
}
};
CPLogColorize=function(_65,_66){
return _65;
};
CPLogAlert=function(_67,_68,_69,_6a){
if(typeof alert!="undefined"&&!CPLogDisable){
var _6b=(_6a||_5a)(_67,_68,_69);
CPLogDisable=!confirm(_6b+"\n\n(Click cancel to stop log alerts)");
}
};
var _6c=null;
CPLogPopup=function(_6d,_6e,_6f,_70){
try{
if(CPLogDisable||window.open==_2f){
return;
}
if(!_6c||!_6c.document){
_6c=window.open("","_blank","width=600,height=400,status=no,resizable=yes,scrollbars=yes");
if(!_6c){
CPLogDisable=!confirm(_6d+"\n\n(Disable pop-up blocking for CPLog window; Click cancel to stop log alerts)");
return;
}
_71(_6c);
}
var _72=_6c.document.createElement("div");
_72.setAttribute("class",_6e||"fatal");
var _73=(_70||_5a)(_6d,_70?_6e:null,_6f);
_72.appendChild(_6c.document.createTextNode(_73));
_6c.log.appendChild(_72);
if(_6c.focusEnabled.checked){
_6c.focus();
}
if(_6c.blockEnabled.checked){
_6c.blockEnabled.checked=_6c.confirm(_73+"\nContinue blocking?");
}
if(_6c.scrollEnabled.checked){
_6c.scrollToBottom();
}
}
catch(e){
}
};
var _74="<style type=\"text/css\" media=\"screen\"> body{font:10px Monaco,Courier,\"Courier New\",monospace,mono;padding-top:15px;} div > .fatal,div > .error,div > .warn,div > .info,div > .debug,div > .trace{display:none;overflow:hidden;white-space:pre;padding:0px 5px 0px 5px;margin-top:2px;-moz-border-radius:5px;-webkit-border-radius:5px;} div[wrap=\"yes\"] > div{white-space:normal;} .fatal{background-color:#ffb2b3;} .error{background-color:#ffe2b2;} .warn{background-color:#fdffb2;} .info{background-color:#e4ffb2;} .debug{background-color:#a0e5a0;} .trace{background-color:#99b9ff;} .enfatal .fatal,.enerror .error,.enwarn .warn,.eninfo .info,.endebug .debug,.entrace .trace{display:block;} div#header{background-color:rgba(240,240,240,0.82);position:fixed;top:0px;left:0px;width:100%;border-bottom:1px solid rgba(0,0,0,0.33);text-align:center;} ul#enablers{display:inline-block;margin:1px 15px 0 15px;padding:2px 0 2px 0;} ul#enablers li{display:inline;padding:0px 5px 0px 5px;margin-left:4px;-moz-border-radius:5px;-webkit-border-radius:5px;} [enabled=\"no\"]{opacity:0.25;} ul#options{display:inline-block;margin:0 15px 0px 15px;padding:0 0px;} ul#options li{margin:0 0 0 0;padding:0 0 0 0;display:inline;} </style>";
function _71(_75){
var doc=_75.document;
doc.writeln("<html><head><title></title>"+_74+"</head><body></body></html>");
doc.title=_42+" Run Log";
var _76=doc.getElementsByTagName("head")[0];
var _77=doc.getElementsByTagName("body")[0];
var _78=window.location.protocol+"//"+window.location.host+window.location.pathname;
_78=_78.substring(0,_78.lastIndexOf("/")+1);
var div=doc.createElement("div");
div.setAttribute("id","header");
_77.appendChild(div);
var ul=doc.createElement("ul");
ul.setAttribute("id","enablers");
div.appendChild(ul);
for(var i=0;i<_43.length;i++){
var li=doc.createElement("li");
li.setAttribute("id","en"+_43[i]);
li.setAttribute("class",_43[i]);
li.setAttribute("onclick","toggle(this);");
li.setAttribute("enabled","yes");
li.appendChild(doc.createTextNode(_43[i]));
ul.appendChild(li);
}
var ul=doc.createElement("ul");
ul.setAttribute("id","options");
div.appendChild(ul);
var _79={"focus":["Focus",false],"block":["Block",false],"wrap":["Wrap",false],"scroll":["Scroll",true],"close":["Close",true]};
for(o in _79){
var li=doc.createElement("li");
ul.appendChild(li);
_75[o+"Enabled"]=doc.createElement("input");
_75[o+"Enabled"].setAttribute("id",o);
_75[o+"Enabled"].setAttribute("type","checkbox");
if(_79[o][1]){
_75[o+"Enabled"].setAttribute("checked","checked");
}
li.appendChild(_75[o+"Enabled"]);
var _7a=doc.createElement("label");
_7a.setAttribute("for",o);
_7a.appendChild(doc.createTextNode(_79[o][0]));
li.appendChild(_7a);
}
_75.log=doc.createElement("div");
_75.log.setAttribute("class","enerror endebug enwarn eninfo enfatal entrace");
_77.appendChild(_75.log);
_75.toggle=function(_7b){
var _7c=(_7b.getAttribute("enabled")=="yes")?"no":"yes";
_7b.setAttribute("enabled",_7c);
if(_7c=="yes"){
_75.log.className+=" "+_7b.id;
}else{
_75.log.className=_75.log.className.replace(new RegExp("[\\s]*"+_7b.id,"g"),"");
}
};
_75.scrollToBottom=function(){
_75.scrollTo(0,_77.offsetHeight);
};
_75.wrapEnabled.addEventListener("click",function(){
_75.log.setAttribute("wrap",_75.wrapEnabled.checked?"yes":"no");
},false);
_75.addEventListener("keydown",function(e){
var e=e||_75.event;
if(e.keyCode==75&&(e.ctrlKey||e.metaKey)){
while(_75.log.firstChild){
_75.log.removeChild(_75.log.firstChild);
}
e.preventDefault();
}
},"false");
window.addEventListener("unload",function(){
if(_75&&_75.closeEnabled&&_75.closeEnabled.checked){
CPLogDisable=true;
_75.close();
}
},false);
_75.addEventListener("unload",function(){
if(!CPLogDisable){
CPLogDisable=!confirm("Click cancel to stop logging");
}
},false);
};
CPLogDefault=(typeof window==="object"&&window.console)?CPLogConsole:CPLogPopup;
var _2f;
if(typeof window!=="undefined"){
window.setNativeTimeout=window.setTimeout;
window.clearNativeTimeout=window.clearTimeout;
window.setNativeInterval=window.setInterval;
window.clearNativeInterval=window.clearInterval;
}
NO=false;
YES=true;
nil=null;
Nil=null;
NULL=null;
ABS=Math.abs;
ASIN=Math.asin;
ACOS=Math.acos;
ATAN=Math.atan;
ATAN2=Math.atan2;
SIN=Math.sin;
COS=Math.cos;
TAN=Math.tan;
EXP=Math.exp;
POW=Math.pow;
CEIL=Math.ceil;
FLOOR=Math.floor;
ROUND=Math.round;
MIN=Math.min;
MAX=Math.max;
RAND=Math.random;
SQRT=Math.sqrt;
E=Math.E;
LN2=Math.LN2;
LN10=Math.LN10;
LOG=Math.log;
LOG2E=Math.LOG2E;
LOG10E=Math.LOG10E;
PI=Math.PI;
PI2=Math.PI*2;
PI_2=Math.PI/2;
SQRT1_2=Math.SQRT1_2;
SQRT2=Math.SQRT2;
function _7d(_7e){
this._eventListenersForEventNames={};
this._owner=_7e;
};
_7d.prototype.addEventListener=function(_7f,_80){
var _81=this._eventListenersForEventNames;
if(!_82.call(_81,_7f)){
var _83=[];
_81[_7f]=_83;
}else{
var _83=_81[_7f];
}
var _84=_83.length;
while(_84--){
if(_83[_84]===_80){
return;
}
}
_83.push(_80);
};
_7d.prototype.removeEventListener=function(_85,_86){
var _87=this._eventListenersForEventNames;
if(!_82.call(_87,_85)){
return;
}
var _88=_87[_85],_89=_88.length;
while(_89--){
if(_88[_89]===_86){
return _88.splice(_89,1);
}
}
};
_7d.prototype.dispatchEvent=function(_8a){
var _8b=_8a.type,_8c=this._eventListenersForEventNames;
if(_82.call(_8c,_8b)){
var _8d=this._eventListenersForEventNames[_8b],_8e=0,_8f=_8d.length;
for(;_8e<_8f;++_8e){
_8d[_8e](_8a);
}
}
var _90=(this._owner||this)["on"+_8b];
if(_90){
_90(_8a);
}
};
var _91=0,_92=null,_93=[];
function _94(_95){
var _96=_91;
if(_92===null){
window.setNativeTimeout(function(){
var _97=_93,_98=0,_99=_93.length;
++_91;
_92=null;
_93=[];
for(;_98<_99;++_98){
_97[_98]();
}
},0);
}
return function(){
var _9a=arguments;
if(_91>_96){
_95.apply(this,_9a);
}else{
_93.push(function(){
_95.apply(this,_9a);
});
}
};
};
var _9b=null;
if(window.XMLHttpRequest){
_9b=window.XMLHttpRequest;
}else{
if(window.ActiveXObject!==_2f){
var _9c=["Msxml2.XMLHTTP.3.0","Msxml2.XMLHTTP.6.0"],_9d=_9c.length;
while(_9d--){
try{
var _9e=_9c[_9d];
new ActiveXObject(_9e);
_9b=function(){
return new ActiveXObject(_9e);
};
break;
}
catch(anException){
}
}
}
}
CFHTTPRequest=function(){
this._isOpen=false;
this._requestHeaders={};
this._mimeType=null;
this._eventDispatcher=new _7d(this);
this._nativeRequest=new _9b();
this._nativeRequest.withCredentials=false;
var _9f=this;
this._stateChangeHandler=function(){
_b7(_9f);
};
this._timeoutHandler=function(){
_b5(_9f);
};
this._nativeRequest.onreadystatechange=this._stateChangeHandler;
this._nativeRequest.ontimeout=this._timeoutHandler;
if(CFHTTPRequest.AuthenticationDelegate!==nil){
this._eventDispatcher.addEventListener("HTTP403",function(){
CFHTTPRequest.AuthenticationDelegate(_9f);
});
}
};
CFHTTPRequest.UninitializedState=0;
CFHTTPRequest.LoadingState=1;
CFHTTPRequest.LoadedState=2;
CFHTTPRequest.InteractiveState=3;
CFHTTPRequest.CompleteState=4;
CFHTTPRequest.AuthenticationDelegate=nil;
CFHTTPRequest.prototype.status=function(){
try{
return this._nativeRequest.status||0;
}
catch(anException){
return 0;
}
};
CFHTTPRequest.prototype.statusText=function(){
try{
return this._nativeRequest.statusText||"";
}
catch(anException){
return "";
}
};
CFHTTPRequest.prototype.readyState=function(){
return this._nativeRequest.readyState;
};
CFHTTPRequest.prototype.success=function(){
var _a0=this.status();
if(_a0>=200&&_a0<300){
return YES;
}
return _a0===0&&this.responseText()&&this.responseText().length;
};
CFHTTPRequest.prototype.responseXML=function(){
var _a1=this._nativeRequest.responseXML;
if(_a1&&(_9b===window.XMLHttpRequest)&&_a1.documentRoot){
return _a1;
}
return _a2(this.responseText());
};
CFHTTPRequest.prototype.responsePropertyList=function(){
var _a3=this.responseText();
if(CFPropertyList.sniffedFormatOfString(_a3)===CFPropertyList.FormatXML_v1_0){
return CFPropertyList.propertyListFromXML(this.responseXML());
}
return CFPropertyList.propertyListFromString(_a3);
};
CFHTTPRequest.prototype.responseText=function(){
return this._nativeRequest.responseText;
};
CFHTTPRequest.prototype.setRequestHeader=function(_a4,_a5){
this._requestHeaders[_a4]=_a5;
};
CFHTTPRequest.prototype.getResponseHeader=function(_a6){
return this._nativeRequest.getResponseHeader(_a6);
};
CFHTTPRequest.prototype.setTimeout=function(_a7){
this._nativeRequest.timeout=_a7;
};
CFHTTPRequest.prototype.getTimeout=function(_a8){
return this._nativeRequest.timeout;
};
CFHTTPRequest.prototype.getAllResponseHeaders=function(){
return this._nativeRequest.getAllResponseHeaders();
};
CFHTTPRequest.prototype.overrideMimeType=function(_a9){
this._mimeType=_a9;
};
CFHTTPRequest.prototype.open=function(_aa,_ab,_ac,_ad,_ae){
this._isOpen=true;
this._URL=_ab;
this._async=_ac;
this._method=_aa;
this._user=_ad;
this._password=_ae;
return this._nativeRequest.open(_aa,_ab,_ac,_ad,_ae);
};
CFHTTPRequest.prototype.send=function(_af){
if(!this._isOpen){
delete this._nativeRequest.onreadystatechange;
delete this._nativeRequest.ontimeout;
this._nativeRequest.open(this._method,this._URL,this._async,this._user,this._password);
this._nativeRequest.ontimeout=this._timeoutHandler;
this._nativeRequest.onreadystatechange=this._stateChangeHandler;
}
for(var i in this._requestHeaders){
if(this._requestHeaders.hasOwnProperty(i)){
this._nativeRequest.setRequestHeader(i,this._requestHeaders[i]);
}
}
if(this._mimeType&&"overrideMimeType" in this._nativeRequest){
this._nativeRequest.overrideMimeType(this._mimeType);
}
this._isOpen=false;
try{
return this._nativeRequest.send(_af);
}
catch(anException){
this._eventDispatcher.dispatchEvent({type:"failure",request:this});
}
};
CFHTTPRequest.prototype.abort=function(){
this._isOpen=false;
return this._nativeRequest.abort();
};
CFHTTPRequest.prototype.addEventListener=function(_b0,_b1){
this._eventDispatcher.addEventListener(_b0,_b1);
};
CFHTTPRequest.prototype.removeEventListener=function(_b2,_b3){
this._eventDispatcher.removeEventListener(_b2,_b3);
};
CFHTTPRequest.prototype.setWithCredentials=function(_b4){
this._nativeRequest.withCredentials=_b4;
};
CFHTTPRequest.prototype.withCredentials=function(){
return this._nativeRequest.withCredentials;
};
CFHTTPRequest.prototype.isTimeoutRequest=function(){
return !this.success()&&!this._nativeRequest.response&&!this._nativeRequest.responseText&&!this._nativeRequest.responseType&&!this._nativeRequest.responseURL&&!this._nativeRequest.responseXML;
};
function _b5(_b6){
_b6._eventDispatcher.dispatchEvent({type:"timeout",request:_b6});
};
function _b7(_b8){
var _b9=_b8._eventDispatcher,_ba=_b8._nativeRequest,_bb=["uninitialized","loading","loaded","interactive","complete"];
_b9.dispatchEvent({type:"readystatechange",request:_b8});
if(_bb[_b8.readyState()]==="complete"){
var _bc="HTTP"+_b8.status();
_b9.dispatchEvent({type:_bc,request:_b8});
var _bd=_b8.success()?"success":"failure";
_b9.dispatchEvent({type:_bd,request:_b8});
_b9.dispatchEvent({type:_bb[_b8.readyState()],request:_b8});
}else{
_b9.dispatchEvent({type:_bb[_b8.readyState()],request:_b8});
}
};
function _be(_bf,_c0,_c1,_c2){
var _c3=new CFHTTPRequest();
if(_bf.pathExtension()==="plist"){
_c3.overrideMimeType("text/xml");
}
var _c4=0,_c5=null;
function _c6(_c7){
_c2(_c7.loaded-_c4);
_c4=_c7.loaded;
};
function _c8(_c9){
if(_c2&&_c5===null){
_c2(_c9.request.responseText().length);
}
_c0(_c9);
};
if(_2.asyncLoader){
_c3.onsuccess=_94(_c8);
_c3.onfailure=_94(_c1);
}else{
_c3.onsuccess=_c8;
_c3.onfailure=_c1;
}
if(_c2){
var _ca=true;
if(document.all){
_ca=!!window.atob;
}
if(_ca){
try{
_c5=_2.asyncLoader?_94(_c6):_c6;
_c3._nativeRequest.onprogress=_c5;
}
catch(anException){
_c5=null;
}
}
}
_c3.open("GET",_bf.absoluteString(),_2.asyncLoader);
_c3.send("");
};
_2.asyncLoader=YES;
_2.Asynchronous=_94;
_2.determineAndDispatchHTTPRequestEvents=_b7;
var _cb=0;
objj_generateObjectUID=function(){
return _cb++;
};
CFPropertyList=function(){
this._UID=objj_generateObjectUID();
};
CFPropertyList.DTDRE=/^\s*(?:<\?\s*xml\s+version\s*=\s*\"1.0\"[^>]*\?>\s*)?(?:<\!DOCTYPE[^>]*>\s*)?/i;
CFPropertyList.XMLRE=/^\s*(?:<\?\s*xml\s+version\s*=\s*\"1.0\"[^>]*\?>\s*)?(?:<\!DOCTYPE[^>]*>\s*)?<\s*plist[^>]*\>/i;
CFPropertyList.FormatXMLDTD="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">";
CFPropertyList.Format280NorthMagicNumber="280NPLIST";
CFPropertyList.FormatOpenStep=1,CFPropertyList.FormatXML_v1_0=100,CFPropertyList.FormatBinary_v1_0=200,CFPropertyList.Format280North_v1_0=-1000;
CFPropertyList.sniffedFormatOfString=function(_cc){
if(_cc.match(CFPropertyList.XMLRE)){
return CFPropertyList.FormatXML_v1_0;
}
if(_cc.substr(0,CFPropertyList.Format280NorthMagicNumber.length)===CFPropertyList.Format280NorthMagicNumber){
return CFPropertyList.Format280North_v1_0;
}
return NULL;
};
CFPropertyList.dataFromPropertyList=function(_cd,_ce){
var _cf=new CFMutableData();
_cf.setRawString(CFPropertyList.stringFromPropertyList(_cd,_ce));
return _cf;
};
CFPropertyList.stringFromPropertyList=function(_d0,_d1){
if(!_d1){
_d1=CFPropertyList.Format280North_v1_0;
}
var _d2=_d3[_d1];
return _d2["start"]()+_d4(_d0,_d2)+_d2["finish"]();
};
function _d4(_d5,_d6){
var _d7=typeof _d5,_d8=_d5.valueOf(),_d9=typeof _d8;
if(_d7!==_d9){
_d7=_d9;
_d5=_d8;
}
if(_d5===YES||_d5===NO){
_d7="boolean";
}else{
if(_d7==="number"){
if(FLOOR(_d5)===_d5&&(""+_d5).indexOf("e")==-1){
_d7="integer";
}else{
_d7="real";
}
}else{
if(_d7!=="string"){
if(_d5.slice){
_d7="array";
}else{
_d7="dictionary";
}
}
}
}
return _d6[_d7](_d5,_d6);
};
var _d3={};
_d3[CFPropertyList.FormatXML_v1_0]={"start":function(){
return CFPropertyList.FormatXMLDTD+"<plist version = \"1.0\">";
},"finish":function(){
return "</plist>";
},"string":function(_da){
return "<string>"+_db(_da)+"</string>";
},"boolean":function(_dc){
return _dc?"<true/>":"<false/>";
},"integer":function(_dd){
return "<integer>"+_dd+"</integer>";
},"real":function(_de){
return "<real>"+_de+"</real>";
},"array":function(_df,_e0){
var _e1=0,_e2=_df.length,_e3="<array>";
for(;_e1<_e2;++_e1){
_e3+=_d4(_df[_e1],_e0);
}
return _e3+"</array>";
},"dictionary":function(_e4,_e5){
var _e6=_e4._keys,_9d=0,_e7=_e6.length,_e8="<dict>";
for(;_9d<_e7;++_9d){
var key=_e6[_9d];
_e8+="<key>"+key+"</key>";
_e8+=_d4(_e4.valueForKey(key),_e5);
}
return _e8+"</dict>";
}};
var _e9="A",_ea="D",_eb="f",_ec="d",_ed="S",_ee="T",_ef="F",_f0="K",_f1="E";
_d3[CFPropertyList.Format280North_v1_0]={"start":function(){
return CFPropertyList.Format280NorthMagicNumber+";1.0;";
},"finish":function(){
return "";
},"string":function(_f2){
return _ed+";"+_f2.length+";"+_f2;
},"boolean":function(_f3){
return (_f3?_ee:_ef)+";";
},"integer":function(_f4){
var _f5=""+_f4;
return _ec+";"+_f5.length+";"+_f5;
},"real":function(_f6){
var _f7=""+_f6;
return _eb+";"+_f7.length+";"+_f7;
},"array":function(_f8,_f9){
var _fa=0,_fb=_f8.length,_fc=_e9+";";
for(;_fa<_fb;++_fa){
_fc+=_d4(_f8[_fa],_f9);
}
return _fc+_f1+";";
},"dictionary":function(_fd,_fe){
var _ff=_fd._keys,_9d=0,_100=_ff.length,_101=_ea+";";
for(;_9d<_100;++_9d){
var key=_ff[_9d];
_101+=_f0+";"+key.length+";"+key;
_101+=_d4(_fd.valueForKey(key),_fe);
}
return _101+_f1+";";
}};
var _102="xml",_103="#document",_104="plist",_105="key",_106="dict",_107="array",_108="string",_109="date",_10a="true",_10b="false",_10c="real",_10d="integer",_10e="data";
var _10f=function(_110){
var text="",_9d=0,_111=_110.length;
for(;_9d<_111;++_9d){
var node=_110[_9d];
if(node.nodeType===3||node.nodeType===4){
text+=node.nodeValue;
}else{
if(node.nodeType!==8){
text+=_10f(node.childNodes);
}
}
}
return text;
};
var _112=function(_113,_114,_115){
var node=_113;
node=(node.firstChild);
if(node!==NULL&&((node.nodeType)===8||(node.nodeType)===3)){
while((node=(node.nextSibling))&&((node.nodeType)===8||(node.nodeType)===3)){
}
}
if(node){
return node;
}
if((String(_113.nodeName))===_107||(String(_113.nodeName))===_106){
_115.pop();
}else{
if(node===_114){
return NULL;
}
node=_113;
while((node=(node.nextSibling))&&((node.nodeType)===8||(node.nodeType)===3)){
}
if(node){
return node;
}
}
node=_113;
while(node){
var next=node;
while((next=(next.nextSibling))&&((next.nodeType)===8||(next.nodeType)===3)){
}
if(next){
return next;
}
var node=(node.parentNode);
if(_114&&node===_114){
return NULL;
}
_115.pop();
}
return NULL;
};
CFPropertyList.propertyListFromData=function(_116,_117){
return CFPropertyList.propertyListFromString(_116.rawString(),_117);
};
CFPropertyList.propertyListFromString=function(_118,_119){
if(!_119){
_119=CFPropertyList.sniffedFormatOfString(_118);
}
if(_119===CFPropertyList.FormatXML_v1_0){
return CFPropertyList.propertyListFromXML(_118);
}
if(_119===CFPropertyList.Format280North_v1_0){
return _11a(_118);
}
return NULL;
};
var _e9="A",_ea="D",_eb="f",_ec="d",_ed="S",_ee="T",_ef="F",_f0="K",_f1="E";
function _11a(_11b){
var _11c=new _11d(_11b),_11e=NULL,key="",_11f=NULL,_120=NULL,_121=[],_122=NULL;
while(_11e=_11c.getMarker()){
if(_11e===_f1){
_121.pop();
continue;
}
var _123=_121.length;
if(_123){
_122=_121[_123-1];
}
if(_11e===_f0){
key=_11c.getString();
_11e=_11c.getMarker();
}
switch(_11e){
case _e9:
_11f=[];
_121.push(_11f);
break;
case _ea:
_11f=new CFMutableDictionary();
_121.push(_11f);
break;
case _eb:
_11f=parseFloat(_11c.getString());
break;
case _ec:
_11f=parseInt(_11c.getString(),10);
break;
case _ed:
_11f=_11c.getString();
break;
case _ee:
_11f=YES;
break;
case _ef:
_11f=NO;
break;
default:
throw new Error("*** "+_11e+" marker not recognized in Plist.");
}
if(!_120){
_120=_11f;
}else{
if(_122){
if(_122.slice){
_122.push(_11f);
}else{
_122.setValueForKey(key,_11f);
}
}
}
}
return _120;
};
function _db(_124){
return _124.replace(/&/g,"&amp;").replace(/"/g,"&quot;").replace(/'/g,"&apos;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
};
function _125(_126){
return _126.replace(/&quot;/g,"\"").replace(/&apos;/g,"'").replace(/&lt;/g,"<").replace(/&gt;/g,">").replace(/&amp;/g,"&");
};
function _a2(_127){
if(window.DOMParser){
return (new window.DOMParser().parseFromString(_127,"text/xml").documentElement);
}else{
if(window.ActiveXObject){
XMLNode=new ActiveXObject("Microsoft.XMLDOM");
var _128=_127.match(CFPropertyList.DTDRE);
if(_128){
_127=_127.substr(_128[0].length);
}
XMLNode.loadXML(_127);
return XMLNode;
}
}
return NULL;
};
CFPropertyList.propertyListFromXML=function(_129){
var _12a=_129;
if(_129.valueOf&&typeof _129.valueOf()==="string"){
_12a=_a2(_129);
}
while(((String(_12a.nodeName))===_103)||((String(_12a.nodeName))===_102)){
_12a=(_12a.firstChild);
if(_12a!==NULL&&((_12a.nodeType)===8||(_12a.nodeType)===3)){
while((_12a=(_12a.nextSibling))&&((_12a.nodeType)===8||(_12a.nodeType)===3)){
}
}
}
if(((_12a.nodeType)===10)){
while((_12a=(_12a.nextSibling))&&((_12a.nodeType)===8||(_12a.nodeType)===3)){
}
}
if(!((String(_12a.nodeName))===_104)){
return NULL;
}
var key="",_12b=NULL,_12c=NULL,_12d=_12a,_12e=[],_12f=NULL;
while(_12a=_112(_12a,_12d,_12e)){
var _130=_12e.length;
if(_130){
_12f=_12e[_130-1];
}
if((String(_12a.nodeName))===_105){
key=(_12a.textContent||(_12a.textContent!==""&&_10f([_12a])));
while((_12a=(_12a.nextSibling))&&((_12a.nodeType)===8||(_12a.nodeType)===3)){
}
}
switch(String((String(_12a.nodeName)))){
case _107:
_12b=[];
_12e.push(_12b);
break;
case _106:
_12b=new CFMutableDictionary();
_12e.push(_12b);
break;
case _10c:
_12b=parseFloat((_12a.textContent||(_12a.textContent!==""&&_10f([_12a]))));
break;
case _10d:
_12b=parseInt((_12a.textContent||(_12a.textContent!==""&&_10f([_12a]))),10);
break;
case _108:
if((_12a.getAttribute("type")==="base64")){
_12b=(_12a.firstChild)?CFData.decodeBase64ToString((_12a.textContent||(_12a.textContent!==""&&_10f([_12a])))):"";
}else{
_12b=_125((_12a.firstChild)?(_12a.textContent||(_12a.textContent!==""&&_10f([_12a]))):"");
}
break;
case _109:
var _131=Date.parseISO8601((_12a.textContent||(_12a.textContent!==""&&_10f([_12a]))));
_12b=isNaN(_131)?new Date():new Date(_131);
break;
case _10a:
_12b=YES;
break;
case _10b:
_12b=NO;
break;
case _10e:
_12b=new CFMutableData();
var _132=(_12a.firstChild)?CFData.decodeBase64ToArray((_12a.textContent||(_12a.textContent!==""&&_10f([_12a]))),YES):[];
_12b.setBytes(_132);
break;
default:
throw new Error("*** "+(String(_12a.nodeName))+" tag not recognized in Plist.");
}
if(!_12c){
_12c=_12b;
}else{
if(_12f){
if(_12f.slice){
_12f.push(_12b);
}else{
_12f.setValueForKey(key,_12b);
}
}
}
}
return _12c;
};
kCFPropertyListOpenStepFormat=CFPropertyList.FormatOpenStep;
kCFPropertyListXMLFormat_v1_0=CFPropertyList.FormatXML_v1_0;
kCFPropertyListBinaryFormat_v1_0=CFPropertyList.FormatBinary_v1_0;
kCFPropertyList280NorthFormat_v1_0=CFPropertyList.Format280North_v1_0;
CFPropertyListCreate=function(){
return new CFPropertyList();
};
CFPropertyListCreateFromXMLData=function(data){
return CFPropertyList.propertyListFromData(data,CFPropertyList.FormatXML_v1_0);
};
CFPropertyListCreateXMLData=function(_133){
return CFPropertyList.dataFromPropertyList(_133,CFPropertyList.FormatXML_v1_0);
};
CFPropertyListCreateFrom280NorthData=function(data){
return CFPropertyList.propertyListFromData(data,CFPropertyList.Format280North_v1_0);
};
CFPropertyListCreate280NorthData=function(_134){
return CFPropertyList.dataFromPropertyList(_134,CFPropertyList.Format280North_v1_0);
};
CPPropertyListCreateFromData=function(data,_135){
return CFPropertyList.propertyListFromData(data,_135);
};
CPPropertyListCreateData=function(_136,_137){
return CFPropertyList.dataFromPropertyList(_136,_137);
};
CFDictionary=function(_138){
this._keys=[];
this._count=0;
this._buckets={};
this._UID=objj_generateObjectUID();
};
var _139=Array.prototype.indexOf,_82=Object.prototype.hasOwnProperty;
CFDictionary.prototype.copy=function(){
return this;
};
CFDictionary.prototype.mutableCopy=function(){
var _13a=new CFMutableDictionary(),keys=this._keys,_13b=this._count;
_13a._keys=keys.slice();
_13a._count=_13b;
var _13c=0,_13d=this._buckets,_13e=_13a._buckets;
for(;_13c<_13b;++_13c){
var key=keys[_13c];
_13e[key]=_13d[key];
}
return _13a;
};
CFDictionary.prototype.containsKey=function(aKey){
return _82.apply(this._buckets,[aKey]);
};
CFDictionary.prototype.containsValue=function(_13f){
var keys=this._keys,_140=this._buckets,_9d=0,_141=keys.length;
for(;_9d<_141;++_9d){
if(_140[keys[_9d]]===_13f){
return YES;
}
}
return NO;
};
CFDictionary.prototype.count=function(){
return this._count;
};
CFDictionary.prototype.countOfKey=function(aKey){
return this.containsKey(aKey)?1:0;
};
CFDictionary.prototype.countOfValue=function(_142){
var keys=this._keys,_143=this._buckets,_9d=0,_144=keys.length,_145=0;
for(;_9d<_144;++_9d){
if(_143[keys[_9d]]===_142){
++_145;
}
}
return _145;
};
CFDictionary.prototype.keys=function(){
return this._keys.slice();
};
CFDictionary.prototype.valueForKey=function(aKey){
var _146=this._buckets;
if(!_82.apply(_146,[aKey])){
return nil;
}
return _146[aKey];
};
CFDictionary.prototype.toString=function(){
var _147="{\n",keys=this._keys,_9d=0,_148=this._count;
for(;_9d<_148;++_9d){
var key=keys[_9d];
_147+="\t"+key+" = \""+String(this.valueForKey(key)).split("\n").join("\n\t")+"\"\n";
}
return _147+"}";
};
CFMutableDictionary=function(_149){
CFDictionary.apply(this,[]);
};
CFMutableDictionary.prototype=new CFDictionary();
CFMutableDictionary.prototype.copy=function(){
return this.mutableCopy();
};
CFMutableDictionary.prototype.addValueForKey=function(aKey,_14a){
if(this.containsKey(aKey)){
return;
}
++this._count;
this._keys.push(aKey);
this._buckets[aKey]=_14a;
};
CFMutableDictionary.prototype.removeValueForKey=function(aKey){
var _14b=-1;
if(_139){
_14b=_139.call(this._keys,aKey);
}else{
var keys=this._keys,_9d=0,_14c=keys.length;
for(;_9d<_14c;++_9d){
if(keys[_9d]===aKey){
_14b=_9d;
break;
}
}
}
if(_14b===-1){
return;
}
--this._count;
this._keys.splice(_14b,1);
delete this._buckets[aKey];
};
CFMutableDictionary.prototype.removeAllValues=function(){
this._count=0;
this._keys=[];
this._buckets={};
};
CFMutableDictionary.prototype.replaceValueForKey=function(aKey,_14d){
if(!this.containsKey(aKey)){
return;
}
this._buckets[aKey]=_14d;
};
CFMutableDictionary.prototype.setValueForKey=function(aKey,_14e){
if(_14e===nil||_14e===_2f){
this.removeValueForKey(aKey);
}else{
if(this.containsKey(aKey)){
this.replaceValueForKey(aKey,_14e);
}else{
this.addValueForKey(aKey,_14e);
}
}
};
kCFErrorLocalizedDescriptionKey="CPLocalizedDescription";
kCFErrorLocalizedFailureReasonKey="CPLocalizedFailureReason";
kCFErrorLocalizedRecoverySuggestionKey="CPLocalizedRecoverySuggestion";
kCFErrorDescriptionKey="CPDescription";
kCFErrorUnderlyingErrorKey="CPUnderlyingError";
kCFErrorURLKey="CPURL";
kCFErrorFilePathKey="CPFilePath";
kCFErrorDomainCappuccino="CPCappuccinoErrorDomain";
kCFErrorDomainCocoa=kCFErrorDomainCappuccino;
CFError=function(_14f,code,_150){
this._domain=_14f||NULL;
this._code=code||0;
this._userInfo=_150||new CFDictionary();
this._UID=objj_generateObjectUID();
};
CFError.prototype.domain=function(){
return this._domain;
};
CFError.prototype.code=function(){
return this._code;
};
CFError.prototype.description=function(){
var _151=this._userInfo.valueForKey(kCFErrorLocalizedDescriptionKey);
if(_151){
return _151;
}
var _152=this._userInfo.valueForKey(kCFErrorLocalizedFailureReasonKey);
if(_152){
var _153="The operation couldn’t be completed. "+_152;
return _153;
}
var _154="",desc=this._userInfo.valueForKey(kCFErrorDescriptionKey);
if(desc){
var _154="The operation couldn’t be completed. (error "+this._code+" - "+desc+")";
}else{
var _154="The operation couldn’t be completed. (error "+this._code+")";
}
return _154;
};
CFError.prototype.failureReason=function(){
return this._userInfo.valueForKey(kCFErrorLocalizedFailureReasonKey);
};
CFError.prototype.recoverySuggestion=function(){
return this._userInfo.valueForKey(kCFErrorLocalizedRecoverySuggestionKey);
};
CFError.prototype.userInfo=function(){
return this._userInfo;
};
CFErrorCreate=function(_155,code,_156){
return new CFError(_155,code,_156);
};
CFErrorCreateWithUserInfoKeysAndValues=function(_157,code,_158,_159,_15a){
var _15b=new CFMutableDictionary();
while(_15a--){
_15b.setValueForKey(_158[_15a],_159[_15a]);
}
return new CFError(_157,code,_15b);
};
CFErrorGetCode=function(err){
return err.code();
};
CFErrorGetDomain=function(err){
return err.domain();
};
CFErrorCopyDescription=function(err){
return err.description();
};
CFErrorCopyUserInfo=function(err){
return err.userInfo();
};
CFErrorCopyFailureReason=function(err){
return err.failureReason();
};
CFErrorCopyRecoverySuggestion=function(err){
return err.recoverySuggestion();
};
kCFURLErrorUnknown=-998;
kCFURLErrorCancelled=-999;
kCFURLErrorBadURL=-1000;
kCFURLErrorTimedOut=-1001;
kCFURLErrorUnsupportedURL=-1002;
kCFURLErrorCannotFindHost=-1003;
kCFURLErrorCannotConnectToHost=-1004;
kCFURLErrorNetworkConnectionLost=-1005;
kCFURLErrorDNSLookupFailed=-1006;
kCFURLErrorHTTPTooManyRedirects=-1007;
kCFURLErrorResourceUnavailable=-1008;
kCFURLErrorNotConnectedToInternet=-1009;
kCFURLErrorRedirectToNonExistentLocation=-1010;
kCFURLErrorBadServerResponse=-1011;
kCFURLErrorUserCancelledAuthentication=-1012;
kCFURLErrorUserAuthenticationRequired=-1013;
kCFURLErrorZeroByteResource=-1014;
kCFURLErrorCannotDecodeRawData=-1015;
kCFURLErrorCannotDecodeContentData=-1016;
kCFURLErrorCannotParseResponse=-1017;
kCFURLErrorRequestBodyStreamExhausted=-1021;
kCFURLErrorFileDoesNotExist=-1100;
kCFURLErrorFileIsDirectory=-1101;
kCFURLErrorNoPermissionsToReadFile=-1102;
kCFURLErrorDataLengthExceedsMaximum=-1103;
CFData=function(){
this._rawString=NULL;
this._propertyList=NULL;
this._propertyListFormat=NULL;
this._JSONObject=NULL;
this._bytes=NULL;
this._base64=NULL;
};
CFData.prototype.propertyList=function(){
if(!this._propertyList){
this._propertyList=CFPropertyList.propertyListFromString(this.rawString());
}
return this._propertyList;
};
CFData.prototype.JSONObject=function(){
if(!this._JSONObject){
try{
this._JSONObject=JSON.parse(this.rawString());
}
catch(anException){
}
}
return this._JSONObject;
};
CFData.prototype.rawString=function(){
if(this._rawString===NULL){
if(this._propertyList){
this._rawString=CFPropertyList.stringFromPropertyList(this._propertyList,this._propertyListFormat);
}else{
if(this._JSONObject){
this._rawString=JSON.stringify(this._JSONObject);
}else{
if(this._bytes){
this._rawString=CFData.bytesToString(this._bytes);
}else{
if(this._base64){
this._rawString=CFData.decodeBase64ToString(this._base64,true);
}else{
throw new Error("Can't convert data to string.");
}
}
}
}
}
return this._rawString;
};
CFData.prototype.bytes=function(){
if(this._bytes===NULL){
var _15c=CFData.stringToBytes(this.rawString());
this.setBytes(_15c);
}
return this._bytes;
};
CFData.prototype.base64=function(){
if(this._base64===NULL){
var _15d;
if(this._bytes){
_15d=CFData.encodeBase64Array(this._bytes);
}else{
_15d=CFData.encodeBase64String(this.rawString());
}
this.setBase64String(_15d);
}
return this._base64;
};
CFMutableData=function(){
CFData.call(this);
};
CFMutableData.prototype=new CFData();
function _15e(_15f){
this._rawString=NULL;
this._propertyList=NULL;
this._propertyListFormat=NULL;
this._JSONObject=NULL;
this._bytes=NULL;
this._base64=NULL;
};
CFMutableData.prototype.setPropertyList=function(_160,_161){
_15e(this);
this._propertyList=_160;
this._propertyListFormat=_161;
};
CFMutableData.prototype.setJSONObject=function(_162){
_15e(this);
this._JSONObject=_162;
};
CFMutableData.prototype.setRawString=function(_163){
_15e(this);
this._rawString=_163;
};
CFMutableData.prototype.setBytes=function(_164){
_15e(this);
this._bytes=_164;
};
CFMutableData.prototype.setBase64String=function(_165){
_15e(this);
this._base64=_165;
};
var _166=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/","="],_167=[];
for(var i=0;i<_166.length;i++){
_167[_166[i].charCodeAt(0)]=i;
}
CFData.decodeBase64ToArray=function(_168,_169){
if(_169){
_168=_168.replace(/[^A-Za-z0-9\+\/\=]/g,"");
}
var pad=(_168[_168.length-1]=="="?1:0)+(_168[_168.length-2]=="="?1:0),_16a=_168.length,_16b=[];
var i=0;
while(i<_16a){
var bits=(_167[_168.charCodeAt(i++)]<<18)|(_167[_168.charCodeAt(i++)]<<12)|(_167[_168.charCodeAt(i++)]<<6)|(_167[_168.charCodeAt(i++)]);
_16b.push((bits&16711680)>>16);
_16b.push((bits&65280)>>8);
_16b.push(bits&255);
}
if(pad>0){
return _16b.slice(0,-1*pad);
}
return _16b;
};
CFData.encodeBase64Array=function(_16c){
var pad=(3-(_16c.length%3))%3,_16d=_16c.length+pad,_16e=[];
if(pad>0){
_16c.push(0);
}
if(pad>1){
_16c.push(0);
}
var i=0;
while(i<_16d){
var bits=(_16c[i++]<<16)|(_16c[i++]<<8)|(_16c[i++]);
_16e.push(_166[(bits&16515072)>>18]);
_16e.push(_166[(bits&258048)>>12]);
_16e.push(_166[(bits&4032)>>6]);
_16e.push(_166[bits&63]);
}
if(pad>0){
_16e[_16e.length-1]="=";
_16c.pop();
}
if(pad>1){
_16e[_16e.length-2]="=";
_16c.pop();
}
return _16e.join("");
};
CFData.decodeBase64ToString=function(_16f,_170){
return CFData.bytesToString(CFData.decodeBase64ToArray(_16f,_170));
};
CFData.decodeBase64ToUtf16String=function(_171,_172){
return CFData.bytesToUtf16String(CFData.decodeBase64ToArray(_171,_172));
};
CFData.bytesToString=function(_173){
return String.fromCharCode.apply(NULL,_173);
};
CFData.stringToBytes=function(_174){
var temp=[];
for(var i=0;i<_174.length;i++){
temp.push(_174.charCodeAt(i));
}
return temp;
};
CFData.encodeBase64String=function(_175){
var temp=[];
for(var i=0;i<_175.length;i++){
temp.push(_175.charCodeAt(i));
}
return CFData.encodeBase64Array(temp);
};
CFData.bytesToUtf16String=function(_176){
var temp=[];
for(var i=0;i<_176.length;i+=2){
temp.push(_176[i+1]<<8|_176[i]);
}
return String.fromCharCode.apply(NULL,temp);
};
CFData.encodeBase64Utf16String=function(_177){
var temp=[];
for(var i=0;i<_177.length;i++){
var c=_177.charCodeAt(i);
temp.push(c&255);
temp.push((c&65280)>>8);
}
return CFData.encodeBase64Array(temp);
};
var _178,_179,_17a=0;
function _17b(){
if(++_17a!==1){
return;
}
_178={};
_179={};
};
function _17c(){
_17a=MAX(_17a-1,0);
if(_17a!==0){
return;
}
delete _178;
delete _179;
};
var _17d=new RegExp("^"+"(?:"+"([^:/?#]+):"+")?"+"(?:"+"(//)"+"("+"(?:"+"("+"([^:@]*)"+":?"+"([^:@]*)"+")?"+"@"+")?"+"([^:/?#]*)"+"(?::(\\d*))?"+")"+")?"+"([^?#]*)"+"(?:\\?([^#]*))?"+"(?:#(.*))?");
var _17e=["url","scheme","authorityRoot","authority","userInfo","user","password","domain","portNumber","path","queryString","fragment"];
function _17f(aURL){
if(aURL._parts){
return aURL._parts;
}
var _180=aURL.string(),_181=_180.match(/^mhtml:/);
if(_181){
_180=_180.substr("mhtml:".length);
}
if(_17a>0&&_82.call(_179,_180)){
aURL._parts=_179[_180];
return aURL._parts;
}
aURL._parts={};
var _182=aURL._parts,_183=_17d.exec(_180),_9d=_183.length;
while(_9d--){
_182[_17e[_9d]]=_183[_9d]||NULL;
}
_182.portNumber=parseInt(_182.portNumber,10);
if(isNaN(_182.portNumber)){
_182.portNumber=-1;
}
_182.pathComponents=[];
if(_182.path){
var _184=_182.path.split("/"),_185=_182.pathComponents,_186=_184.length;
for(_9d=0;_9d<_186;++_9d){
var _187=_184[_9d];
if(_187){
_185.push(_187);
}else{
if(_9d===0){
_185.push("/");
}
}
}
_182.pathComponents=_185;
}
if(_181){
_182.url="mhtml:"+_182.url;
_182.scheme="mhtml:"+_182.scheme;
}
if(_17a>0){
_179[_180]=_182;
}
return _182;
};
CFURL=function(aURL,_188){
aURL=aURL||"";
if(aURL instanceof CFURL){
if(!_188){
return new CFURL(aURL.absoluteString());
}
var _189=aURL.baseURL();
if(_189){
_188=new CFURL(_189.absoluteURL(),_188);
}
aURL=aURL.string();
}
if(_17a>0){
var _18a=aURL+" "+(_188&&_188.UID()||"");
if(_82.call(_178,_18a)){
return _178[_18a];
}
_178[_18a]=this;
}
if(aURL.match(/^data:/)){
var _18b={},_9d=_17e.length;
while(_9d--){
_18b[_17e[_9d]]="";
}
_18b.url=aURL;
_18b.scheme="data";
_18b.pathComponents=[];
this._parts=_18b;
this._standardizedURL=this;
this._absoluteURL=this;
}
this._UID=objj_generateObjectUID();
this._string=aURL;
this._baseURL=_188;
};
CFURL.prototype.UID=function(){
return this._UID;
};
var _18c={};
CFURL.prototype.mappedURL=function(){
return _18c[this.absoluteString()]||this;
};
CFURL.setMappedURLForURL=function(_18d,_18e){
_18c[_18d.absoluteString()]=_18e;
};
CFURL.prototype.schemeAndAuthority=function(){
var _18f="",_190=this.scheme();
if(_190){
_18f+=_190+":";
}
var _191=this.authority();
if(_191){
_18f+="//"+_191;
}
return _18f;
};
CFURL.prototype.absoluteString=function(){
if(this._absoluteString===_2f){
this._absoluteString=this.absoluteURL().string();
}
return this._absoluteString;
};
CFURL.prototype.toString=function(){
return this.absoluteString();
};
function _192(aURL){
aURL=aURL.standardizedURL();
var _193=aURL.baseURL();
if(!_193){
return aURL;
}
var _194=((aURL)._parts||_17f(aURL)),_195,_196=_193.absoluteURL(),_197=((_196)._parts||_17f(_196));
if(!_194.scheme&&_194.authorityRoot){
_195=_198(_194);
_195.scheme=_193.scheme();
}else{
if(_194.scheme||_194.authority){
_195=_194;
}else{
_195={};
_195.scheme=_197.scheme;
_195.authority=_197.authority;
_195.userInfo=_197.userInfo;
_195.user=_197.user;
_195.password=_197.password;
_195.domain=_197.domain;
_195.portNumber=_197.portNumber;
_195.queryString=_194.queryString;
_195.fragment=_194.fragment;
var _199=_194.pathComponents;
if(_199.length&&_199[0]==="/"){
_195.path=_194.path;
_195.pathComponents=_199;
}else{
var _19a=_197.pathComponents,_19b=_19a.concat(_199);
if(!_193.hasDirectoryPath()&&_19a.length){
_19b.splice(_19a.length-1,1);
}
if(_199.length&&(_199[0]===".."||_199[0]===".")){
_19c(_19b,YES);
}
_195.pathComponents=_19b;
_195.path=_19d(_19b,_199.length<=0||aURL.hasDirectoryPath());
}
}
}
var _19e=_19f(_195),_1a0=new CFURL(_19e);
_1a0._parts=_195;
_1a0._standardizedURL=_1a0;
_1a0._standardizedString=_19e;
_1a0._absoluteURL=_1a0;
_1a0._absoluteString=_19e;
return _1a0;
};
function _19d(_1a1,_1a2){
var path=_1a1.join("/");
if(path.length&&path.charAt(0)==="/"){
path=path.substr(1);
}
if(_1a2){
path+="/";
}
return path;
};
function _19c(_1a3,_1a4){
var _1a5=0,_1a6=0,_1a7=_1a3.length,_1a8=_1a4?_1a3:[],_1a9=NO;
for(;_1a5<_1a7;++_1a5){
var _1aa=_1a3[_1a5];
if(_1aa===""){
continue;
}
if(_1aa==="."){
_1a9=_1a6===0;
continue;
}
if(_1aa!==".."||_1a6===0||_1a8[_1a6-1]===".."){
_1a8[_1a6]=_1aa;
_1a6++;
continue;
}
if(_1a6>0&&_1a8[_1a6-1]!=="/"){
--_1a6;
}
}
if(_1a9&&_1a6===0){
_1a8[_1a6++]=".";
}
_1a8.length=_1a6;
return _1a8;
};
function _19f(_1ab){
var _1ac="",_1ad=_1ab.scheme;
if(_1ad){
_1ac+=_1ad+":";
}
var _1ae=_1ab.authority;
if(_1ae){
_1ac+="//"+_1ae;
}
_1ac+=_1ab.path;
var _1af=_1ab.queryString;
if(_1af){
_1ac+="?"+_1af;
}
var _1b0=_1ab.fragment;
if(_1b0){
_1ac+="#"+_1b0;
}
return _1ac;
};
CFURL.prototype.absoluteURL=function(){
if(this._absoluteURL===_2f){
this._absoluteURL=_192(this);
}
return this._absoluteURL;
};
CFURL.prototype.standardizedURL=function(){
if(this._standardizedURL===_2f){
var _1b1=((this)._parts||_17f(this)),_1b2=_1b1.pathComponents,_1b3=_19c(_1b2,NO);
var _1b4=_19d(_1b3,this.hasDirectoryPath());
if(_1b1.path===_1b4){
this._standardizedURL=this;
}else{
var _1b5=_198(_1b1);
_1b5.pathComponents=_1b3;
_1b5.path=_1b4;
var _1b6=new CFURL(_19f(_1b5),this.baseURL());
_1b6._parts=_1b5;
_1b6._standardizedURL=_1b6;
this._standardizedURL=_1b6;
}
}
return this._standardizedURL;
};
function _198(_1b7){
var _1b8={},_1b9=_17e.length;
while(_1b9--){
var _1ba=_17e[_1b9];
_1b8[_1ba]=_1b7[_1ba];
}
return _1b8;
};
CFURL.prototype.string=function(){
return this._string;
};
CFURL.prototype.authority=function(){
var _1bb=((this)._parts||_17f(this)).authority;
if(_1bb){
return _1bb;
}
var _1bc=this.baseURL();
return _1bc&&_1bc.authority()||"";
};
CFURL.prototype.hasDirectoryPath=function(){
var _1bd=this._hasDirectoryPath;
if(_1bd===_2f){
var path=this.path();
if(!path){
return NO;
}
if(path.charAt(path.length-1)==="/"){
return YES;
}
var _1be=this.lastPathComponent();
_1bd=_1be==="."||_1be==="..";
this._hasDirectoryPath=_1bd;
}
return _1bd;
};
CFURL.prototype.hostName=function(){
return this.authority();
};
CFURL.prototype.fragment=function(){
return ((this)._parts||_17f(this)).fragment;
};
CFURL.prototype.lastPathComponent=function(){
if(this._lastPathComponent===_2f){
var _1bf=this.pathComponents(),_1c0=_1bf.length;
if(!_1c0){
this._lastPathComponent="";
}else{
this._lastPathComponent=_1bf[_1c0-1];
}
}
return this._lastPathComponent;
};
CFURL.prototype.path=function(){
return ((this)._parts||_17f(this)).path;
};
CFURL.prototype.createCopyDeletingLastPathComponent=function(){
var _1c1=((this)._parts||_17f(this)),_1c2=_19c(_1c1.pathComponents,NO);
if(_1c2.length>0){
if(_1c2.length>1||_1c2[0]!=="/"){
_1c2.pop();
}
}
var _1c3=_1c2.length===1&&_1c2[0]==="/";
_1c1.pathComponents=_1c2;
_1c1.path=_1c3?"/":_19d(_1c2,NO);
return new CFURL(_19f(_1c1));
};
CFURL.prototype.pathComponents=function(){
return ((this)._parts||_17f(this)).pathComponents;
};
CFURL.prototype.pathExtension=function(){
var _1c4=this.lastPathComponent();
if(!_1c4){
return NULL;
}
_1c4=_1c4.replace(/^\.*/,"");
var _1c5=_1c4.lastIndexOf(".");
return _1c5<=0?"":_1c4.substring(_1c5+1);
};
CFURL.prototype.queryString=function(){
return ((this)._parts||_17f(this)).queryString;
};
CFURL.prototype.scheme=function(){
var _1c6=this._scheme;
if(_1c6===_2f){
_1c6=((this)._parts||_17f(this)).scheme;
if(!_1c6){
var _1c7=this.baseURL();
_1c6=_1c7&&_1c7.scheme();
}
this._scheme=_1c6;
}
return _1c6;
};
CFURL.prototype.user=function(){
return ((this)._parts||_17f(this)).user;
};
CFURL.prototype.password=function(){
return ((this)._parts||_17f(this)).password;
};
CFURL.prototype.portNumber=function(){
return ((this)._parts||_17f(this)).portNumber;
};
CFURL.prototype.domain=function(){
return ((this)._parts||_17f(this)).domain;
};
CFURL.prototype.baseURL=function(){
return this._baseURL;
};
CFURL.prototype.asDirectoryPathURL=function(){
if(this.hasDirectoryPath()){
return this;
}
var _1c8=this.lastPathComponent();
if(_1c8!=="/"){
_1c8="./"+_1c8;
}
return new CFURL(_1c8+"/",this);
};
function _1c9(aURL){
if(!aURL._resourcePropertiesForKeys){
aURL._resourcePropertiesForKeys=new CFMutableDictionary();
}
return aURL._resourcePropertiesForKeys;
};
CFURL.prototype.resourcePropertyForKey=function(aKey){
return _1c9(this).valueForKey(aKey);
};
CFURL.prototype.setResourcePropertyForKey=function(aKey,_1ca){
_1c9(this).setValueForKey(aKey,_1ca);
};
CFURL.prototype.staticResourceData=function(){
var data=new CFMutableData();
data.setRawString(_1cb.resourceAtURL(this).contents());
return data;
};
function _11d(_1cc){
this._string=_1cc;
var _1cd=_1cc.indexOf(";");
this._magicNumber=_1cc.substr(0,_1cd);
this._location=_1cc.indexOf(";",++_1cd);
this._version=_1cc.substring(_1cd,this._location++);
};
_11d.prototype.magicNumber=function(){
return this._magicNumber;
};
_11d.prototype.version=function(){
return this._version;
};
_11d.prototype.getMarker=function(){
var _1ce=this._string,_1cf=this._location;
if(_1cf>=_1ce.length){
return null;
}
var next=_1ce.indexOf(";",_1cf);
if(next<0){
return null;
}
var _1d0=_1ce.substring(_1cf,next);
if(_1d0==="e"){
return null;
}
this._location=next+1;
return _1d0;
};
_11d.prototype.getString=function(){
var _1d1=this._string,_1d2=this._location;
if(_1d2>=_1d1.length){
return null;
}
var next=_1d1.indexOf(";",_1d2);
if(next<0){
return null;
}
var size=parseInt(_1d1.substring(_1d2,next),10),text=_1d1.substr(next+1,size);
this._location=next+1+size;
return text;
};
var _1d3=0,_1d4=1<<0,_1d5=1<<1,_1d6=1<<2,_1d7=1<<3,_1d8=1<<4;
var _1d9={},_1da={},_1db={},_1dc=new Date().getTime(),_1dd=0,_1de=0;
CFBundle=function(aURL){
aURL=_1df(aURL).asDirectoryPathURL();
var _1e0=aURL.absoluteString(),_1e1=_1d9[_1e0];
if(_1e1){
return _1e1;
}
_1d9[_1e0]=this;
this._bundleURL=aURL;
this._resourcesDirectoryURL=new CFURL("Resources/",aURL);
this._staticResource=NULL;
this._isValid=NO;
this._loadStatus=_1d3;
this._loadRequests=[];
this._infoDictionary=new CFDictionary();
this._eventDispatcher=new _7d(this);
};
CFBundle.environments=function(){
return ["Browser","ObjJ"];
};
CFBundle.bundleContainingURL=function(aURL){
aURL=new CFURL(".",_1df(aURL));
var _1e2,_1e3=aURL.absoluteString();
while(!_1e2||_1e2!==_1e3){
var _1e4=_1d9[_1e3];
if(_1e4&&_1e4._isValid){
return _1e4;
}
aURL=new CFURL("..",aURL);
_1e2=_1e3;
_1e3=aURL.absoluteString();
}
return NULL;
};
CFBundle.mainBundle=function(){
return new CFBundle(_1e5);
};
function _1e6(_1e7,_1e8){
if(_1e8){
_1da[_1e7.name]=_1e8;
}
};
function _1e9(){
_1d9={};
_1da={};
_1db={};
_1dd=0;
_1de=0;
};
CFBundle.bundleForClass=function(_1ea){
return _1da[_1ea.name]||CFBundle.mainBundle();
};
CFBundle.bundleWithIdentifier=function(_1eb){
return _1db[_1eb]||NULL;
};
CFBundle.prototype.bundleURL=function(){
return this._bundleURL.absoluteURL();
};
CFBundle.prototype.resourcesDirectoryURL=function(){
return this._resourcesDirectoryURL;
};
CFBundle.prototype.resourceURL=function(_1ec,_1ed,_1ee){
if(_1ed){
_1ec=_1ec+"."+_1ed;
}
if(_1ee){
_1ec=_1ee+"/"+_1ec;
}
var _1ef=(new CFURL(_1ec,this.resourcesDirectoryURL())).mappedURL();
return _1ef.absoluteURL();
};
CFBundle.prototype.mostEligibleEnvironmentURL=function(){
if(this._mostEligibleEnvironmentURL===_2f){
this._mostEligibleEnvironmentURL=new CFURL(this.mostEligibleEnvironment()+".environment/",this.bundleURL());
}
return this._mostEligibleEnvironmentURL;
};
CFBundle.prototype.executableURL=function(){
if(this._executableURL===_2f){
var _1f0=this.valueForInfoDictionaryKey("CPBundleExecutable");
if(!_1f0){
this._executableURL=NULL;
}else{
this._executableURL=new CFURL(_1f0,this.mostEligibleEnvironmentURL());
}
}
return this._executableURL;
};
CFBundle.prototype.infoDictionary=function(){
return this._infoDictionary;
};
CFBundle.prototype.valueForInfoDictionaryKey=function(aKey){
return this._infoDictionary.valueForKey(aKey);
};
CFBundle.prototype.identifier=function(){
return this._infoDictionary.valueForKey("CPBundleIdentifier");
};
CFBundle.prototype.hasSpritedImages=function(){
var _1f1=this._infoDictionary.valueForKey("CPBundleEnvironmentsWithImageSprites")||[],_9d=_1f1.length,_1f2=this.mostEligibleEnvironment();
while(_9d--){
if(_1f1[_9d]===_1f2){
return YES;
}
}
return NO;
};
CFBundle.prototype.environments=function(){
return this._infoDictionary.valueForKey("CPBundleEnvironments")||["ObjJ"];
};
CFBundle.prototype.mostEligibleEnvironment=function(_1f3){
_1f3=_1f3||this.environments();
var _1f4=CFBundle.environments(),_9d=0,_1f5=_1f4.length,_1f6=_1f3.length;
for(;_9d<_1f5;++_9d){
var _1f7=0,_1f8=_1f4[_9d];
for(;_1f7<_1f6;++_1f7){
if(_1f8===_1f3[_1f7]){
return _1f8;
}
}
}
return NULL;
};
CFBundle.prototype.isLoading=function(){
return this._loadStatus&_1d4;
};
CFBundle.prototype.isLoaded=function(){
return !!(this._loadStatus&_1d8);
};
CFBundle.prototype.load=function(_1f9){
if(this._loadStatus!==_1d3){
return;
}
this._loadStatus=_1d4|_1d5;
var self=this,_1fa=this.bundleURL(),_1fb=new CFURL("..",_1fa);
if(_1fb.absoluteString()===_1fa.absoluteString()){
_1fb=_1fb.schemeAndAuthority();
}
_1cb.resolveResourceAtURL(_1fb,YES,function(_1fc){
var _1fd=_1fa.lastPathComponent();
self._staticResource=_1fc._children[_1fd]||new _1cb(_1fa,_1fc,YES,NO);
function _1fe(_1ff){
self._loadStatus&=~_1d5;
var _200=_1ff.request.responsePropertyList();
self._isValid=!!_200||CFBundle.mainBundle()===self;
if(_200){
self._infoDictionary=_200;
var _201=self._infoDictionary.valueForKey("CPBundleIdentifier");
if(_201){
_1db[_201]=self;
}
}
if(!self._infoDictionary){
_203(self,new Error("Could not load bundle at \""+path+"\""));
return;
}
if(self===CFBundle.mainBundle()&&self.valueForInfoDictionaryKey("CPApplicationSize")){
_1de=self.valueForInfoDictionaryKey("CPApplicationSize").valueForKey("executable")||0;
}
_207(self,_1f9);
};
function _202(){
self._isValid=CFBundle.mainBundle()===self;
self._loadStatus=_1d3;
_203(self,new Error("Could not load bundle at \""+self.bundleURL()+"\""));
};
new _be(new CFURL("Info.plist",self.bundleURL()),_1fe,_202);
});
};
function _203(_204,_205){
_206(_204._staticResource);
_204._eventDispatcher.dispatchEvent({type:"error",error:_205,bundle:_204});
};
function _207(_208,_209){
if(!_208.mostEligibleEnvironment()){
return _20a();
}
_20b(_208,_20c,_20a,_20d);
_20e(_208,_20c,_20a,_20d);
if(_208._loadStatus===_1d4){
return _20c();
}
function _20a(_20f){
var _210=_208._loadRequests,_211=_210.length;
while(_211--){
_210[_211].abort();
}
this._loadRequests=[];
_208._loadStatus=_1d3;
_203(_208,_20f||new Error("Could not recognize executable code format in Bundle "+_208));
};
function _20d(_212){
if((typeof CPApp==="undefined"||!CPApp||!CPApp._finishedLaunching)&&typeof OBJJ_PROGRESS_CALLBACK==="function"){
_1dd+=_212;
var _213=_1de?MAX(MIN(1,_1dd/_1de),0):0;
OBJJ_PROGRESS_CALLBACK(_213,_1de,_208.bundlePath());
}
};
function _20c(){
if(_208._loadStatus===_1d4){
_208._loadStatus=_1d8;
}else{
return;
}
_206(_208._staticResource);
function _214(){
_208._eventDispatcher.dispatchEvent({type:"load",bundle:_208});
};
if(_209){
_215(_208,_214);
}else{
_214();
}
};
};
function _20b(_216,_217,_218,_219){
var _21a=_216.executableURL();
if(!_21a){
return;
}
_216._loadStatus|=_1d6;
new _be(_21a,function(_21b){
try{
_21c(_216,_21b.request.responseText(),_21a);
_216._loadStatus&=~_1d6;
_217();
}
catch(anException){
_218(anException);
}
},_218,_219);
};
function _21d(_21e){
return "mhtml:"+new CFURL("MHTMLTest.txt",_21e.mostEligibleEnvironmentURL());
};
function _21f(_220){
if(_221===_222){
return new CFURL("dataURLs.txt",_220.mostEligibleEnvironmentURL());
}
if(_221===_223||_221===_224){
return new CFURL("MHTMLPaths.txt",_220.mostEligibleEnvironmentURL());
}
return NULL;
};
function _20e(_225,_226,_227,_228){
if(!_225.hasSpritedImages()){
return;
}
_225._loadStatus|=_1d7;
if(!_229()){
return _22a(_21d(_225),function(){
_20e(_225,_226,_227,_228);
});
}
var _22b=_21f(_225);
if(!_22b){
_225._loadStatus&=~_1d7;
return _226();
}
new _be(_22b,function(_22c){
try{
_21c(_225,_22c.request.responseText(),_22b);
_225._loadStatus&=~_1d7;
_226();
}
catch(anException){
_227(anException);
}
},_227,_228);
};
var _22d=[],_221=-1,_22e=0,_222=1,_223=2,_224=3;
function _229(){
return _221!==-1;
};
function _22a(_22f,_230){
if(_229()){
return;
}
_22d.push(_230);
if(_22d.length>1){
return;
}
_22d.push(function(){
var size=0,_231=CFBundle.mainBundle().valueForInfoDictionaryKey("CPApplicationSize");
if(!_231){
return;
}
switch(_221){
case _222:
size=_231.valueForKey("data");
break;
case _223:
case _224:
size=_231.valueForKey("mhtml");
break;
}
_1de+=size;
});
_232([_222,"data:image/gif;base64,R0lGODlhAQABAIAAAMc9BQAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==",_223,_22f+"!test",_224,_22f+"?"+_1dc+"!test"]);
};
function _233(){
var _234=_22d.length;
while(_234--){
_22d[_234]();
}
};
function _232(_235){
if(!("Image" in _1)||_235.length<2){
_221=_22e;
_233();
return;
}
var _236=new Image();
_236.onload=function(){
if(_236.width===1&&_236.height===1){
_221=_235[0];
_233();
}else{
_236.onerror();
}
};
_236.onerror=function(){
_232(_235.slice(2));
};
_236.src=_235[1];
};
function _215(_237,_238){
var _239=[_237._staticResource];
function _23a(_23b){
for(;_23b<_239.length;++_23b){
var _23c=_239[_23b];
if(_23c.isNotFound()){
continue;
}
if(_23c.isFile()){
var _23d=new _6ae(_23c.URL());
if(_23d.hasLoadedFileDependencies()){
_23d.execute();
}else{
_23d.loadFileDependencies(function(){
_23a(_23b);
});
return;
}
}else{
if(_23c.URL().absoluteString()===_237.resourcesDirectoryURL().absoluteString()){
continue;
}
var _23e=_23c.children();
for(var name in _23e){
if(_82.call(_23e,name)){
_239.push(_23e[name]);
}
}
}
}
_238();
};
_23a(0);
};
var _23f="@STATIC",_240="p",_241="u",_242="c",_243="t",_244="I",_245="i";
function _21c(_246,_247,_248){
var _249=new _11d(_247);
if(_249.magicNumber()!==_23f){
throw new Error("Could not read static file: "+_248);
}
if(_249.version()!=="1.0"){
throw new Error("Could not read static file: "+_248);
}
var _24a,_24b=_246.bundleURL(),file=NULL;
while(_24a=_249.getMarker()){
var text=_249.getString();
if(_24a===_240){
var _24c=new CFURL(text,_24b),_24d=_1cb.resourceAtURL(new CFURL(".",_24c),YES);
file=new _1cb(_24c,_24d,NO,YES);
}else{
if(_24a===_241){
var URL=new CFURL(text,_24b),_24e=_249.getString();
if(_24e.indexOf("mhtml:")===0){
_24e="mhtml:"+new CFURL(_24e.substr("mhtml:".length),_24b);
if(_221===_224){
var _24f=_24e.indexOf("!"),_250=_24e.substring(0,_24f),_251=_24e.substring(_24f);
_24e=_250+"?"+_1dc+_251;
}
}
CFURL.setMappedURLForURL(URL,new CFURL(_24e));
var _24d=_1cb.resourceAtURL(new CFURL(".",URL),YES);
new _1cb(URL,_24d,NO,YES);
}else{
if(_24a===_243){
file.write(text);
}
}
}
}
};
CFBundle.prototype.addEventListener=function(_252,_253){
this._eventDispatcher.addEventListener(_252,_253);
};
CFBundle.prototype.removeEventListener=function(_254,_255){
this._eventDispatcher.removeEventListener(_254,_255);
};
CFBundle.prototype.onerror=function(_256){
throw _256.error;
};
CFBundle.prototype.bundlePath=function(){
return this.bundleURL().path();
};
CFBundle.prototype.path=function(){
CPLog.warn("CFBundle.prototype.path is deprecated, use CFBundle.prototype.bundlePath instead.");
return this.bundlePath.apply(this,arguments);
};
CFBundle.prototype.pathForResource=function(_257){
return this.resourceURL(_257).absoluteString();
};
var _258={};
function _1cb(aURL,_259,_25a,_25b,_25c){
this._parent=_259;
this._eventDispatcher=new _7d(this);
var name=aURL.absoluteURL().lastPathComponent()||aURL.schemeAndAuthority();
this._name=name;
this._URL=aURL;
this._isResolved=!!_25b;
this._filenameTranslateDictionary=_25c;
if(_25a){
this._URL=this._URL.asDirectoryPathURL();
}
if(!_259){
_258[name]=this;
}
this._isDirectory=!!_25a;
this._isNotFound=NO;
if(_259){
_259._children[name]=this;
}
if(_25a){
this._children={};
}else{
this._contents="";
}
};
_1cb.rootResources=function(){
return _258;
};
function _25d(x){
var _25e=0;
for(var k in x){
if(x.hasOwnProperty(k)){
++_25e;
}
}
return _25e;
};
_1cb.resetRootResources=function(){
_258={};
};
_1cb.prototype.filenameTranslateDictionary=function(){
return this._filenameTranslateDictionary||{};
};
_2.StaticResource=_1cb;
function _206(_25f){
_25f._isResolved=YES;
_25f._eventDispatcher.dispatchEvent({type:"resolve",staticResource:_25f});
};
_1cb.prototype.resolve=function(){
if(this.isDirectory()){
var _260=new CFBundle(this.URL());
_260.onerror=function(){
};
_260.load(NO);
}else{
var self=this;
function _261(_262){
self._contents=_262.request.responseText();
_206(self);
};
function _263(){
self._isNotFound=YES;
_206(self);
};
var url=this.URL(),_264=this.filenameTranslateDictionary();
if(_264){
var _265=url.toString(),_266=url.lastPathComponent(),_267=_265.substring(0,_265.length-_266.length),_268=_264[_266];
if(_268&&_265.slice(-_268.length)!==_268){
url=new CFURL(_267+_268);
}
}
new _be(url,_261,_263);
}
};
_1cb.prototype.name=function(){
return this._name;
};
_1cb.prototype.URL=function(){
return this._URL;
};
_1cb.prototype.contents=function(){
return this._contents;
};
_1cb.prototype.children=function(){
return this._children;
};
_1cb.prototype.parent=function(){
return this._parent;
};
_1cb.prototype.isResolved=function(){
return this._isResolved;
};
_1cb.prototype.write=function(_269){
this._contents+=_269;
};
function _26a(_26b){
var _26c=_26b.schemeAndAuthority(),_26d=_258[_26c];
if(!_26d){
_26d=new _1cb(new CFURL(_26c),NULL,YES,YES);
}
return _26d;
};
_1cb.resourceAtURL=function(aURL,_26e){
aURL=_1df(aURL).absoluteURL();
var _26f=_26a(aURL),_270=aURL.pathComponents(),_9d=0,_271=_270.length;
for(;_9d<_271;++_9d){
var name=_270[_9d];
if(_82.call(_26f._children,name)){
_26f=_26f._children[name];
}else{
if(_26e){
if(name!=="/"){
name="./"+name;
}
_26f=new _1cb(new CFURL(name,_26f.URL()),_26f,YES,YES);
}else{
throw new Error("Static Resource at "+aURL+" is not resolved (\""+name+"\")");
}
}
}
return _26f;
};
_1cb.prototype.resourceAtURL=function(aURL,_272){
return _1cb.resourceAtURL(new CFURL(aURL,this.URL()),_272);
};
_1cb.resolveResourceAtURL=function(aURL,_273,_274,_275){
aURL=_1df(aURL).absoluteURL();
_276(_26a(aURL),_273,aURL.pathComponents(),0,_274,_275);
};
_1cb.prototype.resolveResourceAtURL=function(aURL,_277,_278){
_1cb.resolveResourceAtURL(new CFURL(aURL,this.URL()).absoluteURL(),_277,_278);
};
function _276(_279,_27a,_27b,_27c,_27d,_27e){
var _27f=_27b.length;
for(;_27c<_27f;++_27c){
var name=_27b[_27c],_280=_82.call(_279._children,name)&&_279._children[name];
if(!_280){
_280=new _1cb(new CFURL(name,_279.URL()),_279,_27c+1<_27f||_27a,NO,_27e);
_280.resolve();
}
if(!_280.isResolved()){
return _280.addEventListener("resolve",function(){
_276(_279,_27a,_27b,_27c,_27d,_27e);
});
}
if(_280.isNotFound()){
return _27d(null,new Error("File not found: "+_27b.join("/")));
}
if((_27c+1<_27f)&&_280.isFile()){
return _27d(null,new Error("File is not a directory: "+_27b.join("/")));
}
_279=_280;
}
_27d(_279);
};
function _281(aURL,_282,_283){
var _284=_1cb.includeURLs(),_285=new CFURL(aURL,_284[_282]).absoluteURL();
_1cb.resolveResourceAtURL(_285,NO,function(_286){
if(!_286){
if(_282+1<_284.length){
_281(aURL,_282+1,_283);
}else{
_283(NULL);
}
return;
}
_283(_286);
});
};
_1cb.resolveResourceAtURLSearchingIncludeURLs=function(aURL,_287){
_281(aURL,0,_287);
};
_1cb.prototype.addEventListener=function(_288,_289){
this._eventDispatcher.addEventListener(_288,_289);
};
_1cb.prototype.removeEventListener=function(_28a,_28b){
this._eventDispatcher.removeEventListener(_28a,_28b);
};
_1cb.prototype.isNotFound=function(){
return this._isNotFound;
};
_1cb.prototype.isFile=function(){
return !this._isDirectory;
};
_1cb.prototype.isDirectory=function(){
return this._isDirectory;
};
_1cb.prototype.toString=function(_28c){
if(this.isNotFound()){
return "<file not found: "+this.name()+">";
}
var _28d=this.name();
if(this.isDirectory()){
var _28e=this._children;
for(var name in _28e){
if(_28e.hasOwnProperty(name)){
var _28f=_28e[name];
if(_28c||!_28f.isNotFound()){
_28d+="\n\t"+_28e[name].toString(_28c).split("\n").join("\n\t");
}
}
}
}
return _28d;
};
var _290=NULL;
_1cb.includeURLs=function(){
if(_290!==NULL){
return _290;
}
_290=[];
if(!_1.OBJJ_INCLUDE_PATHS&&!_1.OBJJ_INCLUDE_URLS){
_290=["Frameworks","Frameworks/Debug"];
}else{
_290=(_1.OBJJ_INCLUDE_PATHS||[]).concat(_1.OBJJ_INCLUDE_URLS||[]);
}
var _291=_290.length;
while(_291--){
_290[_291]=new CFURL(_290[_291]).asDirectoryPathURL();
}
return _290;
};
var _292="accessors",_293="class",_294="end",_295="function",_296="implementation",_297="import",_298="each",_299="outlet",_29a="action",_29b="new",_29c="selector",_29d="super",_29e="var",_29f="in",_2a0="pragma",_2a1="mark",_2a2="=",_2a3="+",_2a4="-",_2a5=":",_2a6=",",_2a7=".",_2a8="*",_2a9=";",_2aa="<",_2ab="{",_2ac="}",_2ad=">",_2ae="[",_2af="\"",_2b0="@",_2b1="#",_2b2="]",_2b3="?",_2b4="(",_2b5=")",_2b6=/^(?:(?:\s+$)|(?:\/(?:\/|\*)))/,_2b7=/^[+-]?\d+(([.]\d+)*([eE][+-]?\d+))?$/,_2b8=/^[a-zA-Z_$](\w|$)*$/;
function _2b9(_2ba){
this._index=-1;
this._tokens=(_2ba+"\n").match(/\/\/.*(\r|\n)?|\/\*(?:.|\n|\r)*?\*\/|\w+\b|[+-]?\d+(([.]\d+)*([eE][+-]?\d+))?|"[^"\\]*(\\[\s\S][^"\\]*)*"|'[^'\\]*(\\[\s\S][^'\\]*)*'|\s+|./g);
this._context=[];
return this;
};
_2b9.prototype.push=function(){
this._context.push(this._index);
};
_2b9.prototype.pop=function(){
this._index=this._context.pop();
};
_2b9.prototype.peek=function(_2bb){
if(_2bb){
this.push();
var _2bc=this.skip_whitespace();
this.pop();
return _2bc;
}
return this._tokens[this._index+1];
};
_2b9.prototype.next=function(){
return this._tokens[++this._index];
};
_2b9.prototype.previous=function(){
return this._tokens[--this._index];
};
_2b9.prototype.last=function(){
if(this._index<0){
return NULL;
}
return this._tokens[this._index-1];
};
_2b9.prototype.skip_whitespace=function(_2bd){
var _2be;
if(_2bd){
while((_2be=this.previous())&&_2b6.test(_2be)){
}
}else{
while((_2be=this.next())&&_2b6.test(_2be)){
}
}
return _2be;
};
_2.Lexer=_2b9;
function _2bf(){
this.atoms=[];
};
_2bf.prototype.toString=function(){
return this.atoms.join("");
};
_2.preprocess=function(_2c0,aURL,_2c1){
return new _2c2(_2c0,aURL,_2c1).executable();
};
_2.eval=function(_2c3){
return eval(_2.preprocess(_2c3).code());
};
var _2c2=function(_2c4,aURL,_2c5){
this._URL=new CFURL(aURL);
_2c4=_2c4.replace(/^#[^\n]+\n/,"\n");
this._currentSelector="";
this._currentClass="";
this._currentSuperClass="";
this._currentSuperMetaClass="";
this._buffer=new _2bf();
this._preprocessed=NULL;
this._dependencies=[];
this._tokens=new _2b9(_2c4);
this._flags=_2c5;
this._classMethod=false;
this._executable=NULL;
this._classLookupTable={};
this._classVars={};
var _2c6=new objj_class();
for(var i in _2c6){
this._classVars[i]=1;
}
this.preprocess(this._tokens,this._buffer);
};
_2c2.prototype.setClassInfo=function(_2c7,_2c8,_2c9){
this._classLookupTable[_2c7]={superClassName:_2c8,ivars:_2c9};
};
_2c2.prototype.getClassInfo=function(_2ca){
return this._classLookupTable[_2ca];
};
_2c2.prototype.allIvarNamesForClassName=function(_2cb){
var _2cc={},_2cd=this.getClassInfo(_2cb);
while(_2cd){
for(var i in _2cd.ivars){
_2cc[i]=1;
}
_2cd=this.getClassInfo(_2cd.superClassName);
}
return _2cc;
};
_2.Preprocessor=_2c2;
_2c2.Flags={};
_2c2.Flags.IncludeDebugSymbols=1<<0;
_2c2.Flags.IncludeTypeSignatures=1<<1;
_2c2.prototype.executable=function(){
if(!this._executable){
this._executable=new _2ce(this._buffer.toString(),this._dependencies,this._URL);
}
return this._executable;
};
_2c2.prototype.accessors=function(_2cf){
var _2d0=_2cf.skip_whitespace(),_2d1={};
if(_2d0!=_2b4){
_2cf.previous();
return _2d1;
}
while((_2d0=_2cf.skip_whitespace())!=_2b5){
var name=_2d0,_2d2=true;
if(!/^\w+$/.test(name)){
throw new SyntaxError(this.error_message("*** @accessors attribute name not valid."));
}
if((_2d0=_2cf.skip_whitespace())==_2a2){
_2d2=_2cf.skip_whitespace();
if(!/^\w+$/.test(_2d2)){
throw new SyntaxError(this.error_message("*** @accessors attribute value not valid."));
}
if(name=="setter"){
if((_2d0=_2cf.next())!=_2a5){
throw new SyntaxError(this.error_message("*** @accessors setter attribute requires argument with \":\" at end of selector name."));
}
_2d2+=":";
}
_2d0=_2cf.skip_whitespace();
}
_2d1[name]=_2d2;
if(_2d0==_2b5){
break;
}
if(_2d0!=_2a6){
throw new SyntaxError(this.error_message("*** Expected ',' or ')' in @accessors attribute list."));
}
}
return _2d1;
};
_2c2.prototype.brackets=function(_2d3,_2d4){
var _2d5=[];
while(this.preprocess(_2d3,NULL,NULL,NULL,_2d5[_2d5.length]=[])){
}
if(_2d5[0].length===1){
_2d4.atoms[_2d4.atoms.length]="[";
_2d4.atoms[_2d4.atoms.length]=_2d5[0][0];
_2d4.atoms[_2d4.atoms.length]="]";
}else{
var _2d6=new _2bf();
if(_2d5[0][0].atoms[0]==_29d){
_2d4.atoms[_2d4.atoms.length]="objj_msgSendSuper(";
_2d4.atoms[_2d4.atoms.length]="{ receiver:self, super_class:"+(this._classMethod?this._currentSuperMetaClass:this._currentSuperClass)+" }";
}else{
_2d4.atoms[_2d4.atoms.length]="objj_msgSend(";
_2d4.atoms[_2d4.atoms.length]=_2d5[0][0];
}
_2d6.atoms[_2d6.atoms.length]=_2d5[0][1];
var _2d7=1,_2d8=_2d5.length,_2d9=new _2bf();
for(;_2d7<_2d8;++_2d7){
var pair=_2d5[_2d7];
_2d6.atoms[_2d6.atoms.length]=pair[1];
_2d9.atoms[_2d9.atoms.length]=", "+pair[0];
}
_2d4.atoms[_2d4.atoms.length]=", \"";
_2d4.atoms[_2d4.atoms.length]=_2d6;
_2d4.atoms[_2d4.atoms.length]="\"";
_2d4.atoms[_2d4.atoms.length]=_2d9;
_2d4.atoms[_2d4.atoms.length]=")";
}
};
_2c2.prototype.directive=function(_2da,_2db,_2dc){
var _2dd=_2db?_2db:new _2bf(),_2de=_2da.next();
if(_2de.charAt(0)==_2af){
_2dd.atoms[_2dd.atoms.length]=_2de;
}else{
if(_2de===_293){
_2da.skip_whitespace();
return;
}else{
if(_2de===_296){
this.implementation(_2da,_2dd);
}else{
if(_2de===_297){
this._import(_2da);
}else{
if(_2de===_29c){
this.selector(_2da,_2dd);
}
}
}
}
}
if(!_2db){
return _2dd;
}
};
_2c2.prototype.hash=function(_2df,_2e0){
var _2e1=_2e0?_2e0:new _2bf(),_2e2=_2df.next();
if(_2e2===_2a0){
_2e2=_2df.skip_whitespace();
if(_2e2===_2a1){
while((_2e2=_2df.next()).indexOf("\n")<0){
}
}
}else{
throw new SyntaxError(this.error_message("*** Expected \"pragma\" to follow # but instead saw \""+_2e2+"\"."));
}
};
_2c2.prototype.implementation=function(_2e3,_2e4){
var _2e5=_2e4,_2e6="",_2e7=NO,_2e8=_2e3.skip_whitespace(),_2e9="Nil",_2ea=new _2bf(),_2eb=new _2bf();
if(!(/^\w/).test(_2e8)){
throw new Error(this.error_message("*** Expected class name, found \""+_2e8+"\"."));
}
this._currentSuperClass="objj_getClass(\""+_2e8+"\").super_class";
this._currentSuperMetaClass="objj_getMetaClass(\""+_2e8+"\").super_class";
this._currentClass=_2e8;
this._currentSelector="";
if((_2e6=_2e3.skip_whitespace())==_2b4){
_2e6=_2e3.skip_whitespace();
if(_2e6==_2b5){
throw new SyntaxError(this.error_message("*** Can't Have Empty Category Name for class \""+_2e8+"\"."));
}
if(_2e3.skip_whitespace()!=_2b5){
throw new SyntaxError(this.error_message("*** Improper Category Definition for class \""+_2e8+"\"."));
}
_2e5.atoms[_2e5.atoms.length]="{\nvar the_class = objj_getClass(\""+_2e8+"\")\n";
_2e5.atoms[_2e5.atoms.length]="if(!the_class) throw new SyntaxError(\"*** Could not find definition for class \\\""+_2e8+"\\\"\");\n";
_2e5.atoms[_2e5.atoms.length]="var meta_class = the_class.isa;";
}else{
if(_2e6==_2a5){
_2e6=_2e3.skip_whitespace();
if(!_2b8.test(_2e6)){
throw new SyntaxError(this.error_message("*** Expected class name, found \""+_2e6+"\"."));
}
_2e9=_2e6;
_2e6=_2e3.skip_whitespace();
}
_2e5.atoms[_2e5.atoms.length]="{var the_class = objj_allocateClassPair("+_2e9+", \""+_2e8+"\"),\nmeta_class = the_class.isa;";
if(_2e6==_2ab){
var _2ec={},_2ed=0,_2ee=[],_2ef,_2f0={},_2f1=[];
while((_2e6=_2e3.skip_whitespace())&&_2e6!=_2ac){
if(_2e6===_2b0){
_2e6=_2e3.next();
if(_2e6===_292){
_2ef=this.accessors(_2e3);
}else{
if(_2e6!==_299){
throw new SyntaxError(this.error_message("*** Unexpected '@' token in ivar declaration ('@"+_2e6+"')."));
}else{
_2f1.push("@"+_2e6);
}
}
}else{
if(_2e6==_2a9){
if(_2ed++===0){
_2e5.atoms[_2e5.atoms.length]="class_addIvars(the_class, [";
}else{
_2e5.atoms[_2e5.atoms.length]=", ";
}
var name=_2ee[_2ee.length-1];
if(this._flags&_2c2.Flags.IncludeTypeSignatures){
_2e5.atoms[_2e5.atoms.length]="new objj_ivar(\""+name+"\", \""+_2f1.slice(0,_2f1.length-1).join(" ")+"\")";
}else{
_2e5.atoms[_2e5.atoms.length]="new objj_ivar(\""+name+"\")";
}
_2ec[name]=1;
_2ee=[];
_2f1=[];
if(_2ef){
_2f0[name]=_2ef;
_2ef=NULL;
}
}else{
_2ee.push(_2e6);
_2f1.push(_2e6);
}
}
}
if(_2ee.length){
throw new SyntaxError(this.error_message("*** Expected ';' in ivar declaration, found '}'."));
}
if(_2ed){
_2e5.atoms[_2e5.atoms.length]="]);\n";
}
if(!_2e6){
throw new SyntaxError(this.error_message("*** Expected '}'"));
}
this.setClassInfo(_2e8,_2e9==="Nil"?null:_2e9,_2ec);
var _2ec=this.allIvarNamesForClassName(_2e8);
for(ivar_name in _2f0){
var _2f2=_2f0[ivar_name],_2f3=_2f2["property"]||ivar_name;
var _2f4=_2f2["getter"]||_2f3,_2f5="(id)"+_2f4+"\n{\nreturn "+ivar_name+";\n}";
if(_2ea.atoms.length!==0){
_2ea.atoms[_2ea.atoms.length]=",\n";
}
_2ea.atoms[_2ea.atoms.length]=this.method(new _2b9(_2f5),_2ec);
if(_2f2["readonly"]){
continue;
}
var _2f6=_2f2["setter"];
if(!_2f6){
var _2f7=_2f3.charAt(0)=="_"?1:0;
_2f6=(_2f7?"_":"")+"set"+_2f3.substr(_2f7,1).toUpperCase()+_2f3.substring(_2f7+1)+":";
}
var _2f8="(void)"+_2f6+"(id)newValue\n{\n";
if(_2f2["copy"]){
_2f8+="if ("+ivar_name+" !== newValue)\n"+ivar_name+" = [newValue copy];\n}";
}else{
_2f8+=ivar_name+" = newValue;\n}";
}
if(_2ea.atoms.length!==0){
_2ea.atoms[_2ea.atoms.length]=",\n";
}
_2ea.atoms[_2ea.atoms.length]=this.method(new _2b9(_2f8),_2ec);
}
}else{
_2e3.previous();
}
_2e5.atoms[_2e5.atoms.length]="objj_registerClassPair(the_class);\n";
}
if(!_2ec){
var _2ec=this.allIvarNamesForClassName(_2e8);
}
while((_2e6=_2e3.skip_whitespace())){
if(_2e6==_2a3){
this._classMethod=true;
if(_2eb.atoms.length!==0){
_2eb.atoms[_2eb.atoms.length]=", ";
}
_2eb.atoms[_2eb.atoms.length]=this.method(_2e3,this._classVars);
}else{
if(_2e6==_2a4){
this._classMethod=false;
if(_2ea.atoms.length!==0){
_2ea.atoms[_2ea.atoms.length]=", ";
}
_2ea.atoms[_2ea.atoms.length]=this.method(_2e3,_2ec);
}else{
if(_2e6==_2b1){
this.hash(_2e3,_2e5);
}else{
if(_2e6==_2b0){
if((_2e6=_2e3.next())==_294){
break;
}else{
throw new SyntaxError(this.error_message("*** Expected \"@end\", found \"@"+_2e6+"\"."));
}
}
}
}
}
}
if(_2ea.atoms.length!==0){
_2e5.atoms[_2e5.atoms.length]="class_addMethods(the_class, [";
_2e5.atoms[_2e5.atoms.length]=_2ea;
_2e5.atoms[_2e5.atoms.length]="]);\n";
}
if(_2eb.atoms.length!==0){
_2e5.atoms[_2e5.atoms.length]="class_addMethods(meta_class, [";
_2e5.atoms[_2e5.atoms.length]=_2eb;
_2e5.atoms[_2e5.atoms.length]="]);\n";
}
_2e5.atoms[_2e5.atoms.length]="}";
this._currentClass="";
};
_2c2.prototype._import=function(_2f9){
var _2fa="",_2fb=_2f9.skip_whitespace(),_2fc=(_2fb!==_2aa);
if(_2fb===_2aa){
while((_2fb=_2f9.next())&&_2fb!==_2ad){
_2fa+=_2fb;
}
if(!_2fb){
throw new SyntaxError(this.error_message("*** Unterminated import statement."));
}
}else{
if(_2fb.charAt(0)===_2af){
_2fa=_2fb.substr(1,_2fb.length-2);
}else{
throw new SyntaxError(this.error_message("*** Expecting '<' or '\"', found \""+_2fb+"\"."));
}
}
this._buffer.atoms[this._buffer.atoms.length]="objj_executeFile(\"";
this._buffer.atoms[this._buffer.atoms.length]=_2fa;
this._buffer.atoms[this._buffer.atoms.length]=_2fc?"\", YES);":"\", NO);";
this._dependencies.push(new _2fd(new CFURL(_2fa),_2fc));
};
_2c2.prototype.method=function(_2fe,_2ff){
var _300=new _2bf(),_301,_302="",_303=[],_304=[null];
_2ff=_2ff||{};
while((_301=_2fe.skip_whitespace())&&_301!==_2ab&&_301!==_2a9){
if(_301==_2a5){
var type="";
_302+=_301;
_301=_2fe.skip_whitespace();
if(_301==_2b4){
while((_301=_2fe.skip_whitespace())&&_301!=_2b5){
type+=_301;
}
_301=_2fe.skip_whitespace();
}
_304[_303.length+1]=type||null;
_303[_303.length]=_301;
if(_301 in _2ff){
CPLog.warn(this.error_message("*** Warning: Method ( "+_302+" ) uses a parameter name that is already in use ( "+_301+" )"));
}
}else{
if(_301==_2b4){
var type="";
while((_301=_2fe.skip_whitespace())&&_301!=_2b5){
type+=_301;
}
_304[0]=type||null;
}else{
if(_301==_2a6){
if((_301=_2fe.skip_whitespace())!=_2a7||_2fe.next()!=_2a7||_2fe.next()!=_2a7){
throw new SyntaxError(this.error_message("*** Argument list expected after ','."));
}
}else{
_302+=_301;
}
}
}
}
if(_301===_2a9){
_301=_2fe.skip_whitespace();
if(_301!==_2ab){
throw new SyntaxError(this.error_message("Invalid semi-colon in method declaration. "+"Semi-colons are allowed only to terminate the method signature, before the open brace."));
}
}
var _305=0,_306=_303.length;
_300.atoms[_300.atoms.length]="new objj_method(sel_getUid(\"";
_300.atoms[_300.atoms.length]=_302;
_300.atoms[_300.atoms.length]="\"), function";
this._currentSelector=_302;
if(this._flags&_2c2.Flags.IncludeDebugSymbols){
_300.atoms[_300.atoms.length]=" $"+this._currentClass+"__"+_302.replace(/:/g,"_");
}
_300.atoms[_300.atoms.length]="(self, _cmd";
for(;_305<_306;++_305){
_300.atoms[_300.atoms.length]=", ";
_300.atoms[_300.atoms.length]=_303[_305];
}
_300.atoms[_300.atoms.length]=")\n{ with(self)\n{";
_300.atoms[_300.atoms.length]=this.preprocess(_2fe,NULL,_2ac,_2ab);
_300.atoms[_300.atoms.length]="}\n}";
if(this._flags&_2c2.Flags.IncludeDebugSymbols){
_300.atoms[_300.atoms.length]=","+JSON.stringify(_304);
}
_300.atoms[_300.atoms.length]=")";
this._currentSelector="";
return _300;
};
_2c2.prototype.preprocess=function(_307,_308,_309,_30a,_30b){
var _30c=_308?_308:new _2bf(),_30d=0,_30e="";
if(_30b){
_30b[0]=_30c;
var _30f=false,_310=[0,0,0];
}
while((_30e=_307.next())&&((_30e!==_309)||_30d)){
if(_30b){
if(_30e===_2b3){
++_310[2];
}else{
if(_30e===_2ab){
++_310[0];
}else{
if(_30e===_2ac){
--_310[0];
}else{
if(_30e===_2b4){
++_310[1];
}else{
if(_30e===_2b5){
--_310[1];
}else{
if((_30e===_2a5&&_310[2]--===0||(_30f=(_30e===_2b2)))&&_310[0]===0&&_310[1]===0){
_307.push();
var _311=_30f?_307.skip_whitespace(true):_307.previous(),_312=_2b6.test(_311);
if(_312||_2b8.test(_311)&&_2b6.test(_307.previous())){
_307.push();
var last=_307.skip_whitespace(true),_313=true,_314=false;
if(last==="+"||last==="-"){
if(_307.previous()!==last){
_313=false;
}else{
last=_307.skip_whitespace(true);
_314=true;
}
}
_307.pop();
_307.pop();
if(_313&&((!_314&&(last===_2ac))||last===_2b5||last===_2b2||last===_2a7||_2b7.test(last)||last.charAt(last.length-1)==="\""||last.charAt(last.length-1)==="'"||_2b8.test(last)&&!/^(new|return|case|var)$/.test(last))){
if(_312){
_30b[1]=":";
}else{
_30b[1]=_311;
if(!_30f){
_30b[1]+=":";
}
var _30d=_30c.atoms.length;
while(_30c.atoms[_30d--]!==_311){
}
_30c.atoms.length=_30d;
}
return !_30f;
}
if(_30f){
return NO;
}
}
_307.pop();
if(_30f){
return NO;
}
}
}
}
}
}
}
_310[2]=MAX(_310[2],0);
}
if(_30a){
if(_30e===_30a){
++_30d;
}else{
if(_30e===_309){
--_30d;
}
}
}
if(_30e===_295){
var _315="";
while((_30e=_307.next())&&_30e!==_2b4&&!(/^\w/).test(_30e)){
_315+=_30e;
}
if(_30e===_2b4){
if(_30a===_2b4){
++_30d;
}
_30c.atoms[_30c.atoms.length]="function"+_315+"(";
if(_30b){
++_310[1];
}
}else{
_30c.atoms[_30c.atoms.length]=_30e+" = function";
}
}else{
if(_30e==_2b0){
this.directive(_307,_30c);
}else{
if(_30e==_2b1){
this.hash(_307,_30c);
}else{
if(_30e==_2ae){
this.brackets(_307,_30c);
}else{
_30c.atoms[_30c.atoms.length]=_30e;
}
}
}
}
}
if(_30b){
throw new SyntaxError(this.error_message("*** Expected ']' - Unterminated message send or array."));
}
if(!_308){
return _30c;
}
};
_2c2.prototype.selector=function(_316,_317){
var _318=_317?_317:new _2bf();
_318.atoms[_318.atoms.length]="sel_getUid(\"";
if(_316.skip_whitespace()!=_2b4){
throw new SyntaxError(this.error_message("*** Expected '('"));
}
var _319=_316.skip_whitespace();
if(_319==_2b5){
throw new SyntaxError(this.error_message("*** Unexpected ')', can't have empty @selector()"));
}
_317.atoms[_317.atoms.length]=_319;
var _31a,_31b=true;
while((_31a=_316.next())&&_31a!=_2b5){
if(_31b&&/^\d+$/.test(_31a)||!(/^(\w|$|\:)/.test(_31a))){
if(!(/\S/).test(_31a)){
if(_316.skip_whitespace()==_2b5){
break;
}else{
throw new SyntaxError(this.error_message("*** Unexpected whitespace in @selector()."));
}
}else{
throw new SyntaxError(this.error_message("*** Illegal character '"+_31a+"' in @selector()."));
}
}
_318.atoms[_318.atoms.length]=_31a;
_31b=(_31a==_2a5);
}
_318.atoms[_318.atoms.length]="\")";
if(!_317){
return _318;
}
};
_2c2.prototype.error_message=function(_31c){
return _31c+" <Context File: "+this._URL+(this._currentClass?" Class: "+this._currentClass:"")+(this._currentSelector?" Method: "+this._currentSelector:"")+">";
};
if(typeof _2!="undefined"&&!_2.acorn){
_2.acorn={};
_2.acorn.walk={};
}
(function(_31d){
"use strict";
_31d.version="0.1.01";
var _31e,_31f,_320,_321;
_31d.parse=function(inpt,opts){
_31f=String(inpt);
_320=_31f.length;
_322(opts);
_323();
return _324(_31e.program);
};
var _325=_31d.defaultOptions={ecmaVersion:5,strictSemicolons:false,allowTrailingCommas:true,forbidReserved:false,trackComments:false,trackSpaces:false,locations:false,ranges:false,program:null,sourceFile:null,objj:true,preprocess:true,preprocessAddMacro:_326,preprocessGetMacro:_327,preprocessUndefineMacro:_328,preprocessIsMacro:_329};
function _322(opts){
_31e=opts||{};
for(var opt in _325){
if(!_31e.hasOwnProperty(opt)){
_31e[opt]=_325[opt];
}
}
_321=_31e.sourceFile||null;
};
var _32a;
var _32b;
function _326(_32c){
_32a[_32c.identifier]=_32c;
_32b=null;
};
function _327(_32d){
return _32a[_32d];
};
function _328(_32e){
delete _32a[_32e];
_32b=null;
};
function _329(_32f){
var x=Object.keys(_32a).join(" ");
return (_32b||(_32b=_330(x)))(_32f);
};
var _331=_31d.getLineInfo=function(_332,_333){
for(var line=1,cur=0;;){
_334.lastIndex=cur;
var _335=_334.exec(_332);
if(_335&&_335.index<_333){
++line;
cur=_335.index+_335[0].length;
}else{
break;
}
}
return {line:line,column:_333-cur,lineStart:cur,lineEnd:(_335?_335.index+_335[0].length:_332.length)};
};
_31d.tokenize=function(inpt,opts){
_31f=String(inpt);
_320=_31f.length;
_322(opts);
_323();
var t={};
function _336(_337){
_3e6(_337);
t.start=_33f;
t.end=_340;
t.startLoc=_341;
t.endLoc=_342;
t.type=_343;
t.value=_344;
return t;
};
_336.jumpTo=function(pos,_338){
_339=pos;
if(_31e.locations){
_33a=_33b=_334.lastIndex=0;
var _33c;
while((_33c=_334.exec(_31f))&&_33c.index<pos){
++_33a;
_33b=_33c.index+_33c[0].length;
}
}
var ch=_31f.charAt(pos-1);
_33d=_338;
_33e();
};
return _336;
};
var _339;
var _33f,_340;
var _341,_342;
var _343,_344;
var _345,_346,_347;
var _348,_349,_34a;
var _33d,_34b,_34c;
var _33a,_33b,_34d;
var _34e,_34f;
var _350,_351,_352;
var _353;
var _354;
var _355,_356,_357;
var _358,_359,_35a,_35b,_35c;
var _35d,_35e;
var _35f=[];
var _360=false;
function _361(pos,_362){
if(typeof pos=="number"){
pos=_331(_31f,pos);
}
var _363=new SyntaxError(_362);
_363.line=pos.line;
_363.column=pos.column;
_363.lineStart=pos.lineStart;
_363.lineEnd=pos.lineEnd;
_363.fileName=_321;
throw _363;
};
var _364={type:"num"},_365={type:"regexp"},_366={type:"string"};
var _367={type:"name"},_368={type:"eof"},_369={type:"eol"};
var _36a={keyword:"break"},_36b={keyword:"case",beforeExpr:true},_36c={keyword:"catch"};
var _36d={keyword:"continue"},_36e={keyword:"debugger"},_36f={keyword:"default"};
var _370={keyword:"do",isLoop:true},_371={keyword:"else",beforeExpr:true};
var _372={keyword:"finally"},_373={keyword:"for",isLoop:true},_374={keyword:"function"};
var _375={keyword:"if"},_376={keyword:"return",beforeExpr:true},_377={keyword:"switch"};
var _378={keyword:"throw",beforeExpr:true},_379={keyword:"try"},_37a={keyword:"var"};
var _37b={keyword:"while",isLoop:true},_37c={keyword:"with"},_37d={keyword:"new",beforeExpr:true};
var _37e={keyword:"this"};
var _37f={keyword:"void",prefix:true,beforeExpr:true};
var _380={keyword:"null",atomValue:null},_381={keyword:"true",atomValue:true};
var _382={keyword:"false",atomValue:false};
var _383={keyword:"in",binop:7,beforeExpr:true};
var _384={keyword:"implementation"},_385={keyword:"outlet"},_386={keyword:"accessors"};
var _387={keyword:"end"},_388={keyword:"import",afterImport:true};
var _389={keyword:"action"},_38a={keyword:"selector"},_38b={keyword:"class"},_38c={keyword:"global"};
var _38d={keyword:"{"},_38e={keyword:"["};
var _38f={keyword:"ref"},_390={keyword:"deref"};
var _391={keyword:"protocol"},_392={keyword:"optional"},_393={keyword:"required"};
var _394={keyword:"interface"};
var _395={keyword:"typedef"};
var _396={keyword:"filename"},_397={keyword:"unsigned",okAsIdent:true},_398={keyword:"signed",okAsIdent:true};
var _399={keyword:"byte",okAsIdent:true},_39a={keyword:"char",okAsIdent:true},_39b={keyword:"short",okAsIdent:true};
var _39c={keyword:"int",okAsIdent:true},_39d={keyword:"long",okAsIdent:true},_39e={keyword:"id",okAsIdent:true};
var _39f={keyword:"BOOL",okAsIdent:true},_3a0={keyword:"SEL",okAsIdent:true},_3a1={keyword:"float",okAsIdent:true};
var _3a2={keyword:"double",okAsIdent:true};
var _3a3={keyword:"#"};
var _3a4={keyword:"define"};
var _3a5={keyword:"undef"};
var _3a6={keyword:"ifdef"};
var _3a7={keyword:"ifndef"};
var _3a8={keyword:"if"};
var _3a9={keyword:"else"};
var _3aa={keyword:"endif"};
var _3ab={keyword:"elif"};
var _3ac={keyword:"pragma"};
var _3ad={keyword:"defined"};
var _3ae={keyword:"\\"};
var _3af={type:"preprocessParamItem"};
var _3b0={"break":_36a,"case":_36b,"catch":_36c,"continue":_36d,"debugger":_36e,"default":_36f,"do":_370,"else":_371,"finally":_372,"for":_373,"function":_374,"if":_375,"return":_376,"switch":_377,"throw":_378,"try":_379,"var":_37a,"while":_37b,"with":_37c,"null":_380,"true":_381,"false":_382,"new":_37d,"in":_383,"instanceof":{keyword:"instanceof",binop:7,beforeExpr:true},"this":_37e,"typeof":{keyword:"typeof",prefix:true,beforeExpr:true},"void":_37f,"delete":{keyword:"delete",prefix:true,beforeExpr:true}};
var _3b1={"IBAction":_389,"IBOutlet":_385,"unsigned":_397,"signed":_398,"byte":_399,"char":_39a,"short":_39b,"int":_39c,"long":_39d,"id":_39e,"float":_3a1,"BOOL":_39f,"SEL":_3a0,"double":_3a2};
var _3b2={"implementation":_384,"outlet":_385,"accessors":_386,"end":_387,"import":_388,"action":_389,"selector":_38a,"class":_38b,"global":_38c,"ref":_38f,"deref":_390,"protocol":_391,"optional":_392,"required":_393,"interface":_394,"typedef":_395};
var _3b3={"define":_3a4,"pragma":_3ac,"ifdef":_3a6,"ifndef":_3a7,"undef":_3a5,"if":_3a8,"endif":_3aa,"else":_3a9,"elif":_3ab,"defined":_3ad};
var _3b4={type:"[",beforeExpr:true},_3b5={type:"]"},_3b6={type:"{",beforeExpr:true};
var _3b7={type:"}"},_3b8={type:"(",beforeExpr:true},_3b9={type:")"};
var _3ba={type:",",beforeExpr:true},_3bb={type:";",beforeExpr:true};
var _3bc={type:":",beforeExpr:true},_3bd={type:"."},_3be={type:"?",beforeExpr:true};
var _3bf={type:"@"},_3c0={type:"..."},_3c1={type:"#"};
var _3c2={binop:10,beforeExpr:true,preprocess:true},_3c3={isAssign:true,beforeExpr:true,preprocess:true};
var _3c4={isAssign:true,beforeExpr:true},_3c5={binop:9,prefix:true,beforeExpr:true,preprocess:true};
var _3c6={postfix:true,prefix:true,isUpdate:true},_3c7={prefix:true,beforeExpr:true};
var _3c8={binop:1,beforeExpr:true,preprocess:true},_3c9={binop:2,beforeExpr:true,preprocess:true};
var _3ca={binop:3,beforeExpr:true,preprocess:true},_3cb={binop:4,beforeExpr:true,preprocess:true};
var _3cc={binop:5,beforeExpr:true,preprocess:true},_3cd={binop:6,beforeExpr:true,preprocess:true};
var _3ce={binop:7,beforeExpr:true,preprocess:true},_3cf={binop:8,beforeExpr:true,preprocess:true};
var _3d0={binop:10,beforeExpr:true,preprocess:true};
_31d.tokTypes={bracketL:_3b4,bracketR:_3b5,braceL:_3b6,braceR:_3b7,parenL:_3b8,parenR:_3b9,comma:_3ba,semi:_3bb,colon:_3bc,dot:_3bd,question:_3be,slash:_3c2,eq:_3c3,name:_367,eof:_368,num:_364,regexp:_365,string:_366};
for(var kw in _3b0){
_31d.tokTypes[kw]=_3b0[kw];
}
function _330(_3d1){
_3d1=_3d1.split(" ");
var f="",cats=[];
out:
for(var i=0;i<_3d1.length;++i){
for(var j=0;j<cats.length;++j){
if(cats[j][0].length==_3d1[i].length){
cats[j].push(_3d1[i]);
continue out;
}
}
cats.push([_3d1[i]]);
}
function _3d2(arr){
if(arr.length==1){
return f+="return str === "+JSON.stringify(arr[0])+";";
}
f+="switch(str){";
for(var i=0;i<arr.length;++i){
f+="case "+JSON.stringify(arr[i])+":";
}
f+="return true}return false;";
};
if(cats.length>3){
cats.sort(function(a,b){
return b.length-a.length;
});
f+="switch(str.length){";
for(var i=0;i<cats.length;++i){
var cat=cats[i];
f+="case "+cat[0].length+":";
_3d2(cat);
}
f+="}";
}else{
_3d2(_3d1);
}
return new Function("str",f);
};
_31d.makePredicate=_330;
var _3d3=_330("abstract boolean byte char class double enum export extends final float goto implements import int interface long native package private protected public short static super synchronized throws transient volatile");
var _3d4=_330("class enum extends super const export import");
var _3d5=_330("implements interface let package private protected public static yield");
var _3d6=_330("eval arguments");
var _3d7=_330("break case catch continue debugger default do else finally for function if return switch throw try var while with null true false instanceof typeof void delete new in this");
var _3d8=_330("IBAction IBOutlet byte char short int long float unsigned signed id BOOL SEL double");
var _3d9=_330("define pragma if ifdef ifndef else elif endif defined");
var _3da=/[\u1680\u180e\u2000-\u200a\u2028\u2029\u202f\u205f\u3000]/;
var _3db=/[\u1680\u180e\u2000-\u200a\u202f\u205f\u3000]/;
var _3dc="ªµºÀ-ÖØ-öø-ˁˆ-ˑˠ-ˤˬˮͰ-ʹͶͷͺ-ͽΆΈ-ΊΌΎ-ΡΣ-ϵϷ-ҁҊ-ԧԱ-Ֆՙա-ևא-תװ-ײؠ-يٮٯٱ-ۓەۥۦۮۯۺ-ۼۿܐܒ-ܯݍ-ޥޱߊ-ߪߴߵߺࠀ-ࠕࠚࠤࠨࡀ-ࡘࢠࢢ-ࢬऄ-हऽॐक़-ॡॱ-ॷॹ-ॿঅ-ঌএঐও-নপ-রলশ-হঽৎড়ঢ়য়-ৡৰৱਅ-ਊਏਐਓ-ਨਪ-ਰਲਲ਼ਵਸ਼ਸਹਖ਼-ੜਫ਼ੲ-ੴઅ-ઍએ-ઑઓ-નપ-રલળવ-હઽૐૠૡଅ-ଌଏଐଓ-ନପ-ରଲଳଵ-ହଽଡ଼ଢ଼ୟ-ୡୱஃஅ-ஊஎ-ஐஒ-கஙசஜஞடணதந-பம-ஹௐఅ-ఌఎ-ఐఒ-నప-ళవ-హఽౘౙౠౡಅ-ಌಎ-ಐಒ-ನಪ-ಳವ-ಹಽೞೠೡೱೲഅ-ഌഎ-ഐഒ-ഺഽൎൠൡൺ-ൿඅ-ඖක-නඳ-රලව-ෆก-ะาำเ-ๆກຂຄງຈຊຍດ-ທນ-ຟມ-ຣລວສຫອ-ະາຳຽເ-ໄໆໜ-ໟༀཀ-ཇཉ-ཬྈ-ྌက-ဪဿၐ-ၕၚ-ၝၡၥၦၮ-ၰၵ-ႁႎႠ-ჅჇჍა-ჺჼ-ቈቊ-ቍቐ-ቖቘቚ-ቝበ-ኈኊ-ኍነ-ኰኲ-ኵኸ-ኾዀዂ-ዅወ-ዖዘ-ጐጒ-ጕጘ-ፚᎀ-ᎏᎠ-Ᏼᐁ-ᙬᙯ-ᙿᚁ-ᚚᚠ-ᛪᛮ-ᛰᜀ-ᜌᜎ-ᜑᜠ-ᜱᝀ-ᝑᝠ-ᝬᝮ-ᝰក-ឳៗៜᠠ-ᡷᢀ-ᢨᢪᢰ-ᣵᤀ-ᤜᥐ-ᥭᥰ-ᥴᦀ-ᦫᧁ-ᧇᨀ-ᨖᨠ-ᩔᪧᬅ-ᬳᭅ-ᭋᮃ-ᮠᮮᮯᮺ-ᯥᰀ-ᰣᱍ-ᱏᱚ-ᱽᳩ-ᳬᳮ-ᳱᳵᳶᴀ-ᶿḀ-ἕἘ-Ἕἠ-ὅὈ-Ὅὐ-ὗὙὛὝὟ-ώᾀ-ᾴᾶ-ᾼιῂ-ῄῆ-ῌῐ-ΐῖ-Ίῠ-Ῥῲ-ῴῶ-ῼⁱⁿₐ-ₜℂℇℊ-ℓℕℙ-ℝℤΩℨK-ℭℯ-ℹℼ-ℿⅅ-ⅉⅎⅠ-ↈⰀ-Ⱞⰰ-ⱞⱠ-ⳤⳫ-ⳮⳲⳳⴀ-ⴥⴧⴭⴰ-ⵧⵯⶀ-ⶖⶠ-ⶦⶨ-ⶮⶰ-ⶶⶸ-ⶾⷀ-ⷆⷈ-ⷎⷐ-ⷖⷘ-ⷞⸯ々-〇〡-〩〱-〵〸-〼ぁ-ゖゝ-ゟァ-ヺー-ヿㄅ-ㄭㄱ-ㆎㆠ-ㆺㇰ-ㇿ㐀-䶵一-鿌ꀀ-ꒌꓐ-ꓽꔀ-ꘌꘐ-ꘟꘪꘫꙀ-ꙮꙿ-ꚗꚠ-ꛯꜗ-ꜟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꠁꠃ-ꠅꠇ-ꠊꠌ-ꠢꡀ-ꡳꢂ-ꢳꣲ-ꣷꣻꤊ-ꤥꤰ-ꥆꥠ-ꥼꦄ-ꦲꧏꨀ-ꨨꩀ-ꩂꩄ-ꩋꩠ-ꩶꩺꪀ-ꪯꪱꪵꪶꪹ-ꪽꫀꫂꫛ-ꫝꫠ-ꫪꫲ-ꫴꬁ-ꬆꬉ-ꬎꬑ-ꬖꬠ-ꬦꬨ-ꬮꯀ-ꯢ가-힣ힰ-ퟆퟋ-ퟻ豈-舘並-龎ﬀ-ﬆﬓ-ﬗיִײַ-ﬨשׁ-זּטּ-לּמּנּסּףּפּצּ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼＡ-Ｚａ-ｚｦ-ﾾￂ-ￇￊ-ￏￒ-ￗￚ-ￜ";
var _3dd="ͱ-ʹ҃-֑҇-ׇֽֿׁׂׅׄؐ-ؚؠ-ىٲ-ۓۧ-ۨۻ-ۼܰ-݊ࠀ-ࠔࠛ-ࠣࠥ-ࠧࠩ-࠭ࡀ-ࡗࣤ-ࣾऀ-ःऺ-़ा-ॏ॑-ॗॢ-ॣ०-९ঁ-ঃ়া-ৄেৈৗয়-ৠਁ-ਃ਼ਾ-ੂੇੈੋ-੍ੑ੦-ੱੵઁ-ઃ઼ા-ૅે-ૉો-્ૢ-ૣ૦-૯ଁ-ଃ଼ା-ୄେୈୋ-୍ୖୗୟ-ୠ୦-୯ஂா-ூெ-ைொ-்ௗ௦-௯ఁ-ఃె-ైొ-్ౕౖౢ-ౣ౦-౯ಂಃ಼ಾ-ೄೆ-ೈೊ-್ೕೖೢ-ೣ೦-೯ംഃെ-ൈൗൢ-ൣ൦-൯ංඃ්ා-ුූෘ-ෟෲෳิ-ฺเ-ๅ๐-๙ິ-ູ່-ໍ໐-໙༘༙༠-༩༹༵༷ཁ-ཇཱ-྄྆-྇ྍ-ྗྙ-ྼ࿆က-ဩ၀-၉ၧ-ၭၱ-ၴႂ-ႍႏ-ႝ፝-፟ᜎ-ᜐᜠ-ᜰᝀ-ᝐᝲᝳក-ឲ៝០-៩᠋-᠍᠐-᠙ᤠ-ᤫᤰ-᤻ᥑ-ᥭᦰ-ᧀᧈ-ᧉ᧐-᧙ᨀ-ᨕᨠ-ᩓ᩠-᩿᩼-᪉᪐-᪙ᭆ-ᭋ᭐-᭙᭫-᭳᮰-᮹᯦-᯳ᰀ-ᰢ᱀-᱉ᱛ-ᱽ᳐-᳒ᴀ-ᶾḁ-ἕ‌‍‿⁀⁔⃐-⃥⃜⃡-⃰ⶁ-ⶖⷠ-ⷿ〡-〨゙゚Ꙁ-ꙭꙴ-꙽ꚟ꛰-꛱ꟸ-ꠀ꠆ꠋꠣ-ꠧꢀ-ꢁꢴ-꣄꣐-꣙ꣳ-ꣷ꤀-꤉ꤦ-꤭ꤰ-ꥅꦀ-ꦃ꦳-꧀ꨀ-ꨧꩀ-ꩁꩌ-ꩍ꩐-꩙ꩻꫠ-ꫩꫲ-ꫳꯀ-ꯡ꯬꯭꯰-꯹ﬠ-ﬨ︀-️︠-︦︳︴﹍-﹏０-９＿";
var _3de=new RegExp("["+_3dc+"]");
var _3df=new RegExp("["+_3dc+_3dd+"]");
var _3e0=/[\n\r\u2028\u2029]/;
var _334=/\r\n|[\n\r\u2028\u2029]/g;
function _3e1(code){
if(code<65){
return code===36;
}
if(code<91){
return true;
}
if(code<97){
return code===95;
}
if(code<123){
return true;
}
return code>=170&&_3de.test(String.fromCharCode(code));
};
function _3e2(code){
if(code<48){
return code===36;
}
if(code<58){
return true;
}
if(code<65){
return false;
}
if(code<91){
return true;
}
if(code<97){
return code===95;
}
if(code<123){
return true;
}
return code>=170&&_3df.test(String.fromCharCode(code));
};
function _3e3(){
this.line=_33a;
this.column=_339-_33b;
};
function _323(){
_32a=Object.create(null);
_33a=1;
_339=_33b=0;
_33d=true;
_34b=null;
_34c=null;
_33e();
};
var _3e4=[_3a8,_3a6,_3a7,_3a9,_3ab,_3aa];
function _3e5(type,val){
if(type in _3e4){
return _3e6();
}
_340=_339;
if(_31e.locations){
_342=new _3e3;
}
_343=type;
_33e();
if(_31e.preprocess&&_31f.charCodeAt(_339)===35&&_31f.charCodeAt(_339+1)===35){
var val1=type===_367?val:type.keyword;
_339+=2;
if(val1){
_33e();
_3e6();
var val2=_343===_367?_344:_343.keyword;
if(val2){
var _3e7=""+val1+val2,code=_3e7.charCodeAt(0),tok;
if(_3e1(code)){
tok=_3e8(_3e7)!==false;
}
if(tok){
return tok;
}
tok=_3e9(code,_3e5);
if(tok===false){
_3ea();
}
return tok;
}else{
}
}
}
_344=val;
_347=_346;
_34a=_349;
_346=_34b;
_349=_34c;
_33d=type.beforeExpr;
_353=type.afterImport;
};
function _3eb(){
var _3ec=_31e.onComment&&_31e.locations&&new _3e3;
var _3ed=_339,end=_31f.indexOf("*/",_339+=2);
if(end===-1){
_361(_339-2,"Unterminated comment");
}
_339=end+2;
if(_31e.locations){
_334.lastIndex=_3ed;
var _3ee;
while((_3ee=_334.exec(_31f))&&_3ee.index<_339){
++_33a;
_33b=_3ee.index+_3ee[0].length;
}
}
if(_31e.onComment){
_31e.onComment(true,_31f.slice(_3ed+2,end),_3ed,_339,_3ec,_31e.locations&&new _3e3);
}
if(_31e.trackComments){
(_34b||(_34b=[])).push(_31f.slice(_3ed,end));
}
};
function _3ef(){
var _3f0=_339;
var _3f1=_31e.onComment&&_31e.locations&&new _3e3;
var ch=_31f.charCodeAt(_339+=2);
while(_339<_320&&ch!==10&&ch!==13&&ch!==8232&&ch!==8329){
++_339;
ch=_31f.charCodeAt(_339);
}
if(_31e.onComment){
_31e.onComment(false,_31f.slice(_3f0+2,_339),_3f0,_339,_3f1,_31e.locations&&new _3e3);
}
if(_31e.trackComments){
(_34b||(_34b=[])).push(_31f.slice(_3f0,_339));
}
};
function _3f2(){
var ch=_31f.charCodeAt(_339);
var last;
while(_339<_320&&((ch!==10&&ch!==13&&ch!==8232&&ch!==8329)||last===92)){
if(ch!=32&&ch!=9&&ch!=160&&(ch<5760||!_3db.test(String.fromCharCode(ch)))){
last=ch;
}
ch=_31f.charCodeAt(++_339);
}
};
function _33e(){
_34b=null;
_34c=null;
var _3f3=_339;
for(;;){
var ch=_31f.charCodeAt(_339);
if(ch===32){
++_339;
}else{
if(ch===13){
++_339;
var next=_31f.charCodeAt(_339);
if(next===10){
++_339;
}
if(_31e.locations){
++_33a;
_33b=_339;
}
}else{
if(ch===10){
++_339;
++_33a;
_33b=_339;
}else{
if(ch<14&&ch>8){
++_339;
}else{
if(ch===47){
var next=_31f.charCodeAt(_339+1);
if(next===42){
if(_31e.trackSpaces){
(_34c||(_34c=[])).push(_31f.slice(_3f3,_339));
}
_3eb();
_3f3=_339;
}else{
if(next===47){
if(_31e.trackSpaces){
(_34c||(_34c=[])).push(_31f.slice(_3f3,_339));
}
_3ef();
_3f3=_339;
}else{
break;
}
}
}else{
if(ch===160){
++_339;
}else{
if(ch>=5760&&_3da.test(String.fromCharCode(ch))){
++_339;
}else{
if(_339>=_320){
if(_31e.preprocess&&_35f.length){
var _3f4=_35f.pop();
_339=_3f4.end;
_31f=_3f4.input;
_320=_3f4.inputLen;
_351=_3f4.lastEnd;
_350=_3f4.lastStart;
}else{
break;
}
}else{
break;
}
}
}
}
}
}
}
}
}
};
function _3f5(code,_3f6){
var next=_31f.charCodeAt(_339+1);
if(next>=48&&next<=57){
return _3f7(String.fromCharCode(code),_3f6);
}
if(next===46&&_31e.objj&&_31f.charCodeAt(_339+2)===46){
_339+=3;
return _3f6(_3c0);
}
++_339;
return _3f6(_3bd);
};
function _3f8(_3f9){
var next=_31f.charCodeAt(_339+1);
if(_33d){
++_339;
return _3fa();
}
if(next===61){
return _3fb(_3c4,2,_3f9);
}
return _3fb(_3c2,1,_3f9);
};
function _3fc(_3fd){
var next=_31f.charCodeAt(_339+1);
if(next===61){
return _3fb(_3c4,2,_3fd);
}
return _3fb(_3d0,1,_3fd);
};
function _3fe(code,_3ff){
var next=_31f.charCodeAt(_339+1);
if(next===code){
return _3fb(code===124?_3c8:_3c9,2,_3ff);
}
if(next===61){
return _3fb(_3c4,2,_3ff);
}
return _3fb(code===124?_3ca:_3cc,1,_3ff);
};
function _400(_401){
var next=_31f.charCodeAt(_339+1);
if(next===61){
return _3fb(_3c4,2,_401);
}
return _3fb(_3cb,1,_401);
};
function _402(code,_403){
var next=_31f.charCodeAt(_339+1);
if(next===code){
return _3fb(_3c6,2,_403);
}
if(next===61){
return _3fb(_3c4,2,_403);
}
return _3fb(_3c5,1,_403);
};
function _404(code,_405){
if(_353&&_31e.objj&&code===60){
var str=[];
for(;;){
if(_339>=_320){
_361(_33f,"Unterminated import statement");
}
var ch=_31f.charCodeAt(++_339);
if(ch===62){
++_339;
return _405(_396,String.fromCharCode.apply(null,str));
}
str.push(ch);
}
}
var next=_31f.charCodeAt(_339+1);
var size=1;
if(next===code){
size=code===62&&_31f.charCodeAt(_339+2)===62?3:2;
if(_31f.charCodeAt(_339+size)===61){
return _3fb(_3c4,size+1,_405);
}
return _3fb(_3cf,size,_405);
}
if(next===61){
size=_31f.charCodeAt(_339+2)===61?3:2;
}
return _3fb(_3ce,size,_405);
};
function _406(code,_407){
var next=_31f.charCodeAt(_339+1);
if(next===61){
return _3fb(_3cd,_31f.charCodeAt(_339+2)===61?3:2,_407);
}
return _3fb(code===61?_3c3:_3c7,1,_407);
};
function _408(code,_409){
var next=_31f.charCodeAt(++_339);
if(next===34||next===39){
return _40a(next,_409);
}
if(next===123){
return _409(_38d);
}
if(next===91){
return _409(_38e);
}
var word=_40b(),_40c=_3b2[word];
if(!_40c){
_361(_339,"Unrecognized Objective-J keyword '@"+word+"'");
}
return _409(_40c);
};
var _40d=true;
var _40e=0;
function _40f(_410){
++_339;
_411();
switch(_359){
case _3a4:
_411();
var _412=_35c;
var _413=_414();
if(_31f.charCodeAt(_412)===40){
_415(_3b8);
var _416=[];
var _417=true;
while(!_418(_3b9)){
if(!_417){
_415(_3ba,"Expected ',' between macro parameters");
}else{
_417=false;
}
_416.push(_414());
}
}
var _419=_339=_35b;
_3f2();
var _41a=_31f.slice(_419,_339);
_41a=_41a.replace(/\\/g," ");
_31e.preprocessAddMacro(new _41b(_413,_41a,_416));
break;
case _3a5:
_411();
_31e.preprocessUndefineMacro(_414());
_3f2();
break;
case _3a8:
if(_40d){
_40e++;
_411();
var expr=_41c();
var test=_41d(expr);
if(!test){
_40d=false;
}
_41e(!test);
}else{
return _410(_3a8);
}
break;
case _3a6:
if(_40d){
_40e++;
_411();
var _41f=_414();
var test=_31e.preprocessGetMacro(_41f);
if(!test){
_40d=false;
}
_41e(!test);
}else{
return _410(_3a6);
}
break;
case _3a7:
if(_40d){
_40e++;
_411();
var _41f=_414();
var test=_31e.preprocessGetMacro(_41f);
if(test){
_40d=false;
}
_41e(test);
}else{
return _410(_3a7);
}
break;
case _3a9:
if(_40e){
if(_40d){
_40d=false;
_410(_3a9);
_411();
_41e(true,true);
}else{
return _410(_3a9);
}
}else{
_361(_35b,"#else without #if");
}
break;
case _3aa:
if(_40e){
if(_40d){
_40e--;
break;
}
}else{
_361(_35b,"#endif without #if");
}
return _410(_3aa);
break;
case _3ac:
_3f2();
break;
case _3c7:
_3f2();
break;
default:
_361(_35b,"Invalid preprocessing directive");
_3f2();
return _410(_3a3);
}
_3e5(_3a3);
return _3e6();
};
function _41d(expr){
return _31d.walk.recursive(expr,{},{BinaryExpression:function(node,st,c){
var left=node.left,_420=node.right;
switch(node.operator){
case "+":
return c(left,st)+c(_420,st);
case "-":
return c(left,st)-c(_420,st);
case "*":
return c(left,st)*c(_420,st);
case "/":
return c(left,st)/c(_420,st);
case "%":
return c(left,st)%c(_420,st);
case "<":
return c(left,st)<c(_420,st);
case ">":
return c(left,st)>c(_420,st);
case "=":
case "==":
case "===":
return c(left,st)===c(_420,st);
case "<=":
return c(left,st)<=c(_420,st);
case ">=":
return c(left,st)>=c(_420,st);
case "&&":
return c(left,st)&&c(_420,st);
case "||":
return c(left,st)||c(_420,st);
}
},Literal:function(node,st,c){
return node.value;
},Identifier:function(node,st,c){
var name=node.name,_421=_31e.preprocessGetMacro(name);
return (_421&&parseInt(_421.macro))||0;
},DefinedExpression:function(node,st,c){
return !!_31e.preprocessGetMacro(node.id.name);
}},{});
};
function _3e9(code,_422,_423){
switch(code){
case 46:
return _3f5(code,_422);
case 40:
++_339;
return _422(_3b8);
case 41:
++_339;
return _422(_3b9);
case 59:
++_339;
return _422(_3bb);
case 44:
++_339;
return _422(_3ba);
case 91:
++_339;
return _422(_3b4);
case 93:
++_339;
return _422(_3b5);
case 123:
++_339;
return _422(_3b6);
case 125:
++_339;
return _422(_3b7);
case 58:
++_339;
return _422(_3bc);
case 63:
++_339;
return _422(_3be);
case 48:
var next=_31f.charCodeAt(_339+1);
if(next===120||next===88){
return _424(_422);
}
case 49:
case 50:
case 51:
case 52:
case 53:
case 54:
case 55:
case 56:
case 57:
return _3f7(false,_422);
case 34:
case 39:
return _40a(code,_422);
case 47:
return _3f8(_422);
case 37:
case 42:
return _3fc(_422);
case 124:
case 38:
return _3fe(code,_422);
case 94:
return _400(_422);
case 43:
case 45:
return _402(code,_422);
case 60:
case 62:
return _404(code,_422,_422);
case 61:
case 33:
return _406(code,_422);
case 126:
return _3fb(_3c7,1,_422);
case 64:
if(_31e.objj){
return _408(code,_422);
}
return false;
case 35:
if(_31e.preprocess){
return _40f(_422);
}
return false;
case 92:
if(_31e.preprocess){
return _3fb(_3ae,1,_422);
}
return false;
}
if(_423&&_3e0.test(String.fromCharCode(code))){
return _3fb(_369,1,_422);
}
return false;
};
function _425(){
while(_339<_320){
var ch=_31f.charCodeAt(_339);
if(ch===32||ch===9||ch===160||(ch>=5760&&_3db.test(String.fromCharCode(ch)))){
++_339;
}else{
if(ch===92){
var pos=_339+1;
ch=_31f.charCodeAt(pos);
while(pos<_320&&(ch===32||ch===9||ch===11||ch===12||(ch>=5760&&_3db.test(String.fromCharCode(ch))))){
ch=_31f.charCodeAt(++pos);
}
_334.lastIndex=0;
var _426=_334.exec(_31f.slice(pos,pos+2));
if(_426&&_426.index===0){
_339=pos+_426[0].length;
}else{
return false;
}
}else{
_334.lastIndex=0;
var _426=_334.exec(_31f.slice(_339,_339+2));
return _426&&_426.index===0;
}
}
}
};
function _41e(test,_427){
if(test){
var _428=0;
while(_428>0||(_359!=_3aa&&(_359!=_3a9||_427))){
switch(_359){
case _3a8:
case _3a6:
case _3a7:
_428++;
break;
case _3aa:
_428--;
break;
case _368:
_40d=true;
_361(_35b,"Missing #endif");
}
_411();
}
_40d=true;
if(_359===_3aa){
_40e--;
}
}
};
function _411(){
_35b=_339;
_34f=_31f;
if(_339>=_320){
return _368;
}
var code=_31f.charCodeAt(_339);
if(_360&&code!==41&&code!==44){
var _429=0;
while(_339<_320&&(_429||(code!==41&&code!==44))){
if(code===40){
_429++;
}
if(code===41){
_429--;
}
code=_31f.charCodeAt(++_339);
}
return _42a(_3af,_31f.slice(_35b,_339));
}
if(_3e1(code)||(code===92&&_31f.charCodeAt(_339+1)===117)){
return _42b();
}
if(_3e9(code,_42a,true)===false){
var ch=String.fromCharCode(code);
if(ch==="\\"||_3de.test(ch)){
return _42b();
}
_361(_339,"Unexpected character '"+ch+"'");
}
};
function _42b(){
var word=_40b();
_42a(_3d9(word)?_3b3[word]:_367,word);
};
function _42a(type,val){
_359=type;
_35a=val;
_35c=_339;
_425();
};
function _42c(){
_35d=_33f;
_35e=_340;
return _411();
};
function _418(type){
if(_359===type){
_42c();
return true;
}
};
function _415(type,_42d){
if(_359===type){
_411();
}else{
_361(_35b,_42d||"Unexpected token");
}
};
function _414(){
var _42e=_359===_367?_35a:((!_31e.forbidReserved||_359.okAsIdent)&&_359.keyword)||_361(_35b,"Expected Macro identifier");
_42c();
return _42e;
};
function _42f(){
var node=_430();
node.name=_414();
return _431(node,"Identifier");
};
function _41c(){
return _432();
};
function _432(){
return _433(_434(),-1);
};
function _433(left,_435){
var prec=_359.binop;
if(prec){
if(!_359.preprocess){
_361(_35b,"Unsupported macro operator");
}
if(prec>_435){
var node=_436(left);
node.left=left;
node.operator=_35a;
_42c();
node.right=_433(_434(),prec);
var node=_431(node,"BinaryExpression");
return _433(node,_435);
}
}
return left;
};
function _434(){
if(_359.preprocess&&_359.prefix){
var node=_430();
node.operator=_344;
node.prefix=true;
_42c();
node.argument=_434();
return _431(node,"UnaryExpression");
}
return _437();
};
function _437(){
switch(_359){
case _367:
return _42f();
case _364:
case _366:
return _438();
case _3b8:
var _439=_35b;
_42c();
var val=_41c();
val.start=_439;
val.end=_35c;
_415(_3b9,"Expected closing ')' in macro expression");
return val;
case _3ad:
var node=_430();
_42c();
node.id=_42f();
return _431(node,"DefinedExpression");
default:
_3ea();
}
};
function _438(){
var node=_430();
node.value=_35a;
node.raw=_34f.slice(_35b,_35c);
_42c();
return _431(node,"Literal");
};
function _431(node,type){
node.type=type;
node.end=_35e;
return node;
};
function _3e6(_43a){
_33f=_339;
_34e=_31f;
if(_31e.locations){
_341=new _3e3;
}
_345=_34b;
_348=_34c;
if(_43a){
return _3fa();
}
if(_339>=_320){
return _3e5(_368);
}
var code=_31f.charCodeAt(_339);
if(_3e1(code)||code===92){
return _3e8();
}
var tok=_3e9(code,_3e5);
if(tok===false){
var ch=String.fromCharCode(code);
if(ch==="\\"||_3de.test(ch)){
return _3e8();
}
_361(_339,"Unexpected character '"+ch+"'");
}
return tok;
};
function _3fb(type,size,_43b){
var str=_31f.slice(_339,_339+size);
_339+=size;
_43b(type,str);
};
function _3fa(){
var _43c="",_43d,_43e,_43f=_339;
for(;;){
if(_339>=_320){
_361(_43f,"Unterminated regular expression");
}
var ch=_31f.charAt(_339);
if(_3e0.test(ch)){
_361(_43f,"Unterminated regular expression");
}
if(!_43d){
if(ch==="["){
_43e=true;
}else{
if(ch==="]"&&_43e){
_43e=false;
}else{
if(ch==="/"&&!_43e){
break;
}
}
}
_43d=ch==="\\";
}else{
_43d=false;
}
++_339;
}
var _43c=_31f.slice(_43f,_339);
++_339;
var mods=_40b();
if(mods&&!/^[gmsiy]*$/.test(mods)){
_361(_43f,"Invalid regexp flag");
}
return _3e5(_365,new RegExp(_43c,mods));
};
function _440(_441,len){
var _442=_339,_443=0;
for(var i=0,e=len==null?Infinity:len;i<e;++i){
var code=_31f.charCodeAt(_339),val;
if(code>=97){
val=code-97+10;
}else{
if(code>=65){
val=code-65+10;
}else{
if(code>=48&&code<=57){
val=code-48;
}else{
val=Infinity;
}
}
}
if(val>=_441){
break;
}
++_339;
_443=_443*_441+val;
}
if(_339===_442||len!=null&&_339-_442!==len){
return null;
}
return _443;
};
function _424(_444){
_339+=2;
var val=_440(16);
if(val==null){
_361(_33f+2,"Expected hexadecimal number");
}
if(_3e1(_31f.charCodeAt(_339))){
_361(_339,"Identifier directly after number");
}
return _444(_364,val);
};
function _3f7(_445,_446){
var _447=_339,_448=false,_449=_31f.charCodeAt(_339)===48;
if(!_445&&_440(10)===null){
_361(_447,"Invalid number");
}
if(_31f.charCodeAt(_339)===46){
++_339;
_440(10);
_448=true;
}
var next=_31f.charCodeAt(_339);
if(next===69||next===101){
next=_31f.charCodeAt(++_339);
if(next===43||next===45){
++_339;
}
if(_440(10)===null){
_361(_447,"Invalid number");
}
_448=true;
}
if(_3e1(_31f.charCodeAt(_339))){
_361(_339,"Identifier directly after number");
}
var str=_31f.slice(_447,_339),val;
if(_448){
val=parseFloat(str);
}else{
if(!_449||str.length===1){
val=parseInt(str,10);
}else{
if(/[89]/.test(str)||_357){
_361(_447,"Invalid number");
}else{
val=parseInt(str,8);
}
}
}
return _446(_364,val);
};
var _44a=[];
function _40a(_44b,_44c){
_339++;
_44a.length=0;
for(;;){
if(_339>=_320){
_361(_33f,"Unterminated string constant");
}
var ch=_31f.charCodeAt(_339);
if(ch===_44b){
++_339;
return _44c(_366,String.fromCharCode.apply(null,_44a));
}
if(ch===92){
ch=_31f.charCodeAt(++_339);
var _44d=/^[0-7]+/.exec(_31f.slice(_339,_339+3));
if(_44d){
_44d=_44d[0];
}
while(_44d&&parseInt(_44d,8)>255){
_44d=_44d.slice(0,_44d.length-1);
}
if(_44d==="0"){
_44d=null;
}
++_339;
if(_44d){
if(_357){
_361(_339-2,"Octal literal in strict mode");
}
_44a.push(parseInt(_44d,8));
_339+=_44d.length-1;
}else{
switch(ch){
case 110:
_44a.push(10);
break;
case 114:
_44a.push(13);
break;
case 120:
_44a.push(_44e(2));
break;
case 117:
_44a.push(_44e(4));
break;
case 85:
_44a.push(_44e(8));
break;
case 116:
_44a.push(9);
break;
case 98:
_44a.push(8);
break;
case 118:
_44a.push(11);
break;
case 102:
_44a.push(12);
break;
case 48:
_44a.push(0);
break;
case 13:
if(_31f.charCodeAt(_339)===10){
++_339;
}
case 10:
if(_31e.locations){
_33b=_339;
++_33a;
}
break;
default:
_44a.push(ch);
break;
}
}
}else{
if(ch===13||ch===10||ch===8232||ch===8329){
_361(_33f,"Unterminated string constant");
}
_44a.push(ch);
++_339;
}
}
};
function _44e(len){
var n=_440(16,len);
if(n===null){
_361(_33f,"Bad character escape sequence");
}
return n;
};
var _44f;
function _40b(){
_44f=false;
var word,_450=true,_451=_339;
for(;;){
var ch=_31f.charCodeAt(_339);
if(_3e2(ch)){
if(_44f){
word+=_31f.charAt(_339);
}
++_339;
}else{
if(ch===92){
if(!_44f){
word=_31f.slice(_451,_339);
}
_44f=true;
if(_31f.charCodeAt(++_339)!=117){
_361(_339,"Expecting Unicode escape sequence \\uXXXX");
}
++_339;
var esc=_44e(4);
var _452=String.fromCharCode(esc);
if(!_452){
_361(_339-1,"Invalid Unicode escape");
}
if(!(_450?_3e1(esc):_3e2(esc))){
_361(_339-4,"Invalid Unicode escape");
}
word+=_452;
}else{
break;
}
}
_450=false;
}
return _44f?word:_31f.slice(_451,_339);
};
function _3e8(_453){
var word=_453||_40b();
var type=_367;
var _454;
if(_31e.preprocess){
var _455;
var i=_35f.length;
if(i>0){
var _456=_35f[i-1];
if(_456.parameterDict&&_456.macro.isParameterFunction()(word)){
_455=_456.parameterDict[word];
}
}
if(!_455&&_31e.preprocessIsMacro(word)){
_455=_31e.preprocessGetMacro(word);
}
if(_455){
var _457=_33f;
var _458;
var _459=_455.parameters;
var _45a;
if(_459){
_45a=_339<_320&&_31f.charCodeAt(_339)===40;
}
if(!_459||_45a){
var _45b=_455.macro;
var _45c=_339;
if(_45a){
var _45d=true;
var _45e=0;
_458=Object.create(null);
_411();
_360=true;
_415(_3b8);
_45c=_339;
while(!_418(_3b9)){
if(!_45d){
_415(_3ba,"Expected ',' between macro parameters");
}else{
_45d=false;
}
var _45f=_459[_45e++];
var val=_35a;
_415(_3af);
_458[_45f]=new _41b(_45f,val);
_45c=_339;
}
_360=false;
}
if(_45b){
_35f.push({macro:_455,parameterDict:_458,start:_457,end:_45c,input:_31f,inputLen:_320,lastStart:_33f,lastEnd:_45c});
_31f=_45b;
_320=_45b.length;
_339=0;
}
return next();
}
}
}
if(!_44f){
if(_3d7(word)){
type=_3b0[word];
}else{
if(_31e.objj&&_3d8(word)){
type=_3b1[word];
}else{
if(_31e.forbidReserved&&(_31e.ecmaVersion===3?_3d3:_3d4)(word)||_357&&_3d5(word)){
_361(_33f,"The keyword '"+word+"' is reserved");
}
}
}
}
return _3e5(type,word);
};
function _41b(_460,_461,_462){
this.identifier=_460;
if(_461){
this.macro=_461;
}
if(_462){
this.parameters=_462;
}
};
_41b.prototype.isParameterFunction=function(){
var y=(this.parameters||[]).join(" ");
return this.isParameterFunctionVar||(this.isParameterFunctionVar=_330(y));
};
function next(){
_350=_33f;
_351=_340;
_352=_342;
_354=null;
return _3e6();
};
function _463(_464){
_357=_464;
_339=_351;
_33e();
_3e6();
};
function _465(){
this.type=null;
this.start=_33f;
this.end=null;
};
function _466(){
this.start=_341;
this.end=null;
if(_321!==null){
this.source=_321;
}
};
function _430(){
var node=new _465();
if(_31e.trackComments&&_345){
node.commentsBefore=_345;
_345=null;
}
if(_31e.trackSpaces&&_348){
node.spacesBefore=_348;
_348=null;
}
if(_31e.locations){
node.loc=new _466();
}
if(_31e.ranges){
node.range=[_33f,0];
}
return node;
};
function _436(_467){
var node=new _465();
node.start=_467.start;
if(_467.commentsBefore){
node.commentsBefore=_467.commentsBefore;
delete _467.commentsBefore;
}
if(_467.spacesBefore){
node.spacesBefore=_467.spacesBefore;
delete _467.spacesBefore;
}
if(_31e.locations){
node.loc=new _466();
node.loc.start=_467.loc.start;
}
if(_31e.ranges){
node.range=[_467.range[0],0];
}
return node;
};
var _468;
function _469(node,type){
node.type=type;
node.end=_351;
if(_31e.trackComments){
if(_347){
node.commentsAfter=_347;
_346=null;
}else{
if(_468&&_468.end===_351&&_468.commentsAfter){
node.commentsAfter=_468.commentsAfter;
delete _468.commentsAfter;
}
}
if(!_31e.trackSpaces){
_468=node;
}
}
if(_31e.trackSpaces){
if(_34a){
node.spacesAfter=_34a;
_34a=null;
}else{
if(_468&&_468.end===_351&&_468.spacesAfter){
node.spacesAfter=_468.spacesAfter;
delete _468.spacesAfter;
}
}
_468=node;
}
if(_31e.locations){
node.loc.end=_352;
}
if(_31e.ranges){
node.range[1]=_351;
}
return node;
};
function _46a(stmt){
return _31e.ecmaVersion>=5&&stmt.type==="ExpressionStatement"&&stmt.expression.type==="Literal"&&stmt.expression.value==="use strict";
};
function eat(type){
if(_343===type){
next();
return true;
}
};
function _46b(){
return !_31e.strictSemicolons&&(_343===_368||_343===_3b7||_3e0.test(_34e.slice(_351,_33f))||(_354&&_31e.objj));
};
function _46c(){
if(!eat(_3bb)&&!_46b()){
_361(_33f,"Expected a semicolon");
}
};
function _46d(type,_46e){
if(_343===type){
next();
}else{
_46e?_361(_33f,_46e):_3ea();
}
};
function _3ea(){
_361(_33f,"Unexpected token");
};
function _46f(expr){
if(expr.type!=="Identifier"&&expr.type!=="MemberExpression"&&expr.type!=="Dereference"){
_361(expr.start,"Assigning to rvalue");
}
if(_357&&expr.type==="Identifier"&&_3d6(expr.name)){
_361(expr.start,"Assigning to "+expr.name+" in strict mode");
}
};
function _324(_470){
_350=_351=_339;
if(_31e.locations){
_352=new _3e3;
}
_355=_357=null;
_356=[];
_3e6();
var node=_470||_430(),_471=true;
if(!_470){
node.body=[];
}
while(_343!==_368){
var stmt=_472();
node.body.push(stmt);
if(_471&&_46a(stmt)){
_463(true);
}
_471=false;
}
return _469(node,"Program");
};
var _473={kind:"loop"},_474={kind:"switch"};
function _472(){
if(_343===_3c2){
_3e6(true);
}
var _475=_343,node=_430();
if(_354){
node.expression=_476(_354,_354.object);
_46c();
return _469(node,"ExpressionStatement");
}
switch(_475){
case _36a:
case _36d:
next();
var _477=_475===_36a;
if(eat(_3bb)||_46b()){
node.label=null;
}else{
if(_343!==_367){
_3ea();
}else{
node.label=_478();
_46c();
}
}
for(var i=0;i<_356.length;++i){
var lab=_356[i];
if(node.label==null||lab.name===node.label.name){
if(lab.kind!=null&&(_477||lab.kind==="loop")){
break;
}
if(node.label&&_477){
break;
}
}
}
if(i===_356.length){
_361(node.start,"Unsyntactic "+_475.keyword);
}
return _469(node,_477?"BreakStatement":"ContinueStatement");
case _36e:
next();
_46c();
return _469(node,"DebuggerStatement");
case _370:
next();
_356.push(_473);
node.body=_472();
_356.pop();
_46d(_37b,"Expected 'while' at end of do statement");
node.test=_479();
_46c();
return _469(node,"DoWhileStatement");
case _373:
next();
_356.push(_473);
_46d(_3b8,"Expected '(' after 'for'");
if(_343===_3bb){
return _47a(node,null);
}
if(_343===_37a){
var init=_430();
next();
_47b(init,true);
if(init.declarations.length===1&&eat(_383)){
return _47c(node,init);
}
return _47a(node,init);
}
var init=_47d(false,true);
if(eat(_383)){
_46f(init);
return _47c(node,init);
}
return _47a(node,init);
case _374:
next();
return _47e(node,true);
case _375:
next();
node.test=_479();
node.consequent=_472();
node.alternate=eat(_371)?_472():null;
return _469(node,"IfStatement");
case _376:
if(!_355){
_361(_33f,"'return' outside of function");
}
next();
if(eat(_3bb)||_46b()){
node.argument=null;
}else{
node.argument=_47d();
_46c();
}
return _469(node,"ReturnStatement");
case _377:
next();
node.discriminant=_479();
node.cases=[];
_46d(_3b6,"Expected '{' in switch statement");
_356.push(_474);
for(var cur,_47f;_343!=_3b7;){
if(_343===_36b||_343===_36f){
var _480=_343===_36b;
if(cur){
_469(cur,"SwitchCase");
}
node.cases.push(cur=_430());
cur.consequent=[];
next();
if(_480){
cur.test=_47d();
}else{
if(_47f){
_361(_350,"Multiple default clauses");
}
_47f=true;
cur.test=null;
}
_46d(_3bc,"Expected ':' after case clause");
}else{
if(!cur){
_3ea();
}
cur.consequent.push(_472());
}
}
if(cur){
_469(cur,"SwitchCase");
}
next();
_356.pop();
return _469(node,"SwitchStatement");
case _378:
next();
if(_3e0.test(_34e.slice(_351,_33f))){
_361(_351,"Illegal newline after throw");
}
node.argument=_47d();
_46c();
return _469(node,"ThrowStatement");
case _379:
next();
node.block=_481();
node.handlers=[];
while(_343===_36c){
var _482=_430();
next();
_46d(_3b8,"Expected '(' after 'catch'");
_482.param=_478();
if(_357&&_3d6(_482.param.name)){
_361(_482.param.start,"Binding "+_482.param.name+" in strict mode");
}
_46d(_3b9,"Expected closing ')' after catch");
_482.guard=null;
_482.body=_481();
node.handlers.push(_469(_482,"CatchClause"));
}
node.finalizer=eat(_372)?_481():null;
if(!node.handlers.length&&!node.finalizer){
_361(node.start,"Missing catch or finally clause");
}
return _469(node,"TryStatement");
case _37a:
next();
node=_47b(node);
_46c();
return node;
case _37b:
next();
node.test=_479();
_356.push(_473);
node.body=_472();
_356.pop();
return _469(node,"WhileStatement");
case _37c:
if(_357){
_361(_33f,"'with' in strict mode");
}
next();
node.object=_479();
node.body=_472();
return _469(node,"WithStatement");
case _3b6:
return _481();
case _3bb:
next();
return _469(node,"EmptyStatement");
case _394:
if(_31e.objj){
next();
node.classname=_478(true);
if(eat(_3bc)){
node.superclassname=_478(true);
}else{
if(eat(_3b8)){
node.categoryname=_478(true);
_46d(_3b9,"Expected closing ')' after category name");
}
}
if(_344==="<"){
next();
var _483=[],_484=true;
node.protocols=_483;
while(_344!==">"){
if(!_484){
_46d(_3ba,"Expected ',' between protocol names");
}else{
_484=false;
}
_483.push(_478(true));
}
next();
}
if(eat(_3b6)){
node.ivardeclarations=[];
for(;;){
if(eat(_3b7)){
break;
}
_485(node);
}
node.endOfIvars=_33f;
}
node.body=[];
while(!eat(_387)){
if(_343===_368){
_361(_339,"Expected '@end' after '@interface'");
}
node.body.push(_486());
}
return _469(node,"InterfaceDeclarationStatement");
}
break;
case _384:
if(_31e.objj){
next();
node.classname=_478(true);
if(eat(_3bc)){
node.superclassname=_478(true);
}else{
if(eat(_3b8)){
node.categoryname=_478(true);
_46d(_3b9,"Expected closing ')' after category name");
}
}
if(_344==="<"){
next();
var _483=[],_484=true;
node.protocols=_483;
while(_344!==">"){
if(!_484){
_46d(_3ba,"Expected ',' between protocol names");
}else{
_484=false;
}
_483.push(_478(true));
}
next();
}
if(_344==="<"){
next();
var _483=[],_484=true;
node.protocols=_483;
while(_344!==">"){
if(!_484){
_46d(_3ba,"Expected ',' between protocol names");
}else{
_484=false;
}
_483.push(_478(true));
}
next();
}
if(eat(_3b6)){
node.ivardeclarations=[];
for(;;){
if(eat(_3b7)){
break;
}
_485(node);
}
node.endOfIvars=_33f;
}
node.body=[];
while(!eat(_387)){
if(_343===_368){
_361(_339,"Expected '@end' after '@implementation'");
}
node.body.push(_486());
}
return _469(node,"ClassDeclarationStatement");
}
break;
case _391:
if(_31e.objj&&_31f.charCodeAt(_339)!==40){
next();
node.protocolname=_478(true);
if(_344==="<"){
next();
var _483=[],_484=true;
node.protocols=_483;
while(_344!==">"){
if(!_484){
_46d(_3ba,"Expected ',' between protocol names");
}else{
_484=false;
}
_483.push(_478(true));
}
next();
}
while(!eat(_387)){
if(_343===_368){
_361(_339,"Expected '@end' after '@protocol'");
}
if(eat(_393)){
continue;
}
if(eat(_392)){
while(!eat(_393)&&_343!==_387){
(node.optional||(node.optional=[])).push(_487());
}
}else{
(node.required||(node.required=[])).push(_487());
}
}
return _469(node,"ProtocolDeclarationStatement");
}
break;
case _388:
if(_31e.objj){
next();
if(_343===_366){
node.localfilepath=true;
}else{
if(_343===_396){
node.localfilepath=false;
}else{
_3ea();
}
}
node.filename=_488();
return _469(node,"ImportStatement");
}
break;
case _3a3:
if(_31e.objj){
next();
return _469(node,"PreprocessStatement");
}
break;
case _38b:
if(_31e.objj){
next();
node.id=_478(false);
return _469(node,"ClassStatement");
}
break;
case _38c:
if(_31e.objj){
next();
node.id=_478(false);
return _469(node,"GlobalStatement");
}
break;
case _395:
if(_31e.objj){
next();
node.typedefname=_478(true);
return _469(node,"TypeDefStatement");
}
break;
}
var _489=_344,expr=_47d();
if(_475===_367&&expr.type==="Identifier"&&eat(_3bc)){
for(var i=0;i<_356.length;++i){
if(_356[i].name===_489){
_361(expr.start,"Label '"+_489+"' is already declared");
}
}
var kind=_343.isLoop?"loop":_343===_377?"switch":null;
_356.push({name:_489,kind:kind});
node.body=_472();
_356.pop();
node.label=expr;
return _469(node,"LabeledStatement");
}else{
node.expression=expr;
_46c();
return _469(node,"ExpressionStatement");
}
};
function _485(node){
var _48a;
if(eat(_385)){
_48a=true;
}
var type=_48b();
if(_357&&_3d6(type.name)){
_361(type.start,"Binding "+type.name+" in strict mode");
}
for(;;){
var decl=_430();
if(_48a){
decl.outlet=_48a;
}
decl.ivartype=type;
decl.id=_478();
if(_357&&_3d6(decl.id.name)){
_361(decl.id.start,"Binding "+decl.id.name+" in strict mode");
}
if(eat(_386)){
decl.accessors={};
if(eat(_3b8)){
if(!eat(_3b9)){
for(;;){
var _48c=_478(true);
switch(_48c.name){
case "property":
case "getter":
_46d(_3c3,"Expected '=' after 'getter' accessor attribute");
decl.accessors[_48c.name]=_478(true);
break;
case "setter":
_46d(_3c3,"Expected '=' after 'setter' accessor attribute");
var _48d=_478(true);
decl.accessors[_48c.name]=_48d;
if(eat(_3bc)){
_48d.end=_33f;
}
_48d.name+=":";
break;
case "readwrite":
case "readonly":
case "copy":
decl.accessors[_48c.name]=true;
break;
default:
_361(_48c.start,"Unknown accessors attribute '"+_48c.name+"'");
}
if(!eat(_3ba)){
break;
}
}
_46d(_3b9,"Expected closing ')' after accessor attributes");
}
}
}
_469(decl,"IvarDeclaration");
node.ivardeclarations.push(decl);
if(!eat(_3ba)){
break;
}
}
_46c();
};
function _48e(node){
node.methodtype=_344;
_46d(_3c5,"Method declaration must start with '+' or '-'");
if(eat(_3b8)){
var _48f=_430();
if(eat(_389)){
node.action=_469(_48f,"ObjectiveJActionType");
_48f=_430();
}
if(!eat(_3b9)){
node.returntype=_48b(_48f);
_46d(_3b9,"Expected closing ')' after method return type");
}
}
var _490=true,_491=[],args=[];
node.selectors=_491;
node.arguments=args;
for(;;){
if(_343!==_3bc){
_491.push(_478(true));
if(_490&&_343!==_3bc){
break;
}
}else{
_491.push(null);
}
_46d(_3bc,"Expected ':' in selector");
var _492={};
args.push(_492);
if(eat(_3b8)){
_492.type=_48b();
_46d(_3b9,"Expected closing ')' after method argument type");
}
_492.identifier=_478(false);
if(_343===_3b6||_343===_3bb){
break;
}
if(eat(_3ba)){
_46d(_3c0,"Expected '...' after ',' in method declaration");
node.parameters=true;
break;
}
_490=false;
}
};
function _486(){
var _493=_430();
if(_344==="+"||_344==="-"){
_48e(_493);
eat(_3bb);
_493.startOfBody=_351;
var _494=_355,_495=_356;
_355=true;
_356=[];
_493.body=_481(true);
_355=_494;
_356=_495;
return _469(_493,"MethodDeclarationStatement");
}else{
return _472();
}
};
function _487(){
var _496=_430();
_48e(_496);
_46c();
return _469(_496,"MethodDeclarationStatement");
};
function _479(){
_46d(_3b8,"Expected '(' before expression");
var val=_47d();
_46d(_3b9,"Expected closing ')' after expression");
return val;
};
function _481(_497){
var node=_430(),_498=true,_357=false,_499;
node.body=[];
_46d(_3b6,"Expected '{' before block");
while(!eat(_3b7)){
var stmt=_472();
node.body.push(stmt);
if(_498&&_46a(stmt)){
_499=_357;
_463(_357=true);
}
_498=false;
}
if(_357&&!_499){
_463(false);
}
return _469(node,"BlockStatement");
};
function _47a(node,init){
node.init=init;
_46d(_3bb,"Expected ';' in for statement");
node.test=_343===_3bb?null:_47d();
_46d(_3bb,"Expected ';' in for statement");
node.update=_343===_3b9?null:_47d();
_46d(_3b9,"Expected closing ')' in for statement");
node.body=_472();
_356.pop();
return _469(node,"ForStatement");
};
function _47c(node,init){
node.left=init;
node.right=_47d();
_46d(_3b9,"Expected closing ')' in for statement");
node.body=_472();
_356.pop();
return _469(node,"ForInStatement");
};
function _47b(node,noIn){
node.declarations=[];
node.kind="var";
for(;;){
var decl=_430();
decl.id=_478();
if(_357&&_3d6(decl.id.name)){
_361(decl.id.start,"Binding "+decl.id.name+" in strict mode");
}
decl.init=eat(_3c3)?_47d(true,noIn):null;
node.declarations.push(_469(decl,"VariableDeclarator"));
if(!eat(_3ba)){
break;
}
}
return _469(node,"VariableDeclaration");
};
function _47d(_49a,noIn){
var expr=_49b(noIn);
if(!_49a&&_343===_3ba){
var node=_436(expr);
node.expressions=[expr];
while(eat(_3ba)){
node.expressions.push(_49b(noIn));
}
return _469(node,"SequenceExpression");
}
return expr;
};
function _49b(noIn){
var left=_49c(noIn);
if(_343.isAssign){
var node=_436(left);
node.operator=_344;
node.left=left;
next();
node.right=_49b(noIn);
_46f(left);
return _469(node,"AssignmentExpression");
}
return left;
};
function _49c(noIn){
var expr=_49d(noIn);
if(eat(_3be)){
var node=_436(expr);
node.test=expr;
node.consequent=_47d(true);
_46d(_3bc,"Expected ':' in conditional expression");
node.alternate=_47d(true,noIn);
return _469(node,"ConditionalExpression");
}
return expr;
};
function _49d(noIn){
return _49e(_49f(noIn),-1,noIn);
};
function _49e(left,_4a0,noIn){
var prec=_343.binop;
if(prec!=null&&(!noIn||_343!==_383)){
if(prec>_4a0){
var node=_436(left);
node.left=left;
node.operator=_344;
next();
node.right=_49e(_49f(noIn),prec,noIn);
var node=_469(node,/&&|\|\|/.test(node.operator)?"LogicalExpression":"BinaryExpression");
return _49e(node,_4a0,noIn);
}
}
return left;
};
function _49f(noIn){
if(_343.prefix){
var node=_430(),_4a1=_343.isUpdate;
node.operator=_344;
node.prefix=true;
next();
node.argument=_49f(noIn);
if(_4a1){
_46f(node.argument);
}else{
if(_357&&node.operator==="delete"&&node.argument.type==="Identifier"){
_361(node.start,"Deleting local variable in strict mode");
}
}
return _469(node,_4a1?"UpdateExpression":"UnaryExpression");
}
var expr=_4a2();
while(_343.postfix&&!_46b()){
var node=_436(expr);
node.operator=_344;
node.prefix=false;
node.argument=expr;
_46f(expr);
next();
expr=_469(node,"UpdateExpression");
}
return expr;
};
function _4a2(){
return _4a3(_4a4());
};
function _4a3(base,_4a5){
if(eat(_3bd)){
var node=_436(base);
node.object=base;
node.property=_478(true);
node.computed=false;
return _4a3(_469(node,"MemberExpression"),_4a5);
}else{
if(_31e.objj){
var _4a6=_430();
}
if(eat(_3b4)){
var expr=_47d();
if(_31e.objj&&_343!==_3b5){
_4a6.object=expr;
_354=_4a6;
return base;
}
var node=_436(base);
node.object=base;
node.property=expr;
node.computed=true;
_46d(_3b5,"Expected closing ']' in subscript");
return _4a3(_469(node,"MemberExpression"),_4a5);
}else{
if(!_4a5&&eat(_3b8)){
var node=_436(base);
node.callee=base;
node.arguments=_4a7(_3b9,_343===_3b9?null:_47d(true),false);
return _4a3(_469(node,"CallExpression"),_4a5);
}
}
}
return base;
};
function _4a4(){
switch(_343){
case _37e:
var node=_430();
next();
return _469(node,"ThisExpression");
case _367:
return _478();
case _364:
case _366:
case _365:
return _488();
case _380:
case _381:
case _382:
var node=_430();
node.value=_343.atomValue;
node.raw=_343.keyword;
next();
return _469(node,"Literal");
case _3b8:
var _4a8=_341,_4a9=_33f;
next();
var val=_47d();
val.start=_4a9;
val.end=_340;
if(_31e.locations){
val.loc.start=_4a8;
val.loc.end=_342;
}
if(_31e.ranges){
val.range=[_4a9,_340];
}
_46d(_3b9,"Expected closing ')' in expression");
return val;
case _38e:
var node=_430(),_4aa=null;
next();
_46d(_3b4,"Expected '[' at beginning of array literal");
if(_343!==_3b5){
_4aa=_47d(true,true);
}
node.elements=_4a7(_3b5,_4aa,true,true);
return _469(node,"ArrayLiteral");
case _3b4:
var node=_430(),_4aa=null;
next();
if(_343!==_3ba&&_343!==_3b5){
_4aa=_47d(true,true);
if(_343!==_3ba&&_343!==_3b5){
return _476(node,_4aa);
}
}
node.elements=_4a7(_3b5,_4aa,true,true);
return _469(node,"ArrayExpression");
case _38d:
var node=_430();
next();
var r=_4ab();
node.keys=r[0];
node.values=r[1];
return _469(node,"DictionaryLiteral");
case _3b6:
return _4ac();
case _374:
var node=_430();
next();
return _47e(node,false);
case _37d:
return _4ad();
case _38a:
var node=_430();
next();
_46d(_3b8,"Expected '(' after '@selector'");
_4ae(node,_3b9);
_46d(_3b9,"Expected closing ')' after selector");
return _469(node,"SelectorLiteralExpression");
case _391:
var node=_430();
next();
_46d(_3b8,"Expected '(' after '@protocol'");
node.id=_478(true);
_46d(_3b9,"Expected closing ')' after protocol name");
return _469(node,"ProtocolLiteralExpression");
case _38f:
var node=_430();
next();
_46d(_3b8,"Expected '(' after '@ref'");
node.element=_478(node,_3b9);
_46d(_3b9,"Expected closing ')' after ref");
return _469(node,"Reference");
case _390:
var node=_430();
next();
_46d(_3b8,"Expected '(' after '@deref'");
node.expr=_47d(true,true);
_46d(_3b9,"Expected closing ')' after deref");
return _469(node,"Dereference");
default:
if(_343.okAsIdent){
return _478();
}
_3ea();
}
};
function _476(node,_4af){
_4b0(node,_3b5);
if(_4af.type==="Identifier"&&_4af.name==="super"){
node.superObject=true;
}else{
node.object=_4af;
}
return _469(node,"MessageSendExpression");
};
function _4ae(node,_4b1){
var _4b2=true,_4b3=[];
for(;;){
if(_343!==_3bc){
_4b3.push(_478(true).name);
if(_4b2&&_343===_4b1){
break;
}
}
_46d(_3bc,"Expected ':' in selector");
_4b3.push(":");
if(_343===_4b1){
break;
}
_4b2=false;
}
node.selector=_4b3.join("");
};
function _4b0(node,_4b4){
var _4b5=true,_4b6=[],args=[],_4b7=[];
node.selectors=_4b6;
node.arguments=args;
for(;;){
if(_343!==_3bc){
_4b6.push(_478(true));
if(_4b5&&eat(_4b4)){
break;
}
}else{
_4b6.push(null);
}
_46d(_3bc,"Expected ':' in selector");
args.push(_47d(true,true));
if(eat(_4b4)){
break;
}
if(_343===_3ba){
node.parameters=[];
while(eat(_3ba)){
node.parameters.push(_47d(true,true));
}
eat(_4b4);
break;
}
_4b5=false;
}
};
function _4ad(){
var node=_430();
next();
node.callee=_4a3(_4a4(false),true);
if(eat(_3b8)){
node.arguments=_4a7(_3b9,_343===_3b9?null:_47d(true),false);
}else{
node.arguments=[];
}
return _469(node,"NewExpression");
};
function _4ac(){
var node=_430(),_4b8=true,_4b9=false;
node.properties=[];
next();
while(!eat(_3b7)){
if(!_4b8){
_46d(_3ba,"Expected ',' in object literal");
if(_31e.allowTrailingCommas&&eat(_3b7)){
break;
}
}else{
_4b8=false;
}
var prop={key:_4ba()},_4bb=false,kind;
if(eat(_3bc)){
prop.value=_47d(true);
kind=prop.kind="init";
}else{
if(_31e.ecmaVersion>=5&&prop.key.type==="Identifier"&&(prop.key.name==="get"||prop.key.name==="set")){
_4bb=_4b9=true;
kind=prop.kind=prop.key.name;
prop.key=_4ba();
if(_343!==_3b8){
_3ea();
}
prop.value=_47e(_430(),false);
}else{
_3ea();
}
}
if(prop.key.type==="Identifier"&&(_357||_4b9)){
for(var i=0;i<node.properties.length;++i){
var _4bc=node.properties[i];
if(_4bc.key.name===prop.key.name){
var _4bd=kind==_4bc.kind||_4bb&&_4bc.kind==="init"||kind==="init"&&(_4bc.kind==="get"||_4bc.kind==="set");
if(_4bd&&!_357&&kind==="init"&&_4bc.kind==="init"){
_4bd=false;
}
if(_4bd){
_361(prop.key.start,"Redefinition of property");
}
}
}
}
node.properties.push(prop);
}
return _469(node,"ObjectExpression");
};
function _4ba(){
if(_343===_364||_343===_366){
return _4a4();
}
return _478(true);
};
function _47e(node,_4be){
if(_343===_367){
node.id=_478();
}else{
if(_4be){
_3ea();
}else{
node.id=null;
}
}
node.params=[];
var _4bf=true;
_46d(_3b8,"Expected '(' before function parameters");
while(!eat(_3b9)){
if(!_4bf){
_46d(_3ba,"Expected ',' between function parameters");
}else{
_4bf=false;
}
node.params.push(_478());
}
var _4c0=_355,_4c1=_356;
_355=true;
_356=[];
node.body=_481(true);
_355=_4c0;
_356=_4c1;
if(_357||node.body.body.length&&_46a(node.body.body[0])){
for(var i=node.id?-1:0;i<node.params.length;++i){
var id=i<0?node.id:node.params[i];
if(_3d5(id.name)||_3d6(id.name)){
_361(id.start,"Defining '"+id.name+"' in strict mode");
}
if(i>=0){
for(var j=0;j<i;++j){
if(id.name===node.params[j].name){
_361(id.start,"Argument name clash in strict mode");
}
}
}
}
}
return _469(node,_4be?"FunctionDeclaration":"FunctionExpression");
};
function _4a7(_4c2,_4c3,_4c4,_4c5){
if(_4c3&&eat(_4c2)){
return [_4c3];
}
var elts=[],_4c6=true;
while(!eat(_4c2)){
if(_4c6){
_4c6=false;
if(_4c5&&_343===_3ba&&!_4c3){
elts.push(null);
}else{
elts.push(_4c3);
}
}else{
_46d(_3ba,"Expected ',' between expressions");
if(_4c4&&_31e.allowTrailingCommas&&eat(_4c2)){
break;
}
if(_4c5&&_343===_3ba){
elts.push(null);
}else{
elts.push(_47d(true));
}
}
}
return elts;
};
function _4ab(){
_46d(_3b6,"Expected '{' before dictionary");
var keys=[],_4c7=[],_4c8=true;
while(!eat(_3b7)){
if(!_4c8){
_46d(_3ba,"Expected ',' between expressions");
if(_31e.allowTrailingCommas&&eat(_3b7)){
break;
}
}
keys.push(_47d(true,true));
_46d(_3bc,"Expected ':' between dictionary key and value");
_4c7.push(_47d(true,true));
_4c8=false;
}
return [keys,_4c7];
};
function _478(_4c9){
var node=_430();
node.name=_343===_367?_344:(((_4c9&&!_31e.forbidReserved)||_343.okAsIdent)&&_343.keyword)||_3ea();
next();
return _469(node,"Identifier");
};
function _488(){
var node=_430();
node.value=_344;
node.raw=_34e.slice(_33f,_340);
next();
return _469(node,"Literal");
};
function _48b(_4ca){
var node=_4ca?_436(_4ca):_430();
if(_343===_367){
node.name=_344;
node.typeisclass=true;
next();
}else{
node.typeisclass=false;
node.name=_343.keyword;
if(!eat(_37f)){
if(eat(_39e)){
if(_344==="<"){
var _4cb=true,_4cc=[];
node.protocols=_4cc;
do{
next();
if(_4cb){
_4cb=false;
}else{
eat(_3ba);
}
_4cc.push(_478(true));
}while(_344!==">");
next();
}
}else{
var _4cd;
if(eat(_3a1)||eat(_39f)||eat(_3a0)||eat(_3a2)){
_4cd=_343.keyword;
}else{
if(eat(_398)||eat(_397)){
_4cd=_343.keyword||true;
}
if(eat(_39a)||eat(_399)||eat(_39b)){
if(_4cd){
node.name+=" "+_4cd;
}
_4cd=_343.keyword||true;
}else{
if(eat(_39c)){
if(_4cd){
node.name+=" "+_4cd;
}
_4cd=_343.keyword||true;
}
if(eat(_39d)){
if(_4cd){
node.name+=" "+_4cd;
}
_4cd=_343.keyword||true;
if(eat(_39d)){
node.name+=" "+_4cd;
}
}
}
if(!_4cd){
node.name=(!_31e.forbidReserved&&_343.keyword)||_3ea();
node.typeisclass=true;
next();
}
}
}
}
}
return _469(node,"ObjectiveJType");
};
})(typeof _2==="undefined"?(self.acorn={}):_2.acorn);
if(!_2.acorn){
_2.acorn={};
_2.acorn.walk={};
}
(function(_4ce){
"use strict";
_4ce.simple=function(node,_4cf,base,_4d0){
if(!base){
base=_4ce;
}
function c(node,st,_4d1){
var type=_4d1||node.type,_4d2=_4cf[type];
if(_4d2){
_4d2(node,st);
}
base[type](node,st,c);
};
c(node,_4d0);
};
_4ce.recursive=function(node,_4d3,_4d4,base){
var _4d5=_4ce.make(_4d4,base);
function c(node,st,_4d6){
return _4d5[_4d6||node.type](node,st,c);
};
return c(node,_4d3);
};
_4ce.make=function(_4d7,base){
if(!base){
base=_4ce;
}
var _4d8={};
for(var type in base){
_4d8[type]=base[type];
}
for(var type in _4d7){
_4d8[type]=_4d7[type];
}
return _4d8;
};
function _4d9(node,st,c){
c(node,st);
};
function _4da(node,st,c){
};
_4ce.Program=_4ce.BlockStatement=function(node,st,c){
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
};
_4ce.Statement=_4d9;
_4ce.EmptyStatement=_4da;
_4ce.ExpressionStatement=function(node,st,c){
c(node.expression,st,"Expression");
};
_4ce.IfStatement=function(node,st,c){
c(node.test,st,"Expression");
c(node.consequent,st,"Statement");
if(node.alternate){
c(node.alternate,st,"Statement");
}
};
_4ce.LabeledStatement=function(node,st,c){
c(node.body,st,"Statement");
};
_4ce.BreakStatement=_4ce.ContinueStatement=_4da;
_4ce.WithStatement=function(node,st,c){
c(node.object,st,"Expression");
c(node.body,st,"Statement");
};
_4ce.SwitchStatement=function(node,st,c){
c(node.discriminant,st,"Expression");
for(var i=0;i<node.cases.length;++i){
var cs=node.cases[i];
if(cs.test){
c(cs.test,st,"Expression");
}
for(var j=0;j<cs.consequent.length;++j){
c(cs.consequent[j],st,"Statement");
}
}
};
_4ce.ReturnStatement=function(node,st,c){
if(node.argument){
c(node.argument,st,"Expression");
}
};
_4ce.ThrowStatement=function(node,st,c){
c(node.argument,st,"Expression");
};
_4ce.TryStatement=function(node,st,c){
c(node.block,st,"Statement");
for(var i=0;i<node.handlers.length;++i){
c(node.handlers[i].body,st,"ScopeBody");
}
if(node.finalizer){
c(node.finalizer,st,"Statement");
}
};
_4ce.WhileStatement=function(node,st,c){
c(node.test,st,"Expression");
c(node.body,st,"Statement");
};
_4ce.DoWhileStatement=function(node,st,c){
c(node.body,st,"Statement");
c(node.test,st,"Expression");
};
_4ce.ForStatement=function(node,st,c){
if(node.init){
c(node.init,st,"ForInit");
}
if(node.test){
c(node.test,st,"Expression");
}
if(node.update){
c(node.update,st,"Expression");
}
c(node.body,st,"Statement");
};
_4ce.ForInStatement=function(node,st,c){
c(node.left,st,"ForInit");
c(node.right,st,"Expression");
c(node.body,st,"Statement");
};
_4ce.ForInit=function(node,st,c){
if(node.type=="VariableDeclaration"){
c(node,st);
}else{
c(node,st,"Expression");
}
};
_4ce.DebuggerStatement=_4da;
_4ce.FunctionDeclaration=function(node,st,c){
c(node,st,"Function");
};
_4ce.VariableDeclaration=function(node,st,c){
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i];
if(decl.init){
c(decl.init,st,"Expression");
}
}
};
_4ce.Function=function(node,st,c){
c(node.body,st,"ScopeBody");
};
_4ce.ScopeBody=function(node,st,c){
c(node,st,"Statement");
};
_4ce.Expression=_4d9;
_4ce.ThisExpression=_4da;
_4ce.ArrayExpression=_4ce.ArrayLiteral=function(node,st,c){
for(var i=0;i<node.elements.length;++i){
var elt=node.elements[i];
if(elt){
c(elt,st,"Expression");
}
}
};
_4ce.DictionaryLiteral=function(node,st,c){
for(var i=0;i<node.keys.length;i++){
var key=node.keys[i];
c(key,st,"Expression");
var _4db=node.values[i];
c(_4db,st,"Expression");
}
};
_4ce.ObjectExpression=function(node,st,c){
for(var i=0;i<node.properties.length;++i){
c(node.properties[i].value,st,"Expression");
}
};
_4ce.FunctionExpression=_4ce.FunctionDeclaration;
_4ce.SequenceExpression=function(node,st,c){
for(var i=0;i<node.expressions.length;++i){
c(node.expressions[i],st,"Expression");
}
};
_4ce.UnaryExpression=_4ce.UpdateExpression=function(node,st,c){
c(node.argument,st,"Expression");
};
_4ce.BinaryExpression=_4ce.AssignmentExpression=_4ce.LogicalExpression=function(node,st,c){
c(node.left,st,"Expression");
c(node.right,st,"Expression");
};
_4ce.ConditionalExpression=function(node,st,c){
c(node.test,st,"Expression");
c(node.consequent,st,"Expression");
c(node.alternate,st,"Expression");
};
_4ce.NewExpression=_4ce.CallExpression=function(node,st,c){
c(node.callee,st,"Expression");
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
c(node.arguments[i],st,"Expression");
}
}
};
_4ce.MemberExpression=function(node,st,c){
c(node.object,st,"Expression");
if(node.computed){
c(node.property,st,"Expression");
}
};
_4ce.Identifier=_4ce.Literal=_4da;
_4ce.ClassDeclarationStatement=function(node,st,c){
if(node.ivardeclarations){
for(var i=0;i<node.ivardeclarations.length;++i){
c(node.ivardeclarations[i],st,"IvarDeclaration");
}
}
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
};
_4ce.ImportStatement=_4da;
_4ce.IvarDeclaration=_4da;
_4ce.PreprocessStatement=_4da;
_4ce.ClassStatement=_4da;
_4ce.GlobalStatement=_4da;
_4ce.ProtocolDeclarationStatement=function(node,st,c){
if(node.required){
for(var i=0;i<node.required.length;++i){
c(node.required[i],st,"Statement");
}
}
if(node.optional){
for(var i=0;i<node.optional.length;++i){
c(node.optional[i],st,"Statement");
}
}
};
_4ce.TypeDefStatement=_4da;
_4ce.MethodDeclarationStatement=function(node,st,c){
var body=node.body;
if(body){
c(body,st,"Statement");
}
};
_4ce.MessageSendExpression=function(node,st,c){
if(!node.superObject){
c(node.object,st,"Expression");
}
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
c(node.arguments[i],st,"Expression");
}
}
if(node.parameters){
for(var i=0;i<node.parameters.length;++i){
c(node.parameters[i],st,"Expression");
}
}
};
_4ce.SelectorLiteralExpression=_4da;
_4ce.ProtocolLiteralExpression=_4da;
_4ce.Reference=function(node,st,c){
c(node.element,st,"Identifier");
};
_4ce.Dereference=function(node,st,c){
c(node.expr,st,"Expression");
};
function _4dc(prev){
return {vars:Object.create(null),prev:prev};
};
_4ce.scopeVisitor=_4ce.make({Function:function(node,_4dd,c){
var _4de=_4dc(_4dd);
for(var i=0;i<node.params.length;++i){
_4de.vars[node.params[i].name]={type:"argument",node:node.params[i]};
}
if(node.id){
var decl=node.type=="FunctionDeclaration";
(decl?_4dd:_4de).vars[node.id.name]={type:decl?"function":"function name",node:node.id};
}
c(node.body,_4de,"ScopeBody");
},TryStatement:function(node,_4df,c){
c(node.block,_4df,"Statement");
for(var i=0;i<node.handlers.length;++i){
var _4e0=node.handlers[i],_4e1=_4dc(_4df);
_4e1.vars[_4e0.param.name]={type:"catch clause",node:_4e0.param};
c(_4e0.body,_4e1,"ScopeBody");
}
if(node.finalizer){
c(node.finalizer,_4df,"Statement");
}
},VariableDeclaration:function(node,_4e2,c){
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i];
_4e2.vars[decl.id.name]={type:"var",node:decl.id};
if(decl.init){
c(decl.init,_4e2,"Expression");
}
}
}});
})(typeof _2=="undefined"?acorn.walk={}:_2.acorn.walk);
var _4e3=function(prev,base){
this.vars=Object.create(null);
if(base){
for(var key in base){
this[key]=base[key];
}
}
this.prev=prev;
if(prev){
this.compiler=prev.compiler;
}
};
_4e3.prototype.compiler=function(){
return this.compiler;
};
_4e3.prototype.rootScope=function(){
return this.prev?this.prev.rootScope():this;
};
_4e3.prototype.isRootScope=function(){
return !this.prev;
};
_4e3.prototype.currentClassName=function(){
return this.classDef?this.classDef.name:this.prev?this.prev.currentClassName():null;
};
_4e3.prototype.currentProtocolName=function(){
return this.protocolDef?this.protocolDef.name:this.prev?this.prev.currentProtocolName():null;
};
_4e3.prototype.getIvarForCurrentClass=function(_4e4){
if(this.ivars){
var ivar=this.ivars[_4e4];
if(ivar){
return ivar;
}
}
var prev=this.prev;
if(prev&&!this.classDef){
return prev.getIvarForCurrentClass(_4e4);
}
return null;
};
_4e3.prototype.getLvar=function(_4e5,_4e6){
if(this.vars){
var lvar=this.vars[_4e5];
if(lvar){
return lvar;
}
}
var prev=this.prev;
if(prev&&(!_4e6||!this.methodType)){
return prev.getLvar(_4e5,_4e6);
}
return null;
};
_4e3.prototype.currentMethodType=function(){
return this.methodType?this.methodType:this.prev?this.prev.currentMethodType():null;
};
_4e3.prototype.copyAddedSelfToIvarsToParent=function(){
if(this.prev&&this.addedSelfToIvars){
for(var key in this.addedSelfToIvars){
var _4e7=this.addedSelfToIvars[key],_4e8=(this.prev.addedSelfToIvars||(this.prev.addedSelfToIvars=Object.create(null)))[key]||(this.prev.addedSelfToIvars[key]=[]);
_4e8.push.apply(_4e8,_4e7);
}
}
};
_4e3.prototype.addMaybeWarning=function(_4e9){
var _4ea=this.rootScope();
(_4ea._maybeWarnings||(_4ea._maybeWarnings=[])).push(_4e9);
};
_4e3.prototype.maybeWarnings=function(){
return this.rootScope()._maybeWarnings;
};
var _4eb=function(_4ec,node,code){
this.message=_4ed(_4ec,node,code);
this.node=node;
};
_4eb.prototype.checkIfWarning=function(st){
var _4ee=this.node.name;
return !st.getLvar(_4ee)&&typeof _1[_4ee]==="undefined"&&typeof window[_4ee]==="undefined"&&!st.compiler.getClassDef(_4ee);
};
function _2bf(){
this.atoms=[];
};
_2bf.prototype.toString=function(){
return this.atoms.join("");
};
_2bf.prototype.concat=function(_4ef){
this.atoms.push(_4ef);
};
_2bf.prototype.isEmpty=function(){
return this.atoms.length!==0;
};
var _4f0=function(_4f1,name,_4f2,_4f3,_4f4,_4f5,_4f6){
this.name=name;
if(_4f2){
this.superClass=_4f2;
}
if(_4f3){
this.ivars=_4f3;
}
if(_4f1){
this.instanceMethods=_4f4||Object.create(null);
this.classMethods=_4f5||Object.create(null);
}
if(_4f6){
this.protocols=_4f6;
}
};
_4f0.prototype.addInstanceMethod=function(_4f7){
this.instanceMethods[_4f7.name]=_4f7;
};
_4f0.prototype.addClassMethod=function(_4f8){
this.classMethods[_4f8.name]=_4f8;
};
_4f0.prototype.listOfNotImplementedMethodsForProtocols=function(_4f9){
var _4fa=[],_4fb=this.getInstanceMethods(),_4fc=this.getClassMethods();
for(var i=0,size=_4f9.length;i<size;i++){
var _4fd=_4f9[i],_4fe=_4fd.requiredInstanceMethods,_4ff=_4fd.requiredClassMethods,_500=_4fd.protocols;
if(_4fe){
for(var _501 in _4fe){
var _502=_4fe[_501];
if(!_4fb[_501]){
_4fa.push({"methodDef":_502,"protocolDef":_4fd});
}
}
}
if(_4ff){
for(var _501 in _4ff){
var _502=_4ff[_501];
if(!_4fc[_501]){
_4fa.push({"methodDef":_502,"protocolDef":_4fd});
}
}
}
if(_500){
_4fa=_4fa.concat(this.listOfNotImplementedMethodsForProtocols(_500));
}
}
return _4fa;
};
_4f0.prototype.getInstanceMethod=function(name){
var _503=this.instanceMethods;
if(_503){
var _504=_503[name];
if(_504){
return _504;
}
}
var _505=this.superClass;
if(_505){
return _505.getInstanceMethod(name);
}
return null;
};
_4f0.prototype.getClassMethod=function(name){
var _506=this.classMethods;
if(_506){
var _507=_506[name];
if(_507){
return _507;
}
}
var _508=this.superClass;
if(_508){
return _508.getClassMethod(name);
}
return null;
};
_4f0.prototype.getInstanceMethods=function(){
var _509=this.instanceMethods;
if(_509){
var _50a=this.superClass,_50b=Object.create(null);
if(_50a){
var _50c=_50a.getInstanceMethods();
for(var _50d in _50c){
_50b[_50d]=_50c[_50d];
}
}
for(var _50d in _509){
_50b[_50d]=_509[_50d];
}
return _50b;
}
return [];
};
_4f0.prototype.getClassMethods=function(){
var _50e=this.classMethods;
if(_50e){
var _50f=this.superClass,_510=Object.create(null);
if(_50f){
var _511=_50f.getClassMethods();
for(var _512 in _511){
_510[_512]=_511[_512];
}
}
for(var _512 in _50e){
_510[_512]=_50e[_512];
}
return _510;
}
return [];
};
var _513=function(name,_514,_515,_516){
this.name=name;
this.protocols=_514;
if(_515){
this.requiredInstanceMethods=_515;
}
if(_516){
this.requiredClassMethods=_516;
}
};
_513.prototype.addInstanceMethod=function(_517){
(this.requiredInstanceMethods||(this.requiredInstanceMethods=Object.create(null)))[_517.name]=_517;
};
_513.prototype.addClassMethod=function(_518){
(this.requiredClassMethods||(this.requiredClassMethods=Object.create(null)))[_518.name]=_518;
};
_513.prototype.getInstanceMethod=function(name){
var _519=this.requiredInstanceMethods;
if(_519){
var _51a=_519[name];
if(_51a){
return _51a;
}
}
var _51b=this.protocols;
for(var i=0,size=_51b.length;i<size;i++){
var _51c=_51b[i],_51a=_51c.getInstanceMethod(name);
if(_51a){
return _51a;
}
}
return null;
};
_513.prototype.getClassMethod=function(name){
var _51d=this.requiredClassMethods;
if(_51d){
var _51e=_51d[name];
if(_51e){
return _51e;
}
}
var _51f=this.protocols;
for(var i=0,size=_51f.length;i<size;i++){
var _520=_51f[i],_51e=_520.getInstanceMethod(name);
if(_51e){
return _51e;
}
}
return null;
};
var _521=function(name){
this.name=name;
};
var _522=function(name,_523){
this.name=name;
this.types=_523;
};
var _524="";
var _525=_2.acorn.makePredicate("self _cmd undefined localStorage arguments");
var _526=_2.acorn.makePredicate("delete in instanceof new typeof void");
var _527=_2.acorn.makePredicate("LogicalExpression BinaryExpression");
var _528=_2.acorn.makePredicate("in instanceof");
var _529=function(_52a,aURL,_52b,pass,_52c,_52d,_52e){
this.source=_52a;
this.URL=new CFURL(aURL);
this.pass=pass;
this.jsBuffer=new _2bf();
this.imBuffer=null;
this.cmBuffer=null;
this.warnings=[];
try{
this.tokens=_2.acorn.parse(_52a);
}
catch(e){
if(e.lineStart!=null){
var _52f=this.prettifyMessage(e,"ERROR");
console.log(_52f);
}
throw e;
}
this.dependencies=[];
this.flags=_52b|_529.Flags.IncludeDebugSymbols;
this.classDefs=_52c?_52c:Object.create(null);
this.protocolDefs=_52d?_52d:Object.create(null);
this.typeDefs=_52e?_52e:Object.create(null);
this.lastPos=0;
if(_524&_529.Flags.Generate){
this.generate=true;
}
this.generate=true;
_530(this.tokens,new _4e3(null,{compiler:this}),pass===2?_531:_532);
};
_2.ObjJAcornCompiler=_529;
_2.ObjJAcornCompiler.compileToExecutable=function(_533,aURL,_534){
_529.currentCompileFile=aURL;
return new _529(_533,aURL,_534,2).executable();
};
_2.ObjJAcornCompiler.compileToIMBuffer=function(_535,aURL,_536,_537,_538,_539){
return new _529(_535,aURL,_536,2,_537,_538,_539).IMBuffer();
};
_2.ObjJAcornCompiler.compileFileDependencies=function(_53a,aURL,_53b){
_529.currentCompileFile=aURL;
return new _529(_53a,aURL,_53b,1).executable();
};
_529.prototype.compilePass2=function(){
var _53c=[];
_529.currentCompileFile=this.URL;
this.pass=2;
this.jsBuffer=new _2bf();
this.warnings=[];
_530(this.tokens,new _4e3(null,{compiler:this}),_531);
for(var i=0;i<this.warnings.length;i++){
var _53d=this.warnings[i],type="WARNING";
var _53e=this.prettifyMessage(_53d,type);
console.log(_53e);
}
if(_53c.length&&_2.outputFormatInXML){
print(CFPropertyListCreateXMLData(_53c,kCFPropertyListXMLFormat_v1_0).rawString());
}
return this.jsBuffer.toString();
};
var _524="";
_2.setCurrentCompilerFlags=function(_53f){
_524=_53f;
};
_2.currentCompilerFlags=function(_540){
return _524;
};
_529.Flags={};
_529.Flags.IncludeDebugSymbols=1<<0;
_529.Flags.IncludeTypeSignatures=1<<1;
_529.Flags.Generate=1<<2;
_529.prototype.addWarning=function(_541){
this.warnings.push(_541);
};
_529.prototype.getIvarForClass=function(_542,_543){
var ivar=_543.getIvarForCurrentClass(_542);
if(ivar){
return ivar;
}
var c=this.getClassDef(_543.currentClassName());
while(c){
var _544=c.ivars;
if(_544){
var _545=_544[_542];
if(_545){
return _545;
}
}
c=c.superClass;
}
};
_529.prototype.getClassDef=function(_546){
if(!_546){
return null;
}
var c=this.classDefs[_546];
if(c){
return c;
}
if(typeof objj_getClass==="function"){
var _547=objj_getClass(_546);
if(_547){
var _548=class_copyIvarList(_547),_549=_548.length,_54a=Object.create(null),_54b=class_copyProtocolList(_547),_54c=_54b.length,_54d=Object.create(null),_54e=_529.methodDefsFromMethodList(class_copyMethodList(_547)),_54f=_529.methodDefsFromMethodList(class_copyMethodList(_547.isa)),_550=class_getSuperclass(_547);
for(var i=0;i<_549;i++){
var ivar=_548[i];
_54a[ivar.name]={"type":ivar.type,"name":ivar.name};
}
for(var i=0;i<_54c;i++){
var _551=_54b[i],_552=protocol_getName(_551),_553=this.getProtocolDef(_552);
_54d[_552]=_553;
}
c=new _4f0(true,_546,_550?this.getClassDef(_550.name):null,_54a,_54e,_54f,_54d);
this.classDefs[_546]=c;
return c;
}
}
return null;
};
_529.prototype.getProtocolDef=function(_554){
if(!_554){
return null;
}
var p=this.protocolDefs[_554];
if(p){
return p;
}
if(typeof objj_getProtocol==="function"){
var _555=objj_getProtocol(_554);
if(_555){
var _556=protocol_getName(_555),_557=protocol_copyMethodDescriptionList(_555,true,true),_558=_529.methodDefsFromMethodList(_557),_559=protocol_copyMethodDescriptionList(_555,true,false),_55a=_529.methodDefsFromMethodList(_559),_55b=_555.protocols,_55c=[];
if(_55b){
for(var i=0,size=_55b.length;i<size;i++){
_55c.push(compiler.getProtocolDef(_55b[i].name));
}
}
p=new _513(_556,_55c,_558,_55a);
this.protocolDefs[_554]=p;
return p;
}
}
return null;
};
_529.prototype.getTypeDef=function(_55d){
if(!_55d){
return null;
}
var t=this.typeDefs[_55d];
if(t){
return t;
}
if(typeof objj_getTypeDef==="function"){
var _55e=objj_getTypeDef(_55d);
if(_55e){
var _55f=typeDef_getName(_55e);
t=new _521(_55f);
this.typeDefs[_55f]=t;
return t;
}
}
return null;
};
_529.methodDefsFromMethodList=function(_560){
var _561=_560.length,_562=Object.create(null);
for(var i=0;i<_561;i++){
var _563=_560[i],_564=method_getName(_563);
_562[_564]=new _522(_564,_563.types);
}
return _562;
};
_529.prototype.executable=function(){
if(!this._executable){
this._executable=new _2ce(this.jsBuffer?this.jsBuffer.toString():null,this.dependencies,this.URL,null,this);
}
return this._executable;
};
_529.prototype.IMBuffer=function(){
return this.imBuffer;
};
_529.prototype.JSBuffer=function(){
return this.jsBuffer;
};
_529.prototype.prettifyMessage=function(_565,_566){
var line=this.source.substring(_565.lineStart,_565.lineEnd),_567="\n"+line;
_567+=(new Array(_565.column+1)).join(" ");
_567+=(new Array(Math.min(1,line.length)+1)).join("^")+"\n";
_567+=_566+" line "+_565.line+" in "+this.URL+": "+_565.message;
return _567;
};
_529.prototype.error_message=function(_568,node){
var pos=_2.acorn.getLineInfo(this.source,node.start),_569={message:_568,line:pos.line,column:pos.column,lineStart:pos.lineStart,lineEnd:pos.lineEnd},_56a=new SyntaxError(this.prettifyMessage(_569,"ERROR"));
_56a.line=pos.line;
_56a.path=this.URL.path();
return _56a;
};
_529.prototype.pushImport=function(url){
if(!_529.importStack){
_529.importStack=[];
}
_529.importStack.push(url);
};
_529.prototype.popImport=function(){
_529.importStack.pop();
};
function _4ed(_56b,node,code){
var _56c=_2.acorn.getLineInfo(code,node.start);
_56c.message=_56b;
return _56c;
};
function _530(node,_56d,_56e){
function c(node,st,_56f){
_56e[_56f||node.type](node,st,c);
};
c(node,_56d);
};
function _570(node){
switch(node.type){
case "Literal":
case "Identifier":
return true;
case "ArrayExpression":
for(var i=0;i<node.elements.length;++i){
if(!_570(node.elements[i])){
return false;
}
}
return true;
case "DictionaryLiteral":
for(var i=0;i<node.keys.length;++i){
if(!_570(node.keys[i])){
return false;
}
if(!_570(node.values[i])){
return false;
}
}
return true;
case "ObjectExpression":
for(var i=0;i<node.properties.length;++i){
if(!_570(node.properties[i].value)){
return false;
}
}
return true;
case "FunctionExpression":
for(var i=0;i<node.params.length;++i){
if(!_570(node.params[i])){
return false;
}
}
return true;
case "SequenceExpression":
for(var i=0;i<node.expressions.length;++i){
if(!_570(node.expressions[i])){
return false;
}
}
return true;
case "UnaryExpression":
return _570(node.argument);
case "BinaryExpression":
return _570(node.left)&&_570(node.right);
case "ConditionalExpression":
return _570(node.test)&&_570(node.consequent)&&_570(node.alternate);
case "MemberExpression":
return _570(node.object)&&(!node.computed||_570(node.property));
case "Dereference":
return _570(node.expr);
case "Reference":
return _570(node.element);
default:
return false;
}
};
function _571(st,node){
if(!_570(node)){
throw st.compiler.error_message("Dereference of expression with side effects",node);
}
};
function _572(c){
return function(node,st,_573){
st.compiler.jsBuffer.concat("(");
c(node,st,_573);
st.compiler.jsBuffer.concat(")");
};
};
var _574={"*":3,"/":3,"%":3,"+":4,"-":4,"<<":5,">>":5,">>>":5,"<":6,"<=":6,">":6,">=":6,"in":6,"instanceof":6,"==":7,"!=":7,"===":7,"!==":7,"&":8,"^":9,"|":10,"&&":11,"||":12};
var _575={MemberExpression:0,CallExpression:1,NewExpression:2,FunctionExpression:3,UnaryExpression:4,UpdateExpression:4,BinaryExpression:5,LogicalExpression:6,ConditionalExpression:7,AssignmentExpression:8};
function _576(node,_577,_578){
var _579=node.type,_576=_575[_579]||-1,_57a=_575[_577.type]||-1,_57b,_57c;
return _576<_57a||(_576===_57a&&_527(_579)&&((_57b=_574[node.operator])<(_57c=_574[_577.operator])||(_578&&_57b===_57c)));
};
var _532=_2.acorn.walk.make({ImportStatement:function(node,st,c){
var _57d=node.filename.value;
st.compiler.dependencies.push(new _2fd(new CFURL(_57d),node.localfilepath));
}});
var _57e=4;
var _57f=Array(_57e+1).join(" ");
var _580="";
var _531=_2.acorn.walk.make({Program:function(node,st,c){
var _581=st.compiler,_582=_581.generate;
_580="";
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
if(!_582){
_581.jsBuffer.concat(_581.source.substring(_581.lastPos,node.end));
}
var _583=st.maybeWarnings();
if(_583){
for(var i=0;i<_583.length;i++){
var _584=_583[i];
if(_584.checkIfWarning(st)){
_581.addWarning(_584.message);
}
}
}
},BlockStatement:function(node,st,c){
var _585=st.compiler,_586=_585.generate,_587=st.endOfScopeBody,_588;
if(_587){
delete st.endOfScopeBody;
}
if(_586){
st.indentBlockLevel=typeof st.indentBlockLevel==="undefined"?0:st.indentBlockLevel+1;
_588=_585.jsBuffer;
_588.concat(_580.substring(_57e));
_588.concat("{\n");
}
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
if(_586){
var _589=st.maxReceiverLevel;
if(_587&&_589){
_588.concat(_580);
_588.concat("var ");
for(var i=0;i<_589;i++){
if(i){
_588.concat(", ");
}
_588.concat("___r");
_588.concat((i+1)+"");
}
_588.concat(";\n");
}
_588.concat(_580.substring(_57e));
_588.concat("}");
if(st.isDecl||st.indentBlockLevel>0){
_588.concat("\n");
}
st.indentBlockLevel--;
}
},ExpressionStatement:function(node,st,c){
var _58a=st.compiler,_58b=_58a.generate;
if(_58b){
_58a.jsBuffer.concat(_580);
}
c(node.expression,st,"Expression");
if(_58b){
_58a.jsBuffer.concat(";\n");
}
},IfStatement:function(node,st,c){
var _58c=st.compiler,_58d=_58c.generate,_58e;
if(_58d){
_58e=_58c.jsBuffer;
if(!st.superNodeIsElse){
_58e.concat(_580);
}else{
delete st.superNodeIsElse;
}
_58e.concat("if (");
}
c(node.test,st,"Expression");
if(_58d){
_58e.concat(node.consequent.type==="EmptyStatement"?");\n":")\n");
}
_580+=_57f;
c(node.consequent,st,"Statement");
_580=_580.substring(_57e);
var _58f=node.alternate;
if(_58f){
var _590=_58f.type!=="IfStatement";
if(_58d){
var _591=_58f.type==="EmptyStatement";
_58e.concat(_580);
_58e.concat(_590?_591?"else;\n":"else\n":"else ");
}
if(_590){
_580+=_57f;
}else{
st.superNodeIsElse=true;
}
c(_58f,st,"Statement");
if(_590){
_580=_580.substring(_57e);
}
}
},LabeledStatement:function(node,st,c){
var _592=st.compiler;
if(_592.generate){
var _593=_592.jsBuffer;
_593.concat(_580);
_593.concat(node.label.name);
_593.concat(": ");
}
c(node.body,st,"Statement");
},BreakStatement:function(node,st,c){
var _594=st.compiler;
if(_594.generate){
_594.jsBuffer.concat(_580);
if(node.label){
_594.jsBuffer.concat("break ");
_594.jsBuffer.concat(node.label.name);
_594.jsBuffer.concat(";\n");
}else{
_594.jsBuffer.concat("break;\n");
}
}
},ContinueStatement:function(node,st,c){
var _595=st.compiler;
if(_595.generate){
var _596=_595.jsBuffer;
_596.concat(_580);
if(node.label){
_596.concat("continue ");
_596.concat(node.label.name);
_596.concat(";\n");
}else{
_596.concat("continue;\n");
}
}
},WithStatement:function(node,st,c){
var _597=st.compiler,_598=_597.generate,_599;
if(_598){
_599=_597.jsBuffer;
_599.concat(_580);
_599.concat("with(");
}
c(node.object,st,"Expression");
if(_598){
_599.concat(")\n");
}
_580+=_57f;
c(node.body,st,"Statement");
_580=_580.substring(_57e);
},SwitchStatement:function(node,st,c){
var _59a=st.compiler,_59b=_59a.generate,_59c;
if(_59b){
_59c=_59a.jsBuffer;
_59c.concat(_580);
_59c.concat("switch(");
}
c(node.discriminant,st,"Expression");
if(_59b){
_59c.concat(") {\n");
}
for(var i=0;i<node.cases.length;++i){
var cs=node.cases[i];
if(cs.test){
if(_59b){
_59c.concat(_580);
_59c.concat("case ");
}
c(cs.test,st,"Expression");
if(_59b){
_59c.concat(":\n");
}
}else{
if(_59b){
_59c.concat("default:\n");
}
}
_580+=_57f;
for(var j=0;j<cs.consequent.length;++j){
c(cs.consequent[j],st,"Statement");
}
_580=_580.substring(_57e);
}
if(_59b){
_59c.concat(_580);
_59c.concat("}\n");
}
},ReturnStatement:function(node,st,c){
var _59d=st.compiler,_59e=_59d.generate,_59f;
if(_59e){
_59f=_59d.jsBuffer;
_59f.concat(_580);
_59f.concat("return");
}
if(node.argument){
if(_59e){
_59f.concat(" ");
}
c(node.argument,st,"Expression");
}
if(_59e){
_59f.concat(";\n");
}
},ThrowStatement:function(node,st,c){
var _5a0=st.compiler,_5a1=_5a0.generate,_5a2;
if(_5a1){
_5a2=_5a0.jsBuffer;
_5a2.concat(_580);
_5a2.concat("throw ");
}
c(node.argument,st,"Expression");
if(_5a1){
_5a2.concat(";\n");
}
},TryStatement:function(node,st,c){
var _5a3=st.compiler,_5a4=_5a3.generate,_5a5;
if(_5a4){
_5a5=_5a3.jsBuffer;
_5a5.concat(_580);
_5a5.concat("try");
}
_580+=_57f;
c(node.block,st,"Statement");
_580=_580.substring(_57e);
for(var i=0;i<node.handlers.length;++i){
var _5a6=node.handlers[i],_5a7=new _4e3(st),_5a8=_5a6.param,name=_5a8.name;
_5a7.vars[name]={type:"catch clause",node:_5a8};
if(_5a4){
_5a5.concat(_580);
_5a5.concat("catch(");
_5a5.concat(name);
_5a5.concat(") ");
}
_580+=_57f;
_5a7.endOfScopeBody=true;
c(_5a6.body,_5a7,"ScopeBody");
_580=_580.substring(_57e);
_5a7.copyAddedSelfToIvarsToParent();
}
if(node.finalizer){
if(_5a4){
_5a5.concat(_580);
_5a5.concat("finally ");
}
_580+=_57f;
c(node.finalizer,st,"Statement");
_580=_580.substring(_57e);
}
},WhileStatement:function(node,st,c){
var _5a9=st.compiler,_5aa=_5a9.generate,body=node.body,_5ab;
if(_5aa){
_5ab=_5a9.jsBuffer;
_5ab.concat(_580);
_5ab.concat("while (");
}
c(node.test,st,"Expression");
if(_5aa){
_5ab.concat(body.type==="EmptyStatement"?");\n":")\n");
}
_580+=_57f;
c(body,st,"Statement");
_580=_580.substring(_57e);
},DoWhileStatement:function(node,st,c){
var _5ac=st.compiler,_5ad=_5ac.generate,_5ae;
if(_5ad){
_5ae=_5ac.jsBuffer;
_5ae.concat(_580);
_5ae.concat("do\n");
}
_580+=_57f;
c(node.body,st,"Statement");
_580=_580.substring(_57e);
if(_5ad){
_5ae.concat(_580);
_5ae.concat("while (");
}
c(node.test,st,"Expression");
if(_5ad){
_5ae.concat(");\n");
}
},ForStatement:function(node,st,c){
var _5af=st.compiler,_5b0=_5af.generate,body=node.body,_5b1;
if(_5b0){
_5b1=_5af.jsBuffer;
_5b1.concat(_580);
_5b1.concat("for (");
}
if(node.init){
c(node.init,st,"ForInit");
}
if(_5b0){
_5b1.concat("; ");
}
if(node.test){
c(node.test,st,"Expression");
}
if(_5b0){
_5b1.concat("; ");
}
if(node.update){
c(node.update,st,"Expression");
}
if(_5b0){
_5b1.concat(body.type==="EmptyStatement"?");\n":")\n");
}
_580+=_57f;
c(body,st,"Statement");
_580=_580.substring(_57e);
},ForInStatement:function(node,st,c){
var _5b2=st.compiler,_5b3=_5b2.generate,body=node.body,_5b4;
if(_5b3){
_5b4=_5b2.jsBuffer;
_5b4.concat(_580);
_5b4.concat("for (");
}
c(node.left,st,"ForInit");
if(_5b3){
_5b4.concat(" in ");
}
c(node.right,st,"Expression");
if(_5b3){
_5b4.concat(body.type==="EmptyStatement"?");\n":")\n");
}
_580+=_57f;
c(body,st,"Statement");
_580=_580.substring(_57e);
},ForInit:function(node,st,c){
var _5b5=st.compiler,_5b6=_5b5.generate;
if(node.type==="VariableDeclaration"){
st.isFor=true;
c(node,st);
delete st.isFor;
}else{
c(node,st,"Expression");
}
},DebuggerStatement:function(node,st,c){
var _5b7=st.compiler;
if(_5b7.generate){
var _5b8=_5b7.jsBuffer;
_5b8.concat(_580);
_5b8.concat("debugger;\n");
}
},Function:function(node,st,c){
var _5b9=st.compiler,_5ba=_5b9.generate,_5bb=_5b9.jsBuffer;
inner=new _4e3(st),decl=node.type=="FunctionDeclaration";
inner.isDecl=decl;
for(var i=0;i<node.params.length;++i){
inner.vars[node.params[i].name]={type:"argument",node:node.params[i]};
}
if(node.id){
(decl?st:inner).vars[node.id.name]={type:decl?"function":"function name",node:node.id};
if(_5ba){
_5bb.concat(node.id.name);
_5bb.concat(" = ");
}else{
_5bb.concat(_5b9.source.substring(_5b9.lastPos,node.start));
_5bb.concat(node.id.name);
_5bb.concat(" = function");
_5b9.lastPos=node.id.end;
}
}
if(_5ba){
_5bb.concat("function(");
for(var i=0;i<node.params.length;++i){
if(i){
_5bb.concat(", ");
}
_5bb.concat(node.params[i].name);
}
_5bb.concat(")\n");
}
_580+=_57f;
inner.endOfScopeBody=true;
c(node.body,inner,"ScopeBody");
_580=_580.substring(_57e);
inner.copyAddedSelfToIvarsToParent();
},VariableDeclaration:function(node,st,c){
var _5bc=st.compiler,_5bd=_5bc.generate,_5be;
if(_5bd){
_5be=_5bc.jsBuffer;
if(!st.isFor){
_5be.concat(_580);
}
_5be.concat("var ");
}
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i],_5bf=decl.id.name;
if(i){
if(_5bd){
if(st.isFor){
_5be.concat(", ");
}else{
_5be.concat(",\n");
_5be.concat(_580);
_5be.concat("    ");
}
}
}
st.vars[_5bf]={type:"var",node:decl.id};
if(_5bd){
_5be.concat(_5bf);
}
if(decl.init){
if(_5bd){
_5be.concat(" = ");
}
c(decl.init,st,"Expression");
}
if(st.addedSelfToIvars){
var _5c0=st.addedSelfToIvars[_5bf];
if(_5c0){
var _5be=st.compiler.jsBuffer.atoms;
for(var i=0;i<_5c0.length;i++){
var dict=_5c0[i];
_5be[dict.index]="";
_5bc.addWarning(_4ed("Local declaration of '"+_5bf+"' hides instance variable",dict.node,_5bc.source));
}
st.addedSelfToIvars[_5bf]=[];
}
}
}
if(_5bd&&!st.isFor){
_5bc.jsBuffer.concat(";\n");
}
},ThisExpression:function(node,st,c){
var _5c1=st.compiler;
if(_5c1.generate){
_5c1.jsBuffer.concat("this");
}
},ArrayExpression:function(node,st,c){
var _5c2=st.compiler,_5c3=_5c2.generate;
if(_5c3){
_5c2.jsBuffer.concat("[");
}
for(var i=0;i<node.elements.length;++i){
var elt=node.elements[i];
if(i!==0){
if(_5c3){
_5c2.jsBuffer.concat(", ");
}
}
if(elt){
c(elt,st,"Expression");
}
}
if(_5c3){
_5c2.jsBuffer.concat("]");
}
},ObjectExpression:function(node,st,c){
var _5c4=st.compiler,_5c5=_5c4.generate;
if(_5c5){
_5c4.jsBuffer.concat("{");
}
for(var i=0;i<node.properties.length;++i){
var prop=node.properties[i];
if(_5c5){
if(i){
_5c4.jsBuffer.concat(", ");
}
st.isPropertyKey=true;
c(prop.key,st,"Expression");
delete st.isPropertyKey;
_5c4.jsBuffer.concat(": ");
}else{
if(prop.key.raw&&prop.key.raw.charAt(0)==="@"){
_5c4.jsBuffer.concat(_5c4.source.substring(_5c4.lastPos,prop.key.start));
_5c4.lastPos=prop.key.start+1;
}
}
c(prop.value,st,"Expression");
}
if(_5c5){
_5c4.jsBuffer.concat("}");
}
},SequenceExpression:function(node,st,c){
var _5c6=st.compiler,_5c7=_5c6.generate;
if(_5c7){
_5c6.jsBuffer.concat("(");
}
for(var i=0;i<node.expressions.length;++i){
if(_5c7&&i!==0){
_5c6.jsBuffer.concat(", ");
}
c(node.expressions[i],st,"Expression");
}
if(_5c7){
_5c6.jsBuffer.concat(")");
}
},UnaryExpression:function(node,st,c){
var _5c8=st.compiler,_5c9=_5c8.generate,_5ca=node.argument;
if(_5c9){
if(node.prefix){
_5c8.jsBuffer.concat(node.operator);
if(_526(node.operator)){
_5c8.jsBuffer.concat(" ");
}
(_576(node,_5ca)?_572(c):c)(_5ca,st,"Expression");
}else{
(_576(node,_5ca)?_572(c):c)(_5ca,st,"Expression");
_5c8.jsBuffer.concat(node.operator);
}
}else{
c(_5ca,st,"Expression");
}
},UpdateExpression:function(node,st,c){
var _5cb=st.compiler,_5cc=_5cb.generate;
if(node.argument.type==="Dereference"){
_571(st,node.argument);
if(!_5cc){
_5cb.jsBuffer.concat(_5cb.source.substring(_5cb.lastPos,node.start));
}
_5cb.jsBuffer.concat((node.prefix?"":"(")+"(");
if(!_5cc){
_5cb.lastPos=node.argument.expr.start;
}
c(node.argument.expr,st,"Expression");
if(!_5cc){
_5cb.jsBuffer.concat(_5cb.source.substring(_5cb.lastPos,node.argument.expr.end));
}
_5cb.jsBuffer.concat(")(");
if(!_5cc){
_5cb.lastPos=node.argument.start;
}
c(node.argument,st,"Expression");
if(!_5cc){
_5cb.jsBuffer.concat(_5cb.source.substring(_5cb.lastPos,node.argument.end));
}
_5cb.jsBuffer.concat(" "+node.operator.substring(0,1)+" 1)"+(node.prefix?"":node.operator=="++"?" - 1)":" + 1)"));
if(!_5cc){
_5cb.lastPos=node.end;
}
return;
}
if(node.prefix){
if(_5cc){
_5cb.jsBuffer.concat(node.operator);
if(_526(node.operator)){
_5cb.jsBuffer.concat(" ");
}
}
(_5cc&&_576(node,node.argument)?_572(c):c)(node.argument,st,"Expression");
}else{
(_5cc&&_576(node,node.argument)?_572(c):c)(node.argument,st,"Expression");
if(_5cc){
_5cb.jsBuffer.concat(node.operator);
}
}
},BinaryExpression:function(node,st,c){
var _5cd=st.compiler,_5ce=_5cd.generate,_5cf=_528(node.operator);
(_5ce&&_576(node,node.left)?_572(c):c)(node.left,st,"Expression");
if(_5ce){
var _5d0=_5cd.jsBuffer;
_5d0.concat(" ");
_5d0.concat(node.operator);
_5d0.concat(" ");
}
(_5ce&&_576(node,node.right,true)?_572(c):c)(node.right,st,"Expression");
},LogicalExpression:function(node,st,c){
var _5d1=st.compiler,_5d2=_5d1.generate;
(_5d2&&_576(node,node.left)?_572(c):c)(node.left,st,"Expression");
if(_5d2){
var _5d3=_5d1.jsBuffer;
_5d3.concat(" ");
_5d3.concat(node.operator);
_5d3.concat(" ");
}
(_5d2&&_576(node,node.right,true)?_572(c):c)(node.right,st,"Expression");
},AssignmentExpression:function(node,st,c){
var _5d4=st.compiler,_5d5=_5d4.generate,_5d6=st.assignment,_5d7=_5d4.jsBuffer;
if(node.left.type==="Dereference"){
_571(st,node.left);
if(!_5d5){
_5d7.concat(_5d4.source.substring(_5d4.lastPos,node.start));
}
_5d7.concat("(");
if(!_5d5){
_5d4.lastPos=node.left.expr.start;
}
c(node.left.expr,st,"Expression");
if(!_5d5){
_5d7.concat(_5d4.source.substring(_5d4.lastPos,node.left.expr.end));
}
_5d7.concat(")(");
if(node.operator!=="="){
if(!_5d5){
_5d4.lastPos=node.left.start;
}
c(node.left,st,"Expression");
if(!_5d5){
_5d7.concat(_5d4.source.substring(_5d4.lastPos,node.left.end));
}
_5d7.concat(" "+node.operator.substring(0,1)+" ");
}
if(!_5d5){
_5d4.lastPos=node.right.start;
}
c(node.right,st,"Expression");
if(!_5d5){
_5d7.concat(_5d4.source.substring(_5d4.lastPos,node.right.end));
}
_5d7.concat(")");
if(!_5d5){
_5d4.lastPos=node.end;
}
return;
}
var _5d6=st.assignment,_5d8=node.left;
st.assignment=true;
if(_5d8.type==="Identifier"&&_5d8.name==="self"){
var lVar=st.getLvar("self",true);
if(lVar){
var _5d9=lVar.scope;
if(_5d9){
_5d9.assignmentToSelf=true;
}
}
}
(_5d5&&_576(node,_5d8)?_572(c):c)(_5d8,st,"Expression");
if(_5d5){
_5d7.concat(" ");
_5d7.concat(node.operator);
_5d7.concat(" ");
}
st.assignment=_5d6;
(_5d5&&_576(node,node.right,true)?_572(c):c)(node.right,st,"Expression");
if(st.isRootScope()&&_5d8.type==="Identifier"&&!st.getLvar(_5d8.name)){
st.vars[_5d8.name]={type:"global",node:_5d8};
}
},ConditionalExpression:function(node,st,c){
var _5da=st.compiler,_5db=_5da.generate;
(_5db&&_576(node,node.test)?_572(c):c)(node.test,st,"Expression");
if(_5db){
_5da.jsBuffer.concat(" ? ");
}
c(node.consequent,st,"Expression");
if(_5db){
_5da.jsBuffer.concat(" : ");
}
c(node.alternate,st,"Expression");
},NewExpression:function(node,st,c){
var _5dc=st.compiler,_5dd=_5dc.generate;
if(_5dd){
_5dc.jsBuffer.concat("new ");
}
(_5dd&&_576(node,node.callee)?_572(c):c)(node.callee,st,"Expression");
if(_5dd){
_5dc.jsBuffer.concat("(");
}
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
if(_5dd&&i){
_5dc.jsBuffer.concat(", ");
}
c(node.arguments[i],st,"Expression");
}
}
if(_5dd){
_5dc.jsBuffer.concat(")");
}
},CallExpression:function(node,st,c){
var _5de=st.compiler,_5df=_5de.generate,_5e0=node.callee;
if(_5e0.type==="Identifier"&&_5e0.name==="eval"){
var _5e1=st.getLvar("self",true);
if(_5e1){
var _5e2=_5e1.scope;
if(_5e2){
_5e2.assignmentToSelf=true;
}
}
}
(_5df&&_576(node,_5e0)?_572(c):c)(_5e0,st,"Expression");
if(_5df){
_5de.jsBuffer.concat("(");
}
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
if(_5df&&i){
_5de.jsBuffer.concat(", ");
}
c(node.arguments[i],st,"Expression");
}
}
if(_5df){
_5de.jsBuffer.concat(")");
}
},MemberExpression:function(node,st,c){
var _5e3=st.compiler,_5e4=_5e3.generate,_5e5=node.computed;
(_5e4&&_576(node,node.object)?_572(c):c)(node.object,st,"Expression");
if(_5e4){
if(_5e5){
_5e3.jsBuffer.concat("[");
}else{
_5e3.jsBuffer.concat(".");
}
}
st.secondMemberExpression=!_5e5;
(_5e4&&!_5e5&&_576(node,node.property)?_572(c):c)(node.property,st,"Expression");
st.secondMemberExpression=false;
if(_5e4&&_5e5){
_5e3.jsBuffer.concat("]");
}
},Identifier:function(node,st,c){
var _5e6=st.compiler,_5e7=_5e6.generate,_5e8=node.name;
if(st.currentMethodType()==="-"&&!st.secondMemberExpression&&!st.isPropertyKey){
var lvar=st.getLvar(_5e8,true),ivar=_5e6.getIvarForClass(_5e8,st);
if(ivar){
if(lvar){
_5e6.addWarning(_4ed("Local declaration of '"+_5e8+"' hides instance variable",node,_5e6.source));
}else{
var _5e9=node.start;
if(!_5e7){
do{
_5e6.jsBuffer.concat(_5e6.source.substring(_5e6.lastPos,_5e9));
_5e6.lastPos=_5e9;
}while(_5e6.source.substr(_5e9++,1)==="(");
}
((st.addedSelfToIvars||(st.addedSelfToIvars=Object.create(null)))[_5e8]||(st.addedSelfToIvars[_5e8]=[])).push({node:node,index:_5e6.jsBuffer.atoms.length});
_5e6.jsBuffer.concat("self.");
}
}else{
if(!_525(_5e8)){
var _5ea,_5eb=typeof _1[_5e8]!=="undefined"||typeof window[_5e8]!=="undefined"||_5e6.getClassDef(_5e8),_5ec=st.getLvar(_5e8);
if(_5eb&&(!_5ec||_5ec.type!=="class")){
}else{
if(!_5ec){
if(st.assignment){
_5ea=new _4eb("Creating global variable inside function or method '"+_5e8+"'",node,_5e6.source);
st.vars[_5e8]={type:"remove global warning",node:node};
}else{
_5ea=new _4eb("Using unknown class or uninitialized global variable '"+_5e8+"'",node,_5e6.source);
}
}
}
if(_5ea){
st.addMaybeWarning(_5ea);
}
}
}
}
if(_5e7){
_5e6.jsBuffer.concat(_5e8);
}
},Literal:function(node,st,c){
var _5ed=st.compiler,_5ee=_5ed.generate;
if(_5ee){
if(node.raw&&node.raw.charAt(0)==="@"){
_5ed.jsBuffer.concat(node.raw.substring(1));
}else{
_5ed.jsBuffer.concat(node.raw);
}
}else{
if(node.raw.charAt(0)==="@"){
_5ed.jsBuffer.concat(_5ed.source.substring(_5ed.lastPos,node.start));
_5ed.lastPos=node.start+1;
}
}
},ArrayLiteral:function(node,st,c){
var _5ef=st.compiler,_5f0=_5ef.generate;
if(!_5f0){
_5ef.jsBuffer.concat(_5ef.source.substring(_5ef.lastPos,node.start));
_5ef.lastPos=node.start;
}
if(!_5f0){
buffer.concat(" ");
}
if(!node.elements.length){
_5ef.jsBuffer.concat("objj_msgSend(objj_msgSend(CPArray, \"alloc\"), \"init\")");
}else{
_5ef.jsBuffer.concat("objj_msgSend(objj_msgSend(CPArray, \"alloc\"), \"initWithObjects:count:\", [");
for(var i=0;i<node.elements.length;i++){
var elt=node.elements[i];
if(i){
_5ef.jsBuffer.concat(", ");
}
if(!_5f0){
_5ef.lastPos=elt.start;
}
c(elt,st,"Expression");
if(!_5f0){
_5ef.jsBuffer.concat(_5ef.source.substring(_5ef.lastPos,elt.end));
}
}
_5ef.jsBuffer.concat("], "+node.elements.length+")");
}
if(!_5f0){
_5ef.lastPos=node.end;
}
},DictionaryLiteral:function(node,st,c){
var _5f1=st.compiler,_5f2=_5f1.generate;
if(!_5f2){
_5f1.jsBuffer.concat(_5f1.source.substring(_5f1.lastPos,node.start));
_5f1.lastPos=node.start;
}
if(!_5f2){
buffer.concat(" ");
}
if(!node.keys.length){
_5f1.jsBuffer.concat("objj_msgSend(objj_msgSend(CPDictionary, \"alloc\"), \"init\")");
}else{
_5f1.jsBuffer.concat("objj_msgSend(objj_msgSend(CPDictionary, \"alloc\"), \"initWithObjectsAndKeys:\"");
for(var i=0;i<node.keys.length;i++){
var key=node.keys[i],_5f3=node.values[i];
_5f1.jsBuffer.concat(", ");
if(!_5f2){
_5f1.lastPos=_5f3.start;
}
c(_5f3,st,"Expression");
if(!_5f2){
_5f1.jsBuffer.concat(_5f1.source.substring(_5f1.lastPos,_5f3.end));
}
_5f1.jsBuffer.concat(", ");
if(!_5f2){
_5f1.lastPos=key.start;
}
c(key,st,"Expression");
if(!_5f2){
_5f1.jsBuffer.concat(_5f1.source.substring(_5f1.lastPos,key.end));
}
}
_5f1.jsBuffer.concat(")");
}
if(!_5f2){
_5f1.lastPos=node.end;
}
},ImportStatement:function(node,st,c){
var _5f4=st.compiler,_5f5=_5f4.generate,_5f6=_5f4.jsBuffer;
if(!_5f5){
_5f6.concat(_5f4.source.substring(_5f4.lastPos,node.start));
}
_5f6.concat("objj_executeFile(\"");
_5f6.concat(node.filename.value);
_5f6.concat(node.localfilepath?"\", YES);":"\", NO);");
if(!_5f5){
_5f4.lastPos=node.end;
}
},ClassDeclarationStatement:function(node,st,c){
var _5f7=st.compiler,_5f8=_5f7.generate,_5f9=_5f7.jsBuffer,_5fa=node.classname.name,_5fb=_5f7.getClassDef(_5fa),_5fc=new _4e3(st),_5fd=node.type==="InterfaceDeclarationStatement",_5fe=node.protocols;
_5f7.imBuffer=new _2bf();
_5f7.cmBuffer=new _2bf();
_5f7.classBodyBuffer=new _2bf();
if(_5f7.getTypeDef(_5fa)){
throw _5f7.error_message(_5fa+" is already declared as a type",node.classname);
}
if(!_5f8){
_5f9.concat(_5f7.source.substring(_5f7.lastPos,node.start));
}
if(node.superclassname){
if(_5fb&&_5fb.ivars){
throw _5f7.error_message("Duplicate class "+_5fa,node.classname);
}
if(_5fd&&_5fb&&_5fb.instanceMethods&&_5fb.classMethods){
throw _5f7.error_message("Duplicate interface definition for class "+_5fa,node.classname);
}
var _5ff=_5f7.getClassDef(node.superclassname.name);
if(!_5ff){
var _600="Can't find superclass "+node.superclassname.name;
for(var i=_529.importStack.length;--i>=0;){
_600+="\n"+Array((_529.importStack.length-i)*2+1).join(" ")+"Imported by: "+_529.importStack[i];
}
throw _5f7.error_message(_600,node.superclassname);
}
_5fb=new _4f0(!_5fd,_5fa,_5ff,Object.create(null));
_5f9.concat("{var the_class = objj_allocateClassPair("+node.superclassname.name+", \""+_5fa+"\"),\nmeta_class = the_class.isa;");
}else{
if(node.categoryname){
_5fb=_5f7.getClassDef(_5fa);
if(!_5fb){
throw _5f7.error_message("Class "+_5fa+" not found ",node.classname);
}
_5f9.concat("{\nvar the_class = objj_getClass(\""+_5fa+"\")\n");
_5f9.concat("if(!the_class) throw new SyntaxError(\"*** Could not find definition for class \\\""+_5fa+"\\\"\");\n");
_5f9.concat("var meta_class = the_class.isa;");
}else{
_5fb=new _4f0(!_5fd,_5fa,null,Object.create(null));
_5f9.concat("{var the_class = objj_allocateClassPair(Nil, \""+_5fa+"\"),\nmeta_class = the_class.isa;");
}
}
if(_5fe){
for(var i=0,size=_5fe.length;i<size;i++){
_5f9.concat("\nvar aProtocol = objj_getProtocol(\""+_5fe[i].name+"\");");
_5f9.concat("\nif (!aProtocol) throw new SyntaxError(\"*** Could not find definition for protocol \\\""+_5fe[i].name+"\\\"\");");
_5f9.concat("\nclass_addProtocol(the_class, aProtocol);");
}
}
_5fc.classDef=_5fb;
_5f7.currentSuperClass="objj_getClass(\""+_5fa+"\").super_class";
_5f7.currentSuperMetaClass="objj_getMetaClass(\""+_5fa+"\").super_class";
var _601=true,_602=_5fb.ivars,_603=[],_604=false;
if(node.ivardeclarations){
for(var i=0;i<node.ivardeclarations.length;++i){
var _605=node.ivardeclarations[i],_606=_605.ivartype?_605.ivartype.name:null,_607=_605.ivartype?_605.ivartype.typeisclass:false,_608=_605.id.name,ivar={"type":_606,"name":_608},_609=_605.accessors;
var _60a=function(_60b,_60c){
if(_60b.ivars[_608]){
throw _5f7.error_message("Instance variable '"+_608+"' is already declared for class "+_5fa+(_60b.name!==_5fa?" in superclass "+_60b.name:""),_605.id);
}
if(_60b.superClass){
_60c(_60b.superClass,_60c);
}
};
_60a(_5fb,_60a);
var _60d=!_607||typeof _1[_606]!=="undefined"||typeof window[_606]!=="undefined"||_5f7.getClassDef(_606)||_5f7.getTypeDef(_606)||_606==_5fb.name;
if(!_60d){
_5f7.addWarning(_4ed("Unknown type '"+_606+"' for ivar '"+_608+"'",_605.id,_5f7.source));
}
if(_601){
_601=false;
_5f9.concat("class_addIvars(the_class, [");
}else{
_5f9.concat(", ");
}
if(_5f7.flags&_529.Flags.IncludeTypeSignatures){
_5f9.concat("new objj_ivar(\""+_608+"\", \""+_606+"\")");
}else{
_5f9.concat("new objj_ivar(\""+_608+"\")");
}
if(_605.outlet){
ivar.outlet=true;
}
_603.push(ivar);
if(!_5fc.ivars){
_5fc.ivars=Object.create(null);
}
_5fc.ivars[_608]={type:"ivar",name:_608,node:_605.id,ivar:ivar};
if(_609){
var _60e=(_609.property&&_609.property.name)||_608,_60f=(_609.getter&&_609.getter.name)||_60e;
_5fb.addInstanceMethod(new _522(_60f,[_606]));
if(!_609.readonly){
var _610=_609.setter?_609.setter.name:null;
if(!_610){
var _611=_60e.charAt(0)=="_"?1:0;
_610=(_611?"_":"")+"set"+_60e.substr(_611,1).toUpperCase()+_60e.substring(_611+1)+":";
}
_5fb.addInstanceMethod(new _522(_610,["void",_606]));
}
_604=true;
}
}
}
if(!_601){
_5f9.concat("]);");
}
if(!_5fd&&_604){
var _612=new _2bf();
_612.concat(_5f7.source.substring(node.start,node.endOfIvars).replace(/<.*>/g,""));
_612.concat("\n");
for(var i=0;i<node.ivardeclarations.length;++i){
var _605=node.ivardeclarations[i],_606=_605.ivartype?_605.ivartype.name:null,_608=_605.id.name,_609=_605.accessors;
if(!_609){
continue;
}
var _60e=(_609.property&&_609.property.name)||_608,_60f=(_609.getter&&_609.getter.name)||_60e,_613="- ("+(_606?_606:"id")+")"+_60f+"\n{\nreturn "+_608+";\n}\n";
_612.concat(_613);
if(_609.readonly){
continue;
}
var _610=_609.setter?_609.setter.name:null;
if(!_610){
var _611=_60e.charAt(0)=="_"?1:0;
_610=(_611?"_":"")+"set"+_60e.substr(_611,1).toUpperCase()+_60e.substring(_611+1)+":";
}
var _614="- (void)"+_610+"("+(_606?_606:"id")+")newValue\n{\n";
if(_609.copy){
_614+="if ("+_608+" !== newValue)\n"+_608+" = [newValue copy];\n}\n";
}else{
_614+=_608+" = newValue;\n}\n";
}
_612.concat(_614);
}
_612.concat("\n@end");
var b=_612.toString().replace(/@accessors(\(.*\))?/g,"");
var _615=_529.compileToIMBuffer(b,"Accessors",_5f7.flags,_5f7.classDefs,_5f7.protocolDefs,_5f7.typeDefs);
_5f7.imBuffer.concat(_615);
}
for(var _616=_603.length,i=0;i<_616;i++){
var ivar=_603[i],_608=ivar.name;
_602[_608]=ivar;
}
_5f7.classDefs[_5fa]=_5fb;
var _617=node.body,_618=_617.length;
if(_618>0){
if(!_5f8){
_5f7.lastPos=_617[0].start;
}
for(var i=0;i<_618;++i){
var body=_617[i];
c(body,_5fc,"Statement");
}
if(!_5f8){
_5f9.concat(_5f7.source.substring(_5f7.lastPos,body.end));
}
}
if(!_5fd&&!node.categoryname){
_5f9.concat("objj_registerClassPair(the_class);\n");
}
if(_5f7.imBuffer.isEmpty()){
_5f9.concat("class_addMethods(the_class, [");
_5f9.atoms.push.apply(_5f9.atoms,_5f7.imBuffer.atoms);
_5f9.concat("]);\n");
}
if(_5f7.cmBuffer.isEmpty()){
_5f9.concat("class_addMethods(meta_class, [");
_5f9.atoms.push.apply(_5f9.atoms,_5f7.cmBuffer.atoms);
_5f9.concat("]);\n");
}
_5f9.concat("}");
_5f7.jsBuffer=_5f9;
if(!_5f8){
_5f7.lastPos=node.end;
}
if(_5fe){
var _619=[];
for(var i=0,size=_5fe.length;i<size;i++){
var _61a=_5fe[i],_61b=_5f7.getProtocolDef(_61a.name);
if(!_61b){
throw _5f7.error_message("Cannot find protocol declaration for '"+_61a.name+"'",_61a);
}
_619.push(_61b);
}
var _61c=_5fb.listOfNotImplementedMethodsForProtocols(_619);
if(_61c&&_61c.length>0){
for(var i=0,size=_61c.length;i<size;i++){
var _61d=_61c[i],_61e=_61d.methodDef,_61b=_61d.protocolDef;
_5f7.addWarning(_4ed("Method '"+_61e.name+"' in protocol '"+_61b.name+"' is not implemented",node.classname,_5f7.source));
}
}
}
},ProtocolDeclarationStatement:function(node,st,c){
var _61f=st.compiler,_620=_61f.generate,_621=_61f.jsBuffer,_622=node.protocolname.name,_623=_61f.getProtocolDef(_622),_624=node.protocols,_625=new _4e3(st),_626=[];
if(_623){
throw _61f.error_message("Duplicate protocol "+_622,node.protocolname);
}
_61f.imBuffer=new _2bf();
_61f.cmBuffer=new _2bf();
if(!_620){
_621.concat(_61f.source.substring(_61f.lastPos,node.start));
}
_621.concat("{var the_protocol = objj_allocateProtocol(\""+_622+"\");");
if(_624){
for(var i=0,size=_624.length;i<size;i++){
var _627=_624[i],_628=_627.name;
inheritProtocolDef=_61f.getProtocolDef(_628);
if(!inheritProtocolDef){
throw _61f.error_message("Can't find protocol "+_628,_627);
}
_621.concat("\nvar aProtocol = objj_getProtocol(\""+_628+"\");");
_621.concat("\nif (!aProtocol) throw new SyntaxError(\"*** Could not find definition for protocol \\\""+_622+"\\\"\");");
_621.concat("\nprotocol_addProtocol(the_protocol, aProtocol);");
_626.push(inheritProtocolDef);
}
}
_623=new _513(_622,_626);
_61f.protocolDefs[_622]=_623;
_625.protocolDef=_623;
var _629=node.required;
if(_629){
var _62a=_629.length;
if(_62a>0){
for(var i=0;i<_62a;++i){
var _62b=_629[i];
if(!_620){
_61f.lastPos=_62b.start;
}
c(_62b,_625,"Statement");
}
if(!_620){
_621.concat(_61f.source.substring(_61f.lastPos,_62b.end));
}
}
}
_621.concat("\nobjj_registerProtocol(the_protocol);\n");
if(_61f.imBuffer.isEmpty()){
_621.concat("protocol_addMethodDescriptions(the_protocol, [");
_621.atoms.push.apply(_621.atoms,_61f.imBuffer.atoms);
_621.concat("], true, true);\n");
}
if(_61f.cmBuffer.isEmpty()){
_621.concat("protocol_addMethodDescriptions(the_protocol, [");
_621.atoms.push.apply(_621.atoms,_61f.cmBuffer.atoms);
_621.concat("], true, false);\n");
}
_621.concat("}");
_61f.jsBuffer=_621;
if(!_620){
_61f.lastPos=node.end;
}
},MethodDeclarationStatement:function(node,st,c){
var _62c=st.compiler,_62d=_62c.generate,_62e=_62c.jsBuffer,_62f=new _4e3(st),_630=node.methodtype==="-";
selectors=node.selectors,nodeArguments=node.arguments,returnType=node.returntype,types=[returnType?returnType.name:(node.action?"void":"id")],returnTypeProtocols=returnType?returnType.protocols:null;
selector=selectors[0].name;
if(returnTypeProtocols){
for(var i=0,size=returnTypeProtocols.length;i<size;i++){
var _631=returnTypeProtocols[i];
if(!_62c.getProtocolDef(_631.name)){
_62c.addWarning(_4ed("Cannot find protocol declaration for '"+_631.name+"'",_631,_62c.source));
}
}
}
if(!_62d){
_62e.concat(_62c.source.substring(_62c.lastPos,node.start));
}
_62c.jsBuffer=_630?_62c.imBuffer:_62c.cmBuffer;
for(var i=0;i<nodeArguments.length;i++){
var _632=nodeArguments[i],_633=_632.type,_634=_633?_633.name:"id",_635=_633?_633.protocols:null;
types.push(_633?_633.name:"id");
if(_635){
for(var j=0,size=_635.length;j<size;j++){
var _636=_635[j];
if(!_62c.getProtocolDef(_636.name)){
_62c.addWarning(_4ed("Cannot find protocol declaration for '"+_636.name+"'",_636,_62c.source));
}
}
}
if(i===0){
selector+=":";
}else{
selector+=(selectors[i]?selectors[i].name:"")+":";
}
}
if(_62c.jsBuffer.isEmpty()){
_62c.jsBuffer.concat(", ");
}
_62c.jsBuffer.concat("new objj_method(sel_getUid(\"");
_62c.jsBuffer.concat(selector);
_62c.jsBuffer.concat("\"), ");
if(node.body){
_62c.jsBuffer.concat("function");
if(_62c.flags&_529.Flags.IncludeDebugSymbols){
_62c.jsBuffer.concat(" $"+st.currentClassName()+"__"+selector.replace(/:/g,"_"));
}
_62c.jsBuffer.concat("(self, _cmd");
_62f.methodType=node.methodtype;
_62f.vars["self"]={type:"method base",scope:_62f};
_62f.vars["_cmd"]={type:"method base",scope:_62f};
if(nodeArguments){
for(var i=0;i<nodeArguments.length;i++){
var _632=nodeArguments[i],_637=_632.identifier.name;
_62c.jsBuffer.concat(", ");
_62c.jsBuffer.concat(_637);
_62f.vars[_637]={type:"method argument",node:_632};
}
}
_62c.jsBuffer.concat(")\n");
if(!_62d){
_62c.lastPos=node.startOfBody;
}
_580+=_57f;
_62f.endOfScopeBody=true;
c(node.body,_62f,"Statement");
_580=_580.substring(_57e);
if(!_62d){
_62c.jsBuffer.concat(_62c.source.substring(_62c.lastPos,node.body.end));
}
_62c.jsBuffer.concat("\n");
}else{
_62c.jsBuffer.concat("Nil\n");
}
if(_62c.flags&_529.Flags.IncludeDebugSymbols){
_62c.jsBuffer.concat(","+JSON.stringify(types));
}
_62c.jsBuffer.concat(")");
_62c.jsBuffer=_62e;
if(!_62d){
_62c.lastPos=node.end;
}
var def=st.classDef,_638;
if(def){
_638=_630?def.getInstanceMethod(selector):def.getClassMethod(selector);
}else{
def=st.protocolDef;
}
if(!def){
throw "InternalError: MethodDeclaration without ClassDeclaration or ProtocolDeclaration at line: "+_2.acorn.getLineInfo(_62c.source,node.start).line;
}
if(!_638){
var _639=def.protocols;
if(_639){
for(var i=0,size=_639.length;i<size;i++){
var _63a=_639[i],_638=_630?_63a.getInstanceMethod(selector):_63a.getClassMethod(selector);
if(_638){
break;
}
}
}
}
if(_638){
var _63b=_638.types;
if(_63b){
var _63c=_63b.length;
if(_63c>0){
var _63d=_63b[0];
if(_63d!==types[0]&&!(_63d==="id"&&returnType&&returnType.typeisclass)){
_62c.addWarning(_4ed("Conflicting return type in implementation of '"+selector+"': '"+_63d+"' vs '"+types[0]+"'",returnType||node.action||selectors[0],_62c.source));
}
for(var i=1;i<_63c;i++){
var _63e=_63b[i];
if(_63e!==types[i]&&!(_63e==="id"&&nodeArguments[i-1].type.typeisclass)){
_62c.addWarning(_4ed("Conflicting parameter types in implementation of '"+selector+"': '"+_63e+"' vs '"+types[i]+"'",nodeArguments[i-1].type||nodeArguments[i-1].identifier,_62c.source));
}
}
}
}
}
var _63f=new _522(selector,types);
if(_630){
def.addInstanceMethod(_63f);
}else{
def.addClassMethod(_63f);
}
},MessageSendExpression:function(node,st,c){
var _640=st.compiler,_641=_640.generate,_642=_640.jsBuffer,_643=node.object;
if(!_641){
_642.concat(_640.source.substring(_640.lastPos,node.start));
_640.lastPos=_643?_643.start:node.arguments.length?node.arguments[0].start:node.end;
}
if(node.superObject){
if(!_641){
_642.concat(" ");
}
_642.concat("objj_msgSendSuper(");
_642.concat("{ receiver:self, super_class:"+(st.currentMethodType()==="+"?_640.currentSuperMetaClass:_640.currentSuperClass)+" }");
}else{
if(_641){
var _644=_643.type==="Identifier"&&!(st.currentMethodType()==="-"&&_640.getIvarForClass(_643.name,st)&&!st.getLvar(_643.name,true)),_645,_646;
if(_644){
var name=_643.name,_645=st.getLvar(name);
if(name==="self"){
_646=!_645||!_645.scope||_645.scope.assignmentToSelf;
}else{
_646=!!_645||!_640.getClassDef(name);
}
if(_646){
_642.concat("(");
c(_643,st,"Expression");
_642.concat(" == null ? null : ");
}
c(_643,st,"Expression");
}else{
_646=true;
if(!st.receiverLevel){
st.receiverLevel=0;
}
_642.concat("((___r");
_642.concat(++st.receiverLevel+"");
_642.concat(" = ");
c(_643,st,"Expression");
_642.concat("), ___r");
_642.concat(st.receiverLevel+"");
_642.concat(" == null ? null : ___r");
_642.concat(st.receiverLevel+"");
if(!(st.maxReceiverLevel>=st.receiverLevel)){
st.maxReceiverLevel=st.receiverLevel;
}
}
_642.concat(".isa.objj_msgSend");
}else{
_642.concat(" ");
_642.concat("objj_msgSend(");
_642.concat(_640.source.substring(_640.lastPos,_643.end));
}
}
var _647=node.selectors,_648=node.arguments,_649=_648.length,_64a=_647[0],_64b=_64a?_64a.name:"";
if(_641&&!node.superObject){
var _64c=_649;
if(node.parameters){
_64c+=node.parameters.length;
}
if(_64c<4){
_642.concat(""+_64c);
}
if(_644){
_642.concat("(");
c(_643,st,"Expression");
}else{
_642.concat("(___r");
_642.concat(st.receiverLevel+"");
}
}
for(var i=0;i<_649;i++){
if(i===0){
_64b+=":";
}else{
_64b+=(_647[i]?_647[i].name:"")+":";
}
}
_642.concat(", \"");
_642.concat(_64b);
_642.concat("\"");
if(node.arguments){
for(var i=0;i<node.arguments.length;i++){
var _64d=node.arguments[i];
_642.concat(", ");
if(!_641){
_640.lastPos=_64d.start;
}
c(_64d,st,"Expression");
if(!_641){
_642.concat(_640.source.substring(_640.lastPos,_64d.end));
_640.lastPos=_64d.end;
}
}
}
if(node.parameters){
for(var i=0;i<node.parameters.length;++i){
var _64e=node.parameters[i];
_642.concat(", ");
if(!_641){
_640.lastPos=_64e.start;
}
c(_64e,st,"Expression");
if(!_641){
_642.concat(_640.source.substring(_640.lastPos,_64e.end));
_640.lastPos=_64e.end;
}
}
}
if(_641&&!node.superObject){
if(_646){
_642.concat(")");
}
if(!_644){
st.receiverLevel--;
}
}
_642.concat(")");
if(!_641){
_640.lastPos=node.end;
}
},SelectorLiteralExpression:function(node,st,c){
var _64f=st.compiler,_650=_64f.jsBuffer,_651=_64f.generate;
if(!_651){
_650.concat(_64f.source.substring(_64f.lastPos,node.start));
_650.concat(" ");
}
_650.concat("sel_getUid(\"");
_650.concat(node.selector);
_650.concat("\")");
if(!_651){
_64f.lastPos=node.end;
}
},ProtocolLiteralExpression:function(node,st,c){
var _652=st.compiler,_653=_652.jsBuffer,_654=_652.generate;
if(!_654){
_653.concat(_652.source.substring(_652.lastPos,node.start));
_653.concat(" ");
}
_653.concat("objj_getProtocol(\"");
_653.concat(node.id.name);
_653.concat("\")");
if(!_654){
_652.lastPos=node.end;
}
},Reference:function(node,st,c){
var _655=st.compiler,_656=_655.jsBuffer,_657=_655.generate;
if(!_657){
_656.concat(_655.source.substring(_655.lastPos,node.start));
_656.concat(" ");
}
_656.concat("function(__input) { if (arguments.length) return ");
c(node.element,st,"Expression");
_656.concat(" = __input; return ");
c(node.element,st,"Expression");
_656.concat("; }");
if(!_657){
_655.lastPos=node.end;
}
},Dereference:function(node,st,c){
var _658=st.compiler,_659=_658.generate;
_571(st,node.expr);
if(!_659){
_658.jsBuffer.concat(_658.source.substring(_658.lastPos,node.start));
_658.lastPos=node.expr.start;
}
c(node.expr,st,"Expression");
if(!_659){
_658.jsBuffer.concat(_658.source.substring(_658.lastPos,node.expr.end));
}
_658.jsBuffer.concat("()");
if(!_659){
_658.lastPos=node.end;
}
},ClassStatement:function(node,st,c){
var _65a=st.compiler;
if(!_65a.generate){
_65a.jsBuffer.concat(_65a.source.substring(_65a.lastPos,node.start));
_65a.lastPos=node.start;
_65a.jsBuffer.concat("//");
}
var _65b=node.id.name;
if(_65a.getTypeDef(_65b)){
throw _65a.error_message(_65b+" is already declared as a type",node.id);
}
if(!_65a.getClassDef(_65b)){
classDef=new _4f0(false,_65b);
_65a.classDefs[_65b]=classDef;
}
st.vars[node.id.name]={type:"class",node:node.id};
},GlobalStatement:function(node,st,c){
var _65c=st.compiler;
if(!_65c.generate){
_65c.jsBuffer.concat(_65c.source.substring(_65c.lastPos,node.start));
_65c.lastPos=node.start;
_65c.jsBuffer.concat("//");
}
st.rootScope().vars[node.id.name]={type:"global",node:node.id};
},PreprocessStatement:function(node,st,c){
var _65d=st.compiler;
if(!_65d.generate){
_65d.jsBuffer.concat(_65d.source.substring(_65d.lastPos,node.start));
_65d.lastPos=node.start;
_65d.jsBuffer.concat("//");
}
},TypeDefStatement:function(node,st,c){
var _65e=st.compiler,_65f=_65e.generate,_660=_65e.jsBuffer,_661=node.typedefname.name,_662=_65e.getTypeDef(_661),_663=new _4e3(st);
if(_662){
throw _65e.error_message("Duplicate type definition "+_661,node.typedefname);
}
if(_65e.getClassDef(_661)){
throw _65e.error_message(_661+" is already declared as class",node.typedefname);
}
_65e.imBuffer=new _2bf();
_65e.cmBuffer=new _2bf();
if(!_65f){
_660.concat(_65e.source.substring(_65e.lastPos,node.start));
}
_660.concat("{var the_typedef = objj_allocateTypeDef(\""+_661+"\");");
_662=new _521(_661);
_65e.typeDefs[_661]=_662;
_663.typeDef=_662;
_660.concat("\nobjj_registerTypeDef(the_typedef);\n");
_660.concat("}");
_65e.jsBuffer=_660;
if(!_65f){
_65e.lastPos=node.end;
}
}});
function _2fd(aURL,_664){
this._URL=aURL;
this._isLocal=_664;
};
_2.FileDependency=_2fd;
_2fd.prototype.URL=function(){
return this._URL;
};
_2fd.prototype.isLocal=function(){
return this._isLocal;
};
_2fd.prototype.toMarkedString=function(){
var _665=this.URL().absoluteString();
return (this.isLocal()?_245:_244)+";"+_665.length+";"+_665;
};
_2fd.prototype.toString=function(){
return (this.isLocal()?"LOCAL: ":"STD: ")+this.URL();
};
var _666=0,_667=1,_668=2,_669=0;
function _2ce(_66a,_66b,aURL,_66c,_66d,_66e){
if(arguments.length===0){
return this;
}
this._code=_66a;
this._function=_66c||null;
this._URL=_1df(aURL||new CFURL("(Anonymous"+(_669++)+")"));
this._compiler=_66d||null;
this._fileDependencies=_66b;
this._filenameTranslateDictionary=_66e;
if(_66b.length){
this._fileDependencyStatus=_666;
this._fileDependencyCallbacks=[];
}else{
this._fileDependencyStatus=_668;
}
if(this._function){
return;
}
if(!_66d){
this.setCode(_66a);
}
};
_2.Executable=_2ce;
_2ce.prototype.path=function(){
return this.URL().path();
};
_2ce.prototype.URL=function(){
return this._URL;
};
_2ce.prototype.functionParameters=function(){
var _66f=["global","objj_executeFile","objj_importFile"];
return _66f;
};
_2ce.prototype.functionArguments=function(){
var _670=[_1,this.fileExecuter(),this.fileImporter()];
return _670;
};
_2ce.prototype.execute=function(){
if(this._compiler){
var _671=this.fileDependencies(),_9d=0,_672=_671.length;
this._compiler.pushImport(this.URL().lastPathComponent());
for(;_9d<_672;++_9d){
var _673=_671[_9d],_674=_673.isLocal(),URL=_673.URL();
this.fileExecuter()(URL,_674);
}
this._compiler.popImport();
this.setCode(this._compiler.compilePass2());
this._compiler=null;
}
var _675=_676;
_676=CFBundle.bundleContainingURL(this.URL());
var _677=this._function.apply(_1,this.functionArguments());
_676=_675;
return _677;
};
_2ce.prototype.code=function(){
return this._code;
};
_2ce.prototype.setCode=function(code){
this._code=code;
var _678=this.functionParameters().join(",");
this._function=new Function(_678,code);
};
_2ce.prototype.fileDependencies=function(){
return this._fileDependencies;
};
_2ce.prototype.hasLoadedFileDependencies=function(){
return this._fileDependencyStatus===_668;
};
var _679=0,_67a=[],_67b={};
_2ce.prototype.loadFileDependencies=function(_67c){
var _67d=this._fileDependencyStatus;
if(_67c){
if(_67d===_668){
return _67c();
}
this._fileDependencyCallbacks.push(_67c);
}
if(_67d===_666){
if(_679){
throw "Can't load";
}
_67e(this);
}
};
function _67e(_67f){
_67a.push(_67f);
_67f._fileDependencyStatus=_667;
var _680=_67f.fileDependencies(),_9d=0,_681=_680.length,_682=_67f.referenceURL(),_683=_682.absoluteString(),_684=_67f.fileExecutableSearcher();
_679+=_681;
for(;_9d<_681;++_9d){
var _685=_680[_9d],_686=_685.isLocal(),URL=_685.URL(),_687=(_686&&(_683+" ")||"")+URL;
if(_67b[_687]){
if(--_679===0){
_688();
}
continue;
}
_67b[_687]=YES;
_684(URL,_686,_689);
}
};
function _689(_68a){
--_679;
if(_68a._fileDependencyStatus===_666){
_67e(_68a);
}else{
if(_679===0){
_688();
}
}
};
function _688(){
var _68b=_67a,_9d=0,_68c=_68b.length;
_67a=[];
for(;_9d<_68c;++_9d){
_68b[_9d]._fileDependencyStatus=_668;
}
for(_9d=0;_9d<_68c;++_9d){
var _68d=_68b[_9d],_68e=_68d._fileDependencyCallbacks,_68f=0,_690=_68e.length;
for(;_68f<_690;++_68f){
_68e[_68f]();
}
_68d._fileDependencyCallbacks=[];
}
};
_2ce.prototype.referenceURL=function(){
if(this._referenceURL===_2f){
this._referenceURL=new CFURL(".",this.URL());
}
return this._referenceURL;
};
_2ce.prototype.fileImporter=function(){
return _2ce.fileImporterForURL(this.referenceURL());
};
_2ce.prototype.fileExecuter=function(){
return _2ce.fileExecuterForURL(this.referenceURL());
};
_2ce.prototype.fileExecutableSearcher=function(){
return _2ce.fileExecutableSearcherForURL(this.referenceURL());
};
var _691={};
_2ce.fileExecuterForURL=function(aURL){
var _692=_1df(aURL),_693=_692.absoluteString(),_694=_691[_693];
if(!_694){
_694=function(aURL,_695,_696){
_2ce.fileExecutableSearcherForURL(_692)(aURL,_695,function(_697){
if(!_697.hasLoadedFileDependencies()){
throw "No executable loaded for file at URL "+aURL;
}
_697.execute(_696);
});
};
_691[_693]=_694;
}
return _694;
};
var _698={};
_2ce.fileImporterForURL=function(aURL){
var _699=_1df(aURL),_69a=_699.absoluteString(),_69b=_698[_69a];
if(!_69b){
_69b=function(aURL,_69c,_69d){
_17b();
_2ce.fileExecutableSearcherForURL(_699)(aURL,_69c,function(_69e){
_69e.loadFileDependencies(function(){
_69e.execute();
_17c();
if(_69d){
_69d();
}
});
});
};
_698[_69a]=_69b;
}
return _69b;
};
var _69f={},_6a0={};
function _25d(x){
var _6a1=0;
for(var k in x){
if(x.hasOwnProperty(k)){
++_6a1;
}
}
return _6a1;
};
_2ce.resetCachedFileExecutableSearchers=function(){
_69f={};
_6a0={};
_698={};
_691={};
_67b={};
};
_2ce.fileExecutableSearcherForURL=function(_6a2){
var _6a3=_6a2.absoluteString(),_6a4=_69f[_6a3],_6a5=_2ce.filenameTranslateDictionary?_2ce.filenameTranslateDictionary():null;
cachedSearchResults={};
if(!_6a4){
_6a4=function(aURL,_6a6,_6a7){
var _6a8=(_6a6&&_6a2||"")+aURL,_6a9=_6a0[_6a8];
if(_6a9){
return _6aa(_6a9);
}
var _6ab=(aURL instanceof CFURL)&&aURL.scheme();
if(_6a6||_6ab){
if(!_6ab){
aURL=new CFURL(aURL,_6a2);
}
_1cb.resolveResourceAtURL(aURL,NO,_6aa,_6a5);
}else{
_1cb.resolveResourceAtURLSearchingIncludeURLs(aURL,_6aa);
}
function _6aa(_6ac){
if(!_6ac){
var _6ad=_529?_529.currentCompileFile:null;
throw new Error("Could not load file at "+aURL+(_6ad?" when compiling "+_6ad:""));
}
_6a0[_6a8]=_6ac;
_6a7(new _6ae(_6ac.URL(),_6a5));
};
};
_69f[_6a3]=_6a4;
}
return _6a4;
};
var _6af={};
function _6ae(aURL,_6b0){
aURL=_1df(aURL);
var _6b1=aURL.absoluteString(),_6b2=_6af[_6b1];
if(_6b2){
return _6b2;
}
_6af[_6b1]=this;
var _6b3=_1cb.resourceAtURL(aURL).contents(),_6b4=NULL,_6b5=aURL.pathExtension().toLowerCase();
if(_6b3.match(/^@STATIC;/)){
_6b4=_6b6(_6b3,aURL);
}else{
if((_6b5==="j"||!_6b5)&&!_6b3.match(/^{/)){
_6b4=_2.ObjJAcornCompiler.compileFileDependencies(_6b3,aURL,_529.Flags.IncludeDebugSymbols);
}else{
_6b4=new _2ce(_6b3,[],aURL);
}
}
_2ce.apply(this,[_6b4.code(),_6b4.fileDependencies(),aURL,_6b4._function,_6b4._compiler,_6b0]);
this._hasExecuted=NO;
};
_2.FileExecutable=_6ae;
_6ae.prototype=new _2ce();
_6ae.resetFileExecutables=function(){
_6af={};
_6b7={};
};
_6ae.prototype.execute=function(_6b8){
if(this._hasExecuted&&!_6b8){
return;
}
this._hasExecuted=YES;
_2ce.prototype.execute.call(this);
};
_6ae.prototype.hasExecuted=function(){
return this._hasExecuted;
};
function _6b6(_6b9,aURL){
var _6ba=new _11d(_6b9);
var _6bb=NULL,code="",_6bc=[];
while(_6bb=_6ba.getMarker()){
var text=_6ba.getString();
if(_6bb===_243){
code+=text;
}else{
if(_6bb===_244){
_6bc.push(new _2fd(new CFURL(text),NO));
}else{
if(_6bb===_245){
_6bc.push(new _2fd(new CFURL(text),YES));
}
}
}
}
var fn=_6ae._lookupCachedFunction(aURL);
if(fn){
return new _2ce(code,_6bc,aURL,fn);
}
return new _2ce(code,_6bc,aURL);
};
var _6b7={};
_6ae._cacheFunction=function(aURL,fn){
aURL=typeof aURL==="string"?aURL:aURL.absoluteString();
_6b7[aURL]=fn;
};
_6ae._lookupCachedFunction=function(aURL){
aURL=typeof aURL==="string"?aURL:aURL.absoluteString();
return _6b7[aURL];
};
var _6bd=1,_6be=2,_6bf=4,_6c0=8;
objj_ivar=function(_6c1,_6c2){
this.name=_6c1;
this.type=_6c2;
};
objj_method=function(_6c3,_6c4,_6c5){
this.name=_6c3;
this.method_imp=_6c4;
this.types=_6c5;
};
objj_class=function(_6c6){
this.isa=NULL;
this.version=0;
this.super_class=NULL;
this.sub_classes=[];
this.name=NULL;
this.info=0;
this.ivar_list=[];
this.ivar_store=function(){
};
this.ivar_dtable=this.ivar_store.prototype;
this.method_list=[];
this.method_store=function(){
};
this.method_dtable=this.method_store.prototype;
this.protocol_list=[];
this.allocator=function(){
};
this._UID=-1;
};
objj_protocol=function(_6c7){
this.name=_6c7;
this.instance_methods={};
this.class_methods={};
};
objj_object=function(){
this.isa=NULL;
this._UID=-1;
};
objj_typeDef=function(_6c8){
this.name=_6c8;
};
class_getName=function(_6c9){
if(_6c9==Nil){
return "";
}
return _6c9.name;
};
class_isMetaClass=function(_6ca){
if(!_6ca){
return NO;
}
return ((_6ca.info&(_6be)));
};
class_getSuperclass=function(_6cb){
if(_6cb==Nil){
return Nil;
}
return _6cb.super_class;
};
class_setSuperclass=function(_6cc,_6cd){
_6cc.super_class=_6cd;
_6cc.isa.super_class=_6cd.isa;
};
class_addIvar=function(_6ce,_6cf,_6d0){
var _6d1=_6ce.allocator.prototype;
if(typeof _6d1[_6cf]!="undefined"){
return NO;
}
var ivar=new objj_ivar(_6cf,_6d0);
_6ce.ivar_list.push(ivar);
_6ce.ivar_dtable[_6cf]=ivar;
_6d1[_6cf]=NULL;
return YES;
};
class_addIvars=function(_6d2,_6d3){
var _6d4=0,_6d5=_6d3.length,_6d6=_6d2.allocator.prototype;
for(;_6d4<_6d5;++_6d4){
var ivar=_6d3[_6d4],name=ivar.name;
if(typeof _6d6[name]==="undefined"){
_6d2.ivar_list.push(ivar);
_6d2.ivar_dtable[name]=ivar;
_6d6[name]=NULL;
}
}
};
class_copyIvarList=function(_6d7){
return _6d7.ivar_list.slice(0);
};
class_addMethod=function(_6d8,_6d9,_6da,_6db){
var _6dc=new objj_method(_6d9,_6da,_6db);
_6d8.method_list.push(_6dc);
_6d8.method_dtable[_6d9]=_6dc;
if(!((_6d8.info&(_6be)))&&(((_6d8.info&(_6be)))?_6d8:_6d8.isa).isa===(((_6d8.info&(_6be)))?_6d8:_6d8.isa)){
class_addMethod((((_6d8.info&(_6be)))?_6d8:_6d8.isa),_6d9,_6da,_6db);
}
return YES;
};
class_addMethods=function(_6dd,_6de){
var _6df=0,_6e0=_6de.length,_6e1=_6dd.method_list,_6e2=_6dd.method_dtable;
for(;_6df<_6e0;++_6df){
var _6e3=_6de[_6df];
_6e1.push(_6e3);
_6e2[_6e3.name]=_6e3;
}
if(!((_6dd.info&(_6be)))&&(((_6dd.info&(_6be)))?_6dd:_6dd.isa).isa===(((_6dd.info&(_6be)))?_6dd:_6dd.isa)){
class_addMethods((((_6dd.info&(_6be)))?_6dd:_6dd.isa),_6de);
}
};
class_getInstanceMethod=function(_6e4,_6e5){
if(!_6e4||!_6e5){
return NULL;
}
var _6e6=_6e4.method_dtable[_6e5];
return _6e6?_6e6:NULL;
};
class_getInstanceVariable=function(_6e7,_6e8){
if(!_6e7||!_6e8){
return NULL;
}
var _6e9=_6e7.ivar_dtable[_6e8];
return _6e9;
};
class_getClassMethod=function(_6ea,_6eb){
if(!_6ea||!_6eb){
return NULL;
}
var _6ec=(((_6ea.info&(_6be)))?_6ea:_6ea.isa).method_dtable[_6eb];
return _6ec?_6ec:NULL;
};
class_respondsToSelector=function(_6ed,_6ee){
return class_getClassMethod(_6ed,_6ee)!=NULL;
};
class_copyMethodList=function(_6ef){
return _6ef.method_list.slice(0);
};
class_getVersion=function(_6f0){
return _6f0.version;
};
class_setVersion=function(_6f1,_6f2){
_6f1.version=parseInt(_6f2,10);
};
class_replaceMethod=function(_6f3,_6f4,_6f5){
if(!_6f3||!_6f4){
return NULL;
}
var _6f6=_6f3.method_dtable[_6f4],_6f7=NULL;
if(_6f6){
_6f7=_6f6.method_imp;
}
_6f6.method_imp=_6f5;
return _6f7;
};
class_addProtocol=function(_6f8,_6f9){
if(!_6f9||class_conformsToProtocol(_6f8,_6f9)){
return;
}
(_6f8.protocol_list||(_6f8.protocol_list==[])).push(_6f9);
return true;
};
class_conformsToProtocol=function(_6fa,_6fb){
if(!_6fb){
return false;
}
while(_6fa){
var _6fc=_6fa.protocol_list,size=_6fc?_6fc.length:0;
for(var i=0;i<size;i++){
var p=_6fc[i];
if(p.name===_6fb.name){
return true;
}
if(protocol_conformsToProtocol(p,_6fb)){
return true;
}
}
_6fa=class_getSuperclass(_6fa);
}
return false;
};
class_copyProtocolList=function(_6fd){
var _6fe=_6fd.protocol_list;
return _6fe?_6fe.slice(0):[];
};
protocol_conformsToProtocol=function(p1,p2){
if(!p1||!p2){
return false;
}
if(p1.name===p2.name){
return true;
}
var _6ff=p1.protocol_list,size=_6ff?_6ff.length:0;
for(var i=0;i<size;i++){
var p=_6ff[i];
if(p.name===p2.name){
return true;
}
if(protocol_conformsToProtocol(p,p2)){
return true;
}
}
return false;
};
var _700=Object.create(null);
objj_allocateProtocol=function(_701){
var _702=new objj_protocol(_701);
return _702;
};
objj_registerProtocol=function(_703){
_700[_703.name]=_703;
};
protocol_getName=function(_704){
return _704.name;
};
protocol_addMethodDescription=function(_705,_706,_707,_708,_709){
if(!_705||!_706){
return;
}
if(_708){
(_709?_705.instance_methods:_705.class_methods)[_706]=new objj_method(_706,null,_707);
}
};
protocol_addMethodDescriptions=function(_70a,_70b,_70c,_70d){
if(!_70c){
return;
}
var _70e=0,_70f=_70b.length,_710=_70d?_70a.instance_methods:_70a.class_methods;
for(;_70e<_70f;++_70e){
var _711=_70b[_70e];
_710[_711.name]=_711;
}
};
protocol_copyMethodDescriptionList=function(_712,_713,_714){
if(!_713){
return [];
}
var _715=_714?_712.instance_methods:_712.class_methods,_716=[];
for(var _717 in _715){
if(_715.hasOwnProperty(_717)){
_716.push(_715[_717]);
}
}
return _716;
};
protocol_addProtocol=function(_718,_719){
if(!_718||!_719){
return;
}
(_718.protocol_list||(_718.protocol_list=[])).push(_719);
};
var _71a=Object.create(null);
objj_allocateTypeDef=function(_71b){
var _71c=new objj_typeDef(_71b);
return _71c;
};
objj_registerTypeDef=function(_71d){
_71a[_71d.name]=_71d;
};
typeDef_getName=function(_71e){
return _71e.name;
};
var _71f=function(_720){
var meta=(((_720.info&(_6be)))?_720:_720.isa);
if((_720.info&(_6be))){
_720=objj_getClass(_720.name);
}
if(_720.super_class&&!((((_720.super_class.info&(_6be)))?_720.super_class:_720.super_class.isa).info&(_6bf))){
_71f(_720.super_class);
}
if(!(meta.info&(_6bf))&&!(meta.info&(_6c0))){
meta.info=(meta.info|(_6c0))&~(0);
_720.objj_msgSend=objj_msgSendFast;
_720.objj_msgSend0=objj_msgSendFast0;
_720.objj_msgSend1=objj_msgSendFast1;
_720.objj_msgSend2=objj_msgSendFast2;
_720.objj_msgSend3=objj_msgSendFast3;
meta.objj_msgSend=objj_msgSendFast;
meta.objj_msgSend0=objj_msgSendFast0;
meta.objj_msgSend1=objj_msgSendFast1;
meta.objj_msgSend2=objj_msgSendFast2;
meta.objj_msgSend3=objj_msgSendFast3;
meta.objj_msgSend0(_720,"initialize");
meta.info=(meta.info|(_6bf))&~(_6c0);
}
};
var _721=function(self,_722){
var isa=self.isa,_723=isa.method_dtable[_724];
if(_723){
var _725=_723.method_imp.call(this,self,_724,_722);
if(_725&&_725!==self){
arguments[0]=_725;
return objj_msgSend.apply(this,arguments);
}
}
_723=isa.method_dtable[_726];
if(_723){
var _727=isa.method_dtable[_728];
if(_727){
var _729=_723.method_imp.call(this,self,_726,_722);
if(_729){
var _72a=objj_lookUpClass("CPInvocation");
if(_72a){
var _72b=_72a.isa.objj_msgSend1(_72a,_72c,_729),_9d=0,_72d=arguments.length;
if(_72b!=null){
var _72e=_72b.isa;
for(;_9d<_72d;++_9d){
_72e.objj_msgSend2(_72b,_72f,arguments[_9d],_9d);
}
}
_727.method_imp.call(this,self,_728,_72b);
return _72b==null?null:_72e.objj_msgSend0(_72b,_730);
}
}
}
}
_723=isa.method_dtable[_731];
if(_723){
return _723.method_imp.call(this,self,_731,_722);
}
throw class_getName(isa)+" does not implement doesNotRecognizeSelector:. Did you forget a superclass for "+class_getName(isa)+"?";
};
class_getMethodImplementation=function(_732,_733){
if(!((((_732.info&(_6be)))?_732:_732.isa).info&(_6bf))){
_71f(_732);
}
var _734=_732.method_dtable[_733];
var _735=_734?_734.method_imp:_721;
return _735;
};
var _736=Object.create(null);
objj_enumerateClassesUsingBlock=function(_737){
for(var key in _736){
_737(_736[key]);
}
};
objj_allocateClassPair=function(_738,_739){
var _73a=new objj_class(_739),_73b=new objj_class(_739),_73c=_73a;
if(_738){
_73c=_738;
while(_73c.superclass){
_73c=_73c.superclass;
}
_73a.allocator.prototype=new _738.allocator;
_73a.ivar_dtable=_73a.ivar_store.prototype=new _738.ivar_store;
_73a.method_dtable=_73a.method_store.prototype=new _738.method_store;
_73b.method_dtable=_73b.method_store.prototype=new _738.isa.method_store;
_73a.super_class=_738;
_73b.super_class=_738.isa;
}else{
_73a.allocator.prototype=new objj_object();
}
_73a.isa=_73b;
_73a.name=_739;
_73a.info=_6bd;
_73a._UID=objj_generateObjectUID();
_73b.isa=_73c.isa;
_73b.name=_739;
_73b.info=_6be;
_73b._UID=objj_generateObjectUID();
return _73a;
};
var _676=nil;
objj_registerClassPair=function(_73d){
_1[_73d.name]=_73d;
_736[_73d.name]=_73d;
_1e6(_73d,_676);
};
objj_resetRegisterClasses=function(){
for(var key in _736){
delete _1[key];
}
_736=Object.create(null);
_700=Object.create(null);
_71a=Object.create(null);
_1e9();
};
class_createInstance=function(_73e){
if(!_73e){
throw new Error("*** Attempting to create object with Nil class.");
}
var _73f=new _73e.allocator();
_73f.isa=_73e;
_73f._UID=objj_generateObjectUID();
return _73f;
};
var _740=function(){
};
_740.prototype.member=false;
with(new _740()){
member=true;
}
if(new _740().member){
var _741=class_createInstance;
class_createInstance=function(_742){
var _743=_741(_742);
if(_743){
var _744=_743.isa,_745=_744;
while(_744){
var _746=_744.ivar_list,_747=_746.length;
while(_747--){
_743[_746[_747].name]=NULL;
}
_744=_744.super_class;
}
_743.isa=_745;
}
return _743;
};
}
object_getClassName=function(_748){
if(!_748){
return "";
}
var _749=_748.isa;
return _749?class_getName(_749):"";
};
objj_lookUpClass=function(_74a){
var _74b=_736[_74a];
return _74b?_74b:Nil;
};
objj_getClass=function(_74c){
var _74d=_736[_74c];
if(!_74d){
}
return _74d?_74d:Nil;
};
objj_getClassList=function(_74e,_74f){
for(var _750 in _736){
_74e.push(_736[_750]);
if(_74f&&--_74f===0){
break;
}
}
return _74e.length;
};
objj_getMetaClass=function(_751){
var _752=objj_getClass(_751);
return (((_752.info&(_6be)))?_752:_752.isa);
};
objj_getProtocol=function(_753){
return _700[_753];
};
objj_getTypeDef=function(_754){
return _71a[_754];
};
ivar_getName=function(_755){
return _755.name;
};
ivar_getTypeEncoding=function(_756){
return _756.type;
};
objj_msgSend=function(_757,_758){
if(_757==nil){
return nil;
}
var isa=_757.isa;
if(!((((isa.info&(_6be)))?isa:isa.isa).info&(_6bf))){
_71f(isa);
}
var _759=isa.method_dtable[_758];
var _75a=_759?_759.method_imp:_721;
switch(arguments.length){
case 2:
return _75a(_757,_758);
case 3:
return _75a(_757,_758,arguments[2]);
case 4:
return _75a(_757,_758,arguments[2],arguments[3]);
}
return _75a.apply(_757,arguments);
};
objj_msgSendSuper=function(_75b,_75c){
var _75d=_75b.super_class;
arguments[0]=_75b.receiver;
if(!((((_75d.info&(_6be)))?_75d:_75d.isa).info&(_6bf))){
_71f(_75d);
}
var _75e=_75d.method_dtable[_75c];
var _75f=_75e?_75e.method_imp:_721;
return _75f.apply(_75b.receiver,arguments);
};
objj_msgSendFast=function(_760,_761){
var _762=this.method_dtable[_761],_763=_762?_762.method_imp:_721;
return _763.apply(_760,arguments);
};
var _764=function(_765,_766){
_71f(this);
return this.objj_msgSend.apply(this,arguments);
};
objj_msgSendFast0=function(_767,_768){
var _769=this.method_dtable[_768],_76a=_769?_769.method_imp:_721;
return _76a(_767,_768);
};
var _76b=function(_76c,_76d){
_71f(this);
return this.objj_msgSend0(_76c,_76d);
};
objj_msgSendFast1=function(_76e,_76f,arg0){
var _770=this.method_dtable[_76f],_771=_770?_770.method_imp:_721;
return _771(_76e,_76f,arg0);
};
var _772=function(_773,_774,arg0){
_71f(this);
return this.objj_msgSend1(_773,_774,arg0);
};
objj_msgSendFast2=function(_775,_776,arg0,arg1){
var _777=this.method_dtable[_776],_778=_777?_777.method_imp:_721;
return _778(_775,_776,arg0,arg1);
};
var _779=function(_77a,_77b,arg0,arg1){
_71f(this);
return this.objj_msgSend2(_77a,_77b,arg0,arg1);
};
objj_msgSendFast3=function(_77c,_77d,arg0,arg1,arg2){
var _77e=this.method_dtable[_77d],_77f=_77e?_77e.method_imp:_721;
return _77f(_77c,_77d,arg0,arg1,arg2);
};
var _780=function(_781,_782,arg0,arg1,arg2){
_71f(this);
return this.objj_msgSend3(_781,_782,arg0,arg1,arg2);
};
method_getName=function(_783){
return _783.name;
};
method_getImplementation=function(_784){
return _784.method_imp;
};
method_setImplementation=function(_785,_786){
var _787=_785.method_imp;
_785.method_imp=_786;
return _787;
};
method_exchangeImplementations=function(lhs,rhs){
var _788=method_getImplementation(lhs),_789=method_getImplementation(rhs);
method_setImplementation(lhs,_789);
method_setImplementation(rhs,_788);
};
sel_getName=function(_78a){
return _78a?_78a:"<null selector>";
};
sel_getUid=function(_78b){
return _78b;
};
sel_isEqual=function(lhs,rhs){
return lhs===rhs;
};
sel_registerName=function(_78c){
return _78c;
};
objj_class.prototype.toString=objj_object.prototype.toString=function(){
var isa=this.isa;
if(class_getInstanceMethod(isa,_78d)){
return isa.objj_msgSend0(this,_78d);
}
if(class_isMetaClass(isa)){
return this.name;
}
return "["+isa.name+" Object](-description not implemented)";
};
objj_class.prototype.objj_msgSend=_764;
objj_class.prototype.objj_msgSend0=_76b;
objj_class.prototype.objj_msgSend1=_772;
objj_class.prototype.objj_msgSend2=_779;
objj_class.prototype.objj_msgSend3=_780;
var _78d=sel_getUid("description"),_724=sel_getUid("forwardingTargetForSelector:"),_726=sel_getUid("methodSignatureForSelector:"),_728=sel_getUid("forwardInvocation:"),_731=sel_getUid("doesNotRecognizeSelector:"),_72c=sel_getUid("invocationWithMethodSignature:"),_78e=sel_getUid("setTarget:"),_78f=sel_getUid("setSelector:"),_72f=sel_getUid("setArgument:atIndex:"),_730=sel_getUid("returnValue");
objj_eval=function(_790){
var url=_2.pageURL;
var _791=_2.asyncLoader;
_2.asyncLoader=NO;
var _792=_2.preprocess(_790,url,0);
if(!_792.hasLoadedFileDependencies()){
_792.loadFileDependencies();
}
_1._objj_eval_scope={};
_1._objj_eval_scope.objj_executeFile=_2ce.fileExecuterForURL(url);
_1._objj_eval_scope.objj_importFile=_2ce.fileImporterForURL(url);
var code="with(_objj_eval_scope){"+_792._code+"\n//*/\n}";
var _793;
_793=eval(code);
_2.asyncLoader=_791;
return _793;
};
_2.objj_eval=objj_eval;
_17b();
var _794=new CFURL(window.location.href),_795=document.getElementsByTagName("base"),_796=_795.length;
if(_796>0){
var _797=_795[_796-1],_798=_797&&_797.getAttribute("href");
if(_798){
_794=new CFURL(_798,_794);
}
}
var _799=new CFURL(window.OBJJ_MAIN_FILE||"main.j"),_1e5=new CFURL(".",new CFURL(_799,_794)).absoluteURL(),_79a=new CFURL("..",_1e5).absoluteURL();
if(_1e5===_79a){
_79a=new CFURL(_79a.schemeAndAuthority());
}
_1cb.resourceAtURL(_79a,YES);
_2.pageURL=_794;
_2.bootstrap=function(){
_79b();
};
function _79b(){
_1cb.resolveResourceAtURL(_1e5,YES,function(_79c){
var _79d=_1cb.includeURLs(),_9d=0,_79e=_79d.length;
for(;_9d<_79e;++_9d){
_79c.resourceAtURL(_79d[_9d],YES);
}
_2ce.fileImporterForURL(_1e5)(_799.lastPathComponent(),YES,function(){
_17c();
_7a4(function(){
var _79f=window.location.hash.substring(1),args=[];
if(_79f.length){
args=_79f.split("/");
for(var i=0,_79e=args.length;i<_79e;i++){
args[i]=decodeURIComponent(args[i]);
}
}
var _7a0=window.location.search.substring(1).split("&"),_7a1=new CFMutableDictionary();
for(var i=0,_79e=_7a0.length;i<_79e;i++){
var _7a2=_7a0[i].split("=");
if(!_7a2[0]){
continue;
}
if(_7a2[1]==null){
_7a2[1]=true;
}
_7a1.setValueForKey(decodeURIComponent(_7a2[0]),decodeURIComponent(_7a2[1]));
}
main(args,_7a1);
});
});
});
};
var _7a3=NO;
function _7a4(_7a5){
if(_7a3||document.readyState==="complete"){
return _7a5();
}
if(window.addEventListener){
window.addEventListener("load",_7a5,NO);
}else{
if(window.attachEvent){
window.attachEvent("onload",_7a5);
}
}
};
_7a4(function(){
_7a3=YES;
});
if(typeof OBJJ_AUTO_BOOTSTRAP==="undefined"||OBJJ_AUTO_BOOTSTRAP){
_2.bootstrap();
}
function _1df(aURL){
if(aURL instanceof CFURL&&aURL.scheme()){
return aURL;
}
return new CFURL(aURL,_1e5);
};
objj_importFile=_2ce.fileImporterForURL(_1e5);
objj_executeFile=_2ce.fileExecuterForURL(_1e5);
objj_import=function(){
CPLog.warn("objj_import is deprecated, use objj_importFile instead");
objj_importFile.apply(this,arguments);
};
})(window,ObjectiveJ);

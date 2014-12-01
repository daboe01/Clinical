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
var _9f=this;
this._stateChangeHandler=function(){
_b3(_9f);
};
this._nativeRequest.onreadystatechange=this._stateChangeHandler;
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
CFHTTPRequest.prototype.getAllResponseHeaders=function(){
return this._nativeRequest.getAllResponseHeaders();
};
CFHTTPRequest.prototype.overrideMimeType=function(_a7){
this._mimeType=_a7;
};
CFHTTPRequest.prototype.open=function(_a8,_a9,_aa,_ab,_ac){
this._isOpen=true;
this._URL=_a9;
this._async=_aa;
this._method=_a8;
this._user=_ab;
this._password=_ac;
return this._nativeRequest.open(_a8,_a9,_aa,_ab,_ac);
};
CFHTTPRequest.prototype.send=function(_ad){
if(!this._isOpen){
delete this._nativeRequest.onreadystatechange;
this._nativeRequest.open(this._method,this._URL,this._async,this._user,this._password);
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
return this._nativeRequest.send(_ad);
}
catch(anException){
this._eventDispatcher.dispatchEvent({type:"failure",request:this});
}
};
CFHTTPRequest.prototype.abort=function(){
this._isOpen=false;
return this._nativeRequest.abort();
};
CFHTTPRequest.prototype.addEventListener=function(_ae,_af){
this._eventDispatcher.addEventListener(_ae,_af);
};
CFHTTPRequest.prototype.removeEventListener=function(_b0,_b1){
this._eventDispatcher.removeEventListener(_b0,_b1);
};
CFHTTPRequest.prototype.setWithCredentials=function(_b2){
this._nativeRequest.withCredentials=_b2;
};
CFHTTPRequest.prototype.getWithCredentials=function(){
return this._nativeRequest.withCredentials;
};
function _b3(_b4){
var _b5=_b4._eventDispatcher;
_b5.dispatchEvent({type:"readystatechange",request:_b4});
var _b6=_b4._nativeRequest,_b7=["uninitialized","loading","loaded","interactive","complete"];
if(_b7[_b4.readyState()]==="complete"){
var _b8="HTTP"+_b4.status();
_b5.dispatchEvent({type:_b8,request:_b4});
var _b9=_b4.success()?"success":"failure";
_b5.dispatchEvent({type:_b9,request:_b4});
_b5.dispatchEvent({type:_b7[_b4.readyState()],request:_b4});
}else{
_b5.dispatchEvent({type:_b7[_b4.readyState()],request:_b4});
}
};
function _ba(_bb,_bc,_bd,_be){
var _bf=new CFHTTPRequest();
if(_bb.pathExtension()==="plist"){
_bf.overrideMimeType("text/xml");
}
var _c0=0,_c1=null;
function _c2(_c3){
_be(_c3.loaded-_c0);
_c0=_c3.loaded;
};
function _c4(_c5){
if(_be&&_c1===null){
_be(_c5.request.responseText().length);
}
_bc(_c5);
};
if(_2.asyncLoader){
_bf.onsuccess=_94(_c4);
_bf.onfailure=_94(_bd);
}else{
_bf.onsuccess=_c4;
_bf.onfailure=_bd;
}
if(_be){
var _c6=true;
if(document.all){
_c6=!!window.atob;
}
if(_c6){
try{
_c1=_2.asyncLoader?_94(_c2):_c2;
_bf._nativeRequest.onprogress=_c1;
}
catch(anException){
_c1=null;
}
}
}
_bf.open("GET",_bb.absoluteString(),_2.asyncLoader);
_bf.send("");
};
_2.asyncLoader=YES;
_2.Asynchronous=_94;
_2.determineAndDispatchHTTPRequestEvents=_b3;
var _c7=0;
objj_generateObjectUID=function(){
return _c7++;
};
CFPropertyList=function(){
this._UID=objj_generateObjectUID();
};
CFPropertyList.DTDRE=/^\s*(?:<\?\s*xml\s+version\s*=\s*\"1.0\"[^>]*\?>\s*)?(?:<\!DOCTYPE[^>]*>\s*)?/i;
CFPropertyList.XMLRE=/^\s*(?:<\?\s*xml\s+version\s*=\s*\"1.0\"[^>]*\?>\s*)?(?:<\!DOCTYPE[^>]*>\s*)?<\s*plist[^>]*\>/i;
CFPropertyList.FormatXMLDTD="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">";
CFPropertyList.Format280NorthMagicNumber="280NPLIST";
CFPropertyList.FormatOpenStep=1,CFPropertyList.FormatXML_v1_0=100,CFPropertyList.FormatBinary_v1_0=200,CFPropertyList.Format280North_v1_0=-1000;
CFPropertyList.sniffedFormatOfString=function(_c8){
if(_c8.match(CFPropertyList.XMLRE)){
return CFPropertyList.FormatXML_v1_0;
}
if(_c8.substr(0,CFPropertyList.Format280NorthMagicNumber.length)===CFPropertyList.Format280NorthMagicNumber){
return CFPropertyList.Format280North_v1_0;
}
return NULL;
};
CFPropertyList.dataFromPropertyList=function(_c9,_ca){
var _cb=new CFMutableData();
_cb.setRawString(CFPropertyList.stringFromPropertyList(_c9,_ca));
return _cb;
};
CFPropertyList.stringFromPropertyList=function(_cc,_cd){
if(!_cd){
_cd=CFPropertyList.Format280North_v1_0;
}
var _ce=_cf[_cd];
return _ce["start"]()+_d0(_cc,_ce)+_ce["finish"]();
};
function _d0(_d1,_d2){
var _d3=typeof _d1,_d4=_d1.valueOf(),_d5=typeof _d4;
if(_d3!==_d5){
_d3=_d5;
_d1=_d4;
}
if(_d1===YES||_d1===NO){
_d3="boolean";
}else{
if(_d3==="number"){
if(FLOOR(_d1)===_d1&&(""+_d1).indexOf("e")==-1){
_d3="integer";
}else{
_d3="real";
}
}else{
if(_d3!=="string"){
if(_d1.slice){
_d3="array";
}else{
_d3="dictionary";
}
}
}
}
return _d2[_d3](_d1,_d2);
};
var _cf={};
_cf[CFPropertyList.FormatXML_v1_0]={"start":function(){
return CFPropertyList.FormatXMLDTD+"<plist version = \"1.0\">";
},"finish":function(){
return "</plist>";
},"string":function(_d6){
return "<string>"+_d7(_d6)+"</string>";
},"boolean":function(_d8){
return _d8?"<true/>":"<false/>";
},"integer":function(_d9){
return "<integer>"+_d9+"</integer>";
},"real":function(_da){
return "<real>"+_da+"</real>";
},"array":function(_db,_dc){
var _dd=0,_de=_db.length,_df="<array>";
for(;_dd<_de;++_dd){
_df+=_d0(_db[_dd],_dc);
}
return _df+"</array>";
},"dictionary":function(_e0,_e1){
var _e2=_e0._keys,_9d=0,_e3=_e2.length,_e4="<dict>";
for(;_9d<_e3;++_9d){
var key=_e2[_9d];
_e4+="<key>"+key+"</key>";
_e4+=_d0(_e0.valueForKey(key),_e1);
}
return _e4+"</dict>";
}};
var _e5="A",_e6="D",_e7="f",_e8="d",_e9="S",_ea="T",_eb="F",_ec="K",_ed="E";
_cf[CFPropertyList.Format280North_v1_0]={"start":function(){
return CFPropertyList.Format280NorthMagicNumber+";1.0;";
},"finish":function(){
return "";
},"string":function(_ee){
return _e9+";"+_ee.length+";"+_ee;
},"boolean":function(_ef){
return (_ef?_ea:_eb)+";";
},"integer":function(_f0){
var _f1=""+_f0;
return _e8+";"+_f1.length+";"+_f1;
},"real":function(_f2){
var _f3=""+_f2;
return _e7+";"+_f3.length+";"+_f3;
},"array":function(_f4,_f5){
var _f6=0,_f7=_f4.length,_f8=_e5+";";
for(;_f6<_f7;++_f6){
_f8+=_d0(_f4[_f6],_f5);
}
return _f8+_ed+";";
},"dictionary":function(_f9,_fa){
var _fb=_f9._keys,_9d=0,_fc=_fb.length,_fd=_e6+";";
for(;_9d<_fc;++_9d){
var key=_fb[_9d];
_fd+=_ec+";"+key.length+";"+key;
_fd+=_d0(_f9.valueForKey(key),_fa);
}
return _fd+_ed+";";
}};
var _fe="xml",_ff="#document",_100="plist",_101="key",_102="dict",_103="array",_104="string",_105="date",_106="true",_107="false",_108="real",_109="integer",_10a="data";
var _10b=function(_10c){
var text="",_9d=0,_10d=_10c.length;
for(;_9d<_10d;++_9d){
var node=_10c[_9d];
if(node.nodeType===3||node.nodeType===4){
text+=node.nodeValue;
}else{
if(node.nodeType!==8){
text+=_10b(node.childNodes);
}
}
}
return text;
};
var _10e=function(_10f,_110,_111){
var node=_10f;
node=(node.firstChild);
if(node!==NULL&&((node.nodeType)===8||(node.nodeType)===3)){
while((node=(node.nextSibling))&&((node.nodeType)===8||(node.nodeType)===3)){
}
}
if(node){
return node;
}
if((String(_10f.nodeName))===_103||(String(_10f.nodeName))===_102){
_111.pop();
}else{
if(node===_110){
return NULL;
}
node=_10f;
while((node=(node.nextSibling))&&((node.nodeType)===8||(node.nodeType)===3)){
}
if(node){
return node;
}
}
node=_10f;
while(node){
var next=node;
while((next=(next.nextSibling))&&((next.nodeType)===8||(next.nodeType)===3)){
}
if(next){
return next;
}
var node=(node.parentNode);
if(_110&&node===_110){
return NULL;
}
_111.pop();
}
return NULL;
};
CFPropertyList.propertyListFromData=function(_112,_113){
return CFPropertyList.propertyListFromString(_112.rawString(),_113);
};
CFPropertyList.propertyListFromString=function(_114,_115){
if(!_115){
_115=CFPropertyList.sniffedFormatOfString(_114);
}
if(_115===CFPropertyList.FormatXML_v1_0){
return CFPropertyList.propertyListFromXML(_114);
}
if(_115===CFPropertyList.Format280North_v1_0){
return _116(_114);
}
return NULL;
};
var _e5="A",_e6="D",_e7="f",_e8="d",_e9="S",_ea="T",_eb="F",_ec="K",_ed="E";
function _116(_117){
var _118=new _119(_117),_11a=NULL,key="",_11b=NULL,_11c=NULL,_11d=[],_11e=NULL;
while(_11a=_118.getMarker()){
if(_11a===_ed){
_11d.pop();
continue;
}
var _11f=_11d.length;
if(_11f){
_11e=_11d[_11f-1];
}
if(_11a===_ec){
key=_118.getString();
_11a=_118.getMarker();
}
switch(_11a){
case _e5:
_11b=[];
_11d.push(_11b);
break;
case _e6:
_11b=new CFMutableDictionary();
_11d.push(_11b);
break;
case _e7:
_11b=parseFloat(_118.getString());
break;
case _e8:
_11b=parseInt(_118.getString(),10);
break;
case _e9:
_11b=_118.getString();
break;
case _ea:
_11b=YES;
break;
case _eb:
_11b=NO;
break;
default:
throw new Error("*** "+_11a+" marker not recognized in Plist.");
}
if(!_11c){
_11c=_11b;
}else{
if(_11e){
if(_11e.slice){
_11e.push(_11b);
}else{
_11e.setValueForKey(key,_11b);
}
}
}
}
return _11c;
};
function _d7(_120){
return _120.replace(/&/g,"&amp;").replace(/"/g,"&quot;").replace(/'/g,"&apos;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
};
function _121(_122){
return _122.replace(/&quot;/g,"\"").replace(/&apos;/g,"'").replace(/&lt;/g,"<").replace(/&gt;/g,">").replace(/&amp;/g,"&");
};
function _a2(_123){
if(window.DOMParser){
return (new window.DOMParser().parseFromString(_123,"text/xml").documentElement);
}else{
if(window.ActiveXObject){
XMLNode=new ActiveXObject("Microsoft.XMLDOM");
var _124=_123.match(CFPropertyList.DTDRE);
if(_124){
_123=_123.substr(_124[0].length);
}
XMLNode.loadXML(_123);
return XMLNode;
}
}
return NULL;
};
CFPropertyList.propertyListFromXML=function(_125){
var _126=_125;
if(_125.valueOf&&typeof _125.valueOf()==="string"){
_126=_a2(_125);
}
while(((String(_126.nodeName))===_ff)||((String(_126.nodeName))===_fe)){
_126=(_126.firstChild);
if(_126!==NULL&&((_126.nodeType)===8||(_126.nodeType)===3)){
while((_126=(_126.nextSibling))&&((_126.nodeType)===8||(_126.nodeType)===3)){
}
}
}
if(((_126.nodeType)===10)){
while((_126=(_126.nextSibling))&&((_126.nodeType)===8||(_126.nodeType)===3)){
}
}
if(!((String(_126.nodeName))===_100)){
return NULL;
}
var key="",_127=NULL,_128=NULL,_129=_126,_12a=[],_12b=NULL;
while(_126=_10e(_126,_129,_12a)){
var _12c=_12a.length;
if(_12c){
_12b=_12a[_12c-1];
}
if((String(_126.nodeName))===_101){
key=(_126.textContent||(_126.textContent!==""&&_10b([_126])));
while((_126=(_126.nextSibling))&&((_126.nodeType)===8||(_126.nodeType)===3)){
}
}
switch(String((String(_126.nodeName)))){
case _103:
_127=[];
_12a.push(_127);
break;
case _102:
_127=new CFMutableDictionary();
_12a.push(_127);
break;
case _108:
_127=parseFloat((_126.textContent||(_126.textContent!==""&&_10b([_126]))));
break;
case _109:
_127=parseInt((_126.textContent||(_126.textContent!==""&&_10b([_126]))),10);
break;
case _104:
if((_126.getAttribute("type")==="base64")){
_127=(_126.firstChild)?CFData.decodeBase64ToString((_126.textContent||(_126.textContent!==""&&_10b([_126])))):"";
}else{
_127=_121((_126.firstChild)?(_126.textContent||(_126.textContent!==""&&_10b([_126]))):"");
}
break;
case _105:
var _12d=Date.parseISO8601((_126.textContent||(_126.textContent!==""&&_10b([_126]))));
_127=isNaN(_12d)?new Date():new Date(_12d);
break;
case _106:
_127=YES;
break;
case _107:
_127=NO;
break;
case _10a:
_127=new CFMutableData();
var _12e=(_126.firstChild)?CFData.decodeBase64ToArray((_126.textContent||(_126.textContent!==""&&_10b([_126]))),YES):[];
_127.setBytes(_12e);
break;
default:
throw new Error("*** "+(String(_126.nodeName))+" tag not recognized in Plist.");
}
if(!_128){
_128=_127;
}else{
if(_12b){
if(_12b.slice){
_12b.push(_127);
}else{
_12b.setValueForKey(key,_127);
}
}
}
}
return _128;
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
CFPropertyListCreateXMLData=function(_12f){
return CFPropertyList.dataFromPropertyList(_12f,CFPropertyList.FormatXML_v1_0);
};
CFPropertyListCreateFrom280NorthData=function(data){
return CFPropertyList.propertyListFromData(data,CFPropertyList.Format280North_v1_0);
};
CFPropertyListCreate280NorthData=function(_130){
return CFPropertyList.dataFromPropertyList(_130,CFPropertyList.Format280North_v1_0);
};
CPPropertyListCreateFromData=function(data,_131){
return CFPropertyList.propertyListFromData(data,_131);
};
CPPropertyListCreateData=function(_132,_133){
return CFPropertyList.dataFromPropertyList(_132,_133);
};
CFDictionary=function(_134){
this._keys=[];
this._count=0;
this._buckets={};
this._UID=objj_generateObjectUID();
};
var _135=Array.prototype.indexOf,_82=Object.prototype.hasOwnProperty;
CFDictionary.prototype.copy=function(){
return this;
};
CFDictionary.prototype.mutableCopy=function(){
var _136=new CFMutableDictionary(),keys=this._keys,_137=this._count;
_136._keys=keys.slice();
_136._count=_137;
var _138=0,_139=this._buckets,_13a=_136._buckets;
for(;_138<_137;++_138){
var key=keys[_138];
_13a[key]=_139[key];
}
return _136;
};
CFDictionary.prototype.containsKey=function(aKey){
return _82.apply(this._buckets,[aKey]);
};
CFDictionary.prototype.containsValue=function(_13b){
var keys=this._keys,_13c=this._buckets,_9d=0,_13d=keys.length;
for(;_9d<_13d;++_9d){
if(_13c[keys[_9d]]===_13b){
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
CFDictionary.prototype.countOfValue=function(_13e){
var keys=this._keys,_13f=this._buckets,_9d=0,_140=keys.length,_141=0;
for(;_9d<_140;++_9d){
if(_13f[keys[_9d]]===_13e){
++_141;
}
}
return _141;
};
CFDictionary.prototype.keys=function(){
return this._keys.slice();
};
CFDictionary.prototype.valueForKey=function(aKey){
var _142=this._buckets;
if(!_82.apply(_142,[aKey])){
return nil;
}
return _142[aKey];
};
CFDictionary.prototype.toString=function(){
var _143="{\n",keys=this._keys,_9d=0,_144=this._count;
for(;_9d<_144;++_9d){
var key=keys[_9d];
_143+="\t"+key+" = \""+String(this.valueForKey(key)).split("\n").join("\n\t")+"\"\n";
}
return _143+"}";
};
CFMutableDictionary=function(_145){
CFDictionary.apply(this,[]);
};
CFMutableDictionary.prototype=new CFDictionary();
CFMutableDictionary.prototype.copy=function(){
return this.mutableCopy();
};
CFMutableDictionary.prototype.addValueForKey=function(aKey,_146){
if(this.containsKey(aKey)){
return;
}
++this._count;
this._keys.push(aKey);
this._buckets[aKey]=_146;
};
CFMutableDictionary.prototype.removeValueForKey=function(aKey){
var _147=-1;
if(_135){
_147=_135.call(this._keys,aKey);
}else{
var keys=this._keys,_9d=0,_148=keys.length;
for(;_9d<_148;++_9d){
if(keys[_9d]===aKey){
_147=_9d;
break;
}
}
}
if(_147===-1){
return;
}
--this._count;
this._keys.splice(_147,1);
delete this._buckets[aKey];
};
CFMutableDictionary.prototype.removeAllValues=function(){
this._count=0;
this._keys=[];
this._buckets={};
};
CFMutableDictionary.prototype.replaceValueForKey=function(aKey,_149){
if(!this.containsKey(aKey)){
return;
}
this._buckets[aKey]=_149;
};
CFMutableDictionary.prototype.setValueForKey=function(aKey,_14a){
if(_14a===nil||_14a===_2f){
this.removeValueForKey(aKey);
}else{
if(this.containsKey(aKey)){
this.replaceValueForKey(aKey,_14a);
}else{
this.addValueForKey(aKey,_14a);
}
}
};
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
var _14b=CFData.stringToBytes(this.rawString());
this.setBytes(_14b);
}
return this._bytes;
};
CFData.prototype.base64=function(){
if(this._base64===NULL){
var _14c;
if(this._bytes){
_14c=CFData.encodeBase64Array(this._bytes);
}else{
_14c=CFData.encodeBase64String(this.rawString());
}
this.setBase64String(_14c);
}
return this._base64;
};
CFMutableData=function(){
CFData.call(this);
};
CFMutableData.prototype=new CFData();
function _14d(_14e){
this._rawString=NULL;
this._propertyList=NULL;
this._propertyListFormat=NULL;
this._JSONObject=NULL;
this._bytes=NULL;
this._base64=NULL;
};
CFMutableData.prototype.setPropertyList=function(_14f,_150){
_14d(this);
this._propertyList=_14f;
this._propertyListFormat=_150;
};
CFMutableData.prototype.setJSONObject=function(_151){
_14d(this);
this._JSONObject=_151;
};
CFMutableData.prototype.setRawString=function(_152){
_14d(this);
this._rawString=_152;
};
CFMutableData.prototype.setBytes=function(_153){
_14d(this);
this._bytes=_153;
};
CFMutableData.prototype.setBase64String=function(_154){
_14d(this);
this._base64=_154;
};
var _155=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/","="],_156=[];
for(var i=0;i<_155.length;i++){
_156[_155[i].charCodeAt(0)]=i;
}
CFData.decodeBase64ToArray=function(_157,_158){
if(_158){
_157=_157.replace(/[^A-Za-z0-9\+\/\=]/g,"");
}
var pad=(_157[_157.length-1]=="="?1:0)+(_157[_157.length-2]=="="?1:0),_159=_157.length,_15a=[];
var i=0;
while(i<_159){
var bits=(_156[_157.charCodeAt(i++)]<<18)|(_156[_157.charCodeAt(i++)]<<12)|(_156[_157.charCodeAt(i++)]<<6)|(_156[_157.charCodeAt(i++)]);
_15a.push((bits&16711680)>>16);
_15a.push((bits&65280)>>8);
_15a.push(bits&255);
}
if(pad>0){
return _15a.slice(0,-1*pad);
}
return _15a;
};
CFData.encodeBase64Array=function(_15b){
var pad=(3-(_15b.length%3))%3,_15c=_15b.length+pad,_15d=[];
if(pad>0){
_15b.push(0);
}
if(pad>1){
_15b.push(0);
}
var i=0;
while(i<_15c){
var bits=(_15b[i++]<<16)|(_15b[i++]<<8)|(_15b[i++]);
_15d.push(_155[(bits&16515072)>>18]);
_15d.push(_155[(bits&258048)>>12]);
_15d.push(_155[(bits&4032)>>6]);
_15d.push(_155[bits&63]);
}
if(pad>0){
_15d[_15d.length-1]="=";
_15b.pop();
}
if(pad>1){
_15d[_15d.length-2]="=";
_15b.pop();
}
return _15d.join("");
};
CFData.decodeBase64ToString=function(_15e,_15f){
return CFData.bytesToString(CFData.decodeBase64ToArray(_15e,_15f));
};
CFData.decodeBase64ToUtf16String=function(_160,_161){
return CFData.bytesToUtf16String(CFData.decodeBase64ToArray(_160,_161));
};
CFData.bytesToString=function(_162){
return String.fromCharCode.apply(NULL,_162);
};
CFData.stringToBytes=function(_163){
var temp=[];
for(var i=0;i<_163.length;i++){
temp.push(_163.charCodeAt(i));
}
return temp;
};
CFData.encodeBase64String=function(_164){
var temp=[];
for(var i=0;i<_164.length;i++){
temp.push(_164.charCodeAt(i));
}
return CFData.encodeBase64Array(temp);
};
CFData.bytesToUtf16String=function(_165){
var temp=[];
for(var i=0;i<_165.length;i+=2){
temp.push(_165[i+1]<<8|_165[i]);
}
return String.fromCharCode.apply(NULL,temp);
};
CFData.encodeBase64Utf16String=function(_166){
var temp=[];
for(var i=0;i<_166.length;i++){
var c=_166.charCodeAt(i);
temp.push(c&255);
temp.push((c&65280)>>8);
}
return CFData.encodeBase64Array(temp);
};
var _167,_168,_169=0;
function _16a(){
if(++_169!==1){
return;
}
_167={};
_168={};
};
function _16b(){
_169=MAX(_169-1,0);
if(_169!==0){
return;
}
delete _167;
delete _168;
};
var _16c=new RegExp("^"+"(?:"+"([^:/?#]+):"+")?"+"(?:"+"(//)"+"("+"(?:"+"("+"([^:@]*)"+":?"+"([^:@]*)"+")?"+"@"+")?"+"([^:/?#]*)"+"(?::(\\d*))?"+")"+")?"+"([^?#]*)"+"(?:\\?([^#]*))?"+"(?:#(.*))?");
var _16d=["url","scheme","authorityRoot","authority","userInfo","user","password","domain","portNumber","path","queryString","fragment"];
function _16e(aURL){
if(aURL._parts){
return aURL._parts;
}
var _16f=aURL.string(),_170=_16f.match(/^mhtml:/);
if(_170){
_16f=_16f.substr("mhtml:".length);
}
if(_169>0&&_82.call(_168,_16f)){
aURL._parts=_168[_16f];
return aURL._parts;
}
aURL._parts={};
var _171=aURL._parts,_172=_16c.exec(_16f),_9d=_172.length;
while(_9d--){
_171[_16d[_9d]]=_172[_9d]||NULL;
}
_171.portNumber=parseInt(_171.portNumber,10);
if(isNaN(_171.portNumber)){
_171.portNumber=-1;
}
_171.pathComponents=[];
if(_171.path){
var _173=_171.path.split("/"),_174=_171.pathComponents,_175=_173.length;
for(_9d=0;_9d<_175;++_9d){
var _176=_173[_9d];
if(_176){
_174.push(_176);
}else{
if(_9d===0){
_174.push("/");
}
}
}
_171.pathComponents=_174;
}
if(_170){
_171.url="mhtml:"+_171.url;
_171.scheme="mhtml:"+_171.scheme;
}
if(_169>0){
_168[_16f]=_171;
}
return _171;
};
CFURL=function(aURL,_177){
aURL=aURL||"";
if(aURL instanceof CFURL){
if(!_177){
return new CFURL(aURL.absoluteString());
}
var _178=aURL.baseURL();
if(_178){
_177=new CFURL(_178.absoluteURL(),_177);
}
aURL=aURL.string();
}
if(_169>0){
var _179=aURL+" "+(_177&&_177.UID()||"");
if(_82.call(_167,_179)){
return _167[_179];
}
_167[_179]=this;
}
if(aURL.match(/^data:/)){
var _17a={},_9d=_16d.length;
while(_9d--){
_17a[_16d[_9d]]="";
}
_17a.url=aURL;
_17a.scheme="data";
_17a.pathComponents=[];
this._parts=_17a;
this._standardizedURL=this;
this._absoluteURL=this;
}
this._UID=objj_generateObjectUID();
this._string=aURL;
this._baseURL=_177;
};
CFURL.prototype.UID=function(){
return this._UID;
};
var _17b={};
CFURL.prototype.mappedURL=function(){
return _17b[this.absoluteString()]||this;
};
CFURL.setMappedURLForURL=function(_17c,_17d){
_17b[_17c.absoluteString()]=_17d;
};
CFURL.prototype.schemeAndAuthority=function(){
var _17e="",_17f=this.scheme();
if(_17f){
_17e+=_17f+":";
}
var _180=this.authority();
if(_180){
_17e+="//"+_180;
}
return _17e;
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
function _181(aURL){
aURL=aURL.standardizedURL();
var _182=aURL.baseURL();
if(!_182){
return aURL;
}
var _183=((aURL)._parts||_16e(aURL)),_184,_185=_182.absoluteURL(),_186=((_185)._parts||_16e(_185));
if(!_183.scheme&&_183.authorityRoot){
_184=_187(_183);
_184.scheme=_182.scheme();
}else{
if(_183.scheme||_183.authority){
_184=_183;
}else{
_184={};
_184.scheme=_186.scheme;
_184.authority=_186.authority;
_184.userInfo=_186.userInfo;
_184.user=_186.user;
_184.password=_186.password;
_184.domain=_186.domain;
_184.portNumber=_186.portNumber;
_184.queryString=_183.queryString;
_184.fragment=_183.fragment;
var _188=_183.pathComponents;
if(_188.length&&_188[0]==="/"){
_184.path=_183.path;
_184.pathComponents=_188;
}else{
var _189=_186.pathComponents,_18a=_189.concat(_188);
if(!_182.hasDirectoryPath()&&_189.length){
_18a.splice(_189.length-1,1);
}
if(_188.length&&(_188[0]===".."||_188[0]===".")){
_18b(_18a,YES);
}
_184.pathComponents=_18a;
_184.path=_18c(_18a,_188.length<=0||aURL.hasDirectoryPath());
}
}
}
var _18d=_18e(_184),_18f=new CFURL(_18d);
_18f._parts=_184;
_18f._standardizedURL=_18f;
_18f._standardizedString=_18d;
_18f._absoluteURL=_18f;
_18f._absoluteString=_18d;
return _18f;
};
function _18c(_190,_191){
var path=_190.join("/");
if(path.length&&path.charAt(0)==="/"){
path=path.substr(1);
}
if(_191){
path+="/";
}
return path;
};
function _18b(_192,_193){
var _194=0,_195=0,_196=_192.length,_197=_193?_192:[],_198=NO;
for(;_194<_196;++_194){
var _199=_192[_194];
if(_199===""){
continue;
}
if(_199==="."){
_198=_195===0;
continue;
}
if(_199!==".."||_195===0||_197[_195-1]===".."){
_197[_195]=_199;
_195++;
continue;
}
if(_195>0&&_197[_195-1]!=="/"){
--_195;
}
}
if(_198&&_195===0){
_197[_195++]=".";
}
_197.length=_195;
return _197;
};
function _18e(_19a){
var _19b="",_19c=_19a.scheme;
if(_19c){
_19b+=_19c+":";
}
var _19d=_19a.authority;
if(_19d){
_19b+="//"+_19d;
}
_19b+=_19a.path;
var _19e=_19a.queryString;
if(_19e){
_19b+="?"+_19e;
}
var _19f=_19a.fragment;
if(_19f){
_19b+="#"+_19f;
}
return _19b;
};
CFURL.prototype.absoluteURL=function(){
if(this._absoluteURL===_2f){
this._absoluteURL=_181(this);
}
return this._absoluteURL;
};
CFURL.prototype.standardizedURL=function(){
if(this._standardizedURL===_2f){
var _1a0=((this)._parts||_16e(this)),_1a1=_1a0.pathComponents,_1a2=_18b(_1a1,NO);
var _1a3=_18c(_1a2,this.hasDirectoryPath());
if(_1a0.path===_1a3){
this._standardizedURL=this;
}else{
var _1a4=_187(_1a0);
_1a4.pathComponents=_1a2;
_1a4.path=_1a3;
var _1a5=new CFURL(_18e(_1a4),this.baseURL());
_1a5._parts=_1a4;
_1a5._standardizedURL=_1a5;
this._standardizedURL=_1a5;
}
}
return this._standardizedURL;
};
function _187(_1a6){
var _1a7={},_1a8=_16d.length;
while(_1a8--){
var _1a9=_16d[_1a8];
_1a7[_1a9]=_1a6[_1a9];
}
return _1a7;
};
CFURL.prototype.string=function(){
return this._string;
};
CFURL.prototype.authority=function(){
var _1aa=((this)._parts||_16e(this)).authority;
if(_1aa){
return _1aa;
}
var _1ab=this.baseURL();
return _1ab&&_1ab.authority()||"";
};
CFURL.prototype.hasDirectoryPath=function(){
var _1ac=this._hasDirectoryPath;
if(_1ac===_2f){
var path=this.path();
if(!path){
return NO;
}
if(path.charAt(path.length-1)==="/"){
return YES;
}
var _1ad=this.lastPathComponent();
_1ac=_1ad==="."||_1ad==="..";
this._hasDirectoryPath=_1ac;
}
return _1ac;
};
CFURL.prototype.hostName=function(){
return this.authority();
};
CFURL.prototype.fragment=function(){
return ((this)._parts||_16e(this)).fragment;
};
CFURL.prototype.lastPathComponent=function(){
if(this._lastPathComponent===_2f){
var _1ae=this.pathComponents(),_1af=_1ae.length;
if(!_1af){
this._lastPathComponent="";
}else{
this._lastPathComponent=_1ae[_1af-1];
}
}
return this._lastPathComponent;
};
CFURL.prototype.path=function(){
return ((this)._parts||_16e(this)).path;
};
CFURL.prototype.createCopyDeletingLastPathComponent=function(){
var _1b0=((this)._parts||_16e(this)),_1b1=_18b(_1b0.pathComponents,NO);
if(_1b1.length>0){
if(_1b1.length>1||_1b1[0]!=="/"){
_1b1.pop();
}
}
var _1b2=_1b1.length===1&&_1b1[0]==="/";
_1b0.pathComponents=_1b1;
_1b0.path=_1b2?"/":_18c(_1b1,NO);
return new CFURL(_18e(_1b0));
};
CFURL.prototype.pathComponents=function(){
return ((this)._parts||_16e(this)).pathComponents;
};
CFURL.prototype.pathExtension=function(){
var _1b3=this.lastPathComponent();
if(!_1b3){
return NULL;
}
_1b3=_1b3.replace(/^\.*/,"");
var _1b4=_1b3.lastIndexOf(".");
return _1b4<=0?"":_1b3.substring(_1b4+1);
};
CFURL.prototype.queryString=function(){
return ((this)._parts||_16e(this)).queryString;
};
CFURL.prototype.scheme=function(){
var _1b5=this._scheme;
if(_1b5===_2f){
_1b5=((this)._parts||_16e(this)).scheme;
if(!_1b5){
var _1b6=this.baseURL();
_1b5=_1b6&&_1b6.scheme();
}
this._scheme=_1b5;
}
return _1b5;
};
CFURL.prototype.user=function(){
return ((this)._parts||_16e(this)).user;
};
CFURL.prototype.password=function(){
return ((this)._parts||_16e(this)).password;
};
CFURL.prototype.portNumber=function(){
return ((this)._parts||_16e(this)).portNumber;
};
CFURL.prototype.domain=function(){
return ((this)._parts||_16e(this)).domain;
};
CFURL.prototype.baseURL=function(){
return this._baseURL;
};
CFURL.prototype.asDirectoryPathURL=function(){
if(this.hasDirectoryPath()){
return this;
}
var _1b7=this.lastPathComponent();
if(_1b7!=="/"){
_1b7="./"+_1b7;
}
return new CFURL(_1b7+"/",this);
};
function _1b8(aURL){
if(!aURL._resourcePropertiesForKeys){
aURL._resourcePropertiesForKeys=new CFMutableDictionary();
}
return aURL._resourcePropertiesForKeys;
};
CFURL.prototype.resourcePropertyForKey=function(aKey){
return _1b8(this).valueForKey(aKey);
};
CFURL.prototype.setResourcePropertyForKey=function(aKey,_1b9){
_1b8(this).setValueForKey(aKey,_1b9);
};
CFURL.prototype.staticResourceData=function(){
var data=new CFMutableData();
data.setRawString(_1ba.resourceAtURL(this).contents());
return data;
};
function _119(_1bb){
this._string=_1bb;
var _1bc=_1bb.indexOf(";");
this._magicNumber=_1bb.substr(0,_1bc);
this._location=_1bb.indexOf(";",++_1bc);
this._version=_1bb.substring(_1bc,this._location++);
};
_119.prototype.magicNumber=function(){
return this._magicNumber;
};
_119.prototype.version=function(){
return this._version;
};
_119.prototype.getMarker=function(){
var _1bd=this._string,_1be=this._location;
if(_1be>=_1bd.length){
return null;
}
var next=_1bd.indexOf(";",_1be);
if(next<0){
return null;
}
var _1bf=_1bd.substring(_1be,next);
if(_1bf==="e"){
return null;
}
this._location=next+1;
return _1bf;
};
_119.prototype.getString=function(){
var _1c0=this._string,_1c1=this._location;
if(_1c1>=_1c0.length){
return null;
}
var next=_1c0.indexOf(";",_1c1);
if(next<0){
return null;
}
var size=parseInt(_1c0.substring(_1c1,next),10),text=_1c0.substr(next+1,size);
this._location=next+1+size;
return text;
};
var _1c2=0,_1c3=1<<0,_1c4=1<<1,_1c5=1<<2,_1c6=1<<3,_1c7=1<<4;
var _1c8={},_1c9={},_1ca={},_1cb=new Date().getTime(),_1cc=0,_1cd=0;
CFBundle=function(aURL){
aURL=_1ce(aURL).asDirectoryPathURL();
var _1cf=aURL.absoluteString(),_1d0=_1c8[_1cf];
if(_1d0){
return _1d0;
}
_1c8[_1cf]=this;
this._bundleURL=aURL;
this._resourcesDirectoryURL=new CFURL("Resources/",aURL);
this._staticResource=NULL;
this._isValid=NO;
this._loadStatus=_1c2;
this._loadRequests=[];
this._infoDictionary=new CFDictionary();
this._eventDispatcher=new _7d(this);
};
CFBundle.environments=function(){
return ["Browser","ObjJ"];
};
CFBundle.bundleContainingURL=function(aURL){
aURL=new CFURL(".",_1ce(aURL));
var _1d1,_1d2=aURL.absoluteString();
while(!_1d1||_1d1!==_1d2){
var _1d3=_1c8[_1d2];
if(_1d3&&_1d3._isValid){
return _1d3;
}
aURL=new CFURL("..",aURL);
_1d1=_1d2;
_1d2=aURL.absoluteString();
}
return NULL;
};
CFBundle.mainBundle=function(){
return new CFBundle(_1d4);
};
function _1d5(_1d6,_1d7){
if(_1d7){
_1c9[_1d6.name]=_1d7;
}
};
function _1d8(){
_1c8={};
_1c9={};
_1ca={};
_1cc=0;
_1cd=0;
};
CFBundle.bundleForClass=function(_1d9){
return _1c9[_1d9.name]||CFBundle.mainBundle();
};
CFBundle.bundleWithIdentifier=function(_1da){
return _1ca[_1da]||NULL;
};
CFBundle.prototype.bundleURL=function(){
return this._bundleURL.absoluteURL();
};
CFBundle.prototype.resourcesDirectoryURL=function(){
return this._resourcesDirectoryURL;
};
CFBundle.prototype.resourceURL=function(_1db,_1dc,_1dd){
if(_1dc){
_1db=_1db+"."+_1dc;
}
if(_1dd){
_1db=_1dd+"/"+_1db;
}
var _1de=(new CFURL(_1db,this.resourcesDirectoryURL())).mappedURL();
return _1de.absoluteURL();
};
CFBundle.prototype.mostEligibleEnvironmentURL=function(){
if(this._mostEligibleEnvironmentURL===_2f){
this._mostEligibleEnvironmentURL=new CFURL(this.mostEligibleEnvironment()+".environment/",this.bundleURL());
}
return this._mostEligibleEnvironmentURL;
};
CFBundle.prototype.executableURL=function(){
if(this._executableURL===_2f){
var _1df=this.valueForInfoDictionaryKey("CPBundleExecutable");
if(!_1df){
this._executableURL=NULL;
}else{
this._executableURL=new CFURL(_1df,this.mostEligibleEnvironmentURL());
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
var _1e0=this._infoDictionary.valueForKey("CPBundleEnvironmentsWithImageSprites")||[],_9d=_1e0.length,_1e1=this.mostEligibleEnvironment();
while(_9d--){
if(_1e0[_9d]===_1e1){
return YES;
}
}
return NO;
};
CFBundle.prototype.environments=function(){
return this._infoDictionary.valueForKey("CPBundleEnvironments")||["ObjJ"];
};
CFBundle.prototype.mostEligibleEnvironment=function(_1e2){
_1e2=_1e2||this.environments();
var _1e3=CFBundle.environments(),_9d=0,_1e4=_1e3.length,_1e5=_1e2.length;
for(;_9d<_1e4;++_9d){
var _1e6=0,_1e7=_1e3[_9d];
for(;_1e6<_1e5;++_1e6){
if(_1e7===_1e2[_1e6]){
return _1e7;
}
}
}
return NULL;
};
CFBundle.prototype.isLoading=function(){
return this._loadStatus&_1c3;
};
CFBundle.prototype.isLoaded=function(){
return !!(this._loadStatus&_1c7);
};
CFBundle.prototype.load=function(_1e8){
if(this._loadStatus!==_1c2){
return;
}
this._loadStatus=_1c3|_1c4;
var self=this,_1e9=this.bundleURL(),_1ea=new CFURL("..",_1e9);
if(_1ea.absoluteString()===_1e9.absoluteString()){
_1ea=_1ea.schemeAndAuthority();
}
_1ba.resolveResourceAtURL(_1ea,YES,function(_1eb){
var _1ec=_1e9.lastPathComponent();
self._staticResource=_1eb._children[_1ec]||new _1ba(_1e9,_1eb,YES,NO);
function _1ed(_1ee){
self._loadStatus&=~_1c4;
var _1ef=_1ee.request.responsePropertyList();
self._isValid=!!_1ef||CFBundle.mainBundle()===self;
if(_1ef){
self._infoDictionary=_1ef;
var _1f0=self._infoDictionary.valueForKey("CPBundleIdentifier");
if(_1f0){
_1ca[_1f0]=self;
}
}
if(!self._infoDictionary){
_1f2(self,new Error("Could not load bundle at \""+path+"\""));
return;
}
if(self===CFBundle.mainBundle()&&self.valueForInfoDictionaryKey("CPApplicationSize")){
_1cd=self.valueForInfoDictionaryKey("CPApplicationSize").valueForKey("executable")||0;
}
_1f6(self,_1e8);
};
function _1f1(){
self._isValid=CFBundle.mainBundle()===self;
self._loadStatus=_1c2;
_1f2(self,new Error("Could not load bundle at \""+self.bundleURL()+"\""));
};
new _ba(new CFURL("Info.plist",self.bundleURL()),_1ed,_1f1);
});
};
function _1f2(_1f3,_1f4){
_1f5(_1f3._staticResource);
_1f3._eventDispatcher.dispatchEvent({type:"error",error:_1f4,bundle:_1f3});
};
function _1f6(_1f7,_1f8){
if(!_1f7.mostEligibleEnvironment()){
return _1f9();
}
_1fa(_1f7,_1fb,_1f9,_1fc);
_1fd(_1f7,_1fb,_1f9,_1fc);
if(_1f7._loadStatus===_1c3){
return _1fb();
}
function _1f9(_1fe){
var _1ff=_1f7._loadRequests,_200=_1ff.length;
while(_200--){
_1ff[_200].abort();
}
this._loadRequests=[];
_1f7._loadStatus=_1c2;
_1f2(_1f7,_1fe||new Error("Could not recognize executable code format in Bundle "+_1f7));
};
function _1fc(_201){
if((typeof CPApp==="undefined"||!CPApp||!CPApp._finishedLaunching)&&typeof OBJJ_PROGRESS_CALLBACK==="function"){
_1cc+=_201;
var _202=_1cd?MAX(MIN(1,_1cc/_1cd),0):0;
OBJJ_PROGRESS_CALLBACK(_202,_1cd,_1f7.bundlePath());
}
};
function _1fb(){
if(_1f7._loadStatus===_1c3){
_1f7._loadStatus=_1c7;
}else{
return;
}
_1f5(_1f7._staticResource);
function _203(){
_1f7._eventDispatcher.dispatchEvent({type:"load",bundle:_1f7});
};
if(_1f8){
_204(_1f7,_203);
}else{
_203();
}
};
};
function _1fa(_205,_206,_207,_208){
var _209=_205.executableURL();
if(!_209){
return;
}
_205._loadStatus|=_1c5;
new _ba(_209,function(_20a){
try{
_20b(_205,_20a.request.responseText(),_209);
_205._loadStatus&=~_1c5;
_206();
}
catch(anException){
_207(anException);
}
},_207,_208);
};
function _20c(_20d){
return "mhtml:"+new CFURL("MHTMLTest.txt",_20d.mostEligibleEnvironmentURL());
};
function _20e(_20f){
if(_210===_211){
return new CFURL("dataURLs.txt",_20f.mostEligibleEnvironmentURL());
}
if(_210===_212||_210===_213){
return new CFURL("MHTMLPaths.txt",_20f.mostEligibleEnvironmentURL());
}
return NULL;
};
function _1fd(_214,_215,_216,_217){
if(!_214.hasSpritedImages()){
return;
}
_214._loadStatus|=_1c6;
if(!_218()){
return _219(_20c(_214),function(){
_1fd(_214,_215,_216,_217);
});
}
var _21a=_20e(_214);
if(!_21a){
_214._loadStatus&=~_1c6;
return _215();
}
new _ba(_21a,function(_21b){
try{
_20b(_214,_21b.request.responseText(),_21a);
_214._loadStatus&=~_1c6;
_215();
}
catch(anException){
_216(anException);
}
},_216,_217);
};
var _21c=[],_210=-1,_21d=0,_211=1,_212=2,_213=3;
function _218(){
return _210!==-1;
};
function _219(_21e,_21f){
if(_218()){
return;
}
_21c.push(_21f);
if(_21c.length>1){
return;
}
_21c.push(function(){
var size=0,_220=CFBundle.mainBundle().valueForInfoDictionaryKey("CPApplicationSize");
if(!_220){
return;
}
switch(_210){
case _211:
size=_220.valueForKey("data");
break;
case _212:
case _213:
size=_220.valueForKey("mhtml");
break;
}
_1cd+=size;
});
_221([_211,"data:image/gif;base64,R0lGODlhAQABAIAAAMc9BQAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==",_212,_21e+"!test",_213,_21e+"?"+_1cb+"!test"]);
};
function _222(){
var _223=_21c.length;
while(_223--){
_21c[_223]();
}
};
function _221(_224){
if(!("Image" in _1)||_224.length<2){
_210=_21d;
_222();
return;
}
var _225=new Image();
_225.onload=function(){
if(_225.width===1&&_225.height===1){
_210=_224[0];
_222();
}else{
_225.onerror();
}
};
_225.onerror=function(){
_221(_224.slice(2));
};
_225.src=_224[1];
};
function _204(_226,_227){
var _228=[_226._staticResource];
function _229(_22a){
for(;_22a<_228.length;++_22a){
var _22b=_228[_22a];
if(_22b.isNotFound()){
continue;
}
if(_22b.isFile()){
var _22c=new _684(_22b.URL());
if(_22c.hasLoadedFileDependencies()){
_22c.execute();
}else{
_22c.loadFileDependencies(function(){
_229(_22a);
});
return;
}
}else{
if(_22b.URL().absoluteString()===_226.resourcesDirectoryURL().absoluteString()){
continue;
}
var _22d=_22b.children();
for(var name in _22d){
if(_82.call(_22d,name)){
_228.push(_22d[name]);
}
}
}
}
_227();
};
_229(0);
};
var _22e="@STATIC",_22f="p",_230="u",_231="c",_232="t",_233="I",_234="i";
function _20b(_235,_236,_237){
var _238=new _119(_236);
if(_238.magicNumber()!==_22e){
throw new Error("Could not read static file: "+_237);
}
if(_238.version()!=="1.0"){
throw new Error("Could not read static file: "+_237);
}
var _239,_23a=_235.bundleURL(),file=NULL;
while(_239=_238.getMarker()){
var text=_238.getString();
if(_239===_22f){
var _23b=new CFURL(text,_23a),_23c=_1ba.resourceAtURL(new CFURL(".",_23b),YES);
file=new _1ba(_23b,_23c,NO,YES);
}else{
if(_239===_230){
var URL=new CFURL(text,_23a),_23d=_238.getString();
if(_23d.indexOf("mhtml:")===0){
_23d="mhtml:"+new CFURL(_23d.substr("mhtml:".length),_23a);
if(_210===_213){
var _23e=_23d.indexOf("!"),_23f=_23d.substring(0,_23e),_240=_23d.substring(_23e);
_23d=_23f+"?"+_1cb+_240;
}
}
CFURL.setMappedURLForURL(URL,new CFURL(_23d));
var _23c=_1ba.resourceAtURL(new CFURL(".",URL),YES);
new _1ba(URL,_23c,NO,YES);
}else{
if(_239===_232){
file.write(text);
}
}
}
}
};
CFBundle.prototype.addEventListener=function(_241,_242){
this._eventDispatcher.addEventListener(_241,_242);
};
CFBundle.prototype.removeEventListener=function(_243,_244){
this._eventDispatcher.removeEventListener(_243,_244);
};
CFBundle.prototype.onerror=function(_245){
throw _245.error;
};
CFBundle.prototype.bundlePath=function(){
return this.bundleURL().path();
};
CFBundle.prototype.path=function(){
CPLog.warn("CFBundle.prototype.path is deprecated, use CFBundle.prototype.bundlePath instead.");
return this.bundlePath.apply(this,arguments);
};
CFBundle.prototype.pathForResource=function(_246){
return this.resourceURL(_246).absoluteString();
};
var _247={};
function _1ba(aURL,_248,_249,_24a,_24b){
this._parent=_248;
this._eventDispatcher=new _7d(this);
var name=aURL.absoluteURL().lastPathComponent()||aURL.schemeAndAuthority();
this._name=name;
this._URL=aURL;
this._isResolved=!!_24a;
this._filenameTranslateDictionary=_24b;
if(_249){
this._URL=this._URL.asDirectoryPathURL();
}
if(!_248){
_247[name]=this;
}
this._isDirectory=!!_249;
this._isNotFound=NO;
if(_248){
_248._children[name]=this;
}
if(_249){
this._children={};
}else{
this._contents="";
}
};
_1ba.rootResources=function(){
return _247;
};
function _24c(x){
var _24d=0;
for(var k in x){
if(x.hasOwnProperty(k)){
++_24d;
}
}
return _24d;
};
_1ba.resetRootResources=function(){
_247={};
};
_1ba.prototype.filenameTranslateDictionary=function(){
return this._filenameTranslateDictionary||{};
};
_2.StaticResource=_1ba;
function _1f5(_24e){
_24e._isResolved=YES;
_24e._eventDispatcher.dispatchEvent({type:"resolve",staticResource:_24e});
};
_1ba.prototype.resolve=function(){
if(this.isDirectory()){
var _24f=new CFBundle(this.URL());
_24f.onerror=function(){
};
_24f.load(NO);
}else{
var self=this;
function _250(_251){
self._contents=_251.request.responseText();
_1f5(self);
};
function _252(){
self._isNotFound=YES;
_1f5(self);
};
var url=this.URL(),_253=this.filenameTranslateDictionary();
if(_253){
var _254=url.toString(),_255=url.lastPathComponent(),_256=_254.substring(0,_254.length-_255.length),_257=_253[_255];
if(_257&&_254.slice(-_257.length)!==_257){
url=new CFURL(_256+_257);
}
}
new _ba(url,_250,_252);
}
};
_1ba.prototype.name=function(){
return this._name;
};
_1ba.prototype.URL=function(){
return this._URL;
};
_1ba.prototype.contents=function(){
return this._contents;
};
_1ba.prototype.children=function(){
return this._children;
};
_1ba.prototype.parent=function(){
return this._parent;
};
_1ba.prototype.isResolved=function(){
return this._isResolved;
};
_1ba.prototype.write=function(_258){
this._contents+=_258;
};
function _259(_25a){
var _25b=_25a.schemeAndAuthority(),_25c=_247[_25b];
if(!_25c){
_25c=new _1ba(new CFURL(_25b),NULL,YES,YES);
}
return _25c;
};
_1ba.resourceAtURL=function(aURL,_25d){
aURL=_1ce(aURL).absoluteURL();
var _25e=_259(aURL),_25f=aURL.pathComponents(),_9d=0,_260=_25f.length;
for(;_9d<_260;++_9d){
var name=_25f[_9d];
if(_82.call(_25e._children,name)){
_25e=_25e._children[name];
}else{
if(_25d){
if(name!=="/"){
name="./"+name;
}
_25e=new _1ba(new CFURL(name,_25e.URL()),_25e,YES,YES);
}else{
throw new Error("Static Resource at "+aURL+" is not resolved (\""+name+"\")");
}
}
}
return _25e;
};
_1ba.prototype.resourceAtURL=function(aURL,_261){
return _1ba.resourceAtURL(new CFURL(aURL,this.URL()),_261);
};
_1ba.resolveResourceAtURL=function(aURL,_262,_263,_264){
aURL=_1ce(aURL).absoluteURL();
_265(_259(aURL),_262,aURL.pathComponents(),0,_263,_264);
};
_1ba.prototype.resolveResourceAtURL=function(aURL,_266,_267){
_1ba.resolveResourceAtURL(new CFURL(aURL,this.URL()).absoluteURL(),_266,_267);
};
function _265(_268,_269,_26a,_26b,_26c,_26d){
var _26e=_26a.length;
for(;_26b<_26e;++_26b){
var name=_26a[_26b],_26f=_82.call(_268._children,name)&&_268._children[name];
if(!_26f){
_26f=new _1ba(new CFURL(name,_268.URL()),_268,_26b+1<_26e||_269,NO,_26d);
_26f.resolve();
}
if(!_26f.isResolved()){
return _26f.addEventListener("resolve",function(){
_265(_268,_269,_26a,_26b,_26c,_26d);
});
}
if(_26f.isNotFound()){
return _26c(null,new Error("File not found: "+_26a.join("/")));
}
if((_26b+1<_26e)&&_26f.isFile()){
return _26c(null,new Error("File is not a directory: "+_26a.join("/")));
}
_268=_26f;
}
_26c(_268);
};
function _270(aURL,_271,_272){
var _273=_1ba.includeURLs(),_274=new CFURL(aURL,_273[_271]).absoluteURL();
_1ba.resolveResourceAtURL(_274,NO,function(_275){
if(!_275){
if(_271+1<_273.length){
_270(aURL,_271+1,_272);
}else{
_272(NULL);
}
return;
}
_272(_275);
});
};
_1ba.resolveResourceAtURLSearchingIncludeURLs=function(aURL,_276){
_270(aURL,0,_276);
};
_1ba.prototype.addEventListener=function(_277,_278){
this._eventDispatcher.addEventListener(_277,_278);
};
_1ba.prototype.removeEventListener=function(_279,_27a){
this._eventDispatcher.removeEventListener(_279,_27a);
};
_1ba.prototype.isNotFound=function(){
return this._isNotFound;
};
_1ba.prototype.isFile=function(){
return !this._isDirectory;
};
_1ba.prototype.isDirectory=function(){
return this._isDirectory;
};
_1ba.prototype.toString=function(_27b){
if(this.isNotFound()){
return "<file not found: "+this.name()+">";
}
var _27c=this.name();
if(this.isDirectory()){
var _27d=this._children;
for(var name in _27d){
if(_27d.hasOwnProperty(name)){
var _27e=_27d[name];
if(_27b||!_27e.isNotFound()){
_27c+="\n\t"+_27d[name].toString(_27b).split("\n").join("\n\t");
}
}
}
}
return _27c;
};
var _27f=NULL;
_1ba.includeURLs=function(){
if(_27f!==NULL){
return _27f;
}
_27f=[];
if(!_1.OBJJ_INCLUDE_PATHS&&!_1.OBJJ_INCLUDE_URLS){
_27f=["Frameworks","Frameworks/Debug"];
}else{
_27f=(_1.OBJJ_INCLUDE_PATHS||[]).concat(_1.OBJJ_INCLUDE_URLS||[]);
}
var _280=_27f.length;
while(_280--){
_27f[_280]=new CFURL(_27f[_280]).asDirectoryPathURL();
}
return _27f;
};
var _281="accessors",_282="class",_283="end",_284="function",_285="implementation",_286="import",_287="each",_288="outlet",_289="action",_28a="new",_28b="selector",_28c="super",_28d="var",_28e="in",_28f="pragma",_290="mark",_291="=",_292="+",_293="-",_294=":",_295=",",_296=".",_297="*",_298=";",_299="<",_29a="{",_29b="}",_29c=">",_29d="[",_29e="\"",_29f="@",_2a0="#",_2a1="]",_2a2="?",_2a3="(",_2a4=")",_2a5=/^(?:(?:\s+$)|(?:\/(?:\/|\*)))/,_2a6=/^[+-]?\d+(([.]\d+)*([eE][+-]?\d+))?$/,_2a7=/^[a-zA-Z_$](\w|$)*$/;
function _2a8(_2a9){
this._index=-1;
this._tokens=(_2a9+"\n").match(/\/\/.*(\r|\n)?|\/\*(?:.|\n|\r)*?\*\/|\w+\b|[+-]?\d+(([.]\d+)*([eE][+-]?\d+))?|"[^"\\]*(\\[\s\S][^"\\]*)*"|'[^'\\]*(\\[\s\S][^'\\]*)*'|\s+|./g);
this._context=[];
return this;
};
_2a8.prototype.push=function(){
this._context.push(this._index);
};
_2a8.prototype.pop=function(){
this._index=this._context.pop();
};
_2a8.prototype.peek=function(_2aa){
if(_2aa){
this.push();
var _2ab=this.skip_whitespace();
this.pop();
return _2ab;
}
return this._tokens[this._index+1];
};
_2a8.prototype.next=function(){
return this._tokens[++this._index];
};
_2a8.prototype.previous=function(){
return this._tokens[--this._index];
};
_2a8.prototype.last=function(){
if(this._index<0){
return NULL;
}
return this._tokens[this._index-1];
};
_2a8.prototype.skip_whitespace=function(_2ac){
var _2ad;
if(_2ac){
while((_2ad=this.previous())&&_2a5.test(_2ad)){
}
}else{
while((_2ad=this.next())&&_2a5.test(_2ad)){
}
}
return _2ad;
};
_2.Lexer=_2a8;
function _2ae(){
this.atoms=[];
};
_2ae.prototype.toString=function(){
return this.atoms.join("");
};
_2.preprocess=function(_2af,aURL,_2b0){
return new _2b1(_2af,aURL,_2b0).executable();
};
_2.eval=function(_2b2){
return eval(_2.preprocess(_2b2).code());
};
var _2b1=function(_2b3,aURL,_2b4){
this._URL=new CFURL(aURL);
_2b3=_2b3.replace(/^#[^\n]+\n/,"\n");
this._currentSelector="";
this._currentClass="";
this._currentSuperClass="";
this._currentSuperMetaClass="";
this._buffer=new _2ae();
this._preprocessed=NULL;
this._dependencies=[];
this._tokens=new _2a8(_2b3);
this._flags=_2b4;
this._classMethod=false;
this._executable=NULL;
this._classLookupTable={};
this._classVars={};
var _2b5=new objj_class();
for(var i in _2b5){
this._classVars[i]=1;
}
this.preprocess(this._tokens,this._buffer);
};
_2b1.prototype.setClassInfo=function(_2b6,_2b7,_2b8){
this._classLookupTable[_2b6]={superClassName:_2b7,ivars:_2b8};
};
_2b1.prototype.getClassInfo=function(_2b9){
return this._classLookupTable[_2b9];
};
_2b1.prototype.allIvarNamesForClassName=function(_2ba){
var _2bb={},_2bc=this.getClassInfo(_2ba);
while(_2bc){
for(var i in _2bc.ivars){
_2bb[i]=1;
}
_2bc=this.getClassInfo(_2bc.superClassName);
}
return _2bb;
};
_2.Preprocessor=_2b1;
_2b1.Flags={};
_2b1.Flags.IncludeDebugSymbols=1<<0;
_2b1.Flags.IncludeTypeSignatures=1<<1;
_2b1.prototype.executable=function(){
if(!this._executable){
this._executable=new _2bd(this._buffer.toString(),this._dependencies,this._URL);
}
return this._executable;
};
_2b1.prototype.accessors=function(_2be){
var _2bf=_2be.skip_whitespace(),_2c0={};
if(_2bf!=_2a3){
_2be.previous();
return _2c0;
}
while((_2bf=_2be.skip_whitespace())!=_2a4){
var name=_2bf,_2c1=true;
if(!/^\w+$/.test(name)){
throw new SyntaxError(this.error_message("*** @accessors attribute name not valid."));
}
if((_2bf=_2be.skip_whitespace())==_291){
_2c1=_2be.skip_whitespace();
if(!/^\w+$/.test(_2c1)){
throw new SyntaxError(this.error_message("*** @accessors attribute value not valid."));
}
if(name=="setter"){
if((_2bf=_2be.next())!=_294){
throw new SyntaxError(this.error_message("*** @accessors setter attribute requires argument with \":\" at end of selector name."));
}
_2c1+=":";
}
_2bf=_2be.skip_whitespace();
}
_2c0[name]=_2c1;
if(_2bf==_2a4){
break;
}
if(_2bf!=_295){
throw new SyntaxError(this.error_message("*** Expected ',' or ')' in @accessors attribute list."));
}
}
return _2c0;
};
_2b1.prototype.brackets=function(_2c2,_2c3){
var _2c4=[];
while(this.preprocess(_2c2,NULL,NULL,NULL,_2c4[_2c4.length]=[])){
}
if(_2c4[0].length===1){
_2c3.atoms[_2c3.atoms.length]="[";
_2c3.atoms[_2c3.atoms.length]=_2c4[0][0];
_2c3.atoms[_2c3.atoms.length]="]";
}else{
var _2c5=new _2ae();
if(_2c4[0][0].atoms[0]==_28c){
_2c3.atoms[_2c3.atoms.length]="objj_msgSendSuper(";
_2c3.atoms[_2c3.atoms.length]="{ receiver:self, super_class:"+(this._classMethod?this._currentSuperMetaClass:this._currentSuperClass)+" }";
}else{
_2c3.atoms[_2c3.atoms.length]="objj_msgSend(";
_2c3.atoms[_2c3.atoms.length]=_2c4[0][0];
}
_2c5.atoms[_2c5.atoms.length]=_2c4[0][1];
var _2c6=1,_2c7=_2c4.length,_2c8=new _2ae();
for(;_2c6<_2c7;++_2c6){
var pair=_2c4[_2c6];
_2c5.atoms[_2c5.atoms.length]=pair[1];
_2c8.atoms[_2c8.atoms.length]=", "+pair[0];
}
_2c3.atoms[_2c3.atoms.length]=", \"";
_2c3.atoms[_2c3.atoms.length]=_2c5;
_2c3.atoms[_2c3.atoms.length]="\"";
_2c3.atoms[_2c3.atoms.length]=_2c8;
_2c3.atoms[_2c3.atoms.length]=")";
}
};
_2b1.prototype.directive=function(_2c9,_2ca,_2cb){
var _2cc=_2ca?_2ca:new _2ae(),_2cd=_2c9.next();
if(_2cd.charAt(0)==_29e){
_2cc.atoms[_2cc.atoms.length]=_2cd;
}else{
if(_2cd===_282){
_2c9.skip_whitespace();
return;
}else{
if(_2cd===_285){
this.implementation(_2c9,_2cc);
}else{
if(_2cd===_286){
this._import(_2c9);
}else{
if(_2cd===_28b){
this.selector(_2c9,_2cc);
}
}
}
}
}
if(!_2ca){
return _2cc;
}
};
_2b1.prototype.hash=function(_2ce,_2cf){
var _2d0=_2cf?_2cf:new _2ae(),_2d1=_2ce.next();
if(_2d1===_28f){
_2d1=_2ce.skip_whitespace();
if(_2d1===_290){
while((_2d1=_2ce.next()).indexOf("\n")<0){
}
}
}else{
throw new SyntaxError(this.error_message("*** Expected \"pragma\" to follow # but instead saw \""+_2d1+"\"."));
}
};
_2b1.prototype.implementation=function(_2d2,_2d3){
var _2d4=_2d3,_2d5="",_2d6=NO,_2d7=_2d2.skip_whitespace(),_2d8="Nil",_2d9=new _2ae(),_2da=new _2ae();
if(!(/^\w/).test(_2d7)){
throw new Error(this.error_message("*** Expected class name, found \""+_2d7+"\"."));
}
this._currentSuperClass="objj_getClass(\""+_2d7+"\").super_class";
this._currentSuperMetaClass="objj_getMetaClass(\""+_2d7+"\").super_class";
this._currentClass=_2d7;
this._currentSelector="";
if((_2d5=_2d2.skip_whitespace())==_2a3){
_2d5=_2d2.skip_whitespace();
if(_2d5==_2a4){
throw new SyntaxError(this.error_message("*** Can't Have Empty Category Name for class \""+_2d7+"\"."));
}
if(_2d2.skip_whitespace()!=_2a4){
throw new SyntaxError(this.error_message("*** Improper Category Definition for class \""+_2d7+"\"."));
}
_2d4.atoms[_2d4.atoms.length]="{\nvar the_class = objj_getClass(\""+_2d7+"\")\n";
_2d4.atoms[_2d4.atoms.length]="if(!the_class) throw new SyntaxError(\"*** Could not find definition for class \\\""+_2d7+"\\\"\");\n";
_2d4.atoms[_2d4.atoms.length]="var meta_class = the_class.isa;";
}else{
if(_2d5==_294){
_2d5=_2d2.skip_whitespace();
if(!_2a7.test(_2d5)){
throw new SyntaxError(this.error_message("*** Expected class name, found \""+_2d5+"\"."));
}
_2d8=_2d5;
_2d5=_2d2.skip_whitespace();
}
_2d4.atoms[_2d4.atoms.length]="{var the_class = objj_allocateClassPair("+_2d8+", \""+_2d7+"\"),\nmeta_class = the_class.isa;";
if(_2d5==_29a){
var _2db={},_2dc=0,_2dd=[],_2de,_2df={},_2e0=[];
while((_2d5=_2d2.skip_whitespace())&&_2d5!=_29b){
if(_2d5===_29f){
_2d5=_2d2.next();
if(_2d5===_281){
_2de=this.accessors(_2d2);
}else{
if(_2d5!==_288){
throw new SyntaxError(this.error_message("*** Unexpected '@' token in ivar declaration ('@"+_2d5+"')."));
}else{
_2e0.push("@"+_2d5);
}
}
}else{
if(_2d5==_298){
if(_2dc++===0){
_2d4.atoms[_2d4.atoms.length]="class_addIvars(the_class, [";
}else{
_2d4.atoms[_2d4.atoms.length]=", ";
}
var name=_2dd[_2dd.length-1];
if(this._flags&_2b1.Flags.IncludeTypeSignatures){
_2d4.atoms[_2d4.atoms.length]="new objj_ivar(\""+name+"\", \""+_2e0.slice(0,_2e0.length-1).join(" ")+"\")";
}else{
_2d4.atoms[_2d4.atoms.length]="new objj_ivar(\""+name+"\")";
}
_2db[name]=1;
_2dd=[];
_2e0=[];
if(_2de){
_2df[name]=_2de;
_2de=NULL;
}
}else{
_2dd.push(_2d5);
_2e0.push(_2d5);
}
}
}
if(_2dd.length){
throw new SyntaxError(this.error_message("*** Expected ';' in ivar declaration, found '}'."));
}
if(_2dc){
_2d4.atoms[_2d4.atoms.length]="]);\n";
}
if(!_2d5){
throw new SyntaxError(this.error_message("*** Expected '}'"));
}
this.setClassInfo(_2d7,_2d8==="Nil"?null:_2d8,_2db);
var _2db=this.allIvarNamesForClassName(_2d7);
for(ivar_name in _2df){
var _2e1=_2df[ivar_name],_2e2=_2e1["property"]||ivar_name;
var _2e3=_2e1["getter"]||_2e2,_2e4="(id)"+_2e3+"\n{\nreturn "+ivar_name+";\n}";
if(_2d9.atoms.length!==0){
_2d9.atoms[_2d9.atoms.length]=",\n";
}
_2d9.atoms[_2d9.atoms.length]=this.method(new _2a8(_2e4),_2db);
if(_2e1["readonly"]){
continue;
}
var _2e5=_2e1["setter"];
if(!_2e5){
var _2e6=_2e2.charAt(0)=="_"?1:0;
_2e5=(_2e6?"_":"")+"set"+_2e2.substr(_2e6,1).toUpperCase()+_2e2.substring(_2e6+1)+":";
}
var _2e7="(void)"+_2e5+"(id)newValue\n{\n";
if(_2e1["copy"]){
_2e7+="if ("+ivar_name+" !== newValue)\n"+ivar_name+" = [newValue copy];\n}";
}else{
_2e7+=ivar_name+" = newValue;\n}";
}
if(_2d9.atoms.length!==0){
_2d9.atoms[_2d9.atoms.length]=",\n";
}
_2d9.atoms[_2d9.atoms.length]=this.method(new _2a8(_2e7),_2db);
}
}else{
_2d2.previous();
}
_2d4.atoms[_2d4.atoms.length]="objj_registerClassPair(the_class);\n";
}
if(!_2db){
var _2db=this.allIvarNamesForClassName(_2d7);
}
while((_2d5=_2d2.skip_whitespace())){
if(_2d5==_292){
this._classMethod=true;
if(_2da.atoms.length!==0){
_2da.atoms[_2da.atoms.length]=", ";
}
_2da.atoms[_2da.atoms.length]=this.method(_2d2,this._classVars);
}else{
if(_2d5==_293){
this._classMethod=false;
if(_2d9.atoms.length!==0){
_2d9.atoms[_2d9.atoms.length]=", ";
}
_2d9.atoms[_2d9.atoms.length]=this.method(_2d2,_2db);
}else{
if(_2d5==_2a0){
this.hash(_2d2,_2d4);
}else{
if(_2d5==_29f){
if((_2d5=_2d2.next())==_283){
break;
}else{
throw new SyntaxError(this.error_message("*** Expected \"@end\", found \"@"+_2d5+"\"."));
}
}
}
}
}
}
if(_2d9.atoms.length!==0){
_2d4.atoms[_2d4.atoms.length]="class_addMethods(the_class, [";
_2d4.atoms[_2d4.atoms.length]=_2d9;
_2d4.atoms[_2d4.atoms.length]="]);\n";
}
if(_2da.atoms.length!==0){
_2d4.atoms[_2d4.atoms.length]="class_addMethods(meta_class, [";
_2d4.atoms[_2d4.atoms.length]=_2da;
_2d4.atoms[_2d4.atoms.length]="]);\n";
}
_2d4.atoms[_2d4.atoms.length]="}";
this._currentClass="";
};
_2b1.prototype._import=function(_2e8){
var _2e9="",_2ea=_2e8.skip_whitespace(),_2eb=(_2ea!==_299);
if(_2ea===_299){
while((_2ea=_2e8.next())&&_2ea!==_29c){
_2e9+=_2ea;
}
if(!_2ea){
throw new SyntaxError(this.error_message("*** Unterminated import statement."));
}
}else{
if(_2ea.charAt(0)===_29e){
_2e9=_2ea.substr(1,_2ea.length-2);
}else{
throw new SyntaxError(this.error_message("*** Expecting '<' or '\"', found \""+_2ea+"\"."));
}
}
this._buffer.atoms[this._buffer.atoms.length]="objj_executeFile(\"";
this._buffer.atoms[this._buffer.atoms.length]=_2e9;
this._buffer.atoms[this._buffer.atoms.length]=_2eb?"\", YES);":"\", NO);";
this._dependencies.push(new _2ec(new CFURL(_2e9),_2eb));
};
_2b1.prototype.method=function(_2ed,_2ee){
var _2ef=new _2ae(),_2f0,_2f1="",_2f2=[],_2f3=[null];
_2ee=_2ee||{};
while((_2f0=_2ed.skip_whitespace())&&_2f0!==_29a&&_2f0!==_298){
if(_2f0==_294){
var type="";
_2f1+=_2f0;
_2f0=_2ed.skip_whitespace();
if(_2f0==_2a3){
while((_2f0=_2ed.skip_whitespace())&&_2f0!=_2a4){
type+=_2f0;
}
_2f0=_2ed.skip_whitespace();
}
_2f3[_2f2.length+1]=type||null;
_2f2[_2f2.length]=_2f0;
if(_2f0 in _2ee){
CPLog.warn(this.error_message("*** Warning: Method ( "+_2f1+" ) uses a parameter name that is already in use ( "+_2f0+" )"));
}
}else{
if(_2f0==_2a3){
var type="";
while((_2f0=_2ed.skip_whitespace())&&_2f0!=_2a4){
type+=_2f0;
}
_2f3[0]=type||null;
}else{
if(_2f0==_295){
if((_2f0=_2ed.skip_whitespace())!=_296||_2ed.next()!=_296||_2ed.next()!=_296){
throw new SyntaxError(this.error_message("*** Argument list expected after ','."));
}
}else{
_2f1+=_2f0;
}
}
}
}
if(_2f0===_298){
_2f0=_2ed.skip_whitespace();
if(_2f0!==_29a){
throw new SyntaxError(this.error_message("Invalid semi-colon in method declaration. "+"Semi-colons are allowed only to terminate the method signature, before the open brace."));
}
}
var _2f4=0,_2f5=_2f2.length;
_2ef.atoms[_2ef.atoms.length]="new objj_method(sel_getUid(\"";
_2ef.atoms[_2ef.atoms.length]=_2f1;
_2ef.atoms[_2ef.atoms.length]="\"), function";
this._currentSelector=_2f1;
if(this._flags&_2b1.Flags.IncludeDebugSymbols){
_2ef.atoms[_2ef.atoms.length]=" $"+this._currentClass+"__"+_2f1.replace(/:/g,"_");
}
_2ef.atoms[_2ef.atoms.length]="(self, _cmd";
for(;_2f4<_2f5;++_2f4){
_2ef.atoms[_2ef.atoms.length]=", ";
_2ef.atoms[_2ef.atoms.length]=_2f2[_2f4];
}
_2ef.atoms[_2ef.atoms.length]=")\n{ with(self)\n{";
_2ef.atoms[_2ef.atoms.length]=this.preprocess(_2ed,NULL,_29b,_29a);
_2ef.atoms[_2ef.atoms.length]="}\n}";
if(this._flags&_2b1.Flags.IncludeDebugSymbols){
_2ef.atoms[_2ef.atoms.length]=","+JSON.stringify(_2f3);
}
_2ef.atoms[_2ef.atoms.length]=")";
this._currentSelector="";
return _2ef;
};
_2b1.prototype.preprocess=function(_2f6,_2f7,_2f8,_2f9,_2fa){
var _2fb=_2f7?_2f7:new _2ae(),_2fc=0,_2fd="";
if(_2fa){
_2fa[0]=_2fb;
var _2fe=false,_2ff=[0,0,0];
}
while((_2fd=_2f6.next())&&((_2fd!==_2f8)||_2fc)){
if(_2fa){
if(_2fd===_2a2){
++_2ff[2];
}else{
if(_2fd===_29a){
++_2ff[0];
}else{
if(_2fd===_29b){
--_2ff[0];
}else{
if(_2fd===_2a3){
++_2ff[1];
}else{
if(_2fd===_2a4){
--_2ff[1];
}else{
if((_2fd===_294&&_2ff[2]--===0||(_2fe=(_2fd===_2a1)))&&_2ff[0]===0&&_2ff[1]===0){
_2f6.push();
var _300=_2fe?_2f6.skip_whitespace(true):_2f6.previous(),_301=_2a5.test(_300);
if(_301||_2a7.test(_300)&&_2a5.test(_2f6.previous())){
_2f6.push();
var last=_2f6.skip_whitespace(true),_302=true,_303=false;
if(last==="+"||last==="-"){
if(_2f6.previous()!==last){
_302=false;
}else{
last=_2f6.skip_whitespace(true);
_303=true;
}
}
_2f6.pop();
_2f6.pop();
if(_302&&((!_303&&(last===_29b))||last===_2a4||last===_2a1||last===_296||_2a6.test(last)||last.charAt(last.length-1)==="\""||last.charAt(last.length-1)==="'"||_2a7.test(last)&&!/^(new|return|case|var)$/.test(last))){
if(_301){
_2fa[1]=":";
}else{
_2fa[1]=_300;
if(!_2fe){
_2fa[1]+=":";
}
var _2fc=_2fb.atoms.length;
while(_2fb.atoms[_2fc--]!==_300){
}
_2fb.atoms.length=_2fc;
}
return !_2fe;
}
if(_2fe){
return NO;
}
}
_2f6.pop();
if(_2fe){
return NO;
}
}
}
}
}
}
}
_2ff[2]=MAX(_2ff[2],0);
}
if(_2f9){
if(_2fd===_2f9){
++_2fc;
}else{
if(_2fd===_2f8){
--_2fc;
}
}
}
if(_2fd===_284){
var _304="";
while((_2fd=_2f6.next())&&_2fd!==_2a3&&!(/^\w/).test(_2fd)){
_304+=_2fd;
}
if(_2fd===_2a3){
if(_2f9===_2a3){
++_2fc;
}
_2fb.atoms[_2fb.atoms.length]="function"+_304+"(";
if(_2fa){
++_2ff[1];
}
}else{
_2fb.atoms[_2fb.atoms.length]=_2fd+" = function";
}
}else{
if(_2fd==_29f){
this.directive(_2f6,_2fb);
}else{
if(_2fd==_2a0){
this.hash(_2f6,_2fb);
}else{
if(_2fd==_29d){
this.brackets(_2f6,_2fb);
}else{
_2fb.atoms[_2fb.atoms.length]=_2fd;
}
}
}
}
}
if(_2fa){
throw new SyntaxError(this.error_message("*** Expected ']' - Unterminated message send or array."));
}
if(!_2f7){
return _2fb;
}
};
_2b1.prototype.selector=function(_305,_306){
var _307=_306?_306:new _2ae();
_307.atoms[_307.atoms.length]="sel_getUid(\"";
if(_305.skip_whitespace()!=_2a3){
throw new SyntaxError(this.error_message("*** Expected '('"));
}
var _308=_305.skip_whitespace();
if(_308==_2a4){
throw new SyntaxError(this.error_message("*** Unexpected ')', can't have empty @selector()"));
}
_306.atoms[_306.atoms.length]=_308;
var _309,_30a=true;
while((_309=_305.next())&&_309!=_2a4){
if(_30a&&/^\d+$/.test(_309)||!(/^(\w|$|\:)/.test(_309))){
if(!(/\S/).test(_309)){
if(_305.skip_whitespace()==_2a4){
break;
}else{
throw new SyntaxError(this.error_message("*** Unexpected whitespace in @selector()."));
}
}else{
throw new SyntaxError(this.error_message("*** Illegal character '"+_309+"' in @selector()."));
}
}
_307.atoms[_307.atoms.length]=_309;
_30a=(_309==_294);
}
_307.atoms[_307.atoms.length]="\")";
if(!_306){
return _307;
}
};
_2b1.prototype.error_message=function(_30b){
return _30b+" <Context File: "+this._URL+(this._currentClass?" Class: "+this._currentClass:"")+(this._currentSelector?" Method: "+this._currentSelector:"")+">";
};
if(typeof _2!="undefined"&&!_2.acorn){
_2.acorn={};
_2.acorn.walk={};
}
(function(_30c){
"use strict";
_30c.version="0.1.01";
var _30d,_30e,_30f,_310;
_30c.parse=function(inpt,opts){
_30e=String(inpt);
_30f=_30e.length;
_311(opts);
_312();
return _313(_30d.program);
};
var _314=_30c.defaultOptions={ecmaVersion:5,strictSemicolons:false,allowTrailingCommas:true,forbidReserved:false,trackComments:false,trackSpaces:false,locations:false,ranges:false,program:null,sourceFile:null,objj:true,preprocess:true,preprocessAddMacro:_315,preprocessGetMacro:_316,preprocessUndefineMacro:_317,preprocessIsMacro:_318};
function _311(opts){
_30d=opts||{};
for(var opt in _314){
if(!_30d.hasOwnProperty(opt)){
_30d[opt]=_314[opt];
}
}
_310=_30d.sourceFile||null;
};
var _319;
var _31a;
function _315(_31b){
_319[_31b.identifier]=_31b;
_31a=null;
};
function _316(_31c){
return _319[_31c];
};
function _317(_31d){
delete _319[_31d];
_31a=null;
};
function _318(_31e){
var x=Object.keys(_319).join(" ");
return (_31a||(_31a=_31f(x)))(_31e);
};
var _320=_30c.getLineInfo=function(_321,_322){
for(var line=1,cur=0;;){
_323.lastIndex=cur;
var _324=_323.exec(_321);
if(_324&&_324.index<_322){
++line;
cur=_324.index+_324[0].length;
}else{
break;
}
}
return {line:line,column:_322-cur,lineStart:cur,lineEnd:(_324?_324.index+_324[0].length:_321.length)};
};
_30c.tokenize=function(inpt,opts){
_30e=String(inpt);
_30f=_30e.length;
_311(opts);
_312();
var t={};
function _325(_326){
_3d0(_326);
t.start=_32e;
t.end=_32f;
t.startLoc=_330;
t.endLoc=_331;
t.type=_332;
t.value=_333;
return t;
};
_325.jumpTo=function(pos,_327){
_328=pos;
if(_30d.locations){
_329=_32a=_323.lastIndex=0;
var _32b;
while((_32b=_323.exec(_30e))&&_32b.index<pos){
++_329;
_32a=_32b.index+_32b[0].length;
}
}
var ch=_30e.charAt(pos-1);
_32c=_327;
_32d();
};
return _325;
};
var _328;
var _32e,_32f;
var _330,_331;
var _332,_333;
var _334,_335,_336;
var _337,_338,_339;
var _32c,_33a,_33b;
var _329,_32a,_33c;
var _33d,_33e;
var _33f,_340,_341;
var _342;
var _343;
var _344,_345,_346;
var _347,_348,_349,_34a,_34b;
var _34c,_34d;
var _34e=[];
var _34f=false;
function _350(pos,_351){
if(typeof pos=="number"){
pos=_320(_30e,pos);
}
var _352=new SyntaxError(_351);
_352.line=pos.line;
_352.column=pos.column;
_352.lineStart=pos.lineStart;
_352.lineEnd=pos.lineEnd;
_352.fileName=_310;
throw _352;
};
var _353={type:"num"},_354={type:"regexp"},_355={type:"string"};
var _356={type:"name"},_357={type:"eof"},_358={type:"eol"};
var _359={keyword:"break"},_35a={keyword:"case",beforeExpr:true},_35b={keyword:"catch"};
var _35c={keyword:"continue"},_35d={keyword:"debugger"},_35e={keyword:"default"};
var _35f={keyword:"do",isLoop:true},_360={keyword:"else",beforeExpr:true};
var _361={keyword:"finally"},_362={keyword:"for",isLoop:true},_363={keyword:"function"};
var _364={keyword:"if"},_365={keyword:"return",beforeExpr:true},_366={keyword:"switch"};
var _367={keyword:"throw",beforeExpr:true},_368={keyword:"try"},_369={keyword:"var"};
var _36a={keyword:"while",isLoop:true},_36b={keyword:"with"},_36c={keyword:"new",beforeExpr:true};
var _36d={keyword:"this"};
var _36e={keyword:"void",prefix:true,beforeExpr:true};
var _36f={keyword:"null",atomValue:null},_370={keyword:"true",atomValue:true};
var _371={keyword:"false",atomValue:false};
var _372={keyword:"in",binop:7,beforeExpr:true};
var _373={keyword:"implementation"},_374={keyword:"outlet"},_375={keyword:"accessors"};
var _376={keyword:"end"},_377={keyword:"import",afterImport:true};
var _378={keyword:"action"},_379={keyword:"selector"},_37a={keyword:"class"},_37b={keyword:"global"};
var _37c={keyword:"{"},_37d={keyword:"["};
var _37e={keyword:"ref"},_37f={keyword:"deref"};
var _380={keyword:"protocol"},_381={keyword:"optional"},_382={keyword:"required"};
var _383={keyword:"interface"};
var _384={keyword:"filename"},_385={keyword:"unsigned",okAsIdent:true},_386={keyword:"signed",okAsIdent:true};
var _387={keyword:"byte",okAsIdent:true},_388={keyword:"char",okAsIdent:true},_389={keyword:"short",okAsIdent:true};
var _38a={keyword:"int",okAsIdent:true},_38b={keyword:"long",okAsIdent:true},_38c={keyword:"id",okAsIdent:true};
var _38d={keyword:"#"};
var _38e={keyword:"define"};
var _38f={keyword:"undef"};
var _390={keyword:"ifdef"};
var _391={keyword:"ifndef"};
var _392={keyword:"if"};
var _393={keyword:"else"};
var _394={keyword:"endif"};
var _395={keyword:"elif"};
var _396={keyword:"pragma"};
var _397={keyword:"defined"};
var _398={keyword:"\\"};
var _399={type:"preprocessParamItem"};
var _39a={"break":_359,"case":_35a,"catch":_35b,"continue":_35c,"debugger":_35d,"default":_35e,"do":_35f,"else":_360,"finally":_361,"for":_362,"function":_363,"if":_364,"return":_365,"switch":_366,"throw":_367,"try":_368,"var":_369,"while":_36a,"with":_36b,"null":_36f,"true":_370,"false":_371,"new":_36c,"in":_372,"instanceof":{keyword:"instanceof",binop:7,beforeExpr:true},"this":_36d,"typeof":{keyword:"typeof",prefix:true,beforeExpr:true},"void":_36e,"delete":{keyword:"delete",prefix:true,beforeExpr:true}};
var _39b={"IBAction":_378,"IBOutlet":_374,"unsigned":_385,"signed":_386,"byte":_387,"char":_388,"short":_389,"int":_38a,"long":_38b,"id":_38c};
var _39c={"implementation":_373,"outlet":_374,"accessors":_375,"end":_376,"import":_377,"action":_378,"selector":_379,"class":_37a,"global":_37b,"ref":_37e,"deref":_37f,"protocol":_380,"optional":_381,"required":_382,"interface":_383};
var _39d={"define":_38e,"pragma":_396,"ifdef":_390,"ifndef":_391,"undef":_38f,"if":_392,"endif":_394,"else":_393,"elif":_395,"defined":_397};
var _39e={type:"[",beforeExpr:true},_39f={type:"]"},_3a0={type:"{",beforeExpr:true};
var _3a1={type:"}"},_3a2={type:"(",beforeExpr:true},_3a3={type:")"};
var _3a4={type:",",beforeExpr:true},_3a5={type:";",beforeExpr:true};
var _3a6={type:":",beforeExpr:true},_3a7={type:"."},_3a8={type:"?",beforeExpr:true};
var _3a9={type:"@"},_3aa={type:"..."},_3ab={type:"#"};
var _3ac={binop:10,beforeExpr:true,preprocess:true},_3ad={isAssign:true,beforeExpr:true,preprocess:true};
var _3ae={isAssign:true,beforeExpr:true},_3af={binop:9,prefix:true,beforeExpr:true,preprocess:true};
var _3b0={postfix:true,prefix:true,isUpdate:true},_3b1={prefix:true,beforeExpr:true};
var _3b2={binop:1,beforeExpr:true,preprocess:true},_3b3={binop:2,beforeExpr:true,preprocess:true};
var _3b4={binop:3,beforeExpr:true,preprocess:true},_3b5={binop:4,beforeExpr:true,preprocess:true};
var _3b6={binop:5,beforeExpr:true,preprocess:true},_3b7={binop:6,beforeExpr:true,preprocess:true};
var _3b8={binop:7,beforeExpr:true,preprocess:true},_3b9={binop:8,beforeExpr:true,preprocess:true};
var _3ba={binop:10,beforeExpr:true,preprocess:true};
_30c.tokTypes={bracketL:_39e,bracketR:_39f,braceL:_3a0,braceR:_3a1,parenL:_3a2,parenR:_3a3,comma:_3a4,semi:_3a5,colon:_3a6,dot:_3a7,question:_3a8,slash:_3ac,eq:_3ad,name:_356,eof:_357,num:_353,regexp:_354,string:_355};
for(var kw in _39a){
_30c.tokTypes[kw]=_39a[kw];
}
function _31f(_3bb){
_3bb=_3bb.split(" ");
var f="",cats=[];
out:
for(var i=0;i<_3bb.length;++i){
for(var j=0;j<cats.length;++j){
if(cats[j][0].length==_3bb[i].length){
cats[j].push(_3bb[i]);
continue out;
}
}
cats.push([_3bb[i]]);
}
function _3bc(arr){
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
_3bc(cat);
}
f+="}";
}else{
_3bc(_3bb);
}
return new Function("str",f);
};
_30c.makePredicate=_31f;
var _3bd=_31f("abstract boolean byte char class double enum export extends final float goto implements import int interface long native package private protected public short static super synchronized throws transient volatile");
var _3be=_31f("class enum extends super const export import");
var _3bf=_31f("implements interface let package private protected public static yield");
var _3c0=_31f("eval arguments");
var _3c1=_31f("break case catch continue debugger default do else finally for function if return switch throw try var while with null true false instanceof typeof void delete new in this");
var _3c2=_31f("IBAction IBOutlet byte char short int long unsigned signed id");
var _3c3=_31f("define pragma if ifdef ifndef else elif endif defined");
var _3c4=/[\u1680\u180e\u2000-\u200a\u2028\u2029\u202f\u205f\u3000\ufeff]/;
var _3c5=/[\u1680\u180e\u2000-\u200a\u202f\u205f\u3000\ufeff]/;
var _3c6="ªµºÀ-ÖØ-öø-ˁˆ-ˑˠ-ˤˬˮͰ-ʹͶͷͺ-ͽΆΈ-ΊΌΎ-ΡΣ-ϵϷ-ҁҊ-ԧԱ-Ֆՙա-ևא-תװ-ײؠ-يٮٯٱ-ۓەۥۦۮۯۺ-ۼۿܐܒ-ܯݍ-ޥޱߊ-ߪߴߵߺࠀ-ࠕࠚࠤࠨࡀ-ࡘࢠࢢ-ࢬऄ-हऽॐक़-ॡॱ-ॷॹ-ॿঅ-ঌএঐও-নপ-রলশ-হঽৎড়ঢ়য়-ৡৰৱਅ-ਊਏਐਓ-ਨਪ-ਰਲਲ਼ਵਸ਼ਸਹਖ਼-ੜਫ਼ੲ-ੴઅ-ઍએ-ઑઓ-નપ-રલળવ-હઽૐૠૡଅ-ଌଏଐଓ-ନପ-ରଲଳଵ-ହଽଡ଼ଢ଼ୟ-ୡୱஃஅ-ஊஎ-ஐஒ-கஙசஜஞடணதந-பம-ஹௐఅ-ఌఎ-ఐఒ-నప-ళవ-హఽౘౙౠౡಅ-ಌಎ-ಐಒ-ನಪ-ಳವ-ಹಽೞೠೡೱೲഅ-ഌഎ-ഐഒ-ഺഽൎൠൡൺ-ൿඅ-ඖක-නඳ-රලව-ෆก-ะาำเ-ๆກຂຄງຈຊຍດ-ທນ-ຟມ-ຣລວສຫອ-ະາຳຽເ-ໄໆໜ-ໟༀཀ-ཇཉ-ཬྈ-ྌက-ဪဿၐ-ၕၚ-ၝၡၥၦၮ-ၰၵ-ႁႎႠ-ჅჇჍა-ჺჼ-ቈቊ-ቍቐ-ቖቘቚ-ቝበ-ኈኊ-ኍነ-ኰኲ-ኵኸ-ኾዀዂ-ዅወ-ዖዘ-ጐጒ-ጕጘ-ፚᎀ-ᎏᎠ-Ᏼᐁ-ᙬᙯ-ᙿᚁ-ᚚᚠ-ᛪᛮ-ᛰᜀ-ᜌᜎ-ᜑᜠ-ᜱᝀ-ᝑᝠ-ᝬᝮ-ᝰក-ឳៗៜᠠ-ᡷᢀ-ᢨᢪᢰ-ᣵᤀ-ᤜᥐ-ᥭᥰ-ᥴᦀ-ᦫᧁ-ᧇᨀ-ᨖᨠ-ᩔᪧᬅ-ᬳᭅ-ᭋᮃ-ᮠᮮᮯᮺ-ᯥᰀ-ᰣᱍ-ᱏᱚ-ᱽᳩ-ᳬᳮ-ᳱᳵᳶᴀ-ᶿḀ-ἕἘ-Ἕἠ-ὅὈ-Ὅὐ-ὗὙὛὝὟ-ώᾀ-ᾴᾶ-ᾼιῂ-ῄῆ-ῌῐ-ΐῖ-Ίῠ-Ῥῲ-ῴῶ-ῼⁱⁿₐ-ₜℂℇℊ-ℓℕℙ-ℝℤΩℨK-ℭℯ-ℹℼ-ℿⅅ-ⅉⅎⅠ-ↈⰀ-Ⱞⰰ-ⱞⱠ-ⳤⳫ-ⳮⳲⳳⴀ-ⴥⴧⴭⴰ-ⵧⵯⶀ-ⶖⶠ-ⶦⶨ-ⶮⶰ-ⶶⶸ-ⶾⷀ-ⷆⷈ-ⷎⷐ-ⷖⷘ-ⷞⸯ々-〇〡-〩〱-〵〸-〼ぁ-ゖゝ-ゟァ-ヺー-ヿㄅ-ㄭㄱ-ㆎㆠ-ㆺㇰ-ㇿ㐀-䶵一-鿌ꀀ-ꒌꓐ-ꓽꔀ-ꘌꘐ-ꘟꘪꘫꙀ-ꙮꙿ-ꚗꚠ-ꛯꜗ-ꜟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꠁꠃ-ꠅꠇ-ꠊꠌ-ꠢꡀ-ꡳꢂ-ꢳꣲ-ꣷꣻꤊ-ꤥꤰ-ꥆꥠ-ꥼꦄ-ꦲꧏꨀ-ꨨꩀ-ꩂꩄ-ꩋꩠ-ꩶꩺꪀ-ꪯꪱꪵꪶꪹ-ꪽꫀꫂꫛ-ꫝꫠ-ꫪꫲ-ꫴꬁ-ꬆꬉ-ꬎꬑ-ꬖꬠ-ꬦꬨ-ꬮꯀ-ꯢ가-힣ힰ-ퟆퟋ-ퟻ豈-舘並-龎ﬀ-ﬆﬓ-ﬗיִײַ-ﬨשׁ-זּטּ-לּמּנּסּףּפּצּ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼＡ-Ｚａ-ｚｦ-ﾾￂ-ￇￊ-ￏￒ-ￗￚ-ￜ";
var _3c7="ͱ-ʹ҃-֑҇-ׇֽֿׁׂׅׄؐ-ؚؠ-ىٲ-ۓۧ-ۨۻ-ۼܰ-݊ࠀ-ࠔࠛ-ࠣࠥ-ࠧࠩ-࠭ࡀ-ࡗࣤ-ࣾऀ-ःऺ-़ा-ॏ॑-ॗॢ-ॣ०-९ঁ-ঃ়া-ৄেৈৗয়-ৠਁ-ਃ਼ਾ-ੂੇੈੋ-੍ੑ੦-ੱੵઁ-ઃ઼ા-ૅે-ૉો-્ૢ-ૣ૦-૯ଁ-ଃ଼ା-ୄେୈୋ-୍ୖୗୟ-ୠ୦-୯ஂா-ூெ-ைொ-்ௗ௦-௯ఁ-ఃె-ైొ-్ౕౖౢ-ౣ౦-౯ಂಃ಼ಾ-ೄೆ-ೈೊ-್ೕೖೢ-ೣ೦-೯ംഃെ-ൈൗൢ-ൣ൦-൯ංඃ්ා-ුූෘ-ෟෲෳิ-ฺเ-ๅ๐-๙ິ-ູ່-ໍ໐-໙༘༙༠-༩༹༵༷ཁ-ཇཱ-྄྆-྇ྍ-ྗྙ-ྼ࿆က-ဩ၀-၉ၧ-ၭၱ-ၴႂ-ႍႏ-ႝ፝-፟ᜎ-ᜐᜠ-ᜰᝀ-ᝐᝲᝳក-ឲ៝០-៩᠋-᠍᠐-᠙ᤠ-ᤫᤰ-᤻ᥑ-ᥭᦰ-ᧀᧈ-ᧉ᧐-᧙ᨀ-ᨕᨠ-ᩓ᩠-᩿᩼-᪉᪐-᪙ᭆ-ᭋ᭐-᭙᭫-᭳᮰-᮹᯦-᯳ᰀ-ᰢ᱀-᱉ᱛ-ᱽ᳐-᳒ᴀ-ᶾḁ-ἕ‌‍‿⁀⁔⃐-⃥⃜⃡-⃰ⶁ-ⶖⷠ-ⷿ〡-〨゙゚Ꙁ-ꙭꙴ-꙽ꚟ꛰-꛱ꟸ-ꠀ꠆ꠋꠣ-ꠧꢀ-ꢁꢴ-꣄꣐-꣙ꣳ-ꣷ꤀-꤉ꤦ-꤭ꤰ-ꥅꦀ-ꦃ꦳-꧀ꨀ-ꨧꩀ-ꩁꩌ-ꩍ꩐-꩙ꩻꫠ-ꫩꫲ-ꫳꯀ-ꯡ꯬꯭꯰-꯹ﬠ-ﬨ︀-️︠-︦︳︴﹍-﹏０-９＿";
var _3c8=new RegExp("["+_3c6+"]");
var _3c9=new RegExp("["+_3c6+_3c7+"]");
var _3ca=/[\n\r\u2028\u2029]/;
var _323=/\r\n|[\n\r\u2028\u2029]/g;
function _3cb(code){
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
return code>=170&&_3c8.test(String.fromCharCode(code));
};
function _3cc(code){
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
return code>=170&&_3c9.test(String.fromCharCode(code));
};
function _3cd(){
this.line=_329;
this.column=_328-_32a;
};
function _312(){
_319=Object.create(null);
_329=1;
_328=_32a=0;
_32c=true;
_33a=null;
_33b=null;
_32d();
};
var _3ce=[_392,_390,_391,_393,_395,_394];
function _3cf(type,val){
if(type in _3ce){
return _3d0();
}
_32f=_328;
if(_30d.locations){
_331=new _3cd;
}
_332=type;
_32d();
if(_30d.preprocess&&_30e.charCodeAt(_328)===35&&_30e.charCodeAt(_328+1)===35){
var val1=type===_356?val:type.keyword;
_328+=2;
if(val1){
_32d();
_3d0();
var val2=_332===_356?_333:_332.keyword;
if(val2){
var _3d1=""+val1+val2,code=_3d1.charCodeAt(0),tok;
if(_3cb(code)){
tok=_3d2(_3d1)!==false;
}
if(tok){
return tok;
}
tok=_3d3(code,_3cf);
if(tok===false){
_3d4();
}
return tok;
}else{
}
}
}
_333=val;
_336=_335;
_339=_338;
_335=_33a;
_338=_33b;
_32c=type.beforeExpr;
_342=type.afterImport;
};
function _3d5(){
var _3d6=_30d.onComment&&_30d.locations&&new _3cd;
var _3d7=_328,end=_30e.indexOf("*/",_328+=2);
if(end===-1){
_350(_328-2,"Unterminated comment");
}
_328=end+2;
if(_30d.locations){
_323.lastIndex=_3d7;
var _3d8;
while((_3d8=_323.exec(_30e))&&_3d8.index<_328){
++_329;
_32a=_3d8.index+_3d8[0].length;
}
}
if(_30d.onComment){
_30d.onComment(true,_30e.slice(_3d7+2,end),_3d7,_328,_3d6,_30d.locations&&new _3cd);
}
if(_30d.trackComments){
(_33a||(_33a=[])).push(_30e.slice(_3d7,end));
}
};
function _3d9(){
var _3da=_328;
var _3db=_30d.onComment&&_30d.locations&&new _3cd;
var ch=_30e.charCodeAt(_328+=2);
while(_328<_30f&&ch!==10&&ch!==13&&ch!==8232&&ch!==8329){
++_328;
ch=_30e.charCodeAt(_328);
}
if(_30d.onComment){
_30d.onComment(false,_30e.slice(_3da+2,_328),_3da,_328,_3db,_30d.locations&&new _3cd);
}
if(_30d.trackComments){
(_33a||(_33a=[])).push(_30e.slice(_3da,_328));
}
};
function _3dc(){
var ch=_30e.charCodeAt(_328);
var last;
while(_328<_30f&&((ch!==10&&ch!==13&&ch!==8232&&ch!==8329)||last===92)){
if(ch!=32&&ch!=9&&ch!=160&&(ch<5760||!_3c5.test(String.fromCharCode(ch)))){
last=ch;
}
ch=_30e.charCodeAt(++_328);
}
};
function _32d(){
_33a=null;
_33b=null;
var _3dd=_328;
for(;;){
var ch=_30e.charCodeAt(_328);
if(ch===32){
++_328;
}else{
if(ch===13){
++_328;
var next=_30e.charCodeAt(_328);
if(next===10){
++_328;
}
if(_30d.locations){
++_329;
_32a=_328;
}
}else{
if(ch===10){
++_328;
++_329;
_32a=_328;
}else{
if(ch<14&&ch>8){
++_328;
}else{
if(ch===47){
var next=_30e.charCodeAt(_328+1);
if(next===42){
if(_30d.trackSpaces){
(_33b||(_33b=[])).push(_30e.slice(_3dd,_328));
}
_3d5();
_3dd=_328;
}else{
if(next===47){
if(_30d.trackSpaces){
(_33b||(_33b=[])).push(_30e.slice(_3dd,_328));
}
_3d9();
_3dd=_328;
}else{
break;
}
}
}else{
if(ch===160){
++_328;
}else{
if(ch>=5760&&_3c4.test(String.fromCharCode(ch))){
++_328;
}else{
if(_328>=_30f){
if(_30d.preprocess&&_34e.length){
var _3de=_34e.pop();
_328=_3de.end;
_30e=_3de.input;
_30f=_3de.inputLen;
_340=_3de.lastEnd;
_33f=_3de.lastStart;
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
function _3df(code,_3e0){
var next=_30e.charCodeAt(_328+1);
if(next>=48&&next<=57){
return _3e1(String.fromCharCode(code),_3e0);
}
if(next===46&&_30d.objj&&_30e.charCodeAt(_328+2)===46){
_328+=3;
return _3e0(_3aa);
}
++_328;
return _3e0(_3a7);
};
function _3e2(_3e3){
var next=_30e.charCodeAt(_328+1);
if(_32c){
++_328;
return _3e4();
}
if(next===61){
return _3e5(_3ae,2,_3e3);
}
return _3e5(_3ac,1,_3e3);
};
function _3e6(_3e7){
var next=_30e.charCodeAt(_328+1);
if(next===61){
return _3e5(_3ae,2,_3e7);
}
return _3e5(_3ba,1,_3e7);
};
function _3e8(code,_3e9){
var next=_30e.charCodeAt(_328+1);
if(next===code){
return _3e5(code===124?_3b2:_3b3,2,_3e9);
}
if(next===61){
return _3e5(_3ae,2,_3e9);
}
return _3e5(code===124?_3b4:_3b6,1,_3e9);
};
function _3ea(_3eb){
var next=_30e.charCodeAt(_328+1);
if(next===61){
return _3e5(_3ae,2,_3eb);
}
return _3e5(_3b5,1,_3eb);
};
function _3ec(code,_3ed){
var next=_30e.charCodeAt(_328+1);
if(next===code){
return _3e5(_3b0,2,_3ed);
}
if(next===61){
return _3e5(_3ae,2,_3ed);
}
return _3e5(_3af,1,_3ed);
};
function _3ee(code,_3ef){
if(_342&&_30d.objj&&code===60){
var str=[];
for(;;){
if(_328>=_30f){
_350(_32e,"Unterminated import statement");
}
var ch=_30e.charCodeAt(++_328);
if(ch===62){
++_328;
return _3ef(_384,String.fromCharCode.apply(null,str));
}
str.push(ch);
}
}
var next=_30e.charCodeAt(_328+1);
var size=1;
if(next===code){
size=code===62&&_30e.charCodeAt(_328+2)===62?3:2;
if(_30e.charCodeAt(_328+size)===61){
return _3e5(_3ae,size+1,_3ef);
}
return _3e5(_3b9,size,_3ef);
}
if(next===61){
size=_30e.charCodeAt(_328+2)===61?3:2;
}
return _3e5(_3b8,size,_3ef);
};
function _3f0(code,_3f1){
var next=_30e.charCodeAt(_328+1);
if(next===61){
return _3e5(_3b7,_30e.charCodeAt(_328+2)===61?3:2,_3f1);
}
return _3e5(code===61?_3ad:_3b1,1,_3f1);
};
function _3f2(code,_3f3){
var next=_30e.charCodeAt(++_328);
if(next===34||next===39){
return _3f4(next,_3f3);
}
if(next===123){
return _3f3(_37c);
}
if(next===91){
return _3f3(_37d);
}
var word=_3f5(),_3f6=_39c[word];
if(!_3f6){
_350(_328,"Unrecognized Objective-J keyword '@"+word+"'");
}
return _3f3(_3f6);
};
var _3f7=true;
var _3f8=0;
function _3f9(_3fa){
++_328;
_3fb();
switch(_348){
case _38e:
_3fb();
var _3fc=_34b;
var _3fd=_3fe();
if(_30e.charCodeAt(_3fc)===40){
_3ff(_3a2);
var _400=[];
var _401=true;
while(!_402(_3a3)){
if(!_401){
_3ff(_3a4,"Expected ',' between macro parameters");
}else{
_401=false;
}
_400.push(_3fe());
}
}
var _403=_328=_34a;
_3dc();
var _404=_30e.slice(_403,_328);
_404=_404.replace(/\\/g," ");
_30d.preprocessAddMacro(new _405(_3fd,_404,_400));
break;
case _38f:
_3fb();
_30d.preprocessUndefineMacro(_3fe());
_3dc();
break;
case _392:
if(_3f7){
_3f8++;
_3fb();
var expr=_406();
var test=_407(expr);
if(!test){
_3f7=false;
}
_408(!test);
}else{
return _3fa(_392);
}
break;
case _390:
if(_3f7){
_3f8++;
_3fb();
var _409=_3fe();
var test=_30d.preprocessGetMacro(_409);
if(!test){
_3f7=false;
}
_408(!test);
}else{
return _3fa(_390);
}
break;
case _391:
if(_3f7){
_3f8++;
_3fb();
var _409=_3fe();
var test=_30d.preprocessGetMacro(_409);
if(test){
_3f7=false;
}
_408(test);
}else{
return _3fa(_391);
}
break;
case _393:
if(_3f8){
if(_3f7){
_3f7=false;
_3fa(_393);
_3fb();
_408(true,true);
}else{
return _3fa(_393);
}
}else{
_350(_34a,"#else without #if");
}
break;
case _394:
if(_3f8){
if(_3f7){
_3f8--;
break;
}
}else{
_350(_34a,"#endif without #if");
}
return _3fa(_394);
break;
case _396:
_3dc();
break;
case _3b1:
_3dc();
break;
default:
_350(_34a,"Invalid preprocessing directive");
_3dc();
return _3fa(_38d);
}
_3cf(_38d);
return _3d0();
};
function _407(expr){
return _30c.walk.recursive(expr,{},{BinaryExpression:function(node,st,c){
var left=node.left,_40a=node.right;
switch(node.operator){
case "+":
return c(left,st)+c(_40a,st);
case "-":
return c(left,st)-c(_40a,st);
case "*":
return c(left,st)*c(_40a,st);
case "/":
return c(left,st)/c(_40a,st);
case "%":
return c(left,st)%c(_40a,st);
case "<":
return c(left,st)<c(_40a,st);
case ">":
return c(left,st)>c(_40a,st);
case "=":
case "==":
case "===":
return c(left,st)===c(_40a,st);
case "<=":
return c(left,st)<=c(_40a,st);
case ">=":
return c(left,st)>=c(_40a,st);
case "&&":
return c(left,st)&&c(_40a,st);
case "||":
return c(left,st)||c(_40a,st);
}
},Literal:function(node,st,c){
return node.value;
},Identifier:function(node,st,c){
var name=node.name,_40b=_30d.preprocessGetMacro(name);
return (_40b&&parseInt(_40b.macro))||0;
},DefinedExpression:function(node,st,c){
return !!_30d.preprocessGetMacro(node.id.name);
}},{});
};
function _3d3(code,_40c,_40d){
switch(code){
case 46:
return _3df(code,_40c);
case 40:
++_328;
return _40c(_3a2);
case 41:
++_328;
return _40c(_3a3);
case 59:
++_328;
return _40c(_3a5);
case 44:
++_328;
return _40c(_3a4);
case 91:
++_328;
return _40c(_39e);
case 93:
++_328;
return _40c(_39f);
case 123:
++_328;
return _40c(_3a0);
case 125:
++_328;
return _40c(_3a1);
case 58:
++_328;
return _40c(_3a6);
case 63:
++_328;
return _40c(_3a8);
case 48:
var next=_30e.charCodeAt(_328+1);
if(next===120||next===88){
return _40e(_40c);
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
return _3e1(false,_40c);
case 34:
case 39:
return _3f4(code,_40c);
case 47:
return _3e2(_40c);
case 37:
case 42:
return _3e6(_40c);
case 124:
case 38:
return _3e8(code,_40c);
case 94:
return _3ea(_40c);
case 43:
case 45:
return _3ec(code,_40c);
case 60:
case 62:
return _3ee(code,_40c,_40c);
case 61:
case 33:
return _3f0(code,_40c);
case 126:
return _3e5(_3b1,1,_40c);
case 64:
if(_30d.objj){
return _3f2(code,_40c);
}
return false;
case 35:
if(_30d.preprocess){
return _3f9(_40c);
}
return false;
case 92:
if(_30d.preprocess){
return _3e5(_398,1,_40c);
}
return false;
}
if(_40d&&_3ca.test(String.fromCharCode(code))){
return _3e5(_358,1,_40c);
}
return false;
};
function _40f(){
while(_328<_30f){
var ch=_30e.charCodeAt(_328);
if(ch===32||ch===9||ch===160||(ch>=5760&&_3c5.test(String.fromCharCode(ch)))){
++_328;
}else{
if(ch===92){
var pos=_328+1;
ch=_30e.charCodeAt(pos);
while(pos<_30f&&(ch===32||ch===9||ch===11||ch===12||(ch>=5760&&_3c5.test(String.fromCharCode(ch))))){
ch=_30e.charCodeAt(++pos);
}
_323.lastIndex=0;
var _410=_323.exec(_30e.slice(pos,pos+2));
if(_410&&_410.index===0){
_328=pos+_410[0].length;
}else{
return false;
}
}else{
_323.lastIndex=0;
var _410=_323.exec(_30e.slice(_328,_328+2));
return _410&&_410.index===0;
}
}
}
};
function _408(test,_411){
if(test){
var _412=0;
while(_412>0||(_348!=_394&&(_348!=_393||_411))){
switch(_348){
case _392:
case _390:
case _391:
_412++;
break;
case _394:
_412--;
break;
case _357:
_3f7=true;
_350(_34a,"Missing #endif");
}
_3fb();
}
_3f7=true;
if(_348===_394){
_3f8--;
}
}
};
function _3fb(){
_34a=_328;
_33e=_30e;
if(_328>=_30f){
return _357;
}
var code=_30e.charCodeAt(_328);
if(_34f&&code!==41&&code!==44){
var _413=0;
while(_328<_30f&&(_413||(code!==41&&code!==44))){
if(code===40){
_413++;
}
if(code===41){
_413--;
}
code=_30e.charCodeAt(++_328);
}
return _414(_399,_30e.slice(_34a,_328));
}
if(_3cb(code)||(code===92&&_30e.charCodeAt(_328+1)===117)){
return _415();
}
if(_3d3(code,_414,true)===false){
var ch=String.fromCharCode(code);
if(ch==="\\"||_3c8.test(ch)){
return _415();
}
_350(_328,"Unexpected character '"+ch+"'");
}
};
function _415(){
var word=_3f5();
_414(_3c3(word)?_39d[word]:_356,word);
};
function _414(type,val){
_348=type;
_349=val;
_34b=_328;
_40f();
};
function _416(){
_34c=_32e;
_34d=_32f;
return _3fb();
};
function _402(type){
if(_348===type){
_416();
return true;
}
};
function _3ff(type,_417){
if(_348===type){
_3fb();
}else{
_350(_34a,_417||"Unexpected token");
}
};
function _3fe(){
var _418=_348===_356?_349:((!_30d.forbidReserved||_348.okAsIdent)&&_348.keyword)||_350(_34a,"Expected Macro identifier");
_416();
return _418;
};
function _419(){
var node=_41a();
node.name=_3fe();
return _41b(node,"Identifier");
};
function _406(){
return _41c();
};
function _41c(){
return _41d(_41e(),-1);
};
function _41d(left,_41f){
var prec=_348.binop;
if(prec){
if(!_348.preprocess){
_350(_34a,"Unsupported macro operator");
}
if(prec>_41f){
var node=_420(left);
node.left=left;
node.operator=_349;
_416();
node.right=_41d(_41e(),prec);
var node=_41b(node,"BinaryExpression");
return _41d(node,_41f);
}
}
return left;
};
function _41e(){
if(_348.preprocess&&_348.prefix){
var node=_41a();
node.operator=_333;
node.prefix=true;
_416();
node.argument=_41e();
return _41b(node,"UnaryExpression");
}
return _421();
};
function _421(){
switch(_348){
case _356:
return _419();
case _353:
case _355:
return _422();
case _3a2:
var _423=_34a;
_416();
var val=_406();
val.start=_423;
val.end=_34b;
_3ff(_3a3,"Expected closing ')' in macro expression");
return val;
case _397:
var node=_41a();
_416();
node.id=_419();
return _41b(node,"DefinedExpression");
default:
_3d4();
}
};
function _422(){
var node=_41a();
node.value=_349;
node.raw=_33e.slice(_34a,_34b);
_416();
return _41b(node,"Literal");
};
function _41b(node,type){
node.type=type;
node.end=_34d;
return node;
};
function _3d0(_424){
_32e=_328;
_33d=_30e;
if(_30d.locations){
_330=new _3cd;
}
_334=_33a;
_337=_33b;
if(_424){
return _3e4();
}
if(_328>=_30f){
return _3cf(_357);
}
var code=_30e.charCodeAt(_328);
if(_3cb(code)||code===92){
return _3d2();
}
var tok=_3d3(code,_3cf);
if(tok===false){
var ch=String.fromCharCode(code);
if(ch==="\\"||_3c8.test(ch)){
return _3d2();
}
_350(_328,"Unexpected character '"+ch+"'");
}
return tok;
};
function _3e5(type,size,_425){
var str=_30e.slice(_328,_328+size);
_328+=size;
_425(type,str);
};
function _3e4(){
var _426="",_427,_428,_429=_328;
for(;;){
if(_328>=_30f){
_350(_429,"Unterminated regular expression");
}
var ch=_30e.charAt(_328);
if(_3ca.test(ch)){
_350(_429,"Unterminated regular expression");
}
if(!_427){
if(ch==="["){
_428=true;
}else{
if(ch==="]"&&_428){
_428=false;
}else{
if(ch==="/"&&!_428){
break;
}
}
}
_427=ch==="\\";
}else{
_427=false;
}
++_328;
}
var _426=_30e.slice(_429,_328);
++_328;
var mods=_3f5();
if(mods&&!/^[gmsiy]*$/.test(mods)){
_350(_429,"Invalid regexp flag");
}
return _3cf(_354,new RegExp(_426,mods));
};
function _42a(_42b,len){
var _42c=_328,_42d=0;
for(var i=0,e=len==null?Infinity:len;i<e;++i){
var code=_30e.charCodeAt(_328),val;
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
if(val>=_42b){
break;
}
++_328;
_42d=_42d*_42b+val;
}
if(_328===_42c||len!=null&&_328-_42c!==len){
return null;
}
return _42d;
};
function _40e(_42e){
_328+=2;
var val=_42a(16);
if(val==null){
_350(_32e+2,"Expected hexadecimal number");
}
if(_3cb(_30e.charCodeAt(_328))){
_350(_328,"Identifier directly after number");
}
return _42e(_353,val);
};
function _3e1(_42f,_430){
var _431=_328,_432=false,_433=_30e.charCodeAt(_328)===48;
if(!_42f&&_42a(10)===null){
_350(_431,"Invalid number");
}
if(_30e.charCodeAt(_328)===46){
++_328;
_42a(10);
_432=true;
}
var next=_30e.charCodeAt(_328);
if(next===69||next===101){
next=_30e.charCodeAt(++_328);
if(next===43||next===45){
++_328;
}
if(_42a(10)===null){
_350(_431,"Invalid number");
}
_432=true;
}
if(_3cb(_30e.charCodeAt(_328))){
_350(_328,"Identifier directly after number");
}
var str=_30e.slice(_431,_328),val;
if(_432){
val=parseFloat(str);
}else{
if(!_433||str.length===1){
val=parseInt(str,10);
}else{
if(/[89]/.test(str)||_346){
_350(_431,"Invalid number");
}else{
val=parseInt(str,8);
}
}
}
return _430(_353,val);
};
var _434=[];
function _3f4(_435,_436){
_328++;
_434.length=0;
for(;;){
if(_328>=_30f){
_350(_32e,"Unterminated string constant");
}
var ch=_30e.charCodeAt(_328);
if(ch===_435){
++_328;
return _436(_355,String.fromCharCode.apply(null,_434));
}
if(ch===92){
ch=_30e.charCodeAt(++_328);
var _437=/^[0-7]+/.exec(_30e.slice(_328,_328+3));
if(_437){
_437=_437[0];
}
while(_437&&parseInt(_437,8)>255){
_437=_437.slice(0,_437.length-1);
}
if(_437==="0"){
_437=null;
}
++_328;
if(_437){
if(_346){
_350(_328-2,"Octal literal in strict mode");
}
_434.push(parseInt(_437,8));
_328+=_437.length-1;
}else{
switch(ch){
case 110:
_434.push(10);
break;
case 114:
_434.push(13);
break;
case 120:
_434.push(_438(2));
break;
case 117:
_434.push(_438(4));
break;
case 85:
_434.push(_438(8));
break;
case 116:
_434.push(9);
break;
case 98:
_434.push(8);
break;
case 118:
_434.push(11);
break;
case 102:
_434.push(12);
break;
case 48:
_434.push(0);
break;
case 13:
if(_30e.charCodeAt(_328)===10){
++_328;
}
case 10:
if(_30d.locations){
_32a=_328;
++_329;
}
break;
default:
_434.push(ch);
break;
}
}
}else{
if(ch===13||ch===10||ch===8232||ch===8329){
_350(_32e,"Unterminated string constant");
}
_434.push(ch);
++_328;
}
}
};
function _438(len){
var n=_42a(16,len);
if(n===null){
_350(_32e,"Bad character escape sequence");
}
return n;
};
var _439;
function _3f5(){
_439=false;
var word,_43a=true,_43b=_328;
for(;;){
var ch=_30e.charCodeAt(_328);
if(_3cc(ch)){
if(_439){
word+=_30e.charAt(_328);
}
++_328;
}else{
if(ch===92){
if(!_439){
word=_30e.slice(_43b,_328);
}
_439=true;
if(_30e.charCodeAt(++_328)!=117){
_350(_328,"Expecting Unicode escape sequence \\uXXXX");
}
++_328;
var esc=_438(4);
var _43c=String.fromCharCode(esc);
if(!_43c){
_350(_328-1,"Invalid Unicode escape");
}
if(!(_43a?_3cb(esc):_3cc(esc))){
_350(_328-4,"Invalid Unicode escape");
}
word+=_43c;
}else{
break;
}
}
_43a=false;
}
return _439?word:_30e.slice(_43b,_328);
};
function _3d2(_43d){
var word=_43d||_3f5();
var type=_356;
var _43e;
if(_30d.preprocess){
var _43f;
var i=_34e.length;
if(i>0){
var _440=_34e[i-1];
if(_440.parameterDict&&_440.macro.isParameterFunction()(word)){
_43f=_440.parameterDict[word];
}
}
if(!_43f&&_30d.preprocessIsMacro(word)){
_43f=_30d.preprocessGetMacro(word);
}
if(_43f){
var _441=_32e;
var _442;
var _443=_43f.parameters;
var _444;
if(_443){
_444=_328<_30f&&_30e.charCodeAt(_328)===40;
}
if(!_443||_444){
var _445=_43f.macro;
var _446=_328;
if(_444){
var _447=true;
var _448=0;
_442=Object.create(null);
_3fb();
_34f=true;
_3ff(_3a2);
_446=_328;
while(!_402(_3a3)){
if(!_447){
_3ff(_3a4,"Expected ',' between macro parameters");
}else{
_447=false;
}
var _449=_443[_448++];
var val=_349;
_3ff(_399);
_442[_449]=new _405(_449,val);
_446=_328;
}
_34f=false;
}
if(_445){
_34e.push({macro:_43f,parameterDict:_442,start:_441,end:_446,input:_30e,inputLen:_30f,lastStart:_32e,lastEnd:_446});
_30e=_445;
_30f=_445.length;
_328=0;
}
return next();
}
}
}
if(!_439){
if(_3c1(word)){
type=_39a[word];
}else{
if(_30d.objj&&_3c2(word)){
type=_39b[word];
}else{
if(_30d.forbidReserved&&(_30d.ecmaVersion===3?_3bd:_3be)(word)||_346&&_3bf(word)){
_350(_32e,"The keyword '"+word+"' is reserved");
}
}
}
}
return _3cf(type,word);
};
function _405(_44a,_44b,_44c){
this.identifier=_44a;
if(_44b){
this.macro=_44b;
}
if(_44c){
this.parameters=_44c;
}
};
_405.prototype.isParameterFunction=function(){
var y=(this.parameters||[]).join(" ");
return this.isParameterFunctionVar||(this.isParameterFunctionVar=_31f(y));
};
function next(){
_33f=_32e;
_340=_32f;
_341=_331;
_343=null;
return _3d0();
};
function _44d(_44e){
_346=_44e;
_328=_340;
_32d();
_3d0();
};
function _44f(){
this.type=null;
this.start=_32e;
this.end=null;
};
function _450(){
this.start=_330;
this.end=null;
if(_310!==null){
this.source=_310;
}
};
function _41a(){
var node=new _44f();
if(_30d.trackComments&&_334){
node.commentsBefore=_334;
_334=null;
}
if(_30d.trackSpaces&&_337){
node.spacesBefore=_337;
_337=null;
}
if(_30d.locations){
node.loc=new _450();
}
if(_30d.ranges){
node.range=[_32e,0];
}
return node;
};
function _420(_451){
var node=new _44f();
node.start=_451.start;
if(_451.commentsBefore){
node.commentsBefore=_451.commentsBefore;
delete _451.commentsBefore;
}
if(_451.spacesBefore){
node.spacesBefore=_451.spacesBefore;
delete _451.spacesBefore;
}
if(_30d.locations){
node.loc=new _450();
node.loc.start=_451.loc.start;
}
if(_30d.ranges){
node.range=[_451.range[0],0];
}
return node;
};
var _452;
function _453(node,type){
node.type=type;
node.end=_340;
if(_30d.trackComments){
if(_336){
node.commentsAfter=_336;
_335=null;
}else{
if(_452&&_452.end===_340&&_452.commentsAfter){
node.commentsAfter=_452.commentsAfter;
delete _452.commentsAfter;
}
}
if(!_30d.trackSpaces){
_452=node;
}
}
if(_30d.trackSpaces){
if(_339){
node.spacesAfter=_339;
_339=null;
}else{
if(_452&&_452.end===_340&&_452.spacesAfter){
node.spacesAfter=_452.spacesAfter;
delete _452.spacesAfter;
}
}
_452=node;
}
if(_30d.locations){
node.loc.end=_341;
}
if(_30d.ranges){
node.range[1]=_340;
}
return node;
};
function _454(stmt){
return _30d.ecmaVersion>=5&&stmt.type==="ExpressionStatement"&&stmt.expression.type==="Literal"&&stmt.expression.value==="use strict";
};
function eat(type){
if(_332===type){
next();
return true;
}
};
function _455(){
return !_30d.strictSemicolons&&(_332===_357||_332===_3a1||_3ca.test(_33d.slice(_340,_32e))||(_343&&_30d.objj));
};
function _456(){
if(!eat(_3a5)&&!_455()){
_350(_32e,"Expected a semicolon");
}
};
function _457(type,_458){
if(_332===type){
next();
}else{
_458?_350(_32e,_458):_3d4();
}
};
function _3d4(){
_350(_32e,"Unexpected token");
};
function _459(expr){
if(expr.type!=="Identifier"&&expr.type!=="MemberExpression"&&expr.type!=="Dereference"){
_350(expr.start,"Assigning to rvalue");
}
if(_346&&expr.type==="Identifier"&&_3c0(expr.name)){
_350(expr.start,"Assigning to "+expr.name+" in strict mode");
}
};
function _313(_45a){
_33f=_340=_328;
if(_30d.locations){
_341=new _3cd;
}
_344=_346=null;
_345=[];
_3d0();
var node=_45a||_41a(),_45b=true;
if(!_45a){
node.body=[];
}
while(_332!==_357){
var stmt=_45c();
node.body.push(stmt);
if(_45b&&_454(stmt)){
_44d(true);
}
_45b=false;
}
return _453(node,"Program");
};
var _45d={kind:"loop"},_45e={kind:"switch"};
function _45c(){
if(_332===_3ac){
_3d0(true);
}
var _45f=_332,node=_41a();
if(_343){
node.expression=_460(_343,_343.object);
_456();
return _453(node,"ExpressionStatement");
}
switch(_45f){
case _359:
case _35c:
next();
var _461=_45f===_359;
if(eat(_3a5)||_455()){
node.label=null;
}else{
if(_332!==_356){
_3d4();
}else{
node.label=_462();
_456();
}
}
for(var i=0;i<_345.length;++i){
var lab=_345[i];
if(node.label==null||lab.name===node.label.name){
if(lab.kind!=null&&(_461||lab.kind==="loop")){
break;
}
if(node.label&&_461){
break;
}
}
}
if(i===_345.length){
_350(node.start,"Unsyntactic "+_45f.keyword);
}
return _453(node,_461?"BreakStatement":"ContinueStatement");
case _35d:
next();
_456();
return _453(node,"DebuggerStatement");
case _35f:
next();
_345.push(_45d);
node.body=_45c();
_345.pop();
_457(_36a,"Expected 'while' at end of do statement");
node.test=_463();
_456();
return _453(node,"DoWhileStatement");
case _362:
next();
_345.push(_45d);
_457(_3a2,"Expected '(' after 'for'");
if(_332===_3a5){
return _464(node,null);
}
if(_332===_369){
var init=_41a();
next();
_465(init,true);
if(init.declarations.length===1&&eat(_372)){
return _466(node,init);
}
return _464(node,init);
}
var init=_467(false,true);
if(eat(_372)){
_459(init);
return _466(node,init);
}
return _464(node,init);
case _363:
next();
return _468(node,true);
case _364:
next();
node.test=_463();
node.consequent=_45c();
node.alternate=eat(_360)?_45c():null;
return _453(node,"IfStatement");
case _365:
if(!_344){
_350(_32e,"'return' outside of function");
}
next();
if(eat(_3a5)||_455()){
node.argument=null;
}else{
node.argument=_467();
_456();
}
return _453(node,"ReturnStatement");
case _366:
next();
node.discriminant=_463();
node.cases=[];
_457(_3a0,"Expected '{' in switch statement");
_345.push(_45e);
for(var cur,_469;_332!=_3a1;){
if(_332===_35a||_332===_35e){
var _46a=_332===_35a;
if(cur){
_453(cur,"SwitchCase");
}
node.cases.push(cur=_41a());
cur.consequent=[];
next();
if(_46a){
cur.test=_467();
}else{
if(_469){
_350(_33f,"Multiple default clauses");
}
_469=true;
cur.test=null;
}
_457(_3a6,"Expected ':' after case clause");
}else{
if(!cur){
_3d4();
}
cur.consequent.push(_45c());
}
}
if(cur){
_453(cur,"SwitchCase");
}
next();
_345.pop();
return _453(node,"SwitchStatement");
case _367:
next();
if(_3ca.test(_33d.slice(_340,_32e))){
_350(_340,"Illegal newline after throw");
}
node.argument=_467();
_456();
return _453(node,"ThrowStatement");
case _368:
next();
node.block=_46b();
node.handlers=[];
while(_332===_35b){
var _46c=_41a();
next();
_457(_3a2,"Expected '(' after 'catch'");
_46c.param=_462();
if(_346&&_3c0(_46c.param.name)){
_350(_46c.param.start,"Binding "+_46c.param.name+" in strict mode");
}
_457(_3a3,"Expected closing ')' after catch");
_46c.guard=null;
_46c.body=_46b();
node.handlers.push(_453(_46c,"CatchClause"));
}
node.finalizer=eat(_361)?_46b():null;
if(!node.handlers.length&&!node.finalizer){
_350(node.start,"Missing catch or finally clause");
}
return _453(node,"TryStatement");
case _369:
next();
node=_465(node);
_456();
return node;
case _36a:
next();
node.test=_463();
_345.push(_45d);
node.body=_45c();
_345.pop();
return _453(node,"WhileStatement");
case _36b:
if(_346){
_350(_32e,"'with' in strict mode");
}
next();
node.object=_463();
node.body=_45c();
return _453(node,"WithStatement");
case _3a0:
return _46b();
case _3a5:
next();
return _453(node,"EmptyStatement");
case _383:
if(_30d.objj){
next();
node.classname=_462(true);
if(eat(_3a6)){
node.superclassname=_462(true);
}else{
if(eat(_3a2)){
node.categoryname=_462(true);
_457(_3a3,"Expected closing ')' after category name");
}
}
if(_333==="<"){
next();
var _46d=[],_46e=true;
node.protocols=_46d;
while(_333!==">"){
if(!_46e){
_457(_3a4,"Expected ',' between protocol names");
}else{
_46e=false;
}
_46d.push(_462(true));
}
next();
}
if(eat(_3a0)){
node.ivardeclarations=[];
for(;;){
if(eat(_3a1)){
break;
}
_46f(node);
}
node.endOfIvars=_32e;
}
node.body=[];
while(!eat(_376)){
if(_332===_357){
_350(_328,"Expected '@end' after '@interface'");
}
node.body.push(_470());
}
return _453(node,"InterfaceDeclarationStatement");
}
break;
case _373:
if(_30d.objj){
next();
node.classname=_462(true);
if(eat(_3a6)){
node.superclassname=_462(true);
}else{
if(eat(_3a2)){
node.categoryname=_462(true);
_457(_3a3,"Expected closing ')' after category name");
}
}
if(_333==="<"){
next();
var _46d=[],_46e=true;
node.protocols=_46d;
while(_333!==">"){
if(!_46e){
_457(_3a4,"Expected ',' between protocol names");
}else{
_46e=false;
}
_46d.push(_462(true));
}
next();
}
if(_333==="<"){
next();
var _46d=[],_46e=true;
node.protocols=_46d;
while(_333!==">"){
if(!_46e){
_457(_3a4,"Expected ',' between protocol names");
}else{
_46e=false;
}
_46d.push(_462(true));
}
next();
}
if(eat(_3a0)){
node.ivardeclarations=[];
for(;;){
if(eat(_3a1)){
break;
}
_46f(node);
}
node.endOfIvars=_32e;
}
node.body=[];
while(!eat(_376)){
if(_332===_357){
_350(_328,"Expected '@end' after '@implementation'");
}
node.body.push(_470());
}
return _453(node,"ClassDeclarationStatement");
}
break;
case _380:
if(_30d.objj&&_30e.charCodeAt(_328)!==40){
next();
node.protocolname=_462(true);
if(_333==="<"){
next();
var _46d=[],_46e=true;
node.protocols=_46d;
while(_333!==">"){
if(!_46e){
_457(_3a4,"Expected ',' between protocol names");
}else{
_46e=false;
}
_46d.push(_462(true));
}
next();
}
while(!eat(_376)){
if(_332===_357){
_350(_328,"Expected '@end' after '@protocol'");
}
if(eat(_382)){
continue;
}
if(eat(_381)){
while(!eat(_382)&&_332!==_376){
(node.optional||(node.optional=[])).push(_471());
}
}else{
(node.required||(node.required=[])).push(_471());
}
}
return _453(node,"ProtocolDeclarationStatement");
}
break;
case _377:
if(_30d.objj){
next();
if(_332===_355){
node.localfilepath=true;
}else{
if(_332===_384){
node.localfilepath=false;
}else{
_3d4();
}
}
node.filename=_472();
return _453(node,"ImportStatement");
}
break;
case _38d:
if(_30d.objj){
next();
return _453(node,"PreprocessStatement");
}
break;
case _37a:
if(_30d.objj){
next();
node.id=_462(false);
return _453(node,"ClassStatement");
}
break;
case _37b:
if(_30d.objj){
next();
node.id=_462(false);
return _453(node,"GlobalStatement");
}
break;
}
var _473=_333,expr=_467();
if(_45f===_356&&expr.type==="Identifier"&&eat(_3a6)){
for(var i=0;i<_345.length;++i){
if(_345[i].name===_473){
_350(expr.start,"Label '"+_473+"' is already declared");
}
}
var kind=_332.isLoop?"loop":_332===_366?"switch":null;
_345.push({name:_473,kind:kind});
node.body=_45c();
_345.pop();
node.label=expr;
return _453(node,"LabeledStatement");
}else{
node.expression=expr;
_456();
return _453(node,"ExpressionStatement");
}
};
function _46f(node){
var _474;
if(eat(_374)){
_474=true;
}
var type=_475();
if(_346&&_3c0(type.name)){
_350(type.start,"Binding "+type.name+" in strict mode");
}
for(;;){
var decl=_41a();
if(_474){
decl.outlet=_474;
}
decl.ivartype=type;
decl.id=_462();
if(_346&&_3c0(decl.id.name)){
_350(decl.id.start,"Binding "+decl.id.name+" in strict mode");
}
if(eat(_375)){
decl.accessors={};
if(eat(_3a2)){
if(!eat(_3a3)){
for(;;){
var _476=_462(true);
switch(_476.name){
case "property":
case "getter":
_457(_3ad,"Expected '=' after 'getter' accessor attribute");
decl.accessors[_476.name]=_462(true);
break;
case "setter":
_457(_3ad,"Expected '=' after 'setter' accessor attribute");
var _477=_462(true);
decl.accessors[_476.name]=_477;
if(eat(_3a6)){
_477.end=_32e;
}
_477.name+=":";
break;
case "readwrite":
case "readonly":
case "copy":
decl.accessors[_476.name]=true;
break;
default:
_350(_476.start,"Unknown accessors attribute '"+_476.name+"'");
}
if(!eat(_3a4)){
break;
}
}
_457(_3a3,"Expected closing ')' after accessor attributes");
}
}
}
_453(decl,"IvarDeclaration");
node.ivardeclarations.push(decl);
if(!eat(_3a4)){
break;
}
}
_456();
};
function _478(node){
node.methodtype=_333;
_457(_3af,"Method declaration must start with '+' or '-'");
if(eat(_3a2)){
var _479=_41a();
if(eat(_378)){
node.action=_453(_479,"ObjectiveJActionType");
_479=_41a();
}
if(!eat(_3a3)){
node.returntype=_475(_479);
_457(_3a3,"Expected closing ')' after method return type");
}
}
var _47a=true,_47b=[],args=[];
node.selectors=_47b;
node.arguments=args;
for(;;){
if(_332!==_3a6){
_47b.push(_462(true));
if(_47a&&_332!==_3a6){
break;
}
}else{
_47b.push(null);
}
_457(_3a6,"Expected ':' in selector");
var _47c={};
args.push(_47c);
if(eat(_3a2)){
_47c.type=_475();
_457(_3a3,"Expected closing ')' after method argument type");
}
_47c.identifier=_462(false);
if(_332===_3a0||_332===_3a5){
break;
}
if(eat(_3a4)){
_457(_3aa,"Expected '...' after ',' in method declaration");
node.parameters=true;
break;
}
_47a=false;
}
};
function _470(){
var _47d=_41a();
if(_333==="+"||_333==="-"){
_478(_47d);
eat(_3a5);
_47d.startOfBody=_340;
var _47e=_344,_47f=_345;
_344=true;
_345=[];
_47d.body=_46b(true);
_344=_47e;
_345=_47f;
return _453(_47d,"MethodDeclarationStatement");
}else{
return _45c();
}
};
function _471(){
var _480=_41a();
_478(_480);
_456();
return _453(_480,"MethodDeclarationStatement");
};
function _463(){
_457(_3a2,"Expected '(' before expression");
var val=_467();
_457(_3a3,"Expected closing ')' after expression");
return val;
};
function _46b(_481){
var node=_41a(),_482=true,_346=false,_483;
node.body=[];
_457(_3a0,"Expected '{' before block");
while(!eat(_3a1)){
var stmt=_45c();
node.body.push(stmt);
if(_482&&_454(stmt)){
_483=_346;
_44d(_346=true);
}
_482=false;
}
if(_346&&!_483){
_44d(false);
}
return _453(node,"BlockStatement");
};
function _464(node,init){
node.init=init;
_457(_3a5,"Expected ';' in for statement");
node.test=_332===_3a5?null:_467();
_457(_3a5,"Expected ';' in for statement");
node.update=_332===_3a3?null:_467();
_457(_3a3,"Expected closing ')' in for statement");
node.body=_45c();
_345.pop();
return _453(node,"ForStatement");
};
function _466(node,init){
node.left=init;
node.right=_467();
_457(_3a3,"Expected closing ')' in for statement");
node.body=_45c();
_345.pop();
return _453(node,"ForInStatement");
};
function _465(node,noIn){
node.declarations=[];
node.kind="var";
for(;;){
var decl=_41a();
decl.id=_462();
if(_346&&_3c0(decl.id.name)){
_350(decl.id.start,"Binding "+decl.id.name+" in strict mode");
}
decl.init=eat(_3ad)?_467(true,noIn):null;
node.declarations.push(_453(decl,"VariableDeclarator"));
if(!eat(_3a4)){
break;
}
}
return _453(node,"VariableDeclaration");
};
function _467(_484,noIn){
var expr=_485(noIn);
if(!_484&&_332===_3a4){
var node=_420(expr);
node.expressions=[expr];
while(eat(_3a4)){
node.expressions.push(_485(noIn));
}
return _453(node,"SequenceExpression");
}
return expr;
};
function _485(noIn){
var left=_486(noIn);
if(_332.isAssign){
var node=_420(left);
node.operator=_333;
node.left=left;
next();
node.right=_485(noIn);
_459(left);
return _453(node,"AssignmentExpression");
}
return left;
};
function _486(noIn){
var expr=_487(noIn);
if(eat(_3a8)){
var node=_420(expr);
node.test=expr;
node.consequent=_467(true);
_457(_3a6,"Expected ':' in conditional expression");
node.alternate=_467(true,noIn);
return _453(node,"ConditionalExpression");
}
return expr;
};
function _487(noIn){
return _488(_489(noIn),-1,noIn);
};
function _488(left,_48a,noIn){
var prec=_332.binop;
if(prec!=null&&(!noIn||_332!==_372)){
if(prec>_48a){
var node=_420(left);
node.left=left;
node.operator=_333;
next();
node.right=_488(_489(noIn),prec,noIn);
var node=_453(node,/&&|\|\|/.test(node.operator)?"LogicalExpression":"BinaryExpression");
return _488(node,_48a,noIn);
}
}
return left;
};
function _489(noIn){
if(_332.prefix){
var node=_41a(),_48b=_332.isUpdate;
node.operator=_333;
node.prefix=true;
next();
node.argument=_489(noIn);
if(_48b){
_459(node.argument);
}else{
if(_346&&node.operator==="delete"&&node.argument.type==="Identifier"){
_350(node.start,"Deleting local variable in strict mode");
}
}
return _453(node,_48b?"UpdateExpression":"UnaryExpression");
}
var expr=_48c();
while(_332.postfix&&!_455()){
var node=_420(expr);
node.operator=_333;
node.prefix=false;
node.argument=expr;
_459(expr);
next();
expr=_453(node,"UpdateExpression");
}
return expr;
};
function _48c(){
return _48d(_48e());
};
function _48d(base,_48f){
if(eat(_3a7)){
var node=_420(base);
node.object=base;
node.property=_462(true);
node.computed=false;
return _48d(_453(node,"MemberExpression"),_48f);
}else{
if(_30d.objj){
var _490=_41a();
}
if(eat(_39e)){
var expr=_467();
if(_30d.objj&&_332!==_39f){
_490.object=expr;
_343=_490;
return base;
}
var node=_420(base);
node.object=base;
node.property=expr;
node.computed=true;
_457(_39f,"Expected closing ']' in subscript");
return _48d(_453(node,"MemberExpression"),_48f);
}else{
if(!_48f&&eat(_3a2)){
var node=_420(base);
node.callee=base;
node.arguments=_491(_3a3,_332===_3a3?null:_467(true),false);
return _48d(_453(node,"CallExpression"),_48f);
}
}
}
return base;
};
function _48e(){
switch(_332){
case _36d:
var node=_41a();
next();
return _453(node,"ThisExpression");
case _356:
return _462();
case _353:
case _355:
case _354:
return _472();
case _36f:
case _370:
case _371:
var node=_41a();
node.value=_332.atomValue;
node.raw=_332.keyword;
next();
return _453(node,"Literal");
case _3a2:
var _492=_330,_493=_32e;
next();
var val=_467();
val.start=_493;
val.end=_32f;
if(_30d.locations){
val.loc.start=_492;
val.loc.end=_331;
}
if(_30d.ranges){
val.range=[_493,_32f];
}
_457(_3a3,"Expected closing ')' in expression");
return val;
case _37d:
var node=_41a(),_494=null;
next();
_457(_39e,"Expected '[' at beginning of array literal");
if(_332!==_39f){
_494=_467(true,true);
}
node.elements=_491(_39f,_494,true,true);
return _453(node,"ArrayLiteral");
case _39e:
var node=_41a(),_494=null;
next();
if(_332!==_3a4&&_332!==_39f){
_494=_467(true,true);
if(_332!==_3a4&&_332!==_39f){
return _460(node,_494);
}
}
node.elements=_491(_39f,_494,true,true);
return _453(node,"ArrayExpression");
case _37c:
var node=_41a();
next();
var r=_495();
node.keys=r[0];
node.values=r[1];
return _453(node,"DictionaryLiteral");
case _3a0:
return _496();
case _363:
var node=_41a();
next();
return _468(node,false);
case _36c:
return _497();
case _379:
var node=_41a();
next();
_457(_3a2,"Expected '(' after '@selector'");
_498(node,_3a3);
_457(_3a3,"Expected closing ')' after selector");
return _453(node,"SelectorLiteralExpression");
case _380:
var node=_41a();
next();
_457(_3a2,"Expected '(' after '@protocol'");
node.id=_462(true);
_457(_3a3,"Expected closing ')' after protocol name");
return _453(node,"ProtocolLiteralExpression");
case _37e:
var node=_41a();
next();
_457(_3a2,"Expected '(' after '@ref'");
node.element=_462(node,_3a3);
_457(_3a3,"Expected closing ')' after ref");
return _453(node,"Reference");
case _37f:
var node=_41a();
next();
_457(_3a2,"Expected '(' after '@deref'");
node.expr=_467(true,true);
_457(_3a3,"Expected closing ')' after deref");
return _453(node,"Dereference");
default:
if(_332.okAsIdent){
return _462();
}
_3d4();
}
};
function _460(node,_499){
_49a(node,_39f);
if(_499.type==="Identifier"&&_499.name==="super"){
node.superObject=true;
}else{
node.object=_499;
}
return _453(node,"MessageSendExpression");
};
function _498(node,_49b){
var _49c=true,_49d=[];
for(;;){
if(_332!==_3a6){
_49d.push(_462(true).name);
if(_49c&&_332===_49b){
break;
}
}
_457(_3a6,"Expected ':' in selector");
_49d.push(":");
if(_332===_49b){
break;
}
_49c=false;
}
node.selector=_49d.join("");
};
function _49a(node,_49e){
var _49f=true,_4a0=[],args=[],_4a1=[];
node.selectors=_4a0;
node.arguments=args;
for(;;){
if(_332!==_3a6){
_4a0.push(_462(true));
if(_49f&&eat(_49e)){
break;
}
}else{
_4a0.push(null);
}
_457(_3a6,"Expected ':' in selector");
args.push(_467(true,true));
if(eat(_49e)){
break;
}
if(_332===_3a4){
node.parameters=[];
while(eat(_3a4)){
node.parameters.push(_467(true,true));
}
eat(_49e);
break;
}
_49f=false;
}
};
function _497(){
var node=_41a();
next();
node.callee=_48d(_48e(false),true);
if(eat(_3a2)){
node.arguments=_491(_3a3,_332===_3a3?null:_467(true),false);
}else{
node.arguments=[];
}
return _453(node,"NewExpression");
};
function _496(){
var node=_41a(),_4a2=true,_4a3=false;
node.properties=[];
next();
while(!eat(_3a1)){
if(!_4a2){
_457(_3a4,"Expected ',' in object literal");
if(_30d.allowTrailingCommas&&eat(_3a1)){
break;
}
}else{
_4a2=false;
}
var prop={key:_4a4()},_4a5=false,kind;
if(eat(_3a6)){
prop.value=_467(true);
kind=prop.kind="init";
}else{
if(_30d.ecmaVersion>=5&&prop.key.type==="Identifier"&&(prop.key.name==="get"||prop.key.name==="set")){
_4a5=_4a3=true;
kind=prop.kind=prop.key.name;
prop.key=_4a4();
if(_332!==_3a2){
_3d4();
}
prop.value=_468(_41a(),false);
}else{
_3d4();
}
}
if(prop.key.type==="Identifier"&&(_346||_4a3)){
for(var i=0;i<node.properties.length;++i){
var _4a6=node.properties[i];
if(_4a6.key.name===prop.key.name){
var _4a7=kind==_4a6.kind||_4a5&&_4a6.kind==="init"||kind==="init"&&(_4a6.kind==="get"||_4a6.kind==="set");
if(_4a7&&!_346&&kind==="init"&&_4a6.kind==="init"){
_4a7=false;
}
if(_4a7){
_350(prop.key.start,"Redefinition of property");
}
}
}
}
node.properties.push(prop);
}
return _453(node,"ObjectExpression");
};
function _4a4(){
if(_332===_353||_332===_355){
return _48e();
}
return _462(true);
};
function _468(node,_4a8){
if(_332===_356){
node.id=_462();
}else{
if(_4a8){
_3d4();
}else{
node.id=null;
}
}
node.params=[];
var _4a9=true;
_457(_3a2,"Expected '(' before function parameters");
while(!eat(_3a3)){
if(!_4a9){
_457(_3a4,"Expected ',' between function parameters");
}else{
_4a9=false;
}
node.params.push(_462());
}
var _4aa=_344,_4ab=_345;
_344=true;
_345=[];
node.body=_46b(true);
_344=_4aa;
_345=_4ab;
if(_346||node.body.body.length&&_454(node.body.body[0])){
for(var i=node.id?-1:0;i<node.params.length;++i){
var id=i<0?node.id:node.params[i];
if(_3bf(id.name)||_3c0(id.name)){
_350(id.start,"Defining '"+id.name+"' in strict mode");
}
if(i>=0){
for(var j=0;j<i;++j){
if(id.name===node.params[j].name){
_350(id.start,"Argument name clash in strict mode");
}
}
}
}
}
return _453(node,_4a8?"FunctionDeclaration":"FunctionExpression");
};
function _491(_4ac,_4ad,_4ae,_4af){
if(_4ad&&eat(_4ac)){
return [_4ad];
}
var elts=[],_4b0=true;
while(!eat(_4ac)){
if(_4b0){
_4b0=false;
if(_4af&&_332===_3a4&&!_4ad){
elts.push(null);
}else{
elts.push(_4ad);
}
}else{
_457(_3a4,"Expected ',' between expressions");
if(_4ae&&_30d.allowTrailingCommas&&eat(_4ac)){
break;
}
if(_4af&&_332===_3a4){
elts.push(null);
}else{
elts.push(_467(true));
}
}
}
return elts;
};
function _495(){
_457(_3a0,"Expected '{' before dictionary");
var keys=[],_4b1=[],_4b2=true;
while(!eat(_3a1)){
if(!_4b2){
_457(_3a4,"Expected ',' between expressions");
if(_30d.allowTrailingCommas&&eat(_3a1)){
break;
}
}
keys.push(_467(true,true));
_457(_3a6,"Expected ':' between dictionary key and value");
_4b1.push(_467(true,true));
_4b2=false;
}
return [keys,_4b1];
};
function _462(_4b3){
var node=_41a();
node.name=_332===_356?_333:(((_4b3&&!_30d.forbidReserved)||_332.okAsIdent)&&_332.keyword)||_3d4();
next();
return _453(node,"Identifier");
};
function _472(){
var node=_41a();
node.value=_333;
node.raw=_33d.slice(_32e,_32f);
next();
return _453(node,"Literal");
};
function _475(_4b4){
var node=_4b4?_420(_4b4):_41a();
if(_332===_356){
node.name=_333;
node.typeisclass=true;
next();
}else{
node.name=_332.keyword;
if(!eat(_36e)){
if(eat(_38c)){
if(_333==="<"){
var _4b5=true,_4b6=[];
node.protocols=_4b6;
do{
next();
if(_4b5){
_4b5=false;
}else{
eat(_3a4);
}
_4b6.push(_462(true));
}while(_333!==">");
next();
}
}else{
var _4b7;
if(eat(_386)||eat(_385)){
_4b7=_332.keyword||true;
}
if(eat(_388)||eat(_387)||eat(_389)){
if(_4b7){
node.name+=" "+_4b7;
}
_4b7=_332.keyword||true;
}else{
if(eat(_38a)){
if(_4b7){
node.name+=" "+_4b7;
}
_4b7=_332.keyword||true;
}
if(eat(_38b)){
if(_4b7){
node.name+=" "+_4b7;
}
_4b7=_332.keyword||true;
if(eat(_38b)){
node.name+=" "+_4b7;
}
}
}
if(!_4b7){
node.name=(!_30d.forbidReserved&&_332.keyword)||_3d4();
node.typeisclass=true;
next();
}
}
}
}
return _453(node,"ObjectiveJType");
};
})(typeof _2==="undefined"?(self.acorn={}):_2.acorn);
if(!_2.acorn){
_2.acorn={};
_2.acorn.walk={};
}
(function(_4b8){
"use strict";
_4b8.simple=function(node,_4b9,base,_4ba){
if(!base){
base=_4b8;
}
function c(node,st,_4bb){
var type=_4bb||node.type,_4bc=_4b9[type];
if(_4bc){
_4bc(node,st);
}
base[type](node,st,c);
};
c(node,_4ba);
};
_4b8.recursive=function(node,_4bd,_4be,base){
var _4bf=_4b8.make(_4be,base);
function c(node,st,_4c0){
return _4bf[_4c0||node.type](node,st,c);
};
return c(node,_4bd);
};
_4b8.make=function(_4c1,base){
if(!base){
base=_4b8;
}
var _4c2={};
for(var type in base){
_4c2[type]=base[type];
}
for(var type in _4c1){
_4c2[type]=_4c1[type];
}
return _4c2;
};
function _4c3(node,st,c){
c(node,st);
};
function _4c4(node,st,c){
};
_4b8.Program=_4b8.BlockStatement=function(node,st,c){
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
};
_4b8.Statement=_4c3;
_4b8.EmptyStatement=_4c4;
_4b8.ExpressionStatement=function(node,st,c){
c(node.expression,st,"Expression");
};
_4b8.IfStatement=function(node,st,c){
c(node.test,st,"Expression");
c(node.consequent,st,"Statement");
if(node.alternate){
c(node.alternate,st,"Statement");
}
};
_4b8.LabeledStatement=function(node,st,c){
c(node.body,st,"Statement");
};
_4b8.BreakStatement=_4b8.ContinueStatement=_4c4;
_4b8.WithStatement=function(node,st,c){
c(node.object,st,"Expression");
c(node.body,st,"Statement");
};
_4b8.SwitchStatement=function(node,st,c){
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
_4b8.ReturnStatement=function(node,st,c){
if(node.argument){
c(node.argument,st,"Expression");
}
};
_4b8.ThrowStatement=function(node,st,c){
c(node.argument,st,"Expression");
};
_4b8.TryStatement=function(node,st,c){
c(node.block,st,"Statement");
for(var i=0;i<node.handlers.length;++i){
c(node.handlers[i].body,st,"ScopeBody");
}
if(node.finalizer){
c(node.finalizer,st,"Statement");
}
};
_4b8.WhileStatement=function(node,st,c){
c(node.test,st,"Expression");
c(node.body,st,"Statement");
};
_4b8.DoWhileStatement=function(node,st,c){
c(node.body,st,"Statement");
c(node.test,st,"Expression");
};
_4b8.ForStatement=function(node,st,c){
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
_4b8.ForInStatement=function(node,st,c){
c(node.left,st,"ForInit");
c(node.right,st,"Expression");
c(node.body,st,"Statement");
};
_4b8.ForInit=function(node,st,c){
if(node.type=="VariableDeclaration"){
c(node,st);
}else{
c(node,st,"Expression");
}
};
_4b8.DebuggerStatement=_4c4;
_4b8.FunctionDeclaration=function(node,st,c){
c(node,st,"Function");
};
_4b8.VariableDeclaration=function(node,st,c){
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i];
if(decl.init){
c(decl.init,st,"Expression");
}
}
};
_4b8.Function=function(node,st,c){
c(node.body,st,"ScopeBody");
};
_4b8.ScopeBody=function(node,st,c){
c(node,st,"Statement");
};
_4b8.Expression=_4c3;
_4b8.ThisExpression=_4c4;
_4b8.ArrayExpression=_4b8.ArrayLiteral=function(node,st,c){
for(var i=0;i<node.elements.length;++i){
var elt=node.elements[i];
if(elt){
c(elt,st,"Expression");
}
}
};
_4b8.DictionaryLiteral=function(node,st,c){
for(var i=0;i<node.keys.length;i++){
var key=node.keys[i];
c(key,st,"Expression");
var _4c5=node.values[i];
c(_4c5,st,"Expression");
}
};
_4b8.ObjectExpression=function(node,st,c){
for(var i=0;i<node.properties.length;++i){
c(node.properties[i].value,st,"Expression");
}
};
_4b8.FunctionExpression=_4b8.FunctionDeclaration;
_4b8.SequenceExpression=function(node,st,c){
for(var i=0;i<node.expressions.length;++i){
c(node.expressions[i],st,"Expression");
}
};
_4b8.UnaryExpression=_4b8.UpdateExpression=function(node,st,c){
c(node.argument,st,"Expression");
};
_4b8.BinaryExpression=_4b8.AssignmentExpression=_4b8.LogicalExpression=function(node,st,c){
c(node.left,st,"Expression");
c(node.right,st,"Expression");
};
_4b8.ConditionalExpression=function(node,st,c){
c(node.test,st,"Expression");
c(node.consequent,st,"Expression");
c(node.alternate,st,"Expression");
};
_4b8.NewExpression=_4b8.CallExpression=function(node,st,c){
c(node.callee,st,"Expression");
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
c(node.arguments[i],st,"Expression");
}
}
};
_4b8.MemberExpression=function(node,st,c){
c(node.object,st,"Expression");
if(node.computed){
c(node.property,st,"Expression");
}
};
_4b8.Identifier=_4b8.Literal=_4c4;
_4b8.ClassDeclarationStatement=function(node,st,c){
if(node.ivardeclarations){
for(var i=0;i<node.ivardeclarations.length;++i){
c(node.ivardeclarations[i],st,"IvarDeclaration");
}
}
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
};
_4b8.ImportStatement=_4c4;
_4b8.IvarDeclaration=_4c4;
_4b8.PreprocessStatement=_4c4;
_4b8.ClassStatement=_4c4;
_4b8.GlobalStatement=_4c4;
_4b8.ProtocolDeclarationStatement=function(node,st,c){
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
_4b8.MethodDeclarationStatement=function(node,st,c){
var body=node.body;
if(body){
c(body,st,"Statement");
}
};
_4b8.MessageSendExpression=function(node,st,c){
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
_4b8.SelectorLiteralExpression=_4c4;
_4b8.ProtocolLiteralExpression=_4c4;
_4b8.Reference=function(node,st,c){
c(node.element,st,"Identifier");
};
_4b8.Dereference=function(node,st,c){
c(node.expr,st,"Expression");
};
function _4c6(prev){
return {vars:Object.create(null),prev:prev};
};
_4b8.scopeVisitor=_4b8.make({Function:function(node,_4c7,c){
var _4c8=_4c6(_4c7);
for(var i=0;i<node.params.length;++i){
_4c8.vars[node.params[i].name]={type:"argument",node:node.params[i]};
}
if(node.id){
var decl=node.type=="FunctionDeclaration";
(decl?_4c7:_4c8).vars[node.id.name]={type:decl?"function":"function name",node:node.id};
}
c(node.body,_4c8,"ScopeBody");
},TryStatement:function(node,_4c9,c){
c(node.block,_4c9,"Statement");
for(var i=0;i<node.handlers.length;++i){
var _4ca=node.handlers[i],_4cb=_4c6(_4c9);
_4cb.vars[_4ca.param.name]={type:"catch clause",node:_4ca.param};
c(_4ca.body,_4cb,"ScopeBody");
}
if(node.finalizer){
c(node.finalizer,_4c9,"Statement");
}
},VariableDeclaration:function(node,_4cc,c){
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i];
_4cc.vars[decl.id.name]={type:"var",node:decl.id};
if(decl.init){
c(decl.init,_4cc,"Expression");
}
}
}});
})(typeof _2=="undefined"?acorn.walk={}:_2.acorn.walk);
var _4cd=function(prev,base){
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
_4cd.prototype.compiler=function(){
return this.compiler;
};
_4cd.prototype.rootScope=function(){
return this.prev?this.prev.rootScope():this;
};
_4cd.prototype.isRootScope=function(){
return !this.prev;
};
_4cd.prototype.currentClassName=function(){
return this.classDef?this.classDef.name:this.prev?this.prev.currentClassName():null;
};
_4cd.prototype.currentProtocolName=function(){
return this.protocolDef?this.protocolDef.name:this.prev?this.prev.currentProtocolName():null;
};
_4cd.prototype.getIvarForCurrentClass=function(_4ce){
if(this.ivars){
var ivar=this.ivars[_4ce];
if(ivar){
return ivar;
}
}
var prev=this.prev;
if(prev&&!this.classDef){
return prev.getIvarForCurrentClass(_4ce);
}
return null;
};
_4cd.prototype.getLvar=function(_4cf,_4d0){
if(this.vars){
var lvar=this.vars[_4cf];
if(lvar){
return lvar;
}
}
var prev=this.prev;
if(prev&&(!_4d0||!this.methodType)){
return prev.getLvar(_4cf,_4d0);
}
return null;
};
_4cd.prototype.currentMethodType=function(){
return this.methodType?this.methodType:this.prev?this.prev.currentMethodType():null;
};
_4cd.prototype.copyAddedSelfToIvarsToParent=function(){
if(this.prev&&this.addedSelfToIvars){
for(var key in this.addedSelfToIvars){
var _4d1=this.addedSelfToIvars[key],_4d2=(this.prev.addedSelfToIvars||(this.prev.addedSelfToIvars=Object.create(null)))[key]||(this.prev.addedSelfToIvars[key]=[]);
_4d2.push.apply(_4d2,_4d1);
}
}
};
_4cd.prototype.addMaybeWarning=function(_4d3){
var _4d4=this.rootScope();
(_4d4._maybeWarnings||(_4d4._maybeWarnings=[])).push(_4d3);
};
_4cd.prototype.maybeWarnings=function(){
return this.rootScope()._maybeWarnings;
};
var _4d5=function(_4d6,node,code){
this.message=_4d7(_4d6,node,code);
this.node=node;
};
_4d5.prototype.checkIfWarning=function(st){
var _4d8=this.node.name;
return !st.getLvar(_4d8)&&typeof _1[_4d8]==="undefined"&&typeof window[_4d8]==="undefined"&&!st.compiler.getClassDef(_4d8);
};
function _2ae(){
this.atoms=[];
};
_2ae.prototype.toString=function(){
return this.atoms.join("");
};
_2ae.prototype.concat=function(_4d9){
this.atoms.push(_4d9);
};
_2ae.prototype.isEmpty=function(){
return this.atoms.length!==0;
};
var _4da=function(_4db,name,_4dc,_4dd,_4de,_4df,_4e0){
this.name=name;
if(_4dc){
this.superClass=_4dc;
}
if(_4dd){
this.ivars=_4dd;
}
if(_4db){
this.instanceMethods=_4de||Object.create(null);
this.classMethods=_4df||Object.create(null);
}
if(_4e0){
this.protocols=_4e0;
}
};
_4da.prototype.addInstanceMethod=function(_4e1){
this.instanceMethods[_4e1.name]=_4e1;
};
_4da.prototype.addClassMethod=function(_4e2){
this.classMethods[_4e2.name]=_4e2;
};
_4da.prototype.listOfNotImplementedMethodsForProtocols=function(_4e3){
var _4e4=[],_4e5=this.getInstanceMethods(),_4e6=this.getClassMethods();
for(var i=0,size=_4e3.length;i<size;i++){
var _4e7=_4e3[i],_4e8=_4e7.requiredInstanceMethods,_4e9=_4e7.requiredClassMethods,_4ea=_4e7.protocols;
if(_4e8){
for(var _4eb in _4e8){
var _4ec=_4e8[_4eb];
if(!_4e5[_4eb]){
_4e4.push({"methodDef":_4ec,"protocolDef":_4e7});
}
}
}
if(_4e9){
for(var _4eb in _4e9){
var _4ec=_4e9[_4eb];
if(!_4e6[_4eb]){
_4e4.push({"methodDef":_4ec,"protocolDef":_4e7});
}
}
}
if(_4ea){
_4e4=_4e4.concat(this.listOfNotImplementedMethodsForProtocols(_4ea));
}
}
return _4e4;
};
_4da.prototype.getInstanceMethod=function(name){
var _4ed=this.instanceMethods;
if(_4ed){
var _4ee=_4ed[name];
if(_4ee){
return _4ee;
}
}
var _4ef=this.superClass;
if(_4ef){
return _4ef.getInstanceMethod(name);
}
return null;
};
_4da.prototype.getClassMethod=function(name){
var _4f0=this.classMethods;
if(_4f0){
var _4f1=_4f0[name];
if(_4f1){
return _4f1;
}
}
var _4f2=this.superClass;
if(_4f2){
return _4f2.getClassMethod(name);
}
return null;
};
_4da.prototype.getInstanceMethods=function(){
var _4f3=this.instanceMethods;
if(_4f3){
var _4f4=this.superClass,_4f5=Object.create(null);
if(_4f4){
var _4f6=_4f4.getInstanceMethods();
for(var _4f7 in _4f6){
_4f5[_4f7]=_4f6[_4f7];
}
}
for(var _4f7 in _4f3){
_4f5[_4f7]=_4f3[_4f7];
}
return _4f5;
}
return [];
};
_4da.prototype.getClassMethods=function(){
var _4f8=this.classMethods;
if(_4f8){
var _4f9=this.superClass,_4fa=Object.create(null);
if(_4f9){
var _4fb=_4f9.getClassMethods();
for(var _4fc in _4fb){
_4fa[_4fc]=_4fb[_4fc];
}
}
for(var _4fc in _4f8){
_4fa[_4fc]=_4f8[_4fc];
}
return _4fa;
}
return [];
};
var _4fd=function(name,_4fe,_4ff,_500){
this.name=name;
this.protocols=_4fe;
if(_4ff){
this.requiredInstanceMethods=_4ff;
}
if(_500){
this.requiredClassMethods=_500;
}
};
_4fd.prototype.addInstanceMethod=function(_501){
(this.requiredInstanceMethods||(this.requiredInstanceMethods=Object.create(null)))[_501.name]=_501;
};
_4fd.prototype.addClassMethod=function(_502){
(this.requiredClassMethods||(this.requiredClassMethods=Object.create(null)))[_502.name]=_502;
};
_4fd.prototype.getInstanceMethod=function(name){
var _503=this.requiredInstanceMethods;
if(_503){
var _504=_503[name];
if(_504){
return _504;
}
}
var _505=this.protocols;
for(var i=0,size=_505.length;i<size;i++){
var _506=_505[i],_504=_506.getInstanceMethod(name);
if(_504){
return _504;
}
}
return null;
};
_4fd.prototype.getClassMethod=function(name){
var _507=this.requiredClassMethods;
if(_507){
var _508=_507[name];
if(_508){
return _508;
}
}
var _509=this.protocols;
for(var i=0,size=_509.length;i<size;i++){
var _50a=_509[i],_508=_50a.getInstanceMethod(name);
if(_508){
return _508;
}
}
return null;
};
var _50b=function(name,_50c){
this.name=name;
this.types=_50c;
};
var _50d="";
var _50e=_2.acorn.makePredicate("self _cmd undefined localStorage arguments");
var _50f=_2.acorn.makePredicate("delete in instanceof new typeof void");
var _510=_2.acorn.makePredicate("LogicalExpression BinaryExpression");
var _511=_2.acorn.makePredicate("in instanceof");
var _512=function(_513,aURL,_514,pass,_515,_516){
this.source=_513;
this.URL=new CFURL(aURL);
this.pass=pass;
this.jsBuffer=new _2ae();
this.imBuffer=null;
this.cmBuffer=null;
this.warnings=[];
try{
this.tokens=_2.acorn.parse(_513);
}
catch(e){
if(e.lineStart!=null){
var _517=this.prettifyMessage(e,"ERROR");
console.log(_517);
}
throw e;
}
this.dependencies=[];
this.flags=_514|_512.Flags.IncludeDebugSymbols;
this.classDefs=_515?_515:Object.create(null);
this.protocolDefs=_516?_516:Object.create(null);
this.lastPos=0;
if(_50d&_512.Flags.Generate){
this.generate=true;
}
this.generate=true;
_518(this.tokens,new _4cd(null,{compiler:this}),pass===2?_519:_51a);
};
_2.ObjJAcornCompiler=_512;
_2.ObjJAcornCompiler.compileToExecutable=function(_51b,aURL,_51c){
_512.currentCompileFile=aURL;
return new _512(_51b,aURL,_51c,2).executable();
};
_2.ObjJAcornCompiler.compileToIMBuffer=function(_51d,aURL,_51e,_51f,_520){
return new _512(_51d,aURL,_51e,2,_51f,_520).IMBuffer();
};
_2.ObjJAcornCompiler.compileFileDependencies=function(_521,aURL,_522){
_512.currentCompileFile=aURL;
return new _512(_521,aURL,_522,1).executable();
};
_512.prototype.compilePass2=function(){
_512.currentCompileFile=this.URL;
this.pass=2;
this.jsBuffer=new _2ae();
this.warnings=[];
_518(this.tokens,new _4cd(null,{compiler:this}),_519);
for(var i=0;i<this.warnings.length;i++){
var _523=this.prettifyMessage(this.warnings[i],"WARNING");
console.log(_523);
}
return this.jsBuffer.toString();
};
var _50d="";
_2.setCurrentCompilerFlags=function(_524){
_50d=_524;
};
_2.currentCompilerFlags=function(_525){
return _50d;
};
_512.Flags={};
_512.Flags.IncludeDebugSymbols=1<<0;
_512.Flags.IncludeTypeSignatures=1<<1;
_512.Flags.Generate=1<<2;
_512.prototype.addWarning=function(_526){
this.warnings.push(_526);
};
_512.prototype.getIvarForClass=function(_527,_528){
var ivar=_528.getIvarForCurrentClass(_527);
if(ivar){
return ivar;
}
var c=this.getClassDef(_528.currentClassName());
while(c){
var _529=c.ivars;
if(_529){
var _52a=_529[_527];
if(_52a){
return _52a;
}
}
c=c.superClass;
}
};
_512.prototype.getClassDef=function(_52b){
if(!_52b){
return null;
}
var c=this.classDefs[_52b];
if(c){
return c;
}
if(typeof objj_getClass==="function"){
var _52c=objj_getClass(_52b);
if(_52c){
var _52d=class_copyIvarList(_52c),_52e=_52d.length,_52f=Object.create(null),_530=class_copyProtocolList(_52c),_531=_530.length,_532=Object.create(null),_533=_512.methodDefsFromMethodList(class_copyMethodList(_52c)),_534=_512.methodDefsFromMethodList(class_copyMethodList(_52c.isa)),_535=class_getSuperclass(_52c);
for(var i=0;i<_52e;i++){
var ivar=_52d[i];
_52f[ivar.name]={"type":ivar.type,"name":ivar.name};
}
for(var i=0;i<_531;i++){
var _536=_530[i],_537=protocol_getName(_536),_538=this.getProtocolDef(_537);
_532[_537]=_538;
}
c=new _4da(true,_52b,_535?this.getClassDef(_535.name):null,_52f,_533,_534,_532);
this.classDefs[_52b]=c;
return c;
}
}
return null;
};
_512.prototype.getProtocolDef=function(_539){
if(!_539){
return null;
}
var p=this.protocolDefs[_539];
if(p){
return p;
}
if(typeof objj_getProtocol==="function"){
var _53a=objj_getProtocol(_539);
if(_53a){
var _53b=protocol_getName(_53a),_53c=protocol_copyMethodDescriptionList(_53a,true,true),_53d=_512.methodDefsFromMethodList(_53c),_53e=protocol_copyMethodDescriptionList(_53a,true,false),_53f=_512.methodDefsFromMethodList(_53e),_540=_53a.protocols,_541=[];
if(_540){
for(var i=0,size=_540.length;i<size;i++){
_541.push(compiler.getProtocolDef(_540[i].name));
}
}
p=new _4fd(_53b,_541,_53d,_53f);
this.protocolDefs[_539]=p;
return p;
}
}
return null;
};
_512.methodDefsFromMethodList=function(_542){
var _543=_542.length,_544=Object.create(null);
for(var i=0;i<_543;i++){
var _545=_542[i],_546=method_getName(_545);
_544[_546]=new _50b(_546,_545.types);
}
return _544;
};
_512.prototype.executable=function(){
if(!this._executable){
this._executable=new _2bd(this.jsBuffer?this.jsBuffer.toString():null,this.dependencies,this.URL,null,this);
}
return this._executable;
};
_512.prototype.IMBuffer=function(){
return this.imBuffer;
};
_512.prototype.JSBuffer=function(){
return this.jsBuffer;
};
_512.prototype.prettifyMessage=function(_547,_548){
var line=this.source.substring(_547.lineStart,_547.lineEnd),_549="\n"+line;
_549+=(new Array(_547.column+1)).join(" ");
_549+=(new Array(Math.min(1,line.length)+1)).join("^")+"\n";
_549+=_548+" line "+_547.line+" in "+this.URL+": "+_547.message;
return _549;
};
_512.prototype.error_message=function(_54a,node){
var pos=_2.acorn.getLineInfo(this.source,node.start),_54b={message:_54a,line:pos.line,column:pos.column,lineStart:pos.lineStart,lineEnd:pos.lineEnd};
return new SyntaxError(this.prettifyMessage(_54b,"ERROR"));
};
_512.prototype.pushImport=function(url){
if(!_512.importStack){
_512.importStack=[];
}
_512.importStack.push(url);
};
_512.prototype.popImport=function(){
_512.importStack.pop();
};
function _4d7(_54c,node,code){
var _54d=_2.acorn.getLineInfo(code,node.start);
_54d.message=_54c;
return _54d;
};
function _518(node,_54e,_54f){
function c(node,st,_550){
_54f[_550||node.type](node,st,c);
};
c(node,_54e);
};
function _551(node){
switch(node.type){
case "Literal":
case "Identifier":
return true;
case "ArrayExpression":
for(var i=0;i<node.elements.length;++i){
if(!_551(node.elements[i])){
return false;
}
}
return true;
case "DictionaryLiteral":
for(var i=0;i<node.keys.length;++i){
if(!_551(node.keys[i])){
return false;
}
if(!_551(node.values[i])){
return false;
}
}
return true;
case "ObjectExpression":
for(var i=0;i<node.properties.length;++i){
if(!_551(node.properties[i].value)){
return false;
}
}
return true;
case "FunctionExpression":
for(var i=0;i<node.params.length;++i){
if(!_551(node.params[i])){
return false;
}
}
return true;
case "SequenceExpression":
for(var i=0;i<node.expressions.length;++i){
if(!_551(node.expressions[i])){
return false;
}
}
return true;
case "UnaryExpression":
return _551(node.argument);
case "BinaryExpression":
return _551(node.left)&&_551(node.right);
case "ConditionalExpression":
return _551(node.test)&&_551(node.consequent)&&_551(node.alternate);
case "MemberExpression":
return _551(node.object)&&(!node.computed||_551(node.property));
case "Dereference":
return _551(node.expr);
case "Reference":
return _551(node.element);
default:
return false;
}
};
function _552(st,node){
if(!_551(node)){
throw st.compiler.error_message("Dereference of expression with side effects",node);
}
};
function _553(c){
return function(node,st,_554){
st.compiler.jsBuffer.concat("(");
c(node,st,_554);
st.compiler.jsBuffer.concat(")");
};
};
var _555={"*":3,"/":3,"%":3,"+":4,"-":4,"<<":5,">>":5,">>>":5,"<":6,"<=":6,">":6,">=":6,"in":6,"instanceof":6,"==":7,"!=":7,"===":7,"!==":7,"&":8,"^":9,"|":10,"&&":11,"||":12};
var _556={MemberExpression:0,CallExpression:1,NewExpression:2,FunctionExpression:3,UnaryExpression:4,UpdateExpression:4,BinaryExpression:5,LogicalExpression:6,ConditionalExpression:7,AssignmentExpression:8};
function _557(node,_558,_559){
var _55a=node.type,_557=_556[_55a]||-1,_55b=_556[_558.type]||-1,_55c,_55d;
return _557<_55b||(_557===_55b&&_510(_55a)&&((_55c=_555[node.operator])<(_55d=_555[_558.operator])||(_559&&_55c===_55d)));
};
var _51a=_2.acorn.walk.make({ImportStatement:function(node,st,c){
var _55e=node.filename.value;
st.compiler.dependencies.push(new _2ec(new CFURL(_55e),node.localfilepath));
}});
var _55f=4;
var _560=Array(_55f+1).join(" ");
var _561="";
var _519=_2.acorn.walk.make({Program:function(node,st,c){
var _562=st.compiler,_563=_562.generate;
_561="";
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
if(!_563){
_562.jsBuffer.concat(_562.source.substring(_562.lastPos,node.end));
}
var _564=st.maybeWarnings();
if(_564){
for(var i=0;i<_564.length;i++){
var _565=_564[i];
if(_565.checkIfWarning(st)){
_562.addWarning(_565.message);
}
}
}
},BlockStatement:function(node,st,c){
var _566=st.compiler,_567=_566.generate,_568=st.endOfScopeBody,_569;
if(_568){
delete st.endOfScopeBody;
}
if(_567){
st.indentBlockLevel=typeof st.indentBlockLevel==="undefined"?0:st.indentBlockLevel+1;
_569=_566.jsBuffer;
_569.concat(_561.substring(_55f));
_569.concat("{\n");
}
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
if(_567){
var _56a=st.maxReceiverLevel;
if(_568&&_56a){
_569.concat(_561);
_569.concat("var ");
for(var i=0;i<_56a;i++){
if(i){
_569.concat(", ");
}
_569.concat("___r");
_569.concat((i+1)+"");
}
_569.concat(";\n");
}
_569.concat(_561.substring(_55f));
_569.concat("}");
if(st.isDecl||st.indentBlockLevel>0){
_569.concat("\n");
}
st.indentBlockLevel--;
}
},ExpressionStatement:function(node,st,c){
var _56b=st.compiler,_56c=_56b.generate;
if(_56c){
_56b.jsBuffer.concat(_561);
}
c(node.expression,st,"Expression");
if(_56c){
_56b.jsBuffer.concat(";\n");
}
},IfStatement:function(node,st,c){
var _56d=st.compiler,_56e=_56d.generate,_56f;
if(_56e){
_56f=_56d.jsBuffer;
if(!st.superNodeIsElse){
_56f.concat(_561);
}else{
delete st.superNodeIsElse;
}
_56f.concat("if (");
}
c(node.test,st,"Expression");
if(_56e){
_56f.concat(node.consequent.type==="EmptyStatement"?");\n":")\n");
}
_561+=_560;
c(node.consequent,st,"Statement");
_561=_561.substring(_55f);
var _570=node.alternate;
if(_570){
var _571=_570.type!=="IfStatement";
if(_56e){
var _572=_570.type==="EmptyStatement";
_56f.concat(_561);
_56f.concat(_571?_572?"else;\n":"else\n":"else ");
}
if(_571){
_561+=_560;
}else{
st.superNodeIsElse=true;
}
c(_570,st,"Statement");
if(_571){
_561=_561.substring(_55f);
}
}
},LabeledStatement:function(node,st,c){
var _573=st.compiler;
if(_573.generate){
var _574=_573.jsBuffer;
_574.concat(_561);
_574.concat(node.label.name);
_574.concat(": ");
}
c(node.body,st,"Statement");
},BreakStatement:function(node,st,c){
var _575=st.compiler;
if(_575.generate){
_575.jsBuffer.concat(_561);
if(node.label){
_575.jsBuffer.concat("break ");
_575.jsBuffer.concat(node.label.name);
_575.jsBuffer.concat(";\n");
}else{
_575.jsBuffer.concat("break;\n");
}
}
},ContinueStatement:function(node,st,c){
var _576=st.compiler;
if(_576.generate){
var _577=_576.jsBuffer;
_577.concat(_561);
if(node.label){
_577.concat("continue ");
_577.concat(node.label.name);
_577.concat(";\n");
}else{
_577.concat("continue;\n");
}
}
},WithStatement:function(node,st,c){
var _578=st.compiler,_579=_578.generate,_57a;
if(_579){
_57a=_578.jsBuffer;
_57a.concat(_561);
_57a.concat("with(");
}
c(node.object,st,"Expression");
if(_579){
_57a.concat(")\n");
}
_561+=_560;
c(node.body,st,"Statement");
_561=_561.substring(_55f);
},SwitchStatement:function(node,st,c){
var _57b=st.compiler,_57c=_57b.generate,_57d;
if(_57c){
_57d=_57b.jsBuffer;
_57d.concat(_561);
_57d.concat("switch(");
}
c(node.discriminant,st,"Expression");
if(_57c){
_57d.concat(") {\n");
}
for(var i=0;i<node.cases.length;++i){
var cs=node.cases[i];
if(cs.test){
if(_57c){
_57d.concat(_561);
_57d.concat("case ");
}
c(cs.test,st,"Expression");
if(_57c){
_57d.concat(":\n");
}
}else{
if(_57c){
_57d.concat("default:\n");
}
}
_561+=_560;
for(var j=0;j<cs.consequent.length;++j){
c(cs.consequent[j],st,"Statement");
}
_561=_561.substring(_55f);
}
if(_57c){
_57d.concat(_561);
_57d.concat("}\n");
}
},ReturnStatement:function(node,st,c){
var _57e=st.compiler,_57f=_57e.generate,_580;
if(_57f){
_580=_57e.jsBuffer;
_580.concat(_561);
_580.concat("return");
}
if(node.argument){
if(_57f){
_580.concat(" ");
}
c(node.argument,st,"Expression");
}
if(_57f){
_580.concat(";\n");
}
},ThrowStatement:function(node,st,c){
var _581=st.compiler,_582=_581.generate,_583;
if(_582){
_583=_581.jsBuffer;
_583.concat(_561);
_583.concat("throw ");
}
c(node.argument,st,"Expression");
if(_582){
_583.concat(";\n");
}
},TryStatement:function(node,st,c){
var _584=st.compiler,_585=_584.generate,_586;
if(_585){
_586=_584.jsBuffer;
_586.concat(_561);
_586.concat("try");
}
_561+=_560;
c(node.block,st,"Statement");
_561=_561.substring(_55f);
for(var i=0;i<node.handlers.length;++i){
var _587=node.handlers[i],_588=new _4cd(st),_589=_587.param,name=_589.name;
_588.vars[name]={type:"catch clause",node:_589};
if(_585){
_586.concat(_561);
_586.concat("catch(");
_586.concat(name);
_586.concat(") ");
}
_561+=_560;
_588.endOfScopeBody=true;
c(_587.body,_588,"ScopeBody");
_561=_561.substring(_55f);
_588.copyAddedSelfToIvarsToParent();
}
if(node.finalizer){
if(_585){
_586.concat(_561);
_586.concat("finally ");
}
_561+=_560;
c(node.finalizer,st,"Statement");
_561=_561.substring(_55f);
}
},WhileStatement:function(node,st,c){
var _58a=st.compiler,_58b=_58a.generate,body=node.body,_58c;
if(_58b){
_58c=_58a.jsBuffer;
_58c.concat(_561);
_58c.concat("while (");
}
c(node.test,st,"Expression");
if(_58b){
_58c.concat(body.type==="EmptyStatement"?");\n":")\n");
}
_561+=_560;
c(body,st,"Statement");
_561=_561.substring(_55f);
},DoWhileStatement:function(node,st,c){
var _58d=st.compiler,_58e=_58d.generate,_58f;
if(_58e){
_58f=_58d.jsBuffer;
_58f.concat(_561);
_58f.concat("do\n");
}
_561+=_560;
c(node.body,st,"Statement");
_561=_561.substring(_55f);
if(_58e){
_58f.concat(_561);
_58f.concat("while (");
}
c(node.test,st,"Expression");
if(_58e){
_58f.concat(");\n");
}
},ForStatement:function(node,st,c){
var _590=st.compiler,_591=_590.generate,body=node.body,_592;
if(_591){
_592=_590.jsBuffer;
_592.concat(_561);
_592.concat("for (");
}
if(node.init){
c(node.init,st,"ForInit");
}
if(_591){
_592.concat("; ");
}
if(node.test){
c(node.test,st,"Expression");
}
if(_591){
_592.concat("; ");
}
if(node.update){
c(node.update,st,"Expression");
}
if(_591){
_592.concat(body.type==="EmptyStatement"?");\n":")\n");
}
_561+=_560;
c(body,st,"Statement");
_561=_561.substring(_55f);
},ForInStatement:function(node,st,c){
var _593=st.compiler,_594=_593.generate,body=node.body,_595;
if(_594){
_595=_593.jsBuffer;
_595.concat(_561);
_595.concat("for (");
}
c(node.left,st,"ForInit");
if(_594){
_595.concat(" in ");
}
c(node.right,st,"Expression");
if(_594){
_595.concat(body.type==="EmptyStatement"?");\n":")\n");
}
_561+=_560;
c(body,st,"Statement");
_561=_561.substring(_55f);
},ForInit:function(node,st,c){
var _596=st.compiler,_597=_596.generate;
if(node.type==="VariableDeclaration"){
st.isFor=true;
c(node,st);
delete st.isFor;
}else{
c(node,st,"Expression");
}
},DebuggerStatement:function(node,st,c){
var _598=st.compiler;
if(_598.generate){
var _599=_598.jsBuffer;
_599.concat(_561);
_599.concat("debugger;\n");
}
},Function:function(node,st,c){
var _59a=st.compiler,_59b=_59a.generate,_59c=_59a.jsBuffer;
inner=new _4cd(st),decl=node.type=="FunctionDeclaration";
inner.isDecl=decl;
for(var i=0;i<node.params.length;++i){
inner.vars[node.params[i].name]={type:"argument",node:node.params[i]};
}
if(node.id){
(decl?st:inner).vars[node.id.name]={type:decl?"function":"function name",node:node.id};
if(_59b){
_59c.concat(node.id.name);
_59c.concat(" = ");
}else{
_59c.concat(_59a.source.substring(_59a.lastPos,node.start));
_59c.concat(node.id.name);
_59c.concat(" = function");
_59a.lastPos=node.id.end;
}
}
if(_59b){
_59c.concat("function(");
for(var i=0;i<node.params.length;++i){
if(i){
_59c.concat(", ");
}
_59c.concat(node.params[i].name);
}
_59c.concat(")\n");
}
_561+=_560;
inner.endOfScopeBody=true;
c(node.body,inner,"ScopeBody");
_561=_561.substring(_55f);
inner.copyAddedSelfToIvarsToParent();
},VariableDeclaration:function(node,st,c){
var _59d=st.compiler,_59e=_59d.generate,_59f;
if(_59e){
_59f=_59d.jsBuffer;
if(!st.isFor){
_59f.concat(_561);
}
_59f.concat("var ");
}
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i],_5a0=decl.id.name;
if(i){
if(_59e){
if(st.isFor){
_59f.concat(", ");
}else{
_59f.concat(",\n");
_59f.concat(_561);
_59f.concat("    ");
}
}
}
st.vars[_5a0]={type:"var",node:decl.id};
if(_59e){
_59f.concat(_5a0);
}
if(decl.init){
if(_59e){
_59f.concat(" = ");
}
c(decl.init,st,"Expression");
}
if(st.addedSelfToIvars){
var _5a1=st.addedSelfToIvars[_5a0];
if(_5a1){
var _59f=st.compiler.jsBuffer.atoms;
for(var i=0;i<_5a1.length;i++){
var dict=_5a1[i];
_59f[dict.index]="";
_59d.addWarning(_4d7("Local declaration of '"+_5a0+"' hides instance variable",dict.node,_59d.source));
}
st.addedSelfToIvars[_5a0]=[];
}
}
}
if(_59e&&!st.isFor){
_59d.jsBuffer.concat(";\n");
}
},ThisExpression:function(node,st,c){
var _5a2=st.compiler;
if(_5a2.generate){
_5a2.jsBuffer.concat("this");
}
},ArrayExpression:function(node,st,c){
var _5a3=st.compiler,_5a4=_5a3.generate;
if(_5a4){
_5a3.jsBuffer.concat("[");
}
for(var i=0;i<node.elements.length;++i){
var elt=node.elements[i];
if(i!==0){
if(_5a4){
_5a3.jsBuffer.concat(", ");
}
}
if(elt){
c(elt,st,"Expression");
}
}
if(_5a4){
_5a3.jsBuffer.concat("]");
}
},ObjectExpression:function(node,st,c){
var _5a5=st.compiler,_5a6=_5a5.generate;
if(_5a6){
_5a5.jsBuffer.concat("{");
}
for(var i=0;i<node.properties.length;++i){
var prop=node.properties[i];
if(_5a6){
if(i){
_5a5.jsBuffer.concat(", ");
}
st.isPropertyKey=true;
c(prop.key,st,"Expression");
delete st.isPropertyKey;
_5a5.jsBuffer.concat(": ");
}else{
if(prop.key.raw&&prop.key.raw.charAt(0)==="@"){
_5a5.jsBuffer.concat(_5a5.source.substring(_5a5.lastPos,prop.key.start));
_5a5.lastPos=prop.key.start+1;
}
}
c(prop.value,st,"Expression");
}
if(_5a6){
_5a5.jsBuffer.concat("}");
}
},SequenceExpression:function(node,st,c){
var _5a7=st.compiler,_5a8=_5a7.generate;
if(_5a8){
_5a7.jsBuffer.concat("(");
}
for(var i=0;i<node.expressions.length;++i){
if(_5a8&&i!==0){
_5a7.jsBuffer.concat(", ");
}
c(node.expressions[i],st,"Expression");
}
if(_5a8){
_5a7.jsBuffer.concat(")");
}
},UnaryExpression:function(node,st,c){
var _5a9=st.compiler,_5aa=_5a9.generate,_5ab=node.argument;
if(_5aa){
if(node.prefix){
_5a9.jsBuffer.concat(node.operator);
if(_50f(node.operator)){
_5a9.jsBuffer.concat(" ");
}
(_557(node,_5ab)?_553(c):c)(_5ab,st,"Expression");
}else{
(_557(node,_5ab)?_553(c):c)(_5ab,st,"Expression");
_5a9.jsBuffer.concat(node.operator);
}
}else{
c(_5ab,st,"Expression");
}
},UpdateExpression:function(node,st,c){
var _5ac=st.compiler,_5ad=_5ac.generate;
if(node.argument.type==="Dereference"){
_552(st,node.argument);
if(!_5ad){
_5ac.jsBuffer.concat(_5ac.source.substring(_5ac.lastPos,node.start));
}
_5ac.jsBuffer.concat((node.prefix?"":"(")+"(");
if(!_5ad){
_5ac.lastPos=node.argument.expr.start;
}
c(node.argument.expr,st,"Expression");
if(!_5ad){
_5ac.jsBuffer.concat(_5ac.source.substring(_5ac.lastPos,node.argument.expr.end));
}
_5ac.jsBuffer.concat(")(");
if(!_5ad){
_5ac.lastPos=node.argument.start;
}
c(node.argument,st,"Expression");
if(!_5ad){
_5ac.jsBuffer.concat(_5ac.source.substring(_5ac.lastPos,node.argument.end));
}
_5ac.jsBuffer.concat(" "+node.operator.substring(0,1)+" 1)"+(node.prefix?"":node.operator=="++"?" - 1)":" + 1)"));
if(!_5ad){
_5ac.lastPos=node.end;
}
return;
}
if(node.prefix){
if(_5ad){
_5ac.jsBuffer.concat(node.operator);
if(_50f(node.operator)){
_5ac.jsBuffer.concat(" ");
}
}
(_5ad&&_557(node,node.argument)?_553(c):c)(node.argument,st,"Expression");
}else{
(_5ad&&_557(node,node.argument)?_553(c):c)(node.argument,st,"Expression");
if(_5ad){
_5ac.jsBuffer.concat(node.operator);
}
}
},BinaryExpression:function(node,st,c){
var _5ae=st.compiler,_5af=_5ae.generate,_5b0=_511(node.operator);
(_5af&&_557(node,node.left)?_553(c):c)(node.left,st,"Expression");
if(_5af){
var _5b1=_5ae.jsBuffer;
_5b1.concat(" ");
_5b1.concat(node.operator);
_5b1.concat(" ");
}
(_5af&&_557(node,node.right,true)?_553(c):c)(node.right,st,"Expression");
},LogicalExpression:function(node,st,c){
var _5b2=st.compiler,_5b3=_5b2.generate;
(_5b3&&_557(node,node.left)?_553(c):c)(node.left,st,"Expression");
if(_5b3){
var _5b4=_5b2.jsBuffer;
_5b4.concat(" ");
_5b4.concat(node.operator);
_5b4.concat(" ");
}
(_5b3&&_557(node,node.right,true)?_553(c):c)(node.right,st,"Expression");
},AssignmentExpression:function(node,st,c){
var _5b5=st.compiler,_5b6=_5b5.generate,_5b7=st.assignment,_5b8=_5b5.jsBuffer;
if(node.left.type==="Dereference"){
_552(st,node.left);
if(!_5b6){
_5b8.concat(_5b5.source.substring(_5b5.lastPos,node.start));
}
_5b8.concat("(");
if(!_5b6){
_5b5.lastPos=node.left.expr.start;
}
c(node.left.expr,st,"Expression");
if(!_5b6){
_5b8.concat(_5b5.source.substring(_5b5.lastPos,node.left.expr.end));
}
_5b8.concat(")(");
if(node.operator!=="="){
if(!_5b6){
_5b5.lastPos=node.left.start;
}
c(node.left,st,"Expression");
if(!_5b6){
_5b8.concat(_5b5.source.substring(_5b5.lastPos,node.left.end));
}
_5b8.concat(" "+node.operator.substring(0,1)+" ");
}
if(!_5b6){
_5b5.lastPos=node.right.start;
}
c(node.right,st,"Expression");
if(!_5b6){
_5b8.concat(_5b5.source.substring(_5b5.lastPos,node.right.end));
}
_5b8.concat(")");
if(!_5b6){
_5b5.lastPos=node.end;
}
return;
}
var _5b7=st.assignment,_5b9=node.left;
st.assignment=true;
if(_5b9.type==="Identifier"&&_5b9.name==="self"){
var lVar=st.getLvar("self",true);
if(lVar){
var _5ba=lVar.scope;
if(_5ba){
_5ba.assignmentToSelf=true;
}
}
}
(_5b6&&_557(node,_5b9)?_553(c):c)(_5b9,st,"Expression");
if(_5b6){
_5b8.concat(" ");
_5b8.concat(node.operator);
_5b8.concat(" ");
}
st.assignment=_5b7;
(_5b6&&_557(node,node.right,true)?_553(c):c)(node.right,st,"Expression");
if(st.isRootScope()&&_5b9.type==="Identifier"&&!st.getLvar(_5b9.name)){
st.vars[_5b9.name]={type:"global",node:_5b9};
}
},ConditionalExpression:function(node,st,c){
var _5bb=st.compiler,_5bc=_5bb.generate;
(_5bc&&_557(node,node.test)?_553(c):c)(node.test,st,"Expression");
if(_5bc){
_5bb.jsBuffer.concat(" ? ");
}
c(node.consequent,st,"Expression");
if(_5bc){
_5bb.jsBuffer.concat(" : ");
}
c(node.alternate,st,"Expression");
},NewExpression:function(node,st,c){
var _5bd=st.compiler,_5be=_5bd.generate;
if(_5be){
_5bd.jsBuffer.concat("new ");
}
(_5be&&_557(node,node.callee)?_553(c):c)(node.callee,st,"Expression");
if(_5be){
_5bd.jsBuffer.concat("(");
}
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
if(_5be&&i){
_5bd.jsBuffer.concat(", ");
}
c(node.arguments[i],st,"Expression");
}
}
if(_5be){
_5bd.jsBuffer.concat(")");
}
},CallExpression:function(node,st,c){
var _5bf=st.compiler,_5c0=_5bf.generate,_5c1=node.callee;
if(_5c1.type==="Identifier"&&_5c1.name==="eval"){
var _5c2=st.getLvar("self",true);
if(_5c2){
var _5c3=_5c2.scope;
if(_5c3){
_5c3.assignmentToSelf=true;
}
}
}
(_5c0&&_557(node,_5c1)?_553(c):c)(_5c1,st,"Expression");
if(_5c0){
_5bf.jsBuffer.concat("(");
}
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
if(_5c0&&i){
_5bf.jsBuffer.concat(", ");
}
c(node.arguments[i],st,"Expression");
}
}
if(_5c0){
_5bf.jsBuffer.concat(")");
}
},MemberExpression:function(node,st,c){
var _5c4=st.compiler,_5c5=_5c4.generate,_5c6=node.computed;
(_5c5&&_557(node,node.object)?_553(c):c)(node.object,st,"Expression");
if(_5c5){
if(_5c6){
_5c4.jsBuffer.concat("[");
}else{
_5c4.jsBuffer.concat(".");
}
}
st.secondMemberExpression=!_5c6;
(_5c5&&!_5c6&&_557(node,node.property)?_553(c):c)(node.property,st,"Expression");
st.secondMemberExpression=false;
if(_5c5&&_5c6){
_5c4.jsBuffer.concat("]");
}
},Identifier:function(node,st,c){
var _5c7=st.compiler,_5c8=_5c7.generate,_5c9=node.name;
if(st.currentMethodType()==="-"&&!st.secondMemberExpression&&!st.isPropertyKey){
var lvar=st.getLvar(_5c9,true),ivar=_5c7.getIvarForClass(_5c9,st);
if(ivar){
if(lvar){
_5c7.addWarning(_4d7("Local declaration of '"+_5c9+"' hides instance variable",node,_5c7.source));
}else{
var _5ca=node.start;
if(!_5c8){
do{
_5c7.jsBuffer.concat(_5c7.source.substring(_5c7.lastPos,_5ca));
_5c7.lastPos=_5ca;
}while(_5c7.source.substr(_5ca++,1)==="(");
}
((st.addedSelfToIvars||(st.addedSelfToIvars=Object.create(null)))[_5c9]||(st.addedSelfToIvars[_5c9]=[])).push({node:node,index:_5c7.jsBuffer.atoms.length});
_5c7.jsBuffer.concat("self.");
}
}else{
if(!_50e(_5c9)){
var _5cb,_5cc=typeof _1[_5c9]!=="undefined"||typeof window[_5c9]!=="undefined"||_5c7.getClassDef(_5c9),_5cd=st.getLvar(_5c9);
if(_5cc&&(!_5cd||_5cd.type!=="class")){
}else{
if(!_5cd){
if(st.assignment){
_5cb=new _4d5("Creating global variable inside function or method '"+_5c9+"'",node,_5c7.source);
st.vars[_5c9]={type:"remove global warning",node:node};
}else{
_5cb=new _4d5("Using unknown class or uninitialized global variable '"+_5c9+"'",node,_5c7.source);
}
}
}
if(_5cb){
st.addMaybeWarning(_5cb);
}
}
}
}
if(_5c8){
_5c7.jsBuffer.concat(_5c9);
}
},Literal:function(node,st,c){
var _5ce=st.compiler,_5cf=_5ce.generate;
if(_5cf){
if(node.raw&&node.raw.charAt(0)==="@"){
_5ce.jsBuffer.concat(node.raw.substring(1));
}else{
_5ce.jsBuffer.concat(node.raw);
}
}else{
if(node.raw.charAt(0)==="@"){
_5ce.jsBuffer.concat(_5ce.source.substring(_5ce.lastPos,node.start));
_5ce.lastPos=node.start+1;
}
}
},ArrayLiteral:function(node,st,c){
var _5d0=st.compiler,_5d1=_5d0.generate;
if(!_5d1){
_5d0.jsBuffer.concat(_5d0.source.substring(_5d0.lastPos,node.start));
_5d0.lastPos=node.start;
}
if(!_5d1){
buffer.concat(" ");
}
if(!node.elements.length){
_5d0.jsBuffer.concat("objj_msgSend(objj_msgSend(CPArray, \"alloc\"), \"init\")");
}else{
_5d0.jsBuffer.concat("objj_msgSend(objj_msgSend(CPArray, \"alloc\"), \"initWithObjects:count:\", [");
for(var i=0;i<node.elements.length;i++){
var elt=node.elements[i];
if(i){
_5d0.jsBuffer.concat(", ");
}
if(!_5d1){
_5d0.lastPos=elt.start;
}
c(elt,st,"Expression");
if(!_5d1){
_5d0.jsBuffer.concat(_5d0.source.substring(_5d0.lastPos,elt.end));
}
}
_5d0.jsBuffer.concat("], "+node.elements.length+")");
}
if(!_5d1){
_5d0.lastPos=node.end;
}
},DictionaryLiteral:function(node,st,c){
var _5d2=st.compiler,_5d3=_5d2.generate;
if(!_5d3){
_5d2.jsBuffer.concat(_5d2.source.substring(_5d2.lastPos,node.start));
_5d2.lastPos=node.start;
}
if(!_5d3){
buffer.concat(" ");
}
if(!node.keys.length){
_5d2.jsBuffer.concat("objj_msgSend(objj_msgSend(CPDictionary, \"alloc\"), \"init\")");
}else{
_5d2.jsBuffer.concat("objj_msgSend(objj_msgSend(CPDictionary, \"alloc\"), \"initWithObjectsAndKeys:\"");
for(var i=0;i<node.keys.length;i++){
var key=node.keys[i],_5d4=node.values[i];
_5d2.jsBuffer.concat(", ");
if(!_5d3){
_5d2.lastPos=_5d4.start;
}
c(_5d4,st,"Expression");
if(!_5d3){
_5d2.jsBuffer.concat(_5d2.source.substring(_5d2.lastPos,_5d4.end));
}
_5d2.jsBuffer.concat(", ");
if(!_5d3){
_5d2.lastPos=key.start;
}
c(key,st,"Expression");
if(!_5d3){
_5d2.jsBuffer.concat(_5d2.source.substring(_5d2.lastPos,key.end));
}
}
_5d2.jsBuffer.concat(")");
}
if(!_5d3){
_5d2.lastPos=node.end;
}
},ImportStatement:function(node,st,c){
var _5d5=st.compiler,_5d6=_5d5.generate,_5d7=_5d5.jsBuffer;
if(!_5d6){
_5d7.concat(_5d5.source.substring(_5d5.lastPos,node.start));
}
_5d7.concat("objj_executeFile(\"");
_5d7.concat(node.filename.value);
_5d7.concat(node.localfilepath?"\", YES);":"\", NO);");
if(!_5d6){
_5d5.lastPos=node.end;
}
},ClassDeclarationStatement:function(node,st,c){
var _5d8=st.compiler,_5d9=_5d8.generate,_5da=_5d8.jsBuffer,_5db=node.classname.name,_5dc=_5d8.getClassDef(_5db),_5dd=new _4cd(st),_5de=node.type==="InterfaceDeclarationStatement",_5df=node.protocols;
_5d8.imBuffer=new _2ae();
_5d8.cmBuffer=new _2ae();
_5d8.classBodyBuffer=new _2ae();
if(!_5d9){
_5da.concat(_5d8.source.substring(_5d8.lastPos,node.start));
}
if(node.superclassname){
if(_5dc&&_5dc.ivars){
throw _5d8.error_message("Duplicate class "+_5db,node.classname);
}
if(_5de&&_5dc&&_5dc.instanceMethods&&_5dc.classMethods){
throw _5d8.error_message("Duplicate interface definition for class "+_5db,node.classname);
}
var _5e0=_5d8.getClassDef(node.superclassname.name);
if(!_5e0){
var _5e1="Can't find superclass "+node.superclassname.name;
for(var i=_512.importStack.length;--i>=0;){
_5e1+="\n"+Array((_512.importStack.length-i)*2+1).join(" ")+"Imported by: "+_512.importStack[i];
}
throw _5d8.error_message(_5e1,node.superclassname);
}
_5dc=new _4da(!_5de,_5db,_5e0,Object.create(null));
_5da.concat("{var the_class = objj_allocateClassPair("+node.superclassname.name+", \""+_5db+"\"),\nmeta_class = the_class.isa;");
}else{
if(node.categoryname){
_5dc=_5d8.getClassDef(_5db);
if(!_5dc){
throw _5d8.error_message("Class "+_5db+" not found ",node.classname);
}
_5da.concat("{\nvar the_class = objj_getClass(\""+_5db+"\")\n");
_5da.concat("if(!the_class) throw new SyntaxError(\"*** Could not find definition for class \\\""+_5db+"\\\"\");\n");
_5da.concat("var meta_class = the_class.isa;");
}else{
_5dc=new _4da(!_5de,_5db,null,Object.create(null));
_5da.concat("{var the_class = objj_allocateClassPair(Nil, \""+_5db+"\"),\nmeta_class = the_class.isa;");
}
}
if(_5df){
for(var i=0,size=_5df.length;i<size;i++){
_5da.concat("\nvar aProtocol = objj_getProtocol(\""+_5df[i].name+"\");");
_5da.concat("\nif (!aProtocol) throw new SyntaxError(\"*** Could not find definition for protocol \\\""+_5df[i].name+"\\\"\");");
_5da.concat("\nclass_addProtocol(the_class, aProtocol);");
}
}
_5dd.classDef=_5dc;
_5d8.currentSuperClass="objj_getClass(\""+_5db+"\").super_class";
_5d8.currentSuperMetaClass="objj_getMetaClass(\""+_5db+"\").super_class";
var _5e2=true,_5e3=_5dc.ivars,_5e4=[],_5e5=false;
if(node.ivardeclarations){
for(var i=0;i<node.ivardeclarations.length;++i){
var _5e6=node.ivardeclarations[i],_5e7=_5e6.ivartype?_5e6.ivartype.name:null,_5e8=_5e6.id.name,ivar={"type":_5e7,"name":_5e8},_5e9=_5e6.accessors;
if(_5e3[_5e8]){
throw _5d8.error_message("Instance variable '"+_5e8+"'is already declared for class "+_5db,_5e6.id);
}
if(_5e2){
_5e2=false;
_5da.concat("class_addIvars(the_class, [");
}else{
_5da.concat(", ");
}
if(_5d8.flags&_512.Flags.IncludeTypeSignatures){
_5da.concat("new objj_ivar(\""+_5e8+"\", \""+_5e7+"\")");
}else{
_5da.concat("new objj_ivar(\""+_5e8+"\")");
}
if(_5e6.outlet){
ivar.outlet=true;
}
_5e4.push(ivar);
if(!_5dd.ivars){
_5dd.ivars=Object.create(null);
}
_5dd.ivars[_5e8]={type:"ivar",name:_5e8,node:_5e6.id,ivar:ivar};
if(_5e9){
var _5ea=(_5e9.property&&_5e9.property.name)||_5e8,_5eb=(_5e9.getter&&_5e9.getter.name)||_5ea;
_5dc.addInstanceMethod(new _50b(_5eb,[_5e7]));
if(!_5e9.readonly){
var _5ec=_5e9.setter?_5e9.setter.name:null;
if(!_5ec){
var _5ed=_5ea.charAt(0)=="_"?1:0;
_5ec=(_5ed?"_":"")+"set"+_5ea.substr(_5ed,1).toUpperCase()+_5ea.substring(_5ed+1)+":";
}
_5dc.addInstanceMethod(new _50b(_5ec,["void",_5e7]));
}
_5e5=true;
}
}
}
if(!_5e2){
_5da.concat("]);");
}
if(!_5de&&_5e5){
var _5ee=new _2ae();
_5ee.concat(_5d8.source.substring(node.start,node.endOfIvars).replace(/<.*>/g,""));
_5ee.concat("\n");
for(var i=0;i<node.ivardeclarations.length;++i){
var _5e6=node.ivardeclarations[i],_5e7=_5e6.ivartype?_5e6.ivartype.name:null,_5e8=_5e6.id.name,_5e9=_5e6.accessors;
if(!_5e9){
continue;
}
var _5ea=(_5e9.property&&_5e9.property.name)||_5e8,_5eb=(_5e9.getter&&_5e9.getter.name)||_5ea,_5ef="- ("+(_5e7?_5e7:"id")+")"+_5eb+"\n{\nreturn "+_5e8+";\n}\n";
_5ee.concat(_5ef);
if(_5e9.readonly){
continue;
}
var _5ec=_5e9.setter?_5e9.setter.name:null;
if(!_5ec){
var _5ed=_5ea.charAt(0)=="_"?1:0;
_5ec=(_5ed?"_":"")+"set"+_5ea.substr(_5ed,1).toUpperCase()+_5ea.substring(_5ed+1)+":";
}
var _5f0="- (void)"+_5ec+"("+(_5e7?_5e7:"id")+")newValue\n{\n";
if(_5e9.copy){
_5f0+="if ("+_5e8+" !== newValue)\n"+_5e8+" = [newValue copy];\n}\n";
}else{
_5f0+=_5e8+" = newValue;\n}\n";
}
_5ee.concat(_5f0);
}
_5ee.concat("\n@end");
var b=_5ee.toString().replace(/@accessors(\(.*\))?/g,"");
var _5f1=_512.compileToIMBuffer(b,"Accessors",_5d8.flags,_5d8.classDefs,_5d8.protocolDefs);
_5d8.imBuffer.concat(_5f1);
}
for(var _5f2=_5e4.length,i=0;i<_5f2;i++){
var ivar=_5e4[i],_5e8=ivar.name;
_5e3[_5e8]=ivar;
}
_5d8.classDefs[_5db]=_5dc;
var _5f3=node.body,_5f4=_5f3.length;
if(_5f4>0){
if(!_5d9){
_5d8.lastPos=_5f3[0].start;
}
for(var i=0;i<_5f4;++i){
var body=_5f3[i];
c(body,_5dd,"Statement");
}
if(!_5d9){
_5da.concat(_5d8.source.substring(_5d8.lastPos,body.end));
}
}
if(!_5de&&!node.categoryname){
_5da.concat("objj_registerClassPair(the_class);\n");
}
if(_5d8.imBuffer.isEmpty()){
_5da.concat("class_addMethods(the_class, [");
_5da.atoms.push.apply(_5da.atoms,_5d8.imBuffer.atoms);
_5da.concat("]);\n");
}
if(_5d8.cmBuffer.isEmpty()){
_5da.concat("class_addMethods(meta_class, [");
_5da.atoms.push.apply(_5da.atoms,_5d8.cmBuffer.atoms);
_5da.concat("]);\n");
}
_5da.concat("}");
_5d8.jsBuffer=_5da;
if(!_5d9){
_5d8.lastPos=node.end;
}
if(_5df){
var _5f5=[];
for(var i=0,size=_5df.length;i<size;i++){
var _5f6=_5df[i],_5f7=_5d8.getProtocolDef(_5f6.name);
if(!_5f7){
throw _5d8.error_message("Cannot find protocol declaration for '"+_5f6.name+"'",_5f6);
}
_5f5.push(_5f7);
}
var _5f8=_5dc.listOfNotImplementedMethodsForProtocols(_5f5);
if(_5f8&&_5f8.length>0){
for(var i=0,size=_5f8.length;i<size;i++){
var _5f9=_5f8[i],_5fa=_5f9.methodDef,_5f7=_5f9.protocolDef;
_5d8.addWarning(_4d7("Method '"+_5fa.name+"' in protocol '"+_5f7.name+"' is not implemented",node.classname,_5d8.source));
}
}
}
},ProtocolDeclarationStatement:function(node,st,c){
var _5fb=st.compiler,_5fc=_5fb.generate,_5fd=_5fb.jsBuffer,_5fe=node.protocolname.name,_5ff=_5fb.getProtocolDef(_5fe),_600=node.protocols,_601=new _4cd(st),_602=[];
if(_5ff){
throw _5fb.error_message("Duplicate protocol "+_5fe,node.protocolname);
}
_5fb.imBuffer=new _2ae();
_5fb.cmBuffer=new _2ae();
if(!_5fc){
_5fd.concat(_5fb.source.substring(_5fb.lastPos,node.start));
}
_5fd.concat("{var the_protocol = objj_allocateProtocol(\""+_5fe+"\");");
if(_600){
for(var i=0,size=_600.length;i<size;i++){
var _603=_600[i],_604=_603.name;
inheritProtocolDef=_5fb.getProtocolDef(_604);
if(!inheritProtocolDef){
throw _5fb.error_message("Can't find protocol "+_604,_603);
}
_5fd.concat("\nvar aProtocol = objj_getProtocol(\""+_604+"\");");
_5fd.concat("\nif (!aProtocol) throw new SyntaxError(\"*** Could not find definition for protocol \\\""+_5fe+"\\\"\");");
_5fd.concat("\nprotocol_addProtocol(the_protocol, aProtocol);");
_602.push(inheritProtocolDef);
}
}
_5ff=new _4fd(_5fe,_602);
_5fb.protocolDefs[_5fe]=_5ff;
_601.protocolDef=_5ff;
var _605=node.required;
if(_605){
var _606=_605.length;
if(_606>0){
for(var i=0;i<_606;++i){
var _607=_605[i];
if(!_5fc){
_5fb.lastPos=_607.start;
}
c(_607,_601,"Statement");
}
if(!_5fc){
_5fd.concat(_5fb.source.substring(_5fb.lastPos,_607.end));
}
}
}
_5fd.concat("\nobjj_registerProtocol(the_protocol);\n");
if(_5fb.imBuffer.isEmpty()){
_5fd.concat("protocol_addMethodDescriptions(the_protocol, [");
_5fd.atoms.push.apply(_5fd.atoms,_5fb.imBuffer.atoms);
_5fd.concat("], true, true);\n");
}
if(_5fb.cmBuffer.isEmpty()){
_5fd.concat("protocol_addMethodDescriptions(the_protocol, [");
_5fd.atoms.push.apply(_5fd.atoms,_5fb.cmBuffer.atoms);
_5fd.concat("], true, false);\n");
}
_5fd.concat("}");
_5fb.jsBuffer=_5fd;
if(!_5fc){
_5fb.lastPos=node.end;
}
},MethodDeclarationStatement:function(node,st,c){
var _608=st.compiler,_609=_608.generate,_60a=_608.jsBuffer,_60b=new _4cd(st),_60c=node.methodtype==="-";
selectors=node.selectors,nodeArguments=node.arguments,returnType=node.returntype,types=[returnType?returnType.name:(node.action?"void":"id")],returnTypeProtocols=returnType?returnType.protocols:null;
selector=selectors[0].name;
if(returnTypeProtocols){
for(var i=0,size=returnTypeProtocols.length;i<size;i++){
var _60d=returnTypeProtocols[i];
if(!_608.getProtocolDef(_60d.name)){
_608.addWarning(_4d7("Cannot find protocol declaration for '"+_60d.name+"'",_60d,_608.source));
}
}
}
if(!_609){
_60a.concat(_608.source.substring(_608.lastPos,node.start));
}
_608.jsBuffer=_60c?_608.imBuffer:_608.cmBuffer;
for(var i=0;i<nodeArguments.length;i++){
var _60e=nodeArguments[i],_60f=_60e.type,_610=_60f?_60f.name:"id",_611=_60f?_60f.protocols:null;
types.push(_60f?_60f.name:"id");
if(_611){
for(var j=0,size=_611.length;j<size;j++){
var _612=_611[j];
if(!_608.getProtocolDef(_612.name)){
_608.addWarning(_4d7("Cannot find protocol declaration for '"+_612.name+"'",_612,_608.source));
}
}
}
if(i===0){
selector+=":";
}else{
selector+=(selectors[i]?selectors[i].name:"")+":";
}
}
if(_608.jsBuffer.isEmpty()){
_608.jsBuffer.concat(", ");
}
_608.jsBuffer.concat("new objj_method(sel_getUid(\"");
_608.jsBuffer.concat(selector);
_608.jsBuffer.concat("\"), ");
if(node.body){
_608.jsBuffer.concat("function");
if(_608.flags&_512.Flags.IncludeDebugSymbols){
_608.jsBuffer.concat(" $"+st.currentClassName()+"__"+selector.replace(/:/g,"_"));
}
_608.jsBuffer.concat("(self, _cmd");
_60b.methodType=node.methodtype;
_60b.vars["self"]={type:"method base",scope:_60b};
_60b.vars["_cmd"]={type:"method base",scope:_60b};
if(nodeArguments){
for(var i=0;i<nodeArguments.length;i++){
var _60e=nodeArguments[i],_613=_60e.identifier.name;
_608.jsBuffer.concat(", ");
_608.jsBuffer.concat(_613);
_60b.vars[_613]={type:"method argument",node:_60e};
}
}
_608.jsBuffer.concat(")\n");
if(!_609){
_608.lastPos=node.startOfBody;
}
_561+=_560;
_60b.endOfScopeBody=true;
c(node.body,_60b,"Statement");
_561=_561.substring(_55f);
if(!_609){
_608.jsBuffer.concat(_608.source.substring(_608.lastPos,node.body.end));
}
_608.jsBuffer.concat("\n");
}else{
_608.jsBuffer.concat("Nil\n");
}
if(_608.flags&_512.Flags.IncludeDebugSymbols){
_608.jsBuffer.concat(","+JSON.stringify(types));
}
_608.jsBuffer.concat(")");
_608.jsBuffer=_60a;
if(!_609){
_608.lastPos=node.end;
}
var def=st.classDef,_614;
if(def){
_614=_60c?def.getInstanceMethod(selector):def.getClassMethod(selector);
}else{
def=st.protocolDef;
}
if(!def){
throw "InternalError: MethodDeclaration without ClassDeclaration or ProtocolDeclaration at line: "+_2.acorn.getLineInfo(_608.source,node.start).line;
}
if(!_614){
var _615=def.protocols;
if(_615){
for(var i=0,size=_615.length;i<size;i++){
var _616=_615[i],_614=_60c?_616.getInstanceMethod(selector):_616.getClassMethod(selector);
if(_614){
break;
}
}
}
}
if(_614){
var _617=_614.types;
if(_617){
var _618=_617.length;
if(_618>0){
var _619=_617[0];
if(_619!==types[0]&&!(_619==="id"&&returnType&&returnType.typeisclass)){
_608.addWarning(_4d7("Conflicting return type in implementation of '"+selector+"': '"+_619+"' vs '"+types[0]+"'",returnType||node.action||selectors[0],_608.source));
}
for(var i=1;i<_618;i++){
var _61a=_617[i];
if(_61a!==types[i]&&!(_61a==="id"&&nodeArguments[i-1].type.typeisclass)){
_608.addWarning(_4d7("Conflicting parameter types in implementation of '"+selector+"': '"+_61a+"' vs '"+types[i]+"'",nodeArguments[i-1].type||nodeArguments[i-1].identifier,_608.source));
}
}
}
}
}
var _61b=new _50b(selector,types);
if(_60c){
def.addInstanceMethod(_61b);
}else{
def.addClassMethod(_61b);
}
},MessageSendExpression:function(node,st,c){
var _61c=st.compiler,_61d=_61c.generate,_61e=_61c.jsBuffer,_61f=node.object;
if(!_61d){
_61e.concat(_61c.source.substring(_61c.lastPos,node.start));
_61c.lastPos=_61f?_61f.start:node.arguments.length?node.arguments[0].start:node.end;
}
if(node.superObject){
if(!_61d){
_61e.concat(" ");
}
_61e.concat("objj_msgSendSuper(");
_61e.concat("{ receiver:self, super_class:"+(st.currentMethodType()==="+"?_61c.currentSuperMetaClass:_61c.currentSuperClass)+" }");
}else{
if(_61d){
var _620=_61f.type==="Identifier"&&!(st.currentMethodType()==="-"&&_61c.getIvarForClass(_61f.name,st)&&!st.getLvar(_61f.name,true)),_621,_622;
if(_620){
var name=_61f.name,_621=st.getLvar(name);
if(name==="self"){
_622=!_621||!_621.scope||_621.scope.assignmentToSelf;
}else{
_622=!!_621||!_61c.getClassDef(name);
}
if(_622){
_61e.concat("(");
c(_61f,st,"Expression");
_61e.concat(" == null ? null : ");
}
c(_61f,st,"Expression");
}else{
_622=true;
if(!st.receiverLevel){
st.receiverLevel=0;
}
_61e.concat("((___r");
_61e.concat(++st.receiverLevel+"");
_61e.concat(" = ");
c(_61f,st,"Expression");
_61e.concat("), ___r");
_61e.concat(st.receiverLevel+"");
_61e.concat(" == null ? null : ___r");
_61e.concat(st.receiverLevel+"");
if(!(st.maxReceiverLevel>=st.receiverLevel)){
st.maxReceiverLevel=st.receiverLevel;
}
}
_61e.concat(".isa.objj_msgSend");
}else{
_61e.concat(" ");
_61e.concat("objj_msgSend(");
_61e.concat(_61c.source.substring(_61c.lastPos,_61f.end));
}
}
var _623=node.selectors,_624=node.arguments,_625=_624.length,_626=_623[0],_627=_626?_626.name:"";
if(_61d&&!node.superObject){
var _628=_625;
if(node.parameters){
_628+=node.parameters.length;
}
if(_628<4){
_61e.concat(""+_628);
}
if(_620){
_61e.concat("(");
c(_61f,st,"Expression");
}else{
_61e.concat("(___r");
_61e.concat(st.receiverLevel+"");
}
}
for(var i=0;i<_625;i++){
if(i===0){
_627+=":";
}else{
_627+=(_623[i]?_623[i].name:"")+":";
}
}
_61e.concat(", \"");
_61e.concat(_627);
_61e.concat("\"");
if(node.arguments){
for(var i=0;i<node.arguments.length;i++){
var _629=node.arguments[i];
_61e.concat(", ");
if(!_61d){
_61c.lastPos=_629.start;
}
c(_629,st,"Expression");
if(!_61d){
_61e.concat(_61c.source.substring(_61c.lastPos,_629.end));
_61c.lastPos=_629.end;
}
}
}
if(node.parameters){
for(var i=0;i<node.parameters.length;++i){
var _62a=node.parameters[i];
_61e.concat(", ");
if(!_61d){
_61c.lastPos=_62a.start;
}
c(_62a,st,"Expression");
if(!_61d){
_61e.concat(_61c.source.substring(_61c.lastPos,_62a.end));
_61c.lastPos=_62a.end;
}
}
}
if(_61d&&!node.superObject){
if(_622){
_61e.concat(")");
}
if(!_620){
st.receiverLevel--;
}
}
_61e.concat(")");
if(!_61d){
_61c.lastPos=node.end;
}
},SelectorLiteralExpression:function(node,st,c){
var _62b=st.compiler,_62c=_62b.jsBuffer,_62d=_62b.generate;
if(!_62d){
_62c.concat(_62b.source.substring(_62b.lastPos,node.start));
_62c.concat(" ");
}
_62c.concat("sel_getUid(\"");
_62c.concat(node.selector);
_62c.concat("\")");
if(!_62d){
_62b.lastPos=node.end;
}
},ProtocolLiteralExpression:function(node,st,c){
var _62e=st.compiler,_62f=_62e.jsBuffer,_630=_62e.generate;
if(!_630){
_62f.concat(_62e.source.substring(_62e.lastPos,node.start));
_62f.concat(" ");
}
_62f.concat("objj_getProtocol(\"");
_62f.concat(node.id.name);
_62f.concat("\")");
if(!_630){
_62e.lastPos=node.end;
}
},Reference:function(node,st,c){
var _631=st.compiler,_632=_631.jsBuffer,_633=_631.generate;
if(!_633){
_632.concat(_631.source.substring(_631.lastPos,node.start));
_632.concat(" ");
}
_632.concat("function(__input) { if (arguments.length) return ");
_632.concat(node.element.name);
_632.concat(" = __input; return ");
_632.concat(node.element.name);
_632.concat("; }");
if(!_633){
_631.lastPos=node.end;
}
},Dereference:function(node,st,c){
var _634=st.compiler,_635=_634.generate;
_552(st,node.expr);
if(!_635){
_634.jsBuffer.concat(_634.source.substring(_634.lastPos,node.start));
_634.lastPos=node.expr.start;
}
c(node.expr,st,"Expression");
if(!_635){
_634.jsBuffer.concat(_634.source.substring(_634.lastPos,node.expr.end));
}
_634.jsBuffer.concat("()");
if(!_635){
_634.lastPos=node.end;
}
},ClassStatement:function(node,st,c){
var _636=st.compiler;
if(!_636.generate){
_636.jsBuffer.concat(_636.source.substring(_636.lastPos,node.start));
_636.lastPos=node.start;
_636.jsBuffer.concat("//");
}
var _637=node.id.name;
if(!_636.getClassDef(_637)){
classDef=new _4da(false,_637);
_636.classDefs[_637]=classDef;
}
st.vars[node.id.name]={type:"class",node:node.id};
},GlobalStatement:function(node,st,c){
var _638=st.compiler;
if(!_638.generate){
_638.jsBuffer.concat(_638.source.substring(_638.lastPos,node.start));
_638.lastPos=node.start;
_638.jsBuffer.concat("//");
}
st.rootScope().vars[node.id.name]={type:"global",node:node.id};
},PreprocessStatement:function(node,st,c){
var _639=st.compiler;
if(!_639.generate){
_639.jsBuffer.concat(_639.source.substring(_639.lastPos,node.start));
_639.lastPos=node.start;
_639.jsBuffer.concat("//");
}
}});
function _2ec(aURL,_63a){
this._URL=aURL;
this._isLocal=_63a;
};
_2.FileDependency=_2ec;
_2ec.prototype.URL=function(){
return this._URL;
};
_2ec.prototype.isLocal=function(){
return this._isLocal;
};
_2ec.prototype.toMarkedString=function(){
var _63b=this.URL().absoluteString();
return (this.isLocal()?_234:_233)+";"+_63b.length+";"+_63b;
};
_2ec.prototype.toString=function(){
return (this.isLocal()?"LOCAL: ":"STD: ")+this.URL();
};
var _63c=0,_63d=1,_63e=2,_63f=0;
function _2bd(_640,_641,aURL,_642,_643,_644){
if(arguments.length===0){
return this;
}
this._code=_640;
this._function=_642||null;
this._URL=_1ce(aURL||new CFURL("(Anonymous"+(_63f++)+")"));
this._compiler=_643||null;
this._fileDependencies=_641;
this._filenameTranslateDictionary=_644;
if(_641.length){
this._fileDependencyStatus=_63c;
this._fileDependencyCallbacks=[];
}else{
this._fileDependencyStatus=_63e;
}
if(this._function){
return;
}
if(!_643){
this.setCode(_640);
}
};
_2.Executable=_2bd;
_2bd.prototype.path=function(){
return this.URL().path();
};
_2bd.prototype.URL=function(){
return this._URL;
};
_2bd.prototype.functionParameters=function(){
var _645=["global","objj_executeFile","objj_importFile"];
return _645;
};
_2bd.prototype.functionArguments=function(){
var _646=[_1,this.fileExecuter(),this.fileImporter()];
return _646;
};
_2bd.prototype.execute=function(){
if(this._compiler){
var _647=this.fileDependencies(),_9d=0,_648=_647.length;
this._compiler.pushImport(this.URL().lastPathComponent());
for(;_9d<_648;++_9d){
var _649=_647[_9d],_64a=_649.isLocal(),URL=_649.URL();
this.fileExecuter()(URL,_64a);
}
this._compiler.popImport();
this.setCode(this._compiler.compilePass2());
this._compiler=null;
}
var _64b=_64c;
_64c=CFBundle.bundleContainingURL(this.URL());
var _64d=this._function.apply(_1,this.functionArguments());
_64c=_64b;
return _64d;
};
_2bd.prototype.code=function(){
return this._code;
};
_2bd.prototype.setCode=function(code){
this._code=code;
var _64e=this.functionParameters().join(",");
this._function=new Function(_64e,code);
};
_2bd.prototype.fileDependencies=function(){
return this._fileDependencies;
};
_2bd.prototype.hasLoadedFileDependencies=function(){
return this._fileDependencyStatus===_63e;
};
var _64f=0,_650=[],_651={};
_2bd.prototype.loadFileDependencies=function(_652){
var _653=this._fileDependencyStatus;
if(_652){
if(_653===_63e){
return _652();
}
this._fileDependencyCallbacks.push(_652);
}
if(_653===_63c){
if(_64f){
throw "Can't load";
}
_654(this);
}
};
function _654(_655){
_650.push(_655);
_655._fileDependencyStatus=_63d;
var _656=_655.fileDependencies(),_9d=0,_657=_656.length,_658=_655.referenceURL(),_659=_658.absoluteString(),_65a=_655.fileExecutableSearcher();
_64f+=_657;
for(;_9d<_657;++_9d){
var _65b=_656[_9d],_65c=_65b.isLocal(),URL=_65b.URL(),_65d=(_65c&&(_659+" ")||"")+URL;
if(_651[_65d]){
if(--_64f===0){
_65e();
}
continue;
}
_651[_65d]=YES;
_65a(URL,_65c,_65f);
}
};
function _65f(_660){
--_64f;
if(_660._fileDependencyStatus===_63c){
_654(_660);
}else{
if(_64f===0){
_65e();
}
}
};
function _65e(){
var _661=_650,_9d=0,_662=_661.length;
_650=[];
for(;_9d<_662;++_9d){
_661[_9d]._fileDependencyStatus=_63e;
}
for(_9d=0;_9d<_662;++_9d){
var _663=_661[_9d],_664=_663._fileDependencyCallbacks,_665=0,_666=_664.length;
for(;_665<_666;++_665){
_664[_665]();
}
_663._fileDependencyCallbacks=[];
}
};
_2bd.prototype.referenceURL=function(){
if(this._referenceURL===_2f){
this._referenceURL=new CFURL(".",this.URL());
}
return this._referenceURL;
};
_2bd.prototype.fileImporter=function(){
return _2bd.fileImporterForURL(this.referenceURL());
};
_2bd.prototype.fileExecuter=function(){
return _2bd.fileExecuterForURL(this.referenceURL());
};
_2bd.prototype.fileExecutableSearcher=function(){
return _2bd.fileExecutableSearcherForURL(this.referenceURL());
};
var _667={};
_2bd.fileExecuterForURL=function(aURL){
var _668=_1ce(aURL),_669=_668.absoluteString(),_66a=_667[_669];
if(!_66a){
_66a=function(aURL,_66b,_66c){
_2bd.fileExecutableSearcherForURL(_668)(aURL,_66b,function(_66d){
if(!_66d.hasLoadedFileDependencies()){
throw "No executable loaded for file at URL "+aURL;
}
_66d.execute(_66c);
});
};
_667[_669]=_66a;
}
return _66a;
};
var _66e={};
_2bd.fileImporterForURL=function(aURL){
var _66f=_1ce(aURL),_670=_66f.absoluteString(),_671=_66e[_670];
if(!_671){
_671=function(aURL,_672,_673){
_16a();
_2bd.fileExecutableSearcherForURL(_66f)(aURL,_672,function(_674){
_674.loadFileDependencies(function(){
_674.execute();
_16b();
if(_673){
_673();
}
});
});
};
_66e[_670]=_671;
}
return _671;
};
var _675={},_676={};
function _24c(x){
var _677=0;
for(var k in x){
if(x.hasOwnProperty(k)){
++_677;
}
}
return _677;
};
_2bd.resetCachedFileExecutableSearchers=function(){
_675={};
_676={};
_66e={};
_667={};
_651={};
};
_2bd.fileExecutableSearcherForURL=function(_678){
var _679=_678.absoluteString(),_67a=_675[_679],_67b=_2bd.filenameTranslateDictionary?_2bd.filenameTranslateDictionary():null;
cachedSearchResults={};
if(!_67a){
_67a=function(aURL,_67c,_67d){
var _67e=(_67c&&_678||"")+aURL,_67f=_676[_67e];
if(_67f){
return _680(_67f);
}
var _681=(aURL instanceof CFURL)&&aURL.scheme();
if(_67c||_681){
if(!_681){
aURL=new CFURL(aURL,_678);
}
_1ba.resolveResourceAtURL(aURL,NO,_680,_67b);
}else{
_1ba.resolveResourceAtURLSearchingIncludeURLs(aURL,_680);
}
function _680(_682){
if(!_682){
var _683=_512?_512.currentCompileFile:null;
throw new Error("Could not load file at "+aURL+(_683?" when compiling "+_683:""));
}
_676[_67e]=_682;
_67d(new _684(_682.URL(),_67b));
};
};
_675[_679]=_67a;
}
return _67a;
};
var _685={};
function _684(aURL,_686){
aURL=_1ce(aURL);
var _687=aURL.absoluteString(),_688=_685[_687];
if(_688){
return _688;
}
_685[_687]=this;
var _689=_1ba.resourceAtURL(aURL).contents(),_68a=NULL,_68b=aURL.pathExtension().toLowerCase();
if(_689.match(/^@STATIC;/)){
_68a=_68c(_689,aURL);
}else{
if((_68b==="j"||!_68b)&&!_689.match(/^{/)){
_68a=_2.ObjJAcornCompiler.compileFileDependencies(_689,aURL,_512.Flags.IncludeDebugSymbols);
}else{
_68a=new _2bd(_689,[],aURL);
}
}
_2bd.apply(this,[_68a.code(),_68a.fileDependencies(),aURL,_68a._function,_68a._compiler,_686]);
this._hasExecuted=NO;
};
_2.FileExecutable=_684;
_684.prototype=new _2bd();
_684.resetFileExecutables=function(){
_685={};
_68d={};
};
_684.prototype.execute=function(_68e){
if(this._hasExecuted&&!_68e){
return;
}
this._hasExecuted=YES;
_2bd.prototype.execute.call(this);
};
_684.prototype.hasExecuted=function(){
return this._hasExecuted;
};
function _68c(_68f,aURL){
var _690=new _119(_68f);
var _691=NULL,code="",_692=[];
while(_691=_690.getMarker()){
var text=_690.getString();
if(_691===_232){
code+=text;
}else{
if(_691===_233){
_692.push(new _2ec(new CFURL(text),NO));
}else{
if(_691===_234){
_692.push(new _2ec(new CFURL(text),YES));
}
}
}
}
var fn=_684._lookupCachedFunction(aURL);
if(fn){
return new _2bd(code,_692,aURL,fn);
}
return new _2bd(code,_692,aURL);
};
var _68d={};
_684._cacheFunction=function(aURL,fn){
aURL=typeof aURL==="string"?aURL:aURL.absoluteString();
_68d[aURL]=fn;
};
_684._lookupCachedFunction=function(aURL){
aURL=typeof aURL==="string"?aURL:aURL.absoluteString();
return _68d[aURL];
};
var _693=1,_694=2,_695=4,_696=8;
objj_ivar=function(_697,_698){
this.name=_697;
this.type=_698;
};
objj_method=function(_699,_69a,_69b){
this.name=_699;
this.method_imp=_69a;
this.types=_69b;
};
objj_class=function(_69c){
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
objj_protocol=function(_69d){
this.name=_69d;
this.instance_methods={};
this.class_methods={};
};
objj_object=function(){
this.isa=NULL;
this._UID=-1;
};
class_getName=function(_69e){
if(_69e==Nil){
return "";
}
return _69e.name;
};
class_isMetaClass=function(_69f){
if(!_69f){
return NO;
}
return ((_69f.info&(_694)));
};
class_getSuperclass=function(_6a0){
if(_6a0==Nil){
return Nil;
}
return _6a0.super_class;
};
class_setSuperclass=function(_6a1,_6a2){
_6a1.super_class=_6a2;
_6a1.isa.super_class=_6a2.isa;
};
class_addIvar=function(_6a3,_6a4,_6a5){
var _6a6=_6a3.allocator.prototype;
if(typeof _6a6[_6a4]!="undefined"){
return NO;
}
var ivar=new objj_ivar(_6a4,_6a5);
_6a3.ivar_list.push(ivar);
_6a3.ivar_dtable[_6a4]=ivar;
_6a6[_6a4]=NULL;
return YES;
};
class_addIvars=function(_6a7,_6a8){
var _6a9=0,_6aa=_6a8.length,_6ab=_6a7.allocator.prototype;
for(;_6a9<_6aa;++_6a9){
var ivar=_6a8[_6a9],name=ivar.name;
if(typeof _6ab[name]==="undefined"){
_6a7.ivar_list.push(ivar);
_6a7.ivar_dtable[name]=ivar;
_6ab[name]=NULL;
}
}
};
class_copyIvarList=function(_6ac){
return _6ac.ivar_list.slice(0);
};
class_addMethod=function(_6ad,_6ae,_6af,_6b0){
var _6b1=new objj_method(_6ae,_6af,_6b0);
_6ad.method_list.push(_6b1);
_6ad.method_dtable[_6ae]=_6b1;
if(!((_6ad.info&(_694)))&&(((_6ad.info&(_694)))?_6ad:_6ad.isa).isa===(((_6ad.info&(_694)))?_6ad:_6ad.isa)){
class_addMethod((((_6ad.info&(_694)))?_6ad:_6ad.isa),_6ae,_6af,_6b0);
}
return YES;
};
class_addMethods=function(_6b2,_6b3){
var _6b4=0,_6b5=_6b3.length,_6b6=_6b2.method_list,_6b7=_6b2.method_dtable;
for(;_6b4<_6b5;++_6b4){
var _6b8=_6b3[_6b4];
_6b6.push(_6b8);
_6b7[_6b8.name]=_6b8;
}
if(!((_6b2.info&(_694)))&&(((_6b2.info&(_694)))?_6b2:_6b2.isa).isa===(((_6b2.info&(_694)))?_6b2:_6b2.isa)){
class_addMethods((((_6b2.info&(_694)))?_6b2:_6b2.isa),_6b3);
}
};
class_getInstanceMethod=function(_6b9,_6ba){
if(!_6b9||!_6ba){
return NULL;
}
var _6bb=_6b9.method_dtable[_6ba];
return _6bb?_6bb:NULL;
};
class_getInstanceVariable=function(_6bc,_6bd){
if(!_6bc||!_6bd){
return NULL;
}
var _6be=_6bc.ivar_dtable[_6bd];
return _6be;
};
class_getClassMethod=function(_6bf,_6c0){
if(!_6bf||!_6c0){
return NULL;
}
var _6c1=(((_6bf.info&(_694)))?_6bf:_6bf.isa).method_dtable[_6c0];
return _6c1?_6c1:NULL;
};
class_respondsToSelector=function(_6c2,_6c3){
return class_getClassMethod(_6c2,_6c3)!=NULL;
};
class_copyMethodList=function(_6c4){
return _6c4.method_list.slice(0);
};
class_getVersion=function(_6c5){
return _6c5.version;
};
class_setVersion=function(_6c6,_6c7){
_6c6.version=parseInt(_6c7,10);
};
class_replaceMethod=function(_6c8,_6c9,_6ca){
if(!_6c8||!_6c9){
return NULL;
}
var _6cb=_6c8.method_dtable[_6c9],_6cc=NULL;
if(_6cb){
_6cc=_6cb.method_imp;
}
_6cb.method_imp=_6ca;
return _6cc;
};
class_addProtocol=function(_6cd,_6ce){
if(!_6ce||class_conformsToProtocol(_6cd,_6ce)){
return;
}
(_6cd.protocol_list||(_6cd.protocol_list==[])).push(_6ce);
return true;
};
class_conformsToProtocol=function(_6cf,_6d0){
if(!_6d0){
return false;
}
while(_6cf){
var _6d1=_6cf.protocol_list,size=_6d1?_6d1.length:0;
for(var i=0;i<size;i++){
var p=_6d1[i];
if(p.name===_6d0.name){
return true;
}
if(protocol_conformsToProtocol(p,_6d0)){
return true;
}
}
_6cf=class_getSuperclass(_6cf);
}
return false;
};
class_copyProtocolList=function(_6d2){
var _6d3=_6d2.protocol_list;
return _6d3?_6d3.slice(0):[];
};
protocol_conformsToProtocol=function(p1,p2){
if(!p1||!p2){
return false;
}
if(p1.name===p2.name){
return true;
}
var _6d4=p1.protocol_list,size=_6d4?_6d4.length:0;
for(var i=0;i<size;i++){
var p=_6d4[i];
if(p.name===p2.name){
return true;
}
if(protocol_conformsToProtocol(p,p2)){
return true;
}
}
return false;
};
var _6d5=Object.create(null);
objj_allocateProtocol=function(_6d6){
var _6d7=new objj_protocol(_6d6);
return _6d7;
};
objj_registerProtocol=function(_6d8){
_6d5[_6d8.name]=_6d8;
};
protocol_getName=function(_6d9){
return _6d9.name;
};
protocol_addMethodDescription=function(_6da,_6db,_6dc,_6dd,_6de){
if(!_6da||!_6db){
return;
}
if(_6dd){
(_6de?_6da.instance_methods:_6da.class_methods)[_6db]=new objj_method(_6db,null,_6dc);
}
};
protocol_addMethodDescriptions=function(_6df,_6e0,_6e1,_6e2){
if(!_6e1){
return;
}
var _6e3=0,_6e4=_6e0.length,_6e5=_6e2?_6df.instance_methods:_6df.class_methods;
for(;_6e3<_6e4;++_6e3){
var _6e6=_6e0[_6e3];
_6e5[_6e6.name]=_6e6;
}
};
protocol_copyMethodDescriptionList=function(_6e7,_6e8,_6e9){
if(!_6e8){
return [];
}
var _6ea=_6e9?_6e7.instance_methods:_6e7.class_methods,_6eb=[];
for(var _6ec in _6ea){
if(_6ea.hasOwnProperty(_6ec)){
_6eb.push(_6ea[_6ec]);
}
}
return _6eb;
};
protocol_addProtocol=function(_6ed,_6ee){
if(!_6ed||!_6ee){
return;
}
(_6ed.protocol_list||(_6ed.protocol_list=[])).push(_6ee);
};
var _6ef=function(_6f0){
var meta=(((_6f0.info&(_694)))?_6f0:_6f0.isa);
if((_6f0.info&(_694))){
_6f0=objj_getClass(_6f0.name);
}
if(_6f0.super_class&&!((((_6f0.super_class.info&(_694)))?_6f0.super_class:_6f0.super_class.isa).info&(_695))){
_6ef(_6f0.super_class);
}
if(!(meta.info&(_695))&&!(meta.info&(_696))){
meta.info=(meta.info|(_696))&~(0);
_6f0.objj_msgSend=objj_msgSendFast;
_6f0.objj_msgSend0=objj_msgSendFast0;
_6f0.objj_msgSend1=objj_msgSendFast1;
_6f0.objj_msgSend2=objj_msgSendFast2;
_6f0.objj_msgSend3=objj_msgSendFast3;
meta.objj_msgSend=objj_msgSendFast;
meta.objj_msgSend0=objj_msgSendFast0;
meta.objj_msgSend1=objj_msgSendFast1;
meta.objj_msgSend2=objj_msgSendFast2;
meta.objj_msgSend3=objj_msgSendFast3;
meta.objj_msgSend0(_6f0,"initialize");
meta.info=(meta.info|(_695))&~(_696);
}
};
var _6f1=function(self,_6f2){
var isa=self.isa,_6f3=isa.method_dtable[_6f4];
if(_6f3){
var _6f5=_6f3.method_imp.call(this,self,_6f4,_6f2);
if(_6f5&&_6f5!==self){
arguments[0]=_6f5;
return objj_msgSend.apply(this,arguments);
}
}
_6f3=isa.method_dtable[_6f6];
if(_6f3){
var _6f7=isa.method_dtable[_6f8];
if(_6f7){
var _6f9=_6f3.method_imp.call(this,self,_6f6,_6f2);
if(_6f9){
var _6fa=objj_lookUpClass("CPInvocation");
if(_6fa){
var _6fb=_6fa.isa.objj_msgSend1(_6fa,_6fc,_6f9),_9d=0,_6fd=arguments.length;
if(_6fb!=null){
var _6fe=_6fb.isa;
for(;_9d<_6fd;++_9d){
_6fe.objj_msgSend2(_6fb,_6ff,arguments[_9d],_9d);
}
}
_6f7.method_imp.call(this,self,_6f8,_6fb);
return _6fb==null?null:_6fe.objj_msgSend0(_6fb,_700);
}
}
}
}
_6f3=isa.method_dtable[_701];
if(_6f3){
return _6f3.method_imp.call(this,self,_701,_6f2);
}
throw class_getName(isa)+" does not implement doesNotRecognizeSelector:. Did you forget a superclass for "+class_getName(isa)+"?";
};
class_getMethodImplementation=function(_702,_703){
if(!((((_702.info&(_694)))?_702:_702.isa).info&(_695))){
_6ef(_702);
}
var _704=_702.method_dtable[_703];
var _705=_704?_704.method_imp:_6f1;
return _705;
};
var _706=Object.create(null);
objj_enumerateClassesUsingBlock=function(_707){
for(var key in _706){
_707(_706[key]);
}
};
objj_allocateClassPair=function(_708,_709){
var _70a=new objj_class(_709),_70b=new objj_class(_709),_70c=_70a;
if(_708){
_70c=_708;
while(_70c.superclass){
_70c=_70c.superclass;
}
_70a.allocator.prototype=new _708.allocator;
_70a.ivar_dtable=_70a.ivar_store.prototype=new _708.ivar_store;
_70a.method_dtable=_70a.method_store.prototype=new _708.method_store;
_70b.method_dtable=_70b.method_store.prototype=new _708.isa.method_store;
_70a.super_class=_708;
_70b.super_class=_708.isa;
}else{
_70a.allocator.prototype=new objj_object();
}
_70a.isa=_70b;
_70a.name=_709;
_70a.info=_693;
_70a._UID=objj_generateObjectUID();
_70b.isa=_70c.isa;
_70b.name=_709;
_70b.info=_694;
_70b._UID=objj_generateObjectUID();
return _70a;
};
var _64c=nil;
objj_registerClassPair=function(_70d){
_1[_70d.name]=_70d;
_706[_70d.name]=_70d;
_1d5(_70d,_64c);
};
objj_resetRegisterClasses=function(){
for(var key in _706){
delete _1[key];
}
_706=Object.create(null);
_6d5=Object.create(null);
_1d8();
};
class_createInstance=function(_70e){
if(!_70e){
throw new Error("*** Attempting to create object with Nil class.");
}
var _70f=new _70e.allocator();
_70f.isa=_70e;
_70f._UID=objj_generateObjectUID();
return _70f;
};
var _710=function(){
};
_710.prototype.member=false;
with(new _710()){
member=true;
}
if(new _710().member){
var _711=class_createInstance;
class_createInstance=function(_712){
var _713=_711(_712);
if(_713){
var _714=_713.isa,_715=_714;
while(_714){
var _716=_714.ivar_list,_717=_716.length;
while(_717--){
_713[_716[_717].name]=NULL;
}
_714=_714.super_class;
}
_713.isa=_715;
}
return _713;
};
}
object_getClassName=function(_718){
if(!_718){
return "";
}
var _719=_718.isa;
return _719?class_getName(_719):"";
};
objj_lookUpClass=function(_71a){
var _71b=_706[_71a];
return _71b?_71b:Nil;
};
objj_getClass=function(_71c){
var _71d=_706[_71c];
if(!_71d){
}
return _71d?_71d:Nil;
};
objj_getClassList=function(_71e,_71f){
for(var _720 in _706){
_71e.push(_706[_720]);
if(_71f&&--_71f===0){
break;
}
}
return _71e.length;
};
objj_getMetaClass=function(_721){
var _722=objj_getClass(_721);
return (((_722.info&(_694)))?_722:_722.isa);
};
objj_getProtocol=function(_723){
return _6d5[_723];
};
ivar_getName=function(_724){
return _724.name;
};
ivar_getTypeEncoding=function(_725){
return _725.type;
};
objj_msgSend=function(_726,_727){
if(_726==nil){
return nil;
}
var isa=_726.isa;
if(!((((isa.info&(_694)))?isa:isa.isa).info&(_695))){
_6ef(isa);
}
var _728=isa.method_dtable[_727];
var _729=_728?_728.method_imp:_6f1;
switch(arguments.length){
case 2:
return _729(_726,_727);
case 3:
return _729(_726,_727,arguments[2]);
case 4:
return _729(_726,_727,arguments[2],arguments[3]);
}
return _729.apply(_726,arguments);
};
objj_msgSendSuper=function(_72a,_72b){
var _72c=_72a.super_class;
arguments[0]=_72a.receiver;
if(!((((_72c.info&(_694)))?_72c:_72c.isa).info&(_695))){
_6ef(_72c);
}
var _72d=_72c.method_dtable[_72b];
var _72e=_72d?_72d.method_imp:_6f1;
return _72e.apply(_72a.receiver,arguments);
};
objj_msgSendFast=function(_72f,_730){
var _731=this.method_dtable[_730],_732=_731?_731.method_imp:_6f1;
return _732.apply(_72f,arguments);
};
var _733=function(_734,_735){
_6ef(this);
return this.objj_msgSend.apply(this,arguments);
};
objj_msgSendFast0=function(_736,_737){
var _738=this.method_dtable[_737],_739=_738?_738.method_imp:_6f1;
return _739(_736,_737);
};
var _73a=function(_73b,_73c){
_6ef(this);
return this.objj_msgSend0(_73b,_73c);
};
objj_msgSendFast1=function(_73d,_73e,arg0){
var _73f=this.method_dtable[_73e],_740=_73f?_73f.method_imp:_6f1;
return _740(_73d,_73e,arg0);
};
var _741=function(_742,_743,arg0){
_6ef(this);
return this.objj_msgSend1(_742,_743,arg0);
};
objj_msgSendFast2=function(_744,_745,arg0,arg1){
var _746=this.method_dtable[_745],_747=_746?_746.method_imp:_6f1;
return _747(_744,_745,arg0,arg1);
};
var _748=function(_749,_74a,arg0,arg1){
_6ef(this);
return this.objj_msgSend2(_749,_74a,arg0,arg1);
};
objj_msgSendFast3=function(_74b,_74c,arg0,arg1,arg2){
var _74d=this.method_dtable[_74c],_74e=_74d?_74d.method_imp:_6f1;
return _74e(_74b,_74c,arg0,arg1,arg2);
};
var _74f=function(_750,_751,arg0,arg1,arg2){
_6ef(this);
return this.objj_msgSend3(_750,_751,arg0,arg1,arg2);
};
method_getName=function(_752){
return _752.name;
};
method_getImplementation=function(_753){
return _753.method_imp;
};
method_setImplementation=function(_754,_755){
var _756=_754.method_imp;
_754.method_imp=_755;
return _756;
};
method_exchangeImplementations=function(lhs,rhs){
var _757=method_getImplementation(lhs),_758=method_getImplementation(rhs);
method_setImplementation(lhs,_758);
method_setImplementation(rhs,_757);
};
sel_getName=function(_759){
return _759?_759:"<null selector>";
};
sel_getUid=function(_75a){
return _75a;
};
sel_isEqual=function(lhs,rhs){
return lhs===rhs;
};
sel_registerName=function(_75b){
return _75b;
};
objj_class.prototype.toString=objj_object.prototype.toString=function(){
var isa=this.isa;
if(class_getInstanceMethod(isa,_75c)){
return isa.objj_msgSend0(this,_75c);
}
if(class_isMetaClass(isa)){
return this.name;
}
return "["+isa.name+" Object](-description not implemented)";
};
objj_class.prototype.objj_msgSend=_733;
objj_class.prototype.objj_msgSend0=_73a;
objj_class.prototype.objj_msgSend1=_741;
objj_class.prototype.objj_msgSend2=_748;
objj_class.prototype.objj_msgSend3=_74f;
var _75c=sel_getUid("description"),_6f4=sel_getUid("forwardingTargetForSelector:"),_6f6=sel_getUid("methodSignatureForSelector:"),_6f8=sel_getUid("forwardInvocation:"),_701=sel_getUid("doesNotRecognizeSelector:"),_6fc=sel_getUid("invocationWithMethodSignature:"),_75d=sel_getUid("setTarget:"),_75e=sel_getUid("setSelector:"),_6ff=sel_getUid("setArgument:atIndex:"),_700=sel_getUid("returnValue");
objj_eval=function(_75f){
var url=_2.pageURL;
var _760=_2.asyncLoader;
_2.asyncLoader=NO;
var _761=_2.preprocess(_75f,url,0);
if(!_761.hasLoadedFileDependencies()){
_761.loadFileDependencies();
}
_1._objj_eval_scope={};
_1._objj_eval_scope.objj_executeFile=_2bd.fileExecuterForURL(url);
_1._objj_eval_scope.objj_importFile=_2bd.fileImporterForURL(url);
var code="with(_objj_eval_scope){"+_761._code+"\n//*/\n}";
var _762;
_762=eval(code);
_2.asyncLoader=_760;
return _762;
};
_2.objj_eval=objj_eval;
_16a();
var _763=new CFURL(window.location.href),_764=document.getElementsByTagName("base"),_765=_764.length;
if(_765>0){
var _766=_764[_765-1],_767=_766&&_766.getAttribute("href");
if(_767){
_763=new CFURL(_767,_763);
}
}
var _768=new CFURL(window.OBJJ_MAIN_FILE||"main.j"),_1d4=new CFURL(".",new CFURL(_768,_763)).absoluteURL(),_769=new CFURL("..",_1d4).absoluteURL();
if(_1d4===_769){
_769=new CFURL(_769.schemeAndAuthority());
}
_1ba.resourceAtURL(_769,YES);
_2.pageURL=_763;
_2.bootstrap=function(){
_76a();
};
function _76a(){
_1ba.resolveResourceAtURL(_1d4,YES,function(_76b){
var _76c=_1ba.includeURLs(),_9d=0,_76d=_76c.length;
for(;_9d<_76d;++_9d){
_76b.resourceAtURL(_76c[_9d],YES);
}
_2bd.fileImporterForURL(_1d4)(_768.lastPathComponent(),YES,function(){
_16b();
_773(function(){
var _76e=window.location.hash.substring(1),args=[];
if(_76e.length){
args=_76e.split("/");
for(var i=0,_76d=args.length;i<_76d;i++){
args[i]=decodeURIComponent(args[i]);
}
}
var _76f=window.location.search.substring(1).split("&"),_770=new CFMutableDictionary();
for(var i=0,_76d=_76f.length;i<_76d;i++){
var _771=_76f[i].split("=");
if(!_771[0]){
continue;
}
if(_771[1]==null){
_771[1]=true;
}
_770.setValueForKey(decodeURIComponent(_771[0]),decodeURIComponent(_771[1]));
}
main(args,_770);
});
});
});
};
var _772=NO;
function _773(_774){
if(_772||document.readyState==="complete"){
return _774();
}
if(window.addEventListener){
window.addEventListener("load",_774,NO);
}else{
if(window.attachEvent){
window.attachEvent("onload",_774);
}
}
};
_773(function(){
_772=YES;
});
if(typeof OBJJ_AUTO_BOOTSTRAP==="undefined"||OBJJ_AUTO_BOOTSTRAP){
_2.bootstrap();
}
function _1ce(aURL){
if(aURL instanceof CFURL&&aURL.scheme()){
return aURL;
}
return new CFURL(aURL,_1d4);
};
objj_importFile=_2bd.fileImporterForURL(_1d4);
objj_executeFile=_2bd.fileExecuterForURL(_1d4);
objj_import=function(){
CPLog.warn("objj_import is deprecated, use objj_importFile instead");
objj_importFile.apply(this,arguments);
};
})(window,ObjectiveJ);

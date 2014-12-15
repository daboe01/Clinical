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
var _22c=new _697(_22b.URL());
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
_3d5(_326);
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
var _384={keyword:"typedef"};
var _385={keyword:"filename"},_386={keyword:"unsigned",okAsIdent:true},_387={keyword:"signed",okAsIdent:true};
var _388={keyword:"byte",okAsIdent:true},_389={keyword:"char",okAsIdent:true},_38a={keyword:"short",okAsIdent:true};
var _38b={keyword:"int",okAsIdent:true},_38c={keyword:"long",okAsIdent:true},_38d={keyword:"id",okAsIdent:true};
var _38e={keyword:"BOOL",okAsIdent:true},_38f={keyword:"SEL",okAsIdent:true},_390={keyword:"float",okAsIdent:true};
var _391={keyword:"double",okAsIdent:true};
var _392={keyword:"#"};
var _393={keyword:"define"};
var _394={keyword:"undef"};
var _395={keyword:"ifdef"};
var _396={keyword:"ifndef"};
var _397={keyword:"if"};
var _398={keyword:"else"};
var _399={keyword:"endif"};
var _39a={keyword:"elif"};
var _39b={keyword:"pragma"};
var _39c={keyword:"defined"};
var _39d={keyword:"\\"};
var _39e={type:"preprocessParamItem"};
var _39f={"break":_359,"case":_35a,"catch":_35b,"continue":_35c,"debugger":_35d,"default":_35e,"do":_35f,"else":_360,"finally":_361,"for":_362,"function":_363,"if":_364,"return":_365,"switch":_366,"throw":_367,"try":_368,"var":_369,"while":_36a,"with":_36b,"null":_36f,"true":_370,"false":_371,"new":_36c,"in":_372,"instanceof":{keyword:"instanceof",binop:7,beforeExpr:true},"this":_36d,"typeof":{keyword:"typeof",prefix:true,beforeExpr:true},"void":_36e,"delete":{keyword:"delete",prefix:true,beforeExpr:true}};
var _3a0={"IBAction":_378,"IBOutlet":_374,"unsigned":_386,"signed":_387,"byte":_388,"char":_389,"short":_38a,"int":_38b,"long":_38c,"id":_38d,"float":_390,"BOOL":_38e,"SEL":_38f,"double":_391};
var _3a1={"implementation":_373,"outlet":_374,"accessors":_375,"end":_376,"import":_377,"action":_378,"selector":_379,"class":_37a,"global":_37b,"ref":_37e,"deref":_37f,"protocol":_380,"optional":_381,"required":_382,"interface":_383,"typedef":_384};
var _3a2={"define":_393,"pragma":_39b,"ifdef":_395,"ifndef":_396,"undef":_394,"if":_397,"endif":_399,"else":_398,"elif":_39a,"defined":_39c};
var _3a3={type:"[",beforeExpr:true},_3a4={type:"]"},_3a5={type:"{",beforeExpr:true};
var _3a6={type:"}"},_3a7={type:"(",beforeExpr:true},_3a8={type:")"};
var _3a9={type:",",beforeExpr:true},_3aa={type:";",beforeExpr:true};
var _3ab={type:":",beforeExpr:true},_3ac={type:"."},_3ad={type:"?",beforeExpr:true};
var _3ae={type:"@"},_3af={type:"..."},_3b0={type:"#"};
var _3b1={binop:10,beforeExpr:true,preprocess:true},_3b2={isAssign:true,beforeExpr:true,preprocess:true};
var _3b3={isAssign:true,beforeExpr:true},_3b4={binop:9,prefix:true,beforeExpr:true,preprocess:true};
var _3b5={postfix:true,prefix:true,isUpdate:true},_3b6={prefix:true,beforeExpr:true};
var _3b7={binop:1,beforeExpr:true,preprocess:true},_3b8={binop:2,beforeExpr:true,preprocess:true};
var _3b9={binop:3,beforeExpr:true,preprocess:true},_3ba={binop:4,beforeExpr:true,preprocess:true};
var _3bb={binop:5,beforeExpr:true,preprocess:true},_3bc={binop:6,beforeExpr:true,preprocess:true};
var _3bd={binop:7,beforeExpr:true,preprocess:true},_3be={binop:8,beforeExpr:true,preprocess:true};
var _3bf={binop:10,beforeExpr:true,preprocess:true};
_30c.tokTypes={bracketL:_3a3,bracketR:_3a4,braceL:_3a5,braceR:_3a6,parenL:_3a7,parenR:_3a8,comma:_3a9,semi:_3aa,colon:_3ab,dot:_3ac,question:_3ad,slash:_3b1,eq:_3b2,name:_356,eof:_357,num:_353,regexp:_354,string:_355};
for(var kw in _39f){
_30c.tokTypes[kw]=_39f[kw];
}
function _31f(_3c0){
_3c0=_3c0.split(" ");
var f="",cats=[];
out:
for(var i=0;i<_3c0.length;++i){
for(var j=0;j<cats.length;++j){
if(cats[j][0].length==_3c0[i].length){
cats[j].push(_3c0[i]);
continue out;
}
}
cats.push([_3c0[i]]);
}
function _3c1(arr){
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
_3c1(cat);
}
f+="}";
}else{
_3c1(_3c0);
}
return new Function("str",f);
};
_30c.makePredicate=_31f;
var _3c2=_31f("abstract boolean byte char class double enum export extends final float goto implements import int interface long native package private protected public short static super synchronized throws transient volatile");
var _3c3=_31f("class enum extends super const export import");
var _3c4=_31f("implements interface let package private protected public static yield");
var _3c5=_31f("eval arguments");
var _3c6=_31f("break case catch continue debugger default do else finally for function if return switch throw try var while with null true false instanceof typeof void delete new in this");
var _3c7=_31f("IBAction IBOutlet byte char short int long float unsigned signed id BOOL SEL double");
var _3c8=_31f("define pragma if ifdef ifndef else elif endif defined");
var _3c9=/[\u1680\u180e\u2000-\u200a\u2028\u2029\u202f\u205f\u3000\ufeff]/;
var _3ca=/[\u1680\u180e\u2000-\u200a\u202f\u205f\u3000\ufeff]/;
var _3cb="ªµºÀ-ÖØ-öø-ˁˆ-ˑˠ-ˤˬˮͰ-ʹͶͷͺ-ͽΆΈ-ΊΌΎ-ΡΣ-ϵϷ-ҁҊ-ԧԱ-Ֆՙա-ևא-תװ-ײؠ-يٮٯٱ-ۓەۥۦۮۯۺ-ۼۿܐܒ-ܯݍ-ޥޱߊ-ߪߴߵߺࠀ-ࠕࠚࠤࠨࡀ-ࡘࢠࢢ-ࢬऄ-हऽॐक़-ॡॱ-ॷॹ-ॿঅ-ঌএঐও-নপ-রলশ-হঽৎড়ঢ়য়-ৡৰৱਅ-ਊਏਐਓ-ਨਪ-ਰਲਲ਼ਵਸ਼ਸਹਖ਼-ੜਫ਼ੲ-ੴઅ-ઍએ-ઑઓ-નપ-રલળવ-હઽૐૠૡଅ-ଌଏଐଓ-ନପ-ରଲଳଵ-ହଽଡ଼ଢ଼ୟ-ୡୱஃஅ-ஊஎ-ஐஒ-கஙசஜஞடணதந-பம-ஹௐఅ-ఌఎ-ఐఒ-నప-ళవ-హఽౘౙౠౡಅ-ಌಎ-ಐಒ-ನಪ-ಳವ-ಹಽೞೠೡೱೲഅ-ഌഎ-ഐഒ-ഺഽൎൠൡൺ-ൿඅ-ඖක-නඳ-රලව-ෆก-ะาำเ-ๆກຂຄງຈຊຍດ-ທນ-ຟມ-ຣລວສຫອ-ະາຳຽເ-ໄໆໜ-ໟༀཀ-ཇཉ-ཬྈ-ྌက-ဪဿၐ-ၕၚ-ၝၡၥၦၮ-ၰၵ-ႁႎႠ-ჅჇჍა-ჺჼ-ቈቊ-ቍቐ-ቖቘቚ-ቝበ-ኈኊ-ኍነ-ኰኲ-ኵኸ-ኾዀዂ-ዅወ-ዖዘ-ጐጒ-ጕጘ-ፚᎀ-ᎏᎠ-Ᏼᐁ-ᙬᙯ-ᙿᚁ-ᚚᚠ-ᛪᛮ-ᛰᜀ-ᜌᜎ-ᜑᜠ-ᜱᝀ-ᝑᝠ-ᝬᝮ-ᝰក-ឳៗៜᠠ-ᡷᢀ-ᢨᢪᢰ-ᣵᤀ-ᤜᥐ-ᥭᥰ-ᥴᦀ-ᦫᧁ-ᧇᨀ-ᨖᨠ-ᩔᪧᬅ-ᬳᭅ-ᭋᮃ-ᮠᮮᮯᮺ-ᯥᰀ-ᰣᱍ-ᱏᱚ-ᱽᳩ-ᳬᳮ-ᳱᳵᳶᴀ-ᶿḀ-ἕἘ-Ἕἠ-ὅὈ-Ὅὐ-ὗὙὛὝὟ-ώᾀ-ᾴᾶ-ᾼιῂ-ῄῆ-ῌῐ-ΐῖ-Ίῠ-Ῥῲ-ῴῶ-ῼⁱⁿₐ-ₜℂℇℊ-ℓℕℙ-ℝℤΩℨK-ℭℯ-ℹℼ-ℿⅅ-ⅉⅎⅠ-ↈⰀ-Ⱞⰰ-ⱞⱠ-ⳤⳫ-ⳮⳲⳳⴀ-ⴥⴧⴭⴰ-ⵧⵯⶀ-ⶖⶠ-ⶦⶨ-ⶮⶰ-ⶶⶸ-ⶾⷀ-ⷆⷈ-ⷎⷐ-ⷖⷘ-ⷞⸯ々-〇〡-〩〱-〵〸-〼ぁ-ゖゝ-ゟァ-ヺー-ヿㄅ-ㄭㄱ-ㆎㆠ-ㆺㇰ-ㇿ㐀-䶵一-鿌ꀀ-ꒌꓐ-ꓽꔀ-ꘌꘐ-ꘟꘪꘫꙀ-ꙮꙿ-ꚗꚠ-ꛯꜗ-ꜟꜢ-ꞈꞋ-ꞎꞐ-ꞓꞠ-Ɦꟸ-ꠁꠃ-ꠅꠇ-ꠊꠌ-ꠢꡀ-ꡳꢂ-ꢳꣲ-ꣷꣻꤊ-ꤥꤰ-ꥆꥠ-ꥼꦄ-ꦲꧏꨀ-ꨨꩀ-ꩂꩄ-ꩋꩠ-ꩶꩺꪀ-ꪯꪱꪵꪶꪹ-ꪽꫀꫂꫛ-ꫝꫠ-ꫪꫲ-ꫴꬁ-ꬆꬉ-ꬎꬑ-ꬖꬠ-ꬦꬨ-ꬮꯀ-ꯢ가-힣ힰ-ퟆퟋ-ퟻ豈-舘並-龎ﬀ-ﬆﬓ-ﬗיִײַ-ﬨשׁ-זּטּ-לּמּנּסּףּפּצּ-ﮱﯓ-ﴽﵐ-ﶏﶒ-ﷇﷰ-ﷻﹰ-ﹴﹶ-ﻼＡ-Ｚａ-ｚｦ-ﾾￂ-ￇￊ-ￏￒ-ￗￚ-ￜ";
var _3cc="ͱ-ʹ҃-֑҇-ׇֽֿׁׂׅׄؐ-ؚؠ-ىٲ-ۓۧ-ۨۻ-ۼܰ-݊ࠀ-ࠔࠛ-ࠣࠥ-ࠧࠩ-࠭ࡀ-ࡗࣤ-ࣾऀ-ःऺ-़ा-ॏ॑-ॗॢ-ॣ०-९ঁ-ঃ়া-ৄেৈৗয়-ৠਁ-ਃ਼ਾ-ੂੇੈੋ-੍ੑ੦-ੱੵઁ-ઃ઼ા-ૅે-ૉો-્ૢ-ૣ૦-૯ଁ-ଃ଼ା-ୄେୈୋ-୍ୖୗୟ-ୠ୦-୯ஂா-ூெ-ைொ-்ௗ௦-௯ఁ-ఃె-ైొ-్ౕౖౢ-ౣ౦-౯ಂಃ಼ಾ-ೄೆ-ೈೊ-್ೕೖೢ-ೣ೦-೯ംഃെ-ൈൗൢ-ൣ൦-൯ංඃ්ා-ුූෘ-ෟෲෳิ-ฺเ-ๅ๐-๙ິ-ູ່-ໍ໐-໙༘༙༠-༩༹༵༷ཁ-ཇཱ-྄྆-྇ྍ-ྗྙ-ྼ࿆က-ဩ၀-၉ၧ-ၭၱ-ၴႂ-ႍႏ-ႝ፝-፟ᜎ-ᜐᜠ-ᜰᝀ-ᝐᝲᝳក-ឲ៝០-៩᠋-᠍᠐-᠙ᤠ-ᤫᤰ-᤻ᥑ-ᥭᦰ-ᧀᧈ-ᧉ᧐-᧙ᨀ-ᨕᨠ-ᩓ᩠-᩿᩼-᪉᪐-᪙ᭆ-ᭋ᭐-᭙᭫-᭳᮰-᮹᯦-᯳ᰀ-ᰢ᱀-᱉ᱛ-ᱽ᳐-᳒ᴀ-ᶾḁ-ἕ‌‍‿⁀⁔⃐-⃥⃜⃡-⃰ⶁ-ⶖⷠ-ⷿ〡-〨゙゚Ꙁ-ꙭꙴ-꙽ꚟ꛰-꛱ꟸ-ꠀ꠆ꠋꠣ-ꠧꢀ-ꢁꢴ-꣄꣐-꣙ꣳ-ꣷ꤀-꤉ꤦ-꤭ꤰ-ꥅꦀ-ꦃ꦳-꧀ꨀ-ꨧꩀ-ꩁꩌ-ꩍ꩐-꩙ꩻꫠ-ꫩꫲ-ꫳꯀ-ꯡ꯬꯭꯰-꯹ﬠ-ﬨ︀-️︠-︦︳︴﹍-﹏０-９＿";
var _3cd=new RegExp("["+_3cb+"]");
var _3ce=new RegExp("["+_3cb+_3cc+"]");
var _3cf=/[\n\r\u2028\u2029]/;
var _323=/\r\n|[\n\r\u2028\u2029]/g;
function _3d0(code){
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
return code>=170&&_3cd.test(String.fromCharCode(code));
};
function _3d1(code){
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
return code>=170&&_3ce.test(String.fromCharCode(code));
};
function _3d2(){
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
var _3d3=[_397,_395,_396,_398,_39a,_399];
function _3d4(type,val){
if(type in _3d3){
return _3d5();
}
_32f=_328;
if(_30d.locations){
_331=new _3d2;
}
_332=type;
_32d();
if(_30d.preprocess&&_30e.charCodeAt(_328)===35&&_30e.charCodeAt(_328+1)===35){
var val1=type===_356?val:type.keyword;
_328+=2;
if(val1){
_32d();
_3d5();
var val2=_332===_356?_333:_332.keyword;
if(val2){
var _3d6=""+val1+val2,code=_3d6.charCodeAt(0),tok;
if(_3d0(code)){
tok=_3d7(_3d6)!==false;
}
if(tok){
return tok;
}
tok=_3d8(code,_3d4);
if(tok===false){
_3d9();
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
function _3da(){
var _3db=_30d.onComment&&_30d.locations&&new _3d2;
var _3dc=_328,end=_30e.indexOf("*/",_328+=2);
if(end===-1){
_350(_328-2,"Unterminated comment");
}
_328=end+2;
if(_30d.locations){
_323.lastIndex=_3dc;
var _3dd;
while((_3dd=_323.exec(_30e))&&_3dd.index<_328){
++_329;
_32a=_3dd.index+_3dd[0].length;
}
}
if(_30d.onComment){
_30d.onComment(true,_30e.slice(_3dc+2,end),_3dc,_328,_3db,_30d.locations&&new _3d2);
}
if(_30d.trackComments){
(_33a||(_33a=[])).push(_30e.slice(_3dc,end));
}
};
function _3de(){
var _3df=_328;
var _3e0=_30d.onComment&&_30d.locations&&new _3d2;
var ch=_30e.charCodeAt(_328+=2);
while(_328<_30f&&ch!==10&&ch!==13&&ch!==8232&&ch!==8329){
++_328;
ch=_30e.charCodeAt(_328);
}
if(_30d.onComment){
_30d.onComment(false,_30e.slice(_3df+2,_328),_3df,_328,_3e0,_30d.locations&&new _3d2);
}
if(_30d.trackComments){
(_33a||(_33a=[])).push(_30e.slice(_3df,_328));
}
};
function _3e1(){
var ch=_30e.charCodeAt(_328);
var last;
while(_328<_30f&&((ch!==10&&ch!==13&&ch!==8232&&ch!==8329)||last===92)){
if(ch!=32&&ch!=9&&ch!=160&&(ch<5760||!_3ca.test(String.fromCharCode(ch)))){
last=ch;
}
ch=_30e.charCodeAt(++_328);
}
};
function _32d(){
_33a=null;
_33b=null;
var _3e2=_328;
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
(_33b||(_33b=[])).push(_30e.slice(_3e2,_328));
}
_3da();
_3e2=_328;
}else{
if(next===47){
if(_30d.trackSpaces){
(_33b||(_33b=[])).push(_30e.slice(_3e2,_328));
}
_3de();
_3e2=_328;
}else{
break;
}
}
}else{
if(ch===160){
++_328;
}else{
if(ch>=5760&&_3c9.test(String.fromCharCode(ch))){
++_328;
}else{
if(_328>=_30f){
if(_30d.preprocess&&_34e.length){
var _3e3=_34e.pop();
_328=_3e3.end;
_30e=_3e3.input;
_30f=_3e3.inputLen;
_340=_3e3.lastEnd;
_33f=_3e3.lastStart;
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
function _3e4(code,_3e5){
var next=_30e.charCodeAt(_328+1);
if(next>=48&&next<=57){
return _3e6(String.fromCharCode(code),_3e5);
}
if(next===46&&_30d.objj&&_30e.charCodeAt(_328+2)===46){
_328+=3;
return _3e5(_3af);
}
++_328;
return _3e5(_3ac);
};
function _3e7(_3e8){
var next=_30e.charCodeAt(_328+1);
if(_32c){
++_328;
return _3e9();
}
if(next===61){
return _3ea(_3b3,2,_3e8);
}
return _3ea(_3b1,1,_3e8);
};
function _3eb(_3ec){
var next=_30e.charCodeAt(_328+1);
if(next===61){
return _3ea(_3b3,2,_3ec);
}
return _3ea(_3bf,1,_3ec);
};
function _3ed(code,_3ee){
var next=_30e.charCodeAt(_328+1);
if(next===code){
return _3ea(code===124?_3b7:_3b8,2,_3ee);
}
if(next===61){
return _3ea(_3b3,2,_3ee);
}
return _3ea(code===124?_3b9:_3bb,1,_3ee);
};
function _3ef(_3f0){
var next=_30e.charCodeAt(_328+1);
if(next===61){
return _3ea(_3b3,2,_3f0);
}
return _3ea(_3ba,1,_3f0);
};
function _3f1(code,_3f2){
var next=_30e.charCodeAt(_328+1);
if(next===code){
return _3ea(_3b5,2,_3f2);
}
if(next===61){
return _3ea(_3b3,2,_3f2);
}
return _3ea(_3b4,1,_3f2);
};
function _3f3(code,_3f4){
if(_342&&_30d.objj&&code===60){
var str=[];
for(;;){
if(_328>=_30f){
_350(_32e,"Unterminated import statement");
}
var ch=_30e.charCodeAt(++_328);
if(ch===62){
++_328;
return _3f4(_385,String.fromCharCode.apply(null,str));
}
str.push(ch);
}
}
var next=_30e.charCodeAt(_328+1);
var size=1;
if(next===code){
size=code===62&&_30e.charCodeAt(_328+2)===62?3:2;
if(_30e.charCodeAt(_328+size)===61){
return _3ea(_3b3,size+1,_3f4);
}
return _3ea(_3be,size,_3f4);
}
if(next===61){
size=_30e.charCodeAt(_328+2)===61?3:2;
}
return _3ea(_3bd,size,_3f4);
};
function _3f5(code,_3f6){
var next=_30e.charCodeAt(_328+1);
if(next===61){
return _3ea(_3bc,_30e.charCodeAt(_328+2)===61?3:2,_3f6);
}
return _3ea(code===61?_3b2:_3b6,1,_3f6);
};
function _3f7(code,_3f8){
var next=_30e.charCodeAt(++_328);
if(next===34||next===39){
return _3f9(next,_3f8);
}
if(next===123){
return _3f8(_37c);
}
if(next===91){
return _3f8(_37d);
}
var word=_3fa(),_3fb=_3a1[word];
if(!_3fb){
_350(_328,"Unrecognized Objective-J keyword '@"+word+"'");
}
return _3f8(_3fb);
};
var _3fc=true;
var _3fd=0;
function _3fe(_3ff){
++_328;
_400();
switch(_348){
case _393:
_400();
var _401=_34b;
var _402=_403();
if(_30e.charCodeAt(_401)===40){
_404(_3a7);
var _405=[];
var _406=true;
while(!_407(_3a8)){
if(!_406){
_404(_3a9,"Expected ',' between macro parameters");
}else{
_406=false;
}
_405.push(_403());
}
}
var _408=_328=_34a;
_3e1();
var _409=_30e.slice(_408,_328);
_409=_409.replace(/\\/g," ");
_30d.preprocessAddMacro(new _40a(_402,_409,_405));
break;
case _394:
_400();
_30d.preprocessUndefineMacro(_403());
_3e1();
break;
case _397:
if(_3fc){
_3fd++;
_400();
var expr=_40b();
var test=_40c(expr);
if(!test){
_3fc=false;
}
_40d(!test);
}else{
return _3ff(_397);
}
break;
case _395:
if(_3fc){
_3fd++;
_400();
var _40e=_403();
var test=_30d.preprocessGetMacro(_40e);
if(!test){
_3fc=false;
}
_40d(!test);
}else{
return _3ff(_395);
}
break;
case _396:
if(_3fc){
_3fd++;
_400();
var _40e=_403();
var test=_30d.preprocessGetMacro(_40e);
if(test){
_3fc=false;
}
_40d(test);
}else{
return _3ff(_396);
}
break;
case _398:
if(_3fd){
if(_3fc){
_3fc=false;
_3ff(_398);
_400();
_40d(true,true);
}else{
return _3ff(_398);
}
}else{
_350(_34a,"#else without #if");
}
break;
case _399:
if(_3fd){
if(_3fc){
_3fd--;
break;
}
}else{
_350(_34a,"#endif without #if");
}
return _3ff(_399);
break;
case _39b:
_3e1();
break;
case _3b6:
_3e1();
break;
default:
_350(_34a,"Invalid preprocessing directive");
_3e1();
return _3ff(_392);
}
_3d4(_392);
return _3d5();
};
function _40c(expr){
return _30c.walk.recursive(expr,{},{BinaryExpression:function(node,st,c){
var left=node.left,_40f=node.right;
switch(node.operator){
case "+":
return c(left,st)+c(_40f,st);
case "-":
return c(left,st)-c(_40f,st);
case "*":
return c(left,st)*c(_40f,st);
case "/":
return c(left,st)/c(_40f,st);
case "%":
return c(left,st)%c(_40f,st);
case "<":
return c(left,st)<c(_40f,st);
case ">":
return c(left,st)>c(_40f,st);
case "=":
case "==":
case "===":
return c(left,st)===c(_40f,st);
case "<=":
return c(left,st)<=c(_40f,st);
case ">=":
return c(left,st)>=c(_40f,st);
case "&&":
return c(left,st)&&c(_40f,st);
case "||":
return c(left,st)||c(_40f,st);
}
},Literal:function(node,st,c){
return node.value;
},Identifier:function(node,st,c){
var name=node.name,_410=_30d.preprocessGetMacro(name);
return (_410&&parseInt(_410.macro))||0;
},DefinedExpression:function(node,st,c){
return !!_30d.preprocessGetMacro(node.id.name);
}},{});
};
function _3d8(code,_411,_412){
switch(code){
case 46:
return _3e4(code,_411);
case 40:
++_328;
return _411(_3a7);
case 41:
++_328;
return _411(_3a8);
case 59:
++_328;
return _411(_3aa);
case 44:
++_328;
return _411(_3a9);
case 91:
++_328;
return _411(_3a3);
case 93:
++_328;
return _411(_3a4);
case 123:
++_328;
return _411(_3a5);
case 125:
++_328;
return _411(_3a6);
case 58:
++_328;
return _411(_3ab);
case 63:
++_328;
return _411(_3ad);
case 48:
var next=_30e.charCodeAt(_328+1);
if(next===120||next===88){
return _413(_411);
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
return _3e6(false,_411);
case 34:
case 39:
return _3f9(code,_411);
case 47:
return _3e7(_411);
case 37:
case 42:
return _3eb(_411);
case 124:
case 38:
return _3ed(code,_411);
case 94:
return _3ef(_411);
case 43:
case 45:
return _3f1(code,_411);
case 60:
case 62:
return _3f3(code,_411,_411);
case 61:
case 33:
return _3f5(code,_411);
case 126:
return _3ea(_3b6,1,_411);
case 64:
if(_30d.objj){
return _3f7(code,_411);
}
return false;
case 35:
if(_30d.preprocess){
return _3fe(_411);
}
return false;
case 92:
if(_30d.preprocess){
return _3ea(_39d,1,_411);
}
return false;
}
if(_412&&_3cf.test(String.fromCharCode(code))){
return _3ea(_358,1,_411);
}
return false;
};
function _414(){
while(_328<_30f){
var ch=_30e.charCodeAt(_328);
if(ch===32||ch===9||ch===160||(ch>=5760&&_3ca.test(String.fromCharCode(ch)))){
++_328;
}else{
if(ch===92){
var pos=_328+1;
ch=_30e.charCodeAt(pos);
while(pos<_30f&&(ch===32||ch===9||ch===11||ch===12||(ch>=5760&&_3ca.test(String.fromCharCode(ch))))){
ch=_30e.charCodeAt(++pos);
}
_323.lastIndex=0;
var _415=_323.exec(_30e.slice(pos,pos+2));
if(_415&&_415.index===0){
_328=pos+_415[0].length;
}else{
return false;
}
}else{
_323.lastIndex=0;
var _415=_323.exec(_30e.slice(_328,_328+2));
return _415&&_415.index===0;
}
}
}
};
function _40d(test,_416){
if(test){
var _417=0;
while(_417>0||(_348!=_399&&(_348!=_398||_416))){
switch(_348){
case _397:
case _395:
case _396:
_417++;
break;
case _399:
_417--;
break;
case _357:
_3fc=true;
_350(_34a,"Missing #endif");
}
_400();
}
_3fc=true;
if(_348===_399){
_3fd--;
}
}
};
function _400(){
_34a=_328;
_33e=_30e;
if(_328>=_30f){
return _357;
}
var code=_30e.charCodeAt(_328);
if(_34f&&code!==41&&code!==44){
var _418=0;
while(_328<_30f&&(_418||(code!==41&&code!==44))){
if(code===40){
_418++;
}
if(code===41){
_418--;
}
code=_30e.charCodeAt(++_328);
}
return _419(_39e,_30e.slice(_34a,_328));
}
if(_3d0(code)||(code===92&&_30e.charCodeAt(_328+1)===117)){
return _41a();
}
if(_3d8(code,_419,true)===false){
var ch=String.fromCharCode(code);
if(ch==="\\"||_3cd.test(ch)){
return _41a();
}
_350(_328,"Unexpected character '"+ch+"'");
}
};
function _41a(){
var word=_3fa();
_419(_3c8(word)?_3a2[word]:_356,word);
};
function _419(type,val){
_348=type;
_349=val;
_34b=_328;
_414();
};
function _41b(){
_34c=_32e;
_34d=_32f;
return _400();
};
function _407(type){
if(_348===type){
_41b();
return true;
}
};
function _404(type,_41c){
if(_348===type){
_400();
}else{
_350(_34a,_41c||"Unexpected token");
}
};
function _403(){
var _41d=_348===_356?_349:((!_30d.forbidReserved||_348.okAsIdent)&&_348.keyword)||_350(_34a,"Expected Macro identifier");
_41b();
return _41d;
};
function _41e(){
var node=_41f();
node.name=_403();
return _420(node,"Identifier");
};
function _40b(){
return _421();
};
function _421(){
return _422(_423(),-1);
};
function _422(left,_424){
var prec=_348.binop;
if(prec){
if(!_348.preprocess){
_350(_34a,"Unsupported macro operator");
}
if(prec>_424){
var node=_425(left);
node.left=left;
node.operator=_349;
_41b();
node.right=_422(_423(),prec);
var node=_420(node,"BinaryExpression");
return _422(node,_424);
}
}
return left;
};
function _423(){
if(_348.preprocess&&_348.prefix){
var node=_41f();
node.operator=_333;
node.prefix=true;
_41b();
node.argument=_423();
return _420(node,"UnaryExpression");
}
return _426();
};
function _426(){
switch(_348){
case _356:
return _41e();
case _353:
case _355:
return _427();
case _3a7:
var _428=_34a;
_41b();
var val=_40b();
val.start=_428;
val.end=_34b;
_404(_3a8,"Expected closing ')' in macro expression");
return val;
case _39c:
var node=_41f();
_41b();
node.id=_41e();
return _420(node,"DefinedExpression");
default:
_3d9();
}
};
function _427(){
var node=_41f();
node.value=_349;
node.raw=_33e.slice(_34a,_34b);
_41b();
return _420(node,"Literal");
};
function _420(node,type){
node.type=type;
node.end=_34d;
return node;
};
function _3d5(_429){
_32e=_328;
_33d=_30e;
if(_30d.locations){
_330=new _3d2;
}
_334=_33a;
_337=_33b;
if(_429){
return _3e9();
}
if(_328>=_30f){
return _3d4(_357);
}
var code=_30e.charCodeAt(_328);
if(_3d0(code)||code===92){
return _3d7();
}
var tok=_3d8(code,_3d4);
if(tok===false){
var ch=String.fromCharCode(code);
if(ch==="\\"||_3cd.test(ch)){
return _3d7();
}
_350(_328,"Unexpected character '"+ch+"'");
}
return tok;
};
function _3ea(type,size,_42a){
var str=_30e.slice(_328,_328+size);
_328+=size;
_42a(type,str);
};
function _3e9(){
var _42b="",_42c,_42d,_42e=_328;
for(;;){
if(_328>=_30f){
_350(_42e,"Unterminated regular expression");
}
var ch=_30e.charAt(_328);
if(_3cf.test(ch)){
_350(_42e,"Unterminated regular expression");
}
if(!_42c){
if(ch==="["){
_42d=true;
}else{
if(ch==="]"&&_42d){
_42d=false;
}else{
if(ch==="/"&&!_42d){
break;
}
}
}
_42c=ch==="\\";
}else{
_42c=false;
}
++_328;
}
var _42b=_30e.slice(_42e,_328);
++_328;
var mods=_3fa();
if(mods&&!/^[gmsiy]*$/.test(mods)){
_350(_42e,"Invalid regexp flag");
}
return _3d4(_354,new RegExp(_42b,mods));
};
function _42f(_430,len){
var _431=_328,_432=0;
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
if(val>=_430){
break;
}
++_328;
_432=_432*_430+val;
}
if(_328===_431||len!=null&&_328-_431!==len){
return null;
}
return _432;
};
function _413(_433){
_328+=2;
var val=_42f(16);
if(val==null){
_350(_32e+2,"Expected hexadecimal number");
}
if(_3d0(_30e.charCodeAt(_328))){
_350(_328,"Identifier directly after number");
}
return _433(_353,val);
};
function _3e6(_434,_435){
var _436=_328,_437=false,_438=_30e.charCodeAt(_328)===48;
if(!_434&&_42f(10)===null){
_350(_436,"Invalid number");
}
if(_30e.charCodeAt(_328)===46){
++_328;
_42f(10);
_437=true;
}
var next=_30e.charCodeAt(_328);
if(next===69||next===101){
next=_30e.charCodeAt(++_328);
if(next===43||next===45){
++_328;
}
if(_42f(10)===null){
_350(_436,"Invalid number");
}
_437=true;
}
if(_3d0(_30e.charCodeAt(_328))){
_350(_328,"Identifier directly after number");
}
var str=_30e.slice(_436,_328),val;
if(_437){
val=parseFloat(str);
}else{
if(!_438||str.length===1){
val=parseInt(str,10);
}else{
if(/[89]/.test(str)||_346){
_350(_436,"Invalid number");
}else{
val=parseInt(str,8);
}
}
}
return _435(_353,val);
};
var _439=[];
function _3f9(_43a,_43b){
_328++;
_439.length=0;
for(;;){
if(_328>=_30f){
_350(_32e,"Unterminated string constant");
}
var ch=_30e.charCodeAt(_328);
if(ch===_43a){
++_328;
return _43b(_355,String.fromCharCode.apply(null,_439));
}
if(ch===92){
ch=_30e.charCodeAt(++_328);
var _43c=/^[0-7]+/.exec(_30e.slice(_328,_328+3));
if(_43c){
_43c=_43c[0];
}
while(_43c&&parseInt(_43c,8)>255){
_43c=_43c.slice(0,_43c.length-1);
}
if(_43c==="0"){
_43c=null;
}
++_328;
if(_43c){
if(_346){
_350(_328-2,"Octal literal in strict mode");
}
_439.push(parseInt(_43c,8));
_328+=_43c.length-1;
}else{
switch(ch){
case 110:
_439.push(10);
break;
case 114:
_439.push(13);
break;
case 120:
_439.push(_43d(2));
break;
case 117:
_439.push(_43d(4));
break;
case 85:
_439.push(_43d(8));
break;
case 116:
_439.push(9);
break;
case 98:
_439.push(8);
break;
case 118:
_439.push(11);
break;
case 102:
_439.push(12);
break;
case 48:
_439.push(0);
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
_439.push(ch);
break;
}
}
}else{
if(ch===13||ch===10||ch===8232||ch===8329){
_350(_32e,"Unterminated string constant");
}
_439.push(ch);
++_328;
}
}
};
function _43d(len){
var n=_42f(16,len);
if(n===null){
_350(_32e,"Bad character escape sequence");
}
return n;
};
var _43e;
function _3fa(){
_43e=false;
var word,_43f=true,_440=_328;
for(;;){
var ch=_30e.charCodeAt(_328);
if(_3d1(ch)){
if(_43e){
word+=_30e.charAt(_328);
}
++_328;
}else{
if(ch===92){
if(!_43e){
word=_30e.slice(_440,_328);
}
_43e=true;
if(_30e.charCodeAt(++_328)!=117){
_350(_328,"Expecting Unicode escape sequence \\uXXXX");
}
++_328;
var esc=_43d(4);
var _441=String.fromCharCode(esc);
if(!_441){
_350(_328-1,"Invalid Unicode escape");
}
if(!(_43f?_3d0(esc):_3d1(esc))){
_350(_328-4,"Invalid Unicode escape");
}
word+=_441;
}else{
break;
}
}
_43f=false;
}
return _43e?word:_30e.slice(_440,_328);
};
function _3d7(_442){
var word=_442||_3fa();
var type=_356;
var _443;
if(_30d.preprocess){
var _444;
var i=_34e.length;
if(i>0){
var _445=_34e[i-1];
if(_445.parameterDict&&_445.macro.isParameterFunction()(word)){
_444=_445.parameterDict[word];
}
}
if(!_444&&_30d.preprocessIsMacro(word)){
_444=_30d.preprocessGetMacro(word);
}
if(_444){
var _446=_32e;
var _447;
var _448=_444.parameters;
var _449;
if(_448){
_449=_328<_30f&&_30e.charCodeAt(_328)===40;
}
if(!_448||_449){
var _44a=_444.macro;
var _44b=_328;
if(_449){
var _44c=true;
var _44d=0;
_447=Object.create(null);
_400();
_34f=true;
_404(_3a7);
_44b=_328;
while(!_407(_3a8)){
if(!_44c){
_404(_3a9,"Expected ',' between macro parameters");
}else{
_44c=false;
}
var _44e=_448[_44d++];
var val=_349;
_404(_39e);
_447[_44e]=new _40a(_44e,val);
_44b=_328;
}
_34f=false;
}
if(_44a){
_34e.push({macro:_444,parameterDict:_447,start:_446,end:_44b,input:_30e,inputLen:_30f,lastStart:_32e,lastEnd:_44b});
_30e=_44a;
_30f=_44a.length;
_328=0;
}
return next();
}
}
}
if(!_43e){
if(_3c6(word)){
type=_39f[word];
}else{
if(_30d.objj&&_3c7(word)){
type=_3a0[word];
}else{
if(_30d.forbidReserved&&(_30d.ecmaVersion===3?_3c2:_3c3)(word)||_346&&_3c4(word)){
_350(_32e,"The keyword '"+word+"' is reserved");
}
}
}
}
return _3d4(type,word);
};
function _40a(_44f,_450,_451){
this.identifier=_44f;
if(_450){
this.macro=_450;
}
if(_451){
this.parameters=_451;
}
};
_40a.prototype.isParameterFunction=function(){
var y=(this.parameters||[]).join(" ");
return this.isParameterFunctionVar||(this.isParameterFunctionVar=_31f(y));
};
function next(){
_33f=_32e;
_340=_32f;
_341=_331;
_343=null;
return _3d5();
};
function _452(_453){
_346=_453;
_328=_340;
_32d();
_3d5();
};
function _454(){
this.type=null;
this.start=_32e;
this.end=null;
};
function _455(){
this.start=_330;
this.end=null;
if(_310!==null){
this.source=_310;
}
};
function _41f(){
var node=new _454();
if(_30d.trackComments&&_334){
node.commentsBefore=_334;
_334=null;
}
if(_30d.trackSpaces&&_337){
node.spacesBefore=_337;
_337=null;
}
if(_30d.locations){
node.loc=new _455();
}
if(_30d.ranges){
node.range=[_32e,0];
}
return node;
};
function _425(_456){
var node=new _454();
node.start=_456.start;
if(_456.commentsBefore){
node.commentsBefore=_456.commentsBefore;
delete _456.commentsBefore;
}
if(_456.spacesBefore){
node.spacesBefore=_456.spacesBefore;
delete _456.spacesBefore;
}
if(_30d.locations){
node.loc=new _455();
node.loc.start=_456.loc.start;
}
if(_30d.ranges){
node.range=[_456.range[0],0];
}
return node;
};
var _457;
function _458(node,type){
node.type=type;
node.end=_340;
if(_30d.trackComments){
if(_336){
node.commentsAfter=_336;
_335=null;
}else{
if(_457&&_457.end===_340&&_457.commentsAfter){
node.commentsAfter=_457.commentsAfter;
delete _457.commentsAfter;
}
}
if(!_30d.trackSpaces){
_457=node;
}
}
if(_30d.trackSpaces){
if(_339){
node.spacesAfter=_339;
_339=null;
}else{
if(_457&&_457.end===_340&&_457.spacesAfter){
node.spacesAfter=_457.spacesAfter;
delete _457.spacesAfter;
}
}
_457=node;
}
if(_30d.locations){
node.loc.end=_341;
}
if(_30d.ranges){
node.range[1]=_340;
}
return node;
};
function _459(stmt){
return _30d.ecmaVersion>=5&&stmt.type==="ExpressionStatement"&&stmt.expression.type==="Literal"&&stmt.expression.value==="use strict";
};
function eat(type){
if(_332===type){
next();
return true;
}
};
function _45a(){
return !_30d.strictSemicolons&&(_332===_357||_332===_3a6||_3cf.test(_33d.slice(_340,_32e))||(_343&&_30d.objj));
};
function _45b(){
if(!eat(_3aa)&&!_45a()){
_350(_32e,"Expected a semicolon");
}
};
function _45c(type,_45d){
if(_332===type){
next();
}else{
_45d?_350(_32e,_45d):_3d9();
}
};
function _3d9(){
_350(_32e,"Unexpected token");
};
function _45e(expr){
if(expr.type!=="Identifier"&&expr.type!=="MemberExpression"&&expr.type!=="Dereference"){
_350(expr.start,"Assigning to rvalue");
}
if(_346&&expr.type==="Identifier"&&_3c5(expr.name)){
_350(expr.start,"Assigning to "+expr.name+" in strict mode");
}
};
function _313(_45f){
_33f=_340=_328;
if(_30d.locations){
_341=new _3d2;
}
_344=_346=null;
_345=[];
_3d5();
var node=_45f||_41f(),_460=true;
if(!_45f){
node.body=[];
}
while(_332!==_357){
var stmt=_461();
node.body.push(stmt);
if(_460&&_459(stmt)){
_452(true);
}
_460=false;
}
return _458(node,"Program");
};
var _462={kind:"loop"},_463={kind:"switch"};
function _461(){
if(_332===_3b1){
_3d5(true);
}
var _464=_332,node=_41f();
if(_343){
node.expression=_465(_343,_343.object);
_45b();
return _458(node,"ExpressionStatement");
}
switch(_464){
case _359:
case _35c:
next();
var _466=_464===_359;
if(eat(_3aa)||_45a()){
node.label=null;
}else{
if(_332!==_356){
_3d9();
}else{
node.label=_467();
_45b();
}
}
for(var i=0;i<_345.length;++i){
var lab=_345[i];
if(node.label==null||lab.name===node.label.name){
if(lab.kind!=null&&(_466||lab.kind==="loop")){
break;
}
if(node.label&&_466){
break;
}
}
}
if(i===_345.length){
_350(node.start,"Unsyntactic "+_464.keyword);
}
return _458(node,_466?"BreakStatement":"ContinueStatement");
case _35d:
next();
_45b();
return _458(node,"DebuggerStatement");
case _35f:
next();
_345.push(_462);
node.body=_461();
_345.pop();
_45c(_36a,"Expected 'while' at end of do statement");
node.test=_468();
_45b();
return _458(node,"DoWhileStatement");
case _362:
next();
_345.push(_462);
_45c(_3a7,"Expected '(' after 'for'");
if(_332===_3aa){
return _469(node,null);
}
if(_332===_369){
var init=_41f();
next();
_46a(init,true);
if(init.declarations.length===1&&eat(_372)){
return _46b(node,init);
}
return _469(node,init);
}
var init=_46c(false,true);
if(eat(_372)){
_45e(init);
return _46b(node,init);
}
return _469(node,init);
case _363:
next();
return _46d(node,true);
case _364:
next();
node.test=_468();
node.consequent=_461();
node.alternate=eat(_360)?_461():null;
return _458(node,"IfStatement");
case _365:
if(!_344){
_350(_32e,"'return' outside of function");
}
next();
if(eat(_3aa)||_45a()){
node.argument=null;
}else{
node.argument=_46c();
_45b();
}
return _458(node,"ReturnStatement");
case _366:
next();
node.discriminant=_468();
node.cases=[];
_45c(_3a5,"Expected '{' in switch statement");
_345.push(_463);
for(var cur,_46e;_332!=_3a6;){
if(_332===_35a||_332===_35e){
var _46f=_332===_35a;
if(cur){
_458(cur,"SwitchCase");
}
node.cases.push(cur=_41f());
cur.consequent=[];
next();
if(_46f){
cur.test=_46c();
}else{
if(_46e){
_350(_33f,"Multiple default clauses");
}
_46e=true;
cur.test=null;
}
_45c(_3ab,"Expected ':' after case clause");
}else{
if(!cur){
_3d9();
}
cur.consequent.push(_461());
}
}
if(cur){
_458(cur,"SwitchCase");
}
next();
_345.pop();
return _458(node,"SwitchStatement");
case _367:
next();
if(_3cf.test(_33d.slice(_340,_32e))){
_350(_340,"Illegal newline after throw");
}
node.argument=_46c();
_45b();
return _458(node,"ThrowStatement");
case _368:
next();
node.block=_470();
node.handlers=[];
while(_332===_35b){
var _471=_41f();
next();
_45c(_3a7,"Expected '(' after 'catch'");
_471.param=_467();
if(_346&&_3c5(_471.param.name)){
_350(_471.param.start,"Binding "+_471.param.name+" in strict mode");
}
_45c(_3a8,"Expected closing ')' after catch");
_471.guard=null;
_471.body=_470();
node.handlers.push(_458(_471,"CatchClause"));
}
node.finalizer=eat(_361)?_470():null;
if(!node.handlers.length&&!node.finalizer){
_350(node.start,"Missing catch or finally clause");
}
return _458(node,"TryStatement");
case _369:
next();
node=_46a(node);
_45b();
return node;
case _36a:
next();
node.test=_468();
_345.push(_462);
node.body=_461();
_345.pop();
return _458(node,"WhileStatement");
case _36b:
if(_346){
_350(_32e,"'with' in strict mode");
}
next();
node.object=_468();
node.body=_461();
return _458(node,"WithStatement");
case _3a5:
return _470();
case _3aa:
next();
return _458(node,"EmptyStatement");
case _383:
if(_30d.objj){
next();
node.classname=_467(true);
if(eat(_3ab)){
node.superclassname=_467(true);
}else{
if(eat(_3a7)){
node.categoryname=_467(true);
_45c(_3a8,"Expected closing ')' after category name");
}
}
if(_333==="<"){
next();
var _472=[],_473=true;
node.protocols=_472;
while(_333!==">"){
if(!_473){
_45c(_3a9,"Expected ',' between protocol names");
}else{
_473=false;
}
_472.push(_467(true));
}
next();
}
if(eat(_3a5)){
node.ivardeclarations=[];
for(;;){
if(eat(_3a6)){
break;
}
_474(node);
}
node.endOfIvars=_32e;
}
node.body=[];
while(!eat(_376)){
if(_332===_357){
_350(_328,"Expected '@end' after '@interface'");
}
node.body.push(_475());
}
return _458(node,"InterfaceDeclarationStatement");
}
break;
case _373:
if(_30d.objj){
next();
node.classname=_467(true);
if(eat(_3ab)){
node.superclassname=_467(true);
}else{
if(eat(_3a7)){
node.categoryname=_467(true);
_45c(_3a8,"Expected closing ')' after category name");
}
}
if(_333==="<"){
next();
var _472=[],_473=true;
node.protocols=_472;
while(_333!==">"){
if(!_473){
_45c(_3a9,"Expected ',' between protocol names");
}else{
_473=false;
}
_472.push(_467(true));
}
next();
}
if(_333==="<"){
next();
var _472=[],_473=true;
node.protocols=_472;
while(_333!==">"){
if(!_473){
_45c(_3a9,"Expected ',' between protocol names");
}else{
_473=false;
}
_472.push(_467(true));
}
next();
}
if(eat(_3a5)){
node.ivardeclarations=[];
for(;;){
if(eat(_3a6)){
break;
}
_474(node);
}
node.endOfIvars=_32e;
}
node.body=[];
while(!eat(_376)){
if(_332===_357){
_350(_328,"Expected '@end' after '@implementation'");
}
node.body.push(_475());
}
return _458(node,"ClassDeclarationStatement");
}
break;
case _380:
if(_30d.objj&&_30e.charCodeAt(_328)!==40){
next();
node.protocolname=_467(true);
if(_333==="<"){
next();
var _472=[],_473=true;
node.protocols=_472;
while(_333!==">"){
if(!_473){
_45c(_3a9,"Expected ',' between protocol names");
}else{
_473=false;
}
_472.push(_467(true));
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
(node.optional||(node.optional=[])).push(_476());
}
}else{
(node.required||(node.required=[])).push(_476());
}
}
return _458(node,"ProtocolDeclarationStatement");
}
break;
case _377:
if(_30d.objj){
next();
if(_332===_355){
node.localfilepath=true;
}else{
if(_332===_385){
node.localfilepath=false;
}else{
_3d9();
}
}
node.filename=_477();
return _458(node,"ImportStatement");
}
break;
case _392:
if(_30d.objj){
next();
return _458(node,"PreprocessStatement");
}
break;
case _37a:
if(_30d.objj){
next();
node.id=_467(false);
return _458(node,"ClassStatement");
}
break;
case _37b:
if(_30d.objj){
next();
node.id=_467(false);
return _458(node,"GlobalStatement");
}
break;
case _384:
if(_30d.objj){
next();
node.typedefname=_467(true);
return _458(node,"TypeDefStatement");
}
break;
}
var _478=_333,expr=_46c();
if(_464===_356&&expr.type==="Identifier"&&eat(_3ab)){
for(var i=0;i<_345.length;++i){
if(_345[i].name===_478){
_350(expr.start,"Label '"+_478+"' is already declared");
}
}
var kind=_332.isLoop?"loop":_332===_366?"switch":null;
_345.push({name:_478,kind:kind});
node.body=_461();
_345.pop();
node.label=expr;
return _458(node,"LabeledStatement");
}else{
node.expression=expr;
_45b();
return _458(node,"ExpressionStatement");
}
};
function _474(node){
var _479;
if(eat(_374)){
_479=true;
}
var type=_47a();
if(_346&&_3c5(type.name)){
_350(type.start,"Binding "+type.name+" in strict mode");
}
for(;;){
var decl=_41f();
if(_479){
decl.outlet=_479;
}
decl.ivartype=type;
decl.id=_467();
if(_346&&_3c5(decl.id.name)){
_350(decl.id.start,"Binding "+decl.id.name+" in strict mode");
}
if(eat(_375)){
decl.accessors={};
if(eat(_3a7)){
if(!eat(_3a8)){
for(;;){
var _47b=_467(true);
switch(_47b.name){
case "property":
case "getter":
_45c(_3b2,"Expected '=' after 'getter' accessor attribute");
decl.accessors[_47b.name]=_467(true);
break;
case "setter":
_45c(_3b2,"Expected '=' after 'setter' accessor attribute");
var _47c=_467(true);
decl.accessors[_47b.name]=_47c;
if(eat(_3ab)){
_47c.end=_32e;
}
_47c.name+=":";
break;
case "readwrite":
case "readonly":
case "copy":
decl.accessors[_47b.name]=true;
break;
default:
_350(_47b.start,"Unknown accessors attribute '"+_47b.name+"'");
}
if(!eat(_3a9)){
break;
}
}
_45c(_3a8,"Expected closing ')' after accessor attributes");
}
}
}
_458(decl,"IvarDeclaration");
node.ivardeclarations.push(decl);
if(!eat(_3a9)){
break;
}
}
_45b();
};
function _47d(node){
node.methodtype=_333;
_45c(_3b4,"Method declaration must start with '+' or '-'");
if(eat(_3a7)){
var _47e=_41f();
if(eat(_378)){
node.action=_458(_47e,"ObjectiveJActionType");
_47e=_41f();
}
if(!eat(_3a8)){
node.returntype=_47a(_47e);
_45c(_3a8,"Expected closing ')' after method return type");
}
}
var _47f=true,_480=[],args=[];
node.selectors=_480;
node.arguments=args;
for(;;){
if(_332!==_3ab){
_480.push(_467(true));
if(_47f&&_332!==_3ab){
break;
}
}else{
_480.push(null);
}
_45c(_3ab,"Expected ':' in selector");
var _481={};
args.push(_481);
if(eat(_3a7)){
_481.type=_47a();
_45c(_3a8,"Expected closing ')' after method argument type");
}
_481.identifier=_467(false);
if(_332===_3a5||_332===_3aa){
break;
}
if(eat(_3a9)){
_45c(_3af,"Expected '...' after ',' in method declaration");
node.parameters=true;
break;
}
_47f=false;
}
};
function _475(){
var _482=_41f();
if(_333==="+"||_333==="-"){
_47d(_482);
eat(_3aa);
_482.startOfBody=_340;
var _483=_344,_484=_345;
_344=true;
_345=[];
_482.body=_470(true);
_344=_483;
_345=_484;
return _458(_482,"MethodDeclarationStatement");
}else{
return _461();
}
};
function _476(){
var _485=_41f();
_47d(_485);
_45b();
return _458(_485,"MethodDeclarationStatement");
};
function _468(){
_45c(_3a7,"Expected '(' before expression");
var val=_46c();
_45c(_3a8,"Expected closing ')' after expression");
return val;
};
function _470(_486){
var node=_41f(),_487=true,_346=false,_488;
node.body=[];
_45c(_3a5,"Expected '{' before block");
while(!eat(_3a6)){
var stmt=_461();
node.body.push(stmt);
if(_487&&_459(stmt)){
_488=_346;
_452(_346=true);
}
_487=false;
}
if(_346&&!_488){
_452(false);
}
return _458(node,"BlockStatement");
};
function _469(node,init){
node.init=init;
_45c(_3aa,"Expected ';' in for statement");
node.test=_332===_3aa?null:_46c();
_45c(_3aa,"Expected ';' in for statement");
node.update=_332===_3a8?null:_46c();
_45c(_3a8,"Expected closing ')' in for statement");
node.body=_461();
_345.pop();
return _458(node,"ForStatement");
};
function _46b(node,init){
node.left=init;
node.right=_46c();
_45c(_3a8,"Expected closing ')' in for statement");
node.body=_461();
_345.pop();
return _458(node,"ForInStatement");
};
function _46a(node,noIn){
node.declarations=[];
node.kind="var";
for(;;){
var decl=_41f();
decl.id=_467();
if(_346&&_3c5(decl.id.name)){
_350(decl.id.start,"Binding "+decl.id.name+" in strict mode");
}
decl.init=eat(_3b2)?_46c(true,noIn):null;
node.declarations.push(_458(decl,"VariableDeclarator"));
if(!eat(_3a9)){
break;
}
}
return _458(node,"VariableDeclaration");
};
function _46c(_489,noIn){
var expr=_48a(noIn);
if(!_489&&_332===_3a9){
var node=_425(expr);
node.expressions=[expr];
while(eat(_3a9)){
node.expressions.push(_48a(noIn));
}
return _458(node,"SequenceExpression");
}
return expr;
};
function _48a(noIn){
var left=_48b(noIn);
if(_332.isAssign){
var node=_425(left);
node.operator=_333;
node.left=left;
next();
node.right=_48a(noIn);
_45e(left);
return _458(node,"AssignmentExpression");
}
return left;
};
function _48b(noIn){
var expr=_48c(noIn);
if(eat(_3ad)){
var node=_425(expr);
node.test=expr;
node.consequent=_46c(true);
_45c(_3ab,"Expected ':' in conditional expression");
node.alternate=_46c(true,noIn);
return _458(node,"ConditionalExpression");
}
return expr;
};
function _48c(noIn){
return _48d(_48e(noIn),-1,noIn);
};
function _48d(left,_48f,noIn){
var prec=_332.binop;
if(prec!=null&&(!noIn||_332!==_372)){
if(prec>_48f){
var node=_425(left);
node.left=left;
node.operator=_333;
next();
node.right=_48d(_48e(noIn),prec,noIn);
var node=_458(node,/&&|\|\|/.test(node.operator)?"LogicalExpression":"BinaryExpression");
return _48d(node,_48f,noIn);
}
}
return left;
};
function _48e(noIn){
if(_332.prefix){
var node=_41f(),_490=_332.isUpdate;
node.operator=_333;
node.prefix=true;
next();
node.argument=_48e(noIn);
if(_490){
_45e(node.argument);
}else{
if(_346&&node.operator==="delete"&&node.argument.type==="Identifier"){
_350(node.start,"Deleting local variable in strict mode");
}
}
return _458(node,_490?"UpdateExpression":"UnaryExpression");
}
var expr=_491();
while(_332.postfix&&!_45a()){
var node=_425(expr);
node.operator=_333;
node.prefix=false;
node.argument=expr;
_45e(expr);
next();
expr=_458(node,"UpdateExpression");
}
return expr;
};
function _491(){
return _492(_493());
};
function _492(base,_494){
if(eat(_3ac)){
var node=_425(base);
node.object=base;
node.property=_467(true);
node.computed=false;
return _492(_458(node,"MemberExpression"),_494);
}else{
if(_30d.objj){
var _495=_41f();
}
if(eat(_3a3)){
var expr=_46c();
if(_30d.objj&&_332!==_3a4){
_495.object=expr;
_343=_495;
return base;
}
var node=_425(base);
node.object=base;
node.property=expr;
node.computed=true;
_45c(_3a4,"Expected closing ']' in subscript");
return _492(_458(node,"MemberExpression"),_494);
}else{
if(!_494&&eat(_3a7)){
var node=_425(base);
node.callee=base;
node.arguments=_496(_3a8,_332===_3a8?null:_46c(true),false);
return _492(_458(node,"CallExpression"),_494);
}
}
}
return base;
};
function _493(){
switch(_332){
case _36d:
var node=_41f();
next();
return _458(node,"ThisExpression");
case _356:
return _467();
case _353:
case _355:
case _354:
return _477();
case _36f:
case _370:
case _371:
var node=_41f();
node.value=_332.atomValue;
node.raw=_332.keyword;
next();
return _458(node,"Literal");
case _3a7:
var _497=_330,_498=_32e;
next();
var val=_46c();
val.start=_498;
val.end=_32f;
if(_30d.locations){
val.loc.start=_497;
val.loc.end=_331;
}
if(_30d.ranges){
val.range=[_498,_32f];
}
_45c(_3a8,"Expected closing ')' in expression");
return val;
case _37d:
var node=_41f(),_499=null;
next();
_45c(_3a3,"Expected '[' at beginning of array literal");
if(_332!==_3a4){
_499=_46c(true,true);
}
node.elements=_496(_3a4,_499,true,true);
return _458(node,"ArrayLiteral");
case _3a3:
var node=_41f(),_499=null;
next();
if(_332!==_3a9&&_332!==_3a4){
_499=_46c(true,true);
if(_332!==_3a9&&_332!==_3a4){
return _465(node,_499);
}
}
node.elements=_496(_3a4,_499,true,true);
return _458(node,"ArrayExpression");
case _37c:
var node=_41f();
next();
var r=_49a();
node.keys=r[0];
node.values=r[1];
return _458(node,"DictionaryLiteral");
case _3a5:
return _49b();
case _363:
var node=_41f();
next();
return _46d(node,false);
case _36c:
return _49c();
case _379:
var node=_41f();
next();
_45c(_3a7,"Expected '(' after '@selector'");
_49d(node,_3a8);
_45c(_3a8,"Expected closing ')' after selector");
return _458(node,"SelectorLiteralExpression");
case _380:
var node=_41f();
next();
_45c(_3a7,"Expected '(' after '@protocol'");
node.id=_467(true);
_45c(_3a8,"Expected closing ')' after protocol name");
return _458(node,"ProtocolLiteralExpression");
case _37e:
var node=_41f();
next();
_45c(_3a7,"Expected '(' after '@ref'");
node.element=_467(node,_3a8);
_45c(_3a8,"Expected closing ')' after ref");
return _458(node,"Reference");
case _37f:
var node=_41f();
next();
_45c(_3a7,"Expected '(' after '@deref'");
node.expr=_46c(true,true);
_45c(_3a8,"Expected closing ')' after deref");
return _458(node,"Dereference");
default:
if(_332.okAsIdent){
return _467();
}
_3d9();
}
};
function _465(node,_49e){
_49f(node,_3a4);
if(_49e.type==="Identifier"&&_49e.name==="super"){
node.superObject=true;
}else{
node.object=_49e;
}
return _458(node,"MessageSendExpression");
};
function _49d(node,_4a0){
var _4a1=true,_4a2=[];
for(;;){
if(_332!==_3ab){
_4a2.push(_467(true).name);
if(_4a1&&_332===_4a0){
break;
}
}
_45c(_3ab,"Expected ':' in selector");
_4a2.push(":");
if(_332===_4a0){
break;
}
_4a1=false;
}
node.selector=_4a2.join("");
};
function _49f(node,_4a3){
var _4a4=true,_4a5=[],args=[],_4a6=[];
node.selectors=_4a5;
node.arguments=args;
for(;;){
if(_332!==_3ab){
_4a5.push(_467(true));
if(_4a4&&eat(_4a3)){
break;
}
}else{
_4a5.push(null);
}
_45c(_3ab,"Expected ':' in selector");
args.push(_46c(true,true));
if(eat(_4a3)){
break;
}
if(_332===_3a9){
node.parameters=[];
while(eat(_3a9)){
node.parameters.push(_46c(true,true));
}
eat(_4a3);
break;
}
_4a4=false;
}
};
function _49c(){
var node=_41f();
next();
node.callee=_492(_493(false),true);
if(eat(_3a7)){
node.arguments=_496(_3a8,_332===_3a8?null:_46c(true),false);
}else{
node.arguments=[];
}
return _458(node,"NewExpression");
};
function _49b(){
var node=_41f(),_4a7=true,_4a8=false;
node.properties=[];
next();
while(!eat(_3a6)){
if(!_4a7){
_45c(_3a9,"Expected ',' in object literal");
if(_30d.allowTrailingCommas&&eat(_3a6)){
break;
}
}else{
_4a7=false;
}
var prop={key:_4a9()},_4aa=false,kind;
if(eat(_3ab)){
prop.value=_46c(true);
kind=prop.kind="init";
}else{
if(_30d.ecmaVersion>=5&&prop.key.type==="Identifier"&&(prop.key.name==="get"||prop.key.name==="set")){
_4aa=_4a8=true;
kind=prop.kind=prop.key.name;
prop.key=_4a9();
if(_332!==_3a7){
_3d9();
}
prop.value=_46d(_41f(),false);
}else{
_3d9();
}
}
if(prop.key.type==="Identifier"&&(_346||_4a8)){
for(var i=0;i<node.properties.length;++i){
var _4ab=node.properties[i];
if(_4ab.key.name===prop.key.name){
var _4ac=kind==_4ab.kind||_4aa&&_4ab.kind==="init"||kind==="init"&&(_4ab.kind==="get"||_4ab.kind==="set");
if(_4ac&&!_346&&kind==="init"&&_4ab.kind==="init"){
_4ac=false;
}
if(_4ac){
_350(prop.key.start,"Redefinition of property");
}
}
}
}
node.properties.push(prop);
}
return _458(node,"ObjectExpression");
};
function _4a9(){
if(_332===_353||_332===_355){
return _493();
}
return _467(true);
};
function _46d(node,_4ad){
if(_332===_356){
node.id=_467();
}else{
if(_4ad){
_3d9();
}else{
node.id=null;
}
}
node.params=[];
var _4ae=true;
_45c(_3a7,"Expected '(' before function parameters");
while(!eat(_3a8)){
if(!_4ae){
_45c(_3a9,"Expected ',' between function parameters");
}else{
_4ae=false;
}
node.params.push(_467());
}
var _4af=_344,_4b0=_345;
_344=true;
_345=[];
node.body=_470(true);
_344=_4af;
_345=_4b0;
if(_346||node.body.body.length&&_459(node.body.body[0])){
for(var i=node.id?-1:0;i<node.params.length;++i){
var id=i<0?node.id:node.params[i];
if(_3c4(id.name)||_3c5(id.name)){
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
return _458(node,_4ad?"FunctionDeclaration":"FunctionExpression");
};
function _496(_4b1,_4b2,_4b3,_4b4){
if(_4b2&&eat(_4b1)){
return [_4b2];
}
var elts=[],_4b5=true;
while(!eat(_4b1)){
if(_4b5){
_4b5=false;
if(_4b4&&_332===_3a9&&!_4b2){
elts.push(null);
}else{
elts.push(_4b2);
}
}else{
_45c(_3a9,"Expected ',' between expressions");
if(_4b3&&_30d.allowTrailingCommas&&eat(_4b1)){
break;
}
if(_4b4&&_332===_3a9){
elts.push(null);
}else{
elts.push(_46c(true));
}
}
}
return elts;
};
function _49a(){
_45c(_3a5,"Expected '{' before dictionary");
var keys=[],_4b6=[],_4b7=true;
while(!eat(_3a6)){
if(!_4b7){
_45c(_3a9,"Expected ',' between expressions");
if(_30d.allowTrailingCommas&&eat(_3a6)){
break;
}
}
keys.push(_46c(true,true));
_45c(_3ab,"Expected ':' between dictionary key and value");
_4b6.push(_46c(true,true));
_4b7=false;
}
return [keys,_4b6];
};
function _467(_4b8){
var node=_41f();
node.name=_332===_356?_333:(((_4b8&&!_30d.forbidReserved)||_332.okAsIdent)&&_332.keyword)||_3d9();
next();
return _458(node,"Identifier");
};
function _477(){
var node=_41f();
node.value=_333;
node.raw=_33d.slice(_32e,_32f);
next();
return _458(node,"Literal");
};
function _47a(_4b9){
var node=_4b9?_425(_4b9):_41f();
if(_332===_356){
node.name=_333;
node.typeisclass=true;
next();
}else{
node.typeisclass=false;
node.name=_332.keyword;
if(!eat(_36e)){
if(eat(_38d)){
if(_333==="<"){
var _4ba=true,_4bb=[];
node.protocols=_4bb;
do{
next();
if(_4ba){
_4ba=false;
}else{
eat(_3a9);
}
_4bb.push(_467(true));
}while(_333!==">");
next();
}
}else{
var _4bc;
if(eat(_390)||eat(_38e)||eat(_38f)||eat(_391)){
_4bc=_332.keyword;
}else{
if(eat(_387)||eat(_386)){
_4bc=_332.keyword||true;
}
if(eat(_389)||eat(_388)||eat(_38a)){
if(_4bc){
node.name+=" "+_4bc;
}
_4bc=_332.keyword||true;
}else{
if(eat(_38b)){
if(_4bc){
node.name+=" "+_4bc;
}
_4bc=_332.keyword||true;
}
if(eat(_38c)){
if(_4bc){
node.name+=" "+_4bc;
}
_4bc=_332.keyword||true;
if(eat(_38c)){
node.name+=" "+_4bc;
}
}
}
if(!_4bc){
node.name=(!_30d.forbidReserved&&_332.keyword)||_3d9();
node.typeisclass=true;
next();
}
}
}
}
}
return _458(node,"ObjectiveJType");
};
})(typeof _2==="undefined"?(self.acorn={}):_2.acorn);
if(!_2.acorn){
_2.acorn={};
_2.acorn.walk={};
}
(function(_4bd){
"use strict";
_4bd.simple=function(node,_4be,base,_4bf){
if(!base){
base=_4bd;
}
function c(node,st,_4c0){
var type=_4c0||node.type,_4c1=_4be[type];
if(_4c1){
_4c1(node,st);
}
base[type](node,st,c);
};
c(node,_4bf);
};
_4bd.recursive=function(node,_4c2,_4c3,base){
var _4c4=_4bd.make(_4c3,base);
function c(node,st,_4c5){
return _4c4[_4c5||node.type](node,st,c);
};
return c(node,_4c2);
};
_4bd.make=function(_4c6,base){
if(!base){
base=_4bd;
}
var _4c7={};
for(var type in base){
_4c7[type]=base[type];
}
for(var type in _4c6){
_4c7[type]=_4c6[type];
}
return _4c7;
};
function _4c8(node,st,c){
c(node,st);
};
function _4c9(node,st,c){
};
_4bd.Program=_4bd.BlockStatement=function(node,st,c){
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
};
_4bd.Statement=_4c8;
_4bd.EmptyStatement=_4c9;
_4bd.ExpressionStatement=function(node,st,c){
c(node.expression,st,"Expression");
};
_4bd.IfStatement=function(node,st,c){
c(node.test,st,"Expression");
c(node.consequent,st,"Statement");
if(node.alternate){
c(node.alternate,st,"Statement");
}
};
_4bd.LabeledStatement=function(node,st,c){
c(node.body,st,"Statement");
};
_4bd.BreakStatement=_4bd.ContinueStatement=_4c9;
_4bd.WithStatement=function(node,st,c){
c(node.object,st,"Expression");
c(node.body,st,"Statement");
};
_4bd.SwitchStatement=function(node,st,c){
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
_4bd.ReturnStatement=function(node,st,c){
if(node.argument){
c(node.argument,st,"Expression");
}
};
_4bd.ThrowStatement=function(node,st,c){
c(node.argument,st,"Expression");
};
_4bd.TryStatement=function(node,st,c){
c(node.block,st,"Statement");
for(var i=0;i<node.handlers.length;++i){
c(node.handlers[i].body,st,"ScopeBody");
}
if(node.finalizer){
c(node.finalizer,st,"Statement");
}
};
_4bd.WhileStatement=function(node,st,c){
c(node.test,st,"Expression");
c(node.body,st,"Statement");
};
_4bd.DoWhileStatement=function(node,st,c){
c(node.body,st,"Statement");
c(node.test,st,"Expression");
};
_4bd.ForStatement=function(node,st,c){
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
_4bd.ForInStatement=function(node,st,c){
c(node.left,st,"ForInit");
c(node.right,st,"Expression");
c(node.body,st,"Statement");
};
_4bd.ForInit=function(node,st,c){
if(node.type=="VariableDeclaration"){
c(node,st);
}else{
c(node,st,"Expression");
}
};
_4bd.DebuggerStatement=_4c9;
_4bd.FunctionDeclaration=function(node,st,c){
c(node,st,"Function");
};
_4bd.VariableDeclaration=function(node,st,c){
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i];
if(decl.init){
c(decl.init,st,"Expression");
}
}
};
_4bd.Function=function(node,st,c){
c(node.body,st,"ScopeBody");
};
_4bd.ScopeBody=function(node,st,c){
c(node,st,"Statement");
};
_4bd.Expression=_4c8;
_4bd.ThisExpression=_4c9;
_4bd.ArrayExpression=_4bd.ArrayLiteral=function(node,st,c){
for(var i=0;i<node.elements.length;++i){
var elt=node.elements[i];
if(elt){
c(elt,st,"Expression");
}
}
};
_4bd.DictionaryLiteral=function(node,st,c){
for(var i=0;i<node.keys.length;i++){
var key=node.keys[i];
c(key,st,"Expression");
var _4ca=node.values[i];
c(_4ca,st,"Expression");
}
};
_4bd.ObjectExpression=function(node,st,c){
for(var i=0;i<node.properties.length;++i){
c(node.properties[i].value,st,"Expression");
}
};
_4bd.FunctionExpression=_4bd.FunctionDeclaration;
_4bd.SequenceExpression=function(node,st,c){
for(var i=0;i<node.expressions.length;++i){
c(node.expressions[i],st,"Expression");
}
};
_4bd.UnaryExpression=_4bd.UpdateExpression=function(node,st,c){
c(node.argument,st,"Expression");
};
_4bd.BinaryExpression=_4bd.AssignmentExpression=_4bd.LogicalExpression=function(node,st,c){
c(node.left,st,"Expression");
c(node.right,st,"Expression");
};
_4bd.ConditionalExpression=function(node,st,c){
c(node.test,st,"Expression");
c(node.consequent,st,"Expression");
c(node.alternate,st,"Expression");
};
_4bd.NewExpression=_4bd.CallExpression=function(node,st,c){
c(node.callee,st,"Expression");
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
c(node.arguments[i],st,"Expression");
}
}
};
_4bd.MemberExpression=function(node,st,c){
c(node.object,st,"Expression");
if(node.computed){
c(node.property,st,"Expression");
}
};
_4bd.Identifier=_4bd.Literal=_4c9;
_4bd.ClassDeclarationStatement=function(node,st,c){
if(node.ivardeclarations){
for(var i=0;i<node.ivardeclarations.length;++i){
c(node.ivardeclarations[i],st,"IvarDeclaration");
}
}
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
};
_4bd.ImportStatement=_4c9;
_4bd.IvarDeclaration=_4c9;
_4bd.PreprocessStatement=_4c9;
_4bd.ClassStatement=_4c9;
_4bd.GlobalStatement=_4c9;
_4bd.ProtocolDeclarationStatement=function(node,st,c){
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
_4bd.TypeDefStatement=_4c9;
_4bd.MethodDeclarationStatement=function(node,st,c){
var body=node.body;
if(body){
c(body,st,"Statement");
}
};
_4bd.MessageSendExpression=function(node,st,c){
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
_4bd.SelectorLiteralExpression=_4c9;
_4bd.ProtocolLiteralExpression=_4c9;
_4bd.Reference=function(node,st,c){
c(node.element,st,"Identifier");
};
_4bd.Dereference=function(node,st,c){
c(node.expr,st,"Expression");
};
function _4cb(prev){
return {vars:Object.create(null),prev:prev};
};
_4bd.scopeVisitor=_4bd.make({Function:function(node,_4cc,c){
var _4cd=_4cb(_4cc);
for(var i=0;i<node.params.length;++i){
_4cd.vars[node.params[i].name]={type:"argument",node:node.params[i]};
}
if(node.id){
var decl=node.type=="FunctionDeclaration";
(decl?_4cc:_4cd).vars[node.id.name]={type:decl?"function":"function name",node:node.id};
}
c(node.body,_4cd,"ScopeBody");
},TryStatement:function(node,_4ce,c){
c(node.block,_4ce,"Statement");
for(var i=0;i<node.handlers.length;++i){
var _4cf=node.handlers[i],_4d0=_4cb(_4ce);
_4d0.vars[_4cf.param.name]={type:"catch clause",node:_4cf.param};
c(_4cf.body,_4d0,"ScopeBody");
}
if(node.finalizer){
c(node.finalizer,_4ce,"Statement");
}
},VariableDeclaration:function(node,_4d1,c){
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i];
_4d1.vars[decl.id.name]={type:"var",node:decl.id};
if(decl.init){
c(decl.init,_4d1,"Expression");
}
}
}});
})(typeof _2=="undefined"?acorn.walk={}:_2.acorn.walk);
var _4d2=function(prev,base){
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
_4d2.prototype.compiler=function(){
return this.compiler;
};
_4d2.prototype.rootScope=function(){
return this.prev?this.prev.rootScope():this;
};
_4d2.prototype.isRootScope=function(){
return !this.prev;
};
_4d2.prototype.currentClassName=function(){
return this.classDef?this.classDef.name:this.prev?this.prev.currentClassName():null;
};
_4d2.prototype.currentProtocolName=function(){
return this.protocolDef?this.protocolDef.name:this.prev?this.prev.currentProtocolName():null;
};
_4d2.prototype.getIvarForCurrentClass=function(_4d3){
if(this.ivars){
var ivar=this.ivars[_4d3];
if(ivar){
return ivar;
}
}
var prev=this.prev;
if(prev&&!this.classDef){
return prev.getIvarForCurrentClass(_4d3);
}
return null;
};
_4d2.prototype.getLvar=function(_4d4,_4d5){
if(this.vars){
var lvar=this.vars[_4d4];
if(lvar){
return lvar;
}
}
var prev=this.prev;
if(prev&&(!_4d5||!this.methodType)){
return prev.getLvar(_4d4,_4d5);
}
return null;
};
_4d2.prototype.currentMethodType=function(){
return this.methodType?this.methodType:this.prev?this.prev.currentMethodType():null;
};
_4d2.prototype.copyAddedSelfToIvarsToParent=function(){
if(this.prev&&this.addedSelfToIvars){
for(var key in this.addedSelfToIvars){
var _4d6=this.addedSelfToIvars[key],_4d7=(this.prev.addedSelfToIvars||(this.prev.addedSelfToIvars=Object.create(null)))[key]||(this.prev.addedSelfToIvars[key]=[]);
_4d7.push.apply(_4d7,_4d6);
}
}
};
_4d2.prototype.addMaybeWarning=function(_4d8){
var _4d9=this.rootScope();
(_4d9._maybeWarnings||(_4d9._maybeWarnings=[])).push(_4d8);
};
_4d2.prototype.maybeWarnings=function(){
return this.rootScope()._maybeWarnings;
};
var _4da=function(_4db,node,code){
this.message=_4dc(_4db,node,code);
this.node=node;
};
_4da.prototype.checkIfWarning=function(st){
var _4dd=this.node.name;
return !st.getLvar(_4dd)&&typeof _1[_4dd]==="undefined"&&typeof window[_4dd]==="undefined"&&!st.compiler.getClassDef(_4dd);
};
function _2ae(){
this.atoms=[];
};
_2ae.prototype.toString=function(){
return this.atoms.join("");
};
_2ae.prototype.concat=function(_4de){
this.atoms.push(_4de);
};
_2ae.prototype.isEmpty=function(){
return this.atoms.length!==0;
};
var _4df=function(_4e0,name,_4e1,_4e2,_4e3,_4e4,_4e5){
this.name=name;
if(_4e1){
this.superClass=_4e1;
}
if(_4e2){
this.ivars=_4e2;
}
if(_4e0){
this.instanceMethods=_4e3||Object.create(null);
this.classMethods=_4e4||Object.create(null);
}
if(_4e5){
this.protocols=_4e5;
}
};
_4df.prototype.addInstanceMethod=function(_4e6){
this.instanceMethods[_4e6.name]=_4e6;
};
_4df.prototype.addClassMethod=function(_4e7){
this.classMethods[_4e7.name]=_4e7;
};
_4df.prototype.listOfNotImplementedMethodsForProtocols=function(_4e8){
var _4e9=[],_4ea=this.getInstanceMethods(),_4eb=this.getClassMethods();
for(var i=0,size=_4e8.length;i<size;i++){
var _4ec=_4e8[i],_4ed=_4ec.requiredInstanceMethods,_4ee=_4ec.requiredClassMethods,_4ef=_4ec.protocols;
if(_4ed){
for(var _4f0 in _4ed){
var _4f1=_4ed[_4f0];
if(!_4ea[_4f0]){
_4e9.push({"methodDef":_4f1,"protocolDef":_4ec});
}
}
}
if(_4ee){
for(var _4f0 in _4ee){
var _4f1=_4ee[_4f0];
if(!_4eb[_4f0]){
_4e9.push({"methodDef":_4f1,"protocolDef":_4ec});
}
}
}
if(_4ef){
_4e9=_4e9.concat(this.listOfNotImplementedMethodsForProtocols(_4ef));
}
}
return _4e9;
};
_4df.prototype.getInstanceMethod=function(name){
var _4f2=this.instanceMethods;
if(_4f2){
var _4f3=_4f2[name];
if(_4f3){
return _4f3;
}
}
var _4f4=this.superClass;
if(_4f4){
return _4f4.getInstanceMethod(name);
}
return null;
};
_4df.prototype.getClassMethod=function(name){
var _4f5=this.classMethods;
if(_4f5){
var _4f6=_4f5[name];
if(_4f6){
return _4f6;
}
}
var _4f7=this.superClass;
if(_4f7){
return _4f7.getClassMethod(name);
}
return null;
};
_4df.prototype.getInstanceMethods=function(){
var _4f8=this.instanceMethods;
if(_4f8){
var _4f9=this.superClass,_4fa=Object.create(null);
if(_4f9){
var _4fb=_4f9.getInstanceMethods();
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
_4df.prototype.getClassMethods=function(){
var _4fd=this.classMethods;
if(_4fd){
var _4fe=this.superClass,_4ff=Object.create(null);
if(_4fe){
var _500=_4fe.getClassMethods();
for(var _501 in _500){
_4ff[_501]=_500[_501];
}
}
for(var _501 in _4fd){
_4ff[_501]=_4fd[_501];
}
return _4ff;
}
return [];
};
var _502=function(name,_503,_504,_505){
this.name=name;
this.protocols=_503;
if(_504){
this.requiredInstanceMethods=_504;
}
if(_505){
this.requiredClassMethods=_505;
}
};
_502.prototype.addInstanceMethod=function(_506){
(this.requiredInstanceMethods||(this.requiredInstanceMethods=Object.create(null)))[_506.name]=_506;
};
_502.prototype.addClassMethod=function(_507){
(this.requiredClassMethods||(this.requiredClassMethods=Object.create(null)))[_507.name]=_507;
};
_502.prototype.getInstanceMethod=function(name){
var _508=this.requiredInstanceMethods;
if(_508){
var _509=_508[name];
if(_509){
return _509;
}
}
var _50a=this.protocols;
for(var i=0,size=_50a.length;i<size;i++){
var _50b=_50a[i],_509=_50b.getInstanceMethod(name);
if(_509){
return _509;
}
}
return null;
};
_502.prototype.getClassMethod=function(name){
var _50c=this.requiredClassMethods;
if(_50c){
var _50d=_50c[name];
if(_50d){
return _50d;
}
}
var _50e=this.protocols;
for(var i=0,size=_50e.length;i<size;i++){
var _50f=_50e[i],_50d=_50f.getInstanceMethod(name);
if(_50d){
return _50d;
}
}
return null;
};
var _510=function(name){
this.name=name;
};
var _511=function(name,_512){
this.name=name;
this.types=_512;
};
var _513="";
var _514=_2.acorn.makePredicate("self _cmd undefined localStorage arguments");
var _515=_2.acorn.makePredicate("delete in instanceof new typeof void");
var _516=_2.acorn.makePredicate("LogicalExpression BinaryExpression");
var _517=_2.acorn.makePredicate("in instanceof");
var _518=function(_519,aURL,_51a,pass,_51b,_51c,_51d){
this.source=_519;
this.URL=new CFURL(aURL);
this.pass=pass;
this.jsBuffer=new _2ae();
this.imBuffer=null;
this.cmBuffer=null;
this.warnings=[];
try{
this.tokens=_2.acorn.parse(_519);
}
catch(e){
if(e.lineStart!=null){
var _51e=this.prettifyMessage(e,"ERROR");
console.log(_51e);
}
throw e;
}
this.dependencies=[];
this.flags=_51a|_518.Flags.IncludeDebugSymbols;
this.classDefs=_51b?_51b:Object.create(null);
this.protocolDefs=_51c?_51c:Object.create(null);
this.typeDefs=_51d?_51d:Object.create(null);
this.lastPos=0;
if(_513&_518.Flags.Generate){
this.generate=true;
}
this.generate=true;
_51f(this.tokens,new _4d2(null,{compiler:this}),pass===2?_520:_521);
};
_2.ObjJAcornCompiler=_518;
_2.ObjJAcornCompiler.compileToExecutable=function(_522,aURL,_523){
_518.currentCompileFile=aURL;
return new _518(_522,aURL,_523,2).executable();
};
_2.ObjJAcornCompiler.compileToIMBuffer=function(_524,aURL,_525,_526,_527,_528){
return new _518(_524,aURL,_525,2,_526,_527,_528).IMBuffer();
};
_2.ObjJAcornCompiler.compileFileDependencies=function(_529,aURL,_52a){
_518.currentCompileFile=aURL;
return new _518(_529,aURL,_52a,1).executable();
};
_518.prototype.compilePass2=function(){
_518.currentCompileFile=this.URL;
this.pass=2;
this.jsBuffer=new _2ae();
this.warnings=[];
_51f(this.tokens,new _4d2(null,{compiler:this}),_520);
for(var i=0;i<this.warnings.length;i++){
var _52b=this.prettifyMessage(this.warnings[i],"WARNING");
console.log(_52b);
}
return this.jsBuffer.toString();
};
var _513="";
_2.setCurrentCompilerFlags=function(_52c){
_513=_52c;
};
_2.currentCompilerFlags=function(_52d){
return _513;
};
_518.Flags={};
_518.Flags.IncludeDebugSymbols=1<<0;
_518.Flags.IncludeTypeSignatures=1<<1;
_518.Flags.Generate=1<<2;
_518.prototype.addWarning=function(_52e){
this.warnings.push(_52e);
};
_518.prototype.getIvarForClass=function(_52f,_530){
var ivar=_530.getIvarForCurrentClass(_52f);
if(ivar){
return ivar;
}
var c=this.getClassDef(_530.currentClassName());
while(c){
var _531=c.ivars;
if(_531){
var _532=_531[_52f];
if(_532){
return _532;
}
}
c=c.superClass;
}
};
_518.prototype.getClassDef=function(_533){
if(!_533){
return null;
}
var c=this.classDefs[_533];
if(c){
return c;
}
if(typeof objj_getClass==="function"){
var _534=objj_getClass(_533);
if(_534){
var _535=class_copyIvarList(_534),_536=_535.length,_537=Object.create(null),_538=class_copyProtocolList(_534),_539=_538.length,_53a=Object.create(null),_53b=_518.methodDefsFromMethodList(class_copyMethodList(_534)),_53c=_518.methodDefsFromMethodList(class_copyMethodList(_534.isa)),_53d=class_getSuperclass(_534);
for(var i=0;i<_536;i++){
var ivar=_535[i];
_537[ivar.name]={"type":ivar.type,"name":ivar.name};
}
for(var i=0;i<_539;i++){
var _53e=_538[i],_53f=protocol_getName(_53e),_540=this.getProtocolDef(_53f);
_53a[_53f]=_540;
}
c=new _4df(true,_533,_53d?this.getClassDef(_53d.name):null,_537,_53b,_53c,_53a);
this.classDefs[_533]=c;
return c;
}
}
return null;
};
_518.prototype.getProtocolDef=function(_541){
if(!_541){
return null;
}
var p=this.protocolDefs[_541];
if(p){
return p;
}
if(typeof objj_getProtocol==="function"){
var _542=objj_getProtocol(_541);
if(_542){
var _543=protocol_getName(_542),_544=protocol_copyMethodDescriptionList(_542,true,true),_545=_518.methodDefsFromMethodList(_544),_546=protocol_copyMethodDescriptionList(_542,true,false),_547=_518.methodDefsFromMethodList(_546),_548=_542.protocols,_549=[];
if(_548){
for(var i=0,size=_548.length;i<size;i++){
_549.push(compiler.getProtocolDef(_548[i].name));
}
}
p=new _502(_543,_549,_545,_547);
this.protocolDefs[_541]=p;
return p;
}
}
return null;
};
_518.prototype.getTypeDef=function(_54a){
if(!_54a){
return null;
}
var t=this.typeDefs[_54a];
if(t){
return t;
}
if(typeof objj_getTypeDef==="function"){
var _54b=objj_getTypeDef(_54a);
if(_54b){
var _54c=typeDef_getName(_54b);
t=new _510(_54c);
this.typeDefs[_54c]=t;
return t;
}
}
return null;
};
_518.methodDefsFromMethodList=function(_54d){
var _54e=_54d.length,_54f=Object.create(null);
for(var i=0;i<_54e;i++){
var _550=_54d[i],_551=method_getName(_550);
_54f[_551]=new _511(_551,_550.types);
}
return _54f;
};
_518.prototype.executable=function(){
if(!this._executable){
this._executable=new _2bd(this.jsBuffer?this.jsBuffer.toString():null,this.dependencies,this.URL,null,this);
}
return this._executable;
};
_518.prototype.IMBuffer=function(){
return this.imBuffer;
};
_518.prototype.JSBuffer=function(){
return this.jsBuffer;
};
_518.prototype.prettifyMessage=function(_552,_553){
var line=this.source.substring(_552.lineStart,_552.lineEnd),_554="\n"+line;
_554+=(new Array(_552.column+1)).join(" ");
_554+=(new Array(Math.min(1,line.length)+1)).join("^")+"\n";
_554+=_553+" line "+_552.line+" in "+this.URL+": "+_552.message;
return _554;
};
_518.prototype.error_message=function(_555,node){
var pos=_2.acorn.getLineInfo(this.source,node.start),_556={message:_555,line:pos.line,column:pos.column,lineStart:pos.lineStart,lineEnd:pos.lineEnd};
return new SyntaxError(this.prettifyMessage(_556,"ERROR"));
};
_518.prototype.pushImport=function(url){
if(!_518.importStack){
_518.importStack=[];
}
_518.importStack.push(url);
};
_518.prototype.popImport=function(){
_518.importStack.pop();
};
function _4dc(_557,node,code){
var _558=_2.acorn.getLineInfo(code,node.start);
_558.message=_557;
return _558;
};
function _51f(node,_559,_55a){
function c(node,st,_55b){
_55a[_55b||node.type](node,st,c);
};
c(node,_559);
};
function _55c(node){
switch(node.type){
case "Literal":
case "Identifier":
return true;
case "ArrayExpression":
for(var i=0;i<node.elements.length;++i){
if(!_55c(node.elements[i])){
return false;
}
}
return true;
case "DictionaryLiteral":
for(var i=0;i<node.keys.length;++i){
if(!_55c(node.keys[i])){
return false;
}
if(!_55c(node.values[i])){
return false;
}
}
return true;
case "ObjectExpression":
for(var i=0;i<node.properties.length;++i){
if(!_55c(node.properties[i].value)){
return false;
}
}
return true;
case "FunctionExpression":
for(var i=0;i<node.params.length;++i){
if(!_55c(node.params[i])){
return false;
}
}
return true;
case "SequenceExpression":
for(var i=0;i<node.expressions.length;++i){
if(!_55c(node.expressions[i])){
return false;
}
}
return true;
case "UnaryExpression":
return _55c(node.argument);
case "BinaryExpression":
return _55c(node.left)&&_55c(node.right);
case "ConditionalExpression":
return _55c(node.test)&&_55c(node.consequent)&&_55c(node.alternate);
case "MemberExpression":
return _55c(node.object)&&(!node.computed||_55c(node.property));
case "Dereference":
return _55c(node.expr);
case "Reference":
return _55c(node.element);
default:
return false;
}
};
function _55d(st,node){
if(!_55c(node)){
throw st.compiler.error_message("Dereference of expression with side effects",node);
}
};
function _55e(c){
return function(node,st,_55f){
st.compiler.jsBuffer.concat("(");
c(node,st,_55f);
st.compiler.jsBuffer.concat(")");
};
};
var _560={"*":3,"/":3,"%":3,"+":4,"-":4,"<<":5,">>":5,">>>":5,"<":6,"<=":6,">":6,">=":6,"in":6,"instanceof":6,"==":7,"!=":7,"===":7,"!==":7,"&":8,"^":9,"|":10,"&&":11,"||":12};
var _561={MemberExpression:0,CallExpression:1,NewExpression:2,FunctionExpression:3,UnaryExpression:4,UpdateExpression:4,BinaryExpression:5,LogicalExpression:6,ConditionalExpression:7,AssignmentExpression:8};
function _562(node,_563,_564){
var _565=node.type,_562=_561[_565]||-1,_566=_561[_563.type]||-1,_567,_568;
return _562<_566||(_562===_566&&_516(_565)&&((_567=_560[node.operator])<(_568=_560[_563.operator])||(_564&&_567===_568)));
};
var _521=_2.acorn.walk.make({ImportStatement:function(node,st,c){
var _569=node.filename.value;
st.compiler.dependencies.push(new _2ec(new CFURL(_569),node.localfilepath));
}});
var _56a=4;
var _56b=Array(_56a+1).join(" ");
var _56c="";
var _520=_2.acorn.walk.make({Program:function(node,st,c){
var _56d=st.compiler,_56e=_56d.generate;
_56c="";
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
if(!_56e){
_56d.jsBuffer.concat(_56d.source.substring(_56d.lastPos,node.end));
}
var _56f=st.maybeWarnings();
if(_56f){
for(var i=0;i<_56f.length;i++){
var _570=_56f[i];
if(_570.checkIfWarning(st)){
_56d.addWarning(_570.message);
}
}
}
},BlockStatement:function(node,st,c){
var _571=st.compiler,_572=_571.generate,_573=st.endOfScopeBody,_574;
if(_573){
delete st.endOfScopeBody;
}
if(_572){
st.indentBlockLevel=typeof st.indentBlockLevel==="undefined"?0:st.indentBlockLevel+1;
_574=_571.jsBuffer;
_574.concat(_56c.substring(_56a));
_574.concat("{\n");
}
for(var i=0;i<node.body.length;++i){
c(node.body[i],st,"Statement");
}
if(_572){
var _575=st.maxReceiverLevel;
if(_573&&_575){
_574.concat(_56c);
_574.concat("var ");
for(var i=0;i<_575;i++){
if(i){
_574.concat(", ");
}
_574.concat("___r");
_574.concat((i+1)+"");
}
_574.concat(";\n");
}
_574.concat(_56c.substring(_56a));
_574.concat("}");
if(st.isDecl||st.indentBlockLevel>0){
_574.concat("\n");
}
st.indentBlockLevel--;
}
},ExpressionStatement:function(node,st,c){
var _576=st.compiler,_577=_576.generate;
if(_577){
_576.jsBuffer.concat(_56c);
}
c(node.expression,st,"Expression");
if(_577){
_576.jsBuffer.concat(";\n");
}
},IfStatement:function(node,st,c){
var _578=st.compiler,_579=_578.generate,_57a;
if(_579){
_57a=_578.jsBuffer;
if(!st.superNodeIsElse){
_57a.concat(_56c);
}else{
delete st.superNodeIsElse;
}
_57a.concat("if (");
}
c(node.test,st,"Expression");
if(_579){
_57a.concat(node.consequent.type==="EmptyStatement"?");\n":")\n");
}
_56c+=_56b;
c(node.consequent,st,"Statement");
_56c=_56c.substring(_56a);
var _57b=node.alternate;
if(_57b){
var _57c=_57b.type!=="IfStatement";
if(_579){
var _57d=_57b.type==="EmptyStatement";
_57a.concat(_56c);
_57a.concat(_57c?_57d?"else;\n":"else\n":"else ");
}
if(_57c){
_56c+=_56b;
}else{
st.superNodeIsElse=true;
}
c(_57b,st,"Statement");
if(_57c){
_56c=_56c.substring(_56a);
}
}
},LabeledStatement:function(node,st,c){
var _57e=st.compiler;
if(_57e.generate){
var _57f=_57e.jsBuffer;
_57f.concat(_56c);
_57f.concat(node.label.name);
_57f.concat(": ");
}
c(node.body,st,"Statement");
},BreakStatement:function(node,st,c){
var _580=st.compiler;
if(_580.generate){
_580.jsBuffer.concat(_56c);
if(node.label){
_580.jsBuffer.concat("break ");
_580.jsBuffer.concat(node.label.name);
_580.jsBuffer.concat(";\n");
}else{
_580.jsBuffer.concat("break;\n");
}
}
},ContinueStatement:function(node,st,c){
var _581=st.compiler;
if(_581.generate){
var _582=_581.jsBuffer;
_582.concat(_56c);
if(node.label){
_582.concat("continue ");
_582.concat(node.label.name);
_582.concat(";\n");
}else{
_582.concat("continue;\n");
}
}
},WithStatement:function(node,st,c){
var _583=st.compiler,_584=_583.generate,_585;
if(_584){
_585=_583.jsBuffer;
_585.concat(_56c);
_585.concat("with(");
}
c(node.object,st,"Expression");
if(_584){
_585.concat(")\n");
}
_56c+=_56b;
c(node.body,st,"Statement");
_56c=_56c.substring(_56a);
},SwitchStatement:function(node,st,c){
var _586=st.compiler,_587=_586.generate,_588;
if(_587){
_588=_586.jsBuffer;
_588.concat(_56c);
_588.concat("switch(");
}
c(node.discriminant,st,"Expression");
if(_587){
_588.concat(") {\n");
}
for(var i=0;i<node.cases.length;++i){
var cs=node.cases[i];
if(cs.test){
if(_587){
_588.concat(_56c);
_588.concat("case ");
}
c(cs.test,st,"Expression");
if(_587){
_588.concat(":\n");
}
}else{
if(_587){
_588.concat("default:\n");
}
}
_56c+=_56b;
for(var j=0;j<cs.consequent.length;++j){
c(cs.consequent[j],st,"Statement");
}
_56c=_56c.substring(_56a);
}
if(_587){
_588.concat(_56c);
_588.concat("}\n");
}
},ReturnStatement:function(node,st,c){
var _589=st.compiler,_58a=_589.generate,_58b;
if(_58a){
_58b=_589.jsBuffer;
_58b.concat(_56c);
_58b.concat("return");
}
if(node.argument){
if(_58a){
_58b.concat(" ");
}
c(node.argument,st,"Expression");
}
if(_58a){
_58b.concat(";\n");
}
},ThrowStatement:function(node,st,c){
var _58c=st.compiler,_58d=_58c.generate,_58e;
if(_58d){
_58e=_58c.jsBuffer;
_58e.concat(_56c);
_58e.concat("throw ");
}
c(node.argument,st,"Expression");
if(_58d){
_58e.concat(";\n");
}
},TryStatement:function(node,st,c){
var _58f=st.compiler,_590=_58f.generate,_591;
if(_590){
_591=_58f.jsBuffer;
_591.concat(_56c);
_591.concat("try");
}
_56c+=_56b;
c(node.block,st,"Statement");
_56c=_56c.substring(_56a);
for(var i=0;i<node.handlers.length;++i){
var _592=node.handlers[i],_593=new _4d2(st),_594=_592.param,name=_594.name;
_593.vars[name]={type:"catch clause",node:_594};
if(_590){
_591.concat(_56c);
_591.concat("catch(");
_591.concat(name);
_591.concat(") ");
}
_56c+=_56b;
_593.endOfScopeBody=true;
c(_592.body,_593,"ScopeBody");
_56c=_56c.substring(_56a);
_593.copyAddedSelfToIvarsToParent();
}
if(node.finalizer){
if(_590){
_591.concat(_56c);
_591.concat("finally ");
}
_56c+=_56b;
c(node.finalizer,st,"Statement");
_56c=_56c.substring(_56a);
}
},WhileStatement:function(node,st,c){
var _595=st.compiler,_596=_595.generate,body=node.body,_597;
if(_596){
_597=_595.jsBuffer;
_597.concat(_56c);
_597.concat("while (");
}
c(node.test,st,"Expression");
if(_596){
_597.concat(body.type==="EmptyStatement"?");\n":")\n");
}
_56c+=_56b;
c(body,st,"Statement");
_56c=_56c.substring(_56a);
},DoWhileStatement:function(node,st,c){
var _598=st.compiler,_599=_598.generate,_59a;
if(_599){
_59a=_598.jsBuffer;
_59a.concat(_56c);
_59a.concat("do\n");
}
_56c+=_56b;
c(node.body,st,"Statement");
_56c=_56c.substring(_56a);
if(_599){
_59a.concat(_56c);
_59a.concat("while (");
}
c(node.test,st,"Expression");
if(_599){
_59a.concat(");\n");
}
},ForStatement:function(node,st,c){
var _59b=st.compiler,_59c=_59b.generate,body=node.body,_59d;
if(_59c){
_59d=_59b.jsBuffer;
_59d.concat(_56c);
_59d.concat("for (");
}
if(node.init){
c(node.init,st,"ForInit");
}
if(_59c){
_59d.concat("; ");
}
if(node.test){
c(node.test,st,"Expression");
}
if(_59c){
_59d.concat("; ");
}
if(node.update){
c(node.update,st,"Expression");
}
if(_59c){
_59d.concat(body.type==="EmptyStatement"?");\n":")\n");
}
_56c+=_56b;
c(body,st,"Statement");
_56c=_56c.substring(_56a);
},ForInStatement:function(node,st,c){
var _59e=st.compiler,_59f=_59e.generate,body=node.body,_5a0;
if(_59f){
_5a0=_59e.jsBuffer;
_5a0.concat(_56c);
_5a0.concat("for (");
}
c(node.left,st,"ForInit");
if(_59f){
_5a0.concat(" in ");
}
c(node.right,st,"Expression");
if(_59f){
_5a0.concat(body.type==="EmptyStatement"?");\n":")\n");
}
_56c+=_56b;
c(body,st,"Statement");
_56c=_56c.substring(_56a);
},ForInit:function(node,st,c){
var _5a1=st.compiler,_5a2=_5a1.generate;
if(node.type==="VariableDeclaration"){
st.isFor=true;
c(node,st);
delete st.isFor;
}else{
c(node,st,"Expression");
}
},DebuggerStatement:function(node,st,c){
var _5a3=st.compiler;
if(_5a3.generate){
var _5a4=_5a3.jsBuffer;
_5a4.concat(_56c);
_5a4.concat("debugger;\n");
}
},Function:function(node,st,c){
var _5a5=st.compiler,_5a6=_5a5.generate,_5a7=_5a5.jsBuffer;
inner=new _4d2(st),decl=node.type=="FunctionDeclaration";
inner.isDecl=decl;
for(var i=0;i<node.params.length;++i){
inner.vars[node.params[i].name]={type:"argument",node:node.params[i]};
}
if(node.id){
(decl?st:inner).vars[node.id.name]={type:decl?"function":"function name",node:node.id};
if(_5a6){
_5a7.concat(node.id.name);
_5a7.concat(" = ");
}else{
_5a7.concat(_5a5.source.substring(_5a5.lastPos,node.start));
_5a7.concat(node.id.name);
_5a7.concat(" = function");
_5a5.lastPos=node.id.end;
}
}
if(_5a6){
_5a7.concat("function(");
for(var i=0;i<node.params.length;++i){
if(i){
_5a7.concat(", ");
}
_5a7.concat(node.params[i].name);
}
_5a7.concat(")\n");
}
_56c+=_56b;
inner.endOfScopeBody=true;
c(node.body,inner,"ScopeBody");
_56c=_56c.substring(_56a);
inner.copyAddedSelfToIvarsToParent();
},VariableDeclaration:function(node,st,c){
var _5a8=st.compiler,_5a9=_5a8.generate,_5aa;
if(_5a9){
_5aa=_5a8.jsBuffer;
if(!st.isFor){
_5aa.concat(_56c);
}
_5aa.concat("var ");
}
for(var i=0;i<node.declarations.length;++i){
var decl=node.declarations[i],_5ab=decl.id.name;
if(i){
if(_5a9){
if(st.isFor){
_5aa.concat(", ");
}else{
_5aa.concat(",\n");
_5aa.concat(_56c);
_5aa.concat("    ");
}
}
}
st.vars[_5ab]={type:"var",node:decl.id};
if(_5a9){
_5aa.concat(_5ab);
}
if(decl.init){
if(_5a9){
_5aa.concat(" = ");
}
c(decl.init,st,"Expression");
}
if(st.addedSelfToIvars){
var _5ac=st.addedSelfToIvars[_5ab];
if(_5ac){
var _5aa=st.compiler.jsBuffer.atoms;
for(var i=0;i<_5ac.length;i++){
var dict=_5ac[i];
_5aa[dict.index]="";
_5a8.addWarning(_4dc("Local declaration of '"+_5ab+"' hides instance variable",dict.node,_5a8.source));
}
st.addedSelfToIvars[_5ab]=[];
}
}
}
if(_5a9&&!st.isFor){
_5a8.jsBuffer.concat(";\n");
}
},ThisExpression:function(node,st,c){
var _5ad=st.compiler;
if(_5ad.generate){
_5ad.jsBuffer.concat("this");
}
},ArrayExpression:function(node,st,c){
var _5ae=st.compiler,_5af=_5ae.generate;
if(_5af){
_5ae.jsBuffer.concat("[");
}
for(var i=0;i<node.elements.length;++i){
var elt=node.elements[i];
if(i!==0){
if(_5af){
_5ae.jsBuffer.concat(", ");
}
}
if(elt){
c(elt,st,"Expression");
}
}
if(_5af){
_5ae.jsBuffer.concat("]");
}
},ObjectExpression:function(node,st,c){
var _5b0=st.compiler,_5b1=_5b0.generate;
if(_5b1){
_5b0.jsBuffer.concat("{");
}
for(var i=0;i<node.properties.length;++i){
var prop=node.properties[i];
if(_5b1){
if(i){
_5b0.jsBuffer.concat(", ");
}
st.isPropertyKey=true;
c(prop.key,st,"Expression");
delete st.isPropertyKey;
_5b0.jsBuffer.concat(": ");
}else{
if(prop.key.raw&&prop.key.raw.charAt(0)==="@"){
_5b0.jsBuffer.concat(_5b0.source.substring(_5b0.lastPos,prop.key.start));
_5b0.lastPos=prop.key.start+1;
}
}
c(prop.value,st,"Expression");
}
if(_5b1){
_5b0.jsBuffer.concat("}");
}
},SequenceExpression:function(node,st,c){
var _5b2=st.compiler,_5b3=_5b2.generate;
if(_5b3){
_5b2.jsBuffer.concat("(");
}
for(var i=0;i<node.expressions.length;++i){
if(_5b3&&i!==0){
_5b2.jsBuffer.concat(", ");
}
c(node.expressions[i],st,"Expression");
}
if(_5b3){
_5b2.jsBuffer.concat(")");
}
},UnaryExpression:function(node,st,c){
var _5b4=st.compiler,_5b5=_5b4.generate,_5b6=node.argument;
if(_5b5){
if(node.prefix){
_5b4.jsBuffer.concat(node.operator);
if(_515(node.operator)){
_5b4.jsBuffer.concat(" ");
}
(_562(node,_5b6)?_55e(c):c)(_5b6,st,"Expression");
}else{
(_562(node,_5b6)?_55e(c):c)(_5b6,st,"Expression");
_5b4.jsBuffer.concat(node.operator);
}
}else{
c(_5b6,st,"Expression");
}
},UpdateExpression:function(node,st,c){
var _5b7=st.compiler,_5b8=_5b7.generate;
if(node.argument.type==="Dereference"){
_55d(st,node.argument);
if(!_5b8){
_5b7.jsBuffer.concat(_5b7.source.substring(_5b7.lastPos,node.start));
}
_5b7.jsBuffer.concat((node.prefix?"":"(")+"(");
if(!_5b8){
_5b7.lastPos=node.argument.expr.start;
}
c(node.argument.expr,st,"Expression");
if(!_5b8){
_5b7.jsBuffer.concat(_5b7.source.substring(_5b7.lastPos,node.argument.expr.end));
}
_5b7.jsBuffer.concat(")(");
if(!_5b8){
_5b7.lastPos=node.argument.start;
}
c(node.argument,st,"Expression");
if(!_5b8){
_5b7.jsBuffer.concat(_5b7.source.substring(_5b7.lastPos,node.argument.end));
}
_5b7.jsBuffer.concat(" "+node.operator.substring(0,1)+" 1)"+(node.prefix?"":node.operator=="++"?" - 1)":" + 1)"));
if(!_5b8){
_5b7.lastPos=node.end;
}
return;
}
if(node.prefix){
if(_5b8){
_5b7.jsBuffer.concat(node.operator);
if(_515(node.operator)){
_5b7.jsBuffer.concat(" ");
}
}
(_5b8&&_562(node,node.argument)?_55e(c):c)(node.argument,st,"Expression");
}else{
(_5b8&&_562(node,node.argument)?_55e(c):c)(node.argument,st,"Expression");
if(_5b8){
_5b7.jsBuffer.concat(node.operator);
}
}
},BinaryExpression:function(node,st,c){
var _5b9=st.compiler,_5ba=_5b9.generate,_5bb=_517(node.operator);
(_5ba&&_562(node,node.left)?_55e(c):c)(node.left,st,"Expression");
if(_5ba){
var _5bc=_5b9.jsBuffer;
_5bc.concat(" ");
_5bc.concat(node.operator);
_5bc.concat(" ");
}
(_5ba&&_562(node,node.right,true)?_55e(c):c)(node.right,st,"Expression");
},LogicalExpression:function(node,st,c){
var _5bd=st.compiler,_5be=_5bd.generate;
(_5be&&_562(node,node.left)?_55e(c):c)(node.left,st,"Expression");
if(_5be){
var _5bf=_5bd.jsBuffer;
_5bf.concat(" ");
_5bf.concat(node.operator);
_5bf.concat(" ");
}
(_5be&&_562(node,node.right,true)?_55e(c):c)(node.right,st,"Expression");
},AssignmentExpression:function(node,st,c){
var _5c0=st.compiler,_5c1=_5c0.generate,_5c2=st.assignment,_5c3=_5c0.jsBuffer;
if(node.left.type==="Dereference"){
_55d(st,node.left);
if(!_5c1){
_5c3.concat(_5c0.source.substring(_5c0.lastPos,node.start));
}
_5c3.concat("(");
if(!_5c1){
_5c0.lastPos=node.left.expr.start;
}
c(node.left.expr,st,"Expression");
if(!_5c1){
_5c3.concat(_5c0.source.substring(_5c0.lastPos,node.left.expr.end));
}
_5c3.concat(")(");
if(node.operator!=="="){
if(!_5c1){
_5c0.lastPos=node.left.start;
}
c(node.left,st,"Expression");
if(!_5c1){
_5c3.concat(_5c0.source.substring(_5c0.lastPos,node.left.end));
}
_5c3.concat(" "+node.operator.substring(0,1)+" ");
}
if(!_5c1){
_5c0.lastPos=node.right.start;
}
c(node.right,st,"Expression");
if(!_5c1){
_5c3.concat(_5c0.source.substring(_5c0.lastPos,node.right.end));
}
_5c3.concat(")");
if(!_5c1){
_5c0.lastPos=node.end;
}
return;
}
var _5c2=st.assignment,_5c4=node.left;
st.assignment=true;
if(_5c4.type==="Identifier"&&_5c4.name==="self"){
var lVar=st.getLvar("self",true);
if(lVar){
var _5c5=lVar.scope;
if(_5c5){
_5c5.assignmentToSelf=true;
}
}
}
(_5c1&&_562(node,_5c4)?_55e(c):c)(_5c4,st,"Expression");
if(_5c1){
_5c3.concat(" ");
_5c3.concat(node.operator);
_5c3.concat(" ");
}
st.assignment=_5c2;
(_5c1&&_562(node,node.right,true)?_55e(c):c)(node.right,st,"Expression");
if(st.isRootScope()&&_5c4.type==="Identifier"&&!st.getLvar(_5c4.name)){
st.vars[_5c4.name]={type:"global",node:_5c4};
}
},ConditionalExpression:function(node,st,c){
var _5c6=st.compiler,_5c7=_5c6.generate;
(_5c7&&_562(node,node.test)?_55e(c):c)(node.test,st,"Expression");
if(_5c7){
_5c6.jsBuffer.concat(" ? ");
}
c(node.consequent,st,"Expression");
if(_5c7){
_5c6.jsBuffer.concat(" : ");
}
c(node.alternate,st,"Expression");
},NewExpression:function(node,st,c){
var _5c8=st.compiler,_5c9=_5c8.generate;
if(_5c9){
_5c8.jsBuffer.concat("new ");
}
(_5c9&&_562(node,node.callee)?_55e(c):c)(node.callee,st,"Expression");
if(_5c9){
_5c8.jsBuffer.concat("(");
}
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
if(_5c9&&i){
_5c8.jsBuffer.concat(", ");
}
c(node.arguments[i],st,"Expression");
}
}
if(_5c9){
_5c8.jsBuffer.concat(")");
}
},CallExpression:function(node,st,c){
var _5ca=st.compiler,_5cb=_5ca.generate,_5cc=node.callee;
if(_5cc.type==="Identifier"&&_5cc.name==="eval"){
var _5cd=st.getLvar("self",true);
if(_5cd){
var _5ce=_5cd.scope;
if(_5ce){
_5ce.assignmentToSelf=true;
}
}
}
(_5cb&&_562(node,_5cc)?_55e(c):c)(_5cc,st,"Expression");
if(_5cb){
_5ca.jsBuffer.concat("(");
}
if(node.arguments){
for(var i=0;i<node.arguments.length;++i){
if(_5cb&&i){
_5ca.jsBuffer.concat(", ");
}
c(node.arguments[i],st,"Expression");
}
}
if(_5cb){
_5ca.jsBuffer.concat(")");
}
},MemberExpression:function(node,st,c){
var _5cf=st.compiler,_5d0=_5cf.generate,_5d1=node.computed;
(_5d0&&_562(node,node.object)?_55e(c):c)(node.object,st,"Expression");
if(_5d0){
if(_5d1){
_5cf.jsBuffer.concat("[");
}else{
_5cf.jsBuffer.concat(".");
}
}
st.secondMemberExpression=!_5d1;
(_5d0&&!_5d1&&_562(node,node.property)?_55e(c):c)(node.property,st,"Expression");
st.secondMemberExpression=false;
if(_5d0&&_5d1){
_5cf.jsBuffer.concat("]");
}
},Identifier:function(node,st,c){
var _5d2=st.compiler,_5d3=_5d2.generate,_5d4=node.name;
if(st.currentMethodType()==="-"&&!st.secondMemberExpression&&!st.isPropertyKey){
var lvar=st.getLvar(_5d4,true),ivar=_5d2.getIvarForClass(_5d4,st);
if(ivar){
if(lvar){
_5d2.addWarning(_4dc("Local declaration of '"+_5d4+"' hides instance variable",node,_5d2.source));
}else{
var _5d5=node.start;
if(!_5d3){
do{
_5d2.jsBuffer.concat(_5d2.source.substring(_5d2.lastPos,_5d5));
_5d2.lastPos=_5d5;
}while(_5d2.source.substr(_5d5++,1)==="(");
}
((st.addedSelfToIvars||(st.addedSelfToIvars=Object.create(null)))[_5d4]||(st.addedSelfToIvars[_5d4]=[])).push({node:node,index:_5d2.jsBuffer.atoms.length});
_5d2.jsBuffer.concat("self.");
}
}else{
if(!_514(_5d4)){
var _5d6,_5d7=typeof _1[_5d4]!=="undefined"||typeof window[_5d4]!=="undefined"||_5d2.getClassDef(_5d4),_5d8=st.getLvar(_5d4);
if(_5d7&&(!_5d8||_5d8.type!=="class")){
}else{
if(!_5d8){
if(st.assignment){
_5d6=new _4da("Creating global variable inside function or method '"+_5d4+"'",node,_5d2.source);
st.vars[_5d4]={type:"remove global warning",node:node};
}else{
_5d6=new _4da("Using unknown class or uninitialized global variable '"+_5d4+"'",node,_5d2.source);
}
}
}
if(_5d6){
st.addMaybeWarning(_5d6);
}
}
}
}
if(_5d3){
_5d2.jsBuffer.concat(_5d4);
}
},Literal:function(node,st,c){
var _5d9=st.compiler,_5da=_5d9.generate;
if(_5da){
if(node.raw&&node.raw.charAt(0)==="@"){
_5d9.jsBuffer.concat(node.raw.substring(1));
}else{
_5d9.jsBuffer.concat(node.raw);
}
}else{
if(node.raw.charAt(0)==="@"){
_5d9.jsBuffer.concat(_5d9.source.substring(_5d9.lastPos,node.start));
_5d9.lastPos=node.start+1;
}
}
},ArrayLiteral:function(node,st,c){
var _5db=st.compiler,_5dc=_5db.generate;
if(!_5dc){
_5db.jsBuffer.concat(_5db.source.substring(_5db.lastPos,node.start));
_5db.lastPos=node.start;
}
if(!_5dc){
buffer.concat(" ");
}
if(!node.elements.length){
_5db.jsBuffer.concat("objj_msgSend(objj_msgSend(CPArray, \"alloc\"), \"init\")");
}else{
_5db.jsBuffer.concat("objj_msgSend(objj_msgSend(CPArray, \"alloc\"), \"initWithObjects:count:\", [");
for(var i=0;i<node.elements.length;i++){
var elt=node.elements[i];
if(i){
_5db.jsBuffer.concat(", ");
}
if(!_5dc){
_5db.lastPos=elt.start;
}
c(elt,st,"Expression");
if(!_5dc){
_5db.jsBuffer.concat(_5db.source.substring(_5db.lastPos,elt.end));
}
}
_5db.jsBuffer.concat("], "+node.elements.length+")");
}
if(!_5dc){
_5db.lastPos=node.end;
}
},DictionaryLiteral:function(node,st,c){
var _5dd=st.compiler,_5de=_5dd.generate;
if(!_5de){
_5dd.jsBuffer.concat(_5dd.source.substring(_5dd.lastPos,node.start));
_5dd.lastPos=node.start;
}
if(!_5de){
buffer.concat(" ");
}
if(!node.keys.length){
_5dd.jsBuffer.concat("objj_msgSend(objj_msgSend(CPDictionary, \"alloc\"), \"init\")");
}else{
_5dd.jsBuffer.concat("objj_msgSend(objj_msgSend(CPDictionary, \"alloc\"), \"initWithObjectsAndKeys:\"");
for(var i=0;i<node.keys.length;i++){
var key=node.keys[i],_5df=node.values[i];
_5dd.jsBuffer.concat(", ");
if(!_5de){
_5dd.lastPos=_5df.start;
}
c(_5df,st,"Expression");
if(!_5de){
_5dd.jsBuffer.concat(_5dd.source.substring(_5dd.lastPos,_5df.end));
}
_5dd.jsBuffer.concat(", ");
if(!_5de){
_5dd.lastPos=key.start;
}
c(key,st,"Expression");
if(!_5de){
_5dd.jsBuffer.concat(_5dd.source.substring(_5dd.lastPos,key.end));
}
}
_5dd.jsBuffer.concat(")");
}
if(!_5de){
_5dd.lastPos=node.end;
}
},ImportStatement:function(node,st,c){
var _5e0=st.compiler,_5e1=_5e0.generate,_5e2=_5e0.jsBuffer;
if(!_5e1){
_5e2.concat(_5e0.source.substring(_5e0.lastPos,node.start));
}
_5e2.concat("objj_executeFile(\"");
_5e2.concat(node.filename.value);
_5e2.concat(node.localfilepath?"\", YES);":"\", NO);");
if(!_5e1){
_5e0.lastPos=node.end;
}
},ClassDeclarationStatement:function(node,st,c){
var _5e3=st.compiler,_5e4=_5e3.generate,_5e5=_5e3.jsBuffer,_5e6=node.classname.name,_5e7=_5e3.getClassDef(_5e6),_5e8=new _4d2(st),_5e9=node.type==="InterfaceDeclarationStatement",_5ea=node.protocols;
_5e3.imBuffer=new _2ae();
_5e3.cmBuffer=new _2ae();
_5e3.classBodyBuffer=new _2ae();
if(_5e3.getTypeDef(_5e6)){
throw _5e3.error_message(_5e6+" is already declared as a type",node.classname);
}
if(!_5e4){
_5e5.concat(_5e3.source.substring(_5e3.lastPos,node.start));
}
if(node.superclassname){
if(_5e7&&_5e7.ivars){
throw _5e3.error_message("Duplicate class "+_5e6,node.classname);
}
if(_5e9&&_5e7&&_5e7.instanceMethods&&_5e7.classMethods){
throw _5e3.error_message("Duplicate interface definition for class "+_5e6,node.classname);
}
var _5eb=_5e3.getClassDef(node.superclassname.name);
if(!_5eb){
var _5ec="Can't find superclass "+node.superclassname.name;
for(var i=_518.importStack.length;--i>=0;){
_5ec+="\n"+Array((_518.importStack.length-i)*2+1).join(" ")+"Imported by: "+_518.importStack[i];
}
throw _5e3.error_message(_5ec,node.superclassname);
}
_5e7=new _4df(!_5e9,_5e6,_5eb,Object.create(null));
_5e5.concat("{var the_class = objj_allocateClassPair("+node.superclassname.name+", \""+_5e6+"\"),\nmeta_class = the_class.isa;");
}else{
if(node.categoryname){
_5e7=_5e3.getClassDef(_5e6);
if(!_5e7){
throw _5e3.error_message("Class "+_5e6+" not found ",node.classname);
}
_5e5.concat("{\nvar the_class = objj_getClass(\""+_5e6+"\")\n");
_5e5.concat("if(!the_class) throw new SyntaxError(\"*** Could not find definition for class \\\""+_5e6+"\\\"\");\n");
_5e5.concat("var meta_class = the_class.isa;");
}else{
_5e7=new _4df(!_5e9,_5e6,null,Object.create(null));
_5e5.concat("{var the_class = objj_allocateClassPair(Nil, \""+_5e6+"\"),\nmeta_class = the_class.isa;");
}
}
if(_5ea){
for(var i=0,size=_5ea.length;i<size;i++){
_5e5.concat("\nvar aProtocol = objj_getProtocol(\""+_5ea[i].name+"\");");
_5e5.concat("\nif (!aProtocol) throw new SyntaxError(\"*** Could not find definition for protocol \\\""+_5ea[i].name+"\\\"\");");
_5e5.concat("\nclass_addProtocol(the_class, aProtocol);");
}
}
_5e8.classDef=_5e7;
_5e3.currentSuperClass="objj_getClass(\""+_5e6+"\").super_class";
_5e3.currentSuperMetaClass="objj_getMetaClass(\""+_5e6+"\").super_class";
var _5ed=true,_5ee=_5e7.ivars,_5ef=[],_5f0=false;
if(node.ivardeclarations){
for(var i=0;i<node.ivardeclarations.length;++i){
var _5f1=node.ivardeclarations[i],_5f2=_5f1.ivartype?_5f1.ivartype.name:null,_5f3=_5f1.ivartype?_5f1.ivartype.typeisclass:false,_5f4=_5f1.id.name,ivar={"type":_5f2,"name":_5f4},_5f5=_5f1.accessors;
if(_5ee[_5f4]){
throw _5e3.error_message("Instance variable '"+_5f4+"' is already declared for class "+_5e6,_5f1.id);
}
var _5f6=!_5f3||typeof _1[_5f2]!=="undefined"||typeof window[_5f2]!=="undefined"||_5e3.getClassDef(_5f2)||_5e3.getTypeDef(_5f2)||_5f2==_5e7.name;
if(!_5f6){
_5e3.addWarning(_4dc("Unknown type '"+_5f2+"' for ivar '"+_5f4+"'",_5f1.id,_5e3.source));
}
if(_5ed){
_5ed=false;
_5e5.concat("class_addIvars(the_class, [");
}else{
_5e5.concat(", ");
}
if(_5e3.flags&_518.Flags.IncludeTypeSignatures){
_5e5.concat("new objj_ivar(\""+_5f4+"\", \""+_5f2+"\")");
}else{
_5e5.concat("new objj_ivar(\""+_5f4+"\")");
}
if(_5f1.outlet){
ivar.outlet=true;
}
_5ef.push(ivar);
if(!_5e8.ivars){
_5e8.ivars=Object.create(null);
}
_5e8.ivars[_5f4]={type:"ivar",name:_5f4,node:_5f1.id,ivar:ivar};
if(_5f5){
var _5f7=(_5f5.property&&_5f5.property.name)||_5f4,_5f8=(_5f5.getter&&_5f5.getter.name)||_5f7;
_5e7.addInstanceMethod(new _511(_5f8,[_5f2]));
if(!_5f5.readonly){
var _5f9=_5f5.setter?_5f5.setter.name:null;
if(!_5f9){
var _5fa=_5f7.charAt(0)=="_"?1:0;
_5f9=(_5fa?"_":"")+"set"+_5f7.substr(_5fa,1).toUpperCase()+_5f7.substring(_5fa+1)+":";
}
_5e7.addInstanceMethod(new _511(_5f9,["void",_5f2]));
}
_5f0=true;
}
}
}
if(!_5ed){
_5e5.concat("]);");
}
if(!_5e9&&_5f0){
var _5fb=new _2ae();
_5fb.concat(_5e3.source.substring(node.start,node.endOfIvars).replace(/<.*>/g,""));
_5fb.concat("\n");
for(var i=0;i<node.ivardeclarations.length;++i){
var _5f1=node.ivardeclarations[i],_5f2=_5f1.ivartype?_5f1.ivartype.name:null,_5f4=_5f1.id.name,_5f5=_5f1.accessors;
if(!_5f5){
continue;
}
var _5f7=(_5f5.property&&_5f5.property.name)||_5f4,_5f8=(_5f5.getter&&_5f5.getter.name)||_5f7,_5fc="- ("+(_5f2?_5f2:"id")+")"+_5f8+"\n{\nreturn "+_5f4+";\n}\n";
_5fb.concat(_5fc);
if(_5f5.readonly){
continue;
}
var _5f9=_5f5.setter?_5f5.setter.name:null;
if(!_5f9){
var _5fa=_5f7.charAt(0)=="_"?1:0;
_5f9=(_5fa?"_":"")+"set"+_5f7.substr(_5fa,1).toUpperCase()+_5f7.substring(_5fa+1)+":";
}
var _5fd="- (void)"+_5f9+"("+(_5f2?_5f2:"id")+")newValue\n{\n";
if(_5f5.copy){
_5fd+="if ("+_5f4+" !== newValue)\n"+_5f4+" = [newValue copy];\n}\n";
}else{
_5fd+=_5f4+" = newValue;\n}\n";
}
_5fb.concat(_5fd);
}
_5fb.concat("\n@end");
var b=_5fb.toString().replace(/@accessors(\(.*\))?/g,"");
var _5fe=_518.compileToIMBuffer(b,"Accessors",_5e3.flags,_5e3.classDefs,_5e3.protocolDefs,_5e3.typeDefs);
_5e3.imBuffer.concat(_5fe);
}
for(var _5ff=_5ef.length,i=0;i<_5ff;i++){
var ivar=_5ef[i],_5f4=ivar.name;
_5ee[_5f4]=ivar;
}
_5e3.classDefs[_5e6]=_5e7;
var _600=node.body,_601=_600.length;
if(_601>0){
if(!_5e4){
_5e3.lastPos=_600[0].start;
}
for(var i=0;i<_601;++i){
var body=_600[i];
c(body,_5e8,"Statement");
}
if(!_5e4){
_5e5.concat(_5e3.source.substring(_5e3.lastPos,body.end));
}
}
if(!_5e9&&!node.categoryname){
_5e5.concat("objj_registerClassPair(the_class);\n");
}
if(_5e3.imBuffer.isEmpty()){
_5e5.concat("class_addMethods(the_class, [");
_5e5.atoms.push.apply(_5e5.atoms,_5e3.imBuffer.atoms);
_5e5.concat("]);\n");
}
if(_5e3.cmBuffer.isEmpty()){
_5e5.concat("class_addMethods(meta_class, [");
_5e5.atoms.push.apply(_5e5.atoms,_5e3.cmBuffer.atoms);
_5e5.concat("]);\n");
}
_5e5.concat("}");
_5e3.jsBuffer=_5e5;
if(!_5e4){
_5e3.lastPos=node.end;
}
if(_5ea){
var _602=[];
for(var i=0,size=_5ea.length;i<size;i++){
var _603=_5ea[i],_604=_5e3.getProtocolDef(_603.name);
if(!_604){
throw _5e3.error_message("Cannot find protocol declaration for '"+_603.name+"'",_603);
}
_602.push(_604);
}
var _605=_5e7.listOfNotImplementedMethodsForProtocols(_602);
if(_605&&_605.length>0){
for(var i=0,size=_605.length;i<size;i++){
var _606=_605[i],_607=_606.methodDef,_604=_606.protocolDef;
_5e3.addWarning(_4dc("Method '"+_607.name+"' in protocol '"+_604.name+"' is not implemented",node.classname,_5e3.source));
}
}
}
},ProtocolDeclarationStatement:function(node,st,c){
var _608=st.compiler,_609=_608.generate,_60a=_608.jsBuffer,_60b=node.protocolname.name,_60c=_608.getProtocolDef(_60b),_60d=node.protocols,_60e=new _4d2(st),_60f=[];
if(_60c){
throw _608.error_message("Duplicate protocol "+_60b,node.protocolname);
}
_608.imBuffer=new _2ae();
_608.cmBuffer=new _2ae();
if(!_609){
_60a.concat(_608.source.substring(_608.lastPos,node.start));
}
_60a.concat("{var the_protocol = objj_allocateProtocol(\""+_60b+"\");");
if(_60d){
for(var i=0,size=_60d.length;i<size;i++){
var _610=_60d[i],_611=_610.name;
inheritProtocolDef=_608.getProtocolDef(_611);
if(!inheritProtocolDef){
throw _608.error_message("Can't find protocol "+_611,_610);
}
_60a.concat("\nvar aProtocol = objj_getProtocol(\""+_611+"\");");
_60a.concat("\nif (!aProtocol) throw new SyntaxError(\"*** Could not find definition for protocol \\\""+_60b+"\\\"\");");
_60a.concat("\nprotocol_addProtocol(the_protocol, aProtocol);");
_60f.push(inheritProtocolDef);
}
}
_60c=new _502(_60b,_60f);
_608.protocolDefs[_60b]=_60c;
_60e.protocolDef=_60c;
var _612=node.required;
if(_612){
var _613=_612.length;
if(_613>0){
for(var i=0;i<_613;++i){
var _614=_612[i];
if(!_609){
_608.lastPos=_614.start;
}
c(_614,_60e,"Statement");
}
if(!_609){
_60a.concat(_608.source.substring(_608.lastPos,_614.end));
}
}
}
_60a.concat("\nobjj_registerProtocol(the_protocol);\n");
if(_608.imBuffer.isEmpty()){
_60a.concat("protocol_addMethodDescriptions(the_protocol, [");
_60a.atoms.push.apply(_60a.atoms,_608.imBuffer.atoms);
_60a.concat("], true, true);\n");
}
if(_608.cmBuffer.isEmpty()){
_60a.concat("protocol_addMethodDescriptions(the_protocol, [");
_60a.atoms.push.apply(_60a.atoms,_608.cmBuffer.atoms);
_60a.concat("], true, false);\n");
}
_60a.concat("}");
_608.jsBuffer=_60a;
if(!_609){
_608.lastPos=node.end;
}
},MethodDeclarationStatement:function(node,st,c){
var _615=st.compiler,_616=_615.generate,_617=_615.jsBuffer,_618=new _4d2(st),_619=node.methodtype==="-";
selectors=node.selectors,nodeArguments=node.arguments,returnType=node.returntype,types=[returnType?returnType.name:(node.action?"void":"id")],returnTypeProtocols=returnType?returnType.protocols:null;
selector=selectors[0].name;
if(returnTypeProtocols){
for(var i=0,size=returnTypeProtocols.length;i<size;i++){
var _61a=returnTypeProtocols[i];
if(!_615.getProtocolDef(_61a.name)){
_615.addWarning(_4dc("Cannot find protocol declaration for '"+_61a.name+"'",_61a,_615.source));
}
}
}
if(!_616){
_617.concat(_615.source.substring(_615.lastPos,node.start));
}
_615.jsBuffer=_619?_615.imBuffer:_615.cmBuffer;
for(var i=0;i<nodeArguments.length;i++){
var _61b=nodeArguments[i],_61c=_61b.type,_61d=_61c?_61c.name:"id",_61e=_61c?_61c.protocols:null;
types.push(_61c?_61c.name:"id");
if(_61e){
for(var j=0,size=_61e.length;j<size;j++){
var _61f=_61e[j];
if(!_615.getProtocolDef(_61f.name)){
_615.addWarning(_4dc("Cannot find protocol declaration for '"+_61f.name+"'",_61f,_615.source));
}
}
}
if(i===0){
selector+=":";
}else{
selector+=(selectors[i]?selectors[i].name:"")+":";
}
}
if(_615.jsBuffer.isEmpty()){
_615.jsBuffer.concat(", ");
}
_615.jsBuffer.concat("new objj_method(sel_getUid(\"");
_615.jsBuffer.concat(selector);
_615.jsBuffer.concat("\"), ");
if(node.body){
_615.jsBuffer.concat("function");
if(_615.flags&_518.Flags.IncludeDebugSymbols){
_615.jsBuffer.concat(" $"+st.currentClassName()+"__"+selector.replace(/:/g,"_"));
}
_615.jsBuffer.concat("(self, _cmd");
_618.methodType=node.methodtype;
_618.vars["self"]={type:"method base",scope:_618};
_618.vars["_cmd"]={type:"method base",scope:_618};
if(nodeArguments){
for(var i=0;i<nodeArguments.length;i++){
var _61b=nodeArguments[i],_620=_61b.identifier.name;
_615.jsBuffer.concat(", ");
_615.jsBuffer.concat(_620);
_618.vars[_620]={type:"method argument",node:_61b};
}
}
_615.jsBuffer.concat(")\n");
if(!_616){
_615.lastPos=node.startOfBody;
}
_56c+=_56b;
_618.endOfScopeBody=true;
c(node.body,_618,"Statement");
_56c=_56c.substring(_56a);
if(!_616){
_615.jsBuffer.concat(_615.source.substring(_615.lastPos,node.body.end));
}
_615.jsBuffer.concat("\n");
}else{
_615.jsBuffer.concat("Nil\n");
}
if(_615.flags&_518.Flags.IncludeDebugSymbols){
_615.jsBuffer.concat(","+JSON.stringify(types));
}
_615.jsBuffer.concat(")");
_615.jsBuffer=_617;
if(!_616){
_615.lastPos=node.end;
}
var def=st.classDef,_621;
if(def){
_621=_619?def.getInstanceMethod(selector):def.getClassMethod(selector);
}else{
def=st.protocolDef;
}
if(!def){
throw "InternalError: MethodDeclaration without ClassDeclaration or ProtocolDeclaration at line: "+_2.acorn.getLineInfo(_615.source,node.start).line;
}
if(!_621){
var _622=def.protocols;
if(_622){
for(var i=0,size=_622.length;i<size;i++){
var _623=_622[i],_621=_619?_623.getInstanceMethod(selector):_623.getClassMethod(selector);
if(_621){
break;
}
}
}
}
if(_621){
var _624=_621.types;
if(_624){
var _625=_624.length;
if(_625>0){
var _626=_624[0];
if(_626!==types[0]&&!(_626==="id"&&returnType&&returnType.typeisclass)){
_615.addWarning(_4dc("Conflicting return type in implementation of '"+selector+"': '"+_626+"' vs '"+types[0]+"'",returnType||node.action||selectors[0],_615.source));
}
for(var i=1;i<_625;i++){
var _627=_624[i];
if(_627!==types[i]&&!(_627==="id"&&nodeArguments[i-1].type.typeisclass)){
_615.addWarning(_4dc("Conflicting parameter types in implementation of '"+selector+"': '"+_627+"' vs '"+types[i]+"'",nodeArguments[i-1].type||nodeArguments[i-1].identifier,_615.source));
}
}
}
}
}
var _628=new _511(selector,types);
if(_619){
def.addInstanceMethod(_628);
}else{
def.addClassMethod(_628);
}
},MessageSendExpression:function(node,st,c){
var _629=st.compiler,_62a=_629.generate,_62b=_629.jsBuffer,_62c=node.object;
if(!_62a){
_62b.concat(_629.source.substring(_629.lastPos,node.start));
_629.lastPos=_62c?_62c.start:node.arguments.length?node.arguments[0].start:node.end;
}
if(node.superObject){
if(!_62a){
_62b.concat(" ");
}
_62b.concat("objj_msgSendSuper(");
_62b.concat("{ receiver:self, super_class:"+(st.currentMethodType()==="+"?_629.currentSuperMetaClass:_629.currentSuperClass)+" }");
}else{
if(_62a){
var _62d=_62c.type==="Identifier"&&!(st.currentMethodType()==="-"&&_629.getIvarForClass(_62c.name,st)&&!st.getLvar(_62c.name,true)),_62e,_62f;
if(_62d){
var name=_62c.name,_62e=st.getLvar(name);
if(name==="self"){
_62f=!_62e||!_62e.scope||_62e.scope.assignmentToSelf;
}else{
_62f=!!_62e||!_629.getClassDef(name);
}
if(_62f){
_62b.concat("(");
c(_62c,st,"Expression");
_62b.concat(" == null ? null : ");
}
c(_62c,st,"Expression");
}else{
_62f=true;
if(!st.receiverLevel){
st.receiverLevel=0;
}
_62b.concat("((___r");
_62b.concat(++st.receiverLevel+"");
_62b.concat(" = ");
c(_62c,st,"Expression");
_62b.concat("), ___r");
_62b.concat(st.receiverLevel+"");
_62b.concat(" == null ? null : ___r");
_62b.concat(st.receiverLevel+"");
if(!(st.maxReceiverLevel>=st.receiverLevel)){
st.maxReceiverLevel=st.receiverLevel;
}
}
_62b.concat(".isa.objj_msgSend");
}else{
_62b.concat(" ");
_62b.concat("objj_msgSend(");
_62b.concat(_629.source.substring(_629.lastPos,_62c.end));
}
}
var _630=node.selectors,_631=node.arguments,_632=_631.length,_633=_630[0],_634=_633?_633.name:"";
if(_62a&&!node.superObject){
var _635=_632;
if(node.parameters){
_635+=node.parameters.length;
}
if(_635<4){
_62b.concat(""+_635);
}
if(_62d){
_62b.concat("(");
c(_62c,st,"Expression");
}else{
_62b.concat("(___r");
_62b.concat(st.receiverLevel+"");
}
}
for(var i=0;i<_632;i++){
if(i===0){
_634+=":";
}else{
_634+=(_630[i]?_630[i].name:"")+":";
}
}
_62b.concat(", \"");
_62b.concat(_634);
_62b.concat("\"");
if(node.arguments){
for(var i=0;i<node.arguments.length;i++){
var _636=node.arguments[i];
_62b.concat(", ");
if(!_62a){
_629.lastPos=_636.start;
}
c(_636,st,"Expression");
if(!_62a){
_62b.concat(_629.source.substring(_629.lastPos,_636.end));
_629.lastPos=_636.end;
}
}
}
if(node.parameters){
for(var i=0;i<node.parameters.length;++i){
var _637=node.parameters[i];
_62b.concat(", ");
if(!_62a){
_629.lastPos=_637.start;
}
c(_637,st,"Expression");
if(!_62a){
_62b.concat(_629.source.substring(_629.lastPos,_637.end));
_629.lastPos=_637.end;
}
}
}
if(_62a&&!node.superObject){
if(_62f){
_62b.concat(")");
}
if(!_62d){
st.receiverLevel--;
}
}
_62b.concat(")");
if(!_62a){
_629.lastPos=node.end;
}
},SelectorLiteralExpression:function(node,st,c){
var _638=st.compiler,_639=_638.jsBuffer,_63a=_638.generate;
if(!_63a){
_639.concat(_638.source.substring(_638.lastPos,node.start));
_639.concat(" ");
}
_639.concat("sel_getUid(\"");
_639.concat(node.selector);
_639.concat("\")");
if(!_63a){
_638.lastPos=node.end;
}
},ProtocolLiteralExpression:function(node,st,c){
var _63b=st.compiler,_63c=_63b.jsBuffer,_63d=_63b.generate;
if(!_63d){
_63c.concat(_63b.source.substring(_63b.lastPos,node.start));
_63c.concat(" ");
}
_63c.concat("objj_getProtocol(\"");
_63c.concat(node.id.name);
_63c.concat("\")");
if(!_63d){
_63b.lastPos=node.end;
}
},Reference:function(node,st,c){
var _63e=st.compiler,_63f=_63e.jsBuffer,_640=_63e.generate;
if(!_640){
_63f.concat(_63e.source.substring(_63e.lastPos,node.start));
_63f.concat(" ");
}
_63f.concat("function(__input) { if (arguments.length) return ");
_63f.concat(node.element.name);
_63f.concat(" = __input; return ");
_63f.concat(node.element.name);
_63f.concat("; }");
if(!_640){
_63e.lastPos=node.end;
}
},Dereference:function(node,st,c){
var _641=st.compiler,_642=_641.generate;
_55d(st,node.expr);
if(!_642){
_641.jsBuffer.concat(_641.source.substring(_641.lastPos,node.start));
_641.lastPos=node.expr.start;
}
c(node.expr,st,"Expression");
if(!_642){
_641.jsBuffer.concat(_641.source.substring(_641.lastPos,node.expr.end));
}
_641.jsBuffer.concat("()");
if(!_642){
_641.lastPos=node.end;
}
},ClassStatement:function(node,st,c){
var _643=st.compiler;
if(!_643.generate){
_643.jsBuffer.concat(_643.source.substring(_643.lastPos,node.start));
_643.lastPos=node.start;
_643.jsBuffer.concat("//");
}
var _644=node.id.name;
if(_643.getTypeDef(_644)){
throw _643.error_message(_644+" is already declared as a type",node.id);
}
if(!_643.getClassDef(_644)){
classDef=new _4df(false,_644);
_643.classDefs[_644]=classDef;
}
st.vars[node.id.name]={type:"class",node:node.id};
},GlobalStatement:function(node,st,c){
var _645=st.compiler;
if(!_645.generate){
_645.jsBuffer.concat(_645.source.substring(_645.lastPos,node.start));
_645.lastPos=node.start;
_645.jsBuffer.concat("//");
}
st.rootScope().vars[node.id.name]={type:"global",node:node.id};
},PreprocessStatement:function(node,st,c){
var _646=st.compiler;
if(!_646.generate){
_646.jsBuffer.concat(_646.source.substring(_646.lastPos,node.start));
_646.lastPos=node.start;
_646.jsBuffer.concat("//");
}
},TypeDefStatement:function(node,st,c){
var _647=st.compiler,_648=_647.generate,_649=_647.jsBuffer,_64a=node.typedefname.name,_64b=_647.getTypeDef(_64a),_64c=new _4d2(st);
if(_64b){
throw _647.error_message("Duplicate type definition "+_64a,node.typedefname);
}
if(_647.getClassDef(_64a)){
throw _647.error_message(_64a+" is already declared as class",node.typedefname);
}
_647.imBuffer=new _2ae();
_647.cmBuffer=new _2ae();
if(!_648){
_649.concat(_647.source.substring(_647.lastPos,node.start));
}
_649.concat("{var the_typedef = objj_allocateTypeDef(\""+_64a+"\");");
_64b=new _510(_64a);
_647.typeDefs[_64a]=_64b;
_64c.typeDef=_64b;
_649.concat("\nobjj_registerTypeDef(the_typedef);\n");
_649.concat("}");
_647.jsBuffer=_649;
if(!_648){
_647.lastPos=node.end;
}
}});
function _2ec(aURL,_64d){
this._URL=aURL;
this._isLocal=_64d;
};
_2.FileDependency=_2ec;
_2ec.prototype.URL=function(){
return this._URL;
};
_2ec.prototype.isLocal=function(){
return this._isLocal;
};
_2ec.prototype.toMarkedString=function(){
var _64e=this.URL().absoluteString();
return (this.isLocal()?_234:_233)+";"+_64e.length+";"+_64e;
};
_2ec.prototype.toString=function(){
return (this.isLocal()?"LOCAL: ":"STD: ")+this.URL();
};
var _64f=0,_650=1,_651=2,_652=0;
function _2bd(_653,_654,aURL,_655,_656,_657){
if(arguments.length===0){
return this;
}
this._code=_653;
this._function=_655||null;
this._URL=_1ce(aURL||new CFURL("(Anonymous"+(_652++)+")"));
this._compiler=_656||null;
this._fileDependencies=_654;
this._filenameTranslateDictionary=_657;
if(_654.length){
this._fileDependencyStatus=_64f;
this._fileDependencyCallbacks=[];
}else{
this._fileDependencyStatus=_651;
}
if(this._function){
return;
}
if(!_656){
this.setCode(_653);
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
var _658=["global","objj_executeFile","objj_importFile"];
return _658;
};
_2bd.prototype.functionArguments=function(){
var _659=[_1,this.fileExecuter(),this.fileImporter()];
return _659;
};
_2bd.prototype.execute=function(){
if(this._compiler){
var _65a=this.fileDependencies(),_9d=0,_65b=_65a.length;
this._compiler.pushImport(this.URL().lastPathComponent());
for(;_9d<_65b;++_9d){
var _65c=_65a[_9d],_65d=_65c.isLocal(),URL=_65c.URL();
this.fileExecuter()(URL,_65d);
}
this._compiler.popImport();
this.setCode(this._compiler.compilePass2());
this._compiler=null;
}
var _65e=_65f;
_65f=CFBundle.bundleContainingURL(this.URL());
var _660=this._function.apply(_1,this.functionArguments());
_65f=_65e;
return _660;
};
_2bd.prototype.code=function(){
return this._code;
};
_2bd.prototype.setCode=function(code){
this._code=code;
var _661=this.functionParameters().join(",");
this._function=new Function(_661,code);
};
_2bd.prototype.fileDependencies=function(){
return this._fileDependencies;
};
_2bd.prototype.hasLoadedFileDependencies=function(){
return this._fileDependencyStatus===_651;
};
var _662=0,_663=[],_664={};
_2bd.prototype.loadFileDependencies=function(_665){
var _666=this._fileDependencyStatus;
if(_665){
if(_666===_651){
return _665();
}
this._fileDependencyCallbacks.push(_665);
}
if(_666===_64f){
if(_662){
throw "Can't load";
}
_667(this);
}
};
function _667(_668){
_663.push(_668);
_668._fileDependencyStatus=_650;
var _669=_668.fileDependencies(),_9d=0,_66a=_669.length,_66b=_668.referenceURL(),_66c=_66b.absoluteString(),_66d=_668.fileExecutableSearcher();
_662+=_66a;
for(;_9d<_66a;++_9d){
var _66e=_669[_9d],_66f=_66e.isLocal(),URL=_66e.URL(),_670=(_66f&&(_66c+" ")||"")+URL;
if(_664[_670]){
if(--_662===0){
_671();
}
continue;
}
_664[_670]=YES;
_66d(URL,_66f,_672);
}
};
function _672(_673){
--_662;
if(_673._fileDependencyStatus===_64f){
_667(_673);
}else{
if(_662===0){
_671();
}
}
};
function _671(){
var _674=_663,_9d=0,_675=_674.length;
_663=[];
for(;_9d<_675;++_9d){
_674[_9d]._fileDependencyStatus=_651;
}
for(_9d=0;_9d<_675;++_9d){
var _676=_674[_9d],_677=_676._fileDependencyCallbacks,_678=0,_679=_677.length;
for(;_678<_679;++_678){
_677[_678]();
}
_676._fileDependencyCallbacks=[];
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
var _67a={};
_2bd.fileExecuterForURL=function(aURL){
var _67b=_1ce(aURL),_67c=_67b.absoluteString(),_67d=_67a[_67c];
if(!_67d){
_67d=function(aURL,_67e,_67f){
_2bd.fileExecutableSearcherForURL(_67b)(aURL,_67e,function(_680){
if(!_680.hasLoadedFileDependencies()){
throw "No executable loaded for file at URL "+aURL;
}
_680.execute(_67f);
});
};
_67a[_67c]=_67d;
}
return _67d;
};
var _681={};
_2bd.fileImporterForURL=function(aURL){
var _682=_1ce(aURL),_683=_682.absoluteString(),_684=_681[_683];
if(!_684){
_684=function(aURL,_685,_686){
_16a();
_2bd.fileExecutableSearcherForURL(_682)(aURL,_685,function(_687){
_687.loadFileDependencies(function(){
_687.execute();
_16b();
if(_686){
_686();
}
});
});
};
_681[_683]=_684;
}
return _684;
};
var _688={},_689={};
function _24c(x){
var _68a=0;
for(var k in x){
if(x.hasOwnProperty(k)){
++_68a;
}
}
return _68a;
};
_2bd.resetCachedFileExecutableSearchers=function(){
_688={};
_689={};
_681={};
_67a={};
_664={};
};
_2bd.fileExecutableSearcherForURL=function(_68b){
var _68c=_68b.absoluteString(),_68d=_688[_68c],_68e=_2bd.filenameTranslateDictionary?_2bd.filenameTranslateDictionary():null;
cachedSearchResults={};
if(!_68d){
_68d=function(aURL,_68f,_690){
var _691=(_68f&&_68b||"")+aURL,_692=_689[_691];
if(_692){
return _693(_692);
}
var _694=(aURL instanceof CFURL)&&aURL.scheme();
if(_68f||_694){
if(!_694){
aURL=new CFURL(aURL,_68b);
}
_1ba.resolveResourceAtURL(aURL,NO,_693,_68e);
}else{
_1ba.resolveResourceAtURLSearchingIncludeURLs(aURL,_693);
}
function _693(_695){
if(!_695){
var _696=_518?_518.currentCompileFile:null;
throw new Error("Could not load file at "+aURL+(_696?" when compiling "+_696:""));
}
_689[_691]=_695;
_690(new _697(_695.URL(),_68e));
};
};
_688[_68c]=_68d;
}
return _68d;
};
var _698={};
function _697(aURL,_699){
aURL=_1ce(aURL);
var _69a=aURL.absoluteString(),_69b=_698[_69a];
if(_69b){
return _69b;
}
_698[_69a]=this;
var _69c=_1ba.resourceAtURL(aURL).contents(),_69d=NULL,_69e=aURL.pathExtension().toLowerCase();
if(_69c.match(/^@STATIC;/)){
_69d=_69f(_69c,aURL);
}else{
if((_69e==="j"||!_69e)&&!_69c.match(/^{/)){
_69d=_2.ObjJAcornCompiler.compileFileDependencies(_69c,aURL,_518.Flags.IncludeDebugSymbols);
}else{
_69d=new _2bd(_69c,[],aURL);
}
}
_2bd.apply(this,[_69d.code(),_69d.fileDependencies(),aURL,_69d._function,_69d._compiler,_699]);
this._hasExecuted=NO;
};
_2.FileExecutable=_697;
_697.prototype=new _2bd();
_697.resetFileExecutables=function(){
_698={};
_6a0={};
};
_697.prototype.execute=function(_6a1){
if(this._hasExecuted&&!_6a1){
return;
}
this._hasExecuted=YES;
_2bd.prototype.execute.call(this);
};
_697.prototype.hasExecuted=function(){
return this._hasExecuted;
};
function _69f(_6a2,aURL){
var _6a3=new _119(_6a2);
var _6a4=NULL,code="",_6a5=[];
while(_6a4=_6a3.getMarker()){
var text=_6a3.getString();
if(_6a4===_232){
code+=text;
}else{
if(_6a4===_233){
_6a5.push(new _2ec(new CFURL(text),NO));
}else{
if(_6a4===_234){
_6a5.push(new _2ec(new CFURL(text),YES));
}
}
}
}
var fn=_697._lookupCachedFunction(aURL);
if(fn){
return new _2bd(code,_6a5,aURL,fn);
}
return new _2bd(code,_6a5,aURL);
};
var _6a0={};
_697._cacheFunction=function(aURL,fn){
aURL=typeof aURL==="string"?aURL:aURL.absoluteString();
_6a0[aURL]=fn;
};
_697._lookupCachedFunction=function(aURL){
aURL=typeof aURL==="string"?aURL:aURL.absoluteString();
return _6a0[aURL];
};
var _6a6=1,_6a7=2,_6a8=4,_6a9=8;
objj_ivar=function(_6aa,_6ab){
this.name=_6aa;
this.type=_6ab;
};
objj_method=function(_6ac,_6ad,_6ae){
this.name=_6ac;
this.method_imp=_6ad;
this.types=_6ae;
};
objj_class=function(_6af){
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
objj_protocol=function(_6b0){
this.name=_6b0;
this.instance_methods={};
this.class_methods={};
};
objj_object=function(){
this.isa=NULL;
this._UID=-1;
};
objj_typeDef=function(_6b1){
this.name=_6b1;
};
class_getName=function(_6b2){
if(_6b2==Nil){
return "";
}
return _6b2.name;
};
class_isMetaClass=function(_6b3){
if(!_6b3){
return NO;
}
return ((_6b3.info&(_6a7)));
};
class_getSuperclass=function(_6b4){
if(_6b4==Nil){
return Nil;
}
return _6b4.super_class;
};
class_setSuperclass=function(_6b5,_6b6){
_6b5.super_class=_6b6;
_6b5.isa.super_class=_6b6.isa;
};
class_addIvar=function(_6b7,_6b8,_6b9){
var _6ba=_6b7.allocator.prototype;
if(typeof _6ba[_6b8]!="undefined"){
return NO;
}
var ivar=new objj_ivar(_6b8,_6b9);
_6b7.ivar_list.push(ivar);
_6b7.ivar_dtable[_6b8]=ivar;
_6ba[_6b8]=NULL;
return YES;
};
class_addIvars=function(_6bb,_6bc){
var _6bd=0,_6be=_6bc.length,_6bf=_6bb.allocator.prototype;
for(;_6bd<_6be;++_6bd){
var ivar=_6bc[_6bd],name=ivar.name;
if(typeof _6bf[name]==="undefined"){
_6bb.ivar_list.push(ivar);
_6bb.ivar_dtable[name]=ivar;
_6bf[name]=NULL;
}
}
};
class_copyIvarList=function(_6c0){
return _6c0.ivar_list.slice(0);
};
class_addMethod=function(_6c1,_6c2,_6c3,_6c4){
var _6c5=new objj_method(_6c2,_6c3,_6c4);
_6c1.method_list.push(_6c5);
_6c1.method_dtable[_6c2]=_6c5;
if(!((_6c1.info&(_6a7)))&&(((_6c1.info&(_6a7)))?_6c1:_6c1.isa).isa===(((_6c1.info&(_6a7)))?_6c1:_6c1.isa)){
class_addMethod((((_6c1.info&(_6a7)))?_6c1:_6c1.isa),_6c2,_6c3,_6c4);
}
return YES;
};
class_addMethods=function(_6c6,_6c7){
var _6c8=0,_6c9=_6c7.length,_6ca=_6c6.method_list,_6cb=_6c6.method_dtable;
for(;_6c8<_6c9;++_6c8){
var _6cc=_6c7[_6c8];
_6ca.push(_6cc);
_6cb[_6cc.name]=_6cc;
}
if(!((_6c6.info&(_6a7)))&&(((_6c6.info&(_6a7)))?_6c6:_6c6.isa).isa===(((_6c6.info&(_6a7)))?_6c6:_6c6.isa)){
class_addMethods((((_6c6.info&(_6a7)))?_6c6:_6c6.isa),_6c7);
}
};
class_getInstanceMethod=function(_6cd,_6ce){
if(!_6cd||!_6ce){
return NULL;
}
var _6cf=_6cd.method_dtable[_6ce];
return _6cf?_6cf:NULL;
};
class_getInstanceVariable=function(_6d0,_6d1){
if(!_6d0||!_6d1){
return NULL;
}
var _6d2=_6d0.ivar_dtable[_6d1];
return _6d2;
};
class_getClassMethod=function(_6d3,_6d4){
if(!_6d3||!_6d4){
return NULL;
}
var _6d5=(((_6d3.info&(_6a7)))?_6d3:_6d3.isa).method_dtable[_6d4];
return _6d5?_6d5:NULL;
};
class_respondsToSelector=function(_6d6,_6d7){
return class_getClassMethod(_6d6,_6d7)!=NULL;
};
class_copyMethodList=function(_6d8){
return _6d8.method_list.slice(0);
};
class_getVersion=function(_6d9){
return _6d9.version;
};
class_setVersion=function(_6da,_6db){
_6da.version=parseInt(_6db,10);
};
class_replaceMethod=function(_6dc,_6dd,_6de){
if(!_6dc||!_6dd){
return NULL;
}
var _6df=_6dc.method_dtable[_6dd],_6e0=NULL;
if(_6df){
_6e0=_6df.method_imp;
}
_6df.method_imp=_6de;
return _6e0;
};
class_addProtocol=function(_6e1,_6e2){
if(!_6e2||class_conformsToProtocol(_6e1,_6e2)){
return;
}
(_6e1.protocol_list||(_6e1.protocol_list==[])).push(_6e2);
return true;
};
class_conformsToProtocol=function(_6e3,_6e4){
if(!_6e4){
return false;
}
while(_6e3){
var _6e5=_6e3.protocol_list,size=_6e5?_6e5.length:0;
for(var i=0;i<size;i++){
var p=_6e5[i];
if(p.name===_6e4.name){
return true;
}
if(protocol_conformsToProtocol(p,_6e4)){
return true;
}
}
_6e3=class_getSuperclass(_6e3);
}
return false;
};
class_copyProtocolList=function(_6e6){
var _6e7=_6e6.protocol_list;
return _6e7?_6e7.slice(0):[];
};
protocol_conformsToProtocol=function(p1,p2){
if(!p1||!p2){
return false;
}
if(p1.name===p2.name){
return true;
}
var _6e8=p1.protocol_list,size=_6e8?_6e8.length:0;
for(var i=0;i<size;i++){
var p=_6e8[i];
if(p.name===p2.name){
return true;
}
if(protocol_conformsToProtocol(p,p2)){
return true;
}
}
return false;
};
var _6e9=Object.create(null);
objj_allocateProtocol=function(_6ea){
var _6eb=new objj_protocol(_6ea);
return _6eb;
};
objj_registerProtocol=function(_6ec){
_6e9[_6ec.name]=_6ec;
};
protocol_getName=function(_6ed){
return _6ed.name;
};
protocol_addMethodDescription=function(_6ee,_6ef,_6f0,_6f1,_6f2){
if(!_6ee||!_6ef){
return;
}
if(_6f1){
(_6f2?_6ee.instance_methods:_6ee.class_methods)[_6ef]=new objj_method(_6ef,null,_6f0);
}
};
protocol_addMethodDescriptions=function(_6f3,_6f4,_6f5,_6f6){
if(!_6f5){
return;
}
var _6f7=0,_6f8=_6f4.length,_6f9=_6f6?_6f3.instance_methods:_6f3.class_methods;
for(;_6f7<_6f8;++_6f7){
var _6fa=_6f4[_6f7];
_6f9[_6fa.name]=_6fa;
}
};
protocol_copyMethodDescriptionList=function(_6fb,_6fc,_6fd){
if(!_6fc){
return [];
}
var _6fe=_6fd?_6fb.instance_methods:_6fb.class_methods,_6ff=[];
for(var _700 in _6fe){
if(_6fe.hasOwnProperty(_700)){
_6ff.push(_6fe[_700]);
}
}
return _6ff;
};
protocol_addProtocol=function(_701,_702){
if(!_701||!_702){
return;
}
(_701.protocol_list||(_701.protocol_list=[])).push(_702);
};
var _703=Object.create(null);
objj_allocateTypeDef=function(_704){
var _705=new objj_typeDef(_704);
return _705;
};
objj_registerTypeDef=function(_706){
_703[_706.name]=_706;
};
typeDef_getName=function(_707){
return _707.name;
};
var _708=function(_709){
var meta=(((_709.info&(_6a7)))?_709:_709.isa);
if((_709.info&(_6a7))){
_709=objj_getClass(_709.name);
}
if(_709.super_class&&!((((_709.super_class.info&(_6a7)))?_709.super_class:_709.super_class.isa).info&(_6a8))){
_708(_709.super_class);
}
if(!(meta.info&(_6a8))&&!(meta.info&(_6a9))){
meta.info=(meta.info|(_6a9))&~(0);
_709.objj_msgSend=objj_msgSendFast;
_709.objj_msgSend0=objj_msgSendFast0;
_709.objj_msgSend1=objj_msgSendFast1;
_709.objj_msgSend2=objj_msgSendFast2;
_709.objj_msgSend3=objj_msgSendFast3;
meta.objj_msgSend=objj_msgSendFast;
meta.objj_msgSend0=objj_msgSendFast0;
meta.objj_msgSend1=objj_msgSendFast1;
meta.objj_msgSend2=objj_msgSendFast2;
meta.objj_msgSend3=objj_msgSendFast3;
meta.objj_msgSend0(_709,"initialize");
meta.info=(meta.info|(_6a8))&~(_6a9);
}
};
var _70a=function(self,_70b){
var isa=self.isa,_70c=isa.method_dtable[_70d];
if(_70c){
var _70e=_70c.method_imp.call(this,self,_70d,_70b);
if(_70e&&_70e!==self){
arguments[0]=_70e;
return objj_msgSend.apply(this,arguments);
}
}
_70c=isa.method_dtable[_70f];
if(_70c){
var _710=isa.method_dtable[_711];
if(_710){
var _712=_70c.method_imp.call(this,self,_70f,_70b);
if(_712){
var _713=objj_lookUpClass("CPInvocation");
if(_713){
var _714=_713.isa.objj_msgSend1(_713,_715,_712),_9d=0,_716=arguments.length;
if(_714!=null){
var _717=_714.isa;
for(;_9d<_716;++_9d){
_717.objj_msgSend2(_714,_718,arguments[_9d],_9d);
}
}
_710.method_imp.call(this,self,_711,_714);
return _714==null?null:_717.objj_msgSend0(_714,_719);
}
}
}
}
_70c=isa.method_dtable[_71a];
if(_70c){
return _70c.method_imp.call(this,self,_71a,_70b);
}
throw class_getName(isa)+" does not implement doesNotRecognizeSelector:. Did you forget a superclass for "+class_getName(isa)+"?";
};
class_getMethodImplementation=function(_71b,_71c){
if(!((((_71b.info&(_6a7)))?_71b:_71b.isa).info&(_6a8))){
_708(_71b);
}
var _71d=_71b.method_dtable[_71c];
var _71e=_71d?_71d.method_imp:_70a;
return _71e;
};
var _71f=Object.create(null);
objj_enumerateClassesUsingBlock=function(_720){
for(var key in _71f){
_720(_71f[key]);
}
};
objj_allocateClassPair=function(_721,_722){
var _723=new objj_class(_722),_724=new objj_class(_722),_725=_723;
if(_721){
_725=_721;
while(_725.superclass){
_725=_725.superclass;
}
_723.allocator.prototype=new _721.allocator;
_723.ivar_dtable=_723.ivar_store.prototype=new _721.ivar_store;
_723.method_dtable=_723.method_store.prototype=new _721.method_store;
_724.method_dtable=_724.method_store.prototype=new _721.isa.method_store;
_723.super_class=_721;
_724.super_class=_721.isa;
}else{
_723.allocator.prototype=new objj_object();
}
_723.isa=_724;
_723.name=_722;
_723.info=_6a6;
_723._UID=objj_generateObjectUID();
_724.isa=_725.isa;
_724.name=_722;
_724.info=_6a7;
_724._UID=objj_generateObjectUID();
return _723;
};
var _65f=nil;
objj_registerClassPair=function(_726){
_1[_726.name]=_726;
_71f[_726.name]=_726;
_1d5(_726,_65f);
};
objj_resetRegisterClasses=function(){
for(var key in _71f){
delete _1[key];
}
_71f=Object.create(null);
_6e9=Object.create(null);
_703=Object.create(null);
_1d8();
};
class_createInstance=function(_727){
if(!_727){
throw new Error("*** Attempting to create object with Nil class.");
}
var _728=new _727.allocator();
_728.isa=_727;
_728._UID=objj_generateObjectUID();
return _728;
};
var _729=function(){
};
_729.prototype.member=false;
with(new _729()){
member=true;
}
if(new _729().member){
var _72a=class_createInstance;
class_createInstance=function(_72b){
var _72c=_72a(_72b);
if(_72c){
var _72d=_72c.isa,_72e=_72d;
while(_72d){
var _72f=_72d.ivar_list,_730=_72f.length;
while(_730--){
_72c[_72f[_730].name]=NULL;
}
_72d=_72d.super_class;
}
_72c.isa=_72e;
}
return _72c;
};
}
object_getClassName=function(_731){
if(!_731){
return "";
}
var _732=_731.isa;
return _732?class_getName(_732):"";
};
objj_lookUpClass=function(_733){
var _734=_71f[_733];
return _734?_734:Nil;
};
objj_getClass=function(_735){
var _736=_71f[_735];
if(!_736){
}
return _736?_736:Nil;
};
objj_getClassList=function(_737,_738){
for(var _739 in _71f){
_737.push(_71f[_739]);
if(_738&&--_738===0){
break;
}
}
return _737.length;
};
objj_getMetaClass=function(_73a){
var _73b=objj_getClass(_73a);
return (((_73b.info&(_6a7)))?_73b:_73b.isa);
};
objj_getProtocol=function(_73c){
return _6e9[_73c];
};
objj_getTypeDef=function(_73d){
return _703[_73d];
};
ivar_getName=function(_73e){
return _73e.name;
};
ivar_getTypeEncoding=function(_73f){
return _73f.type;
};
objj_msgSend=function(_740,_741){
if(_740==nil){
return nil;
}
var isa=_740.isa;
if(!((((isa.info&(_6a7)))?isa:isa.isa).info&(_6a8))){
_708(isa);
}
var _742=isa.method_dtable[_741];
var _743=_742?_742.method_imp:_70a;
switch(arguments.length){
case 2:
return _743(_740,_741);
case 3:
return _743(_740,_741,arguments[2]);
case 4:
return _743(_740,_741,arguments[2],arguments[3]);
}
return _743.apply(_740,arguments);
};
objj_msgSendSuper=function(_744,_745){
var _746=_744.super_class;
arguments[0]=_744.receiver;
if(!((((_746.info&(_6a7)))?_746:_746.isa).info&(_6a8))){
_708(_746);
}
var _747=_746.method_dtable[_745];
var _748=_747?_747.method_imp:_70a;
return _748.apply(_744.receiver,arguments);
};
objj_msgSendFast=function(_749,_74a){
var _74b=this.method_dtable[_74a],_74c=_74b?_74b.method_imp:_70a;
return _74c.apply(_749,arguments);
};
var _74d=function(_74e,_74f){
_708(this);
return this.objj_msgSend.apply(this,arguments);
};
objj_msgSendFast0=function(_750,_751){
var _752=this.method_dtable[_751],_753=_752?_752.method_imp:_70a;
return _753(_750,_751);
};
var _754=function(_755,_756){
_708(this);
return this.objj_msgSend0(_755,_756);
};
objj_msgSendFast1=function(_757,_758,arg0){
var _759=this.method_dtable[_758],_75a=_759?_759.method_imp:_70a;
return _75a(_757,_758,arg0);
};
var _75b=function(_75c,_75d,arg0){
_708(this);
return this.objj_msgSend1(_75c,_75d,arg0);
};
objj_msgSendFast2=function(_75e,_75f,arg0,arg1){
var _760=this.method_dtable[_75f],_761=_760?_760.method_imp:_70a;
return _761(_75e,_75f,arg0,arg1);
};
var _762=function(_763,_764,arg0,arg1){
_708(this);
return this.objj_msgSend2(_763,_764,arg0,arg1);
};
objj_msgSendFast3=function(_765,_766,arg0,arg1,arg2){
var _767=this.method_dtable[_766],_768=_767?_767.method_imp:_70a;
return _768(_765,_766,arg0,arg1,arg2);
};
var _769=function(_76a,_76b,arg0,arg1,arg2){
_708(this);
return this.objj_msgSend3(_76a,_76b,arg0,arg1,arg2);
};
method_getName=function(_76c){
return _76c.name;
};
method_getImplementation=function(_76d){
return _76d.method_imp;
};
method_setImplementation=function(_76e,_76f){
var _770=_76e.method_imp;
_76e.method_imp=_76f;
return _770;
};
method_exchangeImplementations=function(lhs,rhs){
var _771=method_getImplementation(lhs),_772=method_getImplementation(rhs);
method_setImplementation(lhs,_772);
method_setImplementation(rhs,_771);
};
sel_getName=function(_773){
return _773?_773:"<null selector>";
};
sel_getUid=function(_774){
return _774;
};
sel_isEqual=function(lhs,rhs){
return lhs===rhs;
};
sel_registerName=function(_775){
return _775;
};
objj_class.prototype.toString=objj_object.prototype.toString=function(){
var isa=this.isa;
if(class_getInstanceMethod(isa,_776)){
return isa.objj_msgSend0(this,_776);
}
if(class_isMetaClass(isa)){
return this.name;
}
return "["+isa.name+" Object](-description not implemented)";
};
objj_class.prototype.objj_msgSend=_74d;
objj_class.prototype.objj_msgSend0=_754;
objj_class.prototype.objj_msgSend1=_75b;
objj_class.prototype.objj_msgSend2=_762;
objj_class.prototype.objj_msgSend3=_769;
var _776=sel_getUid("description"),_70d=sel_getUid("forwardingTargetForSelector:"),_70f=sel_getUid("methodSignatureForSelector:"),_711=sel_getUid("forwardInvocation:"),_71a=sel_getUid("doesNotRecognizeSelector:"),_715=sel_getUid("invocationWithMethodSignature:"),_777=sel_getUid("setTarget:"),_778=sel_getUid("setSelector:"),_718=sel_getUid("setArgument:atIndex:"),_719=sel_getUid("returnValue");
objj_eval=function(_779){
var url=_2.pageURL;
var _77a=_2.asyncLoader;
_2.asyncLoader=NO;
var _77b=_2.preprocess(_779,url,0);
if(!_77b.hasLoadedFileDependencies()){
_77b.loadFileDependencies();
}
_1._objj_eval_scope={};
_1._objj_eval_scope.objj_executeFile=_2bd.fileExecuterForURL(url);
_1._objj_eval_scope.objj_importFile=_2bd.fileImporterForURL(url);
var code="with(_objj_eval_scope){"+_77b._code+"\n//*/\n}";
var _77c;
_77c=eval(code);
_2.asyncLoader=_77a;
return _77c;
};
_2.objj_eval=objj_eval;
_16a();
var _77d=new CFURL(window.location.href),_77e=document.getElementsByTagName("base"),_77f=_77e.length;
if(_77f>0){
var _780=_77e[_77f-1],_781=_780&&_780.getAttribute("href");
if(_781){
_77d=new CFURL(_781,_77d);
}
}
var _782=new CFURL(window.OBJJ_MAIN_FILE||"main.j"),_1d4=new CFURL(".",new CFURL(_782,_77d)).absoluteURL(),_783=new CFURL("..",_1d4).absoluteURL();
if(_1d4===_783){
_783=new CFURL(_783.schemeAndAuthority());
}
_1ba.resourceAtURL(_783,YES);
_2.pageURL=_77d;
_2.bootstrap=function(){
_784();
};
function _784(){
_1ba.resolveResourceAtURL(_1d4,YES,function(_785){
var _786=_1ba.includeURLs(),_9d=0,_787=_786.length;
for(;_9d<_787;++_9d){
_785.resourceAtURL(_786[_9d],YES);
}
_2bd.fileImporterForURL(_1d4)(_782.lastPathComponent(),YES,function(){
_16b();
_78d(function(){
var _788=window.location.hash.substring(1),args=[];
if(_788.length){
args=_788.split("/");
for(var i=0,_787=args.length;i<_787;i++){
args[i]=decodeURIComponent(args[i]);
}
}
var _789=window.location.search.substring(1).split("&"),_78a=new CFMutableDictionary();
for(var i=0,_787=_789.length;i<_787;i++){
var _78b=_789[i].split("=");
if(!_78b[0]){
continue;
}
if(_78b[1]==null){
_78b[1]=true;
}
_78a.setValueForKey(decodeURIComponent(_78b[0]),decodeURIComponent(_78b[1]));
}
main(args,_78a);
});
});
});
};
var _78c=NO;
function _78d(_78e){
if(_78c||document.readyState==="complete"){
return _78e();
}
if(window.addEventListener){
window.addEventListener("load",_78e,NO);
}else{
if(window.attachEvent){
window.attachEvent("onload",_78e);
}
}
};
_78d(function(){
_78c=YES;
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

"use strict";(self.webpackChunkhrrp_phone=self.webpackChunkhrrp_phone||[]).push([[2946],{62946:(t,e,r)=>{r.r(e),r.d(e,{default:()=>y});var n=r(39337),o=r(66525),i=r(50678),a=(r(65425),r(20913),r(76487),r(11339)),c=r(87448),u=r(70867),l=r(98330),s=r(53886);function f(t){return f="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},f(t)}function h(){h=function(){return e};var t,e={},r=Object.prototype,n=r.hasOwnProperty,o=Object.defineProperty||function(t,e,r){t[e]=r.value},i="function"==typeof Symbol?Symbol:{},a=i.iterator||"@@iterator",c=i.asyncIterator||"@@asyncIterator",u=i.toStringTag||"@@toStringTag";function l(t,e,r){return Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}),t[e]}try{l({},"")}catch(t){l=function(t,e,r){return t[e]=r}}function s(t,e,r,n){var i=e&&e.prototype instanceof b?e:b,a=Object.create(i.prototype),c=new N(n||[]);return o(a,"_invoke",{value:j(t,r,c)}),a}function p(t,e,r){try{return{type:"normal",arg:t.call(e,r)}}catch(t){return{type:"throw",arg:t}}}e.wrap=s;var d="suspendedStart",y="suspendedYield",g="executing",v="completed",m={};function b(){}function w(){}function x(){}var k={};l(k,a,(function(){return this}));var L=Object.getPrototypeOf,E=L&&L(L(C([])));E&&E!==r&&n.call(E,a)&&(k=E);var S=x.prototype=b.prototype=Object.create(k);function _(t){["next","throw","return"].forEach((function(e){l(t,e,(function(t){return this._invoke(e,t)}))}))}function A(t,e){function r(o,i,a,c){var u=p(t[o],t,i);if("throw"!==u.type){var l=u.arg,s=l.value;return s&&"object"==f(s)&&n.call(s,"__await")?e.resolve(s.__await).then((function(t){r("next",t,a,c)}),(function(t){r("throw",t,a,c)})):e.resolve(s).then((function(t){l.value=t,a(l)}),(function(t){return r("throw",t,a,c)}))}c(u.arg)}var i;o(this,"_invoke",{value:function(t,n){function o(){return new e((function(e,o){r(t,n,e,o)}))}return i=i?i.then(o,o):o()}})}function j(e,r,n){var o=d;return function(i,a){if(o===g)throw Error("Generator is already running");if(o===v){if("throw"===i)throw a;return{value:t,done:!0}}for(n.method=i,n.arg=a;;){var c=n.delegate;if(c){var u=O(c,n);if(u){if(u===m)continue;return u}}if("next"===n.method)n.sent=n._sent=n.arg;else if("throw"===n.method){if(o===d)throw o=v,n.arg;n.dispatchException(n.arg)}else"return"===n.method&&n.abrupt("return",n.arg);o=g;var l=p(e,r,n);if("normal"===l.type){if(o=n.done?v:y,l.arg===m)continue;return{value:l.arg,done:n.done}}"throw"===l.type&&(o=v,n.method="throw",n.arg=l.arg)}}}function O(e,r){var n=r.method,o=e.iterator[n];if(o===t)return r.delegate=null,"throw"===n&&e.iterator.return&&(r.method="return",r.arg=t,O(e,r),"throw"===r.method)||"return"!==n&&(r.method="throw",r.arg=new TypeError("The iterator does not provide a '"+n+"' method")),m;var i=p(o,e.iterator,r.arg);if("throw"===i.type)return r.method="throw",r.arg=i.arg,r.delegate=null,m;var a=i.arg;return a?a.done?(r[e.resultName]=a.value,r.next=e.nextLoc,"return"!==r.method&&(r.method="next",r.arg=t),r.delegate=null,m):a:(r.method="throw",r.arg=new TypeError("iterator result is not an object"),r.delegate=null,m)}function T(t){var e={tryLoc:t[0]};1 in t&&(e.catchLoc=t[1]),2 in t&&(e.finallyLoc=t[2],e.afterLoc=t[3]),this.tryEntries.push(e)}function G(t){var e=t.completion||{};e.type="normal",delete e.arg,t.completion=e}function N(t){this.tryEntries=[{tryLoc:"root"}],t.forEach(T,this),this.reset(!0)}function C(e){if(e||""===e){var r=e[a];if(r)return r.call(e);if("function"==typeof e.next)return e;if(!isNaN(e.length)){var o=-1,i=function r(){for(;++o<e.length;)if(n.call(e,o))return r.value=e[o],r.done=!1,r;return r.value=t,r.done=!0,r};return i.next=i}}throw new TypeError(f(e)+" is not iterable")}return w.prototype=x,o(S,"constructor",{value:x,configurable:!0}),o(x,"constructor",{value:w,configurable:!0}),w.displayName=l(x,u,"GeneratorFunction"),e.isGeneratorFunction=function(t){var e="function"==typeof t&&t.constructor;return!!e&&(e===w||"GeneratorFunction"===(e.displayName||e.name))},e.mark=function(t){return Object.setPrototypeOf?Object.setPrototypeOf(t,x):(t.__proto__=x,l(t,u,"GeneratorFunction")),t.prototype=Object.create(S),t},e.awrap=function(t){return{__await:t}},_(A.prototype),l(A.prototype,c,(function(){return this})),e.AsyncIterator=A,e.async=function(t,r,n,o,i){void 0===i&&(i=Promise);var a=new A(s(t,r,n,o),i);return e.isGeneratorFunction(r)?a:a.next().then((function(t){return t.done?t.value:a.next()}))},_(S),l(S,u,"Generator"),l(S,a,(function(){return this})),l(S,"toString",(function(){return"[object Generator]"})),e.keys=function(t){var e=Object(t),r=[];for(var n in e)r.push(n);return r.reverse(),function t(){for(;r.length;){var n=r.pop();if(n in e)return t.value=n,t.done=!1,t}return t.done=!0,t}},e.values=C,N.prototype={constructor:N,reset:function(e){if(this.prev=0,this.next=0,this.sent=this._sent=t,this.done=!1,this.delegate=null,this.method="next",this.arg=t,this.tryEntries.forEach(G),!e)for(var r in this)"t"===r.charAt(0)&&n.call(this,r)&&!isNaN(+r.slice(1))&&(this[r]=t)},stop:function(){this.done=!0;var t=this.tryEntries[0].completion;if("throw"===t.type)throw t.arg;return this.rval},dispatchException:function(e){if(this.done)throw e;var r=this;function o(n,o){return c.type="throw",c.arg=e,r.next=n,o&&(r.method="next",r.arg=t),!!o}for(var i=this.tryEntries.length-1;i>=0;--i){var a=this.tryEntries[i],c=a.completion;if("root"===a.tryLoc)return o("end");if(a.tryLoc<=this.prev){var u=n.call(a,"catchLoc"),l=n.call(a,"finallyLoc");if(u&&l){if(this.prev<a.catchLoc)return o(a.catchLoc,!0);if(this.prev<a.finallyLoc)return o(a.finallyLoc)}else if(u){if(this.prev<a.catchLoc)return o(a.catchLoc,!0)}else{if(!l)throw Error("try statement without catch or finally");if(this.prev<a.finallyLoc)return o(a.finallyLoc)}}}},abrupt:function(t,e){for(var r=this.tryEntries.length-1;r>=0;--r){var o=this.tryEntries[r];if(o.tryLoc<=this.prev&&n.call(o,"finallyLoc")&&this.prev<o.finallyLoc){var i=o;break}}i&&("break"===t||"continue"===t)&&i.tryLoc<=e&&e<=i.finallyLoc&&(i=null);var a=i?i.completion:{};return a.type=t,a.arg=e,i?(this.method="next",this.next=i.finallyLoc,m):this.complete(a)},complete:function(t,e){if("throw"===t.type)throw t.arg;return"break"===t.type||"continue"===t.type?this.next=t.arg:"return"===t.type?(this.rval=this.arg=t.arg,this.method="return",this.next="end"):"normal"===t.type&&e&&(this.next=e),m},finish:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.finallyLoc===t)return this.complete(r.completion,r.afterLoc),G(r),m}},catch:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.tryLoc===t){var n=r.completion;if("throw"===n.type){var o=n.arg;G(r)}return o}}throw Error("illegal catch attempt")},delegateYield:function(e,r,n){return this.delegate={iterator:C(e),resultName:r,nextLoc:n},"next"===this.method&&(this.arg=t),m}},e}function p(t,e,r,n,o,i,a){try{var c=t[i](a),u=c.value}catch(t){return void r(t)}c.done?e(u):Promise.resolve(u).then(n,o)}r(13541);var d=(0,i.A)((function(t){return{wrapper:{height:"100%",background:t.palette.secondary.main,overflowY:"auto",overflowX:"hidden","&::-webkit-scrollbar":{width:6},"&::-webkit-scrollbar-thumb":{background:"#ffffff52"},"&::-webkit-scrollbar-thumb:hover":{background:"#1de9b6"},"&::-webkit-scrollbar-track":{background:"transparent"}},header:{background:"#1de9b6",fontSize:20,padding:15,lineHeight:"45px"},avatar:{color:"#fff",height:45,width:45},avatarFav:{color:"#fff",height:45,width:45,border:"2px solid gold"},messageAction:{textAlign:"center","&:hover":{color:t.palette.text.main,transition:"color ease-in 0.15s"}},body:{padding:10,height:"77%",display:"flex",flexDirection:"column-reverse",overflowX:"hidden",overflowY:"auto","&::-webkit-scrollbar":{width:6},"&::-webkit-scrollbar-thumb":{background:"#ffffff52"},"&::-webkit-scrollbar-thumb:hover":{background:t.palette.primary.main},"&::-webkit-scrollbar-track":{background:"transparent"}},input:{width:"100%",padding:"0 10px"},textInput:{width:"100%"},submitBtn:{height:"100%",fontSize:30,textAlign:"center",borderBottom:"1px solid rgba(255, 255, 255, 0.7)","&:hover":{borderBottom:"2px solid #fff",color:t.palette.primary.main,transition:"color, border-bottom ease-in 0.15s"}},submitBtnDisabled:{height:"100%",fontSize:30,textAlign:"center",borderBottom:"1px solid rgba(255, 255, 255, 0.7)",filter:"brightness(0.25)"},submitIcon:{display:"block",margin:"auto",height:"100%",width:"40%"},textWrap:{width:"100%",fontSize:16,margin:"20px 0px",color:t.palette.text.light},timestamp:{color:t.palette.text.alt,fontSize:12,marginLeft:5},messageImg:{display:"block",maxWidth:200},copyableText:{color:t.palette.primary.main,textDecoration:"underline","&:hover":{transition:"color ease-in 0.15s",color:t.palette.text.main,cursor:"pointer"}},details:{fontSize:12,color:t.palette.text.alt},username:{color:t.palette.primary.main,fontSize:14},msgText:{padding:20,fontSize:12,display:"block",fontFamily:"monospace",color:t.palette.text.main}}}));const y=(0,o.Ng)(null,{GetMessages:u.GetMessages})((function(t){var e=(0,l.MW)(),r=(0,o.wA)(),i=(0,s.W6)(),u=d(),f=t.match.params.channel;return(0,n.useEffect)((function(){var t=function(){var t,n=(t=h().mark((function t(){return h().wrap((function(t){for(;;)switch(t.prev=t.next){case 0:if(!f){t.next=15;break}return t.prev=1,t.next=4,a.A.send("JoinIRCChannel",f);case 4:return t.next=6,t.sent.json();case 6:t.sent?(r({type:"ADD_DATA",payload:{type:"ircChannels",data:{slug:f,joined:Date.now(),pinned:!1}}}),i.replace("/apps/irc/view/".concat(f)),e("Joined Channel")):(i.goBack(),e("Unable To Join Channel")),t.next=15;break;case 10:t.prev=10,t.t0=t.catch(1),console.log(t.t0),i.goBack(),e("Unable To Join Channel");case 15:case"end":return t.stop()}}),t,null,[[1,10]])})),function(){var e=this,r=arguments;return new Promise((function(n,o){var i=t.apply(e,r);function a(t){p(i,n,o,a,c,"next",t)}function c(t){p(i,n,o,a,c,"throw",t)}a(void 0)}))});return function(){return n.apply(this,arguments)}}();t()}),[f]),n.createElement("div",{className:u.wrapper},n.createElement(c.aH,{text:"Joining Channel"}))}))},13541:t=>{t.exports=function(t){var e=0;function r(t,n){if(!t.fn||"function"!=typeof t.fn)return n;if(!(t.regex&&t.regex instanceof RegExp))return n;if("string"==typeof n){for(var o=t.regex,i=null,a=[];null!==(i=o.exec(n));){var c=i.index,u=i[0];a.push(n.substring(0,c)),a.push(t.fn(++e,i)),n=n.substring(c+u.length,n.length+1),o.lastIndex=0}return a.push(n),a}return Array.isArray(n)?n.map((function(e){return r(t,e)})):n}return function(e){return t&&Array.isArray(t)&&t.length?(t.forEach((function(t){return e=r(t,e)})),e):e}}}}]);
"use strict";(self.webpackChunkhrrp_phone=self.webpackChunkhrrp_phone||[]).push([[3003,142,8322],{142:(t,e,r)=>{r.r(e),r.d(e,{default:()=>s});var n=r(39337),o=r(66525),a=r(50678),i=r(43469),c=r(85193),l=r(79689),u=(0,a.A)((function(t){return{wrapper:{height:"100%",background:t.palette.secondary.main},status:{color:t.palette.success.main,"&::before":{content:'" - "',color:t.palette.text.main},"&.spawned":{color:t.palette.error.main}}}}));const s=function(t){var e,r=t.vehicle,a=u(),s=(0,o.d4)((function(t){return t.data.data.garages})),p=function(){switch(r.Storage.Type){case 0:return s.impound;case 1:return s[r.Storage.Id];case 2:return r.PropertyStorage}}();return n.createElement(i.Ay,{divider:!0,button:!0,component:l.N_,to:"/apps/garage/view/".concat(r.VIN)},n.createElement(c.A,{primary:"".concat(r.Make," ").concat(r.Model),secondary:n.createElement("span",null,null!==(e=null==p?void 0:p.label)&&void 0!==e?e:"Unknown",Boolean(r.Spawned)?n.createElement("span",{className:"".concat(a.status," spawned")},"Out"):n.createElement("span",{className:a.status},0==r.Storage.Type?"In Impound":"In Garage"))}))}},63003:(t,e,r)=>{r.r(e),r.d(e,{default:()=>E});var n=r(39337),o=r(66525),a=r(50678),i=r(42319),c=r(8322),l=r(47143),u=r(25019),s=r(27458),p=r(97463),f=r(65425),h=r(142),d=r(11339),y=r(87448);function m(t){return m="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},m(t)}function v(){v=function(){return e};var t,e={},r=Object.prototype,n=r.hasOwnProperty,o=Object.defineProperty||function(t,e,r){t[e]=r.value},a="function"==typeof Symbol?Symbol:{},i=a.iterator||"@@iterator",c=a.asyncIterator||"@@asyncIterator",l=a.toStringTag||"@@toStringTag";function u(t,e,r){return Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}),t[e]}try{u({},"")}catch(t){u=function(t,e,r){return t[e]=r}}function s(t,e,r,n){var a=e&&e.prototype instanceof b?e:b,i=Object.create(a.prototype),c=new T(n||[]);return o(i,"_invoke",{value:N(t,r,c)}),i}function p(t,e,r){try{return{type:"normal",arg:t.call(e,r)}}catch(t){return{type:"throw",arg:t}}}e.wrap=s;var f="suspendedStart",h="suspendedYield",d="executing",y="completed",g={};function b(){}function w(){}function x(){}var A={};u(A,i,(function(){return this}));var E=Object.getPrototypeOf,k=E&&E(E(C([])));k&&k!==r&&n.call(k,i)&&(A=k);var S=x.prototype=b.prototype=Object.create(A);function L(t){["next","throw","return"].forEach((function(e){u(t,e,(function(t){return this._invoke(e,t)}))}))}function O(t,e){function r(o,a,i,c){var l=p(t[o],t,a);if("throw"!==l.type){var u=l.arg,s=u.value;return s&&"object"==m(s)&&n.call(s,"__await")?e.resolve(s.__await).then((function(t){r("next",t,i,c)}),(function(t){r("throw",t,i,c)})):e.resolve(s).then((function(t){u.value=t,i(u)}),(function(t){return r("throw",t,i,c)}))}c(l.arg)}var a;o(this,"_invoke",{value:function(t,n){function o(){return new e((function(e,o){r(t,n,e,o)}))}return a=a?a.then(o,o):o()}})}function N(e,r,n){var o=f;return function(a,i){if(o===d)throw Error("Generator is already running");if(o===y){if("throw"===a)throw i;return{value:t,done:!0}}for(n.method=a,n.arg=i;;){var c=n.delegate;if(c){var l=_(c,n);if(l){if(l===g)continue;return l}}if("next"===n.method)n.sent=n._sent=n.arg;else if("throw"===n.method){if(o===f)throw o=y,n.arg;n.dispatchException(n.arg)}else"return"===n.method&&n.abrupt("return",n.arg);o=d;var u=p(e,r,n);if("normal"===u.type){if(o=n.done?y:h,u.arg===g)continue;return{value:u.arg,done:n.done}}"throw"===u.type&&(o=y,n.method="throw",n.arg=u.arg)}}}function _(e,r){var n=r.method,o=e.iterator[n];if(o===t)return r.delegate=null,"throw"===n&&e.iterator.return&&(r.method="return",r.arg=t,_(e,r),"throw"===r.method)||"return"!==n&&(r.method="throw",r.arg=new TypeError("The iterator does not provide a '"+n+"' method")),g;var a=p(o,e.iterator,r.arg);if("throw"===a.type)return r.method="throw",r.arg=a.arg,r.delegate=null,g;var i=a.arg;return i?i.done?(r[e.resultName]=i.value,r.next=e.nextLoc,"return"!==r.method&&(r.method="next",r.arg=t),r.delegate=null,g):i:(r.method="throw",r.arg=new TypeError("iterator result is not an object"),r.delegate=null,g)}function I(t){var e={tryLoc:t[0]};1 in t&&(e.catchLoc=t[1]),2 in t&&(e.finallyLoc=t[2],e.afterLoc=t[3]),this.tryEntries.push(e)}function j(t){var e=t.completion||{};e.type="normal",delete e.arg,t.completion=e}function T(t){this.tryEntries=[{tryLoc:"root"}],t.forEach(I,this),this.reset(!0)}function C(e){if(e||""===e){var r=e[i];if(r)return r.call(e);if("function"==typeof e.next)return e;if(!isNaN(e.length)){var o=-1,a=function r(){for(;++o<e.length;)if(n.call(e,o))return r.value=e[o],r.done=!1,r;return r.value=t,r.done=!0,r};return a.next=a}}throw new TypeError(m(e)+" is not iterable")}return w.prototype=x,o(S,"constructor",{value:x,configurable:!0}),o(x,"constructor",{value:w,configurable:!0}),w.displayName=u(x,l,"GeneratorFunction"),e.isGeneratorFunction=function(t){var e="function"==typeof t&&t.constructor;return!!e&&(e===w||"GeneratorFunction"===(e.displayName||e.name))},e.mark=function(t){return Object.setPrototypeOf?Object.setPrototypeOf(t,x):(t.__proto__=x,u(t,l,"GeneratorFunction")),t.prototype=Object.create(S),t},e.awrap=function(t){return{__await:t}},L(O.prototype),u(O.prototype,c,(function(){return this})),e.AsyncIterator=O,e.async=function(t,r,n,o,a){void 0===a&&(a=Promise);var i=new O(s(t,r,n,o),a);return e.isGeneratorFunction(r)?i:i.next().then((function(t){return t.done?t.value:i.next()}))},L(S),u(S,l,"Generator"),u(S,i,(function(){return this})),u(S,"toString",(function(){return"[object Generator]"})),e.keys=function(t){var e=Object(t),r=[];for(var n in e)r.push(n);return r.reverse(),function t(){for(;r.length;){var n=r.pop();if(n in e)return t.value=n,t.done=!1,t}return t.done=!0,t}},e.values=C,T.prototype={constructor:T,reset:function(e){if(this.prev=0,this.next=0,this.sent=this._sent=t,this.done=!1,this.delegate=null,this.method="next",this.arg=t,this.tryEntries.forEach(j),!e)for(var r in this)"t"===r.charAt(0)&&n.call(this,r)&&!isNaN(+r.slice(1))&&(this[r]=t)},stop:function(){this.done=!0;var t=this.tryEntries[0].completion;if("throw"===t.type)throw t.arg;return this.rval},dispatchException:function(e){if(this.done)throw e;var r=this;function o(n,o){return c.type="throw",c.arg=e,r.next=n,o&&(r.method="next",r.arg=t),!!o}for(var a=this.tryEntries.length-1;a>=0;--a){var i=this.tryEntries[a],c=i.completion;if("root"===i.tryLoc)return o("end");if(i.tryLoc<=this.prev){var l=n.call(i,"catchLoc"),u=n.call(i,"finallyLoc");if(l&&u){if(this.prev<i.catchLoc)return o(i.catchLoc,!0);if(this.prev<i.finallyLoc)return o(i.finallyLoc)}else if(l){if(this.prev<i.catchLoc)return o(i.catchLoc,!0)}else{if(!u)throw Error("try statement without catch or finally");if(this.prev<i.finallyLoc)return o(i.finallyLoc)}}}},abrupt:function(t,e){for(var r=this.tryEntries.length-1;r>=0;--r){var o=this.tryEntries[r];if(o.tryLoc<=this.prev&&n.call(o,"finallyLoc")&&this.prev<o.finallyLoc){var a=o;break}}a&&("break"===t||"continue"===t)&&a.tryLoc<=e&&e<=a.finallyLoc&&(a=null);var i=a?a.completion:{};return i.type=t,i.arg=e,a?(this.method="next",this.next=a.finallyLoc,g):this.complete(i)},complete:function(t,e){if("throw"===t.type)throw t.arg;return"break"===t.type||"continue"===t.type?this.next=t.arg:"return"===t.type?(this.rval=this.arg=t.arg,this.method="return",this.next="end"):"normal"===t.type&&e&&(this.next=e),g},finish:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.finallyLoc===t)return this.complete(r.completion,r.afterLoc),j(r),g}},catch:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.tryLoc===t){var n=r.completion;if("throw"===n.type){var o=n.arg;j(r)}return o}}throw Error("illegal catch attempt")},delegateYield:function(e,r,n){return this.delegate={iterator:C(e),resultName:r,nextLoc:n},"next"===this.method&&(this.arg=t),g}},e}function g(t,e,r,n,o,a,i){try{var c=t[a](i),l=c.value}catch(t){return void r(t)}c.done?e(l):Promise.resolve(l).then(n,o)}function b(t){return function(){var e=this,r=arguments;return new Promise((function(n,o){var a=t.apply(e,r);function i(t){g(a,n,o,i,c,"next",t)}function c(t){g(a,n,o,i,c,"throw",t)}i(void 0)}))}}function w(t,e){return function(t){if(Array.isArray(t))return t}(t)||function(t,e){var r=null==t?null:"undefined"!=typeof Symbol&&t[Symbol.iterator]||t["@@iterator"];if(null!=r){var n,o,a,i,c=[],l=!0,u=!1;try{if(a=(r=r.call(t)).next,0===e){if(Object(r)!==r)return;l=!1}else for(;!(l=(n=a.call(r)).done)&&(c.push(n.value),c.length!==e);l=!0);}catch(t){u=!0,o=t}finally{try{if(!l&&null!=r.return&&(i=r.return(),Object(i)!==i))return}finally{if(u)throw o}}return c}}(t,e)||function(t,e){if(t){if("string"==typeof t)return x(t,e);var r={}.toString.call(t).slice(8,-1);return"Object"===r&&t.constructor&&(r=t.constructor.name),"Map"===r||"Set"===r?Array.from(t):"Arguments"===r||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(r)?x(t,e):void 0}}(t,e)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function x(t,e){(null==e||e>t.length)&&(e=t.length);for(var r=0,n=Array(e);r<e;r++)n[r]=t[r];return n}var A=(0,a.A)((function(t){return{wrapper:{height:"100%",background:t.palette.secondary.main},header:{background:"#eb34de",fontSize:20,padding:15,lineHeight:"50px",height:78},headerAction:{},emptyMsg:{width:"100%",textAlign:"center",fontSize:20,fontWeight:"bold",marginTop:"25%"},list:{height:"90%",overflowX:"hidden",overflowY:"auto"}}}));const E=function(t){var e=A(),r=(0,o.wA)(),a=(0,o.d4)((function(t){return t.data.data.myVehicles})),m=w((0,n.useState)(!1),2),g=m[0],x=m[1],E=(0,n.useMemo)((function(){return(0,i.throttle)(b(v().mark((function t(){var e;return v().wrap((function(t){for(;;)switch(t.prev=t.next){case 0:if(!g){t.next=2;break}return t.abrupt("return");case 2:return x(!0),t.prev=3,t.next=6,d.A.send("Garage:GetCars");case 6:return t.next=8,t.sent.json();case 8:e=t.sent,r(e?{type:"SET_DATA",payload:{type:"myVehicles",data:e}}:{type:"SET_DATA",payload:{type:"myVehicles",data:Array()}}),t.next=16;break;case 12:t.prev=12,t.t0=t.catch(3),console.log(t.t0),r({type:"SET_DATA",payload:{type:"myVehicles",data:testVehicles}});case 16:x(!1);case 17:case"end":return t.stop()}}),t,null,[[3,12]])}))),1e3)}),[]);return(0,n.useEffect)((function(){E()}),[]),n.createElement("div",{className:e.wrapper},n.createElement(c.A,{position:"static",className:e.header},n.createElement(l.Ay,{container:!0},n.createElement(l.Ay,{item:!0,xs:7,style:{lineHeight:"50px"}},"Garage"),n.createElement(l.Ay,{item:!0,xs:5,style:{textAlign:"right"}},n.createElement(u.A,{title:"Refresh Garage"},n.createElement("span",null,n.createElement(s.A,{onClick:E,disabled:g,className:e.headerAction},n.createElement(f.g,{className:"fa ".concat(g?"fa-spin":""),icon:["fas","arrows-rotate"]}))))))),g&&n.createElement(y.aH,{static:!0,text:"Loading Garage"}),n.createElement(p.A,{className:e.list},a.map((function(t,e){return n.createElement(h.default,{key:t.VIN,vehicle:t})}))))}},8322:(t,e,r)=>{r.d(e,{A:()=>v});var n=r(82682),o=r(64867),a=r(39337),i=r(37579),c=r(73375),l=r(81808),u=r(43051),s=r(59082),p=r(59187),f=r(94093);function h(t){return(0,f.A)("MuiAppBar",t)}(0,r(84657).A)("MuiAppBar",["root","positionFixed","positionAbsolute","positionSticky","positionStatic","positionRelative","colorDefault","colorPrimary","colorSecondary","colorInherit","colorTransparent"]);var d=r(50493);const y=["className","color","enableColorOnDark","position"],m=(0,l.Ay)(p.A,{name:"MuiAppBar",slot:"Root",overridesResolver:(t,e)=>{const{ownerState:r}=t;return[e.root,e[`position${(0,s.A)(r.position)}`],e[`color${(0,s.A)(r.color)}`]]}})((({theme:t,ownerState:e})=>{const r="light"===t.palette.mode?t.palette.grey[100]:t.palette.grey[900];return(0,o.A)({display:"flex",flexDirection:"column",width:"100%",boxSizing:"border-box",flexShrink:0},"fixed"===e.position&&{position:"fixed",zIndex:t.zIndex.appBar,top:0,left:"auto",right:0,"@media print":{position:"absolute"}},"absolute"===e.position&&{position:"absolute",zIndex:t.zIndex.appBar,top:0,left:"auto",right:0},"sticky"===e.position&&{position:"sticky",zIndex:t.zIndex.appBar,top:0,left:"auto",right:0},"static"===e.position&&{position:"static"},"relative"===e.position&&{position:"relative"},"default"===e.color&&{backgroundColor:r,color:t.palette.getContrastText(r)},e.color&&"default"!==e.color&&"inherit"!==e.color&&"transparent"!==e.color&&{backgroundColor:t.palette[e.color].main,color:t.palette[e.color].contrastText},"inherit"===e.color&&{color:"inherit"},"dark"===t.palette.mode&&!e.enableColorOnDark&&{backgroundColor:null,color:null},"transparent"===e.color&&(0,o.A)({backgroundColor:"transparent",color:"inherit"},"dark"===t.palette.mode&&{backgroundImage:"none"}))})),v=a.forwardRef((function(t,e){const r=(0,u.A)({props:t,name:"MuiAppBar"}),{className:a,color:l="primary",enableColorOnDark:p=!1,position:f="fixed"}=r,v=(0,n.A)(r,y),g=(0,o.A)({},r,{color:l,position:f,enableColorOnDark:p}),b=(t=>{const{color:e,position:r,classes:n}=t,o={root:["root",`color${(0,s.A)(e)}`,`position${(0,s.A)(r)}`]};return(0,c.A)(o,h,n)})(g);return(0,d.jsx)(m,(0,o.A)({square:!0,component:"header",ownerState:g,elevation:4,className:(0,i.A)(b.root,a,"fixed"===f&&"mui-fixed"),ref:e},v))}))}}]);
"use strict";(self.webpackChunkhrrp_laptop=self.webpackChunkhrrp_laptop||[]).push([[3889,5322,2941,84,7703,4846,6270],{26270:(t,e,r)=>{r.r(e),r.d(e,{default:()=>w});var n=r(39337),o=r(66525),i=r(70244),a=r(45731),s=r(29899),c=r(65322),l=r(18946),u=r(65425),f=r(11339),h=r(85367),d=r(23582);function p(t){return p="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},p(t)}function v(){v=function(){return e};var t,e={},r=Object.prototype,n=r.hasOwnProperty,o=Object.defineProperty||function(t,e,r){t[e]=r.value},i="function"==typeof Symbol?Symbol:{},a=i.iterator||"@@iterator",s=i.asyncIterator||"@@asyncIterator",c=i.toStringTag||"@@toStringTag";function l(t,e,r){return Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}),t[e]}try{l({},"")}catch(t){l=function(t,e,r){return t[e]=r}}function u(t,e,r,n){var i=e&&e.prototype instanceof b?e:b,a=Object.create(i.prototype),s=new I(n||[]);return o(a,"_invoke",{value:N(t,r,s)}),a}function f(t,e,r){try{return{type:"normal",arg:t.call(e,r)}}catch(t){return{type:"throw",arg:t}}}e.wrap=u;var h="suspendedStart",d="suspendedYield",y="executing",m="completed",g={};function b(){}function w(){}function E(){}var x={};l(x,a,(function(){return this}));var A=Object.getPrototypeOf,L=A&&A(A(M([])));L&&L!==r&&n.call(L,a)&&(x=L);var S=E.prototype=b.prototype=Object.create(x);function P(t){["next","throw","return"].forEach((function(e){l(t,e,(function(t){return this._invoke(e,t)}))}))}function j(t,e){function r(o,i,a,s){var c=f(t[o],t,i);if("throw"!==c.type){var l=c.arg,u=l.value;return u&&"object"==p(u)&&n.call(u,"__await")?e.resolve(u.__await).then((function(t){r("next",t,a,s)}),(function(t){r("throw",t,a,s)})):e.resolve(u).then((function(t){l.value=t,a(l)}),(function(t){return r("throw",t,a,s)}))}s(c.arg)}var i;o(this,"_invoke",{value:function(t,n){function o(){return new e((function(e,o){r(t,n,e,o)}))}return i=i?i.then(o,o):o()}})}function N(e,r,n){var o=h;return function(i,a){if(o===y)throw Error("Generator is already running");if(o===m){if("throw"===i)throw a;return{value:t,done:!0}}for(n.method=i,n.arg=a;;){var s=n.delegate;if(s){var c=k(s,n);if(c){if(c===g)continue;return c}}if("next"===n.method)n.sent=n._sent=n.arg;else if("throw"===n.method){if(o===h)throw o=m,n.arg;n.dispatchException(n.arg)}else"return"===n.method&&n.abrupt("return",n.arg);o=y;var l=f(e,r,n);if("normal"===l.type){if(o=n.done?m:d,l.arg===g)continue;return{value:l.arg,done:n.done}}"throw"===l.type&&(o=m,n.method="throw",n.arg=l.arg)}}}function k(e,r){var n=r.method,o=e.iterator[n];if(o===t)return r.delegate=null,"throw"===n&&e.iterator.return&&(r.method="return",r.arg=t,k(e,r),"throw"===r.method)||"return"!==n&&(r.method="throw",r.arg=new TypeError("The iterator does not provide a '"+n+"' method")),g;var i=f(o,e.iterator,r.arg);if("throw"===i.type)return r.method="throw",r.arg=i.arg,r.delegate=null,g;var a=i.arg;return a?a.done?(r[e.resultName]=a.value,r.next=e.nextLoc,"return"!==r.method&&(r.method="next",r.arg=t),r.delegate=null,g):a:(r.method="throw",r.arg=new TypeError("iterator result is not an object"),r.delegate=null,g)}function O(t){var e={tryLoc:t[0]};1 in t&&(e.catchLoc=t[1]),2 in t&&(e.finallyLoc=t[2],e.afterLoc=t[3]),this.tryEntries.push(e)}function _(t){var e=t.completion||{};e.type="normal",delete e.arg,t.completion=e}function I(t){this.tryEntries=[{tryLoc:"root"}],t.forEach(O,this),this.reset(!0)}function M(e){if(e||""===e){var r=e[a];if(r)return r.call(e);if("function"==typeof e.next)return e;if(!isNaN(e.length)){var o=-1,i=function r(){for(;++o<e.length;)if(n.call(e,o))return r.value=e[o],r.done=!1,r;return r.value=t,r.done=!0,r};return i.next=i}}throw new TypeError(p(e)+" is not iterable")}return w.prototype=E,o(S,"constructor",{value:E,configurable:!0}),o(E,"constructor",{value:w,configurable:!0}),w.displayName=l(E,c,"GeneratorFunction"),e.isGeneratorFunction=function(t){var e="function"==typeof t&&t.constructor;return!!e&&(e===w||"GeneratorFunction"===(e.displayName||e.name))},e.mark=function(t){return Object.setPrototypeOf?Object.setPrototypeOf(t,E):(t.__proto__=E,l(t,c,"GeneratorFunction")),t.prototype=Object.create(S),t},e.awrap=function(t){return{__await:t}},P(j.prototype),l(j.prototype,s,(function(){return this})),e.AsyncIterator=j,e.async=function(t,r,n,o,i){void 0===i&&(i=Promise);var a=new j(u(t,r,n,o),i);return e.isGeneratorFunction(r)?a:a.next().then((function(t){return t.done?t.value:a.next()}))},P(S),l(S,c,"Generator"),l(S,a,(function(){return this})),l(S,"toString",(function(){return"[object Generator]"})),e.keys=function(t){var e=Object(t),r=[];for(var n in e)r.push(n);return r.reverse(),function t(){for(;r.length;){var n=r.pop();if(n in e)return t.value=n,t.done=!1,t}return t.done=!0,t}},e.values=M,I.prototype={constructor:I,reset:function(e){if(this.prev=0,this.next=0,this.sent=this._sent=t,this.done=!1,this.delegate=null,this.method="next",this.arg=t,this.tryEntries.forEach(_),!e)for(var r in this)"t"===r.charAt(0)&&n.call(this,r)&&!isNaN(+r.slice(1))&&(this[r]=t)},stop:function(){this.done=!0;var t=this.tryEntries[0].completion;if("throw"===t.type)throw t.arg;return this.rval},dispatchException:function(e){if(this.done)throw e;var r=this;function o(n,o){return s.type="throw",s.arg=e,r.next=n,o&&(r.method="next",r.arg=t),!!o}for(var i=this.tryEntries.length-1;i>=0;--i){var a=this.tryEntries[i],s=a.completion;if("root"===a.tryLoc)return o("end");if(a.tryLoc<=this.prev){var c=n.call(a,"catchLoc"),l=n.call(a,"finallyLoc");if(c&&l){if(this.prev<a.catchLoc)return o(a.catchLoc,!0);if(this.prev<a.finallyLoc)return o(a.finallyLoc)}else if(c){if(this.prev<a.catchLoc)return o(a.catchLoc,!0)}else{if(!l)throw Error("try statement without catch or finally");if(this.prev<a.finallyLoc)return o(a.finallyLoc)}}}},abrupt:function(t,e){for(var r=this.tryEntries.length-1;r>=0;--r){var o=this.tryEntries[r];if(o.tryLoc<=this.prev&&n.call(o,"finallyLoc")&&this.prev<o.finallyLoc){var i=o;break}}i&&("break"===t||"continue"===t)&&i.tryLoc<=e&&e<=i.finallyLoc&&(i=null);var a=i?i.completion:{};return a.type=t,a.arg=e,i?(this.method="next",this.next=i.finallyLoc,g):this.complete(a)},complete:function(t,e){if("throw"===t.type)throw t.arg;return"break"===t.type||"continue"===t.type?this.next=t.arg:"return"===t.type?(this.rval=this.arg=t.arg,this.method="return",this.next="end"):"normal"===t.type&&e&&(this.next=e),g},finish:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.finallyLoc===t)return this.complete(r.completion,r.afterLoc),_(r),g}},catch:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.tryLoc===t){var n=r.completion;if("throw"===n.type){var o=n.arg;_(r)}return o}}throw Error("illegal catch attempt")},delegateYield:function(e,r,n){return this.delegate={iterator:M(e),resultName:r,nextLoc:n},"next"===this.method&&(this.arg=t),g}},e}function y(t,e,r,n,o,i,a){try{var s=t[i](a),c=s.value}catch(t){return void r(t)}s.done?e(c):Promise.resolve(c).then(n,o)}function m(t,e){return function(t){if(Array.isArray(t))return t}(t)||function(t,e){var r=null==t?null:"undefined"!=typeof Symbol&&t[Symbol.iterator]||t["@@iterator"];if(null!=r){var n,o,i,a,s=[],c=!0,l=!1;try{if(i=(r=r.call(t)).next,0===e){if(Object(r)!==r)return;c=!1}else for(;!(c=(n=i.call(r)).done)&&(s.push(n.value),s.length!==e);c=!0);}catch(t){l=!0,o=t}finally{try{if(!c&&null!=r.return&&(a=r.return(),Object(a)!==a))return}finally{if(l)throw o}}return s}}(t,e)||function(t,e){if(t){if("string"==typeof t)return g(t,e);var r={}.toString.call(t).slice(8,-1);return"Object"===r&&t.constructor&&(r=t.constructor.name),"Map"===r||"Set"===r?Array.from(t):"Arguments"===r||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(r)?g(t,e):void 0}}(t,e)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function g(t,e){(null==e||e>t.length)&&(e=t.length);for(var r=0,n=Array(e);r<e;r++)n[r]=t[r];return n}var b=(0,l.A)((function(t){return{wrapper:{padding:"20px 10px 20px 20px",height:"100%"},search:{height:"10%"},results:{height:"90%"},items:{maxHeight:"95%",height:"95%",overflowY:"auto",overflowX:"hidden"},empty:{display:"flex",flexDirection:"row",alignItems:"center",justifyContent:"center",width:"100%",height:"60%",textAlign:"center"}}}));const w=function(){var t=b(),e=((0,o.d4)((function(t){return t.data.data.onDuty})),m((0,n.useState)(""),2)),r=e[0],l=e[1],p=m((0,n.useState)(!1),2),g=p[0],w=p[1],E=m((0,n.useState)(!1),2),x=E[0],A=E[1],L=m((0,n.useState)(Array()),2),S=L[0],P=L[1],j=m((0,n.useState)(Array()),2),N=j[0],k=j[1];(0,n.useEffect)((function(){O()}),[]);var O=function(){var t,e=(t=v().mark((function t(){var e;return v().wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return w(!0),t.prev=1,t.next=4,f.A.send("ViewVehicleFleet",{});case 4:return t.next=6,t.sent.json();case 6:(e=t.sent)?P(e):A(!0),w(!1),t.next=16;break;case 11:t.prev=11,t.t0=t.catch(1),console.log(t.t0),A(!0),w(!1);case 16:case"end":return t.stop()}}),t,null,[[1,11]])})),function(){var e=this,r=arguments;return new Promise((function(n,o){var i=t.apply(e,r);function a(t){y(i,n,o,a,s,"next",t)}function s(t){y(i,n,o,a,s,"throw",t)}a(void 0)}))});return function(){return e.apply(this,arguments)}}();(0,n.useEffect)((function(){k(S.filter((function(t){return t.VIN.toLowerCase().includes(r.toLowerCase())||t.RegisteredPlate.toLowerCase().includes(r.toLowerCase())||"".concat(t.Make," ").concat(t.Model).toLowerCase().includes(r.toLowerCase())})))}),[S,r]);return n.createElement("div",{className:t.wrapper},n.createElement("div",{className:t.search},n.createElement("form",{onSubmit:function(t){t.preventDefault()}},n.createElement(i.A,{fullWidth:!0,variant:"outlined",name:"search",value:r,onChange:function(t){return l(t.target.value)},error:x,helperText:x?"Error Performing Search":null,label:"Search By Plate, VIN or Make/Model",InputProps:{endAdornment:n.createElement(a.A,{position:"end"},""!=r&&n.createElement(s.A,{type:"button",onClick:function(){l("")}},n.createElement(u.g,{icon:["fas","xmark"]})))}}))),n.createElement("div",{className:t.results},g?n.createElement(h.aH,{text:"Loading"}):n.createElement(n.Fragment,null,n.createElement(c.A,{className:t.items},0==S.length&&n.createElement("div",{className:t.empty},n.createElement("h2",null,"This Business Has No Fleet Vehicles")),N.sort((function(t,e){return t.RegistrationDate-e.RegistrationDate})).map((function(t){return n.createElement(d.default,{key:t.VIN,vehicle:t})}))))))}},45731:(t,e,r)=>{r.d(e,{A:()=>x});var n=r(82682),o=r(64867),i=r(39337),a=r(13526),s=r(21003),c=r(83163),l=r(86796),u=r(25077),f=r(5701),h=r(44639),d=r(79629),p=r(21329);function v(t){return(0,p.Ay)("MuiInputAdornment",t)}const y=(0,d.A)("MuiInputAdornment",["root","filled","standard","outlined","positionStart","positionEnd","disablePointerEvents","hiddenLabel","sizeSmall"]);var m,g=r(58710),b=r(50493);const w=["children","className","component","disablePointerEvents","disableTypography","position","variant"],E=(0,h.Ay)("div",{name:"MuiInputAdornment",slot:"Root",overridesResolver:(t,e)=>{const{ownerState:r}=t;return[e.root,e[`position${(0,c.A)(r.position)}`],!0===r.disablePointerEvents&&e.disablePointerEvents,e[r.variant]]}})((({theme:t,ownerState:e})=>(0,o.A)({display:"flex",height:"0.01em",maxHeight:"2em",alignItems:"center",whiteSpace:"nowrap",color:(t.vars||t).palette.action.active},"filled"===e.variant&&{[`&.${y.positionStart}&:not(.${y.hiddenLabel})`]:{marginTop:16}},"start"===e.position&&{marginRight:8},"end"===e.position&&{marginLeft:8},!0===e.disablePointerEvents&&{pointerEvents:"none"}))),x=i.forwardRef((function(t,e){const r=(0,g.b)({props:t,name:"MuiInputAdornment"}),{children:h,className:d,component:p="div",disablePointerEvents:y=!1,disableTypography:x=!1,position:A,variant:L}=r,S=(0,n.A)(r,w),P=(0,f.A)()||{};let j=L;L&&P.variant,P&&!j&&(j=P.variant);const N=(0,o.A)({},r,{hiddenLabel:P.hiddenLabel,size:P.size,disablePointerEvents:y,position:A,variant:j}),k=(t=>{const{classes:e,disablePointerEvents:r,hiddenLabel:n,position:o,size:i,variant:a}=t,l={root:["root",r&&"disablePointerEvents",o&&`position${(0,c.A)(o)}`,a,n&&"hiddenLabel",i&&`size${(0,c.A)(i)}`]};return(0,s.A)(l,v,e)})(N);return(0,b.jsx)(u.A.Provider,{value:null,children:(0,b.jsx)(E,(0,o.A)({as:p,ownerState:N,className:(0,a.A)(k.root,d),ref:e},S,{children:"string"!=typeof h||x?(0,b.jsxs)(i.Fragment,{children:["start"===A?m||(m=(0,b.jsx)("span",{className:"notranslate",children:"​"})):null,h]}):(0,b.jsx)(l.A,{color:"text.secondary",children:h})}))})}))},65322:(t,e,r)=>{r.d(e,{A:()=>m});var n=r(82682),o=r(64867),i=r(39337),a=r(13526),s=r(21003),c=r(44639),l=r(58710),u=r(97931),f=r(79629),h=r(21329);function d(t){return(0,h.Ay)("MuiList",t)}(0,f.A)("MuiList",["root","padding","dense","subheader"]);var p=r(50493);const v=["children","className","component","dense","disablePadding","subheader"],y=(0,c.Ay)("ul",{name:"MuiList",slot:"Root",overridesResolver:(t,e)=>{const{ownerState:r}=t;return[e.root,!r.disablePadding&&e.padding,r.dense&&e.dense,r.subheader&&e.subheader]}})((({ownerState:t})=>(0,o.A)({listStyle:"none",margin:0,padding:0,position:"relative"},!t.disablePadding&&{paddingTop:8,paddingBottom:8},t.subheader&&{paddingTop:0}))),m=i.forwardRef((function(t,e){const r=(0,l.b)({props:t,name:"MuiList"}),{children:c,className:f,component:h="ul",dense:m=!1,disablePadding:g=!1,subheader:b}=r,w=(0,n.A)(r,v),E=i.useMemo((()=>({dense:m})),[m]),x=(0,o.A)({},r,{component:h,dense:m,disablePadding:g}),A=(t=>{const{classes:e,disablePadding:r,dense:n,subheader:o}=t,i={root:["root",!r&&"padding",n&&"dense",o&&"subheader"]};return(0,s.A)(i,d,e)})(x);return(0,p.jsx)(u.A.Provider,{value:E,children:(0,p.jsxs)(y,(0,o.A)({as:h,className:(0,a.A)(A.root,f),ref:e,ownerState:x},w,{children:[b,c]}))})}))}}]);
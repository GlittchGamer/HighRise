"use strict";(self.webpackChunkhrrp_laptop=self.webpackChunkhrrp_laptop||[]).push([[5874],{75874:(t,e,r)=>{r.r(e),r.d(e,{default:()=>O});var n=r(39337),o=r(66525),a=r(18946),i=r(95066),c=r(72031),l=r(96591),u=r(70244),s=(r(65425),r(76487)),f=r.n(s),h=r(11339),p=r(43514),y=r(54986);function m(t){return m="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},m(t)}function d(){d=function(){return e};var t,e={},r=Object.prototype,n=r.hasOwnProperty,o=Object.defineProperty||function(t,e,r){t[e]=r.value},a="function"==typeof Symbol?Symbol:{},i=a.iterator||"@@iterator",c=a.asyncIterator||"@@asyncIterator",l=a.toStringTag||"@@toStringTag";function u(t,e,r){return Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}),t[e]}try{u({},"")}catch(t){u=function(t,e,r){return t[e]=r}}function s(t,e,r,n){var a=e&&e.prototype instanceof b?e:b,i=Object.create(a.prototype),c=new _(n||[]);return o(i,"_invoke",{value:P(t,r,c)}),i}function f(t,e,r){try{return{type:"normal",arg:t.call(e,r)}}catch(t){return{type:"throw",arg:t}}}e.wrap=s;var h="suspendedStart",p="suspendedYield",y="executing",v="completed",g={};function b(){}function w(){}function E(){}var x={};u(x,i,(function(){return this}));var A=Object.getPrototypeOf,O=A&&A(A(C([])));O&&O!==r&&n.call(O,i)&&(x=O);var L=E.prototype=b.prototype=Object.create(x);function j(t){["next","throw","return"].forEach((function(e){u(t,e,(function(t){return this._invoke(e,t)}))}))}function S(t,e){function r(o,a,i,c){var l=f(t[o],t,a);if("throw"!==l.type){var u=l.arg,s=u.value;return s&&"object"==m(s)&&n.call(s,"__await")?e.resolve(s.__await).then((function(t){r("next",t,i,c)}),(function(t){r("throw",t,i,c)})):e.resolve(s).then((function(t){u.value=t,i(u)}),(function(t){return r("throw",t,i,c)}))}c(l.arg)}var a;o(this,"_invoke",{value:function(t,n){function o(){return new e((function(e,o){r(t,n,e,o)}))}return a=a?a.then(o,o):o()}})}function P(e,r,n){var o=h;return function(a,i){if(o===y)throw Error("Generator is already running");if(o===v){if("throw"===a)throw i;return{value:t,done:!0}}for(n.method=a,n.arg=i;;){var c=n.delegate;if(c){var l=k(c,n);if(l){if(l===g)continue;return l}}if("next"===n.method)n.sent=n._sent=n.arg;else if("throw"===n.method){if(o===h)throw o=v,n.arg;n.dispatchException(n.arg)}else"return"===n.method&&n.abrupt("return",n.arg);o=y;var u=f(e,r,n);if("normal"===u.type){if(o=n.done?v:p,u.arg===g)continue;return{value:u.arg,done:n.done}}"throw"===u.type&&(o=v,n.method="throw",n.arg=u.arg)}}}function k(e,r){var n=r.method,o=e.iterator[n];if(o===t)return r.delegate=null,"throw"===n&&e.iterator.return&&(r.method="return",r.arg=t,k(e,r),"throw"===r.method)||"return"!==n&&(r.method="throw",r.arg=new TypeError("The iterator does not provide a '"+n+"' method")),g;var a=f(o,e.iterator,r.arg);if("throw"===a.type)return r.method="throw",r.arg=a.arg,r.delegate=null,g;var i=a.arg;return i?i.done?(r[e.resultName]=i.value,r.next=e.nextLoc,"return"!==r.method&&(r.method="next",r.arg=t),r.delegate=null,g):i:(r.method="throw",r.arg=new TypeError("iterator result is not an object"),r.delegate=null,g)}function N(t){var e={tryLoc:t[0]};1 in t&&(e.catchLoc=t[1]),2 in t&&(e.finallyLoc=t[2],e.afterLoc=t[3]),this.tryEntries.push(e)}function T(t){var e=t.completion||{};e.type="normal",delete e.arg,t.completion=e}function _(t){this.tryEntries=[{tryLoc:"root"}],t.forEach(N,this),this.reset(!0)}function C(e){if(e||""===e){var r=e[i];if(r)return r.call(e);if("function"==typeof e.next)return e;if(!isNaN(e.length)){var o=-1,a=function r(){for(;++o<e.length;)if(n.call(e,o))return r.value=e[o],r.done=!1,r;return r.value=t,r.done=!0,r};return a.next=a}}throw new TypeError(m(e)+" is not iterable")}return w.prototype=E,o(L,"constructor",{value:E,configurable:!0}),o(E,"constructor",{value:w,configurable:!0}),w.displayName=u(E,l,"GeneratorFunction"),e.isGeneratorFunction=function(t){var e="function"==typeof t&&t.constructor;return!!e&&(e===w||"GeneratorFunction"===(e.displayName||e.name))},e.mark=function(t){return Object.setPrototypeOf?Object.setPrototypeOf(t,E):(t.__proto__=E,u(t,l,"GeneratorFunction")),t.prototype=Object.create(L),t},e.awrap=function(t){return{__await:t}},j(S.prototype),u(S.prototype,c,(function(){return this})),e.AsyncIterator=S,e.async=function(t,r,n,o,a){void 0===a&&(a=Promise);var i=new S(s(t,r,n,o),a);return e.isGeneratorFunction(r)?i:i.next().then((function(t){return t.done?t.value:i.next()}))},j(L),u(L,l,"Generator"),u(L,i,(function(){return this})),u(L,"toString",(function(){return"[object Generator]"})),e.keys=function(t){var e=Object(t),r=[];for(var n in e)r.push(n);return r.reverse(),function t(){for(;r.length;){var n=r.pop();if(n in e)return t.value=n,t.done=!1,t}return t.done=!0,t}},e.values=C,_.prototype={constructor:_,reset:function(e){if(this.prev=0,this.next=0,this.sent=this._sent=t,this.done=!1,this.delegate=null,this.method="next",this.arg=t,this.tryEntries.forEach(T),!e)for(var r in this)"t"===r.charAt(0)&&n.call(this,r)&&!isNaN(+r.slice(1))&&(this[r]=t)},stop:function(){this.done=!0;var t=this.tryEntries[0].completion;if("throw"===t.type)throw t.arg;return this.rval},dispatchException:function(e){if(this.done)throw e;var r=this;function o(n,o){return c.type="throw",c.arg=e,r.next=n,o&&(r.method="next",r.arg=t),!!o}for(var a=this.tryEntries.length-1;a>=0;--a){var i=this.tryEntries[a],c=i.completion;if("root"===i.tryLoc)return o("end");if(i.tryLoc<=this.prev){var l=n.call(i,"catchLoc"),u=n.call(i,"finallyLoc");if(l&&u){if(this.prev<i.catchLoc)return o(i.catchLoc,!0);if(this.prev<i.finallyLoc)return o(i.finallyLoc)}else if(l){if(this.prev<i.catchLoc)return o(i.catchLoc,!0)}else{if(!u)throw Error("try statement without catch or finally");if(this.prev<i.finallyLoc)return o(i.finallyLoc)}}}},abrupt:function(t,e){for(var r=this.tryEntries.length-1;r>=0;--r){var o=this.tryEntries[r];if(o.tryLoc<=this.prev&&n.call(o,"finallyLoc")&&this.prev<o.finallyLoc){var a=o;break}}a&&("break"===t||"continue"===t)&&a.tryLoc<=e&&e<=a.finallyLoc&&(a=null);var i=a?a.completion:{};return i.type=t,i.arg=e,a?(this.method="next",this.next=a.finallyLoc,g):this.complete(i)},complete:function(t,e){if("throw"===t.type)throw t.arg;return"break"===t.type||"continue"===t.type?this.next=t.arg:"return"===t.type?(this.rval=this.arg=t.arg,this.method="return",this.next="end"):"normal"===t.type&&e&&(this.next=e),g},finish:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.finallyLoc===t)return this.complete(r.completion,r.afterLoc),T(r),g}},catch:function(t){for(var e=this.tryEntries.length-1;e>=0;--e){var r=this.tryEntries[e];if(r.tryLoc===t){var n=r.completion;if("throw"===n.type){var o=n.arg;T(r)}return o}}throw Error("illegal catch attempt")},delegateYield:function(e,r,n){return this.delegate={iterator:C(e),resultName:r,nextLoc:n},"next"===this.method&&(this.arg=t),g}},e}function v(t,e){var r=Object.keys(t);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(t);e&&(n=n.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),r.push.apply(r,n)}return r}function g(t){for(var e=1;e<arguments.length;e++){var r=null!=arguments[e]?arguments[e]:{};e%2?v(Object(r),!0).forEach((function(e){b(t,e,r[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(r)):v(Object(r)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(r,e))}))}return t}function b(t,e,r){return(e=function(t){var e=function(t,e){if("object"!=m(t)||!t)return t;var r=t[Symbol.toPrimitive];if(void 0!==r){var n=r.call(t,e||"default");if("object"!=m(n))return n;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===e?String:Number)(t)}(t,"string");return"symbol"==m(e)?e:e+""}(e))in t?Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}):t[e]=r,t}function w(t,e,r,n,o,a,i){try{var c=t[a](i),l=c.value}catch(t){return void r(t)}c.done?e(l):Promise.resolve(l).then(n,o)}function E(t,e){return function(t){if(Array.isArray(t))return t}(t)||function(t,e){var r=null==t?null:"undefined"!=typeof Symbol&&t[Symbol.iterator]||t["@@iterator"];if(null!=r){var n,o,a,i,c=[],l=!0,u=!1;try{if(a=(r=r.call(t)).next,0===e){if(Object(r)!==r)return;l=!1}else for(;!(l=(n=a.call(r)).done)&&(c.push(n.value),c.length!==e);l=!0);}catch(t){u=!0,o=t}finally{try{if(!l&&null!=r.return&&(i=r.return(),Object(i)!==i))return}finally{if(u)throw o}}return c}}(t,e)||function(t,e){if(t){if("string"==typeof t)return x(t,e);var r={}.toString.call(t).slice(8,-1);return"Object"===r&&t.constructor&&(r=t.constructor.name),"Map"===r||"Set"===r?Array.from(t):"Arguments"===r||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(r)?x(t,e):void 0}}(t,e)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}()}function x(t,e){(null==e||e>t.length)&&(e=t.length);for(var r=0,n=Array(e);r<e;r++)n[r]=t[r];return n}var A=(0,a.A)((function(t){return{contract:{padding:10,background:t.palette.secondary.dark,border:"1px solid ".concat(t.palette.border.divider),textAlign:"center","&:not(:last-of-type)":{marginBottom:10}},contractClass:{width:80,height:80,margin:"auto",marginBottom:15},vehicleLabel:{fontSize:18,color:t.palette.text.main},contractOwner:{fontSize:14,color:t.palette.text.alt},contractPrice:{fontSize:14,color:t.palette.success.main,"& small":{marginLeft:4,"&::before":{content:'"("',marginRight:2},"&::after":{content:'")"',marginLeft:2}}},contractExpiration:{fontSize:12}}}));const O=function(t){var e=t.contract,r=t.repLevel,a=A(),s=((0,o.wA)(),(0,p.MW)()),m=(0,o.d4)((function(t){return t.data.data.disabledBoostingContracts})),v=E((0,n.useState)(!1),2),b=v[0],x=v[1],O=E((0,n.useState)(!1),2),L=O[0],j=O[1],S=E((0,n.useState)(0),2),P=S[0],k=S[1],N=function(){var t,e=(t=d().mark((function t(e,r){var n;return d().wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return j(!0),x(!1),t.prev=2,t.next=5,h.A.send("Boosting:AcceptContract",g(g({},e),{},{scratch:r}));case 5:return t.next=7,t.sent.json();case 7:null!=(n=t.sent)&&n.success?s("Request Sent to Team Leader"):null!=n&&n.message?s(n.message):s("Failed to Accept Contract"),t.next=14;break;case 11:t.prev=11,t.t0=t.catch(2),console.log(t.t0);case 14:j(!1);case 15:case"end":return t.stop()}}),t,null,[[2,11]])})),function(){var e=this,r=arguments;return new Promise((function(n,o){var a=t.apply(e,r);function i(t){w(a,n,o,i,c,"next",t)}function c(t){w(a,n,o,i,c,"throw",t)}i(void 0)}))});return function(t,r){return e.apply(this,arguments)}}(),T=null==m?void 0:m.includes(e.id),_=r<e.vehicle.classLevel&&!e.vehicle.rewarded;return n.createElement(i.Ay,{item:!0,xs:2},n.createElement(i.Ay,{container:!0,className:a.contract},n.createElement(i.Ay,{item:!0,xs:12},n.createElement(c.A,{className:"".concat(a.contractClass," ").concat(e.vehicle.class)},e.vehicle.class)),n.createElement(i.Ay,{item:!0,xs:12,className:a.vehicleLabel},e.vehicle.label),n.createElement(i.Ay,{item:!0,xs:12,className:a.contractOwner},e.owner.Alias),n.createElement(i.Ay,{item:!0,xs:12,className:a.contractPrice},n.createElement("span",null,e.prices.standard.price," $",e.prices.standard.coin),Boolean(e.prices.scratch)&&n.createElement("small",null,e.prices.scratch.price," $",e.prices.scratch.coin)),n.createElement(i.Ay,{item:!0,xs:12,className:a.contractExpiration},"Expires: ",n.createElement(f(),{fromNow:!0,unix:!0,date:e.expires})),b?n.createElement(n.Fragment,null,n.createElement(i.Ay,{item:!0,xs:12,style:{marginTop:15}},n.createElement(y.A,{fullWidth:!0,required:!0,label:"Your Bid ".concat(e.prices.standard.coin),name:"bid",className:a.editorField,value:P,onChange:function(t){return k(t.target.value)},type:"tel",isNumericString:!0,customInput:u.A})),Boolean(e.prices.scratch)&&n.createElement(i.Ay,{item:!0,xs:12,style:{marginTop:15}},n.createElement(l.A,{fullWidth:!0,variant:"contained",color:"warning",onClick:function(){return N(e,!1)}},"VIN Scratch (",e.prices.scratch.price," ","$",e.prices.scratch.coin,")")),n.createElement(i.Ay,{item:!0,xs:12,style:{marginTop:15}},n.createElement(l.A,{fullWidth:!0,variant:"contained",color:"error",onClick:function(){return x(!1)}},"Cancel"))):n.createElement(n.Fragment,null,n.createElement(i.Ay,{item:!0,xs:12,style:{marginTop:15}},n.createElement(l.A,{fullWidth:!0,variant:"contained",color:"success",onClick:function(){return x(!0)},disabled:T||L||_},"Place Your Bid")),n.createElement(i.Ay,{item:!0,xs:12,style:{marginTop:15}},n.createElement(l.A,{fullWidth:!0,variant:"contained",color:"warning",disabled:T||L},"Transfer Contract")),n.createElement(i.Ay,{item:!0,xs:12,style:{marginTop:15}},n.createElement(l.A,{fullWidth:!0,variant:"contained",color:"info",disabled:T||L},"List On Market")),n.createElement(i.Ay,{item:!0,xs:12,style:{marginTop:15}},n.createElement(l.A,{fullWidth:!0,variant:"contained",color:"error",disabled:T||L},"Delist Contract")))))}}}]);
"use strict";(self.webpackChunkhrrp_phone=self.webpackChunkhrrp_phone||[]).push([[1812],{1812:(e,t,n)=>{n.r(t),n.d(t,{DeleteEmail:()=>l,GPSRoute:()=>p,Hyperlink:()=>f,ReadEmail:()=>a});var r=n(11339);function o(e){return o="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},o(e)}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function c(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){u(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function u(e,t,n){return(t=function(e){var t=function(e,t){if("object"!=o(e)||!e)return e;var n=e[Symbol.toPrimitive];if(void 0!==n){var r=n.call(e,t||"default");if("object"!=o(r))return r;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===t?String:Number)(e)}(e,"string");return"symbol"==o(t)?t:t+""}(t))in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}var a=function(e){return function(t){r.A.send("ReadEmail",e._id).then((function(n){t({type:"UPDATE_DATA",payload:{type:"emails",id:e._id,data:c(c({},e),{},{unread:!1})}})})).catch((function(e){}))}},l=function(e){return function(t){r.A.send("DeleteEmail",e).then((function(){return t({type:"REMOVE_DATA",payload:{type:"emails",id:e}}),!0})).catch((function(e){return!1}))}},p=function(e,t){return function(n){r.A.send("GPSRoute",{id:e,location:t}).then((function(e){n({type:"ALERT_SHOW",payload:{alert:"GPS Marked"}})})).catch((function(e){n({type:"ALERT_SHOW",payload:{alert:"Unable To Mark Location On GPS"}})}))}},f=function(e,t){return function(n){r.A.send("Hyperlink",{id:e,hyperlink:t}).catch((function(e){n({type:"ALERT_SHOW",payload:{alert:"Unable To Open Hyperlink"}})}))}}}}]);
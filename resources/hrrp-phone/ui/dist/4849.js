"use strict";(self.webpackChunkhrrp_phone=self.webpackChunkhrrp_phone||[]).push([[4849],{24849:(t,e,n)=>{n.r(e),n.d(e,{BumpAdvert:()=>b,CreateAdvert:()=>f,DeleteAdvert:()=>a,UpdateAdvert:()=>p});var r=n(11339);function o(t){return o="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},o(t)}function c(t,e){var n=Object.keys(t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(t);e&&(r=r.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),n.push.apply(n,r)}return n}function i(t){for(var e=1;e<arguments.length;e++){var n=null!=arguments[e]?arguments[e]:{};e%2?c(Object(n),!0).forEach((function(e){u(t,e,n[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(n)):c(Object(n)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(n,e))}))}return t}function u(t,e,n){return(e=function(t){var e=function(t,e){if("object"!=o(t)||!t)return t;var n=t[Symbol.toPrimitive];if(void 0!==n){var r=n.call(t,e||"default");if("object"!=o(r))return r;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===e?String:Number)(t)}(t,"string");return"symbol"==o(e)?e:e+""}(e))in t?Object.defineProperty(t,e,{value:n,enumerable:!0,configurable:!0,writable:!0}):t[e]=n,t}var f=function(t,e,n){return function(t){r.A.send("CreateAdvert",e).then((function(t){n()})).catch((function(t){}))}},p=function(t,e,n){return function(t){r.A.send("UpdateAdvert",e).then((function(t){n()})).catch((function(t){}))}},a=function(t,e){return function(t){r.A.send("DeleteAdvert").then((function(t){e()})).catch((function(t){}))}},b=function(t,e,n){return function(t){r.A.send("UpdateAdvert",i(i({},e),{},{time:Date.now()})).then((function(t){n()})).catch((function(t){n()}))}}}}]);
"use strict";(self.webpackChunkhrrp_phone=self.webpackChunkhrrp_phone||[]).push([[9291],{39291:(e,t,n)=>{n.r(t),n.d(t,{default:()=>p});var o=n(39337),r=n(66525),a=n(97463),i=n(50678),c=(n(65425),n(87448),n(43193)),l=(0,i.A)((function(e){return{wrapper:{height:"100%",background:e.palette.secondary.main},header:{background:"#61112b",fontSize:20,padding:15,lineHeight:"45px",height:78},headerAction:{textAlign:"right","&:hover":{color:e.palette.text.main,transition:"color ease-in 0.15s"}},body:{padding:10},emptyMsg:{width:"100%",textAlign:"center",fontSize:20,fontWeight:"bold",marginTop:"25%"},list:{position:"inherit"}}}));const p=function(e){var t=e.coins,n=(e.loading,l()),i=(0,r.d4)((function(e){return e.data.data.player})),p=Boolean(t)&&Boolean(i.Crypto)?t.filter((function(e){return Boolean(i.Crypto[e.Short])})):Array();return o.createElement("div",{className:n.body},Boolean(p)&&Object.keys(p).length>0?o.createElement(a.A,{className:n.list},Object.keys(i.Crypto).map((function(e){return o.createElement(c.default,{key:"coin-".concat(e),coin:t.filter((function(t){return t.Short==e}))[0],owned:{Short:e,Quantity:i.Crypto[e]}})}))):o.createElement("div",{className:n.emptyMsg},"You Don't Own Any Crypto"))}}}]);
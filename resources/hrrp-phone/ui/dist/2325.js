"use strict";(self.webpackChunkhrrp_phone=self.webpackChunkhrrp_phone||[]).push([[2325,5228],{72325:(e,a,t)=>{t.r(a),t.d(a,{default:()=>g});var n=t(39337),o=t(66525),i=t(59187),r=t(47143),l=t(50566),s=t(75228),d=t(95155),c=t(50678),p=t(65425),u=t(878),m=t(69122);const f={50:"#fffde7",100:"#fff9c4",200:"#fff59d",300:"#fff176",400:"#ffee58",500:"#ffeb3b",600:"#fdd835",700:"#fbc02d",800:"#f9a825",900:"#f57f17",A100:"#ffff8d",A200:"#ffff00",A400:"#ffea00",A700:"#ffd600"};var b=t(32863),h=(0,c.A)((function(e){return{wrapper:{background:e.palette.secondary.dark,padding:"25px 12px",marginBottom:5,width:"100%","&::last-child":{marginBottom:0}},appIcon:{height:55,width:55,fontSize:35,color:"#fff"},appText:{paddingLeft:10},appTitle:{display:"block",fontSize:20,fontWeight:"bold",lineHeight:"55px"},installbtn:{height:60,width:60,position:"absolute",top:0,bottom:0,margin:"auto"},installbtnText:{fontSize:"2.5rem"},completeBtn:{background:u.A[500]},installBtn:{background:u.A[500],"&:hover":{background:u.A[700]}},uninstallBtn:{background:m.A[500],"&:hover":{background:m.A[700]}},fabInstall:{color:u.A[500],position:"absolute",top:-6,left:-6,zIndex:1},fabUninstall:{color:m.A[500],position:"absolute",top:-6,left:-6,zIndex:1},fabPending:{color:f[500],position:"absolute",top:-6,left:-6,zIndex:1},fabFailed:{color:m.A[800],position:"absolute",top:-6,left:-6,zIndex:1}}}));const g=(0,o.Ng)(null,{install:b.install,uninstall:b.uninstall})((function(e){var a=h(),t=(0,o.d4)((function(e){return e.store.installing})).includes(e.app.name),c=(0,o.d4)((function(e){return e.store.installPending})).includes(e.app.name),u=(0,o.d4)((function(e){return e.store.installFailed})).includes(e.app.name),m=(0,o.d4)((function(e){return e.store.uninstalling})).includes(e.app.name),f=(0,o.d4)((function(e){return e.store.uninstallPending})).includes(e.app.name),b=(0,o.d4)((function(e){return e.store.uninstallFailed})).includes(e.app.name);return n.createElement(i.A,{className:a.wrapper},n.createElement(r.Ay,{container:!0},n.createElement(r.Ay,{item:!0,xs:2,style:{position:"relative"}},n.createElement(l.A,{variant:"rounded",className:a.appIcon,style:{backgroundColor:e.app.color}},n.createElement(p.g,{style:{margin:"auto",width:"auto"},icon:e.app.icon}))),n.createElement(r.Ay,{item:!0,xs:8,className:a.appText},n.createElement("span",{className:a.appTitle},e.app.label)),n.createElement(r.Ay,{item:!0,xs:2,style:{position:"relative"}},e.installed?n.createElement("div",null,n.createElement(s.A,{className:a.uninstallBtn,onClick:function(a){a.preventDefault(),e.uninstall(e.app.name)},disabled:m||f||b||!e.app.canUninstall},n.createElement(p.g,{icon:["fas","x"],style:{fontSize:16}})),m||f?n.createElement(d.A,{size:68,className:m?a.fabInstall:f?a.fabPending:null}):b?n.createElement(d.A,{size:68,variant:"static",value:100,className:a.fabFailed}):null):n.createElement("div",null,n.createElement(s.A,{className:a.installBtn,onClick:function(a){a.preventDefault(),t||e.install(e.app.name)},disabled:t||c||u},n.createElement(p.g,{icon:["fas","download"],style:{fontSize:16}})),t||c?n.createElement(d.A,{size:68,className:t?a.fabInstall:c?a.fabPending:null}):u?n.createElement(d.A,{size:68,variant:"static",value:100,className:a.fabFailed}):null))))}))},75228:(e,a,t)=>{t.d(a,{A:()=>A});var n=t(82682),o=t(64867),i=t(39337),r=t(37579),l=t(73375),s=t(27893),d=t(59082),c=t(43051),p=t(94093);function u(e){return(0,p.A)("MuiFab",e)}const m=(0,t(84657).A)("MuiFab",["root","primary","secondary","extended","circular","focusVisible","disabled","colorInherit","sizeSmall","sizeMedium","sizeLarge"]);var f=t(81808),b=t(50493);const h=["children","className","color","component","disabled","disableFocusRipple","focusVisibleClassName","size","variant"],g=(0,f.Ay)(s.A,{name:"MuiFab",slot:"Root",overridesResolver:(e,a)=>{const{ownerState:t}=e;return[a.root,a[t.variant],a[`size${(0,d.A)(t.size)}`],"inherit"===t.color&&a.colorInherit,"primary"===t.color&&a.primary,"secondary"===t.color&&a.secondary]}})((({theme:e,ownerState:a})=>(0,o.A)({},e.typography.button,{minHeight:36,transition:e.transitions.create(["background-color","box-shadow","border-color"],{duration:e.transitions.duration.short}),borderRadius:"50%",padding:0,minWidth:0,width:56,height:56,boxShadow:e.shadows[6],"&:active":{boxShadow:e.shadows[12]},color:e.palette.getContrastText(e.palette.grey[300]),backgroundColor:e.palette.grey[300],"&:hover":{backgroundColor:e.palette.grey.A100,"@media (hover: none)":{backgroundColor:e.palette.grey[300]},textDecoration:"none"},[`&.${m.focusVisible}`]:{boxShadow:e.shadows[6]},[`&.${m.disabled}`]:{color:e.palette.action.disabled,boxShadow:e.shadows[0],backgroundColor:e.palette.action.disabledBackground}},"small"===a.size&&{width:40,height:40},"medium"===a.size&&{width:48,height:48},"extended"===a.variant&&{borderRadius:24,padding:"0 16px",width:"auto",minHeight:"auto",minWidth:48,height:48},"extended"===a.variant&&"small"===a.size&&{width:"auto",padding:"0 8px",borderRadius:17,minWidth:34,height:34},"extended"===a.variant&&"medium"===a.size&&{width:"auto",padding:"0 16px",borderRadius:20,minWidth:40,height:40},"inherit"===a.color&&{color:"inherit"})),(({theme:e,ownerState:a})=>(0,o.A)({},"primary"===a.color&&{color:e.palette.primary.contrastText,backgroundColor:e.palette.primary.main,"&:hover":{backgroundColor:e.palette.primary.dark,"@media (hover: none)":{backgroundColor:e.palette.primary.main}}},"secondary"===a.color&&{color:e.palette.secondary.contrastText,backgroundColor:e.palette.secondary.main,"&:hover":{backgroundColor:e.palette.secondary.dark,"@media (hover: none)":{backgroundColor:e.palette.secondary.main}}}))),A=i.forwardRef((function(e,a){const t=(0,c.A)({props:e,name:"MuiFab"}),{children:i,className:s,color:p="default",component:m="button",disabled:f=!1,disableFocusRipple:A=!1,focusVisibleClassName:y,size:v="large",variant:x="circular"}=t,k=(0,n.A)(t,h),w=(0,o.A)({},t,{color:p,component:m,disabled:f,disableFocusRipple:A,size:v,variant:x}),z=(e=>{const{color:a,variant:t,classes:n,size:o}=e,i={root:["root",t,`size${(0,d.A)(o)}`,"inherit"===a&&"colorInherit","primary"===a&&"primary","secondary"===a&&"secondary"]};return(0,l.A)(i,u,n)})(w);return(0,b.jsx)(g,(0,o.A)({className:(0,r.A)(z.root,s),component:m,disabled:f,focusRipple:!A,focusVisibleClassName:(0,r.A)(z.focusVisible,y),ownerState:w,ref:a},k,{children:i}))}))}}]);
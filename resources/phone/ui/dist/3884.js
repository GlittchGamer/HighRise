"use strict";(self.webpackChunkhrrp_phone=self.webpackChunkhrrp_phone||[]).push([[3884,8044,5663],{43884:(e,t,a)=>{a.r(t),a.d(t,{default:()=>p});var r=a(39337),n=a(66525),l=a(43469),o=a(68044),s=a(50566),i=a(85193),c=a(25019),m=a(28170),u=a(50678),d=a(65425),A=a(98330),f=(0,u.A)((function(e){return{item:{borderBottom:"1px solid ".concat(e.palette.border.divider),"&:first-child":{borderTop:"1px solid ".concat(e.palette.border.divider)}},avatar:{backgroundColor:e.palette.primary.main},myself:{fontSize:14,color:e.palette.info.main,marginRight:5},owner:{fontSize:14,color:"gold",marginRight:5}}}));const p=function(e){var t=e.jobData,a=e.playerJob,u=e.employee,p=e.onClick,v=f(),I=(0,A.Bm)(),E=((0,A.T1)(),(0,n.d4)((function(e){return e.data.data.player}))),g=E.SID==(null==t?void 0:t.Owner),S=I("JOB_MANAGEMENT",t.Id)||g,w=I("JOB_MANAGE_EMPLOYEES",t.Id)||g,b=(I("JOB_HIRE",t.Id),I("JOB_FIRE",t.Id)||g);return r.createElement(l.Ay,{className:v.item,button:((null==t?void 0:t.Owner)!=u.SID||g)&&(a.Grade.Level>u.JobData.Grade.Level||g)&&(S||w||b),onClick:((null==t?void 0:t.Owner)!=u.SID||g)&&(a.Grade.Level>u.JobData.Grade.Level||g)&&(S||w||b)?function(){return p(u)}:null},r.createElement(o.A,null,r.createElement(s.A,{className:v.avatar},r.createElement(d.g,{icon:["fas","user"]}))),r.createElement(i.A,{primary:r.createElement("span",null,E.SID==u.SID?r.createElement(c.A,{title:"You"},r.createElement("span",null,r.createElement(d.g,{className:v.myself,icon:["fas","user"]}))):(null==t?void 0:t.Owner)==u.SID?r.createElement(c.A,{title:"Business Owner"},r.createElement("span",null,r.createElement(d.g,{className:v.owner,icon:["fas","crown"]}))):null,"".concat(u.First," ").concat(u.Last)),secondary:"".concat(u.JobData.Grade.Name," - ").concat(u.Phone)}),t.Owner!=u._id&&(a.Grade.Level>u.JobData.Grade.Level||g)&&(S||w||b)&&r.createElement(m.A,null,r.createElement(d.g,{icon:["fas","pen-to-square"]})))}},68044:(e,t,a)=>{a.d(t,{A:()=>v});var r=a(82682),n=a(64867),l=a(39337),o=a(37579),s=a(73375),i=a(64474),c=a(81808),m=a(43051),u=a(94093);function d(e){return(0,u.A)("MuiListItemAvatar",e)}(0,a(84657).A)("MuiListItemAvatar",["root","alignItemsFlexStart"]);var A=a(50493);const f=["className"],p=(0,c.Ay)("div",{name:"MuiListItemAvatar",slot:"Root",overridesResolver:(e,t)=>{const{ownerState:a}=e;return[t.root,"flex-start"===a.alignItems&&t.alignItemsFlexStart]}})((({ownerState:e})=>(0,n.A)({minWidth:56,flexShrink:0},"flex-start"===e.alignItems&&{marginTop:8}))),v=l.forwardRef((function(e,t){const a=(0,m.A)({props:e,name:"MuiListItemAvatar"}),{className:c}=a,u=(0,r.A)(a,f),v=l.useContext(i.A),I=(0,n.A)({},a,{alignItems:v.alignItems}),E=(e=>{const{alignItems:t,classes:a}=e,r={root:["root","flex-start"===t&&"alignItemsFlexStart"]};return(0,s.A)(r,d,a)})(I);return(0,A.jsx)(p,(0,n.A)({className:(0,o.A)(E.root,c),ownerState:I,ref:t},u))}))}}]);
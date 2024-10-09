// // zones: [
// //   {
// //     1: {
// //       text: 'Make Parts',
// //       distance: 2,
// //       realName: 'Make Parts',
// //       icon: 'toolbox',
// //       hrrptarget: true,
// //       event: 'Crafting:Client:OpenCrafting',
// //       label: 'Make Parts',
// //       data: {
// //         id: 'mech-harmony-1',
// //         label: 'Make Parts',
// //         restrictions: {
// //           job: {
// //             id: 'harmony',
// //             onDuty: true,
// //           },
// //         },
// //         targeting: {
// //           icon: 'toolbox',
// //           poly: {
// //             l: 1.4,
// //             coords: {
// //               x: 1176.1500244140625,
// //               y: 2635.2099609375,
// //               z: 37.75,
// //             },
// //             options: {
// //               minZ: 36.75,
// //               maxZ: 39.55,
// //               heading: 0,
// //             },
// //             w: 3.8,
// //           },
// //           actionString: 'Crafting',
// //         },
// //         canUseSchematics: false,
// //         location: {
// //           x: 1176.1500244140625,
// //           y: 2635.2099609375,
// //           z: 37.75,
// //           h: 0,
// //         },
// //       },
// //       mainIcon: 'toolbox',
// //     },
// //     jobPerms: {
// //       '1': {
// //         job: 'harmony',
// //         reqDuty: true,
// //       },
// //       icon: 'toolbox',
// //       hrrptarget: true,
// //       distance: 2,
// //       mainIcon: 'toolbox',
// //     },
// //   },
// // ],

// export interface ISetTarget {
//   options: Array<{
//     distance: number;
//     event: string;
//     hide: boolean;
//     icon: string;
//     label: string;
//     minDist: number;
//     hrrptarget: boolean;
//     realName: string;
//     resource: string;
//     text?: string;
//     data?: any[];
//   }>;
//   icon: string;
//   zones: Array<{
//     [key: number]: {
//       text: string;
//       distance: number;
//       realName: string;
//       icon: string;
//       hrrptarget: boolean;
//       event: string;
//       label: string;
//       data: {
//         id: string;
//         label: string;
//         restrictions: {
//           job: {
//             id: string;
//             onDuty: boolean;
//           };
//         };
//         targeting: {
//           icon: string;
//           poly: {
//             l: number;
//             coords: {
//               x: number;
//               y: number;
//               z: number;
//             };
//             options: {
//               minZ: number;
//               maxZ: number;
//               heading: number;
//             };
//             w: number;
//           };
//           actionString: string;
//         };
//         canUseSchematics: boolean;
//         location: {
//           x: number;
//           y: number;
//           z: number;
//           h: number;
//         };
//       };
//       mainIcon: string;
//     };
//     jobPerms: {
//       [key: number]: {
//         job: string;
//         reqDuty: boolean;
//       };
//       icon: string;
//       hrrptarget: boolean;
//       distance: number;
//       mainIcon: string;
//     };
//   }>;
// }

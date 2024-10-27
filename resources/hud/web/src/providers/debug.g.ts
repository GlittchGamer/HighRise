import { debugData } from '@/util/debugData';

// setInterval(() => {
//   debugData([
//     {
//       action: 'UPDATE_RPM',
//       data: {
//         rpm: Math.random(),
//       },
//     },
//   ]);
// }, 1000);

debugData([
  { action: 'APP_SHOW', data: true },
  { action: 'SHOW_HUD', data: true },
  { action: 'SHOW_VEHICLE', data: false },
]);

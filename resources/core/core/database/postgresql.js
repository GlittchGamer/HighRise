// const postesql = require('pg');

// let client = null;

// const host = GetConvar('postgresql_host', '').replace(/'/g, '');
// const port = GetConvar('postgresql_port', '').replace(/'/g, '');
// const username = GetConvar('postgresql_username', '').replace(/'/g, '');
// const password = GetConvar('postgresql_password', '').replace(/'/g, '');
// const database = GetConvar('postgresql_database', '').replace(/'/g, '');
// const schema = GetConvar('postgresql_schema', '').replace(/'/g, '');

// async function connectToDatabase() {
//   try {
//     var conString = 'postgres://' + username + ':' + password + '@' + host + ':' + port + '/' + database + '?schema=' + schema;
//     client = new postesql.Client(conString);
//     client.connect();
//     client.query(`SET search_path TO ${schema}, public`);
//     global.exports['core'].LoggerTrace(`PostgreSQL`, ` Connected to PostgreSQL.`);
//     return { success: true, message: 'Connected to PostgreSQL.' };
//   } catch (err) {
//     setTimeout(function () {
//       global.exports['core'].LoggerError(`PostgreSQL`, `Failed to connect to ${url}. Retrying connection.`);
//       connectToDatabase();
//       return { success: false, message: 'Failed to connect to PostgreSQL.' };
//     }, 5000);
//   }
// }

// const DATABASE = {
//   isConnected: () => !!client,
//   async Query(self, params) {
//     if (!DATABASE.isConnected()) return;
//     if (!params.query) global.exports['core'].LoggerError(`PostgreSQL`, `[ERROR] exports.query: Does not contain query text.`);
//     const query = params.query;
//     const values = params.values || params.value || params.data || params.params || [];
//     try {
//       const result = await client.query(query, values);
//       return { err: false, message: 'Query executed successfully.', result: result.rows };
//     } catch (err) {
//       global.exports['core'].LoggerError(`PostgreSQL`, `[ERROR] exports.query: Error "${err.message}".`);
//       return { err: true, message: err.message };
//     }
//   },
//   async Insert(self, params) {
//     if (!DATABASE.isConnected()) return;
//     if (!params.query) global.exports['core'].LoggerError(`[PostgreSQL][ERROR] exports.insert: Does not contain query text.`);
//     let query = params.query;
//     if (query.slice(0, query.indexOf(' ')) !== 'INSERT') {
//       global.exports['core'].LoggerError(`[PostgreSQL][ERROR] exports.insert: This is not correct INSERT syntax.`);
//       return { err: true, message: 'This is not correct INSERT syntax.' };
//     }
//     if (params.returning) {
//       if (params.returning.length > 1) {
//         const returning = params.returning.join(', ');
//         query = query + ' RETURNING ' + returning;
//       } else {
//         query = query + ' RETURNING ' + params.returning[0];
//       }
//     } else {
//       query = query + ' RETURNING *';
//     }
//     const values = params.values || params.value || params.data || params.params || [];
//     try {
//       const result = await client.query(query, values);
//       return { err: false, message: 'Inserted successfully.', result: result.rows[0] };
//     } catch (err) {
//       global.exports['core'].LoggerError(`[PostgreSQL][ERROR] exports.insert: Error "${err.message}".`);
//       return { err: true, message: err.message };
//     }
//   },
//   async Delete(self, params) {
//     if (!DATABASE.isConnected()) return;
//     if (!params.query) global.exports['core'].LoggerError(`[PostgreSQL][ERROR] exports.delete: Does not contain query text.`);
//     let query = params.query;
//     if (query.slice(0, query.indexOf(' ')) !== 'DELETE') {
//       global.exports['core'].LoggerError(`[PostgreSQL][ERROR] exports.delete: This is not correct DELETE syntax.`);
//       return { err: true, message: 'This is not correct DELETE syntax.' };
//     }
//     if (params.returning) {
//       if (params.returning.length > 1) {
//         const returning = params.returning.join(', ');
//         query = query + ' RETURNING ' + returning;
//       } else {
//         query = query + ' RETURNING ' + params.returning[0];
//       }
//     } else {
//       query = query + ' RETURNING *';
//     }
//     const values = params.values || params.value || params.data || params.params || [];
//     try {
//       const result = await client.query(query, values);
//       return { err: false, message: 'Deleted successfully.', result: result.rows };
//     } catch (err) {
//       global.exports['core'].LoggerError(`[PostgreSQL][ERROR] exports.query: Error "${err.message}".`);
//       return { err: true, message: err.message };
//     }
//   },
//   async Update(self, params) {
//     if (!DATABASE.isConnected()) return;
//     if (!params.query) global.exports['core'].LoggerError(`PostgreSQL`, `[ERROR] exports.update: Does not contain query text.`);
//     let query = params.query;
//     const values = params.values || params.value || params.data || params.params || [];
//     if (query.slice(0, query.indexOf(' ')) !== 'UPDATE') {
//       global.exports['core'].LoggerError(`PostgreSQL`, `[ERROR] exports.update: This is not correct UPDATE syntax.`);
//       return { err: true, message: 'This is not correct UPDATE syntax.' };
//     }
//     if (params.returning) {
//       if (params.returning.length > 1) {
//         const returning = params.returning.join(', ');
//         query = query + ' RETURNING ' + returning;
//       } else {
//         query = query + ' RETURNING ' + params.returning[0];
//       }
//     } else {
//       query = query + ' RETURNING *';
//     }
//     try {
//       const result = await client.query(query, values);
//       return { err: false, message: 'Updated successfully.', result: result.rows };
//     } catch (err) {
//       global.exports['core'].LoggerError(`PostgreSQL`, `[ERROR] exports.update: Error "${err.message}".`);
//       return { err: true, message: err.message };
//     }
//   },
//   async Single(self, params) {
//     if (!DATABASE.isConnected()) return;
//     if (!params.query) global.exports['core'].LoggerError(`[PostgreSQL][ERROR] exports.single: Does not contain query text.`);
//     const query = params.query;
//     const values = params.values || params.value || params.data || params.params || [];
//     try {
//       const result = await client.query(query, values);
//       return { err: false, message: 'Query executed successfully.', result: result.rows[0] || null };
//     } catch (err) {
//       global.exports['core'].LoggerError(`[PostgreSQL][ERROR] exports.single: Error "${err.message}".`);
//       return { err: true, message: err.message };
//     }
//   },
// };

// AddEventHandler('Database:Server:Initialize', async () => {
//   if (host != '') {
//     const { success, message } = await connectToDatabase();
//     if (!success) {
//       return console.error(message);
//     }
//     emit('Database:Server:Ready');
//   } else {
//     if (host == '') global.exports['core'].LoggerError(`PocketBase`, `[ERROR] Convar "postgresql_url" not set (see README)`);
//     if (port == '') global.exports['core'].LoggerError(`PocketBase`, `[ERROR] Convar "postgresql_port" not set (see README)`);
//     if (username == '') global.exports['core'].LoggerError(`PocketBase`, `[ERROR] Convar "postgresql_username" not set (see README)`);
//     if (password == '') global.exports['core'].LoggerError(`PocketBase`, `[ERROR] Convar "postgresql_password" not set (see README)`);
//     if (database == '') global.exports['core'].LoggerError(`PocketBase`, `[ERROR] Convar "postgresql_database" not set (see README)`);
//     if (schema == '') global.exports['core'].LoggerError(`PocketBase`, `[ERROR] Convar "postgresql_schema" not set (see README)`);
//   }
// });

// const exportHandler = (exportName, func) => {
//   AddEventHandler(`__cfx_export_${GetCurrentResourceName()}_${exportName}`, (setCB) => {
//     setCB((...args) => {
//       return func(DATABASE, ...args);
//     });
//   });
// };

// const createExportForObject = (object, name) => {
//   name = name || '';
//   for (const [k, v] of Object.entries(object)) {
//     if (typeof v === 'function') {
//       exportHandler(name + k, v);
//     } else if (typeof v === 'object') {
//       createExportForObject(v, name + k);
//     }
//   }
// };

// for (const [k, v] of Object.entries(DATABASE)) {
//   if (typeof v === 'function') {
//     exportHandler(`Database${k}`, v);
//   } else if (typeof v === 'object') {
//     createExportForObject(v, `Database${k}`);
//   }
// }

// const GetCurrentDate = () => {
//   return new Date();
// };
// exports('GetCurrentDate', GetCurrentDate);

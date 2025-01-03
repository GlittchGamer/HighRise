fx_version 'cerulean'
game 'gta5'
lua54 'yes'
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/server.lua',
  'server/startup.lua',
  'server/stock.lua',
  'server/management.lua',
  'server/showroom.lua',
  'server/records.lua',
  'server/rentals.lua',
  'server/sales.lua',
  'server/gov_fleets.lua',
}

client_scripts {
  'client/utils.lua',
  'client/client.lua',
  'client/showroom.lua',
  'client/catalog.lua',
  'client/employee/*.lua',
  'client/rentals.lua',
  'client/bike_stand.lua',
  'client/gov_fleets.lua',
}

shared_scripts {
  'config/*.lua',
  'shared/*.lua',
}

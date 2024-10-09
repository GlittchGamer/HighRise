fx_version 'cerulean'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"
server_script "@oxmysql/lib/MySQL.lua"
game 'gta5'
lua54 'yes'

client_scripts {
  'interiors/**/*.lua',
  'shared/**/*.lua',
  'client/**/*.lua',
}

server_scripts {
  'interiors/**/*.lua',
  'shared/**/*.lua',
  'sv_config.lua',
  'server/**/*.lua',
}

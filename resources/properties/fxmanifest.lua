fx_version 'cerulean'
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"
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

fx_version 'cerulean'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"
server_script("@oxmysql/lib/MySQL.lua")

game 'gta5'
lua54 'yes'

client_scripts {
  'config/cl_*.lua',
  'client/**/*.lua',
}

shared_scripts {
  'config/sh_*.lua',
}

server_scripts {
  'config/sv_*.lua',
  'server/**/*.lua',
}

version 'v1.0.0'
lua54 'yes'
fx_version "cerulean"
game "gta5"
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

client_scripts {
  'client/**/*.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/**/*.lua',
}

shared_scripts {
  'shared/sh_funcs.lua',
}

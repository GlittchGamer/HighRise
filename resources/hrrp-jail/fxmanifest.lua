fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

server_scripts {
  'server/**/*.lua',
}

shared_scripts {
  'config.lua',
}

client_scripts {
  'client/**/*.lua',
}
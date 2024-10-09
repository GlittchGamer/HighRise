fx_version 'cerulean'
lua54 'yes'
game 'gta5'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

client_scripts {
  'client/**/*.lua',
}

shared_scripts {
  'shared/**/*.lua',
}

server_scripts {
  'configs/**/*.lua',
  'server/**/*.lua',
}

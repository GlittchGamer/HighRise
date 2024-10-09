fx_version 'cerulean'
game 'gta5'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

client_scripts {
  'shared/**/*.lua',
  'client/**/*.lua'
}

server_scripts {
  'shared/**/*.lua',
  'server/**/*.lua',
}

game 'gta5'
fx_version 'cerulean'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

lua54 'yes'

client_scripts {
  'shared/**/*.lua',
  'client/**/*.lua',
}

server_scripts {
  'shared/**/*.lua',
  'server/**/*.lua',
}

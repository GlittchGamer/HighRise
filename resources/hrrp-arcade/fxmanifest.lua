fx_version 'cerulean'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

game 'gta5'
lua54 'yes'

client_scripts {
  'shared/**/*.lua',
  'client/**/*.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'shared/**/*.lua',
  'server/**/*.lua',
}
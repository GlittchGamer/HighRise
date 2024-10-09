fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
description 'Blue Sky Limb Damage'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

version '2.0.0'

client_scripts {
  'shared/**/*.lua',
  'client/**/*.lua',
}

server_scripts {
  'shared/**/*.lua',
  'server/**/*.lua',
}

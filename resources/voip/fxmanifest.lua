game 'gta5'
fx_version 'cerulean'
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"

lua54 'yes'

client_scripts {
  'shared/**/*.lua',
  'client/**/*.lua',
}

server_scripts {
  'shared/**/*.lua',
  'server/**/*.lua',
}

fx_version 'cerulean'
lua54 'yes'
game 'gta5'
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"

client_scripts {
  'client/*.lua',
}

server_scripts {
  'server/*.lua',
}

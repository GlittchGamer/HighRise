fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"
server_script "@oxmysql/lib/MySQL.lua"

shared_scripts {
  'shared/**/*.lua',
}

client_scripts {
  'client/**/*.lua'
}

server_scripts {
  'server/**/*.lua'
}
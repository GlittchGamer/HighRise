fx_version 'cerulean'
game 'gta5'
lua54 'yes'
server_script "@oxmysql/lib/MySQL.lua"
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"

server_scripts {
  'server/**/*.lua',
}

shared_scripts {
  'config/config.lua',
  'config/spawns.lua',
  'config/defaultJobs/*.lua',
}

client_scripts {
  'client/**/*.lua',
}

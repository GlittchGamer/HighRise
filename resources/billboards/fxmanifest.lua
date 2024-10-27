fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"

author 'Stroudy'
version 'v1.0.0'

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'shared/**/*.lua',
  'server/**/*.lua',
}

client_scripts {
  'shared/**/*.lua',
  'client/**/*.lua',
}

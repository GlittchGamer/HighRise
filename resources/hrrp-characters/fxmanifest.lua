fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

client_scripts {
  'config.lua',
  'client/**/*.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'config.lua',
  'server/**/*.lua',
}

ui_page 'ui/dist/index.html'

files { "ui/dist/index.html", 'ui/dist/*.png', 'ui/dist/*.js' }

name 'ARP Phone'
description 'Phone Written For ARP'
author '[Alzar]'
version 'v1.0.0'
url 'https://www.mythicrp.com'
lua54 'yes'
fx_version "cerulean"
game "gta5"
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"

ui_page 'ui/dist/index.html'

files {
  'ui/dist/*.*',
}

client_scripts {
  'client/*.lua',
  'client/apps/**/*.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/*.lua',
  'server/apps/**/*.lua',
}

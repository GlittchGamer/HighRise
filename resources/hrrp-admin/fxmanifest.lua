fx_version 'cerulean'
game 'gta5'
lua54 'yes'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

client_scripts {
  'client/client.lua',
  'client/attach.lua',
  'client/noclip/*.lua',
  -- 'client/menu.lua',
  -- 'client/shitty_menu.lua',
  'client/nui.lua',
  'client/ids.lua',
  'client/nuke.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/*.lua'
}

ui_page 'ui/dist/index.html'

files { "ui/dist/index.html", 'ui/dist/*.js' }
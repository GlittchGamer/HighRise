fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"


data_file "SCALEFORM_DLC_FILE" "stream/int3232302352.gfx"

client_scripts {
  'config.lua',
  'client/*.lua',
  --'demo_games.lua',
}

server_scripts {
  'config.lua',
  'server/*.lua',
}

ui_page 'web/build/index.html'
files { 'web/build/**/*', 'stream/int3232302352.gfx' }

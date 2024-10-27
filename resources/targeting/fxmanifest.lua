fx_version 'cerulean'
game 'gta5'
lua54 'yes'
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"

client_scripts {
  '@polyzone/client.lua',
  '@polyzone/BoxZone.lua',
  '@polyzone/EntityZone.lua',
  '@polyzone/CircleZone.lua',
  '@polyzone/ComboZone.lua',

  'client/*.lua',
  'client/targets/*.lua',
}

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
client_script "@hrrp-base/components/modules/error/cl_error.lua"
client_script "@hrrp-pwnzor/client/check.lua"

client_scripts {
  '@hrrp-polyzone/client.lua',
  '@hrrp-polyzone/BoxZone.lua',
  '@hrrp-polyzone/EntityZone.lua',
  '@hrrp-polyzone/CircleZone.lua',
  '@hrrp-polyzone/ComboZone.lua',

  'client/*.lua',
  'client/targets/*.lua',
}

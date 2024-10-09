fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@hrrp-base/components/modules/error/cl_error.lua"

client_scripts {
  'cl_*.lua',
  'client/*.lua'
}

server_scripts {
  'sv_*.lua',
  'server/*.lua',
}

exports {
  'SetupClient'
}

server_exports {
  'SetupServer'
}

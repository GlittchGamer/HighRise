name "DJBooth"
author "BlazerBoccle"
version "v1.1"
description 'DJBooth'
fx_version "cerulean"
game "gta5"

client_scripts {
	"@hrrp-polyzone/client.lua",
	"@hrrp-polyzone/BoxZone.lua",
	"@hrrp-polyzone/EntityZone.lua",
	"@hrrp-polyzone/CircleZone.lua",
	"@hrrp-polyzone/ComboZone.lua",
    'client.lua'
}

shared_script { 'config.lua' }
server_script { 'server.lua' }

dependency 'xsound'

lua54 'yes'
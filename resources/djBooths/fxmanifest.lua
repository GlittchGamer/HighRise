name "DJBooth"
author "BlazerBoccle"
version "v1.1"
description 'DJBooth'
fx_version "cerulean"
game "gta5"

client_scripts {
	"@polyzone/client.lua",
	"@polyzone/BoxZone.lua",
	"@polyzone/EntityZone.lua",
	"@polyzone/CircleZone.lua",
	"@polyzone/ComboZone.lua",
    'client.lua'
}

shared_script { 'config.lua' }
server_script { 'server.lua' }

dependency 'xsound'

lua54 'yes'
name 'ARP Restaurant'
author '[Cool People Dev Team]'
lua54 'yes'
fx_version "cerulean"
game "gta5"
client_script "@core/components/modules/error/cl_error.lua"
client_script "@pwnzor/client/check.lua"

client_scripts({
  "client/**/*.lua",
})

server_scripts({
  "configs/config.lua",
  "configs/recipies.lua",
  "configs/restaurants/**/*.lua",
  "server/**/*.lua",
})

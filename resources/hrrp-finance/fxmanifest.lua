fx_version("cerulean")
game("gta5")
lua54("yes")
client_script("@hrrp-base/components/modules/error/cl_error.lua")
client_script("@hrrp-pwnzor/client/check.lua")
server_script("@oxmysql/lib/MySQL.lua")

client_scripts({
  "shared/**/*.lua",
  "client/**/*.lua",
})

server_scripts({
  "shared/**/*.lua",
  "server/**/*.lua",
})

ui_page("ui/dist/index.html")

files({ "ui/dist/index.html", "ui/dist/*.js", "ui/dist/*.png", "ui/dist/*.webp" })
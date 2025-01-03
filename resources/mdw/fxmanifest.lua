name("AuthenticRP RP MDT")
description("Mobile Data Terminal Written For AuthenticRP RP")
author("Dr Nick")
version("v1.0.0")
lua54("yes")
fx_version("cerulean")
game("gta5")
client_script("@core/components/modules/error/cl_error.lua")
client_script("@pwnzor/client/check.lua")

client_scripts({ "shared/*.lua", "client/**/*.lua" })

server_scripts({ "@oxmysql/lib/MySQL.lua", "shared/*.lua", "server/**/*.lua" })

ui_page("ui/dist/index.html")

files({ "ui/dist/index.html", "ui/dist/*.js" })

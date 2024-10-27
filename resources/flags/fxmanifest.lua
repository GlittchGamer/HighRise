fx_version 'cerulean'
games { 'gta5' } -- 'gta5' for GTAv / 'rdr3' for Red Dead 2, 'gta5','rdr3' for both
lua54 'yes'

description 'HighRiseRP Flags'
name 'HighRiseRP: Flags'
author 'Stroudy'
version 'v1.0.0'

server_scripts {
  'server/**/*.lua',
}

client_scripts {
  'client/**/*.lua',
}

shared_scripts {
  'flags.lua'
}

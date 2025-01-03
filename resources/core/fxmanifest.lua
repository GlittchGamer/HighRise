fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@pwnzor/client/check.lua"
client_scripts {
  'sh_init.lua',
  'cl_init.lua',
  'core/sh_*.lua',
  'core/cl_*.lua',
  'cl_config.lua',
  'components/**/cl_*.lua',
}

server_scripts {
  'core/database/postgresql.js',
  '@oxmysql/lib/MySQL.lua',
  'sh_init.lua',
  'sv_init.lua',
  'sv_config.lua',
  'core/sv_generator.js',
  'core/sv_regex.js',
  'core/sh_*.lua',
  'core/sv_*.lua',
  'components/**/sv_*.lua',
}

files {
  'weaponanimations.meta',
  'gta5.meta',
  'water.xml',
}

replace_level_meta 'gta5'

data_file 'WEAPON_ANIMATIONS_FILE' 'weaponanimations.meta'

this_is_a_map 'yes'

dependency 'oxmysql'

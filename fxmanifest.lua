fx_version 'cerulean'
game 'gta5'
description 'Weapon dealer script af Fisken'
lua54 'yes'
author 'Fisken'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'config.lua',
    'client/cl-main.lua',
}

server_scripts {
    'config.lua',
    'server/sv-main.lua'
}

dependencies {
	'es_extended'
}

escrow_ignore {
  'config.lua',
}
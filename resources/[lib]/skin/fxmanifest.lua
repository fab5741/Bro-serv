fx_version 'adamant'

game 'gta5'

description 'ESX Skin'

dependency "bf"

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

dependencies {
	'skinchanger'
}

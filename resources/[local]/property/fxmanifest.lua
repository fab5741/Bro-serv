fx_version 'adamant'

game 'gta5'

description 'ESX Property'

version '1.0.4'

dependency "bf"

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}
fx_version 'adamant'

game 'gta5'

description 'ESX Weapon Shop'

version '1.1.0'

dependencies {
	"bro_core",
	"jobManager"
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}
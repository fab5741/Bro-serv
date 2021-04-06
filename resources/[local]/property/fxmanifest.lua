fx_version 'adamant'

game 'gta5'

description 'Bro Properties'

version '1.0.4'

dependency {
	"bro_core",
	"vehicles"
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
fx_version 'adamant'

game 'gta5'

description 'Instance'

dependency "bro_core"

version '1.1.0'

server_scripts {
	'config.lua',
	'server/main.lua'
}


client_scripts {
	'config.lua',
	'client/main.lua'
}

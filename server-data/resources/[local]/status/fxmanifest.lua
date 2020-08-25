fx_version 'adamant'

game 'gta5'

description 'BF Status'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'client.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/app.css',
	'html/scripts/app.js'
}
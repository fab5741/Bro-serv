fx_version 'bodacious'
game 'gta5'

description '- Bro - phone'

version '0.0.1'

ui_page 'html/dist/index.html'

files {
	'html/dist/index.html',
	'html/dist/css/app.css',
	'html/dist/js/app.js',
	'html/dist/js/manifest.js',
	'html/dist/js/vendor.js',

	'html/dist/config/config.json',
	
	-- Coque
	'html/dist/img/coque/*.png',
	'html/dist/img/coque/*.jpg',
	
	-- Background
	'html/dist/img/background/*.jpg',
	'html/dist/img/background/*.png',
	
	'html/dist/img/icons_app/*.png',
	'html/dist/img/icons_app/*.jpg',
	
	'html/dist/img/app_bank/*.jpg',
	'html/dist/img/app_bank/*.png',

	'html/dist/img/app_tchat/*.png',
	'html/dist/img/app_tchat/*.jpg',

	'html/dist/img/twitter/*.png',
	'html/dist/img/twitter/*.jpg',
	'html/dist/sound/*.ogg',

	'html/dist/img/*.png',
	'html/dist/img/*.jpg',
	'html/dist/fonts/fontawesome-webfont.ttf',

	'html/dist/sound/*.ogg',
	'html/dist/sound/*.mp3',

}

client_script {
	"config.lua",
	"client/animation.lua",
	"client/client.lua",

	"client/photo.lua",
	"client/app_tchat.lua",
	"client/bank.lua",
	"client/twitter.lua"
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	"config.lua",
	"server/server.lua",
	"server/app_tchat.lua",
	"server/twitter.lua"
}
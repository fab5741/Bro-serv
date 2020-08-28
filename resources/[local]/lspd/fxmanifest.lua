fx_version 'bodacious'
game 'gta5'

description '- Bro - lspd'

version '0.0.1'

ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/js/script.js',
    'client/html/css/style.css',
    'client/html/img/background.png',
    'client/html/img/arrows_upanddown.jpg',
    'client/html/fonts/SignPainter-HouseScript.ttf'
})


client_script {
    'config/cloackroom.lua',
    'config/config.lua',
    'config/objects.lua',
    'config/vehicles.lua',
    'config/weapons.lua',
    'client/armory.lua',
    'client/cloackroom.lua',
    'client/garage.lua',
    'client/menu.lua',
    'client/client.lua',
}

server_scripts {
    'config/config.lua',
    'server/server.lua'
  }
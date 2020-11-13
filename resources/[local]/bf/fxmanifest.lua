fx_version 'bodacious'
game 'gta5'

description '- Bro -'

version '0.0.1'

client_script 'client/client.lua'


server_script { 
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

-- load screen
loadscreen 'loadscreen/index.html'


files {
    'loadscreen/index.html',
    'loadscreen/keks.css',
   'loadscreen/bankgothic.ttf',
   'loadscreen/loadscreen.jpg',
   'client/html/index.html',
   'client/html/js/script.js',
   'client/html/css/style.css',
   'client/html/img/background.png',
   'client/html/img/arrows_upanddown.jpg',
   'client/html/fonts/SignPainter-HouseScript.ttf'
}

ui_page('client/html/index.html')

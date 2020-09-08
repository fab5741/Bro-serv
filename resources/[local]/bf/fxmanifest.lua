fx_version 'bodacious'
game 'gta5'

description '- Bro -'

version '0.0.1'

client_script 'client.lua'


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
}


dependency  'menu'

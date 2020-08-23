fx_version 'bodacious'
game 'gta5'

description '- Bro Framework -'

version '0.0.1'

-- NUI page
ui_page 'hud/index.html'
ui_page_preload 'yes'

-- load screen
loadscreen 'loadscreen/index.html'

dependencies {
    'mysql-async',
}

files {
    'loadscreen/index.html',
    'loadscreen/keks.css',
    'loadscreen/bankgothic.ttf',
    'loadscreen/loadscreen.jpg',
    'hud/app.css',
    'hud/app.js',
    'hud/index.html',
    'framework/modules.json',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'framework/server/functions.lua',
    'framework/server/events.lua',
    'framework/server/main.lua',
}

client_scripts {
    'framework/client/functions.lua',
    'framework/client/events.lua',
    'framework/client/main.lua',
}

shared_scripts {
    'framework/shared/functions.lua',
    'framework/shared/events.lua',
    'framework/shared/main.lua',
}


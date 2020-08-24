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
    'modules/base/modules.json',
    'modules/core/modules.json',
    'modules/user/modules.json',
    'modules/core/events/shared/events.lua',
    'modules/core/events/shared/main.lua',
    'modules/core/events/shared/functions.lua',
    'modules/core/table/shared/events.lua',
    'modules/core/table/shared/main.lua',
    'modules/core/table/shared/functions.lua',
    'modules/core/string/shared/events.lua',
    'modules/core/string/shared/main.lua',
    'modules/core/string/shared/functions.lua',
    'modules/core/class/shared/events.lua',
    'modules/core/class/shared/main.lua',
    'modules/core/class/shared/functions.lua',
    'modules/core/serializable/shared/events.lua',
    'modules/core/serializable/shared/main.lua',
    'modules/core/serializable/shared/functions.lua',
    'modules/core/cache/shared/events.lua',
    'modules/core/cache/shared/main.lua',
    'modules/core/cache/shared/functions.lua',
    'modules/core/player/client/events.lua',
    'modules/core/player/client/main.lua',
    'modules/core/player/client/functions.lua',
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


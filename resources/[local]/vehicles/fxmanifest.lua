fx_version 'bodacious'
game 'gta5'

description '- Bro - Vehicles'

version '0.0.1'

dependencies {
    "bro_core", 
    "account"
}

client_scripts {
    'menu.lua',
    'events.lua',
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
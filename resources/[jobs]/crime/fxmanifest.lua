fx_version 'bodacious'
game 'gta5'

description '- Bro - Crime - Collect and sell drugs'

version '0.0.1'

dependencies {
    "bro_core",
}

client_script {
    'config.lua',
    'events.lua',
    'client.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
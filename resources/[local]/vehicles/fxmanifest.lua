fx_version 'bodacious'
game 'gta5'

description '- Bro - Vehicles'

version '0.0.1'

dependency "bf"

client_script {
    'events.lua',
    'client.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
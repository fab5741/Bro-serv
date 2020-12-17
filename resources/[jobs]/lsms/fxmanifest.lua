fx_version 'bodacious'
game 'gta5'

description '- Bro - LSMS - Revive and distress signal'

version '0.0.1'

dependency "bf"

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

client_script {
    'client/client.lua',
}
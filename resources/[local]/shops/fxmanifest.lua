fx_version 'bodacious'
game 'gta5'

description '- Bro - ATM'

version '0.0.1'

dependency "bf"

client_script {
    'client.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
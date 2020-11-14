fx_version 'bodacious'
game 'gta5'

description '- Bro - Crime'

version '0.0.1'

client_script {
    'client.lua'
}
server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
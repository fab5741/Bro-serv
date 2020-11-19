fx_version 'bodacious'
game 'gta5'

description '- Bro - Accounting'

version '0.0.1'

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
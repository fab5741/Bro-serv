fx_version 'bodacious'
game 'gta5'

description '- Bro - Accounting'

dependency "bf"

version '0.1'

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
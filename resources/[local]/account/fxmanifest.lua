fx_version 'bodacious'
game 'gta5'

description '- Bro - Accounting'

dependency "bf"

version '0.1'

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
fx_version 'bodacious'
game 'gta5'

description '- Bro -'

version '0.0.1'

dependency "bf"

client_script 'client/client.lua'

server_script { 
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

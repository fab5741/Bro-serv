fx_version 'bodacious'
game 'gta5'

description '- Bro -'

version '0.0.1'

dependencies {
    'bf',
    'account',
    'items',
    'vehicles',
    'jobManager',
    'crime'
}

client_script  {
    'client/menu.lua',
    'client/events.lua',
    'client/client.lua'
} 

server_script { 
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

fx_version 'bodacious'
game 'gta5'

description '- Bro -'

version '0.0.1'

dependencies {
    'bro_core',
    'account',
    'items',
    'vehicles',
    'jobManager',
    'crime',
    'needs'
}

client_script  {
    'client/functions.lua',
    'client/events.lua',
    'client/client.lua'
} 

server_script { 
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

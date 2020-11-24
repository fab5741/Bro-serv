fx_version 'adamant'
games { 'gta5' }

dependencies {
    'bf',
    'vehicles',
    'lsms', 
    'account'   
}

client_script {
    'config.lua',
    'client/cloackroom.lua',
    'client/functions.lua',
    'client/events.lua',
    'client/menu.lua',
    'client/jobs.lua',
    'client/client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/server.lua'
  }
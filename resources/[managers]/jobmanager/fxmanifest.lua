fx_version 'adamant'
games { 'gta5' }

dependencies {
    'bro_core',
    'bf',
    'vehicles',
    'lsms', 
    'account',
    'spawnManager'
}

client_script {
    'config.lua',
    'client/cloackroom.lua',
    'client/functions.lua',
    'client/events.lua',
    'client/jobs.lua',
    'client/client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/server.lua'
  }
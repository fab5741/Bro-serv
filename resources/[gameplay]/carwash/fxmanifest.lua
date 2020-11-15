fx_version 'bodacious'
game 'gta5'

description '- Bro - Carwash commands'

version '0.0.1'

client_script {
    'client/client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
  }
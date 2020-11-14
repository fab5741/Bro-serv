client_script {
    'client/client.lua'
}
server_script { 
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
}

files {
  'client/html/index.html',
  'client/html/index.css',
  'client/html/app.js',
}

ui_page 'client/html/index.html'

fx_version 'adamant'
games { 'gta5' }
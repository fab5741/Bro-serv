fx_version 'bodacious'
game 'gta5'

description '- Bro - ATM commands'

version '0.0.1'

dependencies {
    "bro_core", 
    "account"
} 

client_script {
    'events.lua',
    'client.lua'
}
server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}
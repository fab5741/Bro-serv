fx_version 'adamant'
games { 'gta5' }

client_script {
    'functions.lua',
    'client.lua'
}
server_script { 
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    "bf",
    "skin",
    "skinchanger"
}
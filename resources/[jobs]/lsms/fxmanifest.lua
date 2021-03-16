fx_version 'bodacious'
game 'gta5'

description '- Bro - LSMS - Revive and distress signal'

version '0.0.1'

dependency "bro_core"

client_script {
    'client/functions.lua',
    'client/events.lua',
    'client/client.lua',
}
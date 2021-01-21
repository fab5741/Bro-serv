fx_version 'bodacious'
game 'gta5'

description '- Bro -'

version '0.0.1'

dependency "bro_core"

client_scripts {
    'client/functions.lua',
    'client/client.lua'
} 

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
} 

files {
    'loading/loading.html',
    'loading/config.js',
    'loading/script.js',
    'loading/style.css',
    'loading/music.wav',
    'loading/icon/crown.png',
    'loading/icon/discord.png',
    'loading/icon/facebook.png',
    'loading/icon/music.png',
    'loading/icon/person.png',
    'loading/icon/tip.png',
    'loading/icon/twitch.png',
    'loading/icon/twitter.png',
    'loading/icon/vulkanoa.png',
    'loading/icon/youtube.png',
    'loading/img/1.jpg',
    'loading/img/2.jpg',
    'loading/img/3.jpg',
}

loadscreen 'loading/loading.html'
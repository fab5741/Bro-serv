fx_version 'bodacious'
game 'gta5'

description '- Bro -'

version '0.0.1'

-- NUI page
ui_page 'hud/index.html'
ui_page_preload 'yes'

-- load screen
loadscreen 'loadscreen/index.html'

dependencies {
    'mysql-async',
}

files {
    'loadscreen/index.html',
    'loadscreen/keks.css',
    'loadscreen/bankgothic.ttf',
    'loadscreen/loadscreen.jpg',
    'hud/app.css',
    'hud/app.js',
    'hud/index.html',
}
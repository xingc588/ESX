fx_version 'cerulean'
game 'gta5'

author 'XC-星辰'
description 'XC-Trash can - 翻垃圾桶插件'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'es_extended'
}
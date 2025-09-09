fx_version 'cerulean'
game 'gta5'

author 'Goku | .astrozz'
description 'ForsakenWorld Anti-AFK with Captcha (Standalone)'
version '1.0.0'

lua54 'yes'

-- Opt into NUI Callback Strict Mode (requires recent FiveM build).
-- If this causes issues on older builds, set to 'false' or remove this line.
nui_callback_strict_mode 'true'

ui_page 'web/index.html'

shared_script 'config.lua'

client_scripts {
    'client/main.lua',
    'client/ui.lua',
    'client/captcha.lua'
}

server_scripts {
    'server/permissions.lua',
    'server/main.lua'
}

files {
    'web/index.html',
    'web/style.css',
    'web/app.js'
}

escrow_ignore {
    'client/*',
    'server/*',
    'web/*',
    'config.lua'
}

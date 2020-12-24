fx_version 'adamant'
game 'gta5'

client_scripts {
    "src/client/ui.client.lua",
    "src/client/client.lua",

    -- Blip
    "src/blip/blip.client.lua",
    "src/blip/blips.client.lua",
}

exports {
    -- client
    "GetClosestPlayer",
    "LoadAnimSet",
    "actionPlayer",

    -- Ui
    "HelpPromt",
    "LoadingPromt",
    "Message",
    "Notification",
    "AdvancedNotification",
    "Text",
    "OpenTextInput",
    "TextNotification",
    "Show3DText",

    -- Blip
    "AddBlip",
    "RemoveBlip",
    "ShowBlip",
    "HideBlip",
}

server_scripts {
    -- Utils
    "src/utils/utils.server.lua",
}

server_exports {
        -- Utils
        "TableLength",
        "PrintTable",
        "Round",
        "GetDiscordFromSource",
        "TableContainsValue",
        "GetLastContentValue",
        "DebugPrint",
        "SetDebug",
        "GetRandomString",
        "Copy",
        "Clone",
}
fx_version 'adamant'
game 'gta5'

dependency "rageUI"

client_scripts {
    -- RageUI
    "@rageUI/RMenu.lua",
    "@rageUI/menu/RageUI.lua",
    "@rageUI/menu/Menu.lua",
    "@rageUI/menu/MenuController.lua",
    "@rageUI/components/Audio.lua",
    "@rageUI/components/Enum.lua",
    "@rageUI/components/Keys.lua",
    "@rageUI/components/Rectangle.lua",
    "@rageUI/components/Sprite.lua",
    "@rageUI/components/Text.lua",
    "@rageUI/components/Visual.lua",
    "@rageUI/menu/elements/ItemsBadge.lua",
    "@rageUI/menu/elements/ItemsColour.lua",
    "@rageUI/menu/elements/PanelColour.lua",
    "@rageUI/menu/items/UIButton.lua",
    "@rageUI/menu/items/UICheckBox.lua",
    "@rageUI/menu/items/UIList.lua",
    "@rageUI/menu/items/UISeparator.lua",
    "@rageUI/menu/items/UISlider.lua",
    "@rageUI/menu/items/UISliderHeritage.lua",
    "@rageUI/menu/items/UISliderProgress.lua",
    "@rageUI/menu/panels/UIColourPanel.lua",
    "@rageUI/menu/panels/UIGridPanel.lua",
    "@rageUI/menu/panels/UIPercentagePanel.lua",
    "@rageUI/menu/panels/UISpritPanel.lua",
    "@rageUI/menu/panels/UIStatisticsPanel.lua",
    "@rageUI/menu/windows/UIHeritage.lua",
    -- RageUI


    -- Utils
    "src/utils/utils.common.lua",
    "src/utils/utils.client.lua",

    -- UI
    "src/client/ui.client.lua",
    "src/client/client.lua",

    -- Menu
    "src/menu/menu.client.lua",
    "src/menu/menus.client.lua",

    -- Blip
    "src/blip/blip.client.lua",
    "src/blip/blips.client.lua",

    -- Trigger
    "src/trigger/trigger.client.lua",
    "src/trigger/triggers.client.lua",

    -- Marker
    "src/marker/marker.client.lua",
    "src/marker/markers.client.lua",

    -- Area
    "src/area/area.client.lua",
    "src/area/areas.client.lua",

    "src/load.client.lua",

    -- Entity
    "src/entity/entity.client.lua",
    "src/entity/object.client.lua",
    "src/entity/ped.client.lua",
    "src/entity/pickup.client.lua",
    "src/entity/player.client.lua",
    "src/entity/vehicle.client.lua",

    -- Progress
    "src/progress/progress.lua"
}

exports {
    -- client
    "GetClosestPlayer",
    "LoadAnimSet",
    "LoadModel",
    "actionPlayer",

    -- Utils
    "TableLength",
    "Round",
    "CommaValue",
    "SetDebug",
    "Print",
    "PrintTable",
    "TableContainsValue",
    "GetLastContentValue",
    "GetRandomString",
    "GetDistanceBetween3DCoords",
    "PrintTable",
    "Copy",
    "Clone",
    "getPlayerIdentifiers",
    "Money",
    

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

    -- Menu
    "AddMenu",
    "AddSubMenu",
    "RemoveMenu",
    "Key",

    -- Blip
    "AddBlip",
    "RemoveBlip",
    "ShowBlip",
    "HideBlip",

    
    -- Trigger
    "AddTrigger",
    "RemoveTrigger",
    "SwitchTrigger",
    "EnableTrigger",
    "DisableTrigger",
    "CurrentTrigger",

    -- Marker
    "AddMarker",
    "RemoveMarker",
    "EnableMarker",
    "DisableMarker",
    "SwitchMarker",
    "CurrentMarker",

    -- Areas
    "AddArea",
    "RemoveArea",
    "EnableArea",
    "DisableArea",
    "SwitchArea",

    -- Entity
    "GetEntitiesInArea",
    "GetEntityInDirection",
    "GetEntityObjectInDirection",
    "GetEntitiesInAround",
    "CastRayPlayerPedToPoint",

    -- Player
    "GetPlayerPed",
    "GetPlayersId",
    "GetPlayersPed",
    "GetPlayerCoords",
    "GetPlayersPedOrderById",
    "GetPlayerPedInDirection",
    "GetPlayerServerIdInDirection",
    "actionPlayer",
    "tpPlayer",
    "isPedDrivingAVehicle",
}

server_scripts {
    -- Utils
    "src/utils/utils.common.lua",
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


ui_page 'html/index.html'

ui_page_preload 'yes'

files {
  'html/index.html',
  'html/index.css',
  'html/app.js',
}
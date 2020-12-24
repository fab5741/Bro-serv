fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

ui_page_preload 'yes'

files {
  'html/index.html',
  'html/index.css',
  'html/app.js',
}

client_scripts {

    -- Utils
    "src/utils/utils.common.lua",
    "src/utils/utils.client.lua",

    -- Ui
    "src/ui/ui.client.lua",
    "src/ui/instructionalButtons.client.lua",

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

    -- Event 100% load
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

    -- Instructional Buttons
    "AddInstructionalButtons",
    "RemoveInstructionalButtons",
    "DisplayInstructionalButtons",
    "GetCurrentInstructionalButtons",

    -- Menu
    "AddMenu",
    "RemoveMenu",
    "MenuIsOpen",
    "PrimaryMenu",
    "GetCurrentMenu",
    "GetPrimaryMenu",
    "FreezeMenu",
    "OpenMenu",
    "CloseMenu",
    "NextMenu",
    "BackMenu",
    "CleanMenuButtons",
    "SetMenuButtons",
    "SetMenuValue",
    "AddMenuButton",
    "RemoveMenuButton",
    "SelecteButton",

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

    -- Debug
    "SetDebug",
    "DebugPrint",

    -- Entity
    "GetEntitiesInArea",
    "GetEntityInDirection",
    "GetEntityObjectInDirection",
    "GetEntitiesInAround",
    "CastRayPlayerPedToPoint",

    -- Objects
    "GetObjects",
    "GetObjectsInArea",
    "GetObjectsInAround",
    "GetObjectInDirection",

    -- Peds
    "GetPeds",
    "GetPedsInArea",
    "GetPedsInAround",
    "GetPedInDirection",

    -- Vehicules
    "GetVehicles",
    "GetVehiclesInArea",
    "GetVehiclesInAround",
    "GetVehicleInDirection",

    -- Vehicules
    "GetPickups",
    "GetPickupsInArea",
    "GetPickupsInAround",
    "spawnCar",

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
    -- Dependencies
    "src/server.lua",
}

server_exports {

    -- Utils
    "TableLength",
    "PrintTable",
    "Round",
    "GetSteamIDFormSource",
    "GetDiscordFromSource",
    "GetIpFormSource",
    "TableContainsValue",
    "GetLastContentValue",
    "DebugPrint",
    "SetDebug",
    "GetRandomString",
    "Copy",
    "Clone",
}

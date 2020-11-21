local spawned = false

Citizen.CreateThread(function()
    -- wait for player to be spawned
    while not spawned do
        Citizen.Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            local ped = PlayerPedId()
            SetCanAttackFriendly(ped, true, true)
            NetworkSetFriendlyFireOption(true)
            TriggerServerEvent('skin:getPlayerSkin', "spawn:spawn")
            spawned = true
        end 
    end

    -- le player est spawn, on check des events comme la mort
    while spawned do
        Citizen.Wait(2000)
        if(IsPedDeadOrDying(GetPlayerPed(-1)) and not isDead)then
            TriggerEvent("player:dead")
        end
    end
end)

RegisterNetEvent("player:saveCoords")

-- source is global here, don't add to function
AddEventHandler('player:saveCoords', function ()
    TriggerServerEvent("player:saveCoordsServer", GetPlayerName(PlayerId()),GetEntityCoords(GetPlayerPed(-1)))
end)

-- boucle pour sauvegarder toutes les X s
Citizen.CreateThread(function()
    while true do
        Wait(10000)
        TriggerEvent("player:saveCoords")
    end
end)

RegisterNetEvent("spawn:spawn")

-- source is global here, don't add to function
AddEventHandler('spawn:spawn', function (skin, clothes, jobSkin, x, y, z)
    if skin == nil or skin == "" or skin == "{}" then
        print("start nicoo")
        TriggerEvent('nicoo_charcreator:CharCreator')
        Citizen.Wait(100)
        skinLoaded = true
    else
        TriggerEvent('skinchanger:loadSkin', skin)
        Citizen.Wait(100)
        skinLoaded = true
    end
    spawnPlayer(x, y, z)
end)
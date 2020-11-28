local spawned = false

Citizen.CreateThread(function()
    -- wait for player to be spawned
    while not spawned do
        Citizen.Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            local ped = PlayerPedId()
            SetCanAttackFriendly(ped, true, true)
            NetworkSetFriendlyFireOption(true)
            TriggerServerEvent('player:get', "spawn:spawn")
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

function spawnPlayerBegin(player)
    print(player.skin)
    if player.skin == nil or player.skin == "" then
        TriggerEvent('nicoo_charcreator:CharCreator')
        Citizen.Wait(100)
    else
        TriggerEvent('skinchanger:loadClothes', json.decode(player.skin), json.decode(player.clothes))
        Citizen.Wait(100)
    end
    spawnPlayer(player.x,player.y, player.z)
end

RegisterNetEvent("spawn:spawn")

AddEventHandler('spawn:spawn', function (player)
    if player == nil then
        TriggerServerEvent("player:create", "spawn:spawn:2")
    else
        spawnPlayerBegin(player)
    end
end)

RegisterNetEvent("spawn:spawn2")

AddEventHandler('spawn:spawn', function (player)
    spawnPlayerBegin(player)
end)
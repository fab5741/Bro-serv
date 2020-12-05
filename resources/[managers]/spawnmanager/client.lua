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

weaponsHashes = {
    "WEAPON_PISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_MACHETE",
    "WEAPON_BAT",
    "WEAPON_BALL",
    "WEAPON_FLASHLIGHT",
    "WEAPON_NIGHTSTICK",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_SMG"
}

RegisterNetEvent("player:saveCoords")

-- source is global here, don't add to function
AddEventHandler('player:saveCoords', function ()
    local weapons = {

    }
    for k,v in pairs(weaponsHashes) do
        if HasPedGotWeapon(GetPlayerPed(-1), v, false) then 
            weapons[#weapons+1] = v
        end
    end
    TriggerServerEvent("player:saveCoordsServer", GetEntityCoords(GetPlayerPed(-1)), json.encode(weapons))
end)

-- boucle pour sauvegarder toutes les X s
Citizen.CreateThread(function()
    while true do
        Wait(10000)
        print("save coords")
        TriggerEvent("player:saveCoords")
    end
end)

function spawnPlayerBegin(player)
    if player.skin == nil or player.skin == "" then
        TriggerEvent('nicoo_charcreator:CharCreator')
        Citizen.Wait(100)
    else
        if(player.clothes ~= nil) then
            TriggerEvent('skinchanger:loadClothes', json.decode(player.skin), json.decode(player.clothes))
        else
            TriggerEvent('skinchanger:loadSkin', json.decode(player.skin), function() end)
        end
        Citizen.Wait(100)
    end
    spawnPlayer(player.x,player.y, player.z, player.weapons)

end

RegisterNetEvent("spawn:spawn")

AddEventHandler('spawn:spawn', function (player)
    if player == nil then
        TriggerServerEvent("player:create", "spawn:spawn:2")
    else
        spawnPlayerBegin(player)
    end
end)

RegisterNetEvent("spawn:spawn:2")

AddEventHandler('spawn:spawn:2', function (player)
    spawnPlayerBegin(player)
end)
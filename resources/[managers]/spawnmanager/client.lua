local spawned = false

Citizen.CreateThread(function()
    -- wait for player to be spawned
    while not spawned do
        Citizen.Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent("player:spawnPlayerFromLastPos")
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

-- try to get player
TriggerServerEvent("player:get", "spawnmanager:player:get")


RegisterNetEvent("player:identityCreate")

local playerCreating = false

AddEventHandler('player:identityCreate', function (data)
    -- create player identity
    if not playerCreating then
        playerCreating = true
        local myData = {}
        for k,v in ipairs(data) do
            print(k,v, v.name, v.value)
            myData[v.name] = v.value
        end
        
        TriggerServerEvent("player:set", myData)
        TriggerEvent(
            "menu:delete", "identity"
        )
    end
end)


RegisterNetEvent("spawnmanager:player:get")
local items = {
    {name = "firstName", label =  'Nom :',    type = "text", placeholder = "John"},
{name = "lastName",  label =  'Prénom : ',     type = "text", placeholder = "Smith"},
{name = "birth",       label =  'Date de naissance :',    type = "text", placeholder = "01/02/1234"},
{name = "sex",    label =  'Male :',   type = "checkbox", placeholder = "male"},
}

AddEventHandler('spawnmanager:player:get', function (data)
    if data == nil then
        TriggerEvent(
            "menu:create", "identity", "Création identité", "form",
            "", items, "center|midlle", "identityCreate", "player:identityCreate"
        ) 
    end
end)



RegisterNetEvent("player:spawnLastPos")

-- source is global here, don't add to function
AddEventHandler('player:spawnLastPos', function (x,y,z, skin)
    local ped = PlayerPedId()
	SetCanAttackFriendly(ped, true, true)
	NetworkSetFriendlyFireOption(true)
    spawnPlayer(x, y, z, skin)
end)
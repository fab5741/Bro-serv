
RegisterNUICallback('use', function(data)
    if data.label == "Pain" then
        print("change needs ")
        eat()
        TriggerServerEvent("needs:change", 1, 60)
    end
    if data.label == "Eau" then
        TriggerServerEvent("needs:change", 0, 60)
    end
    if data.label == "Jus de raisin" then
        TriggerServerEvent("needs:change", 1, 80)
        TriggerServerEvent("needs:change", 0, 10)
    end

    TriggerServerEvent("items:sub", data.item, data.amount)
end)

RegisterNetEvent("items:eat")
AddEventHandler("items:eat", function()
    local prop_name = 'prop_cs_burger_01'

    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(playerPed))
        local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
        local boneIndex = GetPedBoneIndex(playerPed, 18905)
        AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
        RequestAnimDict("mp_player_inteat@burger")
        TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

        Citizen.Wait(3000)
        IsAnimated = false
        ClearPedSecondaryTask(playerPed)
        DeleteObject(prop)
    end)
end)

RegisterNetEvent("items:drink")
AddEventHandler("items:drink", function()
    local prop_name = 'prop_ld_flow_bottle'

    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(playerPed))
        local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
        local boneIndex = GetPedBoneIndex(playerPed, 18905)
        AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
        RequestAnimDict("mp_player_intdrink")
        TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

        Citizen.Wait(3000)
        IsAnimated = false
        ClearPedSecondaryTask(playerPed)
        DeleteObject(prop)
    end)
end)

RegisterNetEvent("items:add")
AddEventHandler("items:add", function(type, amount, message)
    TriggerServerEvent("items:add", type, amount, message)
end)
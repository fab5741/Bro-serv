local IsAnimated = false

RegisterNetEvent("items:eat")
AddEventHandler("items:eat", function()
    if not IsAnimated then
        IsAnimated = true
        Citizen.CreateThread(function()
            local playerPed = PlayerPedId() 
            local prop_name = 'prop_cs_burger_01'

            local x,y,z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
            exports.bro_core:LoadAnimSet("mp_player_inteat@burger")
            TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, 1.0, -1, 1, 1.0, false, false, false)
   --         TriggerEvent("bro_core:progressBar:create", 3000, "Vous mangez")

            Citizen.Wait(3000)
            ClearPedTasksImmediately(playerPed)
            DeleteObject(prop)
            IsAnimated = false
        end)
    end
end)

RegisterNetEvent("items:drink")
AddEventHandler("items:drink", function()
    if not IsAnimated then
        IsAnimated = true
        Citizen.CreateThread(function()
            local playerPed = PlayerPedId() 
            local prop_name = 'prop_ld_flow_bottle'

            local x,y,z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
            exports.bro_core:LoadAnimSet("mp_player_intdrink")
            TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
      --      TriggerEvent("bro_core:progressBar:create", 3000, "Vous buvez")

            Citizen.Wait(3000)
            ClearPedTasksImmediately(playerPed)
            DeleteObject(prop)
            IsAnimated = false
        end)
    end
end)

RegisterNetEvent("items:add")
AddEventHandler("items:add", function(type, amount, message)
    TriggerServerEvent("items:add", type, amount, message)
end)

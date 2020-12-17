
hunger = 100
thirst = 100

local thirstTickRate = 90 * 1000
local dangerTickRate = 2000

Citizen.CreateThread(function()
    TriggerServerEvent("needs:get", "needs:spawn2")
    while true do
        Citizen.Wait(dangerTickRate)
        if(hunger < 0 or thirst < 0) then
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1))-10)
        end
	end
end)

RegisterNetEvent("needs:spawn2")

-- source is global here, don't add to function
AddEventHandler('needs:spawn2', function(hunger, thirst)
    TriggerEvent("bf:progress:create", "hunger") 
    TriggerEvent("bf:progress:create", "thirst") 
    hunger = hunger
    thirst = thirst
    TriggerEvent("bf:progress:udpate", "hunger", hunger) 
    TriggerEvent("bf:progress:udpate", "thirst", thirst) 
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(thirstTickRate)
            TriggerServerEvent("needs:get", "needs:update")
        end
    end)
end)
RegisterNetEvent("needs:update")

-- source is global here, don't add to function
AddEventHandler('needs:update', function(hunger, thirst)
    if hunger > 0 and thirst > 0 then
        hunger = hunger -1
        thirst = thirst -1
        TriggerEvent("bf:progress:udpate", "hunger", hunger) 
        TriggerEvent("bf:progress:udpate", "thirst", thirst) 
        TriggerServerEvent("needs:set", hunger, thirst)
    end
end)

RegisterNetEvent("needs:change")

-- source is global here, don't add to function
AddEventHandler('needs:change', function(isHunger, amount)
    TriggerServerEvent("needs:get2", "needs:change2", isHunger, amount)
end)

RegisterNetEvent("needs:change2")

-- source is global here, don't add to function
AddEventHandler('needs:change2', function(hunger, thirst)
    print(hunger)
    print(thirst)
    TriggerEvent("bf:progress:udpate", "hunger", hunger) 
    TriggerEvent("bf:progress:udpate", "thirst", thirst) 
    TriggerServerEvent("needs:set", hunger, thirst)
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' was stopped.')
    TriggerEvent("bf:progress:delete", "hunger") 
    TriggerEvent("bf:progress:delete", "thirst") 
  end)
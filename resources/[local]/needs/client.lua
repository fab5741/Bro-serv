
local hunger = 100
local thirst = 100

local thirstTickRate = 90 * 1000

Citizen.CreateThread(function()
    TriggerEvent("bf:progress:create", "hunger") 
    TriggerEvent("bf:progress:create", "thirst") 
    TriggerServerEvent("needs:get", "needs:spawn2")
end)

local dangerTickRate = 2000

Citizen.CreateThread(function()
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
    hunger = hunger
    thirst = thirst
    TriggerEvent("bf:progress:udpate", "hunger", hunger) 
    TriggerEvent("bf:progress:udpate", "thirst", thirst) 
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(thirstTickRate)
            if hunger > 0 and thirst > 0 then
                hunger = hunger -1
                thirst = thirst -1
                TriggerEvent("bf:progress:udpate", "hunger", hunger) 
                TriggerEvent("bf:progress:udpate", "thirst", thirst) 
                TriggerServerEvent("needs:set", hunger, thirst)
            end
        end
    end)
end)

RegisterNetEvent("needs:change")


-- source is global here, don't add to function
AddEventHandler('needs:change', function(isHunger, amount)
    if(isHunger == 1) then
        hunger = hunger + amount
    else
        thirst = thirst + amount
    end
    if(hunger >100) then
        hunger = 100
    end
    if thirst >100 then
        thirst = 100
    end
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
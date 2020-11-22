
local hunger = 100
local thirsty = 100

local thirstTickRate = 36 * 1000

Citizen.CreateThread(function()
    TriggerEvent("bf:progress:create", "hunger") 
    TriggerEvent("bf:progress:create", "thirsty") 

	while true do
        Citizen.Wait(thirstTickRate)
        hunger = hunger -1
        thirsty = thirsty -1
        TriggerEvent("bf:progress:udpate", "hunger", hunger) 
        TriggerEvent("bf:progress:udpate", "thirsty", thirsty) 
	end
end)

local dangerTickRate = 2000

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(dangerTickRate)
        if(hunger < 0 or thirsty < 0) then
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1))-10)
        end
	end
end)


RegisterNetEvent("needs:spawned")

-- source is global here, don't add to function
AddEventHandler('needs:spawned', function()
    hunger = 100
    thirsty = 100
    TriggerEvent("bf:progress:udpate", "hunger", hunger) 
    TriggerEvent("bf:progress:udpate", "thirsty", thirsty) 
end)

RegisterNetEvent("needs:change")


-- source is global here, don't add to function
AddEventHandler('needs:change', function(isHunger, amount)
    print("CHANGE NEEDS",  isHunger, amount)
    if(isHunger == 1) then
        hunger = hunger + amount
    else
        thirsty = thirsty + amount
    end
    if(hunger >100) then
        hunger = 100
    end
    if thirsty >100 then
        thirsty = 100
    end
    TriggerEvent("bf:progress:udpate", "hunger", hunger) 
    TriggerEvent("bf:progress:udpate", "thirsty", thirsty) 
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' was stopped.')
    TriggerEvent("bf:progress:delete", "hunger") 
    TriggerEvent("bf:progress:delete", "thirsty") 
  end)
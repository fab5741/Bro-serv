RegisterNetEvent("atm:liquid")

AddEventHandler('atm:liquid', function(data)
	liquid = data
	TriggerServerEvent("account:player:get", "atm:get")
end)

RegisterNetEvent("atm:get")

AddEventHandler('atm:get', function(data)
	Wait(0)
	account = data
	exports.bf:SetMenuValue("atm", {
		menuTitle = "LQD ~g~" .. liquid .. " $~s~ / CMP ~g~" .. account.." $",
	})
	exports.bf:CloseMenu("atm")
	exports.bf:OpenMenu("atm")
end)


-- On nettoie le caca
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
    end
    print("on nettoie le caca")
	exports.bf:RemoveMenu("atm")
	exports.bf:RemoveArea("atm")
  end)
  
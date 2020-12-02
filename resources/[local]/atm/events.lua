RegisterNetEvent("atm:get")

AddEventHandler('atm:get', function(account, liquid)
	print(account)
	print(liquid)
	account = account
	liquid = liquid
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
	exports.bf:RemoveMenu("atm")
	exports.bf:RemoveArea("atm")
  end)
  
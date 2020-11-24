
PerformHttpRequest("https://raw.githubusercontent.com/FiveM-Scripts/autotaxi/master/__resource.lua", function(errorCode, result, headers)
    local version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)

    if string.find(tostring(result), version) == nil then
        print("\n\r[autotaxi] The version on this server is not up to date. Please update now.\n\r")
    end
end, "GET", "", "")

RegisterServerEvent('autotaxi:payCab')
AddEventHandler('autotaxi:payCab', function(meters)
	local src = source
	
	local totalPrice = meters / 40.0
	local price = math.floor(totalPrice)
	
	if optional.use_essentialmode then
		TriggerEvent('es:getPlayerFromId', src, function(user)
			if user.getMoney() >= tonumber(price) then
				user.removeMoney(tonumber(price))
				TriggerClientEvent('autotaxi:payment-status', src, true)
			else
				TriggerClientEvent('autotaxi:payment-status', src, false)
			end
		end)
	elseif optional.use_venomous then
		TriggerEvent('vf_base:FindPlayer', src, function(user)
			if user.cash >= tonumber(price) then
				TriggerEvent('vf_base:ClearCash', src, tonumber(price))
				TriggerClientEvent('autotaxi:payment-status', src, true)				
			else
				TriggerClientEvent('autotaxi:payment-status', src, false)
			end
		end)
	else
		TriggerClientEvent('autotaxi:payment-status', src, true)	
	end
end)
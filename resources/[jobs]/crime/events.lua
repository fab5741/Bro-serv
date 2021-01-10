-- Registers
RegisterNetEvent('crime:drug:sell:start')
RegisterNetEvent('crime:drug:sell:stop')
RegisterNetEvent('crime:drug:poucave')
RegisterNetEvent('crime:drug:sell')
RegisterNetEvent('crime:malette:sell')

-- EVENTS
-- drug detail
AddEventHandler('crime:drug:sell:start', function()
	isSellingDrug = true
	exports.bro_core:AdvancedNotification({
		type = 1,
		text = "Revente de drogue ~b~lancée",
		title = "Tommy",
		subTitle = "Weed",
	})
end)

AddEventHandler('crime:drug:sell:stop', function()
	isSellingDrug = false
	exports.bro_core:AdvancedNotification({
		type = 1,
		text = "Revente de drogue ~o~stopée",
		title = "Tommy",
		subTitle = "Weed",
	})
end)

AddEventHandler('crime:drug:poucave', function(posx, posy, posz)
	--TriggerServerEvent('phone:startCall', 'lspd', "deal en cours", { x = posx, y = posy, z = posz })
	TriggerServerEvent("job:avert:all", "lspd", "Deal en cours", true, GetEntityCoords(GetPlayerPed(-1)))
end)

AddEventHandler('crime:drug:sell', function(price)
	TriggerServerEvent("account:player:liquid:add", "", price)
	TriggerServerEvent("items:sub", 7, 1)
end)

-- malettes
AddEventHandler('crime:malette:sell', function(amount)
	if amount ~= nil and amount >= tonumber(nbMalettes) then
		TriggerServerEvent("account:player:liquid:add", "", nbMalettes * 50)
		TriggerServerEvent("items:sub", 8, nbMalettes)
		exports.bro_core:Notification("Vous avez vendu pour : "..exports.bro_core:Money(nbMalettes*50))
	else
		exports.bro_core:Notification("~r~Vous n'avez pas assez de malettes sur vous")
	end
	nbMalettes = 0
end)


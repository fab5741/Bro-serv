RegisterNetEvent("vehicle:buy")

AddEventHandler("vehicle:buy", function(data)
    MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid from players where fivem = @fivem',
        {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]},
		function(res)
			if res[1] and res[1].liquid >= amounte then
				MySQL.Async.fetchAll('UPDATE accounts, players set amount=amount+@amount, liquid=liquid-@amount where fivem = @fivem and accounts.player = players.id',
				{['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
				['amount'] = amounte},
				function(res)
					TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Depot effectué", type = "info", timeout = 5000})
				end)
			else
				TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Depot loupé (Pas assez de liquide)", type = "info", timeout = 5000})
			end
        end)
      end)
end)

RegisterNetEvent("vehicle:menu:buy")

AddEventHandler("vehicle:menu:buy", function()
    local sourceValue = source
    MySQL.Async.fetchAll('SELECT * from vehicles', {
    }, function(result)
        TriggerClientEvent("vehicle:menu:buy", sourceValue, result)
    end)
end)


RegisterNetEvent("vehicle:menu:parking:get")

AddEventHandler("vehicle:menu:parking:get", function(id)
    local sourceValue = source
    local ide = id
    MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label from players, player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id and player_vehicle.player = players.id and players.fivem = @fivem and player_vehicle.parking = @id', {
        ['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
        ['id'] =  id,
    }, function(result)
            TriggerClientEvent("vehicle:menu:parking:get", sourceValue, result, ide)
    end)
end)

RegisterNetEvent("vehicle:parking:get")

AddEventHandler("vehicle:parking:get", function(id)
    MySQL.Async.fetchAll('UPDATE `player_vehicle` SET parking = NULL WHERE `player_vehicle`.`id` = @id ', {
        ['id'] =  id,
    }, function(result)
        print("get")
    end)
end)


RegisterNetEvent("vehicle:store")

AddEventHandler("vehicle:store", function(vehicle, parking)
    local sourceValue = source
    print(vehicle, parking)
    MySQL.Async.fetchAll('UPDATE `player_vehicle` SET parking = @parking WHERE `player_vehicle`.`id` = @vehicle ', {
        ['vehicle'] =  vehicle,
        ['parking'] =  parking,
    }, function(result)
        print("updated", parking)
    end)
end)
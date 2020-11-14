RegisterNetEvent("vehicle:buy")

AddEventHandler("vehicle:buy", function(id, name)
	local sourceValue = source

	for k,v in pairs(GetPlayerIdentifiers(source))do
				
		  if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		  elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		  elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		  elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		  elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		  elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		  end
	end
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid from players where fivem = @fivem',
        {['fivem'] =  discord},
		function(res)
			MySQL.Async.fetchAll('SELECT price FROM `vehicles` where id = @id', {['id'] = id}, function(price)
				if res[1] and price[1] and res[1].liquid >= price[1].price then
					print(res[1].liquid)
					print(price[1].price)
					print("ON ACHETE")
					MySQL.Async.fetchAll('UPDATE players set liquid=liquid-@price where fivem = @fivem',
					{['fivem'] =  discord,
					['price'] = price[1].price},
					function(res)
						TriggerClientEvent("lspd:notify", sourceValue, "CHAR_AGENT14", 1,"Vous avez acheté une ".. name, false)
						TriggerClientEvent("vehicle:buyok", sourceValue, name)
					end)
				else
					TriggerClientEvent("lspd:notify", sourceValue, "CHAR_AGENT14", 1,"Vous n'avez pas assé d'argent", false)
				end
			end)
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

	for k,v in pairs(GetPlayerIdentifiers(sourceValue))do
		
			
		  if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		  elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		  elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		  elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		  elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		  elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		  end
	end
    local ide = id
    MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label from players, player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id and player_vehicle.player = players.id and players.fivem = @fivem and player_vehicle.parking = @id', {
        ['fivem'] =  discord,
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
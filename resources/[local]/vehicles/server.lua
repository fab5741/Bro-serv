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

RegisterNetEvent("vehicle:depots:get:all")

AddEventHandler("vehicle:depots:get:all", function(cb)
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
    MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label from players, player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id and player_vehicle.player = players.id and players.fivem = @fivem and player_vehicle.parking = "depot"', {
        ['fivem'] =  discord,
	}, function(result)
            TriggerClientEvent(cb, sourceValue, result)
    end)
end)



RegisterNetEvent("vehicle:parking:get:all")

AddEventHandler("vehicle:parking:get:all", function(id, cb)
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
	print(id)
	print(discord)
    MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label from players, player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id and player_vehicle.player = players.id and players.fivem = @fivem and player_vehicle.parking = @id', {
        ['fivem'] =  discord,
        ['id'] =  id,
    }, function(result)
            TriggerClientEvent(cb, sourceValue, result)
    end)
end)

RegisterNetEvent("vehicles:get:all")

AddEventHandler("vehicles:get:all", function(cb)
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
    MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label, player_vehicle.parking from players, player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id', {
        ['fivem'] =  discord,
    }, function(result)
            TriggerClientEvent(cb, sourceValue, result)
    end)
end)

RegisterNetEvent("vehicle:parking:get")

AddEventHandler("vehicle:parking:get", function(id, cb)
	local sourceValue = source
    MySQL.Async.fetchAll('UPDATE `player_vehicle` SET parking = "" WHERE `player_vehicle`.`id` = @id ', {
        ['id'] =  id,
	}, function(result)
		MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label from player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id and player_vehicle.id = @id', {
			['fivem'] =  discord,
			['id'] =  id,
		}, function(result)
			TriggerClientEvent(cb, sourceValue, result[1])
		end)
    end)
end)


RegisterNetEvent("vehicle:store")

AddEventHandler("vehicle:store", function(vehicle, parking)
    local sourceValue = source
    MySQL.Async.fetchAll('UPDATE `player_vehicle` SET parking = @parking WHERE `player_vehicle`.`id` = @vehicle ', {
        ['vehicle'] =  vehicle,
        ['parking'] =  parking,
    }, function(result)
        print("updated", parking)
    end)
end)

RegisterNetEvent("vehicle:set:id")

AddEventHandler("vehicle:set:id", function(vehicle, id)
    local sourceValue = source
    MySQL.Async.fetchAll('UPDATE `player_vehicle` SET gameId= @id WHERE `player_vehicle`.`id` = @vehicle ', {
        ['vehicle'] =  vehicle,
        ['id'] =  id,
    }, function(result)
    end)
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		MySQL.ready(function ()
				MySQL.Async.fetchAll('select * from player_vehicle, vehicles where parking = "" and vehicles.id = player_vehicle.vehicle',{},
				function(res)
					for k,v in pairs(res) do    
				--	print(v.gameId)
					end       
				end)
		end)
	end
end)


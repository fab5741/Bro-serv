RegisterNetEvent("vehicle:buy")

AddEventHandler("vehicle:buy", function(cb, id)
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
		MySQL.Async.fetchAll('select liquid, id from players where fivem = @fivem',
        {['fivem'] =  discord},
		function(res)
			MySQL.Async.fetchAll('SELECT price, id, label FROM `vehicles` where id = @id', {['id'] = id}, function(res2)
				if res[1] and res2[1] and res[1].liquid >= res2[1].price then
					MySQL.Async.fetchAll('UPDATE players set liquid=liquid-@price where fivem = @fivem',
					{['fivem'] =  discord,
					['price'] = res2[1].price},
					function(res3)
						MySQL.Async.fetchAll("INSERT INTO `player_vehicle` (`id`, `player`, `vehicle`, `parking`, `gameId`) VALUES (NULL, @player , @vehicle, '', 0)",
						{
							['player'] = res[1].id,
							['vehicle'] = res2[1].id
						},
						function(res4)
							print("OK")
							TriggerClientEvent("bf:Notification", sourceValue, "Vous avez acheté une ~o~".. res2[1].label)
							TriggerClientEvent(cb, sourceValue, res2[1].label)
						end)
					end)
				else
					TriggerClientEvent("bf:Notification", sourceValue, "Vous n'avez pas assez d'argent")
				end
			end)
        end)
      end)
end)

RegisterNetEvent("vehicle:ds")

AddEventHandler("vehicle:ds", function(cb, price)
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
		MySQL.Async.fetchAll('select liquid, id, permis from players where fivem = @fivem',
        {['fivem'] =  discord},
		function(res)
			if res[1] and res[1].liquid >= price and res[1].permis == 0 then
				MySQL.Async.fetchAll('UPDATE players set liquid=liquid-@price where fivem = @fivem',
				{['fivem'] =  discord,
				['price'] = price},
				function(res3)
					TriggerClientEvent(cb, sourceValue)
				end)
			else
				TriggerClientEvent("bf:Notification", sourceValue, "Vous n'avez pas assez d'argent")
			end
		end)
	end)
end)

RegisterNetEvent("vehicle:shop:get:all")

AddEventHandler("vehicle:shop:get:all", function(cb)
    local sourceValue = source
    MySQL.Async.fetchAll('SELECT * from vehicles', {
    }, function(result)
        TriggerClientEvent(cb, sourceValue, result)
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
	print("STORE")
    local sourceValue = source
    MySQL.Async.fetchAll('UPDATE `player_vehicle` SET parking = @parking WHERE `player_vehicle`.`id` = @vehicle ', {
        ['vehicle'] =  vehicle,
        ['parking'] =  parking,
    }, function(result)
        print("updated", parking)
    end)
end)


RegisterNetEvent("vehicle:job:store")

AddEventHandler("vehicle:job:store", function(vehicle, parking)
	print("STORE")
    local sourceValue = source
    MySQL.Async.fetchAll('UPDATE `job_vehicle` SET parking = @parking WHERE `job_vehicle`.`id` = @vehicle ', {
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


-- Permis
RegisterNetEvent("vehicle:permis:give")

AddEventHandler("vehicle:permis:give", function()
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
    MySQL.Async.fetchAll('UPDATE `players` SET permis= 1 WHERE fivem = @fivem ', {
        ['fivem'] =  discord,
	}, function(result)
		TriggerClientEvent("bf:Notification", sourceValue, "Permis enregistré")
    end)
end)

RegisterNetEvent("vehicle:permis:get")

AddEventHandler("vehicle:permis:get", function(cb)
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
    MySQL.Async.fetchScalar('select permis from players where fivem = @fivem ', {
        ['fivem'] =  discord,
	}, function(result)
		TriggerClientEvent(cb, sourceValue, result)
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


--jobs
RegisterNetEvent("vehicle:job:parking")

AddEventHandler("vehicle:job:parking", function(cb, job)
    local sourceValue = source
    MySQL.Async.fetchAll('SELECT vehicles.label, job_vehicle.id from job_vehicle, vehicles, jobs where job_vehicle.parking = "global" and vehicles.id = job_vehicle.vehicle and job_vehicle.job = jobs.id and jobs.name = @job', {['@job'] = job
    }, function(result)
        TriggerClientEvent(cb, sourceValue, result)
    end)
end)




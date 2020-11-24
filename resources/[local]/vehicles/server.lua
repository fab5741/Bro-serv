RegisterNetEvent("vehicle:buy")

AddEventHandler("vehicle:buy", function(cb, id)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid, id, permis from players where discord = @discord',
        {['discord'] =  discord},
		function(res)
			MySQL.Async.fetchAll('SELECT price, id, label, name FROM `vehicles` where id = @id', {['id'] = id}, function(res2)
				if res[1] and res2[1] and res[1].liquid >= res2[1].price then
					if res[1].permis then
						MySQL.Async.fetchAll('UPDATE players set liquid=liquid-@price where discord = @discord',
							{['discord'] =  discord,
							['price'] = res2[1].price},
							function(res3)
								MySQL.Async.insert("INSERT INTO `player_vehicle` (`id`, `player`, `vehicle`, `parking`, `gameId`) VALUES (NULL, @player , @vehicle, '', 0)",
								{
									['player'] = res[1].id,
									['vehicle'] = res2[1].id
								},
								function(insertId)
										MySQL.Async.execute('UPDATE jobs set money = money + @money where id = @gouv',
										{
											['@gouv'] = 7,
											['@money'] = res2[1].price *(tva),
										},
										function(res)
											TriggerClientEvent("bf:Notification", sourceValue, "Vous avez acheté une ~o~".. res2[1].label)
											TriggerClientEvent(cb, sourceValue, res2[1].name, insertId)
										end)
								end)
							end)
					else
						TriggerClientEvent("bf:Notification", sourceValue, "Vous n'avez pas le permis !")

					end					
				else
					TriggerClientEvent("bf:Notification", sourceValue, "Vous n'avez pas assez d'argent")
				end
			end)
        end)
      end)
end)

RegisterNetEvent("vehicle:job:buy")

AddEventHandler("vehicle:job:buy", function(cb, id, job)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid, players.id, permis, job_grades.job as job from players, job_grades where discord = @discord and job_grades.id = players.job_grade',
        {['discord'] =  discord},
		function(res)
			MySQL.Async.fetchAll('SELECT price, id, label, name FROM `vehicles` where id = @id', {['id'] = id}, function(res2)
				if res[1] and res2[1] and res[1].liquid >= res2[1].price then
					if res[1].permis then
						MySQL.Async.fetchAll('UPDATE players set liquid=liquid-@price where discord = @discord',
							{['discord'] =  discord,
							['price'] = res2[1].price},
							function(res3)
								MySQL.Async.insert("INSERT INTO `job_vehicle` (`id`, `job`, `vehicle`, `parking`, `gameId`) VALUES (NULL, @job , @vehicle, '', 0)",
								{
									['job'] = res[1].job,
									['vehicle'] = res2[1].id
								},
								function(insertId)
									TriggerClientEvent("bf:Notification", sourceValue, "Vous avez acheté une ~o~".. res2[1].label)
									TriggerClientEvent(cb, sourceValue, res2[1].name, insertId)
								end)
							end)
					else
						TriggerClientEvent("bf:Notification", sourceValue, "Vous n'avez pas le permis !")

					end					
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
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid, id, permis from players where discord = @discord',
        {['discord'] =  discord},
		function(res)
			if res[1] and res[1].liquid >= price and res[1].permis == false then
				MySQL.Async.fetchAll('UPDATE players set liquid=liquid-@price where discord = @discord',
				{['discord'] =  discord,
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
	MySQL.ready(function ()
		MySQL.Async.fetchAll('SELECT * from vehicles WHERE job IS  NULL ORDER BY price', {
		}, function(result)
			TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)

RegisterNetEvent("vehicle:shop:job:get:all")

AddEventHandler("vehicle:shop:job:get:all", function(cb)
	local sourceValue = source
	MySQL.ready(function ()
		MySQL.Async.fetchAll('SELECT * from vehicles WHERE job IS NOT NULL ORDER BY price', {
		}, function(result)
			TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)

RegisterNetEvent("vehicle:depots:get:all")

AddEventHandler("vehicle:depots:get:all", function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)


	MySQL.ready(function ()
		MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label from players, player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id and player_vehicle.player = players.id and players.discord = @discord and player_vehicle.parking = "depot"', {
			['discord'] =  discord,
		}, function(result)
				TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)

RegisterNetEvent("vehicle:parking:get:all")

AddEventHandler("vehicle:parking:get:all", function(id, cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	local ide = id
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label from players, player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id and player_vehicle.player = players.id and players.discord = @discord and player_vehicle.parking = @id', {
			['discord'] =  discord,
			['id'] =  id,
		}, function(result)
				TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)

RegisterNetEvent("vehicles:get:all")

AddEventHandler("vehicles:get:all", function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label, player_vehicle.parking from players, player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id', {
			['discord'] =  discord,
		}, function(result)
				TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)


RegisterNetEvent("vehicles:jobs:get:all")

AddEventHandler("vehicles:jobs:get:all", function(cb, job)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('select job_vehicle.id, vehicles.name, vehicles.label, job_vehicle.parking from job_vehicle, vehicles where job_vehicle.vehicle = vehicles.id and job_vehicle.job = @job', {
			['@job'] =  job,
		}, function(result)
				TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)

RegisterNetEvent("vehicle:parking:get")

AddEventHandler("vehicle:parking:get", function(id, cb)
	local sourceValue = source
	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE `player_vehicle` SET parking = "" WHERE `player_vehicle`.`id` = @id ', {
			['id'] =  id,
		}, function(result)
			MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label from player_vehicle, vehicles where player_vehicle.vehicle = vehicles.id and player_vehicle.id = @id', {
				['discord'] =  discord,
				['id'] =  id,
			}, function(result)
				TriggerClientEvent(cb, sourceValue, result[1])
			end)
		end)
	end)
end)


RegisterNetEvent("vehicle:store")

AddEventHandler("vehicle:store", function(vehicle, parking)
	local sourceValue = source
	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE `player_vehicle` SET parking = @parking WHERE `player_vehicle`.`id` = @vehicle ', {
			['vehicle'] =  vehicle,
			['parking'] =  parking,
		}, function(result)
			print("updated", parking)
		end)
	end)
end)


RegisterNetEvent("vehicle:job:store")

AddEventHandler("vehicle:job:store", function(vehicle, parking)
	local sourceValue = source
	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE `job_vehicle` SET parking = @parking WHERE `job_vehicle`.`id` = @vehicle ', {
			['vehicle'] =  vehicle,
			['parking'] =  parking,
		}, function(result)
			print("updated", parking)
		end)
	end)
end)

RegisterNetEvent("vehicle:set:id")

AddEventHandler("vehicle:set:id", function(vehicle, id)
	local sourceValue = source
	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE `player_vehicle` SET gameId= @id WHERE `player_vehicle`.`id` = @vehicle ', {
			['vehicle'] =  vehicle,
			['id'] =  id,
		}, function(result)
		end)
	end)
end)


-- Permis
RegisterNetEvent("vehicle:permis:give")

AddEventHandler("vehicle:permis:give", function()
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE `players` SET permis= 1 WHERE discord = @discord ', {
			['discord'] =  discord,
		}, function(result)
			TriggerClientEvent("bf:Notification", sourceValue, "Permis enregistré")
		end)
	end)
end)

RegisterNetEvent("vehicle:permis:get")

AddEventHandler("vehicle:permis:get", function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select permis from players where discord = @discord ', {
			['discord'] =  discord,
		}, function(result)
			print("get permis")
			TriggerClientEvent(cb, sourceValue, result)
		end)
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
	
	MySQL.ready(function ()
		MySQL.Async.fetchAll('SELECT vehicles.label, job_vehicle.id from job_vehicle, vehicles, jobs where job_vehicle.parking = "global" and vehicles.id = job_vehicle.vehicle and job_vehicle.job = jobs.id and jobs.id = @job', {['@job'] = job
		}, function(result)
			TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)




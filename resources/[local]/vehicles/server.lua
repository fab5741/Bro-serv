RegisterNetEvent("vehicle:buy")
RegisterNetEvent("vehicle:job:buy")
RegisterNetEvent("vehicle:ds")
RegisterNetEvent("vehicle:shop:get:all")
RegisterNetEvent("vehicle:shop:job:get:all")
RegisterNetEvent("vehicle:parking:get:all")
RegisterNetEvent("vehicles:get:all")
RegisterNetEvent("vehicles:jobs:get:all")
RegisterNetEvent("vehicle:parking:get")
RegisterNetEvent("vehicle:parking:store")
RegisterNetEvent("vehicle:job:store")
RegisterNetEvent("vehicle:store")
RegisterNetEvent("vehicle:permis:give")
RegisterNetEvent("vehicle:set:id")
RegisterNetEvent("vehicle:permis:get")
RegisterNetEvent("vehicle:permis:withdraw")
RegisterNetEvent("vehicle:job:parking")
RegisterNetEvent("vehicle:player:get")
RegisterNetEvent("vehicle:parking:job:get")
RegisterNetEvent("vehicle:job:get")
RegisterNetEvent("vehicle:save")
RegisterNetEvent("vehicle:saveId")
RegisterNetEvent("vehicle:mods:save")
RegisterNetEvent("vehicle:lock")
RegisterNetEvent("vehicle:sell")

local tva = 0.20

AddEventHandler("vehicle:buy", function(cb, id)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid, dirty, id, permis from players where discord = @discord',
        {['discord'] =  discord},
		function(res)
			MySQL.Async.fetchAll('SELECT price, id, label, name FROM `vehicles` where id = @id', {['id'] = id}, function(res2)
				if res[1] and res2[1] and res[1].liquid + res[1].dirty >= res2[1].price then
					if res[1].permis then
						MySQL.Async.fetchScalar("select count(name) from player_vehicle, vehicle_mod, vehicles where vehicles.id = vehicle_mod.vehicle and vehicle_mod.id = player_vehicle.vehicle_mod and name = @name",
						{
							['@name'] = res[1].name
						},
						function(count)
							MySQL.Async.fetchScalar("select count(name) from job_vehicle, vehicle_mod, vehicles where vehicles.id = job_vehicle.vehicle_mod and vehicle_mod.id = job_vehicle.vehicle_mod and vehicles.name = @name",
							{
								['@name'] = res[1].name
							},
							function(count2)
								count = count +count2
									if count <= 1 then
										if res[1].dirty >= res2[1].price then
											dirty = res[1].dirty - res2[1].price
											liquid = res[1].liquid
										else
											dirty = 0
											liquid = res[1].liquid - res2[1].price
										end
										MySQL.Async.fetchAll('UPDATE players set liquid=@liquid, dirty=@dirty where discord = @discord',
										{['discord'] =  discord,
										['liquid'] = liquid,
										['dirty'] = dirty},
										function(res3)
											MySQL.Async.insert("INSERT INTO `vehicle_mod` (`id`, `vehicle`, `parking`, `gameId`) VALUES (NULL, @id, '', 0)",
											{
												['@id'] = res2[1].id,
											},
											function(inserted)
												MySQL.Async.insert("INSERT INTO `player_vehicle` (`id`, `player`, `vehicle_mod` ) VALUES (NULL, @player , @vehicle_mod)",
												{
													['@player'] = res[1].id,
													['@vehicle_mod'] = inserted
												},
												function(insertId)
													MySQL.Async.execute('UPDATE accounts set amount = amount + @money where id = 1',
													{
														['@money'] = res2[1].price *(tva),
													},
													function(res)
														TriggerClientEvent("bro_core:Notification", sourceValue, "Vous avez acheté une ~o~".. res2[1].label)
														TriggerClientEvent(cb, sourceValue, res2[1].name, insertId)
													end)
												end)
											end)
										end)
									else
										TriggerClientEvent("bro_core:Notification", sourceValue, "~r~Ce véhicule n'est pas accesible")
									end
								end)
							end)
					else
						TriggerClientEvent("bro_core:Notification", sourceValue, "Vous n'avez pas le permis !")

					end					
				else
					TriggerClientEvent("bro_core:Notification", sourceValue, "Vous n'avez pas assez d'argent")
				end
			end)
        end)
      end)
end)


AddEventHandler("vehicle:job:buy", function(cb, id, job)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

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
								MySQL.Async.insert("INSERT INTO `vehicle_mod` (`id`, `vehicle`, `parking`, `gameId`) VALUES (NULL, @id, '', 0)",
								{
									['@id'] = res2[1].id
								},
								function(inserted)
									MySQL.Async.insert("INSERT INTO `job_vehicle` (`id`, `job`, `vehicle_mod`) VALUES (NULL, @job , @vehicle_mod)",
									{
										['job'] = res[1].job,
										['vehicle_mod'] = inserted
									},
									function(insertId)
										TriggerClientEvent("bro_core:Notification", sourceValue, "Vous avez acheté une ~o~".. res2[1].label)
										TriggerClientEvent(cb, sourceValue, res2[1].name, insertId)
								end)
							end)
						end)
					else
						TriggerClientEvent("bro_core:Notification", sourceValue, "Vous n'avez pas le permis !")

					end					
				else
					TriggerClientEvent("bro_core:Notification", sourceValue, "Vous n'avez pas assez d'argent")
				end
			end)
        end)
      end)
end)


AddEventHandler("vehicle:ds", function(cb, price)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid, id, permis from players where discord = @discord',
        {['discord'] =  discord},
		function(res)
			if res[1] and res[1].liquid >= price and res[1].permis <1 then
				MySQL.Async.fetchAll('UPDATE players set liquid=liquid-@price where discord = @discord',
				{['discord'] =  discord,
				['price'] = price},
				function(res3)
					TriggerClientEvent(cb, sourceValue)
				end)
			else
				TriggerClientEvent("bro_core:Notification", sourceValue, "Vous n'avez pas assez d'argent")
			end
		end)
	end)
end)


AddEventHandler("vehicle:shop:get:all", function(cb)
	local sourceValue = source
	MySQL.ready(function ()
		MySQL.Async.fetchAll('SELECT * from vehicles WHERE job IS  NULL ORDER BY price', {
		}, function(result)
			TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)


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
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar("select job_grades.job from players, job_grades where players.discord = @discord  and job_grades.id = players.job_grade", {
			['@discord'] = discord
		}, function(job)
			MySQL.Async.fetchAll('select vehicle_mod.id, vehicles.name, vehicles.price, vehicles.label from players, player_vehicle, vehicles, vehicle_mod where vehicle_mod.id = player_vehicle.vehicle_mod and vehicle_mod.vehicle = vehicles.id and player_vehicle.player = players.id and players.discord = @discord and vehicle_mod.parking = "depot"', {
				['discord'] =  discord,
			}, function(res)
				MySQL.Async.fetchAll('select vehicle_mod.id, vehicles.name, vehicles.price, vehicles.label from players, player_vehicle, vehicles, vehicle_mod where vehicle_mod.id = player_vehicle.vehicle_mod and vehicle_mod.vehicle = vehicles.id and player_vehicle.player = players.id and players.discord = @discord and vehicle_mod.parking = ""', {
					['discord'] =  discord,
				}, function(res2)
					MySQL.Async.fetchAll('select vehicle_mod.id, vehicles.name, vehicles.price, vehicles.label from job_vehicle, vehicles, vehicle_mod where vehicle_mod.id = job_vehicle.vehicle_mod and vehicle_mod.vehicle = vehicles.id and job_vehicle.job= @job and vehicle_mod.parking = ""', {
						['@job'] =  job,
					}, function(res3)
						MySQL.Async.fetchAll('select vehicle_mod.id, vehicles.name, vehicles.price, vehicles.label from  job_vehicle, vehicles, vehicle_mod where vehicle_mod.id = job_vehicle.vehicle_mod and vehicle_mod.vehicle = vehicles.id and job_vehicle.job= @job and vehicle_mod.parking = "depot"', {
							['@job'] =  job,
						}, function(res4)
							TriggerClientEvent(cb, sourceValue, res, res2, res3, res4)
						end)
					end)
				end)
			end)
		end)
	end)
end)


AddEventHandler("vehicle:parking:get:all", function(id, cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	print(id)
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select vehicle_mod.id, vehicles.name, vehicles.label from vehicles, vehicle_mod, players, player_vehicle where player_vehicle.player = players.id and players.discord= @discord and vehicle_mod.vehicle = vehicles.id and vehicle_mod.parking = @id  and player_vehicle.vehicle_mod = vehicle_mod.id UNION select vehicle_mod.id, vehicles.name, vehicles.label from players, job_grades, job_vehicle, vehicle_mod, vehicles where players.discord = @discord and players.job_grade = job_grades.id and job_grades.job = job_vehicle.job and vehicle_mod.id = job_vehicle.vehicle_mod and vehicle_mod.vehicle = vehicles.id and vehicle_mod.parking = @id', {
			['discord'] =  discord,
			['id'] =  id,
		}, function(result)
				TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)


AddEventHandler("vehicles:get:all", function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('select player_vehicle.id, vehicles.name, vehicles.label, vehicle_mod.parking from players, player_vehicle, vehicles, vehicle_mod where player_vehicle.vehicle_mod = vehicle_mod.id and vehicle_mod.vehicle = vehicles.id', {
			['discord'] =  discord,
		}, function(result)
				TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)



AddEventHandler("vehicles:jobs:get:all", function(cb, job)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('select job_vehicle.id, vehicles.name, vehicles.label, job_vehicle.parking from job_vehicle, vehicles where job_vehicle.vehicle = vehicles.id and job_vehicle.job = @job', {
			['@job'] =  job,
		}, function(result)
				TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)


AddEventHandler("vehicle:parking:get", function(id, cb)
	local sourceValue = source
	MySQL.ready(function ()
		MySQL.Async.insert('UPDATE `vehicle_mod` SET parking = "" WHERE `vehicle_mod`.`id` = @id ', {
			['id'] =  id,
		}, function(insert)
			MySQL.Async.fetchAll('select vehicle_mod.id as vehicle_mod,  vehicles.name, vehicles.label, vehicles.price,  vehicle_mod.* from vehicles, vehicle_mod where vehicle_mod.vehicle = vehicles.id and vehicle_mod.id = @id', {
				['discord'] =  discord,
				['id'] =  id,
			}, function(result)
				TriggerClientEvent(cb, sourceValue, result[1])
			end)
		end)
	end)
end)

AddEventHandler("vehicle:parking:store", function(id, parking, cb)
	local sourceValue = source
	MySQL.ready(function ()
		MySQL.Async.insert('UPDATE `vehicle_mod` SET parking = @parking WHERE gameId = @id', {
			['@id'] =  id,
			['@parking'] =  parking,
		}, function(insert)
			MySQL.Async.fetchAll('select vehicle_mod.id as vehicle_mod,  vehicles.name, vehicles.label, vehicles.price,  vehicle_mod.* from vehicles, vehicle_mod where vehicle_mod.vehicle = vehicles.id and vehicle_mod.id = @id', {
				['discord'] =  discord,
				['id'] =  id,
			}, function(result)
				TriggerClientEvent(cb, sourceValue, result[1])
			end)
		end)
	end)
end)


AddEventHandler("vehicle:parking:job:get", function(id, cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.insert('UPDATE `vehicle_mod` SET parking = "" WHERE `vehicle_mod`.`id` = @id ', {
			['id'] =  id,
		}, function(insert)
			MySQL.Async.fetchAll('select vehicle_mod.id as vehicle_mod,  vehicles.name, vehicles.label, vehicles.price,  vehicle_mod.* from vehicles, vehicle_mod where vehicle_mod.vehicle = vehicles.id and vehicle_mod.id = @id', {
				['discord'] =  discord,
				['id'] =  id,
			}, function(result)
				MySQL.Async.fetchScalar("select job_grades.job from players, job_grades where players.discord = @discord  and job_grades.id = players.job_grade", {
					['@discord'] = discord
				}, function(job)
					TriggerClientEvent(cb, sourceValue, result[1], job)
				end)
			end)
		end)
	end)
end)



AddEventHandler("vehicle:store", function(vehicle, parking)
	local sourceValue = source
	print(vehicle)
	print(parking)
	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE `vehicle_mod` SET parking = @parking WHERE `vehicle_mod`.`gameId` = @vehicle ', {
			['vehicle'] =  vehicle,
			['parking'] =  parking,
		}, function(result)
		end)
	end)
end)



AddEventHandler("vehicle:job:store", function(vehicle, parking)
	local sourceValue = source
	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE `job_vehicle` SET parking = @parking WHERE `job_vehicle`.`id` = @vehicle ', {
			['vehicle'] =  vehicle,
			['parking'] =  parking,
		}, function(result)
		end)
	end)
end)


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

AddEventHandler("vehicle:permis:give", function()
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE `players` SET permis= 12 WHERE discord = @discord ', {
			['discord'] =  discord,
		}, function(result)
			TriggerClientEvent("bro_core:Notification", sourceValue, "Permis enregistré")
		end)
	end)
end)


AddEventHandler("vehicle:permis:get", function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select permis from players where discord = @discord ', {
			['discord'] =  discord,
		}, function(result)
			TriggerClientEvent(cb, sourceValue, result)
		end)
	end)
end)



AddEventHandler("vehicle:permis:withdraw", function(cb, amount)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local amount = amount
	MySQL.ready(function ()
		MySQL.Async.execute('update players set permis = permis-@amount where discord = @discord ', {
			['@discord'] =  discord,
			['@amount'] =  amount,
		}, function(numRows)
			TriggerClientEvent(cb, sourceValue)
		end)
	end)
end)



--jobs
AddEventHandler("vehicle:saveId", function(gameId, lastGameId)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.execute("Update vehicle_mod set gameId= @gameId where gameId = @lastGameId",
		{
			['@gameId'] = gameId,
			['@lastGameId'] = lastGameId,
		},function(rows)
		end)
	end)
end)


AddEventHandler("vehicle:save", function(cb,
	gameId,
	coords,
	heading,
	bodyHealth,
	primaryColour,
	secondaryColour,
	dirtLevel,
	doorLockStatus,
	engineHealth,
	livery,
	numberPlateText,
	petrolTankHealth,
	roofLivery,
	windowTint,
	fuelLevel
)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	if livery == -1 then
		livery = 0
	end
	if engineHealth == "-nan" then
		engineHealth = -1
	end

	if heading == nil then
		heading = 0
	end

--	print("DEBUG")
--	print(gameId)
--	print(coords.x)
--	print(coords.y)
--	print(coords.z)
--	print(heading)

--	print("Health")
--	print(bodyHealth)
--	print(engineHealth)
--	print("Colours")
--	print(primaryColour)
--	print(secondaryColour)

--	print(dirtLevel)
--	print("MISC")
--	print(doorLockStatus)
--	print(livery)
--	print(roofLivery)
--	print(windowTint)
--	print(doorLockStatus)
--
--	print("FUEL")
--	print(fuelLevel)
--
--	print("DEBUG")

	if gameId ~= 0 then
		MySQL.ready(function ()
			MySQL.Async.execute("Update vehicle_mod set vehicle_mod.x= @x, vehicle_mod.y=@y, vehicle_mod.z=@z, vehicle_mod.heading = @heading, bodyHealth = @bodyHealth, primaryColour = @primaryColour, secondaryColour = @secondaryColour, dirtLevel = @dirtLevel,	doorLockStatus = @doorLockStatus, engineHealth = @engineHealth, livery = @livery, numberPlateText = @numberPlateText,	petrolTankHealth = petrolTankHealth,roofLivery = @roofLivery, windowTint = @windowTint, fuelLevel = @fuelLevel where vehicle_mod.gameId = @gameId",
			{
				['@gameId'] = gameId,
				['@x'] = coords.x,
				['@y'] = coords.y,
				['@z'] = coords.z,
				['@heading'] = heading,
				['@bodyHealth'] = bodyHealth,
				['@primaryColour'] = primaryColour,
				['@secondaryColour'] = secondaryColour,
				['@dirtLevel'] = dirtLevel,
				['@doorLockStatus'] = doorLockStatus,
				['@engineHealth'] = engineHealth,
				['@livery'] = livery,
				['@numberPlateText'] = numberPlateText,
				['@petrolTankHealth'] = petrolTankHealth,
				['@roofLivery'] = roofLivery,
				['@windowTint'] = windowTint,
				['@fuelLevel'] = fuelLevel,
			},function(rows)
			end)
		end)
	end
end)

AddEventHandler("vehicle:player:get", function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('select vehicle_mod.*, vehicles.name from vehicles, vehicle_mod, players, player_vehicle where player_vehicle.player = players.id and players.discord= @discord and vehicle_mod.vehicle = vehicles.id and vehicle_mod.parking = ""  and player_vehicle.vehicle_mod = vehicle_mod.id UNION select  vehicle_mod.*, vehicles.name from players, job_grades, job_vehicle, vehicle_mod, vehicles where players.discord = @discord and players.job_grade = job_grades.id and job_grades.job = job_vehicle.job and vehicle_mod.id = job_vehicle.vehicle_mod and vehicle_mod.vehicle = vehicles.id and vehicle_mod.parking = ""', {
			['@discord'] =  discord,
		}, function(res)
			for k,v in pairs(res) do
				MySQL.Async.fetchAll("SELECT vehicle_mod_type.* from vehicle_mod_type where vehicle_mod = @vehicle_mod",
				{
					['@vehicle_mod'] = v.id,
				},function(mods)
					TriggerClientEvent("vehicle:mods:refresh", sourceValue, v.gameId, mods)
				end)
			end
			TriggerClientEvent(cb, sourceValue, res)
		end)
	end)
end)


AddEventHandler("vehicle:job:get", function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT jobs.id from players, job_grades, jobs where players.job_grade = job_grades.id and jobs.id = job_grades.job and discord = @discord',
        {['discord'] =  discord},
         function(job)
                if(job) then
					MySQL.Async.fetchAll("SELECT vehicle_mod.id as vehicle_mod, vehicle_mod.*, vehicles.name FROM `job_vehicle`, vehicles, vehicle_mod WHERE job_vehicle.job = @job and vehicle_mod.id = job_vehicle.vehicle_mod and vehicles.id = vehicle_mod.vehicle and vehicle_mod.parking = ''",
					{
						['@job'] = job,
					},function(res)
						for k,v in pairs(res) do
							MySQL.Async.fetchAll("SELECT vehicle_mod_type.* from vehicle_mod_type where vehicle_mod = @vehicle_mod",
							{
								['@vehicle_mod'] = v.vehicle_mod,
							},function(mods)
								TriggerClientEvent("vehicle:mods:refresh", sourceValue, v.gameId, mods)
							end)
						end
						TriggerClientEvent(cb, sourceValue, res)
				end)
			end
		end)
	end)
end)

AddEventHandler("vehicle:mods:save", function(gameid, mods)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select id from vehicle_mod where gameId =@gameid ', {
			['@gameid'] =  gameid,
		}, function(vehicle_mod)
				for i = 0,49 do
					MySQL.Async.execute("INSERT INTO `vehicle_mod_type` (`vehicle_mod`, `type`, `value`) VALUES (@vehicle_mod, @i, @value) ON DUPLICATE KEY UPDATE type = @i, value = @value",
					{
						['@vehicle_mod'] = vehicle_mod,
						['@i'] = i,
						['@value'] = mods[i]
					},function(rows)
					end)
				end
			end)
		end)
end)


AddEventHandler("vehicle:lock", function(cb, vehicle)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local vehicle = vehicle
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT count(vehicle_mod.gameId) FROM `vehicle_mod`, player_vehicle, players where vehicle_mod.gameId = @gameid and player_vehicle.vehicle_mod = vehicle_mod.id and players.discord = @discord and players.id = player_vehicle.player', {
			['@discord'] = discord,
			['@gameid'] =  vehicle,
		}, function(res)
			MySQL.Async.fetchScalar('SELECT count(vehicle_mod.gameId) FROM `vehicle_mod`, job_vehicle, job_grades, players where vehicle_mod.gameid = @gameid and job_vehicle.vehicle_mod = vehicle_mod.id and players.job_grade = job_grades.id and job_grades.job = job_vehicle.job and players.discord = @discord', {
				['@discord'] = discord,
				['@gameid'] =  vehicle,
			}, function(res2)
				if res > 0 or res2 > 0 then
					print("lock")
					TriggerClientEvent(cb, sourceValue, vehicle)
				else
					TriggerClientEvent("bro_core:Notification", sourceValue, "~r~Vous n'avez pas les clés")
				end
			end)
		end)
	end)
end)



AddEventHandler("vehicle:sell", function(vehicle)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local id = vehicle
	print(id)
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select vehicle_mod.id, vehicles.price from vehicle_mod, vehicles where gameId = @id and vehicle_mod.vehicle =  vehicles.id', {
			['@id'] = id,
		}, function(res)
			if res and res[1] then
				MySQL.Async.execute('DELETE from player_vehicle where vehicle_mod = @id', {
					['@id'] =  res[1].id,
				}, function()
					MySQL.Async.execute('DELETE from vehicle_mod  where gameId = @id', {
						['@id'] =  id,
					}, function()
						MySQL.Async.execute('update players set liquid = liquid+@nb where discord = @discord', {
							['@nb'] =  res[1].price/2,
							['@discord'] =  discord,
						}, function()
							TriggerClientEvent("bro_core:Notification", sourceValue, "~r~Vous avez vendu votre véhicle pour ~g~".. res[1].price/2 .." $")
						end)
					end)
				end)
			else
				TriggerClientEvent("bro_core:Notification", sourceValue, "~r~Ce véhicule est volé !")
			end
		end)
	end)
end)


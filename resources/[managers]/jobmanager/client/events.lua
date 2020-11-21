RegisterNetEvent("job:set")

-- source is global here, don't add to function
AddEventHandler('job:set', function (grade)
    TriggerServerEvent("job:set", grade)
end)

RegisterNetEvent("job:process")
AddEventHandler('job:process', function(isOk)
    if isOk then
        TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1,"Vous avez transformé", false, "now_cuffed")
    else
        TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1,"Vos poches sont vides", false, "now_cuffed")
    end
end)

RegisterNetEvent("job:sell")
AddEventHandler('job:sell', function(isOk)
    if isOk then
        TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1,"Vous avez vendu", false, "now_cuffed")
    else
        TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1,"Vos poches sont vides", false, "now_cuffed")
    end
end)

RegisterNetEvent("job:getCar")
AddEventHandler('job:getCar', function(car, carId)
    -- account for the argument not being passed
    local vehicleName = car

    -- check if the vehicle actually exists
    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        return
    end

    -- load the model
    RequestModel(vehicleName)

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end

    -- get the player's position
    local playerPed = PlayerPedId() -- get the local player ped
    local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
   -- SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
    SetModelAsNoLongerNeeded(vehicleName)
    TriggerServerEvent("vehicle:set:id", carId, vehicle)
end)





RegisterNetEvent('job:process:open')

AddEventHandler("job:process:open", function(job)  
	job = job[1]	
	buttons = {}
	for k, v in pairs(config.jobs[job.job].process[zone].items) do

		buttons[#buttons+1] = {
			text = "Traitement "..v.label,
			exec = {
				callback = function()
					TriggerServerEvent('items:process', v.type,  v.amount, v.to,  v.amountTo) 
					exports.bf:Notification('Vous avez transformé : '..v.label.. " X "..v.amount)
					exports.bf:CloseMenu(zoneType..zone)
				end
			},
		}
	end
	exports.bf:SetMenuButtons(zoneType..zone, buttons)
	exports.bf:OpenMenu(zoneType..zone)
end)


RegisterNetEvent('job:collect:open')

AddEventHandler("job:collect:open", function(job)  
	job = job[1]	
	buttons = {}
	for k, v in pairs(config.jobs[job.job].collect[zone].items) do

		buttons[#buttons+1] = {
			text = "Collecter "..v.label,
			exec = {
				callback = function()
					TriggerServerEvent('items:add', v.type,  v.amount) 
					exports.bf:Notification('Vous avez collecté : '..v.label.. " X "..v.amount)
					exports.bf:CloseMenu(zoneType..zone)
				end
			},
		}
	end
	exports.bf:SetMenuButtons(zoneType..zone, buttons)
	exports.bf:OpenMenu(zoneType..zone)
end)

RegisterNetEvent('job:parking:open')

AddEventHandler("job:parking:open", function(job)  
	job = job[1]
	TriggerServerEvent("vehicle:job:parking", "job:parking", job.job)
end)

RegisterNetEvent('job:safe:open2')

AddEventHandler("job:safe:open2", function(money) 
	exports.bf:SetMenuValue(zoneType..zone, {
		menuTitle = "Compte ~r~"..money.. " $"
	})
	exports.bf:OpenMenu(zoneType..zone)
end)

RegisterNetEvent('job:safe:open')

AddEventHandler("job:safe:open", function(job) 
	job = job[1].job
	TriggerServerEvent("account:job:get", "job:safe:open2", job)		
end)


RegisterNetEvent('job:open:menu')

AddEventHandler("job:open:menu", function(job)  
	job = job[1] 
	print(job.job)
	if job.job == "LSMS" or job.job == "LSPD" or job.job == "NEWSPAPERS" then
		exports.bf:OpenMenu(job.job)
	end
end)


RegisterNetEvent('job:parking')

AddEventHandler("job:parking", function(vehicles)  
	local buttons = {

	}
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label,
			exec = {
				callback = function() 
					TriggerServerEvent("job:parking:get", "job:parking:get", v.id)
				end
			},
	}
	end
	exports.bf:SetMenuButtons(zoneType..zone, buttons)
	exports.bf:OpenMenu(zoneType..zone)
end)

RegisterNetEvent('job:parking:get')

AddEventHandler("job:parking:get", function(name, id)  
	local playerPed = PlayerPedId() -- get the local player ped

	if not IsPedInAnyVehicle(playerPed) then
		local vehicleName = name
		currentVehicle = id
		-- check if the vehicle actually exists
		if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
			TriggerEvent('chat:addMessage', {
				args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
			})
			return
		end

		-- load the model
		RequestModel(vehicleName)

		-- wait for the model to load
		while not HasModelLoaded(vehicleName) do
			Wait(500) -- often you'll also see Citizen.Wait
		end
		
		ClearAreaOfVehicles(spawn.x, spawn.y, spawn.z, 5.0, false, false, false, false, false)
		-- create the vehicle
		local vehicle = CreateVehicle(vehicleName, spawn.x, spawn.y, spawn.z, heading, true, false)

		-- set the player ped into the vehicle's driver seat
		SetPedIntoVehicle(playerPed, vehicle, -1)

		-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
		SetEntityAsNoLongerNeeded(vehicle)

		-- release the model
		SetModelAsNoLongerNeeded(vehicleName)
								
		exports.bf:CloseMenu(zoneType..zone)
	end
end)

RegisterNetEvent('job:openStorageMenu')

AddEventHandler("job:openStorageMenu", function(location, job)   
	sell(location, job)
end)


function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

RegisterNetEvent('job:lsms:revive')

AddEventHandler("job:lsms:revive", function()  
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	RespawnPed(playerPed, coords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
	TriggerEvent("player:alive")
end)

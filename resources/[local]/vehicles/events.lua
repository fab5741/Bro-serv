-- Events
RegisterNetEvent("ds:belt")
RegisterNetEvent("vehicle:permis:get:ds")
RegisterNetEvent("vehicle:permis:get:depot")
RegisterNetEvent("vehicle:ds")
RegisterNetEvent("vehicle:job:buy:ok")
RegisterNetEvent("vehicle:buy:ok")
RegisterNetEvent("vehicle:parking:get")
RegisterNetEvent("vehicle:menu:closed")
RegisterNetEvent("vehicle:shop")
RegisterNetEvent("vehicle:depots")
RegisterNetEvent("vehicle:foot")
RegisterNetEvent("vehicle:get")
RegisterNetEvent("vehicle:depots:get")
RegisterNetEvent("vehicle:depots:job:get")
RegisterNetEvent("vehicle:spawn")
RegisterNetEvent("vehicle:refresh")
RegisterNetEvent("vehicle:mods:refresh")

AddEventHandler("ds:belt", function(belt)
	if not belt then
		exports.bro_core:Notification('Pas de ceinture ! Permis annulé')
		exports.bro_core:DisableArea("checkpoints-1")
		exports.bro_core:DisableArea("checkpoints-2")
		exports.bro_core:DisableArea("checkpoints-3")
		ds = false
	end
end)



AddEventHandler("vehicle:permis:get:ds", function(permis)
	if permis < 1 then
		exports.bro_core:HelpPromt("Auto-école : ~INPUT_PICKUP~")
		zoneType = "ds"
	else
		exports.bro_core:Notification("Vous avez déjà le permis")
	end
end)


AddEventHandler("vehicle:permis:get:depot", function(permis)
	if permis > 0 then
		exports.bro_core:HelpPromt("Fourrière : ~INPUT_PICKUP~")
		zoneType = "depots"
	else
		exports.bro_core:Notification("Vous n'avez pas le permis")
	end
end)


AddEventHandler("vehicle:ds", function()
	local vehicleName = "dilettante"
	-- load the model
	RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

	-- wait for the model to load
	while not HasModelLoaded(vehicleName) do
		Wait(500) -- often you'll also see Citizen.Wait
	end
	
	ClearAreaOfVehicles(228.3041229248, -1397.3438720703, 30.488224029541, 5.0, false, false, false, false, false)
	-- create the vehicle
	local vehicle = CreateVehicle(vehicleName, 228.3041229248, -1397.3438720703, 26.42, 150.0, true, false)

	-- set the player ped into the vehicle's driver seat
	SetPedIntoVehicle(playerPed, vehicle, -1)

	-- release the model
	SetModelAsNoLongerNeeded(vehicleName)

	-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
	SetVehicleFuelLevel(vehicle, 100.0)


	dsVehicle = vehicle
	SetEntityAsNoLongerNeeded(vehicle)

	exports.bro_core:Notification("~g~ L'épreuve commence. N'oubliez pas votre ceinture !")
	exports.bro_core:EnableArea("checkpoints-1")
	ds = true
	exports.bro_core:CloseMenu("ds")
end)



AddEventHandler("vehicle:job:buy:ok", function(name, id)
	data = {}
	data.gameId = 0
	data.name = name
	spawnACar(data, false)
	exports.bro_core:CloseMenu("shops-job")
end)


AddEventHandler("vehicle:buy:ok", function(name, id)
	data = {}
	data.x = -29.2
	data.y = -1087.02
	data.z =  25.53
	data.gameId = 0
	data.name = name
	spawnACar(data, false, true)
	exports.bro_core:CloseMenu("shops")
end)


RegisterNetEvent("vehicle:job:shop")

AddEventHandler("vehicle:job:shop", function(vehicles)
	local buttons = {}
	
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label.. " (~g~".. v.price.." $~s~)",
			exec = {
				callback = function() 
					-- buy the car
					TriggerServerEvent("vehicle:job:buy", "vehicle:job:buy:ok", v.id)
				end
			},
		}
	end
	exports.bro_core:SetMenuButtons("shops", buttons)
	exports.bro_core:OpenMenu("shops")
end)


AddEventHandler("vehicle:shop", function(vehicles)
	local buttons = {}
	
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label.. " (~g~".. v.price.." $~s~)",
			exec = {
				callback = function() 
					-- buy the car
					TriggerServerEvent("vehicle:buy", "vehicle:buy:ok", v.id)
				end
			},
			hover = {
				callback = function()
					local vehicleName = v.name
					-- load the model
					RequestModel(vehicleName)
				
					-- wait for the model to load
					while not HasModelLoaded(vehicleName) do
						Wait(500) -- often you'll also see Citizen.Wait
					end
				
					ClearAreaOfVehicles(-44.44, -1098.43, 26.42, 5.0, false, false, false, false, false)
					-- create the vehicle
					local vehicle = CreateVehicle(vehicleName, -44.44, -1098.43, 26.42, 10.04, true, false)
				
					-- set the player ped into the vehicle's driver seat
				  --  SetPedIntoVehicle(playerPed, vehicle, -1)				
				  
					-- release the model
					SetModelAsNoLongerNeeded(vehicleName)
					-- SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS
					SetVehicleDoorsLockedForAllPlayers(
						vehicle --[[ Vehicle ]], 
						true --[[ boolean ]]
					)
					-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
					SetEntityAsNoLongerNeeded(vehicle)
				end
			}
	}
	end
	
	exports.bro_core:SetMenuButtons("shops", buttons)
	exports.bro_core:OpenMenu("shops")
end)



AddEventHandler("vehicle:depots", function(vehicles, vehicles2, vehicles3, vehicles4)
	local buttons = {}
	
	if vehicles ~= nil then
		for k, v in ipairs (vehicles) do
			buttons[k] =     {
				text = v.label.." ~r~(fourrière) ~g~"..tostring(v.price*0.10).."$",
				exec = {
					callback = function() 
						TriggerServerEvent("vehicle:parking:get", v.id, "vehicle:depots:get")
					end
			}
		}
		end
	end

	if vehicles2 ~= nil then
		for k, v in ipairs (vehicles2) do
			buttons[k] =     {
				text = v.label.." ~r~(volé) ~g~"..tostring(v.price*0.01).."$",
				exec = {
					callback = function() 
						
						TriggerServerEvent("vehicle:parking:get", v.id, "vehicle:depots:get")
					end
			}
		}
		end
	end

	if vehicles3 ~= nil then
		for k, v in ipairs (vehicles3) do
			buttons[k] =     {
				text = "Entreprise : "..v.label.." ~r~(volé) ~g~"..tostring(v.price*0.01).."$",
				exec = {
					callback = function() 
						
						TriggerServerEvent("vehicle:parking:job:get", v.id, "vehicle:depots:job:get")
					end
			}
		}
		end
	end
	if vehicles4 ~= nil then
		for k, v in ipairs (vehicles4) do
			buttons[k] =     {
				text = "Entreprise : ".. v.label.. " ~r~(volé) ~g~"..tostring(v.price*0.01).."$",
				exec = {
					callback = function() 
						TriggerServerEvent("vehicle:parking:job:get", v.id, "vehicle:depots:job:get")
					end
			}
		}
	end
	end
	exports.bro_core:SetMenuButtons("depots", buttons)
	exports.bro_core:OpenMenu("depots")
end)


AddEventHandler("vehicle:foot", function(vehicles)
	local buttons = {}

	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label,
			exec = {
				callback = function() 
					if not lockParking then
						local playerPed = GetPlayerPed(-1)
						local time = 4000
						TriggerEvent("bf:progressBar:create", time, "Vous sortez le véhicule du parking")
						FreezeEntityPosition(playerPed, true)
						lockParking = true
						Wait(time)

						TriggerServerEvent("vehicle:parking:get", v.id, "vehicle:get")
						exports.bro_core:CloseMenu("parking-veh")
						FreezeEntityPosition(playerPed, false)
						lockParking = false
					end
				end
		}
	}
	end
	exports.bro_core:SetMenuButtons("parking-foot", buttons)
	exports.bro_core:OpenMenu("parking-foot")
end)


AddEventHandler("vehicle:get", function(data)
	exports.bro_core:CloseMenu("parking-foot")
	TriggerServerEvent("vehicle:parking:get", data.id, "")
	data.x = nil
	data.y = nil
	data.z = nil
	spawnACar(data, false, true)
end)


AddEventHandler("vehicle:depots:get", function(data)
	data.x = nil
	data.y = nil
	data.z = nil
	spawnACar(data, false, true)

	local price = 0
	
	if data.parking == "" then
		price = data.price*(0.01)
	else
		price = data.price*(0.10)
	end
	TriggerServerEvent("account:player:add", "", -price)
	TriggerServerEvent("account:job:add", "", 1, price, true)
	exports.bro_core:Notification("Vous avez payé ~g~".. price.."$")
	exports.bro_core:CloseMenu("depots")
end)

AddEventHandler("vehicle:depots:job:get", function(data, job)
	data.x = nil
	data.y = nil
	data.z = nil
	spawnACar(data, true, true)

	local price = 0
	
	if data.parking == "" then
		price = data.price*(0.01)
	else
		price = data.price*(0.10)
	end
	TriggerServerEvent("account:job:add", "", job, -price, true)
	TriggerServerEvent("account:job:add", "", 1, price, true)
	exports.bro_core:Notification("Vous avez payé ~g~".. price.."$")
	exports.bro_core:CloseMenu("depots")
end)

function spawnACar(v, new, tpIn)
	-- delete old if exist
	DeleteEntity(v.gameId)

	--spawn
	if v.x == nil or v.y == nil or v.z == nil then
		vehicle = exports.bro_core:spawnCar(v.name, true, nil, true, true)
	else
		if tpIn then
			vehicle = exports.bro_core:spawnCar(v.name, true, vector3((v.x+v.x)/2, (v.y+v.y)/2, (v.z+v.z)/2), true, false, v.heading)
		else
			vehicle = exports.bro_core:spawnCar(v.name, true, vector3((v.x+v.x)/2, (v.y+v.y)/2, (v.z+v.z)/2), false, true, v.heading)
		end
	end
	TriggerServerEvent("vehicle:saveId", vehicle, v.gameId)
	currentVehicle = vehicle

	if new == false then
	--	Wait(2000)
		if v.livery == -1 then
			v.livery = 0
		end
		if v.engineHealth == "-nan" then
			v.engineHealth = -1
		end
	
		if v.bodyHealth == "-nan" then
			v.bodyHealth = -1
		end
	
		if v.fuelLevel == nil then
			v.fuelLevel = 30
		end
		if v.dirtLevel == nil then
			v.dirtLevel = 0
		end
	
		if v.bodyHealth == nil then
			v.bodyHealth = 0
		end
	
		if v.heading == nil then
			v.heading = 0
		end
		
--	print("DEBUG")
--	print(vehicle)
--	print(v.x)
--	print(v.y)
--	print(v.z)
--	print(v.name)

--	print("Health")
--	print(v.bodyHealth)
--	print(v.engineHealth)
--	print("Colours")
--	print(v.primaryColour)
--	print(v.secondaryColour)

--	print(v.dirtLevel)
--	print("MISC")
--	print(v.doorLockStatus)
--	print(v.livery)
--	print(v.roofLivery)
--	print(v.windowTint)
--	print(v.doorLockStatus)
--	print("PLATE")
--	print(v.numberPlateText)

--	print("FUEL")
--	print(v.fuelLevel)
--	print("DEBUG")
		SetVehicleColours(vehicle, v.primaryColour, v.secondaryColour)
		SetVehicleDirtLevel(vehicle, (v.dirtLevel+v.dirtLevel)/2)
		SetVehicleBodyHealth(vehicle, (v.bodyHealth+ v.bodyHealth)/2)
		SetVehicleEngineHealth(vehicle, (v.engineHealth+ v.engineHealth)/2)
		SetVehicleDoorsLocked(vehicle, v.doorLockStatus)
		SetVehicleLivery(vehicle, v.livery)
		if v.numberPlateText ~= nil then
			SetVehicleNumberPlateText(vehicle, v.numberPlateText)
		end
		SetVehicleRoofLivery(vehicle, v.roofLivery)
		SetVehicleWindowTint(vehicle, v.windowTint)
		--SetVehicleFuelLevel(vehicle, (v.fuelLevel+ v.fuelLevel)/2)
	end
end

AddEventHandler("vehicle:spawn", function(vehicles)
	for k,v in pairs(vehicles) do
		if v.x and v.y and v.z then
			spawnACar(v, false)
		end
    end
end)

AddEventHandler("vehicle:refresh", function(vehicles)
	for k,v in pairs(vehicles) do
        local ped = GetPlayerPed(-1)
		local primaryColour, secondaryColour = GetVehicleColours(v.gameId)
		local bodyHealth = GetVehicleBodyHealth(v.gameId)
        TriggerServerEvent("vehicle:save", "", 
        v.gameId,
        GetEntityCoords(v.gameId),
        GetEntityHeading(v.gameId),
        bodyHealth,
        primaryColour,
        secondaryColour,
        GetVehicleDirtLevel(v.gameId),
        GetVehicleDoorLockStatus(v.gameId),
        GetVehicleEngineHealth(v.gameId),
        GetVehicleLivery(v.gameId),
        GetVehicleNumberPlateText(v.gameId),
        GetVehiclePetrolTankHealth(v.gameId),
        GetVehicleRoofLivery(v.gameId),
        GetVehicleWindowTint(v.gameId),
		GetVehicleFuelLevel(v.gameId)
	)
    end
end)


AddEventHandler("vehicle:mods:refresh", function(vehicle, mods)
	SetVehicleModKit(
		vehicle, 
		0
	)
	if mods then 
		for k,v in pairs(mods) do
				SetVehicleMod(
					vehicle, 
					v.type, 
					v.value, 
					false -- always 0
				)
		end
	end

end)

RegisterNetEvent("vehicle:lock")
AddEventHandler('vehicle:lock', function(vehicle)
    local islocked = GetVehicleDoorLockStatus(vehicle)
    -- test if its my vehicle
    if (islocked == 1)then
        SetVehicleDoorsLocked(vehicle, 2)
        exports.bro_core:Notification("~r~Vous avez verrouilé votre ~y~".. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~.")
    else
        SetVehicleDoorsLocked(vehicle,1)
        exports.bro_core:Notification("~r~Vous avez déverrouilé votre ~y~".. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~.")
    end
end)
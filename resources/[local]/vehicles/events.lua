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
RegisterNetEvent("vehicle:spawn")
RegisterNetEvent("vehicle:refresh")

AddEventHandler("ds:belt", function(belt)
	print(belt)
	if not belt then
		exports.bf:Notification('Pas de ceinture ! Permis annulé')
		exports.bf:DisableArea("checkpoints-1")
		exports.bf:DisableArea("checkpoints-2")
		exports.bf:DisableArea("checkpoints-3")
		ds = false
	end
end)



AddEventHandler("vehicle:permis:get:ds", function(permis)
	if permis < 1 then
		exports.bf:HelpPromt("Auto-école : ~INPUT_PICKUP~")
		zoneType = "ds"
	end
	exports.bf:Notification("Vous avez déjà le permis")
end)


AddEventHandler("vehicle:permis:get:depot", function(permis)
	if permis then
		exports.bf:HelpPromt("Fourrière : ~INPUT_PICKUP~")
		zoneType = "depots"
	end
	exports.bf:Notification("Vous n'avez pas le permis")
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

	exports.bf:Notification("~g~ L'épreuve commence. N'oubliez pas votre ceinture !")
	exports.bf:EnableArea("checkpoints-1")
	ds = true
	exports.bf:CloseMenu("ds")
end)



AddEventHandler("vehicle:job:buy:ok", function(name, id)
	print(name)
	local vehicleName = name
	currentVehicle = id
    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
   while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end
	ClearAreaOfVehicles(374.59939575195, -1619.4310302734, 29.29193687439, 5.0, false, false, false, false, false)
    local vehicle = CreateVehicle(vehicleName, 374.59939575195, -1619.4310302734, 29.29193687439, 338.41, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
	SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)

	exports.bf:CloseMenu("shops-job")
end)


AddEventHandler("vehicle:buy:ok", function(name, id)
	print(name)
	local vehicleName = name
	currentVehicle = id
    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
   while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end

	ClearAreaOfVehicles(-29.2, -1087.02, 25.53, 5.0, false, false, false, false, false)
    local vehicle = CreateVehicle(vehicleName, -29.2, -1087.02, 25.53, 338.41, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
	SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)

	exports.bf:CloseMenu("shops")
end)


AddEventHandler("vehicle:parking:get", function(data, id)
	local vehicleName = data.name
	currentVehicle = data.id
	menuOpened = 0
	TriggerEvent("menu:delete", "vehiclesShop") 

    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
	end
	

	coords = exports.bf:GetPlayerCoords()

	ClearAreaOfVehicles(coords.x, coords.y, coords.z, 5.0, false, false, false, false, false)
    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, coords.x, coords.y, coords.z, 150.5, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)
	
	TriggerServerEvent("vehicle:parking:get", data.id)
end)


AddEventHandler("vehicle:menu:closed", function()
	menuOpened = 0
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
	exports.bf:SetMenuButtons("shops", buttons)
	exports.bf:OpenMenu("shops")
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
	exports.bf:SetMenuButtons("shops", buttons)
	exports.bf:OpenMenu("shops")
end)



AddEventHandler("vehicle:depots", function(vehicles)
	local buttons = {}
	
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label,
			exec = {
				callback = function() 
					TriggerServerEvent("vehicle:parking:get", v.id, "vehicle:depots:get")
				end
		}
	}
	end
	exports.bf:SetMenuButtons("depots", buttons)
	exports.bf:OpenMenu("depots")
end)


AddEventHandler("vehicle:foot", function(vehicles)
	local buttons = {}

	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label,
			exec = {
				callback = function() 
					TriggerServerEvent("vehicle:parking:get", v.id, "vehicle:get")
				end
		}
	}
	end
	exports.bf:SetMenuButtons("parking-foot", buttons)
	exports.bf:OpenMenu("parking-foot")
end)


AddEventHandler("vehicle:get", function(data)
	print("go")
	local vehicleName = data.name
	currentVehicle = data.id
	menuOpened = 0
    -- check if the vehicle actually exists
    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TriggerEvent('chat:addMessage', {
            args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
        })
        return
    end

    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end

	ClearAreaOfVehicles(232.19, -788.63, 30.63, 5.0, false, false, false, false, false)
    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, 232.19, -788.63, 29.83, 150.5, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)
	
	TriggerServerEvent("vehicle:parking:get", data.id)
	
	exports.bf:CloseMenu("parking-foot")
end)


AddEventHandler("vehicle:depots:get", function(data)
	local vehicleName = data.name
	currentVehicle = data.id
	menuOpened = 0
    -- check if the vehicle actually exists
    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TriggerEvent('chat:addMessage', {
            args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
        })
        return
    end

    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end
	
	ClearAreaOfVehicles(384.67245483398,-1622.2377929688, 29.291933059692, 5.0, false, false, false, false, false)
    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, 384.67245483398,-1622.2377929688, 29.291933059692, -30.0, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)
	
	TriggerServerEvent("vehicle:parking:get", data.id)
	
	exports.bf:CloseMenu("parking-foot")
end)

AddEventHandler("vehicle:spawn", function(vehicles)
    for k,v in pairs(vehicles) do
        vehicle = exports.bf:spawnCar(v.name, true, vector3(v.x, v.y, v.z), false, true)
        SetVehicleColours(vehicle, v.primaryColour, v.secondaryColour)
        SetVehicleDirtLevel(vehicle, v.dirtLevel)
        SetVehicleEngineHealth(vehicle, v.engineHealth)

        TriggerServerEvent("vehicle:player:saveId", "", vehicle, v.gameId)
    end
end)

AddEventHandler("vehicle:refresh", function(vehicles)
    for k,v in pairs(vehicles) do
        local ped = GetPlayerPed(-1)
        local primaryColour, secondaryColour = GetVehicleColours(v.gameId)
        TriggerServerEvent("vehicle:player:save", "", 
        v.gameId,
        GetEntityCoords(v.gameId),
        primaryColour,
        secondaryColour,
        GetVehicleDirtLevel(v.gameId),
        GetVehicleDoorLockStatus(v.gameId),
        GetVehicleEngineHealth(v.gameId),
        GetVehicleLivery(v.gameId),
        GetVehicleNumberPlateText(v.gameId),
        GetVehiclePetrolTankHealth(v.gameId),
        GetVehicleRoofLivery(v.gameId),
        GetVehicleWindowTint(v.gameId)
    )
    end
end)
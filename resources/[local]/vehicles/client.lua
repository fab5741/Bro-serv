config = {
	shops = {
		main = {
			coords = vector3(-43.67,-1109.33,25.44),
			Blip = {
				coords = vector3(-43.67,-1109.33,26.44),
				sprite = 523,
				scale  = 0.8,
				color  = 2
			},
		}
	},
	parkings = {
		main = {
			id = 1,
			coords = vector3(234.68,-782.73,29.9),
			Blip = {
				coords = vector3(234.68,-782.73,30.24),
				sprite = 357,
				scale  = 0.8,
				color  = 2
			},
		}
	}
}

config.Marker  = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
config.DrawDistance = 20


currentVehicle = 0
-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(config.shops) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Concessionnaire')
		EndTextCommandSetBlipName(blip)
	end
	for k,v in pairs(config.parkings) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Parking')
		EndTextCommandSetBlipName(blip)
	end
end)

local menuOpened = 0

-- Draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		print(menuOpened)

		for k,v in pairs(config.shops) do
			local distance = #(playerCoords - v.coords)

			if distance < config.DrawDistance then
				DrawMarker(config.Marker.type, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
			end

			if distance < config.Marker.x then	
				if(menuOpened == 0) then
					menuOpened = 1
					TriggerServerEvent("vehicle:menu:buy")
				end
			end
		end
		for k,v in pairs(config.parkings) do
			local distance = #(playerCoords - v.coords)

			if distance < config.DrawDistance then
				DrawMarker(config.Marker.type, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
			end

			if distance < config.Marker.x then
				if(menuOpened == 0) then
					menuOpened = 1
					if GetVehiclePedIsIn(GetPlayerPed(-1), false) == 0then
						TriggerServerEvent("vehicle:menu:parking:get", v.id)
					else
						TriggerEvent("vehicle:menu:parking:store", v.id)
					end
				end
			end
		end
	end
end)


RegisterNetEvent("vehicle:menu:buy")

AddEventHandler("vehicle:menu:buy", function(data)
	for k,v in pairs(data) do
		v.action = "vehicleBuy"
	end
	TriggerEvent("menu:create", "vehiclesShop", "Concessionnaire", "list",
		"", data, "align-top-right", "", "") 
end)

RegisterNetEvent("vehicle:menu:parking:get")

AddEventHandler("vehicle:menu:parking:get", function(data)
	for k,v in pairs(data) do
		print(v)
		v.action = "parkingGet"
	end	
	TriggerEvent("menu:create", "vehiclesShop", "Parking get", "list",
		"", data, "align-top-right", "", "") 
end)

RegisterNetEvent("vehicle:menu:parking:store")

AddEventHandler("vehicle:menu:parking:store", function(parking)

	items = {
		{
			name = "store",
			label = "Stocker",
			action = "parkingStore",
			parking = parking
		},
		}
	TriggerEvent("menu:create", "vehiclesShop", "Parking store", "list",
		"", items, "align-top-right", "", "") 
end)


RegisterNetEvent("vehicle:try")

AddEventHandler("vehicle:try", function(data)
	print("Try : ", data)
	local vehicleName = data.name

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

	ClearAreaOfVehicles(-44.44, -1098.43, 26.42, 5.0, false, false, false, false, false)
    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, -44.44, -1098.43, 26.42, 10.04, true, false)

    -- set the player ped into the vehicle's driver seat
  --  SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
    SetModelAsNoLongerNeeded(vehicleName)
end)


RegisterNetEvent("vehicle:buy")

AddEventHandler("vehicle:buy", function(data)
	print("buy : ", data)
	local vehicleName = data.name

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

	ClearAreaOfVehicles(-29.2, -1087.02, 25.53, 5.0, false, false, false, false, false)
    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, -29.2, -1087.02, 25.53, 338.41, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)
	
	TriggerServerEvent("vehicle:buy")
end)

RegisterNetEvent("vehicle:parking:get")

AddEventHandler("vehicle:parking:get", function(data, id)
	local vehicleName = data.name
	currentVehicle = data.id
	menuOpened = 0
	TriggerEvent("menu:delete", "vehiclesShop") 
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
end)



RegisterNetEvent("vehicle:parking:store")

AddEventHandler("vehicle:parking:store", function(data)

	TriggerServerEvent("vehicle:store", currentVehicle, data.parking)
	print("store : ", data)
	currentVehicle = 0
	TriggerEvent("menu:delete", "vehiclesShop") 
	menuOpened = 0

	DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))

end)

RegisterNetEvent("vehicle:menu:closed")

AddEventHandler("vehicle:menu:closed", function()
	menuOpened = 0
end)
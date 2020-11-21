RegisterCommand('car', function(source, args)
    -- account for the argument not being passed
    local vehicleName = args[1] or 'adder'

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

    -- get the player's position
    local playerPed = PlayerPedId() -- get the local player ped
    local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
    SetModelAsNoLongerNeeded(vehicleName)

    -- tell the player
    TriggerEvent('chat:addMessage', {
		args = { 'Woohoo! Enjoy your new ^*' .. vehicleName .. '!' }
	})
end, false)


RegisterCommand("tpm", function(source)
    local WaypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(GetFirstBlipInfoId(8)) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end
    end
end)


RegisterCommand("tp", function(source, args)
   -- local waypointCoords = vector3(args[1], args[2], args[3])
   local waypointCoords = vector3(239.61, -2018.95, 18.31)
    for height = 1, 1000 do
        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

        local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

        if foundGround then
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            break
        end

        Citizen.Wait(5)
    end
end)



RegisterCommand("kill", function(source)
    SetEntityHealth(PlayerPedId(),0)
end)

RegisterCommand("revive", function(source)
    print("REVIVING")
    TriggerClientEvent('ambulance:revive', GetPlayerPed(-1))
end)

RegisterCommand("money:add", function(source, args)
    TriggerServerEvent('account:money:add', GetPlayerPed(-1), args[1])
end)

-- A second thread for running at a different delay.
Citizen.CreateThread(function()

    -- Wait until the settings have been loaded.
    while 0.2 == nil or 0.2 == nil do
        Citizen.Wait(1)
    end
    
    -- Do this every tick.
    while true do
        Citizen.Wait(0) -- these things NEED to run every tick.
        
        -- Traffic and ped density management
        SetTrafficDensity(1.0)
        SetPedDensity(1.0)
        
        -- Wanted level management
        SetPlayerWantedLevel(PlayerId(), 0, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
    
        -- Dispatch services management
        for i=0,20 do
            EnableDispatchService(i, false)
        end
        
    end
end)


function SetTrafficDensity(density)
    SetParkedVehicleDensityMultiplierThisFrame(density)
    SetVehicleDensityMultiplierThisFrame(density)
    SetRandomVehicleDensityMultiplierThisFrame(density)
end

function SetPedDensity(density)
    SetPedDensityMultiplierThisFrame(density)
    SetScenarioPedDensityMultiplierThisFrame(density, density)
end


RegisterCommand('coords', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = ""..coords.x..","..coords.y..","..coords.z..""
	})
end)


RegisterCommand('tpc', function(source, args, rawCommand)
	local coords = {}
	for coord in string.gmatch(args[1] or "0,0,0","[^,]+") do
		table.insert(coords,tonumber(coord))
	end

	local x,y,z = 0,0,0
	if coords[1] ~= nil then x = coords[1] end
	if coords[2] ~= nil then y = coords[2] end
	if coords[3] ~= nil then z = coords[3] end

	SetEntityCoords(GetPlayerPed(-1), x,y,z, false)
end)
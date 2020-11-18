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


RegisterCommand("change", function(source, args)

    local skin ={
        sex          = 0,
        face         = 0,
        skin         = 0,
        beard_1      = 0,
        beard_2      = 0,
        beard_3      = 0,
        beard_4      = 0,
        hair_1       = 0,
        hair_2       = 0,
        hair_color_1 = 0,
        hair_color_2 = 0,
        tshirt_1     = 0,
        tshirt_2     = 0,
        torso_1      = 0,
        torso_2      = 0,
        decals_1     = 0,
        decals_2     = 0,
        arms         = 0,
        pants_1      = 0,
        pants_2      = 0,
        shoes_1      = 0,
        shoes_2      = 0,
        mask_1       = 0,
        mask_2       = 0,
        bproof_1     = 0,
        bproof_2     = 0,
        chain_1      = 0,
        chain_2      = 0,
        helmet_1     = 0,
        helmet_2     = 0,
        glasses_1    = 0,
        glasses_2    = 0,
    }
    
    local row = args[1] or 'tshirt_1'
    local value = args[2] or '1'

    local clothes = {
        tshirt_1 = 0,  tshirt_2 = 0,
        torso_1 = 15,   torso_2 = 0,
        decals_1 = 0,   decals_2 = 0,
        arms = 0,
        pants_1 = 0,   pants_2 = 0,
        shoes_1 = 0,   shoes_2 = 0,
        helmet_1 = 2,  helmet_2 = 0,
        chain_1 = 0,    chain_2 = 0,
        ears_1 = 0,     ears_2 = 0
    }

    clothes[row] = tonumber(value)
    
    TriggerEvent('skinchanger:loadClothes', skin, clothes)
end)



-- TODO https://github.com/DevTestingPizza/vBasic/releases


-- A second thread for running at a different delay.
Citizen.CreateThread(function()

    -- Wait until the settings have been loaded.
    while settings.trafficDensity == nil or settings.pedDensity == nil do
        Citizen.Wait(1)
    end
    
    -- Do this every tick.
    while true do
        Citizen.Wait(0) -- these things NEED to run every tick.
        
        -- Traffic and ped density management
        SetTrafficDensity(settings.trafficDensity)
        SetPedDensity(settings.pedDensity)
        
        -- Wanted level management
        if (settings.neverWanted and GetPlayerWantedLevel(PlayerId()) > 0) then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
        
        -- Dispatch services management
        for i=0,20 do
            EnableDispatchService(i, not settings.noEmergencyServices)
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



Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
    local playerPed = GetPlayerPed(-1)
    local playerLocalisation = GetEntityCoords(playerPed)
    ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
    end
    end)
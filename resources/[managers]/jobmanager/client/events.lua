RegisterNetEvent("job:set")



-- source is global here, don't add to function
AddEventHandler('job:set', function (grade)
    TriggerServerEvent("job:set", grade)
end)

RegisterNetEvent("job:draw")

-- source is global here, don't add to function
AddEventHandler('job:draw', function (jobe, gradee)
    job = jobe
    grade = gradee
end)


AddEventHandler('job:hasEnteredMarker', function(location, job)
    label = config.jobs[job].label
    if location.action == 'lockers' then
        DisplayHelpText("Ouvrir le vestiaire : "..label,0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1,config.bindings.interact_position) then
            load_cloackroom(job)
            OpenCloackroom(job)
        end
    elseif location.action == 'collect' then
        DisplayHelpText("Collecter : "..label,0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1,config.bindings.interact_position) then
            collect(location, job)
        end
    elseif location.action == 'process' then
        DisplayHelpText("Transformation : "..label,0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1,config.bindings.interact_position) then
            process(location, job)
        end
    elseif location.action == 'safe' then
        DisplayHelpText("Coffre : "..label,0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1,config.bindings.interact_position) then
            safe()
        end
    elseif location.action == 'parking' then
        DisplayHelpText("Parking : "..label,0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1,config.bindings.interact_position) then
            parking(job)
        end
    end
end)

AddEventHandler('job:hasExitedMarker', function(station, part, partNum)
    -- close menu

	CurrentAction = nil
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

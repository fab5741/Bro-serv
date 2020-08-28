local job = "Chomeur"
local grade = "Chomeur"

Citizen.CreateThread(function()
    TriggerEvent("job:set", 4)
    Wait(5000)
    while true do
        Wait(30)

        SetTextFont(0)
        SetTextScale(0.0, 0.3)
        SetTextColour(128, 128, 128, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(0, 1, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString("Job : ".. job)
        DrawText(0.90, 0.95)
        SetTextFont(0)
        SetTextScale(0.0, 0.3)
        SetTextColour(128, 128, 128, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(0, 1, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString("Grade : ".. grade)
        DrawText(0.90, 0.975)
     end

end)

RegisterNetEvent("job:draw")

-- source is global here, don't add to function
AddEventHandler('job:draw', function (jobe, gradee)
    if(not jobe or not gradee) then
        TriggerServerEvent("job:get")
        return
    end
    job = jobe
    grade = gradee
end)


RegisterNetEvent("job:set")

-- source is global here, don't add to function
AddEventHandler('job:set', function (grade)
    print(grade)
    TriggerServerEvent("job:set", grade)
end)



-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(config.jobs) do
        local blip = AddBlipForCoord(v.collect.coords)
        SetBlipSprite(blip, v.collect.blip.sprite)
        SetBlipScale(blip, v.collect.blip.scale)
        SetBlipColour(blip, v.collect.blip.color)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Collect')
        EndTextCommandSetBlipName(blip)
    end
end)


AddEventHandler('job:hasEnteredMarker', function(station, part, partNum)
	if part == 'collect' then
        print("collect that ?")
	end	
end)

AddEventHandler('job:hasExitedMarker', function(station, part, partNum)
    -- close menu

	CurrentAction = nil
end)


-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local letSleep, isInMarker, hasExited = true, false, false
        local currentstation, currentPart, currentPartNum

        for k,v in pairs(config.jobs) do
            local distance = #(playerCoords - v.collect.coords)

            if distance < config.DrawDistance then
                DrawMarker(config.Marker.type,  v.collect.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
                letSleep = false
                if distance < config.Marker.x then
                    isInMarker, currentstation, currentPart, currentPartNum = true, k, 'collect', 1
                end
            end
        end
        -- Logic for exiting & entering markers
        if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (Laststation ~= currentstation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
            if
                (Laststation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
                (Laststation ~= currentstation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
            then
                TriggerEvent('job:hasExitedMarker', Laststation, LastPart, LastPartNum)
                hasExited = true
            end

            HasAlreadyEnteredMarker, Laststation, LastPart, LastPartNum = true, currentstation, currentPart, currentPartNum

            TriggerEvent('job:hasEnteredMarker', currentstation, currentPart, currentPartNum)
        end

        if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('job:hasExitedMarker', Laststation, LastPart, LastPartNum)
        end

        if letSleep then
            Citizen.Wait(500)
        end
	end
end)


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

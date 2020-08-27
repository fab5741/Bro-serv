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
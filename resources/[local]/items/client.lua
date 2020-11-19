
RegisterNUICallback('use', function(data)
    if data.label == "Pain" then
        print("change needs ")
        TriggerServerEvent("needs:change", 1, 60)
    end
    if data.label == "Eau" then
        TriggerServerEvent("needs:change", 0, 60)
    end
    if data.label == "Jus de raisin" then
        TriggerServerEvent("needs:change", 1, 80)
        TriggerServerEvent("needs:change", 0, 10)
    end

    TriggerServerEvent("items:sub", data.item, data.amount)
end)
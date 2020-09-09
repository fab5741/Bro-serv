
RegisterNUICallback('use', function(data)
    print("name", data.label)
    if data.label == "Pain" then
        print("change needs ")
        TriggerServerEvent("needs:change", 1, 60)
    end
    if data.label == "Eau" then
        TriggerServerEvent("needs:change", 0, 60)
    end

    TriggerServerEvent("items:sub", data.item, data.amount)
end)
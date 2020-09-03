RegisterNetEvent("menu:create")

AddEventHandler("menu:create", function(name, title, type, subtitle, items, position, cb, cbServer)
    if type == "form" then
        SetNuiFocus(true, true)
    end

    SendNUIMessage({
        name = name,
        title = title,
        type = type,
        subtitle = subtitle,
        items = json.encode(items),
        position= position,
        action = "setAndOpen",
        cb = cb
    })
    
    RegisterNUICallback(cb, function(data)
        TriggerEvent(cbServer, data)
    end)
end)

RegisterNetEvent("menu:delete")

AddEventHandler("menu:delete", function(name)
    SetNuiFocus(false, false)
    SendNUIMessage({
        name = name,
        action = "delete",
    })

end)
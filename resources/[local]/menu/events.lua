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

RegisterNetEvent("menu:progress:create")


AddEventHandler("menu:progress:create", function(name)
    SendNUIMessage({
        name = name,
        type = "progress",
        action = "setAndOpen",
    })
end)


RegisterNetEvent("menu:progress:update")


AddEventHandler("menu:progress:udpate", function(name, value)
    SendNUIMessage({
        name = name,
        type = "progress",
        value = value,
        action = "update",
    })
end)

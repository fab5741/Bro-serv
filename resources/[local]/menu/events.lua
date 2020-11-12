RegisterNetEvent("menu:create")

isOpen = {

}


AddEventHandler("menu:create", function(name, title, type, subtitle, items, position, cb, cbServer)
    if(not isOpen[name]) then
        if type == "form" then
            SetNuiFocus(true, true)
        end
        currentMenu = name

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
    end
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


AddEventHandler("menu:progress:create", function(name, color)
    SendNUIMessage({
        name = name,
        type = "progress",
        action = "setAndOpen",
        color = color,
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

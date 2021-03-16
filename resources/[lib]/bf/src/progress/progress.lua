RegisterNetEvent("bf:progress:create")

AddEventHandler("bf:progress:create", function(name, color)
    SendNUIMessage({
        name = name,
        type = "progress",
        action = "setAndOpen",
        color = color,
    })
end)

RegisterNetEvent("bf:progress:update")


AddEventHandler("bf:progress:udpate", function(name, value)
    SendNUIMessage({
        name = name,
        type = "progress",
        value = value,
        action = "update",
    })
end)

RegisterNetEvent("bf:progress:delete")

AddEventHandler("bf:progress:delete", function(name, color)
    SendNUIMessage({
        name = name,
        type = "progress",
        action = "delete",
        color = color,
    })
end)


RegisterNetEvent("bf:progressBar:create")

AddEventHandler("bf:progressBar:create", function(time, text)
	SendNUIMessage({
		action = "ui",
		display = true,
		time = time,
		text = text
	})
end)

RegisterNetEvent("bf:progressBar:delete")

AddEventHandler("bf:progressBar:delete", function()
	SendNUIMessage({
		action = "ui",
		display = false
	})
end)
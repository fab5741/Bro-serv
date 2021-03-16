RegisterNetEvent("bro_core:progress:create")

AddEventHandler("bro_core:progress:create", function(name, color)
    print("create progress")
    SendNUIMessage({
        name = name,
        type = "progress",
        action = "setAndOpen",
        color = color,
    })
end)

RegisterNetEvent("bro_core:progress:update")


AddEventHandler("bro_core:progress:udpate", function(name, value)
    SendNUIMessage({
        name = name,
        type = "progress",
        value = value,
        action = "update",
    })
end)

RegisterNetEvent("bro_core:progress:delete")

AddEventHandler("bro_core:progress:delete", function(name, color)
    SendNUIMessage({
        name = name,
        type = "progress",
        action = "delete",
        color = color,
    })
end)


RegisterNetEvent("bro_core:progressBar:create")

AddEventHandler("bro_core:progressBar:create", function(time, text)
	SendNUIMessage({
		action = "ui",
		display = true,
		time = time,
		text = text
	})
end)

RegisterNetEvent("bro_core:progressBar:delete")

AddEventHandler("bro_core:progressBar:delete", function()
	SendNUIMessage({
		action = "ui",
		display = false
	})
end)
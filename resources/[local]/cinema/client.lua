local cinema = false

RegisterCommand("cinema", function()
	cinema = not cinema
	if cinema then
		DisplayRadar(false)
		SendNUIMessage({
			action = "cinema"
		})

		TriggerEvent("ui:toggle")

		while cinema do Wait(0) end
	end

	DisplayRadar(true)

	SendNUIMessage({
		action = "close"
	})

	TriggerEvent("ui:toggle", true)
end)
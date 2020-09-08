config = {
	shops = {
		main = {
			coords = vector3(-43.67,-1109.33,25.44),
			Blip = {
				coords = vector3(-43.67,-1109.33,26.44),
				sprite = 523,
				scale  = 0.8,
				color  = 2
			},
		}
	},
	parkings = {
		main = {
			coords = vector3(234.68,-782.73,29.9),
			Blip = {
				coords = vector3(234.68,-782.73,30.24),
				sprite = 357,
				scale  = 0.8,
				color  = 2
			},
		}
	}
}

config.Marker  = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
config.DrawDistance = 20

-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(config.shops) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Concessionnaire')
		EndTextCommandSetBlipName(blip)
	end
	for k,v in pairs(config.parkings) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Parking')
		EndTextCommandSetBlipName(blip)
	end
end)

-- Draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(config.shops) do
			local distance = #(playerCoords - v.coords)

			if distance < config.DrawDistance then
				DrawMarker(config.Marker.type, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
			end

			if distance < config.Marker.x then	
				local items = {
					{name = "buy", label =  'Acheter', items= {
						{name = "issi", label =  'Issi'},
						{name = "ferari", label =  'Ferari'},
						{name = "vader", label =  'Vader'}
					}},
					{name = "sell", label =  'Vendre'},
				}

				TriggerEvent("menu:create", "vehicles:shop", "Concessionnaire", "list",
					"", items, "center|midlle", "", "") 
			end
		end
		for k,v in pairs(config.parkings) do
			local distance = #(playerCoords - v.coords)

			if distance < config.DrawDistance then
				DrawMarker(config.Marker.type, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
			end

			if distance < config.Marker.x then
				local items = {
					{name = "store", label =  'Stocker un vehicule'},
					{name = "get", label =  'Récupérer un vehicule'},
				}

				TriggerEvent("menu:create", "vehicles:shop", "Concessionnaire", "list",
					"", items, "center|midlle", "", "") 
			end
		end
	end
end)
config = {}
config.DrawDistance = 100
config.Size         = {x = 1.5, y = 1.5, z = 1.5}
config.Color        = {r = 0, g = 128, b = 255}
config.Type         = 1

config.Zones = {
	TwentyFourSeven = {
		{
			id =1,
			pos = {x = 373.875,   y = 325.896,  z = 102.566},
			pnj = {model = "mp_m_shopkeep_01", x=372.77, y=327.64, z=103.57, a=242.89},
			storage = {
				x= 375.63, 
				y= 333.64,
				z= 101.57
			}
		},
		{
			id =2,
			pos = {x = 2557.458,  y = 382.282,  z = 107.622},
			pnj = {model = "mp_m_shopkeep_01", x=2557.03, y=380.69, z=108.62, a=5.3},
			storage = {
				x= 2549.59, 
				y= 382.15,
				z= 106.62
			}
		},
		{
			id =3,
			pos = {x = 547.431,   y = 2671.710, z = 41.156},
			pnj = {model = "mp_m_shopkeep_01", x=549.43, y=2669.35, z=42.16, a=80.64},
			storage = {
				x= 548.8, 
				y= 2662.91,
				z= 41.0
			}
		},
		{
			id =4,
			pos = {x = 1961.464,  y = 3740.672, z = 31.343},
			pnj = {model = "mp_m_shopkeep_01", x=1958.77, y=3741.79, z=32.34, a=276.71},
			storage = {
				x= 1957.64, 
				y= 3747.6,
				z= 30.34
			}
		},
		{
			id =5,
			pos = {x = 1729.216,  y = 6414.131, z = 34.037},
			pnj = {model = "mp_m_shopkeep_01", x=1728.84, y=6417.17, z=35.04, a=232.14},
			storage = {
				x= 1732.85, 
				y= 6421.49,
				z= 33.0
			}
		},
	},

	LTDgasoline = {
		{			
			id =6,
			pos = {x = -48.519,   y = -1757.514, z = 28.421},
			pnj = {model = "mp_m_shopkeep_01", x=-46.58, y=-1757.82, z=29.42, a=11.33},
			storage = {
				x= -41.2, 
				y= -1751.55,
				z= 27.42
			}
		},
		{
			id =7,
			pos = {x = 1163.373,  y = -323.801,  z = 68.205},
			pnj = {model = "mp_m_shopkeep_01", x=1165.07, y=-324.48, z=69.21, a=92.26},
			storage = {
				x= 1163.57, 
				y= -313.72,
				z= 67.21
			}
		},
		{
			id =8,
			pos = {x = -707.501,  y = -914.260,  z = 18.215},
			pnj = {model = "mp_m_shopkeep_01", x=-705.47, y=-913.5, z=19.22, a=91.14},
			storage = {
				x= -705.64, 
				y= -904.96,
				z= 17.22
			}
		},
		{
			id =9,
			pos = {x = -1820.523, y = 792.518,   z = 137.118},
			pnj = {model = "mp_m_shopkeep_01", x=-1819.16, y=793.22, z=138.08, a=113.33},
			storage = {
				x= -1825.523, 
				y= 800.64,
				z= 136.12,
			}
		},
		{
			id =10,
			pos = {x = 1698.388,  y = 4924.404,  z = 41.063},
			pnj = {model = "mp_m_shopkeep_01", x=1698.79, y=4922.33, z=42.06, a=0.31},
			storage = {
				x= 1705.15, 
				y= 4917.68,
				z= 40.0
			}
		},
	}
}

config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

config.robLength = 60
config.robMaxDistance = 20

-- Create blips
Citizen.CreateThread(function()   
    for k,v in pairs(config.Zones) do
		for i = 1, #v, 1 do
			local blip = AddBlipForCoord(v[i].pos.x, v[i].pos.y, v[i].pos.z)

			SetBlipSprite (blip, 52)
			SetBlipScale  (blip, 1.0)
			SetBlipColour (blip, 2)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName('Supérette')
			EndTextCommandSetBlipName(blip)

			RequestModel(GetHashKey(v[i].pnj.model))
			while not HasModelLoaded(GetHashKey(v[i].pnj.model)) do
				Wait(1)
			end

		-- Spawn the bartender to the coordinates
			bartender =  CreatePed(5, v[i].pnj.model, v[i].pnj.x, v[i].pnj.y, v[i].pnj.z, v[i].pnj.a, false, true)
			SetBlockingOfNonTemporaryEvents(bartender, true)
			SetPedCombatAttributes(bartender, 46, true)
			SetPedFleeAttributes(bartender, 0, 0)
			SetPedRelationshipGroupHash(bartender, GetHashKey("CIVFEMALE"))
		end
	end
end)

AddEventHandler('shops:hasEnteredMarker', function(zone)
	isInshopsMarker = true
	currentZone = zone
	TriggerEvent("notify:SendNotification", {text = "<span style='font-weight: 900'>Appuyez sur e pour le magasin</span>",
	layout = "centerLeft",
	timeout = 2000,
	progressBar = false,
	type = "error",
	animation = {
		open = "gta_effects_fade_in",
		close = "gta_effects_fade_out"
	}})
end)

AddEventHandler('shops:hasExitedMarker', function(zone)
	isInshopsMarker = false
	currentZone = zone
end)


-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, false
		isInMarkerStorage, letSleep, currentZone = false, false

		for k,v in pairs(config.Zones) do
			for i = 1, #v, 1 do
				local distance = GetDistanceBetweenCoords(playerCoords, v[i].pos.x, v[i].pos.y, v[i].pos.z, true)

				if distance < config.DrawDistance then
					DrawMarker(config.Type, v[i].pos.x, v[i].pos.y, v[i].pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Size.x, config.Size.y, config.Size.z, config.Color.r, config.Color.g, config.Color.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false

					if distance < config.Size.x then
						isInMarker  = true
						currentZone = k
						lastZone    = k
					end
				end

				distance = GetDistanceBetweenCoords(playerCoords, v[i].storage.x, v[i].storage.y, v[i].storage.z, true)

				if distance < config.DrawDistance then
					DrawMarker(config.Type, v[i].storage.x, v[i].storage.y, v[i].storage.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Size.x, config.Size.y, config.Size.z, config.Color.r, config.Color.g, config.Color.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false

					if distance < config.Size.x then
						isInMarkerStorage  = v[i].id
					end
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('shops:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('shops:hasExitedMarker', lastZone)
		end
		

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

local menuIsShowed = false

RegisterNetEvent('shops:closeMenu')
AddEventHandler('shops:closeMenu', function()
	SetNuiFocus(false)
	menuIsShowed = false
	SendNUIMessage({
		hideAll = true
	})
end)

RegisterNUICallback('escape', function(data, cb)
	TriggerEvent('shops:closeMenu')
	cb('ok')
end)


RegisterNUICallback('buy', function(data, cb)
	TriggerServerEvent('shops:buy', data.type, data.amount, currentZone)
	cb('ok')
end)

-- Menu interactions
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isInMarkerStorage then
			if IsControlJustReleased(0, 46) and IsPedOnFoot(PlayerPedId()) then
				TriggerEvent('job:openStorageMenu', isInMarkerStorage, "Fermiers")
			end
		end
	end
end)

-- Menu interactions
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isInshopsMarker and not menuIsShowed then
			if IsControlJustReleased(0, 38) and IsPedOnFoot(PlayerPedId()) then
				menuIsShowed = true
				SendNUIMessage({
					showMenu = true,
					shops = {
						money = 0,
					}
				})
				SetNuiFocus(true, true)
			end
		else
			Citizen.Wait(500)
		end
	end
end)


-- close the menu when script is stopping to avoid being stuck in NUI focus
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuIsShowed then
			TriggerEvent('shops:closeMenu')
		end
	end
end)



--- roberry

function robNpc(targetPed)
    robbedRecently = true

    Citizen.CreateThread(function()
        local dict = 'random@mugging3'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(10)
        end

        TaskStandStill(targetPed, config.robLength * 1000)
        FreezeEntityPosition(targetPed, true)
        TaskPlayAnim(targetPed, dict, 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)
		TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "Braquage en cours", false)

        Citizen.Wait(config.robLength * 1000)

		local playerCoords = GetEntityCoords(PlayerPedId())

		if(GetDistanceBetweenCoords(GetEntityCoords(targetPed), GetEntityCoords(GetPlayerPed(-1))) < config.robMaxDistance) then
			local j = 0
			for k,v in pairs(config.Zones) do
				for i = 1, #v, 1 do
					j = j+1
					local distance = GetDistanceBetweenCoords(playerCoords, v[i].pos.x, v[i].pos.y, v[i].pos.z, true)

					if distance < config.DrawDistance then
						TriggerServerEvent("shops:rob", v[i].id)
					end
				end
			end
		else
			TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "Vous vous êtes trop éloigné", false)
		end
        robbedRecently = false
    end)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if IsControlJustPressed(0, 58) then
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))

            if aiming then
                local playerPed = GetPlayerPed(-1)

                if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
					if robbedRecently then
						TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "Trop rapide !", false)
					elseif IsPedDeadOrDying(targetPed, true) then
						TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "L'épicier est mort", false)
                    else
                        robNpc(targetPed)
                    end
                end
            end
        end
    end
end)


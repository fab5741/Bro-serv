config = {}
config.DrawDistance = 100
config.Size         = {x = 1.5, y = 1.5, z = 1.5}
config.Color        = {r = 0, g = 128, b = 255}
config.Type         = 1

config.Zones = {

	TwentyFourSeven = {
		{
			pos = {x = 373.875,   y = 325.896,  z = 102.566},
			pnj = {model = "mp_m_shopkeep_01", x=372.77, y=327.64, z=103.57, a=242.89},
		},
		{
			pos = {x = 2557.458,  y = 382.282,  z = 107.622},
			pnj = {model = "mp_m_shopkeep_01", x=2557.03, y=380.69, z=108.62, a=5.3},
		},
		{
			pos = {x = 547.431,   y = 2671.710, z = 41.156},
			pnj = {model = "mp_m_shopkeep_01", x=549.43, y=2669.35, z=42.16, a=80.64},
		},
		{
			pos = {x = 1961.464,  y = 3740.672, z = 31.343},
			pnj = {model = "mp_m_shopkeep_01", x=1958.77, y=3741.79, z=32.34, a=276.71},
		},
		{
			pos = {x = 1729.216,  y = 6414.131, z = 34.037},
			pnj = {model = "mp_m_shopkeep_01", x=1728.84, y=6417.17, z=35.04, a=232.14},
		},
	},

	LTDgasoline = {
		{
			pos = {x = -48.519,   y = -1757.514, z = 28.421},
			pnj = {model = "mp_m_shopkeep_01", x=-46.58, y=-1757.82, z=29.42, a=11.33},
		},
		{
			pos = {x = 1163.373,  y = -323.801,  z = 68.205},
			pnj = {model = "mp_m_shopkeep_01", x=1165.07, y=-324.48, z=69.21, a=92.26},
		},
		{
			pos = {x = -707.501,  y = -914.260,  z = 18.215},
			pnj = {model = "mp_m_shopkeep_01", x=-705.47, y=-913.5, z=19.22, a=91.14},
		},
		{
			pos = {x = -1820.523, y = 792.518,   z = 137.118},

			pnj = {model = "mp_m_shopkeep_01", x=-1819.16, y=793.22, z=138.08, a=113.33},
		},
		{
			pos = {x = 1698.388,  y = 4924.404,  z = 41.063},
			pnj = {model = "mp_m_shopkeep_01", x=1698.79, y=4922.33, z=42.06, a=0.31},
		},
	}
}

config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

config.PoliceNumberRequired = 2
config.TimerBeforeNewRob    = 1800 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

config.MaxDistance    = 20   -- max distance from the robbary, going any longer away from it will to cancel the robbary
config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

config.stores = {
	["paleto_twentyfourseven"] = {
		position = { x = 1736.32, y = 6419.47, z = 35.03 },
		reward = math.random(5000, 35000),
		nameOfStore = "24/7. (Paleto Bay)",
		secondsRemaining = 350, -- seconds
		lastRobbed = 0,
	},
	["sandyshores_twentyfoursever"] = {
		position = { x = 1961.24, y = 3749.46, z = 32.34 },
		reward = math.random(3000, 20000),
		nameOfStore = "24/7. (Sandy Shores)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["littleseoul_twentyfourseven"] = {
		position = { x = -709.17, y = -904.21, z = 19.21 },
		reward = math.random(3000, 20000),
		nameOfStore = "24/7. (Little Seoul)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["bar_one"] = {
		position = { x = 1990.57, y = 3044.95, z = 47.21 },
		reward = math.random(5000, 35000),
		nameOfStore = "Yellow Jack. (Sandy Shores)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["ocean_liquor"] = {
		position = { x = -2959.33, y = 388.21, z = 14.00 },
		reward = math.random(3000, 30000),
		nameOfStore = "Robs Liquor. (Great Ocean Highway)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["rancho_liquor"] = {
		position = { x = 1126.80, y = -980.40, z = 45.41 },
		reward = math.random(3000, 50000),
		nameOfStore = "Robs Liquor. (El Rancho Blvd)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["sanandreas_liquor"] = {
		position = { x = -1219.85, y = -916.27, z = 11.32 },
		reward = math.random(3000, 30000),
		nameOfStore = "Robs Liquor. (San Andreas Avenue)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["grove_ltd"] = {
		position = { x = -43.40, y = -1749.20, z = 29.42 },
		reward = math.random(3000, 15000),
		nameOfStore = "LTD Gasoline. (Grove Street)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["mirror_ltd"] = {
		position = { x = 1160.67, y = -314.40, z = 69.20 },
		reward = math.random(3000, 15000),
		nameOfStore = "LTD Gasoline. (Mirror Park Boulevard)",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	}
}

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
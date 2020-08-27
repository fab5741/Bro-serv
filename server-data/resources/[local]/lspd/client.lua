local config = {
    stations = {	
		center = {

            Blip = {
                coords = vector3(441.83,-982.71,30.69),
                sprite = 137,
                scale  = 1.2,
                color  = 38
            },

            lspdActions = {
            },

            Pharmacies = {
			},
			
			lockers = {
				coords = vector3(454.39,-989.4,29.5),
				blip = {
					coords = vector3(454.39,-989.4,29.5),
					sprite = 73,
					scale  = 0.5,
					color  = 38
				},
			},

			armory = {
				coords = vector3(452.36,-980.33,29.6),
				blip = {
					coords = vector3(452.36,-980.33,29.6),
					sprite = 156,
					scale  = 0.5,
					color  = 38
				},
			},

            Vehicles = {
				coords = vector3(463.1,-1019.83,26.9),
            },

            Helicopters = {
				coords = vector3(448.83, -981.36, 42.69),
            },

            FastTravels = {
            },

            FastTravelsPrompt = {
            }
        }
	}
}
config.DrawDistance               = 20.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

config.Marker                     = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}

config.ReviveReward               = 700  -- Revive reward, set to 0 if you don't want it enabled
config.AntiCombatLog              = true -- Enable anti-combat logging? (Removes Items when a player logs back after intentionally logging out while dead.)
config.LoadIpl                    = true -- Disable if you're using fivem-ipl or other IPL loaders

config.BleedoutTimer              = 90000 * 10 -- time til the player bleeds out

config.EnablePlayerManagement     = false -- Enable society managing (If you are using esx_society).

config.RespawnPoint = {coords = vector3(341.0, -1397.3, 32.5), heading = 48.5}

config.AuthorizedVehicles = {
	car = {
		lspd = {
			{model = 'lspd', price = 5000}
		},

		doctor = {
			{model = 'lspd', price = 4500}
		},

		chief_doctor = {
			{model = 'lspd', price = 3000}
		},

		boss = {
			{model = 'lspd', price = 2000}
		}
	},

	helicopter = {
		lspd = {},

		doctor = {
			{model = 'buzzard2', price = 150000}
		},

		chief_doctor = {
			{model = 'buzzard2', price = 150000},
			{model = 'seasparrow', price = 300000}
		},

		boss = {
			{model = 'buzzard2', price = 10000},
			{model = 'seasparrow', price = 250000}
		}
	}
}

local onDuty
-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(config.stations) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Police')
		EndTextCommandSetBlipName(blip)

		local blip = AddBlipForCoord(v.lockers.blip.coords)
		SetBlipSprite(blip, v.lockers.blip.sprite)
		SetBlipScale(blip, v.lockers.blip.scale)
		SetBlipColour(blip, v.lockers.blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Vestiaire')
		EndTextCommandSetBlipName(blip)

		local blip = AddBlipForCoord(v.armory.blip.coords)
		SetBlipSprite(blip, v.armory.blip.sprite)
		SetBlipScale(blip, v.armory.blip.scale)
		SetBlipColour(blip, v.armory.blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Armurerie')
		EndTextCommandSetBlipName(blip)
	end

end)

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        -- TODO if job is lspd
        if true then
            DrawMarker(0, 117.14, -1950.29, 20,7513, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.75, 0.75, 0.75, 204, 204, 0, 100, false, true, 2, false, false, false, false)

			local playerCoords = GetEntityCoords(PlayerPedId())
			local letSleep, isInMarker, hasExited = true, false, false
			local currentstation, currentPart, currentPartNum

            for stationNum,station in pairs(config.stations) do
				-- lspd Actions
				for k,v in ipairs(station.lspdActions) do
					local distance = #(playerCoords - v)

					if distance < config.DrawDistance then
						DrawMarker(config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < config.Marker.x then
							isInMarker, currentstation, currentPart, currentPartNum = true, stationNum, 'lspdActions', k
						end
					end
				end

				-- lspds lockers
				local distance = #(playerCoords - station.lockers.coords)

				if distance < config.DrawDistance then
					DrawMarker(config.Marker.type, station.lockers.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
					letSleep = false
					if distance < config.Marker.x then
						isInMarker, currentstation, currentPart, currentPartNum = true, stationNum, 'lockers', 1
					end
				end

				-- armory
				local distance = #(playerCoords - station.armory.coords)

				if distance < config.DrawDistance then
					DrawMarker(config.Marker.type, station.armory.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
					letSleep = false
					if distance < config.Marker.x then
						isInMarker, currentstation, currentPart, currentPartNum = true, stationNum, 'armory', 1
					end
				end

				-- Pharmacies
				for k,v in ipairs(station.Pharmacies) do
					local distance = #(playerCoords - v.coords)

					if true then
						DrawMarker(config.Marker.type, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < config.Marker.x then
							isInMarker, currentstation, currentPart, currentPartNum = true, stationNum, 'Pharmacy', k
						end
					end
				end

				-- Vehicle Spawners
				-- Helicopter Spawners
				local distance = #(playerCoords - station.Vehicles.coords)

				if distance < config.DrawDistance then
					DrawMarker(config.Marker.type, station.Vehicles.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
					letSleep = false
					if distance < config.Marker.x then
						isInMarker, currentstation, currentPart, currentPartNum = true, stationNum, 'Vehicles', 1
					end
				end

				-- Helicopter Spawners
				local distance = #(playerCoords - station.Helicopters.coords)

				if distance < config.DrawDistance then
					DrawMarker(config.Marker.type, station.Helicopters.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
					letSleep = false
					if distance < config.Marker.x then
						isInMarker, currentstation, currentPart, currentPartNum = true, stationNum, 'Helicopters', 1
					end
				end

				-- Fast Travels (Prompt)
				for k,v in ipairs(station.FastTravelsPrompt) do
					local distance = #(playerCoords - v.From)

					if distance < config.DrawDistance then
						DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentstation, currentPart, currentPartNum = true, stationNum, 'FastTravelsPrompt', k
						end
					end
				end
			end

			-- Logic for exiting & entering markers
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (Laststation ~= currentstation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(Laststation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(Laststation ~= currentstation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('lspd:hasExitedMarker', Laststation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker, Laststation, LastPart, LastPartNum = true, currentstation, currentPart, currentPartNum

				TriggerEvent('lspd:hasEnteredMarker', currentstation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('lspd:hasExitedMarker', Laststation, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Fast travels
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, letSleep = GetEntityCoords(PlayerPedId()), true

		for stationNum,station in pairs(config.stations) do
			-- Fast Travels
			for k,v in ipairs(station.FastTravels) do
				local distance = #(playerCoords - v.From)

				if distance < config.DrawDistance then
					DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
					letSleep = false

					if distance < v.Marker.x then
						FastTravel(v.To.coords, v.To.heading)
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

local skinChanged = false

AddEventHandler('lspd:hasEnteredMarker', function(station, part, partNum)
	if part == 'lspdActions' then
		CurrentAction = part
		CurrentActionMsg = _U('actions_prompt')
		CurrentActionData = {}
	elseif part == 'Pharmacy' then
		CurrentAction = part
		CurrentActionMsg = _U('open_pharmacy')
		CurrentActionData = {}
	elseif part == 'Vehicles' then
	-- account for the argument not being passed
	local vehicleName = 'police'

	-- check if the vehicle actually exists
	if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
		TriggerEvent('chat:addMessage', {
			args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
		})

		return
	end

	-- load the model
	RequestModel(vehicleName)

	-- wait for the model to load
	while not HasModelLoaded(vehicleName) do
		Wait(500) -- often you'll also see Citizen.Wait
	end

	-- get the player's position
	local playerPed = PlayerPedId() -- get the local player ped
	local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

	-- create the vehicle
	local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

	-- set the player ped into the vehicle's driver seat
	SetPedIntoVehicle(playerPed, vehicle, -1)

	-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
	SetEntityAsNoLongerNeeded(vehicle)

	-- release the model
	SetModelAsNoLongerNeeded(vehicleName)
	elseif part == 'Helicopters' then
		-- account for the argument not being passed
		local vehicleName = 'polmav'

		-- check if the vehicle actually exists
		if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
			TriggerEvent('chat:addMessage', {
				args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
			})

			return
		end

		-- load the model
		RequestModel(vehicleName)

		-- wait for the model to load
		while not HasModelLoaded(vehicleName) do
			Wait(500) -- often you'll also see Citizen.Wait
		end

		-- get the player's position
		local playerPed = PlayerPedId() -- get the local player ped
		local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

		-- create the vehicle
		local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

		-- set the player ped into the vehicle's driver seat
		SetPedIntoVehicle(playerPed, vehicle, -1)

		-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
		SetEntityAsNoLongerNeeded(vehicle)

		-- release the model
		SetModelAsNoLongerNeeded(vehicleName)
	elseif part == 'FastTravelsPrompt' then
		local travelItem = config.stations[station][part][partNum]

		CurrentAction = part
		CurrentActionMsg = travelItem.Prompt
		CurrentActionData = {to = travelItem.To.coords, heading = travelItem.To.heading}
	elseif part == 'lockers' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skinChanged then
				print("not on duty")
				TriggerEvent('skinchanger:loadSkin', skin)
				TriggerEvent('skinchanger:loadClothes', {})
				skinChanged =false
				onDuty = false
			else
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', 
					{        ['tshirt_1'] = 38,  ['tshirt_2'] = 1,
					['torso_1'] = 31,   ['torso_2'] = 0,
					['decals_1'] = 8,   ['decals_2'] = 3,
					['arms'] = 30,
					['pants_1'] = 25,   ['pants_2'] = 1,
					['shoes_1'] = 54,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 6,    ['chain_2'] = 0,
					['ears_1'] = 0,     ['ears_2'] = 0})
				else
					TriggerEvent('skinchanger:loadClothes', 
					{      ['tshirt_1'] = 51,  ['tshirt_2'] = 1,
					['torso_1'] = 25,   ['torso_2'] = 0,
					['decals_1'] = 7,   ['decals_2'] = 3,
					['arms'] = 31,
					['pants_1'] = 41,   ['pants_2'] = 2,
					['shoes_1'] = 41,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['chain_1'] = 8,    ['chain_2'] = 0,
					['ears_1'] = 0,     ['ears_2'] = 0})
				end
				skinChanged = true
				onDuty = true
			end
		end)
	elseif part == 'armory' then
		--"add a weapon"
		GiveWeaponToPed(GetPlayerPed(-1),"WEAPON_NIGHTSTICK")
		GiveWeaponToPed(GetPlayerPed(-1),"WEAPON_PISTOL", 40)
		GiveWeaponToPed(GetPlayerPed(-1),"StunGun")	
	end	
end)

AddEventHandler('lspd:hasExitedMarker', function(station, part, partNum)
    -- close menu

	CurrentAction = nil
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			--ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'lspdActions' then
					OpenlspdActionsMenu()
				elseif CurrentAction == 'Pharmacy' then
					OpenPharmacyMenu()
                elseif CurrentAction == 'Vehicles' then
				-- account for the argument not being passed
				local vehicleName = 'maverick'

				-- check if the vehicle actually exists
				if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
					TriggerEvent('chat:addMessage', {
						args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
					})

					return
				end

				-- load the model
				RequestModel(vehicleName)

				-- wait for the model to load
				while not HasModelLoaded(vehicleName) do
					Wait(500) -- often you'll also see Citizen.Wait
				end

				-- get the player's position
				local playerPed = PlayerPedId() -- get the local player ped
				local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

				-- create the vehicle
				local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

				-- set the player ped into the vehicle's driver seat
				SetPedIntoVehicle(playerPed, vehicle, -1)

				-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
				SetEntityAsNoLongerNeeded(vehicle)

				-- release the model
				SetModelAsNoLongerNeeded(vehicleName)
				
					OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentAction, CurrentActionData.partNum)
				elseif CurrentAction == 'Helicopters' then
					OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentAction, CurrentActionData.partNum)
				elseif CurrentAction == 'FastTravelsPrompt' then
					FastTravel(CurrentActionData.to, CurrentActionData.heading)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)


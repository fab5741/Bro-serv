config.stations = {	
--	center = {

--		Blip = {
--			coords = vector3(441.83,-982.71,30.69),
--			sprite = 137,
--			scale  = 1.2,
--			color  = 38
--		},
--
--		lspdActions = {
--		},
--
--		Pharmacies = {
--		},
--		
--		lockers = {
--			coords = vector3(454.39,-989.4,29.5),
--			blip = {
--				coords = vector3(454.39,-989.4,29.5),
--				sprite = 73,
--				scale  = 0.5,
--				color  = 38
--			},
--		},
--
--		armory = {
--			coords = vector3(452.36,-980.33,29.6),
--			blip = {
--				coords = vector3(452.36,-980.33,29.6),
--				sprite = 156,
--				scale  = 0.5,
--				color  = 38
--			},
--		},
--
--		Vehicles = {
--			coords = vector3(463.1,-1019.83,26.9),
--		},
--
--		Helicopters = {
--			coords = vector3(448.83, -981.36, 42.69),
--		},
--
--		FastTravels = {
--		},
--
--		FastTravelsPrompt = {
--		}
--	}
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


-- https://github.com/FiveM-Scripts/Cops_FiveM/blob/master/police/client/client.lua

if(config.useCopWhitelist == true) then
	isCop = false
else
	isCop = true
end
local firstSpawn = true
local isInService = false
local policeHeli = nil
local handCuffed = false
local isAlreadyDead = false
local allServiceCops = {}
local blipsCops = {}
local drag = false
local officerDrag = -1

rank = -1


anyMenuOpen = {
	menuName = "",
	isActive = false
}

SpawnedSpikes = {}
isCop = true
rank = 0
dept = 1
load_armory()
load_garage()


AddEventHandler("player:spawned", function()
	if config.useCopWhitelist then
		TriggerServerEvent("lspd:checkIsCop")
	else
		isCop = true
		TriggerServerEvent("lspd:checkIsCop")
		load_armory()
		load_garage()
	end

	if firstSpawn then
		TriggerServerEvent("lspd:GetPayChecks")
		firstSpawn = false
	end
end)


RegisterNetEvent('lspd:receiveIsCop')
AddEventHandler('lspd:receiveIsCop', function(svrank, svdept)
	if(svrank == -1) then
		if(config.useCopWhitelist == true) then
			isCop = false
		else
			isCop = true
			rank = 0
			dept = 1

			load_armory()
			load_garage()
		end
	else
		isCop = true
		rank = 25
		dept = svdept
		if(isInService) then --and config.enableOutfits
			if(GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01")) then
				SetPedComponentVariation(PlayerPedId(), 10, 8, config.rank.outfit_badge[rank], 2)
			else
				SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
			end
		end

		load_armory()
		load_garage()
	end
end)

if(config.useCopWhitelist == true) then
	RegisterNetEvent('lspd:nowCop')
	AddEventHandler('lspd:nowCop', function()
		isCop = true
	end)
end

RegisterNetEvent('lspd:Update')
AddEventHandler('lspd:Update', function(boolState)
	local data = GetResourceMetadata(GetCurrentResourceName(), 'resource_fname', 0)

	if boolState then
		DisplayNotificationLabel("FMMC_ENDVERC1", "~y~" .. data .. "~s~")
	end
end)

if(config.useCopWhitelist == true) then
	RegisterNetEvent('lspd:noLongerCop')
	AddEventHandler('lspd:noLongerCop', function()
		if(config.useCopWhitelist == true) then
			isCop = false
		end

		isInService = false

		if(config.enableOutfits == true) then
			RemoveAllPedWeapons(PlayerPedId())
			TriggerServerEvent("skin_customization:SpawnPlayer")
		else
			local model = GetHashKey("a_m_y_mexthug_01")

			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
		 
			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)
			RemoveAllPedWeapons(PlayerPedId())
		end
		
		if(policeHeli ~= nil) then
			SetEntityAsMissionEntity(policeHeli, true, true)
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(policeHeli))
			policeHeli = nil
		end

		ServiceOff()
	end)
end


RegisterNetEvent('lspd:getArrested')
AddEventHandler('lspd:getArrested', function()
	handCuffed = not handCuffed
	if(handCuffed) then
		TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1,"title_notification", false, "now_cuffed")
	else
		TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "title_notification", false, "now_uncuffed")
		cuffing = false
		drag = false
		ClearPedTasksImmediately(PlayerPedId())
	end
end)

--Inspired from emergency for request system (by Jyben : https://forum.fivem.net/t/release-job-save-people-be-a-hero-paramedic-emergency-coma-ko/19773)
local lockAskingFine = false
RegisterNetEvent('lspd:payFines')
AddEventHandler('lspd:payFines', function(amount, sender)
	Citizen.CreateThread(function()
		
		if(lockAskingFine ~= true) then
			lockAskingFine = true
			local notifReceivedAt = GetGameTimer()
			Notification("info_fine_request_before_amount"..amount.."info_fine_request_after_amount")
			while(true) do
				Wait(0)
				
				if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) then
					TriggerServerEvent('lspd:finesETA', sender, 2)
					Notification("request_fine_expired")
					lockAskingFine = false
					break
				end
				
				if IsControlPressed(1, config.bindings.accept_fine) then
					TriggerServerEvent('lspd:withdraw', amount)
					Notification("pay_fine_success_before_amount"..amount.."pay_fine_success_after_amount")
					TriggerServerEvent('lspd:finesETA', sender, 0)
					lockAskingFine = false
					break
				end
				
				if IsControlPressed(1, config.bindings.refuse_fine) then
					TriggerServerEvent('lspd:finesETA', sender, 3)
					lockAskingFine = false
					break
				end
			end
		else
			TriggerServerEvent('lspd:finesETA', sender, 1)
		end
	end)
end)

RegisterNetEvent("lspd:notify")
AddEventHandler("lspd:notify", function(icon, type, sender, title, text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	SetNotificationMessage(icon, icon, true, type, sender, title, text)
	DrawNotification(false, true)
end)

--Piece of code given by Thefoxeur54
RegisterNetEvent('lspd:unseatme')
AddEventHandler('lspd:unseatme', function(t)
	local ped = GetPlayerPed(t)        
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(PlayerPedId(),  true)
	local xnew = plyPos.x+2
	local ynew = plyPos.y+2
   
	SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)


RegisterNetEvent('lspd:toggleDrag')
AddEventHandler('lspd:toggleDrag', function(t)
	if(handCuffed) then
		drag = not drag
		officerDrag = t
	end
end)
RegisterNetEvent('lspd:forcedEnteringVeh')
AddEventHandler('lspd:forcedEnteringVeh', function(veh)
	if(handCuffed) then
		local pos = GetEntityCoords(PlayerPedId())
		local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)

		if vehicleHandle ~= nil then
			if(IsVehicleSeatFree(vehicleHandle, 1)) then
				SetPedIntoVehicle(PlayerPedId(), vehicleHandle, 1)
			else 
				if(IsVehicleSeatFree(vehicleHandle, 2)) then
					SetPedIntoVehicle(PlayerPedId(), vehicleHandle, 2)
				end
			end
		end
	end
end)

RegisterNetEvent('lspd:removeWeapons')
AddEventHandler('lspd:removeWeapons', function()
    RemoveAllPedWeapons(PlayerPedId(), true)
end)

if(config.enableOtherCopsBlips == true) then
	RegisterNetEvent('lspd:resultAllCopsInService')
	AddEventHandler('lspd:resultAllCopsInService', function(array)
		allServiceCops = array
		enableCopBlips()
	end)
end

function Notification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DisplayNotificationLabel(label, sublabel)
    SetNotificationTextEntry(label)
    if sublabel then
        AddTextComponentSubstringPlayerName(sublabel)
    end

    DrawNotification(true, true)
end

--From Player Blips and Above Head Display (by Scammer : https://forum.fivem.net/t/release-scammers-script-collection-09-03-17/3313)
function enableCopBlips()
	for k, existingBlip in pairs(blipsCops) do
        RemoveBlip(existingBlip)
    end
	blipsCops = {}
	
	local localIdCops = {}
	for id = 0, 64 do
		if(NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId()) then
			for i,c in pairs(allServiceCops) do
				if(i == GetPlayerServerId(id)) then
					localIdCops[id] = c
					break
				end
			end
		end
	end
	
	for id, c in pairs(localIdCops) do
		local ped = GetPlayerPed(id)
		local blip = GetBlipFromEntity(ped)
		
		if not DoesBlipExist(blip) then
			blip = AddBlipForEntity(ped)
			SetBlipSprite(blip, 1)
			Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true)
			HideNumberOnBlip( blip)
			SetBlipNameToPlayerName(blip, id)
			
			SetBlipScale(blip,  0.85)
			SetBlipAlpha(blip, 255)
			
			table.insert(blipsCops, blip)
		else			
			blipSprite = GetBlipSprite(blip)
			
			HideNumberOnBlip(blip)
			if blipSprite ~= 1 then
				SetBlipSprite(blip, 1)
				Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
			end
			
			SetBlipNameToPlayerName(blip, id)
			SetBlipScale(blip, 0.85)
			SetBlipAlpha(blip, 255)
			
			table.insert(blipsCops, blip)
		end
	end
end

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function isNearTakeService()
	local distance = 10000
	local pos = {}
	for i = 1, #clockInStation do
		local coords = GetEntityCoords(PlayerPedId(), 0)
		local currentDistance = Vdist(clockInStation[i].x, clockInStation[i].y, clockInStation[i].z, coords.x, coords.y, coords.z)
		if(currentDistance < distance) then
			distance = currentDistance
			pos = clockInStation[i]
		end
	end
	
	if anyMenuOpen.menuName == "cloackroom" and anyMenuOpen.isActive and distance > 3 then
		CloseMenu()
	end

	if(distance < 30) then
		if anyMenuOpen.menuName ~= "cloackroom" and not anyMenuOpen.isActive then
			DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
	end

	if(distance < 2) then
		return true
	end
end

function isNearStationGarage()
	local distance = 10000
	local pos = {}
	for i = 1, #garageStation do
		local coords = GetEntityCoords(PlayerPedId(), 0)
		local currentDistance = Vdist(garageStation[i].x, garageStation[i].y, garageStation[i].z, coords.x, coords.y, coords.z)
		if(currentDistance < distance) then
			distance = currentDistance
			pos = garageStation[i]
		end
	end
	
	if anyMenuOpen.menuName == "garage" and anyMenuOpen.isActive and distance > 5 then
		CloseMenu()
	end

	if(distance < 30) then
		if anyMenuOpen.menuName ~= "garage" and not anyMenuOpen.isActive then
			DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
	end

	if(distance < 2) then
		return true
	end
end

function isNearHelicopterStation()
	local distance = 10000
	local pos = {}
	for i = 1, #heliStation do
		local coords = GetEntityCoords(PlayerPedId(), 0)
		local currentDistance = Vdist(heliStation[i].x, heliStation[i].y, heliStation[i].z, coords.x, coords.y, coords.z)
		if(currentDistance < distance) then
			distance = currentDistance
			pos = heliStation[i]
		end
	end
	
	if(distance < 30) then
		DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 2.5, 2.5, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
	end
	if(distance < 2) then
		return true
	end
end

function isNearArmory()
	local distance = 10000
	local pos = {}
	for i = 1, #armoryStation do
		local coords = GetEntityCoords(PlayerPedId(), 0)
		local currentDistance = Vdist(armoryStation[i].x, armoryStation[i].y, armoryStation[i].z, coords.x, coords.y, coords.z)
		if(currentDistance < distance) then
			distance = currentDistance
			pos = armoryStation[i]
		end
	end
	
	if (anyMenuOpen.menuName == "armory" or anyMenuOpen.menuName == "armory-weapon_list") and anyMenuOpen.isActive and distance > 2 then
		CloseMenu()
	end
	if(distance < 30) then
		DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
	end
	if(distance < 2) then
		return true
	end
end

function ServiceOn()
	isInService = true
	TriggerServerEvent("lspd:takeService")
end

function ServiceOff()
	isInService = false
	TriggerServerEvent("lspd:breakService")
	
	if config.enableOtherCopsBlips == true then
		allServiceCops = {}
		
		for k, existingBlip in pairs(blipsCops) do
			RemoveBlip(existingBlip)
		end
		blipsCops = {}
	end
end

function DisplayHelpText(str)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function CloseMenu()
	SendNUIMessage({
		action = "close"
	})
	
	anyMenuOpen.menuName = ""
	anyMenuOpen.isActive = false
end

RegisterNUICallback('sendAction', function(data, cb)
	_G[data.action](data.params)
    cb('ok')
end)

--
--Threads
--

local alreadyDead = false
local playerStillDragged = false

Citizen.CreateThread(function()
	DoScreenFadeIn(100)
	local gxt = "fmmc"
	local CurrentSlot = 0

	while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(gxt, CurrentSlot) do
		Wait(1)
		CurrentSlot = CurrentSlot + 1
	end

	if not HasThisAdditionalTextLoaded(gxt, CurrentSlot) then
		ClearAdditionalText(CurrentSlot, true)
		RequestAdditionalText(gxt, CurrentSlot)
		while not HasThisAdditionalTextLoaded(gxt, CurrentSlot) do
			Wait(0)
		end
	end

	RequestAnimDict('mp_arresting')
	while not HasAnimDictLoaded('mp_arresting') do
		Citizen.Wait(50)
	end	

	if not IsIplActive("FIBlobby") then
		RequestIpl("FIBlobbyfake")
	end

	TriggerServerEvent("lspd:checkIsCop")

	if config.enableNeverWanted then
		SetMaxWantedLevel(0)
		SetWantedLevelMultiplier(0.0)
	else
		SetMaxWantedLevel(5)
		SetWantedLevelMultiplier(1.0)
	end
	if config.stationBlipsEnabled then
		for _, item in pairs(clockInStation) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, 60)
			SetBlipScale(item.blip, 0.8)
			SetBlipAsShortRange(item.blip, true)
		end
	end
   
    while true do
        Citizen.Wait(5)	
		DisablePlayerVehicleRewards(PlayerId())	

		if(anyMenuOpen.isActive) then
			DisableControlAction(1, 21)
			DisableControlAction(1, 140)
			DisableControlAction(1, 141)
			DisableControlAction(1, 142)

			SetDisableAmbientMeleeMove(PlayerPedId(), true)

			if (IsControlJustPressed(1,172)) then
				SendNUIMessage({
					action = "keyup"
				})
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (IsControlJustPressed(1,173)) then
				SendNUIMessage({
					action = "keydown"
				})
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (anyMenuOpen.menuName == "cloackroom") then
				if IsControlJustPressed(1, 176) then
					SendNUIMessage({
						action = "keyenter"
					})

					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					Citizen.Wait(500)
					CloseMenu()
				end
			elseif (IsControlJustPressed(1,176)) then
				SendNUIMessage({
					action = "keyenter"
				})
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (IsControlJustPressed(1,177)) then
				if(anyMenuOpen.menuName == "policemenu" or anyMenuOpen.menuName == "cloackroom" or anyMenuOpen.menuName == "garage") then
					CloseMenu()
				elseif(anyMenuOpen.menuName == "armory") then
					CloseArmory()					
				elseif(anyMenuOpen.menuName == "armory-weapon_list") then
					BackArmory()
				else
					BackMenuPolice()
				end
			end
		else
			EnableControlAction(1, 21)
			EnableControlAction(1, 140)
			EnableControlAction(1, 141)
			EnableControlAction(1, 142)
		end
	
		--Control death events
		if(config.useModifiedEmergency == false) then
			if(IsPlayerDead(PlayerId())) then
				if(alreadyDead == false) then
					if(isInService) then
						ServiceOff()
					end

					handCuffed = false
					drag = false
					alreadyDead = true
				end
			else
				alreadyDead = false
			end
		end
		
		if (handCuffed == true) then
			local myPed = PlayerPedId()
			local animation = 'idle'
			local flags = 50				
			
			while IsPedBeingStunned(myPed, 0) do
				ClearPedTasksImmediately(myPed)
			end

			DisableControlAction(1, 12, true)
			DisableControlAction(1, 13, true)
			DisableControlAction(1, 14, true)

			DisableControlAction(1, 23, true)
			DisableControlAction(1, 24, true)

			DisableControlAction(1, 15, true)
			DisableControlAction(1, 16, true)
			DisableControlAction(1, 17, true)

			if not cuffing then
				SetCurrentPedWeapon(myPed, GetHashKey("WEAPON_UNARMED"), true)
				RemoveAllPedWeapons(myPed, true)
				cuffing = true
			end

			if not IsEntityPlayingAnim(myPed, "mp_arresting", animation, 3) then
				TaskPlayAnim(myPed, "mp_arresting", animation, 8.0, -8.0, -1, flags, 0, 0, 0, 0 )
			end
		else
			EnableControlAction(1, 12, false)
			EnableControlAction(1, 13, false)
			EnableControlAction(1, 14, false)

			EnableControlAction(1, 23, false)
			EnableControlAction(1, 24, false)

			EnableControlAction(1, 15, false)
			EnableControlAction(1, 16, false)
			EnableControlAction(1, 17, false)

			if IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) then
				StopAnimTask(PlayerPedId(), "mp_arresting", animation, 3)
				ClearPedTasksImmediately(PlayerPedId())
			end

			cuffing = false		
		end
		
		--Piece of code from Drag command (by Frazzle, Valk, Michael_Sanelli, NYKILLA1127 : https://forum.fivem.net/t/release-drag-command/22174)
		if drag then
			local ped = GetPlayerPed(GetPlayerFromServerId(officerDrag))
			local myped = PlayerPedId()
			AttachEntityToEntity(myped, ped, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			playerStillDragged = true
		else
			if(playerStillDragged) then
				DetachEntity(PlayerPedId(), true, false)
				playerStillDragged = false
			end
		end

		if config.enableNeverWanted then
			if IsPlayerWantedLevelGreater(PlayerId(), 0) then
				ClearPlayerWantedLevel(PlayerId())
			end
		end
	
        if(isCop) then
			if(isNearTakeService()) then
				if not (anyMenuOpen.isActive) then
				    DisplayHelpText("Vestiaire".. GetLabelText("collision_8vlv02g"),0,1,0.5,0.8,0.6,255,255,255,255)
				    if IsControlJustPressed(1,config.bindings.interact_position) then
				    	load_cloackroom()
				    	OpenCloackroom()
				    end
				end
			end
			
			if(isInService) then			
				if(isNearStationGarage()) then
					if(policevehicle ~= nil) then
						if not (anyMenuOpen.isActive) then
							DisplayHelpText("help_text_put_car_into_garage",0,1,0.5,0.8,0.6,255,255,255,255)
						end
					else
						DisplayHelpText("help_text_get_car_out_garage",0,1,0.5,0.8,0.6,255,255,255,255)
					end
					
					if IsControlJustPressed(1,config.bindings.interact_position) then
						if(policevehicle ~= nil) then
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(policevehicle))
							policevehicle = nil
						else
							OpenGarage()
						end
					end
				end
				
				--Open Armory menu
				if(isNearArmory()) then
					if not (anyMenuOpen.isActive) then					
						DisplayHelpText("help_text_open_armory",0,1,0.5,0.8,0.6,255,255,255,255)

						if IsControlJustPressed(1,config.bindings.interact_position) then
							Lx, Ly, Lz = table.unpack(GetEntityCoords(PlayerPedId(), true))
							DoScreenFadeOut(500)
							Wait(600)

							SetEntityCoords(PlayerPedId(), 452.119966796875, -980.061966796875, 30.690966796875)
							Wait(800)
							armoryPed = createArmoryPed()

							if not DoesCamExist(ArmoryRoomCam) then
								ArmoryRoomCam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
								AttachCamToEntity(ArmoryRoomCam, PlayerPedId(), 0.0, 0.0, 1.0, true)
								PointCamAtEntity(ArmoryRoomCam, armoryPed, 0.0, -30.0, 1.0, true)

								SetCamRot(ArmoryRoomCam, 0.0,0.0, GetEntityHeading(PlayerPedId()))
								SetCamFov(ArmoryRoomCam, 70.0)							
							end

							Wait(100)
							DoScreenFadeIn(500)

							if DoesEntityExist(armoryPed) then
								TaskTurnPedToFaceEntity(PlayerPedId(), armoryPed, -1)
							end							

							Wait(300)
							OpenArmory()
							if not IsAmbientSpeechPlaying(armoryPed) then
								PlayAmbientSpeechWithVoice(armoryPed, "WEPSEXPERT_GREETSHOPGEN", "WEPSEXP", "SPEECH_PARAMS_FORCE", 0)
							end
						end
					end
				end

				if (anyMenuOpen.menuName == "armory") then			
					if DoesCamExist(ArmoryRoomCam) then
						RenderScriptCams(true, 1, 1800, 1, 0)
					end		
				end

				if (IsControlJustPressed(1,config.bindings.use_police_menu)) then
					load_menu()
					TogglePoliceMenu()
				end
				
				if isNearHelicopterStation() then
					if(policeHeli ~= nil) then
						DisplayHelpText("help_text_put_heli_into_garage",0,1,0.5,0.8,0.6,255,255,255,255)
					else
						DisplayHelpText("help_text_get_heli_out_garage",0,1,0.5,0.8,0.6,255,255,255,255)
					end
					
					if IsControlJustPressed(1,config.bindings.interact_position)  then
						if(policeHeli ~= nil) then
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(policeHeli))
							policeHeli = nil
						else
							local heli = GetHashKey("polmav")
							local ply = PlayerPedId()
							local plyCoords = GetEntityCoords(ply, 0)
							
							RequestModel(heli)
							while not HasModelLoaded(heli) do
								Citizen.Wait(0)
							end
							
							policeHeli = CreateVehicle(heli, plyCoords["x"], plyCoords["y"], plyCoords["z"], 90.0, true, false)
							SetVehicleHasBeenOwnedByPlayer(policevehicle,true)

							local netid = NetworkGetNetworkIdFromEntity(policeHeli)
							SetNetworkIdCanMigrate(netid, true)
							NetworkRegisterEntityAsNetworked(VehToNet(policeHeli))
							
							SetVehicleLivery(policeHeli, 0)
							TaskWarpPedIntoVehicle(ply, policeHeli, -1)
							SetEntityAsMissionEntity(policeHeli, true, true)
						end
					end
				end
			end
		end
    end
end)


Citizen.CreateThread(function()
	while true do
		isInService = true
		if drag then
			local ped = GetPlayerPed(GetPlayerFromServerId(playerPedDragged))
			plyPos = GetEntityCoords(ped, true)
			SetEntityCoords(ped, plyPos.x, plyPos.y, plyPos.z)
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
			x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))

			if DoesObjectOfTypeExistAtCoords(x, y, z, 0.9, GetHashKey("P_ld_stinger_s"), true) then
				for i= 0, 7 do
					SetVehicleTyreBurst(currentVeh, i, true, 1148846080)
				end

				Citizen.Wait(100)
				DeleteSpike()
			end
		end
	end
end)
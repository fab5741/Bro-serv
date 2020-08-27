local config = {
    hospitals = {	
		CentralLosSantos = {

            Blip = {
                coords = vector3(340.73, -584.6, 28.79),
                sprite = 61,
                scale  = 1.2,
                color  = 8
            },

            AmbulanceActions = {
            },

            Pharmacies = {
			},
			
			lockers = {
				coords = vector3(336.25, -579.45, 27.6),
				blip = {
					coords = vector3(336.25, -579.45, 27.6),
					sprite = 2,
					scale  = 0.5,
					color  = 2
				},
			},

            Vehicles = {

            },

            Helicopters = {

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
		ambulance = {
			{model = 'ambulance', price = 5000}
		},

		doctor = {
			{model = 'ambulance', price = 4500}
		},

		chief_doctor = {
			{model = 'ambulance', price = 3000}
		},

		boss = {
			{model = 'ambulance', price = 2000}
		}
	},

	helicopter = {
		ambulance = {},

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

RegisterNetEvent("ambulance:revive")


-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(config.hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Hopital')
		EndTextCommandSetBlipName(blip)

		local blip = AddBlipForCoord(v.lockers.blip.coords)
		SetBlipSprite(blip, v.lockers.blip.sprite)
		SetBlipScale(blip, v.lockers.blip.scale)
		SetBlipColour(blip, v.lockers.blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Hopital')
		EndTextCommandSetBlipName(blip)
	end

end)

-- local values
local isDead = false

function StartDeathTimer()
	local canPayFine = false

	local bleedoutTimer = config.BleedoutTimer / 1000

	Citizen.CreateThread(function()
		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
        local text, timeHeld
        
		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(0)
			text = 'Respawn dans : ' .. bleedoutTimer

            text = text .. "s"

            if IsControlPressed(0, 38) and timeHeld > 60 then
                RemoveItemsAfterRPDeath()
                break
            end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
            end
            
			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
	end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

    print("Appel envoyé")
	--ESX.ShowNotification(_U('distress_sent'))
	TriggerServerEvent('ambulance:distress', playerPed)
end


function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = config.BleedoutTimer

		while timer > 0 and isDead do
			Citizen.Wait(0)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName('G pour appeler')
			EndTextCommandDisplayText(0.175, 0.805)

			if IsControlJustReleased(0, 47) then
				SendDistressSignal()
				break
			end
		end
	end)
end

AddEventHandler('player:dead', function(data)
    if(not isDead) then
        isDead = true
        --TriggerServerEvent('ambulance:setDeathStatus', true)

        StartDeathTimer()
        StartDistressSignal()

        StartScreenEffect('DeathFailOut', 0, false)
    end
end)

AddEventHandler('ambulance:revive', function(noAmbulancies)
    isDead=false
    if(noAmbulancies) then 
        Citizen.CreateThread(function()
            local timer = 5000
    
            while timer > 0 do
                Citizen.Wait(0)
                timer = timer - 30
    
                SetTextFont(4)
                SetTextScale(0.45, 0.45)
                SetTextColour(185, 185, 185, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                BeginTextCommandDisplayText('STRING')
                AddTextComponentSubstringPlayerName('Respawn instantanée pas d\'ambulanciers')
                EndTextCommandDisplayText(0.175, 0.805)
    
                if IsControlJustReleased(0, 47) then
                    SendDistressSignal()
                    break
                end
            end
        end)
    end
    isDead=false
    DoScreenFadeOut(800)
	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end
    local ped = GetPlayerPed(-1)
    if(noAmbulancies) then 
        --TODO resurect at hospital
        NetworkResurrectLocalPlayer(GetEntityCoords(ped), true, true, false)
    else
        NetworkResurrectLocalPlayer(GetEntityCoords(ped), true, true, false)
    end
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
    StopScreenEffect('DeathFailOut')
    DoScreenFadeIn(800)
end)

-- ESX job part
function OpenAmbulanceActionsMenu()

end

function FastTravel(coords, heading)
	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(500)
	end

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(playerPed, coords.x, coords.y, height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(coords.x, coords.y, height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(playerPed, coords.x, coords.y, height + 0.0)

                break
            end

            Citizen.Wait(5)
        end
		DoScreenFadeIn(800)

		if heading then
			SetEntityHeading(playerPed, heading)
		end
end

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        -- TODO if job is ambulance
        if true then
            DrawMarker(0, 117.14, -1950.29, 20,7513, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.75, 0.75, 0.75, 204, 204, 0, 100, false, true, 2, false, false, false, false)

			local playerCoords = GetEntityCoords(PlayerPedId())
			local letSleep, isInMarker, hasExited = true, false, false
			local currentHospital, currentPart, currentPartNum

            for hospitalNum,hospital in pairs(config.hospitals) do
				-- Ambulance Actions
				for k,v in ipairs(hospital.AmbulanceActions) do
					local distance = #(playerCoords - v)

					if distance < config.DrawDistance then
						DrawMarker(config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceActions', k
						end
					end
				end

				-- Ambulances lockers
				local distance = #(playerCoords - hospital.lockers.coords)

				if distance < config.DrawDistance then
					DrawMarker(config.Marker.type, hospital.lockers.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
					letSleep = false
					if distance < config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'lockers', 1
					end
				end

				-- Pharmacies
				for k,v in ipairs(hospital.Pharmacies) do
					local distance = #(playerCoords - v.coords)

					if true then
						DrawMarker(config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k
						end
					end
				end

				-- Vehicle Spawners
				for k,v in ipairs(hospital.Vehicles) do
					local distance = #(playerCoords - v.Spawner)

					if distance < config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k
						end
					end
				end

				-- Helicopter Spawners
				for k,v in ipairs(hospital.Helicopters) do
					local distance = #(playerCoords - v.Spawner)

					if distance < config.DrawDistance then
						DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', k
						end
					end
				end

				-- Fast Travels (Prompt)
				for k,v in ipairs(hospital.FastTravelsPrompt) do
					local distance = #(playerCoords - v.From)

					if distance < config.DrawDistance then
						DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < v.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'FastTravelsPrompt', k
						end
					end
				end
			end

			-- Logic for exiting & entering markers
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('ambulance:hasExitedMarker', LastHospital, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

				TriggerEvent('ambulance:hasEnteredMarker', currentHospital, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('ambulance:hasExitedMarker', LastHospital, LastPart, LastPartNum)
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

		for hospitalNum,hospital in pairs(config.hospitals) do
			-- Fast Travels
			for k,v in ipairs(hospital.FastTravels) do
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

AddEventHandler('ambulance:hasEnteredMarker', function(hospital, part, partNum)
	if part == 'AmbulanceActions' then
		CurrentAction = part
		CurrentActionMsg = _U('actions_prompt')
		CurrentActionData = {}
	elseif part == 'Pharmacy' then
		CurrentAction = part
		CurrentActionMsg = _U('open_pharmacy')
		CurrentActionData = {}
	elseif part == 'Vehicles' then
		CurrentAction = part
		CurrentActionMsg = _U('garage_prompt')
		CurrentActionData = {hospital = hospital, partNum = partNum}
	elseif part == 'Helicopters' then
		CurrentAction = part
		CurrentActionMsg = _U('helicopter_prompt')
		CurrentActionData = {hospital = hospital, partNum = partNum}
	elseif part == 'FastTravelsPrompt' then
		local travelItem = config.hospitals[hospital][part][partNum]

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
					{tshirt_2=0,hair_color_1=5,glasses_2=3,shoes=9,torso_2=3,hair_color_2=0,pants_1=24,glasses_1=4,hair_1=2,sex=0,decals_2=0,tshirt_1=15,helmet_1=8,helmet_2=0,arms=92,face=19,decals_1=60,torso_1=13,hair_2=0,skin=34,pants_2=5})
				else
					TriggerEvent('skinchanger:loadClothes', 
					{tshirt_2=3,decals_2=0,glasses=0,hair_1=2,torso_1=73,shoes=1,hair_color_2=0,glasses_1=19,skin=13,face=6,pants_2=5,tshirt_1=75,pants_1=37,helmet_1=57,torso_2=0,arms=14,sex=1,glasses_2=0,decals_1=0,hair_2=0,helmet_2=0,hair_color_1=0})
				end
				skinChanged = true
				onDuty = true
			end
		end)
	end	
end)

AddEventHandler('ambulance:hasExitedMarker', function(hospital, part, partNum)
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
				if CurrentAction == 'AmbulanceActions' then
					OpenAmbulanceActionsMenu()
				elseif CurrentAction == 'Pharmacy' then
					OpenPharmacyMenu()
                elseif CurrentAction == 'Vehicles' then
                        -- account for the argument not being passed
    local vehicleName = 'adder'

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
	
		OpenVehicleSpawnerMenu('car', CurrentActionData.hospital, CurrentAction, CurrentActionData.partNum)
	elseif CurrentAction == 'Helicopters' then
		OpenVehicleSpawnerMenu('helicopter', CurrentActionData.hospital, CurrentAction, CurrentActionData.partNum)
	elseif CurrentAction == 'FastTravelsPrompt' then
		FastTravel(CurrentActionData.to, CurrentActionData.heading)
	end

	CurrentAction = nil
end

        -- TODO test if ambulance
		elseif true and not isDead then
			if IsControlJustReleased(0, 167) then
				OpenMobileAmbulanceActionsMenu()
			end
		else
			Citizen.Wait(500)
		end
	end
end)


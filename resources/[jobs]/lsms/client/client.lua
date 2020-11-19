local config = {
    hospitals = {	
		CentralLosSantos = {

            Blip = {
                coords = vector3(340.73, -584.6, 28.79),
                sprite = 61,
                scale  = 1.2,
                color  = 8
            },

            lsmsActions = {
            },

            Pharmacies = {
			},
			
			lockers = {
				coords = vector3(336.25, -579.45, 27.6),
				blip = {
					coords = vector3(336.25, -579.45, 27.6),
					sprite = 73,
					scale  = 0.5,
					color  = 2
				},
			},

            Vehicles = {
				coords = vector3(341.25, -562.98,28.24)
            },

            Helicopters = {
				coords = vector3(55.25, -562.98,28.74)
            },
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
		lsms = {
			{model = 'lsms', price = 5000}
		},

		doctor = {
			{model = 'lsms', price = 4500}
		},

		chief_doctor = {
			{model = 'lsms', price = 3000}
		},

		boss = {
			{model = 'lsms', price = 2000}
		}
	},

	helicopter = {
		lsms = {},

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


anyMenuOpen = {
	menuName = "",
	isActive = false
}


local onDuty
local myJob = {
	"Chomeur",
	"Chomeur"
}

RegisterNUICallback('sendAction', function(data, cb)
	_G[data.action](data.params)
    cb('ok')
end)
-- GET THE JOB
RegisterNetEvent('lsms:job')

AddEventHandler("lsms:job", function(job)
	myJob = job[1]
end)

Citizen.CreateThread(function()
	TriggerServerEvent("job:get", "lsms:job")
end)


RegisterNetEvent("lsms:revive")


function CloseMenu()
	SendNUIMessage({
		action = "close"
	})
	
	anyMenuOpen.menuName = ""
	anyMenuOpen.isActive = false
end

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

		if myJob.job == "LSMS" then
			local blip = AddBlipForCoord(v.lockers.blip.coords)
			SetBlipSprite(blip, v.lockers.blip.sprite)
			SetBlipScale(blip, v.lockers.blip.scale)
			SetBlipColour(blip, v.lockers.blip.color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName('Hopital')
			EndTextCommandSetBlipName(blip)
		end
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
	TriggerServerEvent('lsms:distress', playerPed)
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
        --TriggerServerEvent('lsms:setDeathStatus', true)

        StartDeathTimer()
        StartDistressSignal()

        StartScreenEffect('DeathFailOut', 0, false)
    end
end)

AddEventHandler('lsms:revive', function()
    isDead=false
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
    isDead=false
    DoScreenFadeOut(800)
	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end
    local ped = GetPlayerPed(-1)
	NetworkResurrectLocalPlayer(GetEntityCoords(ped), true, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
    StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
	
	
	TriggerServerEvent("player:spawned")
	TriggerServerEvent("needs:spawned")
end)

-- ESX job part
function OpenlsmsActionsMenu()

end

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        -- TODO if job is lsms
		if myJob ~= nil and myJob.job == "LSMS" then

			if (IsControlJustPressed(1,166)) then
				load_menu()
				ToggleLSMSMenu()
			end

            DrawMarker(0, 117.14, -1950.29, 20,7513, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.75, 0.75, 0.75, 204, 204, 0, 100, false, true, 2, false, false, false, false)

			local playerCoords = GetEntityCoords(PlayerPedId())
			local letSleep, isInMarker, hasExited = true, false, false
			local currentHospital, currentPart, currentPartNum

            for hospitalNum,hospital in pairs(config.hospitals) do
				-- lsms Actions
				for k,v in ipairs(hospital.lsmsActions) do
					local distance = #(playerCoords - v)

					if distance < config.DrawDistance then
						DrawMarker(config.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
						letSleep = false

						if distance < config.Marker.x then
							isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'lsmsActions', k
						end
					end
				end

				-- lsmss lockers
				local distance = #(playerCoords - hospital.lockers.coords)

				if distance < config.DrawDistance then
					DrawMarker(config.Marker.type, hospital.lockers.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
					letSleep = false
					if distance < config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'lockers', 1
					end
				end


				-- Vehicle Spawners
				local distance = #(playerCoords - hospital.Vehicles.coords)

				if distance < config.DrawDistance then
					DrawMarker(config.Marker.type, hospital.Vehicles.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
					letSleep = false
					if distance < config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', 1
					end
				end
				-- Helicopter Spawners
				local distance = #(playerCoords - hospital.Helicopters.coords)

				if distance < config.DrawDistance then
					DrawMarker(config.Marker.type, hospital.Helicopters.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
					letSleep = false
					if distance < config.Marker.x then
						isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', 1
					end
				end
			end
			-- Logic for exiting & entering markers
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('lsms:hasExitedMarker', LastHospital, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum
				TriggerEvent('lsms:hasEnteredMarker', currentHospital, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('lsms:hasExitedMarker', LastHospital, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

local skinChanged = false
local skin ={
	sex          = 0,
	face         = 0,
	skin         = 0,
	beard_1      = 0,
	beard_2      = 0,
	beard_3      = 0,
	beard_4      = 0,
	hair_1       = 0,
	hair_2       = 0,
	hair_color_1 = 0,
	hair_color_2 = 0,
	tshirt_1     = 0,
	tshirt_2     = 0,
	torso_1      = 0,
	torso_2      = 0,
	decals_1     = 0,
	decals_2     = 0,
	arms         = 0,
	pants_1      = 0,
	pants_2      = 0,
	shoes_1      = 0,
	shoes_2      = 0,
	mask_1       = 0,
	mask_2       = 0,
	bproof_1     = 0,
	bproof_2     = 0,
	chain_1      = 0,
	chain_2      = 0,
	helmet_1     = 0,
	helmet_2     = 0,
	glasses_1    = 0,
	glasses_2    = 0,
}

local clothes = {
recruit = {
	male = {
		tshirt_2=0,
		hair_color_1=5,
		glasses_2=3,
		shoes=9,
		torso_2=3,
		hair_color_2=0,
		pants_1=24,
		glasses_1=4,
		hair_1=2,
		sex=0,
		decals_2=0,
		tshirt_1=15,
		helmet_1=8,
		helmet_2=0,
		arms=92,
		face=19,
		decals_1=60,
		torso_1=13,
		hair_2=0,
		skin=34,
		pants_2=5
	},
	female = {
		tshirt_1 = 36,  tshirt_2 = 1,
		torso_1 = 48,   torso_2 = 0,
		decals_1 = 0,   decals_2 = 0,
		arms = 44,
		pants_1 = 34,   pants_2 = 0,
		shoes_1 = 27,   shoes_2 = 0,
		helmet_1 = 45,  helmet_2 = 0,
		chain_1 = 0,    chain_2 = 0,
		ears_1 = 2,     ears_2 = 0
	}
},
}

AddEventHandler('lsms:hasEnteredMarker', function(hospital, part, partNum)
	print(part)
	if part == 'lsmsActions' then
		CurrentAction = part
		CurrentActionMsg = _U('actions_prompt')
		CurrentActionData = {}
	elseif part == 'Pharmacy' then
		CurrentAction = part
		CurrentActionMsg = _U('open_pharmacy')
		CurrentActionData = {}
	elseif part == 'Vehicles' then
		print("vehicle")
		-- account for the argument not being passed
		local vehicleName = 'ambulance'
	
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
	elseif part == 'lockers' then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skinChanged then
				skin ={
					sex          = 0,
					face         = 0,
					skin         = 0,
					beard_1      = 0,
					beard_2      = 0,
					beard_3      = 0,
					beard_4      = 0,
					hair_1       = 0,
					hair_2       = 0,
					hair_color_1 = 0,
					hair_color_2 = 0,
					tshirt_1     = 0,
					tshirt_2     = 0,
					torso_1      = 0,
					torso_2      = 0,
					decals_1     = 0,
					decals_2     = 0,
					arms         = 0,
					pants_1      = 0,
					pants_2      = 0,
					shoes_1      = 0,
					shoes_2      = 0,
					mask_1       = 0,
					mask_2       = 0,
					bproof_1     = 0,
					bproof_2     = 0,
					chain_1      = 0,
					chain_2      = 0,
					helmet_1     = 0,
					helmet_2     = 0,
					glasses_1    = 0,
					glasses_2    = 0,
				}
			
				local clothes = {
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothes)
				skinChanged =false
				onDuty = false
				TriggerServerEvent('lsms:onDuty', false)
			else
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, clothes.recruit.male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, clothes.recruit.female)
				end
				skinChanged = true
				onDuty = true
				TriggerServerEvent('lsms:onDuty', true)
			end
		end)
	end	
end)

AddEventHandler('lsms:hasExitedMarker', function(hospital, part, partNum)
    -- close menu

	CurrentAction = nil
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if myJob ~= nil and myJob.job == "LSMS" then

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
				elseif (IsControlJustPressed(1,176)) then
					print("enter")
					SendNUIMessage({
						action = "keyenter"
					})
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
				elseif (IsControlJustPressed(1,177)) then
					if(anyMenuOpen.menuName == "lsmsmenu" or anyMenuOpen.menuName == "cloackroom" or anyMenuOpen.menuName == "garage") then
						CloseMenu()
					elseif(anyMenuOpen.menuName == "armory") then
						CloseArmory()					
					elseif(anyMenuOpen.menuName == "armory-weapon_list") then
						BackArmory()
					else
						BackMenuLSMS()
					end
				end
			else
				EnableControlAction(1, 21)
				EnableControlAction(1, 140)
				EnableControlAction(1, 141)
				EnableControlAction(1, 142)
			end

						if CurrentAction then
							--ESX.ShowHelpNotification(CurrentActionMsg)

							if IsControlJustReleased(0, 38) then
								if CurrentAction == 'lsmsActions' then
									OpenlsmsActionsMenu()
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
					end

					CurrentAction = nil
				end
			end
			Citizen.Wait(500)
		end
	end
end)


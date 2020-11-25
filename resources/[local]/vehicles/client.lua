config = {
		deformationMultiplier = -1,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
		deformationExponent = 0.4,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
		collisionDamageExponent = 0.6,				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	
		damageFactorEngine = 5.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
		damageFactorBody = 5.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
		damageFactorPetrolTank = 64.0,				-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
		engineDamageExponent = 0.6,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
		weaponsDamageMultiplier = 0.01,				-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
		degradingHealthSpeedFactor = -1,			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
		cascadingFailureSpeedFactor = 8.0,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8
	
		degradingFailureThreshold = 800.0,			-- Below this value, slow health degradation will set in
		cascadingFailureThreshold = 360.0,			-- Below this value, health cascading failure will set in
		engineSafeGuard = 100.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.
	
		torqueMultiplierEnabled = true,				-- Decrease engine torque as engine gets more and more damaged
	
		limpMode = true,							-- If true, the engine never fails completely, so you will always be able to get to a mechanic unless you flip your vehicle and preventVehicleFlip is set to true
		limpModeMultiplier = 0.15,					-- The torque multiplier to use when vehicle is limping. Sane values are 0.05 to 0.25
	
		preventVehicleFlip = true,					-- If true, you can't turn over an upside down vehicle
	
		sundayDriver = true,						-- If true, the accelerator response is scaled to enable easy slow driving. Will not prevent full throttle. Does not work with binary accelerators like a keyboard. Set to false to disable. The included stop-without-reversing and brake-light-hold feature does also work for keyboards.
		sundayDriverAcceleratorCurve = 7.5,			-- The response curve to apply to the accelerator. Range 0.0 to 10.0. Higher values enables easier slow driving, meaning more pressure on the throttle is required to accelerate forward. Does nothing for keyboard drivers
		sundayDriverBrakeCurve = 5.0,				-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers
	
		displayBlips = true,						-- Show blips for mechanics locations
	
		compatibilityMode = false,					-- prevents other scripts from modifying the fuel tank health to avoid random engine failure with BVA 2.01 (Downside is it disabled explosion prevention)
	
		randomTireBurstInterval = 0,				-- Number of minutes (statistically, not precisely) to drive above 22 mph before you get a tire puncture. 0=feature is disabled
	
	
		-- Class Damagefactor Multiplier
		-- The damageFactor for engine, body and Petroltank will be multiplied by this value, depending on vehicle class
		-- Use it to increase or decrease damage for each class
	
		classDamageMultiplier = {
			[0] = 	1.0,		--	0: Compacts
					1.0,		--	1: Sedans
					1.0,		--	2: SUVs
					1.0,		--	3: Coupes
					1.0,		--	4: Muscle
					1.0,		--	5: Sports Classics
					1.0,		--	6: Sports
					1.0,		--	7: Super
					0.25,		--	8: Motorcycles
					0.7,		--	9: Off-road
					0.25,		--	10: Industrial
					1.0,		--	11: Utility
					1.0,		--	12: Vans
					1.0,		--	13: Cycles
					0.5,		--	14: Boats
					1.0,		--	15: Helicopters
					1.0,		--	16: Planes
					1.0,		--	17: Service
					0.75,		--	18: Emergency
					0.75,		--	19: Military
					1.0,		--	20: Commercial
					1.0			--	21: Trains
		}	
	-- End of Main Configuration
}
zoneType =0
zone = "global"
dsVehicle = 0
currentVehicle = 0


function DeleteGivenVehicle( veh, timeoutMax )
    local timeout = 0 

    SetEntityAsMissionEntity( veh, true, true )
    DeleteVehicle( veh )

    if ( DoesEntityExist( veh ) ) then
        Notify( "~r~Failed to delete vehicle, trying again..." )

        -- Fallback if the vehicle doesn't get deleted
        while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
            DeleteVehicle( veh )

            -- The vehicle has been banished from the face of the Earth!
            if ( not DoesEntityExist( veh ) ) then 
                Notify( "~g~Vehicle deleted." )
            end 

            -- Increase the timeout counter and make the system wait
            timeout = timeout + 1 
            Citizen.Wait( 500 )
        end 
    else 
        Notify( "~g~Vehicle deleted." )
    end 
end 

-- Create blips
Citizen.CreateThread(function()
	--shops
	exports.bf:AddMenu("shops", {
		title = "Concessionnaire",
		position = 1,
	})

	exports.bf:AddArea("shops", {
		marker = {
			type = 1,
			weight = 1,
			height = 1,
			red = 255,
			green = 255,
			blue = 153,
		},
		trigger = {
			weight = 2,
			enter = {
				callback = function()
					exports.bf:HelpPromt("Concessionnaire : ~INPUT_PICKUP~")
					zoneType = "shops"
					zone = "global"
				end
			},
			exit = {
				callback = function()
					zoneType = nil
					zone = nil
				end
			}
		},
		blip = {
			text = "Concessionnaire",
			colorId = 1,
			imageId = 326,
		},
		locations = {
			{
				x =-43.67,
				y=-1109.33,
				z=26.0
			}
		},
	})

	--- shop for job

	exports.bf:AddMenu("shops-job", {
		title = "Concessionnaire",
		position = 1,
	})

	exports.bf:AddArea("shops-job", {
		marker = {
			type = 1,
			weight = 1,
			height = 1,
			red = 255,
			green = 255,
			blue = 153,
		},
		trigger = {
			weight = 2,
			enter = {
				callback = function()
					exports.bf:HelpPromt("Concessionnaire entreprise : ~INPUT_PICKUP~")
					zoneType = "shops-job"
					zone = "global"
				end
			},
			exit = {
				callback = function()
					zoneType = nil
					zone = nil
				end
			}
		},
		blip = {
			text = "Concessionnaire entreprise",
			colorId = 1,
			imageId = 326,
		},
		locations = {
			{
				x =375.50732421875,
				y=-1612.0445556641,
				z=29.291933059692
			}
		},
	})
	-- parkings
	exports.bf:AddMenu("parking-veh", {
		title = "Parking",
		position = 1,
	})
	exports.bf:AddMenu("parking-foot", {
		title = "Parking",
		menuTitle = "Retirer",
		position = 1,
	})
	exports.bf:AddArea("parkings", {
		marker = {
			type = 1,
			weight = 1,
			height = 1,
			red = 255,
			green = 255,
			blue = 153,
		},
		trigger = {
			weight = 2,
			enter = {
				callback = function()
					exports.bf:HelpPromt("Parking : ~INPUT_PICKUP~")
					zoneType = "parking"
					zone = "global"
				end
			},
			exit = {
				callback = function()
					zoneType = nil
					zone = nil
				end
			}
		},
		blip = {
			text = "Parking",
			colorId = 2,
			imageId = 357,
		},
		locations = {
			{
				x =234.68,
				y=-782.73,
				z=29.9
			},
			{
				x =316.07934570312,
				y=-540.31567382812,
				z=28.743453979492
			}
		},
	})

	--depots
	exports.bf:AddMenu("depots", {
		title = "Fourrière",
		position = 1,
	})
	exports.bf:AddArea("depots", {
		marker = {
			type = 1,
			weight = 1,
			height = 1,
			red = 255,
			green = 255,
			blue = 153,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					TriggerServerEvent("vehicle:permis:get", "vehicle:permis:get:depot")
				end
			},
			exit = {
				callback = function()
					zoneType = nil
					zone = nil
				end
			}
		},
		blip = {
			text = "Fourrière",
			colorId = 2,
			imageId = 326,
		},
		locations = {
			{
				x =383.04083251953,
				y=-1622.9884033203,
				z=29.291938781738
			}
		},
	})
	--Permis de conduire
	exports.bf:AddArea("ds", {
		marker = {
			type = 1,
			weight = 1,
			height = 1,
			red = 255,
			green = 255,
			blue = 153,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					TriggerServerEvent("vehicle:permis:get", "vehicle:permis:get:ds")
				end
			},
			exit = {
				callback = function()
					zoneType = nil
					zone = nil
				end
			}
		},
		blip = {
			text = "Auto-école",
			colorId = 4,
			imageId = 326,
		},
		locations = {
			{
				x =240.02340698242,
				y=-1380.71,
				z=33.740024
			}
		},
	})

	exports.bf:AddArea("checkpoints-1", {
		marker = {
			type = 1,
			weight = 8,
			height = 3,
			red = 255,
			green = 255,
			blue = 153,
			showDistance = 60
		},
		trigger = {
			weight = 4,
			active = {
				callback = function()
					TriggerEvent('vehicle:belt', "ds:belt")
					exports.bf:DisableArea("checkpoints-1")
					exports.bf:EnableArea("checkpoints-2")
				end
			},
		},
		blip = {
			text = "CheckPoint 1",
			colorId = 24,
			imageId = 309,
		},
		locations = {
			{
				x = 175.87483215332,
				y = -1401.7551269531,
				z = 28.833745956421
			}
		},
	})
	exports.bf:AddArea("checkpoints-2", {
		marker = {
			type = 1,
			weight = 8,
			height = 3,
			red = 255,
			green = 255,
			blue = 153,
			showDistance = 60
		},
		trigger = {
			weight = 4,
			active = {
				callback = function()
					TriggerEvent('vehicle:belt', "ds:belt")
					exports.bf:DisableArea("checkpoints-2")
					exports.bf:EnableArea("checkpoints-3")
				end
			},
		},
		blip = {
			text = "CheckPoint 2",
			colorId = 24,
			imageId = 309,
		},
		locations = {
			{
				x = 446.39315795898,
				y = -1613.5487060547,
				z = 28.838726043701
			}
		},
	})
	exports.bf:AddArea("checkpoints-3", {
		marker = {
			type = 1,
			weight = 8,
			height = 3,
			red = 255,
			green = 255,
			blue = 153,
			showDistance = 60
		},
		trigger = {
			weight = 4,
			active = {
				callback = function()
					exports.bf:DisableArea("checkpoints-3")

					if 	IsVehicleDamaged(dsVehicle --[[ Vehicle ]]) then
						-- TODO: donner le permis
						exports.bf:Notification("Vous avez endommagé le véhicule !")
					else
						TriggerServerEvent("vehicle:permis:give")
						exports.bf:Notification("Vous avez le permis de conduire !")
					end
					ds = false

					-- TASK_LEAVE_VEHICLE
					TaskLeaveVehicle(
						GetPlayerPed(-1) --[[ Ped ]], 
						dsVehicle --[[ Vehicle ]]
					)
					Wait(2000)

					-- delete vehicle
					DeleteGivenVehicle( dsVehicle, 10 )

				end
			},
		},
		blip = {
			text = "CheckPoint 2",
			colorId = 24,
			imageId = 309,
		},
		locations = {
			{
				x = 229.88786315918,
				y = -1404.20935058597,
				z = 29.751350402832
			}
		},
	})
	exports.bf:DisableArea("checkpoints-1")
	exports.bf:DisableArea("checkpoints-2")
	exports.bf:DisableArea("checkpoints-3")
	local price = 100
	exports.bf:AddMenu("ds", {
		title = "Auto-école",
		position = 1,
		buttons = {
			{
				text = "Permis de conduire (~g~"..price.." $~s~)",
				exec = {
					callback = function ()
						TriggerServerEvent("vehicle:ds", "vehicle:ds", price)
					end
				},
			}
		}
	})
end)

local menuOpened = 0

RegisterNetEvent("ds:belt")

AddEventHandler("ds:belt", function(belt)
	print(belt)
	if not belt then
		exports.bf:Notification('Pas de ceinture ! Permis annulé')
		exports.bf:DisableArea("checkpoints-1")
		exports.bf:DisableArea("checkpoints-2")
		exports.bf:DisableArea("checkpoints-3")
		ds = false
	end
end)


RegisterNetEvent("vehicle:permis:get:ds")

AddEventHandler("vehicle:permis:get:ds", function(permis)
	if permis == false then
		exports.bf:HelpPromt("Auto-école : ~INPUT_PICKUP~")
		zoneType = "ds"
	end
	exports.bf:Notification("Vous avez déjà le permis")
end)

RegisterNetEvent("vehicle:permis:get:depot")

AddEventHandler("vehicle:permis:get:depot", function(permis)
	if permis then
		exports.bf:HelpPromt("Fourrière : ~INPUT_PICKUP~")
		zoneType = "depots"
	end
	exports.bf:Notification("Vous n'avez pas le permis")
end)

RegisterNetEvent("vehicle:ds")

AddEventHandler("vehicle:ds", function()
	local vehicleName = "dilettante"
	-- load the model
	RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

	-- wait for the model to load
	while not HasModelLoaded(vehicleName) do
		Wait(500) -- often you'll also see Citizen.Wait
	end
	
	ClearAreaOfVehicles(228.3041229248, -1397.3438720703, 30.488224029541, 5.0, false, false, false, false, false)
	-- create the vehicle
	local vehicle = CreateVehicle(vehicleName, 228.3041229248, -1397.3438720703, 26.42, 150.0, true, false)

	-- set the player ped into the vehicle's driver seat
	SetPedIntoVehicle(playerPed, vehicle, -1)

	-- release the model
	SetModelAsNoLongerNeeded(vehicleName)

	-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
	SetVehicleFuelLevel(vehicle, 100.0)


	dsVehicle = vehicle
	SetEntityAsNoLongerNeeded(vehicle)

	exports.bf:Notification("~g~ L'épreuve commence. N'oubliez pas votre ceinture !")
	exports.bf:EnableArea("checkpoints-1")
	ds = true
	exports.bf:CloseMenu("ds")
end)


RegisterNetEvent("vehicle:job:buy:ok")

AddEventHandler("vehicle:job:buy:ok", function(name, id)
	print(name)
	local vehicleName = name
	currentVehicle = id
    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
   while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end
	ClearAreaOfVehicles(374.59939575195, -1619.4310302734, 29.29193687439, 5.0, false, false, false, false, false)
    local vehicle = CreateVehicle(vehicleName, 374.59939575195, -1619.4310302734, 29.29193687439, 338.41, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
	SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)

	exports.bf:CloseMenu("shops-job")
end)

RegisterNetEvent("vehicle:buy:ok")

AddEventHandler("vehicle:buy:ok", function(name, id)
	print(name)
	local vehicleName = name
	currentVehicle = id
    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
   while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end

	ClearAreaOfVehicles(-29.2, -1087.02, 25.53, 5.0, false, false, false, false, false)
    local vehicle = CreateVehicle(vehicleName, -29.2, -1087.02, 25.53, 338.41, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
	SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)

	exports.bf:CloseMenu("shops")
end)

RegisterNetEvent("vehicle:parking:get")

AddEventHandler("vehicle:parking:get", function(data, id)
	local vehicleName = data.name
	currentVehicle = data.id
	menuOpened = 0
	TriggerEvent("menu:delete", "vehiclesShop") 

    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
	end
	

	coords = exports.bf:GetPlayerCoords()

	ClearAreaOfVehicles(coords.x, coords.y, coords.z, 5.0, false, false, false, false, false)
    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, coords.x, coords.y, coords.z, 150.5, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)
	
	TriggerServerEvent("vehicle:parking:get", data.id)
end)

RegisterNetEvent("vehicle:menu:closed")

AddEventHandler("vehicle:menu:closed", function()
	menuOpened = 0
end)

-- detect parking enter
Citizen.CreateThread(function()
	local notification = false
	while true do
		Citizen.Wait(0)
		if zoneType == "shops" and IsControlJustPressed(1, 51) then
			TriggerServerEvent("vehicle:shop:get:all", "vehicle:shop")	
		elseif zoneType == "shops-job" and IsControlJustPressed(1, 51) then
				TriggerServerEvent("vehicle:shop:job:get:all", "vehicle:job:shop")		
		elseif zoneType == "parking" and IsControlJustPressed(1, 51) then
			if exports.bf:isPedDrivingAVehicle() then
				exports.bf:SetMenuValue("parking-veh", {
					buttons = {
						{
							text = "Stocker : " .. zone,
							exec = {
								callback = function()
									TriggerServerEvent("vehicle:store", currentVehicle, zone)
									currentVehicle = 0
								
									DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
									exports.bf:CloseMenu("parking-veh")
								end
							},
						}
					}
				})

				exports.bf:OpenMenu("parking-veh")
			else
				TriggerServerEvent("vehicle:parking:get:all", zone, "vehicle:foot")
			end
		elseif zoneType == "depots" and IsControlJustPressed(1, 51) then
			if exports.bf:isPedDrivingAVehicle() then
				exports.bf:Notification('~r~Tu ne peux pas récupérer de voiture en conduisant.')
			else
				TriggerServerEvent("vehicle:depots:get:all", "vehicle:depots")
			end
		elseif zoneType == "ds" and IsControlJustPressed(1, 51) then
			if exports.bf:isPedDrivingAVehicle() then
				exports.bf:Notification('~r~Tu ne peux pas passer le permis de voiture en conduisant.')
			else
				exports.bf:OpenMenu("ds")
			end
		end

		if ds then
			local ped = GetPlayerPed(-1)
			vehicle = GetVehiclePedIsIn(ped, false)
			if vehicle ~= dsVehicle then
				exports.bf:Notification('Vous êtes descendu de la voiture. Permis annulé')
				exports.bf:DisableArea("checkpoints-1")
				exports.bf:DisableArea("checkpoints-2")
				exports.bf:DisableArea("checkpoints-3")
				ds = false
			end
		end
	end
end)

RegisterNetEvent("vehicle:job:shop")

AddEventHandler("vehicle:job:shop", function(vehicles)
	local buttons = {}
	
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label.. " (~g~".. v.price.." $~s~)",
			exec = {
				callback = function() 
					-- buy the car
					TriggerServerEvent("vehicle:job:buy", "vehicle:job:buy:ok", v.id)
				end
			},
		}
	end
	exports.bf:SetMenuButtons("shops", buttons)
	exports.bf:OpenMenu("shops")
end)

RegisterNetEvent("vehicle:shop")

AddEventHandler("vehicle:shop", function(vehicles)
	local buttons = {}
	
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label.. " (~g~".. v.price.." $~s~)",
			exec = {
				callback = function() 
					-- buy the car
					TriggerServerEvent("vehicle:buy", "vehicle:buy:ok", v.id)
				end
			},
			hover = {
				callback = function()
					local vehicleName = v.name
					-- load the model
					RequestModel(vehicleName)
				
					-- wait for the model to load
					while not HasModelLoaded(vehicleName) do
						Wait(500) -- often you'll also see Citizen.Wait
					end
				
					ClearAreaOfVehicles(-44.44, -1098.43, 26.42, 5.0, false, false, false, false, false)
					-- create the vehicle
					local vehicle = CreateVehicle(vehicleName, -44.44, -1098.43, 26.42, 10.04, true, false)
				
					-- set the player ped into the vehicle's driver seat
				  --  SetPedIntoVehicle(playerPed, vehicle, -1)				
				  
					-- release the model
					SetModelAsNoLongerNeeded(vehicleName)
					-- SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS
					SetVehicleDoorsLockedForAllPlayers(
						vehicle --[[ Vehicle ]], 
						true --[[ boolean ]]
					)
					-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
					SetEntityAsNoLongerNeeded(vehicle)
				end
			}
	}
	end
	exports.bf:SetMenuButtons("shops", buttons)
	exports.bf:OpenMenu("shops")
end)


RegisterNetEvent("vehicle:depots")

AddEventHandler("vehicle:depots", function(vehicles)
	local buttons = {}
	
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label,
			exec = {
				callback = function() 
					TriggerServerEvent("vehicle:parking:get", v.id, "vehicle:depots:get")
				end
		}
	}
	end
	exports.bf:SetMenuButtons("depots", buttons)
	exports.bf:OpenMenu("depots")
end)

RegisterNetEvent("vehicle:foot")

AddEventHandler("vehicle:foot", function(vehicles)
	local buttons = {}

	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label,
			exec = {
				callback = function() 
					TriggerServerEvent("vehicle:parking:get", v.id, "vehicle:get")
				end
		}
	}
	end
	exports.bf:SetMenuButtons("parking-foot", buttons)
	exports.bf:OpenMenu("parking-foot")
end)

RegisterNetEvent("vehicle:get")

AddEventHandler("vehicle:get", function(data)
	print("go")
	local vehicleName = data.name
	currentVehicle = data.id
	menuOpened = 0
    -- check if the vehicle actually exists
    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TriggerEvent('chat:addMessage', {
            args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
        })
        return
    end

    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end

	ClearAreaOfVehicles(232.19, -788.63, 30.63, 5.0, false, false, false, false, false)
    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, 232.19, -788.63, 29.83, 150.5, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)
	
	TriggerServerEvent("vehicle:parking:get", data.id)
	
	exports.bf:CloseMenu("parking-foot")
end)

RegisterNetEvent("vehicle:depots:get")

AddEventHandler("vehicle:depots:get", function(data)
	local vehicleName = data.name
	currentVehicle = data.id
	menuOpened = 0
    -- check if the vehicle actually exists
    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TriggerEvent('chat:addMessage', {
            args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
        })
        return
    end

    -- load the model
    RequestModel(vehicleName)
    local playerPed = PlayerPedId() -- get the local player ped

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end
	
	ClearAreaOfVehicles(384.67245483398,-1622.2377929688, 29.291933059692, 5.0, false, false, false, false, false)
    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, 384.67245483398,-1622.2377929688, 29.291933059692, -30.0, true, false)

    -- set the player ped into the vehicle's driver seat
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    SetEntityAsNoLongerNeeded(vehicle)

    -- release the model
	SetModelAsNoLongerNeeded(vehicleName)
	
	TriggerServerEvent("vehicle:parking:get", data.id)
	
	exports.bf:CloseMenu("parking-foot")
end)
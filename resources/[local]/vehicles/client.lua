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

            -- We've timed out and the vehicle still hasn't been deleted. 
            if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
                Notify( "~r~Failed to delete vehicle after " .. timeoutMax .. " retries." )
            end 
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
			weight = 2,
			enter = {
				callback = function()
					TriggerServerEvent("vehicle:permis:get", "vehicle:permis:get:depot")
				end
			},
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
			weight = 2,
			enter = {
				callback = function()
					TriggerServerEvent("vehicle:permis:get", "vehicle:permis:get:ds")
				end
			},
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
	local price = 1000
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

local function isPedDrivingAVehicle()
	local ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		-- Check if ped is in driver seat
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains
			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				return true
			end
		end
	end
	return false
end


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
	if not permis then
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


AddEventHandler("vehicle:ds", function()
	local vehicleName = "dilettante"

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

RegisterNetEvent("vehicle:menu:buy")

AddEventHandler("vehicle:menu:buy", function(data)
	for k,v in pairs(data) do
		v.action = "vehicleBuy"
	end
	TriggerEvent("menu:create", "vehiclesShop", "Concessionnaire", "list",
		"", data, "align-top-right", "", "") 
end)

RegisterNetEvent("vehicle:menu:parking:get")

AddEventHandler("vehicle:menu:parking:get", function(data)
	for k,v in pairs(data) do
		print(v)
		v.action = "parkingGet"
	end	
	TriggerEvent("menu:create", "vehiclesShop", "Parking get", "list",
		"", data, "align-top-right", "", "") 
end)

RegisterNetEvent("vehicle:menu:parking:store")

AddEventHandler("vehicle:menu:parking:store", function(parking)

	items = {
		{
			name = "store",
			label = "Stocker",
			action = "parkingStore",
			parking = parking
		},
		}
	TriggerEvent("menu:create", "vehiclesShop", "Parking store", "list",
		"", items, "align-top-right", "", "") 
end)


RegisterNetEvent("vehicle:buy:ok")

AddEventHandler("vehicle:buy:ok", function(name)
	local vehicleName = name
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
end)



RegisterNetEvent("vehicle:menu:closed")

AddEventHandler("vehicle:menu:closed", function()
	menuOpened = 0
end)


------realistic vehicles
-- thanks to https://github.com/iEns/RealisticVehicleFailure

local pedInSameVehicleLast=false
local vehicle
local lastVehicle
local vehicleClass
local fCollisionDamageMult = 0.0
local fDeformationDamageMult = 0.0
local fEngineDamageMult = 0.0
local fBrakeForce = 1.0
local isBrakingForward = false
local isBrakingReverse = false

local healthEngineLast = 1000.0
local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyLast = 1000.0
local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local healthPetrolTankLast = 1000.0
local healthPetrolTankCurrent = 1000.0
local healthPetrolTankNew = 1000.0
local healthPetrolTankDelta = 0.0
local healthPetrolTankDeltaScaled = 0.0
local tireBurstLuckyNumber

local function fscale(inputValue, originalMin, originalMax, newBegin, newEnd, curve)
	local OriginalRange = 0.0
	local NewRange = 0.0
	local zeroRefCurVal = 0.0
	local normalizedCurVal = 0.0
	local rangedValue = 0.0
	local invFlag = 0

	if (curve > 10.0) then curve = 10.0 end
	if (curve < -10.0) then curve = -10.0 end

	curve = (curve * -.1)
	curve = 10.0 ^ curve

	if (inputValue < originalMin) then
	  inputValue = originalMin
	end
	if inputValue > originalMax then
	  inputValue = originalMax
	end

	OriginalRange = originalMax - originalMin

	if (newEnd > newBegin) then
		NewRange = newEnd - newBegin
	else
	  NewRange = newBegin - newEnd
	  invFlag = 1
	end

	zeroRefCurVal = inputValue - originalMin
	normalizedCurVal  =  zeroRefCurVal / OriginalRange

	if (originalMin > originalMax ) then
	  return 0
	end

	if (invFlag == 0) then
		rangedValue =  ((normalizedCurVal ^ curve) * NewRange) + newBegin
	else
		rangedValue =  newBegin - ((normalizedCurVal ^ curve) * NewRange)
	end

	return rangedValue
end



local function tireBurstLottery()
	local tireBurstNumber = math.random(tireBurstMaxNumber)
	if tireBurstNumber == tireBurstLuckyNumber then
		-- We won the lottery, lets burst a tire.
		if GetVehicleTyresCanBurst(vehicle) == false then return end
		local numWheels = GetVehicleNumberOfWheels(vehicle)
		local affectedTire
		if numWheels == 2 then
			affectedTire = (math.random(2)-1)*4		-- wheel 0 or 4
		elseif numWheels == 4 then
			affectedTire = (math.random(4)-1)
			if affectedTire > 1 then affectedTire = affectedTire + 2 end	-- 0, 1, 4, 5
		elseif numWheels == 6 then
			affectedTire = (math.random(6)-1)
		else
			affectedTire = 0
		end
		SetVehicleTyreBurst(vehicle, affectedTire, false, 1000.0)
		tireBurstLuckyNumber = math.random(tireBurstMaxNumber)			-- Select a new number to hit, just in case some numbers occur more often than others
	end
end


if config.torqueMultiplierEnabled or config.preventVehicleFlip or config.limpMode then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if config.torqueMultiplierEnabled or config.sundayDriver or config.limpMode then
				if pedInSameVehicleLast then
					local factor = 1.0
					if config.torqueMultiplierEnabled and healthEngineNew < 900 then
						factor = (healthEngineNew+200.0) / 1100
					end
					if config.sundayDriver and GetVehicleClass(vehicle) ~= 14 then -- Not for boats
						local accelerator = GetControlValue(2,71)
						local brake = GetControlValue(2,72)
						local speed = GetEntitySpeedVector(vehicle, true)['y']
						-- Change Braking force
						local brk = fBrakeForce
						if speed >= 1.0 then
							-- Going forward
							if accelerator > 127 then
								-- Forward and accelerating
								local acc = fscale(accelerator, 127.0, 254.0, 0.1, 1.0, 10.0-(config.sundayDriverAcceleratorCurve*2.0))
								factor = factor * acc
							end
							if brake > 127 then
								-- Forward and braking
								isBrakingForward = true
								brk = fscale(brake, 127.0, 254.0, 0.01, fBrakeForce, 10.0-(config.sundayDriverBrakeCurve*2.0))
							end
						elseif speed <= -1.0 then
							-- Going reverse
							if brake > 127 then
								-- Reversing and accelerating (using the brake)
								local rev = fscale(brake, 127.0, 254.0, 0.1, 1.0, 10.0-(config.sundayDriverAcceleratorCurve*2.0))
								factor = factor * rev
							end
							if accelerator > 127 then
								-- Reversing and braking (Using the accelerator)
								isBrakingReverse = true
								brk = fscale(accelerator, 127.0, 254.0, 0.01, fBrakeForce, 10.0-(config.sundayDriverBrakeCurve*2.0))
							end
						else
							-- Stopped or almost stopped or sliding sideways
							local entitySpeed = GetEntitySpeed(vehicle)
							if entitySpeed < 1 then
								-- Not sliding sideways
								if isBrakingForward == true then
									--Stopped or going slightly forward while braking
									DisableControlAction(2,72,true) -- Disable Brake until user lets go of brake
									SetVehicleForwardSpeed(vehicle,speed*0.98)
									SetVehicleBrakeLights(vehicle,true)
								end
								if isBrakingReverse == true then
									--Stopped or going slightly in reverse while braking
									DisableControlAction(2,71,true) -- Disable reverse Brake until user lets go of reverse brake (Accelerator)
									SetVehicleForwardSpeed(vehicle,speed*0.98)
									SetVehicleBrakeLights(vehicle,true)
								end
								if isBrakingForward == true and GetDisabledControlNormal(2,72) == 0 then
									-- We let go of the brake
									isBrakingForward=false
								end
								if isBrakingReverse == true and GetDisabledControlNormal(2,71) == 0 then
									-- We let go of the reverse brake (Accelerator)
									isBrakingReverse=false
								end
							end
						end
						if brk > fBrakeForce - 0.02 then brk = fBrakeForce end -- Make sure we can brake max.
						SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce', brk)  -- Set new Brake Force multiplier
					end
					if config.limpMode == true and healthEngineNew < config.engineSafeGuard + 5 then
						factor = config.limpModeMultiplier
					end
					SetVehicleEngineTorqueMultiplier(vehicle, factor)
				end
			end
			if config.preventVehicleFlip then
				local roll = GetEntityRoll(vehicle)
				if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
					DisableControlAction(2,59,true) -- Disable left/right
					DisableControlAction(2,60,true) -- Disable up/down
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		local ped = GetPlayerPed(-1)
		if isPedDrivingAVehicle() then
			vehicle = GetVehiclePedIsIn(ped, false)
			vehicleClass = GetVehicleClass(vehicle)
			healthEngineCurrent = GetVehicleEngineHealth(vehicle)
			if healthEngineCurrent == 1000 then healthEngineLast = 1000.0 end
			healthEngineNew = healthEngineCurrent
			healthEngineDelta = healthEngineLast - healthEngineCurrent
			healthEngineDeltaScaled = healthEngineDelta * config.damageFactorEngine * config.classDamageMultiplier[vehicleClass]

			healthBodyCurrent = GetVehicleBodyHealth(vehicle)
			if healthBodyCurrent == 1000 then healthBodyLast = 1000.0 end
			healthBodyNew = healthBodyCurrent
			healthBodyDelta = healthBodyLast - healthBodyCurrent
			healthBodyDeltaScaled = healthBodyDelta * config.damageFactorBody * config.classDamageMultiplier[vehicleClass]

			healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)
			if config.compatibilityMode and healthPetrolTankCurrent < 1 then
				--	SetVehiclePetrolTankHealth(vehicle, healthPetrolTankLast)
				--	healthPetrolTankCurrent = healthPetrolTankLast
				healthPetrolTankLast = healthPetrolTankCurrent
			end
			if healthPetrolTankCurrent == 1000 then healthPetrolTankLast = 1000.0 end
			healthPetrolTankNew = healthPetrolTankCurrent
			healthPetrolTankDelta = healthPetrolTankLast-healthPetrolTankCurrent
			healthPetrolTankDeltaScaled = healthPetrolTankDelta * config.damageFactorPetrolTank * config.classDamageMultiplier[vehicleClass]

			if healthEngineCurrent > config.engineSafeGuard+1 then
				SetVehicleUndriveable(vehicle,false)
			end

			if healthEngineCurrent <= config.engineSafeGuard+1 and config.limpMode == false then
				SetVehicleUndriveable(vehicle,true)
			end

			-- If ped spawned a new vehicle while in a vehicle or teleported from one vehicle to another, handle as if we just entered the car
			if vehicle ~= lastVehicle then
				pedInSameVehicleLast = false
			end


			if pedInSameVehicleLast == true then
				-- Damage happened while in the car = can be multiplied

				-- Only do calculations if any damage is present on the car. Prevents weird behavior when fixing using trainer or other script
				if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then

					-- Combine the delta values (Get the largest of the three)
					local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)

					-- If huge damage, scale back a bit
					if healthEngineCombinedDelta > (healthEngineCurrent - config.engineSafeGuard) then
						healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
					end

					-- If complete damage, but not catastrophic (ie. explosion territory) pull back a bit, to give a couple of seconds og engine runtime before dying
					if healthEngineCombinedDelta > healthEngineCurrent then
						healthEngineCombinedDelta = healthEngineCurrent - (config.cascadingFailureThreshold / 5)
					end


					------- Calculate new value

					healthEngineNew = healthEngineLast - healthEngineCombinedDelta


					------- Sanity Check on new values and further manipulations

					-- If somewhat damaged, slowly degrade until slightly before cascading failure sets in, then stop

					if healthEngineNew > (config.cascadingFailureThreshold + 5) and healthEngineNew < config.degradingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.038 * config.degradingHealthSpeedFactor)
					end

					-- If Damage is near catastrophic, cascade the failure
					if healthEngineNew < config.cascadingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.1 * config.cascadingFailureSpeedFactor)
					end

					-- Prevent Engine going to or below zero. Ensures you can reenter a damaged car.
					if healthEngineNew < config.engineSafeGuard then
						healthEngineNew = config.engineSafeGuard
					end

					-- Prevent Explosions
					if config.compatibilityMode == false and healthPetrolTankCurrent < 750 then
						healthPetrolTankNew = 750.0
					end

					-- Prevent negative body damage.
					if healthBodyNew < 0  then
						healthBodyNew = 0.0
					end
				end
			else
				-- Just got in the vehicle. Damage can not be multiplied this round
				-- Set vehicle handling data
				fDeformationDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult')
				fBrakeForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
				local newFDeformationDamageMult = fDeformationDamageMult ^ config.deformationExponent	-- Pull the handling file value closer to 1
				if config.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult', newFDeformationDamageMult * config.deformationMultiplier) end  -- Multiply by our factor
				if config.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fWeaponDamageMult', config.weaponsDamageMultiplier/config.damageFactorBody) end -- Set weaponsDamageMultiplier and compensate for damageFactorBody

				--Get the CollisionDamageMultiplier
				fCollisionDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult')
				--Modify it by pulling all number a towards 1.0
				local newFCollisionDamageMultiplier = fCollisionDamageMult ^ config.collisionDamageExponent	-- Pull the handling file value closer to 1
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult', newFCollisionDamageMultiplier)

				--Get the EngineDamageMultiplier
				fEngineDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult')
				--Modify it by pulling all number a towards 1.0
				local newFEngineDamageMult = fEngineDamageMult ^ config.engineDamageExponent	-- Pull the handling file value closer to 1
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult', newFEngineDamageMult)

				-- If body damage catastrophic, reset somewhat so we can get new damage to multiply
				if healthBodyCurrent < config.cascadingFailureThreshold then
					healthBodyNew = config.cascadingFailureThreshold
				end
				pedInSameVehicleLast = true
			end

			-- set the actual new values
			if healthEngineNew ~= healthEngineCurrent then
				SetVehicleEngineHealth(vehicle, healthEngineNew)
			end
			if healthBodyNew ~= healthBodyCurrent then SetVehicleBodyHealth(vehicle, healthBodyNew) end
			if healthPetrolTankNew ~= healthPetrolTankCurrent then SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew) end

			-- Store current values, so we can calculate delta next time around
			healthEngineLast = healthEngineNew
			healthBodyLast = healthBodyNew
			healthPetrolTankLast = healthPetrolTankNew
			lastVehicle=vehicle
			if config.randomTireBurstInterval ~= 0 and GetEntitySpeed(vehicle) > 10 then tireBurstLottery() end
		else
			if pedInSameVehicleLast == true then
				-- We just got out of the vehicle
				lastVehicle = GetVehiclePedIsIn(ped, true)				
				if config.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fDeformationDamageMult', fDeformationDamageMult) end -- Restore deformation multiplier
				SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fBrakeForce', fBrakeForce)  -- Restore Brake Force multiplier
				if config.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fWeaponDamageMult', config.weaponsDamageMultiplier) end	-- Since we are out of the vehicle, we should no longer compensate for bodyDamageFactor
				SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fCollisionDamageMult', fCollisionDamageMult) -- Restore the original CollisionDamageMultiplier
				SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fEngineDamageMult', fEngineDamageMult) -- Restore the original EngineDamageMultiplier
			end
			pedInSameVehicleLast = false
		end
	end
end)




-- detect parking enter
Citizen.CreateThread(function()
	local notification = false
	while true do
		Citizen.Wait(0)
		if zoneType == "shops" and IsControlJustPressed(1, 51) then
			TriggerServerEvent("vehicle:shop:get:all", "vehicle:shop")		
		elseif zoneType == "parking" and IsControlJustPressed(1, 51) then
			if isPedDrivingAVehicle() then
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
			if isPedDrivingAVehicle() then
				exports.bf:Notification('~r~Tu ne peux pas récupérer de voiture en conduisant.')
			else
				TriggerServerEvent("vehicle:depots:get:all", "vehicle:depots")
			end
		elseif zoneType == "ds" and IsControlJustPressed(1, 51) then
			if isPedDrivingAVehicle() then
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
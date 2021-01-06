DsVehicle = 0
CurrentVehicle = 0
Ped = GetPlayerPed(-1)

Config = {}
Config.parkings = {
	{
		zone = "global",
		locations = {
			{
				x=236.14970397949,
				y=-779.75360107422,
				z=30.804173355103
			},
		}
	},
	{
		zone = "farm",
		locations = {
			{
				x=2035.1791992188,
				y=4989.015625,
				z=39.695823669434
			}
		}
	},
	{
		zone = "wine",
		locations = {
			{
				x=-1924.4694824219,
				y=2041.6114501953,
				z=140.73466491699
			}
		}
	},
	{
		zone = "bennys",
		locations = {
			{
				x=-190.4766998291,
				y=-1289.2463378906,
				z=31.295963287354
			}
		}
	},
	{
		zone = "lsms",
		locations = {
			{
				x=339.56744384766,
				y=-562.45819091797,
				z=28.743431091309
			}
		}
	},
	{
		zone = "lspd",
		red = 77,
		green = 166,
		blue = 255,
		locations = {
			{
				x=449.6057434082,
				y=-1014.3215942383,
				z=28.56
						}
		}
	},
	{
		zone = "taxi",
		locations = {
			{
				x=911.46813964844,
				y=-169.29028320312,
				z=74.229537963867
			}
		}
	},
}

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
	removeMenus()
	createMenus()
end)

-- detect parking enter
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Ds then
			local Ped = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(Ped, false)
			if vehicle ~= DsVehicle then
				exports.bro_core:Notification('Vous êtes descendu de la voiture. Permis annulé')
				exports.bro_core:DisableArea("checkpoints-1")
				exports.bro_core:DisableArea("checkpoints-2")
				exports.bro_core:DisableArea("checkpoints-3")
				Ds = false
			end
		end
	end
end)


-- update vehicles states
Citizen.CreateThread(function()
	TriggerServerEvent("vehicle:player:get", "vehicle:spawn")
	while true do
		Wait(10000)
		TriggerServerEvent("vehicle:player:get", "vehicle:refresh")
		TriggerServerEvent("vehicle:job:get", "vehicle:refresh")
	end
end)


--[[ SEAT SHUFFLE ]]--
--[[ BY JAF ]]--

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		disableSeatShuffle(false)
		Citizen.Wait(5000)
		disableSeatShuffle(true)
	else
		CancelEvent()
	end
end)

RegisterCommand("seat", function(source, args, raw) --change command here
    TriggerEvent("SeatShuffle")
end, false) --False, allow everyone to run it

-- grip offroad
local GripAmount = 5.8000001907349 -- Max amount = 9.8000001907349 | Default = 5.8000001907349 (Grip amount when on drift)


Citizen.CreateThread(function()
	while true do
		local veh = GetVehiclePedIsIn(PlayerPedId())

		if veh == 0 then -- Player isnt in a vehicle
			Citizen.Wait(500)

		else -- Player is in a vehicle

			local material_id = GetVehicleWheelSurfaceMaterial(veh, 1)
			local wheel_type = GetVehicleWheelType(veh)

			if wheel_type == 3 or wheel_type == 4 or wheel_type == 6 then -- If have Off-road/Suv's/Motorcycles wheel grip its equal
			else
				if material_id == 4 or material_id == 1 or material_id == 3 then -- All road (sandy/los santos/paleto bay)
					-- On road
					SetVehicleGravityAmount(veh, 9.8000001907349)
				else
					-- Off road
					if GripAmount >= 9.8000001907349 then
						GripAmount = 5.8000001907349
					end

					SetVehicleGravityAmount(veh, GripAmount)
				end
			end

			Citizen.Wait(200)
		end
	end
end)

local blacklistedModels = {
}

local turnEngineOn = false

-- [[ THREAD ]] --
	-- Todo: Make sure the vehicle is not a boat, bike, plane, heli or blacklisted

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			local veh = GetVehiclePedIsIn(Ped)
			if DoesEntityExist(veh) then
				disableAirControl(Ped, veh)
				disableVehicleRoll(Ped, veh)
			end


		end
	end)


	-- [[ FUNCTIONS ] --
	function resetVehicle(veh)
		FreezeEntityPosition(veh,false)
		SetVehicleOnGroundProperly(veh)
		SetVehicleEngineOn(veh,turnEngineOn)
	end

	function disableAirControl(Ped, veh)
		if not IsThisModelBlacklisted(veh) then
			if IsPedSittingInAnyVehicle(Ped) then
				if GetPedInVehicleSeat(veh, -1) == Ped then
					if IsEntityInAir(veh) then
						DisableControlAction(0, 59)
						DisableControlAction(0, 60)
					end
				end
			end
		end
	end

	function disableVehicleRoll(Ped, veh)
		local roll = GetEntityRoll(veh)

		if not IsThisModelBlacklisted(veh) then
			if GetPedInVehicleSeat(veh, -1) == Ped then
				if (roll > 75.0 or roll < -75.0) then
					DisableControlAction(2,59,true)
					DisableControlAction(2,60,true)
					if not IsEntityInAir(veh) and GetEntitySpeed(veh) < 0.15 then
						Wait(2000)
						destroyPeDsVehicle(Ped)
					end
				end
			end
		end
	end

	function IsThisModelBlacklisted(veh)
		local model = GetEntityModel(veh)

		for i = 1, #blacklistedModels do
			if model == GetHashKey(blacklistedModels[i]) then
				return true
			end
		end
		return false
	end

	function destroyPeDsVehicle(Ped)
		local veh = GetVehiclePedIsIn(Ped)
		FreezeEntityPosition(veh,true)
		SetVehicleEngineOn(veh, false)
	end

	function drawNotification(text)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(text)
		DrawNotification(true, false)
	end
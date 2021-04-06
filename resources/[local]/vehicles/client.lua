DsVehicle = 0
Ped = GetPlayerPed(-1)
LastHovered = nil
Frames = 0
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


	-- vehicles control loss
--https://github.com/cloudy-develop/vehicle-control-loss
  
config = {

    randomChance = 5, -- The chance you will go out of control randomly (Minimum of 1).
    steeringChance = 2, -- The chance you will go out of control when turning (Minimum of 1).

    disabledVehicles = { -- List of vehicle models you don't want to lose control.

        -- Emergency --
        'firetruk',
        'policeold1',
        'policet',
        'lguard',
        'pranger',
        'sheriff2',
        'fbi2',
        'predator',

        -- SUV's --
        'baller',
        'baller2',
        'baller3',
        'baller4',
        'baller5',
        'baller6',
        'bjxl',
        'cavalcade',
        'cavalcade2',
        'contender',
        'dubsta',
        'dubsta2',
        'granger',
        'gresley',
        'landstalker',
        'landstalker2',
        'mesa',
        'mesa2',
        'patriot',
        'patriot2',
        'seminole',
        'seminole2',
        'squaddie',

        -- Van's --
        'bison',
        'bison2',
        'bison3',
        'bobcatxl',
        'rumpo3',
        'youga2',
        'youga3',

        -- Offroad --
        'bfinjection',
        'blazer',
        'blazer2',
        'blazer3',
        'bodhi2',
        'brawler',
        'bruiser',
        'bruiser2',
        'bruiser3',
        'brutus',
        'brutus2',
        'brutus3',
        'caracara',
        'caracara2',
        'dloader',
        'dubsta3',
        'everon',
        'freecrawler',
        'hellion',
        'insurgent',
        'insurgent2',
        'insurgent3',
        'kamacho',
        'marshall',
        'menacer',
        'mesa3',
        'monster',
        'monster3',
        'monster4',
        'monster5',
        'nightshark',
        'outlaw',
        'rancherxl',
        'rancherxl2',
        'rcbandito',
        'rebel',
        'rebel2',
        'riata',
        'sandking',
        'sandking2',
        'technical',
        'technical2',
        'technical3',
        'trophytruck',
        'trophytruck2',
        'yosemite3',
        'zhaba',
        'verus',
        'winky',

        -- Utility --
        'docktug',
        'ripley',
        'sadler',
        'sadler2',
        'tractor2',
        'tractor3',
        'utillitruck',
        'utillitruck2',
        'utillitruck3',

        -- Commercial --
        'cerberus',
        'cerberus2',
        'cerberus3',

        -- Service --
        'brickade',
        'rallytruck',
        'trash',
        'trash2',
        'wastelander'

    }

}
	local playerPed = 0
local playerVehicle = 0
local vehicleAllowed = false
local vehControlEnabled = false
local isPadShaking = false

Citizen.CreateThread(function()

    while (true) do

        if (vehicleAllowed) then

            if not (vehControlEnabled) then

                if (GetEntitySpeed(playerVehicle) > 30.0) then

                    if (GetVehicleSteeringAngle(playerVehicle) > 30.0) or (GetVehicleSteeringAngle(playerVehicle) < -30.0) then

                        if (math.random(0, config.steeringChance) == 0) then
                            TriggerEvent('VehicleControlLoss', playerVehicle)
                        end

                    end

                end

            else

                if (IsControlPressed(0, 72)) or (IsControlPressed(0, 76)) then
                    ShakePad()
                end

            end

        end

        Citizen.Wait(0)

    end

end)

Citizen.CreateThread(function()

    while (true) do

        playerPed = PlayerPedId()
        playerVehicle = GetVehiclePedIsIn(playerPed, false)

        if (IsWeatherAccurate(GetNextWeatherTypeHashName())) then

            if (playerVehicle ~= 0) and (GetPedInVehicleSeat(playerVehicle, -1) == playerPed) then

                if not (IsClassDisabled(playerVehicle)) and not (IsVehicleDisabled(playerVehicle)) then

                    if not (vehicleAllowed) then
                        vehicleAllowed = true
                    end

                    if not (vehControlEnabled) then

                        if (GetEntitySpeed(playerVehicle) > 20.0) then

                            if (math.random(0, config.randomChance) == 0) then
                                TriggerEvent('VehicleControlLoss', playerVehicle)
                            end
            
                        end

                    end

                else

                    if (vehicleAllowed) then
                        vehicleAllowed = false
                    end

                end

            else

                if (vehicleAllowed) then
                    vehicleAllowed = false
                end

            end

        else

            if (vehicleAllowed) then
                vehicleAllowed = false
            end

        end

        Citizen.Wait(1000)

    end

end)

function IsWeatherAccurate(weather)

    local accurateWeather = {
        1840358669, -- Clearing
        1420204096, -- Rain
        -1233681761, -- Thunder
        -1429616491, -- Xmas
        603685163, -- Light Snow
        -273223690, -- Snow
        669657108 -- Blizzard
    }

    for i,var in pairs(accurateWeather) do

        if (var == weather) then
            return true
        end

    end

    return false

end

function IsClassDisabled(vehicle)

    local vehClass = GetVehicleClass(vehicle)
    local disabledClasses = {
        10, -- Industrial
        13, -- Cycles
        14, -- Boats
        15, -- Helicopters
        16, -- Planes
        19, -- Military
        21 -- Trains
    }

    for i,var in pairs(disabledClasses) do

        if (var == vehClass) then
            return true
        end

    end

    return false

end

function IsVehicleDisabled(vehicle)

    for i,var in pairs(config.disabledVehicles) do

        if (GetHashKey(var) == GetEntityModel(vehicle)) then
            return true
        end

    end

    return false

end

function ShakePad()

    if not (isPadShaking) then

        isPadShaking = true

        local shakeDuration = math.random(1, 2) * 100

        StopPadShake(0)
        SetPadShake(0, shakeDuration, 255)

        Wait(shakeDuration + 100)

        isPadShaking = false

    end

end

RegisterNetEvent('VehicleControlLoss')
AddEventHandler('VehicleControlLoss', function(vehicle)

    vehControlEnabled = true
    SetVehicleReduceGrip(vehicle, true)

    Wait(math.random(1, 8) * 1000)

    SetVehicleReduceGrip(vehicle, false)
    vehControlEnabled = false

end)
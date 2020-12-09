zoneType =0
zone = "global"
dsVehicle = 0
currentVehicle = 0

config = {}
config.parkings = {
	{
		zone = "global",
		locations = {
			{
				x =234.68,
				y=-782.73,
				z=29.9
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
		locations = {
			{
				x=455.12176513672,
				z=-1020.779296875,
				y=28.307716369629
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


-- update vehicles states
Citizen.CreateThread(function()
	TriggerServerEvent("vehicle:player:get", "vehicle:spawn")
	while true do
		Wait(10000)
		TriggerServerEvent("vehicle:player:get", "vehicle:refresh")
		TriggerServerEvent("vehicle:job:get", "vehicle:refresh")
	end
end)

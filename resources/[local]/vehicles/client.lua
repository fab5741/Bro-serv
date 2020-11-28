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
--Citizen.CreateThread(function()
--	TriggerServerEvent("vehicle:player:get", "vehicle:spawn")
--	while true do
--		Wait(3000)
--		TriggerServerEvent("vehicle:player:get", "vehicle:refresh")
--	end
--end)

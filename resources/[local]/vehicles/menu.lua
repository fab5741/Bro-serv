function createMenus()
    	--shops
	exports.bro_core:AddArea("shops", {
		marker = {
			type = 1,
			weight = 1,
			height = 0.2,
			red = 250,
			green = 10,
			blue = 10,
			showDistance = 5,
		},
		trigger = {
			weight = 2,
			enter = {
				callback = function()
					exports.bro_core:Key("E", "E", "Concessionaire", function()
						TriggerServerEvent("vehicle:shop:get:all", "vehicle:shop")	
					end)
					exports.bro_core:HelpPromt("Concessionaire Key : ~INPUT_PICKUP~")
				end
			},
			exit = {
				callback = function()
					exports.bro_core:RemoveMenu("concess")
					exports.bro_core:Key("E", "E", "Interaction", function()
					end)
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

	--- shop for job
	exports.bro_core:AddArea("shops-job", {
		marker = {
			type = 1,
			weight = 1,
			height = 0.2,
			red = 250,
			green = 10,
			blue = 10,
			showDistance = 5,
		},
		trigger = {
			weight = 2,
			enter = {
				callback = function()
					exports.bro_core:HelpPromt("Concessionaire Entreprise Key : ~INPUT_PICKUP~")
					exports.bro_core:Key("E", "E", "Concessionaire", function()
						TriggerServerEvent("vehicle:shop:job:get:all", "vehicle:job:shop")
					end)
				end
			},
			exit = {
				callback = function()
					exports.bro_core:RemoveMenu("concesscorpo")
					exports.bro_core:Key("E", "E", "Interaction", function()
					end)
				end
			},
		},
		blip = {
			text = "Concessionnaire entreprise",
			colorId = 1,
			imageId = 326,
		},
		locations = {
			{
				x =-182.39936828613,
				y=-1315.0681152344,
				z=31.295978546143
			}
		},
	})
	-- parkings
	for k,v in pairs(Config.parkings) do
		exports.bro_core:AddArea("parkings"..k, {
			marker = {
				weight = 2,
				height = 0.15,
				red = v.red,
				green = v.green,
				blue = v.blue,
				alpha = 100,
				showDistance = 5,
				type = 43
			},
			trigger = {
				weight = 2,
				enter = {
					callback = function()
						exports.bro_core:HelpPromt("Parking : ~INPUT_PICKUP~")
						exports.bro_core:Key("E", "E", "Parking ("..v.zone..")", function()
							if exports.bro_core:isPedDrivingAVehicle() then
								exports.bro_core:AddMenu("parking-veh", {
									Title = "Parking",
									Subtitle = v.zone,
									buttons = {
										{
											type= "button",
											label = "Stocker : " .. v.zone,
											actions = {
												onSelected = function()
													exports.bro_core:actionPlayer(4000, "Stockage véhicule", "", "",
													function()
														print("store veh")
														TriggerServerEvent("vehicle:store", CurrentVehicle, v.zone)
														CurrentVehicle = 0
														DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
														exports.bro_core:RemoveMenu("parking-veh")
													end)
												end
											},
										}
									}
								})
							else
								TriggerServerEvent("vehicle:parking:get:all", v.zone, "vehicle:foot")
							end
						end)
					end
				},
				exit = {
					callback = function()
						exports.bro_core:RemoveMenu("parking-veh")
						exports.bro_core:Key("E", "E", "Interaction", function()
						end)
					end
				},
			},
			blip = {
				text = "Parking",
				colorId = 2,
				imageId = 357,
			},
			locations = v.locations,
		})
	end

	--depots
	exports.bro_core:AddArea("depots", {
		marker = {
			type = 43,
			weight = 2,
			height = 0.2,
			red = 250,
			green = 10,
			blue = 10,
			showDistance = 5,
		},
		trigger = {
			weight = 2,
			enter = {
				callback = function()
					exports.bro_core:HelpPromt("Fourrière Key : ~INPUT_PICKUP~")
					exports.bro_core:Key("E", "E", "Fourrière", function()
						if exports.bro_core:isPedDrivingAVehicle() then
							exports.bro_core:Notification('~r~Tu ne peux pas récupérer de voiture en conduisant.')
						else
							TriggerServerEvent("vehicle:depots:get:all", "vehicle:depots")
						end
					end)
				end
			},
			exit = {
				callback = function()
					exports.bro_core:RemoveMenu("depots")
					exports.bro_core:Key("E", "E", "Interaction", function()
					end)
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
				x=-165.1146697998,
				y=-1304.7633056641,
				z=31.365314178467
			}
		},
	})
	--Permis de conduire
	exports.bro_core:AddArea("ds", {
		marker = {
			type = 1,
			weight = 1,
			height = 0.2,
			red = 255,
			green = 255,
			blue = 153,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					exports.bro_core:Key("E", "E", "Permis", function()
						TriggerServerEvent("vehicle:permis:get", "vehicle:permis:get:ds")
					end)
				end
			},
			exit = {
				callback = function()
					exports.bro_core:RemoveMenu("ds")
					exports.bro_core:Key("E", "E", "Interaction", function()
					end)
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

	exports.bro_core:AddArea("checkpoints-1", {
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
					exports.bro_core:DisableArea("checkpoints-1")
					exports.bro_core:EnableArea("checkpoints-2")
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
	exports.bro_core:AddArea("checkpoints-2", {
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
					exports.bro_core:DisableArea("checkpoints-2")
					exports.bro_core:EnableArea("checkpoints-3")
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
	exports.bro_core:AddArea("checkpoints-3", {
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
					exports.bro_core:DisableArea("checkpoints-3")

					if 	IsVehicleDamaged(DsVehicle --[[ Vehicle ]]) then
						-- TODO: donner le permis
						exports.bro_core:Notification("Vous avez endommagé le véhicule !")
					else
						TriggerServerEvent("vehicle:permis:give")
						exports.bro_core:Notification("Vous avez le permis de conduire !")
					end
					ds = false

					-- TASK_LEAVE_VEHICLE
					TaskLeaveVehicle(
						GetPlayerPed(-1) --[[ Ped ]], 
						DsVehicle --[[ Vehicle ]]
					)
					Wait(2000)

					-- delete vehicle
					DeleteGivenVehicle( DsVehicle, 10 )

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
	exports.bro_core:DisableArea("checkpoints-1")
	exports.bro_core:DisableArea("checkpoints-2")
	exports.bro_core:DisableArea("checkpoints-3")
	local price = 100
	exports.bro_core:AddMenu("ds", {
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
end

function removeMenus()
    exports.bro_core:RemoveMenu("concesscorpo")
    exports.bro_core:RemoveMenu("concess")
        --shops
    exports.bro_core:RemoveMenu("shops")
    exports.bro_core:RemoveArea("shops")
    --- shop for job

    exports.bro_core:RemoveMenu("shops-job")

    exports.bro_core:RemoveArea("shops-job")
    -- parkings
    exports.bro_core:RemoveMenu("parking-veh")
    exports.bro_core:RemoveMenu("parking-foot")

    for k,v in pairs(Config.parkings) do
        exports.bro_core:RemoveArea("parkings"..k)
    end


    --depots
    exports.bro_core:RemoveMenu("depots")
	exports.bro_core:RemoveArea("depots")
    --Permis de conduire
    exports.bro_core:RemoveArea("ds")
    exports.bro_core:RemoveArea("checkpoints-1")
    exports.bro_core:RemoveArea("checkpoints-2")
    exports.bro_core:RemoveArea("checkpoints-3")
    exports.bro_core:RemoveMenu("ds")
end
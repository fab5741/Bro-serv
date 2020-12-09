function createMenus()
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
					exports.bf:CloseMenu(zoneType..zone)
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
					exports.bf:CloseMenu(zoneType..zone)
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
				x =-182.39936828613,
				y=-1315.0681152344,
				z=31.295978546143
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

	for k,v in pairs(config.parkings) do
		exports.bf:AddArea("parkings"..k, {
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
						zone = v.zone
					end
				},
				exit = {
					callback = function()
						exports.bf:CloseMenu(zoneType..zone)
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
			locations = v.locations,
		})
	end

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
					zoneType = "depots"
					zone = 1
				end
			},
			exit = {
				callback = function()
					exports.bf:CloseMenu("depots")
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
				x =-162.9992980957,
				y=-1296.6707763672,
				z=30.994600296021
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
					exports.bf:CloseMenu(zoneType..zone)
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
end

function removeMenus()
        --shops
    exports.bf:RemoveMenu("shops")
    exports.bf:RemoveArea("shops")
    --- shop for job

    exports.bf:RemoveMenu("shops-job")

    exports.bf:RemoveArea("shops-job")
    -- parkings
    exports.bf:RemoveMenu("parking-veh")
    exports.bf:RemoveMenu("parking-foot")

    for k,v in pairs(config.parkings) do
        exports.bf:RemoveArea("parkings"..k)
    end


    --depots
    exports.bf:RemoveMenu("depots")
	exports.bf:RemoveArea("depots")
	exports.bf:RemoveMenu("depots")
    exports.bf:RemoveArea("depots")
    --Permis de conduire
    exports.bf:RemoveArea("ds")
    exports.bf:RemoveArea("checkpoints-1")
    exports.bf:RemoveArea("checkpoints-2")
    exports.bf:RemoveArea("checkpoints-3")
    exports.bf:RemoveMenu("ds")
end
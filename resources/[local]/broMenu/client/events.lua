RegisterNetEvent('bromenu:open')
-- Portefeuille
RegisterNetEvent('bromenu:liquid')
RegisterNetEvent('bromenu:permis')
RegisterNetEvent('bromenu:show')
RegisterNetEvent('bromenu:get')
RegisterNetEvent('bromenu:set')
RegisterNetEvent('bromenu:account:get')
-- Items
RegisterNetEvent('bromenu:items')
RegisterNetEvent('vehicle:items:open')
-- Clothes
RegisterNetEvent('bromenu:clothes:mask')
RegisterNetEvent('bromenu:clothes:torse')
RegisterNetEvent('bromenu:clothes:pants')
RegisterNetEvent('bromenu:clothes:shoes')
RegisterNetEvent('bromenu:clothes:reset')


AddEventHandler("bromenu:open", function(job) 
	if job[1] == nil then 
		job = {
			grade = "Chomeur",
			label = ""
		}
	else
		job = job[1]
	end
	local buttons = {}

	buttons[#buttons+1] = 	{
		type = "button",
		label = "Inventaire",
		subMenu = "items"
	}

	buttons[#buttons+1] = 	{
		type = "button",
		label = "Portefeuille",
		subMenu = "wallet",
	}

	buttons[#buttons+1] = 	{
		type = "button",
		label = "Vehicule",
		subMenu = "vehicle"
	}

	if not exports.bro_core:isPedDrivingAVehicle() then
		buttons[#buttons+1] = 	{
			type = "button",
			label = "Vetements",
			subMenu = "clothes"
		}
		buttons[#buttons+1] = 	{
			type = "button",
			label = "Quitter son travail",
			actions = {
				onSelected = function()
					if  exports.bro_core:OpenTextInput({ maxInputLength = 10 , title = "Oui, pour confirmer", customTitle = true}) == "oui" then
						-- on quitte le job
						TriggerServerEvent("job:set:me", nil, "Chomeur")
						Wait(1000)
						TriggerServerEvent("job:get", "jobs:refresh")
					end
				end
			},
		}
	end

	exports.bro_core:AddMenu("bromenu", {
		Title = "Bromenu",
		Subtitle = job.grade.." "..job.label,
		buttons = buttons
	})

	exports.bro_core:AddSubMenu("items", {
		parent = "bromenu",
		buttons = buttons
	})

	exports.bro_core:AddSubMenu("wallet", {
		parent = "bromenu",
		buttons = buttons
	})

	-- trigger menu data loads
	TriggerServerEvent("items:get", "bromenu:items")
	TriggerServerEvent("account:player:liquid:get", "bromenu:liquid")

	buttons = {}

	buttons[#buttons+1] = 	{
		type = "button",
		label = "Verrouiller/Déverouiller",
		actions = {
			onSelected = function()
				local vehicle = GetVehiclePedIsIn(ped, false)
				if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
					if GetPedInVehicleSeat(vehicle, -1) == ped then
						TriggerServerEvent("vehicle:lock", "vehicle:lock", vehicle)
					else
						exports.bro_core:Notification("~r~Vous ne conduisez pas") 
					end
				else
					local pos = GetEntityCoords(ped)
					print(ped)
					local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)
			
					local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
					local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
					print(vehicle)
					if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
						TriggerServerEvent("vehicle:lock", "vehicle:lock", vehicle)
					else
						exports.bro_core:Notification("~r~Pas de voiture à portée")
					end
				end
			end
		}
	}

	buttons[#buttons+1] = 	{
		type = "button",
		label = "Inventaire coffre",
		actions = {
			onSelected = function()
				local coords = GetEntityCoords(ped, true)
				local pos = GetEntityCoords(ped)
				local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)
				local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)
		
				local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
				local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
				local islocked = GetVehicleDoorLockStatus(vehicle)
				if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
					if (islocked == 1)then
						TriggerServerEvent("items:vehicle:get", "vehicle:items:open", vehicle)
					end
				else
					exports.bro_core:Notification("~r~Pas de voiture")
				end
			end
		}
	}
	if exports.bro_core:isPedDrivingAVehicle() then
		buttons[#buttons+1] = 	{
			type = "button",
			label = "Moteur",
			actions = {
				onSelected = function()		
					if (IsPedSittingInAnyVehicle(ped)) then 
						local vehicle = GetVehiclePedIsIn(ped,false)
						
						if GetIsVehicleEngineRunning(vehicle) then
							SetVehicleEngineOn(vehicle,false,false,false)
							SetVehicleUndriveable(vehicle,true)
						else
							SetVehicleUndriveable(vehicle,false)
							SetVehicleEngineOn(vehicle,true,false,false)
						end
					end
				end
			}
		}
		buttons[#buttons+1] = 	{
			type = "button",
			label = "Coffre",
			actions = {
				onSelected = function()
					vehicle = GetVehiclePedIsIn(ped,true)
					
					local isopen = GetVehicleDoorAngleRatio(vehicle,5)
					local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehicle), 1)
					
					if distanceToVeh <= interactionDistance then
						if (isopen == 0) then
						SetVehicleDoorOpen(vehicle,5,0,0)
						else
						SetVehicleDoorShut(vehicle,5,0)
						end
					else
						exports.bro_core:Notification("~r~vous devez être dans un véhicule")
					end
				end
			}
		}
		buttons[#buttons+1] = 	{
			type = "button",
			label = "Porte avant",
			actions = {
				onSelected = function()
					vehicle = GetVehiclePedIsIn(ped,true)
					local isopen = GetVehicleDoorAngleRatio(vehicle,0) and GetVehicleDoorAngleRatio(vehicle,1)
					local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehicle), 1)
					
					if distanceToVeh <= interactionDistance then
						if (isopen == 0) then
						SetVehicleDoorOpen(vehicle,0,0,0)
						SetVehicleDoorOpen(vehicle,1,0,0)
						else
						SetVehicleDoorShut(vehicle,0,0)
						SetVehicleDoorShut(vehicle,1,0)
						end
					else
						exports.bro_core:Notification("~r~vous devez être dans un véhicule")
					end
				end
			}
		}
		buttons[#buttons+1] = 	{
			type = "button",
			label = "Porte arriéres",
			actions = {
				onSelected = function()
					vehicle = GetVehiclePedIsIn(ped,true)
					local isopen = GetVehicleDoorAngleRatio(vehicle,2) and GetVehicleDoorAngleRatio(vehicle,3)
					local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehicle), 1)
					
					if distanceToVeh <= interactionDistance then
						if (isopen == 0) then
						SetVehicleDoorOpen(vehicle,2,0,0)
						SetVehicleDoorOpen(vehicle,3,0,0)
						else
						SetVehicleDoorShut(vehicle,2,0)
						SetVehicleDoorShut(vehicle,3,0)
						end
					else
						exports.bro_core:Notification("~r~vous devez être dans un véhicule")
					end
				end
			}
		}
		buttons[#buttons+1] = 	{
			type = "button",
			label = "Capot",
			actions = {
				onSelected = function()
						vehicle = GetVehiclePedIsIn(ped,true)
							
						local isopen = GetVehicleDoorAngleRatio(vehicle,4)
						local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehicle), 1)
						
						if distanceToVeh <= interactionDistance then
							if (isopen == 0) then
							SetVehicleDoorOpen(vehicle,4,0,0)
							else
							SetVehicleDoorShut(vehicle,4,0)
							end
						else
						exports.bro_core:Notification("~r~vous devez être dans un véhicule")
					end
				end
			}
		}
	end

	exports.bro_core:AddSubMenu("vehicle", {
		parent= "bromenu",
		Title = "Vehicule",
		Subtitle = "Bromenu > Gestion véhicule",
		buttons = buttons
	})

	exports.bro_core:AddSubMenu("clothes", {
		parent= "bromenu",
		Title = "Vêtements",
		Subtitle = "Gestion",
		buttons = {
			{
				type = "button",
				label = "Se rhabiller",
				actions = {
					onSelected = function()
						TriggerServerEvent("bro:skin:get", "bromenu:clothes:reset")
					end
				},
			},
			{
				type = "button",
				label = "Masque",
				actions = {
					onSelected = function()
						TriggerEvent("bromenu:clothes:mask")
					end
				},
			},
			{
				type = "button",
				label = "Torse",
				actions = {
					onSelected = function()
						TriggerEvent("bromenu:clothes:torse")
					end
				},
			},
			{
				type = "button",
				label = "Pontalon",
				actions = {
					onSelected = function()
						TriggerEvent("bromenu:clothes:pants")
					end
				},
			},
			{
				type = "button",
				label = "Chaussures",
				actions = {
					onSelected = function()
						TriggerEvent("bromenu:clothes:shoes")
					end
				},
			}
		}
	})
end)


AddEventHandler("bromenu:liquid", function(liquid) 
	exports.bro_core:AddSubMenu("wallet", {
			parent = "bromenu",
			Title = "Portefeuille",
			Subtitle = firstname.." "..lastname.. " ("..birth..")",
			buttons = {
				{
					type = "button",
					label = "Liquide",
					style = {
						RightLabel = exports.bro_core:Money(liquid)
					},
					actions = {
						onSelected = function()
							local closestPlayer, closestPlayerDist = exports.bro_core:GetClosestPlayer()

							if closestPlayer and closestPlayerDist <= 1.5  then
								local amount = exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})
								exports.bro_core:actionPlayer(2000, "Vous tendez les billets", "amb@prop_human_atm@female@base", "base",
								function()
									TriggerServerEvent("account:player:liquid:give", GetPlayerServerId(closestPlayer), amount)
								end)
							else
								exports.bro_core:Notification("~r~Pas de joueur à proximité")
							end
						end
					},
				},
				{
					type = "button",
					label = "Modifier identité",
					actions = {
						onSelected = function () 
							TriggerServerEvent("bromenu:set", "firstname", exports.bro_core:OpenTextInput({ title="Prénom", maxInputLength=60, customTitle=true}),"")
							TriggerServerEvent("bromenu:set", "lastname", exports.bro_core:OpenTextInput({ title="Nom", maxInputLength=60, customTitle=true}),"")
							TriggerServerEvent("bromenu:set", "birth", exports.bro_core:OpenTextInput({ title="Format (01/01/1911)", maxInputLength=10, customTitle=true}),"")
						end
					}
				},
				{
					type = "button",
					label = "Montrer mon identité",
					actions = {
						onSelected = function()
							exports.bro_core:actionPlayer(2000, "Vous sortez votre carte", "amb@prop_human_atm@female@base", "base",
							function()
								TriggerServerEvent("bromenu:get", "bromenu:show")
							end)
						end
					},
				},
				{
					type = "button",
					label = "Montrer mon permis",
					actions = {
						onSelected = function () 
							exports.bro_core:actionPlayer(2000, "Vous sortez votre carte", "amb@prop_human_atm@female@base", "base",
							function()
								TriggerServerEvent("vehicle:permis:get", "bro:permis")
							end)
						end
					}
				},
			}
		})
end)


AddEventHandler("bromenu:permis", function(permis) 
	local closestPlayerPed, dist = exports.bro_core:GetClosestPlayer()
	if closestPlayerPed and dist < 2 then
		TriggerServerEvent("bro:permis:show", permis, GetPlayerServerId(closestPlayerPed))
	end
end)


AddEventHandler("bromenu:show", function(player) 
	local closestPlayer, closestPlayerDist = exports.bro_core:GetClosestPlayer()

	if closestPlayer and closestPlayerDist <= 1.5  then
		TriggerServerEvent("bro:card:show", player, GetPlayerServerId(closestPlayerPed))
	else
		exports.bro_core:Notification("~r~Pas de joueur à proximité")
	end
end)


AddEventHandler("bromenu:get", function(data) 
	firstname = data.firstname
	lastname = data.lastname
	birth = data.birth
end)



AddEventHandler("bromenu:set", function() 
	exports.bro_core:SetMenuValue("bro-wallet-character",
	{
		menuTitle = firstname.." ".. lastname.. " ("..birth.. ")",
	})
end)


AddEventHandler("bromenu:account:get", function(account) 
	account = account
end)

AddEventHandler("bromenu:items", function(inventory)
	local buttons = {}
	local weight = 0
	local maxWeight = 100

	for k, v in ipairs (inventory) do
		buttons[k] =     {
			type = "button",
			label = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			subMenu = "item"..v.id
		}
		weight = weight + (v.amount*v.weight)
	end
	Subtitle = ""
	if weight > (3/4*maxWeight) then
		Subtitle = "Poids max ~r~("..weight.."/"..maxWeight..")kg"
	else
		Subtitle = "Poids max ~g~("..weight.."/"..maxWeight..")kg"
	end
	exports.bro_core:AddSubMenu("items", {
			parent = "bromenu",
			Title = "Inventaire",
			Subtitle = Subtitle,
			buttons = buttons
		})

		for k, v in ipairs (inventory) do
			OpenMenuItem(v)
		end
end)

AddEventHandler("vehicle:items:open", function(inventory)
	local buttons = {}
	local weight = 0
	local maxWeight = 100

	for k, v in ipairs (inventory) do
		buttons[k] =     {
			type="button",
			label = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			actions = {
				onSelected = function()
					if lockGetCar == false then
						if not  IsPedInAnyVehicle(pedPed, false) then
							local nb = tonumber(exports.bro_core:OpenTextInput({customTitle = true, title = "Nombre", maxInputLength=10}))
							exports.bro_core:actionPlayer(4000, "Stockage", "amb@world_human_gardener_plant@male@enter", "enter", function()
								TriggerServerEvent("item:vehicle:get", v.vehicle_mod, v.id, nb)
							end)
						else
							exports.bro_core:Notification("~r~Vous ne pouvez stocker en véhicule")
						end
					else
						exports.bro_core:Notification("~r~Stockage en cours")
					end
				end
			},
		}
		weight = weight + (v.amount*v.weight)
	end
	exports.bro_core:AddMenu("items", {
		Title = "Inventaire",
		Subtitle = "Cofre",
		buttons = buttons
	})
end)


--clothes event
AddEventHandler('bromenu:clothes:mask', function()
	exports.bro_core:actionPlayer(2000, "Vêtements", clothes_dict, clothes_anim,
	function()
		TriggerEvent('skinchanger:getSkin', function(skin)
			local clothesSkin = {
			['mask_1'] = 0, ['mask_2'] = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)
	end)
end)

AddEventHandler('bromenu:clothes:torse', function()
	exports.bro_core:actionPlayer(2000, "Vêtements", clothes_dict, clothes_anim,
	function()
		TriggerEvent('skinchanger:getSkin', function(skin)
			local clothesSkin = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,
				['torso_1'] = 15, ['torso_2'] = 0,
				['arms'] = 15, ['arms_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)
	end)
end)
AddEventHandler('bromenu:clothes:pants', function()
	exports.bro_core:actionPlayer(2000, "Vêtements", clothes_dict, clothes_anim,
	function()
		TriggerEvent('skinchanger:getSkin', function(skin)
			local clothesSkin = {
				['pants_1'] = 21, ['pants_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)
	end)
end)
AddEventHandler('bromenu:clothes:shoes', function()
	exports.bro_core:actionPlayer(2000, "Vêtements", clothes_dict, clothes_anim,
	function()
		TriggerEvent('skinchanger:getSkin', function(skin)
			local clothesSkin = {
				['shoes_1'] = 34, ['shoes_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)
	end)
end)

AddEventHandler('bromenu:clothes:reset', function(skin)
	exports.bro_core:actionPlayer(2000, "Vêtements", clothes_dict, clothes_anim,
	function()
		TriggerEvent('skinchanger:loadSkin', json.decode(skin))
	end)
end)


-- On nettoie le caca
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	exports.bro_core:RemoveMenu("wallet")
	exports.bro_core:RemoveMenu("items")
	exports.bro_core:RemoveMenu("vehicle")
	exports.bro_core:RemoveMenu("clothes")
	exports.bro_core:RemoveMenu("bromenu")
end)


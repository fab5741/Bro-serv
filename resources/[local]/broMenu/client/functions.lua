
function giveToPlayer()
	local closestPlayerPed, dist = exports.bro_core:GetClosestPlayer()
	if closestPlayerPed and dist <=1 then
		TriggerServerEvent("items:give", v.id, 1, GetPlayerServerId(closestPlayerPed))
	else 
		exports.bro_core:Notification("Pas de joueur à portée")
	end
end

function openMenuItem(item)
	local buttons = {}
	buttons[1] =     {
		type = "button",
		label = "Utiliser",
		actions = {
			onSelected = function() 
				TriggerServerEvent("items:use", item, 1)
			end
		},
	}
	buttons[2] =     {
		type = "button",
		label = "Donner",
		actions = {
			onSelected = function() 
				giveToPlayer()
			end
		},
	}
	buttons[3] =     {
		type = "button",
		label = "Stocker vehicle",
		actions = {
			onSelected = function() 
				coords = GetEntityCoords(GetPlayerPed(-1), true)
				local pos = GetEntityCoords(PlayerPedId())
				local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
		
				local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
				local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
				if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
					if GetVehicleDoorLockStatus(vehicle) == 1 then
						
						local playerPed = GetPlayerPed(-1)
						if lockGetCar == false then
							if not  IsPedInAnyVehicle(playerPed, false) then
								nb = tonumber(exports.bro_core:OpenlabelInput({customTitle = true, title = "Nombre", maxInputLength=10}))
							
								local time = 4000
								TriggerEvent("bro_core:progressBar:create", time, "Stockage en cours")
								lockGetCar = true 
								Citizen.CreateThread(function ()
									FreezeEntityPosition(playerPed)
									
									local dict = "amb@world_human_gardener_plant@male@enter"
									local anim = "enter"
									RequestAnimDict(dict)
	
									while not HasAnimDictLoaded(dict) do
										Citizen.Wait(150)
									end
									TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)
	
									Wait(time)
									lockGetCar = false
									TriggerServerEvent("item:vehicle:store", vehicle, v.id, nb)

								end)
							else
								exports.bro_core:Notification("~r~Vous ne pouvez stocker en véhicule")
							end
						else 
							exports.bro_core:Notification("~r~Stockage en cours")
						end
					else
						exports.bro_core:Notification("~r~Ce véhicule est fermé")
					end
				else 
					exports.bro_core:Notification("~r~Pas de véhicule à portée")
				end
			end
		},
	}
	if item == 7 then
		buttons[4] =     {
			type = "button",
			label = "Commencer la revente",
			actions = {
				onSelected = function() 
					TriggerEvent("crime:drug:sell:start")
					exports.bro_core:RemoveMenu("item")
				end
			},
		}
		buttons[5] =     {
			type = "button",
			label = "Finir la revente",
			actions = {
				onSelected = function() 
					TriggerEvent("crime:drug:sell:stop")
					exports.bro_core:RemoveMenu("item")
				end
			},
		}
	end
	exports.bro_core:AddMenu("item", {
			Title = "Item",
			Subtitle = item,
			buttons = buttons
		})

end

function GetPlayers()
    local players = {}

    for _, player in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(player) then
            table.insert(players, player)
        end
    end

    return players
end


function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

RegisterNetEvent('bf:open')

AddEventHandler("bf:open", function(job) 
	if job[1] == nil then 
		job = {
			grade = "Chomeur",
			label = ""
		}
	else
		job = job[1]
	end
	exports.bf:SetMenuValue("bro", {
		menuTitle = job.grade.." "..job.label
	})
	exports.bf:OpenMenu("bro")
end)


RegisterNetEvent('bf:liquid')

AddEventHandler("bf:liquid", function(liquid) 
  local buttons = {}
	buttons[1] =     {
		text = "Liquide : " .. liquid.. " $",
	}
	buttons[2] =     {
		text = "Identité",
		exec = {
			callback = function()
				TriggerServerEvent("bro:get", "bro:get")
			end
		}
	}
	buttons[3] =     {
		text = "Montrer carte d'identité",
		exec = {
			callback = function()
				local playerPed = GetPlayerPed(-1)
				if lockChanging == false then
					if not  IsPedInAnyVehicle(playerPed, false) then
						local time = 4000
						TriggerEvent("bf:progressBar:create", time, "Vous sortez votre carte")
						lockChanging = true 
						Citizen.CreateThread(function ()
							FreezeEntityPosition(playerPed, true)
							
							local dict = "amb@world_human_gardener_plant@male@enter"
							local anim = "enter"
							RequestAnimDict(dict)

							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(150)
							end
							TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

							Wait(time)
							lockChanging = false
							TriggerServerEvent("bro:get", "bro:show")
							FreezeEntityPosition(playerPed, false)
						end)
					else
						exports.bf:Notification("~r~Vous ne pouvez pas transformer en véhicule")
					end
				else 
					exports.bf:Notification("~r~Vous sortez votre carte")
				end
			end
		}
	}
	buttons[4] =     {
		text = "Montrer permis",
		exec = {
			callback = function()
				local playerPed = GetPlayerPed(-1)
				if lockChanging == false then
					if not  IsPedInAnyVehicle(playerPed, false) then
						local time = 4000
						TriggerEvent("bf:progressBar:create", time, "Vous sortez votre carte")
						lockChanging = true 
						Citizen.CreateThread(function ()
							FreezeEntityPosition(playerPed, true)
							
							local dict = "amb@world_human_gardener_plant@male@enter"
							local anim = "enter"
							RequestAnimDict(dict)

							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(150)
							end
							TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

							Wait(time)
							lockChanging = false
							TriggerServerEvent("vehicle:permis:get", "bro:permis")
							FreezeEntityPosition(playerPed, false)
						end)
					else
						exports.bf:Notification("~r~Vous ne pouvez pas transformer en véhicule")
					end
				else 
					exports.bf:Notification("~r~Vous sortez votre carte")
				end
			end
		}
	}
	exports.bf:SetMenuButtons("bro-wallet", buttons)
	exports.bf:NextMenu("bro-wallet")
end)

RegisterNetEvent('bro:permis')

AddEventHandler("bro:permis", function(permis) 
	local closestPlayerPed, dist = GetClosestPlayer()
	if closestPlayerPed  ~= -1 and dist < 2 then
		TriggerServerEvent("bro:permis:show", permis, GetPlayerServerId(closestPlayerPed))
	end
end)

RegisterNetEvent('bro:show')

AddEventHandler("bro:show", function(player) 
	local closestPlayerPed, dist = GetClosestPlayer()
	if closestPlayerPed ~= -1 and dist < 2 then
		TriggerServerEvent("bro:card:show", permis, GetPlayerServerId(closestPlayerPed))
	end
end)

RegisterNetEvent('bro:get')

AddEventHandler("bro:get", function(data) 
	firstname = data.firstname
	lastname = data.lastname
	birth = data.birth
	exports.bf:SetMenuValue("bro-wallet-character",
	{
		menuTitle = firstname.." ".. lastname.. " ("..birth.. ")",
	})
	exports.bf:NextMenu("bro-wallet-character")
end)




RegisterNetEvent('bro:set')

AddEventHandler("bro:set", function() 
	exports.bf:SetMenuValue("bro-wallet-character",
	{
		menuTitle = firstname.." ".. lastname.. " ("..birth.. ")",
	})
end)

RegisterNetEvent('bf:account:get')

AddEventHandler("bf:account:get", function(account) 
	account = account
end)

RegisterNetEvent('bf:job')

AddEventHandler("bf:job", function(job)
	CloseMenu()
	SendNUIMessage({
		title = player.firstname.. " " .. player.lastname,
		subtitle = job[1].job.. " (" .. job[1].grade ..")",
		buttons = buttonsCategories,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "playermenu"
	anyMenuOpen.isActive = true
end)

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

function giveToPlayer()
	local closestPlayerPed, dist = GetClosestPlayer()
	print(closestPlayerPed)
	print(dist)
	if closestPlayerPed ~= -1 and dist <=1 then
		TriggerServerEvent("items:give", v.id, 1, GetPlayerServerId(closestPlayerPed))
	else 
		exports.bf:Notification("Pas de joueur à portée")
	end
end


RegisterNetEvent('bf:items')

AddEventHandler("bf:items", function(inventory)
	local buttons = {}
	local weight = 0
	local maxWeight = 100

	for k, v in ipairs (inventory) do
		buttons[k] =     {
			text = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			exec = {
				callback = function() 
					local buttons = {}
					buttons[1] =     {
						text = "Utiliser",
						exec = {
							callback = function() 
								TriggerServerEvent("items:use", v.item, 1)
							end
						},
					}
					buttons[2] =     {
						text = "Donner",
						exec = {
							callback = function() 
								giveToPlayer()
							end
						},
					}
				buttons[3] =     {
						text = "Stocker vehicle",
						exec = {
							callback = function() 
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
												nb = tonumber(exports.bf:OpenTextInput({customTitle = true, title = "Nombre", maxInputLength=10}))
											
												local time = 4000
												TriggerEvent("bf:progressBar:create", time, "Stockage en cours")
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
												exports.bf:Notification("~r~Vous ne pouvez stocker en véhicule")
											end
										else 
											exports.bf:Notification("~r~Stockage en cours")
										end
									else
										exports.bf:Notification("~r~Ce véhicule est fermé")
									end
								else 
									exports.bf:Notification("~r~Pas de véhicule à portée")
								end
							end
						},
					}
					if v.item == 7 then
						buttons[4] =     {
							text = "Commencer la revente",
							exec = {
								callback = function() 
									TriggerEvent("crime:drug:sell:start")
									exports.bf:CloseMenu("bromenu")
								end
							},
						}
						buttons[5] =     {
							text = "Finir la revente",
							exec = {
								callback = function() 
									TriggerEvent("crime:drug:sell:stop")
									exports.bf:CloseMenu("bromenu")
								end
							},
						}
					end
					exports.bf:SetMenuButtons("bro-items-item", buttons)
					exports.bf:NextMenu("bro-items-item")
				end
			},
		}
		weight = weight + (v.amount*v.weight)
	end
	exports.bf:SetMenuButtons("bro-items", buttons)
	if weight > (3/4*maxWeight) then
		exports.bf:SetMenuValue("bro-items", {
			menuTitle = "Poids max ~r~("..weight.."/"..maxWeight..")kg",
		})
	else
		exports.bf:SetMenuValue("bro-items", {
			menuTitle = "Poids max ~g~("..weight.."/"..maxWeight..")kg",
		})
	end
	exports.bf:NextMenu("bro-items")
end)



RegisterNetEvent('vehicle:items:open')

AddEventHandler("vehicle:items:open", function(inventory)
	local buttons = {}
	local weight = 0
	local maxWeight = 100

	for k, v in ipairs (inventory) do
		buttons[k] =     {
			text = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			exec = {
				callback = function() 
					local buttons = {}
					buttons[1] =     {
						text = "Récupérer",
						exec = {
							callback = function() 
								local playerPed = GetPlayerPed(-1)
								if lockGetCar == false then
									if not  IsPedInAnyVehicle(playerPed, false) then
										nb = tonumber(exports.bf:OpenTextInput({customTitle = true, title = "Nombre", maxInputLength=10}))
										local time = 4000
										TriggerEvent("bf:progressBar:create", time, "Stockage en cours")
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
											TriggerServerEvent("item:vehicle:get", v.vehicle_mod, v.id, nb)
										end)
									else
										exports.bf:Notification("~r~Vous ne pouvez stocker en véhicule")
									end
								else 
									exports.bf:Notification("~r~Stockage en cours")
								end
							end
						},
					}
					exports.bf:SetMenuButtons("bro-items-item", buttons)
					exports.bf:NextMenu("bro-items-item")
				end
			},
		}
		weight = weight + (v.amount*v.weight)
	end

	exports.bf:SetMenuButtons("bro-items", buttons)
	if weight > (3/4*maxWeight) then
		exports.bf:SetMenuValue("bro-items", {
			menuTitle = "Poids max ~r~("..weight.."/"..maxWeight..")kg",
		})
	else
		exports.bf:SetMenuValue("bro-items", {
			menuTitle = "Poids max ~g~("..weight.."/"..maxWeight..")kg",
		})
	end
	exports.bf:NextMenu("bro-items")
end)


-- surrender anim
Citizen.CreateThread(function()
    local dict = "missminuteman_1ig_2"
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
    local handsup = false
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 323) then --Start holding X
            if not handsup then
                TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            else
                handsup = false
                ClearPedTasks(GetPlayerPed(-1))
            end
        end
    end
end)


--clothes event
RegisterNetEvent('bromenu:mask')
AddEventHandler('bromenu:mask', function()
	if not lockChanging then
		local time = 2000
		local playerPed = GetPlayerPed(-1)
		TriggerEvent("bf:progressBar:create", time, "Changement en cours")
		lockChanging = true 
		Citizen.CreateThread(function ()
			FreezeEntityPosition(playerPed, true)
			
			local dict = "amb@world_human_gardener_plant@male@enter"
			local anim = "enter"
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(150)
			end
			TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

			Wait(time)
			lockChanging = false 
			TriggerEvent('skinchanger:getSkin', function(skin)
				local clothesSkin = {
				['mask_1'] = 0, ['mask_2'] = 0,
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end)
			FreezeEntityPosition(playerPed, false)
		end)
	else
		exports.bf:Notification("~r~Vous êtes occupé")
	end
end)

RegisterNetEvent('bromenu:koszulka')
AddEventHandler('bromenu:koszulka', function()
	if not lockChanging then
		local time = 2000
		local playerPed = GetPlayerPed(-1)
		TriggerEvent("bf:progressBar:create", time, "Changement en cours")
		lockChanging = true 
		Citizen.CreateThread(function ()
			FreezeEntityPosition(playerPed, true)
			
			local dict = "amb@world_human_gardener_plant@male@enter"
			local anim = "enter"
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(150)
			end
			TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

			Wait(time)
			lockChanging = false 
			TriggerEvent('skinchanger:getSkin', function(skin)
				local clothesSkin = {
					['tshirt_1'] = 15, ['tshirt_2'] = 0,
					['torso_1'] = 15, ['torso_2'] = 0,
					['arms'] = 15, ['arms_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end)
			FreezeEntityPosition(playerPed, false)
		end)
	else
		exports.bf:Notification("~r~Vous êtes occupé")
	end
end)
RegisterNetEvent('bromenu:spodnie')
AddEventHandler('bromenu:spodnie', function()
	if not lockChanging then
		local time = 2000
		local playerPed = GetPlayerPed(-1)
		TriggerEvent("bf:progressBar:create", time, "Changement en cours")
		lockChanging = true 
		Citizen.CreateThread(function ()
			FreezeEntityPosition(playerPed, true)
			
			local dict = "amb@world_human_gardener_plant@male@enter"
			local anim = "enter"
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(150)
			end
			TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

			Wait(time)
			lockChanging = false 
			TriggerEvent('skinchanger:getSkin', function(skin)
				local clothesSkin = {
					['pants_1'] = 21, ['pants_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end)
			FreezeEntityPosition(playerPed, false)
		end)
	else
		exports.bf:Notification("~r~Vous êtes occupé")
	end
end)

RegisterNetEvent('bromenu:buty')
AddEventHandler('bromenu:buty', function()
	if not lockChanging then
		local time = 2000
		local playerPed = GetPlayerPed(-1)
		TriggerEvent("bf:progressBar:create", time, "Changement en cours")
		lockChanging = true 
		Citizen.CreateThread(function ()
			FreezeEntityPosition(playerPed, true)
			
			local dict = "amb@world_human_gardener_plant@male@enter"
			local anim = "enter"
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(150)
			end
			TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

			Wait(time)
			lockChanging = false 
			TriggerEvent('skinchanger:getSkin', function(skin)
				local clothesSkin = {
					['shoes_1'] = 34, ['shoes_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end)
			FreezeEntityPosition(playerPed, false)
		end)
	else
		exports.bf:Notification("~r~Vous êtes occupé")
	end
end)

RegisterNetEvent('bromenu:skin:reset')
AddEventHandler('bromenu:skin:reset', function(skin)
	if not lockChanging then
		local time = 2000
		local playerPed = GetPlayerPed(-1)
		TriggerEvent("bf:progressBar:create", time, "Changement en cours")
		lockChanging = true 
		Citizen.CreateThread(function ()
			FreezeEntityPosition(playerPed, true)
			
			local dict = "amb@world_human_gardener_plant@male@enter"
			local anim = "enter"
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(150)
			end
			TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

			Wait(time)
			lockChanging = false 
			TriggerEvent('skinchanger:loadSkin', json.decode(skin))
			FreezeEntityPosition(playerPed, false)
		end)
	else
		exports.bf:Notification("~r~Vous êtes occupé")
	end
end)


-- On nettoie le caca
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	exports.bf:RemoveMenu("bro")
	exports.bf:RemoveMenu("bro-wallet")
	exports.bf:RemoveMenu("bro-items")
	exports.bf:RemoveMenu("bro-items-item")
	exports.bf:RemoveMenu("bro-wallet-character")
	exports.bf:RemoveMenu("bro-vehicles")
	exports.bf:RemoveMenu("bro-clothes")
end)


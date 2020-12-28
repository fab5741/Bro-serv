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
--	exports.bro_core:SetMenuValue("bro", {
--		menuTitle = job.grade.." "..job.label
--	})
--	exports.bro_core:OpenMenu("bro")

	exports.bro_core:AddMenu("bromenu", {
		Title = "Bromenu",
		Subtitle = job.grade.." "..job.label,
		buttons = { 
			{
				type = "button",
				label = "Portefeuille",
				style = { 
					RightLabel = "",
					LeftBadge = { 
						BadgeTexture  = "mp_medal_bronze" 
					}
				},
			---	actions = {
				--	onSelected = function()
				--		TriggerServerEvent("account:player:liquid:get", "bro_core:liquid")
			--		end
			--	},
				subMenu = "bromenu-wallet"
			},
			{
				type = "button",
				label = "Inventaire",
				actions = {
					onSelected = function()
						TriggerServerEvent("items:get", "bro_core:items")
					end
				},
			},
			{
				type = "button",
				label = "Vehicule",
				openMenu = "bro-vehicle"
			},
			{
				type = "button",
				label = "Vetements",
				style = {
					LeftBadge = "Clothes"
				},
				openMenu = "bro-clothes"
			},
			{
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
			},
		}
	})

	local liquid = 150
	exports.bro_core:AddSubMenu("bromenu-wallet", {
		Title = "Portefeuille",
		parent = "bromenu",
		buttons = {
			{
				type = "button",
				label = "Liquide",
				style = {
					RightLabel = exports.bro_core:Money(liquid)
				},
				actions = {
					onSelected = function()
						local amount = exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})
						exports.bro_core:actionPlayer(2000, "Vous tendez les billets", "amb@prop_human_atm@female@base", "base",
						function()
							TriggerServerEvent("account:liquid:player:give", amount)
						end)
					end
				},
			},
			{
				type = "button",
				label = "Identité",
			},
			{
				type = "button",
				label = "Montrer ma carte d'identité",
				actions = {
					onSelected = function()
						exports.bro_core:actionPlayer(2000, "Vous sortez votre carte", "amb@prop_human_atm@female@base", "base",
						function()
							TriggerServerEvent("bro:get", "bro:show")
						end)
					end
				},
			},
		}
	})
end)

RegisterNetEvent('bro_core:liquid')

AddEventHandler("bro_core:liquid", function(liquid) 
  local buttons = {}
	buttons[1] =     {
		label = "Liquide : " .. liquid.. " $",
	}
	buttons[2] =     {
		label = "Identité",
		actions = {
			onSelected = function()
				TriggerServerEvent("bro:get", "bro:get")
			end
		}
	}
	buttons[3] =     {
		label = "Montrer carte d'identité",
		actions = {
			onSelected = function()
				local playerPed = GetPlayerPed(-1)
				if lockChanging == false then
					if not  IsPedInAnyVehicle(playerPed, false) then
						local time = 4000
						TriggerEvent("bro_core:progressBar:create", time, "Vous sortez votre carte")
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
						exports.bro_core:Notification("~r~Vous ne pouvez pas transformer en véhicule")
					end
				else 
					exports.bro_core:Notification("~r~Vous sortez votre carte")
				end
			end
		}
	}
	buttons[4] =     {
		label = "Montrer permis",
		actions = {
			onSelected = function()
				local playerPed = GetPlayerPed(-1)
				if lockChanging == false then
					if not  IsPedInAnyVehicle(playerPed, false) then
						local time = 4000
						TriggerEvent("bro_core:progressBar:create", time, "Vous sortez votre carte")
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
						exports.bro_core:Notification("~r~Vous ne pouvez pas transformer en véhicule")
					end
				else 
					exports.bro_core:Notification("~r~Vous sortez votre carte")
				end
			end
		}
	}
end)

RegisterNetEvent('bro:permis')

AddEventHandler("bro:permis", function(permis) 
	local closestPlayerPed, dist = exports.bro_core:GetClosestPlayer()
	if closestPlayerPed and dist < 2 then
		TriggerServerEvent("bro:permis:show", permis, GetPlayerServerId(closestPlayerPed))
	end
end)

RegisterNetEvent('bro:show')

AddEventHandler("bro:show", function(player) 
	local closestPlayerPed, dist = exports.bro_core:GetClosestPlayer()
	if closestPlayerPed and dist < 2 then
		TriggerServerEvent("bro:card:show", permis, GetPlayerServerId(closestPlayerPed))
	end
end)

RegisterNetEvent('bro:get')

AddEventHandler("bro:get", function(data) 
	firstname = data.firstname
	lastname = data.lastname
	birth = data.birth
	exports.bro_core:SetMenuValue("bro-wallet-character",
	{
		menuTitle = firstname.." ".. lastname.. " ("..birth.. ")",
	})
	exports.bro_core:NextMenu("bro-wallet-character")
end)




RegisterNetEvent('bro:set')

AddEventHandler("bro:set", function() 
	exports.bro_core:SetMenuValue("bro-wallet-character",
	{
		menuTitle = firstname.." ".. lastname.. " ("..birth.. ")",
	})
end)

RegisterNetEvent('bro_core:account:get')

AddEventHandler("bro_core:account:get", function(account) 
	account = account
end)

function giveToPlayer()
	local closestPlayerPed, dist = exports.bro_core:GetClosestPlayer()
	if closestPlayerPed and dist <=1 then
		TriggerServerEvent("items:give", v.id, 1, GetPlayerServerId(closestPlayerPed))
	else 
		exports.bro_core:Notification("Pas de joueur à portée")
	end
end


RegisterNetEvent('bf:items')

AddEventHandler("bf:items", function(inventory)
	local buttons = {}
	local weight = 0
	local maxWeight = 100

	for k, v in ipairs (inventory) do
		buttons[k] =     {
			label = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			actions = {
				onSelected = function() 
					local buttons = {}
					buttons[1] =     {
						label = "Utiliser",
						actions = {
							onSelected = function() 
								TriggerServerEvent("items:use", v.item, 1)
							end
						},
					}
					buttons[2] =     {
						label = "Donner",
						actions = {
							onSelected = function() 
								giveToPlayer()
							end
						},
					}
				buttons[3] =     {
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
					if v.item == 7 then
						buttons[4] =     {
							label = "Commencer la revente",
							actions = {
								onSelected = function() 
									TriggerEvent("crime:drug:sell:start")
									exports.bro_core:CloseMenu("bromenu")
								end
							},
						}
						buttons[5] =     {
							label = "Finir la revente",
							actions = {
								onSelected = function() 
									TriggerEvent("crime:drug:sell:stop")
									exports.bro_core:CloseMenu("bromenu")
								end
							},
						}
					end
				end
			},
		}
		weight = weight + (v.amount*v.weight)
	end
	if weight > (3/4*maxWeight) then
		exports.bro_core:SetMenuValue("bro-items", {
			menuTitle = "Poids max ~r~("..weight.."/"..maxWeight..")kg",
		})
	else
		exports.bro_core:SetMenuValue("bro-items", {
			menuTitle = "Poids max ~g~("..weight.."/"..maxWeight..")kg",
		})
	end
	exports.bro_core:NextMenu("bro-items")
end)



RegisterNetEvent('vehicle:items:open')

AddEventHandler("vehicle:items:open", function(inventory)
	local buttons = {}
	local weight = 0
	local maxWeight = 100

	for k, v in ipairs (inventory) do
		buttons[k] =     {
			label = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			actions = {
				onSelected = function() 
					local buttons = {}
					buttons[1] =     {
						label = "Récupérer",
						actions = {
							onSelected = function() 
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
				end
			},
		}
		weight = weight + (v.amount*v.weight)
	end

	if weight > (3/4*maxWeight) then
		exports.bro_core:SetMenuValue("bro-items", {
			menuTitle = "Poids max ~r~("..weight.."/"..maxWeight..")kg",
		})
	else
		exports.bro_core:SetMenuValue("bro-items", {
			menuTitle = "Poids max ~g~("..weight.."/"..maxWeight..")kg",
		})
	end
	exports.bro_core:NextMenu("bro-items")
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
		TriggerEvent("bro_core:progressBar:create", time, "Changement en cours")
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
		exports.bro_core:Notification("~r~Vous êtes occupé")
	end
end)

RegisterNetEvent('bromenu:koszulka')
AddEventHandler('bromenu:koszulka', function()
	if not lockChanging then
		local time = 2000
		local playerPed = GetPlayerPed(-1)
		TriggerEvent("bro_core:progressBar:create", time, "Changement en cours")
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
		exports.bro_core:Notification("~r~Vous êtes occupé")
	end
end)
RegisterNetEvent('bromenu:spodnie')
AddEventHandler('bromenu:spodnie', function()
	if not lockChanging then
		local time = 2000
		local playerPed = GetPlayerPed(-1)
		TriggerEvent("bro_core:progressBar:create", time, "Changement en cours")
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
		exports.bro_core:Notification("~r~Vous êtes occupé")
	end
end)

RegisterNetEvent('bromenu:buty')
AddEventHandler('bromenu:buty', function()
	if not lockChanging then
		local time = 2000
		local playerPed = GetPlayerPed(-1)
		TriggerEvent("bro_core:progressBar:create", time, "Changement en cours")
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
		exports.bro_core:Notification("~r~Vous êtes occupé")
	end
end)

RegisterNetEvent('bromenu:skin:reset')
AddEventHandler('bromenu:skin:reset', function(skin)
	if not lockChanging then
		local time = 2000
		local playerPed = GetPlayerPed(-1)
		TriggerEvent("bro_core:progressBar:create", time, "Changement en cours")
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
		exports.bro_core:Notification("~r~Vous êtes occupé")
	end
end)


-- On nettoie le caca
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	exports.bro_core:RemoveMenu("bromenu-wallet")
	exports.bro_core:RemoveMenu("bromenu")
end)


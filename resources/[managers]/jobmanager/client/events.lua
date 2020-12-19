RegisterNetEvent("job:set")

-- source is global here, don't add to function
AddEventHandler('job:set', function (grade)
    TriggerServerEvent("job:set", grade)
end)

RegisterNetEvent("job:getCar")
AddEventHandler('job:getCar', function(car, carId)
	exports.bf:spawnCar(car, true, nil, true)
    TriggerServerEvent("vehicle:set:id", carId, vehicle)
end)

RegisterNetEvent('job:process:open')

AddEventHandler("job:process:open", function(job)  
	job = job[1]	
	buttons = {}
	for k, v in pairs(config.jobs[job.name].process[zone].items) do

		buttons[#buttons+1] = {
			text = "Traitement "..v.label,
			exec = {
				callback = function()
					local playerPed = GetPlayerPed(-1)
					if lockCollect == false then
						if not  IsPedInAnyVehicle(playerPed, false) then
							local time = 4000
							TriggerEvent("bf:progressBar:create", time, "Transformation en cours")
							lockCollect = true 
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
								lockCollect = false
								TriggerServerEvent('items:process', v.type,  v.amount, v.to,  v.amountTo, 'Vous avez transformé : '..v.label.. " X "..v.amount) 
								FreezeEntityPosition(playerPed, false)
							end)
						else
							exports.bf:Notification("~r~Vous ne pouvez pas transformer en véhicule")
						end
					else 
						exports.bf:Notification("~r~Tranformation en cours")
					end
				end
			},
		}
	end
	exports.bf:SetMenuButtons(zoneType..zone, buttons)
	exports.bf:OpenMenu(zoneType..zone)
end)

RegisterNetEvent('job:sell:open')

AddEventHandler("job:sell:open", function(job)  
	job = job[1]	
	buttons = {}
	for k, v in pairs(config.jobs[job.name].sell.items) do
		buttons[#buttons+1] = {
			text = "Vente de " ..v.label,
			exec = {
				callback = function()
					local playerPed = GetPlayerPed(-1)
					if lockCollect == false then
							local time = 4000
							TriggerEvent("bf:progressBar:create", time, "Revente en cours")
							lockCollect = true 
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
								lockCollect = false
								nbSold = nbSold +1
								if nbSold >= config.jobs[job.name].sell.maxSold then
									nbSold = 0
									removeSell(job.name)
									beginSell(job.name)
									exports.bf:Notification("J'en ai trop, va vendre ailleurs.")
								end
								TriggerServerEvent("job:sell", v.type, job.job, v.price, 'Vous avez vendu : '..v.label.. " X "..v.amount.." pour ~g~".. v.price.." $")
							end)
					else 
						exports.bf:Notification("~r~Vente en cours")
					end
				end
			},
		}
	end
	exports.bf:SetMenuButtons("sell", buttons)
	exports.bf:OpenMenu("sell")
end)



RegisterNetEvent('job:collect:open')

AddEventHandler("job:collect:open", function(job)  
	job = job[1]	
	buttons = {}
	for k, v in pairs(config.jobs[job.name].collect[zone].items) do
		buttons[#buttons+1] = {
			text = "Collecter "..v.label,
			exec = {
				callback = function()
					local playerPed = GetPlayerPed(-1)
					if lockCollect == false then
						if not  IsPedInAnyVehicle(playerPed, false) then
							local time = 4000
							TriggerEvent("bf:progressBar:create", time, "Collecte")
							lockCollect = true 
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
								lockCollect = false
								TriggerServerEvent('items:add', v.type,  v.amount, 'Vous avez collecté : '..v.label.. " X "..v.amount) 
							end)
						else
							exports.bf:Notification("~r~Vous ne pouvez pas récolter en véhicule")
						end
					else 
						exports.bf:Notification("~r~Collecte en cours")
					end
				end
			},
		}
	end
	exports.bf:SetMenuButtons(zoneType..zone, buttons)
	exports.bf:OpenMenu(zoneType..zone)
end)

RegisterNetEvent('job:parking:open')

AddEventHandler("job:parking:open", function(job)  
	job = job[1]
	TriggerServerEvent("vehicle:parking:get:all", "job:parking", job.name)
end)

RegisterNetEvent('job:safe:open2')

AddEventHandler("job:safe:open2", function(amount) 
	-- todo: test if chef de service
	exports.bf:SetMenuValue("safes-account"..zone, {
		menuTitle = "Compte ~r~"..amount.. " $"
	})
	TriggerServerEvent("job:isChef", "job:safe:open3")
end)

RegisterNetEvent('job:safe:open3')

AddEventHandler("job:safe:open3", function(isChef) 
	if isChef then
		exports.bf:NextMenu("safes-account"..zone)
	else 
		exports.bf:Notification("~r~Vous n'etes pas abilité")
	end
end)


RegisterNetEvent('job:item:open')

AddEventHandler("job:item:open", function(job) 
	job = job[1].job
	TriggerServerEvent("job:items:get", "job:item:open2", job)
end)

RegisterNetEvent('job:item:open:store')

AddEventHandler("job:item:open:store", function(items) 
	buttons = {}
	for k, v in pairs(items) do
		buttons[#buttons+1] = {
			text = v.label .. " X " ..v.amount,
			exec = {
				callback = function() 
					TriggerServerEvent("job:items:store", v.item, 1)
				end
			},
		}
	end
	exports.bf:SetMenuButtons("safes-items-store", buttons)
	exports.bf:NextMenu("safes-items-store")
end)

RegisterNetEvent('job:item:open2')

AddEventHandler("job:item:open2", function(items) 
	buttons = {}
	buttons[#buttons+1] = {
		text = "Stocker item",
		exec = {
			callback = function() 
				TriggerServerEvent("items:get", "job:item:open:store")
			end
		},
	}
	for k, v in pairs(items) do
		buttons[#buttons+1] = {
			text = v.label .. " X " ..v.amount,
			exec = {
				callback = function() 
					local buttons = {}
					buttons[1] =     {
						text = "Retirer",
						exec = {
							callback = function() 
								TriggerServerEvent("job:items:withdraw", v.item, 1)
							end
						},
					}
					exports.bf:SetMenuButtons("safes-items-item", buttons)
					exports.bf:NextMenu("safes-items-item")
				end
			},
		}
	end
	exports.bf:SetMenuButtons("safes-items", buttons)
	exports.bf:NextMenu("safes-items")
end)

RegisterNetEvent('job:safe:open')

AddEventHandler("job:safe:open", function(job) 
	job = job[1].job
	TriggerServerEvent("account:job:get", "job:safe:open2", job)		
end)


RegisterNetEvent('job:open:menu')

AddEventHandler("job:open:menu", function(job)  
	job = job[1] 
	if job.name == "lspd" or job.name == "lsms" or job.name == "farm" or job.name == "wine"  or job.name == "taxi"  or job.name=="bennys" or job.name=="newspapers" then
		exports.bf:OpenMenu(job.name)
	end
end)


RegisterNetEvent('job:parking')

AddEventHandler("job:parking", function(vehicles)  
	local buttons = {

	}
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label,
			exec = {
				callback = function() 
					TriggerServerEvent("job:parking:get", "job:parking:get", v.id)
				end
			},
	}
	end
	exports.bf:SetMenuButtons(zoneType..zone, buttons)
	exports.bf:OpenMenu(zoneType..zone)
end)

RegisterNetEvent('job:parking:get')

AddEventHandler("job:parking:get", function(name, id)  

	local playerPed = PlayerPedId() -- get the local player ped

	if not IsPedInAnyVehicle(playerPed) then
		exports.bf:spawnCar(name, true, nil, true)
		exports.bf:CloseMenu(zoneType..zone)
	end
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end

RegisterNetEvent('job:lsms:revive')

AddEventHandler("job:lsms:revive", function(isBleedout)  
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	RespawnPed(playerPed, coords, 0.0)

	TriggerEvent("player:alive")
	if isBleedout then
		TriggerEvent('skinchanger:getSkin', function(skin)
			local clothesSkin = {
				['mask_1'] = 0, ['mask_2'] = 0,
				['tshirt_1'] = 15, ['tshirt_2'] = 0,
				['torso_1'] = 15, ['torso_2'] = 0,
				['arms'] = 15, ['arms_2'] = 0,
				['pants_1'] = 21, ['pants_2'] = 0,
				['shoes_1'] = 34, ['shoes_2'] = 0
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)
		local PlayerPed = PlayerPedId()
		FreezeEntityPosition(PlayerPedId(), true)
		if not HasAnimDictLoaded("missfbi1") then
			RequestAnimDict("missfbi1")
	
			while not HasAnimDictLoaded("missfbi1") do
				Citizen.Wait(1)
			end
		end
		SetEntityCoords(PlayerPed, vector3(304.0592956543,-573.39636230469,29.836771011353))
		Wait(20)
		TaskPlayAnim(PlayerPed, 'missfbi1', 'cpr_pumpchest_idle', 8.0, -8.0, -1, 1, 0, false, false, false)
		exports.bf:Notification("~g~F1~w~ pour vous relever")		
		FreezeEntityPosition(PlayerPedId(), false)
	end
	
	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
	Wait(0)
end)



RegisterNetEvent('jobs:assurance:vehicles')

AddEventHandler("jobs:assurance:vehicles", function(vehicles)
	local buttons = {}
	for k, v in ipairs (vehicles) do
		local parking = v.parking

		if v.parking == "" then
			parking = "Volé"
		elseif v.parking == "depot" then
			parking = "Fourrière"
		elseif v.parking == "global" then
			parking = "Parking global"
		end
		buttons[k] =     {
			text =  v.label.. " ("..parking..")",
			exec = {
				callback = function() 
					if v.parking == "" then
						local playerPed = PlayerPedId() -- get the local player ped

						if not IsPedInAnyVehicle(playerPed) then
							currentVehicle = v.id
							exports.bf:spawnCar(v.name, true, nil, true)
							TriggerServerEvent("account:money:sub", 10)
							exports.bf:Notification("L'assurance vous rembourse le véhicule volé. Vous payez ~g~ 10 $ ~s~ de franchise.")
							exports.bf:CloseMenu("bro-vehicles")
						else
							exports.bf:Notification("Vous êtes déjà dans un véhicle")
						end
					end
				end
			},
		}
	end
	exports.bf:SetMenuButtons("jobs-vehicles", buttons)
	exports.bf:NextMenu("jobs-vehicles")
end)

RegisterNetEvent('jobs:service:manage')

AddEventHandler("jobs:service:manage", function(grade)
	if grade >= 4 then
		exports.bf:NextMenu("service")
	else
		exports.bf:Notification("~r~Vous n'êtes pas chef de service !")
	end
end)

--lifecycle
RegisterNetEvent("jobs:refresh")

AddEventHandler("jobs:refresh", function(job)
	refresh(job[1])
end)

RegisterNetEvent("jobs:recruit")

AddEventHandler("jobs:recruit", function(job) 
	recruitClosestPlayer(job)
end)


RegisterNetEvent('weapon:store')

AddEventHandler("weapon:store", function(weapons)  
	buttons = {}
	for k, v in pairs(weapons) do
		if v.weapon == "0x1B06D571" then
			v.label = "9mm"
		elseif v.weapon == "0x8BB05FD7" then
			v.label = "Lampe torche"
		elseif v.weapon == "0x3656C8C1" then
			v.label = "Tazer"
		elseif v.weapon == "0x678B81B1" then
			v.label = "Matraque"
		elseif v.weapon == "0x1D073A89" then
			v.label = "Fusil à pompe"
		elseif v.weapon == "0x2BE6766B" then
			v.label = "SMG"
		end
		buttons[#buttons+1] = {
			text = v.label..' x '..v.amount,
			exec = {
				callback = function()
					TriggerServerEvent("weapon:get", "weapon:store:store", v.weapon)
				end
			},
		}
	end
	exports.bf:SetMenuButtons("weapon-store", buttons)
	exports.bf:NextMenu("weapon-store")
end)

RegisterNetEvent('weapon:store:store')

AddEventHandler("weapon:store:store", function(isOk, weapon)  
	if isOk then
		if weapon == "0x1B06D571" then
			weapon = "WEAPON_PISTOL"
		elseif weapon == "0x8BB05FD7" then
			weapon = "WEAPON_FLASHLIGHT"
		elseif weapon == "0x3656C8C1" then
			weapon = "WEAPON_STUNGUN"
		elseif weapon == "0x678B81B1" then
			weapon = "WEAPON_NIGHTSTICK"
		elseif weapon == "0x1D073A89" then
			weapon = "WEAPON_PUMPSHOTGUN"
		elseif weapon == "0x2BE6766B" then
			weapon = "WEAPON_SMG"
		end
		GiveWeaponToPed(
			GetPlayerPed(-1) --[[ Ped ]], 
			weapon --[[ Hash ]], 
			100 --[[ integer ]], 
			false --[[ boolean ]], 
			true --[[ boolean ]]
		)
	else
		exports.bf:Notification("~r~ L'armurerie est vide")
	end
end)


RegisterNetEvent('job:removeWeapons')
AddEventHandler('job:removeWeapons', function()
    RemoveAllPedWeapons(PlayerPedId(), true)
end)


RegisterNetEvent('job:handcuff')
AddEventHandler('job:handcuff', function()
	handCuffed = not handCuffed
	if(handCuffed) then
		exports.bf:AdvancedNotification({
			text = "Menotté",
			title = "LSPD",
			icon = "CHAR_AGENT14",
		})
	else
		exports.bf:AdvancedNotification({
			text = "Démenotté",
			title = "LSPD",
			icon = "CHAR_AGENT14",
		})
		cuffing = false
		ClearPedTasksImmediately(PlayerPedId())
	end
end)


local lockAskingFine = false
RegisterNetEvent('job:payFines')
AddEventHandler('job:payFines', function(amount, sender)
	Citizen.CreateThread(function()
		
		if(lockAskingFine ~= true) then
			lockAskingFine = true
			local notifReceivedAt = GetGameTimer()
			exports.bf:Notification("Amende de " .. amount .. "$. Y pour accepter")
			while(true) do
				Wait(0)
				
				if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) then
					TriggerServerEvent('job:finesETA', sender, 2)
					exports.bf:Notification("Amende expirée")
					lockAskingFine = false
					break
				end
				
				if IsControlPressed(1, config.bindings.accept_fine) then
					TriggerServerEvent("account:player:add", "", -amount)
					exports.bf:Notification("Amende de " .. amount .. "$ payée")
					TriggerServerEvent('job:finesETA', sender, 0)
					lockAskingFine = false
					break
				end
				
				if IsControlPressed(1, config.bindings.refuse_fine) then
					TriggerServerEvent('job:finesETA', sender, 3)
					lockAskingFine = false
					break
				end
			end
		else
			TriggerServerEvent('job:finesETA', sender, 1)
		end
	end)
end)

lockAskingFacture = false
RegisterNetEvent('job:facture')
AddEventHandler('job:facture', function(amount, motif, job, sender)
	Citizen.CreateThread(function()
		
		if(lockAskingFacture ~= true) then
			lockAskingFacture = true
			local notifReceivedAt = GetGameTimer()
			exports.bf:AdvancedNotification({
				text = "Facture de " .. amount .. "$. Y pour accepter, N pour refuser",
				title = job,
				icon = "char_AGENT14"
			})
			while(true) do
				Wait(0)
				
				if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) then
					TriggerServerEvent('job:facture2', sender, 2)
					exports.bf:Notification("Facture expirée")
					lockAskingFacture = false
					break
				end
				
				if IsControlPressed(1, config.bindings.accept_fine) then
					TriggerServerEvent("account:player:liquid:get:facture", "job:facture:accept", amount, sender)
					lockAskingFacture = false
					break
				end
				
				if IsControlPressed(1, config.bindings.refuse_fine) then
					TriggerServerEvent('job:facture2', sender, 3)
					lockAskingFacture = false
					break
				end
			end
		else
			TriggerServerEvent('job:finesETA', sender, 1)
		end
	end)
end)

RegisterNetEvent("job:facture:accept")
AddEventHandler("job:facture:accept", function(liquid, amount, sender, job)
	amount = tonumber(amount)
	if liquid >= amount then
		TriggerServerEvent("account:player:liquid:add", "", amount*(-1))
		TriggerServerEvent("account:job:add", "", job, amount*(1-tva), true)
		TriggerServerEvent("account:job:add", "", 1, amount*tva, true)
		exports.bf:Notification("Facture de " .. amount .. "$ payée")
		TriggerServerEvent('job:facture2', sender, 0)
	else
		exports.bf:Notification("Vous n'avez pas assez d'argent")
		TriggerServerEvent('job:facture2', sender, 3)
	end
	lockAskingFacture = false
end)
RegisterNetEvent('bf:open')

AddEventHandler("bf:open", function(job) 
	job = job[1]
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
				TriggerServerEvent("bro:get", "bro:show")
			end
		}
	}
	buttons[4] =     {
		text = "Montrer permis",
		exec = {
			callback = function()
				TriggerServerEvent("vehicle:permis:get", "bro:permis")
			end
		}
	}
	exports.bf:SetMenuButtons("bro-wallet", buttons)
	exports.bf:NextMenu("bro-wallet")
end)

RegisterNetEvent('bro:permis')

AddEventHandler("bro:permis", function(permis) 
	peds = exports.bf:GetPlayerServerIdInDirection(5.0)
	if peds ~= false then
		TriggerServerEvent("bro:permis:show", permis, peds)
	end
end)

RegisterNetEvent('bro:show')

AddEventHandler("bro:show", function(player) 
	peds = exports.bf:GetPlayerServerIdInDirection(5.0)
	if peds ~= false then
		TriggerServerEvent("bro:permis:show", permis, peds)
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
								local distMin = 18515151515151515151515
								local current = nil

								
								local player, dist = GetClosestPlayer()
								if dist < 10  then
									TriggerServerEvent("items:give", v.id, 1, player)
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
	TriggerEvent('skinchanger:getSkin', function(skin)
		print("MASK CHANGE")
		local clothesSkin = {
		['mask_1'] = 0, ['mask_2'] = 0,
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)

RegisterNetEvent('bromenu:koszulka')
AddEventHandler('bromenu:koszulka', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		print(skin)
		local clothesSkin = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 15, ['torso_2'] = 0,
		['arms'] = 15, ['arms_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)
RegisterNetEvent('bromenu:spodnie')
AddEventHandler('bromenu:spodnie', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		local clothesSkin = {
		['pants_1'] = 21, ['pants_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)

RegisterNetEvent('bromenu:buty')
AddEventHandler('bromenu:buty', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		local clothesSkin = {
		['shoes_1'] = 34, ['shoes_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)

RegisterNetEvent('bromenu:skin:reset')
AddEventHandler('bromenu:skin:reset', function(skin)
		TriggerEvent('skinchanger:loadSkin', json.decode(skin))
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
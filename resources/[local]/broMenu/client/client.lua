firstname = "John"
lastname = "Smith"
birth = "00/00/0000"

CharacterDad = 0
CharacterMom = 0

local anyMenuOpen = {
	menuName = "",
	isActive = false
}

function CloseMenu()
	SendNUIMessage({
		action = "close"
	})
	
	anyMenuOpen.menuName = ""
	anyMenuOpen.isActive = false
end

Citizen.CreateThread(function()
	exports.bf:AddMenu("bro", {
		title = "Bro Menu",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Portefeuille",
				exec = {
					callback = function()
						TriggerServerEvent("account:liquid", "bf:liquid")
					end
				},
			},
			{
				text = "Inventaire",
				exec = {
					callback = function()
						TriggerServerEvent("items:get", "bf:items")
					end
				},
			},
			{
				text = "Vehicules",
				exec = {
					callback = function()
						print("trigger")
						TriggerServerEvent("vehicles:get:all", "bf:vehicles")
					end
				},
			},
		},
	})
	exports.bf:AddMenu("bro-wallet", {
		title = "Portefeuille",
		position = 1,
	})
	exports.bf:AddMenu("bro-items", {
		title = "Inventaire",
		position = 1,
	})
	exports.bf:AddMenu("bro-items-item", {
		title = "Item",
		position = 1,
	})
	exports.bf:AddMenu("bro-wallet-character", {
		title = "Personnage",
		menuTitle = "Léon Paquin (17/05/1992)",
		position = 1,
		buttons = {
			{
				text = "Nom",
				exec = {
					callback = function()
						lastname = exports.bf:OpenTextInput({ title="Nom", maxInputLength=25, customTitle=true})
						TriggerServerEvent("bro:set", "lastname", lastname, "bro:set")
					end
				}
			},
			{
				text = "Prénom",
				exec = {
					callback = function()
						firstname = exports.bf:OpenTextInput({ title="Prénom", maxInputLength=25, customTitle=true})
						TriggerServerEvent("bro:set", "firstname", firstname, "bro:set")
					end
				}
			},
			{
				text = "Date de naissance",
				exec = {
					callback = function()
						birth = exports.bf:OpenTextInput({ title="Date de naissance (01/01/1999)", maxInputLength=10, customTitle=true})
						TriggerServerEvent("bro:set", "birth", birth, "bro:set")
					end
				}
			},
		},
	})
	exports.bf:AddMenu("bro-vehicles", {
		title = "Vehicules",
		position = 1,
	})

	-- main loop
  while true do
    Citizen.Wait(0)
	if (IsControlJustPressed(1, 288)) then
		if exports.bf:MenuIsOpen("bro") then
			exports.bf:CloseMenu("bro") 
		else
			print("ok")
			TriggerServerEvent("job:get", "bf:open")
		end
	end
  end
end)
RegisterNetEvent('bf:open')

AddEventHandler("bf:open", function(job) 
	job = job[1]
	exports.bf:SetMenuValue("bro", {
		menuTitle = job.job
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
	exports.bf:SetMenuButtons("bro-wallet", buttons)
	exports.bf:NextMenu("bro-wallet")
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
-------- MENUUUUUUUUUUU

local buttonsCategories = {}
local buttonsWallet = {}
local buttonsItems = {}
local buttonsUseItem = {}


function load_menu()
	buttonsCategories = {}
	buttonsWallet = {}
	buttonsItems = {}
	buttonsUseItem = {}

	for k in ipairs (buttonsCategories) do
		buttonsCategories [k] = nil
	end
	
	--Categories
	buttonsCategories[#buttonsCategories+1] = {name = "Portefeuille", func = "OpenWalletMenu", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = "Inventaire", func = "OpenItemsMenu", params = ""}
end

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

function TogglePlayerMenu()
	TriggerServerEvent("account:liquid", "bf:liquid")
	TriggerServerEvent("account:get", "bf:account:get")
	if((anyMenuOpen.menuName ~= "playermenu" and anyMenuOpen.menuName ~= "playermenu-wallet" and anyMenuOpen.menuName ~= "playermenu-items") and not anyMenuOpen.isActive) then
		TriggerServerEvent("job:get", "bf:job")
	else
		if((anyMenuOpen.menuName ~= "playermenu" and anyMenuOpen.menuName ~= "playermenu-wallet" and anyMenuOpen.menuName ~= "playermenu-items" ) and  anyMenuOpen.isActive) then
			CloseMenu()
			TogglePlayerMenu()
		else
			CloseMenu()
		end
	end
end

function BackMenuPolice()
	if(anyMenuOpen.menuName == "playermenu-wallet" or anyMenuOpen.menuName == "playermenu-items") then
		CloseMenu()
		TogglePlayerMenu()
	else
		CloseMenu()
		OpenCitizenMenu()
	end
end

function OpenWalletMenu()
	CloseMenu()
	SendNUIMessage({
		title = "Portefeuille",
		--subtitle = "Liquid " .. liquid .. " / Sale " .. dirty,
		subtitle = "Liquid " .. liquid.." $".. " / Compte " .. account.." $",
		buttons = buttonsWallet,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "playermenu-wallet"
	anyMenuOpen.isActive = true
end



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
								TriggerServerEvent("items:use", v.id, 1)
							end
						},
					}
					buttons[2] =     {
						text = "Donner",
						exec = {
							callback = function() 
								local distMin = 18515151515151515151515
								local current = nil

								
								local player = GetClosestPlayer()
								local me = GetPlayerServerId(i)
								local coords = GetEntityCoords(GetPlayerPed(i))
								local mycoords = GetEntityCoords(GetPlayerPed(player))
								local dist = Vdist(mycoords, coords)
								print(player)
								print(me)
								print(coords)
								print(mycoords)
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
	end
	exports.bf:SetMenuButtons("bro-items", buttons)
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


RegisterNetEvent('bf:vehicles')

AddEventHandler("bf:vehicles", function(vehicles)
	print("YO")
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
							local vehicleName = v.name
							currentVehicle = v.id
							-- check if the vehicle actually exists
							if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
								TriggerEvent('chat:addMessage', {
									args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
								})
								return
							end

							-- load the model
							RequestModel(vehicleName)

							-- wait for the model to load
							while not HasModelLoaded(vehicleName) do
								Wait(500) -- often you'll also see Citizen.Wait
							end
							local pos = GetEntityCoords(playerPed) -- get the position of the local player ped

							ClearAreaOfVehicles(pos.x, pos.y, pos.z, 5.0, false, false, false, false, false)
							-- create the vehicle
							local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

							-- set the player ped into the vehicle's driver seat
							SetPedIntoVehicle(playerPed, vehicle, -1)

							-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
							SetEntityAsNoLongerNeeded(vehicle)

							-- release the model
							SetModelAsNoLongerNeeded(vehicleName)

							TriggerServerEvent("account:money:sub", 100)
													
							exports.bf:Notification("L'assurance vous rembourse le véhicule volé. Vous payez ~g~ 100 $ ~s~ de franchise.")
							exports.bf:CloseMenu("bro-vehicles")
						else
							exports.bf:Notification("Vous êtes déjà dans un véhicle")
						end
					end
				end
			},
		}
	end
	exports.bf:SetMenuButtons("bro-vehicles", buttons)
	exports.bf:NextMenu("bro-vehicles")
end)
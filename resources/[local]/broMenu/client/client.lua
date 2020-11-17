local liquid = 0
local account = 0
local dirty = 0
local player = {
	firstname = "Bro",
	lastname = "Inconnu",
}
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
	TriggerServerEvent("bf:player:get", "bf:player:get")
	TriggerServerEvent("account:liquid", "bf:liquid")
	TriggerServerEvent("account:get", "bf:account:get")
  while true do
    Citizen.Wait(0)

    --TriggerEvent("bf:items")
    --if (IsControlJustPressed(1, 288)) then
     -- TriggerServerEvent("account:liquid", "bf:liquid")
    --end

	if (IsControlJustPressed(1, 288)) then
	  TriggerServerEvent("account:liquid", "bf:liquid")
	  TriggerServerEvent("account:get", "bf:account:get")
      load_menu()
      TogglePlayerMenu()
	end
  end
end)


RegisterNUICallback('sendAction', function(data, cb)
	_G[data.action](data.params)
    cb('ok')
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)	
		if(anyMenuOpen.isActive) then
			DisableControlAction(1, 21)
			DisableControlAction(1, 140)
			DisableControlAction(1, 141)
			DisableControlAction(1, 142)

			SetDisableAmbientMeleeMove(PlayerPedId(), true)

			if (IsControlJustPressed(1,172)) then
				SendNUIMessage({
					action = "keyup"
				})
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (IsControlJustPressed(1,173)) then
				SendNUIMessage({
					action = "keydown"
				})
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (anyMenuOpen.menuName == "cloackroom") then
				if IsControlJustPressed(1, 176) then
					SendNUIMessage({
						action = "keyenter"
					})

					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					Citizen.Wait(500)
					CloseMenu()
				end
			elseif (IsControlJustPressed(1,176)) then
				SendNUIMessage({
					action = "keyenter"
				})
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (IsControlJustPressed(1,177)) then
				if(anyMenuOpen.menuName == "playermenu" or anyMenuOpen.menuName == "cloackroom" or anyMenuOpen.menuName == "garage") then
					CloseMenu()
				elseif(anyMenuOpen.menuName == "armory") then
					CloseArmory()					
				elseif(anyMenuOpen.menuName == "armory-weapon_list") then
					BackArmory()
				else
					BackMenuPolice()
				end
			end
		else
			EnableControlAction(1, 21)
			EnableControlAction(1, 140)
			EnableControlAction(1, 141)
			EnableControlAction(1, 142)
		end
  	end
end)

RegisterNetEvent('bf:player:get')

AddEventHandler("bf:player:get", function(playere) 
	player = playere
end)

RegisterNetEvent('bf:liquid')

AddEventHandler("bf:liquid", function(liquide) 
  liquid = liquide
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

	print(account)
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


RegisterNetEvent('bf:items')

AddEventHandler("bf:items", function(inventory)
	CloseMenu()
	buttonsItems = {}
	for k, v in ipairs (inventory) do
		buttonsItems[k] = {name = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )', func = "OpenUseItem", params = v['id']}
	end
	SendNUIMessage({
		title = "Inventaire",
		subtitle = "Inventaire",
		buttons = buttonsItems,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "playermenu-items"
	anyMenuOpen.isActive = true
end)

function OpenItemsMenu()
	CloseMenu()
	
	TriggerServerEvent("items:get", "bf:items")
end

function OpenUseItem(Id)
	CloseMenu()
	buttonsUseItem = {}
	buttonsUseItem[#buttonsUseItem+1] = {name = "Use", func = "useItem", params = Id}
	--TODO
	--buttonsUseItem[#buttonsUseItem+1] = {name = "Give", func = "", params = ""}
	--buttonsUseItem[#buttonsUseItem+1] = {name = "Drop", func = "", params = ""}

	SendNUIMessage({
		title = "Item",
		subtitle = "Item",
		buttons = buttonsUseItem,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "playermenu-wallet"
	anyMenuOpen.isActive = true
end

function useItem(Id)
	--TODO : Really use item
	TriggerServerEvent("items:use", Id, 1)
end

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
	
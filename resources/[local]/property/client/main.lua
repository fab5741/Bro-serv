local OwnedProperties, Blips, CurrentActionData = {}, {}, {}
local CurrentProperty, CurrentPropertyOwner, LastProperty, LastPart, CurrentAction, CurrentActionMsg
local firstSpawn, hasChest, hasAlreadyEnteredMarker = true, false, false

exports.bf:AddMenu("property-owned", {
    title = "Propriété",
})

exports.bf:AddMenu("property", {
    title = "Propriété",
    buttons = {
        {
            text = "Acheter",
			exec=  {
				callback = function ()
					TriggerServerEvent('property:buyProperty', LastProperty)
				end
			},
        },
        {
            text = "Louer",
			exec=  {
				callback = function ()
					TriggerServerEvent('property:rentProperty', LastProperty)
				end
			},
        },
    },
})



exports.bf:AddMenu("property-gateway-bought", {
    title = "Propriétés achetés",
})

exports.bf:AddMenu("property-gateway-avaiable", {
    title = "Propriétés libres",
})


exports.bf:AddMenu("property-gateway", {
    title = "Propriété Portail",
    buttons = {
        {
			text = "Propriétés achetés",
			exec = {
				callback = function()
					local gatewayProperties = GetGatewayProperties(LastProperty)
					local buttons = {}
					for i=1, #gatewayProperties, 1 do
						if PropertyIsOwned(gatewayProperties[i]) then
							buttons[#buttons+1] = {
								text = gatewayProperties[i].label,
								callback = function () 
								end
							}
						end
					end
					exports.bf:SetMenuValue({
						buttons = buttons
					})
					exports.bf:NextMenu("property-gateway-bought")
				end
			},
		},
		{
			text = "Propriétés libres",
			exec = {
				callback = function()
					local gatewayProperties = GetGatewayProperties(LastProperty)
					local buttons = {}
				
					for i=1, #gatewayProperties, 1 do
						if not PropertyIsOwned(gatewayProperties[i]) then
							buttons[#buttons+1] = {
								text = gatewayProperties[i].label,
								callback = function () 
								end
							}
						end
					end
					exports.bf:SetMenuValue({
						buttons = buttons
					})
					exports.bf:NextMenu("property-gateway-avaiable")
				end
			},
        },
    },
})


-- only used when script is restarting mid-session
RegisterNetEvent('property:sendProperties')
AddEventHandler('property:sendProperties', function(properties)
	Config.Properties = properties
	CreateBlips()
	TriggerServerEvent('property:getOwnedProperties', 'property:sendProperties2')
end)
RegisterNetEvent('property:sendProperties2')
AddEventHandler('property:sendProperties2', function(properties)
	print(properties)
	for k,v in ipairs(properties) do
		SetPropertyOwned(v.name, true, v.rented)
	end
end)

function DrawSub(text, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandPrint(time, 1)
end

function CreateBlips()
	for i=1, #Config.Properties, 1 do
		local property = Config.Properties[i]
		--TODO use bf
		if property.entering then
			Blips[property.name] = AddBlipForCoord(property.entering.x, property.entering.y, property.entering.z)

			SetBlipSprite (Blips[property.name], 369)
			SetBlipDisplay(Blips[property.name], 4)
			SetBlipScale  (Blips[property.name], 1.0)
			SetBlipAsShortRange(Blips[property.name], true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName('Propriété')
			EndTextCommandSetBlipName(Blips[property.name])
		end
	end
end

function GetProperties()
	return Config.Properties
end

function GetProperty(name)
	
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end

function GetGateway(property)
	for i=1, #Config.Properties, 1 do
		local property2 = Config.Properties[i]

		if property2.isGateway and property2.name == property.gateway then
			return property2
		end
	end
end

function GetGatewayProperties(property)
	local properties = {}

	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].gateway == property.name then
			table.insert(properties, Config.Properties[i])
		end
	end

	return properties
end

function EnterProperty(name, owner)
	local property       = GetProperty(name)
	local playerPed      = PlayerPedId()
	CurrentProperty      = property
	CurrentPropertyOwner = owner

	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name ~= name then
			Config.Properties[i].disabled = true
		end
	end

	TriggerServerEvent('property:saveLastProperty', name)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		for i=1, #property.ipls, 1 do
			RequestIpl(property.ipls[i])

			while not IsIplActive(property.ipls[i]) do
				Citizen.Wait(0)
			end
		end

		SetEntityCoords(playerPed, property.inside.x, property.inside.y, property.inside.z)
		DoScreenFadeIn(800)
		DrawSub(property.label, 5000)
	end)
	exports.bf:CloseMenu("property")
end

function ExitProperty(name)
	local property  = GetProperty(name)
	local playerPed = PlayerPedId()
	local outside   = nil
	CurrentProperty = nil

	if property.isSingle then
		outside = property.outside
	else
		outside = GetGateway(property).outside
	end

	TriggerServerEvent('property:deleteLastProperty')

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		SetEntityCoords(playerPed, outside.x, outside.y, outside.z)

		for i=1, #property.ipls, 1 do
			RemoveIpl(property.ipls[i])
		end

		for i=1, #Config.Properties, 1 do
			Config.Properties[i].disabled = false
		end

		DoScreenFadeIn(800)
	end)
end

function SetPropertyOwned(name, owned, rented)
	local property     = GetProperty(name)
	local entering     = nil
	local enteringName = nil

	if property.isSingle then
		entering     = property.entering
		enteringName = property.name
	else
		local gateway = GetGateway(property)
		entering      = gateway.entering
		enteringName  = gateway.name
	end

	if owned then
		OwnedProperties[name] = rented
		RemoveBlip(Blips[enteringName])

		Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
		SetBlipSprite(Blips[enteringName], 357)
		SetBlipAsShortRange(Blips[enteringName], true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName('property')
		EndTextCommandSetBlipName(Blips[enteringName])
	else
		OwnedProperties[name] = nil
		local found = false

		for k,v in pairs(OwnedProperties) do
			local _property = GetProperty(k)
			local _gateway  = GetGateway(_property)

			if _gateway then
				if _gateway.name == enteringName then
					found = true
					break
				end
			end
		end

		if not found then
			RemoveBlip(Blips[enteringName])

			Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
			SetBlipSprite(Blips[enteringName], 369)
			SetBlipAsShortRange(Blips[enteringName], true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName('free_prop')
			EndTextCommandSetBlipName(Blips[enteringName])
		end
	end
end

function PropertyIsOwned(property)
	return OwnedProperties[property.name] ~= nil
end

function OpenPropertyMenu(property)
	if PropertyIsOwned(property) then
		exports.bf:SetMenuValue("property-owned", {
			buttons = {
				{
					text = "Entrer : "..property.name,
					exec=  {
						callback = function ()
							TriggerEvent('instance:create', 'property', {property = property.name, owner = 1})
						end
					},
				},
				{
					text = "Vendre",
					exec=  {
						callback = function ()
							TriggerServerEvent('property:removeOwnedProperty', LastProperty)
						end
					},
				},
			}
		})
		exports.bf:OpenMenu("property-owned")
	else
		exports.bf:OpenMenu("property")
	end
end

function OpenGatewayMenu(property)
	LastProperty = property
	exports.bf:OpenMenu("property-gateway")
end

function OpenGatewayOwnedPropertiesMenu(property)
	local gatewayProperties = GetGatewayProperties(property)
	local elements = {}

	for i=1, #gatewayProperties, 1 do
		if PropertyIsOwned(gatewayProperties[i]) then
			table.insert(elements, {
				label = gatewayProperties[i].label,
				value = gatewayProperties[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_owned_properties', {
		title    = property.name .. ' - ' .. 'owned_properties',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		local elements = {{label = 'enter', value = 'enter'}}

		if not Config.EnablePlayerManagement then
			table.insert(elements, {label = 'leave', value = 'leave'})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_owned_properties_actions', {
			title    = data.current.label,
			align    = 'top-left',
			elements = elements
		}, function(data2, menu2)
			menu2.close()

			if data2.current.value == 'enter' then
				TriggerEvent('instance:create', 'property', {property = data.current.value, owner = ESX.GetPlayerData().identifier})
				ESX.UI.Menu.CloseAll()
			elseif data2.current.value == 'leave' then
				TriggerServerEvent('property:removeOwnedProperty', data.current.value)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGatewayAvailablePropertiesMenu(property)
	local gatewayProperties = GetGatewayProperties(property)
	local elements = {}

	for i=1, #gatewayProperties, 1 do
		if not PropertyIsOwned(gatewayProperties[i]) then
			table.insert(elements, {
				label = gatewayProperties[i].label,
				value = gatewayProperties[i].name,
				buyPrice = gatewayProperties[i].price,
				rentPrice = gatewayProperties[i].price / Config.RentModifier
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_available_properties', {
		title    = property.name .. ' - ' .. 'available_properties',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_available_properties_actions', {
			title    = property.label .. ' - ' .. 'available_properties',
			align    = 'top-left',
			elements = {
				{label = 'buy', data.current.buyPrice, value = 'buy'},
				{label = _'rent', data.current.rentPrice, value = 'rent'}
		}}, function(data2, menu2)
			menu.close()
			menu2.close()

			if data2.current.value == 'buy' then
				TriggerServerEvent('property:buyProperty', data.current.value)
			elseif data2.current.value == 'rent' then
				TriggerServerEvent('property:rentProperty', data.current.value)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenRoomMenu(property, owner)
	local entering = nil
	local elements = {{label = 'invite_player',  value = 'invite_player'}}

	if property.isSingle then
		entering = property.entering
	else
		entering = GetGateway(property).entering
	end

	if CurrentPropertyOwner == owner then
		table.insert(elements, {label = 'player_clothes', value = 'player_dressing'})
		table.insert(elements, {label = 'remove_cloth', value = 'remove_cloth'})
	end

	table.insert(elements, {label = 'remove_object',  value = 'room_inventory'})
	table.insert(elements, {label = 'deposit_object', value = 'player_inventory'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
		title    = property.label,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'invite_player' then

			local playersInArea = ESX.Game.GetPlayersInArea(entering, 10.0)
			local elements      = {}

			for i=1, #playersInArea, 1 do
				if playersInArea[i] ~= PlayerId() then
					table.insert(elements, {label = GetPlayerName(playersInArea[i]), value = playersInArea[i]})
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_invite', {
				title    = property.label .. ' - ' ..'invite',
				align    = 'top-left',
				elements = elements,
			}, function(data2, menu2)
				TriggerEvent('instance:invite', 'property', GetPlayerServerId(data2.current.value), {property = property.name, owner = owner})
				ESX.ShowNotification('you_invited', GetPlayerName(data2.current.value))
			end, function(data2, menu2)
				menu2.close()
			end)

		elseif data.current.value == 'player_dressing' then

			ESX.TriggerServerCallback('property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = property.label .. ' - ' .. 'player_clothes',
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'remove_cloth' then

			ESX.TriggerServerCallback('property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = property.label .. ' - ' .. 'remove_cloth',
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('property:removeOutfit', data2.current.value)
					ESX.ShowNotification('removed_cloth')
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'room_inventory' then
			OpenRoomInventoryMenu(property, owner)
		elseif data.current.value == 'player_inventory' then
			OpenPlayerInventoryMenu(property, owner)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'room_menu'
		CurrentActionMsg  = 'press_to_menu'
		CurrentActionData = {property = property, owner = owner}
	end)
end

function OpenRoomInventoryMenu(property, owner)
	ESX.TriggerServerCallback('property:getPropertyInventory', function(inventory)
		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = 'dirty_money', ESX.Math.GroupDigits(inventory.blackMoney),
				type = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				index = i
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_inventory', {
			title    = property.label .. ' - ' .. 'inventory',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.type == 'item_weapon' then
				menu.close()

				TriggerServerEvent('property:getItem', owner, data.current.type, data.current.value, data.current.index)
				ESX.SetTimeout(300, function()
					OpenRoomInventoryMenu(property, owner)
				end)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_item_count', {
					title = 'amount'
				}, function(data2, menu)

					local quantity = tonumber(data2.value)
					if quantity == nil then
						ESX.ShowNotification('amount_invalid')
					else
						menu.close()

						TriggerServerEvent('property:getItem', owner, data.current.type, data.current.value, quantity)
						ESX.SetTimeout(300, function()
							OpenRoomInventoryMenu(property, owner)
						end)
					end
				end, function(data2,menu)
					menu.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, owner)
end

function OpenPlayerInventoryMenu(property, owner)
	ESX.TriggerServerCallback('property:getPlayerInventory', function(inventory)
		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = 'dirty_money', inventory.blackMoney,
				type  = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = weapon.label .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				ammo  = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_inventory', {
			title    = property.label .. ' - ' ..'inventory',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.type == 'item_weapon' then
				menu.close()
				TriggerServerEvent('property:putItem', owner, data.current.type, data.current.value, data.current.ammo)

				ESX.SetTimeout(300, function()
					OpenPlayerInventoryMenu(property, owner)
				end)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
					title = 'amount'
				}, function(data2, menu2)
					local quantity = tonumber(data2.value)

					if quantity == nil then
						ESX.ShowNotification('amount_invalid')
					else
						menu2.close()

						TriggerServerEvent('property:putItem', owner, data.current.type, data.current.value, tonumber(data2.value))
						ESX.SetTimeout(300, function()
							OpenPlayerInventoryMenu(property, owner)
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

AddEventHandler('instance:loaded', function()
	TriggerEvent('instance:registerType', 'property', function(instance)
		EnterProperty(instance.data.property, instance.data.owner)
	end, function(instance)
		ExitProperty(instance.data.property)
	end)
end)

--AddEventHandler('spawn:spawn', function()
--	if firstSpawn then
--		--	ESX.TriggerServerCallback('property:getLastProperty', function(propertyName)
--				if propertyName then
	--				if propertyName ~= '' then
--						local property = GetProperty(propertyName)
---
--						for i=1, #property.ipls, 1 do
--							RequestIpl(property.ipls[i])
--
--							while not IsIplActive(property.ipls[i]) do
--								Citizen.Wait(0)
--							end
--						end

			--			TriggerEvent('instance:create', 'property', {property = propertyName, owner = ESX.GetPlayerData().identifier})
--			end
--		end
--		firstSpawn = false
--	end
--end)

AddEventHandler('property:getProperties', function(cb)
	cb(GetProperties())
end)

AddEventHandler('property:getProperty', function(name, cb)
	cb(GetProperty(name))
end)

AddEventHandler('property:getGateway', function(property, cb)
	cb(GetGateway(property))
end)

RegisterNetEvent('property:setPropertyOwned')
AddEventHandler('property:setPropertyOwned', function(name, owned, rented)
	SetPropertyOwned(name, owned, rented)
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(instance)
	if instance.type == 'property' then
		TriggerEvent('instance:enter', instance)
	end
end)

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance)
	if instance.type == 'property' then
		local property = GetProperty(instance.data.property)
		local isHost   = GetPlayerFromServerId(instance.host) == PlayerId()
		local isOwned  = false

		if PropertyIsOwned(property) == true then
			isOwned = true
		end

		if isOwned or not isHost then
			hasChest = true
		else
			hasChest = false
		end
	end
end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(instance, player)
	if player == instance.host then
		TriggerEvent('instance:leave')
	end
end)

AddEventHandler('property:hasEnteredMarker', function(name, part)
	local property = GetProperty(name)

	if part == 'entering' then
		if property.isSingle then
			CurrentAction     = 'property_menu'
			CurrentActionMsg  = 'press_to_menu'
			CurrentActionData = {property = property}
		else
			CurrentAction     = 'gateway_menu'
			CurrentActionMsg  = 'press_to_menu'
			CurrentActionData = {property = property}
		end
	elseif part == 'exit' then
		CurrentAction     = 'room_exit'
		CurrentActionMsg  = 'press_to_exit'
		CurrentActionData = {propertyName = name}
	elseif part == 'roomMenu' then
		CurrentAction     = 'room_menu'
		CurrentActionMsg  = 'press_to_menu'
		CurrentActionData = {property = property, owner = CurrentPropertyOwner}
	end
end)

-- Enter / Exit marker events & Draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep = false, true
		local currentProperty, currentPart

		for i=1, #Config.Properties, 1 do
			local property = Config.Properties[i]

			-- Entering
			if property.entering and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.entering.x, property.entering.y, property.entering.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.entering.x, property.entering.y, property.entering.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					--ESX.Game.Utils.DrawText3D(property.entering, property.name, 2)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker      = true
					currentProperty = property.name
					currentPart     = 'entering'
				end
			end

			-- Exit
			if property.exit and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.exit.x, property.exit.y, property.exit.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.exit.x, property.exit.y, property.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker      = true
					currentProperty = property.name
					currentPart     = 'exit'
				end
			end

			-- Room menu
			if property.roomMenu and hasChest and not property.disabled then
				local distance = GetDistanceBetweenCoords(coords, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.MarkerType, property.roomMenu.x, property.roomMenu.y, property.roomMenu.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.RoomMenuMarkerColor.r, Config.RoomMenuMarkerColor.g, Config.RoomMenuMarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end

				if distance < Config.MarkerSize.x then
					isInMarker      = true
					currentProperty = property.name
					currentPart     = 'roomMenu'
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker or (isInMarker and (LastProperty ~= currentProperty or LastPart ~= currentPart) ) then
			hasAlreadyEnteredMarker = true
			LastProperty            = currentProperty
			LastPart                = currentPart

			TriggerEvent('property:hasEnteredMarker', currentProperty, currentPart)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('property:hasExitedMarker', LastProperty, LastPart)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			exports.bf:Notification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				print(CurrentAction)
				if CurrentAction == 'property_menu' then
					OpenPropertyMenu(CurrentActionData.property)
				elseif CurrentAction == 'gateway_menu' then
					if Config.EnablePlayerManagement then
						OpenGatewayOwnedPropertiesMenu(CurrentActionData.property)
					else
						OpenGatewayMenu(CurrentActionData.property)
					end
				elseif CurrentAction == 'room_menu' then
					OpenRoomMenu(CurrentActionData.property, CurrentActionData.owner)
				elseif CurrentAction == 'room_exit' then
					ExitProperty(LastProperty)
					TriggerEvent('instance:leave')
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

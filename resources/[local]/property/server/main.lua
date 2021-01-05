
function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end

function SetPropertyOwned(name, price, rented, source)
    local discord = exports.bro_core:GetDiscordFromSource(source)
	local property = GetProperty(propertyName)
	MySQL.ready(function()
		MySQL.Async.fetchScalar("select id from players where discord = @discord", {
			['@discord'] = discord,
		}, function(owner)
			MySQL.Async.execute('INSERT INTO owned_properties (name, price, rented, owner) VALUES (@name, @price, @rented, @owner)', {
			['@name']   = name,
			['@price']  = price,
			['@rented'] = (rented and 1 or 0),
			['@owner']  = owner
			}, function(rowsChanged)
					TriggerClientEvent('property:setPropertyOwned', source, name, true, rented)
				if rented then
					TriggerClientEvent("bro_core:Notification", source, "Loué pour  ~g~"..price.."$")
				else
					TriggerClientEvent("bro_core:Notification", source, "Acheté pour ~g~"..price.."$")
				end
			end)
		end)
	end)
end

function RemoveOwnedProperty(name, noPay)
	local sourcevalue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourcevalue)
	MySQL.Async.fetchAll('SELECT owned_properties.id, rented, price FROM owned_properties, players WHERE name = @name AND owner = players.id and players.discord = @discord', {
		['@name']  = name,
		['@discord'] = discord
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE FROM owned_properties WHERE id = @id', {
				['@id'] = result[1].id
			}, function(rowsChanged)
				if not noPay then
					if result[1].rented == 1 then
						TriggerClientEvent("bro_core:Notification", sourcevalue, "Vous avez déménagé")
					else
						local sellPrice = result[1].price * 0.8
						print(sellPrice)
						TriggerClientEvent("bro_core:Notification", sourcevalue, "Vous avez déménagé. Vous recevez "..exports.bro_core:Money(sellPrice))
						TriggerClientEvent("account:player:add", sellPrice)
					end
				end
			end)
		end
	end)
end

MySQL.ready(function()
	Citizen.Wait(1500)

	MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)

		for i=1, #properties, 1 do
			local entering  = nil
			local exit      = nil
			local inside    = nil
			local outside   = nil
			local isSingle  = nil
			local isRoom    = nil
			local isGateway = nil
			local roomMenu  = nil

			if properties[i].entering then
				entering = json.decode(properties[i].entering)
			end

			if properties[i].exit then
				exit = json.decode(properties[i].exit)
			end

			if properties[i].inside then
				inside = json.decode(properties[i].inside)
			end

			if properties[i].outside then
				outside = json.decode(properties[i].outside)
			end

			if properties[i].is_single == 0 then
				isSingle = false
			else
				isSingle = true
			end

			if properties[i].is_room == 0 then
				isRoom = false
			else
				isRoom = true
			end

			if properties[i].is_gateway == 0 then
				isGateway = false
			else
				isGateway = true
			end

			if properties[i].room_menu then
				roomMenu = json.decode(properties[i].room_menu)
			end

			table.insert(Config.Properties, {
				name      = properties[i].name,
				label     = properties[i].label,
				entering  = entering,
				exit      = exit,
				inside    = inside,
				outside   = outside,
				ipls      = json.decode(properties[i].ipls),
				gateway   = properties[i].gateway,
				isSingle  = isSingle,
				isRoom    = isRoom,
				isGateway = isGateway,
				roomMenu  = roomMenu,
				price     = properties[i].price
			})
		end

		TriggerClientEvent('property:sendProperties', -1, Config.Properties)
	end)
end)

RegisterNetEvent("property:getOwnedProperties")
AddEventHandler('property:getOwnedProperties', function(cb)
	local sourceValue = source
	MySQL.Async.fetchAll('SELECT * FROM owned_properties', {}, function(result)
		local properties = {}

		for i=1, #result, 1 do
			table.insert(properties, {
				id     = result[i].id,
				name   = result[i].name,
				label  = GetProperty(result[i].name).label,
				price  = result[i].price,
				rented = (result[i].rented == 1 and true or false),
				owner  = result[i].owner
			})
		end
		TriggerClientEvent(cb, sourceValue, properties)
	end)
end)

AddEventHandler('property:setPropertyOwned', function(name, price, rented)
	SetPropertyOwned(name, price, rented, sourceValue)
end)

AddEventHandler('property:removeOwnedProperty', function(name, owner)
	RemoveOwnedProperty(name, owner)
end)

RegisterNetEvent('property:rentProperty')
AddEventHandler('property:rentProperty', function(propertyName)
	local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local property = GetProperty(propertyName)
	local rent     = property.price / Config.RentModifier

	SetPropertyOwned(propertyName, rent, true, sourceValue)
end)

RegisterNetEvent('property:buyProperty')
AddEventHandler('property:buyProperty', function(propertyName)
	local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local property = GetProperty(propertyName)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord',
			{
				['@discord'] = discord
			}, function(liquid)
				if property.price <= liquid then
					MySQL.Async.execute('update players set liquid = liquid-@price where discord = @discord',
					{
						['@discord'] = discord,
						['@price'] = property.price,
					}, function(row)
					-- todo - remove player money
						SetPropertyOwned(propertyName, property.price, false, sourceValue)
					end)
				else
					TriggerClientEvent("bro_core:Notification", sourceValue, "Vous n'avez pas assez d'argent")
				end
		end)
	end)
end)

RegisterNetEvent('property:removeOwnedProperty')
AddEventHandler('property:removeOwnedProperty', function(propertyName)
	RemoveOwnedProperty(propertyName)
end)

AddEventHandler('property:removeOwnedPropertyIdentifier', function(propertyName, identifier)
	RemoveOwnedProperty(propertyName)
end)

RegisterNetEvent('property:saveLastProperty')
AddEventHandler('property:saveLastProperty', function(property)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.Async.execute('UPDATE players SET last_property = @last_property WHERE discord = @discord', {
		['@last_property'] = property,
		['@discord']    = discord
	})
end)

RegisterNetEvent('property:deleteLastProperty')
AddEventHandler('property:deleteLastProperty', function()
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.Async.execute('UPDATE players SET last_property = NULL WHERE discord = @discord', {
		['@discord']    = discord
	})
end)

RegisterNetEvent('property:getItem')
AddEventHandler('property:getItem', function(owner, type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then
		TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayerOwner.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)

			-- is there enough in the property?
			if count > 0 and inventoryItem.count >= count then
				-- can the player carry the said amount of x item?
				if xPlayer.canCarryItem(item, count) then
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					xPlayer.showNotification(_U('have_withdrawn', count, inventoryItem.label))
				else
					xPlayer.showNotification(_U('player_cannot_hold'))
				end
			else
				xPlayer.showNotification(_U('not_enough_in_property'))
			end
		end)
	elseif type == 'item_account' then
		TriggerEvent('esx_addonaccount:getAccount', 'property_' .. item, xPlayerOwner.identifier, function(account)
			if account.money >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
			else
				xPlayer.showNotification(_U('amount_invalid'))
			end
		end)
	elseif type == 'item_weapon' then
		TriggerEvent('esx_datastore:getDataStore', 'property', xPlayerOwner.identifier, function(store)
			local storeWeapons = store.get('weapons') or {}
			local weaponName   = nil
			local ammo         = nil

			for i=1, #storeWeapons, 1 do
				if storeWeapons[i].name == item then
					weaponName = storeWeapons[i].name
					ammo       = storeWeapons[i].ammo

					table.remove(storeWeapons, i)
					break
				end
			end

			store.set('weapons', storeWeapons)
			xPlayer.addWeapon(weaponName, ammo)
		end)
	end
end)

RegisterNetEvent('property:putItem')
AddEventHandler('property:putItem', function(owner, type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then
		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayerOwner.identifier, function(inventory)
				xPlayer.removeInventoryItem(item, count)
				inventory.addItem(item, count)
				xPlayer.showNotification(_U('have_deposited', count, inventory.getItem(item).label))
			end)
		else
			xPlayer.showNotification(_U('invalid_quantity'))
		end
	elseif type == 'item_account' then
		if xPlayer.getAccount(item).money >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

			TriggerEvent('esx_addonaccount:getAccount', 'property_' .. item, xPlayerOwner.identifier, function(account)
				account.addMoney(count)
			end)
		else
			xPlayer.showNotification(_U('amount_invalid'))
		end
	elseif type == 'item_weapon' then
		if xPlayer.hasWeapon(item) then
			xPlayer.removeWeapon(item)

			TriggerEvent('esx_datastore:getDataStore', 'property', xPlayerOwner.identifier, function(store)
				local storeWeapons = store.get('weapons') or {}

				table.insert(storeWeapons, {
					name = item,
					ammo = count
				})

				store.set('weapons', storeWeapons)
			end)
		end
	end
end)



RegisterNetEvent('property:removeOutfit')
AddEventHandler('property:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)
RegisterServerEvent('skin:save')
AddEventHandler('skin:save', function(skin)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.execute('UPDATE players SET skin = @skin WHERE discord = @discord', {
			['@skin'] = json.encode(skin),
			['@discord'] = discord
		})
	end)
end)

RegisterServerEvent('skin:clothes:save')
AddEventHandler('skin:clothes:save', function(clothes)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.execute('UPDATE players SET clothes = @clothes WHERE discord = @discord', {
			['@clothes'] = json.encode(clothes),
			['@discord'] = discord
		})
	end)
end)

RegisterNetEvent('skin:getPlayerSkin')

AddEventHandler('skin:getPlayerSkin', function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT skin FROM players WHERE discord = @discord', {
			['@discord'] = discord
		}, function(skin)
			TriggerClientEvent(cb, sourceValue, skin)
		end)
	end)
end)
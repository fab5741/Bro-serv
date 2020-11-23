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

RegisterNetEvent('skin:getPlayerSkin')

AddEventHandler('skin:getPlayerSkin', function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.Async.fetchAll('SELECT skin,  x, y, z FROM players WHERE discord = @discord', {
		['@discord'] = discord
	}, function(res)
		if res== nil or res[1] == nil then
			MySQL.Async.insert("INSERT INTO `players` (`id`, `discord`, `x`, `y`, `z`, `job_grade`, `onDuty`, `skin`, `liquid`, `firstname`, `lastname`, `birth`, `permis`) VALUES (NULL, @discord, 0, 0, 12, '1', '0', NULL,  '10', '', '', '', 0)", {
				['@discord'] = discord
			}, function(id)
				MySQL.Async.execute("INSERT INTO `accounts` (`id`, `player`, `amount`) VALUES (NULL, @id, 100)", {
					['@id'] =  id,
				}, function(res)
					MySQL.Async.fetchAll('SELECT * FROM players WHERE discord = @discord', {
						['@discord'] = discord
					}, function(res)
						TriggerClientEvent(cb, sourceValue, res[1])
					end)
				end)
			end)
		else
		TriggerClientEvent(cb, sourceValue, res[1])
		end
	end)
end)
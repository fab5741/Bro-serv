RegisterServerEvent('skin:save')
AddEventHandler('skin:save', function(skin)
	local sourceValue = source

	for k,v in pairs(GetPlayerIdentifiers(sourceValue))do			
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
		steamid = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
		license = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
		xbl  = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
		ip = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
		discord = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
		liveid = v
		end
	end
	MySQL.Async.execute('UPDATE players SET skin = @skin WHERE fivem = @fivem', {
		['@skin'] = json.encode(skin),
		['@fivem'] = discord
	})
end)

RegisterNetEvent('skin:getPlayerSkin')

AddEventHandler('skin:getPlayerSkin', function(cb)
	local sourceValue = source
	for k,v in pairs(GetPlayerIdentifiers(sourceValue))do			
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
		steamid = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
		license = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
		xbl  = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
		ip = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
		discord = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
		liveid = v
		end
	end

	MySQL.Async.fetchAll('SELECT skin,  x, y, z FROM players WHERE fivem = @fivem', {
		['@fivem'] = discord
	}, function(res)
		if res== nil or res[1] == nil then
			print("pas de joueur, pas de chocolat")
			MySQL.Async.insert("INSERT INTO `players` (`id`, `fivem`, `x`, `y`, `z`, `job_grade`, `onDuty`, `skin`, `liquid`, `firstname`, `lastname`, `birth`, `permis`) VALUES (NULL, @fivem, 0, 0, 12, '1', '0', NULL,  '10', '', '', '', 0)", {
				['@fivem'] = discord
			}, function(id)
				MySQL.Async.execute("INSERT INTO `accounts` (`id`, `player`, `amount`) VALUES (NULL, @id, 100)", {
					['@id'] =  id,
				}, function(res)
					MySQL.Async.fetchAll('SELECT * FROM players WHERE fivem = @fivem', {
						['@fivem'] = discord
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
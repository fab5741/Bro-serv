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


function getSkin(cb, source)
	MySQL.Async.fetchAll('SELECT skin, x, y, z FROM players WHERE fivem = @fivem', {
		['@fivem'] = discord
	}, function(res)
		local user, skin = res[1]

		local jobSkin = {
		--	skin_male   = xPlayer.job.skin_male,
		--	skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end
		if user.x then
			x = json.decode(user.x)
		end
		if user.y then
			y = json.decode(user.y)
		end
		if user.z then
			z = json.decode(user.z)
		end

		TriggerClientEvent(cb, source, skin, jobSkin, x, y, z)
	end)
end

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

	MySQL.Async.fetchAll('SELECT skin, x, y, z FROM players WHERE fivem = @fivem', {
		['@fivem'] = discord
	}, function(res)
		if res== nil or res[1] == nil then
			print("pas de joueur, pas de chocolat")
			MySQL.Async.execute("INSERT INTO `players` (`id`, `fivem`, `x`, `y`, `z`, `job_grade`, `onDuty`, `skin`, `liquid`, `firstname`, `lastname`, `birth`, `permis`) VALUES (NULL, @fivem, '-1038.703', '-2683.085', '12', '1', '0', '', '100', '', '', '', 0)", {
				['@fivem'] = discord
			}, function(affectedrows)
				if affectedrows > 0 then
					MySQL.Async.fetchScalar("select id from players where fivem= @fivem", {
						['@fivem'] =  discord,
					}, function(id)
						print(id)
							MySQL.Async.execute("INSERT INTO `accounts` (`id`, `player`, `amount`) VALUES (NULL, @id, 1000)", {
								['@id'] =  id,
							}, function(res)
								getSkin(cb, sourceValue)
							end)
						end)
				else
					print("c'est la merde")
				end
			end)
		else
			getSkin(cb, sourceValue)
		end
	end)
end)
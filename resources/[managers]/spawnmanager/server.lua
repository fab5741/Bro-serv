-- source is global here, don't add to function
AddEventHandler('playerDropped', function (reason)
    print('Player ' .. GetPlayerName(source) .. ' dropped (Reason: ' .. reason .. ')')

    print("ping")
    TriggerEvent("player:saveCoords", source)
end)

RegisterNetEvent("player:saveCoordsServer")

-- source is global here, don't add to function
AddEventHandler('player:saveCoordsServer', function(name, pos)
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
    local nameValue = name
    MySQL.ready(function ()
        MySQL.Async.execute('UPDATE players SET x= @x, y =@y, z = @z, gameId = @gameId WHERE discord = @discord', {
            ['@discord'] = discord, ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z, ['@gameId'] = sourceValue
        })
      end)
end)



RegisterNetEvent("player:spawnPlayerFromLastPos")

-- source is global here, don't add to function
AddEventHandler('player:spawnPlayerFromLastPos', function()
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
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select x,y,z, skin, clothes from players WHERE discord = @discord',
        {['@discord'] =  discord}, function(res)
			if(res[1]) then
             --   TriggerClientEvent("spawn:spawn", sourceValue, res[1].x, res[1].y, res[1].z, res[1].skin, res[1].clothes)
            else
               -- TriggerClientEvent("spawn:spawn", sourceValue, -1038.709, -2683.085, 8, "{}", "{}")
            end
            end)
      end)
end)

RegisterNetEvent("player:get")

-- source is global here, don't add to function
AddEventHandler('player:get', function(cb)
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
    local cbe = cb
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT * FROM players WHERE discord = @discord', {
            ['@discord'] =  discord
        }, function(res)
            if res and res[1] then
               TriggerClientEvent(cbe, sourceValue, res[1])
            else
                TriggerClientEvent(cbe, sourceValue)
            end
        end)
    end)
end)
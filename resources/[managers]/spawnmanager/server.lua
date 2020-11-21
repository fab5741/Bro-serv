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
     --   MySQL.Async.fetchAll('select x,y,z from players WHERE fivem = @fivem', {['fivem'] =  discord}, function(res)
       --     if(not res[1]) then
         --       MySQL.Async.execute('INSERT INTO players (`id`, `fivem`, `name`, `x`, `y`, `z`, `job_grade`, `onDuty`, `skin`, `liquid`, `firstname`, `lastname`, `sex`, `birth`) VALUES (NULL, @fivem, @name, x= @x, y =@y, z = @z, 1, 0, "",0, "","", 0, "1990-08-04")', {
           --         ['fivem'] = discord, ['name'] = nameValue, ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z
             --   })
            --else
              --  MySQL.Async.execute('UPDATE players SET x= @x, y =@y, z = @z WHERE fivem = @fivem', {
                --    ['fivem'] = discord, ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z
                --})
            --end
        --end)
        MySQL.Async.execute('UPDATE players SET x= @x, y =@y, z = @z WHERE fivem = @fivem', {
            ['fivem'] = discord, ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z
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
        MySQL.Async.fetchAll('select x,y,z, skin from players WHERE fivem = @fivem',
        {['fivem'] =  discord}, function(res)
			if(res[1]) then
                TriggerClientEvent("player:spawnLastPos", sourceValue, res[1].x, res[1].y, res[1].z, res[1].skin)
            else
                TriggerClientEvent("player:spawnLastPos", sourceValue, -1038.709, -2683.085, 8)
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
        MySQL.Async.fetchAll('SELECT * FROM players WHERE fivem = @fivem', {
            ['@fivem'] =  discord
        }, function(res)
            if res and res[1] then
               TriggerClientEvent(cbe, sourceValue, res[1])
            else
                TriggerClientEvent(cbe, sourceValue)
            end
        end)
    end)
end)
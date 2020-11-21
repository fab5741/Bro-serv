RegisterNetEvent('bro:get')
AddEventHandler('bro:get', function(cb)
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
		MySQL.Async.fetchAll('select * from players where fivem = @fivem',
        {['fivem'] =  discord},
        function(res)
            if res and res[1] then
                TriggerClientEvent(cb, sourceValue, res[1])
            end
        end)
    end)
end)

RegisterNetEvent('bro:set')
AddEventHandler('bro:set', function(field, value, cb)
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

	-- TODO generic field

	if field == "firstname" then
		MySQL.ready(function ()
			MySQL.Async.execute('UPDATE players SET firstname = @value where fivem = @fivem',
			{['@fivem'] =  discord, ['field'] = field,  ['value'] = value},
			function(affectedRows)
				if affectedRows > 0 then
					TriggerClientEvent(cb, sourceValue)
				end
			end)
		end)
	elseif field == "lastname" then
		MySQL.ready(function ()
			MySQL.Async.execute('UPDATE players SET lastname = @value where fivem = @fivem',
			{['@fivem'] =  discord, ['field'] = field,  ['value'] = value},
			function(affectedRows)
				if affectedRows > 0 then
					TriggerClientEvent(cb, sourceValue)
				end
			end)
		end)
	elseif field == "birth" then 
		MySQL.ready(function ()
			MySQL.Async.execute('UPDATE players SET birth = @value where fivem = @fivem',
			{['@fivem'] =  discord, ['field'] = field,  ['value'] = value},
			function(affectedRows)
				if affectedRows > 0 then
					TriggerClientEvent(cb, sourceValue)
				end
			end)
		end)
	end

end)




RegisterNetEvent('bro:skin:get')
AddEventHandler('bro:skin:get', function(cb)
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

	print("skin get")
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select skin from players where fivem = @fivem',
		{['@fivem'] =  discord},
		function(res)
				TriggerClientEvent(cb, sourceValue, res)
		end)
	end)
end)

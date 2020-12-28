RegisterNetEvent('bro:get')
AddEventHandler('bro:get', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select * from players where discord = @discord',
        {['discord'] =  discord},
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
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	-- TODO generic field
	if field == "firstname" then
		MySQL.ready(function ()
			MySQL.Async.execute('UPDATE players SET firstname = @value where discord = @discord',
			{['@discord'] =  discord, ['field'] = field,  ['value'] = value},
			function(affectedRows)
				if affectedRows > 0 then
					TriggerClientEvent(cb, sourceValue)
				end
			end)
		end)
	elseif field == "lastname" then
		MySQL.ready(function ()
			MySQL.Async.execute('UPDATE players SET lastname = @value where discord = @discord',
			{['@discord'] =  discord, ['field'] = field,  ['value'] = value},
			function(affectedRows)
				if affectedRows > 0 then
					TriggerClientEvent(cb, sourceValue)
				end
			end)
		end)
	elseif field == "birth" then 
		MySQL.ready(function ()
			MySQL.Async.execute('UPDATE players SET birth = @value where discord = @discord',
			{['@discord'] =  discord, ['field'] = field,  ['value'] = value},
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
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select skin from players where discord = @discord',
		{['@discord'] =  discord},
		function(res)
				TriggerClientEvent(cb, sourceValue, res)
		end)
	end)
end)



RegisterNetEvent('bro:permis:show')
AddEventHandler('bro:permis:show', function(permis, peds)
	 for k,v  in pairs(peds) do
		TriggerClientEvent("bf:Notification", v, "Permis de conduire")
		if permis < 1 then
			TriggerClientEvent("bf:Notification", v, "~r~"..permis.." points")
		else
			TriggerClientEvent("bf:Notification", v,"~g~"..permis.." points")
		end
	 end
end)



RegisterNetEvent('bro:card:show')
AddEventHandler('bro:card:show', function(permis, peds)
	 for k,v  in pairs(peds) do
		TriggerClientEvent("bf:Notification", v, "Carte d'identité")
		TriggerClientEvent("bf:Notification", v, player.firstname.." "..player.lastname)
		TriggerClientEvent("bf:Notification", v, player.birth)
	end
end)

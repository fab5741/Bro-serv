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
			print(res)
				TriggerClientEvent(cb, sourceValue, res)
		end)
	end)
end)



RegisterNetEvent('bro:permis:show')
AddEventHandler('bro:permis:show', function(permis, t)
	TriggerClientEvent("bro_core:Notification", t, "Permis de conduire")
	if permis < 1 then
		TriggerClientEvent("bro_core:Notification", t, "~r~"..permis.." points")
	else
		TriggerClientEvent("bro_core:Notification", t,"~g~"..permis.." points")
	end
end)



RegisterNetEvent('bro:card:show')
AddEventHandler('bro:card:show', function(player, t)
	print("SHOW CARD")
	print(player.name)
	print(t)
	TriggerClientEvent("bro_core:Notification", t, "Carte d'identité")
	TriggerClientEvent("bro_core:Notification", t, player.firstname.." "..player.lastname)
	TriggerClientEvent("bro_core:Notification", t, player.birth)
end)

RegisterNetEvent('bro:permis:get')
AddEventHandler('bro:permis:get', function(t)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select gun_permis from players where discord = @discord',
        {['discord'] =  discord},
		function(res)
			TriggerClientEvent("bro_core:Notification", t, "Permis de Port Armes")
            if res then
				TriggerClientEvent("bro_core:Notification", t, "~b~Valide")
			else
				TriggerClientEvent("bro_core:Notification", t, "~r~Invalide")
            end
        end)
    end)
end)
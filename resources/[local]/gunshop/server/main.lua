RegisterNetEvent("gun:permis")

AddEventHandler('gun:permis', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select gun_permis from players where discord = @discord',
		{['@discord'] =  discord},
		function(permis)
			TriggerClientEvent(cb, sourceValue, permis)
		end)
	end)
end)


RegisterNetEvent("gun:buy")

AddEventHandler('gun:buy', function(cb, price, weapon)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local tva = 0.2
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select liquid from players where discord = @discord',
		{['@discord'] =  discord},
		function(liquid)
			if liquid > tonumber(price) then
				MySQL.Async.execute('update players set liquid = liquid-@price where discord = @discord',
				{['@discord'] =  discord, ['@price'] = price},
				function(numRows)
					MySQL.Async.execute('update accounts set amount = amount+@price where id = 1',
					{['@discord'] =  discord, ['@price'] = price * tva},
					function(numRows)
						TriggerClientEvent(cb, sourceValue, true, weapon)
					end)
				end)			
			else
				TriggerClientEvent(cb, sourceValue, false, weapon)
			end
		end)
	end)
end)


RegisterNetEvent('shops:buy')

AddEventHandler('shops:buy', function(type, amount, zone)
	local sourceValue = source
	local amounte = tonumber(amount)
	local typee = tonumber(type)
	local zonee = zone
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid, price from players, shops where fivem = @fivem and item =@type and shops.type = @zone',
		{['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
		 ['type'] = typee,
		 ['zone'] = zonee},
		function(res)
			local pricee = (amounte * res[1].price)
			if res[1] and res[1].liquid >= pricee then
				MySQL.Async.fetchAll('UPDATE shops SET shops.amount=shops.amount-@amount where shops.type = @zone and shops.item = @type',
				{['amount'] = amounte,
				['type'] = typee,
				['zone'] = zonee},
				function(res)
					MySQL.Async.fetchAll('UPDATE players SET players.liquid=players.liquid-@price where players.fivem = @fivem',
					{['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
					['price'] = pricee},
					function(res)
						MySQL.Async.fetchAll('SELECT * FROM player_item,players where players.fivem = @fivem and player_item.player = players.id and player_item.item = @type',
						{['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
						['amount'] = amounte,
						['type'] = typee},
						function(res)
							if res[1] then
								MySQL.Async.fetchAll('UPDATE player_item, players SET player_item.amount=player_item.amount+@amount where players.fivem = @fivem and player_item.player = players.id and player_item.item = @type',
								{['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
								['amount'] = amounte,
								['type'] = typee},
								function(res)
									TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Achat effectué", type = "info", timeout = 5000})
								end)
							else
								MySQL.Async.fetchAll('select id from players where players.fivem = @fivem',
								{['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]},
								function(res)
									MySQL.Async.fetchAll('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount);',
									{['id'] = res[1].id,
									['amount'] = amounte,
									['type'] = typee},
									function(res)
										TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Achat effectué", type = "info", timeout = 5000})
									end)
								end)
							end
						end)
					end)
				end)
			else
				TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Achat manqué", type = "error", timeout = 5000})
			end
        end)
      end)
end)

RegisterNetEvent('shops:withdraw')
AddEventHandler('shops:withdraw', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select amount from accounts, players where fivem = @fivem and accounts.player = players.id',
        {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]},
		function(res)
			if res[1] and res[1].amount >= amounte then
				MySQL.Async.fetchAll('UPDATE accounts, players set amount=amount-@amount, liquid=liquid+@amount where fivem = @fivem and accounts.player = players.id',
				{['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
				['amount'] = amounte},
				function(res)
					TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Retrait effectué", type = "info", timeout = 5000})
				end)
			else
				TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Retrait loupé (Pas assez d'argent)", type = "error", timeout = 5000})
			end
        end)
      end)
end)
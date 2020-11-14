RegisterNetEvent('shops:buy')

AddEventHandler('shops:buy', function(type, amount, zone)
	local sourceValue = source
	local amounte = tonumber(amount)
	local typee = tonumber(type)
	local zonee = zone

	for k,v in pairs(GetPlayerIdentifiers(sourceValue))do
		print(v)
			
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
		MySQL.Async.fetchAll('select liquid, price from players, shops where fivem = @fivem and item =@type and shops.type = @zone',
		{['fivem'] =  discord,
		 ['type'] = typee,
		 ['zone'] = zonee},
		function(res)
			print("HEREEEE")
			local pricee = (amounte * res[1].price)
			if res[1] and res[1].liquid >= pricee then
				MySQL.Async.fetchAll('UPDATE shops SET shops.amount=shops.amount-@amount where shops.type = @zone and shops.item = @type',
				{['amount'] = amounte,
				['type'] = typee,
				['zone'] = zonee},
				function(res)
					MySQL.Async.fetchAll('UPDATE players SET players.liquid=players.liquid-@price where players.fivem = @fivem',
					{['fivem'] =  discord,
					['price'] = pricee},
					function(res)
						MySQL.Async.fetchAll('SELECT * FROM player_item,players where players.fivem = @fivem and player_item.player = players.id and player_item.item = @type',
						{['fivem'] =  discord,
						['amount'] = amounte,
						['type'] = typee},
						function(res)
							if res[1] then
								MySQL.Async.fetchAll('UPDATE player_item, players SET player_item.amount=player_item.amount+@amount where players.fivem = @fivem and player_item.player = players.id and player_item.item = @type',
								{['fivem'] =  discord,
								['amount'] = amounte,
								['type'] = typee},
								function(res)
									TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Achat effectué", type = "info", timeout = 5000})
								end)
							else
								MySQL.Async.fetchAll('select id from players where players.fivem = @fivem',
								{['fivem'] =  discord},
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

	for k,v in pairs(GetPlayerIdentifiers(sourceValue))do
		print(v)
			
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
		MySQL.Async.fetchAll('select amount from accounts, players where fivem = @fivem and accounts.player = players.id',
        {['fivem'] =  discord},
		function(res)
			if res[1] and res[1].amount >= amounte then
				MySQL.Async.fetchAll('UPDATE accounts, players set amount=amount-@amount, liquid=liquid+@amount where fivem = @fivem and accounts.player = players.id',
				{['fivem'] =  discord,
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
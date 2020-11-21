RegisterNetEvent('shops:buy')

AddEventHandler('shops:buy', function(type, amount, shop_item)
	local sourceValue = source
	local amounte = tonumber(amount)
	local typee = tonumber(type)
	local shop_item = shop_item

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

	local tva = 0.2
	local price = 0
	if type == 13 then
		price = 5
	elseif type == 14 then 
		price =5
	end

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select liquid from players where fivem = @fivem',
		{['fivem'] =  discord},
		function(liquid)
			local pricee = (amounte * price)
			if liquid >= pricee then
				MySQL.Async.fetchScalar('select amount from shop_item where id = @shop_item',
				{['@shop_item'] = shop_item},
				function(amountInShop)
					if amountInShop >= amounte then
						MySQL.Async.execute('UPDATE shop_item SET amount=amount-@amount where id = @shop_item',
						{['amount'] = amounte,
						['type'] = typee,
						['shop_item'] = shop_item},
						function(res)
							MySQL.Async.execute('UPDATE players SET players.liquid=players.liquid-@price where players.fivem = @fivem',
							{['fivem'] =  discord,
							['price'] = pricee},
							function(res)
								MySQL.Async.fetchAll('SELECT * FROM player_item,players where players.fivem = @fivem and player_item.player = players.id and player_item.item = @type',
								{['fivem'] =  discord,
								['amount'] = amounte,
								['type'] = typee},
								function(res)
									if res[1] then
										MySQL.Async.execute('UPDATE player_item, players SET player_item.amount=player_item.amount+@amount where players.fivem = @fivem and player_item.player = players.id and player_item.item = @type',
										{['fivem'] =  discord,
										['amount'] = amounte,
										['type'] = typee},
										function(res)
											MySQL.Async.fetchScalar('select shop from shop_item where id = @shop_item',
											{['@shop_item'] = shop_item},
											function(shop)
												MySQL.Async.execute('UPDATE shops set money = money + @money where id = @shop',
												{
													['@shop'] = shop,
													['@money'] = pricee *(1-tva),
												},
												function(res)
													MySQL.Async.execute('UPDATE jobs set money = money + @money where id = @gouv',
													{
														['@gouv'] = 7,
														['@money'] = pricee *(tva),
													},
													function(res)
														TriggerClientEvent("bf:Notification", sourceValue, "~g~Achat effectué pour ~r~"..pricee.." $")
													end)
												end)
											end)
										end)
									else
										MySQL.Async.fetchAll('select id from players where players.fivem = @fivem',
										{['fivem'] =  discord},
										function(res)
											MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount);',
											{['id'] = res[1].id,
											['amount'] = amounte,
											['type'] = typee},
											function(res)
												MySQL.Async.fetchScalar('select shop from shop_item where id = @shop_item',
												{['@shop_item'] = shop_item},
												function(shop)
													MySQL.Async.execute('UPDATE shops set money = money + @money where id = @shop',
													{
														['@shop'] = shop,
														['@money'] = pricee *(1-tva),
													},
													function(res)
														MySQL.Async.execute('UPDATE jobs set money = money + @money where id = @gouv',
														{
															['@gouv'] = 7,
															['@money'] = pricee *(tva),
														},
														function(res)
															TriggerClientEvent("bf:Notification", sourceValue, "~g~Achat effectué pour ~r~"..pricee.." $")
														end)
													end)
												end)
											end)
										end)
									end
								end)
							end)
						end)
					else
						TriggerClientEvent("bf:Notification", sourceValue, "~r~Le magasin n'a pas assez de stock")
					end
				end)
			else
				TriggerClientEvent("bf:Notification", sourceValue, "~r~Vous n'avez pas assez d'argent. ~r~"..pricee.." $")
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


RegisterNetEvent('shops:rob')
AddEventHandler('shops:rob', function(id)
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
		MySQL.Async.fetchAll('select money from shops where id = @id', {['id'] = id},
		function(res)
			print(res[1])
			if res[1] ~= nil  and res[1].money ~= nil then
				local amount = res[1].money * (math.random(40, 80)/100)
				MySQL.Async.fetchAll('UPDATE players set liquid=liquid+@amount where fivem = @fivem',
				{['fivem'] =  discord,
				['amount'] = amount},
				function(res2)
					MySQL.Async.execute('UPDATE shops SET money=money-@amount where id = @id', {['id'] = id, ['@amount'] = amount},
					 function(res3)
						TriggerClientEvent("bf:Notification", sourceValue, "vous avez braqué pour ~g~" .. amount.." $")
					end)		
				end)
			else
				TriggerClientEvent("bf:Notification", sourceValue, "Error")
			end
        end)
	end)
end)

RegisterNetEvent('shops:items:get')
AddEventHandler('shops:items:get', function(cb, shop)
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
	local shop = shop
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select shop_item.id, items.label, items.id as item from shop_item, items where shop = @shop and shop_item.item = items.id',
        {['@shop'] =  shop},
		function(res)
			print("get")
			TriggerClientEvent(cb, sourceValue, res)
		end)
	end)
end)

RegisterNetEvent('shops:buy')

AddEventHandler('shops:buy', function(type, amount, price)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	local amount = amount

	local tva = 0.2
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid, id from players where discord = @discord',
		{['discord'] =  discord},
		function(player)
			local pricee = (amount * price)
			if player[1].liquid >= pricee then
				MySQL.Async.execute('UPDATE players SET players.liquid=players.liquid-@price where players.id = @id',
					{
						['id'] = player[1].id,
						['price'] = pricee
					},
					function(res)
						MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
						{
							['id'] = player[1].id,
							['amount'] = amount,
							['type'] = type
						},
						function(res)
						MySQL.Async.execute('update accounts set amount = amount+@price where id = 1',
						{['@discord'] =  discord, ['@price'] = pricee * tva},
						function(numRows)
							TriggerClientEvent("bro_core:Notification", sourceValue, "~g~Achat effectué pour ~r~"..pricee.." $")
						end)
					end)
				end)
			else
				TriggerClientEvent("bro_core:Notification", sourceValue, "~r~Vous n'avez pas assez d'argent. ~r~"..pricee.." $")
			end
        end)
      end)
end)

RegisterNetEvent('shops:sell')

AddEventHandler('shops:sell', function(shop, type, amount)
	local sourceValue = source
	local amounte = tonumber(amount)
	local typee = tonumber(type)
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local maxInShop = 100

	local price = 0
	if type == 3 then
		price = 3
	elseif type == 5 then 
		price =3
	else
		price =10
	end

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select money from shops where id = @shop',
		{['@shop'] =  shop},
		function(money)
			local pricee = (amounte * price)
			if money >= pricee then
				MySQL.Async.fetchScalar('select amount from player_item, players where player_item.item = @type and players.id = player_item.player and players.discord = @discord ',
				{
					['@discord'] = discord,
					['@type'] = type
				},function(amount_player)
					if amount_player >= amounte then
						MySQL.Async.fetchScalar('select amount from shop_item where shop=@shop and item = @type',
						{
							['@shop'] = shop,
							['@type'] = type
						},function(amount_Shop)
							if (amount_Shop + amounte) <= maxInShop then
								MySQL.Async.execute('UPDATE shop_item SET amount=amount+@amount where shop = @shop and item = @item',
								{['amount'] = amounte,
								['item'] = typee,
								['shop'] = shop},
								function(res)
									MySQL.Async.execute('UPDATE players SET players.liquid=players.liquid+@price where players.discord = @discord',
									{['discord'] =  discord,
									['price'] = pricee},
									function(res)
										MySQL.Async.fetchAll('SELECT * FROM player_item,players where players.discord = @discord and player_item.player = players.id and player_item.item = @type',
										{['discord'] =  discord,
										['amount'] = amounte,
										['type'] = typee},
										function(res)
												MySQL.Async.execute('UPDATE player_item, players SET player_item.amount=player_item.amount-@amount where players.discord = @discord and player_item.player = players.id and player_item.item = @type',
												{['discord'] =  discord,
												['amount'] = amounte,
												['type'] = typee},
												function(res)
													MySQL.Async.execute('UPDATE shops set money = money - @money where id = @shop',
													{
														['@shop'] = shop,
														['@money'] = pricee,
													},
													function(res)
														TriggerClientEvent("bro_core:Notification", sourceValue, "~g~Vente effectuée pour ~r~"..pricee.." $")
													end)
												end)
											end)
										end)
									end)
								else
									TriggerClientEvent("bro_core:Notification", sourceValue, "Le magazsin à déjà trop de stock. ~r~Max : "..maxInShop)
								end
							end)
						else
							TriggerClientEvent("bro_core:Notification", sourceValue, "~r~Vous n'avez rien à vendre")
						end
				end)
			else
				--TODO ; gouv money help
				TriggerClientEvent("bro_core:Notification", sourceValue, "~r~Le magasin n'a pas assez d'argent. ~r~"..pricee.." $")
			end
        end)
      end)
end)


RegisterNetEvent('shops:stock')

AddEventHandler('shops:stock', function(shop, type)
	local sourceValue = source
	local typee = tonumber(type)
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select amount from shop_item where shop=@shop and item = @type',
		{
			['@shop'] = shop,
			['@type'] = type
		},function(amount_Shop)
			TriggerClientEvent("bro_core:Notification", sourceValue, "Stock : ".. amount_Shop)
		end)
	end)
end)
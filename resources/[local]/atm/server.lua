RegisterNetEvent('atm:deposit')

AddEventHandler('atm:deposit', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)

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

		MySQL.Async.fetchAll('select  * from accounts where player = @fivem',
        {['fivem'] =  discord},
		function(res)
			if res ~= nil  then
				MySQL.Async.fetchAll('select id from players where fivem = @fivem',
				{['fivem'] =  discord},
				function(res)
					MySQL.Async.execute('INSERT INTO `accounts` (`id`, `player`, `amount`) VALUES (NULL, @player, 0)', {
						['player'] = res[1].id
					}, function(res)
						MySQL.Async.fetchAll('select liquid from players where fivem = @fivem',
						{['fivem'] =  discord},
						function(res)
							if res[1] and res[1].liquid >= amounte then
								MySQL.Async.fetchAll('UPDATE accounts, players set amount=amount+@amount, liquid=liquid-@amount where fivem = @fivem and accounts.player = players.id',
								{['fivem'] =  discord,
								['amount'] = amounte},
								function(res)
									TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
										icon = "CHAR_BANK_MAZE",
										type = 2,
										text = "Depot effectué ~g~" .. amounte .. " $",
										title = "MAZE BANK",
										subTitle = "ATM" 
									})
								end)
							else
								TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
									icon = "CHAR_BANK_MAZE",
									type = 2,
									text = "Depot loupé ~g~" .. amounte .. " $",
									title = "MAZE BANK",
									subTitle = "ATM" 
								})
							end
						end)			
					end)
				end)
			else
				MySQL.Async.fetchAll('select liquid from players where fivem = @fivem',
				{['fivem'] =  discord},
				function(res)
					if res[1] and res[1].liquid >= amounte then
						MySQL.Async.fetchAll('UPDATE accounts, players set amount=amount+@amount, liquid=liquid-@amount where fivem = @fivem and accounts.player = players.id',
						{['fivem'] =  discord,
						['amount'] = amounte},
						function(res)
							TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
								icon = "CHAR_BANK_MAZE",
								type = 2,
								text = "Retrait effectué ~g~" .. amounte .. " $",
								title = "MAZE BANK",
								subTitle = "ATM" 
							})
						end)
					else
						TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
							icon = "CHAR_BANK_MAZE",
							type = 2,
							text = "Depot effectué ~g~" .. amounte .. " $",
							title = "MAZE BANK",
							subTitle = "ATM" 
						})
					end
				end)
			end
        end)
      end)
end)

RegisterNetEvent('atm:withdraw')
AddEventHandler('atm:withdraw', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)

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
		MySQL.Async.fetchAll('select amount from accounts, players where fivem = @fivem and accounts.player = players.id',
        {['fivem'] =  discord},
		function(res)
			if res[1] and res[1].amount >= amounte then
				MySQL.Async.fetchAll('UPDATE accounts, players set amount=amount-@amount, liquid=liquid+@amount where fivem = @fivem and accounts.player = players.id',
				{['fivem'] =  discord,
				['amount'] = amounte},
				function(res)
					TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
						icon = "CHAR_BANK_MAZE",
						type = 2,
						text = "Retrait effectué ~g~" .. amounte .. " $",
						title = "MAZE BANK",
						subTitle = "ATM" 
					})
				end)
			else
				TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
					icon = "CHAR_BANK_MAZE",
					type = 2,
					text = "Retrait loupé ~g~" .. amounte .. " $",
					title = "MAZE BANK",
					subTitle = "ATM" 
				})
			end
        end)
      end)
end)
-- Register net Events
-- ATM #1
RegisterNetEvent('atm:deposit')
RegisterNetEvent('atm:withdraw')

-- Event Handlers
-- ATM #1
AddEventHandler('atm:deposit', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select liquid from accounts, players, player_account where discord = @discord and player_account.player = players.id and player_account.account = accounts.id',
        {['@discord'] =  discord},
		function(liquid)
			if liquid >= amounte then
				MySQL.Async.execute('UPDATE accounts, players, player_account set amount=amount+@amount, liquid=liquid-@amount where discord = @discord and player_account.account = accounts.id and player_account.player = players.id',
				{['@discord'] =  discord,
				['@amount'] = amounte},
				function(affectedRows)
					if affectedRows == 2 then

						MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord', {['@discord'] = discord}, function(liquid)
							if liquid > 1000 then
								TriggerClientEvent("account:suitcase:on", sourceValue)
							elseif liquid < 1000 then
								TriggerClientEvent("account:suitcase:off", sourceValue)
							end
						end)
						TriggerClientEvent("phone:account:get", sourceValue)

						TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
							icon = "CHAR_BANK_MAZE",
							type = 2,
							text = "Depot effectué ~g~" .. amounte .. " $",
							title = "MAZE BANK",
							subTitle = "ATM" 
						})
					else
						TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
							icon = "CHAR_BANK_MAZE",
							type = 2,
							text = "~r~ Erreur lors du depot",
							title = "MAZE BANK",
							subTitle = "ATM" 
						})
					end
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

AddEventHandler('atm:withdraw', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('select amount from accounts, players, player_account where discord = @discord and player_account.player = players.id and player_account.account = accounts.id',
        {['@discord'] =  discord},
		function(money)
			if money >= amounte then
				MySQL.Async.execute('UPDATE accounts, players, player_account set amount=amount-@amount, liquid=liquid+@amount where discord = @discord and player_account.account = accounts.id and player_account.player = players.id',
				{['@discord'] =  discord,
				['@amount'] = amounte},
				function(affectedRows)
					if affectedRows == 2 then
						MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord', {['@discord'] = discord}, function(liquid)
							if liquid > 1000 then
								TriggerClientEvent("account:suitcase:on", sourceValue)
							elseif liquid < 1000 then
								TriggerClientEvent("account:suitcase:off", sourceValue)
							end
						end)
						TriggerClientEvent("phone:account:get", sourceValue)

						TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
							icon = "CHAR_BANK_MAZE",
							type = 2,
							text = "Retrait effectué ~g~" .. amounte .. " $",
							title = "MAZE BANK",
							subTitle = "ATM" 
						})
					else
						TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
							icon = "CHAR_BANK_MAZE",
							type = 2,
							text = "~r~ Erreur lors du retrait",
							title = "MAZE BANK",
							subTitle = "ATM" 
						})
					end
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
-- Register net Events
-- ATM #1
RegisterNetEvent('bank:deposit')
RegisterNetEvent('bank:withdraw')
RegisterNetEvent('bank:dirty:deposit')
LimitSuitcase = 50000

-- Event Handlers
-- ATM #1
AddEventHandler('bank:deposit', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	dirty = 0
	liquid = 0
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select players.liquid, players.dirty from accounts, players, player_account where discord = @discord and player_account.player = players.id and player_account.account = accounts.id',
        {['@discord'] =  discord},
		function(res)
			if (res[1].liquid + res[1].dirty) >= amounte then
				if amounte > res[1].dirty then
					liquid = amounte - res[1].dirty
					dirty = res[1].dirty
				else
					liquid = 0
					dirty = amounte
				end
				MySQL.Async.execute('UPDATE players, job_grades, job_account, accounts set accounts.liquid=accounts.liquid+@liquid, players.liquid=players.liquid-@liquid where  discord = @discord and job_grades.id = players.job_grade and job_account.account = accounts.id and job_account.job = job_grades.job',
				{['@discord'] =  discord,
				['@liquid'] = liquid},
				function(affectedRows)
					if affectedRows == 2 then

						MySQL.Async.fetchAll('SELECT dirty, liquid from players where discord = @discord', {['@discord'] = discord}, function(res)
							if (res[1].liquid + res[1].dirty) >= LimitSuitcase then
								TriggerClientEvent("account:suitcase:on", sourceValue)
							elseif (res[1].liquid + res[1].dirty) < LimitSuitcase then
								TriggerClientEvent("account:suitcase:off", sourceValue)
							end
						end)
						TriggerClientEvent("phone:account:get", sourceValue)

						if dirty > 0 then
							TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
								icon = "CHAR_BANK_MAZE",
								type = 2,
								text = "Depot effectué ~g~$ " .. liquid .. ". Argent sâle : ~r~"..dirty.." $",
								title = "MAZE BANK",
								subTitle = "ATM" 
							})
						else
							TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
								icon = "CHAR_BANK_MAZE",
								type = 2,
								text = "Depot effectué ~g~" .. liquid .. " $",
								title = "MAZE BANK",
								subTitle = "ATM" 
							})
						end
					else
						TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
							icon = "CHAR_BANK_MAZE",
							type = 2,
							text = "~r~ Erreur lors du depot",
							title = "MAZE BANK",
							subTitle = "ATM" 
						})
					end
				end)
			else
				TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
					icon = "CHAR_BANK_MAZE",
					type = 2,
					text = "Depot loupé ~r~" .. amounte .. " $",
					title = "MAZE BANK",
					subTitle = "ATM" 
				})
			end
        end)
      end)
end)

AddEventHandler('bank:withdraw', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)
	if amounte and amounte > 0 then
		
		local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
		MySQL.ready(function ()
			MySQL.Async.fetchScalar('select accounts.liquid from accounts, players, player_account where discord = @discord and player_account.player = players.id and player_account.account = accounts.id',
			{['@discord'] =  discord},
			function(money)
				if money >= amounte then
					MySQL.Async.execute('UPDATE players, job_grades, job_account, accounts set accounts.liquid=accounts.liquid-@amount, players.liquid=players.liquid+@amount where  discord = @discord and job_grades.id = players.job_grade and job_account.account = accounts.id and job_account.job = job_grades.job',
					{['@discord'] =  discord,
					['@amount'] = amounte},
					function(affectedRows)
						if affectedRows == 2 then
							MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord', {['@discord'] = discord}, function(liquid)
								if liquid > LimitSuitcase then
									TriggerClientEvent("account:suitcase:on", sourceValue)
								elseif liquid < LimitSuitcase then
									TriggerClientEvent("account:suitcase:off", sourceValue)
								end
							end)
							TriggerClientEvent("phone:account:get", sourceValue)

							TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
								icon = "CHAR_BANK_MAZE",
								type = 2,
								text = "Retrait effectué ~g~" .. amounte .. " $",
								title = "MAZE BANK",
								subTitle = "ATM" 
							})
						else
							TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
								icon = "CHAR_BANK_MAZE",
								type = 2,
								text = "~r~ Erreur lors du retrait",
								title = "MAZE BANK",
								subTitle = "ATM" 
							})
						end
					end)
				else
					TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
						icon = "CHAR_BANK_MAZE",
						type = 2,
						text = "Retrait loupé ~g~" .. amounte .. " $",
						title = "MAZE BANK",
						subTitle = "ATM" 
					})
				end
			end)
		end)
	else
		TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
			icon = "CHAR_BANK_MAZE",
			type = 2,
			text = "~r~Montant invalide",
			title = "MAZE BANK",
			subTitle = "ATM" 
		})
	end
end)

AddEventHandler('bank:dirty:deposit', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	dirty = 0
	liquid = 0
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select dirty from players where discord = @discord',
        {['@discord'] =  discord},
		function(res)
			if res[1].dirty >= amounte then
				MySQL.Async.execute('UPDATE players, job_grades, job_account, accounts set accounts.dirty=accounts.dirty+@amount, players.dirty=players.dirty-@amount where discord = @discord and job_grades.id = players.job_grade and job_account.account = accounts.id and job_account.job = job_grades.job',
				{['@discord'] =  discord,
				['@amount'] = res[1].dirty},
				function(affectedRows)
					if affectedRows == 2 then

						MySQL.Async.fetchAll('SELECT dirty, liquid from players where discord = @discord', {['@discord'] = discord}, function(res)
							if (res[1].liquid + res[1].dirty) >= LimitSuitcase then
								TriggerClientEvent("account:suitcase:on", sourceValue)
							elseif (res[1].liquid + res[1].dirty) < LimitSuitcase then
								TriggerClientEvent("account:suitcase:off", sourceValue)
							end
						end)
						TriggerClientEvent("phone:account:get", sourceValue)

						if dirty > 0 then
							TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
								icon = "CHAR_BANK_MAZE",
								type = 2,
								text = "Depot effectué - Argent sâle : ~r~"..dirty.." $",
								title = "MAZE BANK",
								subTitle = "ATM" 
							})
						else
							TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
								icon = "CHAR_BANK_MAZE",
								type = 2,
								text = "Depot effectué ~g~" .. liquid .. " $",
								title = "MAZE BANK",
								subTitle = "ATM" 
							})
						end
					else
						TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
							icon = "CHAR_BANK_MAZE",
							type = 2,
							text = "~r~ Erreur lors du depot",
							title = "MAZE BANK",
							subTitle = "ATM" 
						})
					end
				end)
			else
				TriggerClientEvent("bro_core:AdvancedNotification", sourceValue, {
					icon = "CHAR_BANK_MAZE",
					type = 2,
					text = "Depot loupé ~r~" .. amounte .. " $",
					title = "MAZE BANK",
					subTitle = "ATM" 
				})
			end
        end)
      end)
end)

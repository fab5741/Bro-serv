-- Register net Events
-- Player #1
RegisterNetEvent("account:player:get")
RegisterNetEvent("account:player:add")
-- Player liquid #2
RegisterNetEvent("account:player:liquid:get")
RegisterNetEvent("account:player:liquid:get:facture")
RegisterNetEvent("account:player:liquid:add")
RegisterNetEvent("account:player:liquid:give")
RegisterNetEvent("account:player:liquid:check")
-- Jobs #3
RegisterNetEvent("account:job:get")
RegisterNetEvent("account:job:add")
-- atm #4
RegisterNetEvent("atm:get")

LimitSuitcase = 50000

-- Event Handlers
-- Player #1
AddEventHandler('account:player:get', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT accounts.amount from accounts, player_account, players where players.discord = @discord and players.id = player_account.player and accounts.id = player_account.account', {
			['@discord'] = discord
		}, function(amount)
			TriggerClientEvent(cb, sourceValue, amount)
		end)
	end)
end)

AddEventHandler('account:player:add', function(cb, amount)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.execute('UPDATE accounts, player_account, players SET accounts.amount = accounts.amount + @amount WHERE player_account.player = players.id and players.discord = @discord and player_account.account= accounts.id ', 
			{
				['@discord'] = discord, 
				['@amount'] = amount
			}, function(numRows)
				TriggerClientEvent("phone:account:get", sourceValue)
				TriggerClientEvent(cb, sourceValue, numRows == 1)
		end)
	end)
end)

-- Player liquid #2
AddEventHandler('account:player:liquid:get', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchAll('SELECT liquid, dirty from players where discord = @discord',
			{
				['@discord'] = discord
			}, function(res)
			TriggerClientEvent(cb, sourceValue, res[1].dirty + res[1].liquid)
		end)
	end)
end)

AddEventHandler('account:player:liquid:get:facture', function(cb, amount, sender, job)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord',
			{
				['@discord'] = discord
			}, function(liquid)
			TriggerClientEvent(cb, sourceValue, liquid, amount, sender, job)
		end)
	end)
end)

AddEventHandler('account:player:liquid:add', function(cb, amount, dirty)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local amount=amount
	print(amount)
	MySQL.ready(function ()
		if dirty then 
			MySQL.Async.insert(
				'update players set dirty=dirty+@amount where discord = @discord',
				{
					['@discord'] = discord,
					['@amount'] = amount,
				}, function(id)
					MySQL.Async.fetchAll('SELECT dirty, liquid from players where discord = @discord', {['@discord'] = discord}, function(res)
						if (res[1].liquid + res[1].dirty) >= LimitSuitcase then
							TriggerClientEvent("account:suitcase:on", sourceValue)
						elseif (res[1].liquid + res[1].dirty) < LimitSuitcase then
							TriggerClientEvent("account:suitcase:off", sourceValue)
						end
						TriggerClientEvent(cb, sourceValue, id ~= nil)
					end)
			end)
		else
			MySQL.Async.insert(
				'update players set liquid=liquid+@amount where discord = @discord',
				{
					['@discord'] = discord,
					['@amount'] = amount,
				}, function(id)
					MySQL.Async.fetchAll('SELECT dirty, liquid from players where discord = @discord', {['@discord'] = discord}, function(res)
						if (res[1].liquid + res[1].dirty) >= LimitSuitcase then
							TriggerClientEvent("account:suitcase:on", sourceValue)
						elseif (res[1].liquid + res[1].dirty) < LimitSuitcase then
							TriggerClientEvent("account:suitcase:off", sourceValue)
						end
						TriggerClientEvent(cb, sourceValue, id ~= nil)
					end)
			end)
		end
	end)
end)


AddEventHandler('account:player:liquid:give', function(cb, player, amount)
	print(player)
	print(amount)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local discordTo = exports.bro_core:GetDiscordFromSource(player)
	local amount=amount
	MySQL.ready(function ()
		MySQL.Async.fetchAll('SELECT liquid, dirty from players where discord = @discord',
		{
			['@discord'] = discord
		}, function(res)

			if (res[1].liquid + res[1].dirty) >= amount then
				if amount > res[1].dirty then
					dirty = res[1].dirty
					liquid = amount - res[1].dirty
				else
					liquid = 0
					dirty = amount
				end
				MySQL.Async.insert(
					'update players set liquid=liquid-@amount where discord = @discord',
					{
						['@discord'] = discord,
						['@amount'] = liquid,
					}, function(id)
						MySQL.Async.insert(
							'update players set dirty=dirty-@amount where discord = @discord',
							{
								['@discord'] = discord,
								['@amount'] = dirty,
							}, function(id)
								MySQL.Async.fetchAll('SELECT liquid, dirty from players where discord = @discord', {['@discord'] = discord}, function(res)
									if (res[1].liquid + res[1].dirty) >= LimitSuitcase then
										TriggerClientEvent("account:suitcase:on", sourceValue)
									elseif (res[1].liquid + res[1].dirty) < LimitSuitcase then
										TriggerClientEvent("account:suitcase:off", sourceValue)
									end
									TriggerClientEvent(cb, sourceValue, id ~= nil)
								end)
						end)
				end)
				MySQL.Async.insert(
					'update players set liquid=liquid+@amount where discord = @discord',
					{
						['@discord'] = discordTo,
						['@amount'] = liquid,
					}, function(id)
						MySQL.Async.insert(
							'update players set dirty=dirty+@amount where discord = @discord',
							{
								['@discord'] = discordTo,
								['@amount'] = dirty,
							}, function(id)
								MySQL.Async.fetchAll('SELECT liquid, dirty from players where discord = @discord', {['@discord'] = discord}, function(res)
									if (res[1].liquid + res[1].dirty) >= LimitSuitcase then
										TriggerClientEvent("account:suitcase:on", sourceValue)
									elseif (res[1].liquid + res[1].dirty) < LimitSuitcase then
										TriggerClientEvent("account:suitcase:off", sourceValue)
									end
									TriggerClientEvent(cb, sourceValue, id ~= nil)
								end)
						end)
				end)
			else
				TriggerClientEvent('bro_core:Notification', sourceValue, "~r~Vous n'avez pas assez de liquide")
			end
			TriggerClientEvent(cb, sourceValue, liquid)
		end)

	end)
end)


AddEventHandler('account:player:liquid:check', function()
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchAll('SELECT dirty, liquid from players where discord = @discord', {['@discord'] = discord}, function(res)
			TriggerClientEvent("bro_core:Notification", sourceValue,  "Sâle : ~r~ $ ".. res[1].dirty)
			TriggerClientEvent("bro_core:Notification", sourceValue, "Propre : ~g~ $ ".. res[1].liquid)
		end)
	end)
end)

-- Jobs #3
AddEventHandler('account:job:get', function(cb, job)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT accounts.amount from accounts, job_account  where job_account.job = @job and accounts.id = job_account.account', {
			['@job'] = job
		}, function(amount)
			TriggerClientEvent(cb, sourceValue, amount)
		end)
	end)
end)

AddEventHandler('account:job:add', function(cb, job, amount, silent)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local job = job
	local amount = amount
	print(job)
	print(amount)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord', {
			['@discord'] = discord
		}, function(money)
			if money >= amount then
				MySQL.Async.execute('UPDATE accounts, job_account SET accounts.amount = accounts.amount + @amount WHERE job_account.job = @job and job_account.account= accounts.id ', 
				{
					['@job'] = job,
					['@amount'] = amount
				}, function(result)
					MySQL.Async.execute('UPDATE players SET liquid = liquid - @amount WHERE discord = @discord', {
						['@discord'] = discord,
						['@amount'] = amount
					}, function(result)
						if not silent then
							TriggerClientEvent('bro_core:Notification', sourceValue, "Vous avez déposé ~g~"..amount.."$")
						end
						TriggerClientEvent(cb, sourceValue, result)
					end)
				end)
			else
				if not silent then
					TriggerClientEvent('bro_core:Notification', sourceValue,  "Vous n'avez pas cet argent !")
				end
			end
		end)
	end)
end)

-- ATM
AddEventHandler('atm:get', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local data = {

	}
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT accounts.amount from accounts, player_account, players where players.discord = @discord and players.id = player_account.player and accounts.id = player_account.account', {
			['@discord'] = discord
		}, function(amount)
			MySQL.Async.fetchAll('SELECT liquid, dirty from players where discord = @discord',
				{
					['@discord'] = discord
				}, function(res)
					TriggerClientEvent(cb, sourceValue, amount, res[1].liquid + res [1].dirty)
			end)
		end)
	end)
end)
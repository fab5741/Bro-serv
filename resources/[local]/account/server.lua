-- Register net Events
-- Player #1
RegisterNetEvent("account:player:get")
RegisterNetEvent("account:player:add")
-- Player liquid #2
RegisterNetEvent("account:player:liquid:get")
RegisterNetEvent("account:player:liquid:get:facture")
RegisterNetEvent("account:player:liquid:add")
RegisterNetEvent("account:player:liquid:give")
-- Jobs #3
RegisterNetEvent("account:job:get")
RegisterNetEvent("account:job:add")
RegisterNetEvent("account:job:withdraw")
-- atm #4
RegisterNetEvent("atm:get")

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
		MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord',
			{
				['@discord'] = discord
			}, function(liquid)
			TriggerClientEvent(cb, sourceValue, liquid)
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

AddEventHandler('account:player:liquid:add', function(cb, amount)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local amount=amount
	MySQL.ready(function ()
		MySQL.Async.insert(
			'update players set liquid=liquid+@amount where discord = @discord',
			{
				['@discord'] = discord,
				['@amount'] = amount,
			}, function(id)
				MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord', {['@discord'] = discord}, function(liquid)
					if liquid > 50000 then
						TriggerClientEvent("account:suitcase:on", sourceValue)
					elseif liquid < 100000 then
						TriggerClientEvent("account:suitcase:off", sourceValue)
					end
					TriggerClientEvent(cb, sourceValue, id ~= nil)
				end)
		end)
	end)
end)


AddEventHandler('account:player:liquid:give', function(cb, player, amount)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local discordTo = exports.bro_core:GetDiscordFromSource(player)
	local amount=amount
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord',
		{
			['@discord'] = discord
		}, function(liquid)
			if liquid >= amount then
				MySQL.Async.insert(
					'update players set liquid=liquid-@amount where discord = @discord',
					{
						['@discord'] = discord,
						['@amount'] = amount,
					}, function(id)
						MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord', {['@discord'] = discord}, function(liquid)
							if liquid > 50000 then
								TriggerClientEvent("account:suitcase:on", sourceValue)
							elseif liquid < 100000 then
								TriggerClientEvent("account:suitcase:off", sourceValue)
							end
							TriggerClientEvent(cb, sourceValue, id ~= nil)
						end)
				end)
				MySQL.Async.insert(
					'update players set liquid=liquid+@amount where discord = @discord',
					{
						['@discord'] = discordTo,
						['@amount'] = amount,
					}, function(id)
						MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord', {['@discord'] = discordTo}, function(liquid)
							if liquid > 50000 then
								TriggerClientEvent("account:suitcase:on", player)
							elseif liquid < 100000 then
								TriggerClientEvent("account:suitcase:off", player)
							end
							TriggerClientEvent(cb, sourceValue, id ~= nil)
						end)
				end)
			else
				TriggerClientEvent('bro_core:Notification', sourceValue, "~r~Vous n'avez pas assé de liquide")
			end
			TriggerClientEvent(cb, sourceValue, liquid)
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
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord', {
			['@discord'] = discord
		}, function(money)
			if money > amount then
				MySQL.Async.execute('UPDATE accounts, job_account SET accounts.amount = accounts.amount + @amount WHERE job_account.job = @job and job_account.account= accounts.id ', 
				{
					['@job'] = job,
					['@amount'] = amount
				}, function(result)
					MySQL.Async.execute('UPDATE players SET liquid = liquid - @amount WHERE discord = @discord', {
						['@discord'] = discord,
						['@amount'] = amount
					}, function(result)
						TriggerClientEvent(cb, sourceValue, result)
						if not silent then
							TriggerClientEvent('bro_core:Notification', sourceValue, "Vous avez déposé ~g~"..amount.."$")
						end
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

AddEventHandler('account:job:withdraw', function(cb, job, amount)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local job = job
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT accounts.amount from accounts, job_account, players where job_account.job = @job and accounts.id = job_account.account', {
			['@job'] = job
		}, function(money)
			if money > amount then
				MySQL.Async.execute('UPDATE accounts, job_account SET accounts.amount = accounts.amount - @amount WHERE job_account.job = @job and job_account.account= accounts.id ', 
				{
					['@job'] = job,
					['@amount'] = amount
				}, function(result)
					MySQL.Async.execute('UPDATE players SET liquid = liquid + @amount WHERE discord = @discord', {
						['@discord'] = discord,
						['@amount'] = amount
					}, function(result)
						TriggerClientEvent(cb, sourceValue, result)
						TriggerClientEvent('bro_core:Notification', sourceValue, "Vous avez retiré ~g~"..amount.."$")
					end)
				end)
			else
				TriggerClientEvent('bro_core:Notification', sourceValue,  "L'entreprise n'a pas assez d'argent")
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
			MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord',
				{
					['@discord'] = discord
				}, function(liquid)
					TriggerClientEvent(cb, sourceValue, amount, liquid)
			end)
		end)
	end)
end)
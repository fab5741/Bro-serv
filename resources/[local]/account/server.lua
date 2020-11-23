-- Register net Events
-- Player #1
RegisterNetEvent("account:player:get")
RegisterNetEvent("account:player:add")
-- Player liquid #2
RegisterNetEvent("account:player:liquid:get")
RegisterNetEvent("account:player:liquid:add")
-- Jobs #3
RegisterNetEvent("account:job:get")
RegisterNetEvent("account:job:add")
RegisterNetEvent("account:job:withdraw")

-- Event Handlers
-- Player #1
AddEventHandler('account:player:get', function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
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
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.execute('UPDATE accounts, player_account SET accounts.amount = accounts.amount + @amount WHERE players.discord = @discord and player_account.account= accounts.id ', 
			{
				['@discord'] = discord, 
				['@amount'] = amount
			}, function(numRows)
				TriggerClientEvent(cb, sourceValue, numRows == 1)
		end)
	end)
end)

-- Player liquid #2
AddEventHandler('account:player:liquid:get', function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT liquid from players where discord = @discord',
			{
				['@discord'] = discord
			}, function(liquid)
			TriggerClientEvent(cb, sourceValue, liquid)
		end)
	end)
end)

AddEventHandler('account:player:liquid:add', function(cb, amount)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
	local amount=amount
	MySQL.ready(function ()
		MySQL.Async.execute(
			'update players set liquid=liquid+@amount where discord = @discord',
			{
				['@discord'] = discord,
				['@amount'] = amount,
			}, function(numRows)
				TriggerClientEvent(cb, sourceValue, numRows == 1)
		end)
	end)
end)

-- Jobs #3
AddEventHandler('account:job:get', function(cb, job)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT accounts.amount from accounts, job_account, players where jobs.name = @job and players.id = job_account.player and accounts.id = job_account.account', {
			['@job'] = job
		}, function(amount)
			TriggerClientEvent(cb, sourceValue, amount)
		end)
	end)
end)

AddEventHandler('account:job:add', function(cb, amount, job)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.execute('UPDATE accounts, job_account SET accounts.amount = accounts.amount + @amount WHERE jobs.name = @job and job_account.account= accounts.id ', 
			{
				['@job'] = job, 
				['@amount'] = amount
			}, function(numRows)
				TriggerClientEvent(cb, sourceValue, numRows == 1)
		end)
	end)
end)

AddEventHandler('account:job:withdraw', function(cb, job, amount)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
	local job = job

	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT accounts.amount from accounts, job_account, players where jobs.name = @job and players.id = job_account.player and accounts.id = job_account.account', {
			['@job'] = job
		}, function(money)
			if money > amount then
				MySQL.Async.execute('UPDATE accounts, job_account SET accounts.amount = accounts.amount - @amount WHERE jobs.name = @job and job_account.account= accounts.id ', 
				{
					['@job'] = job,
					['@amount'] = amount
				}, function(result)
					MySQL.Async.execute('UPDATE players SET liquid = liquid + @amount WHERE discord = @discord', {
						['@discord'] = discord,
						['@amount'] = amount
					}, function(result)
						TriggerClientEvent(cb, sourceValue, result)
						TriggerClientEvent('bf:Notification', sourceValue, "Vous avez retiré ~g~"..amount.."$")
					end)
				end)
			else
				TriggerClientEvent('bf:Notification', sourceValue,  "L'entreprise n'a pas assez d'argent")
			end
		end)
	end)
end)
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
RegisterNetEvent("cash:check")

LimitSuitcase = 10000

-- Event Handlers
-- Player #1
AddEventHandler('account:player:get', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT accounts.liquid from accounts, player_account, players where players.discord = @discord and players.id = player_account.player and accounts.id = player_account.account', {
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
		MySQL.Async.execute('UPDATE accounts, player_account, players SET accounts.liquid = accounts.liquid + @amount WHERE player_account.player = players.id and players.discord = @discord and player_account.account= accounts.id ', 
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
		MySQL.Async.fetchAll('SELECT liquid, dirty from players where discord = @discord',
			{
				['@discord'] = discord
			}, function(res)
			TriggerClientEvent(cb, sourceValue, res[1].liquid + res[1].dirty, amount, sender, job)
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
		MySQL.Async.fetchAll('SELECT accounts.liquid, accounts.dirty from accounts, job_account  where job_account.job = @job and accounts.id = job_account.account', {
			['@job'] = job
		}, function(res)
			TriggerClientEvent(cb, sourceValue, res[1])
		end)
	end)
end)

AddEventHandler('account:job:add', function(cb, job, amount, silent)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local job = job
	local amount = amount
	MySQL.ready(function ()
		--TODO use dirty money
		MySQL.Async.fetchAll('SELECT liquid, dirty from players where discord = @discord', {
			['@discord'] = discord
		}, function(res)
			if res[1].liquid + res[1].dirty >= amount then
				if res[1].dirty >= amount then
					dirty = amount
					liquid = 0
				else
					dirty = res[1].dirty
					liquid = amount-dirty
				end
				print("ADD")
				print(dirty)
				print(liquid)

				MySQL.Async.execute('UPDATE jobs SET liquid = liquid + @liquid, dirty = dirty + @dirty WHERE id = @job', 
				{
					['@job'] = job,
					['@liquid'] = liquid,
					['@dirty'] = dirty
				}, function(result)
					MySQL.Async.execute('UPDATE players SET liquid = liquid - @liquid, dirty = dirty - @dirty WHERE discord = @discord', {
						['@discord'] = discord,
						['@liquid'] = liquid,
						['@dirty'] = dirty
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
		MySQL.Async.fetchScalar('SELECT accounts.liquid + accounts.dirty from accounts, player_account, players where players.discord = @discord and players.id = player_account.player and accounts.id = player_account.account', {
			['@discord'] = discord
		}, function(amount)
			MySQL.Async.fetchAll('SELECT liquid, dirty from players where discord = @discord',
				{
					['@discord'] = discord
				}, function(res)
					TriggerClientEvent(cb, sourceValue, amount, res[1].liquid + res[1].dirty)
			end)
		end)
	end)
end)

AddEventHandler('cash:check', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
	local data = {

	}
	MySQL.ready(function ()
		MySQL.Async.fetchScalar('SELECT accounts.liquid + accounts.dirty from accounts, player_account, players where players.discord = @discord and players.id = player_account.player and accounts.id = player_account.account', {
			['@discord'] = discord
		}, function(amount)
			MySQL.Async.fetchAll('SELECT liquid, dirty from players where discord = @discord',
				{
					['@discord'] = discord
				}, function(res)
					TriggerClientEvent('bro_core:Notification', sourceValue, "Vous avez ~r~"..res[1].dirty.. "$~o~ d'argent sale sur vous !")
			end)
		end)
	end)
end)

-- time for each paycheck
local moneyWashTime = 10 *1000 *60
-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(moneyWashTime)
        -- Check if people are working
        MySQL.ready(function()
            MySQL.Async.fetchAll('select jobs.id as id, accounts.dirty from jobs, accounts, job_account where job_account.job = jobs.id and job_account.account = accounts.id',{},
            function(res)
                for k,v in pairs(res) do
					if v.dirty >= 1000  then
						rand = math.random(1,1000)
						print("DIRTY")
						MySQL.Async.execute('UPDATE job_account, accounts set accounts.dirty=accounts.dirty-@dirty, accounts.liquid = accounts.liquid + @liquid where job_account.job = @job and job_account.account = accounts.id',
						{['@job'] = v.id,
						['@liquid'] = rand*0.95,
						['@dirty'] = rand},
						function()

						end)
					end
                end
            end)
        end)
    end
end)
RegisterNetEvent('atm:deposit')

AddEventHandler('atm:deposit', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select liquid from players where fivem = @fivem',
        {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]},
		function(res)
			if res[1] and res[1].liquid >= amounte then
				MySQL.Async.fetchAll('UPDATE accounts, players set amount=amount+@amount, liquid=liquid-@amount where fivem = @fivem and accounts.player = players.id',
				{['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
				['amount'] = amounte},
				function(res)
					TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Depot effectué", type = "info", timeout = 5000})
				end)
			else
				TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Depot loupé (Pas assez de liquide)", type = "info", timeout = 5000})
			end
        end)
      end)
end)

RegisterNetEvent('atm:withdraw')
AddEventHandler('atm:withdraw', function(amount)
	local sourceValue = source
	local amounte = tonumber(amount)
	MySQL.ready(function ()
		MySQL.Async.fetchAll('select amount from accounts, players where fivem = @fivem and accounts.player = players.id',
        {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]},
		function(res)
			if res[1] and res[1].amount >= amounte then
				MySQL.Async.fetchAll('UPDATE accounts, players set amount=amount-@amount, liquid=liquid+@amount where fivem = @fivem and accounts.player = players.id',
				{['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
				['amount'] = amounte},
				function(res)
					TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Retrait effectué", type = "info", timeout = 5000})
				end)
			else
				TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Retrait loupé (Pas assez d'argent)", type = "info", timeout = 5000})
			end
        end)
      end)
end)
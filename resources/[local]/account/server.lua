RegisterNetEvent("account:liquid")

AddEventHandler('account:liquid', function(cb)
	print("salut")
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
  

  MySQL.Async.fetchScalar('SELECT liquid from players where fivem = @fivem', {
    ['fivem'] = discord
  }, function(result)
	print(result)

    TriggerClientEvent(cb, sourceValue, result)
  end)
end)


RegisterNetEvent("account:get")

AddEventHandler('account:get', function(cb)
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
  

  MySQL.Async.fetchScalar('SELECT amount from players, accounts where fivem = @fivem and players.id = accounts.player', {
    ['fivem'] = discord
  }, function(result)
    TriggerClientEvent(cb, sourceValue, result)
  end)
end)

RegisterNetEvent("account:money:sub")

AddEventHandler('account:money:sub', function(amount)
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
	MySQL.Async.fetchAll('select * from accounts,players where players.fivem = @fivem and players.id=accounts.player',
        {['fivem'] =  discord},
		function(res)
			if res == nil or res[1] == nil  then
				MySQL.Async.fetchAll('select * from players where players.fivem = @fivem',
				{['fivem'] =  discord},
				function(res2)
					MySQL.Async.execute('INSERT INTO `accounts` (`id`, `player`, `amount`) VALUES (NULL, @id, 0)', {
						['@id'] =  res2[1].id,
					}, function(rows)
						MySQL.Async.execute('UPDATE accounts SET accounts.amount = accounts.amount - @amount WHERE player = @id ', {
							['id'] = res2[1].id, ['amount'] = amount
						})				
					end)
				end)
			else
				MySQL.Async.execute('UPDATE accounts SET accounts.amount = accounts.amount - @amount WHERE player = @id ', {
					['id'] = res[1].id, ['amount'] = amount
				})
			end
        end)
  end)
end)


RegisterNetEvent("account:job:get")

AddEventHandler('account:job:get', function(cb,job)
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
  
  local job = job
  MySQL.Async.fetchScalar('SELECT money from jobs WHERE name = @job', {
    ['job'] = job
  }, function(result)
    TriggerClientEvent(cb, sourceValue, result)
  end)
end)

RegisterNetEvent("account:job:withdraw")

AddEventHandler('account:job:withdraw', function(cb,job)
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
  
  local job = job
  MySQL.Async.fetchScalar('SELECT money from jobs WHERE name = @job', {
    ['job'] = job
  }, function(result)
    TriggerClientEvent(cb, sourceValue, result)
  end)
end)

RegisterNetEvent("account:job:withdraw")

AddEventHandler('account:job:withdraw', function(job, amount)
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
  local job = job

	MySQL.Async.fetchScalar('select money from jobs WHERE name = @job', {
		['@job'] = job,
	}, function(money)
		if money > amount then
			MySQL.Async.execute('UPDATE jobs SET money = money - @amount WHERE name = @job', {
				['@job'] = job,
				['@amount'] = amount
			}, function(result)
				MySQL.Async.execute('UPDATE players SET liquid = liquid + @amount WHERE fivem = @fivem', {
					['@fivem'] = discord,
					['@amount'] = amount
				}, function(result)
					TriggerClientEvent(cb, sourceValue, result)
					TriggerClientEvent('bf:Notification', sourceValue, "Vous avez retiré ~g~"..amount.."$")
				end)
			end)
		else
			TriggerClientEvent('bf:Notification', sourceValue,  "L'entreprise n'a pas assé d'argent")
		end
	end)
end)

RegisterNetEvent("account:job:deposit")

AddEventHandler('account:job:deposit', function(job, amount)
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
  
  local job = job

	MySQL.Async.fetchScalar('select liquid from players WHERE fivem = @fivem', {
		['@fivem'] = discord,
	}, function(liquid)
		if liquid > amount+1 then
			MySQL.Async.execute('UPDATE jobs SET money = money + @amount WHERE name = @job', {
				['@job'] = job,
				['@amount'] = amount
			}, function(result)
				MySQL.Async.execute('UPDATE players SET liquid = liquid - @amount WHERE fivem = @fivem', {
					['@fivem'] = discord,
					['@amount'] = amount
				}, function(result)
					TriggerClientEvent(cb, sourceValue, result)
					TriggerClientEvent('bf:Notification', sourceValue, "Vous avez déposé ~g~"..amount.."$")
				end)
			end)
		else
			TriggerClientEvent('bf:Notification', sourceValue,  "Vous n'avez pas assé d'argent")
		end
	end)
end)

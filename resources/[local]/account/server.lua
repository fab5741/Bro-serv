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
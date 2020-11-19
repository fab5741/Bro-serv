RegisterNetEvent("account:money:add")

AddEventHandler('account:money:add', function(amount)
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
	MySQL.Async.fetchAll('select * from accounts where players = @fivem',
        {['fivem'] =  discord},
		function(res)
			print(res)
			if res[1]  then
				MySQL.Async.execute('INSERT INTO `accounts` (`id`, `player`, `amount`) VALUES (NULL, @fivem, `0`)', {
					['fivem'] = discord
				}, function(res)
					MySQL.Async.execute('UPDATE accounts, players SET accounts.amount = accounts.amount + @amount WHERE fivem = @fivem and players.id = accounts.player', {
						['fivem'] = discord, ['amount'] = amount
					})				
				end)

			else
				MySQL.Async.execute('UPDATE accounts, players SET accounts.amount = accounts.amount + @amount WHERE fivem = @fivem and players.id = accounts.player', {
					['fivem'] = discord, ['amount'] = amount
				})
			end
        end)
  end)
end)

RegisterNetEvent("account:liquid")

AddEventHandler('account:liquid', function(cb)
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

RegisterNetEvent("items:add")

-- source is global here, don't add to function
AddEventHandler("items:add", function (type, amount)
    local source = source

    for k,v in pairs(GetPlayerIdentifiers(source))do
		
			
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
    
    MySQL.Async.fetchAll('select id from players where fivem = @fivem',
    {['fivem'] =  discord},
    function(res)
        if res[1] then
            MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
            {['id'] = res[1].id,
            ['amount'] = amount,
            ['type'] = type},
            function(res)
            end)
        end
    end)
end)

function sub(source, type, amount) 
    for k,v in pairs(GetPlayerIdentifiers(source))do		
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
    
    MySQL.Async.fetchAll('select id from players where fivem = @fivem',
    {['fivem'] =  discord},
    function(res)
        if res[1] then
            MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount-@amount;',
            {['id'] = res[1].id,
            ['amount'] = amount,
            ['type'] = type},
            function(res)
            end)
        end
    end)
end

RegisterNetEvent("items:use")

-- source is global here, don't add to function
AddEventHandler("items:use", function (type, amount)
    local source = source
    if(type == "13") then
        print("bread")
        -- EAT bread
        TriggerClientEvent("needs:change", source, 0, 60)
    end
    if(type == "14") then
      -- EAT water
      print("water")
      TriggerClientEvent("needs:change", source, 1, 60)
  end
  if(type == "19") then
    TriggerClientEvent("needs:change", source, 0, 80)
    TriggerClientEvent("needs:change", source, 1, 10)
  end
    sub(source, type, amount)
end)

RegisterNetEvent("items:sub")

-- source is global here, don't add to function
AddEventHandler("items:sub", function (type, amount)
    local source = source
    sub(source, type, amount)
end)


RegisterNetEvent("items:process")

-- source is global here, don't add to function
AddEventHandler("items:process", function (type, amount, typeTo, amountTo)
    local source = source
    for k,v in pairs(GetPlayerIdentifiers(source))do
		
			
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
    MySQL.Async.fetchAll('select id, amount from players, player_item where fivem = @fivem and player_item.item = @type and player_item.player = players.id',
    {['fivem'] =  discord,
    ['amount'] = amount,
    ['type'] = type},
    function(res)
        if res and res[1] and res[1].amount > 0 then
            MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount-@amount;',
            {['id'] = res[1].id,
            ['amount'] = amount,
            ['type'] = type},
            function(affectedRows)
                    MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
                    {['id'] = res[1].id,
                    ['amount'] = amountTo,
                    ['type'] = typeTo},
                    function(res)
                        TriggerClientEvent("job:process", source, true)
                    end)
            end)
        else
            TriggerClientEvent("job:process", source, false)
        end
    end)
end)



RegisterNetEvent("items:get")

-- source is global here, don't add to function
AddEventHandler("items:get", function (cb)
    local sourceValue = source
    for k,v in pairs(GetPlayerIdentifiers(source))do
		
			
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
    MySQL.Async.fetchAll('SELECT items.id, item, amount, label, weight FROM `player_item`, items, players where players.id = player_item.player and items.id = player_item.item and fivem = @fivem and player_item.amount > 0',
    {['fivem'] =  discord},
    function(res)
        TriggerClientEvent(cb, sourceValue, res)
    end)
end)

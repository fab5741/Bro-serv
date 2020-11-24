
RegisterNetEvent("items:add")

-- source is global here, don't add to function
AddEventHandler("items:add", function (type, amount)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    
  MySQL.ready(function ()
    MySQL.Async.fetchAll('select id from players where discord = @discord',
    {['discord'] =  discord},
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
  end)

function sub(source, type, amount)   
  local sourceValue = source
  local discord = exports.bf:GetDiscordFromSource(sourceValue) 
  MySQL.ready(function ()
    MySQL.Async.fetchAll('select id from players where discord = @discord',
    {['discord'] =  discord},
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
    end)
end

RegisterNetEvent("items:use")

-- source is global here, don't add to function
AddEventHandler("items:use", function (type, amount)
    local source = source
    if(type == 13) then
        -- EAT bread
        TriggerClientEvent("items:eat", source)
        TriggerClientEvent("needs:change", source, 0, 60)
    end
    if(type == 14) then
      -- EAT water
      print("water")
      TriggerClientEvent("items:drink", source)
      TriggerClientEvent("needs:change", source, 1, 60)
  end
  if(type == 19) then
    TriggerClientEvent("items:drink", source)
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
    local sourceValue = source
    local discord = exports.bf:GetDiscordFromSource(sourceValue) 
    MySQL.ready(function ()

    MySQL.Async.fetchAll('select id, amount from players, player_item where discord = @discord and player_item.item = @type and player_item.player = players.id',
    {['discord'] =  discord,
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
end)



RegisterNetEvent("items:get")

-- source is global here, don't add to function
AddEventHandler("items:get", function (cb)
  local sourceValue = source
  local discord = exports.bf:GetDiscordFromSource(sourceValue) 
  MySQL.ready(function ()
    MySQL.Async.fetchAll('SELECT items.id, item, amount, label, weight FROM `player_item`, items, players where players.id = player_item.player and items.id = player_item.item and discord = @discord and player_item.amount > 0',
    {['discord'] =  discord},
    function(res)
        TriggerClientEvent(cb, sourceValue, res)
    end)
  end)
end)

RegisterNetEvent("items:give")

-- source is global here, don't add to function
AddEventHandler("items:give", function (type, amount, to)
  local source = source
  local to = to
  local discord = exports.bf:GetDiscordFromSource(source) 
  local discordTo = exports.bf:GetDiscordFromSource(to) 
  MySQL.ready(function ()

    MySQL.Async.fetchAll('select id from players where discord = @discord',
    {['discord'] =  discord},
    function(res)
        if res and res[1] then
            MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount-@amount;',
            {['id'] = res[1].id,
            ['amount'] = amount,
            ['type'] = type},
            function(affectedRows)
              MySQL.Async.fetchAll('select id from players where discord = @discord ',
              {['discord'] =  discordTo,
              ['type'] = type},
              function(res)
                MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
                {['id'] = res[1].id,
                ['amount'] = amount,
                ['type'] = type},
                function(res)
                  print("don reéussi2")
                end)
              end)
            end)
        else
          
        end
      end)
    end)
end)

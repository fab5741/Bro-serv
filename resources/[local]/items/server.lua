maxWeight = 100

RegisterNetEvent("items:add")

-- source is global here, don't add to function
AddEventHandler("items:add", function (type, amount, message)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
  MySQL.ready(function ()
    MySQL.Async.fetchScalar('select id from players where discord = @discord',
    {['@discord'] =  discord},
    function(player)
      if player then
        MySQL.Async.fetchScalar("SELECT SUM(amount * weight) FROM `items`, player_item  WHERE player_item.item= items.id and player_item.player = @player",
          {
            ['@player'] = player,
          }, function(weight)
          MySQL.Async.fetchScalar("SELECT weight FROM `items` WHERE id = @type",
          {
            ['@type'] = type,
          }, function(newWeight)
            weight = (newWeight*amount)+weight
            if weight <= maxWeight then
              MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
              {['id'] = player,
              ['amount'] = amount,
              ['type'] = type},
              function(res)
                print(message)
                TriggerClientEvent("bf:Notification", sourceValue, message)
              end)
            else
              TriggerClientEvent("bf:Notification", sourceValue, "~r~ Vous êtes déjà trop chargé !")
            end
          end)
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
AddEventHandler("items:process", function (type, amount, typeTo, amountTo, message)
    local sourceValue = source
    local discord = exports.bf:GetDiscordFromSource(sourceValue) 
    print(type)
    print(amount)
    print(typeTo)
    print(amountTo)
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
                        TriggerClientEvent("bf:Notification", sourceValue, message)
                      end)
              end)
          else
            TriggerClientEvent("bf:Notification", sourceValue, "Vous n'avez rien à transformer")
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
    MySQL.Async.fetchScalar('select id from players where discord = @discord',
    {['discord'] =  discord},
    function(id)
      MySQL.Async.fetchScalar('select id from players where discord = @discord',
      {['discord'] =  discordTo},
      function(to)
        MySQL.Async.fetchScalar("SELECT SUM(amount * weight) FROM `items`, player_item  WHERE player_item.item= items.id and player_item.player = @player",
          {
            ['@player'] = to,
          }, function(weight)
          MySQL.Async.fetchScalar("SELECT weight FROM `items` WHERE id = @type",
          {
            ['@type'] = type,
          }, function(newWeight)
            weight = (newWeight*amount)+weight
            if weight < maxWeight then
              MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount-@amount;',
              {['id'] = id,
              ['amount'] = amount,
              ['type'] = type},
              function(affectedRows)
                  MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
                  {['id'] = to,
                  ['amount'] = amount,
                  ['type'] = type},
                  function(res)
                    TriggerClientEvent("bf:Notification", sourceValue, "Vous avez donné ~g~" .. type.. " X " .. amount)
                    TriggerClientEvent("bf:Notification", to, "Vous avez reçu un item")
                  end)
                end)
            else
              TriggerClientEvent("bf:Notification", sourceValue, "La personne a trop de ~r~poids")
              TriggerClientEvent("bf:Notification", to, "Vous portez trop de poids !")
            end
          end)
        end)
      end)
    end)
  end)
end)

maxWeight = 100

RegisterNetEvent("items:add")

-- source is global here, don't add to function
AddEventHandler("items:add", function (type, amount, message)
	local sourceValue = source
  local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
  MySQL.ready(function ()
    MySQL.Async.fetchScalar('select id from players where discord = @discord',
    {['@discord'] =  discord},
    function(player)
      if player then
        MySQL.Async.fetchScalar("SELECT SUM(amount * weight) FROM `items`, player_item  WHERE player_item.item= items.id and player_item.player = @player",
          {
            ['@player'] = player,
          }, function(weight)
            if weight == nil then
              weight = 0
            end
          MySQL.Async.fetchScalar("SELECT weight FROM `items` WHERE id = @type",
          {
            ['@type'] = type,
          }, function(newWeight)
            weight = (newWeight*amount)+weight
            if weight <= maxWeight then
              if amount < 0 then
                MySQL.Async.execute('update `player_item` set amount=amount+@amount where player =@id and item = @type',
                {['id'] = player,
                ['amount'] = amount,
                ['type'] = type},
                function(res)
                  TriggerClientEvent("bf:Notification", sourceValue, message)
                end)
              else
                MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
                {['id'] = player,
                ['amount'] = amount,
                ['type'] = type},
                function(res)
                  TriggerClientEvent("bf:Notification", sourceValue, message)
                end)
              end
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
  local discord = exports.bro_core:GetDiscordFromSource(sourceValue) 
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
    if(type == 3) then
      -- EAT bread
      TriggerClientEvent("items:eat", source)
      TriggerClientEvent("needs:change", source, 1, 75)
    elseif(type == 5) then
      -- drink juice
      TriggerClientEvent("items:drink", source)
      TriggerClientEvent("needs:change", source, 0, 75)
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
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue) 
    MySQL.ready(function ()
      MySQL.Async.fetchAll('select id, amount from players, player_item where discord = @discord and player_item.item = @type and player_item.player = players.id',
      {['discord'] =  discord,
      ['amount'] = amount,
      ['type'] = type},
      function(res)
          if res and res[1] and res[1].amount >= amount then
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
            TriggerClientEvent("bf:Notification", sourceValue, "Vous n'avez pas assé d'items à transformé")
          end
        end)
      end)
end)


RegisterNetEvent("items:get")

-- source is global here, don't add to function
AddEventHandler("items:get", function (cb)
  local sourceValue = source
  local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
  MySQL.ready(function ()
    MySQL.Async.fetchAll('SELECT items.id, item, amount, label, weight FROM `player_item`, items, players where players.id = player_item.player and items.id = player_item.item and discord = @discord and player_item.amount > 0',
    {['discord'] =  discord},
    function(res)
        TriggerClientEvent(cb, sourceValue, res)
    end)
  end)
end)


RegisterNetEvent("items:vehicle:get")

-- source is global here, don't add to function
AddEventHandler("items:vehicle:get", function (cb, vehicle)
  local sourceValue = source
  local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
  MySQL.ready(function ()
    MySQL.Async.fetchAll('SELECT items.id, item, amount, label, weight, vehicle_mod FROM `vehicle_item`, items, vehicle_mod where vehicle_mod.gameId = @vehicle and vehicle_mod.id = vehicle_item.vehicle_mod and items.id = vehicle_item.item and vehicle_item.amount > 0',
    {
      ['vehicle'] =  vehicle
     },
    function(res)
        TriggerClientEvent(cb, sourceValue, res)
    end)
  end)
end)

RegisterNetEvent("item:get")

-- source is global here, don't add to function
AddEventHandler("item:get", function (cb, type)
  local sourceValue = source
  local discord = exports.bro_core:GetDiscordFromSource(sourceValue) 
  print(type)
  MySQL.ready(function ()
    MySQL.Async.fetchScalar('SELECT amount FROM `player_item`, items, players where players.id = player_item.player and items.id = player_item.item and discord = @discord and item = @item',
    {['@discord'] =  discord, ['@item']  =type},
    function(amount)
      print(amount)
        TriggerClientEvent(cb, sourceValue, amount)
    end)
  end)
end)


RegisterNetEvent("items:give")

-- source is global here, don't add to function
AddEventHandler("items:give", function (type, amount, to)
  local source = source
  local to = to
  local discord = exports.bro_core:GetDiscordFromSource(source) 
  local discordTo = exports.bro_core:GetDiscordFromSource(to) 
  
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


RegisterNetEvent("item:vehicle:get")

-- source is global here, don't add to function
AddEventHandler("item:vehicle:get", function (vehicle, item, amount)
  local sourceValue = source
  local discord = exports.bro_core:GetDiscordFromSource(sourceValue) 

  MySQL.ready(function ()
    MySQL.Async.fetchScalar("SELECT amount FROM `vehicle_item`, players WHERE vehicle_mod = @vehicle and item = @item",
    {
      ['vehicle'] = vehicle,
      ['item'] = item,
    }, function(amounte)
      if amounte and amounte >= amount then
        MySQL.Async.fetchScalar("SELECT players.id FROM `players` WHERE discord = @discord",
        {
          ['discord'] = discord,
        }, function(playerId)
          MySQL.Async.fetchScalar("SELECT SUM(amount * weight) FROM `items`, player_item  WHERE player_item.item= items.id and player_item.player = @player",
          {
            ['@player'] = player,
          }, function(weight)
            MySQL.Async.fetchScalar("SELECT weight FROM `items`  WHERE items.id = @item",
            {
              ['@item'] = item,
            }, function(newWeight)
              if weight == nil then
                weight = 0
              end
              weight = (newWeight*amount)+weight
              if weight <= maxWeight then
                MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
                {
                  ['id'] = playerId,
                  ['type'] = item,
                  ['amount'] = amount,
                },
                function(affectedRows)
                  MySQL.Async.execute('UPDATE `vehicle_item` SET `amount` = amount-@amount WHERE  vehicle_mod = @vehicle and item = @item',
                  {
                    ['vehicle'] = vehicle,
                    ['item'] = item,
                    ['amount'] = amount,
                  },
                  function(affectedRows)
                    TriggerClientEvent("bf:Notification", sourceValue, "Item récupéré")
                  end)
                end)
            else
              TriggerClientEvent("bf:Notification", sourceValue, "~r~ Vous êtes déjà trop chargé !")
            end
          end)
          end)
      end)
      else
        TriggerClientEvent("bf:Notification", sourceValue, "~r~Il n'ya plus d'item dans le coffre")
      end
    end)
  end)
end)


RegisterNetEvent("item:vehicle:store")

-- source is global here, don't add to function
AddEventHandler("item:vehicle:store", function (vehicle, item, amount)
  local sourceValue = source
  local discord = exports.bro_core:GetDiscordFromSource(sourceValue) 
  print(item)
  print(amount)
  MySQL.ready(function ()
    MySQL.Async.fetchScalar("SELECT amount FROM `player_item`, players WHERE item = @item and players.discord = @discord and players.id = player_item.player",
    {
      ['discord'] = discord,
      ['item'] = item,      
    }, function(amounte)
      if amounte and amounte >= amount then
        MySQL.Async.fetchScalar("SELECT vehicle_mod.id FROM `vehicle_mod` WHERE gameId = @vehicle",
        {
          ['vehicle'] = vehicle,
        }, function(vehicleId)
        if vehicleId == nil then
          TriggerClientEvent("bf:Notification", sourceValue, "~r~Ce véhicule est volé")
        else
          MySQL.Async.fetchScalar("SELECT SUM(amount * weight) FROM `items`, vehicle_item  WHERE vehicle_item.item= items.id and vehicle_item.vehicle_mod = @vehicle",
          {
            ['@vehicle'] = vehicleId,
          }, function(weight)
            MySQL.Async.fetchScalar("SELECT weight FROM `items` where id = @id",
            {
              ['@id'] = item,
            }, function(newWeight)
            if weight == nil then
              weight = 0
            end
            weight = (newWeight*amount)+weight
            if weight <= maxWeight then
              MySQL.Async.execute('INSERT INTO `vehicle_item` (`vehicle_mod`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
              {
                ['id'] = vehicleId,
                ['type'] = item,
                ['amount'] = amount,
              },
              function(affectedRows)
                MySQL.Async.execute('UPDATE `player_item`, players SET `amount` = amount-@amount WHERE players.id = player_item.player and players.discord = @discord AND `player_item`.`item` = @item',
                {
                  ['discord'] = discord,
                  ['item'] = item,
                  ['amount'] = amount,
                },
                function(affectedRows)
                  TriggerClientEvent("bf:Notification", sourceValue, "Item stocké")
                end)
            end)
          else
              TriggerClientEvent("bf:Notification", sourceValue, "~r~ Le véhicule est trop chargé")
            end
          end)
        end)
      end
      end)
      else
        TriggerClientEvent("bf:Notification", sourceValue, "~r~Vous n'avez plus d'item")
      end
    end)
  end)
end)

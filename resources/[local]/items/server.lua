
RegisterNetEvent("items:add")

-- source is global here, don't add to function
AddEventHandler("items:add", function (type, amount)
    MySQL.Async.fetchAll('select id from players where fivem = @fivem',
    {['fivem'] =  GetPlayerIdentifiers(source)[5]},
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


RegisterNetEvent("items:sub")

-- source is global here, don't add to function
AddEventHandler("items:sub", function (type, amount)
    MySQL.Async.fetchAll('select id from players where fivem = @fivem',
    {['fivem'] =  GetPlayerIdentifiers(source)[5]},
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
RegisterNetEvent("items:process")

-- source is global here, don't add to function
AddEventHandler("items:process", function (type, amount, typeTo, amountTo)
    local source = source
    MySQL.Async.fetchAll('select id, amount from players, player_item where fivem = @fivem and player_item.item = @type and player_item.player = players.id',
    {['fivem'] =  GetPlayerIdentifiers(source)[5],
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
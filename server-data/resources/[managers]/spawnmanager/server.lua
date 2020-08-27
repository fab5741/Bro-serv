-- source is global here, don't add to function
AddEventHandler('playerDropped', function (reason)
    print('Player ' .. GetPlayerName(source) .. ' dropped (Reason: ' .. reason .. ')')

    print("ping")
    TriggerEvent("player:saveCoords", source)
end)

RegisterNetEvent("player:saveCoordsServer")

-- source is global here, don't add to function
AddEventHandler('player:saveCoordsServer', function(name, pos)
    local sourceValue = source
    local nameValue = name
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select x,y,z from players WHERE fivem = @fivem', {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]}, function(res)
            if(not res[1]) then
                MySQL.Async.execute('INSERT INTO players (`id`, `fivem`, `name`, `x`, `y`, `z`) VALUES (NULL, @fivem, @name, x= @x, y =@y, z = @z)', {
                    ['fivem'] = GetPlayerIdentifiers(sourceValue)[5], ['name'] = nameValue, ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z
                })
            else
                MySQL.Async.execute('UPDATE players SET x= @x, y =@y, z = @z WHERE fivem = @fivem', {
                    ['fivem'] = GetPlayerIdentifiers(sourceValue)[5], ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z
                })
            end
        end)
        MySQL.Async.execute('UPDATE players SET x= @x, y =@y, z = @z WHERE fivem = @fivem', {
            ['fivem'] = GetPlayerIdentifiers(sourceValue)[5], ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z
        })
      end)
end)



RegisterNetEvent("player:spawnPlayerFromLastPos")

-- source is global here, don't add to function
AddEventHandler('player:spawnPlayerFromLastPos', function()
    local sourceValue = source
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select x,y,z from players WHERE fivem = @fivem',
        {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]}, function(res)
            if(res[1]) then
                TriggerClientEvent("player:spawnLastPos", sourceValue, res[1].x, res[1].y, res[1].z)
            else
                TriggerClientEvent("player:spawnLastPos", sourceValue, -1038.709, -2683.085, 15)
            end
            end)
      end)
end)
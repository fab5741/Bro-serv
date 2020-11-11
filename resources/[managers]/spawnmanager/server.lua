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
     --   MySQL.Async.fetchAll('select x,y,z from players WHERE fivem = @fivem', {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]}, function(res)
       --     if(not res[1]) then
         --       MySQL.Async.execute('INSERT INTO players (`id`, `fivem`, `name`, `x`, `y`, `z`, `job_grade`, `onDuty`, `skin`, `liquid`, `firstname`, `lastname`, `sex`, `birth`) VALUES (NULL, @fivem, @name, x= @x, y =@y, z = @z, 1, 0, "",0, "","", 0, "1990-08-04")', {
           --         ['fivem'] = GetPlayerIdentifiers(sourceValue)[5], ['name'] = nameValue, ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z
             --   })
            --else
              --  MySQL.Async.execute('UPDATE players SET x= @x, y =@y, z = @z WHERE fivem = @fivem', {
                --    ['fivem'] = GetPlayerIdentifiers(sourceValue)[5], ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z
                --})
            --end
        --end)
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
        MySQL.Async.fetchAll('select x,y,z, skin from players WHERE fivem = @fivem',
        {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]}, function(res)
            if(res[1]) then
                TriggerClientEvent("player:spawnLastPos", sourceValue, res[1].x, res[1].y, res[1].z, res[1].skin)
            else
                TriggerClientEvent("player:spawnLastPos", sourceValue, -1038.709, -2683.085, 8)
            end
            end)
      end)
end)

RegisterNetEvent("player:get")

-- source is global here, don't add to function
AddEventHandler('player:get', function(cb)
    local sourceValue = source
    local cbe = cb
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT * FROM players WHERE fivem = @fivem', {
            ['@fivem'] =  GetPlayerIdentifiers(sourceValue)[5]
        }, function(res)
            if res and res[1] then
               TriggerClientEvent(cbe, sourceValue, res[1])
            else
                TriggerClientEvent(cbe, sourceValue)
            end
        end)
    end)
end)


RegisterNetEvent("player:set")

-- source is global here, don't add to function
AddEventHandler('player:set', function(data)
    local sourceValue = source
    local dataa = data
    if(dataa.sex)  then
        dataa.sex = 0
    else 
        dataa.sex = 1
    end
    MySQL.ready(function ()
        MySQL.Async.execute("INSERT INTO `players` (`id`, `fivem`, `name`, `x`, `y`, `z`, `job_grade`, `onDuty`, `skin`, `liquid`, `firstname`, `lastname`, `sex`, `birth`) VALUES (NULL, @fivem, '', '-1038.703', '-2683.085', '12', '1', '0', '', '100', @firstname, @lastname, @sex, @birth);", {
            ['@fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
            ['@firstname'] =  dataa.firstName,
            ['@lastname'] =  dataa.lastName,
            ['@sex'] =  dataa.sex,
            ['@birth'] =  dataa.birth,
        }, function(res)
            if res > 0 then
               print("Player Created")
            end
        end)
    end)
end)
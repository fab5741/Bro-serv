-- source is global here, don't add to function
AddEventHandler('playerDropped', function (reason)
    TriggerEvent("player:saveCoords", source)
end)

RegisterNetEvent("player:saveCoordsServer")

-- source is global here, don't add to function
AddEventHandler('player:saveCoordsServer', function(name, pos)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    local nameValue = name
    MySQL.ready(function ()
        MySQL.Async.execute('UPDATE players SET x= @x, y =@y, z = @z, gameId = @gameId WHERE discord = @discord', {
            ['@discord'] = discord, ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z, ['@gameId'] = sourceValue
        })
      end)
end)

RegisterNetEvent("player:get")

-- source is global here, don't add to function
AddEventHandler('player:get', function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    local cbe = cb
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT * FROM players WHERE discord = @discord', {
            ['@discord'] =  discord
        }, function(res)
            if res and res[1] then
               TriggerClientEvent(cbe, sourceValue, res[1])
            else
                TriggerClientEvent(cbe, sourceValue)
            end
        end)
    end)
end)
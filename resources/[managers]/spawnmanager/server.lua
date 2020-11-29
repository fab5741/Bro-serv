-- source is global here, don't add to function
AddEventHandler('playerDropped', function (reason)
    TriggerEvent("player:saveCoords", source)
end)

RegisterNetEvent("player:saveCoordsServer")

-- source is global here, don't add to function
AddEventHandler('player:saveCoordsServer', function(name, pos, weapons)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    local nameValue = name
    local weapons = weapons

    MySQL.ready(function ()
        MySQL.Async.execute('UPDATE players SET x= @x, y =@y, z = @z, gameId = @gameId, weapons = @weapons WHERE discord = @discord', {
            ['@discord'] = discord, ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z, ['@gameId'] = sourceValue, ['@weapons'] = weapons
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


RegisterNetEvent("player:create")

-- source is global here, don't add to function
AddEventHandler('player:create', function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    local cbe = cb
    MySQL.ready(function ()
        MySQL.Async.insert("INSERT INTO `players` (`id`, `discord`, `x`, `y`, `z`, `job_grade`, `onDuty`, `skin`, `liquid`, `firstname`, `lastname`, `birth`, `permis`, `gun_permis`, `gameId`, `phone_number`) VALUES (NULL, @discord, '0', '0', '0', '13', '0', NULL, '100', 'John', 'Smith', '00/01/1901', '0', '0', '-1', '')", {
            ['@discord'] =  discord
        }, function(res)
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
end)
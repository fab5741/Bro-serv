RegisterNetEvent("player:saveCoordsServer")
RegisterNetEvent("player:get")
RegisterNetEvent("player:create")

-- source is global here, don't add to function
AddEventHandler('player:saveCoordsServer', function(pos, weapons, health)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    local weapons = weapons
    local health = health
    MySQL.ready(function ()
        MySQL.Async.execute('UPDATE players SET x= @x, y =@y, z = @z, gameId = @gameId, weapons = @weapons, health = @health WHERE discord = @discord', {
            ['@discord'] = discord, ['x'] = pos.x, ['y'] = pos.y, ['z'] = pos.z, ['@gameId'] = sourceValue, ['@weapons'] = weapons, ['@health'] = health
        })
      end)
end)


-- source is global here, don't add to function
AddEventHandler('player:get', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
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



-- source is global here, don't add to function
AddEventHandler('player:create', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    local cbe = cb
    MySQL.ready(function ()
        MySQL.Async.insert("INSERT INTO `players` (`id`, `discord`, `x`, `y`, `z`, `job_grade`, `onDuty`, `skin`, `liquid`, `firstname`, `lastname`, `birth`, `permis`, `gun_permis`, `gameId`, `phone_number`) VALUES (NULL, @discord, '0', '0', '0', NULL, '0', NULL, '100', 'John', 'Smith', '00/01/1901', '0', '1', '-1', '')", {
            ['@discord'] =  discord
        }, function(player)
            MySQL.Async.fetchAll('SELECT * FROM players WHERE discord = @discord', {
                ['@discord'] =  discord
            }, function(res)
                MySQL.Async.insert("INSERT INTO `accounts` (`id`, `amount`) VALUES (NULL, '1000')", {
                    ['@discord'] =  discord
                }, function(account)
                    MySQL.Async.insert("INSERT INTO `player_account` (`player`, `account`) VALUES (@player, @account)", {
                        ['@player'] =  player,
                        ['@account'] =  account,
                    }, function(id)
                        if res and res[1] then
                            TriggerClientEvent(cbe, sourceValue, res[1])
                        else
                            TriggerClientEvent(cbe, sourceValue)
                        end
                    end)
                end)
            end)
        end)
    end)
end)
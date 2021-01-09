RegisterNetEvent("property:get:all")
RegisterNetEvent("property:buy")
RegisterNetEvent("property:sell")
RegisterNetEvent("property:safe:get")
RegisterNetEvent("property:safe:withdraw")
RegisterNetEvent("property:safe:add")
RegisterNetEvent("property:storage:get:all")
RegisterNetEvent("property:storage:witdhraw")
RegisterNetEvent("property:storage:store")

AddEventHandler("property:get:all", function(cb)
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)
            TriggerClientEvent(cb, sourceValue, properties, discord)
        end)
    end)
end)

AddEventHandler("property:buy", function(property)
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('update properties set owner = @owner where id = @property', {
            ['@property'] = property,
            ['@owner'] = discord,
        }, function(properties)
            -- TODO pay property
        end)
    end)
end)

AddEventHandler("property:sell", function(property)
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('update properties set owner = NULL  where id = @property', {
            ['@property'] = property,
            ['@owner'] = discord,
        }, function(properties)
            -- TODO pay property
        end)
    end)
end)

AddEventHandler("property:safe:get", function(cb, property)
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('select liquid from properties where id = @property', {
            ['@property'] = property.id,
        }, function(liquid)
            -- TODO pay property
            TriggerClientEvent(cb, sourceValue, liquid, property)
        end)
    end)
end)

AddEventHandler("property:safe:withdraw", function(property, nb)
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    local nb = nb
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('select liquid from properties where id = @property', {
            ['@property'] = property.id,
        }, function (liquid)
            print(liquid)
            print(nb)
            if liquid >= nb then
                MySQL.Async.execute('update players set liquid = liquid+@nb where discord = @discord', {
                    ['@discord'] = discord,
                    ['@nb'] = nb
                }, function()
                    MySQL.Async.execute('update properties set liquid = liquid-@nb where id = @property', {
                        ['@property'] = property.id,
                        ['@nb'] = nb
                    }, function()
                        -- TODO pay property
                        TriggerClientEvent("bro_core:Notification", sourceValue, "Argent retiré. " .. exports.bro_core:Money(nb))

                    end)
                end)
            else
                exports.bro_core:Notification("~r~Vous n'avez pas assez d'argent dans le coffre")
            end
        end)
    end)
end)

AddEventHandler("property:safe:add", function(property, nb)
    print("add")
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    local nb = nb
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('select liquid from players where discord = @discord', {
            ['@discord'] = discord,
        }, function (liquid)
            if liquid >= nb then
                MySQL.Async.execute('update players set liquid = liquid-@nb where discord = @discord', {
                    ['@discord'] = discord,
                    ['@nb'] = nb
                }, function()
                    MySQL.Async.execute('update properties set liquid = liquid+@nb where id = @property', {
                        ['@property'] = property.id,
                        ['@nb'] = nb
                    }, function()
                        -- TODO pay property
                        TriggerClientEvent("bro_core:Notification", sourceValue, "Argent déposé. " .. exports.bro_core:Money(nb))
                    end)
                end)
            else
                exports.bro_core:Notification("~r~Vous n'avez pas assez d'argent sur vous")
            end
        end)
    end)
end)


AddEventHandler("property:storage:get:all", function(cb, property)
    local property = property
    local sourceValue = source
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select * from properties, property_item, items  where properties.id = property_item.property and items.id = property_item.item and properties.id = @property', {
            ['@property'] = property.id,
        }, function (items)
            TriggerClientEvent(cb, sourceValue, items, property)
        end)
    end)
end)

AddEventHandler("property:storage:witdhraw", function(property, type, nb)
    local property = property
    local sourceValue = source
    print(property)
    print(type)
    print(nb)
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('select amount from properties, property_item, items  where properties.id = property_item.property and items.id = property_item.item and properties.id = @property and property_item.item = @id', {
            ['@property'] = property.id,
            ['@id'] = type,
        }, function (amount)
            if amount >= nb then
                MySQL.Async.execute('update properties, property_item, items  set amount = amount-@nb where properties.id = property_item.property and items.id = property_item.item and properties.id = @property and property_item.item = @id', {
                    ['@discord'] = discord,
                    ['@nb'] = nb
                }, function()
                    MySQL.Async.fetchScalar("SELECT players.id FROM `players` WHERE discord = @discord",
                    {
                      ['discord'] = discord,
                    }, function(playerId)
                        MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount;',
                        {
                        ['id'] = playerId,
                        ['type'] = type,
                        ['amount'] = amount,
                        },
                        function(affectedRows)
                            TriggerClientEvent("bro_core:Notification", sourceValue, "Item(s) retiré(s)")
                        end)
                    end)
                end)
            else
                TriggerClientEvent("bro_core:Notification", sourceValue, "Pas assez d'items dans le stockage")
            end
        end)
    end)
end)


AddEventHandler("property:storage:store", function(property)
    local property = property
    local sourceValue = source
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select * from properties, property_item, items  where properties.id = property_item.property and items.id = property_item.item and properties.id = @property', {
            ['@property'] = property.id,
        }, function (items)
        end)
    end)
end)


RegisterNetEvent("needs:spawned")

-- source is global here, don't add to function
AddEventHandler('needs:spawned', function()
    TriggerClientEvent("needs:spawned", source)
end)


RegisterNetEvent("needs:change")

-- source is global here, don't add to function
AddEventHandler('needs:change', function(isHunger, amount)
    TriggerClientEvent("needs:change", source, isHunger, amount)
end)

RegisterNetEvent("needs:get")

-- source is global here, don't add to function
AddEventHandler('needs:get', function(bf)
    local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select hunger, thirst from players where discord = @discord',
        {['@discord'] =  discord},
        function(res)
            TriggerClientEvent(bf, sourceValue, res[1].hunger, res[1].thirst)
        end)
    end)
end)

RegisterNetEvent("needs:get2")

-- source is global here, don't add to function
AddEventHandler('needs:get2', function(bf, isHunger, amount)
    local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select hunger, thirst from players where discord = @discord',
        {['@discord'] =  discord},
        function(res)
            hunger = res[1].hunger
            thirst = res[1].thirst
            if(isHunger == 1) then
                hunger = hunger + amount
            else
                thirst = thirst + amount
            end
            if(hunger >100) then
                hunger = 100
            end
            if thirst >100 then
                thirst = 100
            end
            TriggerClientEvent(bf, sourceValue, hunger, thirst)
        end)
    end)
end)



RegisterNetEvent("needs:set")

-- source is global here, don't add to function
AddEventHandler('needs:set', function(hunger, thirst)
    local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('update players set thirst = @thirst, hunger = @hunger where discord = @discord',
        {
            ['@discord'] =  discord,
            ['@hunger'] = hunger,
            ['@thirst'] = thirst
        },
        function(res)
        end)
    end)
end)

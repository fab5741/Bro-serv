RegisterNetEvent("account:money:add")

AddEventHandler('account:money:add', function(player, money)
  MySQL.ready(function ()
    MySQL.Async.execute('UPDATE accounts SET money = money + @money WHERE owner = @owner', {
        ['owner'] = "Léon paquin", ['money'] = money
    })
  end)
end)

RegisterNetEvent("account:liquid")

AddEventHandler('account:liquid', function(cb)
  local sourceValue = source
  MySQL.Async.fetchScalar('SELECT liquid from players where fivem = @fivem', {
    ['fivem'] = GetPlayerIdentifiers(sourceValue)[5]
  }, function(result)
    TriggerClientEvent(cb, sourceValue, result)
  end)
end)
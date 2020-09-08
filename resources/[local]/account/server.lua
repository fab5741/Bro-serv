RegisterNetEvent("account:money:add")

AddEventHandler('account:money:add', function(player, money)
  MySQL.ready(function ()
    MySQL.Async.execute('UPDATE accounts SET money = money + @money WHERE owner = @owner', {
        ['owner'] = "Léon paquin", ['money'] = money
    })
  end)
end)

RegisterNetEvent("account:liquid")

AddEventHandler('account:liquid', function()
  print("mon liquide est de")
  return("yo")
end)
local bank = 0
local firstname = ''
function setBankBalance (value)
      bank = value
      SendNUIMessage({event = 'updateBankbalance', banking = bank})
end


TriggerServerEvent("account:player:get", "phone:account:get")

RegisterNetEvent('phone:account:get')
AddEventHandler('phone:account:get', function(amount)
      setBankBalance(amount)
end)

-- TODO refresh on bank transfers
RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
      if account.name == 'bank' then
            setBankBalance(account.money)
      end
end)

RegisterNetEvent("es:addedBank")
AddEventHandler("es:addedBank", function(m)
      setBankBalance(bank + m)
end)

RegisterNetEvent("es:removedBank")
AddEventHandler("es:removedBank", function(m)
      setBankBalance(bank - m)
end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(bank)
      setBankBalance(bank)
end)
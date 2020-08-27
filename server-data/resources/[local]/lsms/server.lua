RegisterNetEvent("lsms:distress")

AddEventHandler('lsms:distress', function(player)
    --check le nombre d'ambulanciers présent
    print("appel recu de " .. player)

    if true then
        TriggerClientEvent('lsms:revive', -1, true)
    else
    end
end)


RegisterNetEvent("ambulance:distress")

AddEventHandler('ambulance:distress', function(player)
    --check le nombre d'ambulanciers présent
    print("appel recu de " .. player)

    if true then
        TriggerClientEvent('ambulance:revive', -1, true)
    else
    end
end)


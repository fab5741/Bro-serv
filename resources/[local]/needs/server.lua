RegisterNetEvent("needs:spawned")

-- source is global here, don't add to function
AddEventHandler('needs:spawned', function()
    print("spawneddd")
    TriggerClientEvent("needs:spawned", source)
end)


RegisterNetEvent("needs:change")

-- source is global here, don't add to function
AddEventHandler('needs:change', function(isHunger, amount)
    TriggerClientEvent("needs:change", source, isHunger, amount)
end)

RegisterNetEvent("needs:spawned")

-- source is global here, don't add to function
AddEventHandler('needs:spawned', function()
    print("spawneddd")
    TriggerClientEvent("needs:spawned", source)
end)

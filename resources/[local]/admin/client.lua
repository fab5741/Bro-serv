-- vehicles
RegisterCommand('car', function(source, args)
    exports.bf:spawnCar(args[1] or 'adder', args[2] or true, nil, args[3] or true)
end, false)


-- tp
RegisterCommand("tpm", function(source)
    exports.bf:tpPlayer(PlayerPedId(), true)
end)


RegisterCommand("tp", function(source, args)
    if args[1] and args[2] and args[3] then
        pos = vector3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
    else
        pos= vector3(239.61, -2018.95, 18.31)
    end
    exports.bf:tpPlayer(PlayerPedId(), false, pos)
end)

-- health
RegisterCommand("kill", function(source)
    SetEntityHealth(PlayerPedId(),0)
end)

RegisterCommand("revive", function(source)
    TriggerClientEvent('lsms:revive', GetPlayerPed(-1))
end)

-- Money
RegisterCommand("money:add", function(source, args)
    TriggerServerEvent('account:money:add', GetPlayerPed(-1), args[1])
end)

-- Coords
RegisterCommand('coords', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = ""..coords.x..","..coords.y..","..coords.z..""
	})
end)

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
        pos= vector3(239.61, -2018.95, 19.31)
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


RegisterCommand("admin", function(source, args) 
    pos= vector3(-1094.0128173828,-842.43450927734,-46.269840240479)
    exports.bf:tpPlayer(PlayerPedId(), false, pos, true)
end)

RegisterCommand("prison", function(source, args) 
    pos= vector3(1691.6459960938, 2565.0712578125,45.56489944458)
    exports.bf:tpPlayer(PlayerPedId(), false, pos, true)
end)


RegisterCommand("fight", function(source, args) 
    pos= vector3(925.22357177734,-1782.4407958984,31.275489807129)
    exports.bf:tpPlayer(PlayerPedId(), false, pos, true)
end)


RegisterCommand("reset", function(source, args) 
    TriggerEvent('nicoo_charcreator:CharCreator')
end)


RegisterCommand("tir1", function(source, args) 
    pos= vector3(8.6765041351318,-1093.43359375,29.797025680542)
    exports.bf:tpPlayer(PlayerPedId(), false, pos)
end)

RegisterCommand("tir2", function(source, args) 
    pos= vector3(7.8053555488586,-1096.1379394531,29.797016143799)
    exports.bf:tpPlayer(PlayerPedId(), false, pos)
end)
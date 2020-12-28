
local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1) -- Use native GET_PLAYER_PED

function GetPlayers()
    local players = {}

    for _, player in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(player) then
            table.insert(players, player)
        end
    end

    return players
end


function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = nil
	local closestPlayer = nil
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end


function LoadAnimSet(AnimDict)
	if not HasAnimDictLoaded(AnimDict) then
		RequestAnimDict(AnimDict)

		while not HasAnimDictLoaded(AnimDict) do
			Citizen.Wait(1)
		end
	end
end

function LoadModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end

local lockAction = false

function actionPlayer(time, message, dict, anim, cb)
    if lockAction == false then
        TriggerEvent("bf:progressBar:create", time, message)
        lockAction = true
        Citizen.CreateThread(function ()
            FreezeEntityPosition(playerPed, true)
            
            LoadAnimSet(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(150)
            end
            TaskPlayAnim(playerPed, dict, anim, 8.0, 8.0, -1, 0, 0, false, false, false)

            Wait(time)
            lockAction = false
            cb()
            FreezeEntityPosition(playerPed, false)
        end)
    else
        Notification("~r~"..message.. " déjà en cours")
    end
end

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
	--	local players = GetPlayers()
	--	local closestDistance = nil
	--	local closestPlayer = nil
	--	local ply = PlayerPedId()
	--	local plyCoords = GetEntityCoords(ply, 0)
	--	
	--	for index,value in ipairs(players) do
	--		local target = GetPlayerPed(value)
	--		if(target ~= ply) then
	--			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
	--			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
	--			if(closestDistance == -1 or closestDistance > distance) then
	--				closestPlayer = value
	--				closestDistance = distance
	--			end
	--		end
	--	end
	--	return closestPlayer, closestDistance
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)

	--return NetworkGetPlayerIndexFromPed(ped)
	-- DEBUG
	return NetworkGetPlayerIndexFromPed(GetPlayerPed(-1))
end

function GetClosestPed()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	--return ped
	-- DEBUG
	return GetPlayerPed(-1)
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
        TriggerEvent("bro_core:progressBar:create", time, message)
        lockAction = true
        Citizen.CreateThread(function ()		
			if dict and dict ~= ""  and anim and anim ~= "" then
				if dict == "scenario" then
					TaskStartScenarioInPlace(playerPed, anim, 0, true)
				else
					LoadAnimSet(dict)
					TaskPlayAnim(playerPed, dict, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
				end
			end
            Wait(time)
			lockAction = false
			ClearPedTasksImmediately(PlayerPedId())
			cb()
        end)
    else
        Notification("~r~"..message.. " déjà en cours")
    end
end


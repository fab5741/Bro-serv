--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

local playerPed = nil
local playerCoords = {}

--
-- Update ped and coords for player
--
function UpdatePlayerThread()
  Citizen.CreateThread(function()

      while true do

        playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, -1) -- Use native GET_PLAYER_PED
        local coords = GetEntityCoords(playerPed)
        playerCoords = { ["x"] = coords.x, ["y"] = coords.y, ["z"] = coords.z }
        Citizen.Wait(200)

      end

  end)
end

--
--
--
function GetPlayerPed()

    return playerPed

end

--
--
--
function GetPlayerCoords()

    return playerCoords

end

--
-- Get player in direction
--
function GetPlayerPedInDirection(range)

    if type(range) ~= "number" then
        range = 20.0
    end
    local entity = GetPedInDirection(range)
    if DoesEntityExist(entity) then
        local target = NetworkGetPlayerIndexFromPed(entity)
        local id = GetPlayerServerId(target)
        if id ~= nil then
            return entity
        end
    end
    return false

end

--
-- Get player ped server id in direction
--
function GetPlayerServerIdInDirection(range)

    if type(range) ~= "number" then
        range = 15.50
    end
    local entity = GetPedInDirection(range)
    if DoesEntityExist(entity) then
        local entity = NetworkGetPlayerIndexFromPed(entity)
        local id = GetPlayerServerId(entity)
        if id ~= nil then
            return id
        end
    end
    return false

end

--
--
--
function GetPlayersPed()

    local players = {}
    local playerPed = GetPlayerPed()
    for i = 0, 32, 1 do
        local ped = GetPlayerPed(i)
        if DoesEntityExist(ped) and id ~= playerPed then
          table.insert(players, i)
        end
    end
    return players

end

--
--
--
function GetPlayersId()

    local players = {}
    local playersPed = GetPlayersPed()
    for key, ped in pairs(playersPed) do
        if DoesEntityExist(ped) and ped ~= GetPlayerPed() then
            local network = NetworkGetPlayerIndexFromPed(ped)
            local id = GetPlayerServerId(network)
            if id ~= nil then
                table.insert(players, id)
            end
        end
    end
    return players

end

--
--
--
function GetPlayersPedOrderById()

    local players = {}
    local playersPed = GetPlayersPed()
    for key, ped in pairs(playersPed) do
        if DoesEntityExist(ped) and ped ~= GetPlayerPed() then
            local network = NetworkGetPlayerIndexFromPed(ped)
            local id = GetPlayerServerId(network)
            if id ~= nil then
                players[id] = ped
            end
        end
    end
    return players

end

--
-- Is Ped driving a veh ?
--
function isPedDrivingAVehicle()
	local ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		-- Check if ped is in driver seat
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains
			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				return true
			end
		end
	end
	return false
end


--
-- TP player
--
function tpPlayer(ped, marker, pos)
    if marker and DoesBlipExist(GetFirstBlipInfoId(8)) then
        pos = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
    end

    for height = 1, 1000 do
        SetPedCoordsKeepVehicle(ped, pos["x"], pos["y"], height + 0.0)

        local foundGround, zPos = GetGroundZFor_3dCoord(pos["x"], pos["y"], height + 0.0)

        if foundGround then
            SetPedCoordsKeepVehicle(ped, pos["x"], pos["y"], height + 0.0)
            break
        end

        Citizen.Wait(5)
    end
end
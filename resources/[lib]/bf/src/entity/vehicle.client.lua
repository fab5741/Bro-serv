--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

--
-- Get all vehicles
--
function GetVehicles()

  return GetEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)

end

--
-- Get vehicle in direction
--
function GetVehicleInDirection(range)

    if type(range) ~= "number" then
        range = 20.0
    end
    local entity = GetEntityInDirection(range)
    if DoesEntityExist(entity) then
        if GetEntityType(entity) == 2 then
            return entity
        end
    end
    return false

end

--
-- Get vehicles in area
--
function GetVehiclesInArea(settings)

    local settings = settings or {}
    settings.entities = GetVehicles()
    return GetEntitiesInArea(settings)

end

--
-- Get vehicles in around
--
function GetVehiclesInAround(settings)

    local settings = settings or {}
    settings.entities = GetVehicles()
    return GetEntitiesInAround(settings)

end


--
-- Spawn A car
--
function spawnCar(vehicleName, keep, pos, direct)
    print("spawn car")
    print(vehicleName)
    print(pos)
    -- check if the vehicle actually exists
    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        return false
    end

    -- load the model
    RequestModel(vehicleName)

    -- wait for the model to load
    while not HasModelLoaded(vehicleName) do
        Wait(500) -- often you'll also see Citizen.Wait
    end

    local playerPed = PlayerPedId() -- get the local player ped

    if pos == nil then
        pos = GetEntityCoords(playerPed) -- get the position of the local player ped
    end

    -- create the vehicle
    local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

    SetVehicleOnGroundProperly(vehicle)
	SetVehicleHasBeenOwnedByPlayer(vehicle,true)

    SetVehRadioStation(vehicle, "OFF")	
    
	local netid = NetworkGetNetworkIdFromEntity(policevehicle)
	SetNetworkIdCanMigrate(netid, true)
	NetworkRegisterEntityAsNetworked(VehToNet(policevehicle))

    if direct then
        SetPedIntoVehicle(playerPed, vehicle, -1)
    else
        TaskWarpPedIntoVehicle(playerPed, policevehicle, -1)
    end
	SetEntityInvincible(policevehicle, false)	

    -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
    if not keep then
        SetEntityAsNoLongerNeeded(vehicle)
    end

    -- release the model
    SetModelAsNoLongerNeeded(vehicleName)
    return vehicle
end
-- function as existing in original R* scripts
local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        --SetCharNeverTargetted(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        --SetCharNeverTargetted(ped, true)
        SetPlayerInvincible(player, true)
        --RemovePtfxFromPed(ped)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

local spawnLock = false

-- spawns the current player at a certain spawn point index (or a random one, for that matter)
function spawnPlayer(x, y, z)     
    if spawnLock then
        return
    end
    
    spawnLock = true

    Citizen.CreateThread(function()

        DoScreenFadeOut(500)

        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end

        -- freeze the local player
        freezePlayer(PlayerId(), true)
        local model = "a_m_y_vindouche_01"
        RequestModel(model)

        -- load the model for this spawn
        while not HasModelLoaded(model) do
            RequestModel(model)

            Wait(0)
        end

        -- change the player model
        SetPlayerModel(PlayerId(), model)

        -- release the player model
        SetModelAsNoLongerNeeded(model)      

            -- RDR3 player model bits
            if N_0x283978a15512b2fe then
				N_0x283978a15512b2fe(PlayerPedId(), true)
            end

            print("spawn at ",x,y,z)
        -- preload collisions for the spawnpoint
        RequestCollisionAtCoord(x, y, z)

        -- spawn the player
        local ped = PlayerPedId()

        -- V requires setting coords as well
        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), x, y, height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(x, y, height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), x, y, height + 0.0)

                break
            end

            Citizen.Wait(5)
        end

    --    NetworkResurrectLocalPlayer(x, y, z, 0, true, true, false)

        -- gamelogic-style cleanup stuff
        ClearPedTasksImmediately(ped)
        ClearPlayerWantedLevel(PlayerId())
        SetMaxWantedLevel(0)

        local time = GetGameTimer()

        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end

        ShutdownLoadingScreen()

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)

            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
        end

        -- and unfreeze the player
        freezePlayer(PlayerId(), false)

        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
      spawnLock = false
    end)
end

-- automatic spawning monitor thread, too
local spawned = false

Citizen.CreateThread(function()
    -- wait for player to be spawned
    while not spawned do
        Citizen.Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent("player:spawnPlayerFromLastPos")
            spawned = true
        end 
    end

    -- le player est spawn, on check des events
    while spawned do
        Citizen.Wait(2000)
        if(IsPedDeadOrDying(GetPlayerPed(-1)) and not isDead)then
            TriggerEvent("player:dead")
        end
    end
end)

RegisterNetEvent("player:saveCoords")

-- source is global here, don't add to function
AddEventHandler('player:saveCoords', function ()
    print("piong")
    TriggerServerEvent("player:saveCoordsServer", GetPlayerName(PlayerId()),GetEntityCoords(GetPlayerPed(-1)))
end)

-- boucle pour sauvegarder toutes les X s
Citizen.CreateThread(function()
    while true do
        Wait(10000)
        TriggerEvent("player:saveCoords")
    end
end)


RegisterNetEvent("player:spawnLastPos")

-- source is global here, don't add to function
AddEventHandler('player:spawnLastPos', function (x,y,z)
    spawnPlayer(x, y, z)
end)

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
function spawnPlayer(x, y, z, weapons)     
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
       
        -- preload collisions for the spawnpoint
        RequestCollisionAtCoord(x, y, z)

        -- spawn the player
        local ped = PlayerPedId()

        -- V requires setting coords as well
        for height = z, 1000 do
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

        TriggerServerEvent("player:spawned")
        TriggerServerEvent("needs:spawned")
        
        Wait(2000)
        for k,v in pairs(json.decode(weapons)) do
            print(v)
            GiveWeaponToPed(GetPlayerPed(-1), v, 100, false, false)
        end

       spawnLock = false
    end)
end

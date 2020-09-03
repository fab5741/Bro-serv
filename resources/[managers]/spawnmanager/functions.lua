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
function spawnPlayer(x, y, z, skin)     
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
        local model = "mp_m_freemode_01"
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
        skin = nil   
        if(skin == nil) then
            skin ={
                sex          = 0,
                face         = 0,
                skin         = 0,
                beard_1      = 0,
                beard_2      = 0,
                beard_3      = 0,
                beard_4      = 0,
                hair_1       = 0,
                hair_2       = 0,
                hair_color_1 = 0,
                hair_color_2 = 0,
                tshirt_1     = 0,
                tshirt_2     = 0,
                torso_1      = 0,
                torso_2      = 0,
                decals_1     = 0,
                decals_2     = 0,
                arms         = 0,
                pants_1      = 0,
                pants_2      = 0,
                shoes_1      = 0,
                shoes_2      = 0,
                mask_1       = 0,
                mask_2       = 0,
                bproof_1     = 0,
                bproof_2     = 0,
                chain_1      = 0,
                chain_2      = 0,
                helmet_1     = 0,
                helmet_2     = 0,
                glasses_1    = 0,
                glasses_2    = 0,
            }
        else
            skin = json.decode(skin)
        end
        TriggerEvent('skinchanger:loadSkin', skin)
       
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
        
       spawnLock = false
    end)
end

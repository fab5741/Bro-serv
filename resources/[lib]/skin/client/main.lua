function CreateSkinCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local playerPed = PlayerPedId()

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    isCameraActive = true
    SetCamRot(cam, 0.0, 0.0, 270.0, true)
    SetEntityHeading(playerPed, 0.0)
end

function DeleteSkinCam()
    isCameraActive = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if not skinLoaded and isCameraActive then
            DisableControlAction(2, 30, true)
            DisableControlAction(2, 31, true)
            DisableControlAction(2, 32, true)
            DisableControlAction(2, 33, true)
            DisableControlAction(2, 34, true)
            DisableControlAction(2, 35, true)
            DisableControlAction(0, 25, true) -- Input Aim
            DisableControlAction(0, 24, true) -- Input Attack

            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)

            local angle = heading * math.pi / 180.0
            local theta = {
                x = math.cos(angle),
                y = math.sin(angle)
            }

            local pos = {
                x = coords.x + (zoomOffset * theta.x),
                y = coords.y + (zoomOffset * theta.y)
            }

            local angleToLook = heading - 140.0
            if angleToLook > 360 then
                angleToLook = angleToLook - 360
            elseif angleToLook < 0 then
                angleToLook = angleToLook + 360
            end

            angleToLook = angleToLook * math.pi / 180.0
            local thetaToLook = {
                x = math.cos(angleToLook),
                y = math.sin(angleToLook)
            }

            local posToLook = {
                x = coords.x + (zoomOffset * thetaToLook.x),
                y = coords.y + (zoomOffset * thetaToLook.y)
            }

            SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
            PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)

            ESX.ShowHelpNotification(_U('use_rotate_view'))
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    local angle = 90

    while true do
        Citizen.Wait(0)

        if isCameraActive then
            if IsControlPressed(0, 108) then
                angle = angle - 1
            elseif IsControlPressed(0, 109) then
                angle = angle + 1
            end

            if angle > 360 then
                angle = angle - 360
            elseif angle < 0 then
                angle = angle + 360
            end

            heading = angle + 0.0
        else
            Citizen.Wait(500)
        end
    end
end)

function OpenSaveableMenu(submitCb, cancelCb, restrict)
    TriggerEvent('skinchanger:getSkin', function(skin) lastSkin = skin end)

    OpenMenu(function(data, menu)
        menu.close()
        DeleteSkinCam()

        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent('skin:save', skin)

            if submitCb ~= nil then
                submitCb(data, menu)
            end
        end)

    end, cancelCb, restrict)
end


AddEventHandler('skin:resetFirstSpawn', function()
    firstSpawn = true
    skinLoaded = false
end)

AddEventHandler('skin:playerRegistered', function()
    Citizen.CreateThread(function()
        while not playerLoaded do
            Citizen.Wait(100)
        end

        if firstSpawn then
            ESX.TriggerServerCallback('skin:getPlayerSkin', function(skin, jobSkin)
                if skin == nil then
                    print("on lance l'éditeur")
                    TriggerEvent('nicoo_charcreator:CharCreator')
                    Citizen.Wait(100)
                    skinLoaded = true
                else
                    TriggerEvent('skinchanger:loadSkin', skin)
                    Citizen.Wait(100)
                    skinLoaded = true
                end
            end)

            firstSpawn = false
        end
    end)
end)

AddEventHandler('skin:getLastSkin', function(cb) cb(lastSkin) end)
AddEventHandler('skin:setLastSkin', function(skin) lastSkin = skin end)

RegisterNetEvent('skin:openMenu')
AddEventHandler('skin:openMenu', function(submitCb, cancelCb)
    OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('skin:openRestrictedMenu')
AddEventHandler('skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
    OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('skin:openSaveableMenu')
AddEventHandler('skin:openSaveableMenu', function(submitCb, cancelCb)
    OpenSaveableMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('skin:openSaveableRestrictedMenu')
AddEventHandler('skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
    OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('skin:requestSaveSkin')
AddEventHandler('skin:requestSaveSkin', function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('skin:responseSaveSkin', skin)
    end)
end)

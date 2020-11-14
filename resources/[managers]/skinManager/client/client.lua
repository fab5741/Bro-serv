local cam, isCameraActive
local zoomOffset, camOffset, heading =  0.0, 0.0, 90.0

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

function changeSkin()
	heading = GetEntityHeading(playerPed)

	SendNUIMessage({
		type = 'open',
		value = 'head'
	})
	-- SET_NUI_FOCUS
	SetNuiFocus(
		true, 
		true
	)
	CreateSkinCam()
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

            SetCamCoord(cam, pos.x+1, pos.y+1, coords.z)
            PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z)
        else
            Citizen.Wait(500)
        end
    end
end)


RegisterCommand('register', function(source, args)
	print("change skin")
	changeSkin()
end, false)


-- For tests
--Citizen.CreateThread(function()
--	Wait(1000)
--	changeSkin()
--end)

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

function saveSkin()
	Wait(5)
	TriggerEvent('skinchanger:getSkin', function(skin)
		print("getskin")
		TriggerServerEvent('skinManager:set', skin)
	end)
end

RegisterNUICallback('close', function(data)
	SetNuiFocus(
		false, 
		false
	)
	DeleteSkinCam()
end)

RegisterNUICallback('sexe', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "sex", data)
    saveSkin()
end)

RegisterNUICallback('face', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "face", data)
    saveSkin()
end)

RegisterNUICallback('haircolor_1', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "hair_color_1", data)
    saveSkin()
end)

RegisterNUICallback('hair_color_2', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "hair_color_2", data)
    saveSkin()
end)


RegisterNUICallback('torso_1', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "torso_1", data)
    saveSkin()
end)

RegisterNUICallback('torso_2', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "torso_2", data)
    saveSkin()
end)

RegisterNUICallback('tshirt_1', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "tshirt_1", data)
    saveSkin()
end)

RegisterNUICallback('tshirt_2', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "tshirt_2", data)
    saveSkin()
end)


RegisterNUICallback('pants_1', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "pants_1", data)
    saveSkin()
end)

RegisterNUICallback('pants_2', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "pants_2", data)
    saveSkin()
end)


RegisterNUICallback('shoes_1', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "shoes_1", data)
    saveSkin()
end)

RegisterNUICallback('pants_2', function(data)
	data = tonumber(data)
	TriggerEvent('skinchanger:change', "shoes_2", data)
    saveSkin()
end)

AddEventHandler('onResourceStop', function(resource)
	SetNuiFocus(
		false, 
		false
	)
end)
local job = {
	job = "Chomeur",
	grade = "Chomeur"
}

anyMenuOpen = {
	menuName = "",
	isActive = false
}
RegisterNetEvent('job:get')

AddEventHandler("job:get", function(job)
	job = job[1]
	RegisterNUICallback('amount', function(data)
		print(job.job)
		TriggerServerEvent("job:safe:deposit", data.withdraw, data.amount, job.job)
		amount = tonumber(data.amount)
		SetNuiFocus(false, false)
	end)
	-- Draw blips 
	v = config.jobs[job.job]
	if v then
		drawBlip(v)
		for k, v in pairs(v.lockers) do
			drawBlip(v)
		end
		for k, v in pairs(v.collect) do
			drawBlip(v)
		end
		for k, v in pairs(v.process) do
			drawBlip(v)
		end
		for k, v in pairs(v.safe) do
			drawBlip(v)
		end
		for k, v in pairs(v.parking) do
			drawBlip(v)
		end
	end
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false
		local currentstation, currentPart, currentPartNum

		t = config.jobs[job.job]
		if t then
			for k, v in pairs(t.lockers) do
				DrawMyMarker(playerCoords, v, job.job)
			end
			for k, v in pairs(t.collect) do
				DrawMyMarker(playerCoords, v, job.job)
			end
			for k, v in pairs(t.process) do
				DrawMyMarker(playerCoords, v, job.job)
			end
			for k, v in pairs(t.safe) do
				DrawMyMarker(playerCoords, v, job.job)
			end
			for k, v in pairs(t.parking) do
				DrawMyMarker(playerCoords, v, job.job)
			end
		end
	end
end)

TriggerServerEvent("job:get", "job:get")

RegisterNUICallback('sendAction', function(data, cb)
	_G[data.action](data.params)
    cb('ok')
end)


--
--Threads
--
local alreadyDead = false
local playerStillDragged = false

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(5)	
		if(anyMenuOpen.isActive) then
			DisableControlAction(1, 21)
			DisableControlAction(1, 140)
			DisableControlAction(1, 141)
			DisableControlAction(1, 142)

			SetDisableAmbientMeleeMove(PlayerPedId(), true)

			if (IsControlJustPressed(1,172)) then
				SendNUIMessage({
					action = "keyup"
				})
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (IsControlJustPressed(1,173)) then
				SendNUIMessage({
					action = "keydown"
				})
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (anyMenuOpen.menuName == "cloackroom") then
				if IsControlJustPressed(1, 176) then
					SendNUIMessage({
						action = "keyenter"
					})

					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					Citizen.Wait(500)
					CloseMenu()
				end
			elseif (IsControlJustPressed(1,176)) then
				SendNUIMessage({
					action = "keyenter"
				})
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			elseif (IsControlJustPressed(1,177)) then
				if(anyMenuOpen.menuName == "cloackroom") then
					CloseMenu()
				end
			end
		else
			EnableControlAction(1, 21)
			EnableControlAction(1, 140)
			EnableControlAction(1, 141)
			EnableControlAction(1, 142)
		end
	
		--Control death events
		if(config.useModifiedEmergency == false) then
			if(IsPlayerDead(PlayerId())) then
				if(alreadyDead == false) then
					if(isInService) then
						ServiceOff()
					end
					alreadyDead = true
				end
			else
				alreadyDead = false
			end
		end
    end
end)

--functions

function isNearTakeService()
	local distance = 10000
	local pos = {}
	t = config.jobs[job.job]
	if t then
		for k, v in pairs(t.lockers) do
			local coords = GetEntityCoords(PlayerPedId(), 0)
			local currentDistance = coords - v.coords
			if(currentDistance < distance) then
				distance = currentDistance
				pos = v.coords
			end
		end
	end
	
	if anyMenuOpen.menuName == "cloackroom" and anyMenuOpen.isActive and distance > 3 then
		--CloseMenu()
	end

	if(distance < 30) then
		if anyMenuOpen.menuName ~= "cloackroom" and not anyMenuOpen.isActive then
			DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
		end
	end

	if(distance < 2) then
		return true
	end
end

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(5)	
		if(isNearTakeService()) then
			if not (anyMenuOpen.isActive) then
				DisplayHelpText("Vestiaire".. GetLabelText("collision_8vlv02g"),0,1,0.5,0.8,0.6,255,255,255,255)
				if IsControlJustPressed(1,config.bindings.interact_position) then
					load_cloackroom(job)
					OpenCloackroom(job)
				end
			end
		end
	end
end)


RegisterNetEvent('job:openStorageMenu')

AddEventHandler("job:openStorageMenu", function(location, job)   
	sell(location, job)
end)
local job = "Chomeur"
local grade = "Chomeur"
anyMenuOpen = {
	menuName = "",
	isActive = false
}


Citizen.CreateThread(function()
--	TriggerServerEvent("job:get")
   -- TriggerEvent("job:draw")
   -- Wait(0)
 --   while true do
   --     Wait(30)
--
  --      DrawTextOnSCreen(0.90,0.95, "Job : " .. job)
    --    DrawTextOnSCreen(0.90, 0.975, "Grade : ".. grade)
    -- end

end)

-- Draw markers & Marker logic
Citizen.CreateThread(function()
    -- Draw blips
	for k,v in pairs(config.jobs) do
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
		for k, v in pairs(v.sell) do
			drawBlip(v)
		end
    end
	while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local letSleep, isInMarker, hasExited = true, false, false
        local currentstation, currentPart, currentPartNum

		for k,job in pairs(config.jobs) do
			for k, v in pairs(job.lockers) do
				DrawMyMarker(playerCoords, v, job)
			end
			for k, v in pairs(job.collect) do
				DrawMyMarker(playerCoords, v, job)
			end
			for k, v in pairs(job.process) do
				DrawMyMarker(playerCoords, v, job)
			end
			for k, v in pairs(job.sell) do
				DrawMyMarker(playerCoords, v, job)
			end
        end
	end
end)


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
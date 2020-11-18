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
		for k, v in pairs(v.lockers) do
			exports.bf:AddArea("lockers"..k, {
				marker = {
					weight = 1,
					height = 2,
				},
				trigger = {
					weight = 2,
					enter = {
						callback = function()
							exports.bf:HelpPromt("Vestiaire Key : ~INPUT_PICKUP~")
							zone = k
							zoneType = "lockers"
						end
					},
					exit = {
						callback = function()
							zone = nil
							zoneType = nil
						end
					},
				},
				blip = {
					text = job.job.. " Vestiaire "..k,
					imageId	= 496,
					colorId = 26,
				},
				locations = {
					{
						x = v.coords.x,
						y = v.coords.y,
						z = v.coords.z,
					},
				},
			})
			exports.bf:AddMenu("lockers"..k, {
				title = "Vestiaire "..k,
				position = 1,
				buttons = {
					{
						text = "Prendre le service",
						exec = {
							callback = function()
								clockIn(job.job)
							end
						},
					},
					{
						text = "Quitter le service",
						exec = {
							callback = function()
								clockOut(job.job)
							end
						},
					},
					{
						text = "Close menu",
						close = true,
					},
				},
			})
		end
		for k, v in pairs(v.collect) do
			exports.bf:AddArea("collect"..k, {
				marker = {
					weight = 1,
					height = 2,
				},
				trigger = {
					weight = 2,
					enter = {
						callback = function()
							exports.bf:HelpPromt("Récolte Key : ~INPUT_PICKUP~")
							zone = k
							zoneType = "collect"
						end
					},
					exit = {
						callback = function()
							zone = nil
							zoneType = nil
						end
					},
				},
				blip = {
					text = job.job.. " Récolte "..k,
					imageId	= 496,
					colorId = 26,
				},
				locations = {
					{
						x = v.coords.x,
						y = v.coords.y,
						z = v.coords.z,
					},
				},
			})
			label = config.jobs[job.job].label

			buttons = {}
			for kk, vv in pairs(v.items) do

				buttons[#buttons+1] = {
					text = "Collecter"..vv.label,
					exec = {
						callback = function()
							
						end
					},
				}
			end
			buttons[#buttons+1] = {
				text = "Arreter le farming",
				close = true,
			}

			buttons = {
				{
					text = "Prendre le service",
					exec = {
						callback = function()
							clockIn(job.job)
						end
					},
				},
				{
					text = "Quitter le service",
					exec = {
						callback = function()
							clockOut(job.job)
						end
					},
				},
				{
					text = "Close menu",
					close = true,
				},
			}
			TriggerEvent("bf:PrintTable", buttons)

			exports.bf:AddMenu("collect "..k, {
				title = "Récolte "..k,
				position = 1,
				buttons 
			})
		end
		for k, v in pairs(v.process) do
			exports.bf:AddBlip("process"..k, {
				x = v.coords.x,
				y = v.coords.y,
				z = v.coords.z,
				text = job.job.. " Traitement "..k,
				imageId	= 467,
				colorId = 26,
			})
		end
		for k, v in pairs(v.safe) do
			exports.bf:AddBlip("safe"..k, {
				x = v.coords.x,
				y = v.coords.y,
				z = v.coords.z,
				text = job.job.." Coffre ",
				imageId	= 475,
				colorId = 26,
			})
		end
		for k, v in pairs(v.parking) do
			exports.bf:AddBlip("parking"..k, {
				x = v.coords.x,
				y = v.coords.y,
				z = v.coords.z,
				text = job.job.." Parking" ,
				imageId	= 477,
				colorId = 26,
			})
		end
	end
	local playerCoords = GetEntityCoords(PlayerPedId())
	local letSleep, isInMarker, hasExited = true, false, false
	local currentstation, currentPart, currentPartNum

	t = config.jobs[job.job]
	if t then
		for k, v in pairs(t.collect) do
			exports.bf:AddMarker("collect"..k, {
				x = v.coords.x,
				y = v.coords.y,
				z = v.coords.z,
				weight = 1,
				height = 2,
			})
		end
		for k, v in pairs(t.process) do
			exports.bf:AddMarker("process"..k, {
				x = v.coords.x,
				y = v.coords.y,
				z = v.coords.z,
				weight = 1,
				height = 2,
			})
		end
		for k, v in pairs(t.safe) do
			exports.bf:AddMarker("safe"..k, {
				x = v.coords.x,
				y = v.coords.y,
				z = v.coords.z,
				weight = 1,
				height = 2,
			})
		end
		for k, v in pairs(t.parking) do
			exports.bf:AddMarker("parking"..k, {
				x = v.coords.x,
				y = v.coords.y,
				z = v.coords.z,
				weight = 1,
				height = 2,
			})
		end
	end
end)


--redirect callbacks
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


-- open menu loop
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)	
		if zone ~= nil and zoneType ~= nil and IsControlJustPressed(1,config.bindings.interact_position) then
			exports.bf:OpenMenu(zoneType..zone)
		end
	end
end)


RegisterNetEvent('job:openStorageMenu')

AddEventHandler("job:openStorageMenu", function(location, job)   
	sell(location, job)
end)
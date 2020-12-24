local isInRangeCollect = nil
local isInRangeProcess = nil
local isInRangeSelling = nil

isSellingDrug = false
nbMalettes = 0

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(config.drugs) do
			if GetDistanceBetweenCoords(coords, v.collect.tp.start.x, v.collect.tp.start.y, v.collect.tp.start.z, true) < config.range and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
				SetPedCoordsKeepVehicle(PlayerPedId(), v.collect.tp.endpoint.x, v.collect.tp.endpoint.y, v.collect.tp.endpoint.z)
				Wait(5000)
			end
			if GetDistanceBetweenCoords(coords, v.collect.tp.endpoint.x, v.collect.tp.endpoint.y, v.collect.tp.endpoint.z, true) < config.range and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
				SetPedCoordsKeepVehicle(PlayerPedId(), v.collect.tp.start.x, v.collect.tp.start.y,  v.collect.tp.start.z)
				Wait(5000)
			end
			for kk,vv in pairs(v.collect) do
				if GetDistanceBetweenCoords(coords, vv.x, vv.y, vv.z, true) < config.range then
					if  isInRangeCollect == nil  then
						exports.bro_core:Notification("Hey, tu veux de la beuh, mon bro ? (E)")
						isInRangeCollect = vv
					end
				else
					if  isInRangeCollect == vv  then
						isInRangeCollect = nil
					end
				end
			end
			for kk,vv in pairs(v.process) do
				if GetDistanceBetweenCoords(coords, vv.x, vv.y, vv.z, true) < config.range then
					if  isInRangeProcess == nil  then
						exports.bro_core:Notification("Tu sais comment faire des pochons ?")
						isInRangeProcess = vv
					end
				else
					if  isInRangeProcess == vv  then
						isInRangeProcess = nil
					end
				end
			end
		end
		for kk,vv in pairs(config.shops) do
			if GetDistanceBetweenCoords(coords, vv.pos.x, vv.pos.y, vv.pos.z, true) < config.range then
				exports.bro_core:Notification("PSST, tu sais pas ou trouver des malettes d'argent ?")
				isInRangeSelling = true
			else
				isInRangeSelling = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(config.shops) do
		RequestModel(GetHashKey(v.pnj.model))
		while not HasModelLoaded(GetHashKey(v.pnj.model)) do
			Wait(1)
		end
	
	-- Spawn the bartender to the coordinates
		bartender =  CreatePed(5, v.pnj.model, v.pnj.x, v.pnj.y, v.pnj.z, v.pnj.h, false, true)
		SetBlockingOfNonTemporaryEvents(bartender, true)
		SetPedCombatAttributes(bartender, 46, true)
		SetPedFleeAttributes(bartender, 0, 0)
		SetPedRelationshipGroupHash(bartender, GetHashKey("CIVFEMALE"))
	end
	while true do
		Wait(0)
		if (IsControlJustPressed(1,config.interactKey)) then
			if isInRangeCollect ~= nil then
				exports.bro_core:actionPlayer(4000, "Récolte de weed", "amb@world_human_gardener_plant@male@enter", "enter", function ()
					TriggerServerEvent("items:add",  6, 5, "Vous récoltez un peu de ~g~weed (non traité)")
				end)
			end
			if isInRangeProcess ~= nil then
				exports.bro_core:actionPlayer(4000, "Transformation de la weed", "amb@world_human_gardener_plant@male@enter", "enter", function ()
					TriggerServerEvent("items:process",  6, 10, 7, 5)
				end)
			end
			if isInRangeSelling ~= nil then
				nbMalettes = exports.bro_core:OpenTextInput({ title = "Combien ?", customTitle= true, defaultText = "", maxInputLength = 5 })
				exports.bro_core:actionPlayer(4000, "Vente en cours", "amb@world_human_gardener_plant@male@enter", "enter", function ()
					TriggerServerEvent("item:get", "crime:malette:sell", 8)
				end)
			end
		end
		-- detect fires shoot
		if IsPedShooting(GetPlayerPed(-1)) then
			local random = math.random (0,config.shootingCopsRate)
			if random < 1 then
				TriggerServerEvent("job:avert:all", "lspd", "Coups de feu en cour", true, GetEntityCoords(GetPlayerPed(-1)))
			end				
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(15)
			local handle, ped = FindFirstPed()
			repeat
				if isSellingDrug then
					coords = GetEntityCoords(PlayerPedId())
					success, ped = FindNextPed(handle)
					local pos = GetEntityCoords(ped)
					local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords['x'], coords['y'], coords['z'], true)
					if not IsPedInAnyVehicle(playerPed) then
						if DoesEntityExist(ped) then
							if not IsPedDeadOrDying(ped) then
								if not IsPedInAnyVehicle(ped) then
									local pedType = GetPedType(ped)
									if pedType ~= 28 and not IsPedAPlayer(ped) then
										currentped = pos
										if distance <= 2 and ped ~= playerPed and ped ~= oldped then
											exports.bro_core:Show3DText({
												x= pos.x,
												y= pos.y,
												z= pos.z,
												text= "Vendre",
												red=105,
												green=255,
												blue=102,
											})
											if IsControlJustPressed(1, 86) then
												oldped = ped
												--SetEntityHeading(ped, 180)
												TaskLookAtCoord(ped, coords['x'], coords['y'], coords['z'], -1, 2048, 3)
												TaskStandStill(ped, 100.0)
												SetEntityAsMissionEntity(ped)
												local pos1 = GetEntityCoords(ped)
												if GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, coords['x'], coords['y'], coords['z'], true) <= 2 then
													exports.bro_core:actionPlayer(4000, "Vente en cours",
													 "mp_common",
													 "givetake2_a", function ()
														TriggerServerEvent('crime:drug:sell', pos1)
													end)
												else
													exports.bro_core:Notification("~r~Vous êtes trop éloigné")
												end
												Wait(2500)
												SetPedAsNoLongerNeeded(oldped)
											end
										end
									end
								end
							end
						end
					end
				end
	until not success
	EndFindPed(handle)
	end
end)


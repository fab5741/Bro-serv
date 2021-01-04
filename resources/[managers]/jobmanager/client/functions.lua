-- Refresh areas and menus
function refresh(job)
	deleteMenuAndArea()
	createMenuAndArea(job)
end


function deleteMenuAndArea()
	exports.bro_core:RemoveArea("center")
	exports.bro_core:RemoveMenu("armory")
	exports.bro_core:RemoveMenu("safe")
	exports.bro_core:RemoveMenu("lockers")
	exports.bro_core:RemoveMenu("actions")
	exports.bro_core:RemoveMenu("fines")
	exports.bro_core:RemoveMenu("props")
	exports.bro_core:RemoveMenu("animations")
	exports.bro_core:RemoveMenu("job")
	for kk, vv in pairs(config.jobs) do
		if vv.homes then
			for k, v in pairs(vv.homes) do
				exports.bro_core:RemoveArea("homes"..kk..k)
			end
		end
		if vv.repair then
			for k, v in pairs(vv.repair) do
				exports.bro_core:RemoveArea("repair"..kk..k)
			end
		end
		if vv.lockers then
			for k, v in pairs(vv.lockers) do
				exports.bro_core:RemoveArea("lockers"..k)
				exports.bro_core:RemoveMenu("lockers"..k)
			end
		end
		if vv.collect then
			for k, v in pairs(vv.collect) do
				exports.bro_core:RemoveArea("collect"..k)
				exports.bro_core:RemoveMenu("collect"..k)
			end
		end
		if vv.process then
			for k, v in pairs(vv.process) do
				exports.bro_core:RemoveArea("process"..k)
				exports.bro_core:RemoveMenu("process"..k)
			end
		end
		if vv.safes then
			for k, v in pairs(vv.safes) do
				exports.bro_core:RemoveArea("safes"..k)
				exports.bro_core:RemoveMenu("safes"..k)
			end
		end
		if vv.armories then
			for k, v in pairs(vv.armories) do
				exports.bro_core:RemoveArea("armories"..k)
				exports.bro_core:RemoveMenu("armories"..k)
			end
		end
		if vv.begin then
			for k, v in pairs(vv.begin) do
			exports.bro_core:RemoveArea("begin"..k)
			end
		end
	end
end

function createMenuAndArea(job)
	ClearAllBlipRoutes()
	
	exports.bro_core:AddArea("center", {
		marker = {
			weight = 1,
			height = 1,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					exports.bro_core:HelpPromt("Job Center Key : ~INPUT_PICKUP~")
					zoneType = "center"
					zone = "global"
				end
			},
			exit = {
				callback = function()
					zoneType = nil
				end
			},
		},
		blip = {
			text = "Job Center",
			imageId	= config.center.sprite,
			colorId = config.center.color,
		},
		locations = {
			{
				x = config.center.pos.x,
				y = config.center.pos.y,
				z = config.center.pos.z,
			},
		},
	})

	-- global to everyone
	for kk, vv in pairs(config.jobs) do
		print(kk)
		if vv.homes then
			for k, v in pairs(vv.homes) do
				print(k)
				exports.bro_core:AddArea("homes"..kk..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Accueil ("..job.name..")", function()
									TriggerServerEvent("job:avert:all", avert, "On vous demande à l'acceuil ~b~(".. avert.. ")")
								end)
								exports.bro_core:HelpPromt("Vestiaire Key : ~INPUT_PICKUP~")
							end
						},
						exit = {
							callback = function()
								exports.bro_core:Key("E", "E", "Interaction", function()
								end)
							end
						},
					},
					blip = {
						text = vv.label,
						imageId	= v.sprite,
						colorId = vv.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
			end
		end
		if vv.repair then
			for k, v in pairs(vv.repair) do
				exports.bro_core:AddArea("repair"..kk..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Accueil ("..job.name..")", function()
									if isPedDrivingAVehicle() then
										exports.bro_core:OpenMenu("repair")
									else
										exports.bro_core:Notification("Montez dans un véhicule")
									end
								end)
								exports.bro_core:HelpPromt("Vestiaire Key : ~INPUT_PICKUP~")
							end
						},
						exit = {
							callback = function()
								exports.bro_core:Key("E", "E", "Interaction", function()
								end)
							end
						},
					},
					blip = {
						text = vv.label,
						imageId	= v.sprite,
						colorId = vv.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
			end
		end
	end
	
	-- Draw areas 
	if job ~= nil and job.name ~= nil then
		myjob = config.jobs[job.name]
		if myjob then
			if myjob.lockers then
				for k, v in pairs(myjob.lockers) do
					exports.bro_core:AddArea("lockers"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bro_core:Key("E", "E", "Vestiaire", function()
										exports.bro_core:AddMenu("lockers", {
											Title = "Vestiaire",
											Subtitle = job.name,
											buttons = {
												{
													type  = "button",
													label = "Prendre le service",
													actions = {
														onSelected = function()
															clockIn(job.name)
														end
													},
												},
												{
													type  = "button",
													label = "Quitter le service",
													actions = {
														onSelected = function()
															clockOut(job.name)
														end
													},
												},
											}
										})
									end)
									exports.bro_core:HelpPromt("Vestiaire Key : ~INPUT_PICKUP~")
								end
							},
							exit = {
								callback = function()
									exports.bro_core:RemoveMenu("lockers")
									exports.bro_core:Key("E", "E", "Interaction", function()
									end)
								end
							},
						},
						blip = {
							text = job.label.. " Vestiaire "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
				end
			end
			if myjob.collect then
				for k, v in pairs(myjob.collect) do
					exports.bro_core:AddArea("collect"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 2,
							enter = {
								callback = function()
									exports.bro_core:Key("E", "E", "Vestiaire", function()
										TriggerServerEvent("job:get", "job:collect:open")	
									end)
									exports.bro_core:HelpPromt("Vestiaire Key : ~INPUT_PICKUP~")
								end
							},
							exit = {
								callback = function()
									exports.bro_core:Key("E", "E", "Interaction", function()
									end)
								end
							},
						},
						blip = {
							text = job.label.. " Récolte "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
				end
			end
			if myjob.process then
				for k, v in pairs(myjob.process) do
					exports.bro_core:AddArea("process"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 2,
							enter = {
								callback = function()
									exports.bro_core:Key("E", "E", "Vestiaire", function()
										TriggerServerEvent("job:get", "job:process:open")	
									end)
									exports.bro_core:HelpPromt("Vestiaire Key : ~INPUT_PICKUP~")
								end
							},
							exit = {
								callback = function()
									exports.bro_core:Key("E", "E", "Interaction", function()
									end)
								end
							},
						},
						blip = {
							text = job.label.. " Traitement "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
					exports.bro_core:AddMenu("process"..k, {
						title = "Traitement "..k,
						position = 0,
					})
				end
			end
			if myjob.safes then
				for k, v in pairs(myjob.safes) do
					exports.bro_core:AddArea("safes"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bro_core:Key("E", "E", "Vestiaire", function()
										exports.bro_core:AddMenu("safe", {
											Title = "Vestiaire",
											Subtitle = job.name,
											buttons = {
												{
													type = "separator",
													label = "Compte",
												},
												{
													type  = "button",
													label = "Retirer",
													actions = {
														onSelected = function()
															TriggerServerEvent('account:job:withdraw', "", job.job, tonumber(exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})))
															TriggerServerEvent("job:get", "job:safe:open")		
														end
													},
												},
												{
													type  = "button",
													label = "Déposer",
													actions = {
														onSelected = function()
															TriggerServerEvent('account:job:add', "", job.job, tonumber(exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})))
															TriggerServerEvent("job:get", "job:safe:open")		
														end
													},
												},
												{
													type = "separator",
													label = "Stock",
												},
											}
										})
									end)
									exports.bro_core:HelpPromt("Vestiaire Key : ~INPUT_PICKUP~")
								end
							},
							exit = {
								callback = function()
									exports.bro_core:RemoveMenu("safe")
									exports.bro_core:Key("E", "E", "Interaction", function()
									end)
								end
							},
						},
						blip = {
							text = job.label.. " Coffre "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
				end
			end
			if myjob.armories then
				for k, v in pairs(myjob.armories) do
					exports.bro_core:AddArea("armories"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bro_core:Key("E", "E", "Vestiaire", function()
										exports.bro_core:AddMenu("armory", {
											Title = "Vestiaire",
											Subtitle = job.name,
											buttons = {
												{
													type = "separator",
													label = "gillet",
												},
												{
													type  = "button",
													label = "Mettre",
													actions = {
														onSelected = function()
															addBulletproofVest()	
														end
													},
												},
												{
													type  = "button",
													label = "Enlever",
													actions = {
														onSelected = function()
															removeBulletproofVest()
														end
													},
												},
												{
													type = "separator",
													label = "Armes",
												},
												{
													type  = "button",
													label = "Stocker (arme équipée)",
													actions = {
														onSelected = function()
															local found, weapon  = GetCurrentPedWeapon(
																GetPlayerPed(-1),
																1
															)
															if found then
																RemoveWeaponFromPed(GetPlayerPed(-1), weapon)
					
																weapon = tostring(weapon)
																if weapon == "453432689" then
																	weapon = "0x1B06D571"
																elseif weapon == "-1951375401" then
																	weapon = "0x8BB05FD7"
																elseif weapon == "911657153" then
																	weapon = "0x3656C8C1"
																elseif weapon == "1737195953" then
																	weapon = "0x678B81B1"
																elseif weapon == "911657153" then
																	weapon = "0x1D073A89"
																elseif weapon == "736523883" then
																	weapon = "0x2BE6766B"
																end
																TriggerServerEvent("weapon:store", weapon)
																exports.bro_core:Notification("Arme stocké")
															else
																exports.bro_core:Notification("Pas d'arme sur vous")
															end
														end
													},
												},
												{
													type  = "button",
													label = "Retirer arme",
													actions = {
														onSelected = function()
															TriggerServerEvent("weapon:get:all", "weapon:store")
														end
													},
												},
											}
										})
									end)
									exports.bro_core:HelpPromt("Vestiaire Key : ~INPUT_PICKUP~")
								end
							},
							exit = {
								callback = function()
									exports.bro_core:RemoveMenu("armory")
									exports.bro_core:Key("E", "E", "Interaction", function()
									end)
								end
							},
						},
						blip = {
							text = job.label.. " Armurerie "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
				end
			end
			if myjob.begin then
				for k, v in pairs(myjob.begin) do
				exports.bro_core:AddArea("begin"..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Commencer les courses", function()
									if not beginInProgress then
										vehicleLivraison = exports.bro_core:spawnCar(vehicle, true, nil, true)
										addBeginArea() 
									else
										exports.bro_core:Notification("~r~Vous avez déjà une course en cours !")
									end
								end)
								exports.bro_core:HelpPromt("ATM : ~INPUT_PICKUP~")
							end
						},
						exit = {
							callback = function()
								exports.bro_core:RemoveMenu("ATM")
								exports.bro_core:Key("E", "E", "Interaction", function()
								end)
							end
						},
					},
					blip = {
						text = job.label.. " Livraisons "..k,
						imageId	= v.sprite,
						colorId = myjob.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
				end
			end
			if myjob.custom then
				for k, v in pairs(myjob.custom) do
				exports.bro_core:AddArea("custom"..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Commencer les courses", function()
									if isPedDrivingAVehicle() then
										customMenu()
									else
										exports.bro_core:Notification("Montez dans un véhicule")
									end
								end)
								exports.bro_core:HelpPromt("ATM : ~INPUT_PICKUP~")
							end
						},
						exit = {
							callback = function()
								exports.bro_core:RemoveMenu("ATM")
								exports.bro_core:Key("E", "E", "Interaction", function()
								end)
							end
						},
					},
					blip = {
						text = job.label.. " Customisation "..k,
						imageId	= v.sprite,
						colorId = myjob.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
				end
			end
			if myjob.fourriere then
				for k, v in pairs(myjob.fourriere) do
				exports.bro_core:AddArea("fourriere"..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Fourrière", function()
									-- Mise en fourriére
									vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
									if vehicle ~= nil then
										TriggerServerEvent("vehicle:parking:store", vehicle, "depot", "")
										exports.bro_core:Notification("Vous avez mis le véhicle en fourriére")
										DeleteEntity(vehicle)
									else
										exports.bro_core:Notification("Vous n'êtes pas dans un véhicule")
									end
								end)
								exports.bro_core:HelpPromt("ATM : ~INPUT_PICKUP~")
							end
						},
						exit = {
							callback = function()
								exports.bro_core:RemoveMenu("ATM")
								exports.bro_core:Key("E", "E", "Interaction", function()
								end)
							end
						},
					},
					blip = {
						text = job.label.. " Fourriére "..k,
						imageId	= v.sprite,
						colorId = myjob.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
				end
			end
		end
	end
end

-- LSMS Revive people
function reviveClosestPlayer()
	print(GetPlayerServerId(GetPlayerPed(ped)))
	print(GetPlayerServerId(ped))
	print(ped)
	TriggerServerEvent('job:lsms:revive', GetPlayerServerId(ped))

	exports.bro_core:RemoveMenu("lsms")
	local closestPlayerPed, dist = exports.bro_core:GetClosestPlayer()
   -- if closestPlayerPed and IsPedDeadOrDying(closestPlayerPed, 1) and dist <=1 then
			if not IsPedInAnyVehicle(ped, false) then
				exports.bro_core:actionPlayer(15000, "Réanimation en cours", "mini@cpr@char_a@cpr_str", "cpr_pumpchest",
				function()
					TriggerServerEvent('job:lsms:revive', GetPlayerServerId(ped))
				end)
			else
				exports.bro_core:Notification("~r~Vous ne pouvez pas réanimer en véhicule")
			end
--    else
	    --exports.bro_core:Notification("Pas de joueur mourrant à portée")
 --   end
end

function healClosestPlayer()
	exports.bro_core:RemoveMenu("lsms")
	local playerPed = GetPlayerPed(-1)
	local closestPlayerPed, dist = exports.bro_core:GetClosestPlayer()
	if closestPlayerPed  and dist <=1 then
		exports.bro_core:actionPlayer(2000, "Vêtements","mini@cpr@char_a@cpr_str", "cpr_pumpchest",
			function()
				SetEntityHealth(closestPlayerPed, GetPedMaxHealth(closestPlayerPed))
				FreezeEntityPosition(playerPed, false)
		end)
    else
        exports.bro_core:Notification("Pas de joueur à portée")
    end
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
	--TriggerEvent('spawn:spawn')
end


-- LSPD menu function
function DoTraffic()
	Citizen.CreateThread(function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)
			Citizen.Wait(60000)
			ClearPedTasksImmediately(PlayerPedId())
			exports.bro_core:Notification("menu_doing_traffic_notification")
		else
			exports.bro_core:Notification(GetLabelText("PEN_EXITV"))
		end
	end)
end

function Note()
	Citizen.CreateThread(function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, false)
			Citizen.Wait(20000)
			ClearPedTasksImmediately(PlayerPedId())
		else
			exports.bro_core:Notification(GetLabelText("PEN_EXITV"))
		end
	end)
end

function StandBy()
	Citizen.CreateThread(function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_COP_IDLES", 0, true)
			Citizen.Wait(20000)
			ClearPedTasksImmediately(PlayerPedId())
		else
			exports.bro_core:Notification(GetLabelText("PEN_EXITV"))
		end
    end)
end

function StandBy2()
	Citizen.CreateThread(function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GUARD_STAND", 0, 1)
			Citizen.Wait(20000)
			ClearPedTasksImmediately(PlayerPedId())
		else
			exports.bro_core:Notification(GetLabelText("PEN_EXITV"))
		end
	end)
end

function CancelEmote()
	Citizen.CreateThread(function()
        ClearPedTasksImmediately(PlayerPedId())
    end)
end

function RemoveWeapons()
	local closestPlayer, dist = exports.bro_core:GetClosestPlayer()

    if closestPlayer and dist <=1 then
        TriggerServerEvent("job:removeWeapons", GetPlayerServerId(closestPlayer))
    else
        exports.bro_core:Notification("~r~Pas de joueur à proximité")
    end
end

function ToggleCuff()
	local closestPlayer, dist = exports.bro_core:GetClosestPlayer()

    if closestPlayer  and dist <=1 then
		TriggerServerEvent("job:cuffGranted", GetPlayerServerId(closestPlayer))
	else
		exports.bro_core:Notification("~r~Pas de joueur à proximité")
	end
end

function Fines(amount)
	local closestPlayer, dist = exports.bro_core:GetClosestPlayer()

    if closestPlayer and dist <=1 then
		Citizen.Trace("Price : "..tonumber(amount))
		if(tonumber(amount) == -1) then
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8S", "", "", "", "", "", 20)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0);
				Wait(0);
			end
			if (GetOnscreenKeyboardResult()) then
				local res = tonumber(GetOnscreenKeyboardResult())
				if(res ~= nil and res ~= 0) then
					amount = tonumber(res)
				end
			end
			
			if(tonumber(amount) ~= -1) then
				TriggerServerEvent("job:finesGranted", GetPlayerServerId(closestPlayer), tonumber(amount))
			end
		else
			TriggerServerEvent("job:finesGranted", GetPlayerServerId(closestPlayer), tonumber(amount))
		end
	else
		exports.bro_core:Notification("~r~Pas de joueur à proximité")
	end
end


function giveWeaponLicence()
	local closestPlayer, dist = exports.bro_core:GetClosestPlayer()

    if closestPlayer  and dist <=1 then
		TriggerServerEvent("job:weapon:licence", closestPlayer, true)
	else
		exports.bro_core:Notification("~r~Pas de joueur à proximité")
	end
end


function DropVehicle()
	Citizen.CreateThread(function()
		local pos = GetEntityCoords(PlayerPedId())
		local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
		if DoesEntityExist(vehicleHandle) and IsEntityAVehicle(vehicleHandle) then
			DeleteEntity(vehicleHandle)
		else
			exports.bro_core:Notification("Pas de véhicule à proximité")
		end
	end)
end

function SpawnSpikesStripe()
	if IsPedInAnyPoliceVehicle(PlayerPedId()) then
		local modelHash = GetHashKey("P_ld_stinger_s")
		local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)	
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(currentVeh, 0.0, -5.2, -0.25))

		RequestScriptAudioBank("BIG_SCORE_HIJACK_01", true)
		Citizen.Wait(500)

		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
		end

		if HasModelLoaded(modelHash) then
			SpikeObject = CreateObject(modelHash, x, y, z, true, false, true)
			SetEntityNoCollisionEntity(SpikeObject, PlayerPedId(), 1)
			SetEntityDynamic(SpikeObject, false)
			ActivatePhysics(SpikeObject)

			if DoesEntityExist(SpikeObject) then			
				local height = GetEntityHeightAboveGround(SpikeObject)

				SetEntityCoords(SpikeObject, x, y, z - height + 0.05)
				SetEntityHeading(SpikeObject, GetEntityHeading(PlayerPedId())-80.0)
				SetEntityCollision(SpikeObject, false, false)
				PlaceObjectOnGroundProperly(SpikeObject)

				SetEntityAsMissionEntity(SpikeObject, false, false)				
				SetModelAsNoLongerNeeded(modelHash)
				PlaySoundFromEntity(-1, "DROP_STINGER", PlayerPedId(), "BIG_SCORE_3A_SOUNDS", 0, 0)
			end			
			exports.bro_core:Notification("Spike stripe~g~ deployed~w~.")
		end
	else
		exports.bro_core:Notification("You need to get ~y~inside~w~ a ~y~police vehicle~w~.")
		PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	end
end

function DeleteSpike()
	local model = GetHashKey("P_ld_stinger_s")
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))

	if DoesObjectOfTypeExistAtCoords(x, y, z, 0.9, model, true) then
		local spike = GetClosestObjectOfType(x, y, z, 0.9, model, false, false, false)
		DeleteObject(spike)
	end	
end

local propslist = {}

function SpawnProps(model)
	if(#propslist < 100) then
		local prophash = GetHashKey(tostring(model))
		RequestModel(prophash)
		while not HasModelLoaded(prophash) do
			Citizen.Wait(0)
		end

		local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, 0.0)
		local _, worldZ = GetGroundZFor_3dCoord(offset.x, offset.y, offset.z)
		local propsobj = CreateObjectNoOffset(prophash, offset.x, offset.y, worldZ, true, true, true)
		local heading = GetEntityHeading(PlayerPedId())

		SetEntityHeading(propsobj, heading)
		SetEntityAsMissionEntity(propsobj)
		SetModelAsNoLongerNeeded(prophash)

		propslist[#propslist+1] = ObjToNet(propsobj)
	end
end

function RemoveLastProps()
	DeleteObject(NetToObj(propslist[#propslist]))
	propslist[#propslist] = nil
end

function RemoveAllProps()
	for i, props in pairs(propslist) do
		DeleteObject(NetToObj(props))
		propslist[i] = nil
	end

end


--armory
function createArmoryPed()
	if not DoesEntityExist(armoryPed) then
		local model = GetHashKey("s_m_y_cop_01")

		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(0)
		end

		local armoryPed = CreatePed(26, model, 454.165, -979.999, 30.690, 92.298, false, false)
		SetEntityInvincible(armoryPed, true)
		TaskTurnPedToFaceEntity(armoryPed, PlayerId(), -1)		

		return armoryPed
	end
end

basic_kit = {
	"WEAPON_STUNGUN",
	"WEAPON_NIGHTSTICK",
	"WEAPON_FLASHLIGHT",
	"WEAPON_PISTOL"
}

function giveBasicKit()
	for k,v in pairs(basic_kit) do
		GiveWeaponToPed(PlayerPedId(), GetHashKey(v), -1, true, false)
		-- ADD_AMMO_TO_PED
		AddAmmoToPed(
			PlayerPedId() --[[ Ped ]], 
			GetHashKey(v) --[[ Hash ]], 
			50 --[[ integer ]]
		)
	end

	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function giveBasicPrisonKit()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), 200, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 200, true, true)

	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function addBulletproofVest()
	if(GetEntityModel(PlayerPedId()) == hashSkin) then
		SetPedComponentVariation(PlayerPedId(), 9, 4, 1, 2)
	else
		SetPedComponentVariation(PlayerPedId(), 9, 6, 1, 2)
	end

	SetPedArmour(PlayerPedId(), 100)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function removeBulletproofVest()
	SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)

	SetPedArmour(PlayerPedId(), 0)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function GiveCustomWeapon(weaponData)
	GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponData), -1, false, true)
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

--redirect callbacks
function isPedDrivingAVehicle()
	local ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		-- Check if ped is in driver seat
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains
			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				return true
			end
		end
	end
	return false
end


function addBeginArea() 
	beginInProgress = true
	exports.bro_core:RemoveArea("begin-current")
	points_coords = points[math.random(1,#points)]
	exports.bro_core:AddArea("begin-current", {
		marker = {
			type = 1,
			weight = 1,
			height = 1,
			red = 255,
			green = 255,
			blue = 153,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					if 	GetVehiclePedIsIn(PlayerPedId(), false) == vehicleLivraison then
						TriggerServerEvent("account:player:liquid:add", "", 2.50)
						exports.bro_core:Notification("Vous avez gagné ~g~2.50$")
					else
						exports.bro_core:Notification("Ou est passé votre vehicule de livraison ? non payé")
					end
					addBeginArea()
				end
			},
		},
		blip = {
			text = "Livraison",
			colorId = 38,
			imageId = 77,
			route = true,
		},
		locations = {
			{
				x = points_coords.x,
				y = points_coords.y,
				z = points_coords.z,
			}
		},
	})
end



-- service management
function recruitClosestPlayer(job)
	local closestPlayer, dist = exports.bro_core:GetClosestPlayer()

    if closestPlayer and dist <=1 then
        TriggerServerEvent('job:service:recruit', job[1].id, GetPlayerServerId(closestPlayer))
    else
        exports.bro_core:Notification("Pas de joueur à portée")
    end
end

function promoteClosestPlayer()
	local closestPlayer, dist = exports.bro_core:GetClosestPlayer()

    if closestPlayer  and dist <=1 then
        TriggerServerEvent('job:service:prmote', GetPlayerServerId(closestPlayer))
    else
        exports.bro_core:Notification("Pas de joueur à portée")
    end
end


function demmoteClosestPlayer()
	local closestPlayer, dist = exports.bro_core:GetClosestPlayer()

    if closestPlayer and dist <=1 then
        TriggerServerEvent('job:service:prmote', GetPlayerServerId(closestPlayer))
    else
        exports.bro_core:Notification("Pas de joueur à portée")
    end
end


function fireClosestPlayer()
	local closestPlayer, dist = exports.bro_core:GetClosestPlayer()

	if closestPlayer and dist <=1 then
		--todo
        TriggerServerEvent('job:set', GetPlayerServerId(closestPlayer), nil, "Vous avez été viré", "Vous avez viré un employé")
    else
        exports.bro_core:Notification("Pas de joueur à portée")
    end
end


function beginSell(job)
	local nb = math.random(1,#config.jobs[job].sell.pos)
	local currentSell = config.jobs[job].sell.pos[nb]
	exports.bro_core:AddArea("sell", {
		marker = {
			weight = 1,
			height = 2,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					exports.bro_core:HelpPromt("Vendre Key : ~INPUT_PICKUP~")
					zone = 1
					zoneType = "sell"
				end
			},
			exit = {
				callback = function()
					exports.bro_core:RemoveMenu("sell")
					zone = nil
					zoneType = nil
				end
			},
		},
		blip = {
			text = "Revente",
			imageId	= config.jobs[job].sell.sprite,
			colorId = config.jobs[job].color,
			route = true,
		},
		locations = {
			{
				x = currentSell.coords.x,
				y = currentSell.coords.y,
				z = currentSell.coords.z,
			},
		},
	})
	exports.bro_core:RemoveMenu(job)
	exports.bro_core:RemoveMenu("sell")
end


function removeSell(job)
	exports.bro_core:RemoveArea("sell")
	exports.bro_core:RemoveMenu(job)
	exports.bro_core:RemoveMenu("sell")
end

-- réparations
function fixVitres() 
	local playerPed = GetPlayerPed(-1)
	coords = GetEntityCoords(GetPlayerPed(-1), true)
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	local prop_name = 'prop_cs_wrench'
	if lockRepare == false then
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if not IsPedInAnyVehicle(playerPed, false) then
				local time = 4000
				TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
				exports.bro_core:RemoveMenu("repair")
				lockRepare = true 
				Citizen.CreateThread(function ()
					FreezeEntityPosition(playerPed)
					FreezeEntityPosition(vehicle)
					local x,y,z = table.unpack(GetEntityCoords(playerPed))
					local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
					local boneIndex = GetPedBoneIndex(playerPed, 18905)
					AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
				
					local dict = "amb@world_human_vehicle_mechanic@male@exit"
					local anim = "exit"
					RequestAnimDict(dict)

					while not HasAnimDictLoaded(dict) do
						Citizen.Wait(150)
					end
					TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

					Wait(time)
					lockRepare = false
					FixVehicleWindow(vehicle, 0)
					FixVehicleWindow(vehicle, 1)
					FixVehicleWindow(vehicle, 2)
					FixVehicleWindow(vehicle, 3)
					FixVehicleWindow(vehicle, 4)
					FixVehicleWindow(vehicle, 5)
					FixVehicleWindow(vehicle, 6)
					FixVehicleWindow(vehicle, 7)
					FixVehicleWindow(vehicle, 8)
					TriggerServerEvent("job:repair:price", "window", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
					exports.bro_core:Notification("Véhicle réparé")
					ClearPedSecondaryTask(playerPed)
					DeleteObject(prop)
				end)
			else
				exports.bro_core:Notification("~r~Sortez du véhicle")
			end
		else
			exports.bro_core:Notification("~r~Pas de véhicule à portée")
		end
	else 
		exports.bro_core:Notification("~r~Répération en cours")
	end
end

function fixCarroserie()
	local playerPed = GetPlayerPed(-1)
	coords = GetEntityCoords(GetPlayerPed(-1), true)
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	local prop_name = 'prop_cs_wrench'
	if lockRepare == false then
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if not IsPedInAnyVehicle(playerPed, false) then
				local time = 4000
				TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
				exports.bro_core:RemoveMenu("repair")
				lockRepare = true 
				Citizen.CreateThread(function ()
					FreezeEntityPosition(playerPed)
					FreezeEntityPosition(vehicle)
					
					local dict = "amb@world_human_vehicle_mechanic@male@exit"
					local anim = "exit"
					RequestAnimDict(dict)

					while not HasAnimDictLoaded(dict) do
						Citizen.Wait(150)
					end
					TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

					Wait(time)
					lockRepare = false
					SetVehicleBodyHealth(vehicle, 1000.0)
					SetVehiclePetrolTankHealth(vehicle, 1000.0)
					SetVehicleDeformationFixed(vehicle)
					TriggerServerEvent("job:repair:price", "carroserie", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
					exports.bro_core:Notification("Véhicle réparé")
					ClearPedSecondaryTask(playerPed)
					DeleteObject(prop)
				end)
			else
				exports.bro_core:Notification("~r~Sortez du véhicle")
			end
		else
			exports.bro_core:Notification("~r~Pas de véhicule à portée")
		end
	else 
		exports.bro_core:Notification("~r~Répération en cours")
	end
end

function fixPneus()
	local playerPed = GetPlayerPed(-1)
	coords = GetEntityCoords(GetPlayerPed(-1), true)
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	local prop_name = 'prop_cs_wrench'
	if lockRepare == false then
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if not IsPedInAnyVehicle(playerPed, false) then
				local time = 4000
				TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
				exports.bro_core:RemoveMenu("repair")
				lockRepare = true 
				Citizen.CreateThread(function ()
					FreezeEntityPosition(playerPed)
					FreezeEntityPosition(vehicle)
					local x,y,z = table.unpack(GetEntityCoords(playerPed))
					local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
					local boneIndex = GetPedBoneIndex(playerPed, 18905)
					AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
				
					local dict = "amb@world_human_vehicle_mechanic@male@exit"
					local anim = "exit"
					RequestAnimDict(dict)

					while not HasAnimDictLoaded(dict) do
						Citizen.Wait(150)
					end
					TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

					Wait(time)
					lockRepare = false
					SetVehicleTyreFixed(vehicle, 0)
					SetVehicleTyreFixed(vehicle, 1)
					SetVehicleTyreFixed(vehicle, 2)
					SetVehicleTyreFixed(vehicle, 3)
					SetVehicleTyreFixed(vehicle, 4)
					SetVehicleTyreFixed(vehicle, 5)
					SetVehicleTyreFixed(vehicle, 6)
					TriggerServerEvent("job:repair:price", "tyres", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
					exports.bro_core:Notification("Véhicle réparé")
					ClearPedSecondaryTask(playerPed)
					DeleteObject(prop)
				end)
			else
				exports.bro_core:Notification("~r~Sortez du véhicle")
			end
		else
			exports.bro_core:Notification("~r~Pas de véhicule à portée")
		end
	else 
		exports.bro_core:Notification("~r~Répération en cours")
	end
end

function fixEngine()
	local playerPed = GetPlayerPed(-1)
	coords = GetEntityCoords(GetPlayerPed(-1), true)
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	local prop_name = 'prop_cs_wrench'

	if lockRepare == false then
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if not IsPedInAnyVehicle(playerPed, false) then
				local time = 4000
				TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
				exports.bro_core:RemoveMenu("repair")
				lockRepare = true 
				Citizen.CreateThread(function ()
					FreezeEntityPosition(playerPed)
					FreezeEntityPosition(vehicle)
					local x,y,z = table.unpack(GetEntityCoords(playerPed))
					local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
					local boneIndex = GetPedBoneIndex(playerPed, 18905)
					AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
			   
					local dict = "amb@world_human_vehicle_mechanic@male@exit"
					local anim = "exit"
					RequestAnimDict(dict)

					while not HasAnimDictLoaded(dict) do
						Citizen.Wait(150)
					end
					TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

					Wait(time)
					lockRepare = false
					SetVehicleEngineHealth(vehicle, 1000.0)
					SetVehicleUndriveable(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					TriggerServerEvent("job:repair:price", "motor", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
					exports.bro_core:Notification("Véhicle réparé")
					ClearPedSecondaryTask(playerPed)
					DeleteObject(prop)
				end)
			else
				exports.bro_core:Notification("~r~Sortez du véhicle")
			end
		else
			exports.bro_core:Notification("~r~Pas de véhicule à portée")
		end
	else 
		exports.bro_core:Notification("~r~Répération en cours")
	end
end

-- Nettoyages
function cleanCarroserie()
	local playerPed = GetPlayerPed(-1)
	coords = GetEntityCoords(GetPlayerPed(-1), true)
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	local prop_name = 'prop_rag_01'
	if lockRepare == false then
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if not IsPedInAnyVehicle(playerPed, false) then
				local time = 4000
				TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
				exports.bro_core:RemoveMenu("repair")
				lockRepare = true 
				Citizen.CreateThread(function ()
					FreezeEntityPosition(playerPed)
					FreezeEntityPosition(vehicle)
					local x,y,z = table.unpack(GetEntityCoords(playerPed))
					local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
					local boneIndex = GetPedBoneIndex(playerPed, 0xDEAD)
					AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
				
					local dict = "timetable@maid@cleaning_window@base"
					local anim = "base"
					RequestAnimDict(dict)

					while not HasAnimDictLoaded(dict) do
						Citizen.Wait(150)
					end
					TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

					Wait(time)
					lockRepare = false
					SetVehicleDirtLevel(vehicle, 0.0)
					exports.bro_core:Notification("Véhicle réparé")
					ClearPedSecondaryTask(playerPed)
					DeleteObject(prop)
				end)
			else
				exports.bro_core:Notification("~r~Sortez du véhicle")
			end
		else
			exports.bro_core:Notification("~r~Pas de véhicule à portée")
		end
	else 
		exports.bro_core:Notification("~r~Répération en cours")
	end
end
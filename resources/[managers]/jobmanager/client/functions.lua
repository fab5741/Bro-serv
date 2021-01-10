function DeleteMenuAndArea()
	-- delete area and menus
	exports.bro_core:RemoveArea("center")
	exports.bro_core:RemoveMenu("sell")
	exports.bro_core:RemoveMenu("service")
	exports.bro_core:RemoveMenu("armoryitems")
	exports.bro_core:RemoveMenu("armory")
	exports.bro_core:RemoveMenu("safe")
	exports.bro_core:RemoveMenu("safeitems")
	exports.bro_core:RemoveMenu("lockers")
	exports.bro_core:RemoveMenu("actions")
	exports.bro_core:RemoveMenu("fines")
	exports.bro_core:RemoveMenu("props")
	exports.bro_core:RemoveMenu("animations")
	exports.bro_core:RemoveMenu("job")
	for kk, vv in pairs(Config.jobs) do
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
		if vv.fourriere then
			for k, v in pairs(vv.fourriere) do
				exports.bro_core:RemoveArea("fourriere"..k)
			end
		end
		if vv.frigo then
			for k, v in pairs(vv.frigo) do
				exports.bro_core:RemoveArea("frigo"..k)
			end
		end
	end
end

-- Refresh areas and menus
function Refresh(job)
	-- Add menus and areas
	ClearAllBlipRoutes()
	exports.bro_core:AddArea("center", {
		marker = {
			weight = 1,
			height = 0.2,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					exports.bro_core:Key("E", "E", "Job Center", function()
						local buttons = {}
						for k, v in pairs(Config.center.jobs) do
							buttons[#buttons+1] = {
								type = "button",
								label = v.label,
								actions = {
									onSelected = function()
										TriggerServerEvent("job:set:me", 34, "Livreur de journaux")
										Wait(100)
										TriggerServerEvent("job:get", "jobs:Refresh")
										exports.bro_core:RemoveMenu("center")
									end
								},
							}
						end
						exports.bro_core:AddMenu("service", {
							Title = "Job Center",
							Subtitle = "Job",
							buttons = buttons
						})
					end)
					exports.bro_core:HelpPromt("Job Center Key : ~INPUT_PICKUP~")
				end
			},
			exit = {
				callback = function()
					exports.bro_core:RemoveMenu("center")
					exports.bro_core:Key("E", "E", "Interaction", function()
					end)
				end
			},
		},
		blip = {
			text = "Job Center",
			imageId	= Config.center.sprite,
			colorId = Config.center.color,
		},
		locations = {
			{
				x = Config.center.pos.x,
				y = Config.center.pos.y,
				z = Config.center.pos.z,
			},
		},
	})

	-- global to everyone
	for kk, vv in pairs(Config.jobs) do
		if vv.homes then
			for k, v in pairs(vv.homes) do
				exports.bro_core:AddArea("homes"..kk..k, {
					marker = {
						weight = 1,
						height = 0.1,
						red = vv.red,
						green = vv.green,
						blue = vv.blue,
						alpha = 100,
						showDistance = 6,
						type = 36
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Accueil ("..kk..")", function()
									TriggerServerEvent("job:avert:all", kk, "On vous demande à l'acceuil ~b~(".. job.label.. ")")
								end)
								exports.bro_core:HelpPromt("Accueil Key : ~INPUT_PICKUP~")
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
						height = 0.1,
						red = vv.red,
						green = vv.green,
						blue = vv.blue,
						alpha = 100,
						showDistance = 6,
						type = 36
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Accueil ("..job.name..")", function()
									if IsPedInAnyVehicle(PlayerPedId(), false) then
										exports.bro_core:AddMenu("repair", {
											Title = "Réparation",
											Subtitle = "Garage solidaire",
											buttons = {
												{
													type= "button",
													label = "Réparer totale (1000$)",
													actions = {
														onSelected = function()
															exports.bro_core:RemoveMenu("repair")
															exports.bro_core:actionPlayer(15000, "Réparation en cours", "","",
															function()
																local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)								
																SetVehicleFixed(vehicle)
																SetVehicleDeformationFixed(vehicle)
																SetVehicleUndriveable(vehicle, false)
																ClearPedTasksImmediately(playerPed)
																TriggerServerEvent("account:player:liquid:add", "", -1000.0)
																exports.bro_core:Notification("Véhicle ~b~réparé~n~~g~1000$ ~s~Payé")
															end)
														end
													},
												},
											}
										})
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
		local myjob = Config.jobs[job.name]
		if myjob then
			local marker = {
				weight = 1,
				height = 0.1,
				red = myjob.red,
				green = myjob.green,
				blue = myjob.blue,
				alpha = 100,
				showDistance = 6,
				type = 36
			}
			if myjob.lockers then
				for k, v in pairs(myjob.lockers) do
					exports.bro_core:AddArea("lockers"..k, {
						marker = marker,
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
															ClockIn(job.name)
														end
													},
												},
												{
													type  = "button",
													label = "Quitter le service",
													actions = {
														onSelected = function()
															ClockOut(job.name)
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
									exports.bro_core:RemoveMenu("lockers"..k)
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
							weight = 4,
							height = 0.2,
							red = myjob.red,
							green = myjob.green,
							blue = myjob.blue,
						},
						trigger = {
							weight = 4,
							enter = {
								callback = function()
									exports.bro_core:Key("E", "E", "Collecte", function()
										zone = k
										TriggerServerEvent("job:get", "job:collect:open")	
									end)
									exports.bro_core:HelpPromt("Collecte Key : ~INPUT_PICKUP~")
								end
							},
							exit = {
								callback = function()
									exports.bro_core:RemoveMenu("collect"..k)
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
						marker =  marker,
						trigger = {
							weight = 4,
							enter = {
								callback = function()
									exports.bro_core:Key("E", "E", "Traitement", function()
										TriggerServerEvent("job:get", "job:process:open")	
										zone = k
									end)
									exports.bro_core:HelpPromt("Traitement Key : ~INPUT_PICKUP~")
								end
							},
							exit = {
								callback = function()
									exports.bro_core:RemoveMenu("process"..k)
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
						marker = marker,
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bro_core:Key("E", "E", "Coffre", function()
										TriggerServerEvent("job:get", "job:safe:open")
									end)
									exports.bro_core:HelpPromt("Coffre Key : ~INPUT_PICKUP~")
								end
							},
							exit = {
								callback = function()
									exports.bro_core:RemoveMenu("safe"..k)
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
						marker = marker,
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bro_core:Key("E", "E", "Armurerie", function()
										TriggerServerEvent("weapon:get:all", "weapon:store")
									end)
									exports.bro_core:HelpPromt("Armurerie Key : ~INPUT_PICKUP~")
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
					marker = marker,
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Commencer les courses", function()
									if not BeginInProgress then
										vehicleLivraison = exports.bro_core:spawnCar("faggio2", true, nil, true)
										AddBeginArea() 
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
					marker = marker,
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Commencer les courses", function()
									if IsPedInAnyVehicle(PlayerPedId(), false) then
										CustomMenu()
									else
										exports.bro_core:Notification("Montez dans un véhicule")
									end
								end)
								exports.bro_core:HelpPromt("Customisations : ~INPUT_PICKUP~")
							end
						},
						exit = {
							callback = function()
								exports.bro_core:RemoveMenu("Customisations")
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
						weight = 2,
						height = 1,
						red = myjob.red,
						green = myjob.green,
						blue = myjob.blue,
						alpha = 100,
					--	showDistance = 5,
						type = 43
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Fourrière", function()
									exports.bro_core:actionPlayer(5000, "Fourrière", "", "", function()
										vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
										if vehicle ~= nil then
											TriggerServerEvent("vehicle:parking:store", vehicle, "depot", "")
											exports.bro_core:Notification("Vous avez mis le véhicle en ~b~fourriére")
											DeleteEntity(vehicle)
										else
											exports.bro_core:Notification("~r~Vous n'êtes pas dans un véhicule")
										end
									end)
								end)
								exports.bro_core:HelpPromt("Mise en fourrièere : ~INPUT_PICKUP~")
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
			if myjob.frigo then
				for k, v in pairs(myjob.frigo) do
				exports.bro_core:AddArea("frigo"..k, {
					marker = {
						weight = 2,
						height = 1,
						red = myjob.red,
						green = myjob.green,
						blue = myjob.blue,
						alpha = 100,
					--	showDistance = 5,
						type = 43
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:Key("E", "E", "Frigo", function()
									exports.bro_core:actionPlayer(5000, "Frigo", "", "", function()
									end)
								end)
								exports.bro_core:HelpPromt("Mise en fourrièere : ~INPUT_PICKUP~")
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
function ReviveClosestPlayer()
	exports.bro_core:RemoveMenu("lsms")
	local closestPlayerPed = exports.bro_core:GetClosestPed()
	local closestPlayer = exports.bro_core:GetClosestPlayer()
    if closestPlayerPed ~= -1 and IsPedDeadOrDying(closestPlayerPed, 1) and closestPlayer ~= -1 then
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				exports.bro_core:actionPlayer(15000, "Réanimation en cours", "mini@cpr@char_a@cpr_str", "cpr_pumpchest",
				function()
					TriggerServerEvent('job:lsms:revive', GetPlayerServerId(closestPlayer))
				end)
			else
				exports.bro_core:Notification("~r~Vous ne pouvez pas réanimer en véhicule")
			end
    else
	    exports.bro_core:Notification("Pas de joueur mourrant à portée")
    end
end

function HealClosestPlayer()
	exports.bro_core:RemoveMenu("lsms")
	local playerPed = GetPlayerPed(-1)
	local closestPlayerPed = exports.bro_core:GetClosestPed()
	if closestPlayerPed ~= -1 then
		exports.bro_core:actionPlayer(2000, "Soignage","mini@cpr@char_a@cpr_str", "cpr_pumpchest",
			function()
				SetEntityHealth(closestPlayerPed, GetPedMaxHealth(closestPlayerPed))
				FreezeEntityPosition(playerPed, false)
		end)
    else
        exports.bro_core:Notification("Pas de joueur à portée")
    end
end

function RespawnPed(Ped, coords, heading)
	SetEntityCoordsNoOffset(Ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(Ped, false)
    ClearPedBloodDamage(Ped)
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
	local closestPlayer = exports.bro_core:GetClosestPlayer()

    if closestPlayer ~= -1 then
        TriggerServerEvent("job:removeWeapons", GetPlayerServerId(closestPlayer))
    else
        exports.bro_core:Notification("~r~Pas de joueur à proximité")
    end
end

function ToggleCuff()
	local closestPlayer = exports.bro_core:GetClosestPlayer()

    if closestPlayer ~= -1 then
		TriggerServerEvent("job:cuffGranted", GetPlayerServerId(closestPlayer))
	else
		exports.bro_core:Notification("~r~Pas de joueur à proximité")
	end
end

function Fines(amount)
	local closestPlayer = exports.bro_core:GetClosestPlayer()

    if closestPlayer ~= -1 then
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


function GiveWeaponLicence()
	local closestPlayer = exports.bro_core:GetClosestPlayer()

    if closestPlayer ~= 1  then
		TriggerServerEvent("job:weapon:licence", GetPlayerServerId(closestPlayer), true)
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

function AddBulletproofVest()
	if(GetEntityModel(PlayerPedId()) == hashSkin) then
		SetPedComponentVariation(PlayerPedId(), 9, 4, 1, 2)
	else
		SetPedComponentVariation(PlayerPedId(), 9, 6, 1, 2)
	end

	SetPedArmour(PlayerPedId(), 100)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function RemoveBulletproofVest()
	SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)

	SetPedArmour(PlayerPedId(), 0)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function GiveCustomWeapon(weaponData)
	GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponData), -1, false, true)
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function AddBeginArea() 
	BeginInProgress = true
	local points = Config.jobs.newspapers.points
	exports.bro_core:RemoveArea("begin-current")
	local points_coords = points[math.random(1,#points)]
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
					AddBeginArea()
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
function RecruitClosestPlayer(job)
	local closestPlayer= exports.bro_core:GetClosestPlayer()

	if closestPlayer ~= 1 then
		TriggerServerEvent('job:service:recruit', job, GetPlayerServerId(closestPlayer))
    else
        exports.bro_core:Notification("~r~Pas de joueur à portée")
    end
end


function FireClosestPlayer()
	local closestPlayer= exports.bro_core:GetClosestPlayer()

	if closestPlayer ~= -1 then
		--todo
        TriggerServerEvent('job:set', GetPlayerServerId(closestPlayer), nil, "Vous avez été viré", "Vous avez viré un employé")
    else
        exports.bro_core:Notification("Pas de joueur à portée")
    end
end


function PromoteClosestPlayer()
	local closestPlayer = exports.bro_core:GetClosestPlayer()

    if closestPlayer ~= 1    then
        TriggerServerEvent('job:service:promote', GetPlayerServerId(closestPlayer))
    else
        exports.bro_core:Notification("Pas de joueur à portée")
    end
end


function DemmoteClosestPlayer()
	local closestPlayer = exports.bro_core:GetClosestPlayer()

    if closestPlayer ~= -1 then
        TriggerServerEvent('job:service:demote', GetPlayerServerId(closestPlayer))
    else
        exports.bro_core:Notification("Pas de joueur à portée")
    end
end



function BeginSell(job)
	local nb = math.random(1,#Config.jobs[job].sell.pos)
	local currentSell = Config.jobs[job].sell.pos[nb]
	exports.bro_core:AddArea("sell", {
		marker = {
			weight = 1,
			height = 0.1,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					exports.bro_core:HelpPromt("Revente Key : ~INPUT_PICKUP~")
					exports.bro_core:Key("E", "E", "Revente", function()
						TriggerServerEvent("job:get", "job:sell:open")
					end)
				end
			},
			exit = {
				callback = function()
					exports.bro_core:Key("E", "E", "Revente", function()
					end)
				end
			},
		},
		blip = {
			text = "Revente",
			imageId	= Config.jobs[job].sell.sprite,
			colorId = Config.jobs[job].color,
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


function RemoveSell(job)
	exports.bro_core:RemoveArea("sell")
	exports.bro_core:RemoveMenu(job)
	exports.bro_core:RemoveMenu("sell")
end

-- réparations
function FixVitres() 
	exports.bro_core:RemoveMenu("repair")
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		exports.bro_core:actionPlayer(4000, "Réparation", "mini@repair", "fixing_a_ped", function()
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
		end)
	else
		exports.bro_core:Notification("~r~Pas de véhicule à portée")
	end
end

function FixCarroserie()
	exports.bro_core:RemoveMenu("repair")
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		exports.bro_core:actionPlayer(4000, "Réparation", "scenario", "WORLD_HUMAN_CAR_PARK_ATTENDANT", function()
			SetVehicleBodyHealth(vehicle, 1000.0)
			SetVehiclePetrolTankHealth(vehicle, 1000.0)
			SetVehicleDeformationFixed(vehicle)
			TriggerServerEvent("job:repair:price", "carroserie", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
			exports.bro_core:Notification("Véhicle réparé")
		end)
	else
		exports.bro_core:Notification("~r~Pas de véhicule à portée")
	end
end

function FixPneus()
	exports.bro_core:RemoveMenu("repair")
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		exports.bro_core:actionPlayer(4000, "Réparation", "amb@world_human_vehicle_mechanic@male@exit", "exit", function()
			SetVehicleTyreFixed(vehicle, 0)
			SetVehicleTyreFixed(vehicle, 1)
			SetVehicleTyreFixed(vehicle, 2)
			SetVehicleTyreFixed(vehicle, 3)
			SetVehicleTyreFixed(vehicle, 4)
			SetVehicleTyreFixed(vehicle, 5)
			SetVehicleTyreFixed(vehicle, 6)
			TriggerServerEvent("job:repair:price", "tyres", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
			exports.bro_core:Notification("Véhicle réparé")
		end)
	else
		exports.bro_core:Notification("~r~Pas de véhicule à portée")
	end
end

function FixEngine()
	exports.bro_core:RemoveMenu("repair")
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		exports.bro_core:actionPlayer(4000, "Réparation", "amb@world_human_vehicle_mechanic@male@exit", "exit", function()
			SetVehicleEngineHealth(vehicle, 1000.0)
			SetVehicleUndriveable(vehicle, false)
			ClearPedTasksImmediately(playerPed)
			TriggerServerEvent("job:repair:price", "motor", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
			exports.bro_core:Notification("Véhicle réparé")
		end)
	else
		exports.bro_core:Notification("~r~Pas de véhicule à portée")
	end
end

-- Nettoyages
function CleanCarroserie()
	exports.bro_core:RemoveMenu("repair")
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		exports.bro_core:actionPlayer(4000, "Réparation", "amb@world_human_vehicle_mechanic@male@exit", "exit", function()
			SetVehicleDirtLevel(vehicle, 0.0)
			exports.bro_core:Notification("Véhicle réparé")
		end)
	else
		exports.bro_core:Notification("~r~Pas de véhicule à portée")
	end
end
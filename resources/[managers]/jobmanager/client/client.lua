job = {
	job = "Chomeur",
	grade = "Chomeur"
}

anyMenuOpen = {
	menuName = "",
	isActive = false
}
spawn = vector3(0,0,0)
heading = 0
avert = "LSPD"



RegisterNetEvent('job:get')

AddEventHandler("job:get", function(job)
	job = job[1]
	RegisterNUICallback('amount', function(data)
		print(job.job)
		TriggerServerEvent("job:safe:deposit", data.withdraw, data.amount, job.job)
		amount = tonumber(data.amount)
		SetNuiFocus(false, false)
	end)

	for kk, vv in pairs(config.jobs) do
		print(kk)
		if vv.homes then
			for k, v in pairs(vv.homes) do
				exports.bf:AddArea("homes"..kk..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bf:HelpPromt("Accueil Key : ~INPUT_PICKUP~")
								zone = k
								zoneType = "homes"
								avert = kk
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
						text = kk.. " Accueil "..k,
						imageId	= v.sprite,
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
			end
		end
	end

	-- Draw areas 
	if job ~= nil and job.job ~= nil then
		v = config.jobs[job.job]
		if v then
			if v.lockers then
				for k, v in pairs(v.lockers) do
					exports.bf:AddArea("lockers"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 1,
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
							imageId	= v.sprite,
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
						},
					})
				end
			end
			if v.collect then
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
					exports.bf:AddMenu("collect"..k, {
						title = "Récolte "..k,
						position = 1,
					})
				end
			end
			if v.process then
				for k, v in pairs(v.process) do
					exports.bf:AddArea("process"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 2,
							enter = {
								callback = function()
									exports.bf:HelpPromt("Traitement Key : ~INPUT_PICKUP~")
									zone = k
									zoneType = "process"
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
							text = job.job.. " Traitement "..k,
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
					exports.bf:AddMenu("process"..k, {
						title = "Traitement "..k,
						position = 1,
					})
				end
			end
			if v.safes then
				for k, v in pairs(v.safes) do
					exports.bf:AddArea("safes"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bf:HelpPromt("Coffre Key : ~INPUT_PICKUP~")
									zone = k
									zoneType = "safes"
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
							text = job.job.. " Coffre "..k,
							imageId	= v.sprite,
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
					exports.bf:AddMenu("safes"..k, {
						title = job.job.." Coffre "..k,
						position = 1,
						
					buttons = {
						{
							text = "Retirer",
							exec = {
								callback = function()
									TriggerServerEvent('account:job:withdraw', job.job, tonumber(exports.bf:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})))
									TriggerServerEvent("job:get", "job:safe:open")		
								end
							},
						},
						{
							text = "Déposer",
							exec = {
								callback = function()
									TriggerServerEvent('account:job:deposit', job.job, tonumber(exports.bf:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})))
									TriggerServerEvent("job:get", "job:safe:open")		
								end
							},
						},
					}
					})
				end
			end
			if v.armories then
				for k, v in pairs(v.armories) do
					exports.bf:AddArea("armories"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bf:HelpPromt("Armurerie Key : ~INPUT_PICKUP~")
									zone = k
									zoneType = "armories"
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
							text = job.job.. " Armurerie "..k,
							imageId	= v.sprite,
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
					exports.bf:AddMenu("armories"..k, {
						title = job.job.." Armurerie "..k,
						position = 1,
						closable = false,
						buttons= {
							{
								text = "Kit de base",
								exec = {
									callback = function()
										giveBasicKit()
									end
								},
							},
							{
								text = "Mettre Gillet",
								exec = {
									callback = function()
										addBulletproofVest()
									end
								},
							},
							{
								text = "Enlever Gillet",
								exec = {
									callback = function()
										removeBulletproofVest()
									end
								},
							},
							{
								text = "Quitter",
								exec = {
									callback = function()
										print("close")
										CloseArmory()
										exports.bf:CloseMenu("armories"..k)
									end
								},
							}
						}
					})
				end
			end

			if v.parking then
				for k, v in pairs(v.parking) do
				exports.bf:AddArea("parking"..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bf:HelpPromt("Parking Key : ~INPUT_PICKUP~")
								zone = k
								zoneType = "parking"
								spawn = v.spawn
								heading = v.heading
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
						text = job.job.. " Parking "..k,
						imageId	= v.sprite,
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
				exports.bf:AddMenu("parking"..k, {
					title = job.job.." Parking "..k,
					position = 1,
				})
				exports.bf:AddMenu("parking-veh", {
					title = "Parking",
					position = 1,
				})
				end
			end
		end
	end
end)


--redirect callbacks
local function isPedDrivingAVehicle()
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


RegisterNUICallback('sendAction', function(data, cb)
	_G[data.action](data.params)
    cb('ok')
end)

-- open menu loop
Citizen.CreateThread(function()
	TriggerServerEvent("job:get", "job:get")
	exports.bf:AddMenu("LSMS", {
		title = "Menu LSMS",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "SOIN",
				exec = {
					callback = function()
						closest = GetClosestPlayer()
						revivePlayer(closest)
					end
				},
			},
		},
	})
	exports.bf:AddMenu("LSPD", {
		title = "Menu LSPD",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Animations",
				openMenu = "lspd-animations"
			},
			{
				text = "Citoyen",
				openMenu = "lspd-citizens"
			},
			{
				text = "Vehicules",
				openMenu = "lspd-veh"
			},
			{
				text = "Objets",
				openMenu = "lspd-props"
			},
		},
	})
	exports.bf:AddMenu("lspd-animations", {
		title = "LSPD",
		menuTitle = "Animations",
		position = 1,
		buttons = {
			{
				text = "Traffic",
				exec = {
					callback = function()
						DoTraffic()
					end
				},
			},
			{
				text = "Notes",
				exec = {
					callback = function()
						Note()
					end
				},
			},
			{
				text = "Standby",
				exec = {
					callback = function()
						StandBy()
					end
				},
			},
			{
				text = "Standby2",
				exec = {
					callback = function()
						StandBy2()
					end
				},
			},
			{
				text = "Annuler l'animation",
				exec = {
					callback = function()
						CancelEmote()
					end
				},
			},
		},
	})
	exports.bf:AddMenu("lspd-citizens", {
		title = "LSPD",
		menuTitle = "Animations",
		position = 1,
		buttons = {
			{
				text = "Enelever armes",
				exec = {
					callback = function()
						RemoveWeapons()
					end
				},
			},
			{
				text = "Menotter",
				exec = {
					callback = function()
						ToggleCuff()
					end
				},
			},
			{
				text = "Porter",
				exec = {
					callback = function()
						DragPlayer()
					end
				},
			},
			{
				text = "Amendes",
				openMenu = "lspd-citizens-fines"
			},
		},
	})

	exports.bf:AddMenu("lspd-citizens-fines", {
		title = "LSPD",
		menuTitle = "Amendes",
		position = 1,
		buttons = {
			{
				text = "Infraction légére (250 $)",
				exec = {
					callback = function()
						Fines(250)
					end
				},
			},
			{
				text = "Infraction moyenne (500 $)",
				exec = {
					callback = function()
						Fines(500)
					end
				},
			},
			{
				text = "Infraction lourde (1000 $)",
				exec = {
					callback = function()
						Fines(1000)
					end
				},
			},
		},
	})

	exports.bf:AddMenu("lspd-veh", {
		title = "LSPD",
		menuTitle = "Vehicules",
		position = 1,
		buttons = {
			{
				text = "Supprimer",
				exec = {
					callback = function()
						DropVehicle()
					end
				},
			},
			{
				text = "Herses",
				exec = {
					callback = function()
						SpawnSpikesStripe()
					end
				},
			},
		},
	})


	exports.bf:AddMenu("lspd-props", {
		title = "LSPD",
		menuTitle = "Amendes",
		position = 1,
		buttons = {
			{
				text = "Barrière",
				exec = {
					callback = function()
						SpawnProps("prop_mp_barrier_01b")
					end
				},
			},
			{
				text = "Barrière 2",
				exec = {
					callback = function()
						SpawnProps("prop_barrier_work05")
					end
				},
			},
			{
				text = "Cone lumineux",
				exec = {
					callback = function()
						SpawnProps("prop_air_conelight")
					end
				},
			},
			{
				text = "Barrière 3",
				exec = {
					callback = function()
						SpawnProps("prop_barrier_work06a")
					end
				},
			},
			{
				text = "Cabine",
				exec = {
					callback = function()
						SpawnProps("prop_tollbooth_1")
					end
				},
			},
			{
				text = "Cone 1",
				exec = {
					callback = function()
						SpawnProps("prop_mp_cone_01")
					end
				},
			},
			{
				text = "Cone 2",
				exec = {
					callback = function()
						SpawnProps("prop_mp_cone_04")
					end
				},
			},
			{
				text = "Enlever dernier",
				exec = {
					callback = function()
						RemoveLastProps()
					end
				},
			},
			{
				text = "Enelever tout",
				exec = {
					callback = function()
						RemoveAllProps()
					end
				},
			},
		},
	})


    while true do
		Citizen.Wait(0)	
		if zone ~= nil and zoneType ~= nil and IsControlJustPressed(1,config.bindings.interact_position) then
			if zoneType == "parking" then
				if isPedDrivingAVehicle() then
					exports.bf:SetMenuValue("parking-veh", {
						buttons = {
							{
								text = "Stocker : " .. zone,
								exec = {
									callback = function()
										TriggerServerEvent("vehicle:job:store", currentVehicle, "global")
										currentVehicle = 0
									
										DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
										exports.bf:CloseMenu("parking-veh")
									end
								},
							}
						}
					})	
					exports.bf:OpenMenu("parking-veh")
				else
					TriggerServerEvent("job:get", "job:parking:open")		
				end
			elseif zoneType == "homes" then
				TriggerServerEvent("job:avert:all", avert)
			elseif zoneType == "safes" then
				TriggerServerEvent("job:get", "job:safe:open")		
			elseif zoneType == "collect" then
				TriggerServerEvent("job:get", "job:collect:open")	
			elseif zoneType == "process" then
				TriggerServerEvent("job:get", "job:process:open")		
			elseif zoneType == "armories" then
				DoScreenFadeOut(500)
				Wait(600)

				Wait(800)
				armoryPed = createArmoryPed()

				if not DoesCamExist(ArmoryRoomCam) then
					ArmoryRoomCam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
					AttachCamToEntity(ArmoryRoomCam, PlayerPedId(), 0.0, 0.0, 1.0, true)
					PointCamAtEntity(ArmoryRoomCam, armoryPed, 0.0, -30.0, 1.0, true)

					SetCamRot(ArmoryRoomCam, 0.0,0.0, GetEntityHeading(PlayerPedId()))
					SetCamFov(ArmoryRoomCam, 70.0)							
				end

				Wait(100)
				DoScreenFadeIn(500)

				if DoesEntityExist(armoryPed) then
					TaskTurnPedToFaceEntity(PlayerPedId(), armoryPed, -1)
				end							

				Wait(300)
				exports.bf:OpenMenu(zoneType..zone)
				if not IsAmbientSpeechPlaying(armoryPed) then
					PlayAmbientSpeechWithVoice(armoryPed, "WEPSEXPERT_GREETSHOPGEN", "WEPSEXP", "SPEECH_PARAMS_FORCE", 0)
				end
			else
				exports.bf:OpenMenu(zoneType..zone)
			end
		end

		if IsControlJustPressed(1,config.bindings.use_job_menu) then
			TriggerServerEvent("job:get", "job:open:menu")
		end
	end
end)



RegisterNetEvent('job:process:open')

AddEventHandler("job:process:open", function(job)  
	job = job[1]	
	buttons = {}
	for k, v in pairs(config.jobs[job.job].process[zone].items) do

		buttons[#buttons+1] = {
			text = "Traitement "..v.label,
			exec = {
				callback = function()
					TriggerServerEvent('items:process', v.type,  v.amount, v.to,  v.amountTo) 
					exports.bf:Notification('Vous avez transformé : '..v.label.. " X "..v.amount)
					exports.bf:CloseMenu(zoneType..zone)
				end
			},
		}
	end
	exports.bf:SetMenuButtons(zoneType..zone, buttons)
	exports.bf:OpenMenu(zoneType..zone)
end)


RegisterNetEvent('job:collect:open')

AddEventHandler("job:collect:open", function(job)  
	job = job[1]	
	buttons = {}
	for k, v in pairs(config.jobs[job.job].collect[zone].items) do

		buttons[#buttons+1] = {
			text = "Collecter "..v.label,
			exec = {
				callback = function()
					TriggerServerEvent('items:add', v.type,  v.amount) 
					exports.bf:Notification('Vous avez collecté : '..v.label.. " X "..v.amount)
					exports.bf:CloseMenu(zoneType..zone)
				end
			},
		}
	end
	exports.bf:SetMenuButtons(zoneType..zone, buttons)
	exports.bf:OpenMenu(zoneType..zone)
end)

RegisterNetEvent('job:parking:open')

AddEventHandler("job:parking:open", function(job)  
	job = job[1]
	TriggerServerEvent("vehicle:job:parking", "job:parking", job.job)
end)

RegisterNetEvent('job:safe:open2')

AddEventHandler("job:safe:open2", function(money) 
	exports.bf:SetMenuValue(zoneType..zone, {
		menuTitle = "Compte ~r~"..money.. " $"
	})
	exports.bf:OpenMenu(zoneType..zone)
end)

RegisterNetEvent('job:safe:open')

AddEventHandler("job:safe:open", function(job) 
	job = job[1].job
	TriggerServerEvent("account:job:get", "job:safe:open2", job)		
end)


RegisterNetEvent('job:open:menu')

AddEventHandler("job:open:menu", function(job)  
	job = job[1] 
	print(job.job)
	if job.job == "LSMS" or job.job == "LSPD" then
		exports.bf:OpenMenu(job.job)
	end
end)


RegisterNetEvent('job:parking')

AddEventHandler("job:parking", function(vehicles)  
	local buttons = {

	}
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label,
			exec = {
				callback = function() 
					TriggerServerEvent("job:parking:get", "job:parking:get", v.id)
				end
			},
	}
	end
	exports.bf:SetMenuButtons(zoneType..zone, buttons)
	exports.bf:OpenMenu(zoneType..zone)
end)

RegisterNetEvent('job:parking:get')

AddEventHandler("job:parking:get", function(name, id)  
	local playerPed = PlayerPedId() -- get the local player ped

	if not IsPedInAnyVehicle(playerPed) then
		local vehicleName = name
		currentVehicle = id
		-- check if the vehicle actually exists
		if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
			TriggerEvent('chat:addMessage', {
				args = { 'It might have been a good thing that you tried to spawn a ' .. vehicleName .. '. Who even wants their spawning to actually ^*succeed?' }
			})
			return
		end

		-- load the model
		RequestModel(vehicleName)

		-- wait for the model to load
		while not HasModelLoaded(vehicleName) do
			Wait(500) -- often you'll also see Citizen.Wait
		end
		
		ClearAreaOfVehicles(spawn.x, spawn.y, spawn.z, 5.0, false, false, false, false, false)
		-- create the vehicle
		local vehicle = CreateVehicle(vehicleName, spawn.x, spawn.y, spawn.z, heading, true, false)

		-- set the player ped into the vehicle's driver seat
		SetPedIntoVehicle(playerPed, vehicle, -1)

		-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
		SetEntityAsNoLongerNeeded(vehicle)

		-- release the model
		SetModelAsNoLongerNeeded(vehicleName)
								
		exports.bf:CloseMenu(zoneType..zone)
	end
end)

RegisterNetEvent('job:openStorageMenu')

AddEventHandler("job:openStorageMenu", function(location, job)   
	sell(location, job)
end)


function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

RegisterNetEvent('job:lsms:revive')

AddEventHandler("job:lsms:revive", function()  
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	RespawnPed(playerPed, coords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
	TriggerEvent("player:alive")
end)

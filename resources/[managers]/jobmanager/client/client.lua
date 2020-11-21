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
vehicleLivraison = 0
RegisterNetEvent('job:get')

AddEventHandler("job:get", function(job)
	job = job[1]
	RegisterNUICallback('amount', function(data)
		print(job.job)
		TriggerServerEvent("job:safe:deposit", data.withdraw, data.amount, job.job)
		amount = tonumber(data.amount)
		SetNuiFocus(false, false)
	end)

	ClearAllBlipRoutes()

	exports.bf:AddArea("center", {
		marker = {
			weight = 1,
			height = 1,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					exports.bf:HelpPromt("Job Center Key : ~INPUT_PICKUP~")
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
						text = kk,
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
	if job ~= nil and job.job ~= nil then
		myjob = config.jobs[job.job]
		if myjob then
			if myjob.lockers then
				for k, v in pairs(myjob.lockers) do
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
			if myjob.collect then
				for k, v in pairs(myjob.collect) do
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
					exports.bf:AddMenu("collect"..k, {
						title = "Récolte "..k,
						position = 1,
					})
				end
			end
			if myjob.process then
				for k, v in pairs(myjob.process) do
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
					exports.bf:AddMenu("process"..k, {
						title = "Traitement "..k,
						position = 1,
					})
				end
			end
			if myjob.safes then
				for k, v in pairs(myjob.safes) do
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
			if myjob.armories then
				for k, v in pairs(myjob.armories) do
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
			if myjob.parking then
				for k, v in pairs(myjob.parking) do
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
			if myjob.begin then
				print("yopotet")
				for k, v in pairs(myjob.begin) do
				exports.bf:AddArea("begin"..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bf:HelpPromt("Commencer la tournée Key : ~INPUT_PICKUP~")
								zone = k
								zoneType = "begin"
								vehicle = v.vehicle
								coords = v.coords
								points = v.points
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
						text = job.job.. " Livraisons "..k,
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
end)

RegisterNUICallback('sendAction', function(data, cb)
	_G[data.action](data.params)
    cb('ok')
end)

-- open menu loop
Citizen.CreateThread(function()
	TriggerServerEvent("job:get", "job:get")

	-- create all menus
	menus()

	-- main loop
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
			elseif zoneType == "center" then
				exports.bf:OpenMenu("center")
			elseif zoneType == "begin" then
				--spawn vehicle
				    -- account for the argument not being passed
					local vehicleName = vehicle
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
				
					-- get the player's position
					local playerPed = PlayerPedId() -- get the local player ped
					local pos = coords -- get the position of the local player ped
				
					-- create the vehicle
					local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
				
					-- set the player ped into the vehicle's driver seat
					SetPedIntoVehicle(playerPed, vehicle, -1)
				
					-- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
					SetEntityAsNoLongerNeeded(vehicle)
				
					vehicleLivraison = vehicle
					-- release the model
					SetModelAsNoLongerNeeded(vehicleName)
					--on lui file des points

					addBeginArea() 

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

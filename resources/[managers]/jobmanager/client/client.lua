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
beginInProgress = false
RegisterNetEvent('job:get')

AddEventHandler("job:get", function(job)
	job = job[1]
	RegisterNUICallback('amount', function(data)
		print(job.job)
		TriggerServerEvent("job:safe:deposit", data.withdraw, data.amount, job.job)
		amount = tonumber(data.amount)
		SetNuiFocus(false, false)
	end)
	refresh(job)
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
				TriggerServerEvent("job:avert:all", avert, "On vous demande à l'acceuil ~b~(".. avert.. ")")
			elseif zoneType == "center" then
				exports.bf:OpenMenu("center")
			elseif zoneType == "begin" then
				if not beginInProgress then
				    -- account for the argument not being passed
					local vehicleName = vehicle

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
				else
					exports.bf:Notification("Vous avez déjà une course en cours !")
				end
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
job = {
	job = "Chomeur",
	grade = "Chomeur"
}
spawn = vector3(0,0,0)
heading = 0
avert = "LSPD"
vehicleLivraison = 0
beginInProgress = false
tva = 0.20
lockCollect = false
lockRepare = false
nbSold = 0
lockHeal = false
-- police vars
handCuffed = false

RegisterNetEvent('job:get')

AddEventHandler("job:get", function(job)
	job = job[1]
	RegisterNUICallback('amount', function(data)
		TriggerServerEvent("job:safe:deposit", data.withdraw, data.amount, job.job)
		amount = tonumber(data.amount)
		SetNuiFocus(false, false)
	end)
	refresh(job)
end)

-- open menu loop
Citizen.CreateThread(function()
	
	RequestAnimDict('mp_arresting')
	while not HasAnimDictLoaded('mp_arresting') do
		Citizen.Wait(50)
	end	
	
	TriggerServerEvent("job:get", "job:get")

	-- create all menus
	menus()

	-- main loop
    while true do
		Citizen.Wait(0)	
		if zone ~= nil and zoneType ~= nil and IsControlJustPressed(1,config.bindings.interact_position) then
			if zoneType == "homes" then
				TriggerServerEvent("job:avert:all", avert, "On vous demande à l'acceuil ~b~(".. avert.. ")")
			elseif zoneType == "repair" then
				if isPedDrivingAVehicle() then
					exports.bf:OpenMenu("repair")
				else
					exports.bf:Notification("Montez dans un véhicule")
				end
			elseif zoneType == "custom" then
				if isPedDrivingAVehicle() then
					customMenu()
					exports.bf:OpenMenu("custom")
				else
					exports.bf:Notification("Montez dans un véhicule")
				end
			elseif zoneType == "center" then
				exports.bf:OpenMenu("center")
			elseif zoneType == "begin" then
				if not beginInProgress then
					vehicleLivraison = exports.bf:spawnCar(vehicle, true, nil, true)
					addBeginArea() 
				else
					exports.bf:Notification("Vous avez déjà une course en cours !")
				end
			elseif zoneType == "safes" then
				exports.bf:OpenMenu(zoneType..zone)
			elseif zoneType == "collect" then
				TriggerServerEvent("job:get", "job:collect:open")	
			elseif zoneType == "process" then
				TriggerServerEvent("job:get", "job:process:open")		
			elseif zoneType == "sell" then
				TriggerServerEvent("job:get", "job:sell:open")		
			elseif zoneType == "armories" then
				exports.bf:OpenMenu("armories1")
			elseif zoneType == "fourriere" then
				-- Mise en fourriére
				vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				if vehicle ~= nil then
					TriggerServerEvent("vehicle:parking:store", vehicle, "depot", "")
					exports.bf:Notification("Vous avez mis le véhicle en fourriére")
					DeleteEntity(vehicle)
				else
					exports.bf:Notification("Vous n'êtes pas dans un véhicule")
				end
			else
				exports.bf:OpenMenu(zoneType..zone)
			end
		end

		if zone ~= "custom" then
			customMenuRemove()
		end
		if IsControlJustPressed(1,config.bindings.use_job_menu) then
			TriggerServerEvent("job:get", "job:open:menu")
		end


		if (handCuffed == true) then
			local myPed = PlayerPedId()
			local animation = 'idle'
			local flags = 50				
			
			while IsPedBeingStunned(myPed, 0) do
				ClearPedTasksImmediately(myPed)
			end

			DisableControlAction(1, 12, true)
			DisableControlAction(1, 13, true)
			DisableControlAction(1, 14, true)

			DisableControlAction(1, 23, true)
			DisableControlAction(1, 24, true)

			DisableControlAction(1, 15, true)
			DisableControlAction(1, 16, true)
			DisableControlAction(1, 17, true)

			if not cuffing then
				SetCurrentPedWeapon(myPed, GetHashKey("WEAPON_UNARMED"), true)
				RemoveAllPedWeapons(myPed, true)
				cuffing = true
			end

			if not IsEntityPlayingAnim(myPed, "mp_arresting", animation, 3) then
				TaskPlayAnim(myPed, "mp_arresting", animation, 8.0, -8.0, -1, flags, 0, 0, 0, 0 )
			end
		else
			EnableControlAction(1, 12, false)
			EnableControlAction(1, 13, false)
			EnableControlAction(1, 14, false)

			EnableControlAction(1, 23, false)
			EnableControlAction(1, 24, false)

			EnableControlAction(1, 15, false)
			EnableControlAction(1, 16, false)
			EnableControlAction(1, 17, false)

			if IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) then
				StopAnimTask(PlayerPedId(), "mp_arresting", animation, 3)
				ClearPedTasksImmediately(PlayerPedId())
			end

			cuffing = false		
		end
	end
end)
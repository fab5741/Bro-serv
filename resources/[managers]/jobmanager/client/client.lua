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
		TriggerServerEvent("job:safe:deposit", data.withdraw, data.amount, job.job)
		amount = tonumber(data.amount)
		SetNuiFocus(false, false)
	end)
	refresh(job)
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
			elseif zoneType == "repair" then
				if isPedDrivingAVehicle() then
					exports.bf:OpenMenu("repair")
				else
					exports.bf:Notification("Montez dans un véhicule")
				end
			elseif zoneType == "custom" then
				if isPedDrivingAVehicle() then
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
			elseif zoneType == "armories" then
				openArmory()
			else
				exports.bf:OpenMenu(zoneType..zone)
			end
		end

		if IsControlJustPressed(1,config.bindings.use_job_menu) then
			TriggerServerEvent("job:get", "job:open:menu")
		end
	end
end)
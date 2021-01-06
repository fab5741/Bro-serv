VehicleLivraison = 0
BeginInProgress = false
NbSold = 0
-- police vars
HandCuffed = false
Ped = GetPlayerPed(-1)
job = {
	name = "chomeur",
	label = "chomeur"
}
SafeButtons = {

}
RegisterNetEvent('job:get')

AddEventHandler("job:get", function(job)
	job = job[1]
	Refresh(job)
end)

-- open menu loop
Citizen.CreateThread(function()
	
	RequestAnimDict('mp_arresting')
	while not HasAnimDictLoaded('mp_arresting') do
		Citizen.Wait(50)
	end	
	
	TriggerServerEvent("job:get", "job:get")
	-- main loop
    while true do
		Citizen.Wait(0)	
		if IsControlJustPressed(1,Config.bindings.use_job_menu) then
			TriggerServerEvent("job:get", "job:open:menu")
		end

		if (HandCuffed == true) then
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

			if not Cuffing then
				SetCurrentPedWeapon(myPed, GetHashKey("WEAPON_UNARMED"), true)
				RemoveAllPedWeapons(myPed, true)
				Cuffing = true
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

			Cuffing = false		
		end
	end
end)
local config = {
    hospitals = {	
		vector3(340.73, -584.6, 28.79),
	}
}
config.BleedoutTimer = 900000 -- time til the player bleeds out 15 min
local isDead = false
local PlayerPed = PlayerPedId()

-- Create blips
Citizen.CreateThread(function()	
	for k,v in pairs(config.hospitals) do
		exports.bro_core:AddBlip("hospitals"..k, {
			x = v.x,
			y = v.y,
			z = v.z,
			imageId	=61,
			scale =1.2,
			colorId=8,
			text = "Hopital",
		})
	end
end)


--beds 
local Beds, CurrentBed, OnBed = {'v_med_bed2', 'v_med_bed1', 'v_med_emptybed'}, nil, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		if not OnBed then
			local PlayerCoords = GetEntityCoords(PlayerPed)

			for k,v in pairs(Beds) do
				local ClosestBed = GetClosestObjectOfType(PlayerCoords, 1.5, GetHashKey(v), false, false)

				if ClosestBed ~= 0 and ClosestBed ~= nil then
					CurrentBed = ClosestBed
					break
				else
					CurrentBed = nil
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if CurrentBed ~= nil then
			if not OnBed then
				local BedCoords = GetEntityCoords(CurrentBed)
				exports.bro_core:Show3DText({ text = "~g~[E] ~w~ pour se coucher", x = BedCoords.x, y = BedCoords.y, z = (BedCoords.z+1), scale = 0.35 })
			end
		end
		if CurrentBed ~= nil and IsControlJustReleased(0, 38) then
			local BedCoords, BedHeading = GetEntityCoords(CurrentBed), GetEntityHeading(CurrentBed)

			exports.bro_core:LoadAnimSet('missfbi1')

			SetEntityCoords(PlayerPed, BedCoords)
			SetEntityHeading(PlayerPed, (BedHeading+180))

			TaskPlayAnim(PlayerPed, 'missfbi1', 'cpr_pumpchest_idle', 8.0, -8.0, -1, 1, 0, false, false, false)
			exports.bro_core:TextNotification({text="~g~F1~w~ pour vous relever"})

			OnBed = true
		elseif IsControlJustReleased(0, 288) and IsEntityPlayingAnim(PlayerPedId(), 'missfbi1', 'cpr_pumpchest_idle', 3) then
			ClearPedTasks(PlayerPedId())

			OnBed = false
		end
	end
end)

-- remove my blips on script stop
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	for k,v in pairs(config.hospitals) do
		exports.bro_core:RemoveBlip("hospitals"..k)
	end
end)


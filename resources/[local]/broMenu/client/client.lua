firstname = "John"
lastname = "Smith"
birth = "00/00/0000"

interactionDistance = 3.5 --The radius you have to be in to interact with the vehicle.
lockDistance = 25 --The radius you have to be in to lock your vehicle.

--  V A R I A B L E S --
engineoff = false
saved = false
controlsave_bool = false
lockGetCar = false
lockStoreCar = false
lockChanging = false
clothes_dict = "amb@world_human_gardener_plant@male@enter"
clothes_anim = "enter"
ped = GetPlayerPed(-1)

Citizen.CreateThread(function()
	-- main loop
  while true do
    Citizen.Wait(0)
	if (IsControlJustPressed(1, 288)) then
		if exports.bro_core:MenuIsOpen("bromenu") then
			exports.bro_core:RemoveMenu("bromenu") 
		else
			TriggerServerEvent("job:get", "bromenu:open")
		end
	end
  end
end)

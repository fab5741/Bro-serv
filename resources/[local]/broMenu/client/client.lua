firstname = "John"
lastname = "Smith"
birth = "00/00/0000"

IsEngineOn = true
interactionDistance = 3.5 --The radius you have to be in to interact with the vehicle.
lockDistance = 25 --The radius you have to be in to lock your vehicle.

--  V A R I A B L E S --
engineoff = false
saved = false
controlsave_bool = false

Citizen.CreateThread(function()
	-- main loop
  while true do
    Citizen.Wait(0)
	if (IsControlJustPressed(1, 288)) then
		if exports.bf:MenuIsOpen("bro") then
			exports.bf:CloseMenu("bro") 
		else
			TriggerServerEvent("job:get", "bf:open")
		end
	end
  end
end)

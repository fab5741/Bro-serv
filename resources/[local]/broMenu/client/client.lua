firstname = "John"
lastname = "Smith"
birth = "00/00/0000"

CharacterDad = 0
CharacterMom = 0

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

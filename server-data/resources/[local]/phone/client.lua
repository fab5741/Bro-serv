GUI = {}
GUI.PhoneIsShowed = false
GUI.MessagesIsShowed = false
GUI.AddContactIsShowed = false
PhoneData = {}
PhoneData.phoneNumber = 03333
PhoneData.contacts = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if GUI.PhoneIsShowed then -- codes here: https://pastebin.com/guYd0ht4
			DisableControlAction(0, 1,    true) -- LookLeftRight
			DisableControlAction(0, 2,    true) -- LookUpDown
			DisableControlAction(0, 25,   true) -- Input Aim
			DisableControlAction(0, 106,  true) -- Vehicle Mouse Control Override

			DisableControlAction(0, 24,   true) -- Input Attack
			DisableControlAction(0, 140,  true) -- Melee Attack Alternate
			DisableControlAction(0, 141,  true) -- Melee Attack Alternate
			DisableControlAction(0, 142,  true) -- Melee Attack Alternate
			DisableControlAction(0, 257,  true) -- Input Attack 2
			DisableControlAction(0, 263,  true) -- Input Melee Attack
			DisableControlAction(0, 264,  true) -- Input Melee Attack 2

			DisableControlAction(0, 12,   true) -- Weapon Wheel Up Down
			DisableControlAction(0, 14,   true) -- Weapon Wheel Next
			DisableControlAction(0, 15,   true) -- Weapon Wheel Prev
			DisableControlAction(0, 16,   true) -- Select Next Weapon
			DisableControlAction(0, 17,   true) -- Select Prev Weapon
		else
			-- open phone
			-- todo: is player busy (handcuffed, etc)
            if IsControlJustReleased(0, 27) and IsInputDisabled(0) then
                print("show phone")
                SendNUIMessage({
                    showPhone = true,
                    phoneData = PhoneData
                })
            
                GUI.PhoneIsShowed = true
                if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                    TaskStartScenarioInPlace(GetPlayerPed(-1), 'WORLD_HUMAN_STAND_MOBILE', 0, true)
                end
			end
		end
	end
end)
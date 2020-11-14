local waitAction = 0
currentMenu = ""
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlPressed(0, 18) then
      SendNUIMessage({action = 'controlPressed', control = 'ENTER', name = currentMenu})
      PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end

    if IsControlPressed(0, 177)then
      SendNUIMessage({action  = 'controlPressed', control = 'BACKSPACE', name = currentMenu})
  end

    if IsControlPressed(0, 27) then
      PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
      SendNUIMessage({action  = 'controlPressed', control = 'TOP', name = currentMenu})
      waitAction = 1
    end

    if IsControlPressed(0, 173) then
      SendNUIMessage({action  = 'controlPressed', control = 'DOWN', name = currentMenu})
      waitAction = 1
      PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
    if waitAction then
      Citizen.Wait(500)
      waitAction = 0
    end
  end
end)

--Citizen.CreateThread(function() 
  --while true do
--
  --  Citizen.Wait(0)
    --HideHudComponentThisFrame(1);
    --HideHudComponentThisFrame(2);
    --HideHudComponentThisFrame(3);
    --HideHudComponentThisFrame(4);
    --HideHudComponentThisFrame(5);
    --HideHudComponentThisFrame(6);
    --HideHudComponentThisFrame(7);
    --HideHudComponentThisFrame(8);
    --HideHudComponentThisFrame(9);
    --HideHudComponentThisFrame(11);
    --HideHudComponentThisFrame(12);
   -- HideHudComponentThisFrame(13);
   -- HideHudComponentThisFrame(14);
    --HideHudComponentThisFrame(15);
    --HideHudComponentThisFrame(17);
   -- HideHudComponentThisFrame(18);
    --HideHudComponentThisFrame(20);
    --HideHudComponentThisFrame(21);
    --HideHudComponentThisFrame(22);
  --end
--end)


RegisterNUICallback('try', function(data)
  TriggerEvent("vehicle:try", data)
end)

RegisterNUICallback('buyVehicle', function(data)
  TriggerEvent("vehicle:buy", data)
end)

RegisterNUICallback('parkingGet', function(data)
  TriggerEvent("vehicle:parking:get", data)
end)


RegisterNUICallback('parkingStore', function(data)
  TriggerEvent("vehicle:parking:store", data)
end)


RegisterNUICallback('vehicleMenuClose', function()
  TriggerEvent("vehicle:menu:closed")
end)
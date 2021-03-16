--
-- Client is 100% loaded games
--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)

        if NetworkIsSessionStarted() then

            -- Send event to client & server
            TriggerServerEvent('bro_core:OnClientReady')
            TriggerEvent('bro_core:OnClientReady')

            -- tools thread
            MenuFrame()
          --  InstructionalButtonsFrame()

            -- Check player
            UpdatePlayerThread()
            Citizen.Wait(1000)

            -- Trigger
            CheckTriggerThread()
            ActiveTriggerThread()

            -- Marker
            CheckMarkerThread()
            ActiveMarkerThread()

            break

        end
    end
end)
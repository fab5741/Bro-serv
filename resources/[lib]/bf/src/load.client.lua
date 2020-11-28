--
-- Client is 100% loaded games
--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if NetworkIsSessionStarted() then

            -- Send event to client & server
            TriggerServerEvent('bf:OnClientReady')
            TriggerEvent('bf:OnClientReady')

            -- tools thread
            MenuFrame()
            InstructionalButtonsFrame()

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
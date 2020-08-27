Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false)
    Wait(0)
    
    SendNUIMessage({
        setDisplay = true,
        display    = val
    })
end)
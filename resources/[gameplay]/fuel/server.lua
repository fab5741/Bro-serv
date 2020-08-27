--Edited by Toni Morton and Solarfantom

RegisterNetEvent('frfuel:fuelAdded')
AddEventHandler('frfuel:fuelAdded', function(amount)
    print("fuel added")
    gallons = amount * 0.264172
    Wait(1500)
    TriggerClientEvent("notify:SendNotification", sourceValue, {text= "Refuel", type = "info", timeout = 5000})
    DrawNotification(false, true);
end)
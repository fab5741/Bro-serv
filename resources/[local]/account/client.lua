RegisterNetEvent("account:suitcase:on")

AddEventHandler("account:suitcase:on", function()
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_briefcase"), 1, false, true)

end)

RegisterNetEvent("account:suitcase:off")

AddEventHandler("account:suitcase:off", function()
    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("weapon_briefcase")) ----Leather Brifcase
end)
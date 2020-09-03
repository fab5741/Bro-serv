RegisterNetEvent("character:selectidentity")
RegisterNetEvent("character:openRegistration")

AddEventHandler("character:selectIdentity", function(identity)
    SelectIdentityAndSpawnCharacter(identity)
end)

AddEventHandler("character:openRegistration", function()
    -- identity arrives serialized here
    RequestRegistration(function(identity)
        initIdentity(identity)
    end)
end)

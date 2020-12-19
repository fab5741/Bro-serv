exports.bf:AddMenu("bro", {
    title = "Bro Menu",
    menuTitle = "Job",
    position = 1,
    buttons = {
        {
            text = "Portefeuille",
            exec = {
                callback = function()
                    TriggerServerEvent("account:player:liquid:get", "bf:liquid")
                end
            },
        },
        {
            text = "Inventaire",
            exec = {
                callback = function()
                    TriggerServerEvent("items:get", "bf:items")
                end
            },
        },
        {
            text = "Vehicule",
            openMenu = "bro-vehicle"
        },
        {
            text = "Vetements",
            openMenu = "bro-clothes"
        },
        {
            text = "Quitter son travail",
            exec = {
                callback = function()
                    if  exports.bf:OpenTextInput({ maxInputLength = 10 , title = "Oui, pour confirmer", customTitle = true}) == "oui" then
                        -- on quitte le job
                        TriggerServerEvent("job:set:me", nil, "Chomeur")
                        Wait(1000)
                        TriggerServerEvent("job:get", "jobs:refresh")
                    end
                end
            },
        },
    },
})
exports.bf:AddMenu("bro-wallet", {
    title = "Portefeuille",
    position = 1,
})
exports.bf:AddMenu("bro-items", {
    title = "Inventaire",
    position = 1,
})
exports.bf:AddMenu("bro-items-item", {
    title = "Item",
    position = 1,
})
exports.bf:AddMenu("bro-wallet-character", {
    title = "Personnage",
    menuTitle = "Léon Paquin (17/05/1992)",
    position = 1,
    buttons = {
        {
            text = "Nom",
            exec = {
                callback = function()
                    lastname = exports.bf:OpenTextInput({ title="Nom", maxInputLength=25, customTitle=true})
                    TriggerServerEvent("bro:set", "lastname", lastname, "bro:set")
                end
            }
        },
        {
            text = "Prénom",
            exec = {
                callback = function()
                    firstname = exports.bf:OpenTextInput({ title="Prénom", maxInputLength=25, customTitle=true})
                    TriggerServerEvent("bro:set", "firstname", firstname, "bro:set")
                end
            }
        },
        {
            text = "Date de naissance",
            exec = {
                callback = function()
                    birth = exports.bf:OpenTextInput({ title="Date de naissance (01/01/1999)", maxInputLength=10, customTitle=true})
                    TriggerServerEvent("bro:set", "birth", birth, "bro:set")
                end
            }
        },
    },
})




exports.bf:AddMenu("bro-vehicle", {
    title = "Véhicule",
    position = 1,
    buttons = {
        {
            text = "Verrouiller/Déverouiller",
            exec = {
                callback = function()
                    local player = GetPlayerPed(-1)
                    local pos = GetEntityCoords(PlayerPedId())
                    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
            
                    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
                    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
                    local vehicle2 = GetVehiclePedIsIn(player, false)
                        if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                                TriggerServerEvent("vehicle:lock", "vehicle:lock", vehicle)
                        elseif DoesEntityExist(vehicle2) and IsEntityAVehicle(vehicle2)  then
                            if GetPedInVehicleSeat(vehicle2, -1) == player then
                                TriggerServerEvent("vehicle:lock", "vehicle:lock", vehicle2)
                            else
                                exports.bf:Notification("~r~Vous ne conduisez pas") 
                            end
                        else
                            exports.bf:Notification("~r~Pas de voiture à portée")
                        end
                end
            }
        },
        {
            text = "Inventaire coffre",
            exec = {
                callback = function()
                    coords = GetEntityCoords(GetPlayerPed(-1), true)
                    local player = GetPlayerPed(-1)
                    local pos = GetEntityCoords(PlayerPedId())
                    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
                    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
            
                    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
                    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
                    local islocked = GetVehicleDoorLockStatus(vehicle)
                    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                        if (islocked == 1)then
                        TriggerServerEvent("items:vehicle:get", "vehicle:items:open", vehicle)
                    end
                else
                    exports.bf:Notification("~r~Pas de voiture")
                end
        end
            }
        },
        {
            text = "Moteur",
            exec = {
                callback = function()
                    local player = GetPlayerPed(-1)
	
                    if (IsPedSittingInAnyVehicle(player)) then 
                        local vehicle = GetVehiclePedIsIn(player,false)
                        
                        if IsEngineOn == true then
                            IsEngineOn = false
                            SetVehicleEngineOn(vehicle,false,false,false)
                        else
                            IsEngineOn = true
                            SetVehicleUndriveable(vehicle,false)
                            SetVehicleEngineOn(vehicle,true,false,false)
                        end
                        
                        while (IsEngineOn == false) do
                            SetVehicleUndriveable(vehicle,true)
                            Citizen.Wait(0)
                        end
                    end
                end
            }
        },
        {
            text = "Coffre",
            exec = {
                callback = function()
                    local player = GetPlayerPed(-1)
                    vehicle = GetVehiclePedIsIn(player,true)
                    
                    local isopen = GetVehicleDoorAngleRatio(vehicle,5)
                    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
                    
                    if distanceToVeh <= interactionDistance then
                        if (isopen == 0) then
                        SetVehicleDoorOpen(vehicle,5,0,0)
                        else
                        SetVehicleDoorShut(vehicle,5,0)
                        end
                    else
                        exports.bf:Notification("~r~vous devez être dans un véhicule")
                    end
                end
            }
        },
        {
            text = "Porte avant",
            exec = {
                callback = function()
                    local player = GetPlayerPed(-1)
                    vehicle = GetVehiclePedIsIn(player,true)
                    local isopen = GetVehicleDoorAngleRatio(vehicle,0) and GetVehicleDoorAngleRatio(vehicle,1)
                    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
                    
                    if distanceToVeh <= interactionDistance then
                        if (isopen == 0) then
                        SetVehicleDoorOpen(vehicle,0,0,0)
                        SetVehicleDoorOpen(vehicle,1,0,0)
                        else
                        SetVehicleDoorShut(vehicle,0,0)
                        SetVehicleDoorShut(vehicle,1,0)
                        end
                    else
                        exports.bf:Notification("~r~vous devez être dans un véhicule")
                    end
                end
            }
        },
        {
            text = "Porte arriéres",
            exec = {
                callback = function()
                    local player = GetPlayerPed(-1)
                    vehicle = GetVehiclePedIsIn(player,true)
                    local isopen = GetVehicleDoorAngleRatio(vehicle,2) and GetVehicleDoorAngleRatio(vehicle,3)
                    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
                    
                    if distanceToVeh <= interactionDistance then
                        if (isopen == 0) then
                        SetVehicleDoorOpen(vehicle,2,0,0)
                        SetVehicleDoorOpen(vehicle,3,0,0)
                        else
                        SetVehicleDoorShut(vehicle,2,0)
                        SetVehicleDoorShut(vehicle,3,0)
                        end
                    else
                        exports.bf:Notification("~r~vous devez être dans un véhicule")
                    end
                end
            }
        },
        {
            text = "Capot",
            exec = {
                callback = function()
                        local player = GetPlayerPed(-1)
                        vehicle = GetVehiclePedIsIn(player,true)
                            
                        local isopen = GetVehicleDoorAngleRatio(vehicle,4)
                        local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
                        
                        if distanceToVeh <= interactionDistance then
                            if (isopen == 0) then
                            SetVehicleDoorOpen(vehicle,4,0,0)
                            else
                            SetVehicleDoorShut(vehicle,4,0)
                            end
                        else
                        exports.bf:Notification("~r~vous devez être dans un véhicule")
                    end
                end
            }
        },
    }
})
exports.bf:AddMenu("bro-vehicles", {
    title = "Vehicules",
    position = 1,
})
exports.bf:AddMenu("bro-clothes", {
    title = "Vetements",
    position = 1,
    buttons = {
        {
            text = "Remettre",
            exec = {
                callback = function()
                    TriggerServerEvent("bro:skin:get", "bromenu:skin:reset")
                end
            },
        },
        {
            text = "Masque",
            exec = {
                callback = function()
                    TriggerEvent('bromenu:mask')
                end
            },
        },
        {
            text = "T-Shirt",
            exec = {
                callback = function()
                    TriggerEvent('bromenu:koszulka')
                end
            },
        },
        {
            text = "Pantalon",
            exec = {
                callback = function()
                    TriggerEvent('bromenu:spodnie')
                end
            },
        },
        {
            text = "Chaussures",
            exec = {
                callback = function()
                    TriggerEvent('bromenu:buty')
                end
            },
        },
    }
})

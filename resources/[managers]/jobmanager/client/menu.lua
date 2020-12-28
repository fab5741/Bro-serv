function menus() 
	exports.bro_core:AddMenu("lspd", {
		title = "Menu LSPD",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Animations",
				openMenu = "lspd-animations"
			},
			{
				text = "Citoyen",
				openMenu = "lspd-citizens"
			},
			{
				text = "Vehicules",
				openMenu = "lspd-veh"
			},
			{
				text = "Objets",
				openMenu = "lspd-props"
			},
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bro_core:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bro_core:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local closestPlayer, dist = GetClosestPlayer()

						if closestPlayer and dist <=1 then
							TriggerServerEvent("job:facture", GetPlayerServerId(closestPlayer), motif, price, 2)
						else
							exports.bro_core:Notification("Pas de joueur à proximité")
						end
						exports.bro_core:CloseMenu("lspd")
					end
				},
			},
			{
				text = "Gestion service",
				exec = {
					callback = function()
						TriggerServerEvent("job:isChef", "jobs:service:manage")
					end
				},
			},
		},	
	})
	exports.bro_core:AddMenu("lspd-animations", {
		title = "LSPD",
		menuTitle = "Animations",
		position = 1,
		buttons = {
			{
				text = "Traffic",
				exec = {
					callback = function()
						DoTraffic()
					end
				},
			},
			{
				text = "Notes",
				exec = {
					callback = function()
						Note()
					end
				},
			},
			{
				text = "Standby",
				exec = {
					callback = function()
						StandBy()
					end
				},
			},
			{
				text = "Standby2",
				exec = {
					callback = function()
						StandBy2()
					end
				},
			},
			{
				text = "Annuler l'animation",
				exec = {
					callback = function()
						CancelEmote()
					end
				},
			},
		},
	})
	exports.bro_core:AddMenu("lspd-citizens", {
		title = "LSPD",
		menuTitle = "Animations",
		position = 1,
		buttons = {
			{
				text = "Enelever armes",
				exec = {
					callback = function()
						RemoveWeapons()
					end
				},
			},
			{
				text = "Menotter",
				exec = {
					callback = function()
						ToggleCuff()
					end
				},
			},
			{
				text = "Amendes",
				openMenu = "lspd-citizens-fines"
			},
			{
				text = "Donner permis arme",
				exec = {
					callback = function()
						giveWeaponLicence()
					end
				},
			},
		},
	})

	exports.bro_core:AddMenu("lspd-citizens-fines", {
		title = "LSPD",
		menuTitle = "Amendes",
		position = 1,
		buttons = {
			{
				text = "Infraction légére (250 $)",
				exec = {
					callback = function()
						Fines(250)
					end
				},
			},
			{
				text = "Infraction moyenne (500 $)",
				exec = {
					callback = function()
						Fines(500)
					end
				},
			},
			{
				text = "Infraction lourde (1000 $)",
				exec = {
					callback = function()
						Fines(1000)
					end
				},
			},
		},
	})

	exports.bro_core:AddMenu("lspd-veh", {
		title = "LSPD",
		menuTitle = "Vehicules",
		position = 1,
		buttons = {
			{
				text = "Supprimer",
				exec = {
					callback = function()
						DropVehicle()
					end
				},
			},
			{
				text = "Herses",
				exec = {
					callback = function()
						SpawnSpikesStripe()
					end
				},
			},
		},
	})


	exports.bro_core:AddMenu("lspd-props", {
		title = "LSPD",
		menuTitle = "Amendes",
		position = 1,
		buttons = {
			{
				text = "Barrière",
				exec = {
					callback = function()
						SpawnProps("prop_mp_barrier_01b")
					end
				},
			},
			{
				text = "Barrière 2",
				exec = {
					callback = function()
						SpawnProps("prop_barrier_work05")
					end
				},
			},
			{
				text = "Cone lumineux",
				exec = {
					callback = function()
						SpawnProps("prop_air_conelight")
					end
				},
			},
			{
				text = "Barrière 3",
				exec = {
					callback = function()
						SpawnProps("prop_barrier_work06a")
					end
				},
			},
			{
				text = "Cabine",
				exec = {
					callback = function()
						SpawnProps("prop_tollbooth_1")
					end
				},
			},
			{
				text = "Cone 1",
				exec = {
					callback = function()
						SpawnProps("prop_mp_cone_01")
					end
				},
			},
			{
				text = "Cone 2",
				exec = {
					callback = function()
						SpawnProps("prop_mp_cone_04")
					end
				},
			},
			{
				text = "Enlever dernier",
				exec = {
					callback = function()
						RemoveLastProps()
					end
				},
			},
			{
				text = "Enlever tout",
				exec = {
					callback = function()
						RemoveAllProps()
					end
				},
			},
		},
	})

	exports.bro_core:AddMenu("lsms", {
		title = "Menu LSMS",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Soigner",
				exec = {
					callback = function()
						healClosestPlayer()
					end
				},
			},
			{
				text = "Réanimer",
				exec = {
					callback = function()
						reviveClosestPlayer()
					end
				},
			},
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bro_core:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bro_core:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local closestPlayer, dist = GetClosestPlayer()

						if closestPlayer and dist <=1 then
							TriggerServerEvent("job:facture", GetPlayerServerId(closestPlayer), motif, price, 3)
						else
							exports.bro_core:Notification("Pas de joueur à proximité")
						end
						exports.bro_core:CloseMenu("lspd")
					end
				},
			},
			{
				text = "Gestion service",
				exec = {
					callback = function()
						TriggerServerEvent("job:isChef", "jobs:service:manage")
					end
				},
			},
		}
	})

    -- job center
    buttons = {}
    for k, v in pairs(config.center.jobs) do
        buttons[#buttons+1] = {
            text = v.label,
            exec = {
                callback = function()
					TriggerServerEvent("job:set:me", 34, "Livreur de journaux")
					Wait(100)
					TriggerServerEvent("job:get", "jobs:refresh")
					exports.bro_core:CloseMenu("center")
                end
            },
        }
    end

	exports.bro_core:AddMenu("farm", {
		title = "Menu Fermier",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bro_core:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bro_core:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local closestPlayer, dist = GetClosestPlayer()

						if closestPlayer and dist <=1 then
							TriggerServerEvent("job:facture", GetPlayerServerId(closestPlayer), motif, price, 4)
						else
							exports.bro_core:Notification("Pas de joueur à proximité")
						end
						exports.bro_core:CloseMenu("ferm")
					end
				},
			},
			{
				text = "Commencer la revente",
				exec = {
					callback = function()
						beginSell("farm")
					end
				},
			},
			{
				text = "Finir la revente",
				exec = {
					callback = function()
						removeSell("farm")
					end
				},
			},
			{
				text = "Gestion service",
				exec = {
					callback = function()
						TriggerServerEvent("job:isChef", "jobs:service:manage")
					end
				},
			},
		}
	})
	
	exports.bro_core:AddMenu("sell", {
		title = "Revente ",
		position = 2,
	})

	exports.bro_core:AddMenu("wine", {
		title = "Menu Vigneron",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bro_core:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bro_core:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local closestPlayer, dist = GetClosestPlayer()

						if closestPlayer and dist <=1 then
							TriggerServerEvent("job:facture", GetPlayerServerId(closestPlayer), motif, price, 5)
						else
							exports.bro_core:Notification("Pas de joueur à proximité")
						end
						exports.bro_core:CloseMenu("wine")
					end
				},
			},
			{
				text = "Commencer la revente",
				exec = {
					callback = function()
						beginSell("wine")
					end
				},
			},
			{
				text = "Finir la revente",
				exec = {
					callback = function()
						removeSell("wine")
					end
				},
			},
			{
				text = "Gestion service",
				exec = {
					callback = function()
						TriggerServerEvent("job:isChef", "jobs:service:manage")
					end
				},
			},
		}
	})

	exports.bro_core:AddMenu("taxi", {
		title = "Menu Taxi",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bro_core:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bro_core:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local closestPlayer, dist = GetClosestPlayer()

						if closestPlayer and dist <=1 then
							TriggerServerEvent("job:facture", GetPlayerServerId(closestPlayer), motif, price, 6)
						else
							exports.bro_core:Notification("Pas de joueur à proximité")
						end
						exports.bro_core:CloseMenu("taxi")
					end
				},
			},
			{
				text = "Commencer les courses",
				exec = {
					callback = function()
						TriggerEvent("taxi:fares:start")
						exports.bro_core:Notification("Les courses commencent")
						exports.bro_core:CloseMenu("taxi")
					end
				},
			},
			{
				text = "Stopper les courses",
				exec = {
					callback = function()
						TriggerEvent("taxi:fares:stop")
						exports.bro_core:Notification("Fin des courses")
						exports.bro_core:CloseMenu("taxi")
					end
				},
			},
			{
				text = "Gestion service",
				exec = {
					callback = function()
						TriggerServerEvent("job:isChef", "jobs:service:manage")
					end
				},
			},
		}
	})

	exports.bro_core:AddMenu("bennys", {
		title = "Menu Benny's",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
					text = "Réparer vitres",
					exec = {
					callback = function()
						local playerPed = GetPlayerPed(-1)
						coords = GetEntityCoords(GetPlayerPed(-1), true)
						local pos = GetEntityCoords(PlayerPedId())
						local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
				
						local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
						local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
						local prop_name = 'prop_cs_wrench'
						if lockRepare == false then
							if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
								if not IsPedInAnyVehicle(playerPed, false) then
									local time = 4000
									TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
									exports.bro_core:CloseMenu("repair")
									lockRepare = true 
									Citizen.CreateThread(function ()
										FreezeEntityPosition(playerPed)
										FreezeEntityPosition(vehicle)
										local x,y,z = table.unpack(GetEntityCoords(playerPed))
										local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
										local boneIndex = GetPedBoneIndex(playerPed, 18905)
										AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
								   
										local dict = "amb@world_human_vehicle_mechanic@male@exit"
										local anim = "exit"
										RequestAnimDict(dict)
		
										while not HasAnimDictLoaded(dict) do
											Citizen.Wait(150)
										end
										TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)
		
										Wait(time)
										lockRepare = false
										FixVehicleWindow(vehicle, 0)
										FixVehicleWindow(vehicle, 1)
										FixVehicleWindow(vehicle, 2)
										FixVehicleWindow(vehicle, 3)
										FixVehicleWindow(vehicle, 4)
										FixVehicleWindow(vehicle, 5)
										FixVehicleWindow(vehicle, 6)
										FixVehicleWindow(vehicle, 7)
										FixVehicleWindow(vehicle, 8)
										TriggerServerEvent("job:repair:price", "window", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
										exports.bro_core:Notification("Véhicle réparé")
										ClearPedSecondaryTask(playerPed)
										DeleteObject(prop)
									end)
								else
									exports.bro_core:Notification("~r~Sortez du véhicle")
								end
							else
								exports.bro_core:Notification("~r~Pas de véhicule à portée")
							end
						else 
							exports.bro_core:Notification("~r~Répération en cours")
						end
					end
				},
			},
			{
					text = "Réparer Pneus",
					exec = {
					callback = function()
						local playerPed = GetPlayerPed(-1)
						coords = GetEntityCoords(GetPlayerPed(-1), true)
						local pos = GetEntityCoords(PlayerPedId())
						local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
				
						local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
						local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
						local prop_name = 'prop_cs_wrench'
						if lockRepare == false then
							if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
								if not IsPedInAnyVehicle(playerPed, false) then
									local time = 4000
									TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
									exports.bro_core:CloseMenu("repair")
									lockRepare = true 
									Citizen.CreateThread(function ()
										FreezeEntityPosition(playerPed)
										FreezeEntityPosition(vehicle)
										local x,y,z = table.unpack(GetEntityCoords(playerPed))
										local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
										local boneIndex = GetPedBoneIndex(playerPed, 18905)
										AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
								   
										local dict = "amb@world_human_vehicle_mechanic@male@exit"
										local anim = "exit"
										RequestAnimDict(dict)
		
										while not HasAnimDictLoaded(dict) do
											Citizen.Wait(150)
										end
										TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)
		
										Wait(time)
										lockRepare = false
										SetVehicleTyreFixed(vehicle, 0)
										SetVehicleTyreFixed(vehicle, 1)
										SetVehicleTyreFixed(vehicle, 2)
										SetVehicleTyreFixed(vehicle, 3)
										SetVehicleTyreFixed(vehicle, 4)
										SetVehicleTyreFixed(vehicle, 5)
										SetVehicleTyreFixed(vehicle, 6)
										TriggerServerEvent("job:repair:price", "tyres", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
										exports.bro_core:Notification("Véhicle réparé")
										ClearPedSecondaryTask(playerPed)
										DeleteObject(prop)
									end)
								else
									exports.bro_core:Notification("~r~Sortez du véhicle")
								end
							else
								exports.bro_core:Notification("~r~Pas de véhicule à portée")
							end
						else 
							exports.bro_core:Notification("~r~Répération en cours")
						end
					end
				},
			},
			{
				text = "Nettoyer Carroserie",
				exec = {
					callback = function()
						local playerPed = GetPlayerPed(-1)
						coords = GetEntityCoords(GetPlayerPed(-1), true)
						local pos = GetEntityCoords(PlayerPedId())
						local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
				
						local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
						local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
						local prop_name = 'prop_rag_01'
						if lockRepare == false then
							if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
								if not IsPedInAnyVehicle(playerPed, false) then
									local time = 4000
									TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
									exports.bro_core:CloseMenu("repair")
									lockRepare = true 
									Citizen.CreateThread(function ()
										FreezeEntityPosition(playerPed)
										FreezeEntityPosition(vehicle)
										local x,y,z = table.unpack(GetEntityCoords(playerPed))
										local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
										local boneIndex = GetPedBoneIndex(playerPed, 0xDEAD)
										AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
								   
										local dict = "timetable@maid@cleaning_window@base"
										local anim = "base"
										RequestAnimDict(dict)
		
										while not HasAnimDictLoaded(dict) do
											Citizen.Wait(150)
										end
										TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)
		
										Wait(time)
										lockRepare = false
										SetVehicleDirtLevel(vehicle, 0.0)
										exports.bro_core:Notification("Véhicle réparé")
										ClearPedSecondaryTask(playerPed)
										DeleteObject(prop)
									end)
								else
									exports.bro_core:Notification("~r~Sortez du véhicle")
								end
							else
								exports.bro_core:Notification("~r~Pas de véhicule à portée")
							end
						else 
							exports.bro_core:Notification("~r~Répération en cours")
						end
					end
				},
			},
			{
				text = "Réparer Carroserie",
				exec = {
					callback = function()
						local playerPed = GetPlayerPed(-1)
						coords = GetEntityCoords(GetPlayerPed(-1), true)
						local pos = GetEntityCoords(PlayerPedId())
						local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
				
						local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
						local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
						local prop_name = 'prop_cs_wrench'
						if lockRepare == false then
							if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
								if not IsPedInAnyVehicle(playerPed, false) then
									local time = 4000
									TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
									exports.bro_core:CloseMenu("repair")
									lockRepare = true 
									Citizen.CreateThread(function ()
										FreezeEntityPosition(playerPed)
										FreezeEntityPosition(vehicle)
										
										local dict = "amb@world_human_vehicle_mechanic@male@exit"
										local anim = "exit"
										RequestAnimDict(dict)
		
										while not HasAnimDictLoaded(dict) do
											Citizen.Wait(150)
										end
										TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)
		
										Wait(time)
										lockRepare = false
										SetVehicleBodyHealth(vehicle, 1000.0)
										SetVehiclePetrolTankHealth(vehicle, 1000.0)
										SetVehicleDeformationFixed(vehicle)
										TriggerServerEvent("job:repair:price", "carroserie", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
										exports.bro_core:Notification("Véhicle réparé")
										ClearPedSecondaryTask(playerPed)
										DeleteObject(prop)
									end)
								else
									exports.bro_core:Notification("~r~Sortez du véhicle")
								end
							else
								exports.bro_core:Notification("~r~Pas de véhicule à portée")
							end
						else 
							exports.bro_core:Notification("~r~Répération en cours")
						end
					end
				},
			},
			{
				text = "Réparer Moteur",
				exec = {
					callback = function()
						local playerPed = GetPlayerPed(-1)
						coords = GetEntityCoords(GetPlayerPed(-1), true)
						local pos = GetEntityCoords(PlayerPedId())
						local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
				
						local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
						local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
						local prop_name = 'prop_cs_wrench'

						if lockRepare == false then
							if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
								if not IsPedInAnyVehicle(playerPed, false) then
									local time = 4000
									TriggerEvent("bf:progressBar:create", time, "Réparation en cours")
									exports.bro_core:CloseMenu("repair")
									lockRepare = true 
									Citizen.CreateThread(function ()
										FreezeEntityPosition(playerPed)
										FreezeEntityPosition(vehicle)
										local x,y,z = table.unpack(GetEntityCoords(playerPed))
										local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
										local boneIndex = GetPedBoneIndex(playerPed, 18905)
										AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
								   
										local dict = "amb@world_human_vehicle_mechanic@male@exit"
										local anim = "exit"
										RequestAnimDict(dict)
		
										while not HasAnimDictLoaded(dict) do
											Citizen.Wait(150)
										end
										TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)
		
										Wait(time)
										lockRepare = false
										SetVehicleEngineHealth(vehicle, 1000.0)
										SetVehicleUndriveable(vehicle, false)
										ClearPedTasksImmediately(playerPed)
										TriggerServerEvent("job:repair:price", "motor", string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))
										exports.bro_core:Notification("Véhicle réparé")
										ClearPedSecondaryTask(playerPed)
										DeleteObject(prop)
									end)
								else
									exports.bro_core:Notification("~r~Sortez du véhicle")
								end
							else
								exports.bro_core:Notification("~r~Pas de véhicule à portée")
							end
						else 
							exports.bro_core:Notification("~r~Répération en cours")
						end
					end
				},
			},
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bro_core:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bro_core:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local closestPlayer, dist = GetClosestPlayer()

						if closestPlayer and dist <=1 then
							TriggerServerEvent("job:facture", GetPlayerServerId(closestPlayer), motif, price, 7)
						else
							exports.bro_core:Notification("Pas de joueur à proximité")
						end
						exports.bro_core:CloseMenu("bennys")
					end
				},
			},
			{
				text = "Gestion service",
				exec = {
					callback = function()
						TriggerServerEvent("job:isChef", "jobs:service:manage")
					end
				},
			},
		},
	})

	exports.bro_core:AddMenu("newspapers", {
		title = "Menu Livreurs de journaux",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Stopper les livraisons",
				exec = {
					callback = function()
						beginInProgress = false
						-- on nettoie la merde
						exports.bro_core:RemoveArea("begin-current")
						vehicleLivraison = 0
						ClearAllBlipRoutes()
					end
				},
			},
		},
	})


	exports.bro_core:AddMenu("service", {
		title = "Menu Service",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Recruter",
				exec = {
					callback = function()
						TriggerServerEvent("job:get", "job:recruit")
					end
				},
			},
			{
				text = "Promouvoir",
				exec = {
					callback = function()
						promoteClosestPlayer()
					end
				},
			},
			{
				text = "Rétrograder",
				exec = {
					callback = function()
						demoteClosestPlayer()
					end
				},
			},
			{
				text = "Virer",
				exec = {
					callback = function()
						fireClosestPlayer()
					end
				},
			},
		}
	})


	exports.bro_core:AddMenu("center", {
        title = "LSJC",
        menuTitle = "Prendre un emploi",
        position = 1,
        buttons = buttons
	})


	exports.bro_core:AddMenu("repair", {
        title = "Réparation",
		position = 1,
		buttons = {
			{
				text = "Réparer carrosserie (10$)",
				exec = {
					callback = function()
						vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

						SetVehicleFixed(vehicle)
						SetVehicleDeformationFixed(vehicle)
						SetVehicleUndriveable(vehicle, false)
						ClearPedTasksImmediately(playerPed)
						TriggerServerEvent("account:player:liquid:add", "", -10.0)
						exports.bro_core:Notification("Véhicle réparé")
						exports.bro_core:CloseMenu("repair")
					end
				},
			},
		}
	})

end


function removeMenuPaint(max, type, nb) 
	exports.bro_core:RemoveMenu("custom-paint"..nb.."-"..type)
end

function removeMenuMod(type) 
	exports.bro_core:RemoveMenu("custom-mod-"..type)
end

function customMenuRemove()
	exports.bro_core:RemoveMenu("custom")
	exports.bro_core:RemoveMenu("custom-paint1")
	exports.bro_core:RemoveMenu("custom-paint2")

	for i = 1,2 do
		removeMenuPaint(75, 0, i)	
		removeMenuPaint(75, 1, i)	
		removeMenuPaint(75, 2, i)		
		removeMenuPaint(20, 3, i)		
		removeMenuPaint(5, 4, i)		
		removeMenuPaint(0, 5, i)	
	end



	for i = 0,19 do
		removeMenuMod(i)
	end
	removeMenuMod(23)
	removeMenuMod(50)
end

function addMenuPaint(max, type, nb) 
	buttons = {}
	for i = 0,max do
		buttons[#buttons+1] = {
			text = i,
			hover = {
				callback = function()
					vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					SetVehicleModKit(
						vehicle, 
						0
					)
					if nb == 1 then
						SetVehicleModColor_1(
							vehicle, 
							type, 
							i, 
							0 -- always 0
						)
					elseif nb == 2 then
						SetVehicleModColor_2(
							vehicle, 
							type, 
							i
						)
					end
				end
			},
		}
	end
	exports.bro_core:AddMenu("custom-paint"..nb.."-"..type, {
		title = "Peinture type"..type,
		position = 1,
		buttons = buttons
	})	
end

function addMenuMod(type) 
	buttons = {}
	vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

	SetVehicleModKit(
		vehicle --[[ Vehicle ]], 
		0 --[[ integer ]]
	)
	local max = GetNumVehicleMods(vehicle, type)
	for i = 0,max do
		buttons[#buttons+1] = {
			text = i,
			hover = {
				callback = function()
					SetVehicleMod(
						vehicle, 
						type, 
						i, 
						false -- always 0
					)
				end
			},
		}
	end
	exports.bro_core:AddMenu("custom-mod-"..type, {
		title = "Mod "..type,
		position = 1,
		buttons = buttons
	})	
end

function customMenu()
	exports.bro_core:AddMenu("custom", {
        title = "Customisation",
		position = 1,
		buttons = {
			{
				text = "Peinture",
				openMenu = "custom-paint1"
			},
			{
				text = "Peinture 2",
				openMenu = "custom-paint2"
			},
			{
				text = "Spoilers",
				openMenu = "custom-mod-0"
			},
			{
				text = "Bumpers (devant)",
				openMenu = "custom-mod-1"
			},
			{
				text = "Bumpers (arriére)",
				openMenu = "custom-mod-2"
			},
			{
				text = "Side Skirt",
				openMenu = "custom-mod-3"
			},
			{
				text = "Exhaust",
				openMenu = "custom-mod-4"
			},
			{
				text = "Frame",
				openMenu = "custom-mod-5"
			},
			{
				text = "Grille",
				openMenu = "custom-mod-6"
			},
			{
				text = "Hood",
				openMenu = "custom-mod-7"
			},
			{
				text = "Fender",
				openMenu = "custom-mod-8"
			},
			{
				text = "Right Fender",
				openMenu = "custom-mod-9"
			},
			{
				text = "Toit",
				openMenu = "custom-mod-10"
			},
			{
				text = "Moteur",
				openMenu = "custom-mod-11"
			},
			{
				text = "Freins",
				openMenu = "custom-mod-12"
			},
			{
				text = "Transmission",
				openMenu = "custom-mod-13"
			},
			{
				text = "Klaxon",
				openMenu = "custom-mod-14"
			},
			{
				text = "Suspension",
				openMenu = "custom-mod-15"
			},
			{
				text = "Blindage",
				openMenu = "custom-mod-16"
			},
			{
				text = "Turbo",
				openMenu = "custom-mod-18"
			},
			{
				text = "Roues",
				openMenu = "custom-mod-19"
			},
			{
				text = "Roues avant (moto)",
				openMenu = "custom-mod-23"
			},
			{
				text = "",
				openMenu = "custom-mod-50"
			},
			{
				text = "valider",
				exec = {
					callback = function()
						local mods = {

						}
						for i = 0,49 do
							mods[i] = GetVehicleMod(
								vehicle --[[ Vehicle ]], 
								i --[[ integer ]]
							)
						end
						TriggerServerEvent("vehicle:mods:save" , vehicle, mods)
					end
				}
			}
		}
	})
	
	exports.bro_core:AddMenu("custom-paint1", {
        title = "Customisation",
		position = 1,
		buttons = {
			{
				text = "Normal",
				openMenu = "custom-paint1-0"
			},
			{
				text = "Metallic",
				openMenu = "custom-paint1-1"
			},
			{
				text = "Pearl",
				openMenu = "custom-paint1-2"
			},
			{
				text = "Mat",
				openMenu = "custom-paint1-3"
			},
			{
				text = "Metal",
				openMenu = "custom-paint1-4"
			},
			{
				text = "Chrome",
				openMenu = "custom-paint1-5"
			},
		}
	})

	exports.bro_core:AddMenu("custom-paint2", {
        title = "Customisation",
		position = 1,
		buttons = {
			{
				text = "Normal",
				openMenu = "custom-paint2-0"
			},
			{
				text = "Metallic",
				openMenu = "custom-paint2-1"
			},
			{
				text = "Pearl",
				openMenu = "custom-paint2-2"
			},
			{
				text = "Mat",
				openMenu = "custom-paint2-3"
			},
			{
				text = "Metal",
				openMenu = "custom-paint2-4"
			},
			{
				text = "Chrome",
				openMenu = "custom-paint2-5"
			},
		}
	})


	for i = 1,2 do
		addMenuPaint(75, 0, i)	
		addMenuPaint(75, 1, i)	
		addMenuPaint(75, 2, i)		
		addMenuPaint(20, 3, i)		
		addMenuPaint(5, 4, i)		
		addMenuPaint(0, 5, i)	
	end



	for i = 0,19 do
		addMenuMod(i)
	end
	addMenuMod(23)
	addMenuMod(50)
end
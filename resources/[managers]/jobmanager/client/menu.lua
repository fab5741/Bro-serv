function menus() 
	exports.bf:AddMenu("lspd", {
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
						local motif = exports.bf:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bf:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local t = exports.bf:GetPlayerServerIdInDirection(3)
						--test only
						if t then
							TriggerServerEvent("job:facture", t, motif, price, 2)
						else
							exports.bf:Notification("Pas de joueur à proximité")
						end
						exports.bf:CloseMenu("lspd")
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
	exports.bf:AddMenu("lspd-animations", {
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
	exports.bf:AddMenu("lspd-citizens", {
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

	exports.bf:AddMenu("lspd-citizens-fines", {
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

	exports.bf:AddMenu("lspd-veh", {
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


	exports.bf:AddMenu("lspd-props", {
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

	exports.bf:AddMenu("lsms", {
		title = "Menu LSMS",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "SOIN",
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
						local motif = exports.bf:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bf:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local t = exports.bf:GetPlayerServerIdInDirection(3)
						--test only
						if t then
							TriggerServerEvent("job:facture", t, motif, price, 2)
						else
							exports.bf:Notification("Pas de joueur à proximité")
						end
						exports.bf:CloseMenu("lspd")
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
					TriggerServerEvent("job:set", 18, "Livreur de journaux")
					Wait(100)
					TriggerServerEvent("job:get", "jobs:refresh")
					exports.bf:CloseMenu("center")
                end
            },
        }
    end

	exports.bf:AddMenu("farm", {
		title = "Menu Fermier",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bf:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bf:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local t = exports.bf:GetPlayerServerIdInDirection(3)
						--test only
						if t then
							TriggerServerEvent("job:facture", t, motif, price, 4)
						else
							exports.bf:Notification("Pas de joueur à proximité")
						end
						exports.bf:CloseMenu("ferm")
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

	exports.bf:AddMenu("wine", {
		title = "Menu Vigneron",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bf:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bf:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local t = exports.bf:GetPlayerServerIdInDirection(3)
						--test only
						if t then
							TriggerServerEvent("job:facture", t, motif, price, 5)
						else
							exports.bf:Notification("Pas de joueur à proximité")
						end
						exports.bf:CloseMenu("wine")
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

	exports.bf:AddMenu("taxi", {
		title = "Menu Taxi",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bf:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bf:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local t = exports.bf:GetPlayerServerIdInDirection(3)
						--test only
						if t then
							TriggerServerEvent("job:facture", t, motif, price, 6)
						else
							exports.bf:Notification("Pas de joueur à proximité")
						end
						exports.bf:CloseMenu("taxi")
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

	exports.bf:AddMenu("bennys", {
		title = "Menu Benny's",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "Réparer voiture",
				exec = {
					callback = function()
						vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
						SetVehicleFixed(vehicle)
						SetVehicleDeformationFixed(vehicle)
						SetVehicleUndriveable(vehicle, false)
						ClearPedTasksImmediately(playerPed)
						exports.bf:Notification("Véhicle réparé")
						exports.bf:CloseMenu("repair")
					end
				},
			},
			{
				text = "Facturer",
				exec = {
					callback = function()
						local motif = exports.bf:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bf:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local t = exports.bf:GetPlayerServerIdInDirection(3)
						--test only
						if t then
							TriggerServerEvent("job:facture", t, motif, price, 7)
						else
							exports.bf:Notification("Pas de joueur à proximité")
						end
						exports.bf:CloseMenu("bennys")
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

	exports.bf:AddMenu("newspapers", {
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
						exports.bf:RemoveArea("begin-current")
						vehicleLivraison = 0
						ClearAllBlipRoutes()
					end
				},
			},
		},
	})


	exports.bf:AddMenu("service", {
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


	exports.bf:AddMenu("center", {
        title = "LSJC",
        menuTitle = "Prendre un emploi",
        position = 1,
        buttons = buttons
	})


	exports.bf:AddMenu("repair", {
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
						exports.bf:Notification("Véhicle réparé")
						exports.bf:CloseMenu("repair")
					end
				},
			},
		}
	})

end


function removeMenuPaint(max, type, nb) 
	exports.bf:RemoveMenu("custom-paint"..nb.."-"..type)
end

function removeMenuMod(type) 
	exports.bf:RemoveMenu("custom-mod-"..type)
end

function customMenuRemove()
	exports.bf:RemoveMenu("custom")
	exports.bf:RemoveMenu("custom-paint1")
	exports.bf:RemoveMenu("custom-paint2")
	

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
	exports.bf:AddMenu("custom-paint"..nb.."-"..type, {
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
	exports.bf:AddMenu("custom-mod-"..type, {
		title = "Mod "..type,
		position = 1,
		buttons = buttons
	})	
end

function customMenu()
	exports.bf:AddMenu("custom", {
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
	
	exports.bf:AddMenu("custom-paint1", {
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

	exports.bf:AddMenu("custom-paint2", {
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
function menus() 
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
		},
		{
			text = "Vehicules",
			exec = {
				callback = function()
					TriggerServerEvent("vehicles:jobs:get:all", "jobs:assurance:vehicles", 3)
				end
			},
		},
	})
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
				text = "Vehicules",
				exec = {
					callback = function()
						TriggerServerEvent("vehicles:jobs:get:all", "jobs:assurance:vehicles", 2)
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
	exports.bf:AddMenu("jobs-vehicles", {
		title = "Menu  assurance",
		menuTitle = "Job",
		position = 1,
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
				text = "Porter",
				exec = {
					callback = function()
						DragPlayer()
					end
				},
			},
			{
				text = "Amendes",
				openMenu = "lspd-citizens-fines"
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

	exports.bf:AddMenu("lspd-service", {
		title = "Menu LSMS",
		menuTitle = "Job",
		position = 1,
		buttons = {
			{
				text = "SOIN",
				exec = {
					callback = function()
						closest = GetClosestPlayer()
						revivePlayer(closest)
					end
				},
			},
		},
		{
			text = "Vehicules",
			exec = {
				callback = function()
					TriggerServerEvent("vehicles:jobs:get:all", "jobs:assurance:vehicles", 3)
				end
			},
		},
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
		},
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
	exports.bf:AddMenu("custom", {
        title = "Customisation",
		position = 1,
		buttons = {
			{
				text = "Peinture",
				openMenu = "custom-paint"
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
		--	{
		--		text = "Moteur",
			--	openMenu = "custom-mod-11"
		--	},
		--	{
		--		text = "Freins",
		--		openMenu = "custom-mod-12"
		--	},
		--	{
		--		text = "Transmission",
		--		openMenu = "custom-mod-13"
		--	},
		--	{
		--		text = "Klaxon",
		--		openMenu = "custom-mod-14"
		--	},
		---	{
			--	text = "Suspension",
		--		openMenu = "custom-mod-15"
			--},
		--	{
			--	text = "Blindage",
		----		openMenu = "custom-mod-16"
			--},
		---	{
			--	text = "Turbo",
	--			openMenu = "custom-mod-18"
			--},
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
		}
	})
	
	exports.bf:AddMenu("custom-paint", {
        title = "Customisation",
		position = 1,
		buttons = {
			{
				text = "Normal",
				openMenu = "custom-paint-0"
			},
			{
				text = "Metallic",
				openMenu = "custom-paint-1"
			},
			{
				text = "Pearl",
				openMenu = "custom-paint-2"
			},
			{
				text = "Mat",
				openMenu = "custom-paint-3"
			},
			{
				text = "Metal",
				openMenu = "custom-paint-4"
			},
			{
				text = "Chrome",
				openMenu = "custom-paint-5"
			},
		}
	})

	function addMenuPaint(max, type) 
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
						SetVehicleModColor_1(
							vehicle, 
							type, 
							i, 
							0 -- always 0
						)
					end
				},
			}
		end
		exports.bf:AddMenu("custom-paint-"..type, {
			title = "Peinture type"..type,
			position = 1,
			buttons = buttons
		})	
	end

	addMenuPaint(75, 0)	
	addMenuPaint(75, 1)	
	addMenuPaint(75, 2)	
	addMenuPaint(20, 3)	
	addMenuPaint(5, 4)	
	addMenuPaint(0, 5)	

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

	for i = 0,19 do
		addMenuMod(i)
	end
	addMenuMod(23)
	addMenuMod(50)


	exports.bf:AddMenu("taxi", {
		title = "Menu Taxi",
		menuTitle = "Job",
		position = 1,
		buttons = {
		{
			text = "Vehicules",
			exec = {
				callback = function()
					TriggerServerEvent("vehicles:jobs:get:all", "jobs:assurance:vehicles", 3)
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

end
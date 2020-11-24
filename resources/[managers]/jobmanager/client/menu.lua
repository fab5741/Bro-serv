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

    -- job center
    buttons = {}
    for k, v in pairs(config.center.jobs) do
        buttons[#buttons+1] = {
            text = v.label,
            exec = {
                callback = function()
					TriggerServerEvent("job:set", 11, "Livreur de journaux")
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
end
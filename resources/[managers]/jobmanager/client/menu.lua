function menus() 
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
					exports.bro_core:RemoveMenu("center")
                end
            },
        }
    end
	
	exports.bro_core:AddMenu("sell", {
		title = "Revente ",
		position = 2,
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
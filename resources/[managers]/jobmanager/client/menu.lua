function RemoveMenuPaint(max, type, nb) 
	exports.bro_core:RemoveMenu("custom-paint"..nb.."-"..type)
end

function RemoveMenuMod(type) 
	exports.bro_core:RemoveMenu("custom-mod-"..type)
end

function CustomMenuRemove()
	exports.bro_core:RemoveMenu("custom")
	exports.bro_core:RemoveMenu("custom-paint1")
	exports.bro_core:RemoveMenu("custom-paint2")

	for i = 1,2 do
		RemoveMenuPaint(75, 0, i)	
		RemoveMenuPaint(75, 1, i)	
		RemoveMenuPaint(75, 2, i)		
		RemoveMenuPaint(20, 3, i)		
		RemoveMenuPaint(5, 4, i)		
		RemoveMenuPaint(0, 5, i)	
	end



	for i = 0,19 do
		RemoveMenuMod(i)
	end
	RemoveMenuMod(23)
	RemoveMenuMod(50)
end

function AddMenuPaint(max, type, nb)
	local buttons = {}
	for i = 0,max do
		buttons[#buttons+1] = {
			type = "button",
			label = i,
			actions = {
				onSelected = function()
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
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
	exports.bro_core:AddSubMenu("custom-paint"..nb.."-"..type, {
		parent = "paint"..nb,
		Title = "Peinture type"..type,
		Subtitle = "Customisations > Preintures > "..type,
		buttons = buttons
	})
end

function AddMenuMod(type) 
	local buttons = {}
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

	SetVehicleModKit(
		vehicle --[[ Vehicle ]], 
		0 --[[ integer ]]
	)
	local max = GetNumVehicleMods(vehicle, type)
	for i = 0,max do
		buttons[#buttons+1] = {
			type = "button",
			label = i,
			actions = {
				onSelected = function()
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
	exports.bro_core:AddSubMenu("custom-mod-"..type, {
		parent = "custom",
		Title = "Mod "..type,
		Subtitle = "Customisations > "..type,
		buttons = buttons
	})
end

function CustomMenu()

	exports.bro_core:AddMenu("custom", {
        Title = "Bennys",
        Subtitle = "Customisation",
		buttons = {
			{
				type = "separator",
				label = "Peintures"
			},
			{
				type= "button",
				label = "Peinture",
				subMenu = "paint1",
			},
			{
				type= "button",
				label = "Peinture 2",
				subMenu = "paint2",
			},
			{
				type = "separator",
				label = "Carroserie"
			},
			{
				type= "button",
				label = "Spoilers",
				subMenu = "custom-mod-0"
			},
			{
				type= "button",
				label = "Bumpers (devant)",
				subMenu = "custom-mod-1"
			},
			{
				type= "button",
				label = "Bumpers (arriére)",
				subMenu = "custom-mod-2"
			},
			{
				type= "button",
				label = "Side Skirt",
				subMenu = "custom-mod-3"
			},
			{
				type= "button",
				label = "Exhaust",
				subMenu = "custom-mod-4"
			},
			{
				type= "button",
				label = "Frame",
				subMenu = "custom-mod-5"
			},
			{
				type= "button",
				label = "Grille",
				subMenu = "custom-mod-6"
			},
			{
				type= "button",
				label = "Hood",
				subMenu = "custom-mod-7"
			},
			{
				type= "button",
				label = "Fender",
				subMenu = "custom-mod-8"
			},
			{
				type= "button",
				label = "Right Fender",
				subMenu = "custom-mod-9"
			},
			{
				type= "button",
				label = "Toit",
				subMenu = "custom-mod-10"
			},
			{
				type = "separator",
				label = "Améliorations"
			},
			{
				type= "button",
				label = "Moteur",
				subMenu = "custom-mod-11"
			},
			{
				type= "button",
				label = "Freins",
				subMenu = "custom-mod-12"
			},
			{
				type= "button",
				label = "Transmission",
				subMenu = "custom-mod-13"
			},
			{
				type= "button",
				label = "Klaxon",
				subMenu = "custom-mod-14"
			},
			{
				label = "Suspension",
				subMenu = "custom-mod-15"
			},
			{
				type= "button",
				label = "Blindage",
				subMenu = "custom-mod-16"
			},
			{
				type= "button",
				label = "Turbo",
				subMenu = "custom-mod-18"
			},
			{
				type = "separator",
				label = "Roues"
			},
			{
				type= "button",
				label = "Roues",
				subMenu = "custom-mod-19"
			},
			{
				type= "button",
				label = "Roues avant (moto)",
				subMenu = "custom-mod-23"
			},
			{
				type= "button",
				label = "valider",
				actions = {
					onSelected = function()
						SetVehicleModKit(
							vehicle --[[ Vehicle ]], 
							0 --[[ integer ]]
						)
						local mods = {

						}
						for i = 0,49 do
							mods[i] = GetVehicleMod(
								vehicle --[[ Vehicle ]], 
								i --[[ integer ]]
							)
						end
						exports.bro_core:PrintTable(mods)
						TriggerServerEvent("vehicle:mods:save" , vehicle, mods)
					end
				}
			}
		}
	})
	exports.bro_core:AddSubMenu("paint1", {
		parent = "custom",
		Title = "bennys",
		Subtitle = "Customisations > Peintures > Principale",
		buttons = {
			{
				type= "button",
				label = "Normal",
				subMenu = "custom-paint1-0"
			},
			{
				type= "button",
				label = "Metallic",
				subMenu = "custom-paint1-1"
			},
			{
				type= "button",
				label = "Pearl",
				subMenu = "custom-paint1-2"
			},
			{
				type= "button",
				label = "Mat",
				subMenu = "custom-paint1-3"
			},
			{
				type= "button",
				label = "Metal",
				subMenu = "custom-paint1-4"
			},
			{
				type= "button",
				label = "Chrome",
				subMenu = "custom-paint1-5"
			},
		}
	})
	exports.bro_core:AddSubMenu("paint2", {
		parent = "custom",
		Title = "bennys",
		Subtitle = "Customisations > Peintures > Secondaire",
		buttons = {
			{
				type= "button",
				label = "Normal",
				subMenu = "custom-paint2-0"
			},
			{
				type= "button",
				label = "Metallic",
				subMenu = "custom-paint2-1"
			},
			{
				type= "button",
				label = "Pearl",
				subMenu = "custom-paint2-2"
			},
			{
				type= "button",
				label = "Mat",
				subMenu = "custom-paint2-3"
			},
			{
				type= "button",
				label = "Metal",
				subMenu = "custom-paint2-4"
			},
			{
				type= "button",
				label = "Chrome",
				subMenu = "custom-paint2-5"
			},
		}
	})
	for i = 1,2 do
		AddMenuPaint(75, 0, i)	
		AddMenuPaint(75, 1, i)	
		AddMenuPaint(75, 2, i)		
		AddMenuPaint(20, 3, i)		
		AddMenuPaint(5, 4, i)		
		AddMenuPaint(0, 5, i)	
	end
	for i = 0,19 do
		AddMenuMod(i)
	end
	AddMenuMod(23)
	AddMenuMod(50)
end

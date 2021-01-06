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
			text = i,
			hover = {
				callback = function()
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
	exports.bro_core:AddMenu("custom-paint"..nb.."-"..type, {
		title = "Peinture type"..type,
		position = 1,
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
	exports.bro_core:AddMenu("custom-mod-"..type, {
		title = "Mod "..type,
		position = 1,
		buttons = buttons
	})
end

function CustomMenu()
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
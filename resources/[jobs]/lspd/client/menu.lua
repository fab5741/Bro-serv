local buttonsCategories = {}
local buttonsAnimation = {}
local buttonsCitizen = {}
local buttonsFine = {}
local buttonsVehicle = {}
local buttonsProps = {}

function load_menu()
	for k in ipairs (buttonsCategories) do
		buttonsCategories [k] = nil
	end
	
	for k in ipairs (buttonsAnimation) do
		buttonsAnimation [k] = nil
	end
	
	for k in ipairs (buttonsCitizen) do
		buttonsCitizen [k] = nil
	end
	
	for k in ipairs (buttonsFine) do
		buttonsFine [k] = nil
	end
	
	for k in ipairs (buttonsVehicle) do
		buttonsVehicle [k] = nil
	end
	
	for k in ipairs (buttonsProps) do
		buttonsProps [k] = nil
	end
	
	--Categories
	buttonsCategories[#buttonsCategories+1] = {name = "Animations", func = "OpenAnimMenu", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = GetLabelText("collision_c29ovv"), func = "OpenCitizenMenu", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = GetLabelText("PIM_TVEHI"), func = "OpenVehMenu", params = ""}
	buttonsCategories[#buttonsCategories+1] = {name = GetLabelText("collision_9o6rwvf"), func = "OpenPropsMenu", params = ""}
	
	--Animations
	buttonsAnimation[#buttonsAnimation+1] = {name = "Traffic", func = 'DoTraffic', params = ""}
	buttonsAnimation[#buttonsAnimation+1] = {name = "Notes", func = 'Note', params = ""}
	buttonsAnimation[#buttonsAnimation+1] = {name = "Standby", func = 'StandBy', params = ""}
	buttonsAnimation[#buttonsAnimation+1] = {name = "Standby2", func = 'StandBy2', params = ""}
	buttonsAnimation[#buttonsAnimation+1] = {name = "Annuler animation", func = 'CancelEmote', params = ""}
	
	--Citizens
	buttonsCitizen[#buttonsCitizen+1] = {name = "Enlever armes", func = 'RemoveWeapons', params = ""}
	buttonsCitizen[#buttonsCitizen+1] = {name = "Menotter", func = 'ToggleCuff', params = ""}
	buttonsCitizen[#buttonsCitizen+1] = {name = "Porter", func = 'DragPlayer', params = ""}
	buttonsCitizen[#buttonsCitizen+1] = {name =  "amendes", func = 'OpenMenuFine', params = ""}
	
	--Fines
	buttonsFine[#buttonsFine+1] = {name = "Infraction légére (250 $)", func = 'Fines', params = 250}
	buttonsFine[#buttonsFine+1] = {name = "infraction moyenne (500 $)", func = 'Fines', params = 500}
	buttonsFine[#buttonsFine+1] = {name = "infraction lourde (1000 $)", func = 'Fines', params = 1000}

	-- vehicles
	buttonsVehicle[#buttonsVehicle+1] = {name = GetLabelText("FMMC_REMVEH"), func = 'DropVehicle', params = ""}		
	buttonsVehicle[#buttonsVehicle+1] = {name = "Spike Stripes", func = 'SpawnSpikesStripe', params = ""}
	
	--Props
	for k,v in pairs(SpawnObjects) do
		buttonsProps[#buttonsProps+1] = {name = v.name, func = "SpawnProps", params = tostring(v.hash)}
	end

	buttonsProps[#buttonsProps+1] = {name=GetLabelText("FMMC_PR_23"), func = "SpawnProps", params="prop_mp_barrier_01b"}
	buttonsProps[#buttonsProps+1] = {name=GetLabelText("FMMC_PR_BARQADB"), func = "SpawnProps", params="prop_barrier_work05"}
	buttonsProps[#buttonsProps+1] = {name=GetLabelText("FMMC_DPR_LTRFCN"), func = "SpawnProps", params="prop_air_conelight"}
	buttonsProps[#buttonsProps+1] = {name=GetLabelText("FMMC_PR_PBARR"),   func = "SpawnProps", params="prop_barrier_work06a"}
	buttonsProps[#buttonsProps+1] = {name=GetLabelText("FMMC_PR_CABTBTH"), func = "SpawnProps", params="prop_tollbooth_1"}
	buttonsProps[#buttonsProps+1] = {name=GetLabelText("FMMC_DPR_TRFCNE"), func = "SpawnProps", params="prop_mp_cone_01"}
	buttonsProps[#buttonsProps+1] = {name=GetLabelText("FMMC_DPR_TRFPLE"), func = "SpawnProps", params="prop_mp_cone_04"}

	buttonsProps[#buttonsProps+1] = {name = GetLabelText("collision_7x5xu9w"), func = "RemoveLastProps", params = ""}
	buttonsProps[#buttonsProps+1] = {name = GetLabelText("FMMC_REMOBJ"), func = "RemoveAllProps", params = ""}
end


function TogglePoliceMenu()
	if((anyMenuOpen.menuName ~= "policemenu" and anyMenuOpen.menuName ~= "policemenu-anim" and anyMenuOpen.menuName ~= "policemenu-citizens" and anyMenuOpen.menuName ~= "policemenu-veh" and anyMenuOpen.menuName ~= "policemenu-fines" and anyMenuOpen.menuName ~= "policemenu-props") and not anyMenuOpen.isActive) then
		SendNUIMessage({
			title = "LSPD",
			subtitle = GetLabelText("PM_MP_OPTIONS"),
			buttons = buttonsCategories,
			action = "setAndOpen"
		})
		
		anyMenuOpen.menuName = "policemenu"
		anyMenuOpen.isActive = true
	else
		if((anyMenuOpen.menuName ~= "policemenu" and anyMenuOpen.menuName ~= "policemenu-anim" and anyMenuOpen.menuName ~= "policemenu-citizens" and anyMenuOpen.menuName ~= "policemenu-veh" and anyMenuOpen.menuName ~= "policemenu-fines" and anyMenuOpen.menuName ~= "policemenu-props") and anyMenuOpen.isActive) then
			CloseMenu()
			TogglePoliceMenu()
		else
			CloseMenu()
		end
	end
end

function BackMenuPolice()
	if(anyMenuOpen.menuName == "policemenu-anim" or anyMenuOpen.menuName == "policemenu-citizens" or anyMenuOpen.menuName == "policemenu-veh" or anyMenuOpen.menuName == "policemenu-props") then
		CloseMenu()
		TogglePoliceMenu()
	else
		CloseMenu()
		OpenCitizenMenu()
	end
end

function OpenAnimMenu()
	CloseMenu()
	SendNUIMessage({
		title = "Animations",
		subtitle = GetLabelText("CRW_ANIMATION"),
		buttons = buttonsAnimation,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-anim"
	anyMenuOpen.isActive = true
end

function OpenCitizenMenu()
	CloseMenu()
	SendNUIMessage({
		title = "Citoyen",
		subtitle = GetLabelText("collision_c29ovv"),
		buttons = buttonsCitizen,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-citizens"
	anyMenuOpen.isActive = true
end

function OpenVehMenu()
	CloseMenu()
	SendNUIMessage({
		title = "Vehicules",
		subtitle = GetLabelText("PIM_TVEHI"),
		buttons = buttonsVehicle,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-veh"
	anyMenuOpen.isActive = true
end

function OpenMenuFine()
	CloseMenu()
	SendNUIMessage({
		title = "Amendes",
		subtitle = GetLabelText("PM_MP_OPTIONS"),
		buttons = buttonsFine,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-fines"
	anyMenuOpen.isActive = true
end

function OpenPropsMenu()
	CloseMenu()
	SendNUIMessage({
		title = "Props",
		subtitle = GetLabelText("collision_9o6rwvf"),
		buttons = buttonsProps,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "policemenu-props"
	anyMenuOpen.isActive = true
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		for _, props in pairs(propslist) do
			local ox, oy, oz = table.unpack(GetEntityCoords(NetToObj(props), true))
			local cVeh = GetClosestVehicle(ox, oy, oz, 20.0, 0, 70)
			if(IsEntityAVehicle(cVeh)) then
				if IsEntityAtEntity(cVeh, NetToObj(props), 3.0, 5.0, 2.0, 0, 1, 0) then
					local cDriver = GetPedInVehicleSeat(cVeh, -1)
					TaskVehicleTempAction(cDriver, cVeh, 6, 1000)
					
					SetVehicleHandbrake(cVeh, true)
					SetVehicleIndicatorLights(cVeh, 0, true)
					SetVehicleIndicatorLights(cVeh, 1, true)
				end
			end

		end
	end
end)
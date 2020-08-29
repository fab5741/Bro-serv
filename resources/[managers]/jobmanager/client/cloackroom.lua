local buttons = {}

function load_cloackroom(job)
	for k in ipairs (buttons) do
		buttons [k] = nil
	end

    for k, data in pairs(config.skins) do
		if(v.job == job) then
			buttons[#buttons+1] = {name = tostring(v.name), func = "clockIn", params = tostring(v.model)}
		end			
    end

	buttons[#buttons+1] = {name = "Quitter le service", func = "clockOut", params = ""}
end

function clockIn(model)
    if model then	    	
		if IsModelValid(model) and IsModelInCdimage(model) then
    		ServiceOn()
    		SetCopModel(model)

    		drawNotification("now_in_service_notification")
    		drawNotification("help_open_menu_notification")
    	else
    		drawNotification("This model is ~r~invalid~w~.")
    	end
    end
end

function clockOut()
	ServiceOff()
	removeUniforme()
	drawNotification("break_service_notification")
end

function SetCopModel(model)
	SetMaxWantedLevel(0)
	SetWantedLevelMultiplier(0.0)
	SetRelationshipBetweenGroups(0, GetHashKey("police"), GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("police"))	

	modelHash = GetHashKey(model)

	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Citizen.Wait(0)
	end

	if model == "s_m_y_cop_01" then
		if (config.enableOutfits == true) then
			if(GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01")) then
			    SetPedPropIndex(PlayerPedId(), 1, 5, 0, 2)             --Sunglasses
			    SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)             --Bluetoothn earphone
			    SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 2)  --Shirt
			    SetPedComponentVariation(PlayerPedId(), 8, 58, 0, 2)   --Nightstick decoration
			    SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 2)   --Pants
			    SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)   --Shooes
			    SetPedComponentVariation(PlayerPedId(), 10, 8, config.rank.outfit_badge[rank], 2) --rank
			else
			    SetPedPropIndex(PlayerPedId(), 1, 11, 3, 2)           --Sunglasses
			    SetPedPropIndex(PlayerPedId(), 2, 0, 0, 2)            --Bluetoothn earphone
			    SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)  --Non buggy tshirt
			    SetPedComponentVariation(PlayerPedId(), 11, 48, 0, 2) --Shirt
			    SetPedComponentVariation(PlayerPedId(), 8, 35, 0, 2)  --Nightstick decoration
			    SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 2)  --Pants
			    SetPedComponentVariation(PlayerPedId(), 6, 29, 0, 2)  --Shooes
			    SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2) --rank
			end
		else
			SetPlayerModel(PlayerId(), modelHash)
		end
	elseif model == "s_m_y_hwaycop_01" then
			SetPlayerModel(PlayerId(), modelHash)
			SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
	elseif model == "s_m_y_sheriff_01" then
		    SetPlayerModel(PlayerId(), modelHash)
		    SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
	elseif model == "s_m_y_ranger_01" then
		SetPlayerModel(PlayerId(), modelHash)
		SetPedComponentVariation(PlayerPedId(), 10, 7, config.rank.outfit_badge[rank], 2)
	elseif model == "a_m_y_genstreet_01" then
	
	else
		 SetPlayerModel(PlayerId(), modelHash)
	end

	giveBasicKit()
	SetModelAsNoLongerNeeded(modelHash)
end

function removeUniforme()
	if(config.enableOutfits == true) then
		RemoveAllPedWeapons(PlayerPedId())
		TriggerServerEvent("skin_customization:SpawnPlayer")
	else
		local model = GetHashKey("a_m_y_mexthug_01")
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		 
		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)

		SetMaxWantedLevel(5)
		SetWantedLevelMultiplier(1.0)
		
		SetRelationshipBetweenGroups(3, GetHashKey("police"), GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(3, GetHashKey("PLAYER"), GetHashKey("police"))	
	end
end

function OpenCloackroom()
	if anyMenuOpen.menuName ~= "cloackroom" and not anyMenuOpen.isActive then
		SendNUIMessage({
			title = GetLabelText("collision_8vlv02g"),
			subtitle = GetLabelText("INPUT_CHARACTER_WHEEL"),
			buttons = buttons,
			action = "setAndOpen"
		})
		
		anyMenuOpen.menuName = "cloackroom"
		anyMenuOpen.isActive = true
		if config.enableVersionNotifier then
			TriggerServerEvent('job:UpdateNotifier')
		end
	end
end

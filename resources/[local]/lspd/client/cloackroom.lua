local buttons = {}

function load_cloackroom()
	for k in ipairs (buttons) do
		buttons [k] = nil
	end

	for k, data in pairs(skins) do
		if config.useCopWhitelist then
			if dept == k then
				for k, v in pairs(data) do
					buttons[#buttons+1] = {name = tostring(v.name), func = "clockIn", params = tostring(v.model)}
				end
			end
		else
			for k, v in pairs(data) do
				buttons[#buttons+1] = {name = tostring(v.name), func = "clockIn", params = tostring(v.model)}
			end			
		end
	end

	buttons[#buttons+1] = {name = "Quitter le service", func = "clockOut", params = ""}
end

function clockIn(model)
    if model then	    	
		if IsModelValid(model) and IsModelInCdimage(model) then
    		ServiceOn()
    		SetCopModel(model)

    		drawNotification("En service")
    	else
    		drawNotification("Le model est invalide")
    	end
    end
end

function clockOut()
	ServiceOff()
	removeUniforme()
	drawNotification("Quitter le service")
end

function SetCopModel(model)
	SetRelationshipBetweenGroups(0, GetHashKey("police"), GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("police"))	

	local skin ={
		sex          = 0,
		face         = 0,
		skin         = 0,
		beard_1      = 0,
		beard_2      = 0,
		beard_3      = 0,
		beard_4      = 0,
		hair_1       = 0,
		hair_2       = 0,
		hair_color_1 = 0,
		hair_color_2 = 0,
		tshirt_1     = 0,
		tshirt_2     = 0,
		torso_1      = 0,
		torso_2      = 0,
		decals_1     = 0,
		decals_2     = 0,
		arms         = 0,
		pants_1      = 0,
		pants_2      = 0,
		shoes_1      = 0,
		shoes_2      = 0,
		mask_1       = 0,
		mask_2       = 0,
		bproof_1     = 0,
		bproof_2     = 0,
		chain_1      = 0,
		chain_2      = 0,
		helmet_1     = 0,
		helmet_2     = 0,
		glasses_1    = 0,
		glasses_2    = 0,
	}

	local clothes = {
		recruit = {
			male = {
				tshirt_1 = 59,  tshirt_2 = 1,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = 46,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 36,  tshirt_2 = 1,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = 45,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		},
	
		officer = {
			male = {
				tshirt_1 = 58,  tshirt_2 = 0,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 35,  tshirt_2 = 0,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 0,   decals_2 = 0,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		},
	
		sergeant = {
			male = {
				tshirt_1 = 58,  tshirt_2 = 0,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 8,   decals_2 = 1,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 35,  tshirt_2 = 0,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 7,   decals_2 = 1,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		},
	
		lieutenant = {
			male = {
				tshirt_1 = 58,  tshirt_2 = 0,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 8,   decals_2 = 2,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 35,  tshirt_2 = 0,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 7,   decals_2 = 2,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		},
	
		boss = {
			male = {
				tshirt_1 = 58,  tshirt_2 = 0,
				torso_1 = 55,   torso_2 = 0,
				decals_1 = 8,   decals_2 = 3,
				arms = 41,
				pants_1 = 25,   pants_2 = 0,
				shoes_1 = 25,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			},
			female = {
				tshirt_1 = 35,  tshirt_2 = 0,
				torso_1 = 48,   torso_2 = 0,
				decals_1 = 7,   decals_2 = 3,
				arms = 44,
				pants_1 = 34,   pants_2 = 0,
				shoes_1 = 27,   shoes_2 = 0,
				helmet_1 = -1,  helmet_2 = 0,
				chain_1 = 0,    chain_2 = 0,
				ears_1 = 2,     ears_2 = 0
			}
		},
	
		bullet_wear = {
			male = {
				bproof_1 = 11,  bproof_2 = 1
			},
			female = {
				bproof_1 = 13,  bproof_2 = 1
			}
		},
	
		gilet_wear = {
			male = {
				tshirt_1 = 59,  tshirt_2 = 1
			},
			female = {
				tshirt_1 = 36,  tshirt_2 = 1
			}
		}
	}
	TriggerEvent('skinchanger:loadClothes', skin, clothes.recruit.male)
	giveBasicKit()
end

function removeUniforme()
	RemoveAllPedWeapons(PlayerPedId())

	-- release the player model
	SetModelAsNoLongerNeeded(model)  
	skin ={
		sex          = 0,
		face         = 0,
		skin         = 0,
		beard_1      = 0,
		beard_2      = 0,
		beard_3      = 0,
		beard_4      = 0,
		hair_1       = 0,
		hair_2       = 0,
		hair_color_1 = 0,
		hair_color_2 = 0,
		tshirt_1     = 0,
		tshirt_2     = 0,
		torso_1      = 0,
		torso_2      = 0,
		decals_1     = 0,
		decals_2     = 0,
		arms         = 0,
		pants_1      = 0,
		pants_2      = 0,
		shoes_1      = 0,
		shoes_2      = 0,
		mask_1       = 0,
		mask_2       = 0,
		bproof_1     = 0,
		bproof_2     = 0,
		chain_1      = 0,
		chain_2      = 0,
		helmet_1     = 0,
		helmet_2     = 0,
		glasses_1    = 0,
		glasses_2    = 0,
	}

	local clothes = {
	}
	TriggerEvent('skinchanger:loadClothes', skin, clothes)
		
	SetRelationshipBetweenGroups(3, GetHashKey("police"), GetHashKey("PLAYER"))
	SetRelationshipBetweenGroups(3, GetHashKey("PLAYER"), GetHashKey("police"))	
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
			TriggerServerEvent('lspd:UpdateNotifier')
		end
	end
end

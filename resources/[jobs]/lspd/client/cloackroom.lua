local buttons = {}

function load_cloackroom()
	for k in ipairs (buttons) do
		buttons [k] = nil
	end

	for k, data in pairs(skins) do
		if config.useCopWhitelist then
			if dept == k then
				for k, v in pairs(data) do
					buttons[#buttons+1] = {name = tostring(v.name), func = "clockIn"}
				end
			end
		else
			for k, v in pairs(data) do
				buttons[#buttons+1] = {name = tostring(v.name), func = "clockIn"}
			end			
		end
	end

	buttons[#buttons+1] = {name = "Quitter le service", func = "clockOut", params = ""}
end

function clockIn()
	ServiceOn()
	TriggerServerEvent("player:get", "lspd:add:uniform")
	drawNotification("En service")
end

function clockOut()
	ServiceOff()
	TriggerServerEvent("player:get", "lspd:remove:uniform")
	drawNotification("Quitter le service")
end
RegisterNetEvent("lspd:remove:uniform")

-- source is global here, don't add to function
AddEventHandler('lspd:remove:uniform', function(skin)
	RemoveAllPedWeapons(PlayerPedId())

	TriggerEvent('skinchanger:loadClothes', json.decode(skin.skin), clothes)
	TriggerServerEvent("lspd:breakService")
end)

RegisterNetEvent("lspd:add:uniform")

-- source is global here, don't add to function
AddEventHandler('lspd:add:uniform', function(skin)
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
	TriggerEvent('skinchanger:loadClothes', json.decode(skin.skin), clothes.recruit.male)
	giveBasicKit()
end)

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

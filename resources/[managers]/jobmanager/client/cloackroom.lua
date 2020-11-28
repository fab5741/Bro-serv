local buttons = {}

function clockIn(job)
	TriggerServerEvent("player:get", "job:add:uniform")
	TriggerServerEvent("job:clock", true, job)
	exports.bf:CloseMenu("lockers")
end

function clockOut(job)
	TriggerServerEvent("player:get", "job:remove:uniform")
	TriggerServerEvent("job:clock", false, job)
	exports.bf:CloseMenu("lockers")
end


RegisterNetEvent("job:add:uniform")

-- source is global here, don't add to function
AddEventHandler('job:add:uniform', function(skin)
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

RegisterNetEvent("job:remove:uniform")

-- source is global here, don't add to function
AddEventHandler('job:remove:uniform', function(skin)
	RemoveAllPedWeapons(PlayerPedId())

	TriggerEvent('skinchanger:loadClothes', json.decode(skin.skin), clothes)
	TriggerServerEvent("job:breakService")
end)
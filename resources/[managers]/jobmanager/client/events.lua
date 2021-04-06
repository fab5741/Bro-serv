RegisterNetEvent("job:set")
RegisterNetEvent("job:getCar")
RegisterNetEvent('job:process:open')
RegisterNetEvent('job:sell:open')
RegisterNetEvent('job:collect:open')
RegisterNetEvent('job:parking:open')
RegisterNetEvent('job:safe:open')
RegisterNetEvent('job:safe:open2')
RegisterNetEvent('job:safe:open3')
RegisterNetEvent('job:safe:open4')
RegisterNetEvent('job:item:open')
RegisterNetEvent('job:item:open:store')
RegisterNetEvent('job:item:open2')
RegisterNetEvent('job:open:menu')
RegisterNetEvent('job:parking')
RegisterNetEvent('job:parking:get')
RegisterNetEvent('job:lsms:revive')
RegisterNetEvent('jobs:assurance:vehicles')
RegisterNetEvent('jobs:service:manage')
RegisterNetEvent("jobs:refresh")
RegisterNetEvent("jobs:recruit")
RegisterNetEvent('weapon:store')
RegisterNetEvent('weapon:store:store')
RegisterNetEvent('job:removeWeapons')
RegisterNetEvent('job:handcuff')
RegisterNetEvent('job:payFines')
RegisterNetEvent('job:facture')
RegisterNetEvent("job:facture:accept")

-- source is global here, don't add to function
AddEventHandler('job:set', function (grade)
    TriggerServerEvent("job:set", grade)
end)

AddEventHandler('job:getCar', function(car, carId)
	exports.bro_core:spawnCar(car, true, nil, true)
    TriggerServerEvent("vehicle:set:id", carId, vehicle)
end)


AddEventHandler("job:process:open", function(job)
	job = job[1]
	local buttons = {}
	for k, v in pairs(Config.jobs[job.name].process[zone].items) do

		buttons[#buttons+1] = {
			type = "button",
			label = "Traitement "..v.label,
			actions = {
				onSelected = function()
					if not IsPedInAnyVehicle(playerPed, false) then
						exports.bro_core:actionPlayer(4000, "Transformation", "amb@world_human_gardener_plant@male@enter", "enter", function()
							TriggerServerEvent('items:process', v.type,  v.amount, v.to,  v.amountTo, 'Vous avez transformé : '..v.label.. " X "..v.amount)
						end)
					else
						exports.bro_core:Notification("~r~Vous ne pouvez pas transformer en véhicule")
					end
				end
			},
		}
	end
	exports.bro_core:AddMenu("process", {
		Title = job.label,
		Subtitle = "Transformation",
		buttons = buttons
	})
end)


AddEventHandler("job:sell:open", function(job)
	job = job[1]
	local buttons = {}
	for k, v in pairs(Config.jobs[job.name].sell.items) do
		buttons[#buttons+1] = {
			type = "button",
			label = "Vente de " ..v.label,
			actions = {
				onSelected = function()
					if not IsPedInAnyVehicle(playerPed, false) then
						exports.bro_core:actionPlayer(4000, "Transformation", "amb@world_human_gardener_plant@male@enter", "enter", function()
							NbSold = NbSold +1
							if NbSold >= Config.jobs[job.name].sell.maxSold then
								NbSold = 0
								RemoveSell(job.name)
								BeginSell(job.name)
								exports.bro_core:Notification("J'en ai trop, va vendre ailleurs.")
							end
							TriggerServerEvent("job:sell", v.type, job.job, v.price, 'Vous avez vendu : '..v.label.. " X "..v.amount.." pour ~g~".. v.price*v.amount.." $")
						end)
					else
						exports.bro_core:Notification("~r~Vous ne pouvez pas transformer en véhicule")
					end
				end
			},
		}
	end
	exports.bro_core:AddMenu("sell", {
		Title = job.label,
		Subtitle = "Revente",
		buttons = buttons
	})
end)


AddEventHandler("job:collect:open", function(job)
	job = job[1]
	local buttons = {}
	for k, v in pairs(Config.jobs[job.name].collect[zone].items) do
		buttons[#buttons+1] = {
			type = "button",
			label = "Collecter "..v.label,
			actions = {
				onSelected = function()
					if not IsPedInAnyVehicle(playerPed, false) then
						exports.bro_core:actionPlayer(4000, "Transformation", "amb@world_human_gardener_plant@male@enter", "enter", function()
							TriggerServerEvent('items:add', v.type,  v.amount, 'Vous avez collecté : '..v.label.. " X "..v.amount)
						end)
					else
						exports.bro_core:Notification("~r~Vous ne pouvez pas transformer en véhicule")
					end
				end
			}
		}
	end
	exports.bro_core:AddMenu("collect", {
		Title = job.label,
		Subtitle = "Collecte",
		buttons = buttons
	})
end)


AddEventHandler("job:parking:open", function(job)
	job = job[1]
	TriggerServerEvent("vehicle:parking:get:all", "job:parking", job.name)
end)


AddEventHandler("job:safe:open", function(job)
	job = job[1]
	TriggerServerEvent("job:safe:get", "job:safe:open2", job.job)
end)

AddEventHandler("job:safe:open2", function(amount)
	-- todo: test if chef de service
	AccountAmount = amount
	TriggerServerEvent("job:isChef", "job:safe:open3")
end)

AddEventHandler("job:safe:open3", function(isChef)
	SafeButtons = {}
	if isChef then
		SafeButtons[#SafeButtons+1] = {
			type = "separator",
			label = "Compte " .. exports.bro_core:Money(AccountAmount),
		}
		SafeButtons[#SafeButtons+1] = {
			type  = "button",
			label = "Retirer",
			actions = {
				onSelected = function()
					local nb = tonumber(exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true}))
					TriggerServerEvent('job:safe:withdraw', nb)
				end
			}
		}
		SafeButtons[#SafeButtons+1] = {
			type  = "button",
			label = "Déposer",
			actions = {
				onSelected = function()
					local nb = tonumber(exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true}))
					TriggerServerEvent('job:safe:deposit', nb)
				end
			}
		}
	end
	print("safe")
	TriggerServerEvent("job:items:get", "job:safe:open4")
end)

AddEventHandler("job:safe:open4", function(items)
	SafeButtons[#SafeButtons+1] = {
			type = "separator",
			label = "Stock",
		}
	for k,v in ipairs(items) do
		SafeButtons[#SafeButtons+1] = {
			type="button",
			label = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			actions = {
				onSelected = function()
					local nb = tonumber(exports.bro_core:OpenTextInput({defaultText = "", customTitle = true, title= "Nombre?"}))
					TriggerServerEvent("job:items:withdraw", v.item, nb)
				end
			},
		}
	end
	SafeButtons[#SafeButtons+1] = {
			type = "button",
			label = "Déposer",
			subMenu = "safeitems"
	}
	TriggerServerEvent("items:get", "job:safe:open5")
end)

RegisterNetEvent("job:safe:open5")

AddEventHandler("job:safe:open5", function(items)
	local buttons = {}
	local weight = 0
	local maxWeight = 100

	for k, v in ipairs (items) do
		buttons[k] =     {
			type = "button",
			label = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			actions = {
				onSelected = function() 
					local nb = tonumber(exports.bro_core:OpenTextInput({defaultText = "", customTitle = true, title= "Nombre?"}))
					TriggerServerEvent("job:items:store", v.item, nb)
				end
			},
		}
		weight = weight + (v.amount*v.weight)
	end
	Subtitle = ""
	if weight > (3/4*maxWeight) then
		Subtitle = "Poids max ~r~("..weight.."/"..maxWeight..")kg"
	else
		Subtitle = "Poids max ~g~("..weight.."/"..maxWeight..")kg"
	end

	
	exports.bro_core:AddMenu("safe", {
		Title = "Coffre",
		Subtitle = "Entreprise",
		buttons = SafeButtons
	})

	exports.bro_core:AddSubMenu("safeitems", {
		parent = "safe",
		Title = "Coffre",
		Subtitle = Subtitle, 
		buttons = buttons
	})
end)



AddEventHandler("job:item:open", function(job)
	job = job[1].job
	TriggerServerEvent("job:items:get", "job:item:open2", job)
end)


AddEventHandler("job:item:open:store", function(items)
	local buttons = {}
	for k, v in pairs(items) do
		buttons[#buttons+1] = {
			text = v.label .. " X " ..v.amount,
			actions = {
				onSelected = function()
					TriggerServerEvent("job:items:store", v.item, 1)
				end
			},
		}
	end
	exports.bro_core:SetMenuButtons("safes-items-store", buttons)
	exports.bro_core:NextMenu("safes-items-store")
end)


AddEventHandler("job:item:open2", function(items)
	local buttons = {}
	buttons[#buttons+1] = {
		text = "Stocker item",
		actions = {
			onSelected = function()
				TriggerServerEvent("items:get", "job:item:open:store")
			end
		},
	}
	for k, v in pairs(items) do
		buttons[#buttons+1] = {
			text = v.label .. " X " ..v.amount,
			actions = {
				onSelected = function()
					buttons = {}
					buttons[1] =     {
						text = "Retirer",
						actions = {
							onSelected = function()
								TriggerServerEvent("job:items:withdraw", v.item, 1)
							end
						},
					}
					exports.bro_core:SetMenuButtons("safes-items-item", buttons)
					exports.bro_core:NextMenu("safes-items-item")
				end
			},
		}
	end
	exports.bro_core:SetMenuButtons("safes-items", buttons)
	exports.bro_core:NextMenu("safes-items")
end)

AddEventHandler("job:open:menu", function(job)
	job = job[1]
	if job.name == "lspd" or job.name == "lsms" or job.name == "farm" or job.name == "wine"  or job.name == "taxi"  or job.name=="bennys" or job.name=="newspapers" then
		local buttons = {

		}
		if job.name == "lspd" then
			buttons = {
				{
					type = "button",
					label = "Actions",
					subMenu = "actions"
				},
				{
					type = "button",
					label = "Amendes",
					subMenu = "fines"
				},
				{
					type = "button",
					label = "Animations",
					subMenu = "animations"
				},
				{
					type = "button",
					label = "Objets",
					subMenu = "props"
				},
			}
		else
			buttons = {
				{
					type = "button",
					label = "Actions",
					subMenu = "actions"
				},
				{
					type = "button",
					label = "Animations",
					subMenu = "animations"
				},
			}
		end
		-- TODO: only display when is chief
		if true then
			buttons[#buttons+1] = {
				type = "button",
				label = "Gestion service",
				subMenu = "service"
			}
		end
		exports.bro_core:AddMenu("job", {
			Title = "Menu "..job.label,
			Subtitle = "Job",
			buttons = buttons
		})

		exports.bro_core:AddSubMenu("service", {
			parent= "job",
			Title = "Gestion service",
			Subtitle = job.label,
			buttons = {
				{
					type = "separator",
					label = "Recrutements",
				},
				{
					type = "button",
					label = "Recruter",
					actions = {
						onSelected = function()
							-- TODO - test if chef de service
							RecruitClosestPlayer(job)
						end
					},
				},
				{
					type = "button",
					label = "Virer",
					actions = {
						onSelected = function()
														-- TODO - test if chef de service
							FireClosestPlayer()
						end
					},
				},
				{
					type = "separator",
					label = "Grades",
				},
				{
					type = "button",
					label = "Promouvoir",
					actions = {
						onSelected = function()
														-- TODO - test if chef de service
							PromoteClosestPlayer()
						end
					},
				},
				{
					type = "button",
					label = "Rétrograder",
					actions = {
						onSelected = function()
														-- TODO - test if chef de service
							DemmoteClosestPlayer()
						end
					},
				},

			}
		})
		
		if job.name == "lspd" then
			exports.bro_core:AddSubMenu("fines", {
				parent= "job",
				Title = "fines",
				Subtitle = job.label,
				buttons = {
					{
						type = "button",
						label = "Infraction minorée (250 $)",
						actions = {
							onSelected = function()
								Fines(250)
							end
						},
					},
					{
						type = "button",
						label = "Infraction (500 $)",
						actions = {
							onSelected = function()
								Fines(500)
							end
						},
					},
					{
						type = "button",
						label = "Infraction majorée (1000 $)",
						actions = {
							onSelected = function()
								Fines(1000)
							end
						},
					},
				}
			})
		end

		-- Actions
		buttons = {

		}
		if job.name == "lspd" then
			buttons = {
				{
					type = "separator",
					label = "Citoyen",
				},
				{
					type = "button",
					label = "Retirer armes",
					actions = {
						onSelected = function()
							RemoveWeapons()
						end
					},
				},
				{
					type = "button",
					label = "Menotter",
					actions = {
						onSelected = function()
							ToggleCuff()
						end
					},
				},
				{
					type = "separator",
					label = "Permis",
				},
				{
					type = "button",
					label = "Donner Permis de Port d' Armes (PPA)",
					actions = {
						onSelected = function()
							GiveWeaponLicence()
						end
					},
				},
				{
					type = "separator",
					label = "Véhicules",
				},
				{
					type = "button",
					label = "Supprimer",
					actions = {
						onSelected = function()
							DropVehicle()
						end
					},
				},
				{
					type = "button",
					label = "Herses",
					actions = {
						onSelected = function()
							SpawnSpikesStripe()
						end
					},
				},
				{
					type = "separator",
					label = "SWAT",
				},
				{
					type = "button",
					label = "Bouclier",
					actions = {
						onSelected = function()
							if shieldActive then
								DisableShield()
							else
								EnableShield()
							end
						end
					},
				},
			}
		elseif job.name == "lsms" then
			buttons = {
				{
					type = "separator",
					label = "Soins",
				},
				{
					type = "button",
					label = "Soigner",
					actions = {
						onSelected = function()
							HealClosestPlayer()
						end
					},
				},
				{
					type = "button",
					label = "Réanimer",
					actions = {
						onSelected = function()
							ReviveClosestPlayer()
						end
					},
				},
			}
		elseif job.name == "farm" or job.name == "wine" then
			buttons = {
				{
					type = "separator",
					label = "Revente",
				},
				{
					type = "button",
					label = "Commencer la revente",
					actions = {
						onSelected = function()
							BeginSell(job.name)
						end
					},
				},
				{
					type = "button",
					label = "Finir la revente",
					actions = {
						onSelected = function()
							RemoveSell(job.name)
						end
					},
				},
			}
		elseif job.name == "taxi" then
			buttons = {
				{
					type = "separator",
					label = "Courses",
				},
				{
					type = "button",
					label = "Commencer les courses",
					actions = {
						onSelected = function()
							TriggerEvent("taxi:fares:start")
							exports.bro_core:Notification("~b~Les courses commencent")
							exports.bro_core:RemoveMenu("taxi")
						end
					},
				},
				{
					type = "button",
					label = "Stopper les courses",
					actions = {
						onSelected = function()
							TriggerEvent("taxi:fares:stop")
							exports.bro_core:Notification("~r~Fin des courses")
							exports.bro_core:RemoveMenu("taxi")
						end
					},
				},
			}
		elseif job.name == "bennys" then
			buttons = {
				{
					type = "separator",
					label = "Réparations",
				},
				{
					type = "button",
					label = "Vitres",
					actions = {
						onSelected = function()
							FixVitres()
						end
					},
				},
				{
					type = "button",
					label = "Pneus",
					actions = {
						onSelected = function()
							FixPneus()
						end
					},
				},
				{
					type = "button",
					label = "Carroserie",
					actions = {
						onSelected = function()
							FixCarroserie()
						end
					},
				},
				{
					type = "button",
					label = "Moteur",
					actions = {
						onSelected = function()
							FixEngine()
						end
					},
				},
				{
					type = "separator",
					label = "Nettoyage",
				},
				{
					type = "button",
					label = "Carroserie",
					actions = {
						onSelected = function()
							CleanCarroserie()
						end
					},
				},
			}
		elseif job.name == "newspapers" then
			buttons[#buttons+1] = {
				type = "button",
				label = "Stopper les livraisons",
				actions = {
					onSelected = function()
						BeginInProgress = false
						-- on nettoie la merde
						exports.bro_core:RemoveArea("begin-current")
						VehicleLivraison = 0
						ClearAllBlipRoutes()
					end
				},
			}
		end

		if job.name == "lspd" or job.name == "lsms" or job.name == "bennys" or job.name == "farm" or job.name == "wine" or job.name == "taxi" then
			buttons[#buttons+1] = {
				type = "separator",
				label = "Factures",
			}
			buttons[#buttons+1] = {
				type = "button",
				label = "Facturer",
				actions = {
					onSelected = function()
						local motif = exports.bro_core:OpenTextInput({defaultText = "Réparation", customTitle = true, title= "Motif"})
						local price = exports.bro_core:OpenTextInput({defaultText = "100", customTitle = true, title= "Prix"})
						local closestPlayer = exports.bro_core:GetClosestPlayer()
						if closestPlayer ~= 1  then
							TriggerServerEvent("job:facture", GetPlayerServerId(closestPlayer), motif, price, job)
						else
							exports.bro_core:Notification("~r~Pas de joueur à proximité")
						end
						exports.bro_core:RemoveMenu("actions")
					end
				},
			}
		end
		exports.bro_core:AddSubMenu("actions", {
			parent= "job",
			Title = "Actions",
			Subtitle = job.label,
			buttons = buttons
		})

		-- Animations
		buttons = {
			{
				type = "button",
				label = "Noter",
				actions = {
					onSelected = function()
						Note()
					end
				},
			},
			{
				type = "button",
				label = "Annuler l'Animation",
				actions = {
					onSelected = function()
						CancelEmote()
					end
				},
			}
		}
		if job.name == "lspd" then
			buttons[#buttons+1] = {
					type = "button",
					label = "Traffic",
					actions = {
						onSelected = function()
							DoTraffic()
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "StandBy",
					actions = {
						onSelected = function()
							StandBy()
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "StandBy5",
					actions = {
						onSelected = function()
							StandBy2()
						end
					},
				}

		end
		exports.bro_core:AddSubMenu("animations", {
			parent= "job",
			Title = "Animations",
			Subtitle = job.label,
			buttons = buttons
		})
		-- Props
		buttons = {
		}
		if job.name == "lspd" then
			buttons[#buttons+1] = {
					type = "button",
					label = "Barrière",
					actions = {
						onSelected = function()
							SpawnProps("prop_mp_barrier_01b")
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "Barrière 2",
					actions = {
						onSelected = function()
							SpawnProps("prop_barrier_work05")
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "Cone lumineux",
					actions = {
						onSelected = function()
							SpawnProps("prop_air_conelight")
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "Barrière 3",
					actions = {
						onSelected = function()
							SpawnProps("prop_barrier_work06a")
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "Cabine",
					actions = {
						onSelected = function()
							SpawnProps("prop_tollbooth_1")
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "Cone 1",
					actions = {
						onSelected = function()
							SpawnProps("prop_mp_cone_01")
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "Cone 2",
					actions = {
						onSelected = function()
							SpawnProps("prop_mp_cone_04")
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "Enlever dernier",
					actions = {
						onSelected = function()
							RemoveLastProps()
						end
					},
				}
				buttons[#buttons+1] = {
					type = "button",
					label = "Enlever tout",
					actions = {
						onSelected = function()
							RemoveAllProps()
						end
					},
				}
		end
		exports.bro_core:AddSubMenu("props", {
			parent= "job",
			Title = "Objets",
			Subtitle = job.label,
			buttons = buttons
		})
	end
end)

AddEventHandler("job:parking", function(vehicles)
	local buttons = {

	}
	for k, v in ipairs (vehicles) do
		buttons[k] =     {
			text = v.label,
			actions = {
				onSelected = function()
					TriggerServerEvent("job:parking:get", "job:parking:get", v.id)
				end
			},
	}
	end
end)

AddEventHandler("job:parking:get", function(name, id)
	local playerPed = PlayerPedId() -- get the local player Ped

	if not IsPedInAnyVehicle(playerPed) then
		exports.bro_core:spawnCar(name, true, nil, true)
		exports.bro_core:RemoveMenu(zoneType..zone)
	end
end)

function RespawnPed(Ped, coords, heading)
	SetEntityCoordsNoOffset(Ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(Ped, false)
	ClearPedBloodDamage(Ped)
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end

AddEventHandler("job:lsms:revive", function(isBleedout)
	local coords = GetEntityCoords(GetPlayerPed(-1))

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

	RespawnPed(Ped, coords, 0.0)

	TriggerEvent("player:alive")
	if isBleedout then
		TriggerEvent('skinchanger:getSkin', function(skin)
			local clothesSkin = {
				['mask_1'] = 0, ['mask_2'] = 0,
				['tshirt_1'] = 15, ['tshirt_2'] = 0,
				['torso_1'] = 15, ['torso_2'] = 0,
				['arms'] = 15, ['arms_2'] = 0,
				['pants_1'] = 21, ['pants_2'] = 0,
				['shoes_1'] = 34, ['shoes_2'] = 0
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)
		FreezeEntityPosition(Ped, true)
		if not HasAnimDictLoaded("missfbi1") then
			RequestAnimDict("missfbi1")

			while not HasAnimDictLoaded("missfbi1") do
				Citizen.Wait(1)
			end
		end
		SetEntityCoords(Ped, vector3(304.0592956543,-573.39636230469,29.836771011353))
		Wait(20)
		TaskPlayAnim(Ped, 'missfbi1', 'cpr_pumpchest_idle', 8.0, -8.0, -1, 1, 0, false, false, false)
		exports.bro_core:Notification("~g~F1~w~ pour vous relever")
		FreezeEntityPosition(Ped, false)
	end

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
	Wait(0)
end)

AddEventHandler("jobs:assurance:vehicles", function(vehicles)
	local buttons = {}
	for k, v in ipairs (vehicles) do
		local parking = v.parking

		if v.parking == "" then
			parking = "Volé"
		elseif v.parking == "depot" then
			parking = "Fourrière"
		elseif v.parking == "global" then
			parking = "Parking global"
		end
		buttons[k] =     {
			text =  v.label.. " ("..parking..")",
			actions = {
				onSelected = function()
					if v.parking == "" then
						local playerPed = PlayerPedId() -- get the local player Ped

						if not IsPedInAnyVehicle(playerPed) then
							exports.bro_core:spawnCar(v.name, true, nil, true)
							TriggerServerEvent("account:money:sub", 10)
							exports.bro_core:Notification("L'assurance vous rembourse le véhicule volé. Vous payez ~g~ 10 $ ~s~ de franchise.")
							exports.bro_core:RemoveMenu("bro-vehicles")
						else
							exports.bro_core:Notification("Vous êtes déjà dans un véhicle")
						end
					end
				end
			},
		}
	end
	exports.bro_core:SetMenuButtons("jobs-vehicles", buttons)
	exports.bro_core:NextMenu("jobs-vehicles")
end)

--lifecycle

AddEventHandler("jobs:refresh", function(job)
	refresh(job[1])
end)

AddEventHandler("weapon:store", function(weapons)
	local buttons = {}
	for k, v in pairs(weapons) do
		if v.weapon == "WEAPON_PISTOL" then
			v.label = "9mm"
		elseif v.weapon == "WEAPON_FLASHLIGHT" then
			v.label = "Lampe torche"
		elseif v.weapon == "WEAPON_STUNGUN" then
			v.label = "Tazer"
		elseif v.weapon == "WEAPON_NIGHTSTICK" then
			v.label = "Matraque"
		elseif v.weapon == "WEAPON_SMG" then
			v.label = "SMG"
		end
		buttons[#buttons+1] = {
			type ="button",
			label = v.label..' x '..v.amount,
			actions = {
				onSelected = function()
					TriggerServerEvent("weapon:get", "weapon:store:store", v.weapon)
				end
			},
		}
	end
	exports.bro_core:AddMenu("armory", {
		Title = "Armurerie",
		Subtitle = job.name,
		buttons = {
			{
				type = "separator",
				label = "gillet",
			},
			{
				type  = "button",
				label = "Mettre",
				actions = {
					onSelected = function()
						AddBulletproofVest()
					end
				},
			},
			{
				type  = "button",
				label = "Enlever",
				actions = {
					onSelected = function()
						RemoveBulletproofVest()
					end
				},
			},
			{
				type = "separator",
				label = "Armes",
			},
			{
				type  = "button",
				label = "Stocker (arme équipée)",
				actions = {
					onSelected = function()
						local found, weapon  = GetCurrentPedWeapon(
							GetPlayerPed(-1),
							1
						)
						if found then

							weapon = tostring(weapon)
							print(weapon)
							if weapon == "453432689" then
								weapon = "WEAPON_PISTOL"
							elseif weapon == "-1951375401" then
								weapon = "WEAPON_FLASHLIGHT"
							elseif weapon == "911657153" then
								weapon = "WEAPON_STUNGUN"
							elseif weapon == "1737195953" then
								weapon = "WEAPON_NIGHTSTICK"
							elseif weapon == "911657153" then
								weapon = "WEAPON_SMG"
							elseif weapon == "736523883" then
								weapon = "WEAPON_SMG"
							end
							RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey(weapon))
							TriggerServerEvent("weapon:store", weapon)
							exports.bro_core:Notification("~g~Arme stocké")
						else
							exports.bro_core:Notification("~r~Pas d'arme sur vous")
						end
					end
				},
			},
			{
				type  = "button",
				label = "Retirer arme",
				subMenu = "armoryitems"
			},
		}
	})
	exports.bro_core:AddSubMenu("armoryitems", {
		parent = "armory",
		Title = "Armurerie",
		Subtitle = "Stock",
		buttons =  buttons
	})
end)

AddEventHandler("weapon:store:store", function(isOk, weapon)
	if isOk then
		if not HasPedGotWeapon(GetPlayerPed(-1), GetHashKey(weapon), false) then
			GiveWeaponToPed(
				GetPlayerPed(-1) --[[ Ped ]],
				weapon --[[ Hash ]],
				100 --[[ integer ]],
				false --[[ boolean ]],
				true --[[ boolean ]]
			)
		else
			exports.bro_core:Notification("~r~ Vous avez déjà cet arme")
		end
	else
		exports.bro_core:Notification("~r~ L'armurerie est vide")
	end
end)

AddEventHandler('job:removeWeapons', function()
    RemoveAllPedWeapons(PlayerPedId(), true)
end)

AddEventHandler('job:handcuff', function()
	HandCuffed = not HandCuffed
	if(HandCuffed) then
		exports.bro_core:AdvancedNotification({
			text = "Menotté",
			title = "LSPD",
			icon = "CHAR_AGENT14",
		})
	else
		exports.bro_core:AdvancedNotification({
			text = "Démenotté",
			title = "LSPD",
			icon = "CHAR_AGENT14",
		})
		Cuffing = false
		ClearPedTasksImmediately(PlayerPedId())
	end
end)

local lockAskingFine = false
AddEventHandler('job:payFines', function(amount, sender)
	Citizen.CreateThread(function()

		if(lockAskingFine ~= true) then
			lockAskingFine = true
			local notifReceivedAt = GetGameTimer()
			exports.bro_core:Notification("Amende de " .. amount .. "$. Y pour accepter")
			while(true) do
				Wait(0)

				if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) then
					TriggerServerEvent('job:finesETA', sender, 2)
					exports.bro_core:Notification("Amende expirée")
					lockAskingFine = false
					break
				end

				if IsControlPressed(1, Config.bindings.accept_fine) then
					TriggerServerEvent("account:player:add", "", -amount)
					exports.bro_core:Notification("Amende de " .. amount .. "$ payée")
					TriggerServerEvent('job:finesETA', sender, 0)
					lockAskingFine = false
					break
				end

				if IsControlPressed(1, Config.bindings.refuse_fine) then
					TriggerServerEvent('job:finesETA', sender, 3)
					lockAskingFine = false
					break
				end
			end
		else
			TriggerServerEvent('job:finesETA', sender, 1)
		end
	end)
end)

LockAskingFacture = false
AddEventHandler('job:facture', function(amount, motif, job, sender)
	Citizen.CreateThread(function()
		if(LockAskingFacture ~= true) then
			LockAskingFacture = true
			local notifReceivedAt = GetGameTimer()
			exports.bro_core:AdvancedNotification({
				text = "Facture de ~g~" .. exports.bro_core:Money(tonumber(amount)) .. ".~n~ Motif : " .. motif.. "~n~~g~Y pour accepter.~n~~r~R pour refuser.",
				title = job.name,
				icon = "char_AGENT14"
			})
			while(true) do
				Wait(0)

				if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) then
					TriggerServerEvent('job:facture2', sender, 2, job)
					exports.bro_core:Notification("~r~Facture expirée")
					LockAskingFacture = false
					break
				end

				if IsControlPressed(1, Config.bindings.accept_fine) then
					TriggerServerEvent("account:player:liquid:get:facture", "job:facture:accept", amount, sender, job)
					LockAskingFacture = false
					break
				end

				if IsControlPressed(1, Config.bindings.refuse_fine) then
					TriggerServerEvent('job:facture2', sender, 3, job)
					LockAskingFacture = false
					break
				end
			end
		else
			TriggerServerEvent('job:facture2', sender, 1, job)
		end
	end)
end)

AddEventHandler("job:facture:accept", function(liquid, amount, sender, job)
	amount = tonumber(amount)
	if liquid >= amount then
		TriggerServerEvent("account:job:add", "", job.job, amount*(1-Config.tva), true)
		TriggerServerEvent("account:job:add", "", 1, amount*Config.tva, true)
		exports.bro_core:Notification("Facture de ~g~" .. amount .. "$ payée")
		TriggerServerEvent('job:facture2', sender, 0, job)
	else
		exports.bro_core:Notification("~r~Vous n'avez pas assez d'argent")
		TriggerServerEvent('job:facture2', sender, 3, job)
	end
	LockAskingFacture = false
end)

-- On nettoie le caca
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	DeleteMenuAndArea()
end)


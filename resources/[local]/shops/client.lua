config = {}
config.bindings = {
    interact_position = 51, -- E
}
config.Zones = {
	{
		id =1,
		pos = vector3(373.74911499023,325.75186157227,103.56638336182),
		pnj = {model = "mp_m_shopkeep_01", x=372.77, y=327.64, z=103.57, a=242.89},
		storage = vector3(25.886821746826,-1339.4995117188,29.497024536133),
	},
	{
		id =2,
		pos = vector3(2557.3627929688,382.5471496582,108.62295532227),
		pnj = {model = "mp_m_shopkeep_01", x=2557.03, y=380.69, z=108.62, a=5.3},
		storage = vector3(25.886821746826,-1339.4995117188,29.497024536133),
	},
	{
		id =3,
		pos = vector3(25.746879577637,-1347.7385253906,29.497026443481),
		pnj = {model = "mp_m_shopkeep_01", x=24.393159866333, y=-1345.759765625, z=29.497024536133, a=232.14},
		storage = vector3(25.886821746826,-1339.4995117188,29.497024536133),
	},
	{
		id =4,
		pos = vector3(-48.628559112549,-1757.6479492188,29.420999526978),
		pnj = {model = "mp_m_shopkeep_01", x=-45.917854309082, y=-1757.9925537109, z=29.420999526978, a=232.14},
		storage = vector3(-43.329521179199,-1749.0797119141,29.421012878418),
	},
	{
		id =5,
		pos = vector3(-1486.5401611328,-380.0739440918,40.163394927979),
		pnj = {model = "mp_m_shopkeep_01", x=-1486.9683837891, y=-377.17645263672, z=40.163394927979, a=232.14},
		storage = vector3(-1483.8095703125,-375.59802246094,40.163425445557),
	},
	{
		id =6,
		pos = vector3(1163.5238037109,-323.45788574219,69.205070495605),
		pnj = {model = "mp_m_shopkeep_01", x=1164.7891845703, y=-322.35919189453, z=69.205108642578, a=232.14},
		storage = vector3(1159.9201660156,-314.15371704102,69.205108642578),
	},
	{
		id =7,
		pos = vector3(1698.2857666016,4924.6826171875,42.063640594482),
		pnj = {model = "mp_m_shopkeep_01", x=1698.3309326172, y=4922.51953125, z=42.063640594482, a=232.14},
		storage = vector3(1706.5498046875,4919.9799804688,42.063640594482),
	},
}

config.robLength = 2
config.robMaxDistance = 20

zoneType = ""
zone = 0

-- Create blips
Citizen.CreateThread(function()   
	exports.bf:AddMenu("CurrentShop", {
		title = "Magasin",
		position = 1,
	})
	exports.bf:AddMenu("storage", {
		title = "Entreprôt",
		position = 1,
	})
	for k,v in pairs(config.Zones) do
		exports.bf:AddArea("shops"..v.id, {
			marker = {
				weight = 0.5,
				height = 0.3,
			},
			trigger = {
				weight = 1,
				enter = {
					callback = function()
						exports.bf:HelpPromt("Acheter : ~INPUT_PICKUP~")
						zoneType = "shops"
						zone = v.id
					end
				},
				exit = {
					callback = function()
						zoneType = nil
						zone = 0
					end
				},
			},
			blip = {
				text = "Supérette",
				colorId = 2,
				imageId = 52,
			},
			locations = {
				{
					x= v.pos.x,
					y= v.pos.y,
					z= v.pos.z
				},
			}
		})
		exports.bf:AddArea("storage"..v.id, {
			marker = {
				weight = 0.5,
				height = 0.3,
			},
			trigger = {
				weight = 1,
				enter = {
					callback = function()
						exports.bf:HelpPromt("Vendre : ~INPUT_PICKUP~")
						zoneType = "storage"
						zone = v.id
					end
				},
				exit = {
					callback = function()
						zoneType = nil
						zone = 0
					end
				},
			},
			blip = {
				text = "Entrepôt",
				colorId = 2,
				imageId = 52,
			},
			locations = {
				{
					x= v.storage.x,
					y= v.storage.y,
					z= v.storage.z
				},
			}
		})

		-- spawn apu
		RequestModel(GetHashKey(v.pnj.model))
		while not HasModelLoaded(GetHashKey(v.pnj.model)) do
			Wait(1)
		end

	-- Spawn the bartender to the coordinates
		bartender =  CreatePed(5, v.pnj.model, v.pnj.x, v.pnj.y, v.pnj.z, v.pnj.a, false, true)
		SetBlockingOfNonTemporaryEvents(bartender, true)
		SetPedCombatAttributes(bartender, 46, true)
		SetPedFleeAttributes(bartender, 0, 0)
		SetPedRelationshipGroupHash(bartender, GetHashKey("CIVFEMALE"))
	end
end)

-- open menu loop
Citizen.CreateThread(function()
	-- main loop
    while true do
		Citizen.Wait(0)	
		if zone ~= nil and zoneType ~= nil and IsControlJustPressed(1,config.bindings.interact_position) then
			if zoneType == "shops" then
				TriggerServerEvent("shops:items:get", "shops:open", zone)
			elseif zoneType == "storage" then
				TriggerEvent("storage:open")
			end
		end
	end
end)

RegisterNetEvent("shops:open")
-- close the menu when script is stopping to avoid being stuck in NUI focus
AddEventHandler('shops:open', function(items)
	buttons = {}
	for k, v in pairs(items) do
		if v.item == 13 then
			v.price = 5
		elseif v.item == 14 then
			v.price = 5
		elseif v.item == 19 then
			v.price = 5
		end
        buttons[#buttons+1] = {
            text = v.label.. " ~g~"..v.price.." $",
            exec = {
                callback = function()
					TriggerServerEvent("shops:buy", v.item, 1, v.id)
                end
            },
        }
	end
	buttons[#buttons+1] = {
		text = "Quitter",
		exec = {
			callback = function()
				exports.bf:CloseMenu("CurrentShop")
				exports.bf:RemoveMenu("CurrentShop")
			end
		},
	}
	exports.bf:SetMenuValue("CurrentShop", {
		buttons = buttons
	})
	exports.bf:OpenMenu("CurrentShop")
end)


-- close the menu when script is stopping to avoid being stuck in NUI focus
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		exports.bf:RemoveMenu('CurrentShop')
	end
end)

--- roberry
function robNpc(targetPed)
    robbedRecently = true

    Citizen.CreateThread(function()
        local dict = 'random@mugging3'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(10)
        end

        TaskStandStill(targetPed, config.robLength * 1000)
        FreezeEntityPosition(targetPed, true)
		TaskPlayAnim(targetPed, dict, 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)
		exports.bf:Notification('Braquage en cours')

		-- If no luck, cops get averted
		TriggerServerEvent("job:avert:all", "LSPD", "Un braquage est en cours")

        Citizen.Wait(config.robLength * 1000)

		local playerCoords = GetEntityCoords(PlayerPedId())

		if(GetDistanceBetweenCoords(GetEntityCoords(targetPed), GetEntityCoords(GetPlayerPed(-1))) < config.robMaxDistance) then
			local j = 0
			for k,v in pairs(config.Zones) do
				j = j+1
				local distance = GetDistanceBetweenCoords(playerCoords, v.pos.x, v.pos.y, v.pos.z, true)

				if distance < config.robMaxDistance then
					--lets rob
					TriggerServerEvent("shops:rob", v.id)
				end
			end
		else
			exports.bf:Notification('Vous vous êtes trop éloigné')
		end
        robbedRecently = false
    end)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if IsControlJustPressed(0, 58) then
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))

            if aiming then
                local playerPed = GetPlayerPed(-1)

                if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
					if robbedRecently then
						exports.bf:Notification('Trop rapide !')
					elseif IsPedDeadOrDying(targetPed, true) then
						exports.bf:Notification("L'épicier est mort")
                    else
                        robNpc(targetPed)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("storage:open")
-- close the menu when script is stopping to avoid being stuck in NUI focus
AddEventHandler('storage:open', function()
	buttons = {}
	buttons[#buttons+1] = {
		text = "Vendre pain ~g~3$",
		exec = {
			callback = function()
				TriggerServerEvent("shops:sell", zone, 13, 1)
			end
		},
	}
	buttons[#buttons+1] = {
		text = "Vendre Jus de raisin ~g~3$",
		exec = {
			callback = function()
				TriggerServerEvent("shops:sell", zone, 19, 1)
			end
		},
	}
	buttons[#buttons+1] = {
		text = "Consulter le stock (Pain)",
		exec = {
			callback = function()
				TriggerServerEvent("shops:stock", zone, 13)
			end
		},
	}
	buttons[#buttons+1] = {
		text = "Consulter le stock (Jus de raisin)",
		exec = {
			callback = function()
				TriggerServerEvent("shops:stock", zone, 19)
			end
		},
	}
	buttons[#buttons+1] = {
		text = "Quitter",
		exec = {
			callback = function()
				exports.bf:CloseMenu("storage")
				exports.bf:RemoveMenu("storage")
			end
		},
	}
	exports.bf:SetMenuValue("storage", {
		buttons = buttons
	})
	exports.bf:OpenMenu("storage")
end)



AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	exports.bf:RemoveMenu("CurrentShop")
	exports.bf:RemoveMenu("storage")
	for k,v in pairs(config.Zones) do
		exports.bf:RemoveArea("shops"..v.id)
		exports.bf:RemoveArea("storage"..v.id)
	end
end)
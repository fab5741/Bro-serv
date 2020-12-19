config = {}
config.bindings = {
    interact_position = 51, -- E
}
config.Zones = {
	{
		pnj = {model = "mp_m_shopkeep_01", x=372.77, y=327.64, z=103.57, a=242.89},
	},
	{
		pnj = {model = "mp_m_shopkeep_01", x=2557.03, y=380.69, z=108.62, a=5.3},
	},
	{
		pnj = {model = "mp_m_shopkeep_01", x=24.393159866333, y=-1345.759765625, z=29.497024536133, a=232.14},
	},
	{
		pnj = {model = "mp_m_shopkeep_01", x=-45.917854309082, y=-1757.9925537109, z=29.420999526978, a=232.14},
	},
	{
		pnj = {model = "mp_m_shopkeep_01", x=-1486.9683837891, y=-377.17645263672, z=40.163394927979, a=232.14},
	},
	{
		pnj = {model = "mp_m_shopkeep_01", x=1164.7891845703, y=-322.35919189453, z=69.205108642578, a=232.14},
	},
	{
		pnj = {model = "mp_m_shopkeep_01", x=1698.3309326172, y=4922.51953125, z=42.063640594482, a=232.14},
	},
}

config.items = {
	{
		type = 3, price = 5, label ="Bro'Bab"
	},
	{
		type = 5, price = 5, label ="Le jus des bros"
	}
}

config.robLength = 120000
config.robMaxDistance = 20

zoneType = ""
zone = 0

-- Create blips
Citizen.CreateThread(function()   
	exports.bf:AddMenu("CurrentShop", {
		title = "Magasin",
		position = 1,
	})
	exports.bf:AddArea("shopssss", {
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
				x=373.74911499023,y=325.75186157227,z=103.56638336182,
			},
			{
				x=2557.3627929688,y=382.5471496582,z=108.62295532227,
			},
			{
				x=25.746879577637,y=-1347.7385253906,z=29.497026443481,
			},			
			{
				x=-48.628559112549,y=-1757.6479492188,z=29.420999526978,
			},
			{
				x=-1486.5401611328,y=-380.0739440918,z=40.163394927979,
			},
			{
				x=1163.5238037109,y=-323.45788574219,z=69.205070495605,
			},
			{
				x=1698.2857666016,y=4924.6826171875,z=42.063640594482,
			}
		}
	})
	for k,v in pairs(config.Zones) do
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
				buttons = {}
				for k, v in pairs(config.items) do
					buttons[#buttons+1] = {
						text = v.label.. " ~g~"..v.price.." $",
						exec = {
							callback = function()
								TriggerServerEvent("shops:buy", v.type, 1, v.price)
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
			end
		end
	end
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
		if math.random(1,2) == 1 then
			TriggerServerEvent("job:avert:all", "LSPD", "Un braquage est en cours", true)
		end

		TriggerEvent("bf:progressBar:create", config.robLength, "Braquage en cours")

		timeElapsed = 0
		nb = 5
		while timeElapsed <= config.robLength and robbedRecently do
			Citizen.Wait(10000)
			timeElapsed = timeElapsed + 10000
			local playerCoords = GetEntityCoords(PlayerPedId())
			if(GetDistanceBetweenCoords(GetEntityCoords(targetPed), GetEntityCoords(GetPlayerPed(-1))) < config.robMaxDistance) then
				-- add valise
				TriggerServerEvent("items:add", 8, nb)
				exports.bf:Notification('Valises d\'argent : +~g~'..nb)
			else
				exports.bf:Notification('~r~Vous vous êtes trop éloigné')
				robbedRecently = false
				TriggerEvent("bf:progressBar:delete")
			end
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
				if IsPedArmed(playerPed, 1) or IsPedArmed(playerPed, 4) then
					if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
						if robbedRecently then
							exports.bf:Notification('~r~Trop rapide !')
						elseif IsPedDeadOrDying(targetPed, true) then
							exports.bf:Notification("~r~L'épicier est mort")
						else
							robNpc(targetPed)
						end
					end
				else
					exports.bf:Notification("~r~Vous devez être armé")
				end
			end
        end
    end
end)
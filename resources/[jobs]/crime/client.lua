config = {
	interactKey = 51, -- E
	range = 5,
	drugs = {
		weed = {
			collect = {
				pos = {
					x=1057.64, y= -3196.37, z= -39.16
				},
				tp = {
					start = {
						x = 1440.27, y = -1479.59, z = 63.12
					},
					endpoint = {
						x = 1066.06, y= -3183.45, z = -39.16
					},
				},
			},
			process = {
				pos = {
					x = 144.16, y = -130.84, z = 54.83
				}
			},
		}
	},
	shops = {
		{
			pos = {
				x = 239.61, y = -2018.95, z = 18.31
			},
			pnj = {
				model = "csb_ramp_gang", x = 241.01, y=-2018.03, z=18.32, h = 124.09
			}
		}
	}
}

local isInRangeCollect = nil
local isInRangeProcess = nil
local isInRangeSelling = nil

local isCollecting = false
local isProcessing = false
local isSelling = false
isSellingMalette = false
isSellingDrug = false
nbMalettes = 0

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(config.drugs) do
			if GetDistanceBetweenCoords(coords, v.collect.tp.start.x, v.collect.tp.start.y, v.collect.tp.start.z, true) < config.range and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
				SetPedCoordsKeepVehicle(PlayerPedId(), v.collect.tp.endpoint.x, v.collect.tp.endpoint.y, v.collect.tp.endpoint.z)
				Wait(5000)
			end
			if GetDistanceBetweenCoords(coords, v.collect.tp.endpoint.x, v.collect.tp.endpoint.y, v.collect.tp.endpoint.z, true) < config.range and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
				SetPedCoordsKeepVehicle(PlayerPedId(), v.collect.tp.start.x, v.collect.tp.start.y,  v.collect.tp.start.z)
				Wait(5000)
			end
			for kk,vv in pairs(v.collect) do
				if GetDistanceBetweenCoords(coords, vv.x, vv.y, vv.z, true) < config.range then
					if  isInRangeCollect == nil  then
						exports.bf:Notification("Hey, tu veux de la beuh, mon bro ? (E)")
						isInRangeCollect = vv
					end
				else
					if  isInRangeCollect == vv  then
						isInRangeCollect = nil
					end
				end
			end
			for kk,vv in pairs(v.process) do
				if GetDistanceBetweenCoords(coords, vv.x, vv.y, vv.z, true) < config.range then
					if  isInRangeProcess == nil  then
						exports.bf:Notification("Tu sais comment faire des pochons ?")
						isInRangeProcess = vv
					end
				else
					if  isInRangeProcess == vv  then
						isInRangeProcess = nil
					end
				end
			end
		end
		for kk,vv in pairs(config.shops) do
			if GetDistanceBetweenCoords(coords, vv.pos.x, vv.pos.y, vv.pos.z, true) < config.range then
				exports.bf:Notification("PSST, tu sais pas ou trouver des malettes d'argent ?")
				isInRangeSelling = true
			else
				isInRangeSelling = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(config.shops) do
		RequestModel(GetHashKey(v.pnj.model))
		while not HasModelLoaded(GetHashKey(v.pnj.model)) do
			Wait(1)
		end
	
	-- Spawn the bartender to the coordinates
		bartender =  CreatePed(5, v.pnj.model, v.pnj.x, v.pnj.y, v.pnj.z, v.pnj.h, false, true)
		SetBlockingOfNonTemporaryEvents(bartender, true)
		SetPedCombatAttributes(bartender, 46, true)
		SetPedFleeAttributes(bartender, 0, 0)
		SetPedRelationshipGroupHash(bartender, GetHashKey("CIVFEMALE"))
	end
	while true do
		Wait(5)
		if isInRangeCollect ~= nil then
			if (IsControlJustPressed(1,config.interactKey)) then
				local playerPed = GetPlayerPed(-1)
				if isCollecting == false then
					if not  IsPedInAnyVehicle(playerPed, false) then
						local time = 4000
						TriggerEvent("bf:progressBar:create", time, "Récolte en cours")
						isCollecting = true 
						Citizen.CreateThread(function ()
							FreezeEntityPosition(playerPed)
							
							local dict = "amb@world_human_gardener_plant@male@enter"
							local anim = "enter"
							RequestAnimDict(dict)

							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(150)
							end
							TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

							Wait(time)
							isCollecting = false
							TriggerServerEvent("items:add",  6, 5, "Vous récoltez un peu de ~g~weed (non traité)")
						end)
					else
						exports.bf:Notification("~r~Vous ne pouvez pas transformer en véhicule")
					end
				else 
					exports.bf:Notification("~r~Récolte en cours")
				end
			end
		end
		if isInRangeProcess ~= nil then
			if (IsControlJustPressed(1,config.interactKey)) then
				local playerPed = GetPlayerPed(-1)
				if isProcessing == false then
					if not  IsPedInAnyVehicle(playerPed, false) then
						local time = 4000
						TriggerEvent("bf:progressBar:create", time, "Transformation en cours")
						isProcessing = true 
						Citizen.CreateThread(function ()
							FreezeEntityPosition(playerPed)
							
							local dict = "amb@world_human_gardener_plant@male@enter"
							local anim = "enter"
							RequestAnimDict(dict)

							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(150)
							end
							TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

							Wait(time)
							isProcessing = false
							TriggerServerEvent("items:process",  6, 10, 7, 5)
						end)
					else
						exports.bf:Notification("~r~Vous ne pouvez pas transformer en véhicule")
					end
				else 
					exports.bf:Notification("~r~Transformation en cours")
				end
			end
		end
		if isInRangeSelling ~= nil then
			if (IsControlJustPressed(1,config.interactKey)) then
				local playerPed = GetPlayerPed(-1)
				if isSellingMalette == false then
					if not  IsPedInAnyVehicle(playerPed, false) then
						local time = 4000
						nbMalettes = exports.bf:OpenTextInput(
							{
								title = "Combien ?",
								 customTitle = true,
								 maxInputLength = 10
							}
						)
						if nbMalettes ~= nil and nbMalettes ~= "" and tonumber(nbMalettes) > 0 then
							TriggerEvent("bf:progressBar:create", time, "Vente en cours")
							isSellingMalette = true 
							Citizen.CreateThread(function ()
								FreezeEntityPosition(playerPed)
								
								local dict = "amb@world_human_gardener_plant@male@enter"
								local anim = "enter"
								RequestAnimDict(dict)

								while not HasAnimDictLoaded(dict) do
									Citizen.Wait(150)
								end
								TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

								Wait(time)
								isSellingMalette = false
								TriggerServerEvent("item:get", "crime:malette:sell", 8)
							end)
						end
					else
						exports.bf:Notification("~r~Vous ne pouvez pas vendre en véhicule")
					end
				else 
					exports.bf:Notification("~r~Vente en cours")
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsPedShooting(GetPlayerPed(-1)) then
			local random = math.random (0,100)
			if random < 1 then
				TriggerServerEvent("job:avert:all", "lspd", "Coups de feu en cour", true)
			end				
		end
	end
end)

-- vente de rogues

function Vente(pos1)
    local player = PlayerPedId()
    local playerloc = coords
    local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

	if distance <= 2 then
		if isSelling == false then
			local time = 4000
			TriggerEvent("bf:progressBar:create", time, "Vente en cours")
			isSelling = true 
			Citizen.CreateThread(function ()
				FreezeEntityPosition(player)
				Wait(time)
				isSelling = false
				TriggerServerEvent('crime:drug:sell', playerloc)
			end)
		else 
			exports.bf:Notification("~r~Vente en cours")
		end
    elseif distance > 2 then
		exports.bf:Notification("Vous êtes trop éloigné")
    end
end


Citizen.CreateThread(function()
	while true do
		Wait(15)
			local handle, ped = FindFirstPed()
			repeat
				if isSellingDrug then
					coords = GetEntityCoords(PlayerPedId())
					success, ped = FindNextPed(handle)
					local pos = GetEntityCoords(ped)
					local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords['x'], coords['y'], coords['z'], true)
					if not IsPedInAnyVehicle(playerPed) then
						if DoesEntityExist(ped) then
							if not IsPedDeadOrDying(ped) then
								if not IsPedInAnyVehicle(ped) then
									local pedType = GetPedType(ped)
									if pedType ~= 28 and not IsPedAPlayer(ped) then
										currentped = pos
										if distance <= 2 and ped ~= playerPed and ped ~= oldped then
											DrawText3Ds(pos.x, pos.y, pos.z, "E")
											if IsControlJustPressed(1, 86) then
												oldped = ped
												--SetEntityHeading(ped, 180)
												TaskLookAtCoord(ped, coords['x'], coords['y'], coords['z'], -1, 2048, 3)
												TaskStandStill(ped, 100.0)
												SetEntityAsMissionEntity(ped)
												local pos1 = GetEntityCoords(ped)
												Vente(pos1)
												Wait(2500)
												SetPedAsNoLongerNeeded(oldped)
											end
										end
									end
								end
							end
						end
					end
				end
	until not success
	EndFindPed(handle)
	end
end)


function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end
RegisterNetEvent('crime:drug:poucave')
AddEventHandler('crime:drug:poucave', function(posx, posy, posz)
	--TriggerServerEvent('phone:startCall', 'lspd', "deal en cours", { x = posx, y = posy, z = posz })
	TriggerServerEvent("job:avert:all", "lspd", "Deal en cours", true, { x = posx, y = posy, z = posz })
end)
RegisterNetEvent('crime:drug:sell')
AddEventHandler('crime:drug:sell', function(price)
	TriggerServerEvent("account:player:liquid:add", "", price)
	TriggerServerEvent("items:sub", 7, 1)
end)


RegisterNetEvent('crime:malette:sell')
AddEventHandler('crime:malette:sell', function(amount)
	if amount ~= nil and amount >= tonumber(nbMalettes) then
		TriggerServerEvent("account:player:liquid:add", "", nbMalettes * 50)
		TriggerServerEvent("items:sub", 8, nbMalettes)
		exports.bf:Notification("Vous avez vendu pour : ~g~ "..(nbMalettes*50).."$")
	else
		exports.bf:Notification("~r~Vous n'avez pas assez de malettes sur vous")
	end
end)


RegisterNetEvent('crime:drug:sell:start')
AddEventHandler('crime:drug:sell:start', function()
	isSellingDrug = true
	exports.bf:Notification("Revente de drogue lancée")
end)


RegisterNetEvent('crime:drug:sell:stop')
AddEventHandler('crime:drug:sell:stop', function()
	isSellingDrug = false
	exports.bf:Notification("Revente de drogue stopée")
end)

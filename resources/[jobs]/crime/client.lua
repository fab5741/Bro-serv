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
			sell = {
				pos = {
					x = 239.61, y = -2018.95, z = 18.31
				},
				pnj = {
					model = "csb_ramp_gang", x = 241.01, y=-2018.03, z=18.32, h = 124.09
				}
			}
		}
	}
}

local isInRangeCollect = nil
local isInRangeProcess = nil
local isInRangeSell = nil

Citizen.CreateThread(function()
	for k,v in pairs(config.drugs) do
		vv = v.sell
		RequestModel(GetHashKey(vv.pnj.model))
		while not HasModelLoaded(GetHashKey(vv.pnj.model)) do
			Wait(1)
		end
	
	-- Spawn the bartender to the coordinates
		bartender =  CreatePed(5, vv.pnj.model, vv.pnj.x, vv.pnj.y, vv.pnj.z, vv.pnj.h, false, true)
		SetBlockingOfNonTemporaryEvents(bartender, true)
		SetPedCombatAttributes(bartender, 46, true)
		SetPedFleeAttributes(bartender, 0, 0)
		SetPedRelationshipGroupHash(bartender, GetHashKey("CIVFEMALE"))
	end
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
			for kk,vv in pairs(v.sell) do
				if GetDistanceBetweenCoords(coords, vv.x, vv.y, vv.z, true) < config.range then
					if  isInRangeSell == nil  then
						exports.bf:Notification("Je te prend un pochon")
						isInRangeSell = vv
					end
				else
					if  isInRangeSell == vv  then
						isInRangeSell = nil
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)
		if isInRangeCollect ~= nil then
			if (IsControlJustPressed(1,config.interactKey)) then
				if not isCollecting then
					isCollecting = true
					Wait(5000)
					TriggerServerEvent("items:add",  20, 1, "Vous récoltez un peu de ~g~weed (non traité)")
					isCollecting = false
				end
			end
		end
		if isInRangeProcess ~= nil then
			if (IsControlJustPressed(1,config.interactKey)) then
				if not isProcessing then
					isProcessing = true
					Wait(5000)
					TriggerServerEvent("items:process",  20, 1, 21, 1)
					exports.bf:Notification("Vous avez traité un pochon de weed")
					isProcessing = false
				end
			end
		end
		if isInRangeSell ~= nil then
			if (IsControlJustPressed(1,config.interactKey)) then
				if not isSelling then
					isSelling = true
					Wait(5000)
					-- TODO test, if items in inventory
					TriggerServerEvent("items:sub",  21, 1)
					TriggerServerEvent("account:money:add",  8)
					exports.bf:Notification("Vous avez vendu un pochon de weed")
					isSelling = false
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
				print("LEs flics ont étés alertés")
				TriggerServerEvent("job:avert:all", "lspd", "Coups de feu en cour", true)
			end				
		end
	end
end)

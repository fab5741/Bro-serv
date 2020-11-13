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

local function printTable( t )

    local printTable_cache = {}

    local function sub_printTable( t, indent )

        if ( printTable_cache[tostring(t)] ) then
            print( indent .. "*" .. tostring(t) )
        else
            printTable_cache[tostring(t)] = true
            if ( type( t ) == "table" ) then
                for pos,val in pairs( t ) do
                    if ( type(val) == "table" ) then
                        print( indent .. "[" .. pos .. "] => " .. tostring( t ).. " {" )
                        sub_printTable( val, indent .. string.rep( " ", string.len(pos)+8 ) )
                        print( indent .. string.rep( " ", string.len(pos)+6 ) .. "}" )
                    elseif ( type(val) == "string" ) then
                        print( indent .. "[" .. pos .. '] => "' .. val .. '"' )
                    else
                        print( indent .. "[" .. pos .. "] => " .. tostring(val) )
                    end
                end
            else
                print( indent..tostring(t) )
            end
        end
    end

    if ( type(t) == "table" ) then
        print( tostring(t) .. " {" )
        sub_printTable( t, "  " )
        print( "}" )
    else
        sub_printTable( t, "  " )
    end
end

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
			if GetDistanceBetweenCoords(coords, v.collect.tp.start.x, v.collect.tp.start.y, v.collect.tp.start.z, true) < config.range then
				SetPedCoordsKeepVehicle(PlayerPedId(), v.collect.tp.endpoint.x, v.collect.tp.endpoint.y, v.collect.tp.endpoint.z)
				Wait(5000)
			end
			if GetDistanceBetweenCoords(coords, v.collect.tp.endpoint.x, v.collect.tp.endpoint.y, v.collect.tp.endpoint.z, true) < config.range then
				SetPedCoordsKeepVehicle(PlayerPedId(), v.collect.tp.start.x, v.collect.tp.start.y,  v.collect.tp.start.z)
				Wait(5000)
			end
			for kk,vv in pairs(v.collect) do
				if GetDistanceBetweenCoords(coords, vv.x, vv.y, vv.z, true) < config.range then
					if  isInRangeCollect == nil  then
						TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "Hey, tu veux de la beuh, mon bro ? (E)", false, "")
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
						TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "Tu sais comment faire des pochons ?", false, "")
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
						TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "Je te prend un pochon", false, "")
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
					TriggerServerEvent("items:add",  20, 1)

					TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "Vous récoltez un peu de weed (non traité)", false, "")
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
					TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "Vous avez traité un pochon de weed", false, "")
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
					TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1, "Vous avez vendu un pochon de weed", false, "")
					isSelling = false
				end
			end
		end
	end
end)

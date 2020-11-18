local buttons = {}

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

function clockIn(job)
		ServiceOn()
		SetSkin(job)
		exports.bf:Notification("En service")

end

function clockOut()
	ServiceOff()
	removeUniforme()
	exports.bf:Notification("Fin de service")
end

function SetSkin(job)
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
	TriggerEvent('skinchanger:loadClothes', skin, config.jobs[job].grades.stagiaire.skin_male)
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
end
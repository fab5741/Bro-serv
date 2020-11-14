# Bro-serv
Serveur GTA-RP, pour apprendre les techs, et peut être une réalité un jour !


# Techs
## Voip and Radio by Tokio Voip
https://github.com/Itokoyamato/TokoVOIP_TS3

## Fuel system
Fr fuel

## no reticule addon
https://github.com/ToastinYou/NoReticle

## car hud
https://github.com/bepo13/FiveM-SimpleCarHUD


## PHONE :

https://github.com/Re-Ignited-Development/Re-Ignited-Phone




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
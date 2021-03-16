--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/bro
--

--
-- PrintTable event
--
RegisterNetEvent("bro:PrintTable")
AddEventHandler('bro:PrintTable', function(value)

    print("---------[bro : Debug]---------")
    PrintTable(value)
    print("-------------------------")

end)

--
-- Debug mod
--
RegisterNetEvent("bro:DebugMode")
AddEventHandler('bro:DebugMode', function(status)

    debugMode = status
    if debugMode == true then
        Citizen.Trace("[bro] DEBUG MODE ENABLE")
    else
        Citizen.Trace("[bro] DEBUG MODE DISABLE")
    end

end)


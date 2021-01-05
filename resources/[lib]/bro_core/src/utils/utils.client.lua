--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/bf
--

--
-- PrintTable event
--
RegisterNetEvent("bf:PrintTable")
AddEventHandler('bf:PrintTable', function(value)

    print("---------[bf : Debug]---------")
    PrintTable(value)
    print("-------------------------")

end)

--
-- Debug mod
--
RegisterNetEvent("bf:DebugMode")
AddEventHandler('bf:DebugMode', function(status)

    debugMode = status
    if debugMode == true then
        Citizen.Trace("[bf] DEBUG MODE ENABLE")
    else
        Citizen.Trace("[bf] DEBUG MODE DISABLE")
    end

end)


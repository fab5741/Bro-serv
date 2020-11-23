--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/bf
--

--
-- Get SeamID
--
function GetSteamIDFormSource(source)

    assert(type(source) == "number", "source must be number")

    local identifier = GetPlayerIdentifiers(source)
    if identifier[1] ~= nil and string.find(identifier[1], "steam") then
        return identifier[1]
    end
	return false

end


--
-- Get Discord Id
--
function GetDiscordFromSource(source)

    assert(type(source) == "number", "source must be number")

	for k,v in pairs(GetPlayerIdentifiers(source))do			
		if string.sub(v, 1, string.len("discord:")) == "discord:" then
            return v
		end
	end
	return false

end

--
-- Get IP
--
function GetIpFormSource(source)

    assert(type(source) == "number", "source must be number")

    local ip = GetPlayerEP(source)
    if ip ~= nil then
        return ip
    end
	return false

end

--
-- PrintTable event
--
RegisterServerEvent("bf:PrintTable")
AddEventHandler('bf:PrintTable', function(value)

    print("---------[bf : Debug]---------")
    PrintTable(value)
    print("-------------------------")

end)

--
--
--
AddEventHandler('onServerResourceStart', function(resource)

    if resource == 'bf' then
        debugMode = GetConvar("ft_debug", "false")

        if debugMode == "true" then
            print("[bf] DEBUG MODE ENABLE")
            debugMode = true
        else
            debugMode = false
        end
    end

end)

--
--
--
RegisterServerEvent("bf:OnClientReady")
AddEventHandler('bf:OnClientReady', function()

	TriggerClientEvent("bf:DebugMode", source, debugMode)

end)

--
-- Rcon comand
--
RegisterServerEvent("rconCommand")
AddEventHandler("rconCommand", function(command, args)

    if command == "ft_debugMode" then

        local count = #args
        if count == 0 then

            if debugMode == true then
                debugMode = false
            else
                debugMode = true
            end

        elseif count == 1 then

            local arg = args[1]
            if arg == "true" or arg == "1" then
                debugMode = true
            elseif arg == "false" or arg == "0" then
                debugMode = false
            end

        end

        -- Print to console
        if debugMode == true then
            print("[bf] DEBUG MODE ENABLE")
        else
            print("[bf] DEBUG MODE DISABLE")
        end

        TriggerClientEvent("bf:DebugMode", -1, debugMode)
        CancelEvent()

    end

end)


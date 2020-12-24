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
-- PrintTable event
--
RegisterServerEvent("bro_core:PrintTable")
AddEventHandler('bro_core:PrintTable', function(value)

    print("---------[bro_core : Debug]---------")
    PrintTable(value)
    print("-------------------------")

end)

--
--
--
AddEventHandler('onServerResourceStart', function(resource)
    if resource == 'bro_core' then
        debugMode = GetConvar("ft_debug", "false")

        if debugMode == "true" then
            print("[bro_core] DEBUG MODE ENABLE")
            debugMode = true
        else
            debugMode = false
        end
    end
end)

--
--
--
RegisterServerEvent("bro_core:OnClientReady")
AddEventHandler('bro_core:OnClientReady', function()
	TriggerClientEvent("bro_core:DebugMode", source, debugMode)
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
            print("[bro_core] DEBUG MODE ENABLE")
        else
            print("[bro_core] DEBUG MODE DISABLE")
        end

        TriggerClientEvent("bro_core:DebugMode", -1, debugMode)
        CancelEvent()

    end

end)


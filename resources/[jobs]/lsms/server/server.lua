local inServiceLSMS = {}


RegisterNetEvent("lsms:distress")

AddEventHandler('lsms:distress', function(player)
    --check le nombre d'ambulanciers présent
    print("appel recu de " .. player)

    --TODO disable or true, when phone woirking
    if #inServiceLSMS == 0 or true then
        TriggerClientEvent('lsms:revive', source, true)
    else
        TriggerClientEvent("lspd:notify", source, "CHAR_AGENT14", 1,"Appel en cours", false, #inServiceLSMS.. " in service")

        for k,v in pairs(inServiceLSMS)do
            TriggerClientEvent("lspd:notify", v, "CHAR_AGENT14", 1,"Appel en cours", false, "now_cuffed")
        end
    end
    
end)

RegisterNetEvent("lsms:onDuty")

AddEventHandler('lsms:onDuty', function(onDuty)
    local sourceValue = source
    for k,v in pairs(GetPlayerIdentifiers(sourceValue))do
        
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
    end
    
    MySQL.ready(function ()
        MySQL.Async.fetchAll('UPDATE players set onDuty=@onDuty where fivem = @fivem',
        {['fivem'] =  discord, ['onDuty'] = onDuty},
        function(res)
        end)
    end)

    if(not inServiceLSMS[source]) then
        if onDuty then
            inServiceLSMS[source] = discord
		end
	end
end)

RegisterNetEvent("lsms:revive")

AddEventHandler('lsms:revive', function(player)
    TriggerClientEvent("lsms:revive", player)
end)

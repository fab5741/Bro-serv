
RegisterNetEvent("skinManager:set")

-- source is global here, don't add to function
AddEventHandler("skinManager:set", function (skin)
    print("Change skin")
    local source = source
    for k,v in pairs(GetPlayerIdentifiers(source))do		
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
    
    MySQL.Async.fetchAll('Update players SET skin=@skin where fivem = @fivem',
    {['fivem'] =  discord, ['skin'] = json.encode(skin)},
    function(res)
    end)
end)
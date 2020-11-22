RegisterNetEvent("clothes:save")

AddEventHandler("clothes:save", function(clothes)
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
		MySQL.Async.execute('update players set clothes = @clothes where fivem = @fivem',
		{['@fivem'] =  discord, ['@clothes'] = json.encode(clothes)},
		function(res)
		end)
	end)
end)
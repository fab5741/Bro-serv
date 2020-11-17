RegisterNetEvent('bf:player:get')
AddEventHandler('bf:player:get', function(cb)
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
		MySQL.Async.fetchAll('select * from players where fivem = @fivem',
        {['fivem'] =  discord},
        function(res)
            if res and res[1] then
                TriggerClientEvent(cb, sourceValue, res[1])
            end
        end)
    end)
end)
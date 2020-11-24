-- Ping kicker
-- Ping Limit
pingLimit = 400

RegisterServerEvent("checkMyPingBro")
AddEventHandler("checkMyPingBro", function()
	ping = GetPlayerPing(source)
	if ping >= pingLimit then
		DropPlayer(source, "Votre ping est trop haut : (Limit: " .. pingLimit .. " Votre ping : " .. ping .. ")")
	end
end)

--carwash
price = 10 -- you may edit this to your liking. if "enableprice = false" ignore this one

RegisterServerEvent('carwash:checkmoney')
AddEventHandler('carwash:checkmoney', function ()
local sourceValue = source
local discord = exports.bf:GetDiscordFromSource(sourceValue)
print("CHECKE MONETY")
MySQL.ready(function ()
  MySQL.Async.fetchAll('select liquid from players where discord = @discord',
      {['discord'] =  discord},
  function(res)
    if res[1] and res[1].liquid >= price then
      MySQL.Async.fetchAll('UPDATE players set liquid=liquid-@amount where discord = @discord',
      {['discord'] =  discord,
      ['amount'] = price},
      function(res)
				TriggerClientEvent('carwash:success', sourceValue, price)
      end)
    else
      print(discord)
      TriggerClientEvent('carwash:notenoughmoney', sourceValue)
    end
      end)
    end)
end)

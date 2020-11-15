price = 10 -- you may edit this to your liking. if "enableprice = false" ignore this one

--DO-NOT-EDIT-BELLOW-THIS-LINE--

RegisterServerEvent('carwash:checkmoney')
AddEventHandler('carwash:checkmoney', function ()
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
  MySQL.Async.fetchAll('select liquid from players where fivem = @fivem',
      {['fivem'] =  discord},
  function(res)
    if res[1] and res[1].liquid >= price then
      MySQL.Async.fetchAll('UPDATE players set liquid=liquid-@amount where fivem = @fivem',
      {['fivem'] =  discord,
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

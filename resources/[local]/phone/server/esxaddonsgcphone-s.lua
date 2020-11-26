
ESX                       = nil
local PhoneNumbers        = {}

function notifyAlertSMS (number, alert, listSrc)
  if PhoneNumbers[number] ~= nil then
    local messText = alert.message
    if (messText == '%posrealtime%') then
      messText = 'GPS Live Position'
    end
    local mess = 'From #' .. alert.numero  .. ' : ' .. messText
    if alert.coords ~= nil then
      mess = mess .. ' ' .. alert.coords.x .. ', ' .. alert.coords.y 
    end
    for k, _ in pairs(listSrc) do
      local targetPlayer = tonumber(k)
      getPhoneNumber(targetPlayer, function (n)
        if n ~= nil then
          TriggerEvent('phone:_internalAddMessage', number, n, mess, 0, function (smsMess)
            TriggerClientEvent('phone:receiveMessage', targetPlayer, smsMess)
            if alert.source then
              if messText == 'GPS Live Position' then
                local duration = Config.ShareRealtimeGPSJobTimer * 60000 --Config Time (Default = 10 minutes)
                TriggerClientEvent('phone:receiveLivePosition', targetPlayer, alert.source, duration, alert.numero, 1)
              end
           end
          end)
        end
      end)
    end
  end
end

AddEventHandler('phone:registerNumber', function(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
  print('= INFO = Registered number for ' .. number .. ' => ' .. type)
	local hideNumber    = hideNumber    or false
	local hidePosIfAnon = hidePosIfAnon or false

	PhoneNumbers[number] = {
		type          = type,
    sources       = {},
    alerts        = {}
	}
end)


AddEventHandler('esx:setJob', function(source, job, lastJob)
  if PhoneNumbers[lastJob.name] ~= nil then
    TriggerEvent('esx_addons_phone:removeSource', lastJob.name, source)
  end

  if PhoneNumbers[job.name] ~= nil then
    TriggerEvent('esx_addons_phone:addSource', job.name, source)
  end
end)

AddEventHandler('esx_addons_phone:addSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = true
end)

AddEventHandler('esx_addons_phone:removeSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = nil
end)

RegisterServerEvent('phone:sendMessage')
AddEventHandler('phone:sendMessage', function(number, message)
    local sourcePlayer = tonumber(source)
    if PhoneNumbers[number] ~= nil then
      getPhoneNumber(source, function (phone) 
        notifyAlertSMS(number, {
          message = message,
          numero = phone,
          source = sourcePlayer
        }, PhoneNumbers[number].sources)
      end)
    end
end)

RegisterServerEvent('esx_addons_phone:startCall')
AddEventHandler('esx_addons_phone:startCall', function (number, message, coords)
  local sourcePlayer = tonumber(source)
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
        source = sourcePlayer
      }, PhoneNumbers[number].sources)
    end)
  else
    print('= WARNING = Trying to call an unregistered service => numero : ' .. number)
  end
end)


AddEventHandler('esx:playerLoaded', function(source)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)

    local phoneNumber = result[1].phone_number
    xPlayer.set('phoneNumber', phoneNumber)

    if PhoneNumbers[xPlayer.job.name] ~= nil then
      TriggerEvent('esx_addons_phone:addSource', xPlayer.job.name, source)
    end
  end)

end)


AddEventHandler('esx:playerDropped', function(source)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if PhoneNumbers[xPlayer.job.name] ~= nil then
    TriggerEvent('esx_addons_phone:removeSource', xPlayer.job.name, source)
  end
end)


function getPhoneNumber (source, callback) 
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer == nil then
    callback(nil)
  end
  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)
    callback(result[1].phone_number)
  end)
end



RegisterServerEvent('phone:send')
AddEventHandler('phone:send', function(number, message, _, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
      }, PhoneNumbers[number].sources)
    end)
  else
    -- print('phone:send | Appels sur un service non enregistre => numero : ' .. number)
  end
end)
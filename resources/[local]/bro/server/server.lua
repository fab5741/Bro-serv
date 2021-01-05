-- Ping kicker
-- Ping Limit
local pingLimit = 1000

RegisterServerEvent("bro:ping:check")
AddEventHandler("bro:ping:check", function()
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
local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
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
      TriggerClientEvent('carwash:notenoughmoney', sourceValue)
    end
      end)
    end)
end)

-- weather

------------------ change this -------------------

admins = {
  'discord:150331120255238144',
  'discord:149499775727697920',
  'discord:158325306980171776'
}

-- Set this to false if you don't want the weather to change automatically every 10 minutes.
DynamicWeather = true

--------------------------------------------------
debugprint = false -- don't touch this unless you know what you're doing or you're being asked by Vespura to turn this on.
--------------------------------------------------
-------------------- DON'T CHANGE THIS --------------------
AvailableWeatherTypes = {
  'EXTRASUNNY', 
  'CLEAR', 
  'NEUTRAL', 
  'SMOG', 
  'FOGGY', 
  'OVERCAST', 
  'CLOUDS', 
  'CLEARING', 
  'RAIN', 
  'THUNDER', 
  'SNOW', 
  'BLIZZARD', 
  'SNOWLIGHT', 
  'XMAS', 
  'HALLOWEEN',
}
CurrentWeather = "EXTRASUNNY"
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = 120

RegisterServerEvent('bro:requestSync')
AddEventHandler('bro:requestSync', function()
  TriggerClientEvent('bro:updateWeather', -1, CurrentWeather, blackout)
  TriggerClientEvent('bro:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

function isAllowedToChange(player)
  local allowed = false
  for i,id in ipairs(admins) do
      for x,pid in ipairs(GetPlayerIdentifiers(player)) do
          if debugprint then print('admin id: ' .. id .. '\nplayer id:' .. pid) end
          if string.lower(pid) == string.lower(id) then
              allowed = true
          end
      end
  end
  return allowed
end

RegisterCommand('freezetime', function(source, args)
  if source ~= 0 then
      if isAllowedToChange(source) then
          freezeTime = not freezeTime
          if freezeTime then
              TriggerClientEvent('bf:Notification', source, 'Time is now ~b~frozen~s~.')
          else
              TriggerClientEvent('bf:Notification', source, 'Time is ~y~no longer frozen~s~.')
          end
      else
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You are not allowed to use this command.')
      end
  else
      freezeTime = not freezeTime
      if freezeTime then
          print("Time is now frozen.")
      else
          print("Time is no longer frozen.")
      end
  end
end)

RegisterCommand('freezeweather', function(source, args)
  if source ~= 0 then
      if isAllowedToChange(source) then
          DynamicWeather = not DynamicWeather
          if not DynamicWeather then
              TriggerClientEvent('bf:Notification', source, 'Dynamic weather changes are now ~r~disabled~s~.')
          else
              TriggerClientEvent('bf:Notification', source, 'Dynamic weather changes are now ~b~enabled~s~.')
          end
      else
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You are not allowed to use this command.')
      end
  else
      DynamicWeather = not DynamicWeather
      if not DynamicWeather then
          print("Weather is now frozen.")
      else
          print("Weather is no longer frozen.")
      end
  end
end)

RegisterCommand('weather', function(source, args)
  if source == 0 then
      local validWeatherType = false
      if args[1] == nil then
          print("Invalid syntax, correct syntax is: /weather <weathertype> ")
          return
      else
          for i,wtype in ipairs(AvailableWeatherTypes) do
              if wtype == string.upper(args[1]) then
                  validWeatherType = true
              end
          end
          if validWeatherType then
              print("Weather has been updated.")
              CurrentWeather = string.upper(args[1])
              newWeatherTimer = 10
              TriggerEvent('bro:requestSync')
          else
              print("Invalid weather type, valid weather types are: \nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ")
          end
      end
  else
      if isAllowedToChange(source) then
          local validWeatherType = false
          if args[1] == nil then
              TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax, use ^0/weather <weatherType> ^1instead!')
          else
              for i,wtype in ipairs(AvailableWeatherTypes) do
                  if wtype == string.upper(args[1]) then
                      validWeatherType = true
                  end
              end
              if validWeatherType then
                  TriggerClientEvent('bf:Notification', source, 'Weather will change to: ~y~' .. string.lower(args[1]) .. "~s~.")
                  CurrentWeather = string.upper(args[1])
                  newWeatherTimer = 10
                  TriggerEvent('bro:requestSync')
              else
                  TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid weather type, valid weather types are: ^0\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ')
              end
          end
      else
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
          print('Access for command /weather denied.')
      end
  end
end, false)

RegisterCommand('blackout', function(source)
  if source == 0 then
      blackout = not blackout
      if blackout then
          print("Blackout is now enabled.")
      else
          print("Blackout is now disabled.")
      end
  else
      if isAllowedToChange(source) then
          blackout = not blackout
          if blackout then
              TriggerClientEvent('bf:Notification', source, 'Blackout is now ~b~enabled~s~.')
          else
              TriggerClientEvent('bf:Notification', source, 'Blackout is now ~r~disabled~s~.')
          end
          TriggerEvent('bro:requestSync')
      end
  end
end)

RegisterCommand('morning', function(source)
  if source == 0 then
      print("For console, use the \"/time <hh> <mm>\" command instead!")
      return
  end
  if isAllowedToChange(source) then
      ShiftToMinute(0)
      ShiftToHour(9)
      TriggerClientEvent('bf:Notification', source, 'Time set to ~y~morning~s~.')
      TriggerEvent('bro:requestSync')
  end
end)
RegisterCommand('noon', function(source)
  if source == 0 then
      print("For console, use the \"/time <hh> <mm>\" command instead!")
      return
  end
  if isAllowedToChange(source) then
      ShiftToMinute(0)
      ShiftToHour(12)
      TriggerClientEvent('bf:Notification', source, 'Time set to ~y~noon~s~.')
      TriggerEvent('bro:requestSync')
  end
end)
RegisterCommand('evening', function(source)
  if source == 0 then
      print("For console, use the \"/time <hh> <mm>\" command instead!")
      return
  end
  if isAllowedToChange(source) then
      ShiftToMinute(0)
      ShiftToHour(18)
      TriggerClientEvent('bf:Notification', source, 'Time set to ~y~evening~s~.')
      TriggerEvent('bro:requestSync')
  end
end)
RegisterCommand('night', function(source)
  if source == 0 then
      print("For console, use the \"/time <hh> <mm>\" command instead!")
      return
  end
  if isAllowedToChange(source) then
      ShiftToMinute(0)
      ShiftToHour(23)
      TriggerClientEvent('bf:Notification', source, 'Time set to ~y~night~s~.')
      TriggerEvent('bro:requestSync')
  end
end)

function ShiftToMinute(minute)
  timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
  timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

RegisterCommand('time', function(source, args, rawCommand)
  if source == 0 then
      if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
          local argh = tonumber(args[1])
          local argm = tonumber(args[2])
          if argh < 24 then
              ShiftToHour(argh)
          else
              ShiftToHour(0)
          end
          if argm < 60 then
              ShiftToMinute(argm)
          else
              ShiftToMinute(0)
          end
          print("Time has changed to " .. argh .. ":" .. argm .. ".")
          TriggerEvent('bro:requestSync')
      else
          print("Invalid syntax, correct syntax is: time <hour> <minute> !")
      end
  elseif source ~= 0 then
      if isAllowedToChange(source) then
          if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
              local argh = tonumber(args[1])
              local argm = tonumber(args[2])
              if argh < 24 then
                  ShiftToHour(argh)
              else
                  ShiftToHour(0)
              end
              if argm < 60 then
                  ShiftToMinute(argm)
              else
                  ShiftToMinute(0)
              end
              local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
      local minute = math.floor((baseTime+timeOffset)%60)
              if minute < 10 then
                  newtime = newtime .. "0" .. minute
              else
                  newtime = newtime .. minute
              end
              TriggerClientEvent('bf:Notification', source, 'Time was changed to: ~y~' .. newtime .. "~s~!")
              TriggerEvent('bro:requestSync')
          else
              TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax. Use ^0/time <hour> <minute> ^1instead!')
          end
      else
          TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
          print('Access for command /time denied.')
      end
  end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      local newBaseTime = os.time(os.date("!*t"))/2 + 360
      if freezeTime then
          timeOffset = timeOffset + baseTime - newBaseTime			
      end
      baseTime = newBaseTime
  end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(5000)
      TriggerClientEvent('bro:updateTime', -1, baseTime, timeOffset, freezeTime)
  end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(120000*60)
      TriggerClientEvent('bro:updateWeather', -1, CurrentWeather, blackout)
  end
end)

Citizen.CreateThread(function()
  while true do
      newWeatherTimer = newWeatherTimer - 1
      Citizen.Wait(60000)
      if newWeatherTimer == 0 then
          if DynamicWeather then
              NextWeatherStage()
          end
          newWeatherTimer = 60
      end
  end
end)

function NextWeatherStage()
  if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
      local new = math.random(1,2)
      if new == 1 then
          CurrentWeather = "CLEARING"
      else
          CurrentWeather = "OVERCAST"
      end
  elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
      local new = math.random(1,6)
      if new == 1 then
          if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
      elseif new == 2 then
          CurrentWeather = "CLOUDS"
      elseif new == 3 then
          CurrentWeather = "CLEAR"
      elseif new == 4 then
          CurrentWeather = "EXTRASUNNY"
      elseif new == 5 then
          CurrentWeather = "SMOG"
      else
          CurrentWeather = "FOGGY"
      end
  elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
      CurrentWeather = "CLEARING"
  elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
      CurrentWeather = "CLEAR"
  end
  TriggerEvent("bro:requestSync")
end

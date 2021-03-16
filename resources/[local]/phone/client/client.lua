--====================================================================================
-- #Author: Jonathan D @ Gannon
-- Modified by:
-- BTNGaming 
-- Chip
-- DmACK (f.sanllehiromero@uandresbello.edu)
--====================================================================================
 
-- Configuration
local KeyToucheCloseEvent = {
  { code = 172, event = 'ArrowUp' },
  { code = 173, event = 'ArrowDown' },
  { code = 174, event = 'ArrowLeft' },
  { code = 175, event = 'ArrowRight' },
  { code = 176, event = 'Enter' },
  { code = 177, event = 'Backspace' },
}

local menuIsOpen = false
local contacts = {}
local messages = {}
local gpsBlips = {}
local myPhoneNumber = ''
local isDead = false
local USE_RTC = false
local useMouse = false
local ignoreFocus = false
local takePhoto = false
local hasFocus = false
local TokoVoipID = nil

local PhoneInCall = {}
local currentPlaySound = false
local soundDistanceMax = 8.0

--====================================================================================
--  
--====================================================================================
Citizen.CreateThread(function()
  TriggerServerEvent('phone:allUpdate')
  while true do
    Citizen.Wait(0)
    if not menuIsOpen and isDead then
      DisableControlAction(0, 288, true)
    end
    if takePhoto ~= true then
      if IsControlJustPressed(1, Config.KeyOpenClose) then -- On key press, will open the phone
          TooglePhone()
      end
      if menuIsOpen == true then
        for _, value in ipairs(KeyToucheCloseEvent) do
          if IsControlJustPressed(1, value.code) then
            SendNUIMessage({keyUp = value.event})
          end
        end
        if useMouse == true and hasFocus == ignoreFocus then
          local nuiFocus = not hasFocus
          SetNuiFocus(nuiFocus, nuiFocus)
          hasFocus = nuiFocus
        elseif useMouse == false and hasFocus == true then
          SetNuiFocus(false, false)
          hasFocus = false
        end
      else
        if hasFocus == true then
          SetNuiFocus(false, false)
          hasFocus = false
        end
      end
    end
  end
end)

--====================================================================================
-- GPS Blips
--====================================================================================
function styleBlip(blip, type, number, player)
  local blipLabel = '#' .. number
  local blipLabelPrefix = 'GPS Téléphone : '

  -- [[ type 0 ]] --
  if (type == 0) then
    local isContact = false
    for k,contact in pairs(contacts) do
      if contact.number == number then
        blipLabel = contacts[k].display .. ' (' .. blipLabel .. ')'
        isContact = true
        break
      end
    end

    ShowCrewIndicatorOnBlip(blip, true)
    if (isContact == true) then
      SetBlipColour(blip, 2)
    else
      SetBlipColour(blip, 4)
    end
  end

  -- [[ type 1 ]] --
  if (type == 1) then
    blipLabelPrefix = 'Emergency SMS Sender Location: '
    ShowCrewIndicatorOnBlip(blip, true)
    SetBlipColour(blip, 5)
  end

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(blipLabelPrefix .. blipLabel)
  EndTextCommandSetBlipName(blip)

  SetBlipSecondaryColour(blip, 255, 0, 0)
  SetBlipScale(blip, 0.9)
end

local checkRate = 5000 -- every 5 seconds
local gpsActive = false
RegisterNetEvent('phone:receiveLivePosition')
AddEventHandler('phone:receiveLivePosition', function(sourcePlayerServerId, timeoutInMilliseconds, sourceNumber, type)
  if (sourcePlayerServerId ~= nil and sourceNumber ~= nil) then
    if (entityBlip ~= nil) then
      RemoveBlip(entityBlip)
      entityBlip = nil
    end
    local sourcePlayer = GetPlayerFromServerId(sourcePlayerServerId)
    local sourcePed = GetPlayerPed(sourcePlayer)
    entityBlip = AddBlipForEntity(sourcePed)
    styleBlip(entityBlip, type, sourceNumber, sourcePlayer)
    gpsActive = true
    Citizen.SetTimeout(timeoutInMilliseconds, function()
      SetBlipFlashes(entityBlip, true)
      Citizen.Wait(10000)
      RemoveBlip(entityBlip)
      entityBlip = nil
      gpsActive = false
    end)
    Citizen.CreateThread(function()
      while Config.ItemRequired and gpsActive do
        Citizen.Wait(checkRate)
        hasPhone(function (hasPhone)
          if hasPhone == false then
            SetBlipFlashes(entityBlip, true)
            Citizen.Wait(2000) -- 2 Seconds
            RemoveBlip(entityBlip)
            entityBlip = nil
            gpsActive = false
          end
        end)
      end
    end)
  end
end)

--====================================================================================
--  Activate or Deactivate an application (appName => config.json)
--====================================================================================
RegisterNetEvent('phone:setEnableApp')
AddEventHandler('phone:setEnableApp', function(appName, enable)
  SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)
 
--====================================================================================
--  Events
--====================================================================================
RegisterNetEvent("phone:myPhoneNumber")
AddEventHandler("phone:myPhoneNumber", function(_myPhoneNumber)
  myPhoneNumber = _myPhoneNumber
  SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)

RegisterNetEvent("phone:contactList")
AddEventHandler("phone:contactList", function(_contacts)
  SendNUIMessage({event = 'updateContacts', contacts = _contacts})
  contacts = _contacts
end)

RegisterNetEvent("phone:allMessage")
AddEventHandler("phone:allMessage", function(allmessages)
  SendNUIMessage({event = 'updateMessages', messages = allmessages})
  messages = allmessages
end)


RegisterNetEvent("phone:receiveMessage")
AddEventHandler("phone:receiveMessage", function(message)
  -- SendNUIMessage({event = 'updateMessages', messages = messages})
  SendNUIMessage({event = 'newMessage', message = message})
  table.insert(messages, message)
  if message.owner == 0 then
    local text = 'Vous avez reçu un SMS'
    if Config.ShowNumberNotification == true then
      text = message.transmitter
      for _,contact in pairs(contacts) do
        if contact.number == message.transmitter then
          text = contact.display
          break
        end
      end
    end
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
  end
end)

--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num) 
    TriggerServerEvent('phone:addContact', display, num)
end

function deleteContact(num) 
    TriggerServerEvent('phone:deleteContact', num)
end
--====================================================================================
--  Function client | Messages
--====================================================================================
function sendMessage(num, message)
  print(message)
  TriggerServerEvent('phone:sendMessage', num, message)
end

function deleteMessage(msgId)
  TriggerServerEvent('phone:deleteMessage', msgId)
  for k, v in ipairs(messages) do 
    if v.id == msgId then
      table.remove(messages, k)
      SendNUIMessage({event = 'updateMessages', messages = messages})
      return
    end
  end
end

function deleteMessageContact(num)
  TriggerServerEvent('phone:deleteMessageNumber', num)
end

function deleteAllMessage()
  TriggerServerEvent('phone:deleteAllMessage')
end

function setReadMessageNumber(num)
  TriggerServerEvent('phone:setReadMessageNumber', num)
  for k, v in ipairs(messages) do 
    if v.transmitter == num then
      v.isRead = 1
    end
  end
end

function requestAllMessages()
  TriggerServerEvent('phone:requestAllMessages')
end

function requestAllContact()
  TriggerServerEvent('phone:requestAllContact')
end



--====================================================================================
--  Function client | Appels
--====================================================================================
local aminCall = false
local inCall = false

RegisterNetEvent("phone:waitingCall")
AddEventHandler("phone:waitingCall", function(infoCall, initiator)
  SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
  if initiator == true then
    PhonePlayCall()
    if menuIsOpen == false then
      TooglePhone()
    end
  end
end)

RegisterNetEvent("phone:acceptCall")
AddEventHandler("phone:acceptCall", function(infoCall, initiator)
  if inCall == false and USE_RTC == false then
    inCall = true
    if Config.UseMumbleVoIP then
      exports["mumble-voip"]:SetCallChannel(infoCall.id+1)
    elseif Config.UseTokoVoIP then
      exports.tokovoip_script:addPlayerToRadio(infoCall.id + 120)
      TokoVoipID = infoCall.id + 120
    else
    NetworkSetVoiceChannel(infoCall.id + 1)
    NetworkSetTalkerProximity(0.0)
  end
end
  if menuIsOpen == false then 
    TooglePhone()
  end
  PhonePlayCall()
  SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
end)

RegisterNetEvent("phone:rejectCall")
AddEventHandler("phone:rejectCall", function(infoCall)
  if inCall == true then
    inCall = false
    if Config.UseMumbleVoIP then
      exports["mumble-voip"]:SetCallChannel(0)
    elseif Config.UseTokoVoIP then
      exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
      TokoVoipID = nil
    else
      Citizen.InvokeNative(0xE036A705F989E049)
      NetworkSetTalkerProximity(2.5)
    end
  end
  --PhonePlayText()
  SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
end)


RegisterNetEvent("phone:historiqueCall")
AddEventHandler("phone:historiqueCall", function(historique)
  SendNUIMessage({event = 'historiqueCall', historique = historique})
end)


function startCall (phone_number, rtcOffer, extraData)
  if rtcOffer == nil then
    rtcOffer = ''
  end
  TriggerServerEvent('phone:startCall', phone_number, rtcOffer, extraData)
end

function acceptCall (infoCall, rtcAnswer)
  TriggerServerEvent('phone:acceptCall', infoCall, rtcAnswer)
end

function rejectCall(infoCall)
  TriggerServerEvent('phone:rejectCall', infoCall)
end

function ignoreCall(infoCall)
  TriggerServerEvent('phone:ignoreCall', infoCall)
end

function requestHistoriqueCall() 
  TriggerServerEvent('phone:getHistoriqueCall')
end

function appelsDeleteHistorique (num)
  TriggerServerEvent('phone:appelsDeleteHistorique', num)
end

function appelsDeleteAllHistorique ()
  TriggerServerEvent('phone:appelsDeleteAllHistorique')
end
  

--====================================================================================
--  Event NUI - Appels
--====================================================================================

RegisterNUICallback('startCall', function (data, cb)
  startCall(data.numero, data.rtcOffer, data.extraData)
  cb()
end)

RegisterNUICallback('acceptCall', function (data, cb)
  acceptCall(data.infoCall, data.rtcAnswer)
  cb()
end)
RegisterNUICallback('rejectCall', function (data, cb)
  rejectCall(data.infoCall)
  cb()
end)

RegisterNUICallback('ignoreCall', function (data, cb)
  ignoreCall(data.infoCall)
  cb()
end)

RegisterNUICallback('notififyUseRTC', function (use, cb)
  USE_RTC = use
  if USE_RTC == true and inCall == true then
    inCall = false
    Citizen.InvokeNative(0xE036A705F989E049)
    if Config.UseTokoVoIP then
      exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
      TokoVoipID = nil
    else
      NetworkSetTalkerProximity(2.5)
    end
  end
  cb()
end)


RegisterNUICallback('onCandidates', function (data, cb)
  TriggerServerEvent('phone:candidates', data.id, data.candidates)
  cb()
end)

RegisterNetEvent("phone:candidates")
AddEventHandler("phone:candidates", function(candidates)
  SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
end)



RegisterNetEvent('phone:autoCall')
AddEventHandler('phone:autoCall', function(number, extraData)
  if number ~= nil then
    SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
  end
end)

RegisterNetEvent('phone:autoCallNumber')
AddEventHandler('phone:autoCallNumber', function(data)
  TriggerEvent('phone:autoCall', data.number)
end)

RegisterNetEvent('phone:autoAcceptCall')
AddEventHandler('phone:autoAcceptCall', function(infoCall)
  SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall})
end)

--====================================================================================
--  Management of NUI events
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)
  print(data)
  cb()
end)
RegisterNUICallback('focus', function(data, cb)
  cb()
end)
RegisterNUICallback('blur', function(data, cb)
  cb()
end)
RegisterNUICallback('reponseText', function(data, cb)
  local limit = data.limit or 255
  local text = data.text or ''
  local text = exports.bro_core:OpenTextInput()
  if text ~= nil then
    cb(json.encode({text = tostring(text)}))
  end
end)
--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)
RegisterNUICallback('sendMessage', function(data, cb)
  if data.message == '%pos%' then
    local myPos = GetEntityCoords(PlayerPedId())
    data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
    data.gpsData = GetEntityCoords(PlayerPedId())
  end
  TriggerServerEvent('phone:sendMessage', data.phoneNumber, data.message, data.gpsData)
end)
RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb()
end)
RegisterNUICallback('deleteMessageNumber', function (data, cb)
  deleteMessageContact(data.number)
  cb()
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)
  deleteAllMessage()
  cb()
end)
RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb()
end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb) 
  TriggerServerEvent('phone:addContact', data.display, data.phoneNumber)
end)
RegisterNUICallback('updateContact', function(data, cb)
  TriggerServerEvent('phone:updateContact', data.id, data.display, data.phoneNumber)
end)
RegisterNUICallback('deleteContact', function(data, cb)
  TriggerServerEvent('phone:deleteContact', data.id)
end)
RegisterNUICallback('getContacts', function(data, cb)
  cb(json.encode(contacts))
end)
RegisterNUICallback('setGPS', function(data, cb)
  SetNewWaypoint(tonumber(data.x), tonumber(data.y))
  cb()
end)

-- Add security for event (leuit#0100)
RegisterNUICallback('callEvent', function(data, cb)
  local eventName = data.eventName or ''
  if string.match(eventName, 'phone') then
    if data.data ~= nil then 
      TriggerEvent(data.eventName, data.data)
    else
      TriggerEvent(data.eventName)
    end
  else
    print('Event not allowed')
  end
  cb()
end)
RegisterNUICallback('useMouse', function(um, cb)
  useMouse = um
end)
RegisterNUICallback('deleteALL', function(data, cb)
  TriggerServerEvent('phone:deleteALL')
  cb()
end)

function TooglePhone()
  if Config.ItemRequired == true then
    hasPhone(function (hasPhone)
      if hasPhone == true then
        menuIsOpen = not menuIsOpen
        SendNUIMessage({show = menuIsOpen})
        if menuIsOpen == true then 
          PhonePlayIn()
          TriggerEvent('phone:setMenuStatus', true)
        else
          PhonePlayOut()
          TriggerEvent('phone:setMenuStatus', false)
        end
      elseif hasPhone == false and Config.NoPhoneWarning == true then
        NoPhone()
      end
    end)
  elseif Config.ItemRequired == false then
    menuIsOpen = not menuIsOpen
    SendNUIMessage({show = menuIsOpen})
    if menuIsOpen == true then 
      PhonePlayIn()
      TriggerEvent('phone:setMenuStatus', true)
    else
      PhonePlayOut()
      TriggerEvent('phone:setMenuStatus', false)
    end
  end
end

RegisterNUICallback('faketakePhoto', function(data, cb)
  menuIsOpen = false
  TriggerEvent('phone:setMenuStatus', false)
  SendNUIMessage({show = false})
  cb()
  TriggerEvent('camera:open')
end)

RegisterNUICallback('closePhone', function(data, cb)
  menuIsOpen = false
  TriggerEvent('phone:setMenuStatus', false)
  SendNUIMessage({show = false})
  PhonePlayOut()
  cb()
end)

----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
  appelsDeleteHistorique(data.numero)
  cb()
end)
RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
  appelsDeleteAllHistorique(data.infoCall)
  cb()
end)

----------------------------------
---------- GESTION VIA WEBRTC ----
----------------------------------
AddEventHandler('onClientResourceStart', function(res)
  DoScreenFadeIn(300)
  if res == "phone" then
      TriggerServerEvent('phone:allUpdate')
      -- Try again in 2 minutes (Recovers bugged phone numbers)
      Citizen.Wait(120000)
      TriggerServerEvent('phone:allUpdate')
  end
end)

RegisterNUICallback('setIgnoreFocus', function (data, cb)
  ignoreFocus = data.ignoreFocus
  cb()
end)

RegisterNUICallback('takePhoto', function(data, cb)
	CreateMobilePhone(1)
  CellCamActivate(true, true)
  takePhoto = true
  Citizen.Wait(0)
  if hasFocus == true then
    SetNuiFocus(false, false)
    hasFocus = false
  end
	while takePhoto do
    Citizen.Wait(0)

		if IsControlJustPressed(1, 27) then -- Toogle Mode
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
    elseif IsControlJustPressed(1, 177) then -- CANCEL
      DestroyMobilePhone()
      CellCamActivate(false, false)
      cb(json.encode({ url = nil }))
      takePhoto = false
      break
    elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
			exports['screenshot-basic']:requestScreenshotUpload(data.url, data.field, function(data)
        local resp = json.decode(data)
        DestroyMobilePhone()
        CellCamActivate(false, false)
        --cb(json.encode({ url = resp.files[1].url }))   
        cb(json.encode({ url = resp.url }))
      end)
      takePhoto = false
		end
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(19)
    HideHudAndRadarThisFrame()
  end
  Citizen.Wait(1000)
  PhonePlayAnim('text', false, true)
end)


  TriggerServerEvent("phone:playerLoaded")

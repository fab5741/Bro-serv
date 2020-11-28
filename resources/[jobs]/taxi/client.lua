config ={}

config.JobLocations = {
  vector3(224.47973632812,-1394.4791259766,30.148679733276),
  vector3(-223.17068481445,-1294.1179199219,30.891222000122),
  vector3(-223.17068481445,-1294.1179199219,30.891222000122),
  vector3(413.25640869141,-1614.6507568359,28.879640579224),
  vector3(20.660507202148,-1353.0402832031,28.918878555298),
  vector3(-218.69741821289,-899.73858642578,29.120832443237),
  vector3(-707.24938964844,-942.05078125,18.656518936157),
  vector3(-1176.4499511719,-823.99798583984,13.887656211853),
  vector3(-1482.63671875,-399.28475952148,37.757083892822),
  vector3(364.95983886719,-586.50189208984,28.697441101074),
  vector3(416.15151977539,-801.48742675781,28.95930480957),
  vector3(412.14434814453,-985.09240722656,29.005500793457),
  vector3(-62.740516662598,-1775.2906494141,28.549734115601),
  vector3(-622.19232177734,-918.11138916016,23.228982925415),
}

config.DrawDistance               = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
config.MinimumDistance            = 0 -- Minimum NPC job destination distance from the pickup in GTA units, a higher number prevents nearby destionations.


-- Settings
local enableTaxiGui = true -- Enables the GUI (Default: true)
local fareCost = 0.001 --(1.66 = $100 per minute) Cost per second
local costPerMile = 0.5
local initialFare = 1.0 -- the cost to start a fare

local testMode = true -- enables spawn car command

DecorRegister("fares", 1)
DecorRegister("miles", 1)
DecorRegister("meteractive", 2)
DecorRegister("initialFare", 1)
DecorRegister("costPerMile", 1)
DecorRegister("fareCost", 1)

-- NUI Variables
local inTaxi = false
local meterOpen = false
local meterActive = false

-- Open Gui and Focus NUI
function openGui()
  SendNUIMessage({openMeter = true})
end

-- Close Gui and disable NUI
function closeGui()
  SendNUIMessage({openMeter = false})
  meterOpen = false
end

function GetRandomWalkingNPC()
	local search = {}
	local peds   = exports.bf:GetPedsInAround({
    range = 100
 })
	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    if IsInTaxi() and GetPedInVehicleSeat(veh, -1) ~= ped then
      local ped = GetPlayerPed(-1)
      local veh = GetVehiclePedIsIn(ped, false)
      TriggerEvent('taxi:updatefare', veh)
      openGui()
      meterOpen = true
    end
    if meterActive and GetPedInVehicleSeat(veh, -1) == ped then
      local _fare = DecorGetFloat(veh, "fares")
      local _miles = DecorGetFloat(veh, "miles")
      local _fareCost = DecorGetFloat(veh, "fareCost")

      if _fareCost ~= 0 then
        DecorSetFloat(veh, "fares", _fare + _fareCost)
      else
        DecorSetFloat(veh, "fares", _fare + fareCost)
      end
      DecorSetFloat(veh, "miles", _miles + round(GetEntitySpeed(veh) * 0.000621371, 5))
      TriggerEvent('taxi:updatefare', veh)
    end
    if IsInTaxi() and not GetPedInVehicleSeat(veh, -1) == ped then
      TriggerEvent('taxi:updatefare', veh)
    end
  end
end)

-- If GUI setting turned on, listen for INPUT_PICKUP keypress
if enableTaxiGui then
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if(IsInTaxi()) then
        inTaxi = true
        local ped = GetPlayerPed(-1)
        local playerPed = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)
        if(IsInTaxi() and GetPedInVehicleSeat(veh, -1) == ped) then
          if IsControlJustReleased(0, 213)  then -- HOME
            TriggerEvent('taxi:toggleDisplay')
            Citizen.Wait(100)
          end
          if IsControlJustReleased(0, 311)  then -- K
            TriggerEvent('taxi:toggleHire')
            Citizen.Wait(100)
          end
          if IsControlJustReleased(0,7) then -- L
            TriggerEvent('taxi:resetMeter')
            Citizen.Wait(100)
          end

          --
          if CurrentCustomer == nil then
            if GetEntitySpeed(ped) > 0 and GetEntitySpeed(ped) < 50 then
              print("on cherche un npc")
              CurrentCustomer = GetRandomWalkingNPC()
              if CurrentCustomer ~= nil then
                CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

                SetBlipAsFriendly(CurrentCustomerBlip, true)
                SetBlipColour(CurrentCustomerBlip, 2)
                SetBlipCategory(CurrentCustomerBlip, 3)
                SetBlipRoute(CurrentCustomerBlip, true)

                SetEntityAsMissionEntity(CurrentCustomer, true, false)
                ClearPedTasksImmediately(CurrentCustomer)
                SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

                local standTime = GetRandomIntInRange(60000, 180000)
                TaskStandStill(CurrentCustomer, standTime)
                
                exports.bf:Notification('Client trouvé')
              end
            end
          else
            if IsPedFatallyInjured(CurrentCustomer) then
              exports.bf:Notification('Client inconscient')
    
              if DoesBlipExist(CurrentCustomerBlip) then
                RemoveBlip(CurrentCustomerBlip)
              end
    
              if DoesBlipExist(DestinationBlip) then
                RemoveBlip(DestinationBlip)
              end
    
              SetEntityAsMissionEntity(CurrentCustomer, false, true)
    
              CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
            end
    
            if IsPedInAnyVehicle(playerPed, false) then
              local vehicle          = GetVehiclePedIsIn(playerPed, false)
              local playerCoords     = GetEntityCoords(playerPed)
              local customerCoords   = GetEntityCoords(CurrentCustomer)
              local customerDistance = #(playerCoords - customerCoords)
    
              if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
                if CustomerEnteredVehicle then
                  local targetDistance = #(playerCoords - targetCoords)
    
                  if targetDistance <= 10.0 then
                    TaskLeaveVehicle(CurrentCustomer, vehicle, 0)
    
                    exports.bf:Notification('Arrivé à destination')

                    TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                    SetEntityAsMissionEntity(CurrentCustomer, false, true)
                    TriggerServerEvent('taxi:success')
                    RemoveBlip(DestinationBlip)
    
                    local scope = function(customer)
                      Wait(6000)
                        DeletePed(customer)
                    end
    
                    scope(CurrentCustomer)
    
                    CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
                  end
    
                  if targetCoords then
                    DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
                  end
                else
                  RemoveBlip(CurrentCustomerBlip)
                  CurrentCustomerBlip = nil
                  targetCoords = config.JobLocations[GetRandomIntInRange(1, #config.JobLocations)]
                  local distance = #(playerCoords - targetCoords)
                  while distance < config.MinimumDistance do
                    Citizen.Wait(5)
    
                    targetCoords = config.JobLocations[GetRandomIntInRange(1, #config.JobLocations)]
                    distance = #(playerCoords - targetCoords)
                  end
    
                  local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z))
                  local msg    = nil
    
                  if street[2] ~= 0 and street[2] ~= nil then
                    msg = string.format('Prenez moi pres de ', GetStreetNameFromHashKey(street[1]), GetStreetNameFromHashKey(street[2]))
                  else
                    msg = string.format('Amenez moi à', GetStreetNameFromHashKey(street[1]))
                  end
    
                  exports.bf:Notification(msg)
    
                  DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
    
                  BeginTextCommandSetBlipName('STRING')
               --   AddTextComponentSubstringPlayerName('Destination')
                  EndTextCommandSetBlipName(blip)
                  SetBlipRoute(DestinationBlip, true)
    
                  CustomerEnteredVehicle = true
                end
              else
                DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
    
                if not CustomerEnteredVehicle then
                  if customerDistance <= 40.0 then
    
                    if not IsNearCustomer then
                      exports.bf:Notification("Proche du client")
                      IsNearCustomer = true
                    end
    
                  end
    
                  if customerDistance <= 20.0 then
                    if not CustomerIsEnteringVehicle then
                      ClearPedTasksImmediately(CurrentCustomer)
    
                      local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
    
                      for i=maxSeats - 1, 0, -1 do
                        if IsVehicleSeatFree(vehicle, i) then
                          freeSeat = i
                          break
                        end
                      end
    
                      if freeSeat then
                        TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
                        CustomerIsEnteringVehicle = true
                      end
                    end
                  end
                end
              end
            else
              exports.bf:Notification("Retournez à votre vehicule")
            end
        end
      end
    else
        if(meterOpen) then
          closeGui()
        end
        meterOpen = false
      end
    end
  end)
end

function round(num, numDecimalPlaces)
  local mult = 5^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNetEvent('taxi:toggleDisplay')
AddEventHandler('taxi:toggleDisplay', function()
  local ped = GetPlayerPed(-1)
  local veh = GetVehiclePedIsIn(ped, false)
  if(IsInTaxi() and GetPedInVehicleSeat(veh, -1) == ped) then
    if meterOpen then
      closeGui()
      meterOpen = false
    else
      local _fare = DecorGetFloat(veh, "fares")
      if _fare < initialFare then
        DecorSetFloat(veh, "fares", initialFare)
      end
      TriggerEvent('taxi:updatefare', veh)
      openGui()
      meterOpen = true
    end
  end
end)

RegisterNetEvent('taxi:toggleHire')
AddEventHandler('taxi:toggleHire', function()
  local ped = GetPlayerPed(-1)
  local veh = GetVehiclePedIsIn(ped, false)
  if(IsInTaxi() and GetPedInVehicleSeat(veh, -1) == ped) then
    if meterActive then
      SendNUIMessage({meterActive = false})
      meterActive = false
      DecorSetBool(veh, "meteractive", false)
      Citizen.Trace("Trigger OFF")
    else
      SendNUIMessage({meterActive = true})
      meterActive = true
      DecorSetBool(veh, "meteractive", true)
      Citizen.Trace("Trigger ON")
    end
  end
end)

RegisterNetEvent('taxi:resetMeter')
AddEventHandler('taxi:resetMeter', function()
  local ped = GetPlayerPed(-1)
  local veh = GetVehiclePedIsIn(ped, false)
  if(IsInTaxi() and GetPedInVehicleSeat(veh, -1) == ped) then
    local _fare = DecorGetFloat(veh, "fares")
    local _miles = DecorGetFloat(veh, "miles")
    DecorSetFloat(veh, "initialFare", initialFare)
    DecorSetFloat(veh, "costPerMile", costPerMile)
    DecorSetFloat(veh, "fareCost", fareCost)
    DecorSetFloat(veh, "fares", DecorGetFloat(veh, "initialFare"))
    DecorSetFloat(veh, "miles", 0.0)
    TriggerEvent('taxi:updatefare', veh)
  end
end)

-- Check if player is in a vehicle
function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- Check if player is in a Taxi
function IsInTaxi()
  local ped = GetPlayerPed(-1)
  local veh = GetVehiclePedIsIn(ped, false)
  local model = GetEntityModel(veh)
  local displaytext = GetDisplayNameFromVehicleModel(model)
  local name = GetLabelText(displaytext)
  if (name == "Taxi") then
    return true
  else
    return false
  end
end

-- Send NUI message to update
RegisterNetEvent('taxi:updatefare')
AddEventHandler('taxi:updatefare', function(veh)
  local id = PlayerId()
  local playerName = GetPlayerName(id)
  local _fare = DecorGetFloat(veh, "fares")
  local _miles = DecorGetFloat(veh, "miles")
  local farecost = _fare + (_miles * DecorGetFloat(veh, "costPerMile"))


	SendNUIMessage({
		updateBalance = true,
		balance = string.format("%.2f", farecost),
    player = string.format("%.2f", _miles),
    meterActive = DecorGetBool(veh, "meteractive")
	})
end)
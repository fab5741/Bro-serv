function CreateTaxiPed(vehicle)
	local model = GetHashKey("a_m_y_stlat_01")

	if DoesEntityExist(vehicle) then
		if IsModelValid(model) then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(1)
			end

			local ped = CreatePedInsideVehicle(vehicle, 26, model, -1, true, false)
			SetAmbientVoiceName(ped, "A_M_M_EASTSA_02_LATINO_FULL_01")	
			SetBlockingOfNonTemporaryEvents(ped, true)
			SetEntityAsMissionEntity(ped, true, true)

			SetModelAsNoLongerNeeded(model)
			return ped
		end
	end
end

function CreateTaxi(x, y, z)
	local taxiModel = GetHashKey("taxi")

	if IsModelValid(taxiModel) and IsThisModelACar(taxiModel) then
        if not DoesEntityExist(taxiVeh) then
            RequestModel(taxiModel)
            while not HasModelLoaded(taxiModel) do
                Wait(1)
            end
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            local _, vector = GetNthClosestVehicleNode(x, y, z, math.random(5, 10), playerPos.x, playerPos.y, playerPos.z)
            -- GetClosestVehicleNodeWithHeading(x, y, z, outPosition, outHeading, nodeType, p6, p7)
            local sX, sY, sZ = table.unpack(vector)

            exports.bro_core:Notification("Le chauffeur arrive")
            PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
            Wait(2000)

            taxiVeh = CreateVehicle(taxiModel, sX, sY, sZ, 0, true, false)

            SetEntityAsMissionEntity(taxiVeh, true, true)
            SetVehicleEngineOn(taxiVeh, true, true, false)

            local blip = AddBlipForEntity(taxiVeh)
            SetBlipSprite(blip, 198)
            SetBlipFlashes(blip, true)
            SetBlipFlashTimer(blip, 5000)

            SetModelAsNoLongerNeeded(taxiModel)

            SetHornEnabled(taxiVeh, true)
            StartVehicleHorn(taxiVeh, 1000, GetHashKey("NORMAL"), false)

            return taxiVeh
        else
            exports.bro_core:Notification("Le chauffeur est occupé")
        end
	end	
end

function DeleteTaxi(vehicle, driver)
	if DoesEntityExist(vehicle) then
		if IsPedInVehicle(PlayerPedId(), vehicle, false) then
			TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
			Wait(2000)			
		end

		local blip = GetBlipFromEntity(vehicle)

		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end

		DeleteEntity(driver)
		DeleteEntity(vehicle)
	end

	if not DoesEntityExist(vehicle) and DoesEntityExist(driver) then
		DeleteEntity(driver)
	end
end


function getGroundZ(x, y, z)
	local result, groundZ = GetGroundZFor_3dCoord(x+0.0, y+0.0, z+0.0, Citizen.ReturnResultAnyway())
	return groundZ
  end
  


  
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
	  local peds   = exports.bro_core:GetPedsInAround({
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
  
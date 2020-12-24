local buttons = {}
local lockChanging = false

function clockIn(job)
	TriggerServerEvent("job:get:player", "job:add:uniform")
	TriggerServerEvent("job:clock", true, job)
	exports.bf:CloseMenu("lockers")
end
clockIn("lspd")

function clockOut(job)
	TriggerServerEvent("player:get", "job:remove:uniform")
	TriggerServerEvent("job:clock", false, job)
	exports.bf:CloseMenu("lockers")
end


RegisterNetEvent("job:add:uniform")

-- source is global here, don't add to function
AddEventHandler('job:add:uniform', function(job)
	local playerPed = GetPlayerPed(-1)
	coords = GetEntityCoords(GetPlayerPed(-1), true)
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	local prop_name = 'prop_cs_wrench'
	if lockChanging == false then
		local time = 4000
		TriggerEvent("bf:progressBar:create", time, "Changement en cours")
		lockChanging = true 
		Citizen.CreateThread(function ()
			FreezeEntityPosition(playerPed)
								
			local dict = "amb@world_human_gardener_plant@male@enter"
			local anim = "enter"
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(150)
			end
			TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

			Wait(time)
			lockChanging = false
			local skin = json.decode(job.skin)
			local clothes
			if skin.sex == 0 then
				clothes = config.jobs[job.name].clothes[job.grade].male
			else
				clothes = config.jobs[job.name].clothes[job.grade].female
			end
			TriggerEvent('skinchanger:loadClothes', skin, clothes)
		end)
	else 
		exports.bf:Notification("~r~Changement en cours")
	end

end)

RegisterNetEvent("job:remove:uniform")

-- source is global here, don't add to function
AddEventHandler('job:remove:uniform', function(skin)
	local playerPed = GetPlayerPed(-1)
	coords = GetEntityCoords(GetPlayerPed(-1), true)
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	local prop_name = 'prop_cs_wrench'
	if lockChanging == false then
		local time = 4000
		TriggerEvent("bf:progressBar:create", time, "Changement en cours")
		lockChanging = true 
		Citizen.CreateThread(function ()
			FreezeEntityPosition(playerPed)
								
			local dict = "amb@world_human_gardener_plant@male@enter"
			local anim = "enter"
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(150)
			end
			TaskPlayAnim(playerPed, dict, anim, 3.0, -1, time, flag, 0, false, false, false)

			Wait(time)
			lockChanging = false
			if skin.clothes ~= nil then
				TriggerEvent('skinchanger:loadClothes', json.decode(skin.skin), json.decode(skin.clothes))
			else
				TriggerEvent('skinchanger:loadSkin', json.decode(skin.skin))
			end
			TriggerServerEvent("job:breakService")
		end)
	else 
		exports.bf:Notification("~r~Changement en cours")
	end
end)
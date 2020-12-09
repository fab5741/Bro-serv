function GetPlayers()
    local players = {}

    for _, player in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(player) then
            table.insert(players, player)
        end
    end

    return players
end


function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

-- LSMS Revive people
function reviveClosestPlayer(closestPlayer)
	local closestPlayerPed, dist = GetClosestPlayer()

    if closestPlayerPed and IsPedDeadOrDying(closestPlayerPed, 1) and dist <=1 then
        local playerPed = PlayerPedId()
        local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
        exports.bf:Notification("Réanimation en cours")
        for i=1, 15 do
            Citizen.Wait(900)

            if i % 15 == 0 then
                exports.bf:Notification("Réanimation en cours "..i.."/15")
            end
			RequestAnimDict(lib)
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
        end
		TriggerServerEvent('job:lsms:revive', GetPlayerServerId(closestPlayerPed))
		exports.bf:CloseMenu("lsms")
    else
        exports.bf:Notification("Pas de joueur à portée")
    end
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
	--TriggerEvent('spawn:spawn')
end


-- LSPD menu function
function DoTraffic()
	Citizen.CreateThread(function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CAR_PARK_ATTENDANT", 0, false)
			Citizen.Wait(60000)
			ClearPedTasksImmediately(PlayerPedId())
			exports.bf:Notification("menu_doing_traffic_notification")
		else
			exports.bf:Notification(GetLabelText("PEN_EXITV"))
		end
	end)
end

function Note()
	Citizen.CreateThread(function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, false)
			Citizen.Wait(20000)
			ClearPedTasksImmediately(PlayerPedId())
		else
			exports.bf:Notification(GetLabelText("PEN_EXITV"))
		end
	end)
end

function StandBy()
	Citizen.CreateThread(function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_COP_IDLES", 0, true)
			Citizen.Wait(20000)
			ClearPedTasksImmediately(PlayerPedId())
		else
			exports.bf:Notification(GetLabelText("PEN_EXITV"))
		end
    end)
end

function StandBy2()
	Citizen.CreateThread(function()
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GUARD_STAND", 0, 1)
			Citizen.Wait(20000)
			ClearPedTasksImmediately(PlayerPedId())
		else
			exports.bf:Notification(GetLabelText("PEN_EXITV"))
		end
	end)
end

function CancelEmote()
	Citizen.CreateThread(function()
        ClearPedTasksImmediately(PlayerPedId())
    end)
end

function RemoveWeapons()
	local closestPlayer, dist = GetClosestPlayer()

    if closestPlayer and dist <=1 then
        TriggerServerEvent("job:removeWeapons", GetPlayerServerId(closestPlayer))
    else
        exports.bf:Notification("Pas de joueur à proximité")
    end
end

function ToggleCuff()
	local closestPlayer, dist = GetClosestPlayer()

    if closestPlayer and dist <=1 then
		TriggerServerEvent("job:cuffGranted", GetPlayerServerId(closestPlayer))
	else
		exports.bf:Notification("Pas de joueur à proximité")
	end
end

function Fines(amount)
	local closestPlayer, dist = GetClosestPlayer()

    if closestPlayer and dist <=1 then
		Citizen.Trace("Price : "..tonumber(amount))
		if(tonumber(amount) == -1) then
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8S", "", "", "", "", "", 20)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0);
				Wait(0);
			end
			if (GetOnscreenKeyboardResult()) then
				local res = tonumber(GetOnscreenKeyboardResult())
				if(res ~= nil and res ~= 0) then
					amount = tonumber(res)
				end
			end
			
			if(tonumber(amount) ~= -1) then
				TriggerServerEvent("job:finesGranted", GetPlayerServerId(closestPlayer), tonumber(amount))
			end
		else
			TriggerServerEvent("job:finesGranted", GetPlayerServerId(closestPlayer), tonumber(amount))
		end
	else
		exports.bf:Notification("Pas de joueur à proximité")
	end
end


function giveWeaponLicence()
	local closestPlayer, dist = GetClosestPlayer()

    if closestPlayer and dist <=1 then
		TriggerServerEvent("job:weapon:licence", closestPlayer, true)
	else
		exports.bf:Notification("Pas de joueur à proximité")
	end
end


function DropVehicle()
	Citizen.CreateThread(function()
		local pos = GetEntityCoords(PlayerPedId())
		local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
		if DoesEntityExist(vehicleHandle) and IsEntityAVehicle(vehicleHandle) then
			DeleteEntity(vehicleHandle)
		else
			exports.bf:Notification("no_veh_near_ped")
		end
	end)
end

function SpawnSpikesStripe()
	if IsPedInAnyPoliceVehicle(PlayerPedId()) then
		local modelHash = GetHashKey("P_ld_stinger_s")
		local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)	
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(currentVeh, 0.0, -5.2, -0.25))

		RequestScriptAudioBank("BIG_SCORE_HIJACK_01", true)
		Citizen.Wait(500)

		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
		end

		if HasModelLoaded(modelHash) then
			SpikeObject = CreateObject(modelHash, x, y, z, true, false, true)
			SetEntityNoCollisionEntity(SpikeObject, PlayerPedId(), 1)
			SetEntityDynamic(SpikeObject, false)
			ActivatePhysics(SpikeObject)

			if DoesEntityExist(SpikeObject) then			
				local height = GetEntityHeightAboveGround(SpikeObject)

				SetEntityCoords(SpikeObject, x, y, z - height + 0.05)
				SetEntityHeading(SpikeObject, GetEntityHeading(PlayerPedId())-80.0)
				SetEntityCollision(SpikeObject, false, false)
				PlaceObjectOnGroundProperly(SpikeObject)

				SetEntityAsMissionEntity(SpikeObject, false, false)				
				SetModelAsNoLongerNeeded(modelHash)
				PlaySoundFromEntity(-1, "DROP_STINGER", PlayerPedId(), "BIG_SCORE_3A_SOUNDS", 0, 0)
			end			
			exports.bf:Notification("Spike stripe~g~ deployed~w~.")
		end
	else
		exports.bf:Notification("You need to get ~y~inside~w~ a ~y~police vehicle~w~.")
		PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	end
end

function DeleteSpike()
	local model = GetHashKey("P_ld_stinger_s")
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))

	if DoesObjectOfTypeExistAtCoords(x, y, z, 0.9, model, true) then
		local spike = GetClosestObjectOfType(x, y, z, 0.9, model, false, false, false)
		DeleteObject(spike)
	end	
end

local propslist = {}

function SpawnProps(model)
	if(#propslist < 100) then
		local prophash = GetHashKey(tostring(model))
		RequestModel(prophash)
		while not HasModelLoaded(prophash) do
			Citizen.Wait(0)
		end

		local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.75, 0.0)
		local _, worldZ = GetGroundZFor_3dCoord(offset.x, offset.y, offset.z)
		local propsobj = CreateObjectNoOffset(prophash, offset.x, offset.y, worldZ, true, true, true)
		local heading = GetEntityHeading(PlayerPedId())

		SetEntityHeading(propsobj, heading)
		SetEntityAsMissionEntity(propsobj)
		SetModelAsNoLongerNeeded(prophash)

		propslist[#propslist+1] = ObjToNet(propsobj)
	end
end

function RemoveLastProps()
	DeleteObject(NetToObj(propslist[#propslist]))
	propslist[#propslist] = nil
end

function RemoveAllProps()
	for i, props in pairs(propslist) do
		DeleteObject(NetToObj(props))
		propslist[i] = nil
	end

end


--armory
function createArmoryPed()
	if not DoesEntityExist(armoryPed) then
		local model = GetHashKey("s_m_y_cop_01")

		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(0)
		end

		local armoryPed = CreatePed(26, model, 454.165, -979.999, 30.690, 92.298, false, false)
		SetEntityInvincible(armoryPed, true)
		TaskTurnPedToFaceEntity(armoryPed, PlayerId(), -1)		

		return armoryPed
	end
end

basic_kit = {
	"WEAPON_STUNGUN",
	"WEAPON_NIGHTSTICK",
	"WEAPON_FLASHLIGHT",
	"WEAPON_PISTOL"
}

function giveBasicKit()
	for k,v in pairs(basic_kit) do
		GiveWeaponToPed(PlayerPedId(), GetHashKey(v), -1, true, false)
		-- ADD_AMMO_TO_PED
		AddAmmoToPed(
			PlayerPedId() --[[ Ped ]], 
			GetHashKey(v) --[[ Hash ]], 
			50 --[[ integer ]]
		)
	end

	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function giveBasicPrisonKit()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_PISTOL50"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), -1, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_NIGHTSTICK"), 200, true, true)
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 200, true, true)

	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function addBulletproofVest()
	if(GetEntityModel(PlayerPedId()) == hashSkin) then
		SetPedComponentVariation(PlayerPedId(), 9, 4, 1, 2)
	else
		SetPedComponentVariation(PlayerPedId(), 9, 6, 1, 2)
	end

	SetPedArmour(PlayerPedId(), 100)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function removeBulletproofVest()
	SetPedComponentVariation(PlayerPedId(), 9, 0, 1, 2)

	SetPedArmour(PlayerPedId(), 0)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

function GiveCustomWeapon(weaponData)
	GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponData), -1, false, true)
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

--redirect callbacks
function isPedDrivingAVehicle()
	local ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		-- Check if ped is in driver seat
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains
			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				return true
			end
		end
	end
	return false
end


function addBeginArea() 
	beginInProgress = true
	exports.bf:RemoveArea("begin-current")
	points_coords = points[math.random(1,#points)]
	exports.bf:AddArea("begin-current", {
		marker = {
			type = 1,
			weight = 1,
			height = 1,
			red = 255,
			green = 255,
			blue = 153,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					if 	GetVehiclePedIsIn(PlayerPedId(), false) == vehicleLivraison then
						TriggerServerEvent("account:player:liquid:add", "", 0.30)
						exports.bf:Notification("Vous avez gagné ~g~0.30$")
					else
						exports.bf:Notification("Ou est passé votre vehicule de livraison ? non payé")
					end
					addBeginArea()
				end
			},
		},
		blip = {
			text = "Livraison",
			colorId = 38,
			imageId = 77,
			route = true,
		},
		locations = {
			{
				x = points_coords.x,
				y = points_coords.y,
				z = points_coords.z,
			}
		},
	})
end

function refresh(job)
	deleteMenuAndArea()
	createMenuAndArea(job)
end


function deleteMenuAndArea()
	exports.bf:RemoveArea("center")
	exports.bf:RemoveMenu("lsms")
	exports.bf:RemoveMenu("lspd")
	exports.bf:RemoveMenu("lspd-service")
	exports.bf:RemoveMenu("bennys")
	exports.bf:RemoveMenu("service")
	exports.bf:RemoveMenu("taxi")
	for kk, vv in pairs(config.jobs) do
		if vv.homes then
			for k, v in pairs(vv.homes) do
				exports.bf:RemoveArea("homes"..kk..k)
			end
		end
		if vv.repair then
			for k, v in pairs(vv.repair) do
				exports.bf:RemoveArea("repair"..kk..k)
			end
		end
		if vv.lockers then
			for k, v in pairs(vv.lockers) do
				exports.bf:RemoveArea("lockers"..k)
				exports.bf:RemoveMenu("lockers"..k)
			end
		end
		if vv.collect then
			for k, v in pairs(vv.collect) do
				exports.bf:RemoveArea("collect"..k)
				exports.bf:RemoveMenu("collect"..k)
			end
		end
		if vv.process then
			for k, v in pairs(vv.process) do
				exports.bf:RemoveArea("process"..k)
				exports.bf:RemoveMenu("process"..k)
			end
		end
		if vv.safes then
			for k, v in pairs(vv.safes) do
				exports.bf:RemoveArea("safes"..k)
				exports.bf:RemoveMenu("safes"..k)
			end
		end
		if vv.armories then
			for k, v in pairs(vv.armories) do
				exports.bf:RemoveArea("armories"..k)
				exports.bf:RemoveMenu("armories"..k)
			end
		end
		if vv.begin then
			for k, v in pairs(vv.begin) do
			exports.bf:RemoveArea("begin"..k)
			end
		end
	end
end

function createMenuAndArea(job)
	ClearAllBlipRoutes()

	-- create menus
	menus()
	
	exports.bf:AddArea("center", {
		marker = {
			weight = 1,
			height = 1,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					exports.bf:HelpPromt("Job Center Key : ~INPUT_PICKUP~")
					zoneType = "center"
					zone = "global"
				end
			},
			exit = {
				callback = function()
					zoneType = nil
				end
			},
		},
		blip = {
			text = "Job Center",
			imageId	= config.center.sprite,
			colorId = config.center.color,
		},
		locations = {
			{
				x = config.center.pos.x,
				y = config.center.pos.y,
				z = config.center.pos.z,
			},
		},
	})

	-- global to everyone
	for kk, vv in pairs(config.jobs) do
		if vv.homes then
			for k, v in pairs(vv.homes) do
				exports.bf:AddArea("homes"..kk..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bf:HelpPromt("Accueil Key : ~INPUT_PICKUP~")
								zone = k
								zoneType = "homes"
								avert = kk
							end
						},
						exit = {
							callback = function()
								zone = nil
								zoneType = nil
							end
						},
					},
					blip = {
						text = vv.label,
						imageId	= v.sprite,
						colorId = vv.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
			end
		end
		if vv.repair then
			for k, v in pairs(vv.repair) do
				exports.bf:AddArea("repair"..kk..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bf:HelpPromt("Réparation Key : ~INPUT_PICKUP~")
								zone = k
								zoneType = "repair"
							end
						},
						exit = {
							callback = function()
								zone = nil
								zoneType = nil
							end
						},
					},
					blip = {
						text = vv.label,
						imageId	= v.sprite,
						colorId = vv.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
			end
		end
	end
	
	-- Draw areas 
	if job ~= nil and job.name ~= nil then
		myjob = config.jobs[job.name]
		if myjob then
			if myjob.lockers then
				for k, v in pairs(myjob.lockers) do
					exports.bf:AddArea("lockers"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bf:HelpPromt("Vestiaire Key : ~INPUT_PICKUP~")
									zone = k
									zoneType = "lockers"
								end
							},
							exit = {
								callback = function()
									exports.bf:CloseMenu(zoneType..zone)
									zone = nil
									zoneType = nil
								end
							},
						},
						blip = {
							text = job.label.. " Vestiaire "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
					exports.bf:AddMenu("lockers"..k, {
						title = "Vestiaire "..k,
						position = 1,
						buttons = {
							{
								text = "Prendre le service",
								exec = {
									callback = function()
										clockIn(job.name)
									end
								},
							},
							{
								text = "Quitter le service",
								exec = {
									callback = function()
										clockOut(job.name)
									end
								},
							},
						},
					})
				end
			end
			if myjob.collect then
				for k, v in pairs(myjob.collect) do
					exports.bf:AddArea("collect"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 2,
							enter = {
								callback = function()
									exports.bf:HelpPromt("Récolte Key : ~INPUT_PICKUP~")
									zone = k
									zoneType = "collect"
								end
							},
							exit = {
								callback = function()
					exports.bf:CloseMenu(zoneType..zone)

									zone = nil
									zoneType = nil
								end
							},
						},
						blip = {
							text = job.label.. " Récolte "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
					exports.bf:AddMenu("collect"..k, {
						title = "Récolte "..k,
						position = 0,
					})
				end
			end
			if myjob.process then
				for k, v in pairs(myjob.process) do
					exports.bf:AddArea("process"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 2,
							enter = {
								callback = function()
									exports.bf:HelpPromt("Traitement Key : ~INPUT_PICKUP~")
									zone = k
									zoneType = "process"
								end
							},
							exit = {
								callback = function()
								exports.bf:CloseMenu(zoneType..zone)
									zone = nil
									zoneType = nil
								end
							},
						},
						blip = {
							text = job.label.. " Traitement "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
					exports.bf:AddMenu("process"..k, {
						title = "Traitement "..k,
						position = 0,
					})
				end
			end
			if myjob.safes then
				for k, v in pairs(myjob.safes) do
					exports.bf:AddArea("safes"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bf:HelpPromt("Coffre Key : ~INPUT_PICKUP~")
									zone = k
									zoneType = "safes"
								end
							},
							exit = {
								callback = function()
									exports.bf:CloseMenu(zoneType..zone)
									zone = nil
									zoneType = nil
								end
							},
						},
						blip = {
							text = job.label.. " Coffre "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
					exports.bf:AddMenu("safes"..k, {
						title = job.label.." Coffre "..k,
						position = 1,
						
					buttons = {
						{
							text = "Compte",
							exec = {
								callback = function()
									TriggerServerEvent("job:get", "job:safe:open")			
								end
							},
						},
						{
							text = "Inventaire",
							exec = {
								callback = function()	
									TriggerServerEvent("job:get", "job:item:open")			
								end
							},
						},
					}
					})
					exports.bf:AddMenu("safes-account"..k, {
						title = job.label.." Coffre "..k,
						position = 1,
						
					buttons = {
						{
							text = "Retirer",
							exec = {
								callback = function()
									TriggerServerEvent('account:job:withdraw', "", job.job, tonumber(exports.bf:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})))
									TriggerServerEvent("job:get", "job:safe:open")		
								end
							},
						},
						{
							text = "Déposer",
							exec = {
								callback = function()
									TriggerServerEvent('account:job:add', "", job.job, tonumber(exports.bf:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})))
									TriggerServerEvent("job:get", "job:safe:open")		
								end
							},
						},
					}
					})

					exports.bf:AddMenu("safes-items", {
						title = job.label.." Coffre ",
						position = 1,
					})
					exports.bf:AddMenu("safes-items-item", {
						title = job.label.." Coffre ",
						position = 1,
					})
					exports.bf:AddMenu("safes-items-store", {
						title = job.label.." Coffre ",
						position = 1,
					})
				end
			end
			if myjob.armories then
				for k, v in pairs(myjob.armories) do
					exports.bf:AddArea("armories"..k, {
						marker = {
							weight = 1,
							height = 2,
						},
						trigger = {
							weight = 1,
							enter = {
								callback = function()
									exports.bf:HelpPromt("Armurerie Key : ~INPUT_PICKUP~")
									zone = k
									zoneType = "armories"
								end
							},
							exit = {
								callback = function()
								exports.bf:CloseMenu(zoneType..zone)
									zone = nil
									zoneType = nil
								end
							},
						},
						blip = {
							text = job.label.. " Armurerie "..k,
							imageId	= v.sprite,
							colorId = myjob.color,
						},
						locations = {
							{
								x = v.coords.x,
								y = v.coords.y,
								z = v.coords.z,
							},
						},
					})
					exports.bf:AddMenu("armories"..k, {
						title = job.label.." Armurerie "..k,
						position = 1,
						closable = false,
						buttons= {
							{
								text = "Mettre Gillet",
								exec = {
									callback = function()
										addBulletproofVest()
									end
								},
							},
							{
								text = "Enlever Gillet",
								exec = {
									callback = function()
										removeBulletproofVest()
									end
								},
							},
							{
								text = "Stocker armes",
								exec = {
									callback = function()
										local found, weapon  = GetCurrentPedWeapon(
											GetPlayerPed(-1),
											1
										)
										if found then
											RemoveWeaponFromPed(GetPlayerPed(-1), weapon)

											weapon = tostring(weapon)
											if weapon == "453432689" then
												weapon = "0x1B06D571"
											elseif weapon == "-1951375401" then
												weapon = "0x8BB05FD7"
											elseif weapon == "911657153" then
												weapon = "0x3656C8C1"
											elseif weapon == "1737195953" then
												weapon = "0x678B81B1"
											elseif weapon == "911657153" then
												weapon = "0x1D073A89"
											elseif weapon == "736523883" then
												weapon = "0x2BE6766B"
											end
											TriggerServerEvent("weapon:store", weapon)
											exports.bf:Notification("Arme stocké")
										else
											exports.bf:Notification("Pas d'arme sur vous")
										end
									end
								},
							},
							{
								text = "Retirer arme",
								exec = {
									callback = function()
										TriggerServerEvent("weapon:get:all", "weapon:store")
									end
								},
							},
							{
								text = "Quitter",
								exec = {
									callback = function()
										exports.bf:CloseMenu("armories"..k)
									end
								},
							}
						}
					})
					exports.bf:AddMenu("weapon-store", {
						title = "weapon",
						position = 1,
					})
				end
			end
			if myjob.begin then
				for k, v in pairs(myjob.begin) do
				exports.bf:AddArea("begin"..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bf:HelpPromt("Commencer la tournée Key : ~INPUT_PICKUP~")
								zone = k
								zoneType = "begin"
								vehicle = v.vehicle
								coords = v.coords
								points = v.points
							end
						},
						exit = {
							callback = function()
								zone = nil
								zoneType = nil
							end
						},
					},
					blip = {
						text = job.label.. " Livraisons "..k,
						imageId	= v.sprite,
						colorId = myjob.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
				end
			end
			if myjob.custom then
				for k, v in pairs(myjob.custom) do
				exports.bf:AddArea("custom"..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bf:HelpPromt("Customisation Key : ~INPUT_PICKUP~")
								zone = k
								zoneType = "custom"
							end
						},
						exit = {
							callback = function()
								zone = nil
								zoneType = nil
							end
						},
					},
					blip = {
						text = job.label.. " Customisation "..k,
						imageId	= v.sprite,
						colorId = myjob.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
				end
			end
			if myjob.fourriere then
				for k, v in pairs(myjob.fourriere) do
				exports.bf:AddArea("fourriere"..k, {
					marker = {
						weight = 1,
						height = 2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bf:HelpPromt("Mise en fourriére Key : ~INPUT_PICKUP~")
								zone = k
								zoneType = "fourriere"
							end
						},
						exit = {
							callback = function()
								exports.bf:CloseMenu(zoneType..zone)
								zoneType = nil
								zone = nil
							end
						}
					},
					blip = {
						text = job.label.. " Fourriére "..k,
						imageId	= v.sprite,
						colorId = myjob.color,
					},
					locations = {
						{
							x = v.coords.x,
							y = v.coords.y,
							z = v.coords.z,
						},
					},
				})
				end
			end
		end
	end
end

-- service management
function recruitClosestPlayer(job)
	local closestPlayer, dist = GetClosestPlayer()

    if closestPlayer and dist <=1 then
        TriggerServerEvent('job:service:recruit', job[1].id, GetPlayerServerId(closestPlayer))
    else
        exports.bf:Notification("Pas de joueur à portée")
    end
end

function promoteClosestPlayer()
	local closestPlayer, dist = GetClosestPlayer()

    if closestPlayer and dist <=1 then
        TriggerServerEvent('job:service:prmote', GetPlayerServerId(closestPlayer))
    else
        exports.bf:Notification("Pas de joueur à portée")
    end
end



function demmoteClosestPlayer()
	local closestPlayer, dist = GetClosestPlayer()

    if closestPlayer and dist <=1 then
        TriggerServerEvent('job:service:prmote', GetPlayerServerId(closestPlayer))
    else
        exports.bf:Notification("Pas de joueur à portée")
    end
end


function fireClosestPlayer()
	local closestPlayer, dist = GetClosestPlayer()

	if closestPlayer and dist <=1 then
		--todo
        TriggerServerEvent('job:set', GetPlayerServerId(closestPlayer), nil, "Vous avez été viré", "Vous avez viré un employé")
    else
        exports.bf:Notification("Pas de joueur à portée")
    end
end


function beginSell(job)
	local nb = math.random(1,#config.jobs[job].sell.pos)
	local currentSell = config.jobs[job].sell.pos[nb]
	exports.bf:AddArea("sell", {
		marker = {
			weight = 1,
			height = 2,
		},
		trigger = {
			weight = 1,
			enter = {
				callback = function()
					exports.bf:HelpPromt("Vendre Key : ~INPUT_PICKUP~")
					zone = 1
					zoneType = "sell"
				end
			},
			exit = {
				callback = function()
					exports.bf:CloseMenu("sell")
					zone = nil
					zoneType = nil
				end
			},
		},
		blip = {
			text = "Revente",
			imageId	= config.jobs[job].sell.sprite,
			colorId = config.jobs[job].color,
			route = true,
		},
		locations = {
			{
				x = currentSell.coords.x,
				y = currentSell.coords.y,
				z = currentSell.coords.z,
			},
		},
	})
	exports.bf:CloseMenu(job)
	exports.bf:CloseMenu("sell")
end


function removeSell(job)
	exports.bf:RemoveArea("sell")
	exports.bf:CloseMenu(job)
	exports.bf:CloseMenu("sell")
end
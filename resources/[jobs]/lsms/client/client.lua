local config = {
    hospitals = {	
		CentralLosSantos = {

            Blip = {
                coords = vector3(340.73, -584.6, 28.79),
                sprite = 61,
                scale  = 1.2,
                color  = 8
            },

            lsmsActions = {
            },

            Pharmacies = {
			},
			
			lockers = {
				coords = vector3(336.25, -579.45, 27.6),
				sprite = 51,
			},

            Vehicles = {
				coords = vector3(341.25, -562.98,28.24)
            },

            Helicopters = {
				coords = vector3(55.25, -562.98,28.74)
            },
        }
	}
}
config.BleedoutTimer = 90000 * 10 -- time til the player bleeds out

-- Create blips
Citizen.CreateThread(function()	
	for k,v in pairs(config.hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Hopital')
		EndTextCommandSetBlipName(blip)
	end
end)

-- local values
local isDead = false

function StartDeathTimer()
	local canPayFine = false

	local bleedoutTimer = config.BleedoutTimer / 1000

	Citizen.CreateThread(function()
		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
        local text, timeHeld
        
		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(0)
			text = 'Respawn dans : ' .. bleedoutTimer

            text = text .. "s"

            if IsControlPressed(0, 38) and timeHeld > 60 then
                RemoveItemsAfterRPDeath()
                break
            end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
            end
            
			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
	end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

    print("Appel envoyé")
	TriggerServerEvent('job:lsms:distress', playerPed)
end


function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = config.BleedoutTimer

		while timer > 0 and isDead do
			Citizen.Wait(0)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName('G pour appeler')
			EndTextCommandDisplayText(0.175, 0.805)

			if IsControlJustReleased(0, 47) then
				SendDistressSignal()
				break
			end
		end
	end)
end

AddEventHandler('player:dead', function(data)
    if(not isDead) then
        isDead = true
        --TriggerServerEvent('lsms:setDeathStatus', true)

        StartDeathTimer()
        StartDistressSignal()

        StartScreenEffect('DeathFailOut', 0, false)
    end
end)

AddEventHandler('player:alive', function()
	print("ALIVE")
	isDead = false
end)



--beds 

local Beds, CurrentBed, OnBed = {'v_med_bed2', 'v_med_bed1', 'v_med_emptybed'}, nil, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		if not OnBed then
			local PlayerPed = PlayerPedId()
			local PlayerCoords = GetEntityCoords(PlayerPed)

			for k,v in pairs(Beds) do
				local ClosestBed = GetClosestObjectOfType(PlayerCoords, 1.5, GetHashKey(v), false, false)

				if ClosestBed ~= 0 and ClosestBed ~= nil then
					CurrentBed = ClosestBed
					break
				else
					CurrentBed = nil
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if CurrentBed ~= nil then
			if not OnBed then
				local BedCoords = GetEntityCoords(CurrentBed)
				Draw3DText({x = BedCoords.x, y = BedCoords.y, z = (BedCoords.z+1)}, 'Press ~g~[E] ~w~to lie down', 0.35)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if CurrentBed ~= nil and IsControlJustReleased(0, 38) then
			local PlayerPed = PlayerPedId()
			local BedCoords, BedHeading = GetEntityCoords(CurrentBed), GetEntityHeading(CurrentBed)

			LoadAnimSet('missfbi1')

			SetEntityCoords(PlayerPed, BedCoords)
			SetEntityHeading(PlayerPed, (BedHeading+180))

			TaskPlayAnim(PlayerPed, 'missfbi1', 'cpr_pumpchest_idle', 8.0, -8.0, -1, 1, 0, false, false, false)
			exports.bf:Notification("~g~F1~w~ pour vous relever")

			OnBed = true
		elseif IsControlJustReleased(0, 288) and IsEntityPlayingAnim(PlayerPedId(), 'missfbi1', 'cpr_pumpchest_idle', 3) then
			ClearPedTasks(PlayerPedId())

			OnBed = false
		end
	end
end)

function Draw3DText(coords, text, scale)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)

	SetTextScale(scale, scale)
	SetTextOutline()
	SetTextDropShadow()
	SetTextDropshadow(2, 0, 0, 0, 255)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry('STRING')
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)
	AddTextComponentString(text)
	DrawText(x, y)
end

function LoadAnimSet(AnimDict)
	if not HasAnimDictLoaded(AnimDict) then
		RequestAnimDict(AnimDict)

		while not HasAnimDictLoaded(AnimDict) do
			Citizen.Wait(1)
		end
	end
end
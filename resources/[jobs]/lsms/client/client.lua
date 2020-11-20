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
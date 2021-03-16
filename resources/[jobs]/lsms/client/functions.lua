
function StartDeathTimer()
	local bleedoutTimer = config.BleedoutTimer / 1000

	Citizen.CreateThread(function()
		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
		Citizen.Wait(2000)
		if isDead then 
			TriggerEvent("job:lsms:revive", true)
		end
	end)
end

function SendDistressSignal()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('job:lsms:distress', coords, exports.bro_core:OpenTextInput({title= "Raison du Coma", customTitle = true}))
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

			-- G control
			if IsControlJustReleased(0, 47) then
				SendDistressSignal()
				break
			end
		end
	end)
end
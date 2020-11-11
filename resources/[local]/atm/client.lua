config = {}
config.BlipSprite   = 431

config.ATMLocations = {
    { ['x'] = 381.2827,  ['y'] = 323.2518,  ['z'] = 103.270},
    { ['x'] = 2558.051,  ['y'] = 389.4817,  ['z'] = 108.660},
    { ['x'] = -3044.22,  ['y'] = 595.2429,  ['z'] = 7.595},
	{ ['x'] = -3241.10,  ['y'] = 996.6881,  ['z'] = 12.500},
    { ['x'] = -3241.11,  ['y'] = 1009.152,  ['z'] = 12.877},
    { ['x'] = 540.0420,  ['y'] = 2671.007,  ['z'] = 42.177},
    { ['x'] = 1967.333,  ['y'] = 3744.293,  ['z'] = 32.272},
	{ ['x'] = 1703.138,  ['y'] = 6426.783,  ['z'] = 32.730},
    { ['x'] = 1735.114,  ['y'] = 6411.035,  ['z'] = 35.164},
    { ['x'] = -56.1935,  ['y'] = -1752.53,  ['z'] = 29.452},
    { ['x'] = 1168.975,  ['y'] = -457.241,  ['z'] = 66.641},
	{ ['x'] = -717.614,  ['y'] = -915.880,  ['z'] = 19.268},
	{ ['x'] = -1827.04,  ['y'] = 785.5159,  ['z'] = 138.020},
	{ ['x'] = 1686.753,  ['y'] = 4815.809,  ['z'] = 42.008},
	{ ['x'] = 1153.75,  ['y'] = -326.8,  ['z'] = 69.21},
}
config.ZDiff        = 2.0
config.Range = 5

-- Create blips
Citizen.CreateThread(function()
	for _, ATMLocation in pairs(config.ATMLocations) do
		ATMLocation.blip = AddBlipForCoord(ATMLocation.x, ATMLocation.y, ATMLocation.z - config.ZDiff)
		SetBlipSprite(ATMLocation.blip, config.BlipSprite)
		SetBlipDisplay(ATMLocation.blip, 4)
		SetBlipScale(ATMLocation.blip, 0.5)
		SetBlipColour(ATMLocation.blip, 2)
		SetBlipAsShortRange(ATMLocation.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Guichet')
		EndTextCommandSetBlipName(ATMLocation.blip)
    end
end)

local hasAlreadyEnteredMarker, isInATMMarker, menuIsShowed = false, false, false


RegisterNetEvent('atm:closeATM')
AddEventHandler('atm:closeATM', function()
	SetNuiFocus(false)
	menuIsShowed = false
	SendNUIMessage({
		hideAll = true
	})
end)

RegisterNUICallback('escape', function(data, cb)
	TriggerEvent('atm:closeATM')
	cb('ok')
end)


RegisterNUICallback('deposit', function(data, cb)
	TriggerServerEvent('atm:deposit', data.amount)
	cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
	TriggerServerEvent('atm:withdraw', data.amount)
	cb('ok')
end)


-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())
		local canSleep = true
		isInATMMarker = false

		for k,v in pairs(config.ATMLocations) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < config.Range then
				isInATMMarker, canSleep = true, false
				break
			end
		end

		if isInATMMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			canSleep = false
		end
	
		if not isInATMMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			SetNuiFocus(false)
			menuIsShowed = false
			canSleep = false

			SendNUIMessage({
				hideAll = true
			})
		end

		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Menu interactions
Citizen.CreateThread(function()
	local notification = false
	while true do
		Citizen.Wait(0)

		if not isInATMMarker then
			notification = false
		end

		if isInATMMarker and (not menuIsShowed)  then
			if (not notification) then
				TriggerEvent("notify:SendNotification", {text = "<span style='font-weight: 900'>Appuyez sur e pour l'atm</span>",
				layout = "centerLeft",
				timeout = 2000,
				progressBar = false,
				type = "error",
				animation = {
					open = "gta_effects_fade_in",
					close = "gta_effects_fade_out"
				}})
				notification = true
			end

			if IsControlJustReleased(0, 38) and IsPedOnFoot(PlayerPedId()) then
				menuIsShowed = true
				SendNUIMessage({
					showMenu = true,
					player = {
						money = 0,
					}
				})
				SetNuiFocus(true, true)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- close the menu when script is stopping to avoid being stuck in NUI focus
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuIsShowed then
			TriggerEvent('atm:closeATM')
		end
	end
end)
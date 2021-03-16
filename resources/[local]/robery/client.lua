  
-------------------------
--- robery ---
-------------------------
print("robery")
robberyActive = false
RegisterNetEvent('robery:IsActive:Return')
AddEventHandler('robery:IsActive:Return', function(bool)
	robberyActive = bool
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if not robberyActive then
			if (config.enableBanks == true) then
				for _, bankcoords in pairs(config.bankcoords) do
				DrawMarker(27, bankcoords.x, bankcoords.y, bankcoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, .2, 255, 0, 0, 255, false, true, 2, false, nil, nil, false)
				end
			end

			-- Bank Code
			local coords = GetEntityCoords(GetPlayerPed(-1))
			for _, bankcoords in pairs(config.bankcoords) do
			if (config.enableBanks == true) then
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, bankcoords.x, bankcoords.y, bankcoords.z, true) < 5.0 then
					DisplayNotification('~r~Press the ~w~E ~r~key to rob the bank')
                    if IsControlJustReleased(0, 38) then -- E key
                        -- If no luck, cops get averted
                        --	if math.random(1,2) == 1 then
                        TriggerServerEvent("job:avert:all", "lspd", bankcoords.alarm, true, GetEntityCoords(GetPlayerPed(-1)))
                        --	end
						TriggerServerEvent('robery:SetActive', true)
						if (config.displayBlips == true) then
							bankcoords.blip = AddBlipForCoord(bankcoords.x, bankcoords.y, bankcoords.z)
							SetBlipSprite(bankcoords.blip, 353)
							SetBlipFlashTimer(bankcoords.blip, 1000 * config.timeToRob)
							SetBlipAsShortRange(bankcoords.blip, true)
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString(bankcoords.name)
							EndTextCommandSetBlipName(bankcoords.blip)
                        end
                        -- flag = 49
                        -- prop_ing_crowbar
                        FreezeEntityPosition(
                            GetPlayerPed(-1) --[[ Entity ]], 
                            true --[[ boolean ]]
                        )
                        exports.bro_core:actionPlayer((1000 * config.timeToRob), config.robbingStr, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer",
                        function()
							if not IsEntityDead(GetPlayerPed(-1)) then
                                exports.bro_core:Notification(config.robberySuccess)
                                TriggerServerEvent("account:player:liquid:add", "", 100000, true)
							else
                                exports.bro_core:Notification(config.robberyFailed)
                            end
                            FreezeEntityPosition(
                                GetPlayerPed(-1) --[[ Entity ]], 
                                false --[[ boolean ]]
                            )
                        end)
						RemoveBlip(bankcoords.blip)
					end
				end
			end
			end
		end
	end
end)


function DisplayNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		TriggerServerEvent('robery:IsActive')
	end
end)
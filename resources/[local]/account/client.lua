RegisterNetEvent("account:suitcase:on")
RegisterNetEvent("bank:get")

AddEventHandler("account:suitcase:on", function()
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_briefcase"), 1, false, true)

end)

RegisterNetEvent("account:suitcase:off")

AddEventHandler("account:suitcase:off", function()
    RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("weapon_briefcase")) ----Leather Brifcase
end)

RegisterNetEvent("account:player:add")

AddEventHandler("account:player:add", function(cb, sellPrice)
    TriggerServerEvent("account:player:add", cb, sellPrice)
end)


Citizen.CreateThread(function()
    exports.bro_core:AddArea("pacifik-bank", {
        trigger = {
            weight = 2,
            enter = {
                callback = function()
                    exports.bro_core:Key("E", "E", "Pacifique Banque", function()
                        TriggerServerEvent("job:get", "acccount:pacifik:get")
                    end)
                    exports.bro_core:HelpPromt("Banque : ~INPUT_PICKUP~")
                end
            },
            exit = {
                callback = function()
                    exports.bro_core:RemoveMenu("pacifik-bank")
                    exports.bro_core:Key("E", "E", "Interaction", function()
                    end)
                end
            },
        },
        blip = {
            text = "Pacifique Banque",
            colorId = 2,
            imageId = 300,
        },
        locations = {
            { 
                x=247.81019592285,
                y=222.47581481934,
                z=106.28677368164
            },
        }
    })
end)

RegisterNetEvent("acccount:pacifik:get")

AddEventHandler('acccount:pacifik:get', function(job)
	job = job[1]

    TriggerServerEvent("account:job:get", "acccount:pacifik:get2", job.job)
end)

RegisterNetEvent("acccount:pacifik:get2")

AddEventHandler('acccount:pacifik:get2', function(res)
    print(res)
	exports.bro_core:AddMenu("pacifik-bank", {
		Subtitle = "Compte : "..exports.bro_core:Money(res.liquid).. "/ Sale : "..exports.bro_core:Money(res.dirty),
		buttons = {
			{
				type = "button",
				label = "Retirer",
				actions = {
					onSelected = function()
						local nb = exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})
						exports.bro_core:actionPlayer(4000, "ATM", "scenario", "PROP_HUMAN_ATM", function()
							TriggerServerEvent('bank:withdraw',  nb)
						end)
						exports.bro_core:RemoveMenu("ATM")
					end,
				}
			},
			{
				type = "button",
				label = "Déposer",
				actions = {
					onSelected = function()
						local nb =exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})
						exports.bro_core:actionPlayer(4000, "ATM", "scenario", "PROP_HUMAN_ATM", function()
							TriggerServerEvent('bank:deposit',  nb)
						end)
						exports.bro_core:RemoveMenu("ATM")
					end,
				}
			},
            {
				type = "button",
				label = "Déposer (OFFSHORE)",
				actions = {
					onSelected = function()
						local nb =exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true})
						exports.bro_core:actionPlayer(4000, "ATM", "scenario", "PROP_HUMAN_ATM", function()
							TriggerServerEvent('bank:dirty:deposit',  nb)
						end)
						exports.bro_core:RemoveMenu("ATM")
					end,
				}
			}
		}
	})
end)


AddEventHandler("job:safe:open", function(job)
	job = job[1]
	TriggerServerEvent("account:job:get", "job:safe:open2", job.job)
end)

-- On nettoie le caca
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    exports.bro_core:RemoveMenu("pacifik-bank")
    exports.bro_core:RemoveArea("pacifik-bank")
end)
  

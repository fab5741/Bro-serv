RegisterNetEvent("atm:get")
RegisterNetEvent("bank:get")

AddEventHandler('atm:get', function(account, liquid)
	account = account
	liquid = liquid
	exports.bro_core:AddMenu("ATM", {
		Subtitle = "Compte  : "..exports.bro_core:Money(account).. "/ Liquide : "..exports.bro_core:Money(liquid),
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
		}
	})
end)


AddEventHandler('bank:get', function(account, liquid)
	account = account
	liquid = liquid
	exports.bro_core:AddMenu("Bank", {
		Subtitle = "Compte  : "..exports.bro_core:Money(account).. "/ Liquide : "..exports.bro_core:Money(liquid),
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
			}
		}
	})
end)

-- On nettoie le caca
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    exports.bro_core:RemoveMenu("ATM")
	exports.bro_core:RemoveArea("ATM")
	exports.bro_core:RemoveMenu("bank")
    exports.bro_core:RemoveArea("bank")
end)
  
-- main loop
Citizen.CreateThread(function()
	exports.bro_core:AddArea("gunshop", {
		trigger = {
			weight = 2,
			enter = {
				callback = function()
					exports.bro_core:HelpPromt("Magasin : ~INPUT_PICKUP~")
					exports.bro_core:Key("E", "E", "Magasin", function()
						TriggerServerEvent("gun:permis", "gun:shop")
					end)

				end
			},
			exit = {
				callback = function()
					exports.bro_core:RemoveMenu("gunshop")
					exports.bro_core:Key("E", "E", "", function()
					end)
				end
			},
		},
		blip = {
			text = "Ammunation",
			colorId = 2,
			imageId = 110,
		},
		locations = {
			{ x = 21.907299041748, y=-1107.2723388672, z=29.797023773193},
		}
	})
end)


RegisterNetEvent("gun:buy:ok")

-- source is global here, don't add to function
AddEventHandler("gun:buy:ok", function (bool, weapon)
	if bool then
		GiveWeaponToPed(GetPlayerPed(-1), weapon, 1000, false, false)
		exports.bro_core:Notification("~g~Et voilà, faites pas le con avec.")
	else
		exports.bro_core:Notification("~r~Vous ne pouvez pas acheter cette arme")
	end
end)


RegisterNetEvent("gun:shop2")

-- source is global here, don't add to function
AddEventHandler("gun:shop2", function (job)
	local buttons = {}
	for k,v in pairs(config.weapons) do
		buttons[#buttons+1] = {
			type = "button",
			label = v.label.." prix : ~g~" ..v.price.."$",
			actions = {
				onSelected = function()
					TriggerServerEvent("gun:buy", "gun:buy:ok", v.price, v.name)
				end
			}
		}
	end
	if job[1].name == "lspd" then
		for k,v in pairs(config.weaponsLspd) do
			buttons[#buttons+1] =     {
				type = "button",
				label = v.label.." prix : ~g~" ..v.price.."$",
				actions = {
					onSelected = function()
						TriggerServerEvent("gun:buy", "gun:buy:ok", v.price, v.name)
					end
				}
			}
		end
	end
	exports.bro_core:AddMenu("gunshop", {
		Title = "Magasin",
		Subtitle = "Armes",
		buttons = buttons
	})
end)

RegisterNetEvent("gun:shop")

-- source is global here, don't add to function
AddEventHandler("gun:shop", function (permis)
	if permis then
		TriggerServerEvent("job:get", "gun:shop2")
	else
		exports.bro_core:Notification("Vous n'avez pas le ~r~permis de port d'armes.~s~ Renseignez vous au LSPD.")
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	exports.bro_core:RemoveMenu("gunshop")
	exports.bro_core:RemoveArea("gunshop")
end)
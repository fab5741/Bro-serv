-- Bf version
liquid = 0
account = 0

-- main loop
Citizen.CreateThread(function()
	exports.bf:AddMenu("gunshop", {
		title = "Ammunation",
		position = 1,
		buttons = {
		},
	})
	exports.bf:AddArea("gunshop", {
		trigger = {
			weight = 2,
			enter = {
				callback = function()
					exports.bf:HelpPromt("Magasin : ~INPUT_PICKUP~")
					zoneType = "gunshop"
				end
			},
			exit = {
				callback = function()
					zoneType = nil
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
	while true do
		Citizen.Wait(0)
		if zoneType == "gunshop" and IsControlJustPressed(1, 51) then
			TriggerServerEvent("gun:permis", "gun:shop")
		end
	end
end)


RegisterNetEvent("gun:buy:ok")

-- source is global here, don't add to function
AddEventHandler("gun:buy:ok", function (bool, weapon)
	if bool then
		GiveWeaponToPed(GetPlayerPed(-1), weapon, 1000, false, false)
		exports.bf:Notification("~g~Et voilà, faites pas le con avec.")
	else
		exports.bf:Notification("~r~Vous ne pouvez pas acheter cette arme")
	end
end)


RegisterNetEvent("gun:shop2")

-- source is global here, don't add to function
AddEventHandler("gun:shop2", function (job)
	local buttons = {}
	for k,v in pairs(config.weapons) do
		buttons[#buttons+1] =     {
			text = v.label.." prix : ~g~" ..v.price.."$",
			exec = {
				callback = function()
					TriggerServerEvent("gun:buy", "gun:buy:ok", v.price, v.name)
				end
			}
		}
	end
	if job[1].name == "lspd" then
		for k,v in pairs(config.weaponsLspd) do
			buttons[#buttons+1] =     {
				text = v.label.." prix : ~g~" ..v.price.."$",
				exec = {
					callback = function()
						TriggerServerEvent("gun:buy", "gun:buy:ok", v.price, v.name)
					end
				}
			}
		end
	end
	exports.bf:SetMenuButtons("gunshop", buttons)
	exports.bf:OpenMenu("gunshop")
end)

RegisterNetEvent("gun:shop")

-- source is global here, don't add to function
AddEventHandler("gun:shop", function (permis)
	if permis then
		TriggerServerEvent("job:get", "gun:shop2")
	else
		exports.bf:Notification("Vous n'avez pas le ~r~permis de port d'armes.~s~ Renseignez vous au LSPD.")
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	exports.bf:RemoveMenu("gunshop")
	exports.bf:RemoveArea("gunshop")
end)
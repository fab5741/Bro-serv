-- Events
RegisterNetEvent("property:show")

-- Global var
Ped = GetPlayerPed(-1)

TriggerServerEvent("property:get:all", "property:show")

AddEventHandler("property:show", function(properties, discord)
	RemoveMenusAndAreas(properties)

	for k,v in ipairs(properties) do
		local pos = json.decode(v.pos)
		local blip = {
			text = "Propriétée",
			imageId	= 40,
			colorId = 0,
		}
		if v.owner == discord then
			blip = {
				text = "Propriétée",
				imageId	= 40,
				colorId = 2,
			}
		end

		if not v.owner or v.owner == discord then
			exports.bro_core:AddArea("property"..k, {
				marker = {
					weight = 1,
					height = 0.2,
				},
				trigger = {
					weight = 1,
					enter = {
						callback = function()
							local buttons = {

							}
							if not v.owner then
								buttons[#buttons+1] = {
									type="button",
									label= "Acheter ".. exports.bro_core:Money(v.price),
									actions = {
										onSelected = function()
											exports.bro_core:RemoveMenu("property")
											TriggerServerEvent("property:buy", v.id)
											exports.bro_core:RemoveArea("property"..k)
											Wait(3000)
											TriggerServerEvent("property:get:all", "property:show")
										end
									}
								}
							end

							if v.owner == discord then
								buttons[#buttons+1] = {
									type="button",
									label= "Entrer ",
									actions = {
										onSelected = function()
											exports.bro_core:RemoveMenu("property")
											exports.bro_core:tpPlayer(GetPlayerPed(-1), false, json.decode(v.enter), true)
											print("TP")
									end
									}
								}
								buttons[#buttons+1] = {
									type="button",
									label= "Vendre ",
									actions = {
										onSelected = function()
											exports.bro_core:RemoveMenu("property")
											TriggerServerEvent("property:sell", v.id)
											exports.bro_core:RemoveArea("property"..k)
											Wait(3000)
											TriggerServerEvent("property:get:all", "property:show")
										end
									}
								}
							end
							

							exports.bro_core:Key("E", "E", "Propriété", function()
								exports.bro_core:AddMenu("property", {
									Title = "Propriété",
									Subtitle = v.address,
									buttons = buttons
								})
							end)
							exports.bro_core:HelpPromt("~INPUT_PICKUP~ "..v.address)
						end
					},
					exit = {
						callback = function()
							exports.bro_core:RemoveMenu("property"..k)
							exports.bro_core:Key("E", "E", "Interaction", function()
							end)
						end
					},
				},
				blip = blip,
				locations = {
					{
						x = pos.x,
						y = pos.y,
						z = pos.z,
					},
				},
			})
			if v.owner then
				local exit = json.decode(v.exit)
				local clothes = json.decode(v.clothes)
				local safe = json.decode(v.safe)
				local frigo = json.decode(v.frigo)
				local storage = json.decode(v.storage)
				local parking = json.decode(v.garage)
				exports.bro_core:AddArea("exit"..k, {
					marker = {
						weight = 1,
						height = 0.2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:tpPlayer(Ped, false, pos, true)
							end
						},
					},
					locations = {
						{
							x = exit.x,
							y = exit.y,
							z = exit.z,
						},
					},
				})
				exports.bro_core:AddArea("clothes"..k, {
					marker = {
						weight = 1,
						height = 0.2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:HelpPromt("Penderie ~r~non disponible")
							end
						},
					},
					locations = {
						{
							x = clothes.x,
							y = clothes.y,
							z = clothes.z,
						},
					},
				})
				exports.bro_core:AddArea("safe"..k, {
					marker = {
						weight = 1,
						height = 0.2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:HelpPromt("Coffre Key : ~INPUT_PICKUP~")
								exports.bro_core:Key("E", "E", "Coffre", function()
									TriggerServerEvent("property:safe:get", "property:safe:open", v)
								end)
							end
						},
						exit = {
							callback = function()
								exports.bro_core:RemoveMenu("safe")
								exports.bro_core:Key("E", "E", "Interaction", function()
								end)
							end
						},
					},
					locations = {
						{
							x = safe.x,
							y = safe.y,
							z = safe.z,
						},
					},
				})
				exports.bro_core:AddArea("frigo"..k, {
					marker = {
						weight = 1,
						height = 0.2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:HelpPromt("Frigo ~r~non disponible")
							end
						},
					},
					locations = {
						{
							x = frigo.x,
							y = frigo.y,
							z = frigo.z,
						},
					},
				})
				exports.bro_core:AddArea("storage"..k, {
					marker = {
						weight = 1,
						height = 0.2,
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:HelpPromt("Stockage Key : ~INPUT_PICKUP~")
								exports.bro_core:Key("E", "E", "Stockage", function()
									TriggerServerEvent("property:storage:get:all", "property:storage:open", v)
								end)
							end
						},
						exit = {
							callback = function()
								exports.bro_core:RemoveMenu("storage")
								exports.bro_core:Key("E", "E", "Interaction", function()
								end)
							end
						},
					},
					locations = {
						{
							x = storage.x,
							y = storage.y,
							z = storage.z,
						},
					},
				})
				exports.bro_core:AddArea("parking"..k, {
					marker = {
						weight = 2,
						height = 1,
						red = 50,
						green = 50,
						blue = 50,
						alpha = 100,
					--	showDistance = 5,
						type = 43
					},
					trigger = {
						weight = 1,
						enter = {
							callback = function()
								exports.bro_core:HelpPromt("Parking : ~INPUT_PICKUP~")
								exports.bro_core:Key("E", "E", "Parking ("..v.address..")", function()
									if exports.bro_core:isPedDrivingAVehicle() then
										exports.bro_core:AddMenu("parking-veh", {
											Title = "Parking",
											Subtitle = v.address,
											buttons = {
												{
													type= "button",
													label = "Stocker : " .. v.address,
													actions = {
														onSelected = function()
															exports.bro_core:actionPlayer(4000, "Stockage véhicule", "", "",
															function()
																TriggerEvent("vehicle:store:veh", v.address)
																exports.bro_core:RemoveMenu("parking-veh")
															end)
														end
													},
												}
											}
										})
									else
										TriggerServerEvent("vehicle:parking:get:all", v.address, "vehicle:foot")
									end
								end)
							end
						},
						exit = {
							callback = function()
								exports.bro_core:RemoveMenu("parking-veh")
								exports.bro_core:Key("E", "E", "Interaction", function()
								end)
							end
						},
					},
					locations = {
						{
							x = parking.x,
							y = parking.y,
							z = parking.z,
						},
					},
				})
			end
		end
	end
end)

-- Events
RegisterNetEvent("property:hide")

AddEventHandler("property:hide", function(properties, discord)
	RemoveMenusAndAreas(properties)
end)

function RemoveMenusAndAreas(properties)
	exports.bro_core:RemoveMenu("property")
	exports.bro_core:RemoveMenu("parking-veh")
	
	for k,v in ipairs(properties) do
		exports.bro_core:RemoveArea("property"..k)
		exports.bro_core:RemoveArea("exit"..k)
		exports.bro_core:RemoveArea("clothes"..k)
		exports.bro_core:RemoveArea("safe"..k)
		exports.bro_core:RemoveArea("frigo"..k)
		exports.bro_core:RemoveArea("storage"..k)
	end
end

RegisterNetEvent("property:safe:open")

AddEventHandler("property:safe:open", function(liquid, property)
	print(liquid)
	local buttons = {

	}
	buttons[#buttons+1] = {
		type  = "button",
		label = "Retirer",
		actions = {
			onSelected = function()
				local nb = tonumber(exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true}))
				TriggerServerEvent("property:safe:withdraw", property, nb)
				exports.bro_core:RemoveMenu("safe")
			end
		}
	}
	buttons[#buttons+1] = {
		type  = "button",
		label = "Déposer",
		actions = {
			onSelected = function()
				local nb = tonumber(exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true}))
				TriggerServerEvent("property:safe:add", property, nb)
				exports.bro_core:RemoveMenu("safe")
			end
		}
	}
	exports.bro_core:AddMenu("safe", {
		Title = "Coffre",
		Subtitle = property.address.." "..exports.bro_core:Money(liquid),
		buttons = buttons
	})
end)

RegisterNetEvent("property:storage:open")

AddEventHandler("property:storage:open", function(inventory, property)
	local buttons = {}
	local weight = 0
	local maxWeight = 1000

	for k, v in ipairs (inventory) do
		buttons[k] =     {
			type = "button",
			label = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			actions = {
				onSelected = function() 
					local nb = tonumber(exports.bro_core:OpenTextInput({ title="Montant", maxInputLength=25, customTitle=true}))
					TriggerServerEvent("property:storage:witdhraw", property, v.type, nb)
				end
			},
		}
		weight = weight + (v.amount*v.weight)
	end
	buttons[#buttons+1] = {
		type  = "button",
		label = "Déposer",
		actions = {
			onSelected = function()
				TriggerServerEvent("items:get", "property:storage:add", nb)
				exports.bro_core:RemoveMenu("storage")
			end
		}
	}
	Subtitle = ""
	if weight > (3/4*maxWeight) then
		Subtitle = property.address..". Poids max ~r~("..weight.."/"..maxWeight..")kg"
	else
		Subtitle = property.address..". Poids max ~g~("..weight.."/"..maxWeight..")kg"
	end
	exports.bro_core:AddMenu("safe", {
		Title = "Coffre",
		Subtitle = Subtitle,
		buttons = buttons
	})
end)

RegisterNetEvent("property:storage:add")

AddEventHandler("property:storage:add", function(inventory)
	local buttons = {}
	local weight = 0
	local maxWeight = 1000

	for k, v in ipairs (inventory) do
		buttons[k] =     {
			type = "button",
			label = v['label'].. " X ".. tostring(v['amount']).. ' ( ' .. tostring(v['amount']*v['weight'])..'kg )',
			actions = {
				onSelected = function() 
					TriggerServerEvent("property:")
				end
			},
		}
		weight = weight + (v.amount*v.weight)
	end
	exports.bro_core:AddMenu("safe", {
		Title = "Coffre",
		Subtitle = "",
		buttons = buttons
	})
end)
-- On nettoie le caca
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	TriggerServerEvent("property:get:all", "property:hide")
end)

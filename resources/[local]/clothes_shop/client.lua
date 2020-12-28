config = {}
config.bindings = {
    interact_position = 51, -- E
}

myclothesSkin = {

}

mySkin = {
}


RegisterNetEvent('clothes_shop:skin:update')

AddEventHandler('clothes_shop:skin:update', function(skin)
    if skin ~= nil then
        mySkin = json.decode(skin)
    end
end)


RegisterNetEvent('player:spawned:clothes')

AddEventHandler('player:spawned:clothes', function()
    TriggerServerEvent('skin:getPlayerSkin', "clothes_shop:skin:update")
end)

function addMenu(max, part, variante, maxVariant, isSkin) 
    buttons = {}
	for i = 0,max do
        buttons[#buttons+1] = {
            text = i,
            hover = {
                callback = function()
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        clothesSkin = myclothesSkin
                        if isSkin then
                            for k,v in ipairs(mySkin) do
                                skin[k] = v
                            end
                            skin[part.."_1"] = i
                        else
                            if part == "arms" then
                                clothesSkin[part] = i
                            else
                                clothesSkin[part.."_1"] = i
                            end
                        end
                        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                    end)
                end
            }
        }
	end

    exports.bro_core:AddMenu("clothes-shop-"..part, {
		title = "Magasin Vêtements ",
		position = 1,
		buttons = buttons
    })

    buttons = {}
    if (variante == true) then
        for i = 0,maxVariant do
            buttons[#buttons+1] = {
                text = i,
                hover = {
                    callback = function()
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            clothesSkin = myclothesSkin
                            if isSkin then
                                for k,v in ipairs(mySkin) do
                                    skin[k] = v
                                end
                                skin[part.."_2"] = i
                            else
                                if part == "arms" then
                                    clothesSkin[part] = i
                                else
                                    clothesSkin[part.."_2"] = i
                                end
                            end
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                }
            }
        end

        exports.bro_core:AddMenu("clothes-shop-"..part.."2", {
            title = "Magasin Vêtements ",
            position = 1,
            buttons = buttons
        })
    end
end


-- open menu loop
Citizen.CreateThread(function()
    exports.bro_core:AddMenu("clothes-shop", {
        title = "Magasin Vêtements ",
        position = 1,
        buttons = {
            {
                text = "Reset",
                openMenu = "reset",
                exec = {
                    callback = function()
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            local price  = 10
                            for k,v in ipairs(mySkin) do
                                skin[k] = v
                            end
                            skin["torso_1"] = 0
                            skin["torso_2"] = 0
                            skin["t_shirt_1"] = 15
                            skin["t_shirt_2"] = 0
                            skin["arms"] = 0
                            skin["pants_1"] = 0
                            skin["pants_2"] = 0 
                            skin["shoes_1"] = 1
                            skin["shoes_2"] = 0 
                            skin["mask_1"] = 0
                            skin["mask_2"] = 0 
                            skin["chain_1"] = 0
                            skin["chain_2"] = 0 
                            skin["helmet_1"] = 8
                            skin["helmet_2"] = 0 
                            skin["glasses_1"] = 0
                            skin["glasses_2"] = 0 
                            skin["bracelets_1"] = -1
                            skin["brecelets_2"] = -1
                            skin["watches_1"] = -1
                            skin["watches_2"] = -1
                            clothesSkin = {}
                            mySkin = {}
                            TriggerServerEvent('skin:save', skin)
                            TriggerServerEvent('skin:clothes:save', clothesSkin)
                            TriggerEvent('skinchanger:loadClothes', skin, myclothesSkin)
                        end)
                    end
                },
            },
            {
                text = "Corps",
                openMenu = "clothes-shop-torso"
            },
           {
                text = "Corps (variante)",
                openMenu = "clothes-shop-torso2"
            },
            {
                text = "T-Shirt",
                openMenu = "clothes-shop-tshirt"
            },
            {
                text = "T-Shirt2 (variante)",
                openMenu = "clothes-shop-tshirt2"
            },
            {
                text = "Bras",
                openMenu = "clothes-shop-arms"
            },
            {
                text = "Pantalon",
                openMenu = "clothes-shop-pants"
            },
            {
                text = "Pantalon (variante)",
                openMenu = "clothes-shop-pants2"
            },
            {
                text = "Chaussures",
                openMenu = "clothes-shop-shoes"
            },
            {
                text = "Chaussures (variante)",
                openMenu = "clothes-shop-shoes2"
            },
            {
                text = "Masques",
                openMenu = "clothes-shop-mask"
            },
            {
                text = "Masques (variante)",
                openMenu = "clothes-shop-mask2"
            },
            {
                text = "Cou",
                openMenu = "clothes-shop-chain"
            },
            {
                 text = "Cou (variante)",
                openMenu = "clothes-shop-chain2"
            },
            {
                text = "Tête",
                openMenu = "clothes-shop-helmet"
            },
            {
                text = "Tête (variante)",
                openMenu = "clothes-shop-helmet2"
            },
            {
                text = "Lunettes",
                openMenu = "clothes-shop-glasses"
            },
            {
                text = "Lunettes (variante)",
                openMenu = "clothes-shop-glasses2"
            },
            {
                text = "Bracelets",
                openMenu = "clothes-shop-bracelets"
            },
            {
                text = "Bracelets (variante)",
                openMenu = "clothes-shop-bracelets2"
            },
            {
                text = "Valider la tenue",
                exec = {
                    callback = function()
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            local price  = 10
                            clothesSkin = myclothesSkin
                            for k,v in ipairs(mySkin) do
                                skin[k] = v
                            end
                            TriggerServerEvent("account:player:liquid:add", "", price * -1)
                            exports.bro_core:Notification('Vous avez modifié vos vétements. ~g~'..price..'$')
                            TriggerServerEvent('skin:save', skin)
                            TriggerServerEvent('skin:clothes:save', clothesSkin)
                        end)
                    end
                },
            },
        },
    })
    addMenu(290, "torso", true, 10, true)
    addMenu(144, "tshirt", true, 10)
    addMenu(168, "arms", false)
    addMenu(115, "pants", true, 10, true)
    addMenu(91, "shoes", true, 10)
    addMenu(148, "mask", true, 10)
    addMenu(132, "chain", true, 10)
    addMenu(136, "helmet", true, 10)
    addMenu(29, "glasses", true, 10)
    addMenu(31, "watches", true, 10)
    addMenu(9, "bracelets", true, 10)

    exports.bro_core:AddArea("clothes-shops", {
        marker = {
            type = 1,
            weight = 1,
            height = 1,
            red = 255,
            green = 255,
            blue = 153,
        },
        trigger = {
            weight = 1,
            enter = {
                callback = function()
                    exports.bro_core:HelpPromt("Magasin : ~INPUT_PICKUP~")
                    zoneType = "clothes-shop"
                end
            },
            exit = {
                callback = function()
                    zoneType = nil
                    zone = 0
                end
            },
        },
        blip = {
            text = "Vêtements",
            colorId = 82,
            imageId = 366,
        },
        locations = {
            {
                x= 428.72677612305, y=-800.1708984375, z=29.49112701416
            },
            {
                x=72.586585998535, y=-1399.2108154297,z=29.376140594482
            },
        },
    })
	-- main loop
    while true do
		Citizen.Wait(0)	
		if zoneType ~= nil and IsControlJustPressed(1,config.bindings.interact_position) then
			if zoneType == "clothes-shop" then
				exports.bro_core:OpenMenu("clothes-shop")
			end
		end
	end
end)
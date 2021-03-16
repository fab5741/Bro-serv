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
            type="button",
            label = i,
            actions = {
                onActive = function()
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

    exports.bro_core:AddSubMenu("clothesshop"..part, {
        parent = "shop",
        Title = "Magasin Vêtements ",
        Subtitle = part,
		buttons = buttons
    })

    buttons = {}
    if (variante == true) then
        for i = 0,maxVariant do
            buttons[#buttons+1] = {
                type ="button",
                label = i,
                actions = {
                    onActive = function()
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

        exports.bro_core:AddSubMenu("clothesshop"..part.."2", {
            parent= "shop",
            Title = "Magasin Vêtements ",
            Subtitle = part,
            buttons = buttons
        })
    end
end


-- open menu loop
Citizen.CreateThread(function()
    exports.bro_core:AddArea("clothes-shops", {
        marker = {
            type = 1,
            weight = 1,
            height = 0.2,
            red = 200,
            green = 20,
            blue = 20,
        },
        trigger = {
            weight = 1,
            enter = {
                callback = function()
                    exports.bro_core:HelpPromt("Magasin : ~INPUT_PICKUP~")
                    exports.bro_core:Key("E", "E", "Magasin", function()
                        exports.bro_core:AddMenu("shop", {
                            Title = "Magasin",
                            Subtitle = "Vêtements",
                            buttons = {
                                {
                                    type = "button",
                                    label = "Reset",
                                    actions = {
                                        onSelected = function()
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
                                    type = "button",
                                    label = "Corps",
                                    subMenu = "clothesshoptorso"
                                },
                               {
                                    type = "button",
                                    label = "Corps (variante)",
                                    subMenu = "clothesshoptorso2"
                                },
                                {
                                    type = "button",
                                    label = "TShirt",
                                    subMenu = "clothesshoptshirt"
                                },
                                {
                                    type = "button",
                                    type = "button",
                                    label = "TShirt2 (variante)",
                                    subMenu = "clothesshoptshirt2"
                                },
                                {
                                    type = "button",
                                    label = "Bras",
                                    subMenu = "clothesshoparms"
                                },
                                {
                                    type = "button",
                                    label = "Pantalon",
                                    subMenu = "clothesshoppants"
                                },
                                {
                                    type = "button",
                                    label = "Pantalon (variante)",
                                    subMenu = "clothesshoppants2"
                                },
                                {
                                    type = "button",
                                    label = "Chaussures",
                                    subMenu = "clothesshopshoes"
                                },
                                {
                                    type = "button",
                                    label = "Chaussures (variante)",
                                    subMenu = "clothesshopshoes2"
                                },
                                {
                                    type = "button",
                                    label = "Masques",
                                    subMenu = "clothesshopmask"
                                },
                                {
                                    type = "button",
                                    label = "Masques (variante)",
                                    subMenu = "clothesshopmask2"
                                },
                                {
                                    type = "button",
                                    label = "Cou",
                                    subMenu = "clothesshopchain"
                                },
                                {
                                     label = "Cou (variante)",
                                    subMenu = "clothesshopchain2"
                                },
                                {
                                    type = "button",
                                    label = "Tête",
                                    subMenu = "clothesshophelmet"
                                },
                                {
                                    type = "button",
                                    label = "Tête (variante)",
                                    subMenu = "clothesshophelmet2"
                                },
                                {
                                    type = "button",
                                    label = "Lunettes",
                                    subMenu = "clothesshopglasses"
                                },
                                {
                                    type = "button",
                                    label = "Lunettes (variante)",
                                    subMenu = "clothesshopglasses2"
                                },
                                {
                                    type = "button",
                                    label = "Bracelets",
                                    subMenu = "clothesshopbracelets"
                                },
                                {
                                    type = "button",
                                    label = "Bracelets (variante)",
                                    subMenu = "clothesshopbracelets2"
                                },
                                {
                                    type = "button",
                                    label = "Valider la tenue",
                                    actions = {
                                        onSelected = function()
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
                    end)
                end
            },
            exit = {
                callback = function()
                    exports.bro_core:RemoveMenu("shop")
                    exports.bro_core:Key("E", "E", "Interaction", function()
                    end)
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
end)

-- On nettoie le caca
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	exports.bro_core:RemoveMenu("shop")
end)


config = {}
config.bindings = {
    interact_position = 51, -- E
}

myclothesSkin = {

}

mySkin = {

}

function addMenu(max, part, variante, maxVariant, isSkin) 
    buttons = {}
	for i = 0,max do
        buttons[#buttons+1] = {
            text = i,
            exec = {
                callback = function()
                    if isSkin then
                        myclothesSkin[part.."_1"] = i
                    else
                        mySkin[part.."_1"] = i
                    end

                end
            },
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

    exports.bf:AddMenu("clothes-shop-"..part, {
		title = "Magasin Vêtements ",
		position = 1,
		buttons = buttons
    })

    if (variante == true) then
        for i = 0,maxVariant do
            buttons[#buttons+1] = {
                text = i,
                hover = {
                    callback = function()
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            clothesSkin[part.."_2"] = i
                            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                        end)
                    end
                }
            }
        end

        exports.bf:AddMenu("clothes-shop-"..part.."2", {
            title = "Magasin Vêtements ",
            position = 1,
            buttons = buttons
        })
    end
end

Citizen.CreateThread(function()
	exports.bf:AddMenu("clothes-shop", {
		title = "Magasin Vêtements ",
		position = 1,
		buttons = {
			{
				text = "Corps",
				openMenu = "clothes-shop-torso"
            },
            {
				text = "Corps (variante)",
				openMenu = "clothes-shop-torso2"
            },
            {
				text = "Bras",
				openMenu = "clothes-shop-arms"
            },
            {
				text = "Bras (variante)",
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
				text = "Montres",
				openMenu = "clothes-shop-glasses"
            },
            {
				text = "Montres (variante)",
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
                        --save to bdd
                        TriggerServerEvent("clothes:save", myclothesSkin)
                        TriggerServerEvent("skin:save", mySkin)
                    end
                },
			},
		},
    })
    addMenu(290, "torso", true, 10, true)
    addMenu(168, "arms", true, 10)
    addMenu(115, "pants", true, 10, true)
    addMenu(91, "shoes", true, 10)
    addMenu(148, "mask", true, 10)
    addMenu(132, "chain", true, 10)
    addMenu(144, "shirt", true, 10)
    addMenu(136, "helmet", true, 10)
    addMenu(29, "glasses", true, 10)
    addMenu(31, "watches", true, 10)
    addMenu(9, "bracelets", true, 10)

    exports.bf:AddArea("clothes-shops", {
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
                    exports.bf:HelpPromt("Magasin : ~INPUT_PICKUP~")
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
            colorId = 18,
            imageId = 51,
        },
        locations = {
            {
                x=72.2545394897461,  y=-1399.10229492188, z=29.3761386871338
            },
            {
                x=-703.77685546875,  y=-152.258544921875, z=37.4151458740234
            },
            {
                x=-167.863754272461, y=-298.969482421875, z=39.7332878112793
            },
            {
                x=428.694885253906,  y=-800.1064453125,   z=29.4911422729492
            },
            {
                x=-829.413269042969, y=-1073.71032714844, z=11.3281078338623
            },
            {
                x=-1447.7978515625,  y=-242.461242675781, z=49.8207931518555
            },
            {
                x=11.6323690414429,  y=6514.224609375,    z=31.8778476715088
            },
            {
                x=123.64656829834,   y=-219.440338134766, z=54.5578384399414
            },
            {
                x=1696.29187011719,  y=4829.3125,         z=42.0631141662598
            },
            {
                x=618.093444824219,  y=2759.62939453125,  z=42.0881042480469
            },
            {
                x=1190.55017089844,  y=2713.44189453125,  z=38.2226257324219
            },
            {
                x=-1193.42956542969, y=-772.262329101563, z=17.3244285583496
            },
            {
                x=-3172.49682617188, y=1048.13330078125,  z=20.8632030487061
            },
            {
                x=-1108.44177246094, y=2708.92358398438,  z=19.1078643798828
            },
            {
                x=125.640, y=-763.056, z=45.752
            },
        },
    })
end)


-- open menu loop
Citizen.CreateThread(function()
	-- main loop
    while true do
		Citizen.Wait(0)	
		if zoneType ~= nil and IsControlJustPressed(1,config.bindings.interact_position) then
			if zoneType == "clothes-shop" then
				exports.bf:OpenMenu("clothes-shop")
			end
		end
	end
end)

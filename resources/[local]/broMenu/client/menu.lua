exports.bf:AddMenu("bro", {
    title = "Bro Menu",
    menuTitle = "Job",
    position = 1,
    buttons = {
        {
            text = "Portefeuille",
            exec = {
                callback = function()
                    TriggerServerEvent("account:player:liquid:get", "bf:liquid")
                end
            },
        },
        {
            text = "Inventaire",
            exec = {
                callback = function()
                    TriggerServerEvent("items:get", "bf:items")
                end
            },
        },
        {
            text = "Vehicules",
            exec = {
                callback = function()
                    TriggerServerEvent("vehicles:get:all", "bf:vehicles")
                end
            },
        },
        {
            text = "Vetements",
            openMenu = "bro-clothes"
        },
        {
            text = "Quitter son travail",
            exec = {
                callback = function()
                    if  exports.bf:OpenTextInput({ maxInputLength = 10 , title = "Oui, pour confirmer", customTitle = true}) == "oui" then
                        -- on quitte le job
                        TriggerServerEvent("job:set", 1, "Chomeur")
                        Wait(1000)
                        TriggerServerEvent("job:get", "jobs:refresh")
                    end
                end
            },
        },
    },
})
exports.bf:AddMenu("bro-wallet", {
    title = "Portefeuille",
    position = 1,
})
exports.bf:AddMenu("bro-items", {
    title = "Inventaire",
    position = 1,
})
exports.bf:AddMenu("bro-items-item", {
    title = "Item",
    position = 1,
})
exports.bf:AddMenu("bro-wallet-character", {
    title = "Personnage",
    menuTitle = "Léon Paquin (17/05/1992)",
    position = 1,
    buttons = {
        {
            text = "Nom",
            exec = {
                callback = function()
                    lastname = exports.bf:OpenTextInput({ title="Nom", maxInputLength=25, customTitle=true})
                    TriggerServerEvent("bro:set", "lastname", lastname, "bro:set")
                end
            }
        },
        {
            text = "Prénom",
            exec = {
                callback = function()
                    firstname = exports.bf:OpenTextInput({ title="Prénom", maxInputLength=25, customTitle=true})
                    TriggerServerEvent("bro:set", "firstname", firstname, "bro:set")
                end
            }
        },
        {
            text = "Date de naissance",
            exec = {
                callback = function()
                    birth = exports.bf:OpenTextInput({ title="Date de naissance (01/01/1999)", maxInputLength=10, customTitle=true})
                    TriggerServerEvent("bro:set", "birth", birth, "bro:set")
                end
            }
        },
    },
})
exports.bf:AddMenu("bro-vehicles", {
    title = "Vehicules",
    position = 1,
})
exports.bf:AddMenu("bro-clothes", {
    title = "Vetements",
    position = 1,
    buttons = {
        {
            text = "Remettre",
            exec = {
                callback = function()
                    TriggerServerEvent("bro:skin:get", "bromenu:skin:reset")
                end
            },
        },
        {
            text = "T-Shirt",
            exec = {
                callback = function()
                    print("bromenu")
                    TriggerEvent('bromenu:koszulka')
                end
            },
        },
        {
            text = "Pantalon",
            exec = {
                callback = function()
                    TriggerEvent('bromenu:spodnie')
                end
            },
        },
        {
            text = "Chaussures",
            exec = {
                callback = function()
                    TriggerEvent('bromenu:buty')
                end
            },
        },
    }
})

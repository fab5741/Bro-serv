Menus = {

}
--
-- AddMenu
--
function AddMenu(...)
    local args = {...}

    local name = args[1]
    local settings = args[2]
    if settings.Subtitle == nil then
        settings.Subtitle = ""
    end
    if settings.X == nil then
        settings.X = 80
    end
    if settings.Y == nil then
        settings.Y = 400
    end
    Menus[name] = {
            menu = RageUI.CreateMenu(
                settings.Title,
                settings.Subtitle,
                settings.X,
                settings.Y,
                settings.TextureDictionary,
                settings.TextureName,
                settings.R,
                settings.G,
                settings.B,
                settings.A
            ),
            buttons = settings.buttons
    }
    Menus[name].menu:DisplayPageCounter(false)

    RageUI.Visible(Menus[name].menu, not RageUI.Visible(Menus[name].menu))
end

--
-- Remove Menu
--
function RemoveMenu(name)
    Menus[name] = nil
end

--
-- AddSubMenu
--
function AddSubMenu(...)
    local args = {...}

    local name = args[1]
    local settings = args[2]
    if settings.Subtitle == nil then
        settings.Subtitle = ""
    end
    if settings.X == nil then
        settings.X = 80
    end
    if settings.Y == nil then
        settings.Y = 400
    end
    Menus[name] = {
            menu = RageUI.CreateSubMenu(
                Menus[settings.parent].menu,
                settings.Title,
                settings.Subtitle,
                settings.X,
                settings.Y,
                settings.TextureDictionary,
                settings.TextureName,
                settings.R,
                settings.G,
                settings.B,
                settings.A
            ),
            buttons = settings.buttons
    }
    Menus[name].menu:DisplayPageCounter(false)
    if settings.visible then
        RageUI.Visible(Menus[settings.parent].menu, not RageUI.Visible(Menus[settings.parent].menu))
        RageUI.Visible(Menus[name].menu, not RageUI.Visible(Menus[name].menu))
    end
end

function MenuIsOpen(name)
    return Menus[name] and Menus[name].menu and RageUI.Visible(Menus[name].menu)
end

--
-- Add keys
-- 
function Key(name, input, description, cb)
    Keys.Register(name, input, description, cb)
end

function MenuClose(...)
    local args = {...}

    local name = args[1]
    local cb = args[2]
    Menus[name].menu.Closed = cb
end

--
-- Show menu
--
function MenuFrame()
    Citizen.CreateThread(function()
        while (true) do
            Citizen.Wait(1.0)
            for k,v in pairs(Menus) do
                RageUI.IsVisible(v.menu, function()
                    if v.buttons then
                        for kk,vv in pairs(v.buttons) do
                            if vv.type == "button" then
                                local style = {}
                                if vv.style then
                                    style = vv.style
                                end
                                local actions = {}
                                if vv.actions then
                                    actions = vv.actions
                                end     
                                local subMenu = nil
                                if vv.subMenu then
                                    subMenu = Menus[vv.subMenu].menu
                                end                        
                                if vv.type == "button" then
                                    RageUI.Button(vv.label or "N/D", nil, style, true, actions, subMenu);
                                end
                            elseif vv.type == "separator" then
                                RageUI.Separator(vv.label)
                            end
                        end
                    end
                end)
            end
        end
    end)
end
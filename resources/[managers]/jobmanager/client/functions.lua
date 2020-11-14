function drawBlip(location)
    if location.blip and location.coords then
        local blip = AddBlipForCoord(location.coords)
        SetBlipSprite(blip, location.blip.sprite)
        SetBlipScale(blip, location.blip.scale)
        SetBlipColour(blip, location.blip.color)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(location.string)
        EndTextCommandSetBlipName(blip)
    end
end

function DrawTextOnSCreen(x, y, string)
    SetTextFont(0)
    SetTextScale(0.0, 0.3)
    SetTextColour(128, 128, 128, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(0, 1, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(string)
    DrawText(x, y)
end

function ServiceOn()
	isInService = true
	TriggerServerEvent("job:takeService")
end

function ServiceOff()
	isInService = false
	TriggerServerEvent("job:breakService")
	
	if config.enableOtherCopsBlips == true then
		allServiceCops = {}
		
		for k, existingBlip in pairs(blipsCops) do
			RemoveBlip(existingBlip)
		end
		blipsCops = {}
	end
end


function CloseMenu()
	SendNUIMessage({
		action = "close"
	})
	
	anyMenuOpen.menuName = ""
	anyMenuOpen.isActive = false
end

function DisplayHelpText(str)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end


function DrawMyMarker(playerCoords, location, job)
    local distance = #(playerCoords - location.coords)

    if distance < config.DrawDistance then
        DrawMarker(config.Marker.type,  location.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, config.Marker.x, config.Marker.y, config.Marker.z, config.Marker.r, config.Marker.g, config.Marker.b, config.Marker.a, false, false, 2, config.Marker.rotate, nil, nil, false)
        if distance < config.Marker.x then
            TriggerEvent('job:hasEnteredMarker', location, job)
        end
    end
end

local buttons = {}
local isCollecting = false
local lastLocation = false


function collect(location, job)
    buttons = {}

    for k, v in pairs(location.items) do
        buttons[#buttons+1] = {name = tostring(v.label), func = "collectItem", params = v.type}
    end

    buttons[#buttons+1] = {name = "Arreter le farming", func = "CloseMenu", params = ""}
    
    if anyMenuOpen.menuName ~= "collect" and not anyMenuOpen.isActive then
		SendNUIMessage({
			title = "Collecte",
			subtitle = "Céréales",
			buttons = buttons,
			action = "setAndOpen"
		})
		
		anyMenuOpen.menuName = "collect"
        anyMenuOpen.isActive = true
        lastLocation = location
		if config.enableVersionNotifier then
			TriggerServerEvent('job:UpdateNotifier')
		end
	end
end

local timeCollecting = 0

function collectItem(item)
    for k, v in pairs(lastLocation.items) do
        if(item == v.type)then
            item = v
        end
    end
    isCollecting = true
    Wait(timeCollecting)
    TriggerServerEvent('items:add', item.type,  item.amount) 
    TriggerEvent("notify:SendNotification", 
    {text= "Vous avez collecté", type = "info", timeout = 5000})
    CloseMenu()
    isCollecting = false
end


local buttons = {}
local isprocessing = false
local lastLocation = false
function process(location, job)
	for k in ipairs (buttons) do
		buttons [k] = nil
	end

    for k, v in pairs(location.items) do
        buttons[#buttons+1] = {name = tostring(v.label), func = "processItem", params = v.type}
    end

    buttons[#buttons+1] = {name = "Arreter la transformation", func = "CloseMenu", params = ""}
    
    if anyMenuOpen.menuName ~= "process" and not anyMenuOpen.isActive then
		SendNUIMessage({
			title = "Transformation",
			subtitle = "Moulin",
			buttons = buttons,
			action = "setAndOpen"
		})
		
		anyMenuOpen.menuName = "process"
        anyMenuOpen.isActive = true
        lastLocation = location
		if config.enableVersionNotifier then
			TriggerServerEvent('job:UpdateNotifier')
		end
	end
end

local timeprocessing = 0

function processItem(item)
    for k, v in pairs(lastLocation.items) do
        if(item == v.type)then
            item = v
        end
    end
    isprocessing = true
    Wait(timeprocessing)
    
    TriggerServerEvent('items:process', item.type,  item.amount, item.to,  item.amountTo) 
    CloseMenu()
    isprocessing = false
end



function sell(location, job)
    buttons = {}

    for k, v in pairs(location.items) do
        buttons[#buttons+1] = {name = tostring(v.label), func = "sellItems", params = v.type}
    end

    buttons[#buttons+1] = {name = "Stopper la vente", func = "CloseMenu", params = ""}
    
    if anyMenuOpen.menuName ~= "process" and not anyMenuOpen.isActive then
		SendNUIMessage({
			title = "Revente",
			subtitle = "Grossiste superette",
			buttons = buttons,
			action = "setAndOpen"
		})
		
		anyMenuOpen.menuName = "process"
        anyMenuOpen.isActive = true
        lastLocation = location
		if config.enableVersionNotifier then
			TriggerServerEvent('job:UpdateNotifier')
		end
	end
end

local timeprocessing = 0
local isSelling = false

function sellItems(item)
    for k, v in pairs(lastLocation.items) do
        if(item == v.type)then
            item = v
        end
    end
    isSelling = true
    --Wait(isSelling)
    
    TriggerServerEvent('jobs:sell', item, "TwentyFourSeven")
    CloseMenu()
    isSelling = false
end



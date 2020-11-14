local buttonsCategories = {}
local buttonsAnimation = {}
local buttonsCitizen = {}
local buttonsFine = {}
local buttonsVehicle = {}
local buttonsProps = {}

function load_menu()
	for k in ipairs (buttonsCategories) do
		buttonsCategories [k] = nil
	end
	
	for k in ipairs (buttonsAnimation) do
		buttonsAnimation [k] = nil
	end
	
	for k in ipairs (buttonsCitizen) do
		buttonsCitizen [k] = nil
	end
	
	for k in ipairs (buttonsFine) do
		buttonsFine [k] = nil
	end
	
	for k in ipairs (buttonsVehicle) do
		buttonsVehicle [k] = nil
	end
	
	for k in ipairs (buttonsProps) do
		buttonsProps [k] = nil
	end
	
	buttonsCategories[#buttonsCategories+1] = {name = "Soins", func = "heal", params = ""}
end


function ToggleLSMSMenu()
	if(anyMenuOpen.menuName ~= "lsmsmenu") then
		SendNUIMessage({
			title = "LSMS",
			subtitle = "Menu",
			buttons = buttonsCategories,
			action = "setAndOpen"
		})
		
		anyMenuOpen.menuName = "lsmsmenu"
		anyMenuOpen.isActive = true
	else
		if((anyMenuOpen.menuName ~= "lsmsmenu" ) and anyMenuOpen.isActive) then
			CloseMenu()
			ToggleLSMSMenu()
		else
			CloseMenu()
		end
	end
end

function BackMenuLSMS()
	if(anyMenuOpen.menuName == "lsmsmenu-anim") then
		CloseMenu()
		ToggleLSMSMenu()
	else
		CloseMenu()
		OpenCitizenMenu()
	end
end

function heal()
	print("heal")
	Citizen.CreateThread(function()
		local pos = GetEntityCoords(PlayerPedId())
		local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
		local _, _, _, _, pedHandle = GetRaycastResult(rayHandle)
		if DoesEntityExist(pedHandle) and IsEntityAPed(pedHandle) then
			print("heal dude")
		else
			TriggerEvent("lspd:notify",  "CHAR_AGENT14", 1,"Pas de joueur à proximité", false)
		end
	end)
end
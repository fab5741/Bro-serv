local buttons = {}
local lockChanging = false

function clockIn(job)
	TriggerServerEvent("job:get:player", "job:add:uniform")
	TriggerServerEvent("job:clock", true, job)
	exports.bro_core:RemoveMenu("lockers")
end

function clockOut(job)
	TriggerServerEvent("player:get", "job:remove:uniform")
	TriggerServerEvent("job:clock", false, job)
	exports.bro_core:RemoveMenu("lockers")
end


RegisterNetEvent("job:add:uniform")

-- source is global here, don't add to function
AddEventHandler('job:add:uniform', function(job)
	-- TODO: add prop, local prop_name = 'prop_cs_wrench'
	exports.bro_core:actionPlayer(2000, "Vêtements", "amb@world_human_gardener_plant@male@enter", "enter",
	function()
		TriggerEvent('skinchanger:getSkin', function(skin)
			local skin = json.decode(job.skin)
			local clothes
			if skin.sex == 0 then
				clothes = config.jobs[job.name].clothes[job.grade].male
			else
				clothes = config.jobs[job.name].clothes[job.grade].female
			end
			TriggerEvent('skinchanger:loadClothes', skin, clothes)
		end)
	end)
end)

RegisterNetEvent("job:remove:uniform")

-- source is global here, don't add to function
AddEventHandler('job:remove:uniform', function(skin)
	exports.bro_core:actionPlayer(2000, "Vêtements", "amb@world_human_gardener_plant@male@enter", "enter",
	function()
		if skin.clothes ~= nil then
			TriggerEvent('skinchanger:loadClothes', json.decode(skin.skin), json.decode(skin.clothes))
		else
			TriggerEvent('skinchanger:loadSkin', json.decode(skin.skin))
		end
		TriggerServerEvent("job:breakService")
	end)
end)
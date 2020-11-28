local buttons = {}
function clockIn(job)
	TriggerServerEvent("job:get:player", "job:add:uniform")
	TriggerServerEvent("job:clock", true, job)
	exports.bf:CloseMenu("lockers")
end

function clockOut(job)
	TriggerServerEvent("player:get", "job:remove:uniform")
	TriggerServerEvent("job:clock", false, job)
	exports.bf:CloseMenu("lockers")
end


RegisterNetEvent("job:add:uniform")

-- source is global here, don't add to function
AddEventHandler('job:add:uniform', function(job)
	local skin = json.decode(job.skin)
	local clothes
	if skin.sex == 0 then
		clothes = config.jobs[job.name].clothes[job.grade].male
	else
		clothes = config.jobs[job.name].clothes[job.grade].female
	end
	TriggerEvent('skinchanger:loadClothes', skin, clothes)
end)

RegisterNetEvent("job:remove:uniform")

-- source is global here, don't add to function
AddEventHandler('job:remove:uniform', function(skin)
	TriggerEvent('skinchanger:loadClothes', json.decode(skin.skin), json.decode(skin.clothes))
	TriggerServerEvent("job:breakService")
end)
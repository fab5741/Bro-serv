local inServiceCops = {}

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then	
		inServiceCops[source] = nil
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("lspd:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('lspd:takeService')
AddEventHandler('lspd:takeService', function()
	print("take serviceserver")
	local sourceValue = source
	for k,v in pairs(GetPlayerIdentifiers(sourceValue))do
		
			
		  if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		  elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		  elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		  elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		  elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		  elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		  end
	end

	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE players set onDuty=1 where fivem = @fivem',
		{['fivem'] =  discord},
		function(res)
		end)
	end)

	if(not inServiceCops[source]) then
		inServiceCops[source] = getPlayerID(source)
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("lspd:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('lspd:breakService')
AddEventHandler('lspd:breakService', function()
	local sourceValue = source
	for k,v in pairs(GetPlayerIdentifiers(sourceValue))do
		
			
		  if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		  elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		  elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		  elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		  elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		  elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		  end
	end

	MySQL.ready(function ()
		MySQL.Async.fetchAll('UPDATE players set onDuty=0 where fivem = @fivem',
		{['fivem'] =  discord},
		function(res)
		end)
	end)

	if(not inServiceCops[source]) then
		inServiceCops[source] = getPlayerID(source)
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("lspd:resultAllCopsInService", i, inServiceCops)
		end
	end
	if(inServiceCops[source]) then
		inServiceCops[source] = nil
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("lspd:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('lspd:getAllCopsInService')
AddEventHandler('lspd:getAllCopsInService', function()
	TriggerClientEvent("lspd:resultAllCopsInService", source, inServiceCops)
end)

RegisterServerEvent('lspd:removeWeapons')
AddEventHandler('lspd:removeWeapons', function(target)
	local identifier = getPlayerID(target)
	TriggerClientEvent("lspd:removeWeapons", target)
end)

RegisterServerEvent('lspd:dragRequest')
AddEventHandler('lspd:dragRequest', function(t)
	TriggerClientEvent("lspd:notify", source, "CHAR_AGENT14", 1, "Porter", false, "Porter".. GetPlayerName(t) .. "")
	TriggerClientEvent('lspd:toggleDrag', t, source)
end)

RegisterServerEvent('lspd:finesGranted')
AddEventHandler('lspd:finesGranted', function(target, amount)
	TriggerClientEvent('lspd:payFines', target, amount, source)
	TriggerClientEvent("lspd:notify", source, "CHAR_AGENT14", 1, "Amende", false, "Demande de paiement amende de : "..amount.." $ ")
end)

RegisterServerEvent('lspd:finesETA')
AddEventHandler('lspd:finesETA', function(officer, code)
	if(code==1) then
		TriggerClientEvent("lspd:notify", officer, "CHAR_AGENT14", 1, "Amende", false, "Amende déjà en cours")
	elseif(code==2) then
		TriggerClientEvent("lspd:notify", officer, "CHAR_AGENT14", 1, "Amende", false, "Temps écoulé")
	elseif(code==3) then
		TriggerClientEvent("lspd:notify", officer, "CHAR_AGENT14", 1, "Amende", false, "Refus de payer l'amende")
	elseif(code==0) then
		TriggerClientEvent("lspd:notify", officer, "CHAR_AGENT14", 1, "Amende", false, "Amende payée")
	end
end)

RegisterServerEvent('lspd:cuffGranted')
AddEventHandler('lspd:cuffGranted', function(t)
	TriggerClientEvent("lspd:notify", source, "CHAR_AGENT14", 1, "Menottes", false, "Vous avez menotté le joueur")
	TriggerClientEvent('lspd:getArrested', t)
end)

RegisterServerEvent('ChecklspdVeh')
AddEventHandler('ChecklspdVeh', function(vehicle)
	TriggerClientEvent('FinishlspdCheckForVeh',source)
	TriggerClientEvent('lspdveh:spawnVehicle', source, vehicle)
end)

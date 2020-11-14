local inServiceCops = {}

function addCop(identifier)
	exports.ghmattimysql:scalar("SELECT identifier FROM lspd WHERE identifier = @identifier", { ['identifier'] = tostring(identifier)}, function (result)
		if not result then
			exports.ghmattimysql:execute("INSERT INTO lspd (`identifier`) VALUES ('"..identifier.."')", {['@identifier'] = identifier})
		end
	end)
end

function setDept(source, player,playerDept)
	local identifier = getPlayerID(player)
	if(config.departments.label[playerDept]) then
			exports.ghmattimysql:execute("SELECT * FROM lspd WHERE identifier = '"..identifier.."'", { ['@identifier'] = identifier}, function (result)
				if(result[1]) then
					if(result[1].dept ~= playerDept) then
						exports.ghmattimysql:execute("UPDATE lspd SET dept="..playerDept.." WHERE identifier='"..identifier.."'", { ['identifier'] = identifier})
						TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("command_received"))
						TriggerClientEvent("lspd:notify", player, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("new_dept") .. " " .. config.departments.label[playerDept])
						TriggerClientEvent('lspd:receiveIsCop', source, result[1].rank, playerDept)
					else
						TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("same_dept"))
					end
				else
					TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("player_not_cop"))
				end
			end)
	else
		TriggerClientEvent('chatMessage', source, i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("dept_not_exist"))
	end
end

function remCop(identifier)
	exports.ghmattimysql:execute("DELETE FROM lspd WHERE identifier = '"..identifier.."'", { ['identifier'] = identifier})
end

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then	
		inServiceCops[source] = nil
		
		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("lspd:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('lspd:checkIsCop')
AddEventHandler('lspd:checkIsCop', function()
	local identifier = getPlayerID(source)
	local src = source
	
	if config.useCopWhitelist then
		exports.ghmattimysql:scalar("SELECT `identifier` FROM lspd WHERE identifier = @identifier", { ['identifier'] = identifier}, function(result)
			if not result then
				TriggerClientEvent('lspd:receiveIsCop', src, -1)
			else
				exports.ghmattimysql:execute("SELECT * FROM lspd WHERE identifier = @identifier", { ['identifier'] = identifier}, function(data)
					if data then
						TriggerClientEvent('lspd:receiveIsCop', src, data[1].rank, data[1].dept)
					end
				end)
			end
		end)
	else
		TriggerClientEvent('lspd:receiveIsCop', src, 0, 1)
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

RegisterServerEvent('lspd:confirmUnseat')
AddEventHandler('lspd:confirmUnseat', function(t)
	TriggerClientEvent("lspd:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("unseat_sender_notification_part_1") .. GetPlayerName(t) .. i18n.translate("unseat_sender_notification_part_2"))
	TriggerClientEvent('lspd:unseatme', t)
end)

RegisterServerEvent('lspd:dragRequest')
AddEventHandler('lspd:dragRequest', function(t)
	TriggerClientEvent("lspd:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("drag_sender_notification_part_1").. GetPlayerName(t) .. i18n.translate("drag_sender_notification_part_2"))
	TriggerClientEvent('lspd:toggleDrag', t, source)
end)

RegisterServerEvent('lspd:finesGranted')
AddEventHandler('lspd:finesGranted', function(target, amount)
	TriggerClientEvent('lspd:payFines', target, amount, source)
	TriggerClientEvent("lspd:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("send_fine_request_part_1")..amount..i18n.translate("send_fine_request_part_2")..GetPlayerName(target))
end)

RegisterServerEvent('lspd:finesETA')
AddEventHandler('lspd:finesETA', function(officer, code)
	if(code==1) then
		TriggerClientEvent("lspd:notify", officer, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("already_have_a_pendind_fine_request"))
	elseif(code==2) then
		TriggerClientEvent("lspd:notify", officer, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("request_fine_timeout"))
	elseif(code==3) then
		TriggerClientEvent("lspd:notify", officer, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("request_fine_refused"))
	elseif(code==0) then
		TriggerClientEvent("lspd:notify", officer, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, GetPlayerName(source)..i18n.translate("request_fine_accepted"))
	end
end)

RegisterServerEvent('lspd:cuffGranted')
AddEventHandler('lspd:cuffGranted', function(t)
	TriggerClientEvent("lspd:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("toggle_cuff_player_part_1")..GetPlayerName(t)..i18n.translate("toggle_cuff_player_part_2"))
	TriggerClientEvent('lspd:getArrested', t)
end)

RegisterServerEvent('lspd:forceEnterAsk')
AddEventHandler('lspd:forceEnterAsk', function(t, v)
	TriggerClientEvent("lspd:notify", source, "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("force_player_get_in_vehicle_part_1")..GetPlayerName(t)..i18n.translate("force_player_get_in_vehicle_part_2"))
	TriggerClientEvent('lspd:forcedEnteringVeh', t, v)
end)

RegisterServerEvent('ChecklspdVeh')
AddEventHandler('ChecklspdVeh', function(vehicle)
	TriggerClientEvent('FinishlspdCheckForVeh',source)
	TriggerClientEvent('lspdveh:spawnVehicle', source, vehicle)
end)

RegisterServerEvent('lspd:GetPayChecks')
AddEventHandler('lspd:GetPayChecks', function(t)
	local identifier = getPlayerID(source)
	local src = source
	
	exports.ghmattimysql:scalar("SELECT `amount` FROM lspd WHERE identifier = @identifier", { ['identifier'] = identifier}, function(result)
		if result then		
			data = json.encode(result)
			print(data)
			TriggerClientEvent('lspd:receivePaycheck', src, data)
		end
	end)
end)

RegisterServerEvent('lspd:TransferPayCheck')
AddEventHandler('lspd:TransferPayCheck', function(t)
	local identifier = getPlayerID(source)
	local src = source
	
	exports.ghmattimysql:scalar("SELECT `amount` FROM lspd WHERE identifier = @identifier", { ['identifier'] = identifier}, function(result)
		if result then		
			data = json.encode(result)
			salary = config.weekly_salary + tonumber(data)
			local values = { "lspd", "amount", salary, { ["identifier"] = identifier } }
			exports.ghmattimysql:execute("UPDATE ?? SET ?? = ? WHERE ?", values, function(data)
				if data then
					TriggerClientEvent('lspd:receivePaycheck', src, salary)
				end
			end)
		end
	end)
end)
RegisterCommand("CopAddAdmin", function(source,args,raw)
	if #args ~= 1 then
		RconPrint("Usage: CopAddAdmin [ingame-id]\n")
		CancelEvent()
		return
	else
		local maxi = -1
		for key, value in pairs(config.rank.label) do
			if key > maxi then
				maxi = key
			end
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player is not ingame\n")
			CancelEvent()

			return
		end

		local identifier = getPlayerID(tonumber(args[1]))
		exports.ghmattimysql:scalar("SELECT identifier FROM lspd WHERE identifier = @identifier", {['identifier'] = identifier}, function(result)
			if not result then
				exports.ghmattimysql:execute("INSERT INTO lspd (`identifier`, `dept`, `rank`) VALUES (@identifier, @dept, @maxi)", { ['identifier'] = identifier, ['dept'] = 1, ['maxi'] = maxi})
				TriggerClientEvent("lspd:notify", tonumber(args[1]), "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("become_cop_success"))					
				
				RconPrint(GetPlayerName(tonumber(args[1])) .. " is now added to the lspd database.\n")
				TriggerClientEvent('lspd:receiveIsCop', tonumber(args[1]), maxi, 1)
			else
				RconPrint(GetPlayerName(tonumber(args[1])) .. ' already exists.\n')
			end
		end)
		CancelEvent()
	end
end, true)

RegisterCommand("CopAdd", function(source,args,raw)
	if #args ~= 1 then
		RconPrint("Usage: CopAdd [ingame-id]\n")
		CancelEvent()
		return
	else
		if GetPlayerName(tonumber(args[1])) == nil then
			RconPrint("Player is not ingame\n")
			CancelEvent()
			return
		end
			
		local identifier = getPlayerID(tonumber(args[1]))
		exports.ghmattimysql:scalar("SELECT identifier FROM lspd WHERE identifier = @identifier", { ['identifier'] = identifier}, function (result)
			if not result then
				print('Adding record for player to the database')
				addCop(identifier)

				TriggerClientEvent("lspd:notify", tonumber(args[1]), "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("become_cop_success"))
				TriggerClientEvent('lspd:receiveIsCop', tonumber(args[1]), 0, 1)

				RconPrint(GetPlayerName(tonumber(args[1])) .. " is now added to the lspd database.\n")
			else
				RconPrint(GetPlayerName(tonumber(args[1])) .. " is already a lspd officer.\n")
			end
		end)
	end
end, true)

RegisterCommand("CopRem", function(source,args,raw)
	if #args ~= 1 then
		RconPrint("Usage: CopRem [ingame-id]\n")
		CancelEvent()
		return
	else
		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player is not ingame\n")
			CancelEvent()
			return
		end
			
		local identifier = getPlayerID(tonumber(args[1]))
			
		exports.ghmattimysql:scalar("SELECT identifier FROM lspd WHERE identifier = @identifier", { ['identifier'] = identifier}, function (result)
			if not result then
				RconPrint(GetPlayerName(tonumber(args[1])) .. "  isn't here.\n")
			else
				exports.ghmattimysql:execute("DELETE FROM lspd WHERE identifier = @identifier", { ['identifier'] = identifier})
				TriggerClientEvent('lspd:noLongerCop', tonumber(args[1]))
				TriggerClientEvent("lspd:notify", tonumber(args[1]), "CHAR_AGENT14", 1, i18n.translate("title_notification"), false, i18n.translate("remove_from_cops"))
				RconPrint(GetPlayerName(tonumber(args[1])) .. " is now removed from the lspd database.\n")
			end
		end)

		CancelEvent()
	end
end, true)

RegisterCommand("CopRank", function(source,args,raw)
	if #args ~= 2 then
		RconPrint("Usage: CopRank [ingame-id] [rank]\n")
		CancelEvent()
		return
	elseif(not config.rank.label[tonumber(args[2])]) then
			RconPrint("You have to enter a valid rank !\n")
			CancelEvent()
			return		
	else
		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player is not ingame\n")
			CancelEvent()
			return
		end
			
		local identifier = getPlayerID(tonumber(args[1]))
		exports.ghmattimysql:scalar("SELECT `identifier` FROM lspd WHERE identifier = @identifier", { ['identifier'] = identifier}, function (rank)
			if(rank == nil) then
				RconPrint(GetPlayerName(tonumber(args[1])) .. "  isn't here.\n")
			else
				exports.ghmattimysql:execute("UPDATE lspd SET `rank` = @rank WHERE identifier = @identifier", { ['identifier'] = identifier, ['rank'] = args[2]})
				TriggerClientEvent('lspd:receiveIsCop', tonumber(args[1]), tonumber(args[2]))
				RconPrint(GetPlayerName(tonumber(args[1])) .. " information has been updated.\n")
			end
		end)

		CancelEvent()
	end
end, true)

RegisterCommand("CopDept", function(source,args,raw)
	if #args ~= 2 then
		RconPrint("Usage: CopDept [ingame-id] [department]\n")
		CancelEvent()
		return	
	else
		if(GetPlayerName(tonumber(args[1])) == nil) then
			RconPrint("Player is not ingame\n")
			CancelEvent()
			return
		end

		local identifier = getPlayerID(tonumber(args[1]))
		exports.ghmattimysql:scalar("SELECT `identifier` FROM lspd WHERE identifier = @identifier", { ['identifier'] = identifier}, function (result)
			if result then
				if GetPlayerName(tonumber(args[1])) ~= nil then
					local player = tonumber(args[1])
					local dept = tonumber(args[2])

					setDept(args[1], player, dept)
				else
					TriggerClientEvent('chatMessage', args[1], i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("no_player_with_this_id"))
				end
			else
				TriggerClientEvent('chatMessage', args[1], i18n.translate("title_notification"), {255, 0, 0}, i18n.translate("not_enough_permission"))
			end
		end)

		CancelEvent()
	end
end, true)

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end
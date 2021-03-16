local connectedPlayers = {}

RegisterNetEvent("scoreboard:playerConnected")
RegisterNetEvent("scoreboard:clockIn")

AddEventHandler('scoreboard:clockIn', function(job)
	connectedPlayers[source].job = job
	TriggerClientEvent('scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('scoreboard:playerConnected', function()
	connectedPlayers[source] = {
		name = GetPlayerName(source),
		ping = GetPlayerPing(source)
	}
	TriggerClientEvent('scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('playerDropped', function()
	connectedPlayers[source] = nil
	TriggerClientEvent('scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('scoreboard:updatePlayers', function()
	TriggerClientEvent('scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

Citizen.CreateThread(function()
--	for k,v in ipairs(exports.bro_core:GetPlayersPed()) do
--		connectedPlayers[#connectedPlayers+1] = {
--			name = GetPlayerName(v),
--			id = k,
--			ping = GetPlayerPing(v)
--		}
--	end
--	TriggerClientEvent('scoreboard:updateConnectedPlayers', -1, connectedPlayers)
	while true do
		Citizen.Wait(5000)
		UpdatePing()
	end
end)

function UpdatePing()
	if #connectedPlayers > 0 then
		for k,v in pairs(connectedPlayers) do
			v.ping = GetPlayerPing(k)
			TriggerClientEvent('status:updatePing', k, v.ping)
		end
		TriggerClientEvent('scoreboard:updatePing', -1, connectedPlayers)
	end
end
local connectedPlayers = {}

--ESX.RegisterServerCallback('scoreboard:getConnectedPlayers', function(source, cb)
--	cb(connectedPlayers)
--end)

AddEventHandler('job:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name

	TriggerClientEvent('scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('playerConnecting', function(OnPlayerConnecting)
	AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		UpdatePing()
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			AddPlayersToScoreboard()
		end)
	end
end)

function AddPlayerToScoreboard(player, update)
	connectedPlayers[player] = {}

	if update then
		TriggerClientEvent('scoreboard:updateConnectedPlayers', -1, connectedPlayers)
	end

end

function AddPlayersToScoreboard()
	exports.bro_core:GetPlayersId()

	TriggerClientEvent('scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end

function UpdatePing()
	for k,v in pairs(connectedPlayers) do
		v.ping = GetPlayerPing(k)
		TriggerClientEvent('status:updatePing', k, v.ping)
	end
	TriggerClientEvent('scoreboard:updatePing', -1, connectedPlayers)
end
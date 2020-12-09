local CopsConnected = 0

function isIntrested()
    local percent = math.random(1, 2)
    if percent == 1  then 
      return true
    else 
      return false
    end
end


RegisterServerEvent('crime:drug:sell')
AddEventHandler('crime:drug:sell', function(deal)
    local sourceValue = source
    local discord = exports.bf:GetDiscordFromSource(sourceValue)
    local price = 80.0
    if CopsConnected >= 0 then
        if isIntrested() then
            MySQL.ready(function ()
                MySQL.Async.fetchScalar('SELECT amount from player_item, players where players.discord = @discord and player_item.player = players.id and player_item.item = 7', {
                    ['@discord'] = discord,
                }, function(amount)
                    if amount > 1 then
                        TriggerClientEvent("crime:drug:sell", sourceValue, price)
                        TriggerClientEvent('bf:Notification', sourceValue, "Vendu pour ~g~ "..price.." $")
                        
                        local poukichance = math.random (1,4)
                        if poukichance == 1 then
                            TriggerClientEvent("crime:drug:poucave", sourceValue, deal.x, deal.y, deal.z)
                            TriggerEvent("job:avert:all", "lspd", "Deal en cours", true, deal)
                        end
                    else
                        TriggerClientEvent('bf:Notification', sourceValue, "~r~Tu n'a pas assez de matos.")
                    end
                end)
            end)
		else
			TriggerClientEvent('bf:Notification', sourceValue, "~r~Je touche pas à ta merde.")
		end
	else
		TriggerClientEvent('bf:Notification', sourceValue, "~r~Pas assez de policiers connecté")
	end
end)